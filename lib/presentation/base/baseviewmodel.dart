import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../common/state_renderer/state_render_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs implements BaseViewModelOutputs {
  final StreamController _inputStateStreamController = BehaviorSubject<FlowState>();

  @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStateStreamController.close();
  }

  void resetFlowState() {
    inputState.add(ContentState());
  }

  // static final _rootNavKey = GlobalKey(debugLabel: 'alertDialog');
  //
  // static BuildContext get ctx => _rootNavKey.currentContext!;
  //
  // static void popDialogIfShowing() {
  //   if (ModalRoute.of(ctx)?.isCurrent != true) {
  //     Navigator.of(ctx, rootNavigator: true).pop(true);
  //   }
  // }
// shared variables and functions that will be used through any view model.
}

abstract class BaseViewModelInputs {
  void start(); // will be called while init. of view model
  void dispose(); // will be called when viewmodel dies.

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
