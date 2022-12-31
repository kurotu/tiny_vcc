import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'repos/vcc_settings_repository.dart';
import 'services/tiny_vcc_service.dart';
import 'services/unity_hub_service.dart';
import 'services/vcc_service.dart';

final packageInfoProvider = FutureProvider((ref) => PackageInfo.fromPlatform());
final licenseNoticeProvider = FutureProvider(
    (ref) => rootBundle.loadString('assets/texts/LICENSE_NOTICE'));

final unityHubServiceProvider = Provider((ref) => UnityHubService());
final vccServiceProvider =
    Provider((ref) => VccService.withHub(ref.read(unityHubServiceProvider)));
final vccSettingsRepoProvider = Provider.autoDispose((ref) {
  final vcc = ref.read(vccServiceProvider);
  return VccSettingsRepository.withoutContext(vcc);
});
final vccSettingsProvider = FutureProvider((ref) {
  return ref.read(vccSettingsRepoProvider).fetchSettings(refresh: true);
});

final tinyVccServiceProvider = Provider((ref) => TinyVccService());
