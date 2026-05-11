// Automatic FlutterFlow imports
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/cupertino.dart';

class UniversalPicker extends StatefulWidget {
  const UniversalPicker({
    Key? key,
    this.width,
    this.height,

    /// Список опций для отображения (то, что увидит пользователь).
    required this.options,

    /// Предустановленное значение (должно входить в options). Если null — берём первый элемент.
    this.initialValue,

    /// Экшен/коллбэк при выборе. Вернёт выбранную строку из options.
    /// В FlutterFlow можно привязать Action к этому коллбэку.
    this.onSelected,

    /// Высота одного элемента в пикере.
    this.itemExtent = 36.0,

    /// Кастомизация текста (необязательно).
    this.textStyle,
    this.backgroundColor = const Color(0xFFF2EEE9),
    this.borderRadius = 13.0,

    /// Показывать ли кнопку Done
    this.showDoneButton = true,

    /// Текст кнопки Done
    this.doneButtonText = 'Done',
  }) : super(key: key);

  final double? width;
  final double? height;

  final List<String> options;
  final String? initialValue;

  /// Рекомендуемый тип для FF Action: Future Function(String)? onSelected
  final Future<void> Function(String)? onSelected;

  final double itemExtent;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double borderRadius;

  final bool showDoneButton;
  final String doneButtonText;

  @override
  State<UniversalPicker> createState() => _UniversalPickerState();
}

class _UniversalPickerState extends State<UniversalPicker> {
  late int _selectedIndex;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _resolveInitialIndex(widget.options, widget.initialValue);
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(covariant UniversalPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Если список опций или initialValue поменялись — обновим индекс и прокрутку.
    if (oldWidget.options != widget.options ||
        oldWidget.initialValue != widget.initialValue) {
      final newIndex =
          _resolveInitialIndex(widget.options, widget.initialValue);
      if (newIndex != _selectedIndex) {
        _selectedIndex = newIndex;
        // Без анимации, чтобы не дёргалось при hot-reload/обновлении стейта
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpToItem(_selectedIndex);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _resolveInitialIndex(List<String> list, String? initial) {
    if (list.isEmpty) return 0;
    if (initial == null) return 0;
    final idx = list.indexOf(initial);
    return idx >= 0 ? idx : 0;
    // Если нужно — можно расширить до case-insensitive поиска.
  }

  Future<void> _handleDonePressed() async {
    final displayList =
        widget.options.isEmpty ? const <String>['—'] : widget.options;
    final value = displayList[_selectedIndex];

    // Запускаем экшен/коллбэк и передаём выбранную строку.
    try {
      await widget.onSelected?.call(value);
    } catch (e, st) {
      // Не падаем UI из-за экшена
      debugPrint('UniversalPicker onSelected error: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Защита от пустого списка: покажем один элемент "—"
    final displayList =
        widget.options.isEmpty ? const <String>['—'] : widget.options;

    final effectiveTextStyle = widget.textStyle ??
        const TextStyle(
          fontSize: 16,
          height: 1.2,
          overflow: TextOverflow.ellipsis,
        );

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Column(
        children: [
          Expanded(
            child: CupertinoTheme(
              data: const CupertinoThemeData(brightness: Brightness.light),
              child: CupertinoPicker(
                itemExtent: widget.itemExtent,
                scrollController: _scrollController,
                onSelectedItemChanged: (int newIndex) {
                  setState(() => _selectedIndex = newIndex);
                },
                children: displayList
                    .map(
                      (item) => Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: effectiveTextStyle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          if (widget.showDoneButton)
            CupertinoButton(
              child: Text(widget.doneButtonText),
              onPressed: _handleDonePressed,
            ),
        ],
      ),
    );
  }
}
