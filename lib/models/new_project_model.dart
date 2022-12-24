import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/vcc_service.dart';

class NewProjectModel extends ChangeNotifier {
  NewProjectModel(BuildContext context)
      : _vcc = Provider.of(context, listen: false);

  final VccService _vcc;

  List<VpmTemplate> _projectTemplates = [];
  List<VpmTemplate> get projectTemplates => _projectTemplates;

  VpmTemplate? _template;
  VpmTemplate? get template => _template;

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String get projectName => projectNameController.text;
  String get location => locationController.text;

  bool _isCreatingProject = false;
  bool get isCreatingProject => _isCreatingProject;

  Future<void> fetchInitialData() async {
    await getProjectTemplates();
    final setting = await _vcc.getSettings();
    locationController.text = setting.defaultProjectPath;
    notifyListeners();
  }

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
