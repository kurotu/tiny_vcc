import 'package:pub_semver/pub_semver.dart';

import '../caches/simple_cache.dart';
import '../data/vcc_data.dart';
import '../services/vcc_service.dart';

class VccSettingsRepository {
  VccSettingsRepository(VccService vcc) : _vcc = vcc;

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
    _vcc.addUnityEditor(path);
    return _setSettings(pathToUnityExe: path);
  }

  Future<void> setBackupFolder(String path) async {
    return _setSettings(projectBackupPath: path);
  }

  Future<void> addUnityEditor(String path) async {
    await _vcc.addUnityEditor(path);
    await fetchSettings(refresh: true);
  }

  Future<void> setUnityEditors(List<String> paths) async {
    await _vcc.setUnityEditors(paths);
    await fetchSettings(refresh: true);
  }

  Future<String?> getUnityEditor(String version) async {
    final settings = await fetchSettings();
    final editor = settings.unityEditors.firstWhere(
      (editorPath) => editorPath.contains(version),
      orElse: () => '',
    );
    if (editor == '') {
      return null;
    }
    return editor;
  }

  Future<void> setDefaultProjectPath(String path) async {
    await _vcc.setSettings(defaultProjectPath: path);
    await fetchSettings(refresh: true);
  }

  Future<void> addUserPackageFolder(String path) async {
    final settings = await fetchSettings(refresh: false);
    if (settings.userPackageFolders.contains(path)) {
      return;
    }
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
