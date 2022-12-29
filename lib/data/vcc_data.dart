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

  VccSettings copyWith({
    String? pathToUnityExe,
    String? pathToUnityHub,
    String? projectBackupPath,
    List<String>? userProjects,
    List<String>? unityEditors,
    String? defaultProjectPath,
    List<String>? userPackageFolders,
    bool? showPrereleasePackages,
    List<String>? userRepos,
  }) {
    return VccSettings(
      pathToUnityExe: pathToUnityExe ?? this.pathToUnityExe,
      pathToUnityHub: pathToUnityHub ?? this.pathToUnityHub,
      projectBackupPath: projectBackupPath ?? this.projectBackupPath,
      userProjects: userProjects ?? [...this.userProjects],
      unityEditors: unityEditors ?? [...this.unityEditors],
      defaultProjectPath: defaultProjectPath ?? this.defaultProjectPath,
      userPackageFolders: userPackageFolders ?? [...this.userPackageFolders],
      showPrereleasePackages:
          showPrereleasePackages ?? this.showPrereleasePackages,
      userRepos: userRepos ?? [...this.userRepos],
    );
  }
}
