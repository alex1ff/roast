import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class HomeCalendarCard extends StatelessWidget {
  const HomeCalendarCard({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.monthRecords,
    required this.isExpanded,
    required this.onChangeMonth,
    required this.onSelectDate,
    required this.onToggleExpanded,
  });

  final DateTime month;
  final DateTime selectedDate;
  final List<AddedDishHistoryRecord> monthRecords;
  final bool isExpanded;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final days =
        isExpanded ? _calendarDays(month) : _selectedWeekDays(selectedDate);
    final daySummaries = _calendarDaySummaries(monthRecords);
    final canGoNext = DateTime(month.year, month.month, 1).isBefore(
      DateTime(getCurrentTimestamp.year, getCurrentTimestamp.month, 1),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => onChangeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                  color: FlutterFlowTheme.of(context).primaryText,
                  tooltip: 'Previous month',
                ),
                Expanded(
                  child: Text(
                    dateTimeFormat(
                      'yMMMM',
                      month,
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'SF Pro',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: canGoNext ? () => onChangeMonth(1) : null,
                  icon: const Icon(Icons.chevron_right),
                  color: canGoNext
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).secondaryText,
                  tooltip: 'Next month',
                ),
                IconButton(
                  onPressed: onToggleExpanded,
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.calendar_month,
                  ),
                  color: FlutterFlowTheme.of(context).primary,
                  tooltip: isExpanded ? 'Collapse calendar' : 'Expand calendar',
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            if (isExpanded) ...[
              const _WeekdayHeader(),
              const SizedBox(height: 10.0),
            ],
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                if (_isPlaceholderDay(day)) {
                  return const SizedBox.shrink();
                }
                final summary = daySummaries[homeCalendarDayKey(day)] ??
                    const _CalendarDaySummary(count: 0, kcal: 0);
                return _CalendarDayButton(
                  day: day,
                  isSelected: isSameHomeCalendarDay(day, selectedDate),
                  hasRecords: summary.count > 0,
                  kcal: summary.kcal,
                  showWeekday: !isExpanded,
                  onTap: () => onSelectDate(day),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<DateTime> _calendarDays(DateTime month) {
  final firstDay = DateTime(month.year, month.month, 1);
  final lastDay = DateTime(month.year, month.month + 1, 0);
  final days = <DateTime>[];
  for (var i = 0; i < firstDay.weekday - 1; i++) {
    days.add(DateTime(1900, 1, 1));
  }
  for (var day = firstDay;
      !day.isAfter(lastDay);
      day = day.add(const Duration(days: 1))) {
    days.add(day);
  }
  return days;
}

List<DateTime> _selectedWeekDays(DateTime selectedDate) {
  final monday =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
          .subtract(Duration(days: selectedDate.weekday - 1));
  return List.generate(7, (index) => monday.add(Duration(days: index)));
}

bool _isPlaceholderDay(DateTime day) => day.year == 1900;

bool isSameHomeCalendarDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameHomeCalendarMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

DateTime homeCalendarDayKey(DateTime date) =>
    DateTime(date.year, date.month, date.day);

Map<DateTime, _CalendarDaySummary> _calendarDaySummaries(
  List<AddedDishHistoryRecord> records,
) {
  final summaries = <DateTime, _CalendarDaySummary>{};
  for (final record in records) {
    final addedDate = record.addedDate;
    if (addedDate == null) {
      continue;
    }
    final key = homeCalendarDayKey(addedDate);
    final current =
        summaries[key] ?? const _CalendarDaySummary(count: 0, kcal: 0);
    summaries[key] = _CalendarDaySummary(
      count: current.count + 1,
      kcal: current.kcal + record.kcal,
    );
  }
  return summaries;
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({
    required this.day,
    required this.isSelected,
    required this.hasRecords,
    required this.kcal,
    required this.showWeekday,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool hasRecords;
  final int kcal;
  final bool showWeekday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? FlutterFlowTheme.of(context).primary
        : hasRecords
            ? const Color(0xFFE8F4F1)
            : const Color(0xFFF2F2F7);
    final foreground =
        isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText;

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: hasRecords && !isSelected
                ? const Color(0xFF49928C)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showWeekday)
                Text(
                  dateTimeFormat(
                    'E',
                    day,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        color: isSelected
                            ? Colors.white70
                            : FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              Text(
                day.day.toString(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      color: foreground,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (kcal > 0)
                Text(
                  kcal > 999 ? '${(kcal / 1000).toStringAsFixed(1)}k' : '$kcal',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        color: isSelected
                            ? Colors.white70
                            : FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarDaySummary {
  const _CalendarDaySummary({
    required this.count,
    required this.kcal,
  });

  final int count;
  final int kcal;
}
