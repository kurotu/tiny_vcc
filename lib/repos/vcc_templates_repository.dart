import '../services/vcc_service.dart';

class VccTemplatesRepository {
  VccTemplatesRepository(VccService vcc) : _vcc = vcc;

  final VccService _vcc;

  Future<List<VpmTemplate>> fetchTemplates() async {
    final templates = await _vcc.getTemplates();
    templates.removeWhere((element) => element.name == 'Base');
    return templates;
  }
}
