import '/auth/firebase_auth/auth_util.dart';
import '/backend/ai_agents/ai_agent.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/loading_animation/loading_animation_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/main_page/subscription_pop_up/subscription_pop_up_widget.dart';
import '/main_page/subscription_pop_up_copy/subscription_pop_up_copy_widget.dart';
import '/services/user_account_mutations.dart';
import '/services/usage_limit_service.dart';
import 'dart:async';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'choose_person_model.dart';
export 'choose_person_model.dart';

class ChoosePersonWidget extends StatefulWidget {
  const ChoosePersonWidget({
    super.key,
    required this.dishName,
    this.dishWeight,
    this.restaurant,
    this.dishPhoto,
    required this.action,
  });

  final String? dishName;
  final int? dishWeight;
  final String? restaurant;
  final String? dishPhoto;
  final Future Function()? action;

  @override
  State<ChoosePersonWidget> createState() => _ChoosePersonWidgetState();
}

class _ChoosePersonWidgetState extends State<ChoosePersonWidget> {
  late ChoosePersonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoosePersonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: StreamBuilder<List<PersonsRecord>>(
        stream: queryPersonsRecord(),
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
          List<PersonsRecord> containerPersonsRecordList = snapshot.data!;

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 600.0,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondary,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      'Choose roast character',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                    child: AuthUserStreamWidget(
                      builder: (context) => FlutterFlowDropDown<String>(
                        controller: _model.dropDownValueController ??=
                            FormFieldController<String>(
                          _model.dropDownValue ??=
                              valueOrDefault(currentUserDocument?.voiceId, ''),
                        ),
                        options: List<String>.from(containerPersonsRecordList
                            .map((e) => e.voiceId)
                            .toList()),
                        optionLabels: containerPersonsRecordList
                            .map((e) => e.name)
                            .toList(),
                        onChanged: (val) =>
                            safeSetState(() => _model.dropDownValue = val),
                        height: 45.0,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'SF Pro',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                        hintText: 'Choose a voice character',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).divider,
                        borderWidth: 1.0,
                        borderRadius: 8.0,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            unselectedWidgetColor:
                                FlutterFlowTheme.of(context).alternate,
                          ),
                          child: Checkbox(
                            value: _model.checkboxValue ??= _model.remember,
                            onChanged: (newValue) async {
                              safeSetState(
                                  () => _model.checkboxValue = newValue!);
                            },
                            side: BorderSide(
                              width: 2,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            activeColor: FlutterFlowTheme.of(context).primary,
                            checkColor: FlutterFlowTheme.of(context).info,
                          ),
                        ),
                        Text(
                          'Remember my choice',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) => Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: (_model.dropDownValue == null ||
                                _model.dropDownValue == '')
                            ? null
                            : () async {
                                var _shouldSetState = false;
                                await Future.wait([
                                  Future(() async {
                                    if (UsageLimitService.canUseRoast(
                                      hasPremium: revenue_cat
                                          .activeEntitlementIds
                                          .contains(FFAppConstants.Premium),
                                      usedCount:
                                          currentUserDocument?.countLimited,
                                      subPlan: currentUserDocument?.subPlan,
                                      extraPhoto:
                                          currentUserDocument?.extraPhoto,
                                    )) {
                                      showDialog(
                                        barrierColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: Container(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  1.0,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              child: LoadingAnimationWidget(),
                                            ),
                                          );
                                        },
                                      );

                                      await callAiAgent(
                                        context: context,
                                        prompt: functions.buildDishAgentInput(
                                            'analyze',
                                            valueOrDefault<String>(
                                              widget.dishName,
                                              '-',
                                            ),
                                            valueOrDefault<String>(
                                              widget.dishPhoto,
                                              '-',
                                            ),
                                            valueOrDefault<int>(
                                              widget.dishWeight,
                                              0,
                                            ),
                                            FFAppState().n.toList(),
                                            valueOrDefault<String>(
                                              widget.restaurant,
                                              '-',
                                            ),
                                            valueOrDefault<String>(
                                              valueOrDefault(
                                                  currentUserDocument
                                                      ?.activityLevel,
                                                  ''),
                                              '-',
                                            ),
                                            valueOrDefault<String>(
                                              valueOrDefault(
                                                  currentUserDocument
                                                      ?.activityLevel,
                                                  ''),
                                              '-',
                                            ),
                                            valueOrDefault<String>(
                                              valueOrDefault(
                                                  currentUserDocument?.userGoal,
                                                  ''),
                                              '-',
                                            ),
                                            valueOrDefault<int>(
                                              valueOrDefault(
                                                  currentUserDocument?.kcalGoal,
                                                  0),
                                              0,
                                            ),
                                            'English',
                                            valueOrDefault<String>(
                                              valueOrDefault(
                                                  currentUserDocument
                                                      ?.roastLevel,
                                                  ''),
                                              '-',
                                            ),
                                            _model.dropDownValue!,
                                            0,
                                            0,
                                            0,
                                            0,
                                            FFAppState().n.toList(),
                                            '-',
                                            '-',
                                            FFAppState().n.toList()),
                                        imageUrl: widget.dishPhoto,
                                        threadId: 'roast',
                                        agentCloudFunctionName: 'roast',
                                        provider: 'OPENAI',
                                        agentJson: null,
                                        responseType: 'JSON',
                                      ).then((generatedText) {
                                        safeSetState(
                                            () => _model.roast = generatedText);
                                      });

                                      _shouldSetState = true;
                                      if (_model.roast != null) {
                                        _model.audioResultt =
                                            await TextToSpeechCall.call(
                                          text: getJsonField(
                                            _model.roast,
                                            r'''$.roast''',
                                          ).toString(),
                                          voiceId: _model.dropDownValue,
                                        );

                                        _shouldSetState = true;
                                        unawaited(
                                          UserAccountMutations.recordUsage(
                                            UserUsageFeature.roast,
                                          ),
                                        );
                                        if ((_model.audioResultt?.succeeded ??
                                            true)) {
                                          var addedDishHistoryRecordReference =
                                              AddedDishHistoryRecord.collection
                                                  .doc();
                                          await addedDishHistoryRecordReference
                                              .set({
                                            ...createAddedDishHistoryRecordData(
                                              dishName: getJsonField(
                                                _model.roast,
                                                r'''$.dish_name''',
                                              ).toString(),
                                              dishWeight: getJsonField(
                                                _model.roast,
                                                r'''$.dish_weight''',
                                              ),
                                              addedDate: getCurrentTimestamp,
                                              restaurant: widget.restaurant,
                                              image: widget.dishPhoto,
                                              kcal: getJsonField(
                                                _model.roast,
                                                r'''$.kcal''',
                                              ),
                                              carbs: getJsonField(
                                                _model.roast,
                                                r'''$.carbs''',
                                              ),
                                              proteins: getJsonField(
                                                _model.roast,
                                                r'''$.proteins''',
                                              ),
                                              fats: getJsonField(
                                                _model.roast,
                                                r'''$.fats''',
                                              ),
                                              user: currentUserReference,
                                              roastText: getJsonField(
                                                _model.roast,
                                                r'''$.roast''',
                                              ).toString(),
                                              roastAudio:
                                                  TextToSpeechCall.audio(
                                                (_model.audioResultt
                                                        ?.jsonBody ??
                                                    ''),
                                              ),
                                              roastPerson:
                                                  containerPersonsRecordList
                                                      .where((e) =>
                                                          e.voiceId ==
                                                          _model.dropDownValue)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.name,
                                              roastVoiceId:
                                                  _model.dropDownValue,
                                              roastImage:
                                                  containerPersonsRecordList
                                                      .where((e) =>
                                                          e.voiceId ==
                                                          _model.dropDownValue)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.image,
                                              roastLevel: valueOrDefault(
                                                  currentUserDocument
                                                      ?.roastLevel,
                                                  ''),
                                              badge: getJsonField(
                                                _model.roast,
                                                r'''$.primary_badge_text''',
                                              ).toString(),
                                              impact: getJsonField(
                                                _model.roast,
                                                r'''$.goal_impact_text''',
                                              ).toString(),
                                              calorieshare: getJsonField(
                                                _model.roast,
                                                r'''$.daily_calorie_share_text''',
                                              ).toString(),
                                            ),
                                            ...mapToFirestore(
                                              {
                                                'main_ingredients':
                                                    (getJsonField(
                                                  _model.roast,
                                                  r'''$.main_ingredients''',
                                                  true,
                                                ) as List?)
                                                        ?.map<String>(
                                                            (e) => e.toString())
                                                        .toList()
                                                        .cast<String>(),
                                                'vitamins':
                                                    getDishPageVitaminsDataListFirestoreData(
                                                  (getJsonField(
                                                    _model.roast,
                                                    r'''$.vitaminsAndMinerals''',
                                                    true,
                                                  )
                                                              ?.toList()
                                                              .map<DishPageVitaminsDataStruct?>(
                                                                  DishPageVitaminsDataStruct
                                                                      .maybeFromMap)
                                                              .toList()
                                                          as Iterable<
                                                              DishPageVitaminsDataStruct?>)
                                                      .withoutNulls,
                                                ),
                                                'health_tips': (getJsonField(
                                                  _model.roast,
                                                  r'''$.smart_tweaks''',
                                                  true,
                                                ) as List?)
                                                    ?.map<String>(
                                                        (e) => e.toString())
                                                    .toList()
                                                    .cast<String>(),
                                              },
                                            ),
                                          });
                                          _model.createdDocument =
                                              AddedDishHistoryRecord
                                                  .getDocumentFromData({
                                            ...createAddedDishHistoryRecordData(
                                              dishName: getJsonField(
                                                _model.roast,
                                                r'''$.dish_name''',
                                              ).toString(),
                                              dishWeight: getJsonField(
                                                _model.roast,
                                                r'''$.dish_weight''',
                                              ),
                                              addedDate: getCurrentTimestamp,
                                              restaurant: widget.restaurant,
                                              image: widget.dishPhoto,
                                              kcal: getJsonField(
                                                _model.roast,
                                                r'''$.kcal''',
                                              ),
                                              carbs: getJsonField(
                                                _model.roast,
                                                r'''$.carbs''',
                                              ),
                                              proteins: getJsonField(
                                                _model.roast,
                                                r'''$.proteins''',
                                              ),
                                              fats: getJsonField(
                                                _model.roast,
                                                r'''$.fats''',
                                              ),
                                              user: currentUserReference,
                                              roastText: getJsonField(
                                                _model.roast,
                                                r'''$.roast''',
                                              ).toString(),
                                              roastAudio:
                                                  TextToSpeechCall.audio(
                                                (_model.audioResultt
                                                        ?.jsonBody ??
                                                    ''),
                                              ),
                                              roastPerson:
                                                  containerPersonsRecordList
                                                      .where((e) =>
                                                          e.voiceId ==
                                                          _model.dropDownValue)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.name,
                                              roastVoiceId:
                                                  _model.dropDownValue,
                                              roastImage:
                                                  containerPersonsRecordList
                                                      .where((e) =>
                                                          e.voiceId ==
                                                          _model.dropDownValue)
                                                      .toList()
                                                      .firstOrNull
                                                      ?.image,
                                              roastLevel: valueOrDefault(
                                                  currentUserDocument
                                                      ?.roastLevel,
                                                  ''),
                                              badge: getJsonField(
                                                _model.roast,
                                                r'''$.primary_badge_text''',
                                              ).toString(),
                                              impact: getJsonField(
                                                _model.roast,
                                                r'''$.goal_impact_text''',
                                              ).toString(),
                                              calorieshare: getJsonField(
                                                _model.roast,
                                                r'''$.daily_calorie_share_text''',
                                              ).toString(),
                                            ),
                                            ...mapToFirestore(
                                              {
                                                'main_ingredients':
                                                    (getJsonField(
                                                  _model.roast,
                                                  r'''$.main_ingredients''',
                                                  true,
                                                ) as List?)
                                                        ?.map<String>(
                                                            (e) => e.toString())
                                                        .toList()
                                                        .cast<String>(),
                                                'vitamins':
                                                    getDishPageVitaminsDataListFirestoreData(
                                                  (getJsonField(
                                                    _model.roast,
                                                    r'''$.vitaminsAndMinerals''',
                                                    true,
                                                  )
                                                              ?.toList()
                                                              .map<DishPageVitaminsDataStruct?>(
                                                                  DishPageVitaminsDataStruct
                                                                      .maybeFromMap)
                                                              .toList()
                                                          as Iterable<
                                                              DishPageVitaminsDataStruct?>)
                                                      .withoutNulls,
                                                ),
                                                'health_tips': (getJsonField(
                                                  _model.roast,
                                                  r'''$.smart_tweaks''',
                                                  true,
                                                ) as List?)
                                                    ?.map<String>(
                                                        (e) => e.toString())
                                                    .toList()
                                                    .cast<String>(),
                                              },
                                            ),
                                          }, addedDishHistoryRecordReference);
                                          _shouldSetState = true;
                                          Navigator.pop(context);
                                          unawaited(
                                            () async {
                                              await widget.action?.call();
                                            }(),
                                          );
                                          Navigator.pop(context);

                                          context.pushNamed(
                                            DishInfoWidget.routeName,
                                            queryParameters: {
                                              'dish': serializeParam(
                                                _model
                                                    .createdDocument?.reference,
                                                ParamType.DocumentReference,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              '__transition_info__':
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.fade,
                                                duration:
                                                    Duration(milliseconds: 0),
                                              ),
                                            },
                                          );

                                          _model.soundPlayer ??= AudioPlayer();
                                          if (_model.soundPlayer!.playing) {
                                            await _model.soundPlayer!.stop();
                                          }
                                          _model.soundPlayer!.setVolume(1.0);
                                          _model.soundPlayer!
                                              .setUrl(TextToSpeechCall.audio(
                                                (_model.audioResultt
                                                        ?.jsonBody ??
                                                    ''),
                                              )!)
                                              .then((_) =>
                                                  _model.soundPlayer!.play());

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                      }
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'AI Error',
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    } else {
                                      if (UsageLimitService.roastDecision(
                                        hasPremium: revenue_cat
                                            .activeEntitlementIds
                                            .contains(FFAppConstants.Premium),
                                        usedCount:
                                            currentUserDocument?.countLimited,
                                        subPlan: currentUserDocument?.subPlan,
                                        extraPhoto:
                                            currentUserDocument?.extraPhoto,
                                      ).premiumIncludedQuotaReached) {
                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment:
                                                  AlignmentDirectional(0.0, 0.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.8,
                                                child:
                                                    SubscriptionPopUpCopyWidget(),
                                              ),
                                            );
                                          },
                                        );

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Dialog(
                                              elevation: 0,
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              alignment:
                                                  AlignmentDirectional(0.0, 0.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.8,
                                                child:
                                                    SubscriptionPopUpWidget(),
                                              ),
                                            );
                                          },
                                        );

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    }
                                  }),
                                  Future(() async {
                                    if (_model.checkboxValue!) {
                                      unawaited(
                                        () async {
                                          await currentUserReference!
                                              .update(createUsersRecordData(
                                            voiceId: _model.dropDownValue,
                                            voiceName:
                                                containerPersonsRecordList
                                                    .where((e) =>
                                                        e.voiceId ==
                                                        _model.dropDownValue)
                                                    .toList()
                                                    .firstOrNull
                                                    ?.name,
                                          ));
                                        }(),
                                      );
                                    }
                                  }),
                                ]);
                                if (_shouldSetState) safeSetState(() {});
                              },
                        text: 'Start roasting!',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'SF Pro',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                          disabledColor: Color(0x56FFA07A),
                          disabledTextColor:
                              FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
