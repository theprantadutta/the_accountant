/// This month's AI allowance as the server counts it.
///
/// Premium is [unlimited]. Everyone else gets [freeMonthly] calls a month plus
/// one per rewarded ad, at most [maxAdCredits] of those; the month is the
/// user's own, starting at their midnight on the 1st.
class AiQuota {
  final bool unlimited;
  final int freeMonthly;
  final int used;
  final int adCredits;

  /// Calls left this month; null when [unlimited].
  final int? remaining;
  final int adsWatched;

  /// The most AI calls ads can add in a month.
  final int maxAdCredits;

  /// The most rewarded ads of any kind in a month.
  final int maxAds;

  /// Whether any rewarded ad can still pay out this month.
  final bool canWatchAd;

  /// Whether an ad can still add an AI call this month.
  final bool canEarnAiCall;
  final DateTime? resetsAt;

  /// Premium themes unlocked by an ad until this moment.
  final DateTime? themeTrialEndsAt;

  /// PDF exports bought with ads and not yet used.
  final int pdfExportCredits;

  const AiQuota({
    required this.unlimited,
    required this.freeMonthly,
    required this.used,
    required this.adCredits,
    required this.remaining,
    required this.adsWatched,
    required this.maxAdCredits,
    required this.maxAds,
    required this.canWatchAd,
    required this.canEarnAiCall,
    this.resetsAt,
    this.themeTrialEndsAt,
    this.pdfExportCredits = 0,
  });

  /// What a free user starts each month with, before the server has answered.
  static const AiQuota initial = AiQuota(
    unlimited: false,
    freeMonthly: 10,
    used: 0,
    adCredits: 0,
    remaining: 10,
    adsWatched: 0,
    maxAdCredits: 10,
    maxAds: 30,
    canWatchAd: true,
    canEarnAiCall: true,
  );

  /// Premium: never counted, never offered an ad.
  static const AiQuota premium = AiQuota(
    unlimited: true,
    freeMonthly: 10,
    used: 0,
    adCredits: 0,
    remaining: null,
    adsWatched: 0,
    maxAdCredits: 0,
    maxAds: 0,
    canWatchAd: false,
    canEarnAiCall: false,
  );

  bool get hasCallsLeft => unlimited || (remaining ?? 0) > 0;

  /// AI calls an ad can still add this month.
  int get adCreditsLeft =>
      canEarnAiCall ? (maxAdCredits - adCredits).clamp(0, maxAdCredits) : 0;

  bool get themeTrialActive =>
      themeTrialEndsAt != null && themeTrialEndsAt!.isAfter(DateTime.now());

  AiQuota copyWith({int? used, int? remaining}) => AiQuota(
    unlimited: unlimited,
    freeMonthly: freeMonthly,
    used: used ?? this.used,
    adCredits: adCredits,
    remaining: remaining ?? this.remaining,
    adsWatched: adsWatched,
    maxAdCredits: maxAdCredits,
    maxAds: maxAds,
    canWatchAd: canWatchAd,
    canEarnAiCall: canEarnAiCall,
    resetsAt: resetsAt,
    themeTrialEndsAt: themeTrialEndsAt,
    pdfExportCredits: pdfExportCredits,
  );

  factory AiQuota.fromJson(Map<String, dynamic> json) {
    DateTime? date(Object? v) =>
        v is String ? DateTime.tryParse(v)?.toLocal() : null;
    final canWatch = json['can_watch_ad'] as bool? ?? false;
    return AiQuota(
      unlimited: json['unlimited'] as bool? ?? false,
      freeMonthly: json['free_monthly'] as int? ?? 10,
      used: json['used'] as int? ?? 0,
      adCredits: json['ad_credits'] as int? ?? 0,
      remaining: json['remaining'] as int?,
      adsWatched: json['ads_watched'] as int? ?? 0,
      maxAdCredits: json['max_ad_credits'] as int? ?? 10,
      maxAds: json['max_ads'] as int? ?? 30,
      canWatchAd: canWatch,
      canEarnAiCall: json['can_earn_ai_call'] as bool? ?? canWatch,
      resetsAt: date(json['resets_at']),
      themeTrialEndsAt: date(json['theme_trial_ends_at']),
      pdfExportCredits: json['pdf_export_credits'] as int? ?? 0,
    );
  }
}
