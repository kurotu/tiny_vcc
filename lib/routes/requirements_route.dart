import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../globals.dart';
import '../providers.dart';
import '../utils.dart';

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

  const RequirementsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(_stepProvider);
    final dotnetState = ref.watch(_dotNetStateProvider);
    final vpmState = ref.watch(_vpmStateProvider);
    final hubState = ref.watch(_unityHubStateProvider);
    final unityState = ref.watch(_unityStateProvider);

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
                child: Text('Install .NET 6.0 SDK.')),
            state: _stepState(dotnetState),
          ),
          Step(
            title: const Text('VPM CLI'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Text('Install VPM CLI.'),
            ),
            state: _stepState(vpmState),
          ),
          Step(
            title: const Text('Unity Hub'),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Text('Install Unity Hub.'),
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
        print('TODO: Handle this case.');
        final dialog = showProgressDialog(
            context, Theme.of(context), 'Installing .NET 6.0 SDK.');
        await Future.delayed(const Duration(seconds: 5));
        dialog.close();
        _refresh(ref);
        break;
      case _StepIndex.vpm:
        print('TODO: Handle this case.');
        final dialog = showProgressDialog(
            context, Theme.of(context), 'Installing VPM CLI.');
        await Future.delayed(const Duration(seconds: 5));
        dialog.close();
        _refresh(ref);
        break;
      case _StepIndex.unityHub:
        print('TODO: Handle this case.');
        break;
      case _StepIndex.unity:
        print('TODO: Handle this case.');
        break;
      case _StepIndex.complete:
        print('TODO: Handle this case.');
        break;
    }
  }
}
