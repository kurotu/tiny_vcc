import 'package:flutter/widgets.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class NewProjectModel extends ChangeNotifier {
  NewProjectModel(VccService vcc) : _vcc = vcc {
    getProjectTemplates();
  }

  final VccService _vcc;

  List<VpmTemplate> _projectTemplates = [];
  List<VpmTemplate> get projectTemplates => _projectTemplates;

  VpmTemplate? _template;
  VpmTemplate? get template => _template;

  String _projectName = '';
  String get projectName => _projectName;
  set projectName(String name) {
    _projectName = name;
    notifyListeners();
  }

  String _location = '';
  String get location => _location;
  set location(String location) {
    _location = location;
    notifyListeners();
  }

  bool _isCreatingProject = false;
  bool get isCreatingProject => _isCreatingProject;

  Future<void> getProjectTemplates() async {
    final templates = await _vcc.getTemplates();
    _projectTemplates =
        templates.where((element) => element.name != 'Base').toList();
    notifyListeners();
  }

  void selectTemplate(String path) {
    _template = _projectTemplates.firstWhere((element) => element.path == path);
    notifyListeners();
  }

  Future<VccProject> createProject() async {
    _isCreatingProject = true;
    notifyListeners();
    try {
      final project =
          await _vcc.createNewProject(template!, projectName, location);
      _isCreatingProject = false;
      notifyListeners();
      return project;
    } catch (err) {
      _isCreatingProject = false;
      notifyListeners();
      print(err);
      rethrow;
    }
  }
}
