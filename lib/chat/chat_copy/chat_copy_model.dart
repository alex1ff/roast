import '/backend/backend.dart';
import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_copy_widget.dart' show ChatCopyWidget;
import 'package:flutter/material.dart';

class ChatCopyModel extends FlutterFlowModel<ChatCopyWidget> {
  ///  Local state fields for this page.

  AddedDishHistoryRecord? dish;

  String? string;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in ChatCopy widget.
  List<AddedDishHistoryRecord>? hist;
  // Stores action output result for [AI Agent - Send Message to AIAssistent] action in mess widget.
  String? agentResponse3;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [AI Agent - Send Message to AIAssistent] action in TextField widget.
  String? agentResponse4;
  // Stores action output result for [AI Agent - Send Message to AIAssistent] action in IconButton widget.
  String? agentResponse;
  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    navBarModel.dispose();
  }
}
