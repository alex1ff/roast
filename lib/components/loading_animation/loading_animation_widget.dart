import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'loading_animation_model.dart';
export 'loading_animation_model.dart';

class LoadingAnimationWidget extends StatefulWidget {
  const LoadingAnimationWidget({
    super.key,
    this.roastMode = FFAppConstants.roastModeRoast,
    this.subjectType = FFAppConstants.subjectTypeDish,
  });

  final String roastMode;
  final String subjectType;

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationCopy {
  const _LoadingAnimationCopy({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget> {
  late LoadingAnimationModel _model;

  _LoadingAnimationCopy get _copy {
    final roastMode = widget.roastMode.trim().toLowerCase();
    final subjectType = widget.subjectType.trim().toLowerCase();

    if (roastMode == FFAppConstants.roastModeCongratuRoast) {
      return const _LoadingAnimationCopy(
        title: "We're figuring out what you've just unleashed upon us...",
        subtitle:
            'The parody character is searching for something nice to say. So far, no luck.',
      );
    }

    if (subjectType == FFAppConstants.subjectTypePerson) {
      return const _LoadingAnimationCopy(
        title: "We're figuring out what you've just unleashed upon us...",
        subtitle: 'The parody character is sharpening its tongue.',
      );
    }

    if (subjectType == FFAppConstants.subjectTypeOther) {
      return const _LoadingAnimationCopy(
        title: "We're figuring out what you've just unleashed upon us...",
        subtitle: 'The parody character is sizing up the target.',
      );
    }

    return const _LoadingAnimationCopy(
      title: '🍳 Decoding your dish...',
      subtitle:
          'We’re figuring out what’s on your plate and turning it into a full nutritional breakdown. Almost there!',
    );
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingAnimationModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 15000,
        ),
      );
      _model.exitOK = true;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = _copy;

    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (_model.exitOK)
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 35.0, 0.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 45.0,
                  icon: Icon(
                    Icons.close,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(
                      HomeWidget.routeName,
                      extra: <String, dynamic>{
                        '__transition_info__': TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    _model.exitOK = false;
                    safeSetState(() {});
                  },
                ),
              ),
            ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/jsons/fire_(1).json',
                    width: 160.0,
                    height: 160.0,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: copy.title,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'SF Pro',
                                  fontSize: 21.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  lineHeight: 1.5,
                                ),
                          ),
                          TextSpan(
                            text: '\n${copy.subtitle}',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          )
                        ],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro',
                              fontSize: 17.0,
                              letterSpacing: 0.0,
                              lineHeight: 1.5,
                            ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
