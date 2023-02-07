import 'package:change_case/change_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saaaltodos/build_options.dart';
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
  final locale = LocaleOption(defaultLocale);
  final textDirection = TextDirectionOption(TextDirectionMode.asLocale);
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

class LocaleOption extends Option<Locale> {
  LocaleOption(super.value);

  String get code => value.toLanguageTag().toKebabCase();

  /// Update locale.
  ///
  /// It will check whether the locale is supported by current app.
  /// If you are setting an unsupported locale
  /// (not in [AppLocalizations.supportedLocales]),
  /// it will throw an exception.
  ///
  @override
  set value(Locale newValue) {
    if (!AppLocalizations.supportedLocales.contains(newValue)) {
      throw Exception('set unsupported locale');
    }
    super.value = newValue;
  }

  /// Convert from locale code into existing supported [Locale] value
  /// and then apply the value.
  ///
  /// If there's no such supported locale or code is invalid,
  /// then nothing will happen.
  ///
  void resolveLocale(dynamic raw) {
    if (raw is! String) return;

    final parts = raw.toKebabCase().split('-');
    final locales = List.generate(
      AppLocalizations.supportedLocales.length,
      (index) => AppLocalizations.supportedLocales[index]
          .toLanguageTag()
          .toKebabCase(),
    );

    int index = -1;
    int match = 0;
    for (int i = 0; i < locales.length; i++) {
      int currentMatch = 0;
      for (final localePart in locales[i].split('-')) {
        for (final part in parts) {
          if (localePart == part) currentMatch++;
        }
      }

      if (currentMatch > match) {
        match = currentMatch;
        index = i;
      }
    }

    if (index != -1) value = AppLocalizations.supportedLocales[index];
  }
}

enum TextDirectionMode {
  asLocale,
  forceRtl,
  forceLtr;
}

class TextDirectionOption extends Option<TextDirectionMode> {
  TextDirectionOption(super.value);

  bool rtl(BuildContext context) => value == TextDirectionMode.asLocale
      ? AppLocalizations.of(context)!.rtl == 'true'
      : value == TextDirection.rtl;

  TextDirection resolve(BuildContext context) =>
      rtl(context) ? TextDirection.rtl : TextDirection.ltr;
}
