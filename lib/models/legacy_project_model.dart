import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class LegacyProjectModel extends ChangeNotifier {
  LegacyProjectModel(VccProjectsRepository vcc, VccProject project)
      : _vcc = vcc,
        _project = project;

  final VccProjectsRepository _vcc;

  final VccProject _project;
  VccProject get project => _project;

  bool _isMakingBackup = false;
  bool get isDoingTask => _isMakingBackup;

  Future<VccProject> migrateCopy() async {
    return _vcc.migrateCopy(project);
  }

  Future<VccProject> migrateInPlace() async {
    return _vcc.migrateInPlace(project);
  }

  Future<File> backup() async {
    _isMakingBackup = true;
    notifyListeners();
    final file = await compute(_vcc.backup, project);
    _isMakingBackup = false;
    notifyListeners();
    return file;
  }
}
