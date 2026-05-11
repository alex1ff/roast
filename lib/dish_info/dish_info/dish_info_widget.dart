import '/auth/firebase_auth/auth_util.dart';
import '/backend/ai_agents/ai_agent.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/loading_animation/loading_animation_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/main_page/subscription_pop_up/subscription_pop_up_widget.dart';
import '/main_page/subscription_pop_up_copy/subscription_pop_up_copy_widget.dart';
import '/services/nutrition_summary.dart';
import '/services/user_account_mutations.dart';
import '/services/usage_limit_service.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'dish_info_model.dart';
export 'dish_info_model.dart';

class DishInfoWidget extends StatefulWidget {
  const DishInfoWidget({
    super.key,
    required this.dish,
  });

  final DocumentReference? dish;

  static String routeName = 'DishInfo';
  static String routePath = '/dishInfo';

  @override
  State<DishInfoWidget> createState() => _DishInfoWidgetState();
}

class _DishInfoWidgetState extends State<DishInfoWidget> {
  late DishInfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DishInfoModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      unawaited(
        () async {
          await actions.lockOrientation();
        }(),
      );
      _model.link = await actions.createRoastShareLink(
        widget.dish,
      );
    });

    _model.textFieldwFocusNode ??= FocusNode();
    _model.textFieldwFocusNode!.addListener(() => safeSetState(() {}));
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF2F2F7),
        body: StreamBuilder<AddedDishHistoryRecord>(
          stream: AddedDishHistoryRecord.getDocument(widget.dish!),
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

            final stackAddedDishHistoryRecord = snapshot.data!;

            return Container(
              height: MediaQuery.sizeOf(context).height * 1.0,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  6.0, 0.0, 6.0, 6.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(14.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (stackAddedDishHistoryRecord
                                                            .image !=
                                                        '')
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                    0.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFF2F2F7),
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              fadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          0),
                                                              fadeOutDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          0),
                                                              imageUrl:
                                                                  stackAddedDishHistoryRecord
                                                                      .image,
                                                              memCacheWidth:
                                                                  160,
                                                              memCacheHeight:
                                                                  220,
                                                              maxWidthDiskCache:
                                                                  320,
                                                              maxHeightDiskCache:
                                                                  440,
                                                              width: 80.0,
                                                              height: 110.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AuthUserStreamWidget(
                                                                  builder:
                                                                      (context) =>
                                                                          Text(
                                                                    '${stackAddedDishHistoryRecord.dishName} • ${NutritionSummary.formatGrams(stackAddedDishHistoryRecord.dishWeight, useOunces: valueOrDefault<bool>(currentUserDocument?.measurementOz, false))} • ${stackAddedDishHistoryRecord.kcal.toString()} kcal/dish',
                                                                    maxLines: 2,
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
                                                                ),
                                                              ),
                                                              FlutterFlowIconButton(
                                                                borderRadius:
                                                                    8.0,
                                                                buttonSize:
                                                                    40.0,
                                                                fillColor: Color(
                                                                    0xFFFAE6D7),
                                                                icon: Icon(
                                                                  FFIcons
                                                                      .kgsdfef,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: 20.0,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  _model.editMode =
                                                                      true;
                                                                  _model.ingredientsEdit = stackAddedDishHistoryRecord
                                                                      .mainIngredients
                                                                      .toList()
                                                                      .cast<
                                                                          String>();
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Wrap(
                                                            spacing: 10.0,
                                                            runSpacing: 8.0,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.horizontal,
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Protein',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'SF Pro',
                                                                              color: Color(0xFF80BFB4),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              4.0,
                                                                          height:
                                                                              4.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFF80BFB4),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
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
                                                                          '${stackAddedDishHistoryRecord.proteins.toString()} g',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'SF Pro',
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        'Fat',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'SF Pro',
                                                                              color: Color(0xFFF19656),
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              4.0,
                                                                          height:
                                                                              4.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF19656),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
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
                                                                          '${stackAddedDishHistoryRecord.fats.toString()} g',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'SF Pro',
                                                                                fontSize: 16.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        10.0)),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Carbs',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'SF Pro',
                                                                          color:
                                                                              Color(0xFF9F4284),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          4.0,
                                                                      height:
                                                                          4.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xFF9F4284),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      '${stackAddedDishHistoryRecord.carbs.toString()} g',
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
                                                                                FontWeight.normal,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Wrap(
                                                                spacing: 6.0,
                                                                runSpacing: 6.0,
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
                                                                  Container(
                                                                    height:
                                                                        25.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF2F2F7),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              0.0,
                                                                              12.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            stackAddedDishHistoryRecord.badge,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        25.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF2F2F7),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              0.0,
                                                                              12.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            stackAddedDishHistoryRecord.impact,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        25.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF2F2F7),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              0.0,
                                                                              12.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            stackAddedDishHistoryRecord.calorieshare,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_model.editMode)
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 8.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: 80.0,
                                                          child: TextFormField(
                                                            controller: _model
                                                                    .textFieldwTextController ??=
                                                                TextEditingController(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                stackAddedDishHistoryRecord
                                                                    .dishWeight
                                                                    .toString(),
                                                                '0',
                                                              ),
                                                            ),
                                                            focusNode: _model
                                                                .textFieldwFocusNode,
                                                            onChanged: (_) =>
                                                                EasyDebounce
                                                                    .debounce(
                                                              '_model.textFieldwTextController',
                                                              Duration(
                                                                  milliseconds:
                                                                      0),
                                                              () =>
                                                                  safeSetState(
                                                                      () {}),
                                                            ),
                                                            autofocus: false,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'SF Pro',
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            validator: _model
                                                                .textFieldwTextControllerValidator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      4.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child:
                                                              AuthUserStreamWidget(
                                                            builder:
                                                                (context) =>
                                                                    Text(
                                                              valueOrDefault<
                                                                          bool>(
                                                                      currentUserDocument
                                                                          ?.measurementOz,
                                                                      false)
                                                                  ? 'Oz'
                                                                  : 'g',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
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
                                                                            .w500,
                                                                    lineHeight:
                                                                        1.5,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 0.0),
                                                  child: AutoSizeText(
                                                    '*Estimated from photo/name and may differ from actual values',
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'SF Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            if (!_model.editMode) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Roast Verdict by ${stackAddedDishHistoryRecord.roastPerson}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'SF Pro',
                                                                    fontSize:
                                                                        18.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    lineHeight:
                                                                        1.5,
                                                                  ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        16.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .fade,
                                                                        child:
                                                                            FlutterFlowExpandedImageView(
                                                                          image:
                                                                              CachedNetworkImage(
                                                                            fadeInDuration:
                                                                                Duration(milliseconds: 0),
                                                                            fadeOutDuration:
                                                                                Duration(milliseconds: 0),
                                                                            imageUrl:
                                                                                stackAddedDishHistoryRecord.roastImage,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                          allowRotation:
                                                                              false,
                                                                          tag: stackAddedDishHistoryRecord
                                                                              .roastImage,
                                                                          useHeroAnimation:
                                                                              true,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Hero(
                                                                    tag: stackAddedDishHistoryRecord
                                                                        .roastImage,
                                                                    transitionOnUserGestures:
                                                                        true,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14.0),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration(milliseconds: 0),
                                                                        fadeOutDuration:
                                                                            Duration(milliseconds: 0),
                                                                        imageUrl:
                                                                            stackAddedDishHistoryRecord.roastImage,
                                                                        memCacheWidth:
                                                                            180,
                                                                        memCacheHeight:
                                                                            180,
                                                                        maxWidthDiskCache:
                                                                            360,
                                                                        maxHeightDiskCache:
                                                                            360,
                                                                        width: MediaQuery.sizeOf(context).width *
                                                                            0.15,
                                                                        height:
                                                                            60.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            6.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xFFFAE6D7),
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(12.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Text(
                                                                              '\"${stackAddedDishHistoryRecord.roastText}\"',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'SF Pro',
                                                                                    color: Colors.black,
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  if (responsiveVisibility(
                                                                                    context: context,
                                                                                    phone: false,
                                                                                  ))
                                                                                    FlutterFlowIconButton(
                                                                                      borderRadius: 100.0,
                                                                                      buttonSize: 35.0,
                                                                                      fillColor: FlutterFlowTheme.of(context).primary,
                                                                                      icon: Icon(
                                                                                        Icons.play_arrow,
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        size: 17.0,
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        _model.soundPlayer1 ??= AudioPlayer();
                                                                                        if (_model.soundPlayer1!.playing) {
                                                                                          await _model.soundPlayer1!.stop();
                                                                                        }
                                                                                        _model.soundPlayer1!.setVolume(1.0);
                                                                                        await _model.soundPlayer1!.setUrl(stackAddedDishHistoryRecord.roastAudio).then((_) => _model.soundPlayer1!.play());
                                                                                      },
                                                                                    ),
                                                                                  Container(
                                                                                    width: MediaQuery.sizeOf(context).width * 0.71,
                                                                                    height: 54.0,
                                                                                    child: custom_widgets.AudioMessageWidget(
                                                                                      width: MediaQuery.sizeOf(context).width * 0.71,
                                                                                      height: 54.0,
                                                                                      audioUrl: stackAddedDishHistoryRecord.roastAudio,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        6.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Builder(
                                                                    builder:
                                                                        (context) =>
                                                                            FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        var _shouldSetState =
                                                                            false;
                                                                        if (UsageLimitService
                                                                            .canUseRoast(
                                                                          hasPremium: revenue_cat
                                                                              .activeEntitlementIds
                                                                              .contains(FFAppConstants.Premium),
                                                                          usedCount:
                                                                              currentUserDocument?.countLimited,
                                                                          subPlan:
                                                                              currentUserDocument?.subPlan,
                                                                          extraPhoto:
                                                                              currentUserDocument?.extraPhoto,
                                                                        )) {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (dialogContext) {
                                                                              return Dialog(
                                                                                elevation: 0,
                                                                                insetPadding: EdgeInsets.zero,
                                                                                backgroundColor: Colors.transparent,
                                                                                alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    FocusScope.of(dialogContext).unfocus();
                                                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                                                  },
                                                                                  child: Container(
                                                                                    height: MediaQuery.sizeOf(context).height * 1.0,
                                                                                    width: MediaQuery.sizeOf(context).width * 1.0,
                                                                                    child: LoadingAnimationWidget(),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );

                                                                          await callAiAgent(
                                                                            context:
                                                                                context,
                                                                            prompt: functions.buildDishAgentInput(
                                                                                're_roast',
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.dishName,
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.image,
                                                                                  '-',
                                                                                ),
                                                                                int.parse(_model.textFieldwTextController.text),
                                                                                stackAddedDishHistoryRecord.mainIngredients.toList(),
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.restaurant,
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  valueOrDefault(currentUserDocument?.activityLevel, ''),
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  valueOrDefault(currentUserDocument?.activityLevel, ''),
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  valueOrDefault(currentUserDocument?.userGoal, ''),
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<int>(
                                                                                  valueOrDefault(currentUserDocument?.kcalGoal, 0),
                                                                                  0,
                                                                                ),
                                                                                'English',
                                                                                valueOrDefault<String>(
                                                                                  valueOrDefault(currentUserDocument?.roastLevel, ''),
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.roastPerson,
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<int>(
                                                                                  stackAddedDishHistoryRecord.kcal,
                                                                                  0,
                                                                                ),
                                                                                valueOrDefault<int>(
                                                                                  stackAddedDishHistoryRecord.proteins,
                                                                                  0,
                                                                                ),
                                                                                valueOrDefault<int>(
                                                                                  stackAddedDishHistoryRecord.kcal,
                                                                                  0,
                                                                                ),
                                                                                valueOrDefault<int>(
                                                                                  stackAddedDishHistoryRecord.carbs,
                                                                                  0,
                                                                                ),
                                                                                stackAddedDishHistoryRecord.vitamins.map((e) => e.vitamin).toList(),
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.badge,
                                                                                  '-',
                                                                                ),
                                                                                valueOrDefault<String>(
                                                                                  stackAddedDishHistoryRecord.badge,
                                                                                  '-',
                                                                                ),
                                                                                stackAddedDishHistoryRecord.healthTips.toList()),
                                                                            imageUrl:
                                                                                stackAddedDishHistoryRecord.image,
                                                                            threadId:
                                                                                'roast',
                                                                            agentCloudFunctionName:
                                                                                'roast',
                                                                            provider:
                                                                                'OPENAI',
                                                                            agentJson:
                                                                                null,
                                                                            responseType:
                                                                                'JSON',
                                                                          ).then(
                                                                              (generatedText) {
                                                                            safeSetState(() =>
                                                                                _model.roast = generatedText);
                                                                          });

                                                                          _shouldSetState =
                                                                              true;
                                                                          if (_model.roast !=
                                                                              null) {
                                                                            _model.audioResultt2 =
                                                                                await TextToSpeechCall.call(
                                                                              text: getJsonField(
                                                                                _model.roast,
                                                                                r'''$.roast''',
                                                                              ).toString(),
                                                                              voiceId: stackAddedDishHistoryRecord.roastVoiceId,
                                                                            );

                                                                            _shouldSetState =
                                                                                true;
                                                                            unawaited(
                                                                              UserAccountMutations.recordUsage(
                                                                                UserUsageFeature.roast,
                                                                              ),
                                                                            );
                                                                            if ((_model.audioResultt2?.succeeded ??
                                                                                true)) {
                                                                              unawaited(
                                                                                () async {
                                                                                  await widget.dish!.update(createAddedDishHistoryRecordData(
                                                                                    roastText: getJsonField(
                                                                                      _model.roast,
                                                                                      r'''$.roast''',
                                                                                    ).toString(),
                                                                                    roastAudio: TextToSpeechCall.audio(
                                                                                      (_model.audioResultt2?.jsonBody ?? ''),
                                                                                    ),
                                                                                  ));
                                                                                }(),
                                                                              );
                                                                              Navigator.pop(context);
                                                                              safeSetState(() {});
                                                                              _model.soundPlayer2 ??= AudioPlayer();
                                                                              if (_model.soundPlayer2!.playing) {
                                                                                await _model.soundPlayer2!.stop();
                                                                              }
                                                                              _model.soundPlayer2!.setVolume(1.0);
                                                                              _model.soundPlayer2!
                                                                                  .setUrl(TextToSpeechCall.audio(
                                                                                    (_model.audioResultt2?.jsonBody ?? ''),
                                                                                  )!)
                                                                                  .then((_) => _model.soundPlayer2!.play());

                                                                              if (_shouldSetState)
                                                                                safeSetState(() {});
                                                                              return;
                                                                            }
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'Roast engine overheated, retry.',
                                                                                style: TextStyle(
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                ),
                                                                              ),
                                                                              duration: Duration(milliseconds: 4000),
                                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          if (UsageLimitService
                                                                              .roastDecision(
                                                                            hasPremium:
                                                                                revenue_cat.activeEntitlementIds.contains(FFAppConstants.Premium),
                                                                            usedCount:
                                                                                currentUserDocument?.countLimited,
                                                                            subPlan:
                                                                                currentUserDocument?.subPlan,
                                                                            extraPhoto:
                                                                                currentUserDocument?.extraPhoto,
                                                                          ).premiumIncludedQuotaReached) {
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (dialogContext) {
                                                                                return Dialog(
                                                                                  elevation: 0,
                                                                                  insetPadding: EdgeInsets.zero,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      FocusScope.of(dialogContext).unfocus();
                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                    },
                                                                                    child: Container(
                                                                                      width: MediaQuery.sizeOf(context).width * 0.8,
                                                                                      child: SubscriptionPopUpCopyWidget(),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );

                                                                            return;
                                                                          } else {
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (dialogContext) {
                                                                                return Dialog(
                                                                                  elevation: 0,
                                                                                  insetPadding: EdgeInsets.zero,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  alignment: AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      FocusScope.of(dialogContext).unfocus();
                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                    },
                                                                                    child: Container(
                                                                                      width: MediaQuery.sizeOf(context).width * 0.8,
                                                                                      child: SubscriptionPopUpWidget(),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );

                                                                            return;
                                                                          }
                                                                        }

                                                                        if (_shouldSetState)
                                                                          safeSetState(
                                                                              () {});
                                                                      },
                                                                      text:
                                                                          'Re-roast',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            45.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: Colors
                                                                            .transparent,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'SF Pro',
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            0.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(12.0),
                                                                      ),
                                                                      showLoadingIndicator:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await actions
                                                                          .shareRoastLink(
                                                                        widget
                                                                            .dish,
                                                                        _model
                                                                            .link,
                                                                      );
                                                                    },
                                                                    text:
                                                                        'Send to Friend',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .share_rounded,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          45.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'SF Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    showLoadingIndicator:
                                                                        false,
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 6.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Damage Control',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'SF Pro',
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  lineHeight:
                                                                      1.5,
                                                                ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF2F2F7),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      stackAddedDishHistoryRecord
                                                                          .healthTips
                                                                          .firstOrNull,
                                                                      '-',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
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
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF2F2F7),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      stackAddedDishHistoryRecord
                                                                          .healthTips
                                                                          .elementAtOrNull(
                                                                              1),
                                                                      '-',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
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
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF2F2F7),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      stackAddedDishHistoryRecord
                                                                          .healthTips
                                                                          .elementAtOrNull(
                                                                              2),
                                                                      '-',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
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
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 6.0)),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 16.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'AI Spotted Ingredients',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'SF Pro',
                                                                  fontSize:
                                                                      18.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  lineHeight:
                                                                      1.5,
                                                                ),
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              final ingredients =
                                                                  stackAddedDishHistoryRecord
                                                                      .mainIngredients
                                                                      .toList();

                                                              return Wrap(
                                                                spacing: 6.0,
                                                                runSpacing: 6.0,
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
                                                                children: List.generate(
                                                                    ingredients
                                                                        .length,
                                                                    (ingredientsIndex) {
                                                                  final ingredientsItem =
                                                                      ingredients[
                                                                          ingredientsIndex];
                                                                  return Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF2F2F7),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        ingredientsItem,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'SF Pro',
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }),
                                                              );
                                                            },
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 16.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  if (stackAddedDishHistoryRecord
                                                      .vitamins.isNotEmpty)
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Text(
                                                                'Buffs',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'SF Pro',
                                                                      fontSize:
                                                                          18.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final vitaminsList =
                                                                    stackAddedDishHistoryRecord
                                                                        .vitamins
                                                                        .toList();

                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: List.generate(
                                                                      vitaminsList
                                                                          .length,
                                                                      (vitaminsListIndex) {
                                                                    final vitaminsListItem =
                                                                        vitaminsList[
                                                                            vitaminsListIndex];
                                                                    return Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              40.0,
                                                                          height:
                                                                              40.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF2F2F7),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            vitaminsListItem.vitamin,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              vitaminsListItem.description,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'SF Pro',
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    lineHeight: 1.5,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }).divide(SizedBox(
                                                                      height:
                                                                          6.0)),
                                                                );
                                                              },
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 16.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      unawaited(
                                                        () async {
                                                          Navigator.pop(
                                                              context);
                                                        }(),
                                                      );
                                                      unawaited(
                                                        () async {
                                                          await stackAddedDishHistoryRecord
                                                              .reference
                                                              .delete();
                                                        }(),
                                                      );
                                                      context.safePop();
                                                    },
                                                    text: 'Delete',
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 50.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'SF Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                                letterSpacing:
                                                                    0.0,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 6.0)),
                                              );
                                            } else {
                                              return Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(16.0, 16.0,
                                                          16.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(
                                                        builder: (context) {
                                                          final ingredients =
                                                              _model
                                                                  .ingredientsEdit
                                                                  .toList();

                                                          return Wrap(
                                                            spacing: 12.0,
                                                            runSpacing: 8.0,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.horizontal,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            verticalDirection:
                                                                VerticalDirection
                                                                    .down,
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: List.generate(
                                                                ingredients
                                                                    .length,
                                                                (ingredientsIndex) {
                                                              final ingredientsItem =
                                                                  ingredients[
                                                                      ingredientsIndex];
                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .boxBG,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          4.0,
                                                                          8.0,
                                                                          4.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            ingredientsItem,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'SF Pro',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            _model.removeFromIngredientsEdit(ingredientsItem);
                                                                            safeSetState(() {});
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                16.0,
                                                                            height:
                                                                                16.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0x331C1C1C),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 0.0),
                                                                              child: Icon(
                                                                                Icons.close,
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                size: 12.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    16.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Add ingredient',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'SF Pro',
                                                                fontSize: 17.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                lineHeight: 1.3,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                .textController2,
                                                            focusNode: _model
                                                                .textFieldFocusNode,
                                                            onFieldSubmitted:
                                                                (_) async {
                                                              _model.addToIngredientsEdit(
                                                                  _model
                                                                      .textController2
                                                                      .text);
                                                              safeSetState(
                                                                  () {});
                                                              safeSetState(() {
                                                                _model
                                                                    .textController2
                                                                    ?.clear();
                                                              });
                                                            },
                                                            autofocus: false,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: false,
                                                              hintText:
                                                                  'Put here',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'SF Pro',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            17.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedErrorBorder:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'SF Pro',
                                                                  fontSize:
                                                                      17.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                            cursorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            validator: _model
                                                                .textController2Validator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ]
                                          .divide(SizedBox(height: 6.0))
                                          .addToStart(SizedBox(height: 125.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    6.0, 6.0, 6.0, 35.0),
                                child: Builder(
                                  builder: (context) {
                                    if (_model.editMode) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                _model.editMode = false;
                                                _model.ingredientsEdit = [];
                                                safeSetState(() {});
                                              },
                                              text: 'Cancel',
                                              icon: Icon(
                                                Icons.close,
                                                size: 24.0,
                                              ),
                                              options: FFButtonOptions(
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                iconColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'SF Pro',
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                        ),
                                                elevation: 0.0,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) =>
                                                FlutterFlowIconButton(
                                              borderRadius: 12.0,
                                              buttonSize: 50.0,
                                              fillColor: Color(0xFFFAE6D7),
                                              icon: Icon(
                                                FFIcons.kertc,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 24.0,
                                              ),
                                              showLoadingIndicator: true,
                                              onPressed: () async {
                                                var _shouldSetState = false;
                                                if (UsageLimitService
                                                    .canUseRoast(
                                                  hasPremium: revenue_cat
                                                      .activeEntitlementIds
                                                      .contains(FFAppConstants
                                                          .Premium),
                                                  usedCount: currentUserDocument
                                                      ?.countLimited,
                                                  subPlan: currentUserDocument
                                                      ?.subPlan,
                                                  extraPhoto:
                                                      currentUserDocument
                                                          ?.extraPhoto,
                                                )) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (dialogContext) {
                                                      return Dialog(
                                                        elevation: 0,
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        alignment:
                                                            AlignmentDirectional(
                                                                    0.0, 0.0)
                                                                .resolve(
                                                                    Directionality.of(
                                                                        context)),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    dialogContext)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Container(
                                                            height: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .height *
                                                                1.0,
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                1.0,
                                                            child:
                                                                LoadingAnimationWidget(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  await callAiAgent(
                                                    context: context,
                                                    prompt: functions
                                                        .buildDishAgentInput(
                                                            'analyze',
                                                            valueOrDefault<
                                                                String>(
                                                              stackAddedDishHistoryRecord
                                                                  .dishName,
                                                              '-',
                                                            ),
                                                            valueOrDefault<
                                                                String>(
                                                              stackAddedDishHistoryRecord
                                                                  .image,
                                                              '-',
                                                            ),
                                                            int.parse(_model
                                                                .textFieldwTextController
                                                                .text),
                                                            _model
                                                                .ingredientsEdit
                                                                .toList(),
                                                            valueOrDefault<
                                                                String>(
                                                              stackAddedDishHistoryRecord
                                                                  .restaurant,
                                                              '-',
                                                            ),
                                                            valueOrDefault<
                                                                String>(
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.activityLevel,
                                                                  ''),
                                                              '-',
                                                            ),
                                                            valueOrDefault<
                                                                String>(
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.activityLevel,
                                                                  ''),
                                                              '-',
                                                            ),
                                                            valueOrDefault<
                                                                String>(
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.userGoal,
                                                                  ''),
                                                              '-',
                                                            ),
                                                            valueOrDefault<int>(
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.kcalGoal,
                                                                  0),
                                                              0,
                                                            ),
                                                            'English',
                                                            valueOrDefault<
                                                                String>(
                                                              valueOrDefault(
                                                                  currentUserDocument
                                                                      ?.roastLevel,
                                                                  ''),
                                                              '-',
                                                            ),
                                                            valueOrDefault<
                                                                String>(
                                                              stackAddedDishHistoryRecord
                                                                  .roastPerson,
                                                              '-',
                                                            ),
                                                            0,
                                                            0,
                                                            0,
                                                            0,
                                                            FFAppState()
                                                                .n
                                                                .toList(),
                                                            '-',
                                                            '-',
                                                            FFAppState()
                                                                .n
                                                                .toList()),
                                                    imageUrl:
                                                        stackAddedDishHistoryRecord
                                                            .image,
                                                    threadId: 'roast',
                                                    agentCloudFunctionName:
                                                        'roast',
                                                    provider: 'OPENAI',
                                                    agentJson: null,
                                                    responseType: 'JSON',
                                                  ).then((generatedText) {
                                                    safeSetState(() =>
                                                        _model.reroas =
                                                            generatedText);
                                                  });

                                                  _shouldSetState = true;
                                                  if (_model.reroas != null) {
                                                    _model.audioResultt22 =
                                                        await TextToSpeechCall
                                                            .call(
                                                      text: getJsonField(
                                                        _model.reroas,
                                                        r'''$.roast''',
                                                      ).toString(),
                                                      voiceId:
                                                          stackAddedDishHistoryRecord
                                                              .roastVoiceId,
                                                    );

                                                    _shouldSetState = true;
                                                    if (TextToSpeechCall.audio(
                                                              (_model.audioResultt22
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ) !=
                                                            null &&
                                                        TextToSpeechCall.audio(
                                                              (_model.audioResultt22
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ) !=
                                                            '') {
                                                      unawaited(
                                                        UserAccountMutations
                                                            .recordUsage(
                                                          UserUsageFeature
                                                              .roast,
                                                        ),
                                                      );
                                                      unawaited(
                                                        () async {
                                                          await stackAddedDishHistoryRecord
                                                              .reference
                                                              .update({
                                                            ...createAddedDishHistoryRecordData(
                                                              dishWeight:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.dish_weight''',
                                                              ),
                                                              kcal:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.kcal''',
                                                              ),
                                                              carbs:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.carbs''',
                                                              ),
                                                              fats:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.fats''',
                                                              ),
                                                              proteins:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.proteins''',
                                                              ),
                                                              roastText:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.roast''',
                                                              ).toString(),
                                                              badge:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.primary_badge_text''',
                                                              ).toString(),
                                                              impact:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.goal_impact_text''',
                                                              ).toString(),
                                                              calorieshare:
                                                                  getJsonField(
                                                                _model.reroas,
                                                                r'''$.daily_calorie_share_text''',
                                                              ).toString(),
                                                              roastAudio:
                                                                  TextToSpeechCall
                                                                      .audio(
                                                                (_model.audioResultt22
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              ),
                                                            ),
                                                            ...mapToFirestore(
                                                              {
                                                                'main_ingredients':
                                                                    (getJsonField(
                                                                  _model.reroas,
                                                                  r'''$.main_ingredients''',
                                                                  true,
                                                                ) as List?)
                                                                        ?.map<String>((e) => e
                                                                            .toString())
                                                                        .toList()
                                                                        .cast<
                                                                            String>(),
                                                                'vitamins':
                                                                    getDishPageVitaminsDataListFirestoreData(
                                                                  (getJsonField(
                                                                    _model
                                                                        .reroas,
                                                                    r'''$.vitaminsAndMinerals''',
                                                                    true,
                                                                  )?.toList().map<DishPageVitaminsDataStruct?>(DishPageVitaminsDataStruct.maybeFromMap).toList()
                                                                          as Iterable<
                                                                              DishPageVitaminsDataStruct?>)
                                                                      .withoutNulls,
                                                                ),
                                                                'health_tips':
                                                                    (getJsonField(
                                                                  _model.reroas,
                                                                  r'''$.smart_tweaks''',
                                                                  true,
                                                                ) as List?)
                                                                        ?.map<String>((e) => e
                                                                            .toString())
                                                                        .toList()
                                                                        .cast<
                                                                            String>(),
                                                              },
                                                            ),
                                                          });
                                                        }(),
                                                      );
                                                      _model.soundPlayer3 ??=
                                                          AudioPlayer();
                                                      if (_model.soundPlayer3!
                                                          .playing) {
                                                        await _model
                                                            .soundPlayer3!
                                                            .stop();
                                                      }
                                                      _model.soundPlayer3!
                                                          .setVolume(1.0);
                                                      _model.soundPlayer3!
                                                          .setUrl(
                                                              TextToSpeechCall
                                                                  .audio(
                                                            (_model.audioResultt22
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!)
                                                          .then((_) => _model
                                                              .soundPlayer3!
                                                              .play());
                                                    }
                                                    Navigator.pop(context);
                                                    _model.editMode = false;
                                                    safeSetState(() {});
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'AI Error',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  if (UsageLimitService
                                                      .roastDecision(
                                                    hasPremium: revenue_cat
                                                        .activeEntitlementIds
                                                        .contains(FFAppConstants
                                                            .Premium),
                                                    usedCount:
                                                        currentUserDocument
                                                            ?.countLimited,
                                                    subPlan: currentUserDocument
                                                        ?.subPlan,
                                                    extraPhoto:
                                                        currentUserDocument
                                                            ?.extraPhoto,
                                                  ).premiumIncludedQuotaReached) {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          alignment: AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      dialogContext)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.8,
                                                              child:
                                                                  SubscriptionPopUpCopyWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    return;
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          alignment: AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      dialogContext)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.8,
                                                              child:
                                                                  SubscriptionPopUpWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    return;
                                                  }
                                                }

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 6.0)),
                                      );
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Want a deeper breakdown? Open AI Chat and I’ll roast this dish with smarter tweaks.',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'SF Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                ChatCopyWidget.routeName,
                                                queryParameters: {
                                                  'dish': serializeParam(
                                                    stackAddedDishHistoryRecord,
                                                    ParamType.Document,
                                                  ),
                                                }.withoutNulls,
                                                extra: <String, dynamic>{
                                                  'dish':
                                                      stackAddedDishHistoryRecord,
                                                },
                                              );
                                            },
                                            text: 'Continue in AI Chat',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 50.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).secondaryBackground,
                          Color(0xF2F2F2F7),
                          Color(0x00F2F2F7)
                        ],
                        stops: [0.0, 0.8, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 55.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7.0,
                                  color: Color(0x0D2C2C2C),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: FlutterFlowIconButton(
                              borderRadius: 70.0,
                              buttonSize: 45.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 14.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ),
                          Text(
                            'Dish Breakdown',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
