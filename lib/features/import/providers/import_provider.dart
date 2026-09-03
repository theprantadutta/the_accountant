import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/features/import/services/csv_import_service.dart';
import 'package:the_accountant/features/import/services/import_template_service.dart';

final csvImportServiceProvider = Provider<CsvImportService>(
  (ref) => CsvImportService(ref.watch(databaseProvider)),
);

final importTemplateServiceProvider = Provider<ImportTemplateService>(
  (ref) => ImportTemplateService(ref.watch(databaseProvider)),
);

/// Mappings the user has saved, most recently useful first.
final importTemplatesProvider = FutureProvider<List<ImportTemplate>>(
  (ref) => ref.watch(importTemplateServiceProvider).all(),
);
