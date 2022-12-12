import 'package:flutter/widgets.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectsModel with ChangeNotifier {
  ProjectsModel(VccProjectsRepository vccRepo, VccSettingRepository settingRepo)
      : _vccData = vccRepo,
        _vccSetting = settingRepo;

  final VccProjectsRepository _vccData;
  final VccSettingRepository _vccSetting;

  List<VccProject> get projects => _vccData.projects ?? [];
  bool get hasVpmCli => _vccSetting.vpmVersion != null;

  Future<void> getProjects() async {
    await _vccData.fetchVccProjects();
    notifyListeners();
  }

  Future<void> addProject(String path) async {
    await _vccData.addVccProject(VccProject(path));
    notifyListeners();
  }

  Future<void> deleteProject(VccProject project) async {
    await _vccData.deleteVccProject(project);
    notifyListeners();
  }
}
