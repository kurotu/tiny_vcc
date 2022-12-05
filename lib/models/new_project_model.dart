import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
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

  String get projectPath => p.join(location, projectName);

  Future<void> getProjectTemplates() async {
    final templates = await _vcc.getTemplates();
    _projectTemplates = templates;
    notifyListeners();
  }

  void selectTemplate(String path) {
    _template = _projectTemplates.firstWhere((element) => element.path == path);
    notifyListeners();
  }

  Future<void> createProject() {
    return _vcc.createNewProject(template!, projectName, location);
  }
}
