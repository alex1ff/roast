import '/auth/firebase_auth/auth_util.dart';
import '/components/subscribe_completed_copy_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/purchase_ui_helpers.dart';
import '/services/sub_plan_copy.dart';
import '/services/user_account_mutations.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'roast_reload_pack_model.dart';
export 'roast_reload_pack_model.dart';

class RoastReloadPackWidget extends StatefulWidget {
  const RoastReloadPackWidget({super.key});

  static String routeName = 'RoastReloadPack';
  static String routePath = '/roastReloadPack';

  @override
  State<RoastReloadPackWidget> createState() => _RoastReloadPackWidgetState();
}

class _RoastReloadPackWidgetState extends State<RoastReloadPackWidget> {
  static const _reloadPackPackage = 'Roast_Reload_Pack';

  late RoastReloadPackModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCatalogLoading = true;

  Future<bool> _ensureReloadPackReady() async {
    if (revenue_cat.getPackage(_reloadPackPackage) != null ||
        revenue_cat.getStoreProduct(_reloadPackPackage) != null) {
      return true;
    }

    await _loadPurchaseCatalog();
    if (!mounted) {
      return false;
    }

    if (revenue_cat.getPackage(_reloadPackPackage) != null ||
        revenue_cat.getStoreProduct(_reloadPackPackage) != null) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchases are still loading. Please try again shortly.'),
      ),
    );
    return false;
  }

  Future<void> _loadPurchaseCatalog() async {
    safeSetState(() {
      _isCatalogLoading = true;
    });
    try {
      await revenue_cat.ensureStoreProductsLoaded(
        const [_reloadPackPackage],
        productCategory: revenue_cat.ProductCategory.nonSubscription,
      ).timeout(const Duration(seconds: 20));
    } catch (_) {
      // RevenueCat logs the concrete cause; keep the page usable.
    }
    if (!mounted) {
      return;
    }
    safeSetState(() {
      _isCatalogLoading = false;
    });
  }

  String _priceText(String packageId) {
    return revenue_cat.packagePriceString(
      packageId,
      loadingText: _isCatalogLoading ? 'Loading...' : 'Unavailable',
      unavailableText: 'Unavailable',
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RoastReloadPackModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.lockOrientation();
      await _loadPurchaseCatalog();
    });
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: SubPlanCopy.reloadPackIntro(
                                              currentUserDocument?.subPlan),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'SF Pro',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              '• 21 Photo Analyses\n\n• 7 No-Photo Analyses\n\n• 25 Chat Questions',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        )
                                      ],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'SF Pro',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 32.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 0.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Extra Pack',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'SF Pro',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: _priceText(
                                                    _reloadPackPackage),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'SF Pro',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'SF Pro',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 32.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (!await _ensureReloadPackReady()) {
                                      return;
                                    }
                                    _model.reload =
                                        await revenue_cat.purchasePackage(
                                      _reloadPackPackage,
                                      productCategory: revenue_cat
                                          .ProductCategory.nonSubscription,
                                    );
                                    if (_model.reload!) {
                                      final reloadSync =
                                          await UserAccountMutations
                                              .syncReloadPackPurchase();
                                      if (!reloadSync.success) {
                                        showPurchaseSyncFailedSnackBar(
                                          context,
                                          message:
                                              'Purchase completed, but reload pack sync failed. Please try again.',
                                        );
                                        safeSetState(() {});
                                        return;
                                      }
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child:
                                                  SubscribeCompletedCopyWidget(),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));

                                      return;
                                    } else {
                                      return;
                                    }
                                  },
                                  text: 'Get Roast Reload Pack',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'SF Pro',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 15.0, 12.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'By subscribing, you agree to our',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'SF Pro',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' Terms of Use (EULA) ',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        mouseCursor: SystemMouseCursors.click,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            context.pushNamed(
                                                TermWidget.routeName);
                                          },
                                      ),
                                      TextSpan(
                                        text: '\nand',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text: ' Privacy Policy. ',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        mouseCursor: SystemMouseCursors.click,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            context.pushNamed(
                                                PoliWidget.routeName);
                                          },
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SF Pro',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 15.0, 12.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'One-time purchase. Credits don’t expire.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'SF Pro',
                                              letterSpacing: 0.0,
                                            ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SF Pro',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
                            'Roast Reload Pack',
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
