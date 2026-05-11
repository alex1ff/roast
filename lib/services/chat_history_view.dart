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
    int? fallbackIndex,
    String? textOverride,
  }) {
    final timestamp = message.date?.microsecondsSinceEpoch.toRadixString(36);
    final role = _sanitize(message.role.isEmpty ? 'unknown' : message.role);
    final textHash =
        _hashFNV1a(_normalizeText(textOverride ?? message.message));

    if (timestamp == null) {
      return 'chat_nodate_${role}_$textHash';
    }

    return 'chat_${timestamp}_${role}_$textHash';
  }

  static String _normalizeText(String value) =>
      value.replaceAll(RegExp(r'\s+'), ' ').trim();

  static String _hashFNV1a(String input) {
    int hash = 0x811C9DC5;
    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  static String _sanitize(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
}
