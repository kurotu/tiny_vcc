import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pub_semver/pub_semver.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
const vpmPackageId = 'vrchat.vpm.cli';
final requiredVpmVersion = Version(0, 1, 13);
const requiredUnityVersion = '2019.4.31f1';
const requiredUnityChangeset = 'bd5abf232a62';

/// Logger to output logs.
Logger? logger;
