import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/preferences.dart';

class AppRoot extends StatefulWidget {
  AppRoot({
    Key? key,
    // Options handlers.
    this.preferenceController = preference,

    // Routes.
    Widget? home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
  }) : super(key: key) {
    this.home = routes.isEmpty && initialRoute == null
        ? home ?? const Scaffold(body: CenterText('app root home'))
        : null;
  }

  // User preferences.
  final UserPreference preferenceController;

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
  /// Alias of the current preference controller and
  /// shield the global instance with same name.
  ///
  late final preference = widget.preferenceController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
