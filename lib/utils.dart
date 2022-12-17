import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<String?> showDirectoryPickerWindow(
    {required bool lockParentWindow}) async {
  final path = await FilePicker.platform
      .getDirectoryPath(lockParentWindow: lockParentWindow);
  return _cleanupPath(path);
}

Future<String?> showFilePickerWindow({required bool lockParentWindow}) async {
  final result = await FilePicker.platform
      .pickFiles(allowMultiple: false, lockParentWindow: lockParentWindow);
  if (result == null) {
    return null;
  }
  return _cleanupPath(result.paths[0]);
}

String? _cleanupPath(String? path) {
  if (Platform.isMacOS) {
    path = path?.replaceFirst(RegExp('^/Volumes/Macintosh HD/'), '/');
  }
  return path;
}
