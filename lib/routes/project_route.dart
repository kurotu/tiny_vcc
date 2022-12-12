import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/project_model.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
import 'package:tiny_vcc/widgets/package_list_item.dart';

import '../main.dart';

class ProjectRouteArguments {
  ProjectRouteArguments({required this.project});

  final VccProject project;
}

class ProjectRoute extends StatefulWidget {
  const ProjectRoute({super.key});

  static const String routeName = '/project';

  @override
  State<ProjectRoute> createState() => _ProjectRoute();
}

class _ProjectRoute extends State<ProjectRoute> with RouteAware {
  void _refreshLockedDependencies() {
    final model = Provider.of<ProjectModel>(context, listen: false);
    model.getLockedDependencies();
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
    _refreshLockedDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<ProjectModel>(context, listen: false);

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
              onSelect: (name, version) {
                model.selectVersion(name, version);
              },
              onClickAdd: (name) {
                model.addPackage(name, dep.selectedVersion!);
              },
              onClickRemove: (name) {
                model.removePackage(name);
              },
              onClickUpdate: ((name) {
                model.updatePackage(name, dep.selectedVersion!);
              }),
            );
          },
        ),
      ),
    );
  }
}
