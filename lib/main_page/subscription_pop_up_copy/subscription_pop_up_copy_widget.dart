import '/components/limit_reached_popup/limit_reached_popup_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
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
    return LimitReachedPopup(
      title: 'Monthly Roasts Finished',
      body:
          'We love that you’re using Roast. Your monthly roasts are finished, but your appetite clearly isn’t. Get Roast Reload Pack and keep the heat on.',
      ctaText: 'Get Roast Reload Pack',
      routeName: RoastReloadPackWidget.routeName,
    );
  }
}
