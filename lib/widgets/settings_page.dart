import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

import '../data/tiny_vcc_data.dart';
import '../providers.dart';
import '../utils.dart';

final _formKeyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());
final _editorLoadingProvider =
    StateNotifierProvider<EditorLoadingController, bool>(
        (ref) => EditorLoadingController());
final _backupLocationControllerProvider = Provider.autoDispose((ref) {
  final path = ref.read(vccSettingsProvider).requireValue.projectBackupPath;
  return TextEditingController(text: path);
});

class EditorLoadingController extends StateNotifier<bool> {
  EditorLoadingController() : super(false);

  bool get isLoading => state;
  set isLoading(value) {
    state = value;
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static void didClickOpenSettingsFolder(WidgetRef ref) {
    final dir = ref.read(vccServiceProvider).getSettingsDirectory();
    launchUrl(Uri.file(dir.path));
  }

  static void didClickOpenLogsFolder(WidgetRef ref) async {
    final dir = await ref.read(tinyVccServiceProvider).getLogsDirectory();
    launchUrl(Uri.file(dir.path));
  }

  Future<void> _didClickEditorRefresh(WidgetRef ref) async {
    ref.read(_editorLoadingProvider.notifier).isLoading = true;
    await ref.read(vccServiceProvider).checkHub();
    final hub = ref.read(unityHubServiceProvider);
    final editors = await hub.listInstalledEditors();
    final settings = ref.read(vccSettingsProvider).requireValue;
    final newEditors = {
      ...settings.unityEditors,
      ...editors.values,
    }.toList();
    newEditors.removeWhere((element) => !File(element).existsSync());
    newEditors.sort();
    await ref.read(vccSettingsRepoProvider).setUnityEditors(newEditors);
    ref.read(_editorLoadingProvider.notifier).isLoading = false;
    ref.refresh(vccSettingsProvider);
  }

  Future<void> _didClickEditorFilePicker(
      BuildContext context, WidgetRef ref) async {
    try {
      final path = await showFilePickerWindow(
        dialogTitle: Platform.isWindows ? 'Select Unity.exe' : null,
        lockParentWindow: true,
        allowedExtensions: Platform.isWindows ? ['exe'] : null,
      );
      if (path == null) {
        return;
      }
      await ref.read(vccSettingsRepoProvider).setPreferredEditor(path);
      final _ = ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      await showSimpleErrorDialog(context,
          'Error occurred when setting preferred Unity editor.', error);
    }
  }

  Future<void> _didChangePreferredEditor(
      BuildContext context, WidgetRef ref, String? editorPath) async {
    try {
      if (editorPath == null) {
        return;
      }
      await ref.read(vccSettingsRepoProvider).setPreferredEditor(editorPath);
      final _ = ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      await showSimpleErrorDialog(context,
          'Error occurred when changing preferred Unity editor.', error);
    }
  }

  Future<void> _didClickBackupFolderPicker(
      BuildContext context, WidgetRef ref) async {
    try {
      final path = await showDirectoryPickerWindow(
        lockParentWindow: true,
        initialDirectory:
            ref.read(vccSettingsProvider).requireValue.projectBackupPath,
      );
      if (path == null) {
        return;
      }
      await ref.read(vccSettingsRepoProvider).setBackupFolder(path);
      final _ = ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      await showSimpleErrorDialog(
          context, 'Error occurred when setting backup folder.', error);
    }
  }

  Future<void> _didClickAddUserPackage(
      BuildContext context, WidgetRef ref) async {
    try {
      final packagePath =
          await showDirectoryPickerWindow(lockParentWindow: true);
      if (packagePath == null) {
        return;
      }
      if (!await File(p.join(packagePath, 'package.json')).exists()) {
        throw Exception(
            '$packagePath is not a package. package.json is missing.');
      }
      await ref.read(vccSettingsRepoProvider).addUserPackageFolder(packagePath);
      final _ = ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      await showSimpleErrorDialog(
          context, 'Error occurred when adding a package folder.', error);
    }
  }

  Future<void> _didClickRemoveUserPackage(
      BuildContext context, WidgetRef ref, String userPackage) async {
    try {
      await ref
          .read(vccSettingsRepoProvider)
          .deleteUserPackageFolder(userPackage);
      final _ = ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      await showSimpleErrorDialog(
          context, 'Error occurred when removing a package folder.', error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(vccSettingsProvider, (previous, next) {
      next.when(
        data: (data) {
          ref.read(_backupLocationControllerProvider).text =
              data.projectBackupPath;
        },
        error: (error, stack) {
          showSimpleErrorDialog(
              context, 'Error occurred when loading settings.', error);
        },
        loading: () {},
      );
    });
    final settings = ref.watch(vccSettingsProvider);
    final isLoadingEditors = ref.watch(_editorLoadingProvider);
    final formKey = ref.watch(_formKeyProvider);
    final backupLocationController =
        ref.watch(_backupLocationControllerProvider);
    final tinyVccSettings = ref.watch(tinyVccSettingsProvider);

    return Scaffold(
//      drawer: const MainDrawer(),
/*
        appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  _didClickOpenSettingsFolder(ref);
                },
                child: const Text('Open VCC Settings Folder'),
              ),
              PopupMenuItem(
                onTap: () {
                  _didClickOpenLogsFolder(ref);
                },
                child: const Text('Open Logs Folder'),
              ),
            ],
          ),
        ],
      ),
*/
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiny VCC Preferences',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Theme'),
                  value: tinyVccSettings.valueOrNull?.themeMode,
                  items: TinyVccThemeMode.values
                      .map((mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(toBeginningOfSentenceCase(mode.name)!),
                          ))
                      .toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await ref
                          .read(tinyVccSettingsRepositoryProvider)
                          .setThemeMode(value);
                      ref.refresh(tinyVccSettingsProvider);
                    }
                  },
                ),
                const Divider(),
                Text(
                  'VCC Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: 'Unity Editors',
                      suffixIcon: Wrap(spacing: 8, children: [
                        isLoadingEditors
                            ? const IconButton(
                                onPressed: null,
                                icon: CircularProgressIndicator())
                            : IconButton(
                                onPressed: () {
                                  _didClickEditorRefresh(ref);
                                },
                                icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: isLoadingEditors
                                ? null
                                : () {
                                    _didClickEditorFilePicker(context, ref);
                                  },
                            icon: const Icon(Icons.folder)),
                      ])),
                  value: settings.valueOrNull?.pathToUnityExe,
                  items: settings.valueOrNull?.unityEditors
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: isLoadingEditors
                      ? null
                      : (String? value) {
                          _didChangePreferredEditor(context, ref, value);
                        },
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Backups',
                    suffixIcon: IconButton(
                      onPressed: isLoadingEditors
                          ? null
                          : () {
                              _didClickBackupFolderPicker(context, ref);
                            },
                      icon: const Icon(Icons.folder),
                    ),
                  ),
                  controller: backupLocationController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                Row(
                  children: [
                    const Text('User Packages'),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                    OutlinedButton(
                        onPressed: isLoadingEditors
                            ? null
                            : () {
                                _didClickAddUserPackage(context, ref);
                              },
                        child: const Text('Add')),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: ((context, index) => ListTile(
                          title: Text(
                              settings.requireValue.userPackageFolders[index]),
                          trailing: IconButton(
                            onPressed: isLoadingEditors
                                ? null
                                : () {
                                    _didClickRemoveUserPackage(
                                        context,
                                        ref,
                                        settings.requireValue
                                            .userPackageFolders[index]);
                                  },
                            icon: const Icon(Icons.delete),
                          ),
                        )),
                    itemCount:
                        settings.valueOrNull?.userPackageFolders.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
