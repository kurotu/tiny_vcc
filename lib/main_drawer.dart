import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'routes/projects_route.dart';
import 'routes/settings_route.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text("Projects"),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name !=
                  ProjectsRoute.routeName) {
                Navigator.pushReplacementNamed(
                    context, ProjectsRoute.routeName);
              }
            },
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name !=
                  SettingsRoute.routeName) {
                Navigator.pushReplacementNamed(
                    context, SettingsRoute.routeName);
              }
            },
          ),
          _AboutListTile(),
        ],
      ),
    );
  }
}

class _AboutListTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(packageInfoProvider);
    final notice = ref.watch(licenseNoticeProvider);
    return AboutListTile(
      applicationVersion: info.value?.version,
      applicationIcon: Image.asset(
        'assets/images/app_icon-1024x1024.png',
        width: 64,
        height: 64,
      ),
      applicationLegalese: notice.value,
    );
  }
}
