import '../services/vcc_service.dart';

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

class VccProjectTypeException implements Exception {
  VccProjectTypeException(message, this.projectType) : _message = message;

  final String _message;
  final VccProjectType projectType;

  @override
  String toString() {
    return 'VccProjectTypeException: $_message';
  }
}
