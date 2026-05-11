class CalorieGoalResult {
  const CalorieGoalResult({
    required this.kcalGoal,
    required this.proteinsGoal,
    required this.fatsGoal,
    required this.carbsGoal,
    required this.missingFields,
  });

  final int kcalGoal;
  final int proteinsGoal;
  final int fatsGoal;
  final int carbsGoal;
  final List<String> missingFields;

  bool get isComplete => missingFields.isEmpty;
}

class CalorieGoalService {
  static const mostlySittingOrStanding = 'Mostly sitting or standing';
  static const onYourFeetOften = 'On your feet often or walk a lot';
  static const physicallyActive = 'Phys.active job or regular workouts';

  static const loseWeight = 'Lose Weight';
  static const gainMuscle = 'Gain Muscle';
  static const minimizeDamage = 'Minimize Damage While Eating Out';

  static CalorieGoalResult calculate({
    required double? heightCm,
    required double? weightKg,
    required int? age,
    required String? gender,
    required String? activityLevel,
    required String? userGoal,
  }) {
    final missingFields = <String>[
      if (heightCm == null || heightCm <= 0) 'heightCm',
      if (weightKg == null || weightKg <= 0) 'weightKg',
      if (age == null || age <= 0) 'age',
      if (_genderOffset(gender) == null) 'gender',
      if (_activityMultiplier(activityLevel) == null) 'activityLevel',
      if (_goalMultiplier(userGoal) == null) 'userGoal',
    ];

    if (missingFields.isNotEmpty) {
      return CalorieGoalResult(
        kcalGoal: 0,
        proteinsGoal: 0,
        fatsGoal: 0,
        carbsGoal: 0,
        missingFields: missingFields,
      );
    }

    final bmr = (10 * weightKg!) +
        (6.25 * heightCm!) -
        (5 * age!) +
        _genderOffset(gender)!;
    final tdee = bmr * _activityMultiplier(activityLevel)!;
    final kcalGoal = (tdee * _goalMultiplier(userGoal)!).round();

    return CalorieGoalResult(
      kcalGoal: kcalGoal,
      proteinsGoal: (kcalGoal * 0.25 / 4).round(),
      fatsGoal: (kcalGoal * 0.25 / 9).round(),
      carbsGoal: (kcalGoal * 0.5 / 4).round(),
      missingFields: const [],
    );
  }

  static double? _genderOffset(String? gender) {
    switch (gender?.trim().toLowerCase()) {
      case 'male':
        return 5;
      case 'female':
        return -161;
      default:
        return null;
    }
  }

  static double? _activityMultiplier(String? activityLevel) {
    switch (activityLevel?.trim()) {
      case mostlySittingOrStanding:
        return 1.2;
      case onYourFeetOften:
        return 1.375;
      case physicallyActive:
        return 1.55;
      default:
        return null;
    }
  }

  static double? _goalMultiplier(String? userGoal) {
    switch (userGoal?.trim()) {
      case loseWeight:
        return 0.9;
      case gainMuscle:
        return 1.1;
      case minimizeDamage:
        return 1.0;
      default:
        return null;
    }
  }
}
