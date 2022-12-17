import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/repos/vcc_setting_repository.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel(BuildContext context) : _setting = context.read();

  final VccSettingRepository _setting;

  List<String> _unityEditors = [];
  List<String> get unityEditors => _unityEditors;

  String? _preferedEditor;
  String? get preferedEditor => _preferedEditor;

  String _backupFolder = "";
  String get backupFolder => _backupFolder;

  List<String> get userPackages => [];

  bool _disposed = false;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  Future<void> fetchSetting() async {
    final setting = await _setting.fetchSetting();
    _unityEditors = setting.unityEditors;
    _preferedEditor = setting.pathToUnityExe;
    if (_preferedEditor == "") {
      _preferedEditor = null;
    }
    _backupFolder = setting.projectBackupPath;
    if (!_disposed) {
      notifyListeners();
    }
  }

  void setPreferedEditor(String path) {
    if (!_unityEditors.contains(path)) {
      _unityEditors.add(path);
      _setting.addUnityEditor(path);
    }
    _preferedEditor = path;
    _setting.setPreferedEditor(path);
    if (!_disposed) {
      notifyListeners();
    }
  }

  void setBackupFolder(String path) {
    _backupFolder = path;
    _setting.setBackupFolder(path);
    if (!_disposed) {
      notifyListeners();
    }
  }
}
