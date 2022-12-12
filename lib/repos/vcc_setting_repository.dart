import 'package:pub_semver/pub_semver.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

class VccSettingRepository {
  VccSettingRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  Version? _vpmVersion;
  Version? get vpmVersion => _vpmVersion;

  Future<void> checkVpmCli() async {
    _vpmVersion = await _vcc.getVersion();
  }
}
