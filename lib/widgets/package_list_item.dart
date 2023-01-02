import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';

import '../services/vcc_service.dart';

class PackageItem {
  PackageItem({
    required this.name,
    required this.displayName,
    required this.description,
    this.installedVersion,
    this.selectedVersion,
    required this.versions,
    required this.repoType,
  });

  final String name;
  final String displayName;
  final String description;
  final Version? installedVersion;
  final Version? selectedVersion;
  final List<VpmPackage> versions;
  final RepositoryType repoType;
}

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
          _buildTitle(context),
          Text(
            item.description,
            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),
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

  Widget _buildTitle(BuildContext context) {
    final children = <Widget>[
      Text(
        item.installedVersion != null
            ? "${item.displayName} (${item.installedVersion})"
            : item.displayName,
        style: const TextStyle(fontSize: 16),
      ),
      (() {
        switch (item.repoType) {
          case RepositoryType.official:
            return const Chip(label: Text('official'));
          case RepositoryType.curated:
            return const Chip(label: Text('curated'));
          case RepositoryType.user:
            return const Chip(label: Text('user'));
          case RepositoryType.local:
            return const Chip(label: Text('local'));
        }
      })(),
    ];
    if (item.installedVersion != null) {
      children.add(const Chip(label: Text('installed')));
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: children,
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
      children.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
      ));
    } else if (canRemove) {
      children.add(OutlinedButton(
          onPressed: onClickRemove, child: const Text('Remove')));
      children.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
      ));
    }

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
