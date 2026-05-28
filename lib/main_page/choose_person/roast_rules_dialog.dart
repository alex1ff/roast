import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/legal/terms_markdown.dart';

/// Full-screen rules acceptance dialog shown before the first roast
/// generation. The accept button stays disabled until the user scrolls
/// to the very bottom of the rules.
class RoastRulesDialog extends StatefulWidget {
  const RoastRulesDialog({super.key});

  static const String rulesMarkdown = termsMarkdown;

  /// Shows the rules dialog. Returns `true` if the user accepted.
  /// If rules were already accepted earlier, returns `true` immediately
  /// without showing the dialog.
  static Future<bool> ensureAccepted(BuildContext context) async {
    if (FFAppState().acceptedRoastRules) {
      return true;
    }
    final accepted = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'rules',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, _, __) => const RoastRulesDialog(),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: child,
      ),
    );
    return accepted == true;
  }

  @override
  State<RoastRulesDialog> createState() => _RoastRulesDialogState();
}

class _RoastRulesDialogState extends State<RoastRulesDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _reachedBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If content fits on screen — allow accepting immediately.
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        if (mounted) setState(() => _reachedBottom = true);
      }
    });
  }

  void _onScroll() {
    if (_reachedBottom) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 8.0) {
      setState(() => _reachedBottom = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 70.0, 16.0, 100.0),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: MarkdownBody(
                        data: RoastRulesDialog.rulesMarkdown,
                        selectable: true,
                        onTapLink: (_, url, __) {
                          if (url != null) launchURL(url);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Top header with gradient fade
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.secondaryBackground,
                        const Color(0xF2F2F2F7),
                        const Color(0x00F2F2F7),
                      ],
                      stops: const [0.0, 0.8, 1.0],
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 16.0, 16.0, 16.0),
                  child: Text(
                    'TERMS OF USE (EULA)',
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium.override(
                      fontFamily: 'SF Pro',
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Bottom fixed accept button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0x00F2F2F7),
                        const Color(0xF2F2F2F7),
                        theme.secondaryBackground,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 24.0, 16.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_reachedBottom)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Scroll to the end to enable accept',
                            style: theme.bodyMedium.override(
                              fontFamily: 'SF Pro',
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                              color: theme.secondaryText,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 52.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _reachedBottom
                                ? theme.primary
                                : theme.primary.withValues(alpha: 0.4),
                            disabledBackgroundColor:
                                theme.primary.withValues(alpha: 0.4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          onPressed: _reachedBottom
                              ? () {
                                  FFAppState().acceptedRoastRules = true;
                                  Navigator.of(context).pop(true);
                                }
                              : null,
                          child: Text(
                            'I accept',
                            style: theme.bodyMedium.override(
                              fontFamily: 'SF Pro',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
