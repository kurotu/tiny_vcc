import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'services/tiny_vcc_service.dart';
import 'utils/file_output.dart';

Future<Logger> createLogger(bool isRelease) async {
  final dir = await TinyVccService().getLogsDirectory();
  await dir.create(recursive: true);
  final logFileName =
      'tiny-vcc_${DateFormat('yyyy-MM-dd_HH-mm-ss.SSS').format(DateTime.now())}.txt';
  return isRelease
      ? createReleaseLogger(File(p.join(dir.path, logFileName)))
      : createDevelopLogger();
}

Logger createDevelopLogger() {
  return Logger();
}

Logger createReleaseLogger(File file) {
  return Logger(
    filter: ProductionFilter(),
    printer: SimplePrinter(colors: false, printTime: true),
    output: MultiOutput([
      ConsoleOutput(),
      TinyVCCFileOutput(file: file, overrideExisting: true),
    ]),
  );
}

Future<String?> showDirectoryPickerWindow({
  required bool lockParentWindow,
  String? initialDirectory,
}) async {
  final path = await FilePicker.platform.getDirectoryPath(
    lockParentWindow: lockParentWindow,
    initialDirectory: initialDirectory,
  );
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

Future<T?> showAlertDialog<T>(BuildContext context,
    {String? title, String? message}) {
  return showDialog<T>(
    context: context,
    builder: ((context) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: message != null ? Text(message) : null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        )),
  );
}

Future<T?> showSimpleErrorDialog<T>(
    BuildContext context, String message, Object error) {
  return showDialog<T>(
    context: context,
    builder: ((context) => AlertDialog(
          title: const Text('Error'),
          content: Text('$message\n\n$error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        )),
  );
}

ProgressDialog showProgressDialog(BuildContext context, String message) {
  final pd = ProgressDialog(context: context);
  pd.show(
    msg: message,
    msgFontWeight: FontWeight.normal,
    max: 100,
    hideValue: true,
    barrierColor: Colors.black54,
    progressBgColor: Colors.transparent,
    borderRadius: 4,
  );
  return pd;
}
