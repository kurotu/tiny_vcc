import 'dart:convert';
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

  Future<void> installUnity(
    String version,
    String changeset,
    List<String>? modules, {
    required void Function(String event) onStdout,
    required void Function(String event) onStderr,
  }) async {
    final args = [
      '--',
      '--headless',
      'install',
      '--version',
      version,
      '-c',
      changeset,
    ];
    if (modules != null && modules.isNotEmpty) {
      args.add('--module');
      args.addAll(modules);
    }

    final process = await Process.start(_unityHubExe, args);
    final stdout = process.stdout.transform(utf8.decoder).asBroadcastStream();
    stdout.listen(onStdout);
    stdout.listen((event) {
      // Enter 'n' for child-modules
      if (event.contains('(Y/n)')) {
        process.stdin.writeln('n');
      }
    });
    process.stderr.transform(utf8.decoder).listen(onStderr);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw NonZeroExitException(_unityHubExe, args, exitCode);
    }
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
