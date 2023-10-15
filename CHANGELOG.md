# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- [macOS] Fix Unity installation not working on Apple Silicon.
- Fix Unity version check

## [0.5.0] - 2023-10-01

### Added

- Add Korean translation. (by [Kieaer](https://github.com/Kieaer))

## [0.4.0] - 2023-03-21

### Added

- Add dark theme.
- Add Japanese translation.
- Add Simplified Chinese translation. (by [Sonic853](https://github.com/Sonic853))

### Changed

- New layout for the main page.

## [0.3.0] - 2023-01-09

### Added

- Automate installation of required software.
- [Windows] Added installer, setup.exe.

### Changed

- New layout for required software page.

## [0.2.0] - 2023-01-04

### Added

- Add dark mode.
- Add new layouts for wide window size.
- Add menu to move project to the Recycle Bin or Trash.

### Changed

- Change internal state management to improve app responses.

### Fixed

- Fix app couldn't add StarterVPM project.
- Fix app couldn't start when settings.json of VCC is missng.
- [macOS] Fix backup folder select dialog not opended.

## [0.1.0] - 2022-12-31

### Added

- Add button to open settings folder in settings page.
- Add requirements page to show required software.
- Add logging feature. Logs are written to following folders.
    - Windows: `%USERPROFILE%\AppData\Loaming\kurotu\Tiny VCC\logs`
    - macOS: `~/Library/Application Support/com.github.kurotu.tiny-vcc/logs`
- Add button to detect installed Unity Editors.

### Changed

- Reduce times to execute Unity Hub for requirements check.

### Fixed

- Fix app crashed when adding AvatarGit or WorldGit project.
- Fix a case where app may crash even when .NET and VPM CLI are installed.
- Fix last project location not saved when creating a new project.

## [0.0.2] - 2022-12-22

### Fixed

- [macOS] Fix installed Unity editors not properly detected.
- Fix text fields of new project screen not properly working.
- Fix update checker not properly initialized.

## [0.0.1] - 2022-12-21

- Initial release.
