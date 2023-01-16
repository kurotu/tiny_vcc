import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../utils.dart';
import 'project_route.dart';

final _selectedTemplatePathProvider =
    StateNotifierProvider.autoDispose<SelectedTemplatePath, String?>(
        (ref) => SelectedTemplatePath());
final _isDoingTaskProvider =
    StateNotifierProvider.autoDispose<IsDoingTask, bool>(
        (ref) => IsDoingTask());
final _projectNameControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());
final _projectLocationControllerProvider = Provider.autoDispose((ref) {
  final location =
      ref.read(vccSettingsProvider).requireValue.defaultProjectPath;
  return TextEditingController(text: location);
});
final _formKeyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

class SelectedTemplatePath extends StateNotifier<String?> {
  SelectedTemplatePath() : super(null);

  String? get path => state;
  set path(String? value) {
    state = value;
  }
}

class IsDoingTask extends StateNotifier<bool> {
  IsDoingTask() : super(false);

  bool get isDoingTask => state;
  set isDoingTask(bool value) {
    state = value;
  }
}

class NewProjectRoute extends ConsumerWidget {
  static const routeName = '/new_project';

  const NewProjectRoute({super.key});

  Future<String?> _selectLocation(WidgetRef ref) {
    return showDirectoryPickerWindow(
      lockParentWindow: true,
      initialDirectory:
          ref.read(vccSettingsProvider).valueOrNull?.defaultProjectPath,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(vccSettingsProvider, (previous, next) {
      next.whenData((value) => ref
          .read(_projectLocationControllerProvider)
          .text = value.defaultProjectPath);
    });
    final templates = ref.watch(vpmTemplatesProvider);
    final selectedTemplatePath = ref.watch(_selectedTemplatePathProvider);
    final isDoingTask = ref.watch(_isDoingTaskProvider);
    final formKey = ref.watch(_formKeyProvider);
    final projectNameController = ref.watch(_projectNameControllerProvider);
    final projectLocationController =
        ref.watch(_projectLocationControllerProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.new_project.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: t.new_project.labels.project_template),
                value: selectedTemplatePath,
                items: templates.valueOrNull
                    ?.map((e) => DropdownMenuItem(
                          value: e.path,
                          child: Text(e.name),
                        ))
                    .toList(),
                validator: (value) => value == null
                    ? t.new_project.errors.select_project_template
                    : null,
                onChanged: (value) {
                  ref.read(_selectedTemplatePathProvider.notifier).path = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: t.new_project.labels.project_name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.new_project.errors.enter_project_name;
                  }
                  return null;
                },
                controller: projectNameController,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: t.new_project.labels.location,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final path = await _selectLocation(ref);
                      if (path != null) {
                        await ref
                            .read(vccSettingsRepoProvider)
                            .setDefaultProjectPath(path);
                        ref.refresh(vccSettingsProvider);
                      }
                    },
                    icon: const Icon(Icons.folder),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.new_project.errors.enter_location_path;
                  }
                  return null;
                },
                controller: projectLocationController,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ElevatedButton(
                onPressed: isDoingTask
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        ref.read(_isDoingTaskProvider.notifier).isDoingTask =
                            true;
                        final selected = templates.requireValue
                            .firstWhere((t) => t.path == selectedTemplatePath);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(t.new_project.info.creating_project(
                            template: selected.name,
                            name: projectNameController.text,
                            location: projectLocationController.text,
                          )),
                        ));
                        final newProject = await ref
                            .read(vccProjectsRepoProvider)
                            .createVccProject(
                              selected,
                              projectNameController.text,
                              projectLocationController.text,
                            );
                        ref.refresh(vccSettingsProvider);
                        Navigator.pushReplacementNamed(
                          context,
                          ProjectRoute.routeName,
                          arguments: ProjectRouteArguments(project: newProject),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(t.new_project.info.created_project(
                            template: selected.name,
                            name: newProject.name,
                            projectLocation: newProject.path,
                          )),
                        ));
                      },
                child: Text(t.new_project.labels.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
