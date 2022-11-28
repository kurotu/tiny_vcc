import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectModel with ChangeNotifier {
  ProjectModel(this.vcc, this.project);

  final VccProject project;
  final VccService vcc;

  List<VpmPackage> _lockedDependencies = [];
  List<VpmPackage> get lockedDependencies => _lockedDependencies;

  void getLockedDependencies() async {
    var deps = await project.getLockedDependencies();
    var packages = await vcc.getVpmPackages(VpmRepositoryType.all);

    var locked = packages
        .where((p) => deps.containsKey(p.name) && deps[p.name] == p.version)
        .toList();

    _lockedDependencies = locked;
    notifyListeners();
  }

  void openProject() async {
    var editorVersion = await project.getUnityEditorVersion();
    var editors = await vcc.getUnityEditors();
    var path = editors[editorVersion]!;
    Process.run(path, ['-projectPath', project.path]);
  }
}
