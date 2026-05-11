import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

const Color profileSwitchThumbColor = Colors.white;
const Color profileSwitchActiveTrackColor = Color(0xFF34C759);
const Color profileSwitchInactiveTrackColor = Color(0xFFE5E5EA);

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.0,
      thickness: 1.0,
      indent: 12.0,
      endIndent: 12.0,
      color: FlutterFlowTheme.of(context).alternate,
    );
  }
}

class ProfilePickerRow extends StatelessWidget {
  const ProfilePickerRow({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.valueLeftPadding = 8.0,
    this.iconColor,
    this.iconSize = 24.0,
  });

  final String title;
  final Widget value;
  final Future<void> Function() onTap;
  final double valueLeftPadding;
  final Color? iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        color: FlutterFlowTheme.of(context).textfieldsText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    valueLeftPadding, 0.0, 0.0, 0.0),
                child: value,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                child: Icon(
                  Icons.unfold_more,
                  color: iconColor ?? FlutterFlowTheme.of(context).listPicker,
                  size: iconSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileUnitSwitchTile extends StatelessWidget {
  const ProfileUnitSwitchTile({
    super.key,
    required this.leftLabel,
    required this.switchWidget,
    required this.rightLabel,
    this.mainAxisSize = MainAxisSize.max,
  });

  final String leftLabel;
  final Widget switchWidget;
  final String rightLabel;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final labelStyle = FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'SF Pro',
          fontSize: 16.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.normal,
        );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
        child: Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leftLabel,
              style: labelStyle,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
              child: switchWidget,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
              child: Text(
                rightLabel,
                style: labelStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
