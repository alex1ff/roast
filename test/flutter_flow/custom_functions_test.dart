import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/flutter_flow/custom_functions.dart'
    as functions;

void main() {
  group('formatRecentDishForChat', () {
    test('omits hidden nutrition records from recent meals context', () {
      expect(
        functions.formatRecentDishForChat(
          dishName: 'Sam',
          addedDate: DateTime(2026, 6, 2),
          kcal: 999,
          showNutrition: false,
        ),
        isNull,
      );
      expect(
        functions.formatRecentDishForChat(
          dishName: 'Pasta',
          addedDate: DateTime(2026, 6, 1),
          kcal: 640,
          showNutrition: true,
        ),
        '01.06:Pasta(640);',
      );
    });
  });

  group('buildDishAgentInput', () {
    test('keeps nutrition snapshot fields in kcal proteins fats carbs order',
        () {
      final prompt = functions.buildDishAgentInput(
        're_roast',
        'Burger',
        'photo',
        300,
        const ['bun', 'patty'],
        'Cafe',
        'normal',
        'normal',
        'maintain',
        2200,
        'English',
        'medium',
        'Snack Shady',
        700,
        40,
        25,
        80,
        const [],
        'balanced_pick',
        'Balanced pick',
        const [],
      );

      expect(
        prompt,
        contains(
            'nutrition_snapshot=dish_weight:300,kcal:700,proteins:40,fats:25,carbs:80,'),
      );
    });
  });
}
