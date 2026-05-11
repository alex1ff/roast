import 'dart:async';

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/services/error_reporter.dart';

typedef TextToSpeechRequest = Future<ApiCallResponse> Function({
  String? text,
  String? voiceId,
});

typedef RoastAudioUpdater = Future<void> Function(String audioUrl);

class RoastAudioService {
  const RoastAudioService._();

  static Future<String?> generateAndAttach({
    DocumentReference? roastReference,
    required String roastText,
    required String? voiceId,
    TextToSpeechRequest? textToSpeechRequest,
    RoastAudioUpdater? updateRoastAudio,
  }) async {
    try {
      final request = textToSpeechRequest ?? TextToSpeechCall.call;
      final audioResult = await request(
        text: roastText,
        voiceId: voiceId,
      );
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
