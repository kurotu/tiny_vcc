enum TinyVccThemeMode {
  light,
  dark,
  system,
}

enum RequirementState { ok, ng, notChecked }

class TinyVccSettings {
  TinyVccSettings({required this.themeMode});

  TinyVccSettings.defaultValues() : themeMode = TinyVccThemeMode.system;

  final TinyVccThemeMode themeMode;
}
