import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectModel with ChangeNotifier {
  ProjectModel(this.vcc, this.project);

  final VccProject project;
  final VccService vcc;

  List<VpmPackage> _packages = [];
  List<VpmPackage> _lockedDependencies = [];
  List<VpmPackage> get lockedDependencies => _lockedDependencies;

  List<PackageItem> get packages {
    final List<PackageItem> list = [];
    final locked = _lockedDependencies.map((e) => PackageItem(
          name: e.name,
          displayName: e.displayName,
          description: e.description,
          installedVersion: e.version,
          versions: getVersions(e.name),
        ));
    list.addAll(locked);
    final not = _packages
        .where(
            (p) => _lockedDependencies.where((e) => e.name == p.name).isEmpty)
        .map((e) => e.name)
        .toSet();
    final a = not.toList();
    list.addAll(not.map((name) {
      final p = _packages.firstWhere((element) => element.name == name);
      return PackageItem(
        name: name,
        displayName: p.displayName,
        description: p.description,
        installedVersion: null,
        versions: getVersions(name),
      );
    }));
    return list;
  }

  List<String> getVersions(String name) {
    final list = _packages
        .where((element) => element.name == name)
        .map((e) => e.version)
        .toList();
    return list.reversed.toList();
  }

  void getLockedDependencies() async {
    var deps = await project.getLockedDependencies();
    _packages = await vcc.getVpmPackages(VpmRepositoryType.all);
//    _packages = _packages.where((element) => !element.isPrerelease).toList();

    var locked = _packages
        .where((p) => deps.containsKey(p.name) && deps[p.name] == p.version)
        .toList();
    _lockedDependencies = locked;
    notifyListeners();
  }

  void openProject() async {
    var editorVersion = await project.getUnityEditorVersion();
    var editors = await vcc.getUnityEditors();
    var path = editors[editorVersion]!;
    Process.run(path, ['-projectPath', project.path]);
  }

  void addPackage(String name, String version) async {
    await vcc.addPackage(project.path, name, version);
    getLockedDependencies();
  }

  void removePackage(String name) async {
    await vcc.removePackage(project.path, name);
    getLockedDependencies();
  }

  void updatePackage(String name, String version) async {
    await vcc.updatePackage(project.path, name, version);
    getLockedDependencies();
  }
}

class PackageItem {
  PackageItem(
      {required this.name,
      required this.displayName,
      required this.description,
      this.installedVersion,
      required this.versions});

  final String name;
  final String displayName;
  final String description;
  final String? installedVersion;
  final List<String> versions;
}
