// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

Future<String?> shareRoastLink(
  DocumentReference? dish,
  String? preparedShareUrl,
) async {
  var shareUrl = preparedShareUrl?.trim();

  if (shareUrl == null || shareUrl.isEmpty) {
    if (dish == null) {
      return null;
    }

    final response = await makeCloudCall(
      'createRoastShare',
      {
        'dishPath': dish.path,
      },
    );

    shareUrl = response['shareUrl'] as String?;
    if (shareUrl == null || shareUrl.trim().isEmpty) {
      return null;
    }

    shareUrl = shareUrl.trim();
  }

  await SharePlus.instance.share(
    ShareParams(
      text: shareUrl,
      subject: 'Roast Them All',
    ),
  );

  return shareUrl;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
