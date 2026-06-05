import '/backend/backend.dart';
import '/services/roast_result_metadata.dart';

class NutritionEntry {
  const NutritionEntry({
    required this.kcal,
    required this.fats,
    required this.carbs,
    required this.proteins,
    this.includeInSummary = true,
  });

  final int kcal;
  final int fats;
  final int carbs;
  final int proteins;
  final bool includeInSummary;

  factory NutritionEntry.fromAddedDishHistoryRecord(
    AddedDishHistoryRecord record,
  ) =>
      NutritionEntry(
        kcal: record.kcal,
        fats: record.fats,
        carbs: record.carbs,
        proteins: record.proteins,
        includeInSummary: RoastResultMetadata.shouldShowNutrition(record),
      );
}

class NutritionSummary {
  const NutritionSummary({
    required this.kcal,
    required this.fats,
    required this.carbs,
    required this.proteins,
  });

  factory NutritionSummary.fromEntries(Iterable<NutritionEntry> entries) {
    var kcal = 0;
    var fats = 0;
    var carbs = 0;
    var proteins = 0;

    for (final entry in entries) {
      if (!entry.includeInSummary) {
        continue;
      }
      kcal += entry.kcal;
      fats += entry.fats;
      carbs += entry.carbs;
      proteins += entry.proteins;
    }

    return NutritionSummary(
      kcal: kcal,
      fats: fats,
      carbs: carbs,
      proteins: proteins,
    );
  }

  factory NutritionSummary.fromAddedDishHistoryRecords(
    Iterable<AddedDishHistoryRecord> records,
  ) =>
      NutritionSummary.fromEntries(
        records.map(NutritionEntry.fromAddedDishHistoryRecord),
      );

  static const empty = NutritionSummary(
    kcal: 0,
    fats: 0,
    carbs: 0,
    proteins: 0,
  );

  final int kcal;
  final int fats;
  final int carbs;
  final int proteins;

  int remainingKcal(int goal) => goal - kcal;

  int absoluteRemainingKcal(int goal) => remainingKcal(goal).abs();

  bool exceedsKcalGoal(int goal) => remainingKcal(goal) < 0;

  static double? progress({
    required int value,
    required int goal,
  }) {
    if (goal <= 0) {
      return null;
    }

    return (value / goal).clamp(0.0, 1.0);
  }

  static double? gramsToOz(int? grams) {
    if (grams == null) {
      return null;
    }

    const gramsPerOunce = 28.349523125;
    return (grams / gramsPerOunce * 10).floorToDouble() / 10;
  }

  static String formatGrams(
    int? grams, {
    required bool useOunces,
  }) {
    final value = grams ?? 0;
    if (!useOunces) {
      return '$value g';
    }

    return '${gramsToOz(value)} oz (${value}g)';
  }

  static DateTime startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime endOfDay(DateTime value) =>
      startOfDay(value).add(const Duration(days: 1));
}
