enum TinyVccThemeMode {
  system,
  light,
  dark,
}

enum RequirementState { ok, ng, notChecked }

class TinyVccSettings {
  TinyVccSettings({
    required this.themeMode,
    required this.locale,
  });

  TinyVccSettings.defaultValues()
      : themeMode = TinyVccThemeMode.system,
        locale = 'auto';

  final TinyVccThemeMode themeMode;
  final String locale;
}
