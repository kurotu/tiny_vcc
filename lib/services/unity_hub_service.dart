import 'dart:io';

class UnityHubService {
  late String _unityHubExe;

  void setUnityHubExe(String unityHubExe) {
    _unityHubExe = unityHubExe;
  }

  Future<Map<String, String>> listInstalledEditors() async {
    final result =
        await Process.run(_unityHubExe, ['--', '--headless', 'editors', '-i']);
    final lines =
        result.stdout.toString().split('\n').map((e) => e.trim()).toList();
    final regex = RegExp(r'^(.*) , installed at (.*)$');
    final entries = lines.where((l) => regex.hasMatch(l)).map((l) {
      final match = regex.allMatches(l).toList();
      final version = match[0][1]!;
      final unityExe = match[0][2]!;
      return MapEntry(version, unityExe);
    });
    return Map.fromEntries(entries);
  }
}
