import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

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
          FutureProvider(
            create: (context) async {
              final notice =
                  await rootBundle.loadString('assets/texts/LICENSE_NOTICE');
              final packageInfo = await PackageInfo.fromPlatform();
              return _AboutListTileData(
                applicationVersion: packageInfo.version,
                applicationLegalese: notice,
              );
            },
            initialData: null,
            builder: (context, child) {
              final info = context.watch<_AboutListTileData?>();
              return AboutListTile(
                applicationVersion: info?.applicationVersion,
                applicationIcon: Image.asset(
                  'assets/images/app_icon-1024x1024.png',
                  width: 64,
                  height: 64,
                ),
                applicationLegalese: info?.applicationLegalese,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutListTileData {
  _AboutListTileData({
    required this.applicationVersion,
    required this.applicationLegalese,
  });

  final String applicationVersion;
  final String applicationLegalese;
}
