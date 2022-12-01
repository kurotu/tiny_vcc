import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/project_model.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
import 'package:tiny_vcc/widgets/package_list_item.dart';

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
          itemCount: model.packages.length,
          itemBuilder: (context, index) {
            final dep = model.packages[index];
            return PackageListItem(
              item: dep,
              onClickAdd: (name, version) {
                model.addPackage(name, version);
              },
              onClickRemove: (name) {
                model.removePackage(name);
              },
              onClickUpdate: ((name, version) {
                model.updatePackage(name, version);
              }),
            );
          },
        ),
      ),
    );
  }
}
