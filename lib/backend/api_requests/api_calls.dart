import 'dart:async';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'api_manager.dart' show ApiCallResponse;

const _textToSpeechTimeout = Duration(seconds: 90);

class TextToSpeechCall {
  static Future<ApiCallResponse> call({
    String? text = '',
    String? voiceId = '',
  }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      return ApiCallResponse(
        null,
        {},
        401,
        exception: StateError('TextToSpeech requires authentication.'),
      );
    }

    final ffApiRequestBody = '''
{
  "data": {
    "text": "${escapeStringForJson(text)}",
    "voiceid": "${escapeStringForJson(voiceId)}",
    "modelid": "eleven_multilingual_v2",
    "outputformat": "mp3_44100_128"
  }
}''';
    return ApiManager.instance
        .makeApiCall(
          callName: 'TextToSpeech',
          apiUrl:
              'https://us-central1-roast-nutri-tracker-7c67ct.cloudfunctions.net/textToSpeech',
          callType: ApiCallType.POST,
          headers: {
            'Authorization': 'Bearer $idToken',
          },
          params: {},
          body: ffApiRequestBody,
          bodyType: BodyType.JSON,
          returnBody: true,
          encodeBodyUtf8: false,
          decodeUtf8: false,
          cache: false,
          isStreamingApi: false,
          alwaysAllowBody: false,
        )
        .timeout(
          _textToSpeechTimeout,
          onTimeout: () => ApiCallResponse(
            null,
            {},
            408,
            exception: TimeoutException(
              'TextToSpeech timed out.',
              _textToSpeechTimeout,
            ),
          ),
        );
  }

  static String? audio(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.result.audiopath''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
