import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../providers.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import '../widgets/package_list_item.dart';

final _needsToShowUnityBannerProvider =
    StateProvider.autoDispose((ref) => false);

final _lockedDependenciesProvider = FutureProvider.autoDispose
    .family<List<VpmDependency>, VccProject>(
        (ref, project) => project.getLockedDependencies());

final _packageItemListProvider = FutureProvider.autoDispose
    .family<List<PackageItem>, VccProject>((ref, project) async {
  final List<PackageItem> list = [];
  final settings = ref.watch(vccSettingsProvider);
  final selectedVersion = ref.watch(_selectedVersionProvider);
  final packages = ref.watch(vpmPackagesProvider);
  final lockedDeps = ref.watch(_lockedDependenciesProvider(project));

  if (packages.value == null) {
    return [];
  }

  if (!lockedDeps.hasValue) {
    return [];
  }

  final showPrerelease = settings.requireValue.showPrereleasePackages;
  final locked = lockedDeps.requireValue
      .where((element) =>
          ref
              .read(vpmPackagesRepoProvider)
              .getLatest(element.name, element.version, showPrerelease) !=
          null)
      .map((e) {
    final latest = ref
        .read(vpmPackagesRepoProvider)
        .getLatest(e.name, e.version, showPrerelease);
    return PackageItem(
      name: e.name,
      displayName: latest!.displayName,
      description: latest.description,
      versions: ref
          .read(vpmPackagesRepoProvider)
          .getVersions(e.name, e.version, showPrerelease),
      installedVersion: e.version,
      selectedVersion: selectedVersion[e.name] ?? latest.version,
      repoType: latest.repoType,
    );
  });
  list.addAll(locked);

  if (!lockedDeps.hasValue) {
    return [];
  }

  final not = packages.value
      ?.where(
          (p) => lockedDeps.requireValue.where((e) => e.name == p.name).isEmpty)
      .map((e) => e.name)
      .toSet();
  if (not != null) {
    list.addAll(not.map((name) {
      final latest = ref
          .read(vpmPackagesRepoProvider)
          .getLatest(name, null, showPrerelease);
      return PackageItem(
        name: name,
        displayName: latest!.displayName,
        description: latest.description,
        selectedVersion: selectedVersion[latest.name] ?? latest.version,
        versions: ref
            .read(vpmPackagesRepoProvider)
            .getVersions(name, null, showPrerelease),
        repoType: latest.repoType,
      );
    }));
  }

  return list;
});

final _selectedVersionProvider =
    StateNotifierProvider.autoDispose<SelectedVersion, Map<String, Version>>(
        (ref) => SelectedVersion());

class SelectedVersion extends StateNotifier<Map<String, Version>> {
  SelectedVersion() : super({});

  void select(String name, Version version) {
    final Map<String, Version> map = Map.from(state);
    map[name] = version;
    state = map;
  }

  Version? getSelectedVersion(String name) {
    return state[name];
  }
}

class ProjectRouteArguments {
  ProjectRouteArguments({required this.project});

  final VccProject project;
}

class ProjectRoute extends ConsumerWidget {
  static const String routeName = '/project';

  const ProjectRoute(this.project, {super.key});

  final VccProject project;

  void _refreshLockedDependencies(WidgetRef ref) {
    ref.refresh(_lockedDependenciesProvider(project));
  }

  Future<void> _didClickOpenProject(WidgetRef ref) async {
    final t = ref.watch(translationProvider);
    var editorVersion = await project.getUnityEditorVersion();
    final editor =
        await ref.read(vccSettingsRepoProvider).getUnityEditor(editorVersion);
    if (editor == null) {
      throw Exception(
          t.project.info.unity_not_found(editorVersion: editorVersion));
    }
    await Process.start(editor, ['-projectPath', project.path],
        mode: ProcessStartMode.detached);
  }

  void _didClickOpenFolder() {
    final uri = Uri.file(project.path);
    launchUrl(uri);
  }

  void _didClickMakeBackup(BuildContext context, WidgetRef ref) async {
    final t = ref.watch(translationProvider);
    final projectName = project.name;
    showProgressDialog(context, Theme.of(context),
        t.project.dialogs.progress_backup.title(name: projectName));
    File file;
    try {
      file = await ref.read(vccProjectsRepoProvider).backup(project);
    } on Exception catch (error) {
      Navigator.pop(context);
      showAlertDialog(context,
          title: t.project.dialogs.backup_error.title,
          message: t.project.dialogs.backup_error
              .content(projectName: projectName, error: error));
      return;
    }

    Navigator.pop(context);

    final showFile = await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(t.project.dialogs.made_backup.title),
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
                child: Text(t.project.dialogs.made_backup.labels.show_me),
              ),
            ],
          )),
    );
    if (showFile != null && showFile) {
      launchUrl(Uri.file(file.parent.path));
    }
  }

  void _showMessageToCloseUnity(WidgetRef ref) {
    final t = ref.watch(translationProvider);
    ScaffoldFeatureController? controller;

    controller = scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
      content: Text(t.project.info.packages_changed),
      actions: [
        TextButton(
            onPressed: () {
              controller?.close();
              controller = null;
              ref.read(_needsToShowUnityBannerProvider.notifier).state = false;
            },
            child: Text(t.common.labels.dismiss)),
      ],
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesList = ref.watch(_packageItemListProvider(project));
    final t = ref.watch(translationProvider);
    ref.listen(_needsToShowUnityBannerProvider, (previous, next) {
      if (previous != next && next == true) {
        logger?.i('All requirements satisfied');
        _showMessageToCloseUnity(ref);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.all(16),
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
                      onPressed: () {
                        _didClickOpenProject(ref);
                      },
                      child: Text(t.project.labels.open_project)),
                  OutlinedButton(
                      onPressed: _didClickOpenFolder,
                      child: Text(t.project.labels.open_folder)),
                  OutlinedButton(
                    onPressed: () {
                      _didClickMakeBackup(context, ref);
                    },
                    child: Text(t.project.labels.make_backup),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildList(ref, packagesList),
        ),
      ]),
    );
  }

  Widget _buildList(WidgetRef ref, AsyncValue<List<PackageItem>> items) {
    if (!items.hasValue) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      itemCount: items.requireValue.length,
      itemBuilder: (context, index) {
        final dep = items.requireValue[index];
        return PackageListItem(
          item: dep,
          onSelect: (name, version) {
            ref.read(_selectedVersionProvider.notifier).select(name, version);
          },
          onClickAdd: (name) async {
            await ref.read(vccServiceProvider).addPackage(
                project.path, name, dep.selectedVersion!.toString());
            ref.read(_needsToShowUnityBannerProvider.notifier).state = true;
          },
          onClickRemove: (name) async {
            await ref
                .read(vccServiceProvider)
                .removePackage(project.path, name);
            _refreshLockedDependencies(ref);
            ref.read(_needsToShowUnityBannerProvider.notifier).state = true;
          },
          onClickUpdate: ((name) async {
            await ref
                .read(vccServiceProvider)
                .updatePackage(project.path, name, dep.selectedVersion!);
            _refreshLockedDependencies(ref);
            ref.read(_needsToShowUnityBannerProvider.notifier).state = true;
          }),
        );
      },
    );
  }
}
