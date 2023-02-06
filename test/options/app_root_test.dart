import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/app_root.dart';
import 'package:saaaltodos/options/handler.dart';
import 'package:saaaltodos/options/preferences.dart';

void main() => testAppRoot();

void testAppRoot() {
  group('app root:', () {
    testWidgets('theme mode', (t) async {
      await t.pumpWidget(
        AppRoot(
          preferenceController: preference,
          home: Scaffold(
            body: DarkStateValidation(
              themeModeController: preference.themeMode,
            ),
          ),
        ),
      );

      expect(find.text('brightness: $platformBrightness'), findsOneWidget);
      expect(find.text('platform: $platformBrightness'), findsOneWidget);

      await t.tap(find.text('to dark'));
      await t.pump();
      await t.pump();
      expect(find.text('brightness: ${Brightness.dark}'), findsOneWidget);
    });
  });
}

class DarkModeValidation extends StatelessWidget {
  const DarkModeValidation({
    Key? key,
    required this.themeModeController,
  }) : super(key: key);

  final Option<ThemeMode> themeModeController;

  void toDark() => themeModeController.value = ThemeMode.dark;
  void toLight() => themeModeController.value = ThemeMode.light;
  void toSystem() => themeModeController.value = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('brightness: ${brightness(context)}'),
        Text('platform: $platformBrightness'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: toDark, child: const Text('to dark')),
            TextButton(onPressed: toLight, child: const Text('to light')),
            TextButton(onPressed: toSystem, child: const Text('to system')),
          ],
        ),
      ],
    );
  }
}

class DarkStateValidation extends StatefulWidget {
  DarkStateValidation({
    GlobalKey? key,
    required this.themeModeController,
  }) : super(key: key ?? GlobalKey(debugLabel: 'dark theme validation'));

  final Option<ThemeMode> themeModeController;

  @override
  State<DarkStateValidation> createState() => _DarkStateValidationState();
}

class _DarkStateValidationState extends State<DarkStateValidation> {
  late final key = widget.key as GlobalKey;

  void toDark() => widget.themeModeController.value = ThemeMode.dark;
  void toLight() => widget.themeModeController.value = ThemeMode.light;
  void toSystem() => widget.themeModeController.value = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    widget.themeModeController.attach(key);
  }

  @override
  void dispose() {
    widget.themeModeController.remove(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('brightness: $brightness'),
        Text('platform: $platformBrightness'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: toDark, child: const Text('to dark')),
            TextButton(onPressed: toLight, child: const Text('to light')),
            TextButton(onPressed: toSystem, child: const Text('to system')),
          ],
        ),
      ],
    );
  }
}
