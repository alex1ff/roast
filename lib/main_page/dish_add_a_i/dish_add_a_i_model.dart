import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dish_add_a_i_widget.dart' show DishAddAIWidget;
import 'package:flutter/material.dart';

class DishAddAIModel extends FlutterFlowModel<DishAddAIWidget> {
  ///  Local state fields for this page.

  bool photoCheckRequestActive = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for dishName widget.
  FocusNode? dishNameFocusNode;
  TextEditingController? dishNameTextController;
  String? Function(BuildContext, String?)? dishNameTextControllerValidator;
  // State field(s) for restaurant widget.
  FocusNode? restaurantFocusNode;
  TextEditingController? restaurantTextController;
  String? Function(BuildContext, String?)? restaurantTextControllerValidator;
  // State field(s) for dishWeight widget.
  FocusNode? dishWeightFocusNode;
  TextEditingController? dishWeightTextController;
  String? Function(BuildContext, String?)? dishWeightTextControllerValidator;
  bool isDataUploading_uploadedPhoto2 = false;
  FFUploadedFile uploadedLocalFile_uploadedPhoto2 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadedPhoto2 = '';

  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    dishNameFocusNode?.dispose();
    dishNameTextController?.dispose();

    restaurantFocusNode?.dispose();
    restaurantTextController?.dispose();

    dishWeightFocusNode?.dispose();
    dishWeightTextController?.dispose();

    navBarModel.dispose();
  }
}
