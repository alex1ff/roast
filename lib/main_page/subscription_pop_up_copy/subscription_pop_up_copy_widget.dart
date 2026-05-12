import '/auth/firebase_auth/auth_util.dart';
import '/components/limit_reached_popup/limit_reached_popup_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/sub_plan_copy.dart';
import 'package:flutter/material.dart';
import 'subscription_pop_up_copy_model.dart';
export 'subscription_pop_up_copy_model.dart';

class SubscriptionPopUpCopyWidget extends StatefulWidget {
  const SubscriptionPopUpCopyWidget({super.key});

  @override
  State<SubscriptionPopUpCopyWidget> createState() =>
      _SubscriptionPopUpCopyWidgetState();
}

class _SubscriptionPopUpCopyWidgetState
    extends State<SubscriptionPopUpCopyWidget> {
  late SubscriptionPopUpCopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPopUpCopyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = currentUserDocument?.subPlan;
    return LimitReachedPopup(
      title: SubPlanCopy.quotaReachedTitle(plan),
      body: SubPlanCopy.quotaReachedBody(plan),
      ctaText: 'Get Roast Reload Pack',
      routeName: RoastReloadPackWidget.routeName,
    );
  }
}
