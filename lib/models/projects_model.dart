import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectsModel with ChangeNotifier {
  ProjectsModel(VccProjectsRepository vccRepo, VccSettingRepository settingRepo)
      : _vccData = vccRepo,
        _vccSetting = settingRepo;

  final VccProjectsRepository _vccData;
  final VccSettingRepository _vccSetting;

  List<VccProject> _projects = [];
  List<VccProject> get projects => _projects;

  Future<void> getProjects() async {
    _projects = await _vccData.fetchVccProjects();
    notifyListeners();
  }

  Future<void> addProject(String? path) async {
    if (path == null) {
      return;
    }
    final project = VccProject(path);
    final type = await checkProjectType(project);
    switch (type) {
      case VccProjectType.avatarVpm:
      case VccProjectType.worldVpm:
      case VccProjectType.legacySdk3Avatar:
      case VccProjectType.legacySdk3World:
        break;
      case VccProjectType.legacySdk2:
      case VccProjectType.invalid:
      case VccProjectType.unknown:
        throw type;
    }
    await _vccData.addVccProject(project);
    await getProjects();
  }

  Future<void> deleteProject(VccProject project) async {
    await _vccData.deleteVccProject(project);
    await getProjects();
  }

  Future<VccProjectType> checkProjectType(VccProject project) async {
    final type = await _vccData.checkProjectType(project);
    return type;
  }

  Future<Version?> fetchVpmVersion() {
    return _vccSetting.fetchCliVersion();
  }

  Future<void> installVpmCli() async {
    final result = await Process.run(
        'dotnet', ['tool', 'install', '--global', 'vrchat.vpm.cli']);
    if (result.exitCode != 0 && result.exitCode != 1) {
      throw 'dotnet failed to install vpm cli';
    }
  }
}
