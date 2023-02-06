import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/handler.dart';
import 'package:saaaltodos/options/preferences.dart';

class DarkModeValidation extends StatelessWidget {
  DarkModeValidation({
    Key? key,
    UserPreference? userPreference,
  }) : super(key: key) {
    themeMode = (userPreference ?? preference).themeMode;
  }

  late final ThemeModeOption themeMode;

  void toDark() => themeMode.toDark();
  void toLight() => themeMode.toLight();
  void toSystem() => themeMode.toSystem();

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
