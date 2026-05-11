import 'dart:async';

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/services/error_reporter.dart';
import '/services/performance_monitor.dart';

typedef TextToSpeechRequest = Future<ApiCallResponse> Function({
  String? text,
  String? voiceId,
});

typedef RoastAudioUpdater = Future<void> Function(String audioUrl);

class RoastAudioService {
  const RoastAudioService._();

  static const Duration defaultTimeout = Duration(seconds: 25);

  static Future<String?> generateAndAttach({
    DocumentReference? roastReference,
    required String roastText,
    required String? voiceId,
    TextToSpeechRequest? textToSpeechRequest,
    RoastAudioUpdater? updateRoastAudio,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      return await AppPerformanceMonitor.trace<String?>(
        name: 'roast_audio_attach',
        attributes: {
          'has_existing_reference': roastReference == null ? 'false' : 'true',
        },
        resultAttributes: (audioUrl) => {
          'status':
              audioUrl == null || audioUrl.isEmpty ? 'no_audio' : 'audio_ready',
        },
        action: () async {
          final request = textToSpeechRequest ?? TextToSpeechCall.call;
          final audioResult = await request(
            text: roastText,
            voiceId: voiceId,
          ).timeout(timeout);
          final audioUrl = TextToSpeechCall.audio(audioResult.jsonBody ?? '');
          if (audioUrl == null || audioUrl.isEmpty) {
            return null;
          }

          final updater = updateRoastAudio ??
              (String url) => roastReference!.update(
                    createAddedDishHistoryRecordData(roastAudio: url),
                  );
          await updater(audioUrl);
          return audioUrl;
        },
      );
    } catch (error) {
      unawaited(AppErrorReporter.report(
        area: 'roast_audio',
        message: 'generate_failed',
        error: error,
      ));
      return null;
    }
  }
}
