import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/data/vcc_data.dart';
import 'package:tiny_vcc/repos/vcc_settings_repository.dart';
import 'package:path/path.dart' as p;

class SettingsModel extends ChangeNotifier {
  SettingsModel(BuildContext context) : _settingsRepo = context.read();

  final VccSettingsRepository _settingsRepo;

  VccSettings? _settings;

  List<String> get unityEditors => _settings?.unityEditors ?? [];

  String? get preferredEditor {
    if (_settings?.pathToUnityExe == '') {
      return null;
    }
    return _settings?.pathToUnityExe;
  }

  String get backupFolder => _settings?.projectBackupPath ?? '';

  List<String> get userPackages => _settings?.userPackageFolders ?? [];

  bool _disposed = false;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> initialize() async {
    _fetchSettings(refresh: true);
  }

  Future<void> _fetchSettings({bool refresh = false}) async {
    _settings = await _settingsRepo.fetchSettings(refresh: refresh);
    notifyListeners();
  }

  Future<void> setPreferredEditor(String path) async {
    if (!unityEditors.contains(path)) {
      await _settingsRepo.addUnityEditor(path);
    }
    await _settingsRepo.setPreferredEditor(path);
    await _fetchSettings();
  }

  Future<void> setBackupFolder(String path) async {
    await _settingsRepo.setBackupFolder(path);
    await _fetchSettings();
  }

  Future<void> addUserPackage(String packagePath) async {
    if (!await File(p.join(packagePath, 'package.json')).exists()) {
      throw Exception(
          '$packagePath is not a package. package.json is missing.');
    }
    if (userPackages.contains(packagePath)) {
      return;
    }
    await _settingsRepo.addUserPackageFolder(packagePath);
    await _fetchSettings();
  }

  Future<void> deleteUserPackage(String packagePath) async {
    await _settingsRepo.deleteUserPackageFolder(packagePath);
    await _fetchSettings();
  }
}
