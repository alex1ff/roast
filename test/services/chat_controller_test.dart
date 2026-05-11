import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/backend/schema/structs/index.dart';
import 'package:roast_nutri_tracker/services/chat_controller.dart';

void main() {
  group('ChatController', () {
    late List<AIChatStruct> history;
    late List<String> prompts;
    var usageRecords = 0;

    int addMessage(AIChatStruct message) {
      history.add(message);
      return history.length - 1;
    }

    void updateMessage(int index, String message) {
      history[index].message = message;
    }

    ChatController controller({
      Future<String?> Function(String prompt)? callAi,
      Future<String> Function()? loadRecentMealsText,
      bool Function()? canSend,
    }) =>
        ChatController(
          addMessage: addMessage,
          updateMessage: updateMessage,
          callAi: callAi ??
              (prompt) async {
                prompts.add(prompt);
                return 'assistant response';
              },
          loadRecentMealsText: loadRecentMealsText ?? () async => 'eggs',
          canSend: canSend ?? () => true,
          recordUsage: () async {
            usageRecords += 1;
          },
          now: () => DateTime(2026, 5, 10, 12),
        );

    setUp(() {
      history = [];
      prompts = [];
      usageRecords = 0;
    });

    test('adds user and assistant messages then records successful usage',
        () async {
      final result = await controller().send(
        userMessage: 'How was breakfast?',
        type: 'message',
      );

      expect(result.status, ChatSendStatus.success);
      expect(history, hasLength(2));
      expect(history[0].role, 'user');
      expect(history[0].message, 'How was breakfast?');
      expect(history[1].role, 'assistant');
      expect(history[1].message, 'assistant response');
      expect(usageRecords, 1);
      expect(prompts.single, contains('Last 7 days meals: "eggs"'));
      expect(prompts.single, contains('Type: message'));
    });

    test('stores fallback state and does not record usage on empty response',
        () async {
      final result = await controller(callAi: (_) async => '').send(
        userMessage: 'hello',
        type: 'message',
      );

      expect(result.status, ChatSendStatus.emptyResponse);
      expect(history.last.message, ChatController.fallbackAssistantMessage);
      expect(usageRecords, 0);
    });

    test('stores fallback state and does not record usage on thrown AI error',
        () async {
      final result = await controller(
        callAi: (_) async => throw StateError('failed'),
      ).send(
        userMessage: 'hello',
        type: 'message',
      );

      expect(result.status, ChatSendStatus.error);
      expect(history.last.message, ChatController.fallbackAssistantMessage);
      expect(usageRecords, 0);
    });

    test('retries a transient AI error before storing a successful response',
        () async {
      var attempts = 0;

      final result = await controller(
        callAi: (_) async {
          attempts += 1;
          if (attempts == 1) {
            throw StateError('transient');
          }
          return 'retry response';
        },
      ).send(
        userMessage: 'hello',
        type: 'message',
      );

      expect(result.status, ChatSendStatus.success);
      expect(attempts, 2);
      expect(history.last.message, 'retry response');
      expect(usageRecords, 1);
    });

    test('does not add messages or call AI when chat limit is exceeded',
        () async {
      var aiCalls = 0;

      final result = await controller(
        canSend: () => false,
        callAi: (_) async {
          aiCalls += 1;
          return 'should not call';
        },
      ).send(
        userMessage: 'hello',
        type: 'message',
      );

      expect(result.status, ChatSendStatus.limitExceeded);
      expect(result.assistantIndex, -1);
      expect(history, isEmpty);
      expect(aiCalls, 0);
      expect(usageRecords, 0);
    });

    test('awaits recent meals before building prompt with current dish',
        () async {
      var mealsLoaded = false;
      final result = await controller(
        loadRecentMealsText: () async {
          mealsLoaded = true;
          return 'rice';
        },
        callAi: (prompt) async {
          expect(mealsLoaded, isTrue);
          prompts.add(prompt);
          return 'ok';
        },
      ).send(
        userMessage: 'rate this',
        type: 'message_dish',
        currentDish: 'ramen 500 kcal',
      );

      expect(result.status, ChatSendStatus.success);
      expect(prompts.single, contains('Current dish: "ramen 500 kcal"'));
    });
  });
}
