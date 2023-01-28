import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_vcc/widgets/new_project_form.dart';

import '../providers.dart';
import '../services/vcc_service.dart';

final _formKeyProvider =
    Provider.autoDispose((ref) => GlobalKey<NewProjectFormState>());

class NewProjectDialog extends ConsumerWidget {
  const NewProjectDialog({
    super.key,
    required this.templates,
    required this.onPressedCreate,
    required this.defaultLocation,
    required this.onClickLocationButton,
  });

  final List<VpmTemplate> templates;
  final String defaultLocation;
  final void Function(NewProjectFormData data) onPressedCreate;
  final FutureOr<String?> Function() onClickLocationButton;

  void _didClickCreate(GlobalKey<NewProjectFormState> key) {
    if (!key.currentState!.validate()) {
      return;
    }
    onPressedCreate(NewProjectFormData(
      template: key.currentState!.template,
      name: key.currentState!.name,
      location: key.currentState!.location,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider);
    final formKey = ref.watch(_formKeyProvider);

    return AlertDialog(
      title: Text(t.new_project.title),
      scrollable: true,
      content: NewProjectForm(
        key: formKey,
        formKey: formKey,
        templates: templates,
        defaultLocation: defaultLocation,
        onClickLocationButton: onClickLocationButton,
      ),
      actions: [
        TextButton(
          onPressed: () {
            _didClickCreate(formKey);
          },
          child: Text(t.new_project.labels.create),
        ),
      ],
    );
  }
}
