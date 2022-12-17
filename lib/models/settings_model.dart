import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';
import 'package:path/path.dart' as p;

class SettingsModel extends ChangeNotifier {
  SettingsModel(BuildContext context) : _setting = context.read();

  final VccSettingRepository _setting;

  List<String> _unityEditors = [];
  List<String> get unityEditors => _unityEditors;

  String? _preferedEditor;
  String? get preferedEditor => _preferedEditor;

  String _backupFolder = "";
  String get backupFolder => _backupFolder;

  List<String> _userPackages = [];
  List<String> get userPackages => _userPackages;

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

  Future<void> fetchSetting() async {
    final setting = await _setting.fetchSetting();
    _unityEditors = setting.unityEditors;
    _preferedEditor = setting.pathToUnityExe;
    if (_preferedEditor == "") {
      _preferedEditor = null;
    }
    _backupFolder = setting.projectBackupPath;
    _userPackages = setting.userPackageFolders;
    notifyListeners();
  }

  void setPreferedEditor(String path) {
    if (!_unityEditors.contains(path)) {
      _unityEditors.add(path);
      _setting.addUnityEditor(path);
    }
    _preferedEditor = path;
    _setting.setPreferedEditor(path);
    notifyListeners();
  }

  void setBackupFolder(String path) {
    _backupFolder = path;
    _setting.setBackupFolder(path);
    notifyListeners();
  }

  void addUserPackage(String packagePath) {
    if (!File(p.join(packagePath, 'package.json')).existsSync()) {
      throw Exception(
          '$packagePath is not a package. package.json is missing.');
    }
    if (_userPackages.contains(packagePath)) {
      return;
    }
    _userPackages.add(packagePath);
    _setting.addUserPackageFolder(packagePath);
    notifyListeners();
  }

  void deleteUserPackage(String packagePath) {
    _userPackages.remove(packagePath);
    _setting.deleteUserPackageFolder(packagePath);
    notifyListeners();
  }
}
