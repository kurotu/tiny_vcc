import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/caches/simple_cache.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

import '../data/vcc_data.dart';

class VccSettingsRepository {
  VccSettingsRepository(BuildContext context)
      : _vcc = Provider.of(context, listen: false);

  final VccService _vcc;

  final _settingsCache = SimpleCache<VccSettings>();

  Future<Version> fetchCliVersion() async {
    return _vcc.getCliVersion();
  }

  Future<VccSettings> fetchSettings({bool refresh = false}) async {
    if (_settingsCache.hasCache && !refresh) {
      return _settingsCache.get();
    }
    final setting = await _vcc.getSettings();
    _settingsCache.set(setting);
    return setting;
  }

  Future<void> setPreferredEditor(String path) async {
    return _setSettings(pathToUnityExe: path);
  }

  Future<void> setBackupFolder(String path) async {
    return _setSettings(projectBackupPath: path);
  }

  Future<void> addUnityEditor(String path) async {
    await _vcc.addUnityEditor(path);
    await fetchSettings(refresh: true);
  }

  Future<void> addUserPackageFolder(String path) async {
    await _vcc.addUserPackageFolder(path);
    await fetchSettings(refresh: true);
  }

  Future<void> deleteUserPackageFolder(String path) async {
    await _vcc.deleteUserPackageFolder(path);
    await fetchSettings(refresh: true);
  }

  Future<void> _setSettings({
    String? pathToUnityExe,
    String? projectBackupPath,
  }) async {
    await _vcc.setSettings(
      pathToUnityExe: pathToUnityExe,
      projectBackupPath: projectBackupPath,
    );
    await fetchSettings(refresh: true);
  }
}