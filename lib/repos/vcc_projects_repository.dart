import 'dart:io';

import 'package:tiny_vcc/services/vcc_service.dart';

class VccProjectsRepository {
  VccProjectsRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  List<VccProject>? _projects;
  List<VccProject>? get projects => _projects;

  Future<List<VccProject>> fetchVccProjects() async {
    final setting = await _vcc.getSettings();
    _projects = setting.userProjects.map((e) => VccProject(e)).toList();
    _projects?.sort(((a, b) => a.name.compareTo(b.name)));
    return _projects!;
  }

  Future<void> addVccProject(VccProject project) async {
    _projects?.add(project);
    _vcc
        .addUserProject(Directory(project.path))
        .then((value) => fetchVccProjects());
  }

  Future<void> deleteVccProject(VccProject project) async {
    _projects?.removeWhere((element) => element.path == project.path);
    _vcc.deleteUserProject(project).then((value) => fetchVccProjects());
  }
}
