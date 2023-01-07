import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

class ConsoleDialog extends ConsumerWidget {
  const ConsoleDialog({
    super.key,
    required this.title,
    required this.terminal,
    this.actions,
  });

  final String title;
  final Terminal terminal;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TerminalView(terminal),
      ),
      actions: actions,
    );
  }
}
