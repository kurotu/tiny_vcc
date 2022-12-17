import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/main_drawer.dart';
import 'package:tiny_vcc/models/settings_model.dart';
import 'package:tiny_vcc/utils.dart';

import '../main.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({super.key});

  static const String routeName = '/settings';

  @override
  State<SettingsRoute> createState() => _SettingsRoute();
}

class _SettingsRoute extends State<SettingsRoute> with RouteAware {
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPush() {
    context.read<SettingsModel>().fetchSetting();
  }

  void _didClickAddUserPackage() async {
    final packagePath = await showDirectoryPickerWindow(lockParentWindow: true);
    if (packagePath == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    try {
      context.read<SettingsModel>().addUserPackage(packagePath);
    } catch (error) {
      showAlertDialog(context, title: 'Error', message: '$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController =
        TextEditingController(text: context.read<SettingsModel>().backupFolder);
    Provider.of<SettingsModel>(context).addListener(() {
      locationController.text = context.read<SettingsModel>().backupFolder;
    });
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<SettingsModel>(
                builder: ((context, model, child) => DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: 'Unity Editors',
                          suffixIcon: IconButton(
                              onPressed: () async {
                                final path = await showFilePickerWindow(
                                    lockParentWindow: true);
                                if (path == null) {
                                  return;
                                }
                                if (mounted) {
                                  context
                                      .read<SettingsModel>()
                                      .setPreferedEditor(path);
                                }
                              },
                              icon: const Icon(Icons.folder))),
                      value: model.preferedEditor,
                      items: model.unityEditors
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          model.setPreferedEditor(value);
                        }
                      },
                    )),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Consumer<SettingsModel>(
                builder: ((context, model, child) => TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Backups',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final path = await showDirectoryPickerWindow(
                                lockParentWindow: true);
                            if (path == null) {
                              return;
                            }
                            if (mounted) {
                              context
                                  .read<SettingsModel>()
                                  .setBackupFolder(path);
                            }
                          },
                          icon: const Icon(Icons.folder),
                        ),
                      ),
                      controller: locationController,
                    )),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Row(
                children: [
                  const Text('User Packages'),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                  OutlinedButton(
                      onPressed: () {
                        _didClickAddUserPackage();
                      },
                      child: const Text('Add')),
                ],
              ),
              Expanded(
                child: Consumer<SettingsModel>(
                  builder: (context, model, child) => ListView.builder(
                    itemBuilder: ((context, index) => ListTile(
                          title: Text(model.userPackages[index]),
                          trailing: IconButton(
                            onPressed: () {
                              model
                                  .deleteUserPackage(model.userPackages[index]);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        )),
                    itemCount: model.userPackages.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
