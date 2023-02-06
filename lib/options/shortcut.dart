import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:saaaltodos/options/handler.dart';

/// Global instance of [UserShortcuts].
///
/// There are usually only one user shortcuts instance in the whole app.
/// You can use it as the default value of the controller widgets.
///
final shortcuts = UserShortcuts();

class UserShortcuts {
  final switchTerminal = Option('value');
}

class ShortcutOption extends ListOption<SingleActivator> {
  ShortcutOption(super.value);

  List<String> get codeList => List.generate(
        value.length,
        (index) => value[index].code,
      );

  void addFromString(String raw) {
    final result = parseShortcut(raw);
    if (result != null) add(result);
  }

  void fromList(List<String> raw) {
    final generator = <SingleActivator>[];
    for (final code in raw) {
      final result = parseShortcut(code);
      if (result != null) generator.add(result);
    }
    value = generator;
  }

  void from(dynamic raw) {
    if (raw is String) addFromString(raw);
    if (raw is List<String>) fromList(raw);
  }
}

const controlAndSep = 'control$shortcutSep';
const shiftAndSep = 'shift$shortcutSep';
const metaAndSep = 'meta$shortcutSep';
const altAndSep = 'alt$shortcutSep';
const shortcutSep = '+';

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
