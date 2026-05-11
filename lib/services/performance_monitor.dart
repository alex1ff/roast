import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

typedef TraceAttributes<T> = Map<String, String> Function(T result);

class AppPerformanceMonitor {
  const AppPerformanceMonitor._();

  static Future<T> trace<T>({
    required String name,
    required Future<T> Function() action,
    Map<String, String> attributes = const {},
    TraceAttributes<T>? resultAttributes,
  }) async {
    final trace = await _startTrace(name, attributes);

    try {
      final result = await action();
      _putAttributes(trace, resultAttributes?.call(result) ?? const {});
      return result;
    } catch (error) {
      _putAttributes(trace, const {
        'status': 'exception',
      });
      rethrow;
    } finally {
      await _stopTrace(trace);
    }
  }

  static Future<Trace?> _startTrace(
    String name,
    Map<String, String> attributes,
  ) async {
    try {
      final trace = FirebasePerformance.instance.newTrace(_sanitizeName(name));
      _putAttributes(trace, attributes);
      await trace.start();
      return trace;
    } catch (error) {
      debugPrint('Performance trace start failed: $name $error');
      return null;
    }
  }

  static Future<void> _stopTrace(Trace? trace) async {
    if (trace == null) {
      return;
    }

    try {
      await trace.stop();
    } catch (error) {
      debugPrint('Performance trace stop failed: $error');
    }
  }

  static void _putAttributes(Trace? trace, Map<String, String> attributes) {
    if (trace == null) {
      return;
    }

    for (final entry in attributes.entries) {
      try {
        trace.putAttribute(
            _sanitizeAttribute(entry.key), _sanitizeValue(entry.value));
      } catch (error) {
        debugPrint('Performance trace attribute failed: ${entry.key} $error');
      }
    }
  }

  static String _sanitizeName(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_').take(80);

  static String _sanitizeAttribute(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_').take(32);

  static String _sanitizeValue(String value) => value.take(100);
}

extension _LimitedString on String {
  String take(int maxLength) =>
      length <= maxLength ? this : substring(0, maxLength);
}
