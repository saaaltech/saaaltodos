import 'package:flutter_test/flutter_test.dart';
import 'package:saaaltodos/logger.dart';

void main() => testLogger();

void testLogger() {
  group('logger:', () {
    test('pad zeros', () {
      // pad2
      expect(0.pad2, '00');
      expect(1.pad2, '01');
      expect(23.pad2, '23');

      // pad3
      expect(0.pad3, '000');
      expect(4.pad3, '004');
      expect(56.pad3, '056');
      expect(789.pad3, '789');
    });

    test('format time', () {
      final time = DateTime(2023, 4, 15, 7, 28, 39, 12, 345);
      expect(time.formatDate, '2023.04.15(6)');
      expect(time.formatTime, '07:28:39.012.345');
      expect(time.format, '2023.04.15(6) 07:28:39.012.345');
    });

    test('format duration', () {
      expect(const Duration(days: 6).format, '6 days');
      expect(const Duration(hours: 23).format, '23 h');
      expect(const Duration(minutes: 59).format, '59 min');
      expect(const Duration(seconds: 58).format, '58 sec');
      expect(const Duration(milliseconds: 12).format, '12 ms');
      expect(const Duration(microseconds: 345).format, '345 us');
    });

    test('format', () {
      const duration = Duration(seconds: 2);
      final time = DateTime(2023, 4, 15, 7, 28, 39, 12, 345);

      final logger = Logger(name: 'name', enableColor: false);
      expect(
        logger.format(
          timestamp: time,
          gap: duration,
          message: 'message',
          object: duration,
        ),
        '[name] 2023.04.15(6) 07:28:39.012.345  2 sec message\n$duration',
      );
    });

    test('format map', () {
      expect(
        {
          'name': 'karl',
          'age': 22,
          'has-y-chromosome': true,
          123: 'number: 123',
        }.logFormat,
        'name:             karl\n'
        'age:              22\n'
        'has-y-chromosome: true\n'
        '123:              number: 123',
      );
    });
  });
}
