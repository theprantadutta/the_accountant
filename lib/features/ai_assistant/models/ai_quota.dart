/// Today's AI allowance as the server counts it.
///
/// Premium is [unlimited]. Everyone else gets [freeDaily] calls a day plus one
/// per rewarded ad, up to [maxAdsPerDay] ads; the day is the user's own.
class AiQuota {
  final bool unlimited;
  final int freeDaily;
  final int used;
  final int adCredits;

  /// Calls left today; null when [unlimited].
  final int? remaining;
  final int adsWatched;
  final int maxAdsPerDay;
  final bool canWatchAd;
  final DateTime? resetsAt;

  /// Premium themes unlocked by an ad until this moment.
  final DateTime? themeTrialEndsAt;

  /// PDF exports bought with ads and not yet used.
  final int pdfExportCredits;

  const AiQuota({
    required this.unlimited,
    required this.freeDaily,
    required this.used,
    required this.adCredits,
    required this.remaining,
    required this.adsWatched,
    required this.maxAdsPerDay,
    required this.canWatchAd,
    this.resetsAt,
    this.themeTrialEndsAt,
    this.pdfExportCredits = 0,
  });

  /// What a free user starts each day with, before the server has answered.
  static const AiQuota initial = AiQuota(
    unlimited: false,
    freeDaily: 2,
    used: 0,
    adCredits: 0,
    remaining: 2,
    adsWatched: 0,
    maxAdsPerDay: 10,
    canWatchAd: true,
  );

  bool get hasCallsLeft => unlimited || (remaining ?? 0) > 0;

  bool get themeTrialActive =>
      themeTrialEndsAt != null && themeTrialEndsAt!.isAfter(DateTime.now());

  factory AiQuota.fromJson(Map<String, dynamic> json) {
    DateTime? date(Object? v) =>
        v is String ? DateTime.tryParse(v)?.toLocal() : null;
    return AiQuota(
      unlimited: json['unlimited'] as bool? ?? false,
      freeDaily: json['free_daily'] as int? ?? 2,
      used: json['used'] as int? ?? 0,
      adCredits: json['ad_credits'] as int? ?? 0,
      remaining: json['remaining'] as int?,
      adsWatched: json['ads_watched'] as int? ?? 0,
      maxAdsPerDay: json['max_ads_per_day'] as int? ?? 10,
      canWatchAd: json['can_watch_ad'] as bool? ?? false,
      resetsAt: date(json['resets_at']),
      themeTrialEndsAt: date(json['theme_trial_ends_at']),
      pdfExportCredits: json['pdf_export_credits'] as int? ?? 0,
    );
  }
}
