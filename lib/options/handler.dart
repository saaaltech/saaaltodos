import 'dart:async';

import 'package:flutter/material.dart';

class StatesHandler {
  final attachedStates = <GlobalKey>[];

  void attach(GlobalKey key) => attachedStates.add(key);
  void cancel(GlobalKey key) => attachedStates.remove(key);
  void removeAll() => attachedStates.clear();

  void updateStates() {
    for (final key in attachedStates) {
      // ignore:invalid_use_of_protected_member
      key.currentState?.setState(() {});
    }
  }
}

class ActionsHandler<T> {
  final broadcaster = StreamController<T>.broadcast();
  final actions = <int, StreamSubscription<T>>{};
}

class Option<T> extends StatesHandler {
  Option(this._value);

  T _value;

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      updateStates();
    }
  }

  void update(T Function(T) setter) {
    _value = setter(_value);
    updateStates();
  }
}
