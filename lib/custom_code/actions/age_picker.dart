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

import 'package:flutter/cupertino.dart';

/// Показывает снизу picker для выбора возраста.
/// [value] — исходное значение возраста (если null — ставим 25)
/// [appLanguage] — "Russian" / "English" (может быть null → берём "English")
Future<int?> agePicker(
  BuildContext context,
  int? value,
  String? appLanguage,
) async {
  // 0) Локализация
  final String lang = (appLanguage ?? 'English').toLowerCase();
  final bool isRu = lang.startsWith('ru');

  final String unit = isRu ? 'лет' : 'years';
  final String doneText = isRu ? 'Готово' : 'Done';

  // 1) Диапазон значений
  const int minAge = 1, maxAge = 120;
  final List<int> options = List.generate(
    maxAge - minAge + 1,
    (i) => minAge + i,
  );

  // 2) Начальный индекс
  final int initialIndex = () {
    if (value == null || value < minAge || value > maxAge) return 24; // age 25
    final idx = options.indexOf(value);
    return idx >= 0 ? idx : 24;
  }();

  // 3) UI
  final selected = await showCupertinoModalPopup<int>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      int current = options[initialIndex];
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
                              '$e $unit',
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
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
