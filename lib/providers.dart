import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider((ref) => PackageInfo.fromPlatform());
final licenseNoticeProvider = FutureProvider(
    (ref) => rootBundle.loadString('assets/texts/LICENSE_NOTICE'));
