import '/app_constants.dart';
import '/backend/backend.dart';

class RoastResultMetadata {
  const RoastResultMetadata._();

  static bool hasPositiveNutrition(AddedDishHistoryRecord record) {
    return record.kcal > 0 ||
        record.proteins > 0 ||
        record.fats > 0 ||
        record.carbs > 0;
  }

  static bool shouldShowNutrition(AddedDishHistoryRecord record) {
    final mode = normalizedMode(record.roastMode);
    final subjectType = record.subjectType.trim();

    if (mode == FFAppConstants.roastModeCongratuRoast) {
      return false;
    }
    if (subjectType.isNotEmpty &&
        subjectType != FFAppConstants.subjectTypeDish) {
      return false;
    }
    if (record.hasShowNutrition()) {
      return record.showNutrition;
    }

    return hasPositiveNutrition(record);
  }

  static String normalizedMode(String value) {
    final mode = value.trim();
    return mode.isEmpty ? FFAppConstants.roastModeRoast : mode;
  }

  static bool isCongratuRoast(AddedDishHistoryRecord record) {
    return normalizedMode(record.roastMode) ==
        FFAppConstants.roastModeCongratuRoast;
  }
}
