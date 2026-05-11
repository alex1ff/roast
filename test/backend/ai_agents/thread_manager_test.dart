import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/backend/ai_agents/ai_agent_cloud_function_call.dart';

void main() {
  group('ThreadManager', () {
    const provider = 'OPENAI';
    const threadId = 'thread-manager-test';

    tearDown(() {
      ThreadManager.clearMessages(provider, threadId);
      ThreadManager.clearThread(provider, threadId);
    });

    test('keeps only the newest bounded message history', () {
      for (var index = 0; index < 25; index++) {
        ThreadManager.addMessage(
          provider,
          threadId,
          Message(role: 'user', text: 'message-$index'),
        );
      }

      final messages = ThreadManager.getMessages(provider, threadId);

      expect(messages, hasLength(ThreadManager.maxMessageHistoryLength));
      expect(messages.first.text, 'message-5');
      expect(messages.last.text, 'message-24');
    });

    test('returns an immutable message snapshot', () {
      ThreadManager.addMessage(
        provider,
        threadId,
        const Message(role: 'assistant', text: 'hello'),
      );

      final messages = ThreadManager.getMessages(provider, threadId);

      expect(
        () => messages.add(const Message(role: 'user', text: 'mutation')),
        throwsUnsupportedError,
      );
      expect(ThreadManager.getMessages(provider, threadId), hasLength(1));
    });
  });
}
