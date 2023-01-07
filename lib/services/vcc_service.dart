import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../data/exceptions.dart';
import '../data/vcc_data.dart';
import 'unity_hub_service.dart';

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
  starterVpm,
  avatarGit,
  worldGit,
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
    required this.repoType,
  });

  final String name;
  final String displayName;
  final Version version;
  final String description;
  final RepositoryType repoType;

  bool get isPrerelease => version.isPreRelease;
}

class VpmDependency {
  VpmDependency(this.name, this.version);

  final String name;
  final Version version;
}

enum RepositoryType {
  official,
  curated,
  user,
  local,
}

class VpmTemplate {
  VpmTemplate(this.name, this.path);

  final String name;
  final String path;
}

class VccService {
  VccService(UnityHubService hub) : _hub = hub {
    _findVpm();
  }

  /// Use full path to avoid crash.
  /// https://stackoverflow.com/questions/69139808/
  String _vpmPath = '';

  final UnityHubService _hub;

  String? _findVpm() {
    // find in PATH.
    if (Platform.isWindows) {
      final result = Process.runSync('where', ['vpm']);
      if (result.exitCode == 0) {
        _vpmPath = result.stdout.toString().trim();
        return _vpmPath;
      }
    } else {
      final result = Process.runSync('which', ['vpm']);
      if (result.exitCode == 0) {
        _vpmPath = result.stdout.toString().trim();
        return _vpmPath;
      }
    }
    // find in default install.
    final home = Platform.isWindows
        ? Platform.environment['USERPROFILE']!
        : Platform.environment['HOME']!;
    final vpmPath = p.join(home, '.dotnet', 'tools', 'vpm');
    if (File(vpmPath).existsSync()) {
      _vpmPath = vpmPath;
      return vpmPath;
    }
    _vpmPath = '';
    return null;
  }

  bool isInstalled() {
    return _findVpm() != null;
  }

  Future<Version> getCliVersion() async {
    final exe = _vpmPath;
    final args = ['--version'];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
    return Version.parse(result.stdout.toString().trim());
  }

  Future<VccSettings> getSettings() async {
    var json = await _getSettingsJson();
    final settings = VccSettings(
      pathToUnityExe: json['pathToUnityExe'].toString(),
      pathToUnityHub: json['pathToUnityHub'].toString(),
      projectBackupPath: json['projectBackupPath'].toString(),
      userProjects: (json['userProjects'] as List<dynamic>).cast(),
      unityEditors: (json['unityEditors'] as List<dynamic>).cast(),
      defaultProjectPath: json['defaultProjectPath'].toString(),
      userPackageFolders: (json['userPackageFolders'] as List<dynamic>).cast(),
      showPrereleasePackages: json['showPrereleasePackages'],
      userRepos: (json['userRepos'] as List<dynamic>)
          .map((e) => e['localPath'].toString())
          .toList(),
    );
    return settings;
  }

  Future<void> addUserProject(Directory directory) async {
    final setting = await getSettings();
    if (!setting.userProjects.contains(directory.path)) {
      setting.userProjects.add(directory.path);
      await setSettings(userProjects: setting.userProjects);
    }
  }

  Future<VccProject> createNewProject(
      VpmTemplate template, String name, String location) async {
    final exe = _vpmPath;
    final args = [
      'new',
      name,
      template.path,
      '--path',
      location,
    ];
    final result = await Process.run(_vpmPath, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(_vpmPath, args, result.exitCode);
    }
    final path = p.join(location, name);
    await addUserProject(Directory(path));
    return VccProject(path);
  }

  Future<void> deleteUserProject(VccProject project) async {
    final setting = await getSettings();
    setting.userProjects.remove(project.path);
    await setSettings(userProjects: setting.userProjects);
  }

  Future<VccProject> migrateProject(VccProject project, bool inPlace) async {
    final exe = _vpmPath;
    final args = ['migrate', 'project', project.path];
    if (inPlace) {
      args.add('--inplace');
    }
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
    if (inPlace) {
      return project;
    }
    final migrated = _detectMigratedProject(project, result.stdout);
    await addUserProject(Directory(migrated.path));
    return migrated;
  }

  Future<VccProject> migrateProjectWithStream(
    VccProject project,
    bool inPlace, {
    required void Function(String event) onStdout,
    required void Function(String event) onStderr,
  }) async {
    final exe = _vpmPath;
    final args = ['migrate', 'project', project.path];
    if (inPlace) {
      args.add('--inplace');
    }
    final process = await Process.start(exe, args);

    final stdout = process.stdout.transform(utf8.decoder).asBroadcastStream();
    stdout.listen(onStdout);
    final stdoutBuffer = StringBuffer();
    stdout.listen((text) {
      stdoutBuffer.write(text);
    });
    final stderr = process.stderr.transform(utf8.decoder).asBroadcastStream();
    stderr.listen(onStderr);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw NonZeroExitException(exe, args, exitCode);
    }
    if (inPlace) {
      return project;
    }
    final migrated = _detectMigratedProject(project, stdoutBuffer.toString());
    await addUserProject(Directory(migrated.path));
    return migrated;
  }

  VccProject _detectMigratedProject(VccProject project, String vpmOut) {
    final lines = vpmOut.split('\n').map((e) => e.trim());
    final reg = RegExp('Copying ${RegExp.escape(project.path)} to (.*)');
    final theLine = lines.firstWhere((l) => reg.hasMatch(l));
    final match = reg.allMatches(theLine);
    final path = match.toList()[0][1]!;
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
    final excluded = [
      '.git',
      'Library',
      'Logs',
      'obj',
    ].map((e) => p.join(project.path, e)).toList();
    for (final e in entities) {
      if (excluded.contains(e.path)) {
        continue;
      }
      debugPrint(e.path);
      if (e is Directory) {
        await encoder.addDirectory(e);
      } else if (e is File) {
        await encoder.addFile(e);
      }
    }
    encoder.close();
    return File(encoder.zipPath);
  }

  Future<VccProjectType> checkUserProject(VccProject project) async {
    final exe = _vpmPath;
    final args = ['check', 'project', project.path];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
    final str = result.stdout.toString();
    if (str.contains('AvatarVPM')) {
      return VccProjectType.avatarVpm;
    }
    if (str.contains('WorldVPM')) {
      return VccProjectType.worldVpm;
    }
    if (str.contains('StarterVPM')) {
      return VccProjectType.starterVpm;
    }
    if (str.contains('AvatarGit')) {
      return VccProjectType.avatarGit;
    }
    if (str.contains('WorldGit')) {
      return VccProjectType.worldGit;
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
    throw Exception(
        'Failed to detect project type from vpm output: ${str.trim()}');
  }

  Future<bool> checkHub() async {
    final result = await Process.run(_vpmPath, ['check', 'hub']);
    if (result.exitCode != 0) {
      return false;
    }
    // we can't rely on exit code 0.
    // https://github.com/vrchat-community/creator-companion/issues/52
    final str = result.stdout.toString();
    if (str.contains('not find')) {
      return false;
    }
    if (str.contains('Found unity version  at')) {
      return false;
    }
    final unityHubExe = (await getSettings()).pathToUnityHub;
    if (!await File(unityHubExe).exists()) {
      return false;
    }
    _hub.setUnityHubExe(unityHubExe);
    return true;
  }

  Future<bool> checkUnity() async {
    final result = await Process.run(_vpmPath, ['check', 'unity']);
    if (result.exitCode != 0) {
      return false;
    }

    if (Platform.isMacOS) {
      // vpm doesn't update pathToUnityExe and unityEditors on macOS.
      final settings = await getSettings();
      if (settings.pathToUnityExe == '') {
        final editors = await listUnity();
        if (editors.isEmpty) {
          return false;
        }
        final editor = editors.values.last;
        await setSettings(
          pathToUnityExe: editor,
          unityEditors: [editor],
        );
      }
      return true;
    }

    return true;
  }

  Future<Map<String, String>> listUnity() async {
    if (Platform.isMacOS) {
      // `vpm list unity` can't properly list unity editors on macOS.
      // https://github.com/vrchat-community/creator-companion/issues/46
      await checkHub();
      final editors = await _hub.listInstalledEditors();
      if (Platform.isMacOS) {
        final newEntries = editors.entries.map((entry) =>
            MapEntry(entry.key, p.join(entry.value, 'Contents/MacOS/unity')));
        editors.addEntries(newEntries);
      }
      await setSettings(unityEditors: editors.values.toList());
      return editors;
    }

    final exe = _vpmPath;
    final args = ['list', 'unity'];
    var result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
    var out = result.stdout.toString();
    var entries = out.split('\n').sublist(1).where((e) => e != '').map((e) {
      var path = e.trim().replaceFirst(RegExp(r'\[.*\] '), '');
      var version = RegExp(r'\d+\.\d+\.\d+f\d+').stringMatch(path)!;
      return MapEntry(version, path);
    });
    return Map.fromEntries(entries);
  }

  Future<void> installTemplates() async {
    final exe = _vpmPath;
    final args = ['install', 'templates'];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
  }

  Future<List<VpmTemplate>> getTemplates() async {
    final exe = _vpmPath;
    final args = ['list', 'templates'];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
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
    final dir = getSettingsDirectory();
    final file = File(p.join(dir.path, 'Repos', 'vrc-official.json'));
    return _getVpmPackages(file, RepositoryType.official);
  }

  Future<List<VpmPackage>> getCuratedPackages() async {
    final dir = getSettingsDirectory();
    final file = File(p.join(dir.path, 'Repos', 'vrc-curated.json'));
    return _getVpmPackages(file, RepositoryType.curated);
  }

  Future<List<VpmPackage>> getUserPackages() async {
    final setting = await getSettings();
    final lists = await Future.wait(setting.userRepos
        .map((e) => _getVpmPackages(File(e), RepositoryType.user)));
    return lists.expand((element) => element).toList();
  }

  Future<List<VpmPackage>> _getVpmPackages(
      File repoFile, RepositoryType repoType) async {
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
                repoType: repoType,
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
        repoType: RepositoryType.local,
      );
    }));
    return packages;
  }

  Directory getSettingsDirectory() {
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
    var settings = getSettingsDirectory();
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
        'version': version.toString(),
      };
    }
    final locked = manifestJson['locked'] as Map<String, dynamic>;
    locked[name]['version'] = version.toString();
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

  Future<void> listRepos() async {
    final exe = _vpmPath;
    final args = ['list', 'repos'];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
  }

  Future<void> setSettings({
    String? pathToUnityExe,
    List<String>? userProjects,
    List<String>? unityEditors,
    String? defaultProjectPath,
    List<String>? userPackageFolders,
    String? projectBackupPath,
  }) async {
    final json = await _getSettingsJson();
    if (pathToUnityExe != null) {
      json['pathToUnityExe'] = pathToUnityExe;
    }
    if (userProjects != null) {
      json['userProjects'] = userProjects;
    }
    if (unityEditors != null) {
      json['unityEditors'] = unityEditors;
    }
    if (defaultProjectPath != null) {
      json['defaultProjectPath'] = defaultProjectPath;
    }
    if (userPackageFolders != null) {
      json['userPackageFolders'] = userPackageFolders;
    }
    if (projectBackupPath != null) {
      json['projectBackupPath'] = projectBackupPath;
    }
    await _writeSettingsJson(json);
  }

  Future<void> addUnityEditor(String path) async {
    final setting = await getSettings();
    if (setting.unityEditors.contains(path)) {
      return;
    }
    setting.unityEditors.add(path);
    await setSettings(unityEditors: setting.unityEditors);
  }

  Future<void> setUnityEditors(List<String> unityEditors) async {
    await setSettings(unityEditors: unityEditors);
  }

  Future<void> addUserPackageFolder(String path) async {
    final setting = await getSettings();
    if (!setting.userPackageFolders.contains(path)) {
      setting.userPackageFolders.add(path);
      await setSettings(userPackageFolders: setting.userPackageFolders);
    }
  }

  Future<void> deleteUserPackageFolder(String path) async {
    final setting = await getSettings();
    setting.userPackageFolders.remove(path);
    await setSettings(userPackageFolders: setting.userPackageFolders);
  }

  Future<bool> installUnity({
    required void Function(String event) onStdout,
    required void Function(String event) onStderr,
  }) async {
    final process = await Process.start(_vpmPath, ['install', 'unity']);
    process.stdout.transform(utf8.decoder).listen(onStdout);
    process.stderr.transform(utf8.decoder).listen(onStderr);
    final exitCode = await process.exitCode;
    return exitCode == 0;
  }
}
