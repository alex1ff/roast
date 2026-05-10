import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'subscribe_completed_model.dart';
export 'subscribe_completed_model.dart';

class SubscribeCompletedWidget extends StatefulWidget {
  const SubscribeCompletedWidget({super.key});

  @override
  State<SubscribeCompletedWidget> createState() =>
      _SubscribeCompletedWidgetState();
}

class _SubscribeCompletedWidgetState extends State<SubscribeCompletedWidget> {
  late SubscribeCompletedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribeCompletedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Lottie.asset(
            'assets/jsons/fire_(1).json',
            width: 160.0,
            height: 160.0,
            fit: BoxFit.contain,
            animate: true,
          ),
          Text(
            'Thank you for \nyour subscription!',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'SF Pro',
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 35.0),
            child: FFButtonWidget(
              onPressed: () async {
                Navigator.pop(context);
                context.safePop();
              },
              text: 'Keep Roasting',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(12.0),
              ),
              showLoadingIndicator: false,
            ),
          ),
        ],
      ),
    );
  }
}
