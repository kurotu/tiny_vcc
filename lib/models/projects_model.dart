import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectsModel with ChangeNotifier {
  ProjectsModel(this.vcc) {
    getProjects();
  }

  final VccService vcc;

  List<VccProject> _projects = [];
  List<VccProject> get projects => _projects;

  Future<void> getProjects() async {
    var setting = await vcc.getSettings();
    var pj = setting.userProjects.map((e) => VccProject(e)).toList();
    pj.sort(((a, b) => a.name.compareTo(b.name)));
    _projects = pj;
    notifyListeners();
  }

  Future<void> addProject(String path) async {
    await vcc.addUserProject(Directory(path));
    getProjects();
  }

  Future<void> deleteProject(VccProject project) async {
    await vcc.deleteUserProject(project);
    getProjects();
  }
}
