import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<String?> showDirectoryPickerWindow(
    {required bool lockParentWindow}) async {
  var path = await FilePicker.platform
      .getDirectoryPath(lockParentWindow: lockParentWindow);
  if (Platform.isMacOS) {
    path = path?.replaceFirst(RegExp('^/Volumes/Macintosh HD/'), '/');
  }
  return path;
}
