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
  });

  factory RoastAnalysis.fromAgentResponse(dynamic response) => RoastAnalysis(
        dishName: _string(response, r'''$.dish_name'''),
        dishWeight: _int(response, r'''$.dish_weight'''),
        kcal: _int(response, r'''$.kcal'''),
        carbs: _int(response, r'''$.carbs'''),
        proteins: _int(response, r'''$.proteins'''),
        fats: _int(response, r'''$.fats'''),
        roastText: _string(response, r'''$.roast'''),
        badge: _string(response, r'''$.primary_badge_text'''),
        impact: _string(response, r'''$.goal_impact_text'''),
        calorieShare: _string(response, r'''$.daily_calorie_share_text'''),
        mainIngredients: _stringList(response, r'''$.main_ingredients'''),
        vitamins: _vitamins(response, r'''$.vitaminsAndMinerals'''),
        healthTips: _stringList(response, r'''$.smart_tweaks'''),
      );

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
