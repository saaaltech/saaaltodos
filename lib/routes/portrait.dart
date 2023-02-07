import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';

const portraitRoute = 'portrait';

class PortraitLayout extends StatelessWidget {
  const PortraitLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CenterText('portrait layout'));
  }
}
