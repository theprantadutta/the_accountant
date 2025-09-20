import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/app/app.dart';
import 'package:the_accountant/core/utils/env_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/services/wallet_initialization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvService.init();
  await Firebase.initializeApp();

  // Initialize database and default data
  final db = constructDb();

  // Initialize default categories
  final categoryService = CategoryInitializationService(db);
  await categoryService.initializeDefaultCategories();

  // Initialize default wallets
  final walletService = WalletInitializationService(db);
  await walletService.initializeDefaultWallets();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MyApp(),
    ),
  );
}
