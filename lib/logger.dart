import 'package:ansicolor/ansicolor.dart';
import 'package:saaaltodos/extensions.dart';

// kDebugMode and other outer imports might cause exceptions
// for introducing unsupported packages (like dart:ui) on dart cli.
final _debug = _isDebug;
bool get _isDebug {
  bool flag = false;
  assert(flag = true);
  return flag;
}

final defaultColor = AnsiPen()..black();
final gray = AnsiPen()..gray(level: 0.618);
final deepGray = AnsiPen()..gray(level: 0.314);
final middleGray = AnsiPen()..gray(level: 0.49);

/// Record last update time.
/// It will be refreshed after each logger.
///
DateTime _last = DateTime.now();

class Logger {
  Logger({
    this.name = 'unnamed',
    this.debugOnly = false,
    AnsiPen? color,
    this.enable = true,
    this.enableColor = true,
    this.displayTime = true,
  }) {
    this.color = color ?? defaultColor;
    ansiColorDisabled = false;
  }

  final String name;
  final bool debugOnly;
  late final AnsiPen color;

  bool enable;
  bool enableColor;
  bool displayTime;

  void log({DateTime? timestamp, String message = '', Object? object}) {
    timestamp = timestamp ?? DateTime.now();
    final gap = timestamp.difference(_last);
    _last = timestamp;

    if (!enable) return;
    if (debugOnly && !_debug) return;

    // ignore: avoid_print
    print(
      format(
        timestamp: timestamp,
        gap: gap,
        message: message,
        object: object,
      ),
    );
  }

  String format({
    DateTime? timestamp,
    Duration? gap,
    String message = '',
    Object? object,
    bool enableColor = true,
  }) {
    final useColor = enableColor && this.enableColor;
    timestamp = timestamp ?? DateTime.now();

    // name
    final bracketL = useColor ? middleGray('[') : '[';
    final bracketR = useColor ? middleGray(']') : ']';
    final name = '$bracketL${useColor ? color(this.name) : this.name}$bracketR';

    // time and duration
    final time = displayTime == false
        ? ''
        : ' ${useColor ? deepGray(timestamp.format) : timestamp.format}';
    final duration =
        gap != null ? ' ${useColor ? gray(gap.format6) : gap.format6}' : '';

    // message and object
    message = useColor ? color(message) : message;
    String objectDisplay = object == null ? '' : '\n$object';
    objectDisplay = useColor ? middleGray(objectDisplay) : objectDisplay;

    return '$name$time$duration $message$objectDisplay';
  }
}

extension FormatDuration on Duration {
  String get format {
    if (inDays > 0) return '$inDays days';
    if (inHours > 0) return '$inHours h';
    if (inMinutes > 0) return '$inMinutes min';
    if (inSeconds > 0) return '$inSeconds sec';
    if (inMilliseconds > 0) return '$inMilliseconds ms';
    return '$inMicroseconds us';
  }

  String get format6 => format.padLeft(6);
}

extension FormatTime on DateTime {
  String get format => '$formatDate $formatTime';
  String get formatDate => '$year.${month.pad2}.${day.pad2}($weekday)';
  String get formatTime => '${hour.pad2}:${minute.pad2}:${second.pad2}'
      '.${millisecond.pad3}.${microsecond.pad3}';
}

extension FormatInt on int {
  String get pad2 => toString().padLeft(2, '0');
  String get pad3 => toString().padLeft(3, '0');
}

String ratioDisplay(int count, int all) => '$count/$all ${count / all * 100}%';

extension LogFormatList on List<dynamic> {
  String get logFormat => '- ${join('\n- ')}';
}

extension LogFormatMap on Map<dynamic, dynamic> {
  String get logFormat {
    final List<String> keyNames = [];
    for (final key in keys) {
      keyNames.add(key.toString());
    }

    final List<String> lines = [];
    final len = keyNames.maxLength + 2;
    for (final key in keys) {
      lines.add('$key:'.padRight(len) + this[key].toString());
    }
    return lines.join('\n');
  }
}

/// Global instance of [DefaultLoggers], a group of simple loggers.
/// You can call it anywhere when necessary.
///
final log = DefaultLoggers();

/// This is a sample of logger group.
///
/// 1. It is already available to use, you can just call the [log] instance.
/// 2. If you'd like to configure your own logger,
/// please don't extend this class.
/// It's recommended to create another class with methods of [Logger]s.
///
class DefaultLoggers {
  DefaultLoggers({
    bool enable = true,
    bool enableColor = true,
    bool displayTime = true,
  }) {
    _enable = enable;
    _enableColor = enableColor;
    _displayTime = displayTime;

    _last = DateTime.now();
  }

  /// Logger register.
  late final _loggers = [_dev, _auth, _notice, _success, _warn, _error];

  // Flags.
  late bool _enable;
  late bool _enableColor;

  late bool _displayTime;

  /// Only show in debug mode.
  void dev(String message, {Object? object}) =>
      _dev.log(message: message, object: object);
  late final _dev = Logger(
    name: '>',
    color: middleGray,
    enableColor: _enableColor,
    debugOnly: true,
  );

  void auth(String message, {Object? object}) =>
      _auth.log(message: message, object: object);
  late final _auth = Logger(
    name: 'a',
    color: AnsiPen()..magenta(),
    enableColor: _enableColor,
  );

  void notice(String message, {Object? object}) =>
      _notice.log(message: message, object: object);
  late final _notice = Logger(
    name: 'i',
    color: AnsiPen()..blue(),
    enableColor: _enableColor,
  );

  void success(String message, {Object? object}) =>
      _success.log(message: message, object: object);
  late final _success = Logger(
    name: 'v',
    color: AnsiPen()..green(),
    enableColor: _enableColor,
  );

  void warn(String message, {Object? object}) =>
      _warn.log(message: message, object: object);
  late final _warn = Logger(
    name: '!',
    color: AnsiPen()..yellow(),
    enableColor: _enableColor,
  );

  void error(String message, {Object? object}) =>
      _error.log(message: message, object: object);
  late final _error = Logger(
    name: 'x',
    color: AnsiPen()..red(),
    enableColor: _enableColor,
  );
}

extension LoggerEnableController on DefaultLoggers {
  bool get enable => _enable;
  set enable(bool value) {
    if (_enable != value) {
      _enable = value;
      for (final logger in _loggers) {
        logger.enable = _enable;
      }
    }
  }
}

extension LoggerColorController on DefaultLoggers {
  bool get enableColor => _enableColor;
  set enableColor(bool flag) {
    if (_enableColor != flag) {
      _enableColor == flag;
      for (final logger in _loggers) {
        logger.enableColor = _enableColor;
      }
    }
  }
}

extension LoggerDisplayTimeController on DefaultLoggers {
  bool get displayTime => _displayTime;
  set displayTime(bool value) {
    if (_displayTime != value) {
      _displayTime = value;
      for (final logger in _loggers) {
        logger.displayTime = _displayTime;
      }
    }
  }
}
