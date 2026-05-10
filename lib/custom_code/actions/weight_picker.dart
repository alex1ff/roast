// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/cupertino.dart'; // для CupertinoPicker

/// Показывает снизу picker для выбора веса.
/// [kg]    — true → кг (шаг 0.1), false → фунты (шаг 0.1)
/// [value] — исходное значение (если null — ставим середину диапазона)
/// [appLanguage] — "Russian" / "English" (может быть null → возьмём "English")
Future<double?> weightPicker(
  BuildContext context,
  bool kg,
  double? value,
  String? appLanguage, // <-- позиционный, Nullable
) async {
  // 0) Локализация
  final String lang = (appLanguage ?? 'English').toLowerCase();
  final bool isRu = lang.startsWith('ru'); // "Russian", "ru", "ru-RU" и т.п.

  final String unitKg = isRu ? 'кг' : 'kg';
  final String unitLb = isRu ? 'фнт' : 'lb'; // оставь 'lb' для EN
  final String doneText = isRu ? 'Готово' : 'Done';

  // 1) Диапазоны и шаг
  const double minKg = 20.0, maxKg = 200.0, stepKg = 0.1;
  const double minLb = 44.0, maxLb = 440.0, stepLb = 0.1;

  final List<double> options = kg
      ? List.generate(
          (((maxKg - minKg) / stepKg).round() + 1),
          (i) => double.parse((minKg + i * stepKg).toStringAsFixed(1)),
        )
      : List.generate(
          (((maxLb - minLb) / stepLb).round() + 1),
          (i) => double.parse((minLb + i * stepLb).toStringAsFixed(1)),
        );

  // 2) Стартовый индекс
  final int initialIndex = () {
    if (value == null) return (options.length / 2).floor();
    final formatted = double.parse(value.toStringAsFixed(1));
    final idx = options.indexOf(formatted);
    return idx >= 0 ? idx : (options.length / 2).floor();
  }();

  // 3) UI
  final selected = await showCupertinoModalPopup<double>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      double current = options[initialIndex];
      return Material(
        color: Colors.transparent,
        child: Container(
          height: 260,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(ctx).secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32,
                  onSelectedItemChanged: (i) => current = options[i],
                  children: options
                      .map((e) => Center(
                            child: Text(
                              kg
                                  ? '${e.toStringAsFixed(1)} $unitKg'
                                  : '${e.toStringAsFixed(1)} $unitLb',
                              style: FlutterFlowTheme.of(ctx).bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ),
              CupertinoButton(
                child: Text(doneText),
                onPressed: () => Navigator.of(ctx).pop(current),
              ),
            ],
          ),
        ),
      );
    },
  );

  return selected; // null, если закрыли свайпом
}
