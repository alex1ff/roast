import '/auth/firebase_auth/auth_util.dart';
import '/backend/ai_agents/ai_agent.dart';
import '/backend/backend.dart';
import '/chat/mess/mess_widget.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main_page/subscription_pop_up/subscription_pop_up_widget.dart';
import '/main_page/subscription_pop_up_copy/subscription_pop_up_copy_widget.dart';
import '/services/chat_controller.dart';
import '/services/chat_history_view.dart';
import '/services/user_account_mutations.dart';
import '/services/usage_limit_service.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'chat_copy_model.dart';
export 'chat_copy_model.dart';

class ChatCopyWidget extends StatefulWidget {
  const ChatCopyWidget({
    super.key,
    this.dish,
  });

  final AddedDishHistoryRecord? dish;

  static String routeName = 'ChatCopy';
  static String routePath = '/chatCopy';

  @override
  State<ChatCopyWidget> createState() => _ChatCopyWidgetState();
}

class _ChatCopyWidgetState extends State<ChatCopyWidget> {
  late ChatCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatCopyModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      unawaited(
        () async {
          await actions.lockOrientation();
        }(),
      );
      unawaited(_loadRecentDishHistory());
      if (FFAppState().chathistory.isNotEmpty) {
        if (widget.dish != null) {
          _model.dish = widget.dish;
          _model.string = functions.dishString(widget.dish!);
          safeSetState(() {});
          if (!(FFAppState()
              .chathistory
              .where((e) => e.isFirst == true)
              .toList()
              .isNotEmpty)) {
            FFAppState().addToChathistory(AIChatStruct(
              role: 'assistant',
              isFirst: true,
              dish: widget.dish?.dishName,
              kkal: widget.dish?.kcal,
              date: getCurrentTimestamp,
            ));
            safeSetState(() {});
            await Future.delayed(
              Duration(
                milliseconds: 2000,
              ),
            );
            FFAppState().updateChathistoryAtIndex(
              FFAppState().chathistory.length - 1,
              (e) => e..message = '0',
            );
            safeSetState(() {});
          }
        }
      } else {
        FFAppState().addToChathistory(AIChatStruct(
          role: 'assistant',
          date: getCurrentTimestamp,
        ));
        safeSetState(() {});
        await Future.delayed(
          Duration(
            milliseconds: 2000,
          ),
        );
        FFAppState().updateChathistoryAtIndex(
          FFAppState().chathistory.length - 1,
          (e) => e
            ..message =
                'Hi, I’m Elena — send me a dish, habit, friend story, or questionable life choice. I’ll give you smart tweaks, social commentary, and a playful roast.',
        );
        safeSetState(() {});
      }
    });

    if (!isWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        safeSetState(() {
          _isKeyboardVisible = visible;
        });
      });
    }

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    if (!isWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  String get _chatThreadId {
    final uid = currentUserUid;
    return uid.isEmpty ? 'nutritional_helper_guest' : 'nutritional_helper_$uid';
  }

  Future<List<AddedDishHistoryRecord>> _loadRecentDishHistory() async {
    final existingHistory = _model.hist;
    if (existingHistory != null) {
      return existingHistory;
    }

    final history = await queryAddedDishHistoryRecordOnce(
      queryBuilder: (addedDishHistoryRecord) => addedDishHistoryRecord
          .where(
            'user',
            isEqualTo: currentUserReference,
          )
          .where(
            'addedDate',
            isLessThan: getCurrentTimestamp,
          )
          .where(
            'addedDate',
            isGreaterThan: functions.dateFilterMinusWeek(getCurrentTimestamp),
          )
          .orderBy('addedDate', descending: true),
      limit: 24,
    );
    _model.hist = history;
    return history;
  }

  int _addChatMessage(AIChatStruct message) {
    FFAppState().addToChathistory(message);
    safeSetState(() {});
    return FFAppState().chathistory.length - 1;
  }

  void _updateChatMessage(int index, String message) {
    if (index < 0 || index >= FFAppState().chathistory.length) {
      return;
    }

    FFAppState().updateChathistoryAtIndex(
      index,
      (chatMessage) => chatMessage..message = message,
    );
    safeSetState(() {});
  }

  Future<String> _recentMealsText() async =>
      functions.last7DaysDishesToString(
        (await _loadRecentDishHistory()).toList(),
      ) ??
      '';

  Future<String?> _callAssistant(String prompt) async {
    final generatedText = await callAiAgent(
      context: context,
      prompt: prompt,
      threadId: _chatThreadId,
      agentCloudFunctionName: 'aIAssistent',
      provider: 'OPENAI',
      agentJson: null,
      responseType: 'PLAINTEXT',
    );
    return generatedText is String ? generatedText : generatedText?.toString();
  }

  Future<void> _recordChatUsage() =>
      UserAccountMutations.recordUsage(UserUsageFeature.chat);

  bool get _hasPremium =>
      revenue_cat.activeEntitlementIds.contains(FFAppConstants.Premium);

  UsageLimitDecision _chatLimitDecision() => UsageLimitService.chatDecision(
        hasPremium: _hasPremium,
        usedCount: currentUserDocument?.countLimitedChat,
        otherFeatureUsedCount: currentUserDocument?.countLimited,
        subPlan: currentUserDocument?.subPlan,
        extraChat: currentUserDocument?.extraChat,
      );

  bool _canUseChat() => _chatLimitDecision().allowed;

  Future<ChatSendResult> _sendChatMessage({
    required String userMessage,
    required String type,
    String? currentDish,
  }) {
    final controller = ChatController(
      addMessage: _addChatMessage,
      updateMessage: _updateChatMessage,
      callAi: _callAssistant,
      loadRecentMealsText: _recentMealsText,
      recordUsage: _recordChatUsage,
      now: () => getCurrentTimestamp,
      canSend: _canUseChat,
    );
    return controller.send(
      userMessage: userMessage,
      type: type,
      currentDish: currentDish,
    );
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
        body: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 600.0,
                ),
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final chatMessage = FFAppState().chathistory;

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          135.0,
                          0,
                          180.0,
                        ),
                        cacheExtent: 600.0,
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        itemCount: chatMessage.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.0),
                        itemBuilder: (context, chatMessageIndex) {
                          final sourceIndex =
                              chatMessage.length - 1 - chatMessageIndex;
                          final chatMessageItem =
                              ChatHistoryView.messageAtReverseIndex(
                            chatMessage,
                            chatMessageIndex,
                          );
                          return RepaintBoundary(
                            child: MessWidget(
                              key: ValueKey(ChatHistoryView.stableMessageKey(
                                chatMessageItem,
                                fallbackIndex: sourceIndex,
                              )),
                              mess: chatMessageItem,
                              acton: (type, text) async {
                                await _sendChatMessage(
                                  userMessage: text,
                                  type: type,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00F2F2F7),
                      Color(0xCCF2F2F7),
                      Color(0xFFF2F2F7)
                    ],
                    stops: [0.0, 0.66, 1.0],
                    begin: AlignmentDirectional(0.0, -1.0),
                    end: AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          6.0,
                          12.0,
                          6.0,
                          valueOrDefault<double>(
                            widget.dish != null ? 35.0 : 6.0,
                            6.0,
                          )),
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        children: [
                          if (_model.dish != null)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(21.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 8.0, 8.0, 50.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 6.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              '${valueOrDefault<String>(
                                                _model.dish?.dishName,
                                                '-',
                                              )} • ${_model.dish?.kcal.toString()} kcal',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'SF Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    fontSize: 14.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FlutterFlowIconButton(
                                        borderRadius: 20.0,
                                        borderWidth: 0.0,
                                        buttonSize: 32.0,
                                        icon: Icon(
                                          Icons.close,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 18.0,
                                        ),
                                        onPressed: () async {
                                          _model.dish = null;
                                          _model.string = null;
                                          safeSetState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: 48.0,
                              maxHeight: 210.0,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 8.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Builder(
                                      builder: (context) => Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model.textController,
                                          focusNode: _model.textFieldFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.textController',
                                            Duration(milliseconds: 0),
                                            () => safeSetState(() {}),
                                          ),
                                          onFieldSubmitted: (_) async {
                                            var _shouldSetState = false;
                                            if (_canUseChat()) {
                                              final userMessage =
                                                  _model.textController.text;
                                              safeSetState(() {
                                                _model.textController?.clear();
                                              });
                                              await _sendChatMessage(
                                                userMessage: userMessage,
                                                type: 'message',
                                              );
                                              _shouldSetState = true;
                                            } else {
                                              if (_hasPremium == true) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'limit exceeded',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
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
                                          autofocus: false,
                                          textInputAction: TextInputAction.send,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Message',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'SF Pro',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                      lineHeight: 1.0,
                                                    ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 12.0, 0.0, 12.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                                lineHeight: 1.0,
                                              ),
                                          maxLines: null,
                                          minLines: 1,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .textControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) => FlutterFlowIconButton(
                                      borderRadius: 20.0,
                                      borderWidth: 0.0,
                                      buttonSize: 32.0,
                                      fillColor: valueOrDefault<Color>(
                                        _model.textController.text != ''
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .alternate,
                                        FlutterFlowTheme.of(context).alternate,
                                      ),
                                      disabledColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      disabledIconColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: _model.textController.text != ''
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        size: 14.0,
                                      ),
                                      onPressed: (_model.textController.text ==
                                              '')
                                          ? null
                                          : () async {
                                              var _shouldSetState = false;
                                              if (_canUseChat()) {
                                                final userMessage =
                                                    _model.textController.text;
                                                final currentDish =
                                                    _model.string != null &&
                                                            _model.string != ''
                                                        ? _model.string
                                                        : null;
                                                safeSetState(() {
                                                  _model.textController
                                                      ?.clear();
                                                });
                                                await _sendChatMessage(
                                                  userMessage: userMessage,
                                                  type: currentDish == null
                                                      ? 'message'
                                                      : 'message_dish',
                                                  currentDish: currentDish,
                                                );
                                                _shouldSetState = true;
                                              } else {
                                                if (_chatLimitDecision()
                                                    .premiumIncludedQuotaReached) {
                                                  await showDialog(
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
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!(isWeb
                            ? MediaQuery.viewInsetsOf(context).bottom > 0
                            : _isKeyboardVisible) &&
                        (widget.dish == null))
                      wrapWithModel(
                        model: _model.navBarModel,
                        updateCallback: () => safeSetState(() {}),
                        child: NavBarWidget(
                          activePage: 'Chat',
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
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 55.0, 12.0, 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: _model.dish != null ? 1.0 : 0.0,
                      child: Container(
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
                    ),
                    Text(
                      'RealTalk with Elena',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                        icon: FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: FlutterFlowTheme.of(context).error,
                          size: 16.0,
                        ),
                        onPressed: () async {
                          FFAppState().chathistory = [];
                          safeSetState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
