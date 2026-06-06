abstract class FFAppConstants {
  static const List<String> gender = ['Male', 'Female'];
  static const List<String> UserGoal = [
    'Minimize Damage While Eating Out',
    'Lose Weight',
    'Gain Muscle'
  ];
  static const List<String> ActivityLevel = [
    'Mostly sitting or standing',
    'On your feet often or walk a lot',
    'Phys.active job or regular workouts'
  ];
  static const List<String> RoastLevelVariants = [
    'Light Roast',
    'Medium Heat',
    'Full Inferno'
  ];
  static const String Premium = 'Premium';
  static const int countlimitedW = 25;
  static const int countlimitedchatW = 25;
  static const int countlimitedM = 280;
  static const int countlimitedchatM = 300;
  static const int limitedNoSub = 3;
  static const int countlimitedY = 3360;
  static const int countlimitedchatY = 3600;
  static const String roastModeRoast = 'roast';
  static const String roastModeCongratuRoast = 'congratu_roast';
  static const String subjectTypeDish = 'dish';
  static const String subjectTypePerson = 'person';
  static const String subjectTypeOther = 'other';
}

class CongratuRoastOccasionOption {
  const CongratuRoastOccasionOption({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}

const congratuRoastOccasionOptions = <CongratuRoastOccasionOption>[
  CongratuRoastOccasionOption(key: 'birthday', label: 'Birthday'),
  CongratuRoastOccasionOption(key: 'wedding', label: 'Wedding'),
  CongratuRoastOccasionOption(key: 'new_baby', label: 'New Baby'),
  CongratuRoastOccasionOption(key: 'graduation', label: 'Graduation'),
  CongratuRoastOccasionOption(key: 'promotion', label: 'Promotion'),
  CongratuRoastOccasionOption(key: 'christmas', label: 'Christmas'),
  CongratuRoastOccasionOption(key: 'new_year', label: 'New Year'),
  CongratuRoastOccasionOption(
    key: 'valentines_day',
    label: 'Valentine\'s Day',
  ),
  CongratuRoastOccasionOption(key: 'thanksgiving', label: 'Thanksgiving'),
  CongratuRoastOccasionOption(key: 'halloween', label: 'Halloween'),
  CongratuRoastOccasionOption(
    key: 'mothers_day',
    label: 'Mother\'s Day',
  ),
  CongratuRoastOccasionOption(
    key: 'fathers_day',
    label: 'Father\'s Day',
  ),
  CongratuRoastOccasionOption(key: 'retirement', label: 'Retirement'),
  CongratuRoastOccasionOption(
    key: 'assholes_day',
    label: 'Asshole\'s Day',
  ),
  CongratuRoastOccasionOption(key: 'lazy_ass_day', label: 'Lazy Ass Day'),
  CongratuRoastOccasionOption(key: 'hard_worker_day', label: 'Hard Worker Day'),
  CongratuRoastOccasionOption(
    key: 'survived_another_monday',
    label: 'Survived Another Monday',
  ),
  CongratuRoastOccasionOption(
    key: 'professional_overthinker_award',
    label: 'Professional Overthinker Award',
  ),
  CongratuRoastOccasionOption(
    key: 'certified_chaos_generator',
    label: 'Certified Chaos Generator',
  ),
  CongratuRoastOccasionOption(
    key: 'walking_red_flag_award',
    label: 'Walking Red Flag Award',
  ),
  CongratuRoastOccasionOption(
    key: 'drama_queen_award',
    label: 'Drama Queen Award',
  ),
  CongratuRoastOccasionOption(
    key: 'human_disaster_of_the_month',
    label: 'Human Disaster of the Month',
  ),
  CongratuRoastOccasionOption(
    key: 'most_likely_to_ignore_good_advice',
    label: 'Most Likely to Ignore Good Advice',
  ),
];

String congratuRoastOccasionLabelForKey(String key) {
  final normalizedKey = key.trim();
  return congratuRoastOccasionOptions
      .firstWhere(
        (occasion) => occasion.key == normalizedKey,
        orElse: () => congratuRoastOccasionOptions.first,
      )
      .label;
}

class RoastPersonaOption {
  const RoastPersonaOption({
    required this.id,
    required this.displayName,
  });

  final String id;
  final String displayName;
}

const defaultRoastPersonaId = 'wolf_wrap_street';

const roastPersonaOptions = <RoastPersonaOption>[
  RoastPersonaOption(
    id: 'wolf_wrap_street',
    displayName: 'Wolf of Wrap Street',
  ),
  RoastPersonaOption(id: 'fight_bite_dana', displayName: 'Fight Bite Dana'),
  RoastPersonaOption(
    id: 'lil_green_roastmaster',
    displayName: 'Lil Green Roastmaster',
  ),
  RoastPersonaOption(id: 'connor_mc_roast', displayName: 'Connor McRoast'),
  RoastPersonaOption(id: 'bro_lebunski', displayName: 'Bro Lebunski'),
  RoastPersonaOption(id: 'tony_pepperoni', displayName: 'Tony Pepperoni'),
  RoastPersonaOption(id: 'the_dough_knight', displayName: 'The Dough Knight'),
  RoastPersonaOption(
    id: 'arty_snack_roast_clown',
    displayName: 'Arty Snack, the Roast Clown',
  ),
  RoastPersonaOption(id: 'jayson_snackham', displayName: 'Jayson Snackham'),
  RoastPersonaOption(id: 'iron_bite', displayName: 'Iron Bite'),
  RoastPersonaOption(id: 'iron_pan', displayName: 'Iron Pan'),
  RoastPersonaOption(
    id: 'sn00p_snackity_snack',
    displayName: 'Sn00p Snackity-Snack',
  ),
  RoastPersonaOption(id: 'snack_the_parrot', displayName: 'Snack the Parrot'),
  RoastPersonaOption(id: 'breadfool', displayName: 'Breadfool'),
  RoastPersonaOption(id: 'honeybal_lentil', displayName: 'Honeybal Lentil'),
  RoastPersonaOption(id: 'shaq_and_cheese', displayName: 'Shaq & Cheese'),
  RoastPersonaOption(
    id: 'slim_carb_dashyan',
    displayName: 'Slim Carb-dashyan',
  ),
  RoastPersonaOption(id: 'calorinator', displayName: 'Calorinator'),
  RoastPersonaOption(id: 'rocky_bun_boa', displayName: 'Rocky Bun-boa'),
  RoastPersonaOption(
    id: 'bro_jogan_protein_philosopher',
    displayName: 'Bro Jogan, The Protein Philosopher',
  ),
  RoastPersonaOption(id: 'carbface', displayName: 'Carbface'),
  RoastPersonaOption(
    id: 'yo_yo_carb_kid',
    displayName: 'Yo-Yo Carb Kid, B*tch!',
  ),
  RoastPersonaOption(id: 'heisenbun', displayName: 'Heisenbun'),
  RoastPersonaOption(
    id: 'taco_slam_a_bun_ca',
    displayName: 'Taco Slam-a-Bun-ca',
  ),
  RoastPersonaOption(id: 'bread_pita', displayName: 'Bread Pita'),
  RoastPersonaOption(id: 'southie_beefcake', displayName: 'Southie Beefcake'),
  RoastPersonaOption(id: 'snack_shady', displayName: 'Snack Shady'),
  RoastPersonaOption(id: 'dark_breader', displayName: 'Dark Breader'),
  RoastPersonaOption(
    id: 'no_privacy_algorithm_eater',
    displayName: 'No-privacy Algorithm Eater',
  ),
  RoastPersonaOption(id: 'mars_dinner_chef', displayName: 'Mars Dinner Chef'),
];

const _legacyRoastPersonaAliases = <String, String>{
  'Snackwolf of Wall Street': 'wolf_wrap_street',
  'Dark Snack Knight': 'the_dough_knight',
  'Arty McSnack, the Roast Clown': 'arty_snack_roast_clown',
  'Bite-Sized Iron Mikey': 'iron_bite',
  'Snack Sparrow': 'snack_the_parrot',
  'Breadpool': 'breadfool',
  'Slim Snackdashian': 'slim_carb_dashyan',
  'The Orange Deal Maker': 'tony_pepperoni',
  'Gordon Rant-say': 'mars_dinner_chef',
  'Snackye West': 'slim_carb_dashyan',
  'Jo-Da, Lil Green Roastmaster': 'lil_green_roastmaster',
  'jo_da_lil_green_roastmaster': 'lil_green_roastmaster',
  'Ivan the Enforcer': 'bro_lebunski',
  'ivan_the_enforcer': 'bro_lebunski',
  'Tyler Sweets': 'carbface',
  'tyler_sweets': 'carbface',
};

List<String> roastPersonaDisplayNames() =>
    roastPersonaOptions.map((persona) => persona.displayName).toList();

String? roastPersonaIdForValueOrNull(String value) {
  final normalizedValue = value.trim();
  if (normalizedValue.isEmpty) {
    return null;
  }

  for (final persona in roastPersonaOptions) {
    if (persona.id == normalizedValue ||
        persona.displayName == normalizedValue) {
      return persona.id;
    }
  }

  return _legacyRoastPersonaAliases[normalizedValue];
}

String roastPersonaIdForValue(String value) =>
    roastPersonaIdForValueOrNull(value) ?? defaultRoastPersonaId;

String roastPersonaIdForDisplayName(String displayName) =>
    roastPersonaIdForValue(displayName);

String roastPersonaDisplayNameForId(String id) {
  final normalizedId = id.trim();
  return roastPersonaOptions
      .firstWhere(
        (persona) => persona.id == normalizedId,
        orElse: () => roastPersonaOptions.first,
      )
      .displayName;
}
