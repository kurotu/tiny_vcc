import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationRailFab extends StatelessWidget {
  const NavigationRailFab({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // The extended fab has a shorter height than the regular fab.
        return Container(
          height: 56,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(0, 6, animation.value)!,
          ),
          child: animation.value == 0
              ? FloatingActionButton(
                  onPressed: onPressed,
                  child: icon,
                )
              : Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: animation.value,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: FloatingActionButton.extended(
                      icon: icon,
                      label: label,
                      onPressed: onPressed,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
