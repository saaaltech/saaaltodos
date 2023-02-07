import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saaaltodos/options/app_root.dart';
import 'package:saaaltodos/options/preferences.dart';

void main() => testAppRoot();

void testAppRoot() {
  group('app root:', () {
    testWidgets('locale', (t) async {
      final preference = UserPreference();
      await t.pumpWidget(AppRoot(
        userPreference: preference,
        home: Scaffold(
          body: LocaleValidation(
            preference: preference,
          ),
        ),
      ));

      await t.tap(find.text('to en'));
      await t.pump();
      expect(find.text('language: English'), findsOneWidget);
      expect(find.text('area: United States'), findsOneWidget);

      await t.tap(find.text('to zh'));
      await t.pump();
      expect(find.text('language: 中文'), findsOneWidget);
      expect(find.text('area: 简体'), findsOneWidget);
    });
  });
}

class LocaleValidation extends StatelessWidget {
  LocaleValidation({Key? key, required this.preference}) : super(key: key);

  final UserPreference preference;

  void toEn() => preference.locale.value = const Locale('en');
  void toZh() => preference.locale.value = const Locale('zh');

  late final controlButtons = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextButton(onPressed: () => toEn(), child: const Text('to en')),
      TextButton(onPressed: () => toZh(), child: const Text('to zh')),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('language: ${AppLocalizations.of(context)!.theLanguageName}'),
        Text('area: ${AppLocalizations.of(context)!.theLocaleAreaName}'),
        controlButtons,
      ],
    );
  }
}
