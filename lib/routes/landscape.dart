import 'package:flutter/material.dart';
import 'package:saaaltodos/layouts/terminal.dart';
import 'package:saaaltodos/validation/app_root_validation.dart';

const landscapeRoute = 'landscape';

class LandscapeLayout extends StatefulWidget {
  const LandscapeLayout({Key? key}) : super(key: key);

  @override
  State<LandscapeLayout> createState() => _LandscapeLayoutState();
}

class _LandscapeLayoutState extends State<LandscapeLayout> {
  final terminalKey = GlobalKey(debugLabel: 'terminal container');
  final sidebarKey = GlobalKey(debugLabel: 'sidebar container');

  late final layout = TerminalContainer(
    key: terminalKey,
    mainArea: DarkModeValidation(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Actions(
        actions: {
          TerminalIntent: CallbackAction<TerminalIntent>(
            onInvoke: (intent) => intent.execute(terminalKey),
          )
        },
        child: Focus(
          autofocus: true,
          child: layout,
        ),
      ),
    );
  }
}
