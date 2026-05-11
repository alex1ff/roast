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

    test('builds stable keys independent of fallback index and list order', () {
      final message = AIChatStruct(
        message: 'hello',
        role: 'user',
        date: DateTime(2026, 5, 10, 12),
      );

      final key = ChatHistoryView.stableMessageKey(
        message,
        fallbackIndex: 3,
      );
      final reorderedHistory = [
        AIChatStruct(
          message: 'other',
          role: 'assistant',
          date: DateTime(2026, 5, 10, 11),
        ),
        message,
      ];

      expect(key, contains('chat_'));
      expect(key, contains('user'));
      expect(key, isNot(contains('Keyd2p_3')));
      expect(
        key,
        ChatHistoryView.stableMessageKey(
          message,
          fallbackIndex: 99,
        ),
      );
      expect(
        key,
        ChatHistoryView.stableMessageKey(
          reorderedHistory[1],
          fallbackIndex: 0,
        ),
      );
    });

    test('uses normalized text hash for messages without dates', () {
      final first = AIChatStruct(
        message: 'hello   world',
        role: 'assistant',
      );
      final second = AIChatStruct(
        message: ' hello world ',
        role: 'assistant',
      );

      expect(
        ChatHistoryView.stableMessageKey(first, fallbackIndex: 0),
        ChatHistoryView.stableMessageKey(second, fallbackIndex: 12),
      );
    });

    test('different text, date, and role produce different stable keys', () {
      final base = AIChatStruct(
        message: 'hello',
        role: 'assistant',
        date: DateTime(2026, 5, 10, 12),
      );
      final baseKey = ChatHistoryView.stableMessageKey(base);

      expect(
        ChatHistoryView.stableMessageKey(AIChatStruct(
          message: 'hello!',
          role: 'assistant',
          date: DateTime(2026, 5, 10, 12),
        )),
        isNot(baseKey),
      );
      expect(
        ChatHistoryView.stableMessageKey(AIChatStruct(
          message: 'hello',
          role: 'assistant',
          date: DateTime(2026, 5, 10, 13),
        )),
        isNot(baseKey),
      );
      expect(
        ChatHistoryView.stableMessageKey(AIChatStruct(
          message: 'hello',
          role: 'user',
          date: DateTime(2026, 5, 10, 12),
        )),
        isNot(baseKey),
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
