import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/backend/schema/structs/index.dart';
import 'package:roast_nutri_tracker/services/chat_history_view.dart';

void main() {
  group('ChatHistoryView', () {
    test('reads messages in reverse insertion order without date sorting', () {
      final olderDate = DateTime(2026, 5, 10, 12);
      final newerDate = DateTime(2026, 5, 10, 13);
      final history = [
        AIChatStruct(
          message: 'first inserted but newer date',
          role: 'user',
          date: newerDate,
        ),
        AIChatStruct(
          message: 'second inserted but older date',
          role: 'assistant',
          date: olderDate,
        ),
      ];

      expect(
        ChatHistoryView.messageAtReverseIndex(history, 0).message,
        'second inserted but older date',
      );
      expect(
        ChatHistoryView.messageAtReverseIndex(history, 1).message,
        'first inserted but newer date',
      );
    });

    test('builds stable keys from message data instead of list position only',
        () {
      final message = AIChatStruct(
        message: 'hello',
        role: 'user',
        date: DateTime(2026, 5, 10, 12),
      );

      final key = ChatHistoryView.stableMessageKey(
        message,
        fallbackIndex: 3,
      );

      expect(key, contains('chat_'));
      expect(key, contains('user'));
      expect(key, isNot(contains('Keyd2p_3')));
      expect(
        key,
        ChatHistoryView.stableMessageKey(
          message,
          fallbackIndex: 3,
        ),
      );
      expect(
        key,
        ChatHistoryView.stableMessageKey(
          AIChatStruct(
            message: 'updated',
            role: 'user',
            date: DateTime(2026, 5, 10, 12),
          ),
          fallbackIndex: 3,
        ),
      );
      expect(
        key,
        isNot(ChatHistoryView.stableMessageKey(
          message,
          fallbackIndex: 4,
        )),
      );
    });

    test('throws a range error for invalid reverse indexes', () {
      expect(
        () => ChatHistoryView.messageAtReverseIndex(const [], 0),
        throwsRangeError,
      );
    });
  });
}
