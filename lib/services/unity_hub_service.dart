import 'dart:io';

import '../data/exceptions.dart';

class UnityHubService {
  late String _unityHubExe;

  void setUnityHubExe(String unityHubExe) {
    _unityHubExe = unityHubExe;
  }

  Future<Map<String, String>> listInstalledEditors() async {
    final exe = _unityHubExe;
    final args = ['--', '--headless', 'editors', '-i'];
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
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
