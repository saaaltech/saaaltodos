import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saaaltodos/extensions.dart';

class StatesHandler {
  final attachedStates = <GlobalKey>[];

  void attach(GlobalKey key) => attachedStates.add(key);
  void remove(GlobalKey key) => attachedStates.remove(key);
  void removeAll() => attachedStates.clear();

  void updateStates() {
    for (final key in attachedStates) {
      // ignore:invalid_use_of_protected_member
      key.currentState?.setState(() {});
    }
  }
}

class ActionsHandler<T> {
  final _broadcaster = StreamController<T>.broadcast();
  final _actions = <int, StreamSubscription<T>>{};

  void cancel(int id) => _actions.remove(id);
  void cancelAll() => _actions.clear();

  int _resolveUniqueId(
    void Function(T)? action, {
    Function? onError,
    void Function()? onDone,
  }) {
    if (action != null) return action.hashCode;
    if (onError != null) return onError.hashCode;
    if (onDone != null) return onDone.hashCode;

    int result = random.nextHash;
    while (true) {
      if (!_actions.keys.contains(result)) {
        return result;
      }
      result++;
    }
  }

  Function? _resolveCancelOnError({
    Function? onError,
    bool? cancelOnError,
  }) {
    return onError != null && cancelOnError == true
        ? (dynamic err) {
            _actions.remove(123);
            onError is dynamic Function(dynamic) ? onError(err) : onError();
          }
        : onError;
  }

  int bind(
    void Function(T value)? action, {
    int? id,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      bindOverwrite(
        action,
        id: id,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  int bindOverwrite(
    void Function(T value)? action, {
    int? id,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (id == null) {
      return bindUnique(
        action,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
    }

    _actions[id] = _broadcaster.stream.listen(
      action,
      onDone: onDone,
      onError: _resolveCancelOnError(
        onError: onError,
        cancelOnError: cancelOnError,
      ),
      cancelOnError: false,
    );

    return id;
  }

  int bindUnique(
    void Function(T value)? action, {
    int? id,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    id = id ?? _resolveUniqueId(action, onError: onError, onDone: onDone);

    _actions[id] = _broadcaster.stream.listen(
      action,
      onDone: onDone,
      onError: _resolveCancelOnError(
        onError: onError,
        cancelOnError: cancelOnError,
      ),
      cancelOnError: false,
    );

    return id;
  }

  int bindCheck(
    void Function(T value)? action, {
    int? id,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (_actions.containsKey(id)) {
      throw Exception('cannot bind action for id [$id] already exist');
    }

    return bindUnique(
      action,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class Option<T> extends ActionsHandler<T> with StatesHandler {
  Option(this._value);

  T _value;

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      updateStates();
      _broadcaster.sink.add(_value);
    }
  }

  void update(T Function(T) setter) {
    _value = setter(_value);
    updateStates();
  }
}
