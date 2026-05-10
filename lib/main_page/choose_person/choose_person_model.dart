import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'choose_person_widget.dart' show ChoosePersonWidget;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ChoosePersonModel extends FlutterFlowModel<ChoosePersonWidget> {
  ///  Local state fields for this component.

  bool remember = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [AI Agent - Send Message to roast] action in Button widget.
  Map<String, dynamic>? roast;
  // Stores action output result for [Backend Call - API (TextToSpeech)] action in Button widget.
  ApiCallResponse? audioResultt;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AddedDishHistoryRecord? createdDocument;
  AudioPlayer? soundPlayer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
