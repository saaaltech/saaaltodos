import 'package:flutter/material.dart';

class ValueHandler<T> {
  ValueHandler(this._value);

  T _value;

  // ignore:unnecessary_getters_setters
  T get value => _value;
  set value(T newValue) {
    _value = newValue;
  }
}

class Option<T> extends ValueHandler<T> {
  Option(super.value);

  final attachedStates = <GlobalKey>[];

  @override
  set value(T newValue) {
    if (_value != newValue) {
      super.value = newValue;
      for (final key in attachedStates) {
        // ignore:invalid_use_of_protected_member
        key.currentState?.setState(() {});
      }
    }
  }

  void attach(GlobalKey key) => attachedStates.add(key);
  void remove(GlobalKey key) => attachedStates.remove(key);
  void removeAll() => attachedStates.clear();
}
