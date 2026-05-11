import 'dart:async';

import 'package:flutter/foundation.dart';

typedef AppErrorReportSink = FutureOr<void> Function(AppErrorReport report);

class AppErrorReport {
  const AppErrorReport({
    required this.area,
    required this.message,
    required this.attributes,
    required this.fatal,
  });

  final String area;
  final String message;
  final Map<String, String> attributes;
  final bool fatal;
}

class AppErrorReporter {
  const AppErrorReporter._();

  static AppErrorReportSink? _sink;
  static bool _installed = false;
  static FlutterExceptionHandler? _previousFlutterErrorHandler;
  static bool Function(Object error, StackTrace stackTrace)?
      _previousPlatformErrorHandler;

  static void setSinkForTesting(AppErrorReportSink sink) {
    _sink = sink;
  }

  static void resetForTesting() {
    _sink = null;
  }

  static void installGlobalHandlers({AppErrorReportSink? sink}) {
    if (sink != null) {
      _sink = sink;
    }
    if (_installed) {
      return;
    }

    _installed = true;
    _previousFlutterErrorHandler = FlutterError.onError;
    _previousPlatformErrorHandler = PlatformDispatcher.instance.onError;

    FlutterError.onError = (details) {
      final previous = _previousFlutterErrorHandler;
      if (previous != null) {
        previous(details);
      } else {
        FlutterError.presentError(details);
      }

      unawaited(report(
        area: 'flutter_framework',
        message: 'uncaught_flutter_error',
        error: details.exception,
        stackTrace: details.stack,
        fatal: false,
        attributes: {
          if (details.library != null) 'library': details.library!,
          if (details.context != null) 'context': details.context.toString(),
        },
      ));
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      unawaited(report(
        area: 'platform_dispatcher',
        message: 'uncaught_platform_error',
        error: error,
        stackTrace: stackTrace,
        fatal: true,
      ));
      return _previousPlatformErrorHandler?.call(error, stackTrace) ?? false;
    };
  }

  static Future<void> report({
    required String area,
    required String message,
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
    Map<String, String> attributes = const {},
  }) async {
    final safeAttributes = <String, String>{
      for (final entry in attributes.entries)
        _sanitizeKey(entry.key, 32): _sanitizeValue(entry.value, 100),
      if (error != null)
        'error_type': _sanitizeValue(error.runtimeType.toString(), 100),
      if (stackTrace != null) 'has_stack': 'true',
    };

    final report = AppErrorReport(
      area: _sanitizeKey(area, 40),
      message: _sanitizeValue(message, 120),
      attributes: Map.unmodifiable(safeAttributes),
      fatal: fatal,
    );

    try {
      final sink = _sink;
      if (sink != null) {
        await sink(report);
      } else if (kDebugMode) {
        debugPrint(
          'AppErrorReport ${report.area} ${report.message} '
          'fatal=${report.fatal} attributes=${report.attributes}',
        );
      }
    } catch (error) {
      debugPrint('App error reporting failed: ${error.runtimeType}');
    }
  }

  static String _sanitizeKey(String value, int maxLength) {
    final sanitized = value.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final nonEmpty = sanitized.isEmpty ? 'unknown' : sanitized;
    return _take(nonEmpty, maxLength);
  }

  static String _sanitizeValue(String value, int maxLength) =>
      _take(value.replaceAll(RegExp(r'[\r\n\t]'), ' '), maxLength);

  static String _take(String value, int maxLength) =>
      value.length <= maxLength ? value : value.substring(0, maxLength);
}
