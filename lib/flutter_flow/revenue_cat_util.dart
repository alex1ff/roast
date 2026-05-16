import 'dart:io' show Platform;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/services.dart';

export 'package:purchases_flutter/purchases_flutter.dart'
    show Package, Offering;

Offerings? _offerings;
CustomerInfo? _customerInfo;
String? _loggedInUid;
bool _isConfigured = false;
Future<void>? _initializationFuture;

Offerings? get offerings => _offerings;
CustomerInfo? get customerInfo => _customerInfo;
bool get isConfigured => _isConfigured;

set customerInfo(CustomerInfo? customerInfo) => _customerInfo = customerInfo;

Future<void> initialize(
  String appStoreKey,
  String playStoreKey, {
  String webKey = '',
  bool debugLogEnabled = false,
  bool loadDataAfterLaunch = false,
}) {
  _initializationFuture ??= _initialize(
    appStoreKey,
    playStoreKey,
    webKey: webKey,
    debugLogEnabled: debugLogEnabled,
    loadDataAfterLaunch: loadDataAfterLaunch,
  );
  return _initializationFuture!;
}

Future<void> _initialize(
  String appStoreKey,
  String playStoreKey, {
  required String webKey,
  required bool debugLogEnabled,
  required bool loadDataAfterLaunch,
}) async {
  try {
    // Set log level before configuration
    await Purchases.setLogLevel(
      debugLogEnabled ? LogLevel.debug : LogLevel.info,
    );

    // Configure based on platform
    PurchasesConfiguration configuration;
    if (kIsWeb) {
      if (webKey.isEmpty) {
        debugPrint(
          'RevenueCat web support requires a web API key. '
          'RevenueCat features will be disabled in Test Mode.',
        );
        return;
      }
      configuration = PurchasesConfiguration(webKey);
    } else if (Platform.isIOS) {
      if (appStoreKey.isEmpty) {
        debugPrint(
          'RevenueCat iOS support requires an App Store API key. '
          'RevenueCat features will be disabled.',
        );
        return;
      }
      configuration = PurchasesConfiguration(appStoreKey);
    } else if (Platform.isAndroid) {
      if (playStoreKey.isEmpty) {
        debugPrint(
          'RevenueCat Android support requires a Play Store API key. '
          'RevenueCat features will be disabled.',
        );
        return;
      }
      configuration = PurchasesConfiguration(playStoreKey);
    } else {
      debugPrint("RevenueCat is not supported on this platform.");
      return;
    }

    await Purchases.configure(configuration);
    _isConfigured = true;

    if (loadDataAfterLaunch) {
      loadCustomerInfo();
      loadOfferings();
    } else {
      await loadCustomerInfo();
      await loadOfferings();
    }

    Purchases.addCustomerInfoUpdateListener((info) {
      customerInfo = info;
    });
  } on Exception catch (e) {
    debugPrint("RevenueCat initialization failed: $e");
  }
}

Future<void> waitForInitialization() async {
  await (_initializationFuture ?? Future.value());
}

Package? getPackage(String packageId) =>
    _offerings?.current?.getPackage(packageId);

String packagePriceString(
  String packageId, {
  String loadingText = 'Loading...',
  String unavailableText = 'Unavailable',
}) {
  if (_offerings?.current == null) {
    return loadingText;
  }
  return getPackage(packageId)?.storeProduct.priceString ?? unavailableText;
}

// Purchase a package.
Future<bool> purchasePackage(String package) async {
  if (!_isConfigured) {
    debugPrint('RevenueCat is not configured. Cannot purchase package.');
    return false;
  }
  try {
    final revenueCatPackage = offerings?.current?.getPackage(package);
    if (revenueCatPackage == null) {
      return false;
    }
    final result = await Purchases.purchase(
      PurchaseParams.package(revenueCatPackage),
    );
    customerInfo = result.customerInfo;
    return true;
  } catch (_) {
    return false;
  }
}

List<String> get activeEntitlementIds => _customerInfo != null
    ? _customerInfo!.entitlements.active.values
        .map((e) => e.identifier)
        .toList()
    : [];

Future<Offerings?> ensureOfferingsLoaded() async {
  await waitForInitialization();
  if (!_isConfigured) {
    return _offerings;
  }
  if (_offerings?.current == null) {
    await loadOfferings();
  }
  return _offerings;
}

Future<Offerings?> loadOfferings() async {
  if (!_isConfigured) {
    return _offerings;
  }
  try {
    _offerings = await Purchases.getOfferings();
  } on PlatformException catch (e) {
    debugPrint("Error loading offerings info: $e");
  }
  return _offerings;
}

Future loadCustomerInfo() async {
  if (!_isConfigured) {
    return;
  }
  try {
    _customerInfo = await Purchases.getCustomerInfo();
  } on PlatformException catch (e) {
    debugPrint("Error loading purchaser info: $e");
  }
}

// Return if the user has the entitlement.
// Return null on errors.
// Returns false if RevenueCat is not configured (e.g., no web billing key in Test Mode).
Future<bool?> isEntitled(String entitlementId) async {
  if (!_isConfigured) {
    // Return false instead of null to indicate no entitlement when unconfigured.
    // This allows Test Mode to work without a web billing key.
    return false;
  }
  try {
    customerInfo = await Purchases.getCustomerInfo();
    return customerInfo!.entitlements.all[entitlementId]?.isActive ?? false;
  } on Exception catch (e) {
    debugPrint("Unable to check RevenueCat entitlements: $e");
    return null;
  }
}

// https://docs.revenuecat.com/docs/user-ids
Future login(String? uid) async {
  if (!_isConfigured) {
    return;
  }
  if (uid == _loggedInUid) {
    return;
  }
  try {
    if (uid != null) {
      customerInfo = (await Purchases.logIn(uid)).customerInfo;
    } else {
      customerInfo = await Purchases.logOut();
    }
    _loggedInUid = uid;
  } on Exception catch (e) {
    debugPrint("Unable to logIn or logOut user in RevenueCat: $e");
  }
}

// https://docs.revenuecat.com/docs/restoring-purchases
Future restorePurchases() async {
  if (!_isConfigured) {
    return;
  }
  // Note: On web, purchases are automatically restored by Web Billing.
  // This method is only needed for iOS/Android.
  if (kIsWeb) {
    debugPrint(
      'Restore purchases is not needed on web - Web Billing handles this automatically.',
    );
    return;
  }
  try {
    customerInfo = await Purchases.restorePurchases();
  } on PlatformException catch (e) {
    debugPrint("Unable to restore purchases in RevenueCat: $e");
  }
}
