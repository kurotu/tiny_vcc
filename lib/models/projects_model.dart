import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:tiny_vcc/repos/vpm_packages_repository.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

import '../repos/requirements_repository.dart';

class ProjectsModel with ChangeNotifier {
  ProjectsModel(BuildContext context)
      : _vccData = Provider.of(context, listen: false),
        _packages = Provider.of(context, listen: false),
        _vccSetting = Provider.of(context, listen: false),
        _requirements = Provider.of(context, listen: false);

  final VccProjectsRepository _vccData;
  final VpmPackagesRepository _packages;
  final VccSettingRepository _vccSetting;
  final RequirementsRepository _requirements;

  bool _isReadyToUse = true;
  bool get isReadyToUse => _isReadyToUse;

  List<VccProject> _projects = [];
  List<VccProject> get projects => _projects;

  bool _disposed = false;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  void setReadyToUse(bool ready) {
    _isReadyToUse = ready;
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<RequirementType?> checkMissingRequirement() async {
    final missing = await _requirements.fetchMissingRequirement();
    setReadyToUse(missing == null);
    return missing;
  }

  Future<void> getProjects() async {
    _projects = await _vccData.fetchVccProjects();
    if (!_disposed) {
      notifyListeners();
    }
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
    await _requirements.installVpmCli();
  }

  Future<void> updateVpmCli() async {
    await _requirements.updateVpmCli();
  }

  Future<void> getPackages() async {
    await _packages.fetchPackages();
  }
}
