import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saaaltodos/options/handler.dart';

/// Global instance of [UserPreference].
///
/// There are usually only one user preferences instance in the whole app.
/// You can use it as the default value of the controller widgets.
///
final preference = UserPreference();

class UserPreference {
  UserPreference();

  final themeMode = ThemeModeOption(ThemeMode.system);
}

class ThemeModeOption extends Option<ThemeMode> {
  ThemeModeOption(super.value);

  // Getter of whether dark mode and brightness.
  Brightness get brightness => dark ? Brightness.dark : Brightness.light;
  bool get dark => value == ThemeMode.system
      ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
      : value == ThemeMode.dark;

  // Helper of theme mode change.
  void toDark() => value = ThemeMode.dark;
  void toLight() => value = ThemeMode.light;
  void toSystem() => value = ThemeMode.system;
}
