import 'package:flutter_test/flutter_test.dart';
import 'package:roast_nutri_tracker/backend/schema/enums/enums.dart';
import 'package:roast_nutri_tracker/services/usage_limit_service.dart';

void main() {
  group('UsageLimitService', () {
    test('allows free users until the shared free quota is reached', () {
      final allowed = UsageLimitService.roastDecision(
        hasPremium: false,
        usedCount: 17,
        subPlan: null,
      );
      final blocked = UsageLimitService.roastDecision(
        hasPremium: false,
        usedCount: 18,
        subPlan: null,
      );

      expect(allowed.allowed, isTrue);
      expect(allowed.includedLimit, 18);
      expect(blocked.allowed, isFalse);
      expect(blocked.premiumIncludedQuotaReached, isFalse);
    });

    test('uses weekly, monthly and yearly premium limits per feature', () {
      final weeklyRoast = UsageLimitService.roastDecision(
        hasPremium: true,
        usedCount: 69,
        subPlan: SubPlan.weekly,
      );
      final monthlyRoast = UsageLimitService.roastDecision(
        hasPremium: true,
        usedCount: 279,
        subPlan: SubPlan.monthly,
      );
      final yearlyChat = UsageLimitService.chatDecision(
        hasPremium: true,
        usedCount: 3599,
        subPlan: SubPlan.yearly,
      );
      final weeklyChat = UsageLimitService.chatDecision(
        hasPremium: true,
        usedCount: 74,
        subPlan: SubPlan.weekly,
      );

      expect(weeklyRoast.allowed, isTrue);
      expect(weeklyRoast.includedLimit, 70);
      expect(monthlyRoast.allowed, isTrue);
      expect(monthlyRoast.includedLimit, 280);
      expect(yearlyChat.allowed, isTrue);
      expect(yearlyChat.includedLimit, 3600);
      expect(weeklyChat.allowed, isTrue);
      expect(weeklyChat.includedLimit, 75);
    });

    test('blocks weekly premium roast quota at the limit', () {
      final decision = UsageLimitService.roastDecision(
        hasPremium: true,
        usedCount: 70,
        subPlan: SubPlan.weekly,
      );

      expect(decision.allowed, isFalse);
      expect(decision.premiumIncludedQuotaReached, isTrue);
    });

    test('blocks premium included quota at the limit without extra credits',
        () {
      final decision = UsageLimitService.chatDecision(
        hasPremium: true,
        usedCount: 300,
        subPlan: SubPlan.monthly,
      );

      expect(decision.allowed, isFalse);
      expect(decision.premiumIncludedQuotaReached, isTrue);
    });

    test('allows extra credits after included quota is reached', () {
      final roast = UsageLimitService.roastDecision(
        hasPremium: true,
        usedCount: 280,
        subPlan: SubPlan.monthly,
        extraPhoto: 1,
      );
      final chat = UsageLimitService.chatDecision(
        hasPremium: false,
        usedCount: 18,
        subPlan: null,
        extraChat: 2,
      );

      expect(roast.allowed, isTrue);
      expect(roast.hasExtraCredits, isTrue);
      expect(roast.premiumIncludedQuotaReached, isFalse);
      expect(chat.allowed, isTrue);
    });

    test('normalizes null and negative counts', () {
      final decision = UsageLimitService.roastDecision(
        hasPremium: false,
        usedCount: -1,
        subPlan: null,
        extraPhoto: -1,
      );

      expect(decision.usedCount, 0);
      expect(decision.extraCredits, 0);
      expect(decision.allowed, isTrue);
    });
  });
}
