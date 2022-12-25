import 'dart:io';

import '../data/exceptions.dart';

class DotNetService {
  DotNetService() {
    _findDotNet();
  }

  /// Use full path to avoid crash.
  /// https://stackoverflow.com/questions/69139808/
  String _dotnetCommand = '';

  String? _findDotNet() {
    if (Platform.isWindows) {
      final result = Process.runSync('where', ['dotnet']);
      if (result.exitCode == 0) {
        _dotnetCommand = result.stdout.toString().trim();
        return _dotnetCommand;
      }
      _dotnetCommand = '';
      return null;
    }
    if (Platform.isMacOS) {
      final result = Process.runSync('which', ['dotnet']);
      if (result.exitCode == 0) {
        _dotnetCommand = result.stdout.toString().trim();
        return _dotnetCommand;
      }
      const defaultDotNet = '/usr/local/share/dotnet/dotnet';
      if (File(defaultDotNet).existsSync()) {
        _dotnetCommand = defaultDotNet;
        return defaultDotNet;
      }
      const brewDotNet6 = '/usr/local/opt/dotnet@6/bin/dotnet';
      if (File(brewDotNet6).existsSync()) {
        _dotnetCommand = brewDotNet6;
        return brewDotNet6;
      }
      _dotnetCommand = '';
      return null;
    }
    final result = Process.runSync('which', ['dotnet']);
    if (result.exitCode == 0) {
      _dotnetCommand = result.stdout.toString().trim();
      return _dotnetCommand;
    }
    _dotnetCommand = '';
    return null;
  }

  Future<bool> isInstalled() async {
    final dotnet = _findDotNet();
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
