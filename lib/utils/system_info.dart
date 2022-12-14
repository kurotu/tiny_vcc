import 'package:system_info2/system_info2.dart';

enum Architecture {
  arm64,
  x64,
  x86,
  unknown,
}

class SystemInfo {
  /// See https://sysinfo.onepub.dev/reference/sysinfo/kernelarchitecture.
  static Architecture get arch {
    final core = SysInfo.cores[0];
    switch (core.architecture) {
      case ProcessorArchitecture.arm:
        return Architecture.arm64;
      case ProcessorArchitecture.x86_64:
        return Architecture.x64;
      case ProcessorArchitecture.x86:
        return Architecture.x86;
      default:
        return Architecture.unknown;
    }
  }
}
