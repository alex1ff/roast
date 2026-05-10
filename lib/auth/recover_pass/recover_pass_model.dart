import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'recover_pass_widget.dart' show RecoverPassWidget;
import 'package:flutter/material.dart';

class RecoverPassModel extends FlutterFlowModel<RecoverPassWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
