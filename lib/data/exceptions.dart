class NonZeroExitException implements Exception {
  NonZeroExitException(this.executable, this.arguments, this.exitCode);

  final String executable;
  final List<String> arguments;
  final int exitCode;

  @override
  String toString() {
    final argStr =
        arguments.map((arg) => arg.contains(' ') ? '"$arg"' : arg).join(' ');
    final exeStr = executable.contains(' ') ? '"$executable"' : executable;
    final command = argStr == '' ? exeStr : '$exeStr $argStr';
    return 'NonZeroExitException: $command returned non-zero exit code $exitCode.';
  }
}
