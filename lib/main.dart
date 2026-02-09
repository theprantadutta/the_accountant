import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:the_accountant/app/app.dart';
import 'package:the_accountant/core/utils/env_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/core/services/category_initialization_service.dart';
import 'package:the_accountant/core/providers/default_wallet_provider.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/core/services/background_task_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case BackgroundTaskConstants.periodicTaskName:
      case Workmanager.iOSBackgroundTask:
        return await BackgroundTaskService.executePeriodicProcessing();
      case BackgroundTaskConstants.dueDateReminderTaskName:
        return await BackgroundTaskService.executeDueDateReminder(inputData);
      default:
        return true;
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvService.init();
  await Firebase.initializeApp();

  // Initialize notification service (requests permission + sets up FCM handlers)
  await NotificationService().initialize();

  // Initialize WorkManager for background tasks
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    BackgroundTaskConstants.periodicTaskUniqueName,
    BackgroundTaskConstants.periodicTaskName,
    frequency: const Duration(hours: 1),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.notRequired),
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize database and default data
  final db = constructDb();

  // Initialize default categories (user creates their own wallets during onboarding)
  final categoryService = CategoryInitializationService(db);
  await categoryService.initializeDefaultCategories();

  // Ensure system categories exist (Transfer, Balance Correction)
  await db.ensureSystemCategoriesExist();

  // Run startup catch-up for any missed recurring transactions
  await BackgroundTaskService.runStartupProcessing(db);

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
