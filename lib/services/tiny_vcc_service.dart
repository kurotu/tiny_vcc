import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TinyVccService {
  Future<Directory> getSettingsDirectory() {
    return getApplicationSupportDirectory();
  }

  Future<Directory> getLogsDirectory() async {
    final settings = await getSettingsDirectory();
    return Directory(p.join(settings.path, 'logs'));
  }
}
