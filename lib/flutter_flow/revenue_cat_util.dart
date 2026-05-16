import 'dart:io' show Platform;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/services.dart';

export 'package:purchases_flutter/purchases_flutter.dart'
    show Package, Offering, ProductCategory;

Offerings? _offerings;
CustomerInfo? _customerInfo;
final Map<String, StoreProduct> _storeProducts = {};
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
StoreProduct? getStoreProduct(String productId) => _storeProducts[productId];

String packagePriceString(
  String packageId, {
  String loadingText = 'Loading...',
  String unavailableText = 'Unavailable',
}) {
  final priceString = getPackage(packageId)?.storeProduct.priceString ??
      getStoreProduct(packageId)?.priceString;
  if (priceString != null) {
    return priceString;
  }
  if (_offerings?.current == null && !_storeProducts.containsKey(packageId)) {
    return loadingText;
  }
  return unavailableText;
}

// Purchase a package.
Future<bool> purchasePackage(
  String package, {
  ProductCategory productCategory = ProductCategory.subscription,
}) async {
  if (!_isConfigured) {
    debugPrint('RevenueCat is not configured. Cannot purchase package.');
    return false;
  }
  try {
    final revenueCatPackage = offerings?.current?.getPackage(package);
    final params = revenueCatPackage != null
        ? PurchaseParams.package(revenueCatPackage)
        : PurchaseParams.storeProduct(
            getStoreProduct(package) ??
                await _loadSingleStoreProduct(
                  package,
                  productCategory: productCategory,
                ),
          );
    final result = await Purchases.purchase(params);
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

Future<void> ensureStoreProductsLoaded(
  List<String> productIds, {
  ProductCategory productCategory = ProductCategory.subscription,
}) async {
  await waitForInitialization();
  if (!_isConfigured) {
    return;
  }

  final missingStoreProductIds = productIds
      .where((productId) => getStoreProduct(productId) == null)
      .toList();

  await Future.wait([
    loadOfferings(),
    if (missingStoreProductIds.isNotEmpty)
      loadStoreProducts(
        missingStoreProductIds,
        productCategory: productCategory,
      ),
  ]);
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

Future<List<StoreProduct>> loadStoreProducts(
  List<String> productIds, {
  ProductCategory productCategory = ProductCategory.subscription,
}) async {
  if (!_isConfigured || productIds.isEmpty) {
    return const [];
  }
  try {
    final products = await Purchases.getProducts(
      productIds,
      productCategory: productCategory,
    );
    for (final product in products) {
      _storeProducts[product.identifier] = product;
    }
    return products;
  } on PlatformException catch (e) {
    debugPrint("Error loading StoreKit product info: $e");
    return const [];
  }
}

Future<StoreProduct> _loadSingleStoreProduct(
  String productId, {
  required ProductCategory productCategory,
}) async {
  final products = await loadStoreProducts(
    [productId],
    productCategory: productCategory,
  );
  final product = products.where((item) => item.identifier == productId).first;
  return product;
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
