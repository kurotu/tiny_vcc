import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

import '../services/dotnet_service.dart';
import '../services/vcc_service.dart';

class RequirementsRepository {
  RequirementsRepository(BuildContext context)
      : _dotnet = Provider.of(context, listen: false),
        _vcc = Provider.of(context, listen: false);

  final DotNetService _dotnet;
  final VccService _vcc;

  Future<bool> checkDotNetCommand() async {
    return _dotnet.isInstalled();
  }

  Future<bool> checkDotNet6Sdk() async {
    final sdks = await _dotnet.listSdks();
    const missingVersion = 'MISSING';
    final sdk6Version = sdks.keys
        .firstWhere((v) => v.startsWith('6.'), orElse: () => missingVersion);
    if (sdk6Version == missingVersion) {
      return false;
    }
    return true;
  }

  Future<bool> checkVpmCommand() async {
    return _vcc.isInstalled();
  }

  Future<bool> checkVpmVersion(Version requiredVersion) async {
    final version = await _vcc.getCliVersion();
    if (version < requiredVersion) {
      false;
    }
    return true;
  }

  Future<bool> checkUnityHub() async {
    return _vcc.checkHub();
  }

  Future<bool> checkUnity() async {
    return _vcc.checkUnity();
  }

  Future<void> installVpmCli(Version version) async {
    await _dotnet.installGlobalTool('vrchat.vpm.cli', version.toString());
    await _vcc.installTemplates();
    await _vcc.listRepos();
  }

  Future<void> updateVpmCli(Version version) async {
    await _dotnet.updateGlobalTool('vrchat.vpm.cli', version.toString());
    await _vcc.installTemplates();
    await _vcc.listRepos();
  }
}
