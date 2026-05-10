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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:flutter/cupertino.dart';

/// Показывает снизу picker для выбора роста.
/// [cm]   — true → сантиметры (шаг 0.5), false → футы (шаг 0.01)
/// [value]— исходное значение (если null — ставим середину диапазона)
/// [appLanguage] — "Russian" / "English" (может быть null → возьмём "English")
Future<double?> heightPicker(
  BuildContext context,
  bool cm,
  double? value,
  String? appLanguage, // <-- позиционный параметр, можно сделать Nullable в FF
) async {
  // 0) Локализация
  final String lang = (appLanguage ?? 'English').toLowerCase();
  final bool isRu = lang.startsWith('ru'); // "Russian", "ru", "ru-RU" и т.п.

  final String unitCm = isRu ? 'см' : 'cm';
  final String unitFt = isRu ? 'фт' : 'ft';
  final String doneText = isRu ? 'Готово' : 'Done';

  // 1) Диапазоны
  const double minCm = 50.0, maxCm = 250.0, stepCm = 0.5;
  const double minFt = 3.0, maxFt = 8.0, stepFt = 0.01;

  final List<double> options = cm
      ? List.generate(
          (((maxCm - minCm) / stepCm).round() + 1),
          (i) => minCm + i * stepCm,
        )
      : List.generate(
          (((maxFt - minFt) / stepFt).round() + 1),
          (i) => double.parse((minFt + i * stepFt).toStringAsFixed(2)),
        );

  // 2) Начальный индекс
  final int initialIndex = () {
    if (value == null) return (options.length / 2).floor();
    final formatted = double.parse(
      cm ? value.toStringAsFixed(1) : value.toStringAsFixed(2),
    );
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
                              cm
                                  ? '${e.toStringAsFixed(1)} $unitCm'
                                  : '${e.toStringAsFixed(2)} $unitFt',
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

  return selected; // может быть null, если закрыли свайпом
}
