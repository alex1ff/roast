import '/components/subscribe_completed_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/purchase_ui_helpers.dart';
import '/services/user_account_mutations.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'subscription_page_model.dart';
export 'subscription_page_model.dart';

class SubscriptionPageWidget extends StatefulWidget {
  const SubscriptionPageWidget({super.key});

  static String routeName = 'SubscriptionPage';
  static String routePath = '/subscriptionPage';

  @override
  State<SubscriptionPageWidget> createState() => _SubscriptionPageWidgetState();
}

class _SubscriptionPageWidgetState extends State<SubscriptionPageWidget> {
  static const _weeklyPackage = 'roast_99_1week';
  static const _monthlyPackage = 'roast_9_1Month';
  static const _yearlyPackage = 'roast_99_1year';

  late SubscriptionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCatalogLoading = true;
  bool _catalogLoadFailed = false;

  String get _selectedPackageId {
    switch (_model.subType) {
      case 'week':
        return _weeklyPackage;
      case 'month':
        return _monthlyPackage;
      case 'year':
      default:
        return _yearlyPackage;
    }
  }

  Future<bool> _ensureSelectedPackageReady() async {
    if (revenue_cat.getPackage(_selectedPackageId) != null) {
      return true;
    }

    await _loadPurchaseCatalog();
    if (!mounted) {
      return false;
    }

    if (revenue_cat.getPackage(_selectedPackageId) != null) {
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
      _catalogLoadFailed = false;
    });
    try {
      await revenue_cat
          .ensureOfferingsLoaded()
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      // The UI below shows a retry state; RevenueCat logs the concrete cause.
    }
    if (!mounted) {
      return;
    }
    safeSetState(() {
      _isCatalogLoading = false;
      _catalogLoadFailed = revenue_cat.offerings?.current == null;
    });
  }

  String _priceText(String packageId) {
    if (revenue_cat.offerings?.current == null) {
      return _isCatalogLoading ? 'Loading...' : 'Retry';
    }
    return revenue_cat.packagePriceString(
      packageId,
      unavailableText: 'Unavailable',
    );
  }

  Widget _buildCatalogStatus(BuildContext context) {
    if (!_catalogLoadFailed || revenue_cat.offerings?.current != null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  revenue_cat.isConfigured
                      ? 'Could not load App Store prices.'
                      : 'Purchases are unavailable in this build.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              TextButton(
                onPressed: _loadPurchaseCatalog,
                child: Text(
                  'Retry',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPageModel());

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
                                          text:
                                              'Get the most out of Roast Them All, your arrogant dining companion:\n\n',
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
                                              '• Instant photo and dish based AI analysis of meals\n\n• Roasty Roasts from cult icons and legendary celebs\n\n• Personalized Smart AI chat with Attitude that knows exactly how you eat\n\n• Calorie saving tips without overhauling your diet',
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
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.subType = 'week';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: _model.subType == 'week'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Weekly Subscription',
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
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Text(
                                                  'Up to 8 requests per day',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: _priceText(
                                                      _weeklyPackage),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: ' \n/per week',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.0,
                                                  ),
                                                )
                                              ],
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.subType = 'month';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: _model.subType == 'month'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Monthly Subscription',
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
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Text(
                                                  'Up to 8 requests per day',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: _priceText(
                                                      _monthlyPackage),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: ' \n/per month',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.0,
                                                  ),
                                                )
                                              ],
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.subType = 'year';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: _model.subType == 'year'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Annual Subscription',
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
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Text(
                                                  'Up to 8 requests per day',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: _priceText(
                                                      _yearlyPackage),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: '\n/per year',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.0,
                                                  ),
                                                )
                                              ],
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: _buildCatalogStatus(context),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0,
                                    _catalogLoadFailed ? 20.0 : 32.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    var _shouldSetState = false;
                                    if (!await _ensureSelectedPackageReady()) {
                                      return;
                                    }
                                    if (_model.subType == 'year') {
                                      _model.yearly = await revenue_cat
                                          .purchasePackage(_yearlyPackage);
                                      _shouldSetState = true;
                                      if (_model.yearly!) {
                                        final subscriptionSync =
                                            await UserAccountMutations
                                                .syncRevenueCatSubscription();
                                        if (!subscriptionSync.success) {
                                          showPurchaseSyncFailedSnackBar(
                                            context,
                                            message:
                                                'Purchase completed, but subscription sync failed. Please try again.',
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child:
                                                    SubscribeCompletedWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    } else if (_model.subType == 'week') {
                                      _model.weekly = await revenue_cat
                                          .purchasePackage(_weeklyPackage);
                                      _shouldSetState = true;
                                      if (_model.weekly!) {
                                        final subscriptionSync =
                                            await UserAccountMutations
                                                .syncRevenueCatSubscription();
                                        if (!subscriptionSync.success) {
                                          showPurchaseSyncFailedSnackBar(
                                            context,
                                            message:
                                                'Purchase completed, but subscription sync failed. Please try again.',
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child:
                                                    SubscribeCompletedWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    } else {
                                      _model.monthly = await revenue_cat
                                          .purchasePackage(_monthlyPackage);
                                      _shouldSetState = true;
                                      if (_model.monthly!) {
                                        final subscriptionSync =
                                            await UserAccountMutations
                                                .syncRevenueCatSubscription();
                                        if (!subscriptionSync.success) {
                                          showPurchaseSyncFailedSnackBar(
                                            context,
                                            message:
                                                'Purchase completed, but subscription sync failed. Please try again.',
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        }
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child:
                                                    SubscribeCompletedWidget(),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        return;
                                      }
                                    }
                                  },
                                  text: 'Subscribe now',
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
                                    0.0, 40.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    await revenue_cat.restorePurchases();
                                  },
                                  text: 'Restore purchases',
                                  options: FFButtonOptions(
                                    height: 45.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Colors.transparent,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'SF Pro',
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
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
                            'Plan. Snap. Roast. Repeat.',
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
