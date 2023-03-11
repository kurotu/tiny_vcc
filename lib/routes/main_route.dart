import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/m3_speed_dial.dart';

import '../globals.dart';
import '../main_drawer.dart';
import '../providers.dart';
import '../utils.dart';
import '../utils/layout_util.dart';
import '../widgets/navigation_scaffold.dart';
import '../widgets/new_project_dialog.dart';
import '../widgets/new_project_form.dart';
import '../widgets/projects_page.dart';
import '../widgets/settings_page.dart';

final _selectedIndexProvider =
    StateProvider.autoDispose((ref) => _PageIndex.projects);

enum _PageIndex {
  projects,
  settings,
  about,
}

class MainRoute extends ConsumerWidget {
  static const routeName = '/main';

  const MainRoute({super.key});

  void _didSelectAbout(
      BuildContext context, PackageInfo? packageInfo, String? licenseNotice) {
    showAboutDialog(
      context: context,
      applicationVersion: packageInfo?.version,
      applicationIcon: Image.asset(
        'assets/images/app_icon-1024x1024.png',
        width: 64,
        height: 64,
      ),
      applicationLegalese: licenseNotice,
    );
  }

  void _didSelectNavItem(WidgetRef ref, int selectedIndex) {
    ref.read(_selectedIndexProvider.notifier).state =
        _PageIndex.values[selectedIndex];
  }

  void _didClickAddProject(BuildContext context, WidgetRef ref) {
    ProjectsPage.addProject(context, ref);
  }

  void _didClickNewProject(BuildContext context, WidgetRef ref) async {
    final templates = await ref.read(vpmTemplatesProvider.future);
    final defaultLocation =
        (await ref.read(vccSettingsProvider.future)).defaultProjectPath;
    final data = await showDialog<NewProjectFormData>(
      context: context,
      builder: (context) => NewProjectDialog(
        templates: templates,
        defaultLocation: defaultLocation,
        onPressedCreate: (data) {
          Navigator.of(context).pop(data);
        },
        onClickLocationButton: () async {
          final location = await showDirectoryPickerWindow(
            lockParentWindow: true,
            initialDirectory:
                ref.read(vccSettingsProvider).valueOrNull?.defaultProjectPath,
          );
          if (location != null) {
            await ref
                .read(vccServiceProvider)
                .setSettings(defaultProjectPath: location);
            ref.refresh(vccSettingsProvider);
          }
          return location;
        },
      ),
    );
    if (data == null) {
      return;
    }
    final t = ref.read(translationProvider);
    showSnackBar(
      context,
      t.new_project.info.creating_project(
        template: data.template!.name,
        name: data.name,
        location: data.location,
      ),
    );
    try {
      final newProject = await ref
          .read(vccProjectsRepoProvider)
          .createVccProject(data.template!, data.name, data.location);
      ref.refresh(vccSettingsProvider);
    } on Exception catch (error) {
      logger?.e(error);
      showSnackBar(
          context,
          t.new_project.errors.failed_to_create_project +
              '\n${error.toString()}');
      return;
    }
    showSnackBar(
      context,
      t.new_project.info.created_project(
        template: data.template!.name,
        name: data.name,
        projectLocation: data.location,
      ),
    );
  }

  void _didClickOpenSettingsFolder(WidgetRef ref) {
    SettingsPage.didClickOpenSettingsFolder(ref);
  }

  void _didClickOpenLogsFolder(WidgetRef ref) {
    SettingsPage.didClickOpenLogsFolder(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedIndexProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final notice = ref.watch(licenseNoticeProvider);
    final size = getScreenSizeClass(context);
    final t = ref.watch(translationProvider);
    return NavigationScaffold(
      appBar: AppBar(
        title: Text({
              _PageIndex.projects: t.navigation.projects,
              _PageIndex.settings: t.navigation.settings,
            }[selectedIndex] ??
            ''),
        actions: _buildActions(context, ref, selectedIndex),
      ),
      useNavigationRail: size != ScreenSizeClass.small,
      drawer: MainDrawer(
        selectedIndex: selectedIndex.index,
        onItemSelected: (index) {
          _didSelectNavItem(ref, index);
        },
      ),
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.none,
        extended: size == ScreenSizeClass.large,
        leading: size == ScreenSizeClass.large
            ? Container(
                width: 256,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [_buildExtendedNavRailFAB(context, ref)]),
              )
            : _buildNavRailFAB(context, ref),
        destinations: [
          NavigationRailDestination(
              icon: const Icon(Icons.folder_special_outlined),
              selectedIcon: const Icon(Icons.folder_special),
              label: Text(t.navigation.projects)),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: Text(t.navigation.settings),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.info_outline),
            label: Text(t.navigation.about),
          ),
        ],
        selectedIndex: selectedIndex.index,
        onDestinationSelected: (value) {
          if (value == 2) {
            _didSelectAbout(
                context, packageInfo.valueOrNull, notice.valueOrNull);
          } else {
            _didSelectNavItem(ref, value);
          }
        },
      ),
      body: _buildBody(context, selectedIndex),
      floatingActionButton: size == ScreenSizeClass.small
          ? _buildFAB(context, ref, selectedIndex)
          : null,
    );
  }

  List<Widget>? _buildActions(
      BuildContext context, WidgetRef ref, _PageIndex selectedIndex) {
    final t = ref.watch(translationProvider);
    switch (selectedIndex) {
      case _PageIndex.projects:
        return null;
      case _PageIndex.settings:
        return [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  _didClickOpenSettingsFolder(ref);
                },
                child: Text(t.actions.open_vcc_settings_folder.label),
              ),
              PopupMenuItem(
                onTap: () {
                  _didClickOpenLogsFolder(ref);
                },
                child: Text(t.actions.open_logs_folder.label),
              ),
            ],
          ),
        ];
      case _PageIndex.about:
        return null;
    }
  }

  Widget _buildBody(BuildContext context, _PageIndex selectedIndex) {
    switch (selectedIndex) {
      case _PageIndex.projects:
        return const ProjectsPage();
      case _PageIndex.settings:
        return const SettingsPage();
      case _PageIndex.about:
        throw Error();
    }
  }

  Widget? _buildFAB(
      BuildContext context, WidgetRef ref, _PageIndex selectedIndex) {
    switch (selectedIndex) {
      case _PageIndex.projects:
        return m3SpeedDial(
          icon: Icons.add,
          children: _buildSpeedDialChildren(context, ref),
        );
      case _PageIndex.settings:
      case _PageIndex.about:
        return null;
    }
  }

  Widget _buildNavRailFAB(BuildContext context, WidgetRef ref) {
    return m3SpeedDial(
      icon: Icons.add,
      switchLabelPosition: true,
      direction: SpeedDialDirection.down,
      children: _buildSpeedDialChildren(context, ref),
    );
  }

  Widget _buildExtendedNavRailFAB(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider);
    return m3SpeedDial(
      icon: Icons.add,
      label: Text(t.navigation.new_project),
      isExtended: true,
      switchLabelPosition: true,
      direction: SpeedDialDirection.down,
      children: _buildSpeedDialChildren(context, ref),
    );
  }

  List<SpeedDialChild> _buildSpeedDialChildren(
      BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider);
    return [
      m3SpeedDialChild(
          child: const Icon(Icons.create),
          label: t.actions.create_project.tooltip,
          onTap: () {
            _didClickNewProject(context, ref);
          }),
      m3SpeedDialChild(
          child: const Icon(Icons.folder_open),
          label: t.actions.add_project.tooltip,
          onTap: () {
            _didClickAddProject(context, ref);
          }),
    ];
  }
}
