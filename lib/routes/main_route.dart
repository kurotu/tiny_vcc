import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main_drawer.dart';
import '../providers.dart';
import '../widgets/navigation_scaffold.dart';
import 'new_project_route.dart';
import 'projects_route.dart';
import 'settings_route.dart';

final _selectedIndexProvider = StateProvider.autoDispose((ref) => 0);

enum ScreenSize { small, normal, large }

ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth < 600) return ScreenSize.small;
  if (deviceWidth < 900) return ScreenSize.normal;
  return ScreenSize.large;
}

const _titles = ['Projects', 'Settings'];

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
    ref.read(_selectedIndexProvider.notifier).state = selectedIndex;
  }

  void _didClickAddProject(BuildContext context, WidgetRef ref) {
    ProjectsRoute.addProject(context, ref);
  }

  void _didClickNewProject(BuildContext context) {
    Navigator.pushNamed(context, NewProjectRoute.routeName);
  }

  void _didClickOpenSettingsFolder(WidgetRef ref) {
    SettingsRoute.didClickOpenSettingsFolder(ref);
  }

  void _didClickOpenLogsFolder(WidgetRef ref) {
    SettingsRoute.didClickOpenLogsFolder(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedIndexProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final notice = ref.watch(licenseNoticeProvider);
    final size = getSize(context);

    return NavigationScaffold(
      appBar: AppBar(
        title: Text(_titles[selectedIndex]),
        actions: buildActions(context, ref, selectedIndex),
      ),
      useNavigationRail: size != ScreenSize.small,
      drawer: MainDrawer(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          _didSelectNavItem(ref, index);
        },
      ),
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.none,
        extended: size == ScreenSize.large,
        destinations: const [
          NavigationRailDestination(
              icon: Icon(Icons.folder_special_outlined),
              selectedIcon: Icon(Icons.folder_special),
              label: Text('Projects')),
          NavigationRailDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.info_outline),
            label: Text('About'),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          if (value == 2) {
            _didSelectAbout(
                context, packageInfo.valueOrNull, notice.valueOrNull);
          } else {
            _didSelectNavItem(ref, value);
          }
        },
      ),
      body: buildBody(context, selectedIndex),
    );
  }

  List<Widget>? buildActions(
      BuildContext context, WidgetRef ref, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return [
          IconButton(
            onPressed: () {
              _didClickAddProject(context, ref);
            },
            tooltip: 'Add existing project',
            icon: const Icon(Icons.create_new_folder),
          ),
          IconButton(
            onPressed: () {
              _didClickNewProject(context);
            },
            tooltip: 'Create new project',
            icon: const Icon(Icons.add),
          ),
        ];
      case 1:
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

  Widget buildBody(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const ProjectsRoute();
      case 1:
        return const SettingsRoute();
      default:
        throw Error();
    }
  }
}
