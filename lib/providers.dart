import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/tiny_vcc_data.dart';
import 'globals.dart';
import 'i18n/strings.g.dart';
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
final translationProvider = Provider((ref) {
  final settings = ref.watch(tinyVccSettingsProvider);
  final locale = settings.when(
      data: (data) => data.locale,
      error: (error, stackTrace) => settings.valueOrNull?.locale,
      loading: () => settings.valueOrNull?.locale);
  if (locale == null || locale == 'auto') {
    return AppLocaleUtils.findDeviceLocale().build();
  } else {
    final split = locale.split('-'); // flutter's language tag
    final String lang;
    final String? country;
    if (split.length > 1) {
      lang = split[0];
      country = split[1];
    } else {
      lang = locale;
      country = null;
    }
    return AppLocaleUtils.parseLocaleParts(
            languageCode: lang, countryCode: country)
        .build();
  }
});

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

  final set = states.map((e) => e.valueOrNull).toSet();
  if (set.length == 1 && set.contains(RequirementState.ok)) {
    return RequirementState.ok;
  }
  return RequirementState.notChecked;
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
  final dotnet = ref.watch(dotNetStateProvider);
  final state = dotnet.when(
    data: (data) async {
      switch (data) {
        case RequirementState.ok:
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
        case RequirementState.ng:
        case RequirementState.notChecked:
          return RequirementState.notChecked;
      }
    },
    error: (error, stack) => Future.value(RequirementState.notChecked),
    loading: () => Future.value(RequirementState.notChecked),
  );
  return state;
});

final unityHubStateProvider = FutureProvider.autoDispose((ref) async {
  final vpm = ref.watch(vpmStateProvider);
  final state = vpm.when(
    data: (data) async {
      switch (data) {
        case RequirementState.ok:
          final vcc = ref.watch(vccServiceProvider);
          final hasHub = await vcc.checkHub();
          if (!hasHub) {
            return RequirementState.ng;
          }
          return RequirementState.ok;
        case RequirementState.ng:
        case RequirementState.notChecked:
          return RequirementState.notChecked;
      }
    },
    error: (error, stack) => Future.value(RequirementState.notChecked),
    loading: () => Future.value(RequirementState.notChecked),
  );
  return state;
});

final unityStateProvider = FutureProvider.autoDispose((ref) async {
  final hub = ref.watch(unityHubStateProvider);
  final state = hub.when(data: (data) async {
    switch (data) {
      case RequirementState.ok:
        final vcc = ref.watch(vccServiceProvider);
        if (!vcc.isInstalled()) {
          return RequirementState.notChecked;
        }
        final hasUnity = await vcc.checkUnity();
        if (!hasUnity) {
          return RequirementState.ng;
        }
        return RequirementState.ok;
      case RequirementState.ng:
      case RequirementState.notChecked:
        return RequirementState.notChecked;
    }
  }, error: (error, stack) {
    return Future.value(RequirementState.notChecked);
  }, loading: () {
    return Future.value(RequirementState.notChecked);
  });
  return state;
});
