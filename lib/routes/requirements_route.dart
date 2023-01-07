import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:system_info2/system_info2.dart';
import 'package:tiny_vcc/widgets/console_dialog.dart';
import 'package:url_launcher/link.dart';

import '../globals.dart';
import '../providers.dart';
import '../utils.dart';
import '../utils/system_info.dart';
import '../widgets/copyable_text.dart';

enum RequirementState { ok, ng, notChecked }

enum _StepIndex {
  dotnet,
  vpm,
  unityHub,
  unity,
  complete,
}

final _stepProvider =
    StateProvider.autoDispose<_StepIndex>((ref) => _StepIndex.dotnet);

final _dotNetStateProvider = FutureProvider.autoDispose((ref) async {
  final dotnet = ref.watch(dotNetServiceProvider);
  final hasCommand = await dotnet.isInstalled();
  if (!hasCommand) {
    return StepState.error;
  }

  final sdks = await dotnet.listSdks();
  const missingVersion = 'MISSING';
  final sdk6Version = sdks.keys
      .firstWhere((v) => v.startsWith('6.'), orElse: () => missingVersion);
  final hasSdk6 = sdk6Version != missingVersion;

  if (hasSdk6) {
    return StepState.complete;
  }
  return StepState.error;
});

final _vpmStateProvider = FutureProvider.autoDispose((ref) async {
  final vcc = ref.watch(vccServiceProvider);
  final hasVcc = vcc.isInstalled();
  if (!hasVcc) {
    return StepState.error;
  }
  final version = await ref.read(vccServiceProvider).getCliVersion();
  if (version >= requiredVpmVersion) {
    return StepState.complete;
  }
  return StepState.error;
});

final _unityHubStateProvider = FutureProvider.autoDispose((ref) async {
  final vcc = ref.watch(vccServiceProvider);
  final hasHub = await vcc.checkHub();
  return hasHub ? StepState.complete : StepState.error;
});

final _unityStateProvider = FutureProvider.autoDispose((ref) async {
  final vcc = ref.watch(vccServiceProvider);
  final hasUnity = await vcc.checkUnity();
  return hasUnity ? StepState.complete : StepState.error;
});

class RequirementsRoute extends ConsumerWidget {
  static const routeName = '/requirements';

  RequirementsRoute({super.key});

  final _dotnetDownloadPageUri =
      Uri.parse('https://dotnet.microsoft.com/download/dotnet/6.0');
  final _vpmCliDocsUri =
      Uri.parse('https://vcc.docs.vrchat.com/vpm/cli/#installation--updating');
  final _unityHubDownloadPageUri =
      Uri.parse('https://unity.com/download#how-get-started');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(_stepProvider);
    final dotnetState = ref.watch(_dotNetStateProvider);
    final vpmState = ref.watch(_vpmStateProvider);
    final hubState = ref.watch(_unityHubStateProvider);
    final unityState = ref.watch(_unityStateProvider);
    ref.listen(_dotNetStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == StepState.error) {
        ref.read(_stepProvider.notifier).state = _StepIndex.dotnet;
      }
    });
    ref.listen(_vpmStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == StepState.error) {
        ref.read(_stepProvider.notifier).state = _StepIndex.vpm;
      }
    });
    ref.listen(_unityHubStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == StepState.error) {
        ref.read(_stepProvider.notifier).state = _StepIndex.unityHub;
      }
    });
    ref.listen(_unityStateProvider, (previous, next) {
      if (!next.isLoading && next.valueOrNull == StepState.error) {
        ref.read(_stepProvider.notifier).state = _StepIndex.unity;
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
                    children: [
                      const Text(
                          'Install .NET 6.0 SDK. You can also download the SDK installer from web.'),
                      Link(
                          uri: _dotnetDownloadPageUri,
                          builder: (context, followLink) => TextButton(
                              onPressed: followLink,
                              child: Text(_dotnetDownloadPageUri.toString())))
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
              child: Text('Install Unity.'),
            ),
            state: _stepState(unityState),
          ),
        ],
      ),
    );
  }

  static StepState _stepState(AsyncValue<StepState> state) {
    return state.isLoading
        ? StepState.indexed
        : state.valueOrNull ?? StepState.indexed;
  }

  static ControlsWidgetBuilder _controlsBuilder(WidgetRef ref) {
    return (BuildContext context, ControlsDetails details) {
      final dotnetState = ref.watch(_dotNetStateProvider);
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
    ref.refresh(_dotNetStateProvider);
    ref.refresh(_vpmStateProvider);
    ref.refresh(_unityHubStateProvider);
    ref.refresh(_unityStateProvider);
  }

  static Future<void> _onClickInstall(
      BuildContext context, WidgetRef ref, _StepIndex step) async {
    switch (step) {
      case _StepIndex.dotnet:
        try {
          await _installDotNetSdk(context, ref);
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
    final stdoutBuilder = StateProvider((ref) => '');

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => ConsoleDialog(
            title: 'Install Unity', consoleOutputProvider: stdoutBuilder)));

    final vcc = ref.read(vccServiceProvider);
    final result = await vcc.installUnity(
        onStdout: (event) {
          ref.read(stdoutBuilder.notifier).state += event;
        },
        onStderr: (event) {});

    Navigator.of(context).pop();
    return result;
  }
}
