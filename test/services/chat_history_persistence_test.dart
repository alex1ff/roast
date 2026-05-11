import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/app_state.dart';
import 'package:roast_nutri_tracker/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FFAppState chat history persistence', () {
    late FFAppState appState;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      FFAppState.reset();
      appState = FFAppState();
      await appState.initializePersistedState();
    });

    tearDown(() async {
      await appState.flushChatHistoryPersistence();
      FFAppState.reset();
    });

    test('debounces repeated chat history writes', () async {
      appState.addToChathistory(AIChatStruct(
        message: 'one',
        role: 'user',
        date: DateTime(2026, 5, 10, 12),
      ));
      appState.addToChathistory(AIChatStruct(
        message: 'two',
        role: 'assistant',
        date: DateTime(2026, 5, 10, 12, 0, 1),
      ));
      appState.updateChathistoryAtIndex(
        1,
        (message) => message..message = 'two updated',
      );

      expect(appState.chatHistoryPersistWriteCount, 0);
      expect(appState.prefs.getStringList('ff_chathistory'), isNull);

      await Future<void>.delayed(
        FFAppState.chatHistoryPersistDebounce +
            const Duration(milliseconds: 50),
      );

      final persisted = appState.prefs.getStringList('ff_chathistory');
      expect(appState.chatHistoryPersistWriteCount, 1);
      expect(persisted, hasLength(2));
      expect(persisted!.last, contains('two updated'));
    });

    test('flush writes pending chat history immediately', () async {
      appState.addToChathistory(AIChatStruct(
        message: 'pending',
        role: 'user',
        date: DateTime(2026, 5, 10, 12),
      ));

      await appState.flushChatHistoryPersistence();

      final persisted = appState.prefs.getStringList('ff_chathistory');
      expect(appState.chatHistoryPersistWriteCount, 1);
      expect(persisted, hasLength(1));
      expect(persisted!.single, contains('pending'));
    });

    test('restores persisted chat history after app state reset', () async {
      appState.addToChathistory(AIChatStruct(
        message: 'restored',
        role: 'assistant',
        date: DateTime(2026, 5, 10, 12),
      ));
      await appState.flushChatHistoryPersistence();

      FFAppState.reset();
      final restoredState = FFAppState();
      await restoredState.initializePersistedState();

      expect(restoredState.chathistory, hasLength(1));
      expect(restoredState.chathistory.single.message, 'restored');
      await restoredState.flushChatHistoryPersistence();
    });
  });
}
