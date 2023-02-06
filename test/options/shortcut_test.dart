import 'package:change_case/change_case.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saaaltodos/options/shortcut.dart';

void main() => testShortcut();

void testShortcut() {
  group('shortcut:', () {
    test('resolve key from label', () {
      // Letters.
      expect(resolveKeyFromLabel('a'.toCapitalCase()), LogicalKeyboardKey.keyA);
      expect(resolveKeyFromLabel('b'.toCapitalCase()), LogicalKeyboardKey.keyB);
      expect(resolveKeyFromLabel('c'.toCapitalCase()), LogicalKeyboardKey.keyC);
      expect(resolveKeyFromLabel('x'.toCapitalCase()), LogicalKeyboardKey.keyX);
      expect(resolveKeyFromLabel('y'.toCapitalCase()), LogicalKeyboardKey.keyY);
      expect(resolveKeyFromLabel('z'.toCapitalCase()), LogicalKeyboardKey.keyZ);

      // Special keys
      expect(
        resolveKeyFromLabel('escape'.toCapitalCase()),
        LogicalKeyboardKey.escape,
      );
      expect(
        resolveKeyFromLabel('tab'.toCapitalCase()),
        LogicalKeyboardKey.tab,
      );
      expect(
        resolveKeyFromLabel('caps lock'.toCapitalCase()),
        LogicalKeyboardKey.capsLock,
      );
    });

    test('single activator convert', () {
      final shortcut = parseShortcut('control+shift+alt+meta+A');
      const expected = SingleActivator(
        LogicalKeyboardKey.keyA,
        control: true,
        shift: true,
        meta: true,
        alt: true,
      );

      // Cannot directly compare for their hashcodes are different.
      expect(shortcut?.trigger, expected.trigger);
      expect(shortcut?.control, expected.control);
      expect(shortcut?.shift, expected.shift);
      expect(shortcut?.meta, expected.meta);
      expect(shortcut?.alt, expected.alt);
    });
  });
}
