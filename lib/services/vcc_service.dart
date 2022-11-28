import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class VccSetting {
  VccSetting({
    required this.userProjects,
    required this.userPackageFolders,
  });

  final List<String> userProjects;
  final List<String> userPackageFolders;
}

class VccProject {
  VccProject(this.path);

  String path = '';

  String get name => p.basename(path);

  Future<Map<String, String>> getLockedDependencies() async {
    var vpmManifest = File(p.join(path, 'Packages', 'vpm-manifest.json'));
    var str = await vpmManifest.readAsString();
    var vpmManifestJson = jsonDecode(str);
    Map<String, dynamic> dep = vpmManifestJson['locked'];
    return dep.map((key, value) => MapEntry(key, value['version']));
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
  avatar,
  world,
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
  final String version;
  final String description;
}

enum VpmRepositoryType {
  all,
  official,
  curated,
  user,
}

class VccService {
  Future<VccSetting> getSettings() async {
    var json = await _getSettingsJson();
    var setting = VccSetting(
      userProjects: (json['userProjects'] as List<dynamic>).cast(),
      userPackageFolders: (json['userPackageFolders'] as List<dynamic>).cast(),
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

  Future<void> deleteUserProject(VccProject project) async {
    var json = await _getSettingsJson();
    json['userProjects'].removeWhere((path) => path == project.path);
    await _writeSettingsJson(json);
  }

  Future<Map<String, String>> getUnityEditors() async {
    var result = await Process.run('vpm', ['list', 'unity']);
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
  }

  Future<List<VpmPackage>> getVpmPackages(VpmRepositoryType type) async {
    if (type == VpmRepositoryType.all) {
      final all = await Future.wait([
        getVpmPackages(VpmRepositoryType.official),
        getVpmPackages(VpmRepositoryType.curated),
        getLocalVpmPackages(),
      ]);
      return all.expand((element) => element).toList();
    }

    if (type == VpmRepositoryType.user) {
      return getLocalVpmPackages();
    }

    final dir = _getSettingsDirectory();
    var filename = '';
    if (type == VpmRepositoryType.official) {
      filename = 'vrc-official.json';
    } else if (type == VpmRepositoryType.curated) {
      filename = 'vrc-curated.json';
    }
    final file = File(p.join(dir.path, 'Repos', filename));
    final str = await file.readAsString();
    final json = jsonDecode(str);
    final packages =
        (json['cache'] as Map<String, dynamic>).entries.expand((e) {
      return (e.value['versions'] as Map<String, dynamic>)
          .values
          .map((e) => VpmPackage(
                name: e['name'],
                displayName: e['displayName'],
                version: e['version'],
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
        version: packageJson['version'],
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
    throw Error();
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
}
