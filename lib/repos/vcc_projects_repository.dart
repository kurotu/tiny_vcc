import 'dart:io';

import 'package:tiny_vcc/services/vcc_service.dart';

class VccProjectsRepository {
  VccProjectsRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  List<VccProject>? _projects;

  Future<List<VccProject>> fetchVccProjects() async {
    final setting = await _vcc.getSettings();
    _projects = setting.userProjects.map((e) => VccProject(e)).toList();
    _sortProjects();
    return _projects!;
  }

  Future<VccProject> createVccProject(
      VpmTemplate template, String name, String location) async {
    final project = await _vcc.createNewProject(template, name, location);
    await fetchVccProjects();
    return project;
  }

  Future<void> addVccProject(VccProject project) async {
    await _vcc.addUserProject(Directory(project.path));
    await fetchVccProjects();
  }

  Future<void> deleteVccProject(VccProject project) async {
    await _vcc.deleteUserProject(project);
    await fetchVccProjects();
  }

  Future<VccProjectType> checkProjectType(VccProject project) {
    return _vcc.checkUserProject(project);
  }

  Future<VccProject> migrateCopy(VccProject project) {
    return _vcc.migrateProject(project, false);
  }

  Future<VccProject> migrateInPlace(VccProject project) {
    return _vcc.migrateProject(project, true);
  }

  void _sortProjects() {
    _projects?.sort(((a, b) => a.name.compareTo(b.name)));
  }
}
