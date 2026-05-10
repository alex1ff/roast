// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

// DO NOT REMOVE OR MODIFY THE CODE ABOVE

// Horizontal Calendar Custom Widget

class HorizontalCalendar extends StatefulWidget {
  final DateTime currentTimee;
  final double width;
  final double height;

  const HorizontalCalendar({
    Key? key,
    required this.currentTimee,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late DateTime selectedDate;
  late DateTime startOfWeek;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = FFAppState().selectedDate ?? widget.currentTimee;
    startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday % 7),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void updateSelectedDate(DateTime date) {
    final appStateDate = FFAppState().selectedDate ?? widget.currentTimee;
    if (isSameDate(date, appStateDate)) return;
    FFAppState().update(() {
      FFAppState().selectedDate = date;
    });
  }

  void shiftWeek(int offset) {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7 * offset));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    final index = selectedDate.difference(startOfWeek).inDays;
    final offset = (index * 52.0) - (widget.width / 2) + 26.0;
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final days =
        List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    final appStateDate = FFAppState().selectedDate ?? widget.currentTimee;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => shiftWeek(-1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_left, color: Colors.black87, size: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = isSameDate(day, appStateDate);

                return GestureDetector(
                  onTap: () => updateSelectedDate(day),
                  child: Container(
                    width: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E('en_US').format(day).substring(0, 2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFFFFFFFF) : null,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFB7513)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => shiftWeek(1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_right, color: Colors.black87, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
