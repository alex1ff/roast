import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'request_processed_model.dart';
export 'request_processed_model.dart';

/// Пока грузится инфа
class RequestProcessedWidget extends StatefulWidget {
  const RequestProcessedWidget({super.key});

  @override
  State<RequestProcessedWidget> createState() => _RequestProcessedWidgetState();
}

class _RequestProcessedWidgetState extends State<RequestProcessedWidget> {
  late RequestProcessedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RequestProcessedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              'https://images.unsplash.com/photo-1607434472257-d9f8e57a643d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxsb2FkaW5nfGVufDB8fHx8MTczOTM2NDY0MHww&ixlib=rb-4.0.3&q=80&w=1080',
              width: 102.0,
              height: 102.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
          child: Text(
            'Your request is being processed...',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF Pro',
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    );
  }
}
