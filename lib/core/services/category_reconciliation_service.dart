import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/sync/sync_models.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/providers/database_provider.dart';

/// A question about one built-in category, ready to put in front of the user.
class PendingCategoryReconciliation {
  /// The built-in in question, e.g. `groceries`.
  final String defaultKey;

  /// What the app would have called it.
  final String catalogName;
  final bool catalogIsIncome;

  /// The local, unpushed category seeded for this built-in.
  final String provisionalCategoryId;

  /// Existing categories that might already be this built-in.
  final List<LegacyCategoryCandidate> candidates;

  /// The user's answer, if they have given one and it has not synced yet.
  final String? resolutionKind;
  final String? resolutionCandidateId;

  const PendingCategoryReconciliation({
    required this.defaultKey,
    required this.catalogName,
    required this.catalogIsIncome,
    required this.provisionalCategoryId,
    required this.candidates,
    this.resolutionKind,
    this.resolutionCandidateId,
  });

  /// True while the user still has to decide.
  bool get isAwaitingUser => resolutionKind == null;

  /// True once they have decided but the decision has not reached the server.
  bool get isAwaitingSync => resolutionKind != null;

  factory PendingCategoryReconciliation.fromRow(CategoryReconciliation row) {
    final decoded = jsonDecode(row.candidatesJson);
    return PendingCategoryReconciliation(
      defaultKey: row.defaultKey,
      catalogName: row.catalogName,
      catalogIsIncome: row.catalogIsIncome,
      provisionalCategoryId: row.provisionalCategoryId,
      candidates: decoded is List
          ? decoded
                .whereType<Map>()
                .map(
                  (c) => LegacyCategoryCandidate.fromJson(
                    c.cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const <LegacyCategoryCandidate>[],
      resolutionKind: row.resolutionKind,
      resolutionCandidateId: row.resolutionCandidateId,
    );
  }
}

/// Records what the user decided about pre-slug categories that might already be
/// built-ins.
///
/// The decision itself is the whole point: neither this class nor the server
/// will ever classify one of these categories on its own. Matching on name and
/// direction cannot tell a category the app seeded years ago from one the user
/// typed themselves, and acting on that guess would silently rewrite the
/// category on somebody's real transaction history. So the app asks, and does
/// nothing at all until it is told.
///
/// Nothing here talks to the network. It writes the answer down; the next sync
/// carries it, and the server reports back what it did.
class CategoryReconciliationService {
  final AppDatabase _database;

  CategoryReconciliationService(this._database);

  Stream<List<PendingCategoryReconciliation>> watch() => _database
      .watchCategoryReconciliations()
      .map((rows) => rows.map(PendingCategoryReconciliation.fromRow).toList());

  Future<List<PendingCategoryReconciliation>> list() async {
    final rows = await _database.allCategoryReconciliations();
    return rows.map(PendingCategoryReconciliation.fromRow).toList();
  }

  /// "This category I already have IS the built-in."
  ///
  /// The existing category keeps its id, its transactions, its subcategories,
  /// its learned titles, and its timestamps — it simply gains the built-in's
  /// identity. The provisional copy this device seeded is folded into it once
  /// the server confirms, so the account ends up with one category, not two.
  Future<void> adoptExisting({
    required String defaultKey,
    required String candidateId,
  }) => _database.resolveCategoryReconciliation(
    defaultKey: defaultKey,
    kind: CategoryReconciliationKinds.adoptLegacy,
    candidateId: candidateId,
  );

  /// "Leave my category alone — it is not the built-in."
  ///
  /// The existing category stays exactly as it is, an ordinary custom category,
  /// and the built-in is created separately alongside it.
  Future<void> keepSeparate({required String defaultKey}) =>
      _database.resolveCategoryReconciliation(
        defaultKey: defaultKey,
        kind: CategoryReconciliationKinds.createSeparate,
      );

  /// Takes back an answer that has not synced yet.
  Future<void> undo({required String defaultKey}) =>
      _database.reopenCategoryReconciliation(defaultKey);
}

final categoryReconciliationServiceProvider =
    Provider<CategoryReconciliationService>(
      (ref) => CategoryReconciliationService(ref.watch(databaseProvider)),
    );

/// Every open reconciliation question, live.
final categoryReconciliationsProvider =
    StreamProvider<List<PendingCategoryReconciliation>>(
      (ref) => ref.watch(categoryReconciliationServiceProvider).watch(),
    );

/// How many questions are still waiting on the user — for badges and banners.
final unresolvedCategoryReconciliationCountProvider = Provider<int>((ref) {
  final async = ref.watch(categoryReconciliationsProvider);
  return async.maybeWhen(
    data: (items) => items.where((i) => i.isAwaitingUser).length,
    orElse: () => 0,
  );
});
