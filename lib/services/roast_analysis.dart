import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RoastAnalysis {
  const RoastAnalysis({
    required this.dishName,
    required this.dishWeight,
    required this.kcal,
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.roastText,
    required this.badge,
    required this.impact,
    required this.calorieShare,
    required this.mainIngredients,
    required this.vitamins,
    required this.healthTips,
    required this.roastMode,
    required this.occasionKey,
    required this.occasionLabel,
    required this.subjectType,
    required this.showNutrition,
  });

  factory RoastAnalysis.fromAgentResponse(dynamic response) {
    final roastMode = _string(response, r'''$.roast_mode''');
    final normalizedMode =
        roastMode.isEmpty ? FFAppConstants.roastModeRoast : roastMode;
    final kcal = _int(response, r'''$.kcal''');
    final carbs = _int(response, r'''$.carbs''');
    final proteins = _int(response, r'''$.proteins''');
    final fats = _int(response, r'''$.fats''');
    final hasPositiveNutrition = (kcal ?? 0) > 0 ||
        (carbs ?? 0) > 0 ||
        (proteins ?? 0) > 0 ||
        (fats ?? 0) > 0;
    final responseSubjectType = _string(response, r'''$.subject_type''');
    final subjectType = responseSubjectType.isNotEmpty
        ? responseSubjectType
        : hasPositiveNutrition
            ? FFAppConstants.subjectTypeDish
            : FFAppConstants.subjectTypeOther;
    final responseShowNutrition = _bool(response, r'''$.show_nutrition''');
    final showNutrition = responseShowNutrition ??
        (normalizedMode == FFAppConstants.roastModeRoast &&
            subjectType == FFAppConstants.subjectTypeDish &&
            hasPositiveNutrition);

    return RoastAnalysis(
      dishName: _string(response, r'''$.dish_name'''),
      dishWeight: _int(response, r'''$.dish_weight'''),
      kcal: kcal,
      carbs: carbs,
      proteins: proteins,
      fats: fats,
      roastText: _string(response, r'''$.roast'''),
      badge: _string(response, r'''$.primary_badge_text'''),
      impact: _string(response, r'''$.goal_impact_text'''),
      calorieShare: _string(response, r'''$.daily_calorie_share_text'''),
      mainIngredients: _stringList(response, r'''$.main_ingredients'''),
      vitamins: _vitamins(response, r'''$.vitaminsAndMinerals'''),
      healthTips: _stringList(response, r'''$.smart_tweaks'''),
      roastMode: normalizedMode,
      occasionKey: _string(response, r'''$.occasion_key'''),
      occasionLabel: _string(response, r'''$.occasion_label'''),
      subjectType: subjectType,
      showNutrition: showNutrition,
    );
  }

  final String dishName;
  final int? dishWeight;
  final int? kcal;
  final int? carbs;
  final int? proteins;
  final int? fats;
  final String roastText;
  final String badge;
  final String impact;
  final String calorieShare;
  final List<String> mainIngredients;
  final List<DishPageVitaminsDataStruct> vitamins;
  final List<String> healthTips;
  final String roastMode;
  final String occasionKey;
  final String occasionLabel;
  final String subjectType;
  final bool showNutrition;

  Map<String, dynamic> nestedFirestoreData() => mapToFirestore(
        {
          'main_ingredients': mainIngredients,
          'vitamins': getDishPageVitaminsDataListFirestoreData(vitamins),
          'health_tips': healthTips,
        },
      );

  static String _string(dynamic response, String path) {
    final value = getJsonField(response, path);
    return value?.toString() ?? '';
  }

  static int? _int(dynamic response, String path) {
    final value = getJsonField(response, path);
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  static bool? _bool(dynamic response, String path) {
    final value = getJsonField(response, path);
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
    return null;
  }

  static List<String> _stringList(dynamic response, String path) {
    final value = getJsonField(response, path, true);
    if (value is! Iterable) {
      return const [];
    }
    return value.map((item) => item.toString()).toList(growable: false);
  }

  static List<DishPageVitaminsDataStruct> _vitamins(
    dynamic response,
    String path,
  ) {
    final value = getJsonField(response, path, true);
    if (value is! Iterable) {
      return const [];
    }

    return value
        .map(DishPageVitaminsDataStruct.maybeFromMap)
        .whereType<DishPageVitaminsDataStruct>()
        .toList(growable: false);
  }
}
