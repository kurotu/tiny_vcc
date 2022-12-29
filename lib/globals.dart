import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pub_semver/pub_semver.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final requiredVpmVersion = Version(0, 1, 13);

/// Logger to output logs.
Logger? logger;
