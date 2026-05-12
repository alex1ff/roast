import '/backend/schema/enums/enums.dart';

/// User-facing copy that depends on the active subscription billing
/// period. Centralized so screens that talk about "your monthly roasts"
/// stay correct for weekly / yearly subscribers as well.
class SubPlanCopy {
  const SubPlanCopy._();

  /// e.g. "weekly" / "monthly" / "yearly". Falls back to "monthly"
  /// when the plan is unknown — matches legacy UX.
  static String periodAdjective(SubPlan? plan) {
    switch (plan) {
      case SubPlan.weekly:
        return 'weekly';
      case SubPlan.yearly:
        return 'yearly';
      case SubPlan.monthly:
      case null:
        return 'monthly';
    }
  }

  /// Capitalized form for titles, e.g. "Weekly".
  static String periodAdjectiveTitle(SubPlan? plan) {
    final v = periodAdjective(plan);
    return v[0].toUpperCase() + v.substring(1);
  }

  /// Title for the "quota reached for the current period" popup.
  static String quotaReachedTitle(SubPlan? plan) =>
      '${periodAdjectiveTitle(plan)} Roasts Finished';

  /// Body for the "quota reached" popup variants.
  static String quotaReachedBody(SubPlan? plan) {
    final period = periodAdjective(plan);
    return 'We love that you’re using Roast. Your $period roasts are '
        'finished, but your appetite clearly isn’t. Get Roast Reload Pack '
        'and keep the heat on.';
  }

  /// Body for the reload-pack screen header.
  static String reloadPackIntro(SubPlan? plan) {
    final period = periodAdjective(plan);
    return 'Your $period roasts are finished, but your appetite clearly '
        'isn’t. Reload and keep the heat on.\n\n';
  }
}
