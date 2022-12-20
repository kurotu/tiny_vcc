import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class LegacyProjectModel extends ChangeNotifier {
  LegacyProjectModel(BuildContext context, VccProject project)
      : _vcc = Provider.of(context, listen: false),
        _project = project;

  final VccProjectsRepository _vcc;

  final VccProject _project;
  VccProject get project => _project;

  final StringBuffer _vpmOutput = StringBuffer();
  String get vpmOutput => _vpmOutput.toString();

  VccProject? _migratedProject;
  VccProject? get migratedProject => _migratedProject;

  bool _isMakingBackup = false;
  bool get isDoingTask => _isMakingBackup;

  Future<VccProject> migrateCopy() async {
    return _migrate(project, false);
  }

  Future<VccProject> migrateInPlace() async {
    return _migrate(project, true);
  }

  Future<VccProject> _migrate(VccProject project, bool inPlace) async {
    _migratedProject = null;
    _vpmOutput.clear();
    notifyListeners();

    _migratedProject = await _vcc.migrateProjectWithStream(
      project,
      inPlace,
      onStdout: (text) {
        _vpmOutput.write(text);
        notifyListeners();
      },
      onStderr: (text) {
        _vpmOutput.write(text);
        notifyListeners();
      },
    );
    notifyListeners();
    return _migratedProject!;
  }

  Future<File> backup() async {
    try {
      _isMakingBackup = true;
      notifyListeners();
      final file = await compute(_vcc.backup, project);
      _isMakingBackup = false;
      notifyListeners();
      return file;
    } catch (error) {
      _isMakingBackup = false;
      notifyListeners();
      rethrow;
    }
  }
}
