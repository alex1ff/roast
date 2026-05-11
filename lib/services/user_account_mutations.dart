import 'package:flutter/foundation.dart';

import '/app_constants.dart';
import '/backend/cloud_functions/cloud_functions.dart';

enum UserUsageFeature {
  roast,
  chat,
}

class UserAccountMutationResult {
  const UserAccountMutationResult({
    required this.success,
    this.code,
    this.message,
  });

  final bool success;
  final String? code;
  final String? message;
}

class UserAccountMutations {
  const UserAccountMutations._();

  static Future<UserAccountMutationResult> syncRevenueCatSubscription() {
    return _call('syncRevenueCatSubscription', {
      'entitlementId': FFAppConstants.Premium,
    });
  }

  static Future<UserAccountMutationResult> syncReloadPackPurchase() {
    return _call('syncReloadPackPurchase', {
      'productId': 'Roast_Reload_Pack',
    });
  }

  static Future<UserAccountMutationResult> recordUsage(
    UserUsageFeature feature,
  ) {
    return _call('recordUsage', {
      'feature': feature.name,
    });
  }

  static Future<UserAccountMutationResult> _call(
    String callName,
    Map<String, dynamic> input,
  ) async {
    final response = await makeCloudCall(callName, input);
    final isError = response['_error'] == true;
    if (isError) {
      final code = response['code']?.toString();
      final message = response['message']?.toString() ?? 'Request failed.';
      debugPrint('$callName failed: $code $message');
      return UserAccountMutationResult(
        success: false,
        code: code,
        message: message,
      );
    }

    return const UserAccountMutationResult(success: true);
  }
}
