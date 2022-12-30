import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:github/github.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart';
import 'models/legacy_project_model.dart';
import 'models/new_project_model.dart';
import 'models/project_model.dart';
import 'models/projects_model.dart';
import 'models/settings_model.dart';
import 'repos/requirements_repository.dart';
import 'repos/vcc_projects_repository.dart';
import 'repos/vcc_settings_repository.dart';
import 'repos/vpm_packages_repository.dart';
import 'routes/legacy_project_route.dart';
import 'routes/new_project_route.dart';
import 'routes/project_route.dart';
import 'routes/projects_route.dart';
import 'routes/requirements_route.dart';
import 'routes/settings_route.dart';
import 'services/dotnet_service.dart';
import 'services/tiny_vcc_service.dart';
import 'services/unity_hub_service.dart';
import 'services/updater_service.dart';
import 'services/vcc_service.dart';
import 'utils.dart';

Future<void> _checkForUpdate() async {
  final current = Version.parse((await PackageInfo.fromPlatform()).version);
  debugPrint('Current: $current');
  final Release latest;
  try {
    latest = await UpdaterService(RepositorySlug('kurotu', 'tiny_vcc'))
        .getLatestRelease();
  } on Exception catch (error) {
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

void main() async {
  FlutterError.onError = (details) {
    var message = 'Unhandled Flutter error. ${details.exception}';
    if (details.stack != null) {
      message += details.stack.toString();
    }
    if (logger != null) {
      logger?.wtf(message);
    } else {
      log(message);
    }
    if (kReleaseMode) {
      exit(1);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    final message =
        'Unhandled PlatformDispatcher error. $error\n${stack.toString()}';
    if (logger != null) {
      logger?.wtf(message);
    } else {
      log(message);
    }
    if (kReleaseMode) {
      exit(1);
    }
    return true;
  };

  runApp(const riverpod.ProviderScope(child: MyApp()));

  if (kReleaseMode) {
    Logger.level = Level.info;
  }
  logger = await createLogger(kReleaseMode);
  final info = await PackageInfo.fromPlatform();
  logger?.i('Launched ${info.appName} ${info.version}.');

  Timer.periodic(const Duration(days: 1), ((timer) {
    _checkForUpdate();
  }));
  _checkForUpdate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => UnityHubService()),
          Provider(create: (context) => DotNetService()),
          Provider(create: (context) => VccService(context)),
          Provider(create: (context) => TinyVccService()),
          Provider(create: (context) => RequirementsRepository(context)),
          Provider(create: (context) => VccProjectsRepository(context)),
          Provider(create: (context) => VpmPackagesRepository(context)),
          Provider(create: (context) => VccSettingsRepository(context)),
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
            SettingsRoute.routeName: (context) =>
                ChangeNotifierProvider<SettingsModel>(
                  create: (context) => SettingsModel(context),
                  child: const SettingsRoute(),
                ),
            RequirementsRoute.routeName: (context) => const RequirementsRoute(),
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
