import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

SpeedDial m3SpeedDial({
  IconData? icon,
  Widget? label,
  bool isExtended = false,
  bool switchLabelPosition = false,
  SpeedDialDirection direction = SpeedDialDirection.up,
  List<SpeedDialChild> children = const [],
}) {
  return SpeedDial(
    icon: icon,
    label: isExtended ? label : null,
    direction: direction,
    switchLabelPosition: switchLabelPosition,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    spacing: 16,
    childMargin: EdgeInsets.zero,
    childPadding: const EdgeInsets.all(8.0),
    children: children,
  );
}

SpeedDialChild m3SpeedDialChild({
  String? label,
  Widget? child,
  void Function()? onTap,
}) {
  return SpeedDialChild(
    label: label,
    child: child,
    onTap: onTap,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}
