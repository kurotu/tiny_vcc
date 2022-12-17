import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/models/legacy_project_model.dart';
import 'package:tiny_vcc/models/new_project_model.dart';
import 'package:tiny_vcc/models/projects_model.dart';
import 'package:tiny_vcc/repos/requirements_repository.dart';
import 'package:tiny_vcc/repos/unity_editors_repository.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:tiny_vcc/repos/vpm_packages_repository.dart';
import 'package:tiny_vcc/routes/legacy_project_route.dart';
import 'package:tiny_vcc/routes/new_project_route.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/routes/projects_route.dart';
import 'package:tiny_vcc/routes/settings_route.dart';
import 'package:tiny_vcc/services/unity_hub_service.dart';
import 'package:tiny_vcc/services/updater_service.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';

import 'models/project_model.dart';
import 'services/dotnet_service.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> _checkForUpdate() async {
  final current = Version(0, 0, 0);
  final Release latest;
  try {
    latest = await UpdaterService(RepositorySlug('kurotu', 'tiny-vcc'))
        .getLatestRelease();
  } catch (error) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text('Failed to check for update: $error'),
    ));
    return;
  }
  final latestVersion =
      Version.parse(latest.tagName!.replaceFirst(RegExp('^v'), ''));
  if (latestVersion > current) {
    scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
      content: Text('New version $latestVersion is available.'),
      actions: [
        TextButton(
          onPressed: () {
            launchUrl(Uri.parse(latest.htmlUrl!));
            scaffoldKey.currentState?.clearMaterialBanners();
          },
          child: const Text('Download'),
        ),
        TextButton(
          onPressed: () {
            scaffoldKey.currentState?.clearMaterialBanners();
          },
          child: const Text('Dismiss'),
        ),
      ],
    ));
  }
}

void main() {
  Timer.periodic(const Duration(days: 1), ((timer) {
    _checkForUpdate();
  }));
  _checkForUpdate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setWindowTitle('Tiny VCC');
    return MultiProvider(
        providers: [
          Provider(create: (context) => UnityHubService()),
          Provider(create: (context) => DotNetService()),
          Provider(create: (context) => VccService(context)),
          Provider(create: (context) => RequirementsRepository(context)),
          Provider(create: (context) => VccProjectsRepository(context)),
          Provider(create: (context) => VpmPackagesRepository(context)),
          Provider(create: (context) => UnityEditorsRepository(context)),
          Provider(create: (context) => VccSettingRepository(context)),
        ],
        child: MaterialApp(
          title: 'Tiny VCC',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          scaffoldMessengerKey: scaffoldKey,
          initialRoute: ProjectsRoute.routeName,
          routes: {
            ProjectsRoute.routeName: (context) =>
                ChangeNotifierProvider<ProjectsModel>(
                  create: (context) => ProjectsModel(context),
                  child: const ProjectsRoute(),
                ),
            NewProjectRoute.routeName: (context) =>
                ChangeNotifierProvider<NewProjectModel>(
                  create: (context) => NewProjectModel(context),
                  child: const NewProjectRoute(),
                ),
            SettingsRoute.routeName: ((context) =>
                const SettingsRoute(counter: 1)),
          },
          onGenerateRoute: (settings) {
            if (settings.name == ProjectRoute.routeName) {
              final args = settings.arguments as ProjectRouteArguments;
              return MaterialPageRoute(
                builder: ((context) => ChangeNotifierProvider<ProjectModel>(
                      create: (context) => ProjectModel(
                        context,
                        args.project,
                      ),
                      child: const ProjectRoute(),
                    )),
              );
            } else if (settings.name == LegacyProjectRoute.routeName) {
              final args = settings.arguments as LegacyProjectRouteArguments;
              return MaterialPageRoute(
                builder: ((context) =>
                    ChangeNotifierProvider<LegacyProjectModel>(
                      create: ((context) =>
                          LegacyProjectModel(context, args.project)),
                      child: const LegacyProjectRoute(),
                    )),
              );
            }
            return null;
          },
          navigatorObservers: [routeObserver],
        ));
  }
}
