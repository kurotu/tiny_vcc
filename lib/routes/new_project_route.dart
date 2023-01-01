import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../globals.dart';
import '../providers.dart';
import '../utils.dart';
import 'project_route.dart';

final _selectedTemplatePathProvider =
    StateNotifierProvider.autoDispose<SelectedTemplatePath, String?>(
        (ref) => SelectedTemplatePath());
final _isDoingTaskProvider =
    StateNotifierProvider.autoDispose<IsDoingTask, bool>(
        (ref) => IsDoingTask());

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

class NewProjectRoute extends ConsumerStatefulWidget {
  static const routeName = '/new_project';

  const NewProjectRoute({super.key});

  @override
  ConsumerState<NewProjectRoute> createState() => _NewProjectRoute();
}

class _NewProjectRoute extends ConsumerState<NewProjectRoute> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _projectLocationController = TextEditingController();

  Future<String?> _selectLocation() {
    return showDirectoryPickerWindow(
      lockParentWindow: true,
      initialDirectory:
          ref.read(vccSettingsProvider).valueOrNull?.defaultProjectPath,
    );
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
    final settings = ref.read(vccSettingsProvider);
    if (settings.hasValue) {
      _projectLocationController.text =
          settings.requireValue.defaultProjectPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(vccSettingsProvider, (previous, next) {
      next.whenData((value) =>
          _projectLocationController.text = value.defaultProjectPath);
    });
    final templates = ref.watch(vpmTemplatesProvider);
    final selectedTemplatePath = ref.watch(_selectedTemplatePathProvider);
    final isDoingTask = ref.watch(_isDoingTaskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Project'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                decoration:
                    const InputDecoration(labelText: 'Project Template'),
                value: selectedTemplatePath,
                items: templates.valueOrNull
                    ?.map((e) => DropdownMenuItem(
                          value: e.path,
                          child: Text(e.name),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Please select project template.' : null,
                onChanged: (value) {
                  ref.read(_selectedTemplatePathProvider.notifier).path = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name.';
                  }
                  return null;
                },
                controller: _projectNameController,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final path = await _selectLocation();
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
                    return 'Please enter location path.';
                  }
                  return null;
                },
                controller: _projectLocationController,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ElevatedButton(
                onPressed: isDoingTask
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        ref.read(_isDoingTaskProvider.notifier).isDoingTask =
                            true;
                        final selected = templates.requireValue
                            .firstWhere((t) => t.path == selectedTemplatePath);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Creating ${selected.name} project, "${_projectNameController.text}" at ${_projectLocationController.text}'),
                        ));
                        final newProject = await ref
                            .read(vccProjectsRepoProvider)
                            .createVccProject(
                                selected,
                                _projectNameController.text,
                                _projectLocationController.text);
                        if (!mounted) {
                          return;
                        }
                        Navigator.pushReplacementNamed(
                          context,
                          ProjectRoute.routeName,
                          arguments: ProjectRouteArguments(project: newProject),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '${selected.name} project, "${newProject.name}" has been created at ${newProject.path}')));
                      },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
