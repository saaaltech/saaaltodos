import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:saaaltodos/layouts/terminal.dart';
import 'package:saaaltodos/options/handler.dart';

/// Global instance of [UserShortcuts],
/// also as default value.
///
final shortcuts = UserShortcuts(
  global: ShortcutsOptions.fromIntents({
    // Terminal container show and hide control.
    const TerminalIntent(): [
      const SingleActivator(LogicalKeyboardKey.keyK, control: true),
      const SingleActivator(LogicalKeyboardKey.keyK, meta: true),
    ],
    const TerminalIntent(onlyHide: true): [
      const SingleActivator(LogicalKeyboardKey.escape),
    ],
  }),
);

class UserShortcuts {
  UserShortcuts({required this.global});

  /// Global shortcuts which are supposed to be registered onto app root.
  final ShortcutsOptions global;
}

class ShortcutsOptions extends Option<Map<SingleActivator, Intent>> {
  ShortcutsOptions(super.value);

  factory ShortcutsOptions.fromIntents(Map<Intent, List<SingleActivator>> map) {
    final generator = <SingleActivator, Intent>{};
    for (final intent in map.keys) {
      for (final shortcut in map[intent]!) {
        if (!generator.containsKey(shortcut)) {
          generator[shortcut] = intent;
          continue;
        }

        throw Exception(
          'intents conflict for shortcut [${shortcut.code}]:\n'
          '- ${generator[map[intent]]}\n'
          '- $intent',
        );
      }
    }

    return ShortcutsOptions(generator);
  }
}

// Code convert syntax define.
const controlAndSep = 'control$shortcutSep';
const shiftAndSep = 'shift$shortcutSep';
const metaAndSep = 'meta$shortcutSep';
const altAndSep = 'alt$shortcutSep';
const shortcutSep = '+';

/// Parse shortcuts from a dynamic raw (expect to be list string).
///
/// When return null, it means invalid,
/// that the shortcut will not update.
/// Invalid is not blank.
///
List<SingleActivator>? parseShortcuts(dynamic raw) {
  if (raw is! List<String>) return null;

  final generator = <SingleActivator>[];
  for (final code in raw) {
    final result = parseShortcut(code);
    if (result != null) generator.add(result);
  }
  return generator;
}

SingleActivator? parseShortcut(dynamic raw) {
  if (raw is SingleActivator) return raw;
  if (raw is String) return parseShortcutFromString(raw);
  return null;
}

SingleActivator? parseShortcutFromString(String raw) {
  final trigger = resolveKeyFromLabel(raw.split(shortcutSep).last);
  if (trigger == null) return null;

  return SingleActivator(
    trigger,
    control: raw.contains(controlAndSep),
    shift: raw.contains(shiftAndSep),
    meta: raw.contains(metaAndSep),
    alt: raw.contains(altAndSep),
  );
}

LogicalKeyboardKey? resolveKeyFromLabel(String raw) {
  for (final key in LogicalKeyboardKey.knownLogicalKeys) {
    if (key.keyLabel == raw) return key;
  }
  return null;
}

extension ShortcutGenerator on Map<Intent, List<SingleActivator>> {
  Map<SingleActivator, Intent> get shortcuts {
    final generator = <SingleActivator, Intent>{};
    for (final intent in keys) {
      for (final shortcut in this[intent]!) {
        generator[shortcut] = intent;
      }
    }
    return generator;
  }
}

extension ShortcutsApis on List<SingleActivator> {
  List<String> get codeList {
    return List.generate(length, (index) => this[index].code);
  }
}

extension SingleActivatorJsonApis on SingleActivator {
  /// A string code representing this shortcut combination.
  /// It is usually used in json convert for persistence.
  ///
  String get code {
    final control = this.control ? controlAndSep : '';
    final shift = this.shift ? shiftAndSep : '';
    final meta = this.meta ? metaAndSep : '';
    final alt = this.alt ? altAndSep : '';

    final trigger = this.trigger.keyLabel;

    return '$control$shift$meta$alt$trigger';
  }
}
