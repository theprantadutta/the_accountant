/// Where the currency symbol sits.
enum SymbolPosition {
  /// `$1,234.56` — what every amount in this app did when there was no choice.
  before('before', 'Before the amount', r'$1,234.56'),

  /// `1.234,56 €` — how roughly half of Europe writes it.
  after('after', 'After the amount', '1.234,56 €');

  const SymbolPosition(this.storedAs, this.label, this.example);

  final String storedAs;
  final String label;
  final String example;

  static SymbolPosition fromStored(String? value) => values.firstWhere(
    (p) => p.storedAs == value,
    orElse: () => SymbolPosition.before,
  );
}

/// Twelve-hour, twenty-four-hour, or whatever the phone says.
enum TimeFormatChoice {
  system('system', 'Match my phone'),
  twelveHour('12', '12-hour (1:30 PM)'),
  twentyFourHour('24', '24-hour (13:30)');

  const TimeFormatChoice(this.storedAs, this.label);

  final String storedAs;
  final String label;

  static TimeFormatChoice fromStored(String? value) => values.firstWhere(
    (c) => c.storedAs == value,
    orElse: () => TimeFormatChoice.system,
  );

  /// Whether to show a 24-hour clock, given what the phone is set to.
  bool resolve({required bool platformUses24Hour}) => switch (this) {
    TimeFormatChoice.system => platformUses24Hour,
    TimeFormatChoice.twelveHour => false,
    TimeFormatChoice.twentyFourHour => true,
  };
}

/// Which day a week starts on.
class FirstDayOfWeek {
  const FirstDayOfWeek._();

  /// Stored as 0 to follow the phone's locale, otherwise 1 (Monday) through
  /// 7 (Sunday), matching [DateTime.monday] and friends.
  static const int followLocale = 0;

  static const Map<int, String> labels = {
    followLocale: 'Match my phone',
    DateTime.monday: 'Monday',
    DateTime.saturday: 'Saturday',
    DateTime.sunday: 'Sunday',
  };

  /// The value Flutter's calendars want: 0 for Sunday through 6 for Saturday.
  ///
  /// A different convention from `DateTime.weekday`, and the mismatch is easy
  /// to get subtly wrong, so it is converted in exactly one place.
  static int? materialIndex(int stored) {
    if (stored == followLocale) return null;
    return stored % 7;
  }

  /// The most recent [start]-day on or before [moment].
  static DateTime startOfWeek(DateTime moment, int start) {
    final day = DateTime(moment.year, moment.month, moment.day);
    final anchor = start == followLocale ? DateTime.monday : start;
    final back = (day.weekday - anchor + 7) % 7;
    return day.subtract(Duration(days: back));
  }
}

/// Display preferences that every formatted value needs, held where the
/// formatters can reach them.
///
/// The alternative is threading three more arguments through several hundred
/// call sites that already thread two. These are read-only presentation
/// settings with exactly one writer — the app shell, on the same build that
/// reads them from the database — so an ambient value costs nothing in
/// correctness and saves a great deal of noise. It is the same bargain
/// [AppColors] makes with the palette, for the same reason.
///
/// A caller that needs to override one for a single value can still pass it
/// explicitly; that is what the formatter parameters are for.
class RegionalPreferences {
  const RegionalPreferences._();

  static SymbolPosition symbolPosition = SymbolPosition.before;

  static TimeFormatChoice timeFormat = TimeFormatChoice.system;

  static int firstDayOfWeek = FirstDayOfWeek.followLocale;

  /// Apply the user's stored settings. Returns whether anything changed, so the
  /// caller can decide whether a repaint is owed.
  static bool apply({
    required SymbolPosition symbol,
    required TimeFormatChoice time,
    required int weekStart,
  }) {
    if (symbol == symbolPosition &&
        time == timeFormat &&
        weekStart == firstDayOfWeek) {
      return false;
    }
    symbolPosition = symbol;
    timeFormat = time;
    firstDayOfWeek = weekStart;
    return true;
  }

  /// Put everything back, for tests.
  static void reset() {
    symbolPosition = SymbolPosition.before;
    timeFormat = TimeFormatChoice.system;
    firstDayOfWeek = FirstDayOfWeek.followLocale;
  }
}
