import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart'
    show TitleUsage;
import 'package:the_accountant/data/datasources/local/database_provider.dart';

/// Titles the user has entered before that match what they are typing now.
///
/// Keyed by the query, so each distinct prefix is fetched once and remembered
/// while the field still has it; `autoDispose` drops the lot when the form
/// closes rather than holding a search index for a screen nobody is looking at.
///
/// Empty for a blank query — a list of everything the user has ever typed is
/// not a suggestion, it is a filing cabinet.
final titleUsageSearchProvider = FutureProvider.autoDispose
    .family<List<TitleUsage>, String>((ref, query) async {
      if (query.trim().isEmpty) return const [];
      final db = ref.watch(databaseProvider);
      return db.searchTitleUsages(query);
    });
