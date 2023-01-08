import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/tiny_vcc_data.dart';
import 'globals.dart';
import 'repos/tiny_vcc_settings_repository.dart';
import 'repos/vcc_projects_repository.dart';
import 'repos/vcc_settings_repository.dart';
import 'repos/vcc_templates_repository.dart';
import 'repos/vpm_packages_repository.dart';
import 'services/dotnet_service.dart';
import 'services/tiny_vcc_service.dart';
import 'services/unity_hub_service.dart';
import 'services/vcc_service.dart';

final packageInfoProvider = FutureProvider((ref) => PackageInfo.fromPlatform());
final licenseNoticeProvider = FutureProvider(
    (ref) => rootBundle.loadString('assets/texts/LICENSE_NOTICE'));

final dotNetServiceProvider = Provider((ref) => DotNetService());
final unityHubServiceProvider = Provider((ref) => UnityHubService());
final vccServiceProvider =
    Provider((ref) => VccService(ref.read(unityHubServiceProvider)));
final vccSettingsRepoProvider = Provider((ref) {
  final vcc = ref.read(vccServiceProvider);
  return VccSettingsRepository(vcc);
});
final vccSettingsProvider = FutureProvider((ref) {
  return ref.read(vccSettingsRepoProvider).fetchSettings(refresh: true);
});
final vccProjectsRepoProvider = Provider((ref) {
  return VccProjectsRepository(ref.read(vccServiceProvider));
});

final tinyVccServiceProvider = Provider((ref) => TinyVccService());
final tinyVccSettingsRepositoryProvider = Provider(
    (ref) => TinyVccSettingsRepository(ref.read(tinyVccServiceProvider)));
final tinyVccSettingsProvider = FutureProvider(
    (ref) => ref.read(tinyVccSettingsRepositoryProvider).fetchSettings());

final vpmTemplatesRepoProvider = Provider((ref) {
  return VccTemplatesRepository(ref.read(vccServiceProvider));
});
final vpmTemplatesProvider = FutureProvider((ref) {
  return ref.read(vpmTemplatesRepoProvider).fetchTemplates();
});

final vpmPackagesRepoProvider =
    Provider((ref) => VpmPackagesRepository(ref.read(vccServiceProvider)));
final vpmPackagesProvider =
    FutureProvider((ref) => ref.read(vpmPackagesRepoProvider).fetchPackages());

final readyToUseProvider = FutureProvider.autoDispose((ref) async {
  final providers = [
    dotNetStateProvider,
    vpmStateProvider,
    unityHubStateProvider,
    unityStateProvider,
  ];
  final states = providers.map((e) => ref.watch(e)).toList();

  try {
    states.firstWhere((element) => element.isLoading);
    return RequirementState.notChecked;
  } on StateError {
    // do nothing, just catch
  }

  try {
    states.firstWhere((element) => element.valueOrNull == RequirementState.ng);
    return RequirementState.ng;
  } on StateError {
    // do nothing, just catch
  }

  return RequirementState.ok;
});

final dotNetStateProvider = FutureProvider.autoDispose((ref) async {
  final dotnet = ref.watch(dotNetServiceProvider);
  final hasCommand = await dotnet.isInstalled();
  if (!hasCommand) {
    return RequirementState.ng;
  }

  final sdks = await dotnet.listSdks();
  const missingVersion = 'MISSING';
  final sdk6Version = sdks.keys
      .firstWhere((v) => v.startsWith('6.'), orElse: () => missingVersion);
  final hasSdk6 = sdk6Version != missingVersion;

  if (hasSdk6) {
    return RequirementState.ok;
  }
  return RequirementState.ng;
});

final vpmStateProvider = FutureProvider.autoDispose((ref) async {
  final vcc = ref.watch(vccServiceProvider);
  final hasVcc = vcc.isInstalled();
  if (!hasVcc) {
    return RequirementState.ng;
  }
  final version = await ref.read(vccServiceProvider).getCliVersion();
  if (version >= requiredVpmVersion) {
    return RequirementState.ok;
  }
  return RequirementState.ng;
});

final unityHubStateProvider = FutureProvider.autoDispose((ref) async {
  final settings = ref.watch(vccSettingsProvider);
  if (settings.isLoading || settings.hasError) {
    return RequirementState.notChecked;
  }

  final vcc = ref.watch(vccServiceProvider);
  final hasHub = await vcc.checkHub();
  if (!hasHub) {
    return RequirementState.ng;
  }

  if (!await (File(settings.requireValue.pathToUnityHub).exists())) {
    return RequirementState.ng;
  }

  return RequirementState.ok;
});

final unityStateProvider = FutureProvider.autoDispose((ref) async {
  final settings = ref.watch(vccSettingsProvider);
  if (settings.isLoading || settings.hasError) {
    return RequirementState.notChecked;
  }

  final vcc = ref.watch(vccServiceProvider);
  final hasUnity = await vcc.checkUnity();
  if (!hasUnity) {
    RequirementState.ng;
  }

  if (!await (File(settings.requireValue.pathToUnityExe).exists())) {
    return RequirementState.ng;
  }

  return RequirementState.ok;
});
