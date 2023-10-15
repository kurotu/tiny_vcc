import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:system_info2/system_info2.dart';
import 'package:tiny_vcc/utils/system_info.dart';

void main() {
    test("SysInfo.kernelArchitecture on Mac", () {
        final result = Process.runSync('uname', ['-m']);
        final architecture = result.stdout.trim();
        if (architecture == 'x86_64') {
            expect(SysInfo.kernelArchitecture, ProcessorArchitecture.x86_64);
        } else if (architecture == 'arm64') {
            expect(SysInfo.kernelArchitecture, ProcessorArchitecture.arm64);
        } else {
            fail('Unknown architecture: $architecture');
        }
    }, skip: !Platform.isMacOS);

    test("SystemInfo.arch on Mac", () {
        final result = Process.runSync('uname', ['-m']);
        final architecture = result.stdout.trim();
        if (architecture == 'x86_64') {
            expect(SystemInfo.arch, Architecture.x64);
        } else if (architecture == 'arm64') {
            expect(SystemInfo.arch, Architecture.arm64);
        } else {
            fail('Unknown architecture: $architecture');
        }
    }, skip: !Platform.isMacOS);
}
