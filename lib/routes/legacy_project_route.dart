import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
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
    _showMigrationProgressDialog(context);
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

  void _didClickMakeBackup(BuildContext context) async {
    final file = await _model(context).backup();
    showDialog(
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
                  Navigator.pop(context);
                  launchUrl(Uri.file(file.parent.path));
                },
                child: const Text('Show Me'),
              ),
            ],
          )),
    );
  }

  void _showMigrationProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) => const AlertDialog(
            title: Text('Migrating Project'),
          )),
    );
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
            OutlinedButton(
                onPressed: () {
                  _didClickMigrate(context);
                },
                child: const Text('Migrate')),
            OutlinedButton(
                onPressed: () {
                  _didClickMakeBackup(context);
                },
                child: const Text('Make Backup')),
          ],
        ),
      ),
    );
  }
}
