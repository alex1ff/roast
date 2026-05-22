import '/auth/firebase_auth/auth_util.dart';
import '/backend/ai_agents/ai_agent.dart';
import '/backend/backend.dart';
import '/components/loading_animation/loading_animation_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/main_page/subscription_pop_up/subscription_pop_up_widget.dart';
import '/main_page/subscription_pop_up_copy/subscription_pop_up_copy_widget.dart';
import '/services/roast_analysis.dart';
import '/services/roast_audio_service.dart';
import '/services/user_account_mutations.dart';
import '/services/usage_limit_service.dart';
import 'dart:async';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'choose_person_content.dart';
import 'choose_person_model.dart';
import 'roast_rules_dialog.dart';
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

  Future<String?> _prepareAudioForRoast({
    required DocumentReference roastReference,
    required String roastText,
    required String? voiceId,
  }) async {
    final audioUrl = await RoastAudioService.generateAndAttach(
      roastReference: roastReference,
      roastText: roastText,
      voiceId: voiceId,
    );
    if (audioUrl == null || audioUrl.isEmpty) {
      return null;
    }

    if (!mounted) {
      return audioUrl;
    }
    _model.soundPlayer ??= AudioPlayer();
    if (_model.soundPlayer!.playing) {
      await _model.soundPlayer!.stop();
    }
    _model.soundPlayer!.setVolume(1.0);
    await _model.soundPlayer!.setUrl(audioUrl);
    return audioUrl;
  }

  void _playPreparedRoastAudio() {
    final player = _model.soundPlayer;
    if (player == null) {
      return;
    }
    unawaited(() async {
      try {
        await player.play();
      } catch (_) {}
    }());
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

          return AuthUserStreamWidget(
            builder: (context) {
              final dropDownValueController = _model.dropDownValueController ??=
                  FormFieldController<String>(
                _model.dropDownValue ??=
                    valueOrDefault(currentUserDocument?.voiceId, ''),
              );
              final checkboxValue = _model.checkboxValue ??= _model.remember;

              return ChoosePersonContent(
                persons: containerPersonsRecordList,
                dropDownController: dropDownValueController,
                onVoiceChanged: (val) =>
                    safeSetState(() => _model.dropDownValue = val),
                checkboxValue: checkboxValue,
                onCheckboxChanged: (newValue) {
                  safeSetState(() => _model.checkboxValue = newValue!);
                },
                onStartPressed: (_model.dropDownValue == null ||
                        _model.dropDownValue == '')
                    ? null
                    : () async {
                        // Require accepting the app rules before any
                        // generation can happen. No credits are spent
                        // if the user dismisses or rejects the dialog.
                        final accepted =
                            await RoastRulesDialog.ensureAccepted(context);
                        if (!accepted) {
                          return;
                        }
                        var _shouldSetState = false;
                        await Future.wait([
                          Future(() async {
                            if (UsageLimitService.canUseRoast(
                              hasPremium: revenue_cat.activeEntitlementIds
                                  .contains(FFAppConstants.Premium),
                              usedCount: currentUserDocument?.countLimited,
                              otherFeatureUsedCount:
                                  currentUserDocument?.countLimitedChat,
                              subPlan: currentUserDocument?.subPlan,
                              extraPhoto: currentUserDocument?.extraPhoto,
                            )) {
                              showDialog(
                                barrierColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              1.0,
                                      width: MediaQuery.sizeOf(context).width *
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
                                          currentUserDocument?.activityLevel,
                                          ''),
                                      '-',
                                    ),
                                    valueOrDefault<String>(
                                      valueOrDefault(
                                          currentUserDocument?.activityLevel,
                                          ''),
                                      '-',
                                    ),
                                    valueOrDefault<String>(
                                      valueOrDefault(
                                          currentUserDocument?.userGoal, ''),
                                      '-',
                                    ),
                                    valueOrDefault<int>(
                                      valueOrDefault(
                                          currentUserDocument?.kcalGoal, 0),
                                      0,
                                    ),
                                    'English',
                                    valueOrDefault<String>(
                                      valueOrDefault(
                                          currentUserDocument?.roastLevel, ''),
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
                                final roastAnalysis =
                                    RoastAnalysis.fromAgentResponse(
                                        _model.roast);
                                final roastText = roastAnalysis.roastText;
                                unawaited(
                                  UserAccountMutations.recordUsage(
                                    UserUsageFeature.roast,
                                  ),
                                );
                                var addedDishHistoryRecordReference =
                                    AddedDishHistoryRecord.collection.doc();
                                final roastData = {
                                  ...createAddedDishHistoryRecordData(
                                    dishName: roastAnalysis.dishName,
                                    dishWeight: roastAnalysis.dishWeight,
                                    addedDate: getCurrentTimestamp,
                                    restaurant: widget.restaurant,
                                    image: widget.dishPhoto,
                                    kcal: roastAnalysis.kcal,
                                    carbs: roastAnalysis.carbs,
                                    proteins: roastAnalysis.proteins,
                                    fats: roastAnalysis.fats,
                                    user: currentUserReference,
                                    roastText: roastText,
                                    roastAudio: '',
                                    roastPerson: containerPersonsRecordList
                                        .where((e) =>
                                            e.voiceId == _model.dropDownValue)
                                        .firstOrNull
                                        ?.name,
                                    roastVoiceId: _model.dropDownValue,
                                    roastImage: containerPersonsRecordList
                                        .where((e) =>
                                            e.voiceId == _model.dropDownValue)
                                        .firstOrNull
                                        ?.image,
                                    roastLevel: valueOrDefault(
                                        currentUserDocument?.roastLevel, ''),
                                    badge: roastAnalysis.badge,
                                    impact: roastAnalysis.impact,
                                    calorieshare: roastAnalysis.calorieShare,
                                  ),
                                  ...roastAnalysis.nestedFirestoreData(),
                                };
                                await addedDishHistoryRecordReference
                                    .set(roastData);
                                _model.createdDocument =
                                    AddedDishHistoryRecord.getDocumentFromData(
                                  roastData,
                                  addedDishHistoryRecordReference,
                                );
                                final audioUrl = await _prepareAudioForRoast(
                                  roastReference:
                                      addedDishHistoryRecordReference,
                                  roastText: roastText,
                                  voiceId: _model.dropDownValue,
                                );
                                _shouldSetState = true;
                                Navigator.pop(context);
                                if (audioUrl != null) {
                                  _playPreparedRoastAudio();
                                }
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
                                      _model.createdDocument?.reference,
                                      ParamType.DocumentReference,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    '__transition_info__': TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                                if (audioUrl == null && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Roast text is ready, but audio failed. Try re-roast to retry.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                }

                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'AI Error',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            } else {
                              if (UsageLimitService.roastDecision(
                                hasPremium: revenue_cat.activeEntitlementIds
                                    .contains(FFAppConstants.Premium),
                                usedCount: currentUserDocument?.countLimited,
                                otherFeatureUsedCount:
                                    currentUserDocument?.countLimitedChat,
                                subPlan: currentUserDocument?.subPlan,
                                extraPhoto: currentUserDocument?.extraPhoto,
                              ).premiumIncludedQuotaReached) {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        child: SubscriptionPopUpCopyWidget(),
                                      ),
                                    );
                                  },
                                );

                                if (_shouldSetState) safeSetState(() {});
                                return;
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        child: SubscriptionPopUpWidget(),
                                      ),
                                    );
                                  },
                                );

                                if (_shouldSetState) safeSetState(() {});
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
                                    voiceName: containerPersonsRecordList
                                        .where((e) =>
                                            e.voiceId == _model.dropDownValue)
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
              );
            },
          );
        },
      ),
    );
  }
}
