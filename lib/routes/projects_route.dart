import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/main_drawer.dart';
import 'package:tiny_vcc/models/projects_model.dart';
import 'package:tiny_vcc/routes/new_project_route.dart';
import 'package:tiny_vcc/routes/project_route.dart';

class ProjectsRoute extends StatelessWidget {
  const ProjectsRoute({super.key});

  static const String routeName = '/projects';

  void _addProject(ProjectsModel model) async {
    var path =
        await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
    if (path == null) {
      return;
    }
    model.addProject(path);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProjectsModel>(context, listen: false);
    model.getProjects();

    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          TextButton(
            style: style,
            onPressed: () {
              _addProject(model);
            },
            child: const Text('Add'),
          ),
          TextButton(
            style: style,
            onPressed: () {
              Navigator.pushNamed(context, NewProjectRoute.routeName);
            },
            child: const Text('New'),
          ),
        ],
      ),
      body: Consumer<ProjectsModel>(
        builder: (context, model, child) =>
            Column(children: buildColumn(model)),
      ),
    );
  }

  List<Widget> buildColumn(ProjectsModel model) {
    final List<Widget> list = [];
    if (!model.hasVpmCli) {
      list.add(const Text('VPM CLI needed'));
    }
    list.add(
      Expanded(
        child: ListView.builder(
          itemCount: model.projects.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(model.projects[index].name),
            onTap: () {
              var project = model.projects[index];
              Navigator.pushNamed(
                context,
                ProjectRoute.routeName,
                arguments: ProjectRouteArguments(project: project),
              );
            },
            subtitle: Text(model.projects[index].path),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                model.deleteProject(model.projects[index]);
              },
            ),
          ),
        ),
      ),
    );
    return list;
  }
}
