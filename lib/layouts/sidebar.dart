import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/options/preferences.dart';

class SidebarContainer extends StatefulWidget {
  SidebarContainer({
    GlobalKey? key,
    this.sidebar = const CenterText('sidebar'),
    this.mainArea = const CenterText('sidebar container main area'),
    UserPreference? userPreference,
  }) : super(key: key ?? GlobalKey()) {
    this.userPreference = userPreference ?? preference;
  }

  final Widget sidebar;
  final Widget mainArea;

  late final UserPreference userPreference;

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
  // Aliases as sugars.
  late final key = widget.key as GlobalKey;
  late final preference = widget.userPreference;

  /// Current state of locale rtl,
  /// prevent repeat calling getter to save cost.
  ///
  late bool rtl = preference.textDirection.rtl(context);

  @override
  void initState() {
    super.initState();
    preference.textDirection.attach(key);
  }

  @override
  void dispose() {
    preference.textDirection.cancel(key);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // Refresh rtl when locale changed.
    rtl = preference.textDirection.rtl(context);
    super.setState(fn);
  }

  Positioned get sidebar {
    return Positioned(
      top: 0,
      left: 0,
      width: 300,
      bottom: 0,
      child: Container(
        color: Colors.teal,
        child: widget.sidebar,
      ),
    );
  }

  Positioned get mainArea {
    return Positioned(
      top: 0,
      left: 300,
      right: 0,
      bottom: 0,
      child: widget.mainArea,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [mainArea, sidebar],
    );
  }
}
