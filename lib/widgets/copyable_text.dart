import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  CopyableText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SelectableText(text),
        IconButton(
          iconSize: 16,
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
          onPressed: () async {
            final data = ClipboardData(text: text);
            await Clipboard.setData(data);
          },
        ),
      ],
    );
  }
}
