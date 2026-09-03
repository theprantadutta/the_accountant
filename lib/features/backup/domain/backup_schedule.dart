/// How often a backup should go up on its own, once the user has asked for it.
///
/// Cashew offers an interval and a number of files to keep, and that pairing is
/// worth copying: an interval alone fills the account for ever, and a retained
/// count alone never runs.
enum BackupFrequency {
  /// Only when the button is pressed.
  manual('Only when I ask', null),
  daily('Every day', Duration(days: 1)),
  weekly('Every week', Duration(days: 7)),
  monthly('Every month', Duration(days: 30));

  const BackupFrequency(this.label, this.interval);

  final String label;

  /// How long after the last backup the next one is due, or null when it never
  /// becomes due on its own.
  final Duration? interval;

  static BackupFrequency fromName(String? name) => BackupFrequency.values
      .firstWhere((f) => f.name == name, orElse: () => BackupFrequency.manual);
}

/// What the user has asked automatic backups to do.
class BackupSchedule {
  const BackupSchedule({
    this.frequency = BackupFrequency.manual,
    this.keep = defaultKeep,
    this.lastBackupAt,
    this.lastFailure,
  });

  /// Enough history to survive noticing a mistake a few days late, without
  /// turning the app's Drive allowance into a landfill.
  static const int defaultKeep = 5;

  static const List<int> keepOptions = [3, 5, 10, 20];

  final BackupFrequency frequency;

  /// How many backups to keep. Older ones are removed after a successful run —
  /// after, never before, so a failed upload cannot cost the user the copies
  /// they already had.
  final int keep;

  final DateTime? lastBackupAt;

  /// Why the last automatic attempt did not happen, kept so a schedule that has
  /// quietly stopped working can say so rather than just looking idle.
  final String? lastFailure;

  bool get isAutomatic => frequency.interval != null;

  /// Whether an automatic run is owed as of [now].
  bool isDue(DateTime now) {
    final interval = frequency.interval;
    if (interval == null) return false;
    final last = lastBackupAt;
    if (last == null) return true;
    return !now.isBefore(last.add(interval));
  }

  DateTime? nextDueAt() {
    final interval = frequency.interval;
    if (interval == null) return null;
    final last = lastBackupAt;
    if (last == null) return null;
    return last.add(interval);
  }

  BackupSchedule copyWith({
    BackupFrequency? frequency,
    int? keep,
    DateTime? lastBackupAt,
    String? lastFailure,
    bool clearFailure = false,
  }) => BackupSchedule(
    frequency: frequency ?? this.frequency,
    keep: keep ?? this.keep,
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    lastFailure: clearFailure ? null : (lastFailure ?? this.lastFailure),
  );
}
