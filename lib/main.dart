import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_accountant/app/app.dart';
import 'package:the_accountant/core/utils/env_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvService.init();
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize database and default data
  final db = constructDb();

  // Initialize default categories (user creates their own wallets during onboarding)
  final categoryService = CategoryInitializationService(db);
  await categoryService.initializeDefaultCategories();

  // Ensure system categories exist (Transfer, Balance Correction)
  await db.ensureSystemCategoriesExist();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}
