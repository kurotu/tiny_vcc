import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';

/// Writes the log output to a file. To avoid compile error, copied FileOutput.
/// https://github.com/simc/logger/blob/master/lib/src/outputs/file_output.dart
class TinyVCCFileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  TinyVCCFileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  void init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
