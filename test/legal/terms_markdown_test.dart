import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('terms markdown is the latest revision used by terms screens', () {
    final termsFile = File('lib/legal/terms_markdown.dart');

    expect(termsFile.existsSync(), isTrue);

    final termsSource = termsFile.readAsStringSync();
    expect(termsSource, contains('const String termsMarkdown'));
    expect(termsSource, contains('**Last updated:** 27 May 2026'));
    expect(
      termsSource,
      contains(
        'The App is intended for consensual, lighthearted, social entertainment use',
      ),
    );
    expect(
      termsSource,
      contains(
        '- YOU ARE SOLELY RESPONSIBLE FOR ANY SHARING, PUBLICATION, OR DISTRIBUTION',
      ),
    );

    final termsScreen =
        File('lib/auth/term/term_widget.dart').readAsStringSync();
    final rulesDialog =
        File('lib/main_page/choose_person/roast_rules_dialog.dart')
            .readAsStringSync();

    expect(termsScreen, contains('termsMarkdown'));
    expect(rulesDialog, contains('termsMarkdown'));
  });
}
