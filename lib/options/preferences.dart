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
