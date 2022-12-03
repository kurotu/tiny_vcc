import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/models/project_model.dart';

class PackageListItem extends StatelessWidget {
  const PackageListItem({
    super.key,
    required this.item,
    required this.onSelect,
    required this.onClickAdd,
    required this.onClickUpdate,
    required this.onClickRemove,
  });

  final PackageItem item;
  final void Function(String name, Version version) onSelect;
  final void Function(String name) onClickAdd;
  final void Function(String name) onClickUpdate;
  final void Function(String name) onClickRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.installedVersion != null
                ? "${item.displayName} (${item.installedVersion})"
                : item.displayName,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            item.description,
            style: const TextStyle(color: Colors.black54),
          ),
          _ActionRow(
            canRemove: item.name != 'com.vrchat.base' &&
                item.name != 'com.vrchat.core.vpm-resolver',
            selectedVersion: item.selectedVersion,
            installedVersion: item.installedVersion,
            availableVersions: item.versions.map((e) => e.version).toList(),
            onSelectVersion: (version) {
              onSelect(item.name, version);
            },
            onClickRemove: () {
              onClickRemove(item.name);
            },
            onClickAdd: () {
              onClickAdd(item.name);
            },
            onClickUpdate: () {
              onClickUpdate(item.name);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.canRemove,
    required this.selectedVersion,
    this.installedVersion,
    required this.availableVersions,
    this.onSelectVersion,
    this.onClickAdd,
    this.onClickUpdate,
    this.onClickRemove,
  });

  final bool canRemove;
  final Version? selectedVersion;
  final Version? installedVersion;
  final List<Version> availableVersions;
  final void Function(Version version)? onSelectVersion;
  final void Function()? onClickAdd;
  final void Function()? onClickUpdate;
  final void Function()? onClickRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getChildren(),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [];
    if (installedVersion == null) {
      children
          .add(OutlinedButton(onPressed: onClickAdd, child: const Text('Add')));
    } else {
      if (canRemove) {
        children.add(OutlinedButton(
            onPressed: onClickRemove, child: const Text('Remove')));
      }
    }

    children.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
    ));
    children.add(DropdownButton(
      value: selectedVersion,
      items: availableVersions
          .map((v) => DropdownMenuItem(value: v, child: Text(v.toString())))
          .toList(),
      onChanged: (v) {
        onSelectVersion!(v!);
      },
    ));

    if (installedVersion != null && selectedVersion != null) {
      if (installedVersion != selectedVersion) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
        ));
        final compare = selectedVersion!.compareTo(installedVersion!);
        if (compare > 0) {
          children.add(ElevatedButton(
              onPressed: onClickUpdate, child: const Text('Update')));
        } else {
          children.add(ElevatedButton(
              onPressed: onClickUpdate, child: const Text('Downgrade')));
        }
      }
    }
    return children;
  }
}
