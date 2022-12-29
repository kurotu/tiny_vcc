import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../data/vcc_data.dart';
import '../globals.dart';
import '../repos/vcc_settings_repository.dart';
import '../services/vcc_service.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel(BuildContext context) : _settingsRepo = context.read();

  final VccSettingsRepository _settingsRepo;

  VccSettings? _settings;

  List<String> get unityEditors => _settings?.unityEditors ?? [];

  bool _isDetectingEditors = false;
  bool get isDetectingEditors => _isDetectingEditors;

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
    if (preferredEditor != null && !unityEditors.contains(preferredEditor)) {
      logger
          ?.w('pathToUnityExe ($preferredEditor) is missing in unityEditors.');
      _settings = _settings?.copyWith(pathToUnityExe: '');
    }
    notifyListeners();
  }

  Future<void> refreshEditors() async {
    _isDetectingEditors = true;
    notifyListeners();

    final editors = await VccService.withoutContext().listUnity();
    final newEditors = {
      ...(_settings?.unityEditors ?? []),
      ...editors.values,
    }.toList();
    newEditors.removeWhere((element) => !File(element).existsSync());
    newEditors.sort();

    await _settingsRepo.setUnityEditors(newEditors);
    await _fetchSettings();
    _isDetectingEditors = false;
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
