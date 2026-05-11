import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/calorie_goal_service.dart';

void main() {
  group('CalorieGoalService', () {
    test('calculates Mifflin-St Jeor goals and 25/25/50 macros', () {
      final result = CalorieGoalService.calculate(
        heightCm: 180,
        weightKg: 80,
        age: 30,
        gender: 'Male',
        activityLevel: CalorieGoalService.mostlySittingOrStanding,
        userGoal: CalorieGoalService.minimizeDamage,
      );

      expect(result.missingFields, isEmpty);
      expect(result.kcalGoal, 2136);
      expect(result.proteinsGoal, 134);
      expect(result.fatsGoal, 59);
      expect(result.carbsGoal, 267);
    });

    test('applies user goal policies to TDEE', () {
      CalorieGoalResult calculate(String userGoal) =>
          CalorieGoalService.calculate(
            heightCm: 170,
            weightKg: 70,
            age: 28,
            gender: 'Female',
            activityLevel: CalorieGoalService.onYourFeetOften,
            userGoal: userGoal,
          );

      expect(calculate(CalorieGoalService.loseWeight).kcalGoal, 1809);
      expect(calculate(CalorieGoalService.minimizeDamage).kcalGoal, 2010);
      expect(calculate(CalorieGoalService.gainMuscle).kcalGoal, 2211);
    });

    test('reports missing and invalid fields without calculating goals', () {
      final result = CalorieGoalService.calculate(
        heightCm: 0,
        weightKg: null,
        age: -1,
        gender: '',
        activityLevel: 'Unknown',
        userGoal: null,
      );

      expect(
        result.missingFields,
        [
          'heightCm',
          'weightKg',
          'age',
          'gender',
          'activityLevel',
          'userGoal',
        ],
      );
      expect(result.kcalGoal, 0);
      expect(result.proteinsGoal, 0);
      expect(result.fatsGoal, 0);
      expect(result.carbsGoal, 0);
    });
  });
}
