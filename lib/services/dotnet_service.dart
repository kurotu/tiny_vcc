import 'dart:io';

class DotNetService {
  Future<bool> isInstalled() async {
    final result = Platform.isWindows
        ? await Process.run('where', ['dotnet'])
        : await Process.run('which', ['dotnet']);
    return result.exitCode == 0;
  }

  Future<Map<String, String>> listSdks() async {
    final result = await Process.run('dotnet', ['--list-sdks']);
    if (result.exitCode != 0) {
      throw Exception('dotnet --list-sdks returned ${result.exitCode}');
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

  Future<void> installGlobalTool(String packageId) async {
    final result =
        await Process.run('dotnet', ['tool', 'install', '--global', packageId]);
    if (result.exitCode != 0) {
      throw Exception(
          'dotnet tool install --global $packageId returned ${result.exitCode}');
    }
  }

  Future<void> updateGlobalTool(String packageId) async {
    final result =
        await Process.run('dotnet', ['tool', 'update', '--global', packageId]);
    if (result.exitCode != 0) {
      throw Exception(
          'dotnet tool update --global $packageId returned ${result.exitCode}');
    }
  }
}
