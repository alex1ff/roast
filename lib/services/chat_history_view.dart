import '/backend/schema/structs/index.dart';

class ChatHistoryView {
  ChatHistoryView._();

  static AIChatStruct messageAtReverseIndex(
    List<AIChatStruct> history,
    int reverseIndex,
  ) {
    final sourceIndex = history.length - 1 - reverseIndex;
    if (sourceIndex < 0 || sourceIndex >= history.length) {
      throw RangeError.index(reverseIndex, history, 'reverseIndex');
    }
    return history[sourceIndex];
  }

  static String stableMessageKey(
    AIChatStruct message, {
    required int fallbackIndex,
  }) {
    final timestamp =
        message.date?.microsecondsSinceEpoch.toRadixString(36) ?? 'nodate';
    final role = _sanitize(message.role.isEmpty ? 'unknown' : message.role);
    return 'chat_${timestamp}_${role}_$fallbackIndex';
  }

  static String _sanitize(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
}
