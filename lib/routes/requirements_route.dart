import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import '../models/requirements_model.dart';
import '../utils.dart';
import 'projects_route.dart';

class RequirementsRoute extends StatefulWidget {
  static const routeName = '/requirements';

  const RequirementsRoute({super.key});

  @override
  State<RequirementsRoute> createState() => _RequirementsRoute();
}

class _RequirementsRoute extends State<RequirementsRoute> with RouteAware {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          children: [
            Consumer<RequirementsModel>(
              builder: ((context, model, child) => _RequirementItem(
                    state: model.hasDotNet6,
                    title: '.NET 6.0 SDK',
                  )),
            ),
            Consumer<RequirementsModel>(
              builder: ((context, model, child) => _RequirementItem(
                    state: model.hasVpm,
                    title: 'VPM CLI $requiredVpmVersion',
                  )),
            ),
            Consumer<RequirementsModel>(
              builder: ((context, model, child) => _RequirementItem(
                    state: model.hasUnityHub,
                    title: 'Unity Hub',
                  )),
            ),
            Consumer<RequirementsModel>(
              builder: ((context, model, child) => _RequirementItem(
                    state: model.hasUnity,
                    title: 'Unity',
                  )),
            ),
          ],
        ),
      ),
    );
  }

  RequirementsModel _model(BuildContext context) {
    return context.read<RequirementsModel>();
  }

  Future<void> _checkRequirements() async {
    await context.read<RequirementsModel>().fetchRequirements();
    if (mounted) {
      if (context.read<RequirementsModel>().isReadyToUse) {
        Navigator.pushReplacementNamed(context, ProjectsRoute.routeName);
      } else {
        _showBannerForMissingRequirements();
      }
    }
  }

  void _showBannerForMissingRequirements() {
    final model = _model(context);
    if (model.hasDotNetCommand == RequirementState.ng ||
        model.hasDotNet6Sdk == RequirementState.ng) {
      _showDotNetBanner();
    } else if (model.hasVpm == RequirementState.ng) {
      _showVpmInstallBanner();
    } else if (model.hasCorrectVpm == RequirementState.ng) {
      _showVpmUpdateBanner();
    } else if (model.hasUnityHub == RequirementState.ng) {
      _showUnityHubBanner();
    } else if (model.hasUnity == RequirementState.ng) {
      _showUnityBanner();
    } else {
      throw Error();
    }
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
            await _model(context).installVpmCli();
            dialog.close();
            if (mounted) {
              await _checkRequirements();
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
            await _model(context).updateVpmCli();
            dialog.close();
            if (mounted) {
              await _checkRequirements();
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

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({
    required this.state,
    required this.title,
  });

  final RequirementState state;
  final String title;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        (() {
          switch (state) {
            case RequirementState.checking:
              return const SizedBox.square(
                  dimension: _iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ));
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
        })(),
        Text(title),
      ],
    );
  }
}
