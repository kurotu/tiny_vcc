import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import 'project_route.dart';

final _doingTaskProvider =
    StateNotifierProvider<DoingTaskState, bool>((_) => DoingTaskState());
final _migrationMessageProvider =
    StateNotifierProvider<MigrationMessageState, String>(
        (_) => MigrationMessageState());
final _errorMessageProvider =
    StateNotifierProvider<MigrationErrorState, String>(
        (_) => MigrationErrorState());

class DoingTaskState extends StateNotifier<bool> {
  DoingTaskState() : super(false);

  bool get isDoingTask => state;
  set isDoingTask(bool value) {
    state = value;
  }
}

class MigrationMessageState extends StateNotifier<String> {
  MigrationMessageState() : super('');

  String get message => state;
  set message(String value) {
    state = value;
  }
}

class MigrationErrorState extends StateNotifier<String> {
  MigrationErrorState() : super('');

  String get message => state;
  set message(String value) {
    state = value;
  }
}

class LegacyProjectRouteArguments {
  LegacyProjectRouteArguments({required this.project});

  final VccProject project;
}

enum _MigrateAction {
  migrateCopy,
  migrateInPlace,
}

class LegacyProjectRoute extends ConsumerWidget {
  static const routeName = '/legacy_project';

  const LegacyProjectRoute(this.project, {super.key});

  final VccProject project;

  Future<void> _didClickMigrate(BuildContext context, WidgetRef ref) async {
    final action = await _showMigrationConfirmDialog(context, ref);
    if (action == null) {
      return;
    }

    _showMigrationProgressDialog(context, ref);

    VccProject newProject;
    try {
      ref.read(_doingTaskProvider.notifier).isDoingTask = true;
      ref.read(_errorMessageProvider.notifier).message = '';
      switch (action) {
        case _MigrateAction.migrateCopy:
        case _MigrateAction.migrateInPlace:
          final inPlace = action == _MigrateAction.migrateInPlace;
          newProject =
              await ref.read(vccProjectsRepoProvider).migrateProjectWithStream(
            project,
            inPlace,
            onStdout: (output) {
              ref.read(_migrationMessageProvider.notifier).message += output;
            },
            onStderr: (err) {
              ref.read(_migrationMessageProvider.notifier).message += err;
            },
          );
          break;
      }
    } on Exception catch (error) {
      ref.read(_errorMessageProvider.notifier).message = '$error';
      return;
    } finally {
      ref.read(_doingTaskProvider.notifier).isDoingTask = true;
    }

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    Navigator.pushReplacementNamed(
      context,
      ProjectRoute.routeName,
      arguments: ProjectRouteArguments(project: newProject),
    );
  }

  Future<_MigrateAction?> _showMigrationConfirmDialog(
      BuildContext context, WidgetRef ref) async {
    final t = ref.watch(translationProvider);
    final _MigrateAction? action = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.legacy_project.dialogs.confirm.title),
        content: Text(t.legacy_project.dialogs.confirm.content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _MigrateAction.migrateCopy);
            },
            child: Text(t.legacy_project.dialogs.confirm.labels.migrate_a_copy),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _MigrateAction.migrateInPlace);
            },
            child:
                Text(t.legacy_project.dialogs.confirm.labels.migrate_in_place),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(t.common.labels.cancel),
          ),
        ],
      ),
    );
    return action;
  }

  Future<void> _showMigrationProgressDialog(
      BuildContext context, WidgetRef ref) async {
    return showDialog(
      context: context,
      builder: (context) => _MigrationProgressDialog(project),
      barrierDismissible: false,
    );
  }

  void _didClickOpenFolder() {
    final uri = Uri.file(project.path);
    launchUrl(uri);
  }

  void _didClickMakeBackup(BuildContext context, WidgetRef ref) async {
    final projectName = project.name;
    final t = ref.watch(translationProvider);
    showProgressDialog(context, Theme.of(context),
        t.legacy_project.dialogs.progress_backup.title(name: projectName));
    File file;
    try {
      file = await compute(ref.read(vccProjectsRepoProvider).backup, project);
    } on Exception catch (error) {
      Navigator.pop(context);
      showAlertDialog(context,
          title: t.legacy_project.dialogs.backup_error.title,
          message: t.legacy_project.dialogs.backup_error
              .content(projectName: projectName, error: error));
      return;
    }

    Navigator.pop(context);

    final showFile = await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(t.legacy_project.dialogs.made_backup.title),
            content: Text(file.path),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(t.common.labels.ok),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child:
                    Text(t.legacy_project.dialogs.made_backup.labels.show_me),
              ),
            ],
          )),
    );
    if (showFile != null && showFile) {
      launchUrl(Uri.file(file.parent.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDoingTask = ref.watch(_doingTaskProvider);
    final t = ref.watch(translationProvider);
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.path),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: isDoingTask
                      ? null
                      : () {
                          _didClickMigrate(context, ref);
                        },
                  child: Text(t.legacy_project.labels.migrate),
                ),
                OutlinedButton(
                  onPressed: isDoingTask
                      ? null
                      : () {
                          _didClickOpenFolder();
                        },
                  child: Text(t.legacy_project.labels.open_folder),
                ),
                OutlinedButton(
                  onPressed: isDoingTask
                      ? null
                      : () {
                          _didClickMakeBackup(context, ref);
                        },
                  child: Text(t.legacy_project.labels.make_backup),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MigrationProgressDialog extends ConsumerWidget {
  const _MigrationProgressDialog(this.project);

  final VccProject project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(_migrationMessageProvider);
    final errorMessage = ref.watch(_errorMessageProvider);
    final t = ref.watch(translationProvider);
    return AlertDialog(
      title: Text(t.legacy_project.dialogs.progress_migration
          .title(name: project.name)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black87),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  child: Text(
                    message.trim(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      actions: errorMessage != ''
          ? [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(t.common.labels.ok),
              )
            ]
          : null,
    );
  }
}
