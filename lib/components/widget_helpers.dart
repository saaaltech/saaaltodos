import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension StatelessHelper on StatelessWidget {
  Brightness brightness(BuildContext context) => Theme.of(context).brightness;
  bool dark(BuildContext context) => brightness(context) == Brightness.dark;
}

extension StatefulHelper on State {
  Brightness get brightness => Theme.of(context).brightness;
  bool get dark => brightness == Brightness.dark;
}

Brightness get platformBrightness {
  return PlatformDispatcher.instance.platformBrightness;
}

class CenterText extends StatelessWidget {
  const CenterText(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
