import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../providers.dart';
import '../utils.dart';
import 'projects_route.dart';

enum RequirementState { ok, ng, notChecked }

FutureProvider<RequirementState> _createProvider(
  FutureProvider<RequirementState> dependency,
  FutureOr<bool> Function(Ref ref) isOk,
) {
  return FutureProvider((ref) async {
    final depend = ref.watch(dependency);
    if (depend.isLoading) {
      return RequirementState.notChecked;
    }
    switch (depend.valueOrNull) {
      case null:
      case RequirementState.notChecked:
      case RequirementState.ng:
        return RequirementState.notChecked;
      case RequirementState.ok:
        return await isOk(ref) ? RequirementState.ok : RequirementState.ng;
    }
  });
}

final _dotNetCommandStateProvider = FutureProvider((ref) async =>
    await ref.read(dotNetServiceProvider).isInstalled()
        ? RequirementState.ok
        : RequirementState.ng);

final _dotNet6SdkStateProviver =
    _createProvider(_dotNetCommandStateProvider, (ref) async {
  final sdks = await ref.read(dotNetServiceProvider).listSdks();
  const missingVersion = 'MISSING';
  final sdk6Version = sdks.keys
      .firstWhere((v) => v.startsWith('6.'), orElse: () => missingVersion);
  return sdk6Version != missingVersion;
});

final _vpmCommandStateProvider =
    _createProvider(_dotNet6SdkStateProviver, (ref) async {
  return ref.read(vccServiceProvider).isInstalled();
});

final _vpmVersionStateProvider =
    _createProvider(_vpmCommandStateProvider, (ref) async {
  final version = await ref.read(vccServiceProvider).getCliVersion();
  return version >= requiredVpmVersion;
});

final _unityHubStateProvider =
    _createProvider(_vpmVersionStateProvider, (ref) async {
  return ref.read(vccServiceProvider).checkHub();
});

final _unityStateProvider =
    _createProvider(_unityHubStateProvider, (ref) async {
  return ref.read(vccServiceProvider).checkUnity();
});

class RequirementsRoute extends ConsumerWidget {
  static const routeName = '/requirements';

  const RequirementsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_dotNetCommandStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showDotNetBanner(ref);
        }
      });
    });
    ref.listen(_dotNet6SdkStateProviver, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showDotNetBanner(ref);
        }
      });
    });
    ref.listen(_vpmCommandStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showVpmInstallBanner(context, ref);
        }
      });
    });
    ref.listen(_vpmVersionStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showVpmUpdateBanner(context, ref);
        }
      });
    });
    ref.listen(_unityHubStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showUnityHubBanner(ref);
        }
      });
    });
    ref.listen(_unityStateProvider, ((previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showUnityBanner(ref);
        }
        if (value == RequirementState.ok) {
          Navigator.pushReplacementNamed(context, ProjectsRoute.routeName);
        }
      });
    }));

    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          children: [
            _RequirementItem(_dotNetCommandStateProvider, 'dotnet command'),
            _RequirementItem(_dotNet6SdkStateProviver, '.NET 6.0 SDK'),
            _RequirementItem(_vpmCommandStateProvider, 'vpm command'),
            _RequirementItem(_vpmVersionStateProvider, 'VPM CLI version'),
            _RequirementItem(_vpmVersionStateProvider, 'Unity Hub'),
            _RequirementItem(_vpmVersionStateProvider, 'Unity'),
          ],
        ),
      ),
    );
  }

  void _checkRequirements(WidgetRef ref) {
    final _ = ref.refresh(_dotNetCommandStateProvider);
  }

  void _showDotNetBanner(WidgetRef ref) {
    ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
        controller;
    final banner = MaterialBanner(
      content: const Text(
          '.NET 6 SDK is required to execute VPM CLI. Download and install.'),
      actions: [
        TextButton(
          onPressed: () {
            launchUrl(
                Uri.parse('https://dotnet.microsoft.com/download/dotnet/6.0'));
          },
          child: const Text('Download'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements(ref);
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showVpmInstallBanner(BuildContext context, WidgetRef ref) {
    ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
        controller;
    final banner = MaterialBanner(
      content: const Text('VPM CLI is required.'),
      actions: [
        TextButton(
          onPressed: () async {
            controller?.close();
            final dialog =
                showProgressDialog(context, 'Installing vrchat.vpm.cli');
            await ref
                .read(dotNetServiceProvider)
                .installGlobalTool(vpmPackageId, requiredVpmVersion.toString());
            dialog.close();
            _checkRequirements(ref);
          },
          child: const Text('Install'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements(ref);
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showVpmUpdateBanner(BuildContext context, WidgetRef ref) {
    ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
        controller;
    final banner = MaterialBanner(
      content: Text('VPM CLI $requiredVpmVersion is required.'),
      actions: [
        TextButton(
          onPressed: () async {
            controller?.close();
            final dialog = showProgressDialog(
                context, 'Updating vrchat.vpm.cli to $requiredVpmVersion');
            await ref
                .read(dotNetServiceProvider)
                .updateGlobalTool(vpmPackageId, requiredVpmVersion.toString());
            dialog.close();
            _checkRequirements(ref);
          },
          child: const Text('Update'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements(ref);
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showUnityHubBanner(WidgetRef ref) {
    ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
        controller;
    final banner = MaterialBanner(
      content: const Text('Unity Hub is required.'),
      actions: [
        TextButton(
          onPressed: () async {
            launchUrl(Uri.parse('https://unity.com/download#how-get-started'));
          },
          child: const Text('Download'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements(ref);
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showUnityBanner(WidgetRef ref) {
    ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
        controller;
    final banner = MaterialBanner(
      content: const Text('Unity is required. Install with Unity Hub.'),
      actions: [
        TextButton(
          onPressed: () async {
            launchUrl(Uri.parse(
                'https://docs.vrchat.com/docs/current-unity-version'));
          },
          child: const Text('See current version'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            controller = null;
            _checkRequirements(ref);
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }
}

class _RequirementItem<T> extends ConsumerWidget {
  const _RequirementItem(this.provider, this.title);

  final FutureProvider<RequirementState> provider;
  final String title;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return Wrap(
      spacing: 8,
      children: [
        state.when(
          data: (data) {
            switch (data) {
              case RequirementState.ng:
                return const Icon(
                  Icons.clear,
                  size: _iconSize,
                  color: Colors.red,
                );
              case RequirementState.ok:
                return const Icon(
                  Icons.check,
                  size: _iconSize,
                  color: Colors.green,
                );
              case RequirementState.notChecked:
                return const SizedBox.square(dimension: _iconSize);
            }
          },
          loading: () => const SizedBox.square(
            dimension: _iconSize,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: ((error, stackTrace) {
            return const Icon(
              Icons.clear,
              size: _iconSize,
              color: Colors.red,
            );
          }),
        ),
        Text(title),
      ],
    );
  }
}