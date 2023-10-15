/// Generated file. Do not edit.
///
/// Locales: 4
/// Strings: 428 (107 per locale)
///
/// Built on 2023-10-15 at 07:20 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, StringsEn> {
	en(languageCode: 'en', build: StringsEn.build),
	ja(languageCode: 'ja', build: StringsJa.build),
	ko(languageCode: 'ko', build: StringsKo.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: StringsZhCn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, StringsEn> build;
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, StringsEn> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class StringsEn implements BaseTranslations<AppLocale, StringsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, StringsEn> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final StringsEn _root = this; // ignore: unused_field

	// Translations
	String get lang_name => 'English';
	late final StringsCommonEn common = StringsCommonEn._(_root);
	late final StringsNavigationEn navigation = StringsNavigationEn._(_root);
	late final StringsActionsEn actions = StringsActionsEn._(_root);
	late final StringsProjectsEn projects = StringsProjectsEn._(_root);
	late final StringsSettingsEn settings = StringsSettingsEn._(_root);
	late final StringsNewProjectEn new_project = StringsNewProjectEn._(_root);
	late final StringsProjectEn project = StringsProjectEn._(_root);
	late final StringsLegacyProjectEn legacy_project = StringsLegacyProjectEn._(_root);
	late final StringsRequirementsEn requirements = StringsRequirementsEn._(_root);
}

// Path: common
class StringsCommonEn {
	StringsCommonEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsCommonLabelsEn labels = StringsCommonLabelsEn._(_root);
}

// Path: navigation
class StringsNavigationEn {
	StringsNavigationEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get new_project => 'NEW PROJECT';
	String get projects => 'Projects';
	String get settings => 'Settings';
	String get about => 'About Tiny VCC';
}

// Path: actions
class StringsActionsEn {
	StringsActionsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsActionsAddProjectEn add_project = StringsActionsAddProjectEn._(_root);
	late final StringsActionsCreateProjectEn create_project = StringsActionsCreateProjectEn._(_root);
	late final StringsActionsOpenVccSettingsFolderEn open_vcc_settings_folder = StringsActionsOpenVccSettingsFolderEn._(_root);
	late final StringsActionsOpenLogsFolderEn open_logs_folder = StringsActionsOpenLogsFolderEn._(_root);
}

// Path: projects
class StringsProjectsEn {
	StringsProjectsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsProjectsLabelsEn labels = StringsProjectsLabelsEn._(_root);
	late final StringsProjectsDialogsEn dialogs = StringsProjectsDialogsEn._(_root);
	late final StringsProjectsInfoEn info = StringsProjectsInfoEn._(_root);
}

// Path: settings
class StringsSettingsEn {
	StringsSettingsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsSettingsHeadersEn headers = StringsSettingsHeadersEn._(_root);
	late final StringsSettingsLabelsEn labels = StringsSettingsLabelsEn._(_root);
	late final StringsSettingsThemeEn theme = StringsSettingsThemeEn._(_root);
	late final StringsSettingsLangEn lang = StringsSettingsLangEn._(_root);
}

// Path: new_project
class StringsNewProjectEn {
	StringsNewProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'New Project';
	late final StringsNewProjectLabelsEn labels = StringsNewProjectLabelsEn._(_root);
	late final StringsNewProjectErrorsEn errors = StringsNewProjectErrorsEn._(_root);
	late final StringsNewProjectInfoEn info = StringsNewProjectInfoEn._(_root);
}

// Path: project
class StringsProjectEn {
	StringsProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsProjectLabelsEn labels = StringsProjectLabelsEn._(_root);
	late final StringsProjectInfoEn info = StringsProjectInfoEn._(_root);
	late final StringsProjectDialogsEn dialogs = StringsProjectDialogsEn._(_root);
}

// Path: legacy_project
class StringsLegacyProjectEn {
	StringsLegacyProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsLegacyProjectLabelsEn labels = StringsLegacyProjectLabelsEn._(_root);
	late final StringsLegacyProjectDialogsEn dialogs = StringsLegacyProjectDialogsEn._(_root);
}

// Path: requirements
class StringsRequirementsEn {
	StringsRequirementsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Requirements';
	late final StringsRequirementsLabelsEn labels = StringsRequirementsLabelsEn._(_root);
	late final StringsRequirementsInfoEn info = StringsRequirementsInfoEn._(_root);
	late final StringsRequirementsDescriptionEn description = StringsRequirementsDescriptionEn._(_root);
	late final StringsRequirementsErrorsEn errors = StringsRequirementsErrorsEn._(_root);
}

// Path: common.labels
class StringsCommonLabelsEn {
	StringsCommonLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get yes => 'Yes';
	String get no => 'No';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get dismiss => 'Dismiss';
}

// Path: actions.add_project
class StringsActionsAddProjectEn {
	StringsActionsAddProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Add existing project';
}

// Path: actions.create_project
class StringsActionsCreateProjectEn {
	StringsActionsCreateProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Create new project';
}

// Path: actions.open_vcc_settings_folder
class StringsActionsOpenVccSettingsFolderEn {
	StringsActionsOpenVccSettingsFolderEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get label => 'Open VCC Settings Folder';
}

// Path: actions.open_logs_folder
class StringsActionsOpenLogsFolderEn {
	StringsActionsOpenLogsFolderEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get label => 'Open Logs Folder';
}

// Path: projects.labels
class StringsProjectsLabelsEn {
	StringsProjectsLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get open_folder => 'Open Folder';
	String get remove_from_list => 'Remove from list';
	String get move_to_recycle_bin => 'Move to Recycle Bin';
	String get move_to_trash => 'Move to Trash';
}

// Path: projects.dialogs
class StringsProjectsDialogsEn {
	StringsProjectsDialogsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsProjectsDialogsRemoveProjectEn remove_project = StringsProjectsDialogsRemoveProjectEn._(_root);
}

// Path: projects.info
class StringsProjectsInfoEn {
	StringsProjectsInfoEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String failed_to_remove({required Object projectPath}) => 'Failed to remove ${projectPath}.';
	String error_project_not_supported({required Object path}) => 'Project "${path}" is not supported.';
	String get error_add_project => 'Error occurred when adding a project.';
	String error_project_not_exist({required Object projectPath}) => '${projectPath} does not exist.';
	String avatar_git_not_supported({required Object projectPath}) => 'Avatar Git project (${projectPath}) is not supported in Tiny VCC.';
	String world_git_not_supported({required Object projectPath}) => 'World Git project (${projectPath}) is not supported in Tiny VCC.';
	String project_is_sdk2({required Object projectPath}) => '${projectPath} is VRCSDK2 project.';
	String project_is_invalid({required Object projectPath}) => '${projectPath} is invalid project.';
}

// Path: settings.headers
class StringsSettingsHeadersEn {
	StringsSettingsHeadersEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get tiny_vcc_preferences => 'Tiny VCC Preferences';
	String get vcc_settings => 'VCC Settings';
}

// Path: settings.labels
class StringsSettingsLabelsEn {
	StringsSettingsLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get theme => 'Theme';
	String get language => 'Language';
	String get unity_editors => 'Unity Editors';
	String get backups => 'Backups';
	String get user_packages => 'User Packages';
}

// Path: settings.theme
class StringsSettingsThemeEn {
	StringsSettingsThemeEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get auto => 'Auto';
	String get light => 'Light';
	String get dark => 'Dark';
}

// Path: settings.lang
class StringsSettingsLangEn {
	StringsSettingsLangEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get auto => 'Auto';
}

// Path: new_project.labels
class StringsNewProjectLabelsEn {
	StringsNewProjectLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get project_template => 'Project Template';
	String get project_name => 'Project Name';
	String get location => 'Location';
	String get create => 'Create';
}

// Path: new_project.errors
class StringsNewProjectErrorsEn {
	StringsNewProjectErrorsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get select_project_template => 'Please select project template.';
	String get enter_project_name => 'Please enter project name.';
	String get enter_location_path => 'Please enter location path.';
	String get failed_to_create_project => 'Failed to create project.';
}

// Path: new_project.info
class StringsNewProjectInfoEn {
	StringsNewProjectInfoEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String creating_project({required Object template, required Object name, required Object location}) => 'Creating ${template} project, "${name}" at ${location}.';
	String created_project({required Object template, required Object name, required Object projectLocation}) => '${template} project, "${name}" has been created at ${projectLocation}.';
}

// Path: project.labels
class StringsProjectLabelsEn {
	StringsProjectLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get open_project => 'Open Project';
	String get open_folder => 'Open Folder';
	String get make_backup => 'Make Backup';
	String get add => 'Add';
	String get update => 'Update';
	String get downgrade => 'Downgrade';
	String get remove => 'Remove';
}

// Path: project.info
class StringsProjectInfoEn {
	StringsProjectInfoEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get packages_changed => 'Packages have been changed. Close and reopen Unity project to apply changes.';
	String unity_not_found({required Object editorVersion}) => 'Unity ${editorVersion} not found in VCC settings.';
}

// Path: project.dialogs
class StringsProjectDialogsEn {
	StringsProjectDialogsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsProjectDialogsProgressBackupEn progress_backup = StringsProjectDialogsProgressBackupEn._(_root);
	late final StringsProjectDialogsMadeBackupEn made_backup = StringsProjectDialogsMadeBackupEn._(_root);
	late final StringsProjectDialogsBackupErrorEn backup_error = StringsProjectDialogsBackupErrorEn._(_root);
}

// Path: legacy_project.labels
class StringsLegacyProjectLabelsEn {
	StringsLegacyProjectLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get migrate => 'Migrate';
	String get open_folder => 'Open Folder';
	String get make_backup => 'Make Backup';
}

// Path: legacy_project.dialogs
class StringsLegacyProjectDialogsEn {
	StringsLegacyProjectDialogsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	late final StringsLegacyProjectDialogsConfirmEn confirm = StringsLegacyProjectDialogsConfirmEn._(_root);
	late final StringsLegacyProjectDialogsProgressBackupEn progress_backup = StringsLegacyProjectDialogsProgressBackupEn._(_root);
	late final StringsLegacyProjectDialogsMadeBackupEn made_backup = StringsLegacyProjectDialogsMadeBackupEn._(_root);
	late final StringsLegacyProjectDialogsBackupErrorEn backup_error = StringsLegacyProjectDialogsBackupErrorEn._(_root);
	late final StringsLegacyProjectDialogsProgressMigrationEn progress_migration = StringsLegacyProjectDialogsProgressMigrationEn._(_root);
}

// Path: requirements.labels
class StringsRequirementsLabelsEn {
	StringsRequirementsLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get dotnet6sdk => '.NET 6.0 SDK';
	String get vpm_cli => 'VPM CLI';
	String get unity_hub => 'Unity Hub';
	String get unity => 'Unity';
	String get install => 'Install';
	String get check_again => 'Check again';
}

// Path: requirements.info
class StringsRequirementsInfoEn {
	StringsRequirementsInfoEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get downloading_dotnet => 'Downloading .NET 6.0 SDK installer.';
	String get installing_dotnet => 'Installing .NET 6.0 SDK.';
	String get installing_dotnet_with_brew => 'Installing .NET 6.0 SDK with Homebrew';
	String get see_terminal_to_continue => 'See Terminal app to continue installation.';
	String get installing_vpm => 'Installing VPM CLI';
	String get downloading_unity_hub => 'Downloading Unity Hub installer.';
	String get installing_unity_hub => 'Installing Unity Hub.';
	String get installing_unity => 'Installing Unity';
}

// Path: requirements.description
class StringsRequirementsDescriptionEn {
	StringsRequirementsDescriptionEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get dotnet => 'Install .NET 6.0 SDK. You can also download the SDK installer from web.';
	String get dotnet_brew => 'Install .NET 6.0 SDK with Homebrew. You can also install with following command.';
	String get dotnet_linux => 'Install .NET 6.0 SDK with package manager. See instruction below.';
	String get vpm => 'Install VPM CLI. You can also install with following command.';
	String get unity_hub => 'Install Unity Hub. You can also download the installer from web.';
	String get unity_hub_linux => 'Install Unity Hub. See instruction below.';
	String get unity => 'Install Unity with Unity Hub. You can also install from archive, but you should install the exact version which VRChat specifies.';
	String get unity_modules => 'In manual installation, you must install some modules together:';
	String get unity_modules_android => 'Android Build Support (to upload for Quest)';
	String get unity_modules_mono => 'Windows Build Support (mono) (to upload for PC from macOS or Linux)';
}

// Path: requirements.errors
class StringsRequirementsErrorsEn {
	StringsRequirementsErrorsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get failed_to_isntall_dotnet => 'Failed to install .NET SDK';
	String get failed_to_isntall_vpm => 'Failed to install VPM CLI';
	String get failed_to_isntall_unity_hub => 'Failed to install Unity Hub';
	String get failed_to_isntall_unity => 'Failed to install Unity';
}

// Path: projects.dialogs.remove_project
class StringsProjectsDialogsRemoveProjectEn {
	StringsProjectsDialogsRemoveProjectEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String title({required Object projectName}) => 'Remove ${projectName}';
	String content_win({required Object projectPath}) => 'Are you sure you want to move ${projectPath} to the Recycle Bin?';
	String content_others({required Object projectPath}) => 'Are you sure you want to move ${projectPath} to the Trash?';
}

// Path: project.dialogs.progress_backup
class StringsProjectDialogsProgressBackupEn {
	StringsProjectDialogsProgressBackupEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String title({required Object name}) => 'Backing up ${name}';
}

// Path: project.dialogs.made_backup
class StringsProjectDialogsMadeBackupEn {
	StringsProjectDialogsMadeBackupEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Made Backup';
	late final StringsProjectDialogsMadeBackupLabelsEn labels = StringsProjectDialogsMadeBackupLabelsEn._(_root);
}

// Path: project.dialogs.backup_error
class StringsProjectDialogsBackupErrorEn {
	StringsProjectDialogsBackupErrorEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Backup Error';
	String content({required Object projectName, required Object error}) => 'Failed to back up ${projectName}.\n\n${error}';
}

// Path: legacy_project.dialogs.confirm
class StringsLegacyProjectDialogsConfirmEn {
	StringsLegacyProjectDialogsConfirmEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Project Migration';
	String get content => 'Migration is needed.';
	late final StringsLegacyProjectDialogsConfirmLabelsEn labels = StringsLegacyProjectDialogsConfirmLabelsEn._(_root);
}

// Path: legacy_project.dialogs.progress_backup
class StringsLegacyProjectDialogsProgressBackupEn {
	StringsLegacyProjectDialogsProgressBackupEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String title({required Object name}) => 'Backing up ${name}';
}

// Path: legacy_project.dialogs.made_backup
class StringsLegacyProjectDialogsMadeBackupEn {
	StringsLegacyProjectDialogsMadeBackupEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Made Backup';
	late final StringsLegacyProjectDialogsMadeBackupLabelsEn labels = StringsLegacyProjectDialogsMadeBackupLabelsEn._(_root);
}

// Path: legacy_project.dialogs.backup_error
class StringsLegacyProjectDialogsBackupErrorEn {
	StringsLegacyProjectDialogsBackupErrorEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Backup Error';
	String content({required Object projectName, required Object error}) => 'Failed to back up ${projectName}.\n\n${error}';
}

// Path: legacy_project.dialogs.progress_migration
class StringsLegacyProjectDialogsProgressMigrationEn {
	StringsLegacyProjectDialogsProgressMigrationEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String title({required Object name}) => 'Migrating ${name}';
}

// Path: project.dialogs.made_backup.labels
class StringsProjectDialogsMadeBackupLabelsEn {
	StringsProjectDialogsMadeBackupLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get show_me => 'Show Me';
}

// Path: legacy_project.dialogs.confirm.labels
class StringsLegacyProjectDialogsConfirmLabelsEn {
	StringsLegacyProjectDialogsConfirmLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get migrate_a_copy => 'Migrate a copy';
	String get migrate_in_place => 'Migrate in place\nI HAVE A BACKUP';
}

// Path: legacy_project.dialogs.made_backup.labels
class StringsLegacyProjectDialogsMadeBackupLabelsEn {
	StringsLegacyProjectDialogsMadeBackupLabelsEn._(this._root);

	final StringsEn _root; // ignore: unused_field

	// Translations
	String get show_me => 'Show Me';
}

// Path: <root>
class StringsJa extends StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	StringsJa.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, StringsEn> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final StringsJa _root = this; // ignore: unused_field

	// Translations
	@override String get lang_name => '日本語';
	@override late final StringsCommonJa common = StringsCommonJa._(_root);
	@override late final StringsNavigationJa navigation = StringsNavigationJa._(_root);
	@override late final StringsActionsJa actions = StringsActionsJa._(_root);
	@override late final StringsProjectsJa projects = StringsProjectsJa._(_root);
	@override late final StringsSettingsJa settings = StringsSettingsJa._(_root);
	@override late final StringsNewProjectJa new_project = StringsNewProjectJa._(_root);
	@override late final StringsProjectJa project = StringsProjectJa._(_root);
	@override late final StringsLegacyProjectJa legacy_project = StringsLegacyProjectJa._(_root);
	@override late final StringsRequirementsJa requirements = StringsRequirementsJa._(_root);
}

// Path: common
class StringsCommonJa extends StringsCommonEn {
	StringsCommonJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsCommonLabelsJa labels = StringsCommonLabelsJa._(_root);
}

// Path: navigation
class StringsNavigationJa extends StringsNavigationEn {
	StringsNavigationJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get new_project => '新規プロジェクト';
	@override String get projects => 'プロジェクト';
	@override String get settings => '設定';
	@override String get about => 'Tiny VCC について';
}

// Path: actions
class StringsActionsJa extends StringsActionsEn {
	StringsActionsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsActionsAddProjectJa add_project = StringsActionsAddProjectJa._(_root);
	@override late final StringsActionsCreateProjectJa create_project = StringsActionsCreateProjectJa._(_root);
	@override late final StringsActionsOpenVccSettingsFolderJa open_vcc_settings_folder = StringsActionsOpenVccSettingsFolderJa._(_root);
	@override late final StringsActionsOpenLogsFolderJa open_logs_folder = StringsActionsOpenLogsFolderJa._(_root);
}

// Path: projects
class StringsProjectsJa extends StringsProjectsEn {
	StringsProjectsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsLabelsJa labels = StringsProjectsLabelsJa._(_root);
	@override late final StringsProjectsDialogsJa dialogs = StringsProjectsDialogsJa._(_root);
	@override late final StringsProjectsInfoJa info = StringsProjectsInfoJa._(_root);
}

// Path: settings
class StringsSettingsJa extends StringsSettingsEn {
	StringsSettingsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsSettingsHeadersJa headers = StringsSettingsHeadersJa._(_root);
	@override late final StringsSettingsLabelsJa labels = StringsSettingsLabelsJa._(_root);
	@override late final StringsSettingsThemeJa theme = StringsSettingsThemeJa._(_root);
	@override late final StringsSettingsLangJa lang = StringsSettingsLangJa._(_root);
}

// Path: new_project
class StringsNewProjectJa extends StringsNewProjectEn {
	StringsNewProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '新規プロジェクト';
	@override late final StringsNewProjectLabelsJa labels = StringsNewProjectLabelsJa._(_root);
	@override late final StringsNewProjectErrorsJa errors = StringsNewProjectErrorsJa._(_root);
	@override late final StringsNewProjectInfoJa info = StringsNewProjectInfoJa._(_root);
}

// Path: project
class StringsProjectJa extends StringsProjectEn {
	StringsProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectLabelsJa labels = StringsProjectLabelsJa._(_root);
	@override late final StringsProjectInfoJa info = StringsProjectInfoJa._(_root);
	@override late final StringsProjectDialogsJa dialogs = StringsProjectDialogsJa._(_root);
}

// Path: legacy_project
class StringsLegacyProjectJa extends StringsLegacyProjectEn {
	StringsLegacyProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectLabelsJa labels = StringsLegacyProjectLabelsJa._(_root);
	@override late final StringsLegacyProjectDialogsJa dialogs = StringsLegacyProjectDialogsJa._(_root);
}

// Path: requirements
class StringsRequirementsJa extends StringsRequirementsEn {
	StringsRequirementsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '必須ソフトウェア';
	@override late final StringsRequirementsLabelsJa labels = StringsRequirementsLabelsJa._(_root);
	@override late final StringsRequirementsInfoJa info = StringsRequirementsInfoJa._(_root);
	@override late final StringsRequirementsDescriptionJa description = StringsRequirementsDescriptionJa._(_root);
	@override late final StringsRequirementsErrorsJa errors = StringsRequirementsErrorsJa._(_root);
}

// Path: common.labels
class StringsCommonLabelsJa extends StringsCommonLabelsEn {
	StringsCommonLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get yes => 'はい';
	@override String get no => 'いいえ';
	@override String get ok => 'OK';
	@override String get cancel => 'キャンセル';
	@override String get dismiss => '閉じる';
}

// Path: actions.add_project
class StringsActionsAddProjectJa extends StringsActionsAddProjectEn {
	StringsActionsAddProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '既存プロジェクトを追加';
}

// Path: actions.create_project
class StringsActionsCreateProjectJa extends StringsActionsCreateProjectEn {
	StringsActionsCreateProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '新規プロジェクトを作成';
}

// Path: actions.open_vcc_settings_folder
class StringsActionsOpenVccSettingsFolderJa extends StringsActionsOpenVccSettingsFolderEn {
	StringsActionsOpenVccSettingsFolderJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'VCC の設定フォルダーを開く';
}

// Path: actions.open_logs_folder
class StringsActionsOpenLogsFolderJa extends StringsActionsOpenLogsFolderEn {
	StringsActionsOpenLogsFolderJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ログフォルダーを開く';
}

// Path: projects.labels
class StringsProjectsLabelsJa extends StringsProjectsLabelsEn {
	StringsProjectsLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get open_folder => 'フォルダーを開く';
	@override String get remove_from_list => 'リストから削除';
	@override String get move_to_recycle_bin => 'ごみ箱に移動';
	@override String get move_to_trash => 'ごみ箱に移動';
}

// Path: projects.dialogs
class StringsProjectsDialogsJa extends StringsProjectsDialogsEn {
	StringsProjectsDialogsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsDialogsRemoveProjectJa remove_project = StringsProjectsDialogsRemoveProjectJa._(_root);
}

// Path: projects.info
class StringsProjectsInfoJa extends StringsProjectsInfoEn {
	StringsProjectsInfoJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String failed_to_remove({required Object projectPath}) => '${projectPath} を削除できませんでした。';
	@override String error_project_not_supported({required Object path}) => 'プロジェクト "${path}" はサポートされていません。';
	@override String get error_add_project => 'プロジェクトの追加でエラーが発生しました。';
	@override String error_project_not_exist({required Object projectPath}) => '${projectPath} が見つかりません。';
	@override String avatar_git_not_supported({required Object projectPath}) => 'Avatar Git プロジェクト (${projectPath}) は Tiny VCC ではサポートされていません。';
	@override String world_git_not_supported({required Object projectPath}) => 'World Git プロジェクト (${projectPath}) は Tiny VCC ではサポートされていません。';
	@override String project_is_sdk2({required Object projectPath}) => '${projectPath} は VRCSDK2 プロジェクトです。';
	@override String project_is_invalid({required Object projectPath}) => '${projectPath} は不正なプロジェクトです。';
}

// Path: settings.headers
class StringsSettingsHeadersJa extends StringsSettingsHeadersEn {
	StringsSettingsHeadersJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get tiny_vcc_preferences => 'Tiny VCC 設定';
	@override String get vcc_settings => 'VCC 設定';
}

// Path: settings.labels
class StringsSettingsLabelsJa extends StringsSettingsLabelsEn {
	StringsSettingsLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get theme => 'テーマ';
	@override String get language => '言語';
	@override String get unity_editors => 'Unity エディター';
	@override String get backups => 'バックアップ';
	@override String get user_packages => 'ユーザーパッケージ';
}

// Path: settings.theme
class StringsSettingsThemeJa extends StringsSettingsThemeEn {
	StringsSettingsThemeJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get auto => '自動';
	@override String get light => 'ライト';
	@override String get dark => 'ダーク';
}

// Path: settings.lang
class StringsSettingsLangJa extends StringsSettingsLangEn {
	StringsSettingsLangJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get auto => '自動';
}

// Path: new_project.labels
class StringsNewProjectLabelsJa extends StringsNewProjectLabelsEn {
	StringsNewProjectLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get project_template => 'プロジェクトテンプレート';
	@override String get project_name => 'プロジェクト名';
	@override String get location => '保存先';
	@override String get create => '作成';
}

// Path: new_project.errors
class StringsNewProjectErrorsJa extends StringsNewProjectErrorsEn {
	StringsNewProjectErrorsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get select_project_template => 'テンプレートを選択してください。';
	@override String get enter_project_name => 'プロジェクト名を入力してください。';
	@override String get enter_location_path => '保存先を選択してください。';
	@override String get failed_to_create_project => 'プロジェクトの作成に失敗しました。';
}

// Path: new_project.info
class StringsNewProjectInfoJa extends StringsNewProjectInfoEn {
	StringsNewProjectInfoJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String creating_project({required Object template, required Object name, required Object location}) => '${template} プロジェクト "${name}" を ${location} に作成しています。';
	@override String created_project({required Object template, required Object name, required Object projectLocation}) => '${template} プロジェクト "${name}" が ${projectLocation} に作成されました。';
}

// Path: project.labels
class StringsProjectLabelsJa extends StringsProjectLabelsEn {
	StringsProjectLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get open_project => 'プロジェクトを開く';
	@override String get open_folder => 'フォルダーを開く';
	@override String get make_backup => 'バックアップを作成';
	@override String get add => '追加';
	@override String get update => '更新';
	@override String get downgrade => 'ダウングレード';
	@override String get remove => '削除';
}

// Path: project.info
class StringsProjectInfoJa extends StringsProjectInfoEn {
	StringsProjectInfoJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get packages_changed => 'パッケージが変更されました。Unity を閉じて開きなおしてください。';
	@override String unity_not_found({required Object editorVersion}) => 'VCC 設定に Unity ${editorVersion} が見つかりません。';
}

// Path: project.dialogs
class StringsProjectDialogsJa extends StringsProjectDialogsEn {
	StringsProjectDialogsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectDialogsProgressBackupJa progress_backup = StringsProjectDialogsProgressBackupJa._(_root);
	@override late final StringsProjectDialogsMadeBackupJa made_backup = StringsProjectDialogsMadeBackupJa._(_root);
	@override late final StringsProjectDialogsBackupErrorJa backup_error = StringsProjectDialogsBackupErrorJa._(_root);
}

// Path: legacy_project.labels
class StringsLegacyProjectLabelsJa extends StringsLegacyProjectLabelsEn {
	StringsLegacyProjectLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get migrate => '移行';
	@override String get open_folder => 'フォルダーを開く';
	@override String get make_backup => 'バックアップを作成';
}

// Path: legacy_project.dialogs
class StringsLegacyProjectDialogsJa extends StringsLegacyProjectDialogsEn {
	StringsLegacyProjectDialogsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectDialogsConfirmJa confirm = StringsLegacyProjectDialogsConfirmJa._(_root);
	@override late final StringsLegacyProjectDialogsProgressBackupJa progress_backup = StringsLegacyProjectDialogsProgressBackupJa._(_root);
	@override late final StringsLegacyProjectDialogsMadeBackupJa made_backup = StringsLegacyProjectDialogsMadeBackupJa._(_root);
	@override late final StringsLegacyProjectDialogsBackupErrorJa backup_error = StringsLegacyProjectDialogsBackupErrorJa._(_root);
	@override late final StringsLegacyProjectDialogsProgressMigrationJa progress_migration = StringsLegacyProjectDialogsProgressMigrationJa._(_root);
}

// Path: requirements.labels
class StringsRequirementsLabelsJa extends StringsRequirementsLabelsEn {
	StringsRequirementsLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get dotnet6sdk => '.NET 6.0 SDK';
	@override String get vpm_cli => 'VPM CLI';
	@override String get unity_hub => 'Unity Hub';
	@override String get unity => 'Unity';
	@override String get install => 'インストール';
	@override String get check_again => '再確認';
}

// Path: requirements.info
class StringsRequirementsInfoJa extends StringsRequirementsInfoEn {
	StringsRequirementsInfoJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get downloading_dotnet => '.NET 6.0 SDK インストーラーをダウンロードしています。';
	@override String get installing_dotnet => '.NET 6.0 SDK をインストールしています。';
	@override String get installing_dotnet_with_brew => '.NET 6.0 SDK を Homebrew でインストール中';
	@override String get see_terminal_to_continue => '「ターミナル」アプリを確認してください。';
	@override String get installing_vpm => 'VPM CLI をインストールしています。';
	@override String get downloading_unity_hub => 'Unity Hub インストーラーをダウンロードしています。';
	@override String get installing_unity_hub => 'Unity Hub をインストールしています。';
	@override String get installing_unity => 'Unity をインストール中';
}

// Path: requirements.description
class StringsRequirementsDescriptionJa extends StringsRequirementsDescriptionEn {
	StringsRequirementsDescriptionJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get dotnet => '.NET 6.0 SDK をインストールします。Web から SDK インストーラーをダウンロードすることもできます。';
	@override String get dotnet_brew => '.NET 6.0 SDK を Homebrew でインストールします。次のコマンドでインストールすることもできます。';
	@override String get dotnet_linux => '.NET 6.0 SDK をパッケージマネージャーでインストールします。次の説明を参照してください。';
	@override String get vpm => 'VPM CLI をインストールします。次のコマンドでインストールすることもできます。';
	@override String get unity_hub => 'Unity Hub をインストールします。Web からインストーラーをダウンロードすることもできます。';
	@override String get unity_hub_linux => 'Unity Hub をインストールします。次の説明を参照してください。';
	@override String get unity => 'Unity を Unity Hub でインストールします。アーカイブからインストールすることもできますが、VRChat が指定するバージョンをインストールする必要があります。';
	@override String get unity_modules => '手動でインストールする場合、次のモジュールのインストールが必要です。';
	@override String get unity_modules_android => 'Android Build Support (Quest 用にアップロードする場合)';
	@override String get unity_modules_mono => 'Windows Build Support (mono) (macOS または Linux から PC 用にアップロードする場合)';
}

// Path: requirements.errors
class StringsRequirementsErrorsJa extends StringsRequirementsErrorsEn {
	StringsRequirementsErrorsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get failed_to_isntall_dotnet => '.NET SDK のインストールに失敗しました。';
	@override String get failed_to_isntall_vpm => 'VPM CLI のインストールに失敗しました。';
	@override String get failed_to_isntall_unity_hub => 'Unity Hub のインストールに失敗しました。';
	@override String get failed_to_isntall_unity => 'Unity のインストールに失敗しました。';
}

// Path: projects.dialogs.remove_project
class StringsProjectsDialogsRemoveProjectJa extends StringsProjectsDialogsRemoveProjectEn {
	StringsProjectsDialogsRemoveProjectJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object projectName}) => '${projectName} の削除';
	@override String content_win({required Object projectPath}) => '${projectPath} をごみ箱に移動しますか？';
	@override String content_others({required Object projectPath}) => '${projectPath} をごみ箱に移動しますか？';
}

// Path: project.dialogs.progress_backup
class StringsProjectDialogsProgressBackupJa extends StringsProjectDialogsProgressBackupEn {
	StringsProjectDialogsProgressBackupJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} をバックアップ中';
}

// Path: project.dialogs.made_backup
class StringsProjectDialogsMadeBackupJa extends StringsProjectDialogsMadeBackupEn {
	StringsProjectDialogsMadeBackupJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'バックアップの作成完了';
	@override late final StringsProjectDialogsMadeBackupLabelsJa labels = StringsProjectDialogsMadeBackupLabelsJa._(_root);
}

// Path: project.dialogs.backup_error
class StringsProjectDialogsBackupErrorJa extends StringsProjectDialogsBackupErrorEn {
	StringsProjectDialogsBackupErrorJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'バックアップエラー';
	@override String content({required Object projectName, required Object error}) => '${projectName} のバックアップに失敗しました。\n\n${error}';
}

// Path: legacy_project.dialogs.confirm
class StringsLegacyProjectDialogsConfirmJa extends StringsLegacyProjectDialogsConfirmEn {
	StringsLegacyProjectDialogsConfirmJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プロジェクトの移行';
	@override String get content => 'プロジェクトを移行する必要があります。';
	@override late final StringsLegacyProjectDialogsConfirmLabelsJa labels = StringsLegacyProjectDialogsConfirmLabelsJa._(_root);
}

// Path: legacy_project.dialogs.progress_backup
class StringsLegacyProjectDialogsProgressBackupJa extends StringsLegacyProjectDialogsProgressBackupEn {
	StringsLegacyProjectDialogsProgressBackupJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} をバックアップ中';
}

// Path: legacy_project.dialogs.made_backup
class StringsLegacyProjectDialogsMadeBackupJa extends StringsLegacyProjectDialogsMadeBackupEn {
	StringsLegacyProjectDialogsMadeBackupJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'バックアップの作成完了';
	@override late final StringsLegacyProjectDialogsMadeBackupLabelsJa labels = StringsLegacyProjectDialogsMadeBackupLabelsJa._(_root);
}

// Path: legacy_project.dialogs.backup_error
class StringsLegacyProjectDialogsBackupErrorJa extends StringsLegacyProjectDialogsBackupErrorEn {
	StringsLegacyProjectDialogsBackupErrorJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'バックアップエラー';
	@override String content({required Object projectName, required Object error}) => '${projectName} のバックアップに失敗しました。\n\n${error}';
}

// Path: legacy_project.dialogs.progress_migration
class StringsLegacyProjectDialogsProgressMigrationJa extends StringsLegacyProjectDialogsProgressMigrationEn {
	StringsLegacyProjectDialogsProgressMigrationJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} を移行中';
}

// Path: project.dialogs.made_backup.labels
class StringsProjectDialogsMadeBackupLabelsJa extends StringsProjectDialogsMadeBackupLabelsEn {
	StringsProjectDialogsMadeBackupLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get show_me => '表示';
}

// Path: legacy_project.dialogs.confirm.labels
class StringsLegacyProjectDialogsConfirmLabelsJa extends StringsLegacyProjectDialogsConfirmLabelsEn {
	StringsLegacyProjectDialogsConfirmLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get migrate_a_copy => 'コピーを作成して移行';
	@override String get migrate_in_place => 'バックアップがあるのでそのまま移行';
}

// Path: legacy_project.dialogs.made_backup.labels
class StringsLegacyProjectDialogsMadeBackupLabelsJa extends StringsLegacyProjectDialogsMadeBackupLabelsEn {
	StringsLegacyProjectDialogsMadeBackupLabelsJa._(StringsJa root) : this._root = root, super._(root);

	@override final StringsJa _root; // ignore: unused_field

	// Translations
	@override String get show_me => '表示';
}

// Path: <root>
class StringsKo extends StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	StringsKo.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, StringsEn> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final StringsKo _root = this; // ignore: unused_field

	// Translations
	@override String get lang_name => '한국어';
	@override late final StringsCommonKo common = StringsCommonKo._(_root);
	@override late final StringsNavigationKo navigation = StringsNavigationKo._(_root);
	@override late final StringsActionsKo actions = StringsActionsKo._(_root);
	@override late final StringsProjectsKo projects = StringsProjectsKo._(_root);
	@override late final StringsSettingsKo settings = StringsSettingsKo._(_root);
	@override late final StringsNewProjectKo new_project = StringsNewProjectKo._(_root);
	@override late final StringsProjectKo project = StringsProjectKo._(_root);
	@override late final StringsLegacyProjectKo legacy_project = StringsLegacyProjectKo._(_root);
	@override late final StringsRequirementsKo requirements = StringsRequirementsKo._(_root);
}

// Path: common
class StringsCommonKo extends StringsCommonEn {
	StringsCommonKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsCommonLabelsKo labels = StringsCommonLabelsKo._(_root);
}

// Path: navigation
class StringsNavigationKo extends StringsNavigationEn {
	StringsNavigationKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get new_project => '새 프로젝트';
	@override String get projects => '프로젝트';
	@override String get settings => '설정';
	@override String get about => 'Tiny VCC에 대하여';
}

// Path: actions
class StringsActionsKo extends StringsActionsEn {
	StringsActionsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsActionsAddProjectKo add_project = StringsActionsAddProjectKo._(_root);
	@override late final StringsActionsCreateProjectKo create_project = StringsActionsCreateProjectKo._(_root);
	@override late final StringsActionsOpenVccSettingsFolderKo open_vcc_settings_folder = StringsActionsOpenVccSettingsFolderKo._(_root);
	@override late final StringsActionsOpenLogsFolderKo open_logs_folder = StringsActionsOpenLogsFolderKo._(_root);
}

// Path: projects
class StringsProjectsKo extends StringsProjectsEn {
	StringsProjectsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsLabelsKo labels = StringsProjectsLabelsKo._(_root);
	@override late final StringsProjectsDialogsKo dialogs = StringsProjectsDialogsKo._(_root);
	@override late final StringsProjectsInfoKo info = StringsProjectsInfoKo._(_root);
}

// Path: settings
class StringsSettingsKo extends StringsSettingsEn {
	StringsSettingsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsSettingsHeadersKo headers = StringsSettingsHeadersKo._(_root);
	@override late final StringsSettingsLabelsKo labels = StringsSettingsLabelsKo._(_root);
	@override late final StringsSettingsThemeKo theme = StringsSettingsThemeKo._(_root);
	@override late final StringsSettingsLangKo lang = StringsSettingsLangKo._(_root);
}

// Path: new_project
class StringsNewProjectKo extends StringsNewProjectEn {
	StringsNewProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '새 프로젝트';
	@override late final StringsNewProjectLabelsKo labels = StringsNewProjectLabelsKo._(_root);
	@override late final StringsNewProjectErrorsKo errors = StringsNewProjectErrorsKo._(_root);
	@override late final StringsNewProjectInfoKo info = StringsNewProjectInfoKo._(_root);
}

// Path: project
class StringsProjectKo extends StringsProjectEn {
	StringsProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectLabelsKo labels = StringsProjectLabelsKo._(_root);
	@override late final StringsProjectInfoKo info = StringsProjectInfoKo._(_root);
	@override late final StringsProjectDialogsKo dialogs = StringsProjectDialogsKo._(_root);
}

// Path: legacy_project
class StringsLegacyProjectKo extends StringsLegacyProjectEn {
	StringsLegacyProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectLabelsKo labels = StringsLegacyProjectLabelsKo._(_root);
	@override late final StringsLegacyProjectDialogsKo dialogs = StringsLegacyProjectDialogsKo._(_root);
}

// Path: requirements
class StringsRequirementsKo extends StringsRequirementsEn {
	StringsRequirementsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '요구사항';
	@override late final StringsRequirementsLabelsKo labels = StringsRequirementsLabelsKo._(_root);
	@override late final StringsRequirementsInfoKo info = StringsRequirementsInfoKo._(_root);
	@override late final StringsRequirementsDescriptionKo description = StringsRequirementsDescriptionKo._(_root);
	@override late final StringsRequirementsErrorsKo errors = StringsRequirementsErrorsKo._(_root);
}

// Path: common.labels
class StringsCommonLabelsKo extends StringsCommonLabelsEn {
	StringsCommonLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get yes => '네';
	@override String get no => '아니오';
	@override String get ok => '확인';
	@override String get cancel => '취소';
	@override String get dismiss => '닫기';
}

// Path: actions.add_project
class StringsActionsAddProjectKo extends StringsActionsAddProjectEn {
	StringsActionsAddProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '기존 프로젝트 추가';
}

// Path: actions.create_project
class StringsActionsCreateProjectKo extends StringsActionsCreateProjectEn {
	StringsActionsCreateProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '새 프로젝트 생성';
}

// Path: actions.open_vcc_settings_folder
class StringsActionsOpenVccSettingsFolderKo extends StringsActionsOpenVccSettingsFolderEn {
	StringsActionsOpenVccSettingsFolderKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get label => 'VCC 설정 폴더 열기';
}

// Path: actions.open_logs_folder
class StringsActionsOpenLogsFolderKo extends StringsActionsOpenLogsFolderEn {
	StringsActionsOpenLogsFolderKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get label => '로그 폴더 열기';
}

// Path: projects.labels
class StringsProjectsLabelsKo extends StringsProjectsLabelsEn {
	StringsProjectsLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get open_folder => '폴더 열기';
	@override String get remove_from_list => '목록에서 삭제';
	@override String get move_to_recycle_bin => '휴지통으로 이동';
	@override String get move_to_trash => '휴지통으로 이동';
}

// Path: projects.dialogs
class StringsProjectsDialogsKo extends StringsProjectsDialogsEn {
	StringsProjectsDialogsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsDialogsRemoveProjectKo remove_project = StringsProjectsDialogsRemoveProjectKo._(_root);
}

// Path: projects.info
class StringsProjectsInfoKo extends StringsProjectsInfoEn {
	StringsProjectsInfoKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String failed_to_remove({required Object projectPath}) => '${projectPath} 를 삭제하는데 실패 했습니다.';
	@override String error_project_not_supported({required Object path}) => '프로젝트 "${path}" 는 지원하지 않습니다.';
	@override String get error_add_project => '프로젝트를 추가 하는데 오류가 발생했습니다.';
	@override String error_project_not_exist({required Object projectPath}) => '${projectPath} 가 존재하지 않습니다.';
	@override String avatar_git_not_supported({required Object projectPath}) => '아바타 Git 프로젝트 (${projectPath}) 는 Tiny VCC 에서 지원하지 않습니다.';
	@override String world_git_not_supported({required Object projectPath}) => '월드 Git 프로젝트 (${projectPath}) 는 Tiny VCC 에서 지원하지 않습니다.';
	@override String project_is_sdk2({required Object projectPath}) => '${projectPath} 는 VRCSDK2 프로젝트 입니다.';
	@override String project_is_invalid({required Object projectPath}) => '${projectPath} 는 알 수 없는 프로젝트 입니다.';
}

// Path: settings.headers
class StringsSettingsHeadersKo extends StringsSettingsHeadersEn {
	StringsSettingsHeadersKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get tiny_vcc_preferences => 'Tiny VCC 설정';
	@override String get vcc_settings => 'VCC 설정';
}

// Path: settings.labels
class StringsSettingsLabelsKo extends StringsSettingsLabelsEn {
	StringsSettingsLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get theme => '테마';
	@override String get language => '언어';
	@override String get unity_editors => '유니티 에디터';
	@override String get backups => '백업';
	@override String get user_packages => '사용자 패키지';
}

// Path: settings.theme
class StringsSettingsThemeKo extends StringsSettingsThemeEn {
	StringsSettingsThemeKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get auto => '자동';
	@override String get light => '라이트';
	@override String get dark => '다크';
}

// Path: settings.lang
class StringsSettingsLangKo extends StringsSettingsLangEn {
	StringsSettingsLangKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get auto => '자동';
}

// Path: new_project.labels
class StringsNewProjectLabelsKo extends StringsNewProjectLabelsEn {
	StringsNewProjectLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get project_template => '프로젝트 템플릿';
	@override String get project_name => '프로젝트 이름';
	@override String get location => '위치';
	@override String get create => '생성';
}

// Path: new_project.errors
class StringsNewProjectErrorsKo extends StringsNewProjectErrorsEn {
	StringsNewProjectErrorsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get select_project_template => '프로젝트 템플릿을 선택하세요.';
	@override String get enter_project_name => '프로젝트 이름을 입력하세요.';
	@override String get enter_location_path => '경로를 지정하세요.';
	@override String get failed_to_create_project => '프로젝트를 만드는데 실패 했습니다.';
}

// Path: new_project.info
class StringsNewProjectInfoKo extends StringsNewProjectInfoEn {
	StringsNewProjectInfoKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String creating_project({required Object template, required Object name, required Object location}) => '${template} 프로젝트를 "${name}" 의 이름으로 ${location} 에 생성 중입니다.';
	@override String created_project({required Object template, required Object projectLocation, required Object name}) => '${template} 프로젝트를, ${projectLocation} 에 "${name}" 으로 생성 했습니다.';
}

// Path: project.labels
class StringsProjectLabelsKo extends StringsProjectLabelsEn {
	StringsProjectLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get open_project => '프로젝트 열기';
	@override String get open_folder => '폴더 열기';
	@override String get make_backup => '백업 생성';
	@override String get add => '추가';
	@override String get update => '업데이트';
	@override String get downgrade => '다운그레이드';
	@override String get remove => '삭제';
}

// Path: project.info
class StringsProjectInfoKo extends StringsProjectInfoEn {
	StringsProjectInfoKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get packages_changed => '패키지가 변경 되었습니다. 유니티를 껏다켜서 변경사항을 적용 하세요.';
	@override String unity_not_found({required Object editorVersion}) => 'VCC 설정에서 유니티 ${editorVersion} 를 찾을 수 없습니다.';
}

// Path: project.dialogs
class StringsProjectDialogsKo extends StringsProjectDialogsEn {
	StringsProjectDialogsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectDialogsProgressBackupKo progress_backup = StringsProjectDialogsProgressBackupKo._(_root);
	@override late final StringsProjectDialogsMadeBackupKo made_backup = StringsProjectDialogsMadeBackupKo._(_root);
	@override late final StringsProjectDialogsBackupErrorKo backup_error = StringsProjectDialogsBackupErrorKo._(_root);
}

// Path: legacy_project.labels
class StringsLegacyProjectLabelsKo extends StringsLegacyProjectLabelsEn {
	StringsLegacyProjectLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get migrate => '마이그레이션';
	@override String get open_folder => '폴더 열기';
	@override String get make_backup => '백업 만들기';
}

// Path: legacy_project.dialogs
class StringsLegacyProjectDialogsKo extends StringsLegacyProjectDialogsEn {
	StringsLegacyProjectDialogsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectDialogsConfirmKo confirm = StringsLegacyProjectDialogsConfirmKo._(_root);
	@override late final StringsLegacyProjectDialogsProgressBackupKo progress_backup = StringsLegacyProjectDialogsProgressBackupKo._(_root);
	@override late final StringsLegacyProjectDialogsMadeBackupKo made_backup = StringsLegacyProjectDialogsMadeBackupKo._(_root);
	@override late final StringsLegacyProjectDialogsBackupErrorKo backup_error = StringsLegacyProjectDialogsBackupErrorKo._(_root);
	@override late final StringsLegacyProjectDialogsProgressMigrationKo progress_migration = StringsLegacyProjectDialogsProgressMigrationKo._(_root);
}

// Path: requirements.labels
class StringsRequirementsLabelsKo extends StringsRequirementsLabelsEn {
	StringsRequirementsLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get dotnet6sdk => '.NET 6.0 SDK';
	@override String get vpm_cli => 'VPM CLI';
	@override String get unity_hub => '유니티 허브';
	@override String get unity => '유니티';
	@override String get install => '설치';
	@override String get check_again => '다시 검사';
}

// Path: requirements.info
class StringsRequirementsInfoKo extends StringsRequirementsInfoEn {
	StringsRequirementsInfoKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get downloading_dotnet => '.NET 6.0 SDK 설치 프로그램 다운로드중.';
	@override String get installing_dotnet => '.NET 6.0 SDK 설치중.';
	@override String get installing_dotnet_with_brew => '홈브류를 사용하여 .NET 6.0 SDK 설치중.';
	@override String get see_terminal_to_continue => '터미널 앱에서 설치를 계속하세요.';
	@override String get installing_vpm => 'VPM CLI 설치중';
	@override String get downloading_unity_hub => '유니티 허브 다운로드중.';
	@override String get installing_unity_hub => '유니티 허브 설치중.';
	@override String get installing_unity => '유니티 설치중';
}

// Path: requirements.description
class StringsRequirementsDescriptionKo extends StringsRequirementsDescriptionEn {
	StringsRequirementsDescriptionKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get dotnet => '.NET 6.0 SDK를 설치합니다. 웹에서 SDK 설치 프로그램을 다운로드할 수도 있습니다.';
	@override String get dotnet_brew => '홈브류를 사용하여 .NET 6.0 SDK를 설치합니다. 다음 명령을 사용하여 설치할 수도 있습니다.';
	@override String get dotnet_linux => '패키지 관리자를 사용하여 .NET 6.0 SDK를 설치합니다. 아래 지침을 참조하세요.';
	@override String get vpm => 'VPM CLI를 설치합니다. 다음 명령을 사용하여 설치할 수도 있습니다.';
	@override String get unity_hub => '유니티 허브를 설치하세요. 웹에서 설치 프로그램을 다운로드할 수도 있습니다.';
	@override String get unity_hub_linux => '유니티 허브를 설치하세요. 아래 지침을 참조하세요.';
	@override String get unity => '유니티 허브를 사용하여 유니티를 설치하세요. 아카이브에서 설치할 수도 있지만 VRChat이 지정하는 정확한 버전을 설치해야 합니다.';
	@override String get unity_modules => '수동 설치에서는 일부 모듈을 함께 설치해야 합니다:';
	@override String get unity_modules_android => 'Android 빌드 지원(Quest용 업로드용)';
	@override String get unity_modules_mono => 'Windows 빌드 지원(모노)(macOS 또는 Linux에서 PC용으로 업로드)';
}

// Path: requirements.errors
class StringsRequirementsErrorsKo extends StringsRequirementsErrorsEn {
	StringsRequirementsErrorsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get failed_to_isntall_dotnet => '.NET SDK 를 설치하는데 실패 했습니다.';
	@override String get failed_to_isntall_vpm => 'VPM CLI 를 설치하는데 실패 했습니다.';
	@override String get failed_to_isntall_unity_hub => 'Unity Hub 를 설치하는데 실패 했습니다.';
	@override String get failed_to_isntall_unity => 'Unity 를 설치하는데 실패 했습니다.';
}

// Path: projects.dialogs.remove_project
class StringsProjectsDialogsRemoveProjectKo extends StringsProjectsDialogsRemoveProjectEn {
	StringsProjectsDialogsRemoveProjectKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String title({required Object projectName}) => '${projectName} 삭제';
	@override String content_win({required Object projectPath}) => '정말로 ${projectPath} 를 휴지통으로 이동 하시겠습니까?';
	@override String content_others({required Object projectPath}) => '정말로 ${projectPath} 를 휴지통으로 이동 하시겠습니까?';
}

// Path: project.dialogs.progress_backup
class StringsProjectDialogsProgressBackupKo extends StringsProjectDialogsProgressBackupEn {
	StringsProjectDialogsProgressBackupKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} 백업중';
}

// Path: project.dialogs.made_backup
class StringsProjectDialogsMadeBackupKo extends StringsProjectDialogsMadeBackupEn {
	StringsProjectDialogsMadeBackupKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '백업 생성';
	@override late final StringsProjectDialogsMadeBackupLabelsKo labels = StringsProjectDialogsMadeBackupLabelsKo._(_root);
}

// Path: project.dialogs.backup_error
class StringsProjectDialogsBackupErrorKo extends StringsProjectDialogsBackupErrorEn {
	StringsProjectDialogsBackupErrorKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '백업 오류';
	@override String content({required Object projectName, required Object error}) => '${projectName} 프로젝트를 백업하는데 실패 했습니다.\n\n${error}';
}

// Path: legacy_project.dialogs.confirm
class StringsLegacyProjectDialogsConfirmKo extends StringsLegacyProjectDialogsConfirmEn {
	StringsLegacyProjectDialogsConfirmKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '프로젝트 마이그레이션';
	@override String get content => '마이그레이션이 필요합ㄴ디ㅏ.';
	@override late final StringsLegacyProjectDialogsConfirmLabelsKo labels = StringsLegacyProjectDialogsConfirmLabelsKo._(_root);
}

// Path: legacy_project.dialogs.progress_backup
class StringsLegacyProjectDialogsProgressBackupKo extends StringsLegacyProjectDialogsProgressBackupEn {
	StringsLegacyProjectDialogsProgressBackupKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} 백업중';
}

// Path: legacy_project.dialogs.made_backup
class StringsLegacyProjectDialogsMadeBackupKo extends StringsLegacyProjectDialogsMadeBackupEn {
	StringsLegacyProjectDialogsMadeBackupKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '백업 만들기';
	@override late final StringsLegacyProjectDialogsMadeBackupLabelsKo labels = StringsLegacyProjectDialogsMadeBackupLabelsKo._(_root);
}

// Path: legacy_project.dialogs.backup_error
class StringsLegacyProjectDialogsBackupErrorKo extends StringsLegacyProjectDialogsBackupErrorEn {
	StringsLegacyProjectDialogsBackupErrorKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '백업 오류';
	@override String content({required Object projectName, required Object error}) => '${projectName} 를 백업하는데 실패 했습니다.\n\n${error}';
}

// Path: legacy_project.dialogs.progress_migration
class StringsLegacyProjectDialogsProgressMigrationKo extends StringsLegacyProjectDialogsProgressMigrationEn {
	StringsLegacyProjectDialogsProgressMigrationKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} 마이그레이션중';
}

// Path: project.dialogs.made_backup.labels
class StringsProjectDialogsMadeBackupLabelsKo extends StringsProjectDialogsMadeBackupLabelsEn {
	StringsProjectDialogsMadeBackupLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get show_me => '보이기';
}

// Path: legacy_project.dialogs.confirm.labels
class StringsLegacyProjectDialogsConfirmLabelsKo extends StringsLegacyProjectDialogsConfirmLabelsEn {
	StringsLegacyProjectDialogsConfirmLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get migrate_a_copy => '다른 폴더로 복사후 마이그레이션';
	@override String get migrate_in_place => '이 폴더에 마이그레이션\n백업이 있습니다.';
}

// Path: legacy_project.dialogs.made_backup.labels
class StringsLegacyProjectDialogsMadeBackupLabelsKo extends StringsLegacyProjectDialogsMadeBackupLabelsEn {
	StringsLegacyProjectDialogsMadeBackupLabelsKo._(StringsKo root) : this._root = root, super._(root);

	@override final StringsKo _root; // ignore: unused_field

	// Translations
	@override String get show_me => '보이기';
}

// Path: <root>
class StringsZhCn extends StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, StringsEn> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override String get lang_name => '简体中文';
	@override late final StringsCommonZhCn common = StringsCommonZhCn._(_root);
	@override late final StringsNavigationZhCn navigation = StringsNavigationZhCn._(_root);
	@override late final StringsActionsZhCn actions = StringsActionsZhCn._(_root);
	@override late final StringsProjectsZhCn projects = StringsProjectsZhCn._(_root);
	@override late final StringsSettingsZhCn settings = StringsSettingsZhCn._(_root);
	@override late final StringsNewProjectZhCn new_project = StringsNewProjectZhCn._(_root);
	@override late final StringsProjectZhCn project = StringsProjectZhCn._(_root);
	@override late final StringsLegacyProjectZhCn legacy_project = StringsLegacyProjectZhCn._(_root);
	@override late final StringsRequirementsZhCn requirements = StringsRequirementsZhCn._(_root);
}

// Path: common
class StringsCommonZhCn extends StringsCommonEn {
	StringsCommonZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsCommonLabelsZhCn labels = StringsCommonLabelsZhCn._(_root);
}

// Path: navigation
class StringsNavigationZhCn extends StringsNavigationEn {
	StringsNavigationZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get new_project => '新建项目';
	@override String get projects => '项目';
	@override String get settings => '设置';
	@override String get about => '关于 Tiny VCC';
}

// Path: actions
class StringsActionsZhCn extends StringsActionsEn {
	StringsActionsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsActionsAddProjectZhCn add_project = StringsActionsAddProjectZhCn._(_root);
	@override late final StringsActionsCreateProjectZhCn create_project = StringsActionsCreateProjectZhCn._(_root);
	@override late final StringsActionsOpenVccSettingsFolderZhCn open_vcc_settings_folder = StringsActionsOpenVccSettingsFolderZhCn._(_root);
	@override late final StringsActionsOpenLogsFolderZhCn open_logs_folder = StringsActionsOpenLogsFolderZhCn._(_root);
}

// Path: projects
class StringsProjectsZhCn extends StringsProjectsEn {
	StringsProjectsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsLabelsZhCn labels = StringsProjectsLabelsZhCn._(_root);
	@override late final StringsProjectsDialogsZhCn dialogs = StringsProjectsDialogsZhCn._(_root);
	@override late final StringsProjectsInfoZhCn info = StringsProjectsInfoZhCn._(_root);
}

// Path: settings
class StringsSettingsZhCn extends StringsSettingsEn {
	StringsSettingsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsSettingsHeadersZhCn headers = StringsSettingsHeadersZhCn._(_root);
	@override late final StringsSettingsLabelsZhCn labels = StringsSettingsLabelsZhCn._(_root);
	@override late final StringsSettingsThemeZhCn theme = StringsSettingsThemeZhCn._(_root);
	@override late final StringsSettingsLangZhCn lang = StringsSettingsLangZhCn._(_root);
}

// Path: new_project
class StringsNewProjectZhCn extends StringsNewProjectEn {
	StringsNewProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '新项目';
	@override late final StringsNewProjectLabelsZhCn labels = StringsNewProjectLabelsZhCn._(_root);
	@override late final StringsNewProjectErrorsZhCn errors = StringsNewProjectErrorsZhCn._(_root);
	@override late final StringsNewProjectInfoZhCn info = StringsNewProjectInfoZhCn._(_root);
}

// Path: project
class StringsProjectZhCn extends StringsProjectEn {
	StringsProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectLabelsZhCn labels = StringsProjectLabelsZhCn._(_root);
	@override late final StringsProjectInfoZhCn info = StringsProjectInfoZhCn._(_root);
	@override late final StringsProjectDialogsZhCn dialogs = StringsProjectDialogsZhCn._(_root);
}

// Path: legacy_project
class StringsLegacyProjectZhCn extends StringsLegacyProjectEn {
	StringsLegacyProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectLabelsZhCn labels = StringsLegacyProjectLabelsZhCn._(_root);
	@override late final StringsLegacyProjectDialogsZhCn dialogs = StringsLegacyProjectDialogsZhCn._(_root);
}

// Path: requirements
class StringsRequirementsZhCn extends StringsRequirementsEn {
	StringsRequirementsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '要求';
	@override late final StringsRequirementsLabelsZhCn labels = StringsRequirementsLabelsZhCn._(_root);
	@override late final StringsRequirementsInfoZhCn info = StringsRequirementsInfoZhCn._(_root);
	@override late final StringsRequirementsDescriptionZhCn description = StringsRequirementsDescriptionZhCn._(_root);
	@override late final StringsRequirementsErrorsZhCn errors = StringsRequirementsErrorsZhCn._(_root);
}

// Path: common.labels
class StringsCommonLabelsZhCn extends StringsCommonLabelsEn {
	StringsCommonLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get yes => '是';
	@override String get no => '否';
	@override String get ok => '确定';
	@override String get cancel => '取消';
	@override String get dismiss => '关闭';
}

// Path: actions.add_project
class StringsActionsAddProjectZhCn extends StringsActionsAddProjectEn {
	StringsActionsAddProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '添加现有项目';
}

// Path: actions.create_project
class StringsActionsCreateProjectZhCn extends StringsActionsCreateProjectEn {
	StringsActionsCreateProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tooltip => '创建新项目';
}

// Path: actions.open_vcc_settings_folder
class StringsActionsOpenVccSettingsFolderZhCn extends StringsActionsOpenVccSettingsFolderEn {
	StringsActionsOpenVccSettingsFolderZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '打开 VCC 设置文件夹';
}

// Path: actions.open_logs_folder
class StringsActionsOpenLogsFolderZhCn extends StringsActionsOpenLogsFolderEn {
	StringsActionsOpenLogsFolderZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '打开日志文件夹';
}

// Path: projects.labels
class StringsProjectsLabelsZhCn extends StringsProjectsLabelsEn {
	StringsProjectsLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get open_folder => '打开文件夹';
	@override String get remove_from_list => '从列表中移除';
	@override String get move_to_recycle_bin => '移动到回收站';
	@override String get move_to_trash => '移动到废纸篓';
}

// Path: projects.dialogs
class StringsProjectsDialogsZhCn extends StringsProjectsDialogsEn {
	StringsProjectsDialogsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectsDialogsRemoveProjectZhCn remove_project = StringsProjectsDialogsRemoveProjectZhCn._(_root);
}

// Path: projects.info
class StringsProjectsInfoZhCn extends StringsProjectsInfoEn {
	StringsProjectsInfoZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String failed_to_remove({required Object projectPath}) => '无法移除 ${projectPath}。';
	@override String error_project_not_supported({required Object path}) => '项目 "${path}" 不受支持。';
	@override String get error_add_project => '添加项目时发生错误。';
	@override String error_project_not_exist({required Object projectPath}) => '${projectPath} 不存在。';
	@override String avatar_git_not_supported({required Object projectPath}) => 'Avatar Git 项目 (${projectPath}) 不受 Tiny VCC 支持。';
	@override String world_git_not_supported({required Object projectPath}) => 'World Git 项目 (${projectPath}) 不受 Tiny VCC 支持。';
	@override String project_is_sdk2({required Object projectPath}) => '${projectPath} 是 VRCSDK2 项目。';
	@override String project_is_invalid({required Object projectPath}) => '${projectPath} 是无效项目。';
}

// Path: settings.headers
class StringsSettingsHeadersZhCn extends StringsSettingsHeadersEn {
	StringsSettingsHeadersZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tiny_vcc_preferences => 'Tiny VCC 首选项';
	@override String get vcc_settings => 'VCC 设置';
}

// Path: settings.labels
class StringsSettingsLabelsZhCn extends StringsSettingsLabelsEn {
	StringsSettingsLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get theme => '主题';
	@override String get language => '语言';
	@override String get unity_editors => 'Unity 编辑器';
	@override String get backups => '备份';
	@override String get user_packages => '用户包';
}

// Path: settings.theme
class StringsSettingsThemeZhCn extends StringsSettingsThemeEn {
	StringsSettingsThemeZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get auto => '自动';
	@override String get light => '浅色';
	@override String get dark => '深色';
}

// Path: settings.lang
class StringsSettingsLangZhCn extends StringsSettingsLangEn {
	StringsSettingsLangZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get auto => '自动';
}

// Path: new_project.labels
class StringsNewProjectLabelsZhCn extends StringsNewProjectLabelsEn {
	StringsNewProjectLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get project_template => '项目模板';
	@override String get project_name => '项目名称';
	@override String get location => '位置';
	@override String get create => '创建';
}

// Path: new_project.errors
class StringsNewProjectErrorsZhCn extends StringsNewProjectErrorsEn {
	StringsNewProjectErrorsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get select_project_template => '请选择项目模板。';
	@override String get enter_project_name => '请输入项目名称。';
	@override String get enter_location_path => '请输入位置路径。';
	@override String get failed_to_create_project => '创建项目失败。';
}

// Path: new_project.info
class StringsNewProjectInfoZhCn extends StringsNewProjectInfoEn {
	StringsNewProjectInfoZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String creating_project({required Object location, required Object template, required Object name}) => '正在 ${location} 此路径创建 ${template} 项目 "${name}"。';
	@override String created_project({required Object template, required Object name, required Object projectLocation}) => '${template} 项目 "${name}" 已在 ${projectLocation} 路径创建。';
}

// Path: project.labels
class StringsProjectLabelsZhCn extends StringsProjectLabelsEn {
	StringsProjectLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get open_project => '打开项目';
	@override String get open_folder => '打开文件夹';
	@override String get make_backup => '创建备份';
	@override String get add => '添加';
	@override String get update => '更新';
	@override String get downgrade => '降级';
	@override String get remove => '移除';
}

// Path: project.info
class StringsProjectInfoZhCn extends StringsProjectInfoEn {
	StringsProjectInfoZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get packages_changed => '包已更改。关闭并重新打开 Unity 项目以应用更改。';
	@override String unity_not_found({required Object editorVersion}) => 'VCC 设置中未找到 Unity ${editorVersion}。';
}

// Path: project.dialogs
class StringsProjectDialogsZhCn extends StringsProjectDialogsEn {
	StringsProjectDialogsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsProjectDialogsProgressBackupZhCn progress_backup = StringsProjectDialogsProgressBackupZhCn._(_root);
	@override late final StringsProjectDialogsMadeBackupZhCn made_backup = StringsProjectDialogsMadeBackupZhCn._(_root);
	@override late final StringsProjectDialogsBackupErrorZhCn backup_error = StringsProjectDialogsBackupErrorZhCn._(_root);
}

// Path: legacy_project.labels
class StringsLegacyProjectLabelsZhCn extends StringsLegacyProjectLabelsEn {
	StringsLegacyProjectLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get migrate => '迁移';
	@override String get open_folder => '打开文件夹';
	@override String get make_backup => '创建备份';
}

// Path: legacy_project.dialogs
class StringsLegacyProjectDialogsZhCn extends StringsLegacyProjectDialogsEn {
	StringsLegacyProjectDialogsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final StringsLegacyProjectDialogsConfirmZhCn confirm = StringsLegacyProjectDialogsConfirmZhCn._(_root);
	@override late final StringsLegacyProjectDialogsProgressBackupZhCn progress_backup = StringsLegacyProjectDialogsProgressBackupZhCn._(_root);
	@override late final StringsLegacyProjectDialogsMadeBackupZhCn made_backup = StringsLegacyProjectDialogsMadeBackupZhCn._(_root);
	@override late final StringsLegacyProjectDialogsBackupErrorZhCn backup_error = StringsLegacyProjectDialogsBackupErrorZhCn._(_root);
	@override late final StringsLegacyProjectDialogsProgressMigrationZhCn progress_migration = StringsLegacyProjectDialogsProgressMigrationZhCn._(_root);
}

// Path: requirements.labels
class StringsRequirementsLabelsZhCn extends StringsRequirementsLabelsEn {
	StringsRequirementsLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dotnet6sdk => '.NET 6.0 SDK';
	@override String get vpm_cli => 'VPM CLI';
	@override String get unity_hub => 'Unity Hub';
	@override String get unity => 'Unity';
	@override String get install => '安装';
	@override String get check_again => '再次检查';
}

// Path: requirements.info
class StringsRequirementsInfoZhCn extends StringsRequirementsInfoEn {
	StringsRequirementsInfoZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get downloading_dotnet => '正在下载 .NET 6.0 SDK 安装程序。';
	@override String get installing_dotnet => '正在安装 .NET 6.0 SDK。';
	@override String get installing_dotnet_with_brew => '正在使用 Homebrew 安装 .NET 6.0 SDK';
	@override String get see_terminal_to_continue => '请查看终端应用程序以继续安装。';
	@override String get installing_vpm => '正在安装 VPM CLI';
	@override String get downloading_unity_hub => '正在下载 Unity Hub 安装程序。';
	@override String get installing_unity_hub => '正在安装 Unity Hub。';
	@override String get installing_unity => '正在安装 Unity';
}

// Path: requirements.description
class StringsRequirementsDescriptionZhCn extends StringsRequirementsDescriptionEn {
	StringsRequirementsDescriptionZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dotnet => '安装 .NET 6.0 SDK。您也可以从网页下载 SDK 安装程序。';
	@override String get dotnet_brew => '使用 Homebrew 安装 .NET 6.0 SDK。您也可以使用以下命令安装。';
	@override String get dotnet_linux => '使用包管理器安装 .NET 6.0 SDK。请参阅以下说明。';
	@override String get vpm => '安装 VPM CLI。您也可以使用以下命令安装。';
	@override String get unity_hub => '安装 Unity Hub。您也可以从网页下载安装程序。';
	@override String get unity_hub_linux => '安装 Unity Hub。请参阅以下说明。';
	@override String get unity => '使用 Unity Hub 安装 Unity。您也可以从归档文件安装，但应安装 VRChat 指定的确切版本。';
	@override String get unity_modules => '在手动安装中，您必须一起安装以下模块：';
	@override String get unity_modules_android => 'Android Build Support（用来上传到 Quest）';
	@override String get unity_modules_mono => 'Windows Build Support (mono)（用来从 macOS 或 Linux 上传到 PC）';
}

// Path: requirements.errors
class StringsRequirementsErrorsZhCn extends StringsRequirementsErrorsEn {
	StringsRequirementsErrorsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get failed_to_isntall_dotnet => '.NET SDK 安装失败';
	@override String get failed_to_isntall_vpm => 'VPM CLI 安装失败';
	@override String get failed_to_isntall_unity_hub => 'Unity Hub 安装失败';
	@override String get failed_to_isntall_unity => 'Unity 安装失败';
}

// Path: projects.dialogs.remove_project
class StringsProjectsDialogsRemoveProjectZhCn extends StringsProjectsDialogsRemoveProjectEn {
	StringsProjectsDialogsRemoveProjectZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object projectName}) => '移除 ${projectName}';
	@override String content_win({required Object projectPath}) => '你确定要将 ${projectPath} 移动到回收站吗？';
	@override String content_others({required Object projectPath}) => '你确定要将 ${projectPath} 移动到废纸篓吗？';
}

// Path: project.dialogs.progress_backup
class StringsProjectDialogsProgressBackupZhCn extends StringsProjectDialogsProgressBackupEn {
	StringsProjectDialogsProgressBackupZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '正在备份 ${name}';
}

// Path: project.dialogs.made_backup
class StringsProjectDialogsMadeBackupZhCn extends StringsProjectDialogsMadeBackupEn {
	StringsProjectDialogsMadeBackupZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '已创建备份';
	@override late final StringsProjectDialogsMadeBackupLabelsZhCn labels = StringsProjectDialogsMadeBackupLabelsZhCn._(_root);
}

// Path: project.dialogs.backup_error
class StringsProjectDialogsBackupErrorZhCn extends StringsProjectDialogsBackupErrorEn {
	StringsProjectDialogsBackupErrorZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '备份错误';
	@override String content({required Object projectName, required Object error}) => '无法备份 ${projectName}。\n\n${error}';
}

// Path: legacy_project.dialogs.confirm
class StringsLegacyProjectDialogsConfirmZhCn extends StringsLegacyProjectDialogsConfirmEn {
	StringsLegacyProjectDialogsConfirmZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '项目迁移';
	@override String get content => '需要迁移。';
	@override late final StringsLegacyProjectDialogsConfirmLabelsZhCn labels = StringsLegacyProjectDialogsConfirmLabelsZhCn._(_root);
}

// Path: legacy_project.dialogs.progress_backup
class StringsLegacyProjectDialogsProgressBackupZhCn extends StringsLegacyProjectDialogsProgressBackupEn {
	StringsLegacyProjectDialogsProgressBackupZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '正在备份 ${name}';
}

// Path: legacy_project.dialogs.made_backup
class StringsLegacyProjectDialogsMadeBackupZhCn extends StringsLegacyProjectDialogsMadeBackupEn {
	StringsLegacyProjectDialogsMadeBackupZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '已创建备份';
	@override late final StringsLegacyProjectDialogsMadeBackupLabelsZhCn labels = StringsLegacyProjectDialogsMadeBackupLabelsZhCn._(_root);
}

// Path: legacy_project.dialogs.backup_error
class StringsLegacyProjectDialogsBackupErrorZhCn extends StringsLegacyProjectDialogsBackupErrorEn {
	StringsLegacyProjectDialogsBackupErrorZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '备份错误';
	@override String content({required Object projectName, required Object error}) => '无法备份 ${projectName}。\n\n${error}';
}

// Path: legacy_project.dialogs.progress_migration
class StringsLegacyProjectDialogsProgressMigrationZhCn extends StringsLegacyProjectDialogsProgressMigrationEn {
	StringsLegacyProjectDialogsProgressMigrationZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '正在迁移 ${name}';
}

// Path: project.dialogs.made_backup.labels
class StringsProjectDialogsMadeBackupLabelsZhCn extends StringsProjectDialogsMadeBackupLabelsEn {
	StringsProjectDialogsMadeBackupLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get show_me => '显示';
}

// Path: legacy_project.dialogs.confirm.labels
class StringsLegacyProjectDialogsConfirmLabelsZhCn extends StringsLegacyProjectDialogsConfirmLabelsEn {
	StringsLegacyProjectDialogsConfirmLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get migrate_a_copy => '迁移副本';
	@override String get migrate_in_place => '迁移\n我已备份';
}

// Path: legacy_project.dialogs.made_backup.labels
class StringsLegacyProjectDialogsMadeBackupLabelsZhCn extends StringsLegacyProjectDialogsMadeBackupLabelsEn {
	StringsLegacyProjectDialogsMadeBackupLabelsZhCn._(StringsZhCn root) : this._root = root, super._(root);

	@override final StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get show_me => '显示';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'lang_name': return 'English';
			case 'common.labels.yes': return 'Yes';
			case 'common.labels.no': return 'No';
			case 'common.labels.ok': return 'OK';
			case 'common.labels.cancel': return 'Cancel';
			case 'common.labels.dismiss': return 'Dismiss';
			case 'navigation.new_project': return 'NEW PROJECT';
			case 'navigation.projects': return 'Projects';
			case 'navigation.settings': return 'Settings';
			case 'navigation.about': return 'About Tiny VCC';
			case 'actions.add_project.tooltip': return 'Add existing project';
			case 'actions.create_project.tooltip': return 'Create new project';
			case 'actions.open_vcc_settings_folder.label': return 'Open VCC Settings Folder';
			case 'actions.open_logs_folder.label': return 'Open Logs Folder';
			case 'projects.labels.open_folder': return 'Open Folder';
			case 'projects.labels.remove_from_list': return 'Remove from list';
			case 'projects.labels.move_to_recycle_bin': return 'Move to Recycle Bin';
			case 'projects.labels.move_to_trash': return 'Move to Trash';
			case 'projects.dialogs.remove_project.title': return ({required Object projectName}) => 'Remove ${projectName}';
			case 'projects.dialogs.remove_project.content_win': return ({required Object projectPath}) => 'Are you sure you want to move ${projectPath} to the Recycle Bin?';
			case 'projects.dialogs.remove_project.content_others': return ({required Object projectPath}) => 'Are you sure you want to move ${projectPath} to the Trash?';
			case 'projects.info.failed_to_remove': return ({required Object projectPath}) => 'Failed to remove ${projectPath}.';
			case 'projects.info.error_project_not_supported': return ({required Object path}) => 'Project "${path}" is not supported.';
			case 'projects.info.error_add_project': return 'Error occurred when adding a project.';
			case 'projects.info.error_project_not_exist': return ({required Object projectPath}) => '${projectPath} does not exist.';
			case 'projects.info.avatar_git_not_supported': return ({required Object projectPath}) => 'Avatar Git project (${projectPath}) is not supported in Tiny VCC.';
			case 'projects.info.world_git_not_supported': return ({required Object projectPath}) => 'World Git project (${projectPath}) is not supported in Tiny VCC.';
			case 'projects.info.project_is_sdk2': return ({required Object projectPath}) => '${projectPath} is VRCSDK2 project.';
			case 'projects.info.project_is_invalid': return ({required Object projectPath}) => '${projectPath} is invalid project.';
			case 'settings.headers.tiny_vcc_preferences': return 'Tiny VCC Preferences';
			case 'settings.headers.vcc_settings': return 'VCC Settings';
			case 'settings.labels.theme': return 'Theme';
			case 'settings.labels.language': return 'Language';
			case 'settings.labels.unity_editors': return 'Unity Editors';
			case 'settings.labels.backups': return 'Backups';
			case 'settings.labels.user_packages': return 'User Packages';
			case 'settings.theme.auto': return 'Auto';
			case 'settings.theme.light': return 'Light';
			case 'settings.theme.dark': return 'Dark';
			case 'settings.lang.auto': return 'Auto';
			case 'new_project.title': return 'New Project';
			case 'new_project.labels.project_template': return 'Project Template';
			case 'new_project.labels.project_name': return 'Project Name';
			case 'new_project.labels.location': return 'Location';
			case 'new_project.labels.create': return 'Create';
			case 'new_project.errors.select_project_template': return 'Please select project template.';
			case 'new_project.errors.enter_project_name': return 'Please enter project name.';
			case 'new_project.errors.enter_location_path': return 'Please enter location path.';
			case 'new_project.errors.failed_to_create_project': return 'Failed to create project.';
			case 'new_project.info.creating_project': return ({required Object template, required Object name, required Object location}) => 'Creating ${template} project, "${name}" at ${location}.';
			case 'new_project.info.created_project': return ({required Object template, required Object name, required Object projectLocation}) => '${template} project, "${name}" has been created at ${projectLocation}.';
			case 'project.labels.open_project': return 'Open Project';
			case 'project.labels.open_folder': return 'Open Folder';
			case 'project.labels.make_backup': return 'Make Backup';
			case 'project.labels.add': return 'Add';
			case 'project.labels.update': return 'Update';
			case 'project.labels.downgrade': return 'Downgrade';
			case 'project.labels.remove': return 'Remove';
			case 'project.info.packages_changed': return 'Packages have been changed. Close and reopen Unity project to apply changes.';
			case 'project.info.unity_not_found': return ({required Object editorVersion}) => 'Unity ${editorVersion} not found in VCC settings.';
			case 'project.dialogs.progress_backup.title': return ({required Object name}) => 'Backing up ${name}';
			case 'project.dialogs.made_backup.title': return 'Made Backup';
			case 'project.dialogs.made_backup.labels.show_me': return 'Show Me';
			case 'project.dialogs.backup_error.title': return 'Backup Error';
			case 'project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => 'Failed to back up ${projectName}.\n\n${error}';
			case 'legacy_project.labels.migrate': return 'Migrate';
			case 'legacy_project.labels.open_folder': return 'Open Folder';
			case 'legacy_project.labels.make_backup': return 'Make Backup';
			case 'legacy_project.dialogs.confirm.title': return 'Project Migration';
			case 'legacy_project.dialogs.confirm.content': return 'Migration is needed.';
			case 'legacy_project.dialogs.confirm.labels.migrate_a_copy': return 'Migrate a copy';
			case 'legacy_project.dialogs.confirm.labels.migrate_in_place': return 'Migrate in place\nI HAVE A BACKUP';
			case 'legacy_project.dialogs.progress_backup.title': return ({required Object name}) => 'Backing up ${name}';
			case 'legacy_project.dialogs.made_backup.title': return 'Made Backup';
			case 'legacy_project.dialogs.made_backup.labels.show_me': return 'Show Me';
			case 'legacy_project.dialogs.backup_error.title': return 'Backup Error';
			case 'legacy_project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => 'Failed to back up ${projectName}.\n\n${error}';
			case 'legacy_project.dialogs.progress_migration.title': return ({required Object name}) => 'Migrating ${name}';
			case 'requirements.title': return 'Requirements';
			case 'requirements.labels.dotnet6sdk': return '.NET 6.0 SDK';
			case 'requirements.labels.vpm_cli': return 'VPM CLI';
			case 'requirements.labels.unity_hub': return 'Unity Hub';
			case 'requirements.labels.unity': return 'Unity';
			case 'requirements.labels.install': return 'Install';
			case 'requirements.labels.check_again': return 'Check again';
			case 'requirements.info.downloading_dotnet': return 'Downloading .NET 6.0 SDK installer.';
			case 'requirements.info.installing_dotnet': return 'Installing .NET 6.0 SDK.';
			case 'requirements.info.installing_dotnet_with_brew': return 'Installing .NET 6.0 SDK with Homebrew';
			case 'requirements.info.see_terminal_to_continue': return 'See Terminal app to continue installation.';
			case 'requirements.info.installing_vpm': return 'Installing VPM CLI';
			case 'requirements.info.downloading_unity_hub': return 'Downloading Unity Hub installer.';
			case 'requirements.info.installing_unity_hub': return 'Installing Unity Hub.';
			case 'requirements.info.installing_unity': return 'Installing Unity';
			case 'requirements.description.dotnet': return 'Install .NET 6.0 SDK. You can also download the SDK installer from web.';
			case 'requirements.description.dotnet_brew': return 'Install .NET 6.0 SDK with Homebrew. You can also install with following command.';
			case 'requirements.description.dotnet_linux': return 'Install .NET 6.0 SDK with package manager. See instruction below.';
			case 'requirements.description.vpm': return 'Install VPM CLI. You can also install with following command.';
			case 'requirements.description.unity_hub': return 'Install Unity Hub. You can also download the installer from web.';
			case 'requirements.description.unity_hub_linux': return 'Install Unity Hub. See instruction below.';
			case 'requirements.description.unity': return 'Install Unity with Unity Hub. You can also install from archive, but you should install the exact version which VRChat specifies.';
			case 'requirements.description.unity_modules': return 'In manual installation, you must install some modules together:';
			case 'requirements.description.unity_modules_android': return 'Android Build Support (to upload for Quest)';
			case 'requirements.description.unity_modules_mono': return 'Windows Build Support (mono) (to upload for PC from macOS or Linux)';
			case 'requirements.errors.failed_to_isntall_dotnet': return 'Failed to install .NET SDK';
			case 'requirements.errors.failed_to_isntall_vpm': return 'Failed to install VPM CLI';
			case 'requirements.errors.failed_to_isntall_unity_hub': return 'Failed to install Unity Hub';
			case 'requirements.errors.failed_to_isntall_unity': return 'Failed to install Unity';
			default: return null;
		}
	}
}

extension on StringsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'lang_name': return '日本語';
			case 'common.labels.yes': return 'はい';
			case 'common.labels.no': return 'いいえ';
			case 'common.labels.ok': return 'OK';
			case 'common.labels.cancel': return 'キャンセル';
			case 'common.labels.dismiss': return '閉じる';
			case 'navigation.new_project': return '新規プロジェクト';
			case 'navigation.projects': return 'プロジェクト';
			case 'navigation.settings': return '設定';
			case 'navigation.about': return 'Tiny VCC について';
			case 'actions.add_project.tooltip': return '既存プロジェクトを追加';
			case 'actions.create_project.tooltip': return '新規プロジェクトを作成';
			case 'actions.open_vcc_settings_folder.label': return 'VCC の設定フォルダーを開く';
			case 'actions.open_logs_folder.label': return 'ログフォルダーを開く';
			case 'projects.labels.open_folder': return 'フォルダーを開く';
			case 'projects.labels.remove_from_list': return 'リストから削除';
			case 'projects.labels.move_to_recycle_bin': return 'ごみ箱に移動';
			case 'projects.labels.move_to_trash': return 'ごみ箱に移動';
			case 'projects.dialogs.remove_project.title': return ({required Object projectName}) => '${projectName} の削除';
			case 'projects.dialogs.remove_project.content_win': return ({required Object projectPath}) => '${projectPath} をごみ箱に移動しますか？';
			case 'projects.dialogs.remove_project.content_others': return ({required Object projectPath}) => '${projectPath} をごみ箱に移動しますか？';
			case 'projects.info.failed_to_remove': return ({required Object projectPath}) => '${projectPath} を削除できませんでした。';
			case 'projects.info.error_project_not_supported': return ({required Object path}) => 'プロジェクト "${path}" はサポートされていません。';
			case 'projects.info.error_add_project': return 'プロジェクトの追加でエラーが発生しました。';
			case 'projects.info.error_project_not_exist': return ({required Object projectPath}) => '${projectPath} が見つかりません。';
			case 'projects.info.avatar_git_not_supported': return ({required Object projectPath}) => 'Avatar Git プロジェクト (${projectPath}) は Tiny VCC ではサポートされていません。';
			case 'projects.info.world_git_not_supported': return ({required Object projectPath}) => 'World Git プロジェクト (${projectPath}) は Tiny VCC ではサポートされていません。';
			case 'projects.info.project_is_sdk2': return ({required Object projectPath}) => '${projectPath} は VRCSDK2 プロジェクトです。';
			case 'projects.info.project_is_invalid': return ({required Object projectPath}) => '${projectPath} は不正なプロジェクトです。';
			case 'settings.headers.tiny_vcc_preferences': return 'Tiny VCC 設定';
			case 'settings.headers.vcc_settings': return 'VCC 設定';
			case 'settings.labels.theme': return 'テーマ';
			case 'settings.labels.language': return '言語';
			case 'settings.labels.unity_editors': return 'Unity エディター';
			case 'settings.labels.backups': return 'バックアップ';
			case 'settings.labels.user_packages': return 'ユーザーパッケージ';
			case 'settings.theme.auto': return '自動';
			case 'settings.theme.light': return 'ライト';
			case 'settings.theme.dark': return 'ダーク';
			case 'settings.lang.auto': return '自動';
			case 'new_project.title': return '新規プロジェクト';
			case 'new_project.labels.project_template': return 'プロジェクトテンプレート';
			case 'new_project.labels.project_name': return 'プロジェクト名';
			case 'new_project.labels.location': return '保存先';
			case 'new_project.labels.create': return '作成';
			case 'new_project.errors.select_project_template': return 'テンプレートを選択してください。';
			case 'new_project.errors.enter_project_name': return 'プロジェクト名を入力してください。';
			case 'new_project.errors.enter_location_path': return '保存先を選択してください。';
			case 'new_project.errors.failed_to_create_project': return 'プロジェクトの作成に失敗しました。';
			case 'new_project.info.creating_project': return ({required Object template, required Object name, required Object location}) => '${template} プロジェクト "${name}" を ${location} に作成しています。';
			case 'new_project.info.created_project': return ({required Object template, required Object name, required Object projectLocation}) => '${template} プロジェクト "${name}" が ${projectLocation} に作成されました。';
			case 'project.labels.open_project': return 'プロジェクトを開く';
			case 'project.labels.open_folder': return 'フォルダーを開く';
			case 'project.labels.make_backup': return 'バックアップを作成';
			case 'project.labels.add': return '追加';
			case 'project.labels.update': return '更新';
			case 'project.labels.downgrade': return 'ダウングレード';
			case 'project.labels.remove': return '削除';
			case 'project.info.packages_changed': return 'パッケージが変更されました。Unity を閉じて開きなおしてください。';
			case 'project.info.unity_not_found': return ({required Object editorVersion}) => 'VCC 設定に Unity ${editorVersion} が見つかりません。';
			case 'project.dialogs.progress_backup.title': return ({required Object name}) => '${name} をバックアップ中';
			case 'project.dialogs.made_backup.title': return 'バックアップの作成完了';
			case 'project.dialogs.made_backup.labels.show_me': return '表示';
			case 'project.dialogs.backup_error.title': return 'バックアップエラー';
			case 'project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '${projectName} のバックアップに失敗しました。\n\n${error}';
			case 'legacy_project.labels.migrate': return '移行';
			case 'legacy_project.labels.open_folder': return 'フォルダーを開く';
			case 'legacy_project.labels.make_backup': return 'バックアップを作成';
			case 'legacy_project.dialogs.confirm.title': return 'プロジェクトの移行';
			case 'legacy_project.dialogs.confirm.content': return 'プロジェクトを移行する必要があります。';
			case 'legacy_project.dialogs.confirm.labels.migrate_a_copy': return 'コピーを作成して移行';
			case 'legacy_project.dialogs.confirm.labels.migrate_in_place': return 'バックアップがあるのでそのまま移行';
			case 'legacy_project.dialogs.progress_backup.title': return ({required Object name}) => '${name} をバックアップ中';
			case 'legacy_project.dialogs.made_backup.title': return 'バックアップの作成完了';
			case 'legacy_project.dialogs.made_backup.labels.show_me': return '表示';
			case 'legacy_project.dialogs.backup_error.title': return 'バックアップエラー';
			case 'legacy_project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '${projectName} のバックアップに失敗しました。\n\n${error}';
			case 'legacy_project.dialogs.progress_migration.title': return ({required Object name}) => '${name} を移行中';
			case 'requirements.title': return '必須ソフトウェア';
			case 'requirements.labels.dotnet6sdk': return '.NET 6.0 SDK';
			case 'requirements.labels.vpm_cli': return 'VPM CLI';
			case 'requirements.labels.unity_hub': return 'Unity Hub';
			case 'requirements.labels.unity': return 'Unity';
			case 'requirements.labels.install': return 'インストール';
			case 'requirements.labels.check_again': return '再確認';
			case 'requirements.info.downloading_dotnet': return '.NET 6.0 SDK インストーラーをダウンロードしています。';
			case 'requirements.info.installing_dotnet': return '.NET 6.0 SDK をインストールしています。';
			case 'requirements.info.installing_dotnet_with_brew': return '.NET 6.0 SDK を Homebrew でインストール中';
			case 'requirements.info.see_terminal_to_continue': return '「ターミナル」アプリを確認してください。';
			case 'requirements.info.installing_vpm': return 'VPM CLI をインストールしています。';
			case 'requirements.info.downloading_unity_hub': return 'Unity Hub インストーラーをダウンロードしています。';
			case 'requirements.info.installing_unity_hub': return 'Unity Hub をインストールしています。';
			case 'requirements.info.installing_unity': return 'Unity をインストール中';
			case 'requirements.description.dotnet': return '.NET 6.0 SDK をインストールします。Web から SDK インストーラーをダウンロードすることもできます。';
			case 'requirements.description.dotnet_brew': return '.NET 6.0 SDK を Homebrew でインストールします。次のコマンドでインストールすることもできます。';
			case 'requirements.description.dotnet_linux': return '.NET 6.0 SDK をパッケージマネージャーでインストールします。次の説明を参照してください。';
			case 'requirements.description.vpm': return 'VPM CLI をインストールします。次のコマンドでインストールすることもできます。';
			case 'requirements.description.unity_hub': return 'Unity Hub をインストールします。Web からインストーラーをダウンロードすることもできます。';
			case 'requirements.description.unity_hub_linux': return 'Unity Hub をインストールします。次の説明を参照してください。';
			case 'requirements.description.unity': return 'Unity を Unity Hub でインストールします。アーカイブからインストールすることもできますが、VRChat が指定するバージョンをインストールする必要があります。';
			case 'requirements.description.unity_modules': return '手動でインストールする場合、次のモジュールのインストールが必要です。';
			case 'requirements.description.unity_modules_android': return 'Android Build Support (Quest 用にアップロードする場合)';
			case 'requirements.description.unity_modules_mono': return 'Windows Build Support (mono) (macOS または Linux から PC 用にアップロードする場合)';
			case 'requirements.errors.failed_to_isntall_dotnet': return '.NET SDK のインストールに失敗しました。';
			case 'requirements.errors.failed_to_isntall_vpm': return 'VPM CLI のインストールに失敗しました。';
			case 'requirements.errors.failed_to_isntall_unity_hub': return 'Unity Hub のインストールに失敗しました。';
			case 'requirements.errors.failed_to_isntall_unity': return 'Unity のインストールに失敗しました。';
			default: return null;
		}
	}
}

extension on StringsKo {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'lang_name': return '한국어';
			case 'common.labels.yes': return '네';
			case 'common.labels.no': return '아니오';
			case 'common.labels.ok': return '확인';
			case 'common.labels.cancel': return '취소';
			case 'common.labels.dismiss': return '닫기';
			case 'navigation.new_project': return '새 프로젝트';
			case 'navigation.projects': return '프로젝트';
			case 'navigation.settings': return '설정';
			case 'navigation.about': return 'Tiny VCC에 대하여';
			case 'actions.add_project.tooltip': return '기존 프로젝트 추가';
			case 'actions.create_project.tooltip': return '새 프로젝트 생성';
			case 'actions.open_vcc_settings_folder.label': return 'VCC 설정 폴더 열기';
			case 'actions.open_logs_folder.label': return '로그 폴더 열기';
			case 'projects.labels.open_folder': return '폴더 열기';
			case 'projects.labels.remove_from_list': return '목록에서 삭제';
			case 'projects.labels.move_to_recycle_bin': return '휴지통으로 이동';
			case 'projects.labels.move_to_trash': return '휴지통으로 이동';
			case 'projects.dialogs.remove_project.title': return ({required Object projectName}) => '${projectName} 삭제';
			case 'projects.dialogs.remove_project.content_win': return ({required Object projectPath}) => '정말로 ${projectPath} 를 휴지통으로 이동 하시겠습니까?';
			case 'projects.dialogs.remove_project.content_others': return ({required Object projectPath}) => '정말로 ${projectPath} 를 휴지통으로 이동 하시겠습니까?';
			case 'projects.info.failed_to_remove': return ({required Object projectPath}) => '${projectPath} 를 삭제하는데 실패 했습니다.';
			case 'projects.info.error_project_not_supported': return ({required Object path}) => '프로젝트 "${path}" 는 지원하지 않습니다.';
			case 'projects.info.error_add_project': return '프로젝트를 추가 하는데 오류가 발생했습니다.';
			case 'projects.info.error_project_not_exist': return ({required Object projectPath}) => '${projectPath} 가 존재하지 않습니다.';
			case 'projects.info.avatar_git_not_supported': return ({required Object projectPath}) => '아바타 Git 프로젝트 (${projectPath}) 는 Tiny VCC 에서 지원하지 않습니다.';
			case 'projects.info.world_git_not_supported': return ({required Object projectPath}) => '월드 Git 프로젝트 (${projectPath}) 는 Tiny VCC 에서 지원하지 않습니다.';
			case 'projects.info.project_is_sdk2': return ({required Object projectPath}) => '${projectPath} 는 VRCSDK2 프로젝트 입니다.';
			case 'projects.info.project_is_invalid': return ({required Object projectPath}) => '${projectPath} 는 알 수 없는 프로젝트 입니다.';
			case 'settings.headers.tiny_vcc_preferences': return 'Tiny VCC 설정';
			case 'settings.headers.vcc_settings': return 'VCC 설정';
			case 'settings.labels.theme': return '테마';
			case 'settings.labels.language': return '언어';
			case 'settings.labels.unity_editors': return '유니티 에디터';
			case 'settings.labels.backups': return '백업';
			case 'settings.labels.user_packages': return '사용자 패키지';
			case 'settings.theme.auto': return '자동';
			case 'settings.theme.light': return '라이트';
			case 'settings.theme.dark': return '다크';
			case 'settings.lang.auto': return '자동';
			case 'new_project.title': return '새 프로젝트';
			case 'new_project.labels.project_template': return '프로젝트 템플릿';
			case 'new_project.labels.project_name': return '프로젝트 이름';
			case 'new_project.labels.location': return '위치';
			case 'new_project.labels.create': return '생성';
			case 'new_project.errors.select_project_template': return '프로젝트 템플릿을 선택하세요.';
			case 'new_project.errors.enter_project_name': return '프로젝트 이름을 입력하세요.';
			case 'new_project.errors.enter_location_path': return '경로를 지정하세요.';
			case 'new_project.errors.failed_to_create_project': return '프로젝트를 만드는데 실패 했습니다.';
			case 'new_project.info.creating_project': return ({required Object template, required Object name, required Object location}) => '${template} 프로젝트를 "${name}" 의 이름으로 ${location} 에 생성 중입니다.';
			case 'new_project.info.created_project': return ({required Object template, required Object projectLocation, required Object name}) => '${template} 프로젝트를, ${projectLocation} 에 "${name}" 으로 생성 했습니다.';
			case 'project.labels.open_project': return '프로젝트 열기';
			case 'project.labels.open_folder': return '폴더 열기';
			case 'project.labels.make_backup': return '백업 생성';
			case 'project.labels.add': return '추가';
			case 'project.labels.update': return '업데이트';
			case 'project.labels.downgrade': return '다운그레이드';
			case 'project.labels.remove': return '삭제';
			case 'project.info.packages_changed': return '패키지가 변경 되었습니다. 유니티를 껏다켜서 변경사항을 적용 하세요.';
			case 'project.info.unity_not_found': return ({required Object editorVersion}) => 'VCC 설정에서 유니티 ${editorVersion} 를 찾을 수 없습니다.';
			case 'project.dialogs.progress_backup.title': return ({required Object name}) => '${name} 백업중';
			case 'project.dialogs.made_backup.title': return '백업 생성';
			case 'project.dialogs.made_backup.labels.show_me': return '보이기';
			case 'project.dialogs.backup_error.title': return '백업 오류';
			case 'project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '${projectName} 프로젝트를 백업하는데 실패 했습니다.\n\n${error}';
			case 'legacy_project.labels.migrate': return '마이그레이션';
			case 'legacy_project.labels.open_folder': return '폴더 열기';
			case 'legacy_project.labels.make_backup': return '백업 만들기';
			case 'legacy_project.dialogs.confirm.title': return '프로젝트 마이그레이션';
			case 'legacy_project.dialogs.confirm.content': return '마이그레이션이 필요합ㄴ디ㅏ.';
			case 'legacy_project.dialogs.confirm.labels.migrate_a_copy': return '다른 폴더로 복사후 마이그레이션';
			case 'legacy_project.dialogs.confirm.labels.migrate_in_place': return '이 폴더에 마이그레이션\n백업이 있습니다.';
			case 'legacy_project.dialogs.progress_backup.title': return ({required Object name}) => '${name} 백업중';
			case 'legacy_project.dialogs.made_backup.title': return '백업 만들기';
			case 'legacy_project.dialogs.made_backup.labels.show_me': return '보이기';
			case 'legacy_project.dialogs.backup_error.title': return '백업 오류';
			case 'legacy_project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '${projectName} 를 백업하는데 실패 했습니다.\n\n${error}';
			case 'legacy_project.dialogs.progress_migration.title': return ({required Object name}) => '${name} 마이그레이션중';
			case 'requirements.title': return '요구사항';
			case 'requirements.labels.dotnet6sdk': return '.NET 6.0 SDK';
			case 'requirements.labels.vpm_cli': return 'VPM CLI';
			case 'requirements.labels.unity_hub': return '유니티 허브';
			case 'requirements.labels.unity': return '유니티';
			case 'requirements.labels.install': return '설치';
			case 'requirements.labels.check_again': return '다시 검사';
			case 'requirements.info.downloading_dotnet': return '.NET 6.0 SDK 설치 프로그램 다운로드중.';
			case 'requirements.info.installing_dotnet': return '.NET 6.0 SDK 설치중.';
			case 'requirements.info.installing_dotnet_with_brew': return '홈브류를 사용하여 .NET 6.0 SDK 설치중.';
			case 'requirements.info.see_terminal_to_continue': return '터미널 앱에서 설치를 계속하세요.';
			case 'requirements.info.installing_vpm': return 'VPM CLI 설치중';
			case 'requirements.info.downloading_unity_hub': return '유니티 허브 다운로드중.';
			case 'requirements.info.installing_unity_hub': return '유니티 허브 설치중.';
			case 'requirements.info.installing_unity': return '유니티 설치중';
			case 'requirements.description.dotnet': return '.NET 6.0 SDK를 설치합니다. 웹에서 SDK 설치 프로그램을 다운로드할 수도 있습니다.';
			case 'requirements.description.dotnet_brew': return '홈브류를 사용하여 .NET 6.0 SDK를 설치합니다. 다음 명령을 사용하여 설치할 수도 있습니다.';
			case 'requirements.description.dotnet_linux': return '패키지 관리자를 사용하여 .NET 6.0 SDK를 설치합니다. 아래 지침을 참조하세요.';
			case 'requirements.description.vpm': return 'VPM CLI를 설치합니다. 다음 명령을 사용하여 설치할 수도 있습니다.';
			case 'requirements.description.unity_hub': return '유니티 허브를 설치하세요. 웹에서 설치 프로그램을 다운로드할 수도 있습니다.';
			case 'requirements.description.unity_hub_linux': return '유니티 허브를 설치하세요. 아래 지침을 참조하세요.';
			case 'requirements.description.unity': return '유니티 허브를 사용하여 유니티를 설치하세요. 아카이브에서 설치할 수도 있지만 VRChat이 지정하는 정확한 버전을 설치해야 합니다.';
			case 'requirements.description.unity_modules': return '수동 설치에서는 일부 모듈을 함께 설치해야 합니다:';
			case 'requirements.description.unity_modules_android': return 'Android 빌드 지원(Quest용 업로드용)';
			case 'requirements.description.unity_modules_mono': return 'Windows 빌드 지원(모노)(macOS 또는 Linux에서 PC용으로 업로드)';
			case 'requirements.errors.failed_to_isntall_dotnet': return '.NET SDK 를 설치하는데 실패 했습니다.';
			case 'requirements.errors.failed_to_isntall_vpm': return 'VPM CLI 를 설치하는데 실패 했습니다.';
			case 'requirements.errors.failed_to_isntall_unity_hub': return 'Unity Hub 를 설치하는데 실패 했습니다.';
			case 'requirements.errors.failed_to_isntall_unity': return 'Unity 를 설치하는데 실패 했습니다.';
			default: return null;
		}
	}
}

extension on StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'lang_name': return '简体中文';
			case 'common.labels.yes': return '是';
			case 'common.labels.no': return '否';
			case 'common.labels.ok': return '确定';
			case 'common.labels.cancel': return '取消';
			case 'common.labels.dismiss': return '关闭';
			case 'navigation.new_project': return '新建项目';
			case 'navigation.projects': return '项目';
			case 'navigation.settings': return '设置';
			case 'navigation.about': return '关于 Tiny VCC';
			case 'actions.add_project.tooltip': return '添加现有项目';
			case 'actions.create_project.tooltip': return '创建新项目';
			case 'actions.open_vcc_settings_folder.label': return '打开 VCC 设置文件夹';
			case 'actions.open_logs_folder.label': return '打开日志文件夹';
			case 'projects.labels.open_folder': return '打开文件夹';
			case 'projects.labels.remove_from_list': return '从列表中移除';
			case 'projects.labels.move_to_recycle_bin': return '移动到回收站';
			case 'projects.labels.move_to_trash': return '移动到废纸篓';
			case 'projects.dialogs.remove_project.title': return ({required Object projectName}) => '移除 ${projectName}';
			case 'projects.dialogs.remove_project.content_win': return ({required Object projectPath}) => '你确定要将 ${projectPath} 移动到回收站吗？';
			case 'projects.dialogs.remove_project.content_others': return ({required Object projectPath}) => '你确定要将 ${projectPath} 移动到废纸篓吗？';
			case 'projects.info.failed_to_remove': return ({required Object projectPath}) => '无法移除 ${projectPath}。';
			case 'projects.info.error_project_not_supported': return ({required Object path}) => '项目 "${path}" 不受支持。';
			case 'projects.info.error_add_project': return '添加项目时发生错误。';
			case 'projects.info.error_project_not_exist': return ({required Object projectPath}) => '${projectPath} 不存在。';
			case 'projects.info.avatar_git_not_supported': return ({required Object projectPath}) => 'Avatar Git 项目 (${projectPath}) 不受 Tiny VCC 支持。';
			case 'projects.info.world_git_not_supported': return ({required Object projectPath}) => 'World Git 项目 (${projectPath}) 不受 Tiny VCC 支持。';
			case 'projects.info.project_is_sdk2': return ({required Object projectPath}) => '${projectPath} 是 VRCSDK2 项目。';
			case 'projects.info.project_is_invalid': return ({required Object projectPath}) => '${projectPath} 是无效项目。';
			case 'settings.headers.tiny_vcc_preferences': return 'Tiny VCC 首选项';
			case 'settings.headers.vcc_settings': return 'VCC 设置';
			case 'settings.labels.theme': return '主题';
			case 'settings.labels.language': return '语言';
			case 'settings.labels.unity_editors': return 'Unity 编辑器';
			case 'settings.labels.backups': return '备份';
			case 'settings.labels.user_packages': return '用户包';
			case 'settings.theme.auto': return '自动';
			case 'settings.theme.light': return '浅色';
			case 'settings.theme.dark': return '深色';
			case 'settings.lang.auto': return '自动';
			case 'new_project.title': return '新项目';
			case 'new_project.labels.project_template': return '项目模板';
			case 'new_project.labels.project_name': return '项目名称';
			case 'new_project.labels.location': return '位置';
			case 'new_project.labels.create': return '创建';
			case 'new_project.errors.select_project_template': return '请选择项目模板。';
			case 'new_project.errors.enter_project_name': return '请输入项目名称。';
			case 'new_project.errors.enter_location_path': return '请输入位置路径。';
			case 'new_project.errors.failed_to_create_project': return '创建项目失败。';
			case 'new_project.info.creating_project': return ({required Object location, required Object template, required Object name}) => '正在 ${location} 此路径创建 ${template} 项目 "${name}"。';
			case 'new_project.info.created_project': return ({required Object template, required Object name, required Object projectLocation}) => '${template} 项目 "${name}" 已在 ${projectLocation} 路径创建。';
			case 'project.labels.open_project': return '打开项目';
			case 'project.labels.open_folder': return '打开文件夹';
			case 'project.labels.make_backup': return '创建备份';
			case 'project.labels.add': return '添加';
			case 'project.labels.update': return '更新';
			case 'project.labels.downgrade': return '降级';
			case 'project.labels.remove': return '移除';
			case 'project.info.packages_changed': return '包已更改。关闭并重新打开 Unity 项目以应用更改。';
			case 'project.info.unity_not_found': return ({required Object editorVersion}) => 'VCC 设置中未找到 Unity ${editorVersion}。';
			case 'project.dialogs.progress_backup.title': return ({required Object name}) => '正在备份 ${name}';
			case 'project.dialogs.made_backup.title': return '已创建备份';
			case 'project.dialogs.made_backup.labels.show_me': return '显示';
			case 'project.dialogs.backup_error.title': return '备份错误';
			case 'project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '无法备份 ${projectName}。\n\n${error}';
			case 'legacy_project.labels.migrate': return '迁移';
			case 'legacy_project.labels.open_folder': return '打开文件夹';
			case 'legacy_project.labels.make_backup': return '创建备份';
			case 'legacy_project.dialogs.confirm.title': return '项目迁移';
			case 'legacy_project.dialogs.confirm.content': return '需要迁移。';
			case 'legacy_project.dialogs.confirm.labels.migrate_a_copy': return '迁移副本';
			case 'legacy_project.dialogs.confirm.labels.migrate_in_place': return '迁移\n我已备份';
			case 'legacy_project.dialogs.progress_backup.title': return ({required Object name}) => '正在备份 ${name}';
			case 'legacy_project.dialogs.made_backup.title': return '已创建备份';
			case 'legacy_project.dialogs.made_backup.labels.show_me': return '显示';
			case 'legacy_project.dialogs.backup_error.title': return '备份错误';
			case 'legacy_project.dialogs.backup_error.content': return ({required Object projectName, required Object error}) => '无法备份 ${projectName}。\n\n${error}';
			case 'legacy_project.dialogs.progress_migration.title': return ({required Object name}) => '正在迁移 ${name}';
			case 'requirements.title': return '要求';
			case 'requirements.labels.dotnet6sdk': return '.NET 6.0 SDK';
			case 'requirements.labels.vpm_cli': return 'VPM CLI';
			case 'requirements.labels.unity_hub': return 'Unity Hub';
			case 'requirements.labels.unity': return 'Unity';
			case 'requirements.labels.install': return '安装';
			case 'requirements.labels.check_again': return '再次检查';
			case 'requirements.info.downloading_dotnet': return '正在下载 .NET 6.0 SDK 安装程序。';
			case 'requirements.info.installing_dotnet': return '正在安装 .NET 6.0 SDK。';
			case 'requirements.info.installing_dotnet_with_brew': return '正在使用 Homebrew 安装 .NET 6.0 SDK';
			case 'requirements.info.see_terminal_to_continue': return '请查看终端应用程序以继续安装。';
			case 'requirements.info.installing_vpm': return '正在安装 VPM CLI';
			case 'requirements.info.downloading_unity_hub': return '正在下载 Unity Hub 安装程序。';
			case 'requirements.info.installing_unity_hub': return '正在安装 Unity Hub。';
			case 'requirements.info.installing_unity': return '正在安装 Unity';
			case 'requirements.description.dotnet': return '安装 .NET 6.0 SDK。您也可以从网页下载 SDK 安装程序。';
			case 'requirements.description.dotnet_brew': return '使用 Homebrew 安装 .NET 6.0 SDK。您也可以使用以下命令安装。';
			case 'requirements.description.dotnet_linux': return '使用包管理器安装 .NET 6.0 SDK。请参阅以下说明。';
			case 'requirements.description.vpm': return '安装 VPM CLI。您也可以使用以下命令安装。';
			case 'requirements.description.unity_hub': return '安装 Unity Hub。您也可以从网页下载安装程序。';
			case 'requirements.description.unity_hub_linux': return '安装 Unity Hub。请参阅以下说明。';
			case 'requirements.description.unity': return '使用 Unity Hub 安装 Unity。您也可以从归档文件安装，但应安装 VRChat 指定的确切版本。';
			case 'requirements.description.unity_modules': return '在手动安装中，您必须一起安装以下模块：';
			case 'requirements.description.unity_modules_android': return 'Android Build Support（用来上传到 Quest）';
			case 'requirements.description.unity_modules_mono': return 'Windows Build Support (mono)（用来从 macOS 或 Linux 上传到 PC）';
			case 'requirements.errors.failed_to_isntall_dotnet': return '.NET SDK 安装失败';
			case 'requirements.errors.failed_to_isntall_vpm': return 'VPM CLI 安装失败';
			case 'requirements.errors.failed_to_isntall_unity_hub': return 'Unity Hub 安装失败';
			case 'requirements.errors.failed_to_isntall_unity': return 'Unity 安装失败';
			default: return null;
		}
	}
}
