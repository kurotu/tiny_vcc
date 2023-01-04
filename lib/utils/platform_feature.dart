import 'dart:io';

import 'package:flutter/services.dart';

class PlatformFeature {
  static const _platform = MethodChannel('com.github.kurotu.tiny_vcc/platform');

  static Future<FileSystemEntity> moveToTrash(FileSystemEntity entity) async {
    if (await entity.exists() == false) {
      final String type;
      if (entity is File) {
        type = 'File';
      } else if (entity is Directory) {
        type = 'Directory';
      } else if (entity is Link) {
        type = 'Link';
      } else {
        type = 'Entity';
      }
      throw FileSystemException('$type not found', entity.path);
    }
    await _platform.invokeMethod('moveToTrash', entity.path);
    return entity;
  }
}
