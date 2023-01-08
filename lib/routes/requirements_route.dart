import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:system_info2/system_info2.dart';
import 'package:url_launcher/link.dart';
import 'package:xterm/core.dart';

import '../data/exceptions.dart';
import '../data/tiny_vcc_data.dart';
import '../globals.dart';
import '../providers.dart';
import '../utils.dart';
import '../utils/system_info.dart';
import '../widgets/console_dialog.dart';
import '../widgets/copyable_text.dart';
import 'main_route.dart';

enum _StepIndex {
  dotnet,
  vpm,
  unityHub,
  unity,
  complete,
}

final _stepProvider = StateProvider.autoDispose<_StepIndex>((ref) {
  final dotnet = ref.read(dotNetStateProvider);
  if (dotnet.valueOrNull == RequirementState.ng) {
    return _StepIndex.dotnet;
  }

  final vpm = ref.read(vpmStateProvider);
  if (vpm.valueOrNull == RequirementState.ng) {
    return _StepIndex.vpm;
  }

  final hub = ref.read(unityHubStateProvider);
  if (hub.valueOrNull == RequirementState.ng) {
    return _StepIndex.unityHub;
  }

  final unity = ref.read(unityStateProvider);
  if (unity.valueOrNull == RequirementState.ng) {
    return _StepIndex.dotnet;
  }
  return _StepIndex.dotnet;
});

final _terminalProvider = Provider.autoDispose((ref) => Terminal());

final _hasBrewProvider = FutureProvider.autoDispose((ref) async {
  if (Platform.isWindows) {
    return false;
  }
  final result = await Process.run('which', ['brew']);
  return result.exitCode == 0;
});

class RequirementsRoute extends ConsumerWidget {
  static const routeName = '/requirements';
  static final _reLF = RegExp('[^\r]\n');

  RequirementsRoute({super.key});

  final _dotnetDownloadPageUri =
      Uri.parse('https://dotnet.microsoft.com/download/dotnet/6.0');
  final _vpmCliDocsUri =
      Uri.parse('https://vcc.docs.vrchat.com/vpm/cli/#installation--updating');
  final _unityHubDownloadPageUri =
      Uri.parse('https://unity.com/download#how-get-started');
  final _unityArchiveUri =
      Uri.parse('https://unity.com/releases/editor/archive');
  final _currentUnityVersionUri =
      Uri.parse('https://docs.vrchat.com/docs/current-unity-version');
  final _brewDotNetSdkVersionsUri =
      Uri.parse('https://github.com/isen-ng/homebrew-dotnet-sdk-versions');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(_stepProvider);
    final dotnetState = ref.watch(dotNetStateProvider);
    final vpmState = ref.watch(vpmStateProvider);
    final hubState = ref.watch(unityHubStateProvider);
    final unityState = ref.watch(unityStateProvider);
    final hasBrew = ref.watch(_hasBrewProvider);

    ref.listen(dotNetStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == RequirementState.ng) {
        ref.read(_stepProvider.notifier).state = _StepIndex.dotnet;
      }
    });
    ref.listen(vpmStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == RequirementState.ng) {
        ref.read(_stepProvider.notifier).state = _StepIndex.vpm;
      }
    });
    ref.listen(unityHubStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == RequirementState.ng) {
        ref.read(_stepProvider.notifier).state = _StepIndex.unityHub;
      }
    });
    ref.listen(unityStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == RequirementState.ng) {
        ref.read(_stepProvider.notifier).state = _StepIndex.unity;
      }
    });
    ref.listen(readyToUseProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == RequirementState.ok) {
        Navigator.of(context).pushReplacementNamed(MainRoute.routeName);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: Stepper(
        controlsBuilder: _controlsBuilder(ref),
        onStepTapped: (value) {
          ref.read(_stepProvider.notifier).state = _StepIndex.values[value];
        },
        currentStep: step.index,
        steps: [
          Step(
            title: const Text('.NET 6.0 SDK'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hasBrew.valueOrNull == true
                        ? [
                            const Text(
                                'Install .NET 6.0 SDK with Homebrew. You can also install with following command.'),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(4)),
                              child: CopyableText(
                                  'brew tap isen-ng/dotnet-sdk-versions\n'
                                  'brew install --cask dotnet-sdk6-0-400'),
                            ),
                            Link(
                              uri: _brewDotNetSdkVersionsUri,
                              builder: (context, followLink) => TextButton(
                                  onPressed: followLink,
                                  child: Text(
                                      _brewDotNetSdkVersionsUri.toString())),
                            ),
                          ]
                        : [
                            const Text(
                                'Install .NET 6.0 SDK. You can also download the SDK installer from web.'),
                            Link(
                                uri: _dotnetDownloadPageUri,
                                builder: (context, followLink) => TextButton(
                                    onPressed: followLink,
                                    child: Text(
                                        _dotnetDownloadPageUri.toString())))
                          ])),
            state: _stepState(dotnetState),
          ),
          Step(
            title: const Text('VPM CLI'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Install VPM CLI. You can also install with following command.'),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4)),
                    child: CopyableText(
                        'dotnet tool install --global vrchat.vpm.cli --version ${requiredVpmVersion.toString()}'),
                  ),
                  Link(
                    uri: _vpmCliDocsUri,
                    builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(_vpmCliDocsUri.toString())),
                  ),
                ],
              ),
            ),
            state: _stepState(vpmState),
          ),
          Step(
            title: const Text('Unity Hub'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Install Unity Hub. You can also download the installer from web.'),
                  Link(
                      uri: _unityHubDownloadPageUri,
                      builder: (context, followLink) => TextButton(
                          onPressed: followLink,
                          child: Text(_unityHubDownloadPageUri.toString())))
                ],
              ),
            ),
            state: _stepState(hubState),
          ),
          Step(
            title: const Text('Unity'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Install Unity with Unity Hub. You can also install from archive, but you should install the exact version which VRChat specifies.'),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  const Text(
                      'In manual installation, you must install some modules together:'),
                  Platform.isWindows
                      ? const Text(
                          '  - Android Build Support (to upload for Quest)')
                      : const Text(
                          '  - Android Build Support (to upload for Quest)\n'
                          '  - Windows Build Support (mono) (to upload for PC from macOS or Linux'),
                  Link(
                    uri: _currentUnityVersionUri,
                    builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(_currentUnityVersionUri.toString())),
                  ),
                  Link(
                    uri: _unityArchiveUri,
                    builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: Text(_unityArchiveUri.toString())),
                  ),
                ],
              ),
            ),
            state: _stepState(unityState),
          ),
        ],
      ),
    );
  }

  static StepState _stepState(AsyncValue<RequirementState> state) {
    return state.when(
        data: ((data) {
          switch (data) {
            case RequirementState.ok:
              return StepState.complete;
            case RequirementState.ng:
              return StepState.error;
            case RequirementState.notChecked:
              return StepState.indexed;
          }
        }),
        error: (obj, trace) => StepState.indexed,
        loading: () => StepState.indexed);
  }

  static ControlsWidgetBuilder _controlsBuilder(WidgetRef ref) {
    return (BuildContext context, ControlsDetails details) {
      final step = _StepIndex.values[details.stepIndex];
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        height: 64,
        child: Wrap(
          spacing: 16,
          alignment: WrapAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await _onClickInstall(context, ref, step);
                },
                child: const Text('Install')),
            TextButton(
                onPressed: () {
                  _refresh(ref);
                },
                child: const Text('Check again')),
          ],
        ),
      );
    };
  }

  static void _refresh(WidgetRef ref) {
    ref.refresh(dotNetStateProvider);
    ref.refresh(vpmStateProvider);
    ref.refresh(unityHubStateProvider);
    ref.refresh(unityStateProvider);
    ref.refresh(_hasBrewProvider);
  }

  static Future<void> _onClickInstall(
      BuildContext context, WidgetRef ref, _StepIndex step) async {
    switch (step) {
      case _StepIndex.dotnet:
        try {
          if (ref.read(_hasBrewProvider).valueOrNull == true) {
            await _installDotNetSdkWithBrew(context);
          } else {
            await _installDotNetSdk(context, ref);
          }
        } on Exception catch (error) {
          await showSimpleErrorDialog(
              context, 'Failed to install .NET SDK', error);
        }
        _refresh(ref);
        break;
      case _StepIndex.vpm:
        try {
          await _installVpmCli(context, ref);
        } on Exception catch (error) {
          await showSimpleErrorDialog(
              context, 'Failed to install VPM CLI', error);
        }
        _refresh(ref);
        break;
      case _StepIndex.unityHub:
        try {
          await _installUnityHub(context, ref);
        } on Exception catch (error) {
          await showSimpleErrorDialog(
              context, 'Failed to install Unity Hub', error);
        }
        _refresh(ref);
        break;
      case _StepIndex.unity:
        try {
          await _installUnity(context, ref);
        } on Exception catch (error) {
          await showSimpleErrorDialog(
              context, 'Failed to install Unity', error);
        }
        _refresh(ref);
        break;
      case _StepIndex.complete:
        print('TODO: Handle this case.');
        break;
    }
  }

  static Future<bool> _installDotNetSdk(
      BuildContext context, WidgetRef ref) async {
    final dialog = showProgressDialog(
        context, Theme.of(context), 'Downloading .NET 6.0 SDK installer.');
    File? installer;
    try {
      if (SystemInfo.arch == Architecture.unknown) {
        throw Exception(
            "Failed to detect architecture for ${SysInfo.cores[0].architecture}.");
      }

      final tmp = await getTemporaryDirectory();
      final dir = Directory(p.join(tmp.path, 'tiny_vcc'));
      await dir.create(recursive: true);

      final dotnet = ref.read(dotNetServiceProvider);
      final version = await dotnet.getLatestVersion();
      Uri installerUri;
      if (Platform.isWindows) {
        installer = File(p.join(dir.path,
            'dotnet-sdk-installer-${DateTime.now().millisecondsSinceEpoch}.exe'));
        installerUri = dotnet.getWindowsInstallerUri(version, SystemInfo.arch);
      } else if (Platform.isMacOS) {
        installer = File(p.join(dir.path,
            'dotnet-sdk-installer-${DateTime.now().millisecondsSinceEpoch}.pkg'));
        installerUri = dotnet.getMacInstallerUri(version, SystemInfo.arch);
      } else if (Platform.isLinux) {
        throw UnimplementedError('Need to implement dotnet installer.');
      } else {
        throw Error();
      }

      logger?.i(
          'Downloading dotnet sdk installer from $installerUri to $installer.');
      final client = http.Client();
      final request = http.Request('GET', installerUri);
      final res = await client.send(request);
      if (res.statusCode / 100 != 2) {
        throw HttpException('Failed to get', uri: installerUri);
      }
      final sink = installer.openWrite();
      await sink.addStream(res.stream);
      await sink.close();
      logger?.i(
          'Downloaded dotnet sdk installer from $installerUri to $installer.');

      dialog.update(value: 1, msg: 'Installing .NET 6.0 SDK.');
      logger?.i('Executing installer: $installer');
      ProcessResult result;
      if (Platform.isWindows) {
        result = await Process.run(installer.path, []);
      } else if (Platform.isMacOS) {
        result = await Process.run('open', ['-W', installer.path]);
      } else {
        throw UnimplementedError();
      }
      logger?.i('Finished installer with code ${result.exitCode}: $installer');
      return result.exitCode == 0;
    } on Exception catch (error) {
      logger?.e(error.toString());
      rethrow;
    } finally {
      if (await installer?.exists() == true) {
        await installer?.delete();
      }
      dialog.close();
      await Future.delayed(const Duration());
    }
  }

  static Future<bool> _installDotNetSdkWithBrew(BuildContext context) async {
    const script = 'set -eux\n'
        'brew tap isen-ng/dotnet-sdk-versions\n'
        'brew install --cask dotnet-sdk6-0-400\n'
        'echo \'You can close this window.\'\n';
    final tmp = await getTemporaryDirectory();
    final dir = Directory(p.join(tmp.path, 'tiny_vcc'));
    await dir.create(recursive: true);

    final scriptFile = File(p.join(
        dir.path, 'install-dotnet-sdk-${Random.secure().nextInt(65536)}.sh'));
    await scriptFile.writeAsString(script);
    await Process.run('chmod', ['+x', scriptFile.path]);
    final result = await Process.run('osascript',
        ['-e' 'tell application "Terminal" to do script "${scriptFile.path}"']);

    await showAlertDialog(context,
        title: "Installing .NET 6.0 SDK with Homebrew",
        message: 'See Terminal app to continue installation.');

    return result.exitCode == 0;
  }

  static Future<bool> _installVpmCli(
      BuildContext context, WidgetRef ref) async {
    final dialog = showProgressDialog(context, Theme.of(context),
        'Installing VPM CLI ${requiredVpmVersion.toString()}');
    try {
      final dotnet = ref.read(dotNetServiceProvider);
      final vcc = ref.read(vccServiceProvider);

      if (vcc.isInstalled()) {
        final version = await vcc.getCliVersion();
        if (version >= requiredVpmVersion) {
          return true;
        }
        logger?.i('Updating VPM CLI.');
        await dotnet.updateGlobalTool(
            vpmPackageId, requiredVpmVersion.toString());
      } else {
        logger?.i('Installing VPM CLI.');
        await dotnet.installGlobalTool(
            vpmPackageId, requiredVpmVersion.toString());
      }
      if (!vcc.isInstalled()) {
        return false;
      }

      logger?.i('Installing VPM templates.');
      await vcc.installTemplates();
    } on Exception catch (error) {
      logger?.e(error.toString());
      rethrow;
    } finally {
      dialog.close();
      await Future.delayed(const Duration());
    }
    return true;
  }

  static Future<bool> _installUnityHub(
      BuildContext context, WidgetRef ref) async {
    if (Platform.isWindows || Platform.isMacOS) {
      final dialog = showProgressDialog(
          context, Theme.of(context), 'Downloading Unity Hub installer.');
      File? installer;
      try {
        final tmp = await getTemporaryDirectory();
        final dir = Directory(p.join(tmp.path, 'tiny_vcc'));
        await dir.create(recursive: true);

        final hub = ref.read(unityHubServiceProvider);
        final Uri installerUri;
        if (Platform.isWindows) {
          installer = File(p.join(dir.path,
              'unity-hub-installer-${Random.secure().nextInt(65535)}.exe'));
          installerUri = hub.getWindowsInstallerUri();
        } else if (Platform.isMacOS) {
          installer = File(p.join(dir.path,
              'unity-hub-installer-${Random.secure().nextInt(65535)}.dmg'));
          installerUri = hub.getMacInstallerUri();
        } else {
          throw UnimplementedError();
        }

        logger?.i(
            'Downloading dotnet sdk installer from $installerUri to $installer.');
        final client = http.Client();
        final request = http.Request('GET', installerUri);
        final res = await client.send(request);
        if (res.statusCode / 100 != 2) {
          throw HttpException('Failed to get', uri: installerUri);
        }
        final sink = installer.openWrite();
        await sink.addStream(res.stream);
        await sink.close();
        logger?.i(
            'Downloaded Unity Hub installer from $installerUri to $installer.');

        dialog.update(value: 1, msg: 'Installing Unity Hub.');
        logger?.i('Executing installer: $installer');
        final ProcessResult result;
        if (Platform.isWindows) {
          result = await Process.run(installer.path, [], runInShell: true);
        } else if (Platform.isMacOS) {
          if (await Directory('/Applications/Unity Hub.app').exists()) {
            throw Exception('"/Applications/Unity Hub.app" already exists.');
          }
          result = await Process.run('sh', [
            '-e',
            '-c',
            [
              'hdiutil mount ${installer.path}',
              'cp -rv /Volumes/Unity\\ Hub\\ */Unity\\ Hub.app /Applications/',
              'hdiutil unmount /Volumes/Unity\\ Hub\\ *',
            ].join('\n'),
          ]);
        } else {
          throw UnimplementedError();
        }
        logger
            ?.i('Finished installer with code ${result.exitCode}: $installer');

        return result.exitCode == 0;
      } on Exception catch (error) {
        logger?.e(error);
        rethrow;
      } finally {
        if (await installer?.exists() == true) {
          await installer?.delete();
        }
        dialog.close();
        await Future.delayed(const Duration());
      }
    } else if (Platform.isLinux) {
      throw UnimplementedError("_installUnityHub is not implemented for Linux");
    }
    throw Error();
  }

  static Future<bool> _installUnity(BuildContext context, WidgetRef ref) async {
    final terminal = ref.read(_terminalProvider);
    try {
      final hub = ref.read(unityHubServiceProvider);
      final modules =
          Platform.isWindows ? ['android'] : ['android', 'windows-mono'];
      final process = await hub.installUnity(
        '2019.4.31f1',
        'bd5abf232a62',
        modules,
      );
      process.stdout.transform(utf8.decoder).listen((event) {
        // Enter 'n' for child-modules
        if (event.contains('(Y/n)')) {
          process.stdin.writeln('n');
        }
        final str = event.replaceAll(_reLF, '\r\n');
        terminal.write(str);
      });
      process.stderr.transform(utf8.decoder).listen((event) {
        terminal.write(event);
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ConsoleDialog(
          title: 'Installing Unity',
          terminal: terminal,
          actions: [
            TextButton(
                onPressed: () {
                  process.kill();
                },
                child: const Text('Cancel')),
          ],
        ),
      );

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw NonZeroExitException('Unity Hub', [], exitCode);
      }
      return true;
    } on Exception catch (error) {
      logger?.e(error);
      rethrow;
    } finally {
      Navigator.of(context).pop();
      await Future.delayed(const Duration());
    }
  }
}
