import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsoleDialog extends ConsumerWidget {
  const ConsoleDialog({
    super.key,
    required this.title,
    required this.consoleOutputProvider,
    this.actions,
  });

  final String title;
  final ProviderListenable<String> consoleOutputProvider;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(consoleOutputProvider);
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black87),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  child: Text(
                    message.trim(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
