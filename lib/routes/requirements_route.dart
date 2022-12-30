import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../services/dotnet_service.dart';
import '../services/vcc_service.dart';
import '../utils.dart';
import 'projects_route.dart';

final _dotnet = DotNetService();
final _vcc = VccService.withoutContext();

enum RequirementState { ok, ng, notChecked }

FutureProvider<RequirementState> _createProvider(
  FutureProvider<RequirementState> dependency,
  FutureOr<bool> Function() isOk,
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
        return await isOk() ? RequirementState.ok : RequirementState.ng;
    }
  });
}

final _dotNetCommandStateProvider = FutureProvider((ref) async =>
    await _dotnet.isInstalled() ? RequirementState.ok : RequirementState.ng);

final _dotNet6SdkStateProviver =
    _createProvider(_dotNetCommandStateProvider, () async {
  final sdks = await _dotnet.listSdks();
  const missingVersion = 'MISSING';
  final sdk6Version = sdks.keys
      .firstWhere((v) => v.startsWith('6.'), orElse: () => missingVersion);
  return sdk6Version != missingVersion;
});

final _vpmCommandStateProvider =
    _createProvider(_dotNet6SdkStateProviver, () async {
  return _vcc.isInstalled();
});

final _vpmVersionStateProvider =
    _createProvider(_vpmCommandStateProvider, () async {
  final version = await _vcc.getCliVersion();
  return version >= requiredVpmVersion;
});

final _unityHubStateProvider =
    _createProvider(_vpmVersionStateProvider, () async {
  return _vcc.checkHub();
});

final _unityStateProvider = _createProvider(_unityHubStateProvider, () async {
  return _vcc.checkUnity();
});

class RequirementsRoute extends ConsumerStatefulWidget {
  static const routeName = '/requirements';

  const RequirementsRoute({super.key});

  @override
  ConsumerState<RequirementsRoute> createState() => _RequirementsRoute();
}

class _RequirementsRoute extends ConsumerState<RequirementsRoute>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    Future.delayed(const Duration(), _checkRequirements);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_dotNetCommandStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showDotNetBanner();
        }
      });
    });
    ref.listen(_dotNet6SdkStateProviver, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showDotNetBanner();
        }
      });
    });
    ref.listen(_vpmCommandStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showVpmInstallBanner();
        }
      });
    });
    ref.listen(_vpmVersionStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showVpmUpdateBanner();
        }
      });
    });
    ref.listen(_unityHubStateProvider, (previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showUnityHubBanner();
        }
      });
    });
    ref.listen(_unityStateProvider, ((previous, next) {
      next.whenData((value) {
        if (value == RequirementState.ng) {
          _showUnityBanner();
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

  void _checkRequirements() {
    final _ = ref.refresh(_dotNetCommandStateProvider);
  }

  void _showDotNetBanner() {
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
            _checkRequirements();
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showVpmInstallBanner() {
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
            await _dotnet.installGlobalTool(
                vpmPackageId, requiredVpmVersion.toString());
            dialog.close();
            if (mounted) {
              _checkRequirements();
            }
          },
          child: const Text('Install'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements();
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showVpmUpdateBanner() {
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
            await _dotnet.updateGlobalTool(
                vpmPackageId, requiredVpmVersion.toString());
            dialog.close();
            if (mounted) {
              _checkRequirements();
            }
          },
          child: const Text('Update'),
        ),
        TextButton(
          onPressed: () {
            controller?.close();
            _checkRequirements();
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showUnityHubBanner() {
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
            _checkRequirements();
          },
          child: const Text('Check again'),
        ),
      ],
    );
    controller = scaffoldKey.currentState?.showMaterialBanner(banner);
  }

  void _showUnityBanner() {
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
            _checkRequirements();
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
