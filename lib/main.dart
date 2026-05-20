import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/revenue_cat_util.dart' as revenue_cat;
import 'services/error_reporter.dart';
import 'services/performance_monitor.dart';

const _revenueCatAppStoreKey = String.fromEnvironment(
  'REVENUECAT_APPSTORE_API_KEY',
  defaultValue: 'appl_CRQXxTGBsBRSaHVqIfPgqnbkoqR',
);
const _revenueCatPlayStoreKey =
    String.fromEnvironment('REVENUECAT_PLAYSTORE_API_KEY');
const _revenueCatWebKey = String.fromEnvironment('REVENUECAT_WEB_API_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Silence developer logs in release builds so debugPrint calls scattered
  // across the codebase don't reach production logcat / Console output.
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  AppErrorReporter.installGlobalHandlers();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));

  unawaited(_initializeRevenueCat());
}

Future<void> _initializeRevenueCat() async {
  await AppPerformanceMonitor.trace<void>(
    name: 'revenuecat_init',
    attributes: const {
      'load_data_after_launch': 'true',
    },
    action: () => revenue_cat.initialize(
      _revenueCatAppStoreKey,
      _revenueCatPlayStoreKey,
      webKey: _revenueCatWebKey,
      debugLogEnabled: kDebugMode,
      loadDataAfterLaunch: true,
    ),
  );

  if (currentUserUid.isNotEmpty) {
    await AppPerformanceMonitor.trace<void>(
      name: 'revenuecat_login',
      action: () => revenue_cat.login(currentUserUid),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late final StreamSubscription<dynamic> _authUserSub;
  late final StreamSubscription<BaseAuthUser> _userSub;
  late final StreamSubscription<dynamic> _jwtTokenSub;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    _authUserSub = authenticatedUserStream.listen((user) {
      unawaited(revenue_cat.login(user?.uid));
    });
    userStream = roastThemAllFirebaseUserStream();
    _userSub = userStream.listen((user) {
      _appStateNotifier.update(user);
    });
    _jwtTokenSub = jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      unawaited(FFAppState().flushChatHistoryPersistence());
    }
  }

  @override
  void dispose() {
    unawaited(FFAppState().flushChatHistoryPersistence());
    WidgetsBinding.instance.removeObserver(this);
    _authUserSub.cancel();
    _userSub.cancel();
    _jwtTokenSub.cancel();

    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Roast Them All',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
