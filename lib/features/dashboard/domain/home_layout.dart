import 'dart:convert';

/// A block on the home screen the user can move or hide.
///
/// The [storedAs] id is the stable identity and must never change: it is what
/// is written to preferences, so renaming one would silently reset somebody's
/// layout. The enum's own order is the default layout.
enum HomeSection {
  greeting('greeting'),
  accounts('accounts'),
  quickStats('quick_stats'),
  quickLinks('quick_links'),
  spendingChart('spending_chart'),
  recentTransactions('recent_transactions'),
  budgets('budgets'),
  goals('goals');

  const HomeSection(this.storedAs);

  final String storedAs;

  static HomeSection? fromStored(String id) {
    for (final section in values) {
      if (section.storedAs == id) return section;
    }
    return null;
  }
}

/// Which blocks the home screen shows, and in what order.
///
/// Cashew has fourteen reorderable sections; this app had eight in a fixed
/// order with no way to touch them. What matters more than the count is that
/// the stored layout survives the app changing underneath it — see [decode].
class HomeLayout {
  const HomeLayout({required this.order, this.hidden = const {}});

  /// Every section, including hidden ones, in the order the user chose.
  final List<HomeSection> order;

  final Set<HomeSection> hidden;

  /// The default: every section, in the order the enum declares.
  static const HomeLayout initial = HomeLayout(order: HomeSection.values);

  List<HomeSection> get visible => [
    for (final section in order)
      if (!hidden.contains(section)) section,
  ];

  bool isVisible(HomeSection section) => !hidden.contains(section);

  /// Whether this is still the layout the app ships with.
  bool get isDefault => hidden.isEmpty && _sameOrder(order, HomeSection.values);

  HomeLayout toggle(HomeSection section) => HomeLayout(
    order: order,
    hidden: {
      for (final s in hidden)
        if (s != section) s,
      if (!hidden.contains(section)) section,
    },
  );

  /// Move the section at [from] to [to].
  ///
  /// [to] is an index into the list *with the moved item already taken out*,
  /// which is what `ReorderableListView.onReorderItem` hands over. The older
  /// `onReorder` counted against the list before the lift and so needed a
  /// correction here; doing both would move a downward drag one place short.
  HomeLayout move(int from, int to) {
    if (from < 0 || from >= order.length) return this;
    final next = [...order];
    final section = next.removeAt(from);
    next.insert(to.clamp(0, next.length), section);
    return HomeLayout(order: next, hidden: hidden);
  }

  Map<String, Object?> toJson() => {
    'order': [for (final section in order) section.storedAs],
    'hidden': [for (final section in hidden) section.storedAs],
  };

  String encode() => jsonEncode(toJson());

  /// Read a stored layout, reconciled against the sections this build has.
  ///
  /// Two things have to hold for a stored layout to be safe to keep. A section
  /// this build no longer has must be dropped rather than crashing the home
  /// screen. And a section added *since* the layout was saved must appear —
  /// silently omitting it means a new feature is invisible to every existing
  /// user, and looks like a bug in the feature rather than in the layout. New
  /// sections are inserted at the position the enum declares them, so they land
  /// where they were designed to.
  static HomeLayout decode(String? source) {
    if (source == null || source.isEmpty) return initial;

    final Object? raw;
    try {
      raw = jsonDecode(source);
    } catch (_) {
      return initial;
    }
    if (raw is! Map) return initial;

    final stored = <HomeSection>[];
    final storedIds = raw['order'];
    if (storedIds is List) {
      for (final id in storedIds) {
        final section = HomeSection.fromStored('$id');
        if (section != null && !stored.contains(section)) stored.add(section);
      }
    }
    if (stored.isEmpty) return initial;

    // Anything the build knows about but the stored order does not, put back
    // where it belongs relative to what is already there.
    //
    // Placed *after* whichever stored section comes before it in the default
    // order, rather than before the first stored section that comes after it.
    // Those sound equivalent and are not: the second rule puts a new section at
    // the very front whenever the user has dragged a late section to the top,
    // which silently reorders a layout they arranged deliberately.
    final order = [...stored];
    for (final section in HomeSection.values) {
      if (order.contains(section)) continue;
      final defaultIndex = HomeSection.values.indexOf(section);

      var at = 0;
      var bestPredecessor = -1;
      for (var i = 0; i < order.length; i++) {
        final index = HomeSection.values.indexOf(order[i]);
        if (index < defaultIndex && index > bestPredecessor) {
          bestPredecessor = index;
          at = i + 1;
        }
      }
      order.insert(at, section);
    }

    final hidden = <HomeSection>{};
    final storedHidden = raw['hidden'];
    if (storedHidden is List) {
      for (final id in storedHidden) {
        final section = HomeSection.fromStored('$id');
        if (section != null) hidden.add(section);
      }
    }

    return HomeLayout(order: order, hidden: hidden);
  }

  static bool _sameOrder(List<HomeSection> a, List<HomeSection> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
