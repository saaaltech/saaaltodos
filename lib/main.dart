import 'package:flutter/material.dart';
import 'package:saaaltodos/options/app_root.dart';
import 'package:saaaltodos/validation/app_root_validation.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppRoot(
      home: Scaffold(
        body: Center(
          child: DarkModeValidation(),
        ),
      ),
    );
  }
}
