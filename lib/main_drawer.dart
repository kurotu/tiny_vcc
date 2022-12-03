import 'package:flutter/material.dart';
import 'package:tiny_vcc/routes/projects_route.dart';
import 'package:tiny_vcc/routes/settings_route.dart';

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
        ],
      ),
    );
  }
}
