import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/legal/terms_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'term_model.dart';
export 'term_model.dart';

class TermWidget extends StatefulWidget {
  const TermWidget({super.key});

  static String routeName = 'term';
  static String routePath = '/term';

  @override
  State<TermWidget> createState() => _TermWidgetState();
}

class _TermWidgetState extends State<TermWidget> {
  late TermModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF2F2F7),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MarkdownBody(
                                data: termsMarkdown,
                                selectable: true,
                                onTapLink: (_, url, __) => launchURL(url!),
                              ),
                            ]
                                .addToStart(SizedBox(height: 125.0))
                                .addToEnd(SizedBox(height: 100.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).secondaryBackground,
                          Color(0xF2F2F2F7),
                          Color(0x00F2F2F7)
                        ],
                        stops: [0.0, 0.8, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 55.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7.0,
                                  color: Color(0x0D2C2C2C),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: FlutterFlowIconButton(
                              borderRadius: 70.0,
                              buttonSize: 45.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 14.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ),
                          Text(
                            'TERMS OF USE (EULA)',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
