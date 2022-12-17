import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel(BuildContext context) : _setting = context.read();

  final VccSettingRepository _setting;

  List<String> _unityEditors = [];
  List<String> get unityEditors => _unityEditors;

  String _preferedEditor = "";
  String get preferedEditor => _preferedEditor;

  String _backupFolder = "";
  String get backupFolder => _backupFolder;

  List<String> get userPackages => [];

  Future<void> fetchSetting() async {
    final setting = await _setting.fetchSetting();
    _unityEditors = setting.unityEditors;
    _preferedEditor = setting.pathToUnityExe;
    _backupFolder = setting.projectBackupPath;
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
}
