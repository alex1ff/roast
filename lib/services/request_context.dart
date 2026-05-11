const clientRequestIdKey = '_clientRequestId';
const clientRequestIdHeader = 'X-Client-Request-Id';

class AppRequestContext {
  AppRequestContext._();

  static int _counter = 0;

  static String newRequestId({required String prefix}) {
    final sanitizedPrefix = prefix.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final safePrefix = sanitizedPrefix.isEmpty ? 'request' : sanitizedPrefix;
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final counter = (_counter++).toRadixString(36);
    final requestId = '${safePrefix}_${timestamp}_$counter';
    return requestId.length <= 64 ? requestId : requestId.substring(0, 64);
  }

  static Map<String, dynamic> withClientRequestId(
    Map<String, dynamic> source, {
    required String requestId,
  }) =>
      {
        ...source,
        clientRequestIdKey: requestId,
      };
}
