import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../services/vcc_service.dart';

@immutable
class NewProjectFormData {
  const NewProjectFormData(
      {required this.template, required this.name, required this.location});

  final VpmTemplate? template;
  final String name;
  final String location;

  NewProjectFormData copyWith(
      {VpmTemplate? template, String? name, String? location}) {
    return NewProjectFormData(
      template: template ?? this.template,
      name: name ?? this.name,
      location: location ?? this.location,
    );
  }
}

class NewProjectForm extends ConsumerStatefulWidget {
  const NewProjectForm({
    super.key,
    required this.formKey,
    required this.templates,
    required this.defaultLocation,
    required this.onClickLocationButton,
  });

  final Key formKey;
  final List<VpmTemplate> templates;
  final String defaultLocation;
  final FutureOr<String?> Function() onClickLocationButton;

  @override
  NewProjectFormState createState() {
    return NewProjectFormState();
  }
}

class NewProjectFormState extends ConsumerState<NewProjectForm> {
  VpmTemplate? template;
  String name = '';
  String location = '';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  bool validate() {
    if (_formKey.currentState == null) {
      return false;
    }
    return _formKey.currentState!.validate();
  }

  Future<void> _didClickLocationButton(
      TextEditingController locationController) async {
    final l = await widget.onClickLocationButton();
    if (l != null) {
      setState(() {
        location = l;
        locationController.text = l;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    location = widget.defaultLocation;
    _locationController.text = widget.defaultLocation;
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationProvider);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            key: const ValueKey('template_dropdown'),
            decoration: InputDecoration(
                labelText: t.new_project.labels.project_template),
            value: template,
            items: widget.templates
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ))
                .toList(),
            validator: (value) => value == null
                ? t.new_project.errors.select_project_template
                : null,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  template = value;
                });
              }
            },
          ),
          TextFormField(
            decoration:
                InputDecoration(labelText: t.new_project.labels.project_name),
            controller: _nameController,
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.new_project.errors.enter_project_name;
              }
              return null;
            },
          ),
          TextFormField(
            readOnly: true,
            controller: _locationController,
            decoration: InputDecoration(
              labelText: t.new_project.labels.location,
              suffixIcon: IconButton(
                onPressed: () {
                  _didClickLocationButton(_locationController);
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
          ),
        ],
      ),
    );
  }
}
