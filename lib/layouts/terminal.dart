import 'package:flutter/material.dart';
import 'package:saaaltodos/components/widget_helpers.dart';
import 'package:saaaltodos/environment.dart';
import 'package:saaaltodos/logger.dart';

class TerminalContainer extends StatefulWidget {
  TerminalContainer({
    GlobalKey? key,
    this.mainArea = const CenterText('terminal container main area'),
    Widget? terminalPad,
  }) : super(key: key ?? GlobalKey()) {
    this.terminalPad = terminalPad ??
        Container(
          color: Colors.teal,
          child: const CenterText('terminal pad'),
        );
  }

  late final Widget terminalPad;
  final Widget mainArea;

  @override
  State<TerminalContainer> createState() => _TerminalContainerState();
}

class _TerminalContainerState extends State<TerminalContainer> {
  bool _showTerminal = false;

  void showTerminal() => setState(() => _showTerminal = true);
  void hideTerminal() => setState(() => _showTerminal = false);
  void shiftTerminal({bool onlyHide = false}) {
    if (onlyHide && !_showTerminal) return;
    setState(() => _showTerminal = !_showTerminal);
  }

  @override
  void initState() {
    super.initState();
    if (platform.isPortrait) {
      log.warn('incompatible: terminal container on portrait screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.mainArea,
        Offstage(
          offstage: !_showTerminal,
          child: widget.terminalPad,
        ),
      ],
    );
  }
}

class TerminalIntent extends Intent {
  const TerminalIntent({this.onlyHide = false});

  final bool onlyHide;

  void execute(GlobalKey key) {
    final state = key.currentState as _TerminalContainerState?;
    state?.shiftTerminal(onlyHide: onlyHide);
  }
}
