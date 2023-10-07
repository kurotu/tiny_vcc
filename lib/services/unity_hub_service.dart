import 'dart:convert';
import 'dart:io';

import '../data/exceptions.dart';
import '../utils/system_info.dart';

class UnityHubService {
  late String _unityHubExe;

  void setUnityHubExe(String unityHubExe) {
    _unityHubExe = unityHubExe;
  }

  Future<Map<String, String>> listInstalledEditors() async {
    final exe = _unityHubExe;
    final args = ['--', '--headless', 'editors', '-i'];
    if (Platform.isLinux) {
      args.removeAt(0);
    }
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

  Future<Process> installUnity(
    String version,
    String changeset,
    Architecture arch,
    List<String>? modules,
  ) async {
    final args = [
      '--',
      '--headless',
      'install',
      '--version',
      version,
      '-c',
      changeset,
    ];

    // https://forum.unity.com/threads/install-apple-silicon-arm64-using-hub-cli.1423695/#post-9120544
    if (Platform.isMacOS && arch != Architecture.x64) {
      args.addAll(['--architecture', 'arm64']);
    }

    if (Platform.isLinux) {
      args.removeAt(0);
    }
    if (modules != null && modules.isNotEmpty) {
      args.add('--module');
      args.addAll(modules);
    }

    return Process.start(_unityHubExe, args);
  }

  Uri getWindowsInstallerUri() {
    return Uri.parse(
        'https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.exe');
  }

  Uri getMacInstallerUri() {
    return Uri.parse(
        'https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg');
  }
}
