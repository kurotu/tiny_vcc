enum TinyVccThemeMode {
  light,
  dark,
  system,
}

class TinyVccSettings {
  TinyVccSettings({required this.themeMode});

  TinyVccSettings.defaultValues() : themeMode = TinyVccThemeMode.system;

  final TinyVccThemeMode themeMode;
}
