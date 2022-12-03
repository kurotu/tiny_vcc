import 'package:tiny_vcc/services/vcc_service.dart';

class UnityEditor {
  UnityEditor(this.version, this.path);

  final String version;
  final String path;
}

class UnityEditorsRepository {
  UnityEditorsRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  List<UnityEditor>? _editors;

  Future<List<UnityEditor>> fetchEditors() async {
    if (_editors == null) {
      final editors = await _vcc.getUnityEditors();
      _editors =
          editors.entries.map((e) => UnityEditor(e.key, e.value)).toList();
    }
    return _editors!;
  }

  Future<UnityEditor?> getEditor(String version) async {
    if (_editors == null) {
      await fetchEditors();
    }
    return _editors?.firstWhere((element) => element.version == version);
  }
}
