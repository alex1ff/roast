import 'dart:async';

import '/backend/cloud_functions/cloud_functions.dart';

typedef EmailDomainRequest = Future<Map<String, dynamic>> Function(
    String domain);

class EmailValidation {
  const EmailValidation._();

  static String normalize(String value) {
    final email = value.trim();
    final separator = email.lastIndexOf('@');
    if (separator < 0) {
      return email;
    }
    return '${email.substring(0, separator)}@'
        '${email.substring(separator + 1).toLowerCase()}';
  }

  static String? formatError(String? value) {
    final email = normalize(value ?? '');
    if (email.isEmpty) {
      return 'Enter your email address.';
    }
    final parts = email.split('@');
    const invalidMessage = 'Enter a valid email, e.g. name@gmail.com.';
    if (email.length > 254 || parts.length != 2) {
      return invalidMessage;
    }
    final local = parts.first;
    final domain = parts.last;
    if (local.isEmpty ||
        local.length > 64 ||
        local.startsWith('.') ||
        local.endsWith('.') ||
        local.contains('..') ||
        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+$").hasMatch(local)) {
      return invalidMessage;
    }
    final labels = domain.split('.');
    if (domain.length > 253 ||
        labels.length < 2 ||
        !labels.every((label) => RegExp(
              r'^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$',
            ).hasMatch(label)) ||
        !RegExp(r'^(?:[a-z]{2,63}|xn--[a-z0-9-]+)$').hasMatch(labels.last)) {
      return invalidMessage;
    }
    return null;
  }

  static Future<String?> domainError(
    String email, {
    EmailDomainRequest? request,
  }) async {
    final formatIssue = formatError(email);
    if (formatIssue != null) {
      return formatIssue;
    }
    try {
      final checkDomain = request ??
          (String domain) => makeCloudCall('validateEmailDomain', {
                'domain': domain,
              });
      final response = await checkDomain(normalize(email).split('@').last)
          .timeout(const Duration(seconds: 20));
      if (response['_error'] != true && response['valid'] == true) {
        return null;
      }
      if (response['_error'] != true && response['valid'] == false) {
        if (response['reason'] == 'disposable') {
          return 'Use a permanent email address instead of a temporary one.';
        }
        return "This domain can't receive email. Check the address.";
      }
    } on TimeoutException {
      // A network/DNS failure must not be presented as an invalid address.
    }
    return "Couldn't check your email. Please try again.";
  }
}
