import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/project_model.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class ProjectRouteArguments {
  ProjectRouteArguments({required this.project});

  final VccProject project;
}

class ProjectRoute extends StatelessWidget {
  const ProjectRoute({super.key});

  static const String routeName = '/project';

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<ProjectModel>(context, listen: false);
    model.getLockedDependencies();

    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProjectModel>(
            builder: (context, model, child) => Text(model.project.name)),
        actions: [
          TextButton(
              style: style,
              onPressed: model.openProject,
              child: const Text('Open'))
        ],
      ),
      body: Consumer<ProjectModel>(
        builder: (context, model, child) => ListView.builder(
          itemCount: model.lockedDependencies.length,
          itemBuilder: (context, index) {
            final dep = model.lockedDependencies[index];
            return ListTile(
              title: Text("${dep.displayName} (${dep.version})"),
              subtitle: Text(dep.description),
            );
          },
        ),
      ),
    );
  }
}
