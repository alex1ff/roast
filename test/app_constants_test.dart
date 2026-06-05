import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/app_constants.dart';

void main() {
  group('roast personas', () {
    test('contains the configured persona options', () {
      expect(roastPersonaOptions, hasLength(30));
      expect(roastPersonaOptions.first.id, defaultRoastPersonaId);
      expect(roastPersonaDisplayNames(), contains('Snack Shady'));
      expect(roastPersonaDisplayNames(), contains('Iron Pan'));
      expect(roastPersonaDisplayNames(), contains('Southie Beefcake'));
      expect(roastPersonaDisplayNames(), contains('Tyler Sweets'));
    });

    test('resolves ids, display names, and legacy names', () {
      expect(roastPersonaIdForValue('wolf_wrap_street'), 'wolf_wrap_street');
      expect(roastPersonaIdForValue('Wolf of Wrap Street'), 'wolf_wrap_street');
      expect(roastPersonaIdForValue('Breadpool'), 'breadfool');
      expect(roastPersonaIdForValue('The Orange Deal Maker'),
          isNot(defaultRoastPersonaId));
      expect(roastPersonaIdForValue('Gordon Rant-say'),
          isNot(defaultRoastPersonaId));
      expect(
          roastPersonaIdForValue('Snackye West'), isNot(defaultRoastPersonaId));
      expect(roastPersonaIdForValue('Lil Green Roastmaster'),
          'lil_green_roastmaster');
      expect(roastPersonaIdForValue('Jo-Da, Lil Green Roastmaster'),
          'lil_green_roastmaster');
      expect(roastPersonaIdForValue('jo_da_lil_green_roastmaster'),
          'lil_green_roastmaster');
      expect(roastPersonaDisplayNameForId('snack_shady'), 'Snack Shady');
    });
  });

  group('congratu roast occasions', () {
    test('contains stable keys for every configured occasion', () {
      expect(congratuRoastOccasionOptions, hasLength(23));
      expect(congratuRoastOccasionOptions.first.key, 'birthday');
      expect(congratuRoastOccasionOptions.first.label, 'Birthday');
      expect(
        congratuRoastOccasionOptions.map((occasion) => occasion.key),
        containsAll([
          'lazy_ass_day',
          'professional_overthinker_award',
          'most_likely_to_ignore_good_advice',
        ]),
      );
    });

    test('resolves occasion labels by key', () {
      expect(
        congratuRoastOccasionLabelForKey('lazy_ass_day'),
        'Lazy Ass Day',
      );
      expect(
        congratuRoastOccasionLabelForKey('missing'),
        congratuRoastOccasionOptions.first.label,
      );
    });
  });
}
