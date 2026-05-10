import '/components/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'statistics_widget.dart' show StatisticsWidget;
import 'package:flutter/material.dart';

class StatisticsModel extends FlutterFlowModel<StatisticsWidget> {
  ///  Local state fields for this page.

  DateTime? day;

  DateTime? month;

  ///  State fields for stateful widgets in this page.

  // Model for NavBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    navBarModel.dispose();
  }
}
