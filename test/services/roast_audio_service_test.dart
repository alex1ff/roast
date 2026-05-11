import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/backend/api_requests/api_calls.dart';
import 'package:roast_nutri_tracker/services/roast_audio_service.dart';

void main() {
  group('RoastAudioService', () {
    test('generates audio and delegates persistence', () async {
      String? updatedAudioUrl;

      final audioUrl = await RoastAudioService.generateAndAttach(
        roastText: 'roast text',
        voiceId: 'voice_1',
        textToSpeechRequest: ({text, voiceId}) async {
          expect(text, 'roast text');
          expect(voiceId, 'voice_1');
          return const ApiCallResponse(
            {
              'result': {'audiopath': 'https://example.com/audio.mp3'},
            },
            {},
            200,
          );
        },
        updateRoastAudio: (value) async {
          updatedAudioUrl = value;
        },
      );

      expect(audioUrl, 'https://example.com/audio.mp3');
      expect(updatedAudioUrl, audioUrl);
    });

    test('returns null when TTS response has no audio URL', () async {
      var persisted = false;

      final audioUrl = await RoastAudioService.generateAndAttach(
        roastText: 'roast text',
        voiceId: 'voice_1',
        textToSpeechRequest: ({text, voiceId}) async =>
            const ApiCallResponse({'result': {}}, {}, 200),
        updateRoastAudio: (_) async {
          persisted = true;
        },
      );

      expect(audioUrl, isNull);
      expect(persisted, false);
    });
  });
}
