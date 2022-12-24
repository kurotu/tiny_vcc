import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../main_drawer.dart';
import '../models/projects_model.dart';
import '../repos/requirements_repository.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import 'legacy_project_route.dart';
import 'new_project_route.dart';
import 'project_route.dart';

class ProjectsRoute extends StatefulWidget {
  const ProjectsRoute({super.key});

  static const String routeName = '/projects';

  @override
  State<ProjectsRoute> createState() => _ProjectsRoute();
}

class _ProjectsRoute extends State<ProjectsRoute> with RouteAware {
  void _addProject(ProjectsModel model) async {
    final path = await showDirectoryPickerWindow(lockParentWindow: true);
    try {
      await model.addProject(path);
    } on VccProjectType catch (type) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Project'),
          content: Text(() {
            switch (type) {
              case VccProjectType.invalid:
              case VccProjectType.unknown:
                return '"$path" is not a valid Unity project.';
              case VccProjectType.legacySdk2:
                return '"$path" is a VRCSDK2 project.';
              case VccProjectType.avatarVpm:
              case VccProjectType.worldVpm:
              case VccProjectType.legacySdk3Avatar:
              case VccProjectType.legacySdk3World:
                throw Error();
            }
          }()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _refreshProjects() async {
    if (!mounted) {
      return;
    }
    final model = context.read<ProjectsModel>();
    try {
      await model.getProjects();
      await model.getPackages();
    } on Exception catch (error) {
      print(error);
    }
    if (!mounted) {
      return;
    }
    final missing = await model.checkMissingRequirement();
    switch (missing) {
      case null:
        model.setReadyToUse(true);
        break;
      case RequirementType.dotnet6:
        scaffoldKey.currentState?.showMaterialBanner(
          MaterialBanner(
            content: const Text(
                '.NET 6 SDK is required to execute VPM CLI. Download and install.'),
            actions: [
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse(
                      'https://dotnet.microsoft.com/download/dotnet/6.0'));
                },
                child: const Text('Download'),
              ),
              TextButton(
                onPressed: () {
                  scaffoldKey.currentState?.clearMaterialBanners();
                  _refreshProjects();
                },
                child: const Text('Check again'),
              ),
            ],
          ),
        );
        break;
      case RequirementType.vpm:
        scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
          content: const Text('VPM CLI is required.'),
          actions: [
            TextButton(
              onPressed: () async {
                scaffoldKey.currentState?.clearMaterialBanners();
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Installing vrchat.vpm.cli')));
                await model.installVpmCli();
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Installed vrchat.vpm.cli')));
                _refreshProjects();
              },
              child: const Text('Install'),
            ),
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.clearMaterialBanners();
                _refreshProjects();
              },
              child: const Text('Check again'),
            ),
          ],
        ));
        break;
      case RequirementType.vpmVersion:
        scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
          content: Text('VPM CLI $requiredVpmVersion is required.'),
          actions: [
            TextButton(
              onPressed: () async {
                scaffoldKey.currentState?.clearMaterialBanners();
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Updating vrchat.vpm.cli')));
                await model.updateVpmCli();
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Updated vrchat.vpm.cli')));
                _refreshProjects();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.clearMaterialBanners();
                _refreshProjects();
              },
              child: const Text('Check again'),
            ),
          ],
        ));
        break;
      case RequirementType.hub:
        scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
          content: const Text('Unity Hub is required.'),
          actions: [
            TextButton(
              onPressed: () async {
                launchUrl(
                    Uri.parse('https://unity.com/download#how-get-started'));
              },
              child: const Text('Download'),
            ),
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.clearMaterialBanners();
                _refreshProjects();
              },
              child: const Text('Check again'),
            ),
          ],
        ));
        break;
      case RequirementType.unity:
        scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
          content: const Text('Unity is required. Install with Unity Hub.'),
          actions: [
            TextButton(
              onPressed: () async {
                launchUrl(Uri.parse(
                    'https://docs.vrchat.com/docs/current-unity-version'));
              },
              child: const Text('See current version'),
            ),
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.clearMaterialBanners();
                _refreshProjects();
              },
              child: const Text('Check again'),
            ),
          ],
        ));
        break;
    }
  }

  Future<void> _didSelectProject(VccProject project) async {
    if (!await Directory(project.path).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${project.path} does not exist.'),
      ));
      return;
    }
    final type = await _model(context).checkProjectType(project);
    if (!mounted) {
      return;
    }
    switch (type) {
      case VccProjectType.avatarVpm:
      case VccProjectType.worldVpm:
        Navigator.pushNamed(
          context,
          ProjectRoute.routeName,
          arguments: ProjectRouteArguments(project: project),
        );
        break;
      case VccProjectType.legacySdk3Avatar:
      case VccProjectType.legacySdk3World:
        Navigator.pushNamed(
          context,
          LegacyProjectRoute.routeName,
          arguments: LegacyProjectRouteArguments(project: project),
        );
        break;
      case VccProjectType.legacySdk2:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${project.path} is VRCSDK2 project.'),
        ));
        break;
      case VccProjectType.invalid:
      case VccProjectType.unknown:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${project.path} is invalid project.'),
        ));
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _refreshProjects();
  }

  @override
  void didPopNext() {
    _refreshProjects();
  }

  ProjectsModel _model(BuildContext context) {
    return Provider.of<ProjectsModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          Consumer<ProjectsModel>(
              builder: ((context, model, child) => TextButton(
                    style: style,
                    onPressed: model.isReadyToUse
                        ? () {
                            _addProject(_model(context));
                          }
                        : null,
                    child: const Text('Add'),
                  ))),
          Consumer<ProjectsModel>(
              builder: ((context, model, child) => TextButton(
                    style: style,
                    onPressed: model.isReadyToUse
                        ? () {
                            Navigator.pushNamed(
                                context, NewProjectRoute.routeName);
                          }
                        : null,
                    child: const Text('New'),
                  ))),
        ],
      ),
      body: Consumer<ProjectsModel>(
          builder: ((context, model, child) => model.isReadyToUse
              ? Column(children: buildColumn(model))
              : Center(
                  child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        Text('Tiny VCC is not ready to use.'),
                      ]),
                ))),
    );
  }

  List<Widget> buildColumn(ProjectsModel model) {
    final List<Widget> list = [];
    list.add(
      Expanded(
        child: ListView.builder(
          itemCount: model.projects.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(model.projects[index].name),
            onTap: () {
              var project = model.projects[index];
              _didSelectProject(project);
            },
            subtitle: Text(model.projects[index].path),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                model.deleteProject(model.projects[index]);
              },
            ),
          ),
        ),
      ),
    );
    return list;
  }
}
