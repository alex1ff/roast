import '/backend/schema/enums/enums.dart';
import '/app_constants.dart';

enum UsageFeature {
  roast,
  chat,
}

class UsageLimitDecision {
  const UsageLimitDecision({
    required this.feature,
    required this.hasPremium,
    required this.usedCount,
    required this.includedLimit,
    required this.extraCredits,
  });

  final UsageFeature feature;
  final bool hasPremium;
  final int usedCount;
  final int includedLimit;
  final int extraCredits;

  bool get hasIncludedQuota => usedCount < includedLimit;
  bool get hasExtraCredits => extraCredits > 0;
  bool get canUseExtraCredits => hasPremium && hasExtraCredits;
  bool get allowed => hasIncludedQuota || canUseExtraCredits;
  bool get premiumIncludedQuotaReached =>
      hasPremium && usedCount >= includedLimit && !hasExtraCredits;
}

class UsageLimitService {
  const UsageLimitService._();

  static UsageLimitDecision roastDecision({
    required bool hasPremium,
    required int? usedCount,
    int? otherFeatureUsedCount,
    required SubPlan? subPlan,
    int? extraPhoto,
  }) {
    final normalizedUsedCount = _usageCount(
      hasPremium: hasPremium,
      usedCount: usedCount,
      otherFeatureUsedCount: otherFeatureUsedCount,
    );
    return UsageLimitDecision(
      feature: UsageFeature.roast,
      hasPremium: hasPremium,
      usedCount: normalizedUsedCount,
      includedLimit: _includedLimit(
        feature: UsageFeature.roast,
        hasPremium: hasPremium,
        subPlan: subPlan,
      ),
      extraCredits: _normalizeCount(extraPhoto),
    );
  }

  static UsageLimitDecision chatDecision({
    required bool hasPremium,
    required int? usedCount,
    int? otherFeatureUsedCount,
    required SubPlan? subPlan,
    int? extraChat,
  }) {
    final normalizedUsedCount = _usageCount(
      hasPremium: hasPremium,
      usedCount: usedCount,
      otherFeatureUsedCount: otherFeatureUsedCount,
    );
    return UsageLimitDecision(
      feature: UsageFeature.chat,
      hasPremium: hasPremium,
      usedCount: normalizedUsedCount,
      includedLimit: _includedLimit(
        feature: UsageFeature.chat,
        hasPremium: hasPremium,
        subPlan: subPlan,
      ),
      extraCredits: _normalizeCount(extraChat),
    );
  }

  static bool canUseRoast({
    required bool hasPremium,
    required int? usedCount,
    int? otherFeatureUsedCount,
    required SubPlan? subPlan,
    int? extraPhoto,
  }) {
    return roastDecision(
      hasPremium: hasPremium,
      usedCount: usedCount,
      otherFeatureUsedCount: otherFeatureUsedCount,
      subPlan: subPlan,
      extraPhoto: extraPhoto,
    ).allowed;
  }

  static bool canUseChat({
    required bool hasPremium,
    required int? usedCount,
    int? otherFeatureUsedCount,
    required SubPlan? subPlan,
    int? extraChat,
  }) {
    return chatDecision(
      hasPremium: hasPremium,
      usedCount: usedCount,
      otherFeatureUsedCount: otherFeatureUsedCount,
      subPlan: subPlan,
      extraChat: extraChat,
    ).allowed;
  }

  static int _includedLimit({
    required UsageFeature feature,
    required bool hasPremium,
    required SubPlan? subPlan,
  }) {
    if (!hasPremium) {
      return FFAppConstants.limitedNoSub;
    }

    switch (feature) {
      case UsageFeature.roast:
        switch (subPlan) {
          case SubPlan.weekly:
            return FFAppConstants.countlimitedW;
          case SubPlan.monthly:
            return FFAppConstants.countlimitedM;
          case SubPlan.yearly:
          case null:
            return FFAppConstants.countlimitedY;
        }
      case UsageFeature.chat:
        switch (subPlan) {
          case SubPlan.weekly:
            return FFAppConstants.countlimitedchatW;
          case SubPlan.monthly:
            return FFAppConstants.countlimitedchatM;
          case SubPlan.yearly:
          case null:
            return FFAppConstants.countlimitedchatY;
        }
    }
  }

  static int _normalizeCount(int? value) =>
      value == null || value < 0 ? 0 : value;

  static int _usageCount({
    required bool hasPremium,
    required int? usedCount,
    int? otherFeatureUsedCount,
  }) {
    final current = _normalizeCount(usedCount);
    if (hasPremium) {
      return current;
    }
    return current + _normalizeCount(otherFeatureUsedCount);
  }
}
