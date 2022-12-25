import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';

import '../globals.dart';
import '../repos/requirements_repository.dart';

class RequirementsModel extends ChangeNotifier {
  RequirementsModel(BuildContext context) : _req = context.read();

  final RequirementsRepository _req;

  RequirementState get hasDotNet6 =>
      _combineStates([hasDotNetCommand, hasDotNet6Sdk]);

  RequirementState get hasVpm => _combineStates([hasVpmCommand, hasCorrectVpm]);

  RequirementState _hasDotNetCommand = RequirementState.notChecked;
  RequirementState get hasDotNetCommand => _hasDotNetCommand;

  RequirementState _hasDotNet6Sdk = RequirementState.notChecked;
  RequirementState get hasDotNet6Sdk => _hasDotNet6Sdk;

  RequirementState _hasVpmCommand = RequirementState.notChecked;
  RequirementState get hasVpmCommand => _hasVpmCommand;

  RequirementState _hasCorrectVpm = RequirementState.notChecked;
  RequirementState get hasCorrectVpm => _hasCorrectVpm;

  RequirementState _hasUnityHub = RequirementState.notChecked;
  RequirementState get hasUnityHub => _hasUnityHub;

  RequirementState _hasUnity = RequirementState.notChecked;
  RequirementState get hasUnity => _hasUnity;

  bool get isReadyToUse {
    return hasDotNet6 == RequirementState.ok &&
        hasVpm == RequirementState.ok &&
        hasUnityHub == RequirementState.ok &&
        hasUnity == RequirementState.ok;
  }

  bool _isFetchingRequirements = false;
  bool get isFetchingRequirements => _isFetchingRequirements;

  Future<void> fetchRequirements() async {
    _isFetchingRequirements = true;
    notifyListeners();
    await _fetchRequirements();
    _isFetchingRequirements = false;
    notifyListeners();
  }

  Future<void> _fetchRequirements() async {
    _resetState();
    notifyListeners();
    await for (final state in _checkAsStream(_req.checkDotNetCommand)) {
      _hasDotNetCommand = state;
      notifyListeners();
    }
    if (_hasDotNetCommand != RequirementState.ok) {
      return;
    }

    await for (final state in _checkAsStream(_req.checkDotNet6Sdk)) {
      _hasDotNet6Sdk = state;
      notifyListeners();
    }
    if (_hasDotNet6Sdk != RequirementState.ok) {
      return;
    }

    await for (final state in _checkAsStream(_req.checkVpmCommand)) {
      _hasVpmCommand = state;
      notifyListeners();
    }
    if (_hasVpmCommand != RequirementState.ok) {
      return;
    }

    await for (final state
        in _checkAsStream(() => _req.checkVpmVersion(Version(0, 1, 13)))) {
      _hasCorrectVpm = state;
      notifyListeners();
    }
    if (_hasCorrectVpm != RequirementState.ok) {
      return;
    }

    await for (final state in _checkAsStream(_req.checkUnityHub)) {
      _hasUnityHub = state;
      notifyListeners();
    }
    if (_hasUnityHub != RequirementState.ok) {
      return;
    }

    await for (final state in _checkAsStream(_req.checkUnity)) {
      _hasUnity = state;
      notifyListeners();
    }
    if (_hasUnity != RequirementState.ok) {
      return;
    }
  }

  Future<void> installVpmCli() {
    return _req.installVpmCli(requiredVpmVersion);
  }

  Future<void> updateVpmCli() {
    return _req.updateVpmCli(requiredVpmVersion);
  }

  void _resetState() {
    _hasDotNetCommand = RequirementState.notChecked;
    _hasDotNet6Sdk = RequirementState.notChecked;
    _hasVpmCommand = RequirementState.notChecked;
    _hasCorrectVpm = RequirementState.notChecked;
    _hasUnityHub = RequirementState.notChecked;
    _hasUnity = RequirementState.notChecked;
  }

  Stream<RequirementState> _checkAsStream(Future<bool> Function() func) async* {
    yield RequirementState.checking;
    final result = await func();
    yield result ? RequirementState.ok : RequirementState.ng;
  }

  RequirementState _combineStates(List<RequirementState> states) {
    if (states.contains(RequirementState.checking)) {
      return RequirementState.checking;
    }
    if (states.contains(RequirementState.ng)) {
      return RequirementState.ng;
    }
    final set = states.toSet();
    if (set.length == 1 && set.first == RequirementState.ok) {
      return RequirementState.ok;
    }
    return RequirementState.notChecked;
  }
}

enum RequirementState {
  notChecked,
  checking,
  ng,
  ok,
}
