import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key, required this.selectedIndex, required this.onItemSelected});

  final int selectedIndex;
  final Function(int selectedIndex) onItemSelected;

  void _didSelectItem(BuildContext context, int index) {
    Navigator.pop(context);
    onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _DrawerListTile(
            index: 0,
            selectedIndex: selectedIndex,
            selectedLeading: const Icon(Icons.folder_special),
            leading: const Icon(Icons.folder_special_outlined),
            title: const Text('Projects'),
            onSelect: (value) {
              _didSelectItem(context, value);
            },
          ),
          _DrawerListTile(
            index: 1,
            selectedIndex: selectedIndex,
            selectedLeading: const Icon(Icons.settings),
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onSelect: (value) {
              _didSelectItem(context, value);
            },
          ),
          const Divider(),
          _AboutListTile(),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile(
      {required this.index,
      required this.selectedIndex,
      required this.selectedLeading,
      required this.leading,
      required this.title,
      required this.onSelect});

  final int index;
  final int selectedIndex;
  final Widget selectedLeading;
  final Widget leading;
  final Widget title;

  final Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    bool selected = selectedIndex == index;
    return ListTile(
      title: title,
      leading: selected ? selectedLeading : leading,
      selected: selected,
      onTap: () {
        onSelect(index);
      },
    );
  }
}

class _AboutListTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(packageInfoProvider);
    final notice = ref.watch(licenseNoticeProvider);
    return AboutListTile(
      icon: const Icon(Icons.info_outline),
      applicationVersion: info.value?.version,
      applicationIcon: Image.asset(
        'assets/images/app_icon-1024x1024.png',
        width: 64,
        height: 64,
      ),
      applicationLegalese: notice.value,
    );
  }
}
