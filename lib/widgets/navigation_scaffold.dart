import 'package:flutter/material.dart';

class NavigationScaffold extends Scaffold {
  NavigationScaffold({
    AppBar? appBar,
    required bool useNavigationRail,
    required Widget drawer,
    required NavigationRail navigationRail,
    required Widget body,
    Widget? floatingActionButton,
    super.key,
  }) : super(
          appBar: appBar,
          drawer: useNavigationRail ? null : drawer,
          body: useNavigationRail
              ? Row(children: [
                  navigationRail,
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: body),
                ])
              : body,
          floatingActionButton: floatingActionButton,
        );
}
