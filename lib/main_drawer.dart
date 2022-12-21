import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/routes/projects_route.dart';
import 'package:tiny_vcc/routes/settings_route.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final info = context.watch<PackageInfo?>();

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
            create: (context) =>
                rootBundle.loadString('assets/texts/LICENSE_NOTICE'),
            initialData: null,
            builder: (context, child) {
              final license = context.watch<String?>();
              return AboutListTile(
                applicationVersion: info?.version,
                applicationIcon: Image.asset(
                  'assets/images/app_icon-1024x1024.png',
                  width: 64,
                  height: 64,
                ),
                applicationLegalese: license,
              );
            },
          ),
        ],
      ),
    );
  }
}
