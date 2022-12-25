import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/routes/requirements_route.dart';

import '../data/exceptions.dart';
import '../globals.dart';
import '../main_drawer.dart';
import '../models/projects_model.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import 'legacy_project_route.dart';
import 'new_project_route.dart';
import 'project_route.dart';

class ProjectsRoute extends StatefulWidget {
  const ProjectsRoute({super.key});

  static const String routeName = '/projects';

  @override
  State<ProjectsRoute> createState() => _ProjectsRoute();
}

class _ProjectsRoute extends State<ProjectsRoute> with RouteAware {
  void _addProject(ProjectsModel model) async {
    final path = await showDirectoryPickerWindow(lockParentWindow: true);
    try {
      await model.addProject(path);
    } on VccProjectTypeException catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(
            context, 'Project "$path" is not supported.', error);
      }
    } on Exception catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(
            context, 'Error occurred when adding a project.', error);
      }
    }
  }

  Future<void> _refreshProjects() async {
    if (!mounted) {
      return;
    }
    final model = context.read<ProjectsModel>();
    try {
      await model.getProjects();
      await model.getPackages();
    } on Exception catch (error) {
      print(error);
    }
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
      case VccProjectType.avatarGit:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Avatar Git project (${project.path}) is not supported in Tiny VCC.'),
        ));
        break;
      case VccProjectType.worldGit:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'World Git project (${project.path}) is not supported in Tiny VCC.'),
        ));
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
    _model(context).checkReadyToUse().then((value) {
      if (!value) {
        Navigator.of(context).pushReplacementNamed(RequirementsRoute.routeName);
      }
    });
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
          Consumer<ProjectsModel>(
            builder: ((context, model, child) => TextButton(
                  style: style,
                  onPressed: () {
                    _addProject(_model(context));
                  },
                  child: const Text('Add'),
                )),
          ),
          Consumer<ProjectsModel>(
            builder: ((context, model, child) => TextButton(
                  style: style,
                  onPressed: () {
                    Navigator.pushNamed(context, NewProjectRoute.routeName);
                  },
                  child: const Text('New'),
                )),
          ),
        ],
      ),
      body: Consumer<ProjectsModel>(
        builder: ((context, model, child) =>
            Column(children: buildColumn(model))),
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
