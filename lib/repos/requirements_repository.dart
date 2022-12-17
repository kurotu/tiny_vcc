import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tiny_vcc/services/dotnet_service.dart';
import 'package:tiny_vcc/services/unity_hub_service.dart';
import 'package:tiny_vcc/services/vcc_service.dart';

enum RequirementType {
  dotnet6,
  vpm,
  hub,
  unity,
}

class RequirementsRepository {
  RequirementsRepository(BuildContext context)
      : _dotnet = Provider.of(context, listen: false),
        _vcc = Provider.of(context, listen: false);

  final DotNetService _dotnet;
  final VccService _vcc;

  Future<RequirementType?> fetchMissingRequirement() async {
    final hasDotNet = await _dotnet.isInstalled();
    if (!hasDotNet) {
      return RequirementType.dotnet6;
    }
    final sdks = await _dotnet.listSdks();
    final sdk6Version = sdks.keys
        .firstWhere((v) => v.startsWith('6.'), orElse: () => 'missing');
    if (sdk6Version == 'missing') {
      return RequirementType.dotnet6;
    }

    final vpmVersion = await _vcc.getCliVersion();
    if (vpmVersion == null) {
      return RequirementType.vpm;
    }

    final hasHub = await _vcc.checkHub();
    if (!hasHub) {
      return RequirementType.hub;
    }

    final editors = await _vcc.getUnityEditors();
    if (editors.isEmpty) {
      return RequirementType.unity;
    }

    return null;
  }
}
