import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'universal_picker_model.dart';
export 'universal_picker_model.dart';

class UniversalPickerWidget extends StatefulWidget {
  const UniversalPickerWidget({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onSelected,
  });

  final List<String>? options;
  final String? initialValue;
  final Future Function(String? value)? onSelected;

  @override
  State<UniversalPickerWidget> createState() => _UniversalPickerWidgetState();
}

class _UniversalPickerWidgetState extends State<UniversalPickerWidget> {
  late UniversalPickerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UniversalPickerModel());

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
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: custom_widgets.UniversalPicker(
          width: double.infinity,
          height: double.infinity,
          initialValue: widget.initialValue,
          options: widget.options!,
          onSelected: (value) async {
            await widget.onSelected?.call(
              value,
            );
          },
        ),
      ),
    );
  }
}
