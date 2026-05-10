import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

int? sumKcal(List<AddedDishHistoryRecord>? dishes) {
  if (dishes == null || dishes.isEmpty) {
    return 0;
  }

  int totalKcal = 0;

  for (var dish in dishes) {
    if (dish.kcal != null) {
      totalKcal += dish.kcal!;
    }
  }

  return totalKcal;
}

int? sumFats(List<AddedDishHistoryRecord>? dishes) {
  if (dishes == null || dishes.isEmpty) {
    return 0;
  }

  int totalFats = 0;

  for (var dish in dishes) {
    if (dish.fats != null) {
      totalFats += dish.fats!;
    }
  }

  return totalFats;
}

int? sumCarbs(List<AddedDishHistoryRecord>? dishes) {
  if (dishes == null || dishes.isEmpty) {
    return 0;
  }

  int totalCarbs = 0;

  for (var dish in dishes) {
    if (dish.carbs != null) {
      totalCarbs += dish.carbs!;
    }
  }

  return totalCarbs;
}

int? sumProteins(List<AddedDishHistoryRecord>? dishes) {
  if (dishes == null || dishes.isEmpty) {
    return 0;
  }

  int totalProteins = 0;

  for (var dish in dishes) {
    if (dish.proteins != null) {
      totalProteins += dish.proteins!;
    }
  }

  return totalProteins;
}

double? progressBar(
  int? data,
  int? goal,
) {
  if (data == null || goal == null || goal == 0) {
    return null;
  }

  double progress = data / goal;

  // Ограничим значение от 0.0 до 1.0
  return progress.clamp(0.0, 1.0);
}

List<DateTime> getAllDaysOfMonth(DateTime currentDate) {
  final List<DateTime> days = [];

  final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
  final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

  // Например, пусть понедельник = 1, ..., воскресенье = 7
  // Чтобы неделя начиналась с понедельника, делаем:
  final offset = firstDayOfMonth.weekday - 1;

  // Добавляем "фиктивные" даты вместо null
  for (int i = 0; i < offset; i++) {
    days.add(DateTime(1900, 1, 1)); // или любая другая "пустая" дата
  }

  // Добавляем реальные даты всего месяца
  for (DateTime day = firstDayOfMonth;
      day.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
      day = day.add(const Duration(days: 1))) {
    days.add(day);
  }

  return days;
}

DateTime setMonth(
  DateTime month,
  bool next,
) {
  if (next) {
    // Если next == true, прибавляем месяц
    return DateTime(month.year, month.month + 1, month.day);
  } else {
    // Если next == false, убавляем месяц
    return DateTime(month.year, month.month - 1, month.day);
  }
}

Color? colorObvodkiVCalendare(
  List<AddedDishHistoryRecord>? dishes,
  int? kcalGoal,
  int? carbsGoal,
  int? proteinsGoal,
  int? fatsGoal,
) {
  // Если список пустой или null, возвращаем белый цвет
  if (dishes == null || dishes.isEmpty) {
    return const Color(0xFFFFFFFF); // Белый
  }

  // Проверка целей
  if (kcalGoal == null ||
      carbsGoal == null ||
      proteinsGoal == null ||
      fatsGoal == null) {
    return null;
  }

  // Суммируем значения по КБЖУ
  double totalKcal = 0;
  double totalCarbs = 0;
  double totalProteins = 0;
  double totalFats = 0;

  for (final dish in dishes) {
    totalKcal += dish.kcal?.toDouble() ?? 0;
    totalCarbs += dish.carbs?.toDouble() ?? 0;
    totalProteins += dish.proteins?.toDouble() ?? 0;
    totalFats += dish.fats?.toDouble() ?? 0;
  }

  // Считаем проценты достижения целей по каждому макроэлементу
  double kcalPercent = (totalKcal / kcalGoal) * 100;
  double carbsPercent = (totalCarbs / carbsGoal) * 100;
  double proteinsPercent = (totalProteins / proteinsGoal) * 100;
  double fatsPercent = (totalFats / fatsGoal) * 100;

  // Усредняем процент
  double averagePercent =
      (kcalPercent + carbsPercent + proteinsPercent + fatsPercent) / 4;

  // Определяем цвет по условиям
  if (averagePercent < 50) {
    return const Color(0x19000000); // Прозрачный
  } else if (averagePercent <= 100) {
    return const Color(0xFB7513); // Средний
  } else {
    return const Color(0xFF9F4284); // Превышение
  }
}

int? procent10minus(int? kcalgoal) {
  // need to subtract 10 percent from the number and round, returning int
  if (kcalgoal == null) return null; // Check for null input
  return (kcalgoal * 0.9).round(); // Subtract 10% and round
}

double? gToOz(int? weight) {
  if (weight == null) return null;

  const double gramsPerOunce = 28.349523125;
  final ounces = weight / gramsPerOunce;

  // отбрасываем всё после первой цифры после запятой (3.068… → 3.0)
  return (ounces * 10).floorToDouble() / 10;
}

int? ozToG(double? weight) {
  if (weight == null) return null;

  const double gramsPerOunce = 28.349523125; // 1 oz = 28.349 523 125 g
  final grams = weight * gramsPerOunce;

  // округляем до целого числа
  return grams.round();
}

double? kgToLbs(double? weight) {
  if (weight == null) return null;

  const double poundsPerKg = 2.20462262185;
  final lbs = weight * poundsPerKg;

  return (lbs * 10).roundToDouble() / 10; // округление до 1 знака
}

double? cmToFt(double? height) {
  if (height == null) return null;

  const double cmPerFoot = 30.4761905;
  final ft = height / cmPerFoot;

  return (ft * 100).roundToDouble() / 100;
}

int? indexPlus(int? index) {
  // добавить к index единицу и вернуть
  if (index == null) {
    return null; // Return null if the input index is null
  }
  return index + 1; // Add 1 to the index and return
}

DateTime dateFilterMinusWeek(DateTime currentTime) {
  // функция должна возвращать дату, которая была неделю назад от currentTime
  return currentTime.subtract(Duration(days: 7));
}

String? last7DaysDishesToString(List<AddedDishHistoryRecord>? dishes) {
  if (dishes == null || dishes.isEmpty) {
    return "Записей о приемах пищи нет.";
  }

  final DateFormat formatter =
      DateFormat('dd.MM'); // Еще более короткий формат даты
  final StringBuffer buffer =
      StringBuffer(); // StringBuffer эффективен для сборки строк

  for (var dish in dishes) {
    // Собираем строку вида "17.07:Овсянка(350);"
    buffer.write(
        "${formatter.format(dish.addedDate!)}:${dish.dishName}(${dish.kcal});");
  }

  return buffer.toString();
}

DateTime oneMonthFromNow() {
  final now = DateTime.now();
  // DateTime сам нормализует даты (например, 31 -> в следующий месяц как получится)
  return DateTime(now.year, now.month + 1, now.day, now.hour, now.minute,
      now.second, now.millisecond, now.microsecond);
}

DateTime oneYearFromNow() {
  final now = DateTime.now();
  return DateTime(
    now.year + 1,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
}

String audioconv(String audio) {
  if (audio.isEmpty) {
    return '';
  }

  return audio;
}

String dishString(AddedDishHistoryRecord addedDishHistory) {
  final data = addedDishHistory.snapshotData;

  String sanitize(dynamic v) {
    if (v == null) return '';
    return v
        .toString()
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(';', ',')
        .replaceAll('|', '/')
        .trim();
  }

  String readString(List<String> keys, {String fallback = ''}) {
    for (final k in keys) {
      final value = sanitize(data[k]);
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }
    return fallback;
  }

  int readInt(List<String> keys, {int fallback = 0}) {
    for (final k in keys) {
      final v = data[k];
      if (v is int) return v;
      if (v is num) return v.round();
      if (v is String) {
        final parsed = int.tryParse(v);
        if (parsed != null) return parsed;
      }
    }
    return fallback;
  }

  List<String> readStringList(List<String> keys) {
    for (final k in keys) {
      final raw = data[k];
      if (raw is List) {
        final list = raw
            .map((e) => sanitize(e))
            .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
            .toList();
        if (list.isNotEmpty) return list;
      }
    }
    return <String>[];
  }

  final dishName = addedDishHistory.hasDishName()
      ? sanitize(addedDishHistory.dishName)
      : readString(['dishName', 'dish_name'], fallback: 'Unknown dish');

  final restaurant = addedDishHistory.hasRestaurant()
      ? sanitize(addedDishHistory.restaurant)
      : readString(['restaurant']);

  final portionG = addedDishHistory.hasDishWeight()
      ? addedDishHistory.dishWeight
      : readInt(['dishWeight', 'dish_weight']);

  final kcal = addedDishHistory.hasKcal()
      ? addedDishHistory.kcal
      : readInt(['kcal', 'calories']);

  final proteins = addedDishHistory.hasProteins()
      ? addedDishHistory.proteins
      : readInt(['proteins', 'protein']);

  final fats = addedDishHistory.hasFats()
      ? addedDishHistory.fats
      : readInt(['fats', 'fat']);

  final carbs = addedDishHistory.hasCarbs()
      ? addedDishHistory.carbs
      : readInt(['carbs', 'carbohydrates']);

  final sugar = readInt(['sugar', 'sugars']);
  final fiber = readInt(['fiber', 'fibre']);
  final sodium = readInt(['sodium', 'sodium_mg']);

  final badge = readString(['badge', 'primary_badge_text']);
  final impact = readString(['impact', 'goal_impact_text']);
  final calorieShare =
      readString(['calorieshare', 'daily_calorie_share_text', 'calorie_share']);

  final roastLevel = readString(['roastLevel', 'roast_level']);
  final roastPersona = addedDishHistory.hasRoastPerson()
      ? sanitize(addedDishHistory.roastPerson)
      : readString(['roast_person']);

  final roastText = addedDishHistory.hasRoastText()
      ? sanitize(addedDishHistory.roastText)
      : readString(['roast_text']);

  final image = addedDishHistory.hasImage()
      ? sanitize(addedDishHistory.image)
      : readString(['image', 'dish_photo']);

  final ingredients = addedDishHistory.hasMainIngredients()
      ? addedDishHistory.mainIngredients
          .map((e) => sanitize(e))
          .where((e) => e.isNotEmpty)
          .toList()
      : readStringList(['main_ingredients', 'ingredients']);

  final tips = addedDishHistory.hasHealthTips()
      ? addedDishHistory.healthTips
          .map((e) => sanitize(e))
          .where((e) => e.isNotEmpty)
          .toList()
      : readStringList(['health_tips', 'smart_tweaks']);

  String vitaminsLine = '';
  if (addedDishHistory.hasVitamins() && addedDishHistory.vitamins.isNotEmpty) {
    final parts = addedDishHistory.vitamins
        .map((v) {
          final code = sanitize(v.vitamin);
          final desc = sanitize(v.description);
          if (code.isEmpty && desc.isEmpty) return '';
          return desc.isNotEmpty ? '$code:$desc' : code;
        })
        .where((e) => e.isNotEmpty)
        .toList();
    vitaminsLine = parts.join('|');
  } else {
    final raw = data['vitamins'];
    if (raw is List) {
      final parts = raw
          .map((e) {
            if (e is Map) {
              final code = sanitize(e['vitamin']);
              final desc = sanitize(e['description']);
              if (code.isEmpty && desc.isEmpty) return '';
              return desc.isNotEmpty ? '$code:$desc' : code;
            }
            return sanitize(e);
          })
          .where((e) => e.isNotEmpty)
          .toList();
      vitaminsLine = parts.join('|');
    }
  }

  final addedDateIso =
      addedDishHistory.hasAddedDate() && addedDishHistory.addedDate != null
          ? addedDishHistory.addedDate!.toUtc().toIso8601String()
          : '';

  final resultParts = <String>[
    'name=$dishName',
    'restaurant=$restaurant',
    if (addedDateIso.isNotEmpty) 'added_date_utc=$addedDateIso',
    'portion_g=$portionG',
    'kcal=$kcal',
    'p=$proteins',
    'f=$fats',
    'c=$carbs',
    'sugar_g=$sugar',
    'fiber_g=$fiber',
    'sodium_mg=$sodium',
    'badge=$badge',
    'goal_impact=$impact',
    'calorie_share=$calorieShare',
    'ingredients=${ingredients.join('|')}',
    'smart_tweaks=${tips.join(' || ')}',
    'vitamins=$vitaminsLine',
    'roast_persona=$roastPersona',
    'roast_level=$roastLevel',
    'roast=$roastText',
    'image=$image',
  ];

  return resultParts.join('; ');
}

String buildDishAgentInput(
  String callType,
  String dishName,
  String dishPhoto,
  int dishWeight,
  List<String> ingredients,
  String restaurant,
  String userLevelActivity,
  String userActivityLevel,
  String userGoal,
  int kcalGoal,
  String language,
  String roastLevel,
  String roastPersona,
  int kcal,
  int proteins,
  int fats,
  int carbs,
  List<String> vitaminsAndMinerals,
  String primaryBadgeKey,
  String primaryBadgeText,
  List<String> existingSmartTweaks,
) {
  const allowedCallTypes = {'analyze', 're_roast', 're_roast_harder'};
  final normalizedCallType =
      allowedCallTypes.contains(callType) ? callType : 'analyze';

  final cleanedIngredients =
      ingredients.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  final cleanedSmartTweaks = existingSmartTweaks
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final cleanedVitamins = vitaminsAndMinerals
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  return 'call_type=$normalizedCallType; '
      'dish_name=${dishName.trim()}; '
      'dish_weight=${dishWeight < 0 ? 0 : dishWeight}; '
      'dish_photo=${dishPhoto.trim()}; '
      'restaurant=${restaurant.trim()}; '
      'language=${language.trim()}; '
      'ingredients=${cleanedIngredients.join("|")}; '
      'userActivityLevel=${userActivityLevel.trim()}; '
      'userGoal=${userGoal.trim()}; '
      'roast_level=${roastLevel.trim()}; '
      'roast_persona=${roastPersona.trim()}; '
      'nutrition_snapshot=dish_weight:${dishWeight < 0 ? 0 : dishWeight},'
      'kcal:${kcal < 0 ? 0 : kcal},'
      'proteins:${proteins < 0 ? 0 : proteins},'
      'fats:${fats < 0 ? 0 : fats},'
      'carbs:${carbs < 0 ? 0 : carbs},'
      'main_ingredients:${cleanedIngredients.join("|")},'
      'vitaminsAndMinerals:${cleanedVitamins.join("|")},'
      'primary_badge_key:${primaryBadgeKey.trim()},'
      'primary_badge_text:${primaryBadgeText.trim()}; '
      'existing_smart_tweaks=${cleanedSmartTweaks.join(" || ")}';
}
