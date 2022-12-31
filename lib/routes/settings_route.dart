import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../main_drawer.dart';
import '../providers.dart';
import '../utils.dart';

final _editorLoadingProvider =
    StateNotifierProvider<EditorLoadingController, bool>(
        (ref) => EditorLoadingController());

class EditorLoadingController extends StateNotifier<bool> {
  EditorLoadingController() : super(false);

  bool get isLoading => state;
  set isLoading(value) {
    state = value;
  }
}

class SettingsRoute extends ConsumerStatefulWidget {
  const SettingsRoute({super.key});

  static const String routeName = '/settings';

  @override
  ConsumerState<SettingsRoute> createState() => _SettingsRoute();
}

class _SettingsRoute extends ConsumerState<SettingsRoute> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final backupLocationController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() async {
    ref.read(vccSettingsProvider).whenData(
        (value) => backupLocationController.text = value.projectBackupPath);
  }

  void _didClickOpenSettingsFolder() {
    final dir = ref.read(vccServiceProvider).getSettingsDirectory();
    launchUrl(Uri.file(dir.path));
  }

  void _didClickOpenLogsFolder() async {
    final dir = await ref.read(tinyVccServiceProvider).getLogsDirectory();
    launchUrl(Uri.file(dir.path));
  }

  Future<void> _didClickEditorRefresh() async {
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

  Future<void> _didClickEditorFilePicker() async {
    try {
      final path = await showFilePickerWindow(
        dialogTitle: Platform.isWindows ? 'Select Unity.exe' : null,
        lockParentWindow: true,
        allowedExtensions: Platform.isWindows ? ['exe'] : null,
      );
      if (path == null) {
        return;
      }
      if (mounted) {
        await ref.read(vccSettingsRepoProvider).setPreferredEditor(path);
        final _ = ref.refresh(vccSettingsProvider);
      }
    } on Exception catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(context,
            'Error occurred when setting preferred Unity editor.', error);
      }
    }
  }

  Future<void> _didChangePreferredEditor(String? editorPath) async {
    try {
      if (editorPath == null) {
        return;
      }
      if (mounted) {
        await ref.read(vccSettingsRepoProvider).setPreferredEditor(editorPath);
        final _ = ref.refresh(vccSettingsProvider);
      }
    } on Exception catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(context,
            'Error occurred when changing preferred Unity editor.', error);
      }
    }
  }

  Future<void> _didClickBackupFolderPicker() async {
    try {
      final path = await showDirectoryPickerWindow(
        lockParentWindow: true,
        initialDirectory:
            ref.read(vccSettingsProvider).requireValue.projectBackupPath,
      );
      if (path == null) {
        return;
      }
      if (mounted) {
        ref.read(vccSettingsRepoProvider).setBackupFolder(path);
        final _ = ref.refresh(vccSettingsProvider);
      }
    } on Exception catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(
            context, 'Error occurred when setting backup folder.', error);
      }
    }
  }

  Future<void> _didClickAddUserPackage() async {
    try {
      final packagePath =
          await showDirectoryPickerWindow(lockParentWindow: true);
      if (packagePath == null) {
        return;
      }
      if (!mounted) {
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

  Future<void> _didClickRemoveUserPackage(String userPackage) async {
    try {
      if (mounted) {
        await ref
            .read(vccSettingsRepoProvider)
            .deleteUserPackageFolder(userPackage);
        final _ = ref.refresh(vccSettingsProvider);
      }
    } on Exception catch (error) {
      await showSimpleErrorDialog(
          context, 'Error occurred when removing a package folder.', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(vccSettingsProvider, (previous, next) {
      next.when(
        data: (data) {
          backupLocationController.text = data.projectBackupPath;
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

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _didClickOpenSettingsFolder,
                child: const Text('Open VCC Settings Folder'),
              ),
              PopupMenuItem(
                onTap: _didClickOpenLogsFolder,
                child: const Text('Open Logs Folder'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: 'Unity Editors',
                      suffixIcon: Wrap(spacing: 8, children: [
                        isLoadingEditors
                            ? const IconButton(
                                onPressed: null,
                                icon: CircularProgressIndicator())
                            : IconButton(
                                onPressed: _didClickEditorRefresh,
                                icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: isLoadingEditors
                                ? null
                                : _didClickEditorFilePicker,
                            icon: const Icon(Icons.folder)),
                      ])),
                  value: settings.valueOrNull?.pathToUnityExe,
                  items: settings.valueOrNull?.unityEditors
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged:
                      isLoadingEditors ? null : _didChangePreferredEditor,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Backups',
                    suffixIcon: IconButton(
                      onPressed:
                          isLoadingEditors ? null : _didClickBackupFolderPicker,
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
                        onPressed:
                            isLoadingEditors ? null : _didClickAddUserPackage,
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
                                    _didClickRemoveUserPackage(settings
                                        .requireValue
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
