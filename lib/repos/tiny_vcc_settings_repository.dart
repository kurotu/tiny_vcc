import '../data/tiny_vcc_data.dart';
import '../services/tiny_vcc_service.dart';

class TinyVccSettingsRepository {
  TinyVccSettingsRepository(TinyVccService tinyVcc) : _tinyVcc = tinyVcc;
  final TinyVccService _tinyVcc;

  Future<TinyVccSettings> fetchSettings() async {
    return _tinyVcc.loadSettings();
  }

  Future<void> setThemeMode(TinyVccThemeMode mode) async {
    await _tinyVcc.writeSettings(themeMode: mode);
  }
}
