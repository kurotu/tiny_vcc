import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/main_drawer.dart';
import 'package:tiny_vcc/models/projects_model.dart';
import 'package:tiny_vcc/routes/new_project_route.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

import '../main.dart';
import 'legacy_project_route.dart';

class ProjectsRoute extends StatefulWidget {
  const ProjectsRoute({super.key});

  static const String routeName = '/projects';

  @override
  State<ProjectsRoute> createState() => _ProjectsRoute();
}

class _ProjectsRoute extends State<ProjectsRoute> with RouteAware {
  void _addProject(ProjectsModel model) async {
    var path =
        await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
    try {
      await model.addProject(path);
    } on VccProjectType catch (type) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Project'),
          content: Text(() {
            switch (type) {
              case VccProjectType.invalid:
              case VccProjectType.unknown:
                return '"$path" is not a valid Unity project.';
              case VccProjectType.legacySdk2:
                return '"$path" is a VRCSDK2 project.';
              case VccProjectType.avatarVpm:
              case VccProjectType.worldVpm:
              case VccProjectType.legacySdk3Avatar:
              case VccProjectType.legacySdk3World:
                throw Error();
            }
          }()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _refreshProjects() {
    final model = Provider.of<ProjectsModel>(context, listen: false);
    model.fetchVpmVersion().then((version) {
      if (version != null) {
        model.getProjects();
      } else {
        scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
          content: const Text('VPM CLI is missing'),
          actions: [
            TextButton(
              onPressed: () async {
                scaffoldKey.currentState?.clearMaterialBanners();
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Installing vrchat.vpm.cli')));
                await model.installVpmCli();
                _refreshProjects();
              },
              child: const Text('Install'),
            ),
          ],
        ));
      }
    });
  }

  Future<void> _didSelectProject(VccProject project) async {
    if (!await Directory(project.path).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${project.path} does not exist.'),
      ));
      return;
    }
    final type = await _model(context).checkProjectType(project);
    if (!mounted) {
      return;
    }
    switch (type) {
      case VccProjectType.avatarVpm:
      case VccProjectType.worldVpm:
        Navigator.pushNamed(
          context,
          ProjectRoute.routeName,
          arguments: ProjectRouteArguments(project: project),
        );
        break;
      case VccProjectType.legacySdk3Avatar:
      case VccProjectType.legacySdk3World:
        Navigator.pushNamed(
          context,
          LegacyProjectRoute.routeName,
          arguments: LegacyProjectRouteArguments(project: project),
        );
        break;
      case VccProjectType.legacySdk2:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${project.path} is VRCSDK2 project.'),
        ));
        break;
      case VccProjectType.invalid:
      case VccProjectType.unknown:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${project.path} is invalid project.'),
        ));
        break;
    }
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
    _refreshProjects();
  }

  @override
  void didPopNext() {
    _refreshProjects();
  }

  ProjectsModel _model(BuildContext context) {
    return Provider.of<ProjectsModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
              _addProject(_model(context));
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
    list.add(
      Expanded(
        child: ListView.builder(
          itemCount: model.projects.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(model.projects[index].name),
            onTap: () {
              var project = model.projects[index];
              _didSelectProject(project);
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
