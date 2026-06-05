import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/services/nutrition_summary.dart';

void main() {
  group('NutritionSummary', () {
    test('sums kcal and macros once from entries', () {
      final summary = NutritionSummary.fromEntries([
        const NutritionEntry(kcal: 420, fats: 14, carbs: 50, proteins: 22),
        const NutritionEntry(kcal: 180, fats: 6, carbs: 20, proteins: 12),
      ]);

      expect(summary.kcal, 600);
      expect(summary.fats, 20);
      expect(summary.carbs, 70);
      expect(summary.proteins, 34);
    });

    test('ignores entries hidden from nutrition summary', () {
      final summary = NutritionSummary.fromEntries([
        const NutritionEntry(kcal: 420, fats: 14, carbs: 50, proteins: 22),
        const NutritionEntry(
          kcal: 999,
          fats: 99,
          carbs: 99,
          proteins: 99,
          includeInSummary: false,
        ),
      ]);

      expect(summary.kcal, 420);
      expect(summary.fats, 14);
      expect(summary.carbs, 50);
      expect(summary.proteins, 22);
    });

    test('computes bounded progress and remaining kcal', () {
      final summary = NutritionSummary.fromEntries([
        const NutritionEntry(kcal: 1200, fats: 30, carbs: 140, proteins: 90),
      ]);

      expect(
        NutritionSummary.progress(value: summary.kcal, goal: 2000),
        0.6,
      );
      expect(
        NutritionSummary.progress(value: summary.kcal, goal: 1000),
        1.0,
      );
      expect(NutritionSummary.progress(value: summary.kcal, goal: 0), isNull);
      expect(summary.remainingKcal(2000), 800);
      expect(summary.absoluteRemainingKcal(1000), 200);
      expect(summary.exceedsKcalGoal(1000), true);
    });

    test('converts grams to ounces using existing one-decimal floor behavior',
        () {
      expect(NutritionSummary.gramsToOz(100), 3.5);
      expect(NutritionSummary.gramsToOz(0), 0.0);
      expect(NutritionSummary.gramsToOz(null), isNull);
    });

    test('formats grams using the selected measurement system', () {
      expect(
        NutritionSummary.formatGrams(100, useOunces: false),
        '100 g',
      );
      expect(
        NutritionSummary.formatGrams(100, useOunces: true),
        '3.5 oz (100g)',
      );
      expect(
        NutritionSummary.formatGrams(null, useOunces: true),
        '0.0 oz (0g)',
      );
    });

    test('computes day boundaries for Firestore range queries', () {
      final value = DateTime(2026, 5, 10, 23, 59, 59);

      expect(
        NutritionSummary.startOfDay(value),
        DateTime(2026, 5, 10),
      );
      expect(
        NutritionSummary.endOfDay(value),
        DateTime(2026, 5, 11),
      );
    });
  });
}
