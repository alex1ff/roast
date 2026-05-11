import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main_page/empty_list_copy/empty_list_copy_widget.dart';
import '/services/nutrition_summary.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'statistics_model.dart';
export 'statistics_model.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  static String routeName = 'Statistics';
  static String routePath = '/statistics';

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  late StatisticsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatisticsModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final selectedDate = FFAppState().selectedDate ?? getCurrentTimestamp;
      _model.month = DateTime(selectedDate.year, selectedDate.month, 1);
      FFAppState().selectedDate ??= selectedDate;
      safeSetState(() {});
      unawaited(actions.lockOrientation());
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final selectedDate = FFAppState().selectedDate ?? getCurrentTimestamp;
    final statisticsMonth =
        _model.month ?? DateTime(selectedDate.year, selectedDate.month, 1);
    final statisticsMonthStart =
        DateTime(statisticsMonth.year, statisticsMonth.month, 1);
    final statisticsMonthEnd =
        DateTime(statisticsMonth.year, statisticsMonth.month + 1, 1);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF2F2F7),
        body: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, -1.0),
              child: StreamBuilder<List<AddedDishHistoryRecord>>(
                stream: queryAddedDishHistoryRecord(
                  queryBuilder: (records) => records
                      .where(
                        'user',
                        isEqualTo: currentUserReference,
                      )
                      .where(
                        'addedDate',
                        isGreaterThanOrEqualTo: statisticsMonthStart,
                      )
                      .where(
                        'addedDate',
                        isLessThan: statisticsMonthEnd,
                      )
                      .orderBy('addedDate', descending: true),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }

                  final monthRecords = snapshot.data!;
                  final selectedDayRecords = monthRecords
                      .where((record) =>
                          _isSameDay(record.addedDate, selectedDate))
                      .toList();

                  return AuthUserStreamWidget(
                    builder: (context) {
                      final useOunces = valueOrDefault<bool>(
                          currentUserDocument?.measurementOz, false);
                      return _StatisticsScrollView(
                        month: statisticsMonth,
                        selectedDate: selectedDate,
                        monthRecords: monthRecords,
                        selectedDayRecords: selectedDayRecords,
                        useOunces: useOunces,
                        onChangeMonth: _changeMonth,
                        onSelectDate: _selectDate,
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: wrapWithModel(
                model: _model.navBarModel,
                updateCallback: () => safeSetState(() {}),
                child: const NavBarWidget(
                  activePage: 'Stats',
                ),
              ),
            ),
            _StatisticsHeader(),
          ],
        ),
      ),
    );
  }

  void _selectDate(DateTime day) {
    if (_isPlaceholderDay(day)) {
      return;
    }
    FFAppState().selectedDate = day;
    _model.month = DateTime(day.year, day.month, 1);
    safeSetState(() {});
  }

  void _changeMonth(int delta) {
    final currentMonth = _model.month ?? getCurrentTimestamp;
    final nextMonth =
        DateTime(currentMonth.year, currentMonth.month + delta, 1);
    final currentCalendarMonth =
        DateTime(getCurrentTimestamp.year, getCurrentTimestamp.month, 1);
    if (nextMonth.isAfter(currentCalendarMonth)) {
      return;
    }

    _model.month = nextMonth;
    FFAppState().selectedDate = _isSameMonth(nextMonth, getCurrentTimestamp)
        ? getCurrentTimestamp
        : nextMonth;
    safeSetState(() {});
  }
}

class _StatisticsScrollView extends StatelessWidget {
  const _StatisticsScrollView({
    required this.month,
    required this.selectedDate,
    required this.monthRecords,
    required this.selectedDayRecords,
    required this.useOunces,
    required this.onChangeMonth,
    required this.onSelectDate,
  });

  final DateTime month;
  final DateTime selectedDate;
  final List<AddedDishHistoryRecord> monthRecords;
  final List<AddedDishHistoryRecord> selectedDayRecords;
  final bool useOunces;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600.0),
        child: CustomScrollView(
          primary: true,
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 100.0)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              sliver: SliverToBoxAdapter(
                child: _MonthCalendarCard(
                  month: month,
                  selectedDate: selectedDate,
                  monthRecords: monthRecords,
                  onChangeMonth: onChangeMonth,
                  onSelectDate: onSelectDate,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            if (selectedDayRecords.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: EmptyListCopyWidget(
                    sdf: 'Your dishes will appear here.',
                    sdsd: 'Nothing here yet',
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 6.0);
                      }
                      final record = selectedDayRecords[index ~/ 2];
                      return _StatisticsDishCard(
                        key: ValueKey(record.reference.path),
                        record: record,
                        useOunces: useOunces,
                      );
                    },
                    childCount: selectedDayRecords.length * 2 - 1,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 163.0)),
          ],
        ),
      ),
    );
  }
}

class _MonthCalendarCard extends StatelessWidget {
  const _MonthCalendarCard({
    required this.month,
    required this.selectedDate,
    required this.monthRecords,
    required this.onChangeMonth,
    required this.onSelectDate,
  });

  final DateTime month;
  final DateTime selectedDate;
  final List<AddedDishHistoryRecord> monthRecords;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final days = _calendarDays(month);
    final canGoNext = DateTime(month.year, month.month, 1).isBefore(
        DateTime(getCurrentTimestamp.year, getCurrentTimestamp.month, 1));

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
                Text(
                  dateTimeFormat(
                    'yMMMM',
                    month,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'SF Pro',
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
            const SizedBox(height: 14.0),
            const _WeekdayHeader(),
            const SizedBox(height: 10.0),
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
                final dayRecords = monthRecords
                    .where((record) => _isSameDay(record.addedDate, day))
                    .toList();
                return _CalendarDayButton(
                  day: day,
                  isSelected: _isSameDay(day, selectedDate),
                  hasRecords: dayRecords.isNotEmpty,
                  kcal: dayRecords.fold<int>(
                      0, (sum, record) => sum + record.kcal),
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
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool hasRecords;
  final int kcal;
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

class _StatisticsDishCard extends StatelessWidget {
  const _StatisticsDishCard({
    super.key,
    required this.record,
    required this.useOunces,
  });

  final AddedDishHistoryRecord record;
  final bool useOunces;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {
        context.pushNamed(
          DishInfoWidget.routeName,
          queryParameters: {
            'dish': serializeParam(
              record.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: useOunces ? 104.0 : 88.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: valueOrDefault<String>(
                      record.image,
                      'https://firebasestorage.googleapis.com/v0/b/eat-out-a-i-h2yogm.firebasestorage.app/o/AppImages%2FZaglushkaDish.png?alt=media&token=removed',
                    ),
                    memCacheWidth: 160,
                    memCacheHeight: 220,
                    maxWidthDiskCache: 320,
                    maxHeightDiskCache: 440,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    width: 80.0,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 80.0,
                      color: const Color(0xFFE5E7EB),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF8E8E93),
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 2.0, 0.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.dishName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          children: [
                            Text(
                              NutritionSummary.formatGrams(
                                record.dishWeight,
                                useOunces: useOunces,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              '${record.kcal} kcal',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ].divide(const SizedBox(width: 12.0)),
                        ),
                        const SizedBox(height: 4.0),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children: [
                            _MacroPill(
                              color: const Color(0xFF49928C),
                              value: NutritionSummary.formatGrams(
                                record.proteins,
                                useOunces: useOunces,
                              ),
                            ),
                            _MacroPill(
                              color: const Color(0xFFF19656),
                              value: NutritionSummary.formatGrams(
                                record.fats,
                                useOunces: useOunces,
                              ),
                            ),
                            _MacroPill(
                              color: const Color(0xFF9F4284),
                              value: NutritionSummary.formatGrams(
                                record.carbs,
                                useOunces: useOunces,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.color,
    required this.value,
  });

  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          value,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}

class _StatisticsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FlutterFlowTheme.of(context).secondaryBackground,
              const Color(0xEFF2F2F7),
              const Color(0x00F2F2F7),
            ],
            stops: const [0.0, 0.8, 1.0],
            begin: const AlignmentDirectional(0.0, -1.0),
            end: const AlignmentDirectional(0, 1.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 55.0, 12.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Statistics',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      fontSize: 21.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
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

bool _isPlaceholderDay(DateTime day) => day.year == 1900;

bool _isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;
