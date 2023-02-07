import 'package:flutter/material.dart';

class StatesHandler {
  final attachedStates = <GlobalKey>[];

  void attach(GlobalKey key) => attachedStates.add(key);
  void cancel(GlobalKey key) => attachedStates.remove(key);
  void removeAll() => attachedStates.clear();

  void updateAll() {
    for (final key in attachedStates) {
      // ignore:invalid_use_of_protected_member
      key.currentState?.setState(() {});
    }
  }
}

class Option<T> extends StatesHandler {
  Option(this._value);

  T _value;

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      updateAll();
    }
  }
}

class ListOption<T> extends StatesHandler {
  ListOption({List<T>? defaultValue, this.repeatable = false}) {
    _value = defaultValue ?? [];

    if (!repeatable) {
      final generator = <T>[];
      for (final item in _value) {
        if (!_value.contains(item)) generator.add(item);
      }
      _value = generator;
    }
  }

  late final List<T> _value;

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
