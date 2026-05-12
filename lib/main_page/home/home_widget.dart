import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/kcal_bottom_sheet/kcal_bottom_sheet_widget.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/main_page/empty_list_copy/empty_list_copy_widget.dart';
import '/main_page/widgets/dish_history_card.dart';
import '/services/nutrition_summary.dart';
import '/services/user_account_mutations.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'home_calendar.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().selectedDate ??= getCurrentTimestamp;
      final selectedDate = FFAppState().selectedDate ?? getCurrentTimestamp;
      _model.visibleMonth = DateTime(selectedDate.year, selectedDate.month, 1);
      safeSetState(() {});
      await actions.lockOrientation();
      if (revenue_cat.activeEntitlementIds.contains(FFAppConstants.Premium) &&
          currentUserDocument?.dateSubEnd != null &&
          currentUserDocument!.dateSubEnd! < getCurrentTimestamp) {
        await UserAccountMutations.syncRevenueCatSubscription();
      }
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
    final visibleMonth = _model.visibleMonth ??
        DateTime(selectedDate.year, selectedDate.month, 1);
    final collapsedWeekStart = homeCalendarWeekStart(selectedDate);
    final collapsedWeekEnd = homeCalendarWeekEnd(selectedDate);
    final queryStart = _model.isCalendarExpanded
        ? DateTime(visibleMonth.year, visibleMonth.month, 1)
        : collapsedWeekStart;
    final queryEnd = _model.isCalendarExpanded
        ? DateTime(visibleMonth.year, visibleMonth.month + 1, 1)
        : collapsedWeekEnd;

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
                        isGreaterThanOrEqualTo: queryStart,
                      )
                      .where(
                        'addedDate',
                        isLessThan: queryEnd,
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

                  final queriedRecords = snapshot.data!;
                  final records = queriedRecords
                      .where((record) => isSameHomeCalendarDay(
                            record.addedDate,
                            selectedDate,
                          ))
                      .toList();
                  final monthRecords = queriedRecords;
                  final summary =
                      NutritionSummary.fromAddedDishHistoryRecords(records);

                  return AuthUserStreamWidget(
                    builder: (context) {
                      final useOunces = valueOrDefault<bool>(
                          currentUserDocument?.measurementOz, false);
                      return _HomeScrollView(
                        selectedDate: selectedDate,
                        visibleMonth: visibleMonth,
                        isCalendarExpanded: _model.isCalendarExpanded,
                        monthRecords: monthRecords,
                        records: records,
                        summary: summary,
                        useOunces: useOunces,
                        kcalGoal: valueOrDefault<int>(
                          currentUserDocument?.kcalGoal,
                          0,
                        ),
                        proteinsGoal: valueOrDefault<int>(
                          currentUserDocument?.proteinsGoal,
                          0,
                        ),
                        fatsGoal: valueOrDefault<int>(
                          currentUserDocument?.fatsGoal,
                          0,
                        ),
                        carbsGoal: valueOrDefault<int>(
                          currentUserDocument?.carbsGoal,
                          0,
                        ),
                        onToggleCalendar: _toggleCalendarExpanded,
                        onChangeMonth: _changeCalendarMonth,
                        onSelectDate: _selectCalendarDate,
                        onOpenCalorieGoal: _openCalorieGoalSheet,
                      );
                    },
                  );
                },
              ),
            ),
            _HomeTopFade(),
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: _HomeBottomBar(model: _model),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalendarExpanded() {
    _model.isCalendarExpanded = !_model.isCalendarExpanded;
    final selectedDate = FFAppState().selectedDate ?? getCurrentTimestamp;
    _model.visibleMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    safeSetState(() {});
  }

  void _selectCalendarDate(DateTime day) {
    FFAppState().selectedDate = day;
    _model.visibleMonth = DateTime(day.year, day.month, 1);
    safeSetState(() {});
  }

  void _changeCalendarMonth(int delta) {
    final currentMonth = _model.visibleMonth ??
        DateTime(getCurrentTimestamp.year, getCurrentTimestamp.month, 1);
    final nextMonth =
        DateTime(currentMonth.year, currentMonth.month + delta, 1);
    final currentCalendarMonth =
        DateTime(getCurrentTimestamp.year, getCurrentTimestamp.month, 1);
    if (nextMonth.isAfter(currentCalendarMonth)) {
      return;
    }

    _model.visibleMonth = nextMonth;
    FFAppState().selectedDate =
        isSameHomeCalendarMonth(nextMonth, getCurrentTimestamp)
            ? getCurrentTimestamp
            : nextMonth;
    safeSetState(() {});
  }

  Future<void> _openCalorieGoalSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const KcalBottomSheetWidget(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }
}

class _HomeScrollView extends StatelessWidget {
  const _HomeScrollView({
    required this.selectedDate,
    required this.visibleMonth,
    required this.isCalendarExpanded,
    required this.monthRecords,
    required this.records,
    required this.summary,
    required this.useOunces,
    required this.kcalGoal,
    required this.proteinsGoal,
    required this.fatsGoal,
    required this.carbsGoal,
    required this.onToggleCalendar,
    required this.onChangeMonth,
    required this.onSelectDate,
    required this.onOpenCalorieGoal,
  });

  final DateTime selectedDate;
  final DateTime visibleMonth;
  final bool isCalendarExpanded;
  final List<AddedDishHistoryRecord> monthRecords;
  final List<AddedDishHistoryRecord> records;
  final NutritionSummary summary;
  final bool useOunces;
  final int kcalGoal;
  final int proteinsGoal;
  final int fatsGoal;
  final int carbsGoal;
  final VoidCallback onToggleCalendar;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onOpenCalorieGoal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600.0),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6.0, 55.0, 6.0, 0.0),
              sliver: SliverToBoxAdapter(
                child: _HomeHeader(
                  selectedDate: selectedDate,
                  visibleMonth: visibleMonth,
                  isCalendarExpanded: isCalendarExpanded,
                  monthRecords: monthRecords,
                  onChangeMonth: onChangeMonth,
                  onSelectDate: onSelectDate,
                  onToggleCalendar: onToggleCalendar,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6.0, 40.0, 6.0, 0.0),
              sliver: SliverToBoxAdapter(
                child: _DailyGoalSection(
                  summary: summary,
                  useOunces: useOunces,
                  kcalGoal: kcalGoal,
                  proteinsGoal: proteinsGoal,
                  fatsGoal: fatsGoal,
                  carbsGoal: carbsGoal,
                  onOpenCalorieGoal: onOpenCalorieGoal,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40.0)),
            if (records.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: EmptyListCopyWidget(
                    sdf: 'Your roasted friends & dishes appear here',
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
                      final record = records[index ~/ 2];
                      return DishHistoryCard(
                        key: ValueKey(record.reference.path),
                        record: record,
                        useOunces: useOunces,
                      );
                    },
                    childCount: records.length * 2 - 1,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 150.0)),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.selectedDate,
    required this.visibleMonth,
    required this.isCalendarExpanded,
    required this.monthRecords,
    required this.onChangeMonth,
    required this.onSelectDate,
    required this.onToggleCalendar,
  });

  final DateTime selectedDate;
  final DateTime visibleMonth;
  final bool isCalendarExpanded;
  final List<AddedDishHistoryRecord> monthRecords;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onToggleCalendar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Daily Goal',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 21.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        HomeCalendarCard(
          month: visibleMonth,
          selectedDate: selectedDate,
          monthRecords: monthRecords,
          isExpanded: isCalendarExpanded,
          onChangeMonth: onChangeMonth,
          onSelectDate: onSelectDate,
          onToggleExpanded: onToggleCalendar,
        ),
      ],
    );
  }
}

class _DailyGoalSection extends StatelessWidget {
  const _DailyGoalSection({
    required this.summary,
    required this.useOunces,
    required this.kcalGoal,
    required this.proteinsGoal,
    required this.fatsGoal,
    required this.carbsGoal,
    required this.onOpenCalorieGoal,
  });

  final NutritionSummary summary;
  final bool useOunces;
  final int kcalGoal;
  final int proteinsGoal;
  final int fatsGoal;
  final int carbsGoal;
  final VoidCallback onOpenCalorieGoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KcalGoalCard(
          value: summary.kcal,
          goal: kcalGoal,
          onTap: onOpenCalorieGoal,
        ),
        const SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MacroGoalCard(
                label: 'Proteins',
                value: summary.proteins,
                goal: proteinsGoal,
                color: const Color(0xFF49928C),
                useOunces: useOunces,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: _MacroGoalCard(
                label: 'Fats',
                value: summary.fats,
                goal: fatsGoal,
                color: const Color(0xFFF19656),
                useOunces: useOunces,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: _MacroGoalCard(
                label: 'Carbs',
                value: summary.carbs,
                goal: carbsGoal,
                color: const Color(0xFF9F4284),
                useOunces: useOunces,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KcalGoalCard extends StatelessWidget {
  const _KcalGoalCard({
    required this.value,
    required this.goal,
    required this.onTap,
  });

  final int value;
  final int goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = NutritionSummary.progress(value: value, goal: goal) ?? 0.0;
    final remaining = goal - value;
    final helperText = goal <= 0
        ? 'Set a calorie goal'
        : remaining >= 0
            ? '$remaining kcal left'
            : '${remaining.abs()} kcal over';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calories',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Flexible(
                      child: Text(
                        helperText,
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro',
                              color: remaining < 0
                                  ? const Color(0xFFF19656)
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  goal > 0 ? '$value / $goal kcal' : '$value kcal',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        fontSize: 30.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 14.0),
                _ProgressBar(
                  progress: progress,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroGoalCard extends StatelessWidget {
  const _MacroGoalCard({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
    required this.useOunces,
  });

  final String label;
  final int value;
  final int goal;
  final Color color;
  final bool useOunces;

  @override
  Widget build(BuildContext context) {
    final progress = NutritionSummary.progress(value: value, goal: goal) ?? 0.0;
    final valueText = NutritionSummary.formatGrams(value, useOunces: useOunces);
    final goalText = goal > 0
        ? NutritionSummary.formatGrams(goal, useOunces: useOunces)
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              valueText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (goalText != null)
              Text(
                goalText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
            const SizedBox(height: 10.0),
            _ProgressBar(
              progress: progress,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.0),
      child: LinearProgressIndicator(
        minHeight: 8.0,
        value: progress,
        backgroundColor: const Color(0xFFE5E7EB),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _HomeBottomBar extends StatelessWidget {
  const _HomeBottomBar({required this.model});

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: FFButtonWidget(
            onPressed: () async {
              context.pushNamed(
                DishAddAIWidget.routeName,
                extra: <String, dynamic>{
                  '__transition_info__': TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration.zero,
                  ),
                },
              );
            },
            text: 'Add New Dish or Friend to Roast',
            icon: const Icon(
              FFIcons.kplllllus,
              size: 24.0,
            ),
            options: FFButtonOptions(
              width: double.infinity,
              height: 50.0,
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconColor: FlutterFlowTheme.of(context).secondaryBackground,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'SF Pro',
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(12.0),
            ),
            showLoadingIndicator: false,
          ),
        ),
        wrapWithModel(
          model: model.navBarModel,
          updateCallback: () {},
          child: const NavBarWidget(
            activePage: 'Home',
          ),
        ),
      ],
    );
  }
}

class _HomeTopFade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: 55.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF2F2F7),
              Color(0xF4F2F2F7),
              Color(0x00F2F2F7),
            ],
            stops: [0.0, 0.7, 1.0],
            begin: AlignmentDirectional(0.0, -1.0),
            end: AlignmentDirectional(0, 1.0),
          ),
        ),
      ),
    );
  }
}
