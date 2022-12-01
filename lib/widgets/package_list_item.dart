import 'package:flutter/material.dart';
import 'package:tiny_vcc/models/project_model.dart';

class PackageListItem extends StatefulWidget {
  const PackageListItem({
    super.key,
    required this.item,
    required this.onClickAdd,
    required this.onClickUpdate,
    required this.onClickRemove,
  });

  final PackageItem item;
  final void Function(String name, String version) onClickAdd;
  final void Function(String name, String version) onClickUpdate;
  final void Function(String name) onClickRemove;

  @override
  State<PackageListItem> createState() => _PackageListItem();
}

class _PackageListItem extends State<PackageListItem> {
  late String? _selectedVersion;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedVersion = widget.item.installedVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.installedVersion != null
                ? "${widget.item.displayName} (${widget.item.installedVersion})"
                : widget.item.displayName,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            widget.item.description,
            style: const TextStyle(color: Colors.black54),
          ),
          _ActionRow(
            selectedVersion: _selectedVersion,
            installedVersion: widget.item.installedVersion,
            availableVersions: widget.item.versions,
            onSelectVersion: (version) {
              setState(() {
                _selectedVersion = version;
              });
            },
            onClickRemove: () {
              widget.onClickRemove(widget.item.name);
            },
            onClickAdd: () {
              widget.onClickAdd(widget.item.name, _selectedVersion!);
            },
            onClickUpdate: () {
              widget.onClickUpdate(widget.item.name, _selectedVersion!);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.selectedVersion,
    this.installedVersion,
    required this.availableVersions,
    this.onSelectVersion,
    this.onClickAdd,
    this.onClickUpdate,
    this.onClickRemove,
  });

  final String? selectedVersion;
  final String? installedVersion;
  final List<String> availableVersions;
  final void Function(String version)? onSelectVersion;
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
      children.add(OutlinedButton(
          onPressed: onClickRemove, child: const Text('Remove')));
    }

    children.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
    ));
    children.add(DropdownButton(
      value: selectedVersion,
      items: availableVersions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
      onChanged: (v) {
        onSelectVersion!(v as String);
      },
    ));

    if (installedVersion != selectedVersion) {
      children.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
      ));
      children.add(ElevatedButton(
          onPressed: onClickUpdate, child: const Text('Update')));
    }
    return children;
  }
}
