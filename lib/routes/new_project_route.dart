import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/new_project_model.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/utils.dart';

import '../main.dart';

class NewProjectRoute extends StatefulWidget {
  static const routeName = '/new_project';

  const NewProjectRoute({super.key});

  @override
  State<NewProjectRoute> createState() => _NewProjectRoute();
}

class _NewProjectRoute extends State<NewProjectRoute> with RouteAware {
  final _formKey = GlobalKey<FormState>();

  Future<String?> _selectLocation() {
    return showDirectoryPickerWindow(
      lockParentWindow: true,
      initialDirectory: context.read<NewProjectModel>().location,
    );
  }

  NewProjectModel _model(BuildContext context) {
    return Provider.of<NewProjectModel>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _model(context).fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
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
                controller:
                    context.read<NewProjectModel>().projectNameController,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _selectLocation().then((path) {
                        if (path != null) {
                          context
                              .read<NewProjectModel>()
                              .locationController
                              .text = path;
                        }
                      });
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
                controller: context.read<NewProjectModel>().locationController,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Consumer<NewProjectModel>(
                builder: (context, model, child) => ElevatedButton(
                  onPressed: model.isCreatingProject
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Creating ${model.template?.name} project, "${model.projectName}" at ${model.location}'),
                            ));
                            model.createProject().then((project) {
                              Navigator.pushReplacementNamed(
                                context,
                                ProjectRoute.routeName,
                                arguments:
                                    ProjectRouteArguments(project: project),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      '${model.template?.name} project, "${project.name}" has been created at ${project.path}')));
                            });
                          }
                        },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
