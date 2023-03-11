import 'package:flutter/widgets.dart';

enum ScreenSizeClass { small, normal, large }

ScreenSizeClass getScreenSizeClass(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth < 600) return ScreenSizeClass.small;
  if (deviceWidth < 900) return ScreenSizeClass.normal;
  return ScreenSizeClass.large;
}
