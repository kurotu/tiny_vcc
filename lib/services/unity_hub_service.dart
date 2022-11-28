import 'dart:io';

class UnityHubService {
  UnityHubService(this.unityHubExe);

  String unityHubExe;

  Future<Map<String, String>> getInstalledEditors() async {
    var result = await Process.run(
        unityHubExe, ['--', '--headless', 'editors', '--installed']);
    if (result.exitCode != 0) {
      throw Exception('Unity Hub returned exit code ${result.exitCode}.');
    }
    var out = result.stdout.toString();
    Map<String, String> editors = Map.fromIterable(
      out.split('\n').where((e) => e != '').map((e) {
        var elements = e.split(' , ');
        var version = elements[0].trim();
        var path = elements[1].replaceFirst('installed at ', '');
        return MapEntry(version, path);
      }),
    );
    return editors;
  }
}
