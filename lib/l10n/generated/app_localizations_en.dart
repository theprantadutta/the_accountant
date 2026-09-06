// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsRegionalTitle => 'Regional Settings';

  @override
  String get settingsSectionCurrency => 'CURRENCY';

  @override
  String get settingsSectionDisplayFormat => 'DISPLAY FORMAT';

  @override
  String get settingsSectionLanguage => 'LANGUAGE';

  @override
  String get settingsDefaultCurrency => 'Default Currency';

  @override
  String get settingsExchangeRates => 'Exchange Rates';

  @override
  String get settingsExchangeRatesSubtitle =>
      'Manage currency conversion rates';

  @override
  String get settingsDateFormat => 'Date Format';

  @override
  String get settingsNumberFormat => 'Number Format';

  @override
  String get settingsCurrencySymbol => 'Currency Symbol';

  @override
  String get settingsTimeFormat => 'Time Format';

  @override
  String get settingsFirstDayOfWeek => 'First Day of the Week';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsPreview => 'Preview';

  @override
  String get previewDate => 'Date';

  @override
  String get previewTime => 'Time';

  @override
  String get previewAmount => 'Amount';

  @override
  String get previewWeekStarts => 'This week starts';

  @override
  String get choiceMatchMyPhone => 'Match my phone';

  @override
  String get symbolBeforeAmount => 'Before the amount';

  @override
  String get symbolAfterAmount => 'After the amount';

  @override
  String get time12Hour => '12-hour (1:30 PM)';

  @override
  String get time24Hour => '24-hour (13:30)';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get selectDateFormat => 'Select Date Format';

  @override
  String get selectNumberFormat => 'Select Number Format';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get themeTitle => 'Choose Your Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystemDescription => 'Match whatever your phone is set to';

  @override
  String get themeLightDescription => 'Bright, for daylight and shared screens';

  @override
  String get themeDarkDescription =>
      'The original - deep space with indigo accents';

  @override
  String get languageSystem => 'Match my phone';

  @override
  String get navHome => 'Home';

  @override
  String get navActivity => 'Activity';

  @override
  String get navAi => 'AI';

  @override
  String get navInsights => 'Insights';

  @override
  String get navAiAssistant => 'AI Assistant';

  @override
  String get sectionAccount => 'ACCOUNT';

  @override
  String get sectionMoney => 'MONEY';

  @override
  String get sectionRegional => 'REGIONAL';

  @override
  String get sectionNotifications => 'NOTIFICATIONS';

  @override
  String get sectionPrivacySecurity => 'PRIVACY & SECURITY';

  @override
  String get sectionDataManagement => 'DATA MANAGEMENT';

  @override
  String get sectionHelpSupport => 'HELP & SUPPORT';

  @override
  String get sectionAbout => 'ABOUT';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsAppearanceSubtitle => 'Theme and accent colour';

  @override
  String get settingsBackupRestore => 'Backup & Restore';

  @override
  String get settingsBackupRestoreSubtitle =>
      'A file you keep, or automatic copies in Google Drive';

  @override
  String get settingsImportStatement => 'Import a statement';

  @override
  String get settingsImportStatementSubtitle =>
      'Bring in a CSV from your bank, mapped once and remembered';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsRecentlyDeleted => 'Recently deleted';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'Put back something removed in the last thirty days';

  @override
  String get themeExpressYourself => 'Express Yourself';

  @override
  String get themeExpressYourselfBody =>
      'Choose a theme that reflects your style and makes managing finances a joy.';

  @override
  String get themePremiumHeading => 'Premium Themes';

  @override
  String get themeUnlockPremium => 'Unlock Premium Themes';

  @override
  String get actionRetry => 'Retry';

  @override
  String get dashCreditDebt => 'Credit & Debt';

  @override
  String get dashSubscriptions => 'Subscriptions';

  @override
  String get moneyIncome => 'Income';

  @override
  String get dashExpenses => 'Expenses';

  @override
  String get dashSpendingOverview => 'Spending Overview';

  @override
  String get dashRecentTransactions => 'Recent Transactions';

  @override
  String get dashBudgetProgress => 'Budget Progress';

  @override
  String get actionDelete => 'Delete';

  @override
  String txDeleteManyTitle(int count) {
    return 'Delete $count transactions?';
  }

  @override
  String get txDeleteManyBody =>
      'Balances are recalculated. Any transfer among them takes its other half with it.';

  @override
  String get txMoveToAccount => 'Move to account';

  @override
  String get txDeleted => 'Transaction deleted';

  @override
  String txDeleteFailed(String error) {
    return 'Could not delete that transaction: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get txActions => 'Actions';

  @override
  String get txChangeCategory => 'Change category';

  @override
  String get txChangeDate => 'Change date';

  @override
  String get txMarkAsPaid => 'Mark as paid';

  @override
  String get txDuplicate => 'Duplicate';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterClearAll => 'Clear all';

  @override
  String get filterAny => 'Any';

  @override
  String get filterSpent => 'Spent';

  @override
  String get filterEarned => 'Earned';

  @override
  String get filterHidden => 'Hidden';

  @override
  String get filterIncluded => 'Included';

  @override
  String get filterOnly => 'Only';

  @override
  String get filterFrom => 'From';

  @override
  String get filterTo => 'To';

  @override
  String get actionApply => 'Apply';

  @override
  String get dashThisMonth => 'This month';

  @override
  String get filterPaid => 'Paid';

  @override
  String get filterNotYet => 'Not yet';

  @override
  String get filterSkipped => 'Skipped';

  @override
  String get filterAmount => 'Amount';

  @override
  String get actionEdit => 'Edit';

  @override
  String get entityBudget => 'Budget';

  @override
  String get budgetGone => 'This budget no longer exists.';

  @override
  String get budgetEarlier => 'Earlier';

  @override
  String get budgetLater => 'Later';

  @override
  String get budgetWhereItWent => 'Where it went';

  @override
  String get budgetRecentPeriods => 'Recent periods';

  @override
  String get budgetCaps => 'Caps';

  @override
  String get actionAdd => 'Add';

  @override
  String get budgetNoCategoriesToCap =>
      'This budget has no categories to cap yet.';

  @override
  String get budgetCapACategory => 'Cap a category';

  @override
  String get entityCategory => 'Category';

  @override
  String get budgetAsShare => 'As a share of the budget';

  @override
  String get budgetAsShareHint => 'Moves with the budget when you change it';

  @override
  String get actionSet => 'Set';

  @override
  String get budgetAcrossPeriod => 'Across the period';

  @override
  String get budgetPreviousPeriod => 'Previous period';

  @override
  String get budgetEvenPace => 'Even pace';

  @override
  String get budgetNew => 'New budget';

  @override
  String get budgetCreate => 'Create a budget';

  @override
  String budgetDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get entityAccount => 'Account';

  @override
  String get entityTransaction => 'Transaction';

  @override
  String get walletGone => 'This account no longer exists.';

  @override
  String get walletCorrectBalance => 'Correct the balance';

  @override
  String get walletCorrectBalanceSubtitle =>
      'Record the difference from the real figure';

  @override
  String get walletMergeInto => 'Merge into another account';

  @override
  String get walletInThisMonth => 'In this month';

  @override
  String get walletOutThisMonth => 'Out this month';

  @override
  String get walletRecentActivity => 'Recent activity';

  @override
  String get walletNoOtherAccount => 'There is no other account to merge into.';

  @override
  String get walletMergeIntoTitle => 'Merge into';

  @override
  String get walletMergeAction => 'Merge';

  @override
  String walletMerged(int count, String target) {
    return 'Moved $count into $target.';
  }

  @override
  String get walletRealBalance => 'Real balance';

  @override
  String get walletCorrectAction => 'Correct';

  @override
  String get txGone => 'This transaction no longer exists.';

  @override
  String get txKind => 'Kind';

  @override
  String get txState => 'State';

  @override
  String get txWasDue => 'Was due';

  @override
  String get txNotes => 'Notes';

  @override
  String get txDeleteOneTitle => 'Delete this transaction?';

  @override
  String get rulesTitle => 'Naming rules';

  @override
  String get rulesAdd => 'Add rule';

  @override
  String rulesRemoved(String title) {
    return 'Removed the rule for $title';
  }

  @override
  String get rulesWhenTitleSays => 'When the title says';

  @override
  String get rulesMatchExactly => 'Match exactly';

  @override
  String get rulesChooseCategory => 'Choose category';

  @override
  String get actionSave => 'Save';

  @override
  String get goalNew => 'New goal';

  @override
  String get goalLoadFailed => 'Could not load your goals.';

  @override
  String get goalCreate => 'Create a goal';

  @override
  String get trashTitle => 'Recently deleted';

  @override
  String get trashRestore => 'Restore';

  @override
  String get trashRestored => 'Restored.';

  @override
  String get payTitle => 'Payment methods';

  @override
  String get payDefault => 'Default';

  @override
  String get payAddOne => 'Add one';

  @override
  String payDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get payName => 'Name';

  @override
  String get payNameHint => 'Everyday debit';

  @override
  String get payKind => 'Kind';

  @override
  String get payBankOrIssuer => 'Bank or issuer';

  @override
  String get payLastFour => 'Last four digits';

  @override
  String get payUseByDefault => 'Use by default';

  @override
  String get backupChecking => 'Checking…';

  @override
  String get backupLoading => 'Loading…';

  @override
  String get backupSaveACopy => 'Save a copy';

  @override
  String get backupAutomaticBackups => 'Automatic backups';

  @override
  String get backupHowManyBackupsToKeep => 'How many backups to keep';

  @override
  String get backupSaveABackupFile => 'Save a backup file';

  @override
  String get backupShareItToFilesEmail =>
      'Share it to Files, email, or anywhere you like';

  @override
  String get backupRestoreFromAFile => 'Restore from a file';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Replaces everything currently on this device';

  @override
  String get backupRestoreThisBackup => 'Restore this backup?';

  @override
  String get backupEraseRestore => 'Erase & Restore';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive is unavailable';

  @override
  String get backupConnectGoogleDrive => 'Connect Google Drive';

  @override
  String get backupBackUpNow => 'Back up now';

  @override
  String get backupKeep => 'Keep';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'The last automatic backup did not run';

  @override
  String get backupDisconnectGoogleDrive => 'Disconnect Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'Disconnect Google Drive?';

  @override
  String get backupDisconnect => 'Disconnect';

  @override
  String get backupDeleteThisBackup => 'Delete this backup?';

  @override
  String get importChooseACsvFile => 'Choose a CSV file';

  @override
  String get importRememberTheseSettingsForThis =>
      'Remember these settings for this bank';

  @override
  String get importChange => 'Change';

  @override
  String get importAuto => 'Auto';

  @override
  String get importDone => 'Done';

  @override
  String get importRememberThisBank => 'Remember this bank';

  @override
  String get importForget => 'Forget';

  @override
  String get importImport => 'Import';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsRefundPolicy => 'Refund Policy';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMeetTheDeveloper => 'Meet the Developer';

  @override
  String get settingsContactSupport => 'Contact Support';

  @override
  String get settingsSubject => 'Subject';

  @override
  String get settingsMessage => 'Message';

  @override
  String get settingsSendMessage => 'Send message';

  @override
  String get settingsUseApiRate => 'Use API Rate';

  @override
  String get settingsRefreshRates => 'Refresh rates';

  @override
  String get settingsSearchCurrencies => 'Search currencies...';

  @override
  String get settingsCustomRate => 'Custom rate';

  @override
  String get settingsSetCustomRate => 'Set custom rate';

  @override
  String get settingsNotNow => 'Not now';

  @override
  String get settingsGoPremium => 'Go Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Spreadsheet format for Excel, Google Sheets';

  @override
  String get settingsPdfReport => 'PDF Report';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Formatted summary with breakdowns';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'All income and expense records';

  @override
  String get settingsCategories => 'Categories';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Category breakdown and totals';

  @override
  String get settingsWallets => 'Wallets';

  @override
  String get settingsWalletBalancesAndHistory => 'Wallet balances and history';

  @override
  String get settingsHelpFaq => 'Help & FAQ';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLargeTransactionThreshold => 'Large Transaction Threshold';

  @override
  String get settingsRemindMeBeforeDueDate => 'Remind Me Before Due Date';

  @override
  String get settingsTestNotificationSentCheckYour =>
      'Test notification sent! Check your notifications.';

  @override
  String get settingsTest => 'Test';

  @override
  String get settingsDailyReminders => 'DAILY REMINDERS';

  @override
  String get settingsDailyReminders2 => 'Daily Reminders';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Get reminded to track your expenses';

  @override
  String get settingsBudgetAlerts => 'BUDGET ALERTS';

  @override
  String get settingsBudgetAlerts2 => 'Budget Alerts';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'Notify when approaching budget limit';

  @override
  String get settingsWarningThreshold => 'Warning Threshold';

  @override
  String get settingsTransactionAlerts => 'TRANSACTION ALERTS';

  @override
  String get settingsLargeTransactionAlerts => 'Large Transaction Alerts';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'Notify for transactions above threshold';

  @override
  String get settingsRecurringTransactionReminders =>
      'Recurring Transaction Reminders';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'Remind about upcoming recurring payments';

  @override
  String get settingsOtherNotifications => 'OTHER NOTIFICATIONS';

  @override
  String get settingsSubscriptionExpiryAlerts => 'Subscription Expiry Alerts';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Get notified before your premium expires';

  @override
  String get settingsPromotionalNotifications => 'Promotional Notifications';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Receive offers and feature updates';

  @override
  String get settingsTurnOnDailyReminders => 'Turn on daily reminders?';

  @override
  String get settingsEnterAmount => 'Enter amount';

  @override
  String get settingsReminderTime => 'Reminder Time';

  @override
  String get settingsPrivacySecurity => 'Privacy & Security';

  @override
  String get settingsSecurity => 'SECURITY';

  @override
  String get settingsBiometricLock => 'Biometric Lock';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Use fingerprint or face to unlock';

  @override
  String get settingsAutoLock => 'Auto-lock';

  @override
  String get settingsDataPrivacy => 'DATA PRIVACY';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsClearCachedDataAndForce =>
      'Clear cached data and force re-sync';

  @override
  String get settingsClearAllData => 'Clear All Data';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Delete all transactions, budgets, and settings';

  @override
  String get settingsLegal => 'LEGAL';

  @override
  String get settingsReadOurPrivacyPolicy => 'Read our privacy policy';

  @override
  String get settingsReadOurTermsOfService => 'Read our terms of service';

  @override
  String get settingsHowRefundsAndCancellationsWork =>
      'How refunds and cancellations work';

  @override
  String get settingsDangerZone => 'DANGER ZONE';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Permanently delete your account and all data';

  @override
  String get settingsAutoLockTimeout => 'Auto-lock Timeout';

  @override
  String get settingsDeleteEverything => 'Delete Everything';

  @override
  String get settingsAreYouAbsolutelySure => 'Are you absolutely sure?';

  @override
  String get settingsYesDeleteAll => 'Yes, Delete All';

  @override
  String get settingsContinue => 'Continue';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsDisplayName => 'Display name';

  @override
  String get settingsEmailAddress => 'Email address';

  @override
  String get settingsUnsavedChanges => 'Unsaved Changes';

  @override
  String get settingsStay => 'Stay';

  @override
  String get settingsLeave => 'Leave';

  @override
  String get settingsSearchByCodeOrName => 'Search by code or name...';

  @override
  String get settingsSearchSettings => 'Search settings...';

  @override
  String get settingsSubscription => 'Subscription';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsGoals => 'Goals';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Save toward something and track how far along you are';

  @override
  String get settingsBudgets => 'Budgets';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Set limits and see how the period is going';

  @override
  String get settingsUpcomingAndOverdue => 'Upcoming and overdue';

  @override
  String get settingsWhatIsDueAndWhat => 'What is due, and what was missed';

  @override
  String get settingsRenameRecolourAndGroupThem =>
      'Rename, recolour, and group them';

  @override
  String get settingsAccounts => 'Accounts';

  @override
  String get settingsAddReorderAndEditYour =>
      'Add, reorder, and edit your accounts';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'The cards and accounts you pay with';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Where something goes, based on what it is called';

  @override
  String get settingsNotificationSettings => 'Notification Settings';

  @override
  String get settingsDailyRemindersBudgetAlerts =>
      'Daily reminders, budget alerts';

  @override
  String get settingsBiometricLockDataManagement =>
      'Biometric lock, data management';

  @override
  String get settingsCloudSync => 'Cloud Sync';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Sync your data across devices';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV is free · PDF report is Premium';

  @override
  String get settingsGetAnswersToCommonQuestions =>
      'Get answers to common questions';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Questions, complaints, or feedback';

  @override
  String get settingsRateTheApp => 'Rate the App';

  @override
  String get settingsShareWithFriends => 'Share with Friends';

  @override
  String get settingsReplayAppTour => 'Replay App Tour';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'See the feature walkthrough again';

  @override
  String get settingsAboutTheAccountant => 'About The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Version, licenses, and more';

  @override
  String get settingsTestCrash => 'Test Crash';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Trigger a test exception for Crashlytics';

  @override
  String get settingsDeveloper => 'DEVELOPER';

  @override
  String get settingsRestoreFromCloud => 'Restore from Cloud?';

  @override
  String get settingsSyncing => 'Syncing...';

  @override
  String get settingsSynced => 'Synced';

  @override
  String get settingsSyncError => 'Sync Error';

  @override
  String get settingsOffline => 'Offline';

  @override
  String get settingsReady => 'Ready';

  @override
  String get settingsYesUseThis => 'Yes, use this';

  @override
  String get settingsKeepThemSeparate => 'Keep them separate?';

  @override
  String get settingsCurrentPassword => 'Current Password';

  @override
  String get settingsNewPassword => 'New Password';

  @override
  String get settingsConfirmPassword => 'Confirm Password';

  @override
  String get walletEGPersonalSavingsBusiness =>
      'e.g., Personal, Savings, Business';

  @override
  String get walletEnterCreditLimit => 'Enter credit limit';

  @override
  String get walletSelectBillingDay => 'Select billing day';

  @override
  String get walletCreateAccount => 'Create Account';

  @override
  String get walletWalletCreatedSuccessfully => 'Wallet created successfully';

  @override
  String get walletAccountUpdatedSuccessfully => 'Account updated successfully';

  @override
  String get walletEditAccount => 'Edit Account';

  @override
  String get walletSetAsDefault => 'Set as Default';

  @override
  String get walletUseDecimals => 'Use Decimals';

  @override
  String get walletSaveWallet => 'Save Wallet';

  @override
  String get walletEnterWalletName => 'Enter wallet name';

  @override
  String get walletCurrency => 'Currency';

  @override
  String get walletSelectBillingDayOptional => 'Select billing day (optional)';

  @override
  String get walletIcon => 'Icon';

  @override
  String get walletColor => 'Color';

  @override
  String get walletWalletName => 'Wallet Name';

  @override
  String get walletInitialBalance => 'Initial Balance';

  @override
  String get txScan => 'Scan';

  @override
  String get txAddATransferFee => 'Add a transfer fee';

  @override
  String get txRemove => 'Remove';

  @override
  String get txPaymentMethod => 'Payment Method';

  @override
  String get txObjective => 'Objective';

  @override
  String get txTitle => 'Title';

  @override
  String get txTesco => 'Tesco';

  @override
  String get txAll => 'All';

  @override
  String get txSkip => 'Skip';

  @override
  String get txMarkAsPaid2 => 'Mark as Paid';

  @override
  String get txUndo => 'Undo';

  @override
  String get txNoLoan => 'No loan';

  @override
  String get txLentMoney => 'Lent Money';

  @override
  String get txBorrowedMoney => 'Borrowed Money';

  @override
  String get goalShowOnTheHomeScreen => 'Show on the home screen';

  @override
  String get goalWhatAreYouSavingFor => 'What are you saving for?';

  @override
  String get goalNewLaptop => 'New laptop';

  @override
  String get goalTarget => 'Target';

  @override
  String get goalColour => 'Colour';

  @override
  String get goalClear => 'Clear';

  @override
  String get goalGoal => 'Goal';

  @override
  String get goalThisGoalNoLongerExists => 'This goal no longer exists.';

  @override
  String get goalAddToGoal => 'Add to goal';

  @override
  String get goalUnlink => 'Unlink';

  @override
  String get reportMaybeLater => 'Maybe Later';

  @override
  String get reportUpgrade => 'Upgrade';

  @override
  String get budgetSpending => 'Spending';

  @override
  String get budgetEarnings => 'Earnings';

  @override
  String get budgetEvery => 'Every';

  @override
  String get budgetCarryOverWhatIsLeft => 'Carry over what is left';

  @override
  String get budgetGroceries => 'Groceries';

  @override
  String get authLinkYourAccount => 'Link Your Account';

  @override
  String get authPassword => 'Password';

  @override
  String get authLinkAccount => 'Link Account';

  @override
  String get authEmailAddress => 'Email Address';

  @override
  String get authSendResetCode => 'Send Reset Code';

  @override
  String get authResetCode => 'Reset Code';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authSignInToContinueYour =>
      'Sign in to continue your financial journey';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authJoinUsToStartYour => 'Join us to start your financial journey';

  @override
  String get authFullName => 'Full Name';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Monthly';

  @override
  String get premiumYearly => 'Yearly';

  @override
  String get premiumLifetime => 'Lifetime';

  @override
  String get premiumNotNow => 'Not Now';

  @override
  String get aiRename => 'Rename';

  @override
  String get aiRenameChat => 'Rename chat';

  @override
  String get aiDeleteChat => 'Delete chat?';

  @override
  String get aiChatName => 'Chat name';

  @override
  String get aiRefreshSummary => 'Refresh Summary';

  @override
  String get aiNetSavings => 'Net Savings';

  @override
  String get aiScanReceipt => 'Scan Receipt';

  @override
  String get aiCamera => 'Camera';

  @override
  String get aiGallery => 'Gallery';

  @override
  String get aiMerchantTitle => 'Merchant / title';

  @override
  String get aiSaveAsTransaction => 'Save as transaction';

  @override
  String get onboardBrowseThemes => 'Browse themes';

  @override
  String get onboardBack => 'Back';

  @override
  String get onboardGetStarted => 'Get Started';

  @override
  String get onboardMainAccount => 'Main Account';

  @override
  String get creditRecordPayment => 'Record Payment';

  @override
  String get creditPleaseEnterAValidAmount => 'Please enter a valid amount';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'Amount exceeds remaining balance';

  @override
  String get creditPaymentAmount => 'Payment Amount';

  @override
  String get subSubscriptionName => 'Subscription name';

  @override
  String get catDeleteCategory => 'Delete Category';

  @override
  String get catPleaseEnterACategoryName => 'Please enter a category name';

  @override
  String get catEnterCategoryName => 'Enter category name';

  @override
  String get catNothingItsOwnCategory => 'Nothing — its own category';

  @override
  String get notifEnableNotifications => 'Enable Notifications';

  @override
  String get startupContinueWithoutChecking => 'Continue without checking?';

  @override
  String get startupContinueOffline => 'Continue offline';

  @override
  String get startupViewSubscriptionOptions => 'View subscription options';

  @override
  String get sharedWelcomeBack => 'Welcome back';

  @override
  String get sharedRestoringYourDataFromThe =>
      'Restoring your data from the cloud…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return 'Merge $source into $target?';
  }
}
