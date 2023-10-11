import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_vcc/services/unity_hub_service.dart';

void main() {
  test('parseInstalledEditors on Intel', () {
    final lines = [
      '2019.4.1f1 , installed at /Applications/Unity/Hub/Editor/2019.4.1f1/Unity.app',
      '2020.1.0f1 , installed at /Applications/Unity/Hub/Editor/2020.1.0f1/Unity.app',
    ];

    final expected = {
      '2019.4.1f1': '/Applications/Unity/Hub/Editor/2019.4.1f1/Unity.app',
      '2020.1.0f1': '/Applications/Unity/Hub/Editor/2020.1.0f1/Unity.app',
    };

    final result = UnityHubOutputParser.parseInstalledEditors(lines);
    expect(result, equals(expected));
  });

  test('parseInstalledEditors on Apple Silicon', () {
    final lines = [
      '2019.4.31f1 (Intel), installed at /Applications/Unity/Hub/Editor/2019.4.31f1/Unity.app',
      '2020.1.0f1 (Apple silicon), installed at /Applications/Unity/Hub/Editor/2020.1.0f1/Unity.app',
    ];

    final expected = {
      '2019.4.31f1': '/Applications/Unity/Hub/Editor/2019.4.31f1/Unity.app',
      '2020.1.0f1': '/Applications/Unity/Hub/Editor/2020.1.0f1/Unity.app',
    };

    final result = UnityHubOutputParser.parseInstalledEditors(lines);
    expect(result, equals(expected));
  });

  test('parseInstalledEditors if no editors are installed', () {
    final lines = [
      'No editors installed',
    ];

    final expected = {};

    final result = UnityHubOutputParser.parseInstalledEditors(lines);
    expect(result, equals(expected));
  });
}
