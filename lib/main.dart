import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/models/new_project_model.dart';
import 'package:tiny_vcc/models/projects_model.dart';
import 'package:tiny_vcc/repos/unity_editors_repository.dart';
import 'package:tiny_vcc/repos/vcc_projects_repository.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:tiny_vcc/repos/vpm_packages_repository.dart';
import 'package:tiny_vcc/routes/new_project_route.dart';
import 'package:tiny_vcc/routes/project_route.dart';
import 'package:tiny_vcc/routes/projects_route.dart';
import 'package:tiny_vcc/routes/settings_route.dart';
import 'package:tiny_vcc/services/vcc_service.dart';
import 'package:window_size/window_size.dart';

import 'models/project_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(MyApp(
    vcc: VccService(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.vcc})
      : _projectsRepo = VccProjectsRepository(vcc),
        _packagesRepository = VpmPackagesRepository(vcc),
        _unityRepo = UnityEditorsRepository(vcc),
        _settingRepo = VccSettingRepository(vcc);

  final VccService vcc;
  final VccProjectsRepository _projectsRepo;
  final VpmPackagesRepository _packagesRepository;
  final UnityEditorsRepository _unityRepo;
  final VccSettingRepository _settingRepo;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _unityRepo.fetchEditors();
    _packagesRepository.fetchPackages();
    _settingRepo.checkVpmCli();

    setWindowTitle('Tiny VCC');
    return MaterialApp(
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
      initialRoute: ProjectsRoute.routeName,
      routes: {
        ProjectsRoute.routeName: (context) =>
            ChangeNotifierProvider<ProjectsModel>(
              create: (context) => ProjectsModel(_projectsRepo, _settingRepo),
              child: const ProjectsRoute(),
            ),
        NewProjectRoute.routeName: (context) =>
            ChangeNotifierProvider<NewProjectModel>(
              create: (context) => NewProjectModel(vcc),
              child: NewProjectRoute(),
            ),
        SettingsRoute.routeName: ((context) => const SettingsRoute(counter: 1)),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProjectRoute.routeName) {
          final args = settings.arguments as ProjectRouteArguments;
          return MaterialPageRoute(
            builder: ((context) => ChangeNotifierProvider<ProjectModel>(
                  create: (context) => ProjectModel(
                    vcc,
                    _unityRepo,
                    _packagesRepository,
                    args.project,
                  ),
                  child: const ProjectRoute(),
                )),
          );
        }
        return null;
      },
      navigatorObservers: [routeObserver],
    );
  }
}
