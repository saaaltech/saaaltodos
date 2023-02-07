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
      updateAll();
    }
  }

  void updateAll() {
    for (final key in attachedStates) {
      // ignore:invalid_use_of_protected_member
      key.currentState?.setState(() {});
    }
  }

  void attach(GlobalKey key) => attachedStates.add(key);
  void cancel(GlobalKey key) => attachedStates.remove(key);
  void removeAll() => attachedStates.clear();
}

class ListOption<T> extends Option<List<T>> {
  ListOption({List<T>? defaultValue, this.repeatable = false})
      : super(defaultValue ?? []) {
    if (!repeatable) {
      final generator = <T>[];
      for (final item in _value) {
        if (!_value.contains(item)) generator.add(item);
      }
      _value = generator;
    }
  }

  late bool repeatable;

  void add(T item) {
    if (repeatable || !_value.contains(item)) {
      _value.add(item);
      updateAll();
    }
  }

  void remove(T item, {bool removeAll = false}) {
    while (_value.remove(item) && removeAll) {}
    updateAll();
  }

  void clear() {
    _value.clear();
    updateAll();
  }
}

class MapOption<K, V> extends Option<Map<K, V>> {
  MapOption({Map<K, V>? defaultValue}) : super(defaultValue ?? {});
}
