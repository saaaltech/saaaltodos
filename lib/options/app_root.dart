import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/preferences.dart';

class AppRoot extends StatefulWidget {
  AppRoot({
    GlobalKey? key,
    // Options handlers.
    UserPreference? preferenceController,

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
    this.preferenceController = preferenceController ?? preference;

    // Default display.
    this.home = routes.isEmpty && initialRoute == null
        ? home ?? const Scaffold(body: CenterText('app root home'))
        : null;
  }

  // User preferences.
  late final UserPreference preferenceController;

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

class _AppRootState extends State<AppRoot> {
  // Aliases as sugars.
  late final preference = widget.preferenceController;
  late final key = widget.key as GlobalKey;

  @override
  void initState() {
    super.initState();
    preference.themeMode.attach(key);
  }

  @override
  void dispose() {
    preference.themeMode.remove(key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Controllers.
      themeMode: preference.themeMode.value,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),

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
