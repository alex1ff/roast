import '/backend/schema/structs/index.dart';

typedef ChatAddMessage = int Function(AIChatStruct message);
typedef ChatUpdateMessage = void Function(int index, String message);
typedef ChatAiCaller = Future<String?> Function(String prompt);
typedef ChatRecentMealsTextLoader = Future<String> Function();
typedef ChatUsageRecorder = Future<void> Function();
typedef ChatNow = DateTime Function();
typedef ChatCanSend = bool Function();

enum ChatSendStatus {
  success,
  limitExceeded,
  emptyResponse,
  error,
}

class ChatSendResult {
  const ChatSendResult({
    required this.status,
    required this.assistantIndex,
    this.response,
  });

  final ChatSendStatus status;
  final int assistantIndex;
  final String? response;

  bool get succeeded => status == ChatSendStatus.success;
}

class ChatController {
  const ChatController({
    required this.addMessage,
    required this.updateMessage,
    required this.callAi,
    required this.loadRecentMealsText,
    required this.recordUsage,
    required this.now,
    this.canSend,
    this.maxAiAttempts = 2,
  }) : assert(maxAiAttempts > 0);

  static const fallbackAssistantMessage =
      'Sorry, looks like our partner service is having technical issues. Please try again later.';

  final ChatAddMessage addMessage;
  final ChatUpdateMessage updateMessage;
  final ChatAiCaller callAi;
  final ChatRecentMealsTextLoader loadRecentMealsText;
  final ChatUsageRecorder recordUsage;
  final ChatNow now;
  final ChatCanSend? canSend;
  final int maxAiAttempts;

  Future<ChatSendResult> send({
    required String userMessage,
    required String type,
    String? currentDish,
  }) async {
    if (canSend?.call() == false) {
      return const ChatSendResult(
        status: ChatSendStatus.limitExceeded,
        assistantIndex: -1,
      );
    }

    addMessage(AIChatStruct(
      message: userMessage,
      role: 'user',
      date: now(),
    ));
    final assistantIndex = addMessage(AIChatStruct(
      role: 'assistant',
      date: now(),
    ));

    try {
      final recentMealsText = await loadRecentMealsText();
      final response = await _callAiWithRetry(_buildPrompt(
        userMessage: userMessage,
        recentMealsText: recentMealsText,
        type: type,
        currentDish: currentDish,
      ));

      if (response == null || response.isEmpty) {
        updateMessage(assistantIndex, fallbackAssistantMessage);
        return ChatSendResult(
          status: ChatSendStatus.emptyResponse,
          assistantIndex: assistantIndex,
        );
      }

      updateMessage(assistantIndex, response);
      try {
        await recordUsage();
      } catch (_) {
        // Usage accounting is server-owned and retried by the next successful
        // request path. Do not replace a valid assistant answer with an error.
      }
      return ChatSendResult(
        status: ChatSendStatus.success,
        assistantIndex: assistantIndex,
        response: response,
      );
    } catch (_) {
      updateMessage(assistantIndex, fallbackAssistantMessage);
      return ChatSendResult(
        status: ChatSendStatus.error,
        assistantIndex: assistantIndex,
      );
    }
  }

  Future<String?> _callAiWithRetry(String prompt) async {
    Object? lastError;
    StackTrace? lastStackTrace;

    for (var attempt = 0; attempt < maxAiAttempts; attempt++) {
      try {
        return await callAi(prompt);
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
      }
    }

    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }

  String _buildPrompt({
    required String userMessage,
    required String recentMealsText,
    required String type,
    String? currentDish,
  }) {
    final basePrompt =
        'Answer language: English. User\'s Query: "$userMessage". Last 7 days meals: "$recentMealsText". Type: $type';
    if (currentDish == null || currentDish.isEmpty) {
      return basePrompt;
    }

    return '$basePrompt. Current dish: "$currentDish"';
  }
}
