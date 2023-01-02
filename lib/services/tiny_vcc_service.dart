import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/tiny_vcc_data.dart';

class TinyVccService {
  Future<Directory> getSettingsDirectory() {
    return getApplicationSupportDirectory();
  }

  Future<Directory> getLogsDirectory() async {
    final settings = await getSettingsDirectory();
    return Directory(p.join(settings.path, 'logs'));
  }

  Future<TinyVccSettings> loadSettings() async {
    final file = await _getSettingsFile();
    if (!await file.exists()) {
      await file.writeAsString('{}');
      final defaultValue = TinyVccSettings.defaultValues();
      await writeSettings(themeMode: defaultValue.themeMode);
    }
    final str = await file.readAsString();
    final json = jsonDecode(str);
    return TinyVccSettings(
      themeMode: TinyVccThemeMode.values.byName(json['themeMode'] ?? 'system'),
    );
  }

  Future<void> writeSettings({
    TinyVccThemeMode? themeMode,
  }) async {
    final file = await _getSettingsFile();
    final str = await file.readAsString();
    final json = jsonDecode(str);

    if (themeMode != null) {
      json['themeMode'] = themeMode.name;
    }

    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(json);
    await file.writeAsString((jsonStr), flush: true);
  }

  Future<File> _getSettingsFile() async {
    final dir = await getSettingsDirectory();
    return File(p.join(dir.path, 'settings.json'));
  }
}
