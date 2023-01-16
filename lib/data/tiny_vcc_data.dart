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
        locale = TinyVccLocale.auto;

  final TinyVccThemeMode themeMode;
  final TinyVccLocale locale;
}

enum TinyVccLocale {
  auto,
  en,
  ja,
}
