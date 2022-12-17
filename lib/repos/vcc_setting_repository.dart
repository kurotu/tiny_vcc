import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class VccSettingRepository {
  VccSettingRepository(BuildContext context)
      : _vcc = Provider.of(context, listen: false);

  final VccService _vcc;

  Version? _vpmVersion;
  Version? get vpmVersion => _vpmVersion;

  Future<Version> fetchCliVersion() async {
    _vpmVersion = await _vcc.getCliVersion();
    return _vpmVersion!;
  }
}
