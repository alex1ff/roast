import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_bar_copy_model.dart';
export 'nav_bar_copy_model.dart';

class NavBarCopyWidget extends StatefulWidget {
  const NavBarCopyWidget({
    super.key,
    required this.activePage,
  });

  final String? activePage;

  @override
  State<NavBarCopyWidget> createState() => _NavBarCopyWidgetState();
}

class _NavBarCopyWidgetState extends State<NavBarCopyWidget> {
  late NavBarCopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavBarCopyModel());
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 25.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _NavBarItem(
              activePage: widget.activePage,
              pageKey: 'Profile',
              routeName: ProfileWidget.routeName,
              label: 'Profile',
              activeAsset:
                  'assets/images/Property_1=30,_Property_2=user-edit,_Property_3=green.svg',
              inactiveAsset:
                  'assets/images/Property_1=24,_Property_2=user-edit.webp',
              activeAssetIsSvg: true,
            ),
            _NavBarItem(
              activePage: widget.activePage,
              pageKey: 'Add',
              routeName: DishAddAIWidget.routeName,
              label: 'Roast Them',
              activeAsset:
                  'assets/images/Property_1=30,_Property_2=camera,_Property_3=green.svg',
              inactiveAsset:
                  'assets/images/Property_1=24,_Property_2=camera.webp',
              activeAssetIsSvg: true,
              topPadding: 3.0,
            ),
            _NavBarItem(
              activePage: widget.activePage,
              pageKey: 'Home',
              routeName: HomeWidget.routeName,
              label: 'Home',
              activeAsset:
                  'assets/images/Property_1=30,_Property_2=home,_Property_3=green.svg',
              inactiveAsset:
                  'assets/images/Property_1=24,_Property_2=home.webp',
              activeAssetIsSvg: true,
            ),
            _NavBarItem(
              activePage: widget.activePage,
              pageKey: 'Chat',
              routeName: ChatCopyWidget.routeName,
              label: 'Chat',
              activeAsset: 'assets/images/ChatOn.png',
              inactiveAsset: 'assets/images/ChatOff.png',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.activePage,
    required this.pageKey,
    required this.routeName,
    required this.label,
    required this.activeAsset,
    required this.inactiveAsset,
    this.activeAssetIsSvg = false,
    this.topPadding = 0.0,
  });

  final String? activePage;
  final String pageKey;
  final String routeName;
  final String label;
  final String activeAsset;
  final String inactiveAsset;
  final bool activeAssetIsSvg;
  final double topPadding;

  bool get isActive => activePage == pageKey;

  @override
  Widget build(BuildContext context) {
    final item = InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (isActive) {
          return;
        }
        context.goNamed(
          routeName,
          extra: <String, dynamic>{
            '__transition_info__': const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavBarIcon(
            asset: isActive ? activeAsset : inactiveAsset,
            isSvg: isActive && activeAssetIsSvg,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
        ],
      ),
    );

    return Expanded(
      child: topPadding > 0
          ? Padding(
              padding:
                  EdgeInsetsDirectional.fromSTEB(0.0, topPadding, 0.0, 0.0),
              child: item,
            )
          : item,
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  const _NavBarIcon({
    required this.asset,
    required this.isSvg,
  });

  final String asset;
  final bool isSvg;

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return SvgPicture.asset(
        asset,
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      asset,
      width: 30.0,
      height: 30.0,
      fit: BoxFit.cover,
    );
  }
}
