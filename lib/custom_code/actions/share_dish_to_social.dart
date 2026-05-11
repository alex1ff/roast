// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom actions
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

Future shareDishToSocial(
  String? image,
  String? text,
  String? appstoreurl,
) async {
  final formattedText = _formatItalicText(text);
  final formattedLink = _formatAppStoreLink(appstoreurl);
  final message = _composeMessage(formattedText, formattedLink);

  XFile? attachment;
  if (!kIsWeb && (image?.trim().isNotEmpty ?? false)) {
    attachment = await _loadImageAsXFile(image!.trim());
  }

  if (attachment != null) {
    await SharePlus.instance.share(
      ShareParams(
        files: [attachment],
        text: message.isNotEmpty ? message : null,
        subject: formattedText ?? 'Присоединяйся',
      ),
    );
  } else if (message.isNotEmpty) {
    await SharePlus.instance.share(ShareParams(text: message));
  }
}

String? _formatItalicText(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return '_${trimmed}_';
}

String? _formatAppStoreLink(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return 'Присоединяйся: $trimmed';
}

String _composeMessage(String? italicText, String? appStore) {
  final fragments = <String>[
    if (italicText != null) italicText,
    if (appStore != null) appStore,
  ];
  return fragments.join('\n\n');
}

Future<XFile?> _loadImageAsXFile(String pathOrUrl) async {
  try {
    final uri = Uri.tryParse(pathOrUrl);
    if (uri == null) {
      return XFile(pathOrUrl);
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return XFile.fromData(
          response.bodyBytes,
          name: _resolveFileName(uri.path),
          mimeType: _guessMimeType(uri.path),
        );
      }
      return null;
    }

    if (uri.scheme == 'file') {
      return XFile(uri.toFilePath());
    }

    return XFile(pathOrUrl);
  } catch (_) {
    return null;
  }
}

String _resolveFileName(String path) {
  final sanitized =
      path.split('/').where((segment) => segment.isNotEmpty).toList();
  return sanitized.isNotEmpty ? sanitized.last : 'shared_image.jpg';
}

String? _guessMimeType(String path) {
  final lowerPath = path.toLowerCase();
  if (lowerPath.endsWith('.png')) {
    return 'image/png';
  }
  if (lowerPath.endsWith('.gif')) {
    return 'image/gif';
  }
  return 'image/jpeg';
}
