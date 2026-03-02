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
  // Minimum required before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  await EnvService.init();
  await Firebase.initializeApp(); // Required: GoogleSignInService accesses FirebaseAuth.instance at provider creation
  final prefs = await SharedPreferences.getInstance();
  final db = constructDb();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );

  // Non-essential init runs after first frame is rendered
  _initializeServicesInBackground(db);
}

/// Initialize services that don't need to block the first frame.
/// Notifications, WorkManager, categories, and recurring transactions
/// all run here so the app renders faster.
Future<void> _initializeServicesInBackground(dynamic db) async {
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('[main] Notification init failed: $e');
  }

  try {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      BackgroundTaskConstants.periodicTaskUniqueName,
      BackgroundTaskConstants.periodicTaskName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  } catch (e) {
    debugPrint('[main] WorkManager init failed: $e');
  }

  try {
    final categoryService = CategoryInitializationService(db);
    await categoryService.initializeDefaultCategories();
    await db.ensureSystemCategoriesExist();
  } catch (e) {
    debugPrint('[main] Category init failed: $e');
  }

  try {
    await BackgroundTaskService.runStartupProcessing(db);
  } catch (e) {
    debugPrint('[main] Startup processing failed: $e');
  }
}
