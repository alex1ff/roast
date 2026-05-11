import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/error_reporter.dart';

void main() {
  group('AppErrorReporter', () {
    tearDown(AppErrorReporter.resetForTesting);

    test('builds a sanitized report without raw exception text', () async {
      AppErrorReport? captured;
      AppErrorReporter.setSinkForTesting((report) {
        captured = report;
      });

      await AppErrorReporter.report(
        area: 'api-call!',
        message: 'request failed',
        error: StateError('contains prompt and token'),
        attributes: const {
          'request id': 'abc-123',
          'very-long-value':
              'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz',
        },
      );

      expect(captured, isNotNull);
      expect(captured!.area, 'api_call_');
      expect(captured!.message, 'request failed');
      expect(captured!.attributes['error_type'], 'StateError');
      expect(captured!.attributes['request_id'], 'abc-123');
      expect(captured!.attributes.values.join(' '), isNot(contains('prompt')));
      expect(captured!.attributes.values.join(' '), isNot(contains('token')));
      expect(captured!.attributes['very_long_value']!.length, 100);
    });

    test('keeps reports bounded and swallows sink failures', () async {
      AppErrorReporter.setSinkForTesting((_) {
        throw StateError('sink failed');
      });

      await AppErrorReporter.report(
        area: 'platform dispatcher',
        message:
            'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz',
        error: ArgumentError('raw user data'),
        stackTrace: StackTrace.current,
        fatal: true,
      );

      AppErrorReport? captured;
      AppErrorReporter.setSinkForTesting((report) {
        captured = report;
      });

      await AppErrorReporter.report(
        area: 'platform dispatcher',
        message:
            'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz',
        error: ArgumentError('raw user data'),
        stackTrace: StackTrace.current,
        fatal: true,
      );

      expect(captured, isNotNull);
      expect(captured!.area, 'platform_dispatcher');
      expect(captured!.message.length, 120);
      expect(captured!.attributes['error_type'], 'ArgumentError');
      expect(captured!.attributes['has_stack'], 'true');
      expect(captured!.fatal, isTrue);
      expect(captured!.attributes.values.join(' '), isNot(contains('raw')));
    });
  });
}
