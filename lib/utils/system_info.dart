import 'dart:io';

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
    switch (SysInfo.kernelArchitecture) {
      case ProcessorArchitecture.arm64:
        return Architecture.arm64;
      case ProcessorArchitecture.x86_64:
        return Architecture.x64;
      case ProcessorArchitecture.x86:
        return Architecture.x86;
      default:
        // %PROCESSOR_ARCHITECTURE% may be AMD64 on Windows 11.
        if (Platform.isWindows && SysInfo.rawKernelArchitecture == 'AMD64') {
          return Architecture.x64;
        }
        return Architecture.unknown;
    }
  }
}
