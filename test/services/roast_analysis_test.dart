import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/roast_analysis.dart';

void main() {
  group('RoastAnalysis', () {
    test('parses roast agent response into typed fields', () {
      final analysis = RoastAnalysis.fromAgentResponse({
        'dish_name': 'Taco Bowl',
        'dish_weight': 420,
        'kcal': 650,
        'carbs': 72,
        'proteins': 38,
        'fats': 24,
        'roast': 'A bowl with main character energy.',
        'primary_badge_text': 'Protein decent',
        'goal_impact_text': 'Fits today if dinner behaves.',
        'daily_calorie_share_text': '32% of daily calories',
        'main_ingredients': ['rice', 'beans'],
        'vitaminsAndMinerals': [
          {'vitamin': 'Iron', 'description': '2 mg'},
        ],
        'smart_tweaks': ['Skip sour cream'],
      });

      expect(analysis.dishName, 'Taco Bowl');
      expect(analysis.dishWeight, 420);
      expect(analysis.kcal, 650);
      expect(analysis.carbs, 72);
      expect(analysis.proteins, 38);
      expect(analysis.fats, 24);
      expect(analysis.roastText, 'A bowl with main character energy.');
      expect(analysis.badge, 'Protein decent');
      expect(analysis.impact, 'Fits today if dinner behaves.');
      expect(analysis.calorieShare, '32% of daily calories');
      expect(analysis.mainIngredients, ['rice', 'beans']);
      expect(analysis.vitamins.single.vitamin, 'Iron');
      expect(analysis.healthTips, ['Skip sour cream']);
    });

    test('normalizes string ints and missing list fields', () {
      final analysis = RoastAnalysis.fromAgentResponse({
        'dish_weight': '250',
        'kcal': '430',
        'carbs': '41',
        'proteins': '18',
        'fats': '12',
      });

      expect(analysis.dishWeight, 250);
      expect(analysis.kcal, 430);
      expect(analysis.carbs, 41);
      expect(analysis.proteins, 18);
      expect(analysis.fats, 12);
      expect(analysis.roastText, '');
      expect(analysis.mainIngredients, isEmpty);
      expect(analysis.vitamins, isEmpty);
      expect(analysis.healthTips, isEmpty);
    });
  });
}
