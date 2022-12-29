import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

import '../data/exceptions.dart';
import '../globals.dart';
import '../repos/requirements_repository.dart';
import '../repos/vcc_projects_repository.dart';
import '../repos/vcc_settings_repository.dart';
import '../repos/vpm_packages_repository.dart';
import '../services/vcc_service.dart';

class ProjectsModel with ChangeNotifier {
  ProjectsModel(BuildContext context)
      : _vccData = Provider.of(context, listen: false),
        _packages = Provider.of(context, listen: false),
        _vccSetting = Provider.of(context, listen: false),
        _req = Provider.of(context, listen: false);

  final VccProjectsRepository _vccData;
  final VpmPackagesRepository _packages;
  final VccSettingsRepository _vccSetting;
  final RequirementsRepository _req;

  List<VccProject> _projects = [];
  List<VccProject> get projects => _projects;

  bool _disposed = false;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  Future<bool> checkReadyToUse() async {
    // Quick check for startup.
    final settings = await _vccSetting.fetchSettings();
    final hasVpm = await _req.checkVpmCommand();
    if (!hasVpm) {
      return false;
    }
    final hasCorrectVpm = await _req.checkVpmVersion(requiredVpmVersion);
    if (!hasCorrectVpm) {
      return false;
    }
    if (!await (File(settings.pathToUnityHub).exists())) {
      return false;
    }
    if (!await (File(settings.pathToUnityExe).exists())) {
      return false;
    }
    return true;
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
      case VccProjectType.avatarGit:
        throw VccProjectTypeException(
            'Avatar Git project type is not supported in Tiny VCC. Migrate with the official VCC.',
            type);
      case VccProjectType.worldGit:
        throw VccProjectTypeException(
            'World Git project type is not supported in Tiny VCC. Migrate with the official VCC.',
            type);
      case VccProjectType.legacySdk2:
        throw VccProjectTypeException(
            'VRCSDK2 project is not supported.', type);
      case VccProjectType.invalid:
        throw VccProjectTypeException('Invalid Unity project.', type);
      case VccProjectType.unknown:
        throw VccProjectTypeException('Unknown Unity project type.', type);
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

  Future<void> getPackages() async {
    await _packages.fetchPackages();
  }
}
