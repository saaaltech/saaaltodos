import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/preferences.dart';
import 'package:saaaltodos/options/shortcut.dart';

class AppRoot extends StatefulWidget {
  AppRoot({
    GlobalKey? key,
    // Options handlers.
    UserPreference? userPreference,

    // Routes.
    Widget? home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
  }) : super(key: key ?? GlobalKey(debugLabel: 'app root')) {
    // Options handlers.
    this.userPreference = userPreference ?? preference;

    // Default display.
    this.home = routes.isEmpty && initialRoute == null
        ? home ?? const Scaffold(body: CenterText('app root home'))
        : null;
  }

  // User preferences.
  late final UserPreference userPreference;

  // Routes.
  late final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final Widget Function(BuildContext, Widget?)? builder;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  // Aliases as sugars.
  late final key = widget.key as GlobalKey;
  late final preference = widget.userPreference;

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    preference.themeMode.attach(key);
    preference.locale.attach(key);
    shortcuts.global.attach(key);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    preference.themeMode.cancel(key);
    preference.locale.cancel(key);
    shortcuts.global.cancel(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Controllers.
      themeMode: preference.themeMode.dark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      shortcuts: shortcuts.global.value,

      // Locale control.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: preference.locale.value,

      // Routes.
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      navigatorObservers: widget.navigatorObservers,
      builder: widget.builder,
    );
  }
}
