import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:roast_nutri_tracker/backend/api_requests/api_manager.dart';
import 'package:roast_nutri_tracker/services/request_context.dart';

void main() {
  group('ApiManager', () {
    tearDown(() {
      ApiManager.clearCache('cached');
    });

    test('adds client request id header without mutating caller headers',
        () async {
      final callerHeaders = {'Accept': 'application/json'};
      final seenHeaders = <String, String>{};
      final client = MockClient((request) async {
        seenHeaders.addAll(request.headers);
        return http.Response(
          jsonEncode({'ok': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final response = await ApiManager.instance.makeApiCall(
        callName: 'tts',
        apiUrl: 'https://example.test/tts',
        callType: ApiCallType.GET,
        headers: callerHeaders,
        params: const {},
        requestId: 'api_test_1',
        client: client,
      );

      expect(response.succeeded, isTrue);
      expect(seenHeaders[clientRequestIdHeader], 'api_test_1');
      expect(callerHeaders.containsKey(clientRequestIdHeader), isFalse);
    });

    test('keeps cache key stable when request id changes', () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        return http.Response(
          jsonEncode({'count': requestCount}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final first = await ApiManager.instance.makeApiCall(
        callName: 'cached',
        apiUrl: 'https://example.test/cache',
        callType: ApiCallType.GET,
        cache: true,
        requestId: 'api_cache_1',
        client: client,
      );
      final second = await ApiManager.instance.makeApiCall(
        callName: 'cached',
        apiUrl: 'https://example.test/cache',
        callType: ApiCallType.GET,
        cache: true,
        requestId: 'api_cache_2',
        client: client,
      );

      expect(first.succeeded, isTrue);
      expect(second.succeeded, isTrue);
      expect(first.jsonBody, {'count': 1});
      expect(second.jsonBody, {'count': 1});
      expect(requestCount, 1);
    });
  });
}
