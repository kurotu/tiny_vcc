import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

import '../services/vcc_service.dart';

class VpmPackagesRepository {
  VpmPackagesRepository(BuildContext context)
      : _vcc = Provider.of(context, listen: false);

  final VccService _vcc;

  List<VpmPackage>? _packages;
  List<VpmPackage>? get packages => _packages;

  Future<List<VpmPackage>> fetchPackages({bool refresh = false}) async {
    if (_packages == null || refresh) {
      _packages = await _vcc.getVpmPackages();
    }
    return _packages!;
  }

  List<VpmPackage> getVersions(
      String name, Version? installedVersion, bool showPrerelease) {
    final list = _packages!.where((element) => element.name == name).toList();
    if (!showPrerelease) {
      list.removeWhere((element) =>
          element.version.isPreRelease && element.version != installedVersion);
    }
    list.sort(((a, b) => b.version.compareTo(a.version)));
    return list;
  }

  VpmPackage? getLatest(
      String name, Version? installedVersion, bool showPrerelease) {
    final versions = getVersions(name, installedVersion, showPrerelease);
    if (versions.isEmpty) {
      return null;
    }
    return versions.first;
  }
}
