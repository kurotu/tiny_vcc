import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/exceptions.dart';
import '../data/tiny_vcc_data.dart';
import '../globals.dart';
import '../providers.dart';
import '../routes/legacy_project_route.dart';
import '../routes/project_route.dart';
import '../routes/requirements_route.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import '../utils/platform_feature.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  static void addProject(BuildContext context, WidgetRef ref) async {
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
        case VccProjectType.starterVpm:
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
      _refreshProjects(ref);
    } on VccProjectTypeException catch (error) {
      await showSimpleErrorDialog(
          context, 'Project "$path" is not supported.', error);
    } on Exception catch (error) {
      await showSimpleErrorDialog(
          context, 'Error occurred when adding a project.', error);
    }
  }

  static void _refreshProjects(WidgetRef ref) {
    ref.refresh(vccSettingsProvider);
  }

  Future<void> _didSelectProject(
      BuildContext context, WidgetRef ref, VccProject project) async {
    if (!await Directory(project.path).exists()) {
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('${project.path} does not exist.'),
      ));
      return;
    }
    final type =
        await ref.read(vccProjectsRepoProvider).checkProjectType(project);
    switch (type) {
      case VccProjectType.avatarVpm:
      case VccProjectType.worldVpm:
      case VccProjectType.starterVpm:
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(readyToUseProvider, (previous, next) {
      if (next.valueOrNull == RequirementState.ng) {
        logger?.i('There are missing requirements');
        Navigator.of(context).pushReplacementNamed(RequirementsRoute.routeName);
      }
    });
    final settings = ref.watch(vccSettingsProvider);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 64),
      itemCount: settings.valueOrNull?.userProjects.length ?? 0,
      itemBuilder: (context, index) {
        final project = VccProject(settings.requireValue.userProjects[index]);
        return ListTile(
          title: Text(project.name),
          onTap: () {
            _didSelectProject(context, ref, project);
          },
          subtitle: Text(project.path),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  await ref
                      .read(vccProjectsRepoProvider)
                      .deleteVccProject(project);
                  _refreshProjects(ref);
                },
                child: const Text('Remove from list'),
              ),
              PopupMenuItem(
                onTap: () async {
                  await Future.delayed(const Duration());
                  final result = await showDialog<bool>(
                    context: context,
                    builder: ((context) => AlertDialog(
                          title: Text('Remove ${project.name}'),
                          content: Text(
                              'Are you sure you want to move ${project.path} to the ${Platform.isWindows ? 'Recycle Bin' : 'Trash'}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        )),
                  );
                  if (result == true) {
                    try {
                      await PlatformFeature.moveToTrash(
                          Directory(project.path));
                      await ref
                          .read(vccProjectsRepoProvider)
                          .deleteVccProject(project);
                      _refreshProjects(ref);
                    } on Exception catch (error) {
                      await showSimpleErrorDialog(
                          context, 'Failed to remove ${project.path}.', error);
                    }
                  }
                },
                child: Platform.isWindows
                    ? const Text('Move to Recycle Bin')
                    : const Text('Move to Trash'),
              ),
            ],
          ),
        );
      },
    );
  }
}
