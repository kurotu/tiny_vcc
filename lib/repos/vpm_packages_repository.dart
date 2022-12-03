import 'package:tiny_vcc/services/vcc_service.dart';

class VpmPackagesRepository {
  VpmPackagesRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  List<VpmPackage>? _packages;
  List<VpmPackage>? get packages => _packages;

  Future<List<VpmPackage>> fetchPackages({bool refresh = false}) async {
    if (_packages == null || refresh) {
      _packages = await _vcc.getVpmPackages();
    }
    return _packages!;
  }

  List<VpmPackage> getVersions(String name) {
    final list = _packages!.where((element) => element.name == name).toList();
    list.sort(((a, b) => b.version.compareTo(a.version)));
    return list;
  }

  VpmPackage? getLatest(String name) {
    final versions = getVersions(name);
    if (versions.isEmpty) {
      return null;
    }
    return versions.first;
  }
}
