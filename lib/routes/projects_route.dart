import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/exceptions.dart';
import '../data/vcc_data.dart';
import '../globals.dart';
import '../main_drawer.dart';
import '../providers.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import 'legacy_project_route.dart';
import 'new_project_route.dart';
import 'project_route.dart';
import 'requirements_route.dart';

final _readyToUseProvider = FutureProvider((ref) async {
  // Quick check for startup.
  final settings = ref.watch(vccSettingsProvider);
  if (!settings.hasValue) {
    return true;
  }

  final vcc = ref.read(vccServiceProvider);
  if (!vcc.isInstalled()) {
    return false;
  }

  if (await vcc.getCliVersion() < requiredVpmVersion) {
    return false;
  }

  if (!await (File(settings.requireValue.pathToUnityHub).exists())) {
    return false;
  }
  if (!await (File(settings.requireValue.pathToUnityExe).exists())) {
    return false;
  }
  return true;
});

class ProjectsRoute extends ConsumerStatefulWidget {
  const ProjectsRoute({super.key});

  static const String routeName = '/projects';

  @override
  ConsumerState<ProjectsRoute> createState() => _ProjectsRoute();
}

class _ProjectsRoute extends ConsumerState<ProjectsRoute> with RouteAware {
  void _addProject() async {
    final path = await showDirectoryPickerWindow(lockParentWindow: true);
    if (path == null) {
      return;
    }
    try {
      final repo = ref.read(vccProjectsRepoProvider);
      final type = await repo.checkProjectType(VccProject(path));
      switch (type) {
        case VccProjectType.avatarVpm:
        case VccProjectType.worldVpm:
        case VccProjectType.legacySdk3Avatar:
        case VccProjectType.legacySdk3World:
          break;
        case VccProjectType.avatarGit:
          throw VccProjectTypeException(
              'Avatar Git project type is not supported in Tiny VCC. Migrate with the official VCC.',
              type);
        case VccProjectType.worldGit:
          throw VccProjectTypeException(
              'World Git project type is not supported in Tiny VCC. Migrate with the official VCC.',
              type);
        case VccProjectType.legacySdk2:
          throw VccProjectTypeException(
              'VRCSDK2 project is not supported.', type);
        case VccProjectType.invalid:
          throw VccProjectTypeException('Invalid Unity project.', type);
        case VccProjectType.unknown:
          throw VccProjectTypeException('Unknown Unity project type.', type);
      }
      await repo.addVccProject(VccProject(path));
      _refreshProjects();
    } on VccProjectTypeException catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(
            context, 'Project "$path" is not supported.', error);
      }
    } on Exception catch (error) {
      if (mounted) {
        await showSimpleErrorDialog(
            context, 'Error occurred when adding a project.', error);
      }
    }
  }

  void _refreshProjects() {
    ref.refresh(vccSettingsProvider);
  }

  Future<void> _didSelectProject(VccProject project) async {
    if (!await Directory(project.path).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${project.path} does not exist.'),
      ));
      return;
    }
    final type =
        await ref.read(vccProjectsRepoProvider).checkProjectType(project);
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
      case VccProjectType.avatarGit:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Avatar Git project (${project.path}) is not supported in Tiny VCC.'),
        ));
        break;
      case VccProjectType.worldGit:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'World Git project (${project.path}) is not supported in Tiny VCC.'),
        ));
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
  void didPush() {}

  @override
  void didPopNext() {
    _refreshProjects();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_readyToUseProvider, (previous, next) {
      if (next.valueOrNull == false) {
        Navigator.of(context).pushReplacementNamed(RequirementsRoute.routeName);
      }
    });
    final settings = ref.watch(vccSettingsProvider);

    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          TextButton(
            style: style,
            onPressed: () {
              _addProject();
            },
            child: const Text('Add'),
          ),
          TextButton(
            style: style,
            onPressed: () {
              Navigator.pushNamed(context, NewProjectRoute.routeName);
            },
            child: const Text('New'),
          ),
        ],
      ),
      body: Column(children: buildColumn(settings)),
    );
  }

  List<Widget> buildColumn(AsyncValue<VccSettings> settings) {
    final List<Widget> list = [];
    list.add(
      Expanded(
        child: ListView.builder(
          itemCount: settings.valueOrNull?.userProjects.length ?? 0,
          itemBuilder: (context, index) {
            final project =
                VccProject(settings.requireValue.userProjects[index]);
            return ListTile(
              title: Text(project.name),
              onTap: () {
                _didSelectProject(project);
              },
              subtitle: Text(project.path),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await ref
                      .read(vccProjectsRepoProvider)
                      .deleteVccProject(project);
                  _refreshProjects();
                },
              ),
            );
          },
        ),
      ),
    );
    return list;
  }
}
