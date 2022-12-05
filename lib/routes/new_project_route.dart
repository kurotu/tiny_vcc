import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/new_project_model.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class NewProjectRoute extends StatelessWidget {
  static const routeName = '/new_project';

  final _formKey = GlobalKey<FormState>();

  NewProjectRoute({super.key});

  Future<String?> _selectLocation() {
    return FilePicker.platform.getDirectoryPath(lockParentWindow: true);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewProjectModel>(context, listen: false);

    final TextEditingController projectNameController =
        TextEditingController(text: model.projectName);
    final TextEditingController locationController =
        TextEditingController(text: model.location);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<NewProjectModel>(
                builder: (context, model, child) => DropdownButtonFormField(
                  decoration:
                      const InputDecoration(labelText: 'Project Template'),
                  value: model.template?.path,
                  items: model.projectTemplates
                      .map((e) => DropdownMenuItem(
                            value: e.path,
                            child: Text(e.name),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please select project template.' : null,
                  onChanged: (value) {
                    model.selectTemplate(value!);
                  },
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name.';
                  }
                  return null;
                },
                controller: projectNameController,
                onChanged: (value) {
                  model.projectName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final path = await _selectLocation();
                      if (path != null) {
                        model.location = path;
                        locationController.text = path;
                      }
                    },
                    icon: const Icon(Icons.folder),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location path.';
                  }
                  return null;
                },
                controller: locationController,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    model.createProject().then((value) {
                      Navigator.pushReplacementNamed(
                        context,
                        ProjectRoute.routeName,
                        arguments: ProjectRouteArguments(
                            project: VccProject(model.projectPath)),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Creating ${model.template?.name} project, ${model.projectName} at ${model.location}')));
                    });
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
