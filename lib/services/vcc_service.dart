import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/services/unity_hub_service.dart';
import 'package:yaml/yaml.dart';

class VccSetting {
  VccSetting({
    required this.pathToUnityHub,
    required this.projectBackupPath,
    required this.userProjects,
    required this.userPackageFolders,
    required this.userRepos,
  });

  final String pathToUnityHub;
  final String projectBackupPath;
  final List<String> userProjects;
  final List<String> userPackageFolders;
  final List<String> userRepos;
}

class VccProject {
  VccProject(this.path);

  String path = '';

  String get name => p.basename(path);

  Future<List<VpmDependency>> getLockedDependencies() async {
    var vpmManifest = File(p.join(path, 'Packages', 'vpm-manifest.json'));
    var str = await vpmManifest.readAsString();
    var vpmManifestJson = jsonDecode(str);
    Map<String, dynamic> dep = vpmManifestJson['locked'];
    return dep.entries
        .map((e) => VpmDependency(e.key, Version.parse(e.value['version'])))
        .toList();
  }

  Future<String> getUnityEditorVersion() async {
    var file = File(p.join(path, 'ProjectSettings', 'ProjectVersion.txt'));
    var str = await file.readAsString();
    var yaml = loadYaml(str);
    var version = yaml['m_EditorVersion'];
    return version;
  }
}

enum VccProjectType {
  avatarVpm,
  worldVpm,
  legacySdk3Avatar,
  legacySdk3World,
  legacySdk2,
  invalid,
  unknown,
}

class VpmPackage {
  VpmPackage({
    required this.name,
    required this.displayName,
    required this.version,
    required this.description,
  });

  final String name;
  final String displayName;
  final Version version;
  final String description;

  bool get isPrerelease => version.isPreRelease;
}

class VpmDependency {
  VpmDependency(this.name, this.version);

  final String name;
  final Version version;
}

class VpmTemplate {
  VpmTemplate(this.name, this.path);

  final String name;
  final String path;
}

class VccService {
  VccService(BuildContext context) : _hub = Provider.of(context, listen: false);

  String get _vpmPath {
    final home = Platform.isWindows
        ? Platform.environment['USERPROFILE']!
        : Platform.environment['HOME']!;
    return p.join(home, '.dotnet', 'tools', 'vpm');
  }

  UnityHubService _hub;

  Future<Version?> getCliVersion() async {
    final result = await Process.run(_vpmPath, ['--version']);
    if (result.exitCode != 0) {
      print('vpm-cli returned ${result.exitCode}');
      return null;
    }
    return Version.parse(result.stdout.toString().trim());
  }

  Future<VccSetting> getSettings() async {
    var json = await _getSettingsJson();
    var setting = VccSetting(
      pathToUnityHub: json['pathToUnityHub'].toString(),
      projectBackupPath: json['projectBackupPath'].toString(),
      userProjects: (json['userProjects'] as List<dynamic>).cast(),
      userPackageFolders: (json['userPackageFolders'] as List<dynamic>).cast(),
      userRepos: (json['userRepos'] as List<dynamic>)
          .map((e) => e['localPath'].toString())
          .toList(),
    );
    return setting;
  }

  Future<void> addUserProject(Directory directory) async {
    var json = await _getSettingsJson();
    if (!json['userProjects'].contains(directory.path)) {
      json['userProjects'].add(directory.path);
      await _writeSettingsJson(json);
    }
  }

  Future<VccProject> createNewProject(
      VpmTemplate template, String name, String location) async {
    final result = await Process.run(_vpmPath, [
      'new',
      name,
      template.path,
      '--path',
      location,
    ]);
    if (result.exitCode != 0) {
      throw Exception('vpm returned exit code ${result.exitCode}');
    }
    final path = p.join(location, name);
    await addUserProject(Directory(path));
    return VccProject(path);
  }

  Future<void> deleteUserProject(VccProject project) async {
    var json = await _getSettingsJson();
    json['userProjects'].removeWhere((path) => path == project.path);
    await _writeSettingsJson(json);
  }

  Future<VccProject> migrateProject(VccProject project, bool inPlace) async {
    final args = ['migrate', 'project', project.path];
    if (inPlace) {
      args.add('--inplace');
    }
    final result = await Process.run(_vpmPath, args);
    if (result.exitCode != 0) {
      throw Exception('vpm returned exit code ${result.exitCode}');
    }
    if (inPlace) {
      return project;
    }
    final lines = result.stdout.toString().split('\n').map((e) => e.trim());
    final reg = RegExp('Copying ${RegExp.escape(project.path)} to (.*)');
    final theLine = lines.firstWhere((l) => reg.hasMatch(l));
    final match = reg.allMatches(theLine);
    final path = match.toList()[0][1]!;
    await addUserProject(Directory(path));
    return VccProject(path);
  }

  Future<File> backupProject(VccProject project) async {
    final settings = await getSettings();
    final DateFormat outputFormat = DateFormat('yyyy-MM-ddTHH.mm.ss');
    final zipPath = p.join(settings.projectBackupPath,
        '${project.name}-backup-${outputFormat.format(DateTime.now())}.zip');

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    final entities = Directory(project.path).listSync();
    for (final e in entities) {
      if (e is Directory) {
        if (e.path.endsWith('Library') || e.path.endsWith('Logs')) {
          continue;
        }
        await encoder.addDirectory(e);
      } else if (e is File) {
        await encoder.addFile(e);
      }
    }
    encoder.close();
    return File(encoder.zipPath);
  }

  Future<VccProjectType> checkUserProject(VccProject project) async {
    final result =
        await Process.run(_vpmPath, ['check', 'project', project.path]);
    if (result.exitCode != 0) {
      throw 'vpm returned exit code ${result.exitCode}';
    }
    final str = result.stdout.toString();
    if (str.contains('AvatarVPM')) {
      return VccProjectType.avatarVpm;
    }
    if (str.contains('WorldVPM')) {
      return VccProjectType.worldVpm;
    }
    if (str.contains('LegacySDK3Avatar')) {
      return VccProjectType.legacySdk3Avatar;
    }
    if (str.contains('LegacySDK3World')) {
      return VccProjectType.legacySdk3World;
    }
    if (str.contains('LegacySDK2')) {
      return VccProjectType.legacySdk2;
    }
    if (str.contains('Not a valid unity project')) {
      return VccProjectType.invalid;
    }
    if (str.contains('Unknown')) {
      return VccProjectType.unknown;
    }
    throw 'Unhandled output: ${str.trim()}';
  }

  Future<bool> checkHub() async {
    final result = await Process.run(_vpmPath, ['check', 'hub']);
    return result.exitCode == 0;
  }

  Future<Map<String, String>> getUnityEditors() async {
    // `vpm list unity` can't list unity editors on macOS.
    // https://github.com/vrchat-community/creator-companion/issues/46
    await checkHub();
    final setting = await getSettings();
    _hub.setUnityHubExe(setting.pathToUnityHub);
    final editors = await _hub.listInstalledEditors();
    return editors;

    /*
    var result = await Process.run(_vpmPath, ['list', 'unity']);
    if (result.exitCode != 0) {
      throw Exception('vpm returned exit code ${result.exitCode}');
    }
    var out = result.stdout.toString();
    var entries = out.split('\n').sublist(1).where((e) => e != '').map((e) {
      var path = e.trim().replaceFirst(RegExp(r'\[.*\] '), '');
      var version = RegExp(r'\d+\.\d+\.\d+f\d+').stringMatch(path)!;
      return MapEntry(version, path);
    });
    return Map.fromEntries(entries);
    */
  }

  Future<List<VpmTemplate>> getTemplates() async {
    final result = await Process.run(_vpmPath, ['list', 'templates']);
    if (result.exitCode != 0) {
      throw Exception('vpm returned exit code ${result.exitCode}');
    }
    final out = result.stdout.toString();
    final lines = out
        .split('\n')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .where((element) => !element.endsWith('Templates:'));
    final templates = lines.map((e) {
      final l = e.replaceFirst(RegExp(r'\[.*\] '), '');
      final name = RegExp(r'[^:]+').stringMatch(l)!;
      final path = l.replaceFirst('$name: ', '');
      return VpmTemplate(name, path);
    });
    return templates.toList();
  }

  Future<List<VpmPackage>> getVpmPackages() async {
    final all = await Future.wait([
      getOfficialPackages(),
      getCuratedPackages(),
      getUserPackages(),
      getLocalVpmPackages(),
    ]);
    return all.expand((element) => element).toList();
  }

  Future<List<VpmPackage>> getOfficialPackages() async {
    final dir = _getSettingsDirectory();
    final file = File(p.join(dir.path, 'Repos', 'vrc-official.json'));
    return _getVpmPackages(file);
  }

  Future<List<VpmPackage>> getCuratedPackages() async {
    final dir = _getSettingsDirectory();
    final file = File(p.join(dir.path, 'Repos', 'vrc-curated.json'));
    return _getVpmPackages(file);
  }

  Future<List<VpmPackage>> getUserPackages() async {
    final setting = await getSettings();
    final lists = await Future.wait(
        setting.userRepos.map((e) => _getVpmPackages(File(e))));
    return lists.expand((element) => element).toList();
  }

  Future<List<VpmPackage>> _getVpmPackages(File repoFile) async {
    final str = await repoFile.readAsString();
    final json = jsonDecode(str);
    final packages =
        (json['cache'] as Map<String, dynamic>).entries.expand((e) {
      return (e.value['versions'] as Map<String, dynamic>)
          .values
          .map((e) => VpmPackage(
                name: e['name'],
                displayName: e['displayName'],
                version: Version.parse(e['version']),
                description: e['description'],
              ));
    }).toList();
    return packages;
  }

  Future<List<VpmPackage>> getLocalVpmPackages() async {
    final settings = await getSettings();

    final packages =
        await Future.wait(settings.userPackageFolders.map((path) async {
      final file = p.join(path, 'package.json');
      final str = await File(file).readAsString();
      final packageJson = jsonDecode(str);
      return VpmPackage(
        name: packageJson['name'],
        displayName: packageJson['displayName'],
        version: Version.parse(packageJson['version']),
        description: packageJson['description'],
      );
    }));
    return packages;
  }

  Directory _getSettingsDirectory() {
    if (Platform.isWindows) {
      var appdata =
          Platform.environment['APPDATA']; // %USERPROFILE%\AppData\Roaming
      if (appdata == null) {
        throw Error();
      }
      var roaming = Directory(appdata);
      return Directory(
          p.join(roaming.parent.path, 'Local', 'VRChatCreatorCompanion'));
    }
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home == null) {
        throw Error();
      }
      return Directory(p.join(home, '.local/share/VRChatCreatorCompanion'));
    }
    throw UnimplementedError();
  }

  File _getSettingsFile() {
    var settings = _getSettingsDirectory();
    return File(p.join(settings.path, 'settings.json'));
  }

  Future<dynamic> _getSettingsJson() async {
    var file = _getSettingsFile();
    var data = await file.readAsString();
    return jsonDecode(data);
  }

  Future<void> _writeSettingsJson(dynamic json) async {
    var file = _getSettingsFile();
    var encoder = const JsonEncoder.withIndent('  ');
    var jsonStr = encoder.convert(json);
    await file.writeAsString((jsonStr), flush: true);
  }

  Future<void> addPackage(String path, String name, String version) async {
    final file = File(p.join(path, 'Packages', 'vpm-manifest.json'));
    final str = await file.readAsString();
    final manifestJson = jsonDecode(str);
    final deps = (manifestJson['dependencies'] as Map<String, dynamic>);
    deps[name] = {
      'version': version,
    };
    final locked = manifestJson['locked'] as Map<String, dynamic>;
    locked[name] = {
      'version': version,
    };
    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(manifestJson);
    await file.writeAsString(jsonStr, flush: true);
  }

  Future<void> updatePackage(String path, String name, Version version) async {
    final file = File(p.join(path, 'Packages', 'vpm-manifest.json'));
    final str = await file.readAsString();
    final manifestJson = jsonDecode(str);
    final deps = (manifestJson['dependencies'] as Map<String, dynamic>);
    if (deps.containsKey(name)) {
      deps[name] = {
        'version': version,
      };
    }
    final locked = manifestJson['locked'] as Map<String, dynamic>;
    locked[name]['version'] = version;
    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(manifestJson);
    await file.writeAsString(jsonStr, flush: true);

    final dir = Directory(p.join(path, 'Packages', name));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<void> removePackage(String path, String name) async {
    final file = File(p.join(path, 'Packages', 'vpm-manifest.json'));
    final str = await file.readAsString();
    final manifestJson = jsonDecode(str);
    (manifestJson['dependencies'] as Map<String, dynamic>).remove(name);
    (manifestJson['locked'] as Map<String, dynamic>).remove(name);

    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(manifestJson);
    await file.writeAsString(jsonStr, flush: true);

    final dir = Directory(p.join(path, 'Packages', name));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
