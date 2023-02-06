import 'package:flutter/material.dart';
import 'package:saaaltodos/environment.dart';
import 'package:saaaltodos/logger.dart';
import 'package:saaaltodos/options/app_root.dart';
import 'package:saaaltodos/validation/app_root_validation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PlatformInfo.ensureInitialized();
  await VersionInfo.ensureInitialized();
  log.notice('welcome to saaaltodos version $version', object: platform);
  log.dev('running in ${debug ? "debug" : "production"} mode');

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
