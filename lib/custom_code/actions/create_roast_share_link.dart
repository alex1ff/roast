// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> createRoastShareLink(DocumentReference? dish) async {
  if (dish == null) {
    return null;
  }

  final response = await makeCloudCall(
    'createRoastShare',
    {
      'dishPath': dish.path,
    },
  );

  final shareUrl = response['shareUrl'] as String?;
  if (shareUrl == null || shareUrl.trim().isEmpty) {
    return null;
  }

  return shareUrl.trim();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
