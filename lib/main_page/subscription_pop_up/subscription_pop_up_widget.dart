import '/components/limit_reached_popup/limit_reached_popup_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'subscription_pop_up_model.dart';
export 'subscription_pop_up_model.dart';

class SubscriptionPopUpWidget extends StatefulWidget {
  const SubscriptionPopUpWidget({super.key});

  @override
  State<SubscriptionPopUpWidget> createState() =>
      _SubscriptionPopUpWidgetState();
}

class _SubscriptionPopUpWidgetState extends State<SubscriptionPopUpWidget> {
  late SubscriptionPopUpModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPopUpModel());

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
      title: 'Looks like you’ve reached your free limit',
      body: 'You get 3 free AI requests total. Subscribe to keep roasting.',
      ctaText: 'Subscribe Now',
      routeName: SubscriptionPageWidget.routeName,
    );
  }
}
