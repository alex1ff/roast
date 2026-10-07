import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/email_validation.dart';

void main() {
  test('accepts plus aliases and sends only the normalized domain', () async {
    String? requestedDomain;
    final error = await EmailValidation.domainError(
      ' User+roast@Proton.Me ',
      request: (domain) async {
        requestedDomain = domain;
        return {'valid': true};
      },
    );
    expect(error, isNull);
    expect(requestedDomain, 'proton.me');
    expect(EmailValidation.normalize(' User+roast@Proton.Me '),
        'User+roast@proton.me');
  });

  test('malformed input never makes a domain request', () async {
    for (final email in [
      'random',
      'a@@gmail.com',
      'a..b@gmail.com',
      'a@nonexistent',
      'a@-gmail.com',
      'a b@gmail.com'
    ]) {
      final error =
          await EmailValidation.domainError(email, request: (_) async {
        fail('Invalid syntax must not reach the domain checker');
      });
      expect(error, isNotNull);
    }
  });

  test('rejects disposable addresses with a specific message', () async {
    final error = await EmailValidation.domainError('user@mailinator.com',
        request: (_) async => {'valid': false, 'reason': 'disposable'});
    expect(error, contains('permanent email'));
  });

  test('network errors and malformed responses cannot permit signup', () async {
    for (final response in <Map<String, dynamic>>[
      {'_error': true, 'code': 'unavailable'},
      {},
      {'valid': 'true'},
    ]) {
      final error = await EmailValidation.domainError('user@gmail.com',
          request: (_) async => response);
      expect(error, contains('try again'));
    }
  });
}
