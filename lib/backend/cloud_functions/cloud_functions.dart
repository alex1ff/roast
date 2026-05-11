import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '/services/error_reporter.dart';
import '/services/performance_monitor.dart';
import '/services/request_context.dart';

const _cloudFunctionsRegion = 'us-central1';
const _cloudFunctionTimeout = Duration(seconds: 120);
const _cloudFunctionErrorKey = '_error';
const _cloudFunctionErrorCodeKey = 'code';
const _cloudFunctionErrorMessageKey = 'message';

Map<String, dynamic> _cloudFunctionErrorResponse({
  required String code,
  required String message,
  required String requestId,
  Object? details,
}) =>
    {
      _cloudFunctionErrorKey: true,
      _cloudFunctionErrorCodeKey: code,
      _cloudFunctionErrorMessageKey: message,
      'request_id': requestId,
      if (details != null) 'details': details.toString(),
    };

Future<Map<String, dynamic>> makeCloudCall(
  String callName,
  Map<String, dynamic> input,
) {
  final requestId = AppRequestContext.newRequestId(prefix: callName);
  final requestInput = AppRequestContext.withClientRequestId(
    input,
    requestId: requestId,
  );

  return AppPerformanceMonitor.trace(
    name: 'cloud_function_call',
    attributes: {
      'call': callName,
      'region': _cloudFunctionsRegion,
      'request_id': requestId,
    },
    resultAttributes: (result) => {
      'status': result[_cloudFunctionErrorKey] == true ? 'error' : 'success',
      if (result[_cloudFunctionErrorCodeKey] != null)
        'code': result[_cloudFunctionErrorCodeKey].toString(),
    },
    action: () => _makeCloudCall(callName, requestInput, requestId),
  );
}

Future<Map<String, dynamic>> _makeCloudCall(
  String callName,
  Map<String, dynamic> input,
  String requestId,
) async {
  try {
    final response = await FirebaseFunctions.instanceFor(
      region: _cloudFunctionsRegion,
    )
        .httpsCallable(
          callName,
          options: HttpsCallableOptions(timeout: _cloudFunctionTimeout),
        )
        .call(input);
    return response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : {};
  } on TimeoutException catch (e) {
    debugPrint('Cloud call timeout: $callName $requestId');
    unawaited(AppErrorReporter.report(
      area: 'cloud_function',
      message: 'timeout',
      error: e,
      attributes: {
        'call': callName,
        'request_id': requestId,
        'code': 'deadline_exceeded',
      },
    ));
    return _cloudFunctionErrorResponse(
      code: 'deadline-exceeded',
      message: 'Cloud function timed out.',
      requestId: requestId,
    );
  } on FirebaseFunctionsException catch (e) {
    debugPrint(
      'Cloud call error: $callName $requestId ${e.code}',
    );
    unawaited(AppErrorReporter.report(
      area: 'cloud_function',
      message: 'firebase_functions_exception',
      error: e,
      attributes: {
        'call': callName,
        'request_id': requestId,
        'code': e.code,
      },
    ));
    return _cloudFunctionErrorResponse(
      code: e.code,
      message: e.message ?? 'Cloud function failed.',
      requestId: requestId,
      details: e.details,
    );
  } catch (e) {
    debugPrint('Cloud call error: $callName $requestId ${e.runtimeType}');
    unawaited(AppErrorReporter.report(
      area: 'cloud_function',
      message: 'unexpected_exception',
      error: e,
      attributes: {
        'call': callName,
        'request_id': requestId,
        'code': 'unknown',
      },
    ));
    return _cloudFunctionErrorResponse(
      code: 'unknown',
      message: 'Cloud function failed.',
      requestId: requestId,
      details: e,
    );
  }
}
