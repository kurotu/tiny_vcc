/// VCC settings.json
class VccSettings {
  VccSettings({
    required this.pathToUnityExe,
    required this.pathToUnityHub,
    required this.projectBackupPath,
    required this.userProjects,
    required this.unityEditors,
    required this.defaultProjectPath,
    required this.userPackageFolders,
    required this.showPrereleasePackages,
    required this.userRepos,
  });

  final String pathToUnityExe;
  final String pathToUnityHub;
  final String projectBackupPath;
  final List<String> userProjects;
  final List<String> unityEditors;
  final String defaultProjectPath;
  final List<String> userPackageFolders;
  final bool showPrereleasePackages;
  final List<String> userRepos;
}
