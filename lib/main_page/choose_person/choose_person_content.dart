import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class ChoosePersonContent extends StatelessWidget {
  const ChoosePersonContent({
    super.key,
    required this.persons,
    required this.dropDownController,
    required this.onVoiceChanged,
    required this.checkboxValue,
    required this.onCheckboxChanged,
    required this.onStartPressed,
  });

  final List<PersonsRecord> persons;
  final FormFieldController<String> dropDownController;
  final ValueChanged<String?> onVoiceChanged;
  final bool checkboxValue;
  final ValueChanged<bool?> onCheckboxChanged;
  final Function()? onStartPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: 600.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondary,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Text(
                'Choose roast character',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
              child: FlutterFlowDropDown<String>(
                controller: dropDownController,
                options: List<String>.from(persons.map((e) => e.voiceId)),
                optionLabels: persons.map((e) => e.name).toList(),
                onChanged: onVoiceChanged,
                height: 45.0,
                maxHeight: 360.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
                hintText: 'Choose a voice character',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                elevation: 2.0,
                borderColor: FlutterFlowTheme.of(context).divider,
                borderWidth: 1.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(40.0),
                  thickness: WidgetStateProperty.all<double>(4.0),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                  thumbColor: WidgetStateProperty.all<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
                hidesUnderline: true,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData(
                      checkboxTheme: CheckboxThemeData(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                      unselectedWidgetColor:
                          FlutterFlowTheme.of(context).alternate,
                    ),
                    child: Checkbox(
                      value: checkboxValue,
                      onChanged: onCheckboxChanged,
                      side: BorderSide(
                        width: 2,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      activeColor: FlutterFlowTheme.of(context).primary,
                      checkColor: FlutterFlowTheme.of(context).info,
                    ),
                  ),
                  Text(
                    'Remember my choice',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: onStartPressed,
                  text: 'Start roasting!',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'SF Pro',
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                    disabledColor: Color(0x56FFA07A),
                    disabledTextColor:
                        FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
