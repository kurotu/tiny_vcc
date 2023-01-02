import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
