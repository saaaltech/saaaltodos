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

class ListOptions<T> extends StatesHandler {
  ListOptions({List<T>? defaultValue, this.repeatable = false}) {
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

class MapOptions<K, V> extends StatesHandler {
  MapOptions({Map<K, V>? defaultValue}) {
    _value = defaultValue ?? {};
  }

  late final Map<K, V> _value;

  void set(K key, V value) {
    _value[key] = value;
    updateAll();
  }

  void sets(Map<K, V> map) {
    _value.addAll(map);
    updateAll();
  }

  void remove(K key) {
    _value.remove(key);
    updateAll();
  }

  void clear() {
    _value.clear();
    updateAll();
  }
}
