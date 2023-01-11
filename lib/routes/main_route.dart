import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main_drawer.dart';
import '../providers.dart';
import '../widgets/navigation_scaffold.dart';
import '../widgets/projects_page.dart';
import '../widgets/settings_page.dart';
import 'new_project_route.dart';

final _selectedIndexProvider =
    StateProvider.autoDispose((ref) => _PageIndex.projects);

enum _PageIndex {
  projects,
  settings,
  about,
}

const _titles = {
  _PageIndex.projects: 'Projects',
  _PageIndex.settings: 'Settings',
};

enum ScreenSize { small, normal, large }

ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth < 600) return ScreenSize.small;
  if (deviceWidth < 900) return ScreenSize.normal;
  return ScreenSize.large;
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

  void _didClickNewProject(BuildContext context) {
    Navigator.pushNamed(context, NewProjectRoute.routeName);
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
    final size = getSize(context);
    final t = ref.watch(translationProvider);
    return NavigationScaffold(
      appBar: AppBar(
        title: Text(_titles[selectedIndex] ?? ''),
        actions: _buildActions(context, ref, selectedIndex),
      ),
      useNavigationRail: size != ScreenSize.small,
      drawer: MainDrawer(
        selectedIndex: selectedIndex.index,
        onItemSelected: (index) {
          _didSelectNavItem(ref, index);
        },
      ),
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.none,
        extended: size == ScreenSize.large,
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
      floatingActionButton: _buildFAB(context, selectedIndex),
    );
  }

  List<Widget>? _buildActions(
      BuildContext context, WidgetRef ref, _PageIndex selectedIndex) {
    switch (selectedIndex) {
      case _PageIndex.projects:
        return [
          IconButton(
            onPressed: () {
              _didClickAddProject(context, ref);
            },
            tooltip: 'Add existing project',
            icon: const Icon(Icons.create_new_folder),
          ),
        ];
      case _PageIndex.settings:
        return [
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
        ];
      default:
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

  Widget? _buildFAB(BuildContext context, _PageIndex selectedIndex) {
    switch (selectedIndex) {
      case _PageIndex.projects:
        return FloatingActionButton(
          tooltip: 'Create new project',
          child: const Icon(Icons.add),
          onPressed: () {
            _didClickNewProject(context);
          },
        );
      case _PageIndex.settings:
      case _PageIndex.about:
        return null;
    }
  }
}
