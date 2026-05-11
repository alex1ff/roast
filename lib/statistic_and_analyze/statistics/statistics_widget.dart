import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main_page/empty_list_copy/empty_list_copy_widget.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/services/nutrition_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.month = getCurrentTimestamp;
      safeSetState(() {});
      unawaited(
        () async {
          await actions.lockOrientation();
        }(),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final statisticsMonth = _model.month ?? getCurrentTimestamp;
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
        backgroundColor: Color(0xFFF2F2F7),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: StreamBuilder<List<AddedDishHistoryRecord>>(
                  stream: queryAddedDishHistoryRecord(
                    queryBuilder: (addedDishHistoryRecord) =>
                        addedDishHistoryRecord
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
                    // Customize what your widget looks like when it's loading.
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
                    List<AddedDishHistoryRecord>
                        containerAddedDishHistoryRecordList = snapshot.data!;

                    return Container(
                      constraints: BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            icon: Icon(
                                              FFIcons.karrrow,
                                              color: dateTimeFormat(
                                                        "M/y",
                                                        _model.month,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ) ==
                                                      dateTimeFormat(
                                                        "M/y",
                                                        getCurrentTimestamp,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )
                                                  ? Color(0x80000000)
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 16.0,
                                            ),
                                            onPressed: () async {
                                              _model.month = functions.setMonth(
                                                  _model.month!, false);
                                              safeSetState(() {});
                                            },
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  dateTimeFormat(
                                                    "yMMMM",
                                                    _model.month,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ].divide(SizedBox(height: 5.0)),
                                            ),
                                          ),
                                          FlutterFlowIconButton(
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            icon: Icon(
                                              FFIcons.kfdsfedf,
                                              color: dateTimeFormat(
                                                        "M/y",
                                                        _model.month,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      ) ==
                                                      dateTimeFormat(
                                                        "M/y",
                                                        getCurrentTimestamp,
                                                        locale:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .languageCode,
                                                      )
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 16.0,
                                            ),
                                            onPressed: () async {
                                              if (dateTimeFormat(
                                                    "M/y",
                                                    _model.month,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ) !=
                                                  dateTimeFormat(
                                                    "M/y",
                                                    getCurrentTimestamp,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  )) {
                                                _model.month =
                                                    functions.setMonth(
                                                        _model.month!, true);
                                                safeSetState(() {});
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 16.0, 0.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final allDays = functions
                                                .getAllDaysOfMonth(
                                                    _model.month!)
                                                .toList();

                                            return MasonryGridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 7,
                                              ),
                                              crossAxisSpacing: 14.0,
                                              mainAxisSpacing: 10.0,
                                              itemCount: allDays.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (context, allDaysIndex) {
                                                final allDaysItem =
                                                    allDays[allDaysIndex];
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (allDaysIndex <= 6)
                                                      Text(
                                                        () {
                                                          if (allDaysIndex ==
                                                              0) {
                                                            return 'Mo';
                                                          } else if (allDaysIndex ==
                                                              1) {
                                                            return 'Tu';
                                                          } else if (allDaysIndex ==
                                                              2) {
                                                            return 'We';
                                                          } else if (allDaysIndex ==
                                                              3) {
                                                            return 'Th';
                                                          } else if (allDaysIndex ==
                                                              4) {
                                                            return 'Fr';
                                                          } else if (allDaysIndex ==
                                                              5) {
                                                            return 'Sa';
                                                          } else if (allDaysIndex ==
                                                              6) {
                                                            return 'Su';
                                                          } else {
                                                            return '';
                                                          }
                                                        }(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .override(
                                                                  font:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'SF Pro',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          FFAppState()
                                                                  .selectedDate =
                                                              allDaysItem;
                                                          safeSetState(() {});
                                                        },
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            AuthUserStreamWidget(
                                                              builder:
                                                                  (context) =>
                                                                      Container(
                                                                width: 30.0,
                                                                height: 30.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: () {
                                                                    if (dateTimeFormat(
                                                                          "yMd",
                                                                          allDaysItem,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ) ==
                                                                        dateTimeFormat(
                                                                          "yMd",
                                                                          getCurrentTimestamp,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        )) {
                                                                      return Color(
                                                                          0x989F4284);
                                                                    } else if (dateTimeFormat(
                                                                          "yMd",
                                                                          allDaysItem,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ) ==
                                                                        dateTimeFormat(
                                                                          "yMd",
                                                                          FFAppState()
                                                                              .selectedDate,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        )) {
                                                                      return FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText;
                                                                    } else {
                                                                      return Color(
                                                                          0x00000000);
                                                                    }
                                                                  }(),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: valueOrDefault<
                                                                        Color>(
                                                                      functions.colorObvodkiVCalendare(
                                                                          containerAddedDishHistoryRecordList
                                                                              .where((e) =>
                                                                                  dateTimeFormat(
                                                                                    "Md",
                                                                                    e.addedDate,
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ) ==
                                                                                  dateTimeFormat(
                                                                                    "Md",
                                                                                    allDaysItem,
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ))
                                                                              .toList(),
                                                                          valueOrDefault(currentUserDocument?.kcalGoal, 0),
                                                                          valueOrDefault(currentUserDocument?.carbsGoal, 0),
                                                                          valueOrDefault(currentUserDocument?.proteinsGoal, 0),
                                                                          valueOrDefault(currentUserDocument?.fatsGoal, 0)),
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                    ),
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child: Opacity(
                                                                  opacity: dateTimeFormat(
                                                                            "yyyy",
                                                                            allDaysItem,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ) !=
                                                                          '1900'
                                                                      ? 1.0
                                                                      : 0.0,
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      dateTimeFormat(
                                                                        "d",
                                                                        allDaysItem,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'SF Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Opacity(
                                                              opacity: functions
                                                                          .sumKcal(containerAddedDishHistoryRecordList
                                                                              .where((e) =>
                                                                                  dateTimeFormat(
                                                                                    "Md",
                                                                                    e.addedDate,
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ) ==
                                                                                  dateTimeFormat(
                                                                                    "Md",
                                                                                    allDaysItem,
                                                                                    locale: FFLocalizations.of(context).languageCode,
                                                                                  ))
                                                                              .toList())
                                                                          .toString() !=
                                                                      '0'
                                                                  ? 1.0
                                                                  : 0.0,
                                                              child: Text(
                                                                functions
                                                                    .sumKcal(containerAddedDishHistoryRecordList
                                                                        .where((e) =>
                                                                            dateTimeFormat(
                                                                              "Md",
                                                                              e.addedDate,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ) ==
                                                                            dateTimeFormat(
                                                                              "Md",
                                                                              allDaysItem,
                                                                              locale: FFLocalizations.of(context).languageCode,
                                                                            ))
                                                                        .toList())
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'SF Pro',
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Builder(
                                  builder: (context) {
                                    final dailyDishList =
                                        containerAddedDishHistoryRecordList
                                            .where((e) =>
                                                dateTimeFormat(
                                                  "d/M/y",
                                                  e.addedDate,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ) ==
                                                dateTimeFormat(
                                                  "d/M/y",
                                                  FFAppState().selectedDate,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ))
                                            .toList();
                                    if (dailyDishList.isEmpty) {
                                      return Center(
                                        child: EmptyListCopyWidget(
                                          sdf: 'Your dishes will appear here.',
                                          sdsd: 'Nothing here yet',
                                        ),
                                      );
                                    }

                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: dailyDishList.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 6.0),
                                      itemBuilder:
                                          (context, dailyDishListIndex) {
                                        final dailyDishListItem =
                                            dailyDishList[dailyDishListIndex];
                                        return Visibility(
                                          visible: dateTimeFormat(
                                                "yMd",
                                                dailyDishListItem.addedDate,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ) ==
                                              dateTimeFormat(
                                                "yMd",
                                                FFAppState().selectedDate,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              height: valueOrDefault<double>(
                                                valueOrDefault<bool>(
                                                        currentUserDocument
                                                            ?.measurementOz,
                                                        false)
                                                    ? 104.0
                                                    : 88.0,
                                                88.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    context.pushNamed(
                                                      DishInfoWidget.routeName,
                                                      queryParameters: {
                                                        'dish': serializeParam(
                                                          dailyDishListItem
                                                              .reference,
                                                          ParamType
                                                              .DocumentReference,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            dailyDishListItem
                                                                .image,
                                                            'https://firebasestorage.googleapis.com/v0/b/eat-out-a-i-h2yogm.firebasestorage.app/o/AppImages%2FZaglushkaDish.png?alt=media&token=removed',
                                                          ),
                                                          width: 80.0,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      2.0,
                                                                      0.0,
                                                                      2.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                dailyDishListItem
                                                                    .dishName,
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'SF Pro',
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            14.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      NutritionSummary
                                                                          .formatGrams(
                                                                        dailyDishListItem
                                                                            .dishWeight,
                                                                        useOunces:
                                                                            valueOrDefault<bool>(
                                                                          currentUserDocument
                                                                              ?.measurementOz,
                                                                          false,
                                                                        ),
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'SF Pro',
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${dailyDishListItem.kcal.toString()} kcal',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'SF Pro',
                                                                            fontSize:
                                                                                16.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      width:
                                                                          12.0)),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Wrap(
                                                                  spacing: 12.0,
                                                                  runSpacing:
                                                                      4.0,
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  runAlignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  verticalDirection:
                                                                      VerticalDirection
                                                                          .down,
                                                                  clipBehavior:
                                                                      Clip.none,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              10.0,
                                                                          height:
                                                                              10.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFF49928C),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              4.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            NutritionSummary.formatGrams(
                                                                              dailyDishListItem.proteins,
                                                                              useOunces: valueOrDefault<bool>(currentUserDocument?.measurementOz, false),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              10.0,
                                                                          height:
                                                                              10.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF19656),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              4.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            NutritionSummary.formatGrams(
                                                                              dailyDishListItem.fats,
                                                                              useOunces: valueOrDefault<bool>(currentUserDocument?.measurementOz, false),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              10.0,
                                                                          height:
                                                                              10.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFF9F4284),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              4.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            NutritionSummary.formatGrams(
                                                                              dailyDishListItem.carbs,
                                                                              useOunces: valueOrDefault<bool>(currentUserDocument?.measurementOz, false),
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ]
                                .addToStart(SizedBox(height: 100.0))
                                .addToEnd(SizedBox(height: 163.0)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavBarWidget(
                    activePage: 'Stats',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).secondaryBackground,
                      Color(0xEFF2F2F7),
                      Color(0x00F2F2F7)
                    ],
                    stops: [0.0, 0.8, 1.0],
                    begin: AlignmentDirectional(0.0, -1.0),
                    end: AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 55.0, 12.0, 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
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
            ],
          ),
        ),
      ),
    );
  }
}
