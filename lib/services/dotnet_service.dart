import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../data/exceptions.dart';
import '../utils/system_info.dart';

class DotNetService {
  DotNetService() {
    _findDotNet();
  }

  /// Use full path to avoid crash.
  /// https://stackoverflow.com/questions/69139808/
  String _dotnetCommand = '';

  static const _feed = 'https://dotnetcli.azureedge.net';

  String? _findDotNet() {
    if (Platform.isWindows) {
      final result = Process.runSync('where', ['dotnet']);
      if (result.exitCode == 0) {
        _dotnetCommand = result.stdout.toString().trim();
        return _dotnetCommand;
      }
      final defaultDotNet = File('C:\\Program Files\\dotnet\\dotnet.exe');
      if (defaultDotNet.existsSync()) {
        _dotnetCommand = defaultDotNet.path;
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

  Future<String> getLatestVersion() async {
    final versionUri = Uri.parse('$_feed/dotnet/Sdk/6.0/latest.version');
    return (await http.read(versionUri)).trim();
  }

  Uri getWindowsInstallerUri(String version, Architecture arch) {
    return Uri.parse(
        '$_feed/dotnet/Sdk/$version/dotnet-sdk-$version-win-${arch.name}.exe');
  }

  Uri getMacInstallerUri(String version, Architecture arch) {
    return Uri.parse(
        '$_feed/dotnet/Sdk/$version/dotnet-sdk-$version-osx-${arch.name}.pkg');
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
