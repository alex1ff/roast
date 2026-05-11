import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/request_context.dart';

void main() {
  group('AppRequestContext', () {
    test('adds client request id without mutating source payload', () {
      final payload = {'feature': 'chat'};

      final withRequestId = AppRequestContext.withClientRequestId(
        payload,
        requestId: 'cloud_test_1',
      );

      expect(withRequestId[clientRequestIdKey], 'cloud_test_1');
      expect(withRequestId['feature'], 'chat');
      expect(payload.containsKey(clientRequestIdKey), isFalse);
    });

    test('creates short sanitized request ids', () {
      final requestId = AppRequestContext.newRequestId(
        prefix: 'AI Assist / Roast',
      );

      expect(requestId, startsWith('AI_Assist___Roast_'));
      expect(requestId.length, lessThanOrEqualTo(64));
      expect(requestId, matches(RegExp(r'^[A-Za-z0-9_]+$')));
    });
  });
}
