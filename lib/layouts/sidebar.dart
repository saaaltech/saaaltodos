import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';

class SidebarContainer extends StatefulWidget {
  SidebarContainer({
    GlobalKey? key,
    this.sidebar = const CenterText('sidebar'),
    this.mainArea = const CenterText('sidebar container main area'),
  }) : super(key: key ?? GlobalKey());

  final Widget sidebar;
  final Widget mainArea;

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
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
