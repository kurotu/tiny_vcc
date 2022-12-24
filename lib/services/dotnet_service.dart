import 'dart:io';

import '../data/exceptions.dart';

class DotNetService {
  DotNetService() {
    _dotnetCommand = findDotNet() ?? 'dotnet';
  }

  String _dotnetCommand = 'dotnet';

  String? findDotNet() {
    if (Platform.isWindows) {
      if (Process.runSync('where', ['dotnet']).exitCode == 0) {
        return 'dotnet';
      }
      return null;
    }
    if (Platform.isMacOS) {
      if (Process.runSync('which', ['dotnet']).exitCode == 0) {
        return 'dotnet';
      }
      const defaultDotNet = '/usr/local/share/dotnet/dotnet';
      if (File(defaultDotNet).existsSync()) {
        return defaultDotNet;
      }
      const brewDotNet6 = '/usr/local/opt/dotnet@6/bin/dotnet';
      if (File(brewDotNet6).existsSync()) {
        return brewDotNet6;
      }
      return null;
    }
    if (Process.runSync('which', ['dotnet']).exitCode == 0) {
      return 'dotnet';
    }
    return null;
  }

  Future<bool> isInstalled() async {
    final dotnet = findDotNet();
    _dotnetCommand = dotnet ?? 'dotnet';
    return dotnet != null;
  }

  Future<Map<String, String>> listSdks() async {
    final exe = _dotnetCommand;
    final args = ['--list-sdks'];
    final result = await Process.run(_dotnetCommand, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
    final lines = result.stdout.toString().split('\n').map((l) => l.trim());
    final regex = RegExp(r'([^ ]*) \[(.*)\]');
    final entries = lines.where((l) => regex.hasMatch(l)).map((l) {
      final match = regex.allMatches(l).toList();
      final version = match[0][1]!;
      final path = match[0][2]!;
      return MapEntry(version, path);
    });
    return Map.fromEntries(entries);
  }

  Future<void> installGlobalTool(String packageId, String? version) async {
    final exe = _dotnetCommand;
    final args = ['tool', 'install', '--global', packageId];
    if (version != null) {
      args.addAll(['--version', version]);
    }
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
  }

  Future<void> updateGlobalTool(String packageId, String? version) async {
    final exe = _dotnetCommand;
    final args = ['tool', 'update', '--global', packageId];
    if (version != null) {
      args.addAll(['--version', version]);
    }
    final result = await Process.run(exe, args);
    if (result.exitCode != 0) {
      throw NonZeroExitException(exe, args, result.exitCode);
    }
  }
}
