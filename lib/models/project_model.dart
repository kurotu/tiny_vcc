import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/repos/vcc_settings_repository.dart';

import '../repos/vcc_projects_repository.dart';
import '../repos/vpm_packages_repository.dart';
import '../services/vcc_service.dart';

class ProjectModel with ChangeNotifier {
  ProjectModel(
    BuildContext context,
    this.project,
  )   : vcc = Provider.of(context, listen: false),
        _vccSettings = context.read<VccSettingsRepository>(),
        _projectsRepo = Provider.of(context, listen: false),
        _packageRepo = Provider.of(context, listen: false);

  final VccProject project;
  final VccService vcc;
  final VccSettingsRepository _vccSettings;
  final VccProjectsRepository _projectsRepo;
  final VpmPackagesRepository _packageRepo;

  bool _isMakingBackup = false;
  bool get isDoingTask => _isMakingBackup;

//  List<VpmPackage> _packages = [];
  List<VpmDependency> _lockedDependencies = [];
  List<VpmDependency> get lockedDependencies => _lockedDependencies;

  final Map<String, Version> _selectedVersion = {};

  List<PackageItem> _packages = [];
  List<PackageItem> get packages => _packages;

  void getLockedDependencies() async {
    final locked = await project.getLockedDependencies();
    _lockedDependencies = locked;
    await _updateList();
    notifyListeners();
  }

  void openProject() async {
    var editorVersion = await project.getUnityEditorVersion();
    final editor = await _vccSettings.getUnityEditor(editorVersion);
    if (editor == null) {
      throw Exception('Unity $editorVersion not found in VCC settings.');
    }
    await Process.start(editor, ['-projectPath', project.path],
        mode: ProcessStartMode.detached);
  }

  Future<File> backup() async {
    _isMakingBackup = true;
    notifyListeners();
    final file = await compute(_projectsRepo.backup, project);
    _isMakingBackup = false;
    notifyListeners();
    return file;
  }

  void selectVersion(String name, Version version) async {
    _selectedVersion[name] = version;
    await _updateList();
    notifyListeners();
  }

  void addPackage(String name, Version version) async {
    await vcc.addPackage(project.path, name, version.toString());
    getLockedDependencies();
  }

  void removePackage(String name) async {
    await vcc.removePackage(project.path, name);
    getLockedDependencies();
  }

  void updatePackage(String name, Version version) async {
    await vcc.updatePackage(project.path, name, version);
    getLockedDependencies();
  }

  Future<void> _updateList() async {
    final showPrerelease = (await vcc.getSettings()).showPrereleasePackages;
    final List<PackageItem> list = [];
    final locked = _lockedDependencies
        .where((element) =>
            _packageRepo.getLatest(
                element.name, element.version, showPrerelease) !=
            null)
        .map((e) {
      final latest = _packageRepo.getLatest(e.name, e.version, showPrerelease);
      return PackageItem(
        name: e.name,
        displayName: latest!.displayName,
        description: latest.description,
        installedVersion: e.version,
        selectedVersion: _selectedVersion[e.name] ?? latest.version,
        versions: _packageRepo.getVersions(e.name, e.version, showPrerelease),
        repoType: latest.repoType,
      );
    });
    list.addAll(locked);
    final not = _packageRepo.packages
        ?.where(
            (p) => _lockedDependencies.where((e) => e.name == p.name).isEmpty)
        .map((e) => e.name)
        .toSet();
    if (not != null) {
      list.addAll(not.map((name) {
        final p = _packageRepo.getLatest(name, null, showPrerelease);
        return PackageItem(
          name: name,
          displayName: p!.displayName,
          description: p.description,
          selectedVersion: _selectedVersion[p.name] ?? p.version,
          versions: _packageRepo.getVersions(name, null, showPrerelease),
          repoType: p.repoType,
        );
      }));
    }
    _packages = list;
  }
}

class PackageItem {
  PackageItem({
    required this.name,
    required this.displayName,
    required this.description,
    this.installedVersion,
    this.selectedVersion,
    required this.versions,
    required this.repoType,
  });

  final String name;
  final String displayName;
  final String description;
  final Version? installedVersion;
  final Version? selectedVersion;
  final List<VpmPackage> versions;
  final RepositoryType repoType;
}
