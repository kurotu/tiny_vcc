import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
import 'package:tiny_vcc/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/legacy_project_model.dart';

class LegacyProjectRouteArguments {
  LegacyProjectRouteArguments({required this.project});

  final VccProject project;
}

enum _MigrateAction {
  migrateCopy,
  migrateInPlace,
}

class LegacyProjectRoute extends StatelessWidget {
  static const routeName = '/legacy_project';

  const LegacyProjectRoute({super.key});

  LegacyProjectModel _model(BuildContext context) {
    return Provider.of<LegacyProjectModel>(context, listen: false);
  }

  Future<void> _didClickMigrate(BuildContext context) async {
    final _MigrateAction? action = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Migration'),
        content: const Text('Migration is needed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _MigrateAction.migrateCopy);
            },
            child: const Text('Migrate a copy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _MigrateAction.migrateInPlace);
            },
            child: const Text('Migrate in place\nI HAVE A BACKUP'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (action == null) {
      return;
    }

    showProgressDialog(context, 'Migrating ${_model(context).project.name}');

    VccProject project;
    switch (action) {
      case _MigrateAction.migrateCopy:
        project = await _model(context).migrateCopy();
        break;
      case _MigrateAction.migrateInPlace:
        project = await _model(context).migrateInPlace();
        break;
    }
    Navigator.pop(context);
    Navigator.pushReplacementNamed(
      context,
      ProjectRoute.routeName,
      arguments: ProjectRouteArguments(project: project),
    );
  }

  void _didClickOpenFolder(BuildContext context) {
    final uri = Uri.file(_model(context).project.path);
    launchUrl(uri);
  }

  void _didClickMakeBackup(BuildContext context) async {
    showProgressDialog(context, 'Backing up ${_model(context).project.name}');
    final file = await _model(context).backup();
    Navigator.pop(context);

    final showFile = await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Made Backup'),
            content: Text(file.path),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Show Me'),
              ),
            ],
          )),
    );
    if (showFile != null && showFile) {
      launchUrl(Uri.file(file.parent.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LegacyProjectModel>(
            builder: (context, model, child) => Text(model.project.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Consumer<LegacyProjectModel>(
              builder: ((context, value, child) => OutlinedButton(
                  onPressed: value.isDoingTask
                      ? null
                      : () {
                          _didClickMigrate(context);
                        },
                  child: const Text('Migrate'))),
            ),
            Consumer<LegacyProjectModel>(
              builder: ((context, value, child) => OutlinedButton(
                  onPressed: value.isDoingTask
                      ? null
                      : () {
                          _didClickOpenFolder(context);
                        },
                  child: const Text('Open Folder'))),
            ),
            Consumer<LegacyProjectModel>(
              builder: ((context, value, child) => OutlinedButton(
                  onPressed: value.isDoingTask
                      ? null
                      : () {
                          _didClickMakeBackup(context);
                        },
                  child: const Text('Make Backup'))),
            ),
          ],
        ),
      ),
    );
  }
}
