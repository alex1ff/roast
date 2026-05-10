import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dish_info_widget.dart' show DishInfoWidget;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DishInfoModel extends FlutterFlowModel<DishInfoWidget> {
  ///  Local state fields for this page.

  bool editMode = false;

  List<String> ingredientsEdit = [];
  void addToIngredientsEdit(String item) => ingredientsEdit.add(item);
  void removeFromIngredientsEdit(String item) => ingredientsEdit.remove(item);
  void removeAtIndexFromIngredientsEdit(int index) =>
      ingredientsEdit.removeAt(index);
  void insertAtIndexInIngredientsEdit(int index, String item) =>
      ingredientsEdit.insert(index, item);
  void updateIngredientsEditAtIndex(int index, Function(String) updateFn) =>
      ingredientsEdit[index] = updateFn(ingredientsEdit[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - createRoastShareLink] action in DishInfo widget.
  String? link;
  // State field(s) for TextFieldw widget.
  FocusNode? textFieldwFocusNode;
  TextEditingController? textFieldwTextController;
  String? Function(BuildContext, String?)? textFieldwTextControllerValidator;
  AudioPlayer? soundPlayer1;
  // Stores action output result for [AI Agent - Send Message to roast] action in Button widget.
  Map<String, dynamic>? roast;
  // Stores action output result for [Backend Call - API (TextToSpeech)] action in Button widget.
  ApiCallResponse? audioResultt2;
  AudioPlayer? soundPlayer2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [AI Agent - Send Message to roast] action in IconButton widget.
  Map<String, dynamic>? reroas;
  // Stores action output result for [Backend Call - API (TextToSpeech)] action in IconButton widget.
  ApiCallResponse? audioResultt22;
  AudioPlayer? soundPlayer3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldwFocusNode?.dispose();
    textFieldwTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
