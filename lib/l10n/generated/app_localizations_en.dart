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
  String get navTransactions => 'Transactions';

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
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'Match my phone';

  @override
  String get sectionAccount => 'ACCOUNT';

  @override
  String get sectionDataManagement => 'DATA MANAGEMENT';

  @override
  String get sectionHelpSupport => 'HELP & SUPPORT';

  @override
  String get settingsAppearance => 'Appearance';

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
  String get themePremiumHeading => 'Premium Themes';

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
  String get txMarkAsCorrection => 'Mark as balance correction';

  @override
  String get txMarkAsCorrectionTitle => 'Not income or spending?';

  @override
  String get txMarkAsCorrectionBody =>
      'Use this for money that was neither earned nor spent, like a card\'s limit going up. The balance stays the same; it just stops counting as income or spending.';

  @override
  String get txMarkedAsCorrection => 'Now a balance correction.';

  @override
  String get txMarkAsCorrectionFailed => 'This one cannot be a correction.';

  @override
  String get txDuplicate => 'Duplicate';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterDirection => 'Direction';

  @override
  String get filterState => 'State';

  @override
  String get filterKind => 'Kind';

  @override
  String get filterTransfers => 'Transfers';

  @override
  String get filterAccounts => 'Accounts';

  @override
  String get filterCategories => 'Categories';

  @override
  String get filterDates => 'Dates';

  @override
  String get filterBudget => 'Budget';

  @override
  String get filterGoal => 'Goal';

  @override
  String get filterNone => 'None';

  @override
  String get filterThisMonth => 'This month';

  @override
  String get filterLastMonth => 'Last month';

  @override
  String get filterLast3Months => 'Last 3 months';

  @override
  String get filterThisYear => 'This year';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count transactions',
      one: 'Show 1 transaction',
      zero: 'No transactions match',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Clear';

  @override
  String get filterNoMatches => 'No matches';

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
  String walletMergedWithTransfersRemoved(
    int count,
    String target,
    int removed,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      removed,
      locale: localeName,
      other: '$removed transfers between the two accounts were removed',
      one: 'One transfer between the two accounts was removed',
    );
    return 'Moved $count into $target. $_temp0, as it no longer had two ends.';
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
  String get settingsCardsInNetWorth => 'Count credit cards in net worth';

  @override
  String get settingsCardsInNetWorthSub =>
      'Off: only money you have counts, not card balances.';

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
  String get settingsCloudSync => 'Cloud Sync';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Sync your data across devices';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV is free · PDF report is Premium';

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
  String get syncBackgroundFailed =>
      'Couldn\'t sync. Your changes are safe on this device and will sync later.';

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
  String get walletEnterWalletName => 'Enter wallet name';

  @override
  String get walletCurrency => 'Currency';

  @override
  String get walletIcon => 'Icon';

  @override
  String get walletColor => 'Color';

  @override
  String get walletWalletName => 'Wallet Name';

  @override
  String get walletInitialBalance => 'Initial Balance';

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
  String get txConfirmPayment => 'Confirm payment';

  @override
  String get txAmountCharged => 'Amount charged';

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
  String get creditPaidOn => 'Paid on';

  @override
  String get creditFullAmount => 'Full amount';

  @override
  String get subSubscriptionName => 'Subscription name';

  @override
  String get subAskBeforeEachPayment => 'Ask before recording each payment';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Each payment waits in Upcoming until you confirm what was charged, or skip it. Best for charges that vary, like a card paid in another currency.';

  @override
  String get subChangesApplyFromNext =>
      'A new amount or account applies from the next payment. Payments already made stay as they were.';

  @override
  String get catPleaseEnterACategoryName => 'Please enter a category name';

  @override
  String get catEnterCategoryName => 'Enter category name';

  @override
  String get catSearch => 'Search categories';

  @override
  String get catNoMatch => 'No category matches that.';

  @override
  String get catUseEmoji => 'Use an emoji';

  @override
  String get catEmojiHint => 'Type or pick one emoji';

  @override
  String get catArchive => 'Archive';

  @override
  String get catMergeInto => 'Merge into…';

  @override
  String catMergeIntoTitle(String name) {
    return 'Merge $name into';
  }

  @override
  String get catMergeBuiltIn => 'Built-in';

  @override
  String get catMergeNoTargets =>
      'There is no other category of the same kind to merge into.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return 'Merge $from into $to?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Every transaction, budget and subcategory in $from moves to $to, and $from is removed. This syncs to your other devices.';
  }

  @override
  String get catMergeAction => 'Merge';

  @override
  String catMerged(String from, String to) {
    return 'Merged $from into $to.';
  }

  @override
  String get catExpenseSection => 'Expense categories';

  @override
  String get catIncomeSection => 'Income categories';

  @override
  String get catSectionEmpty => 'None yet';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subcategories',
      one: '1 subcategory',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'In $name';
  }

  @override
  String get catAddSubcategory => 'Add subcategory';

  @override
  String get catNoSubcategoriesYet => 'No subcategories yet. Add one';

  @override
  String get catMoveTo => 'Move to…';

  @override
  String catMoveToTitle(String name) {
    return 'Move $name to';
  }

  @override
  String get catTopLevel => 'Top level';

  @override
  String get catTopLevelHint => 'Not inside any category';

  @override
  String catMovedInto(String name, String parent) {
    return '$name is now in $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name is now a top-level category.';
  }

  @override
  String get catMoveNoParents => 'There is no category it can go inside.';

  @override
  String get catMoveTransactions => 'Move transactions…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Move $name\'s transactions to';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Move $count transactions to $to?',
      one: 'Move 1 transaction to $to?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Only the transactions move. $from stays, with its budgets and subcategories. This syncs to your other devices.';
  }

  @override
  String get catMoveAction => 'Move';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count transactions to $to.',
      one: 'Moved 1 transaction to $to.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name has no transactions to move.';
  }

  @override
  String get catNoMoveTargets =>
      'There is no other category of the same kind to move them to.';

  @override
  String catDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get catDeleteEmptyBody =>
      'It has no transactions, so nothing else changes.';

  @override
  String get catDeleteChildrenNote =>
      'Its subcategories move to the top level.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transactions are filed under it. What should happen to them?',
      one: '1 transaction is filed under it. What should happen to it?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'Move to another category';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Then $name is deleted. Budgets that used it move too.';
  }

  @override
  String get catDeleteThemToo => 'Delete the transactions too';

  @override
  String get catDeleteThemTooHint =>
      'They go to Recently deleted, where you can restore them for 30 days.';

  @override
  String catDeleted(String name) {
    return 'Deleted $name.';
  }

  @override
  String get catActionFailed => 'That could not be done. Try again.';

  @override
  String get catStaysTopLevel =>
      'This category has subcategories of its own, so it stays at the top level.';

  @override
  String get catUnarchive => 'Unarchive';

  @override
  String get catArchivedSection => 'Archived';

  @override
  String get catArchivedHint =>
      'Kept for their history, but not offered when you add a transaction.';

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

  @override
  String get backupNothingHereYet => 'Nothing here yet.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Applied automatically when a file has these columns';

  @override
  String get importDateFormat => 'Date format';

  @override
  String get importChooseOne => 'Choose one';

  @override
  String get importDecimalPoint => 'Decimal point';

  @override
  String get importFlipTheSigns => 'Flip the signs';

  @override
  String get importForExportsThatWriteA =>
      'For exports that write a spend as positive';

  @override
  String get importWhereRowsGoWhenThe =>
      'Where rows go when the file does not name an account of yours';

  @override
  String get importSkipWhatIsAlreadyHere => 'Skip what is already here';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Create categories the file names';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Otherwise those rows arrive uncategorised';

  @override
  String get importCategoriesInThisFile => 'Categories in this file';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Made with love for personal finance';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'Developed & Maintained By:';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Close';

  @override
  String get settingsGetInTouch => 'Get in touch';

  @override
  String get settingsAsAPremiumMemberYour =>
      'As a Premium member, your request is flagged for priority.';

  @override
  String get settingsWhatToInclude => 'What to include';

  @override
  String get settingsNoCurrenciesFound => 'No currencies found';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Export your financial data to analyze in other apps or keep as a backup.';

  @override
  String get settingsDateRange => 'Date Range';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'PDF Reports';

  @override
  String get settingsGettingStarted => 'Getting Started';

  @override
  String get settingsStillNeedHelp => 'Still need help?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'Our support team is here to help you';

  @override
  String get settingsAppLocked => 'App Locked';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Unlock to access The Accountant';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Configure when and how The Accountant should remind you to track your expenses.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'Your email is used to sign in and can’t be changed here.';

  @override
  String get settingsYourDataIsOnThis => 'Your data is on this device only';

  @override
  String get settingsUpgradeForCloudSync => 'Upgrade for cloud sync';

  @override
  String get settingsNoSettingsFound => 'No settings found';

  @override
  String get settingsTryADifferentSearchTerm => 'Try a different search term';

  @override
  String get settingsSyncStatus => 'SYNC STATUS';

  @override
  String get settingsSyncNow => 'Sync Now';

  @override
  String get settingsRestoreFromCloud2 => 'Restore from Cloud';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'NEEDS YOUR CONFIRMATION';

  @override
  String get walletCreateYourFirstAccount => 'Create Your First Account';

  @override
  String get walletYouNeedAtLeastOne =>
      'You need at least one account to start tracking your finances';

  @override
  String get walletAccountType => 'Account Type';

  @override
  String get walletAccountName => 'Account Name';

  @override
  String get walletCreditLimit => 'Credit Limit';

  @override
  String get walletCreditLimitHelp =>
      'Limit went up? Change it here. A new limit is not income.';

  @override
  String get walletAmountOwed => 'Amount owed';

  @override
  String get walletAmountOwedHelp =>
      'What you owe on the card right now. Use 0 if it is paid off.';

  @override
  String get walletCurrentBalance => 'Current balance';

  @override
  String get walletCurrentBalanceHelp =>
      'A change is saved as a balance correction, so your history still adds up.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'What is $amount on this card?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Credit I have left';

  @override
  String get walletCardBalanceOwed => 'What I owe';

  @override
  String get walletCardBalanceChoose =>
      'Choose what this amount is, so the debt is worked out right.';

  @override
  String get walletBillingCycleDayOptional => 'Billing Cycle Day (optional)';

  @override
  String get walletThisWillBeYourDefault => 'This will be your default account';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Nothing recorded against this account yet.';

  @override
  String get walletAddAccount => 'Add Account';

  @override
  String get walletYourAccounts => 'Your Accounts';

  @override
  String get walletNoAccountsYet => 'No accounts yet';

  @override
  String get walletOutstanding => 'Outstanding';

  @override
  String get walletAvailable => 'Available';

  @override
  String get walletLimit => 'Limit';

  @override
  String get walletBalance => 'Balance';

  @override
  String get walletUseThisWalletForNew =>
      'Use this wallet for new transactions';

  @override
  String get walletSelectIcon => 'Select Icon';

  @override
  String get walletSelectColor => 'Select Color';

  @override
  String get txYouNeedAtLeast2 =>
      'You need at least 2 accounts to make a transfer';

  @override
  String get txNoAccountTitle => 'No account to record this against';

  @override
  String get txNoAccountBody =>
      'Add an account, or reopen a closed one, and this form is ready to use.';

  @override
  String get txNoAccountAction => 'Manage accounts';

  @override
  String get txDeleteTransaction => 'Delete Transaction';

  @override
  String get txAreYouSureYouWant =>
      'Are you sure you want to delete this transaction?';

  @override
  String get txTransactionType => 'Transaction Type';

  @override
  String get txTransferFee => 'Transfer fee';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Charged separately, so the transfer itself stays balanced.';

  @override
  String get txDeductedFrom => 'Deducted from';

  @override
  String get txNoPaymentMethods => 'No payment methods';

  @override
  String get txNothingDeletedRecently => 'Nothing deleted recently';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Anything you delete shows up here for thirty days.';

  @override
  String get txNoRulesYet => 'No rules yet';

  @override
  String get txClearAll => 'Clear All';

  @override
  String get txApplyFilters => 'Apply Filters';

  @override
  String get txUpcomingOverdue => 'Upcoming & Overdue';

  @override
  String get txNew => 'New';

  @override
  String get txLoan => 'Loan';

  @override
  String get goalStarted => 'Started';

  @override
  String get goalTargetDate => 'Target date';

  @override
  String get goalWithADateTheGoal =>
      'With a date, the goal works out how much to put aside each day.';

  @override
  String get goalCountedTowardThisGoal => 'Counted toward this goal';

  @override
  String get goalGettingThere => 'Getting there';

  @override
  String get goalSetATargetDateAnd =>
      'Set a target date and this works out what to put aside.';

  @override
  String get reportSpendingInsights => 'Spending Insights';

  @override
  String get reportNoSpendingDataForThis => 'No spending data for this period';

  @override
  String get reportNoCategorySpendingData => 'No category spending data';

  @override
  String get reportNoSpendingDataAvailable => 'No spending data available';

  @override
  String get reportBudgetVsActual => 'Budget vs Actual';

  @override
  String get reportNoActiveBudgets => 'No active budgets';

  @override
  String get reportCreateABudgetToTrack =>
      'Create a budget to track your spending';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Spending faster than the period is passing.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'Nothing recorded in this period.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent of $limit used';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount left';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount over';
  }

  @override
  String get budgetPeriodEnded => 'Period ended';

  @override
  String get budgetPaceOver => 'Over';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Password reset successfully. Please sign in.';

  @override
  String get authResendCode => 'Resend code';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authPleaseAcceptTheTermsAnd =>
      'Please accept the terms and conditions';

  @override
  String get authPasswordStrength => 'Password Strength';

  @override
  String get authAlreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get authPersonalInformation => 'Personal Information';

  @override
  String get authUpgradeToPremium => 'Upgrade to Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Unlock unlimited budgets, advanced analytics, and more!';

  @override
  String get authUpgradeNow => 'Upgrade Now';

  @override
  String get authPremiumMember => 'Premium Member';

  @override
  String get authEnjoyingAllPremiumFeatures => 'Enjoying all premium features';

  @override
  String get authSaveChanges => 'Save Changes';

  @override
  String get authAreYouSureYouWant =>
      'Are you sure you want to sign out of your account?';

  @override
  String get authChangeProfilePhoto => 'Change Profile Photo';

  @override
  String get authTakePhoto => 'Take Photo';

  @override
  String get authUseYourCamera => 'Use your camera';

  @override
  String get authChooseFromGallery => 'Choose from Gallery';

  @override
  String get authSelectAnExistingPhoto => 'Select an existing photo';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Photo selected! Upload feature coming soon.';

  @override
  String get authNameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get authProfileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Privacy & Terms';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Review these before you continue.';

  @override
  String get premiumLimitReached => 'Limit Reached';

  @override
  String get aiChats => 'Chats';

  @override
  String get aiNewChat => 'New chat';

  @override
  String get aiNoConversationsYet => 'No conversations yet';

  @override
  String get aiStartChattingAndYourThreads =>
      'Start chatting and your threads show up here.';

  @override
  String get aiScanAReceipt => 'Scan a receipt';

  @override
  String get aiReadingYourReceipt => 'Reading your receipt…';

  @override
  String get aiReviewSave => 'Review & save';

  @override
  String get aiWeReadThisFromYour =>
      'We read this from your receipt — check it and edit anything before saving.';

  @override
  String get dashErrorLoadingFinancialData => 'Error loading financial data';

  @override
  String get dashNoSpendingDataYet => 'No spending data yet';

  @override
  String get dashManage => 'Manage';

  @override
  String get dashAvailable => 'Available: ****';

  @override
  String get onboardWelcome => 'Welcome!';

  @override
  String get onboardSelectYourDefaultCurrency => 'Select your default currency';

  @override
  String get onboardLoadingCurrencies => 'Loading currencies...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'Set up your primary wallet';

  @override
  String get onboardInitialBalanceOptional => 'Initial Balance (optional)';

  @override
  String get onboardYourAccountIsReadyTo => 'Your account is ready to use';

  @override
  String get onboardTipYouCanAddMore =>
      'Tip: You can add more accounts with different currencies anytime from the Wallets section.';

  @override
  String get creditSettled => 'Settled';

  @override
  String get creditOverdue => 'Overdue';

  @override
  String creditTabCredit(int count) {
    return 'Lent ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Borrowed ($count)';
  }

  @override
  String get creditNetOutstanding => 'Net outstanding';

  @override
  String get creditAllSettled => 'All settled';

  @override
  String get creditOthersOweYou => 'Others owe you';

  @override
  String get creditYouOweOthers => 'You owe others';

  @override
  String creditOverdueCount(int count) {
    return '$count overdue';
  }

  @override
  String get creditEmptyAll => 'No money lent or borrowed';

  @override
  String get creditEmptyLent => 'No money lent';

  @override
  String get creditEmptyBorrowed => 'No money borrowed';

  @override
  String get creditEmptyAllSettled => 'Everything is settled.';

  @override
  String get creditEmptyHint =>
      'Add money you lent or borrowed to keep track of who owes whom.';

  @override
  String get creditShowAll => 'Show all';

  @override
  String get creditShowUnpaid => 'Show unpaid only';

  @override
  String get creditMoneyLent => 'Money lent';

  @override
  String get creditMoneyBorrowed => 'Money borrowed';

  @override
  String get creditTheyOweYou => 'They owe you';

  @override
  String get creditYouOwe => 'You owe';

  @override
  String get creditCollected => 'Collected';

  @override
  String creditPaidOf(String paid, String total) {
    return 'Paid $paid of $total';
  }

  @override
  String get creditRecord => 'Record';

  @override
  String get subRecurring => 'Recurring';

  @override
  String get subPaused => 'Paused';

  @override
  String get subAsksFirst => 'Asks first';

  @override
  String get subFrequency => 'Frequency';

  @override
  String get notifMarkAllRead => 'Mark all read';

  @override
  String get notifTryAgain => 'Try again';

  @override
  String get notifStayOnTopOfYour => 'Stay on top of your money';

  @override
  String get notifNoNotificationsYet => 'No notifications yet';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'When you receive notifications, they will appear here.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Nothing has been changed or deleted.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Include crypto currencies';

  @override
  String get sharedTotalBalance => 'Total Balance';

  @override
  String get heatmapTitle => 'Daily rhythm';

  @override
  String get heatmapSpentMore => 'Spent more';

  @override
  String get heatmapEarnedMore => 'Earned more';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transactions are not shown: no rate is known between their accounts\' currencies and $currency',
      one:
          'One transaction is not shown: no rate is known between its account\'s currency and $currency',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet => 'Nothing recorded in this period yet.';

  @override
  String get heatmapNetForRange => 'Net over this range';

  @override
  String get layoutTitle => 'Home layout';

  @override
  String get layoutSubtitle =>
      'Reorder the home screen, or hide what you do not use';

  @override
  String get layoutExplain =>
      'Drag to reorder. Anything switched off keeps its place, so turning it back on puts it where you left it.';

  @override
  String get layoutReset => 'Reset to default';

  @override
  String get layoutAllHidden =>
      'Every section is hidden. The home screen will be empty.';

  @override
  String get layoutSectionGreeting => 'Greeting';

  @override
  String get layoutSectionAccounts => 'Accounts';

  @override
  String get layoutSectionQuickStats => 'Income and expenses';

  @override
  String get layoutSectionQuickLinks => 'Shortcuts';

  @override
  String get layoutSectionSpendingChart => 'Spending overview';

  @override
  String get layoutSectionRecent => 'Recent transactions';

  @override
  String get layoutSectionBudgets => 'Budget progress';

  @override
  String get layoutSectionGoals => 'Pinned goals';

  @override
  String get shortcutAddExpense => 'Add expense';

  @override
  String get shortcutAddIncome => 'Add income';

  @override
  String get shortcutScanReceipt => 'Scan receipt';

  @override
  String get shortcutTransactions => 'Transactions';

  @override
  String get backupBusySyncing =>
      'A sync is running. Wait for it to finish before restoring.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get themeSunriseLight => 'Sunrise Light';

  @override
  String get themeSunriseDark => 'Sunrise Dark';

  @override
  String get themeMatchSystem => 'Match system';

  @override
  String get themeMatchSystemHint =>
      'Switch between light and dark with your phone';

  @override
  String get themeUnlockAll => 'Unlock all themes';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Sunrise';

  @override
  String get themeAccentSapphire => 'Sapphire';

  @override
  String get themeAccentEmerald => 'Emerald';

  @override
  String get themeAccentRuby => 'Ruby';

  @override
  String get themeAccentAmethyst => 'Amethyst';

  @override
  String get themeAccentGraphite => 'Graphite';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Today';

  @override
  String get navAdd => 'Add';

  @override
  String get navStats => 'Stats';

  @override
  String get navMore => 'More';

  @override
  String get walkthroughTodayTitle => 'Your day at a glance';

  @override
  String get walkthroughTodayBody =>
      'Net worth, what you earned and spent, and today’s activity.';

  @override
  String get walkthroughAddTitle => 'Add in seconds';

  @override
  String get walkthroughAddBody =>
      'Tap Add to record an expense, income or transfer.';

  @override
  String get walkthroughTransactionsTitle => 'Your transactions';

  @override
  String get walkthroughTransactionsBody =>
      'Every transaction, month by month. Search and filter to find anything.';

  @override
  String get walkthroughStatsTitle => 'See where it goes';

  @override
  String get walkthroughStatsBody =>
      'Charts by week, month and year, by category.';

  @override
  String get walkthroughBellTitle => 'Stay informed';

  @override
  String get walkthroughBellBody =>
      'Budget alerts and reminders appear here. You’re all set!';

  @override
  String get walkthroughBalanceTitle => 'Your net worth';

  @override
  String get walkthroughBalanceBody =>
      'Every wallet adds up here, with a bar showing how it splits.';

  @override
  String get txTransfer => 'Transfer';

  @override
  String get txUncategorized => 'Uncategorized';

  @override
  String todayGoodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Good morning';

  @override
  String get todayGoodAfternoonPlain => 'Good afternoon';

  @override
  String get todayGoodEveningPlain => 'Good evening';

  @override
  String get todayNetWorth => 'Net worth';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount this month';
  }

  @override
  String get todayEarned => 'Earned';

  @override
  String get todaySpent => 'Spent';

  @override
  String get todayTitle => 'Today';

  @override
  String get todayRecent => 'Recent';

  @override
  String get todayAllActivity => 'All activity';

  @override
  String get todayNothingYet => 'Nothing yet today';

  @override
  String get todayNothingYetBody => 'Tap Add to record your first one.';

  @override
  String todayMoreWallets(int count) {
    return '+$count more';
  }

  @override
  String get todayCoachTitle => 'Ask your money coach';

  @override
  String get todayCoachBody => 'Answers and nudges from your own spending';

  @override
  String get todayNotifications => 'Notifications';

  @override
  String get todayWithinBudget => 'Within budget';

  @override
  String get todayOverBudget => 'Over budget';

  @override
  String get todayNetCredit => 'Net credit';

  @override
  String get todayNetDebt => 'Net debt';

  @override
  String get todayMonthly => 'Monthly';

  @override
  String get walletsTitle => 'Wallets';

  @override
  String get walletsNew => 'New';

  @override
  String get walletsAddHint => 'Add bank, cash, savings…';

  @override
  String get walletsPlanning => 'Planning';

  @override
  String get walletsUpcoming => 'Upcoming';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count due · $amount';
  }

  @override
  String get walletsUpcomingNone => 'Nothing due soon';

  @override
  String get walletsLendBorrow => 'Lend & borrow';

  @override
  String get splitTitle => 'Split a bill';

  @override
  String get splitSubtitle =>
      'Share a bill with friends; what they owe goes to Lend & borrow';

  @override
  String get splitWhatFor => 'What was it for';

  @override
  String get splitTotal => 'Total';

  @override
  String get splitPeople => 'People';

  @override
  String get splitYou => 'You';

  @override
  String get splitIncludeMe => 'I had a share';

  @override
  String get splitIncludeMeSub => 'Turn off when you paid for the others only';

  @override
  String get splitAddPerson => 'Add a person';

  @override
  String get splitPersonName => 'Name';

  @override
  String get splitKnownPeople => 'From Lend & borrow';

  @override
  String get splitRemove => 'Remove';

  @override
  String get splitPaidBy => 'Paid by';

  @override
  String get splitHow => 'How to split';

  @override
  String get splitEqual => 'Equally';

  @override
  String get splitExact => 'Amounts';

  @override
  String get splitPercent => 'Percent';

  @override
  String get splitShares => 'Shares';

  @override
  String get splitYourShare => 'Your share';

  @override
  String get splitOwesYou => 'Owes you';

  @override
  String splitYouOwe(String name) {
    return 'You owe $name';
  }

  @override
  String get splitPaidTheBill => 'Paid the bill';

  @override
  String splitSettlesWith(String name) {
    return 'Settles up with $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total from your account; $owed owed back to you';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Nothing leaves your account now; you owe $name $amount';
  }

  @override
  String get splitPercentLabel => 'Percent of the bill';

  @override
  String get splitSave => 'Split it';

  @override
  String get splitSaved => 'Split recorded';

  @override
  String get splitNeedCategory => 'Choose a category first.';

  @override
  String get splitThisBill => 'Split this bill';

  @override
  String get splitThisBillSub =>
      'With friends; what they owe goes to Lend & borrow';

  @override
  String get splitPartOf => 'Split bill';

  @override
  String walletsOwedToYou(String amount) {
    return 'You’re owed $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'You owe $amount';
  }

  @override
  String get walletsAllSettled => 'All settled';

  @override
  String get walletsGoals => 'Goals';

  @override
  String walletsGoalsSub(int count) {
    return '$count active';
  }

  @override
  String get walletsBudgets => 'Budgets';

  @override
  String get walletsSubscriptions => 'Subscriptions';

  @override
  String get walletsTransfer => 'Transfer between wallets';

  @override
  String get walletsArchived => 'Archived';

  @override
  String walletsDeleteMessage(String name) {
    return 'Delete “$name”? Every transaction in this account is deleted with it.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name deleted';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name is now your default';
  }

  @override
  String get walletsCreateFailed =>
      'Couldn’t create the account. Please try again.';

  @override
  String get walletsEmptyBody => 'Create your first account to start tracking.';

  @override
  String get walletsTypeBank => 'Bank account';

  @override
  String get walletsTypeCard => 'Credit card';

  @override
  String get walletsTypeCash => 'Cash';

  @override
  String get walletsTypeOther => 'Account';

  @override
  String get moreTitle => 'More';

  @override
  String get moreGoPremium => 'Go Premium';

  @override
  String get moreGoPremiumBody => 'AI assistant, cloud sync, themes';

  @override
  String get moreUnlock => 'Unlock';

  @override
  String get morePremiumActive => 'Premium is active';

  @override
  String get morePremiumThanks => 'Thanks for supporting The Accountant';

  @override
  String get sectionPreferences => 'PREFERENCES';

  @override
  String get sectionTools => 'MONEY TOOLS';

  @override
  String get moreAiAssistant => 'AI assistant';

  @override
  String get moreAiAssistantSub => 'Ask questions about your money';

  @override
  String get moreSignOutConfirm => 'Sign out of your account on this device?';

  @override
  String get moreSignOutFailed => 'Couldn’t sign out. Please try again.';

  @override
  String get moreDeviceOnlyBody =>
      'Free accounts aren’t backed up to the cloud, so reinstalling or switching phones can lose your data. Upgrade for cloud sync, or export a backup regularly.';

  @override
  String get moreUpgradeToPremium => 'Upgrade to Premium';

  @override
  String get moreUser => 'You';

  @override
  String get statsTitle => 'Stats';

  @override
  String get statsWeek => 'Week';

  @override
  String get statsMonth => 'Month';

  @override
  String get statsYear => 'Year';

  @override
  String get statsSpending => 'Spending';

  @override
  String get statsIncome => 'Income';

  @override
  String get statsCategories => 'Categories';

  @override
  String get statsSpent => 'Spent';

  @override
  String get statsEarned => 'Earned';

  @override
  String get statsNet => 'Net';

  @override
  String get statsThisMonth => 'This month';

  @override
  String statsVsLastMonth(String change) {
    return '$change vs last month';
  }

  @override
  String get statsInsightsSub => 'This month’s summary, trends & tips';

  @override
  String get statsAskCoach => 'Ask the AI coach about this';

  @override
  String statsOverBy(String amount) {
    return 'Over by $amount';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get activityAll => 'All';

  @override
  String get activitySpent => 'Spent';

  @override
  String get activityEarned => 'Earned';

  @override
  String get activityTransfers => 'Transfers';

  @override
  String activitySoFar(String month) {
    return '$month so far';
  }

  @override
  String activityNet(String amount) {
    return '$amount net';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches across all months',
      one: '1 match across all months',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'Last 7 days';

  @override
  String get statsPeriodThisMonth => 'This month';

  @override
  String get statsPeriodThisYear => 'This year';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Nothing matches “$query”';
  }

  @override
  String get activitySearchNothingBody =>
      'Every month was searched. Try fewer words, another spelling, or clear a filter.';

  @override
  String get activityIn => 'In';

  @override
  String get activityOut => 'Out';

  @override
  String get activityToday => 'Today';

  @override
  String get activityYesterday => 'Yesterday';

  @override
  String get activityTomorrow => 'Tomorrow';

  @override
  String get activityEmptyFutureTitle => 'No planned transactions';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Add future payments for $month';
  }

  @override
  String get activityEmptyNowTitle => 'No transactions yet';

  @override
  String get activityEmptyNowBody => 'Start tracking your expenses this month';

  @override
  String get activityEmptyPastTitle => 'No transactions found';

  @override
  String activityEmptyPastBody(String month) {
    return 'No records for $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions deleted',
      one: '1 transaction deleted',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return 'Moved $count to $name';
  }

  @override
  String get activityMixedCurrencies =>
      'These are held in different currencies, so there is no one account they can all move to. Select rows from one currency.';

  @override
  String activityMovedPartial(int count) {
    return 'Moved $count; transfers were left where they are';
  }

  @override
  String activityMoved(int count) {
    return 'Moved $count to another account';
  }

  @override
  String activityRedated(int count) {
    return 'Re-dated $count';
  }

  @override
  String get activityNothingToPay => 'Nothing was waiting to be paid';

  @override
  String activityMarkedPaid(int count) {
    return 'Marked $count as paid';
  }

  @override
  String activityCopiedPartial(int count) {
    return 'Copied $count; transfers cannot be copied on their own';
  }

  @override
  String activityCopied(int count) {
    return 'Copied $count';
  }

  @override
  String get activityDeleteOneBody =>
      'It will be removed from your records and your balance will be recalculated.';

  @override
  String get activitySearch => 'Search';

  @override
  String get addNewExpense => 'New expense';

  @override
  String get addNewIncome => 'New income';

  @override
  String get addNewTransfer => 'New transfer';

  @override
  String get addEditTitle => 'Edit transaction';

  @override
  String get addAmount => 'Amount';

  @override
  String get addCategory => 'Category';

  @override
  String get addMore => 'More';

  @override
  String get addWallet => 'Wallet';

  @override
  String addChangeDate(String date) {
    return 'Change date, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Change time, $time';
  }

  @override
  String get addSwapAccounts => 'Swap the two accounts';

  @override
  String get notifCheckTitle => 'Check notifications';

  @override
  String get notifAllowed => 'Notifications are allowed';

  @override
  String get notifAllowedHint => 'Reminders can reach this phone';

  @override
  String get notifBlocked => 'Notifications are off';

  @override
  String get notifBlockedHint => 'Tap to allow them, or nothing can reach you';

  @override
  String get notifSendTest => 'Send a test notification';

  @override
  String get notifSendTestHint =>
      'Sent from our server, the way reminders come';

  @override
  String get notifSending => 'Sending…';

  @override
  String get notifTestSent =>
      'Sent. It should appear in a few seconds, and in your inbox.';

  @override
  String notifTestFailed(String reason) {
    return 'It could not be sent: $reason';
  }

  @override
  String get notifTestOffline => 'no connection to the server';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant will send a gentle daily nudge to log your spending, at the time you choose. It needs permission to show notifications.';

  @override
  String get notifPrimerShow => 'Show reminder notifications';

  @override
  String get notifPrimerTime => 'Arrive at your chosen time';

  @override
  String get notifPrimerOff => 'You can turn this off anytime';

  @override
  String get notifPrimerAllow => 'Allow';

  @override
  String get cardBillsTitle => 'Card bills';

  @override
  String get cardBillsSubtitle =>
      'Credit card statements, due dates and reminders';

  @override
  String get cardBillsEmptyTitle => 'No credit cards yet';

  @override
  String get cardBillsEmptyBody =>
      'Add an account of the Credit card type, set its statement day and due day, and its bills show up here.';

  @override
  String get cardBillsAddCard => 'Add a card';

  @override
  String get cardStatementDay => 'Statement day';

  @override
  String get cardStatementDayHint =>
      'The day each month the bill is made. Everything up to the end of that day is on it.';

  @override
  String get cardDueDay => 'Payment due day';

  @override
  String get cardDueDayHint =>
      'The last day to pay the bill, the first time that day comes round after the statement.';

  @override
  String get cardRemindTitle => 'Remind me';

  @override
  String get cardRemindHint =>
      'Before the due date, if any of the bill is still unpaid. Sent around 9 AM.';

  @override
  String get cardRemindOff => 'Off';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before',
      one: 'The day before',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Not set';

  @override
  String cardDayOfMonth(int day) {
    return 'Day $day';
  }

  @override
  String get cardSetUpBody =>
      'Set the statement day and the due day to see this card\'s bills and get reminded before they are due.';

  @override
  String get cardSetUp => 'Set the dates';

  @override
  String cardDueBy(String date) {
    return 'Left to pay by $date';
  }

  @override
  String get cardLeftToPay => 'Left to pay';

  @override
  String cardStatementClosed(String date) {
    return 'Statement of $date';
  }

  @override
  String get cardPaidSince => 'Paid since';

  @override
  String cardThisCycle(String date) {
    return 'Spent since, next statement $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return '$card bill payment';
  }

  @override
  String get cardEdit => 'Edit card';

  @override
  String get cardEarlierStatements => 'EARLIER STATEMENTS';

  @override
  String get cardPaidShort => 'paid';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount unpaid';
  }

  @override
  String get cardStatusNotSetUp => 'Dates not set';

  @override
  String get cardStatusNothingDue => 'Nothing due';

  @override
  String get cardStatusPaid => 'Paid';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'Due today';

  @override
  String get cardStatusOverdue => 'Overdue';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid of $owed paid';
  }

  @override
  String get cardPayBill => 'Pay bill';

  @override
  String cardPayTitle(String card) {
    return 'Pay $card';
  }

  @override
  String get cardPayHint =>
      'Pay all of it or part of it. Anything you pay counts toward this bill, and the rest stays due.';

  @override
  String cardPayFull(String amount) {
    return 'Pay in full, $amount';
  }

  @override
  String get cardPayFullHint => 'Everything left on this bill';

  @override
  String get cardPayOther => 'Pay another amount';

  @override
  String get cardPayOtherHint => 'A part payment, or more than the bill';

  @override
  String get addNoteHint => 'Add a note';

  @override
  String get addRepeatMonthly => 'Repeat monthly';

  @override
  String get addMoreOptions => 'More options';

  @override
  String get addScanReceipt => 'Scan receipt';

  @override
  String get addDelete => 'Delete transaction';

  @override
  String get addTypeExpense => 'Expense';

  @override
  String get addTypeIncome => 'Income';

  @override
  String get addTypeTransfer => 'Transfer';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Unlock with Premium';

  @override
  String get gateFootnote => 'Lifetime or subscription · Restore anytime';

  @override
  String get aiCoachTitle => 'Meet your money coach';

  @override
  String get aiCoachBody =>
      'Ask in plain words. Get answers, nudges and plans built from your own spending.';

  @override
  String get aiAssistantTitle => 'AI assistant';

  @override
  String get aiAskAnything => 'Ask about your money…';

  @override
  String get aiSend => 'Send';

  @override
  String get aiCopy => 'Copy';

  @override
  String get aiCopied => 'Copied';

  @override
  String get aiRetry => 'Retry';

  @override
  String get aiDismiss => 'Dismiss';

  @override
  String get aiTyping => 'Coach is typing';

  @override
  String aiStarterCategory(String category) {
    return 'Where did my $category money go?';
  }

  @override
  String get aiStarterBudgets => 'Am I on track with my budgets?';

  @override
  String get aiStarterUpcoming => 'What bills are coming up?';

  @override
  String get aiStarterAnalyze => 'Analyze my recent spending patterns';

  @override
  String get aiStarterBudgetTips => 'Give me tips for better budgeting';

  @override
  String get aiStarterSave => 'How can I save more money?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” will be permanently deleted.';
  }

  @override
  String get aiJustNow => 'Just now';

  @override
  String get aiErrorTitle => 'The coach couldn’t answer';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'Everything the app can do, for you.';

  @override
  String get paywallActiveTitle => 'Premium is active';

  @override
  String get paywallActiveTagline => 'Thank you for your support!';

  @override
  String get paywallRestore => 'Restore';

  @override
  String get paywallProcessing => 'Processing…';

  @override
  String paywallTriggered(String feature) {
    return '$feature is a Premium feature';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get paywallFeatSync => 'Cloud sync';

  @override
  String get paywallFeatSyncSub => 'All devices';

  @override
  String get paywallFeatAi => 'AI assistant';

  @override
  String get paywallFeatAiSub => 'Unlimited, no ads';

  @override
  String get paywallFeatOcr => 'Receipt scan';

  @override
  String get paywallFeatOcrSub => 'OCR with AI';

  @override
  String get paywallFeatInsights => 'Spending insights';

  @override
  String get paywallFeatInsightsSub => 'Monthly trends';

  @override
  String get paywallFeatThemes => '5 themes';

  @override
  String get paywallFeatThemesSub => 'Exclusive';

  @override
  String get paywallFeatPdf => 'PDF reports';

  @override
  String get paywallFeatPdfSub => 'CSV stays free';

  @override
  String get paywallFeatUnlimited => 'Unlimited';

  @override
  String get paywallFeatUnlimitedSub => 'Wallets, budgets';

  @override
  String get paywallFeatSupport => 'Priority help';

  @override
  String get paywallFeatSupportSub => 'Faster replies';

  @override
  String get paywallPerMonth => '/month';

  @override
  String get paywallPerYear => '/year';

  @override
  String get paywallOnce => 'once';

  @override
  String get paywallBestValue => 'BEST VALUE';

  @override
  String get paywallForever => 'FOREVER';

  @override
  String get paywallMonthlyDesc => 'Billed monthly';

  @override
  String get paywallYearlyDesc => 'Billed yearly';

  @override
  String get paywallLifetimeDesc => 'Pay once, keep it forever';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial free, then $rest';
  }

  @override
  String get paywallCtaLifetime => 'Get lifetime access';

  @override
  String get paywallCtaYearly => 'Start yearly plan';

  @override
  String get paywallCtaMonthly => 'Start monthly plan';

  @override
  String get paywallFootLifetime => 'One-time purchase · No subscription';

  @override
  String get paywallFootSubscription =>
      'Renews automatically · Cancel anytime in the store';

  @override
  String get paywallTerms =>
      'Subscriptions are charged to your App Store or Google Play account and renew automatically unless canceled at least 24 hours before the end of the current period.';

  @override
  String get paywallIapUnavailable =>
      'In-app purchases are unavailable on this device. Make sure Google Play Services is installed and the app came from the Play Store.';

  @override
  String get paywallLoadingPlans => 'Loading plans…';

  @override
  String get paywallPlansFailed =>
      'Couldn’t load plans. Check your connection and try again.';

  @override
  String get paywallTryAgain => 'Try again';

  @override
  String get paywallRestored => 'Purchases restored';

  @override
  String get paywallPurchased => 'Welcome to Premium!';

  @override
  String get paywallLifetimeNever => 'Lifetime access never expires';

  @override
  String get helpSearchQuestions => 'Search questions';

  @override
  String get helpStepWallets => 'Add wallets';

  @override
  String get helpStepCategories => 'Pick categories';

  @override
  String get helpStepTrack => 'Track daily';

  @override
  String get splashTagline => 'Money, brighter.';

  @override
  String get introStep1 => 'Counting your coins…';

  @override
  String get introStep2 => 'Waking up your wallets…';

  @override
  String get introStep3 => 'Polishing the charts…';

  @override
  String get introStep4 => 'Almost there…';

  @override
  String get introTipLabel => 'Money tip';

  @override
  String get introTip1 =>
      'Pay yourself first: move savings out the day your salary lands.';

  @override
  String get introTip2 =>
      'Small daily spends add up. Logging them is half the battle.';

  @override
  String get introTip3 =>
      'A 3-month emergency fund turns surprises into inconveniences.';

  @override
  String get introTip4 =>
      'Review subscriptions monthly: cancel what you didn’t use.';

  @override
  String get introTip5 => 'Give every taka a job before the month starts.';

  @override
  String get introTip6 => 'Wait 24 hours before any unplanned purchase.';

  @override
  String get introTip7 =>
      'Budgets aren’t limits, they’re permission to spend on what matters.';

  @override
  String get introTip8 =>
      'Celebrate small wins: every goal starts with the first deposit.';

  @override
  String get adConfirmTitleAiCall => 'Get one more AI request';

  @override
  String get adConfirmTitleTheme => 'Try premium themes for 24 hours';

  @override
  String get adConfirmTitlePdf => 'Export one PDF report';

  @override
  String get adConfirmBodyAiCall =>
      'You\'ve used this month\'s free AI requests. Watch a short ad and you get one more.';

  @override
  String get adConfirmBodyTheme =>
      'Watch a short ad and every premium theme is yours for the next 24 hours.';

  @override
  String get adConfirmBodyPdf => 'Watch a short ad to export one PDF report.';

  @override
  String get adConfirmWarning => 'You\'re about to watch an ad. Continue?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more ads available this month',
      one: '1 more ad available this month',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Premium members get unlimited AI, every theme and PDF reports, with no ads at all.';

  @override
  String get adWatch => 'Watch ad';

  @override
  String get adGetPremium => 'Get Premium';

  @override
  String get adNotNow => 'Not now';

  @override
  String get adLoading => 'Loading the ad…';

  @override
  String get adVerifying => 'Confirming your reward…';

  @override
  String get adUnavailable =>
      'No ad is available right now. Please try again in a little while.';

  @override
  String get adSkipped =>
      'The ad was closed before the end, so nothing was unlocked.';

  @override
  String get adRewardAiCall => 'Done! You have one more AI request.';

  @override
  String get adRewardTheme => 'Premium themes unlocked for 24 hours.';

  @override
  String get adRewardPdf => 'One PDF export unlocked.';

  @override
  String get adMonthlyCapReached =>
      'That\'s all the ads for this month. Your free requests come back on the 1st, or go Premium for unlimited.';

  @override
  String get adRewardPending => 'Thanks! Your reward will appear in a moment.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count free AI requests left this month',
      one: '1 free AI request left this month',
      zero: 'No free AI requests left this month',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: unlimited';

  @override
  String get aiToolSearching => 'Searching your transactions…';

  @override
  String get aiToolSummarizing => 'Adding up the numbers…';

  @override
  String get aiToolAccounts => 'Checking your accounts…';

  @override
  String get aiToolCategories => 'Looking at your categories…';

  @override
  String get aiToolCards => 'Checking card bills…';

  @override
  String get aiToolPlans => 'Checking EMIs and savings…';

  @override
  String get aiToolSaving => 'Saving…';

  @override
  String get aiActionAddTitle => 'Add this transaction?';

  @override
  String get aiActionUpdateTitle => 'Change this transaction?';

  @override
  String get aiActionDeleteTitle => 'Delete this transaction?';

  @override
  String get aiActionPayCardTitle => 'Pay a card bill';

  @override
  String get aiActionCardSettingsTitle => 'Change card dates';

  @override
  String get aiActionCreatePlanTitle => 'Start a plan';

  @override
  String get aiActionPayPlanTitle => 'Record a plan payment';

  @override
  String get aiActionClosePlanTitle => 'End a plan early';

  @override
  String get aiActionUpdatePlanTitle => 'Change a plan';

  @override
  String get aiActionCreateInvestmentTitle => 'Add an investment';

  @override
  String get aiActionTradeInvestmentTitle => 'Record a trade';

  @override
  String get aiActionUpdateInvestmentTitle => 'Update a price';

  @override
  String get aiActionConfirm => 'Confirm';

  @override
  String get aiActionClosePlan => 'End it';

  @override
  String get aiActionFrom => 'From';

  @override
  String get aiActionTo => 'To';

  @override
  String get aiActionBill => 'Bill';

  @override
  String get aiActionLeftAfter => 'Left after';

  @override
  String get aiActionRemindDays => 'Remind, days before';

  @override
  String get aiActionPay => 'Pay';

  @override
  String get plansTitle => 'EMI, loans & savings';

  @override
  String get investmentsTitle => 'Investments';

  @override
  String get investmentsSubtitle =>
      'Mutual funds, shares and SIPs, valued at their latest price';

  @override
  String get forecastTitle => 'Cash flow forecast';

  @override
  String get forecastSubtitle =>
      'Where your cash and bank money is headed, and any day it runs short';

  @override
  String forecastRangeDays(int days) {
    return '$days days';
  }

  @override
  String get forecastNow => 'Cash and bank now';

  @override
  String get forecastMoneyIn => 'Coming in';

  @override
  String get forecastMoneyOut => 'Going out';

  @override
  String get forecastLowest => 'Lowest';

  @override
  String forecastLowestOn(String date) {
    return 'on $date';
  }

  @override
  String get forecastChartTitle => 'Projected balance';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'On $date you would be $amount short';
  }

  @override
  String get forecastShortfallCause => 'Going out that day:';

  @override
  String get forecastAlreadyShort =>
      'Your cash and bank accounts are already below zero.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'No shortfall in the next $days days';
  }

  @override
  String get forecastAllCoveredBody =>
      'What is scheduled is covered by your cash and bank money.';

  @override
  String get forecastScheduledOnly =>
      'Counts only what is scheduled: plans, card bills, subscriptions, repeating and upcoming payments, and loans with a due date. Everyday spending is not included.';

  @override
  String get forecastEventsTitle => 'Coming up';

  @override
  String forecastDayBalance(String amount) {
    return 'Balance $amount';
  }

  @override
  String get forecastEmptyTitle => 'Nothing scheduled';

  @override
  String get forecastEmptyBody =>
      'Plans, card bills, subscriptions and upcoming payments in this period show here.';

  @override
  String get forecastOverdue => 'Overdue';

  @override
  String get forecastExpected => 'Expected';

  @override
  String get forecastEventWhen => 'When';

  @override
  String get forecastEventKind => 'Type';

  @override
  String get forecastEventAccount => 'Account';

  @override
  String get forecastEventOpen => 'Open';

  @override
  String get forecastEventOverdueNote =>
      'Its date has passed and it is still open, so it is counted as due today.';

  @override
  String get forecastKindInstallment => 'Installment';

  @override
  String get forecastKindPremium => 'Premium';

  @override
  String get forecastKindDeposit => 'Deposit';

  @override
  String get forecastKindSipBuy => 'SIP purchase';

  @override
  String get forecastKindProfit => 'Profit';

  @override
  String get forecastKindMaturity => 'Maturity';

  @override
  String get forecastKindCardBill => 'Card bill';

  @override
  String get forecastKindCardBillNext => 'Next card bill, so far';

  @override
  String get forecastKindSubscription => 'Subscription';

  @override
  String get forecastKindRecurringBill => 'Repeating payment';

  @override
  String get forecastKindRecurringIncome => 'Repeating income';

  @override
  String get forecastKindUpcoming => 'Upcoming';

  @override
  String get forecastKindBorrowed => 'Loan to repay';

  @override
  String get forecastKindLent => 'Lent, due back';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'You may be $amount short on $date';
  }

  @override
  String get forecastHomeWarningBody => 'See what is coming up';

  @override
  String get forecastDismiss => 'Dismiss';

  @override
  String forecastNotifTitle(String day) {
    return 'You may run short on $day';
  }

  @override
  String get settingsBillReminders => 'Bill and installment reminders';

  @override
  String get settingsBillRemindersSub =>
      'Card bills due, and EMI or savings installments coming up';

  @override
  String get settingsBillRemindersNote =>
      'Card bills and plan installments are worked out by the app on your phone, so your amounts stay private. If you don\'t open the app for a few days, a reminder can arrive late or be missed.';

  @override
  String get forecastNotifNowTitle => 'You are short on money today';

  @override
  String forecastNotifNowBody(String amount) {
    return 'What is due now is $amount more than your accounts hold. Tap to see what is coming up.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Scheduled payments would leave you $amount short. Tap to see what is coming up.';
  }

  @override
  String get investmentsEmptyTitle => 'No investments yet';

  @override
  String get investmentsEmptyBody =>
      'Track a mutual fund, shares or gold: what you paid, what it is worth now, and the gain.';

  @override
  String get investmentsSold => 'Sold';

  @override
  String get investmentsWorth => 'Worth now';

  @override
  String get investmentNew => 'New investment';

  @override
  String get investmentNewHint =>
      'Units of a fund, a company\'s shares, or anything else bought by the unit, like gold by the gram.';

  @override
  String get investmentKindFund => 'Fund';

  @override
  String get investmentKindStock => 'Shares';

  @override
  String get investmentKindOther => 'Other';

  @override
  String get investmentNameHintFund => 'e.g. UCB Income Plus Fund';

  @override
  String get investmentNameHintStock => 'e.g. Grameenphone';

  @override
  String get investmentNameHintOther => 'e.g. Gold, 22 carat';

  @override
  String get investmentSymbol => 'Symbol or code (optional)';

  @override
  String get investmentFirstBuy => 'What you bought';

  @override
  String get investmentFirstBuyHint =>
      'Leave the amount empty to add it without buying anything yet.';

  @override
  String get investmentPaid => 'Paid';

  @override
  String get investmentReceived => 'Received';

  @override
  String get investmentPaidInto => 'Paid into';

  @override
  String get investmentFee => 'Fee or commission';

  @override
  String get investmentUnits => 'Units';

  @override
  String get investmentUnitsSold => 'Units sold';

  @override
  String investmentUnitsShort(String units) {
    return '$units units';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price a unit';
  }

  @override
  String get investmentNeedUnits => 'Enter how many units were bought.';

  @override
  String get investmentSave => 'Add investment';

  @override
  String get investmentAdded => 'Investment added';

  @override
  String get investmentGone => 'This investment was deleted.';

  @override
  String get netWorthSubtitle =>
      'Everything you own, less what you owe, and how it has moved';

  @override
  String get netWorthToday => 'You are worth';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount since last month';
  }

  @override
  String get netWorthBreakdown => 'What it is made of';

  @override
  String get netWorthCash => 'Cash & bank';

  @override
  String get netWorthCards => 'Credit cards';

  @override
  String get netWorthDeposits => 'Savings deposits';

  @override
  String get netWorthAssets => 'Assets';

  @override
  String get netWorthLent => 'Lent to others';

  @override
  String get netWorthBorrowed => 'Borrowed';

  @override
  String get netWorthLoansNote =>
      'Money you lent counts as yours until it is paid back, and money you borrowed counts against you until you repay it.';

  @override
  String get netWorthCardsLeftOut =>
      'Credit cards are not counted; you can change that in Settings.';

  @override
  String get netWorthHistory => 'At each month end';

  @override
  String get netWorthSixMonths => '6 months';

  @override
  String get netWorthOneYear => '1 year';

  @override
  String get netWorthAllTime => 'All';

  @override
  String get netWorthHistoryEmpty =>
      'The line starts once a month has ended with your records in it.';

  @override
  String get assetNew => 'Add asset';

  @override
  String get assetNewHint =>
      'Land, a flat or house, a car, gold or anything else you own. Its value counts toward your net worth.';

  @override
  String get assetKind => 'What it is';

  @override
  String get assetKindLand => 'Land';

  @override
  String get assetKindHome => 'Flat or house';

  @override
  String get assetKindCar => 'Vehicle';

  @override
  String get assetKindGold => 'Gold & jewellery';

  @override
  String get assetKindOther => 'Something else';

  @override
  String get assetNameHintLand => 'e.g. Plot in Savar';

  @override
  String get assetNameHintHome => 'e.g. Flat in Mirpur';

  @override
  String get assetNameHintCar => 'e.g. Toyota Axio';

  @override
  String get assetNameHintGold => 'e.g. Wedding jewellery';

  @override
  String get assetNameHintOther => 'e.g. Camera';

  @override
  String get assetWorthNow => 'Worth now';

  @override
  String get assetBoughtNow => 'Paid for it from an account';

  @override
  String get assetBoughtNowHint =>
      'Off: you already own it, and no money moves.';

  @override
  String get assetSave => 'Add asset';

  @override
  String get assetAdded => 'Asset added';

  @override
  String get assetsEmptyTitle => 'No assets yet';

  @override
  String get assetsEmptyBody =>
      'Add land, a home, a car or gold to see everything you are worth.';

  @override
  String get assetsSold => 'Sold';

  @override
  String assetCostLine(String amount) {
    return 'Cost $amount';
  }

  @override
  String get assetUpdateValue => 'Update value';

  @override
  String get assetSell => 'Sell';

  @override
  String get assetDelete => 'Remove';

  @override
  String get assetValueUpdated => 'Value updated';

  @override
  String get assetSold => 'Sold, and the money recorded';

  @override
  String assetDeleteTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get assetDeleteBody =>
      'It is no longer counted. Its history stays with your records.';

  @override
  String get assetDeleted => 'Asset removed';

  @override
  String get aiActionCreateAssetTitle => 'Add an asset';

  @override
  String get aiActionUpdateAssetTitle => 'Update an asset\'s value';

  @override
  String get aiActionSellAssetTitle => 'Sell an asset';

  @override
  String get investmentWorthNow => 'Worth now';

  @override
  String investmentGainLine(String gain) {
    return '$gain overall';
  }

  @override
  String get investmentPrice => 'Price';

  @override
  String get investmentPutIn => 'Put in';

  @override
  String get investmentTakenOut => 'Taken out';

  @override
  String get investmentBuy => 'Buy';

  @override
  String get investmentSell => 'Sell';

  @override
  String investmentBuyTitle(String name) {
    return 'Buy $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'Sell $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Dividend from $name';
  }

  @override
  String get investmentDividend => 'Dividend';

  @override
  String get investmentRecordDividend => 'Record a dividend';

  @override
  String investmentHeldNow(String units) {
    return '$units units held now.';
  }

  @override
  String get investmentRecorded => 'Recorded';

  @override
  String get investmentUpdatePrice => 'Update the price';

  @override
  String get investmentUpdatePriceHint =>
      'Today\'s NAV or share price, for one unit';

  @override
  String get investmentPriceUpdated => 'Price updated';

  @override
  String get investmentStartSip => 'Start a SIP';

  @override
  String get investmentStartSipHint =>
      'Buy a fixed amount every month, by itself';

  @override
  String get investmentHistory => 'History';

  @override
  String investmentBought(String units) {
    return 'Bought $units units';
  }

  @override
  String investmentSold(String units) {
    return 'Sold $units units';
  }

  @override
  String get investmentPriceRose => 'Price went up';

  @override
  String get investmentPriceFell => 'Price went down';

  @override
  String get investmentUnitsUnknown => 'units not known yet, tap to add';

  @override
  String get investmentCorrectUnits => 'Units on this trade';

  @override
  String get investmentCorrectUnitsHint =>
      'As your fund or broker statement shows them.';

  @override
  String get investmentUnitsCorrected => 'Units corrected';

  @override
  String get investmentDelete => 'Delete this investment';

  @override
  String investmentDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get investmentDeleteBody =>
      'Its trades stay in your history. Only possible once everything is sold.';

  @override
  String get investmentDeleted => 'Investment deleted';

  @override
  String get plansSubtitle =>
      'EMIs, loans, DPS, FDR, insurance, bonds and SIPs, paid and collected on time';

  @override
  String get planNew => 'Start a plan';

  @override
  String get planNewTitle => 'What are you starting?';

  @override
  String get plansEmptyTitle => 'No EMIs, loans or savings yet';

  @override
  String get plansEmptyBody =>
      'Track something bought in installments, a loan, a DPS or an FDR. Installments are recorded on their day and you are reminded before each.';

  @override
  String get plansEnded => 'Finished';

  @override
  String get planKindEmi => 'EMI';

  @override
  String get planKindLoan => 'Loan';

  @override
  String get planKindDps => 'DPS';

  @override
  String get planKindFdr => 'FDR';

  @override
  String get planKindInsurance => 'Insurance';

  @override
  String get planKindBond => 'Bond or certificate';

  @override
  String get planKindSip => 'SIP';

  @override
  String get planKindEmiHint =>
      'Something bought in installments, paid from cash, a bank account or a card';

  @override
  String get planKindLoanHint =>
      'Money borrowed and paid back in installments, with interest';

  @override
  String get planKindDpsHint =>
      'Save a fixed amount every month for a fixed time, and get it back with profit';

  @override
  String get planKindFdrHint =>
      'Put a sum away at a bank for a fixed time, with profit monthly, every three months or at the end';

  @override
  String get planKindInsuranceHint =>
      'A policy with a premium every month, quarter or year, and a payout at the end if it has one';

  @override
  String get planKindBondHint =>
      'A bond or savings certificate: one sum held for years, with profit monthly, every three months or at the end, after tax';

  @override
  String get planKindSipHint =>
      'A fixed sum into a fund or shares every month, bought at the latest price';

  @override
  String get planWeekly => 'Weekly';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planQuarterly => 'Quarterly';

  @override
  String get planHalfYearly => 'Half-yearly';

  @override
  String get planYearly => 'Yearly';

  @override
  String get planMonths => 'Months';

  @override
  String get planYears => 'Years';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount until $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved of $total saved';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid of $total paid';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Next: $amount on $date';
  }

  @override
  String get planStatusCompleted => 'Completed';

  @override
  String get planStatusClosed => 'Closed';

  @override
  String get planStatusOverdue => 'Overdue';

  @override
  String get planStatusRunning => 'Running';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done of $total';
  }

  @override
  String get planGone => 'This plan has been deleted.';

  @override
  String get planAccount => 'Account';

  @override
  String get planAccountEmi => 'Paid from';

  @override
  String get planAccountLoan => 'Received into and paid from';

  @override
  String get planAccountSaving => 'From account';

  @override
  String get planPrice => 'Price';

  @override
  String get planBorrowed => 'Amount borrowed';

  @override
  String get planDeposited => 'Amount deposited';

  @override
  String get planDeposit => 'Each deposit';

  @override
  String get planInstallment => 'Each installment';

  @override
  String get planWorkedOut => 'Worked out from the price, rate and term';

  @override
  String get planProgress => 'Done';

  @override
  String get planSavedSoFar => 'Saved so far';

  @override
  String get planPaidSoFar => 'Paid so far';

  @override
  String get planLeft => 'Left';

  @override
  String get planTotal => 'In all';

  @override
  String get planInterestCharges => 'Interest and charges';

  @override
  String get planRate => 'Rate';

  @override
  String get planRateLabel => 'Rate % a year';

  @override
  String get planRateOptional => 'Optional';

  @override
  String get planPayout => 'Profit paid';

  @override
  String get planPayoutMonthly => 'Every month';

  @override
  String get planPayoutQuarterly => 'Every 3 months';

  @override
  String get planPayoutAtMaturity => 'At the end';

  @override
  String get planMaturesOn => 'Matures on';

  @override
  String get planMaturity => 'Paid back at the end';

  @override
  String get planEstimated =>
      'Estimated from the rate; tap to enter the bank\'s figure';

  @override
  String get planHolding => 'In the deposit now';

  @override
  String get planEnds => 'Last installment';

  @override
  String planTakeMaturity(String amount) {
    return 'Take the maturity, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Record the profit, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Pay installment $number now, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Pay premium $number now, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Make deposit $number now, $amount';
  }

  @override
  String get planRecorded => 'Recorded.';

  @override
  String get planSaved => 'Saved.';

  @override
  String get planPayOff => 'Pay off early';

  @override
  String get planEncash => 'Encash early';

  @override
  String get planSurrender => 'Surrender the policy';

  @override
  String planSurrenderTitle(String name) {
    return 'Surrender $name?';
  }

  @override
  String get planSurrenderBody =>
      'Premiums stop. Whatever the insurer pays back is recorded as income.';

  @override
  String get planSurrenderNothing => 'Nothing paid back';

  @override
  String get planSurrenderValue => 'Enter the surrender value';

  @override
  String get planSurrenderValueLabel => 'Surrender value';

  @override
  String get planStopSip => 'Stop the SIP';

  @override
  String planStopSipTitle(String name) {
    return 'Stop $name?';
  }

  @override
  String get planStopSipBody =>
      'No more buys. What it bought stays in the investment.';

  @override
  String get planSipStopped => 'SIP stopped';

  @override
  String get planSave => 'Save';

  @override
  String get planSurrendered => 'Policy surrendered';

  @override
  String planPayOffTitle(String name) {
    return 'Pay off $name?';
  }

  @override
  String get planPayOffHint =>
      'One payment for what is left, and the plan ends.';

  @override
  String planPayOffLeft(String amount) {
    return 'Pay what is left, $amount';
  }

  @override
  String get planPayOffOther => 'The lender quoted a different amount';

  @override
  String planEncashTitle(String name) {
    return 'Encash $name?';
  }

  @override
  String get planEncashBody =>
      'What is in the deposit goes back to its account, and the plan ends.';

  @override
  String get planEncashNoProfit => 'Encash, without profit';

  @override
  String get planEncashWithProfit => 'Encash, with the profit the bank paid';

  @override
  String get planEncashed => 'Encashed. The money is back in its account.';

  @override
  String get planPaidOff => 'Paid off.';

  @override
  String get planAutoCollect => 'Record by itself';

  @override
  String get planAutoCollectHint =>
      'Each installment, profit and maturity is recorded on its day';

  @override
  String get planSchedule => 'SCHEDULE';

  @override
  String get planDelete => 'Delete this plan';

  @override
  String planDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get planDeleteBody =>
      'What it recorded stays in your transactions. Nothing more is recorded or reminded.';

  @override
  String get planDeleted => 'Deleted.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Installment $number of $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Premium $number of $total';
  }

  @override
  String get planEventPayout => 'Policy pays out';

  @override
  String planEventProfit(int number) {
    return 'Profit, month $number';
  }

  @override
  String get planEventMaturity => 'Maturity';

  @override
  String get planEventDone => 'Done';

  @override
  String get planEventLate => 'Overdue';

  @override
  String get planEventUpcoming => 'Upcoming';

  @override
  String get planNeedAccount => 'Choose an account first.';

  @override
  String get planCreated => 'Started. Anything already due has been recorded.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, of which $interest is interest and charges.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, with no interest.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'You put in $deposited and get back about $maturity on $date.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal grows to about $maturity by $date.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return '$profit profit every month, and $principal back on $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count premiums of $premium, $total in all.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count premiums of $premium, $total in all, and $payout back on $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return '$profit profit every three months, and $principal back on $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount into $fund, $total in all.';
  }

  @override
  String planNewKind(String kind) {
    return 'New $kind';
  }

  @override
  String get planName => 'Name';

  @override
  String get planNameHintEmi => 'e.g. Phone from Daraz';

  @override
  String get planNameHintLoan => 'e.g. Bike loan';

  @override
  String get planNameHintDps => 'e.g. Brac DPS';

  @override
  String get planNameHintFdr => 'e.g. City Bank FDR';

  @override
  String get planNameHintInsurance => 'e.g. Life policy';

  @override
  String get planNameHintBond => 'e.g. 5-year Sanchayapatra';

  @override
  String get planNameHintSip => 'e.g. Monthly fund SIP';

  @override
  String get planSipFund => 'Buys';

  @override
  String get planSipAmount => 'Each SIP';

  @override
  String get planSipNoFund => 'Add the fund or shares in Investments first.';

  @override
  String get planProvider => 'Bank or company';

  @override
  String get planReference => 'Policy or account no.';

  @override
  String get planSumAssured => 'Sum assured';

  @override
  String get planPremium => 'Premium';

  @override
  String get planPremiums => 'Premiums';

  @override
  String get planTaxLabel => 'Tax at source %';

  @override
  String get planTax => 'Tax at source';

  @override
  String get planFirstPremium => 'First premium';

  @override
  String get planLastPremium => 'Last premium';

  @override
  String get planInsurancePayout => 'Paid back at the end';

  @override
  String get planNone => 'None';

  @override
  String get planHowMany => 'How many';

  @override
  String get planTerm => 'Term';

  @override
  String get planOpenedOn => 'Opened on';

  @override
  String get planFirstDue => 'First installment';

  @override
  String get planCategory => 'Category';

  @override
  String get planCategoryDefault => 'Loan Payment';

  @override
  String get planCategoryInsurance => 'Insurance';

  @override
  String get planLoanReceived => 'Money received into this account';

  @override
  String get planLoanReceivedHint => 'Off if it went straight to a seller';

  @override
  String get planStart => 'Start';

  @override
  String get aiActionDeleteNote =>
      'It goes to Recently deleted, where you can restore it for 30 days.';

  @override
  String get aiActionAdd => 'Add it';

  @override
  String get aiActionSave => 'Save change';

  @override
  String get aiActionDelete => 'Delete it';

  @override
  String get aiActionCancel => 'No, leave it';

  @override
  String get aiActionAmount => 'Amount';

  @override
  String get aiActionKind => 'Type';

  @override
  String get aiActionTitle => 'Title';

  @override
  String get aiActionCategory => 'Category';

  @override
  String get aiActionAccount => 'Account';

  @override
  String get aiActionDate => 'Date';

  @override
  String get aiActionNotes => 'Notes';

  @override
  String get aiReport => 'Report a problem';

  @override
  String get aiReportWrongAnswer => 'The coach got something wrong';

  @override
  String get aiReportWrongAnswerHint =>
      'A wrong number, a made-up fact, or a change you did not ask for';

  @override
  String get aiReportWrongAnswerSubject => 'Money coach: wrong answer';

  @override
  String get aiReportBug => 'Report a bug';

  @override
  String get aiReportBugHint => 'Something broke, froze or did not load';

  @override
  String get aiReportBugSubject => 'Money coach: bug report';

  @override
  String get aiAboutCoach => 'How the coach works';

  @override
  String get aiDisclaimerTitle => 'Before you ask the coach';

  @override
  String get aiDisclaimerMistakes =>
      'The coach is an AI. It can get a number wrong, misread a question or state something that is not true, so check anything important against your own transactions.';

  @override
  String get aiDisclaimerData =>
      'Your figures are read on your phone. To answer, the app sends your question and the figures it needs to our server and its AI model.';

  @override
  String get aiDisclaimerChanges =>
      'It never changes your money on its own. Every add, edit or delete is shown to you first and only happens if you confirm it.';

  @override
  String get aiDisclaimerReport =>
      'If an answer looks wrong, tap the flag at the top to tell us.';

  @override
  String get aiDisclaimerAccept => 'I understand';

  @override
  String get aiOutOfRequestsTitle => 'You\'ve used this month\'s free requests';

  @override
  String get aiOutOfRequestsBody =>
      'Watch a short ad to ask this one, or go Premium for unlimited answers with no ads. Free requests come back on the 1st.';

  @override
  String get ocrNoCamera => 'Couldn\'t open the camera.';

  @override
  String get ocrNoGallery => 'Couldn\'t open the gallery.';

  @override
  String get ocrScanTitle => 'Scan a receipt';

  @override
  String get ocrScanAnother => 'Scan another';

  @override
  String get ocrScanBody =>
      'Snap a photo or pick one. The app reads it and the AI fills in the details.';

  @override
  String get ocrReadingWithAi => 'The AI is reading your receipt…';

  @override
  String get ocrNothingRead =>
      'No text could be read from that photo. Try again in better light, with the whole receipt in view.';

  @override
  String get ocrAiOfferTitle => 'Let the AI read it properly';

  @override
  String get ocrAiOfferBody =>
      'It finds the real total, the date, each item and the right category, even on a messy receipt.';

  @override
  String get ocrReadWithAi => 'Read with AI';

  @override
  String get ocrReadByAi => 'Read by AI. Check it before saving.';

  @override
  String get ocrItems => 'Items';

  @override
  String get quickAddTitle => 'Describe it';

  @override
  String get quickAddSubtitle =>
      'Type it the way you\'d say it. The AI fills in the form for you to check.';

  @override
  String get quickAddHint => 'e.g. lunch 250 yesterday from bKash';

  @override
  String get quickAddFill => 'Fill it in';

  @override
  String get summaryTitle => 'Monthly summary';

  @override
  String get summarySpent => 'Spent this month';

  @override
  String summaryEarned(String amount) {
    return 'Earned $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent% less than last month';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent% more than last month';
  }

  @override
  String get summaryAiTitle => 'Your month, in a nutshell';

  @override
  String get summaryAiBody =>
      'The AI reads your month against last month and picks out what stood out, with one thing to try.';

  @override
  String get summaryWrite => 'Write my summary';

  @override
  String get summaryOutdated =>
      'Your transactions have changed since this summary was written.';

  @override
  String get summaryUpdate => 'Update my summary';

  @override
  String get summaryWriting => 'Writing your summary…';

  @override
  String get summaryByCategory => 'By category';

  @override
  String get summaryNoSpending => 'No spending recorded this month yet.';

  @override
  String themeTrialUntil(String time) {
    return 'Premium themes unlocked until $time';
  }

  @override
  String get zakatTitle => 'Zakat';

  @override
  String get zakatSubtitle =>
      'Work out what is due on your wealth, and record what you pay';

  @override
  String get zakatSubtitleOff => 'You don\'t pay zakat. Tap to check it anyway';

  @override
  String get zakatAskTitle => 'Do you pay zakat?';

  @override
  String get zakatAskBody =>
      'Not everyone does. If you don\'t, the app keeps zakat out of your way: nothing due and no reminders.';

  @override
  String get zakatIPay => 'I pay zakat';

  @override
  String get zakatIDontPay => 'I don\'t pay zakat';

  @override
  String get zakatOffTitle => 'You don\'t pay zakat';

  @override
  String get zakatOffBody =>
      'So nothing about zakat shows as due, and there are no zakat reminders. You can still see what it would come to, any time; looking doesn\'t change your answer.';

  @override
  String get zakatOffPeek => 'See what it would come to';

  @override
  String get zakatPeekBanner =>
      'Just a look. You\'ve said you don\'t pay zakat.';

  @override
  String get zakatOptOutTitle => 'Stop tracking zakat?';

  @override
  String get zakatOptOutBody =>
      'Nothing will show as due and there will be no zakat reminders. Your figures are kept, and you can check them here any time.';

  @override
  String get zakatDue => 'Zakat due';

  @override
  String zakatAboveNisab(String amount) {
    return 'Above the nisab: 2.5% of $amount net wealth';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'Below the nisab by $amount, so no zakat is due';
  }

  @override
  String get zakatNeedPrice => 'Enter the price per gram to check the nisab';

  @override
  String get zakatPaidSoFar => 'Paid this year';

  @override
  String get zakatLeftToPay => 'Left to pay';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Zakat date $date, in $days days',
      one: 'Zakat date tomorrow, $date',
      zero: 'Your zakat date is today',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Set your zakat date to track the year and get a reminder';

  @override
  String get zakatPay => 'Pay zakat';

  @override
  String get zakatNisab => 'Nisab';

  @override
  String get zakatBasisGold => 'Gold';

  @override
  String get zakatBasisSilver => 'Silver';

  @override
  String get zakatBasisHint =>
      'Silver gives the lower nisab and is the more cautious choice when your wealth is mostly cash. Enter today\'s local price for one gram.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Price per gram ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams g at that price';
  }

  @override
  String get zakatGroupCash => 'Cash and bank';

  @override
  String get zakatGroupDeposits => 'Savings deposits';

  @override
  String get zakatGroupInvestments => 'Investments';

  @override
  String get zakatGroupMetals => 'Gold and silver';

  @override
  String get zakatGroupLent => 'Money lent to others';

  @override
  String get zakatGroupOtherAssets => 'Other assets';

  @override
  String get zakatGroupPaid => 'Zakat paid this year';

  @override
  String get zakatGroupManual => 'Added by you';

  @override
  String get zakatGroupBorrowed => 'Less: money you owe';

  @override
  String get zakatGroupCards => 'Less: credit card dues';

  @override
  String get zakatOtherAssetsNote =>
      'Land, a home or a car you use is not zakatable. Switch one on only if you hold it for trade.';

  @override
  String get zakatPaidNote =>
      'Added back, because it left your accounts after the year\'s wealth was counted.';

  @override
  String get zakatNoMetals =>
      'No gold or silver is recorded. Add it as an asset, or add its value below.';

  @override
  String get zakatAddAmount => 'Add an amount';

  @override
  String get zakatAmountLabel => 'What is it?';

  @override
  String get zakatAmountHint => 'Business stock, cash at home…';

  @override
  String get zakatAmountDeduct => 'It is a debt due now';

  @override
  String get zakatWealth => 'Zakatable wealth';

  @override
  String get zakatDeductions => 'Debts due now';

  @override
  String get zakatNet => 'Net wealth';

  @override
  String get zakatRate => '2.5% of net wealth';

  @override
  String get zakatYear => 'Zakat year';

  @override
  String get zakatDate => 'Zakat date';

  @override
  String get zakatDateHint =>
      'The day your zakat year completes. It comes round every lunar year, 354 days.';

  @override
  String get zakatRemind => 'Remind me';

  @override
  String get zakatRemindHint => '3 days before, and on the day';

  @override
  String get zakatDisclaimer =>
      'This is a guide to help you work zakat out, not a religious ruling. Scholars differ on some details; when unsure, ask a local scholar.';

  @override
  String get zakatPayNote =>
      'Recorded as an expense under Zakat, and counted toward this year.';

  @override
  String get zakatPayRecord => 'Record payment';

  @override
  String get zakatPaidSnack => 'Zakat recorded';

  @override
  String get aiToolZakat => 'Working out zakat…';

  @override
  String get voiceButton => 'Say a transaction';

  @override
  String get voiceTitle => 'Say it';

  @override
  String get voiceUnlimited => 'Unlimited';

  @override
  String get voiceTapToTalk => 'Tap the orb and say what you spent';

  @override
  String get voiceListening => 'Listening…';

  @override
  String get voiceStop => 'Stop listening';

  @override
  String get voiceTypeInstead => 'Type';

  @override
  String get voiceSpeakInstead => 'Speak';

  @override
  String get voiceSend => 'Done';

  @override
  String get voiceTrySaying => 'Try saying';

  @override
  String get voiceExample1 => 'Lunch 250, rickshaw 60';

  @override
  String get voiceExample2 => 'Got my salary, 45,000';

  @override
  String get voiceExample3 => 'Yesterday\'s tea was 30, not 20';

  @override
  String get voiceExample4 => 'Delete today\'s lunch';

  @override
  String get voiceTypeHint => 'Lunch 250 and rickshaw 60 from bKash';

  @override
  String get voiceThinking => 'Working it out…';

  @override
  String get voiceTryAgain => 'Again';

  @override
  String get voiceSaving => 'Saving…';

  @override
  String get voiceEdit => 'Edit';

  @override
  String get voiceNeedsYou => 'Needs you';

  @override
  String get voiceNew => 'New';

  @override
  String get voiceChange => 'Change';

  @override
  String get voiceRemove => 'Remove';

  @override
  String get voiceNeedsAmount =>
      'No amount was said. Fill it in to add this one.';

  @override
  String get voiceAdjust => 'Adjust';

  @override
  String get voiceFillIn => 'Fill in';

  @override
  String get voiceTime => 'Time';

  @override
  String get voiceUndo => 'Undo';

  @override
  String get voiceUndone => 'Put back as it was';

  @override
  String get voiceNoSpeech => 'I didn\'t catch that. Try again, or type it.';

  @override
  String get voiceNeedsConnection =>
      'Voice needs a connection. You can type instead.';

  @override
  String get voiceMicOff =>
      'Microphone access is off. Allow it in Settings, or type instead.';

  @override
  String get voiceUnavailable =>
      'Voice isn\'t available on this phone. You can type instead.';

  @override
  String get voiceSomethingWrong => 'Something went wrong. Try again.';

  @override
  String get voiceFabSetting => 'Floating mic on Today';

  @override
  String get amountHidden => 'Hidden amount';

  @override
  String get privacyShowAmounts => 'Show amounts';

  @override
  String get privacyHideAmounts => 'Hide amounts';

  @override
  String get privacyAmounts => 'Amounts on screen';

  @override
  String get privacyAmountsFooter =>
      'Balances and totals are blurred so people nearby can\'t read them. Single transactions stay visible. The eye on Today shows or hides them too.';

  @override
  String get privacyHideTitle => 'Hide balances and totals';

  @override
  String get privacyHideSub => 'Blur them until you choose to show them';

  @override
  String get privacyTapTitle => 'Tap a hidden amount to show it';

  @override
  String get privacyTapSub => 'Otherwise only the eye on Today shows them';

  @override
  String get privacyStartTitle => 'When the app opens';

  @override
  String get privacyStartHidden => 'Hidden';

  @override
  String get privacyStartHiddenSub =>
      'Always open with balances and totals hidden';

  @override
  String get privacyStartShown => 'Shown';

  @override
  String get privacyStartShownSub =>
      'Always open with balances and totals showing';

  @override
  String get privacyStartRemember => 'As I left it';

  @override
  String get privacyStartRememberSub => 'Open the way the eye was last left';

  @override
  String get privacyIntroTitle => 'New: hide your balances';

  @override
  String get privacyIntroBody =>
      'Balances and totals are now hidden, so people nearby can\'t read them. Tap the eye on Today to show or hide them; the app remembers how you leave it. You can choose how the app opens in Settings.';

  @override
  String get privacyIntroOk => 'Got it';

  @override
  String get privacyIntroSettings => 'Choose in Settings';

  @override
  String get ppTitle => 'Passphrase protection';

  @override
  String get ppRowOn => 'On';

  @override
  String get ppRowOff => 'Off';

  @override
  String get ppRowLocked => 'Locked on this phone';

  @override
  String get ppIntro =>
      'Your data is already encrypted on this phone and in your backups. A passphrase adds one more lock, so only you can open your synced data and backups — not even we can.';

  @override
  String get ppWithoutTitle => 'Without a passphrase (how it is now)';

  @override
  String get ppWithout1 => 'Everything on this phone is encrypted.';

  @override
  String get ppWithout2 =>
      'Backups and synced data are encrypted with a key tied to your account.';

  @override
  String get ppWithout3 =>
      'Sign in on a new phone and everything comes back, with nothing to remember.';

  @override
  String get ppWithout4 =>
      'Our server holds that key, so in principle we could open your synced data.';

  @override
  String get ppWithTitle => 'With a passphrase';

  @override
  String get ppWith1 =>
      'Only your passphrase or your recovery code can open your synced data and backups.';

  @override
  String get ppWith2 =>
      'Our server keeps only locked copies of your key. We can\'t read your data, and neither can anyone who breaks into our servers.';

  @override
  String get ppWith3 =>
      'On a new phone, or after reinstalling, you type your passphrase once.';

  @override
  String get ppWith4 =>
      'This phone keeps working exactly as it does now, even offline.';

  @override
  String get ppCatchTitle => 'The catch';

  @override
  String get ppCatchBody =>
      'If you forget your passphrase and also lose your recovery code, nobody can recover your synced data or backups — not us, not anyone. What is already on this phone stays readable here.';

  @override
  String get ppAiNote =>
      'AI features still send a summary of your finances so they can answer you. A passphrase does not change that.';

  @override
  String get ppSetButton => 'Set a passphrase';

  @override
  String get ppSetTitle => 'Choose a passphrase';

  @override
  String get ppSetHint =>
      'Use at least 10 characters. A few unrelated words are easy to remember and hard to guess.';

  @override
  String get ppPassphraseLabel => 'Passphrase';

  @override
  String get ppConfirmLabel => 'Type it again';

  @override
  String get ppTooShort => 'Use at least 10 characters.';

  @override
  String get ppMismatch => 'The two passphrases don\'t match.';

  @override
  String get ppUnderstand =>
      'I understand that if I lose both my passphrase and my recovery code, my synced data and backups can\'t be recovered.';

  @override
  String get ppTurnOn => 'Turn on protection';

  @override
  String get ppWorking => 'Locking your key. This takes a few seconds…';

  @override
  String get ppMaybeSaved =>
      'The connection dropped, so the server may already have saved this. Do it again until you see a recovery code, and keep that one.';

  @override
  String get ppRecoveryTitle => 'Your recovery code';

  @override
  String get ppRecoveryBody =>
      'This is the only other way into your data if you forget your passphrase. Write it down or keep it in a password manager — somewhere other than this phone.';

  @override
  String get ppCopy => 'Copy';

  @override
  String get ppCopied => 'Recovery code copied';

  @override
  String get ppSavedIt => 'I\'ve saved my recovery code somewhere safe';

  @override
  String get ppDone => 'Done';

  @override
  String get ppOnTitle => 'Protection is on';

  @override
  String get ppOnBody =>
      'Only your passphrase or your recovery code can open your synced data and backups.';

  @override
  String get ppChange => 'Change passphrase';

  @override
  String get ppNewCode => 'Get a new recovery code';

  @override
  String get ppNewCodeWarn =>
      'Your current recovery code will stop working. Make sure you save the new one.';

  @override
  String get ppTurnOff => 'Turn off protection';

  @override
  String get ppTurnOffBody =>
      'Our server will hold your key again, as before. Your data stays encrypted, but in principle we could open your synced data.';

  @override
  String get ppLockedTitle => 'Unlock your data';

  @override
  String get ppLockedBody =>
      'Your data is protected with a passphrase. Enter it once on this phone to open your synced data and backups.';

  @override
  String get ppUnlock => 'Unlock';

  @override
  String get ppUseRecovery => 'Use my recovery code instead';

  @override
  String get ppUsePassphrase => 'Use my passphrase instead';

  @override
  String get ppRecoveryLabel => 'Recovery code';

  @override
  String get ppWrongPassphrase => 'That passphrase isn\'t right.';

  @override
  String get ppWrongRecovery => 'That recovery code isn\'t right.';

  @override
  String get ppUnlocked => 'Unlocked on this phone';

  @override
  String get ppChanged => 'Passphrase changed';

  @override
  String get ppTurnedOn => 'Protection is on';

  @override
  String get ppTurnedOff => 'Protection turned off';

  @override
  String get encIntroTitle => 'Your data is now encrypted';

  @override
  String get encIntroBody =>
      'Everything on this phone is stored encrypted, and your backups and synced data are encrypted before they leave it. You don\'t need to do anything.';

  @override
  String get encIntroPassphrase =>
      'Want an extra lock? Set a passphrase and only you can open your synced data and backups — not even we can. It\'s optional, and if you lose both the passphrase and its recovery code, that data can\'t be recovered.';

  @override
  String get encIntroSetUp => 'Set a passphrase';

  @override
  String get encIntroNotNow => 'Not now';

  @override
  String get voiceFabSettingSub =>
      'A mic that floats over Today, for saying a transaction';

  @override
  String get voiceFabAskTitle => 'Add a mic to your Today screen?';

  @override
  String get voiceFabAskBody =>
      'Tap it and say what you spent, like \"lunch 250 and a rickshaw 60\". You check everything before it\'s saved. Drag it anywhere you like.';

  @override
  String get voiceFabAskYes => 'Yes, add the mic';

  @override
  String get voiceFabAskNo => 'Not now';

  @override
  String get voiceFabAskLater => 'You can turn it on or off any time in More.';

  @override
  String get voiceFabHideTitle => 'Hide the floating mic?';

  @override
  String get voiceFabHideBody =>
      'The mic at the top of Today stays. You can bring this one back in More.';

  @override
  String get voiceFabHide => 'Hide it';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count READY TO SAVE',
      one: '1 READY TO SAVE',
      zero: 'NOTHING READY',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save $count',
      one: 'Save 1',
      zero: 'Nothing selected',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count transactions',
      one: 'Saved 1 transaction',
    );
    return '$_temp0';
  }

  @override
  String get ppNeedsConnection =>
      'Passphrase settings need an internet connection. Connect to a network and open this again.';

  @override
  String get offlineToast =>
      'You\'re offline. Everything you add is saved on this phone and syncs when you\'re back online.';

  @override
  String get backupLockedTitle => 'Unlock this backup';

  @override
  String get backupLockedBody =>
      'This backup is protected with a passphrase. Enter it, or your recovery code, to open it. This works without an internet connection.';

  @override
  String get settingsSupportDescribeFirst => 'Please describe your issue first';

  @override
  String get settingsSupportSent => 'Thanks! Your message has been sent.';

  @override
  String get settingsSupportSendFailed =>
      'Couldn\'t send right now. Please try again or email us directly.';

  @override
  String get settingsSupportSubjectHint => 'What\'s this about?';

  @override
  String get settingsSupportMessageHint =>
      'Describe your question, issue, or feedback…';

  @override
  String get settingsSupportHeroBody =>
      'Questions, bugs, or feedback — send it over and we\'ll get back to you.';

  @override
  String get settingsSupportTipDescription =>
      'A clear description of your issue';

  @override
  String get settingsSupportTipSteps => 'Steps to reproduce (if it\'s a bug)';

  @override
  String get settingsSupportTipDevice =>
      'Your device model and Android version';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'Prefer email? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'Email copied to clipboard';

  @override
  String get settingsAboutTagline => 'Your Personal Finance Companion';

  @override
  String settingsAboutVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get settingsAboutDescription =>
      'A personal finance app with a focus\non privacy and beautiful UI/UX.';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'Base Currency: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'Last updated: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'Edit Rate: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'Current API rate: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String settingsHoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String settingsDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get settingsExportSectionDateRange => 'DATE RANGE';

  @override
  String get settingsExportSectionFormat => 'FORMAT';

  @override
  String get settingsExportSectionInclude => 'INCLUDE';

  @override
  String get settingsExportAllTime => 'All Time';

  @override
  String get settingsExportThisMonth => 'This Month';

  @override
  String get settingsExportLastMonth => 'Last Month';

  @override
  String get settingsExportLast3Months => 'Last 3 Months';

  @override
  String get settingsExportThisYear => 'This Year';

  @override
  String get settingsExportPdfPremiumBody =>
      'CSV export is free — your data is always yours. The formatted PDF report, with summaries and category & wallet breakdowns, is a Premium feature.';

  @override
  String settingsExportButton(String format) {
    return 'Export $format';
  }

  @override
  String settingsExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - Export';

  @override
  String settingsExportedCount(int count) {
    return 'Exported $count transactions';
  }

  @override
  String get settingsExportPdfShareSubject =>
      'The Accountant - Financial Report';

  @override
  String settingsExportPdfGenerated(int count) {
    return 'PDF report generated with $count transactions';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'Comma for thousands';

  @override
  String get settingsNumberFormatDotThousands => 'Dot for thousands';

  @override
  String get settingsNumberFormatSpaceThousands => 'Space for thousands';

  @override
  String get settingsNumberFormatNoSeparator => 'No separator';

  @override
  String get settingsAutoLockImmediately => 'Immediately';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'Never';

  @override
  String get settingsBiometricUnavailable =>
      'Biometric authentication not available on this device';

  @override
  String get settingsSetPassword => 'Set Password';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsAddPasswordSubtitle => 'Add password to your account';

  @override
  String get settingsPasswordChanged => 'Password changed successfully';

  @override
  String get settingsPasswordSet => 'Password set successfully';

  @override
  String get settingsClearCacheBody =>
      'This will clear cached data and force a re-sync on next app launch. Your data will not be deleted.';

  @override
  String get settingsClearingCache => 'Clearing cache...';

  @override
  String get settingsCacheCleared => 'Cache cleared and sync triggered';

  @override
  String get settingsClearCacheFailed => 'Failed to clear cache';

  @override
  String get settingsClearAllDataBody =>
      'This will permanently delete ALL your transactions, budgets, wallets, categories, and settings. This action cannot be undone!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'All your financial data will be permanently erased.';

  @override
  String get settingsClearingAllData => 'Clearing all data...';

  @override
  String get settingsAllDataCleared => 'All data cleared successfully';

  @override
  String settingsClearDataFailed(String error) {
    return 'Failed to clear data: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'You\'ll be taken to a form to request account deletion. The process takes a few days to complete. Once processed, all data on the server will be permanently deleted.';

  @override
  String get settingsLockAuthFailed =>
      'Authentication failed. Please try again.';

  @override
  String get settingsLockError => 'An error occurred. Please try again.';

  @override
  String get settingsLockAuthenticating => 'Authenticating...';

  @override
  String get settingsProfileNameEmpty => 'Name cannot be empty';

  @override
  String get settingsProfileUpdated => 'Profile updated successfully';

  @override
  String get settingsProfileUpdateFailed => 'Failed to update profile';

  @override
  String get settingsProfileSaveChanges => 'Save changes';

  @override
  String get settingsProfileSaved => 'Saved';

  @override
  String get settingsProfilePhotoSoon => 'Photo upload coming soon';

  @override
  String get settingsProfileAccountInformation => 'Account Information';

  @override
  String get settingsProfileMemberSince => 'Member Since';

  @override
  String get settingsProfileUnknown => 'Unknown';

  @override
  String get settingsProfileFree => 'Free';

  @override
  String get settingsProfileUserId => 'User ID';

  @override
  String get settingsProfileUserIdCopied => 'User ID copied';

  @override
  String get settingsPremiumMonthly => 'Premium Monthly';

  @override
  String get settingsPremiumYearly => 'Premium Yearly';

  @override
  String get settingsPremiumLifetime => 'Premium Lifetime';

  @override
  String get settingsUnsavedChangesBody =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String settingsShareAppText(String url) {
    return 'Check out The Accountant - a beautiful personal finance app!\n\n$url';
  }

  @override
  String get settingsShareAppSubject => 'The Accountant - Personal Finance App';

  @override
  String get settingsCloudSyncGateBody =>
      'Keep your financial data synchronized across all your devices. Never lose your data again.';

  @override
  String settingsSyncPushed(int count) {
    return 'Pushed $count';
  }

  @override
  String settingsSyncPulled(int count) {
    return 'Pulled $count';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count conflicts';
  }

  @override
  String get settingsSyncNowSubtitle => 'Push and pull all changes';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'Sync complete — pushed $pushed, pulled $pulled';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'Sync incomplete — $count record(s) could not be saved and will be retried. $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'Replace this device\'s data with your cloud data';

  @override
  String get settingsRestoreFromCloudBody =>
      'This erases ALL data on this device and replaces it with your cloud data. Any changes on this device that have not synced yet will be lost. This cannot be undone.';

  @override
  String settingsRestoredFromCloud(int count) {
    return 'Restored $count items from the cloud';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'Restore cancelled — your local data was left unchanged. $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'Your data syncs automatically every 15 minutes and when you open the app. Amounts, names and notes are encrypted on this phone before they sync, so our server cannot read them.';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'Completed in ${seconds}s';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'Completed in ${minutes}m ${seconds}s';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'Is this your \"$name\" category?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'Saved. This will be applied the next time you sync.';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your account already has $count categories called \"$name\". Tell us whether to use one of them as the built-in category, or keep it separate. Nothing changes until you choose.',
      one:
          'Your account already has a category called \"$name\". Tell us whether to use it as the built-in category, or keep it separate. Nothing changes until you choose.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'No — keep mine and add a separate one';

  @override
  String get settingsReconcileNoneOfThese =>
      'None of these — add a separate one';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your existing \"$name\" categories stay exactly as they are, with all its transactions. A new built-in \"$name\" will be added alongside.',
      one:
          'Your existing \"$name\" category stays exactly as it is, with all its transactions. A new built-in \"$name\" will be added alongside.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'Keep separate';

  @override
  String settingsReconcileTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String settingsReconcileUseTitle(String name) {
    return 'Use \"$name\"?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'It becomes the built-in \"$name\" category and keeps all $count of its transactions, along with its subcategories. Nothing is deleted.',
      zero:
          'It becomes the built-in \"$name\" category and keeps everything filed under it, along with its subcategories. Nothing is deleted.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'Use this one';

  @override
  String settingsReconcileWillUse(String name) {
    return 'Will use \"$name\".';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'Will add a separate \"$name\".';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'Enter your current password and choose a new one';

  @override
  String get settingsSetPasswordSubtitle =>
      'Add a password to your account for additional security';

  @override
  String get settingsEnterCurrentPassword =>
      'Please enter your current password';

  @override
  String get settingsEnterNewPassword => 'Please enter a new password';

  @override
  String get settingsPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get settingsConfirmYourPassword => 'Please confirm your password';

  @override
  String get settingsPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get settingsPleaseWait => 'Please wait...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'Type \"$word\" to confirm';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return '$percent% of budget';
  }

  @override
  String get authTooManyAttempts =>
      'Too many attempts. Please wait a minute and try again.';

  @override
  String get authServerDown =>
      'We could not reach our servers. This is on our side — please try again in a few minutes.';

  @override
  String get authInitFailed => 'Failed to initialize authentication';

  @override
  String get authSignInError => 'An error occurred during sign in';

  @override
  String get authSignUpError => 'An error occurred during sign up';

  @override
  String get authGoogleCancelled => 'Google Sign-In was cancelled or failed';

  @override
  String get authFirebaseTokenFailed => 'Failed to get Firebase ID token';

  @override
  String get authGoogleSignInError => 'An error occurred during Google sign in';

  @override
  String get authAccountExistsDifferentCredential =>
      'An account already exists with the same email address but different sign-in credentials.';

  @override
  String get authInvalidCredential =>
      'The supplied auth credential is malformed or has expired.';

  @override
  String get authGoogleDisabled => 'Google sign-in is disabled.';

  @override
  String get authUserDisabled => 'The user account has been disabled.';

  @override
  String get authAppleSignInError => 'An error occurred during Apple sign in';

  @override
  String get authAppleDisabled => 'Apple sign-in is disabled.';

  @override
  String get authNoPendingLink => 'No pending account to link';

  @override
  String get authLinkFailed => 'Failed to link account';

  @override
  String get authIncorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get authSignOutError => 'An error occurred during sign out';

  @override
  String get authLinkSubtitle =>
      'An account with this email already exists. Enter your password to link your Google account.';

  @override
  String get authEnterYourPasswordHint => 'Enter your password';

  @override
  String get authEnterYourPassword => 'Please enter your password';

  @override
  String get authLinkInfo =>
      'After linking, you can use either email/password or Google to sign in.';

  @override
  String get authEnterYourEmail => 'Please enter your email';

  @override
  String get authEnterValidEmail => 'Please enter a valid email';

  @override
  String get authPasswordMin6 => 'Password must be at least 6 characters';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authCheckYourEmail => 'Check Your Email';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String authCodeSentSubtitle(String email) {
    return 'We sent a 6-digit code to $email. Enter it below with your new password.';
  }

  @override
  String get authEnterYourEmailHint => 'Enter your email';

  @override
  String get authSixDigitCodeHint => '6-digit code';

  @override
  String get authEnterTheCode => 'Please enter the code';

  @override
  String get authCodeIsSixDigits => 'The code is 6 digits';

  @override
  String get authCreateNewPasswordHint => 'Create a new password';

  @override
  String get authReenterNewPasswordHint => 'Re-enter your new password';

  @override
  String get authEnterYourNameHint => 'Enter your name';

  @override
  String get authEnterFullName => 'Please enter your full name';

  @override
  String get authNameMin2 => 'Name must be at least 2 characters';

  @override
  String get authCreatePasswordHint => 'Create a password';

  @override
  String get authPasswordComplexity =>
      'Must contain uppercase, lowercase, and number';

  @override
  String get authReenterPasswordHint => 'Re-enter your password';

  @override
  String get authStrengthWeak => 'Weak';

  @override
  String get authStrengthFair => 'Fair';

  @override
  String get authStrengthGood => 'Good';

  @override
  String get authStrengthStrong => 'Strong';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'I agree to the $terms and $privacy';
  }

  @override
  String get authDefaultUserName => 'User';

  @override
  String authMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get authFieldRequired => 'This field is required';

  @override
  String authSignOutFailed(String error) {
    return 'Failed to sign out: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get premiumSaveAbout44 => 'Save ~44%';

  @override
  String get premiumBestValue => 'Best Value';

  @override
  String get premiumIapUnavailable => 'IAP not available';

  @override
  String get premiumProductNotFound => 'Product not found';

  @override
  String get premiumPlanUnavailable =>
      'This plan is not available on your account right now';

  @override
  String get premiumRestoreFailed => 'Failed to restore purchases';

  @override
  String get premiumPurchaseFailed => 'Purchase failed';

  @override
  String get premiumVerificationFailed => 'Verification failed';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'You\'ve used $count of $limit free $items.';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'Upgrade to Premium for unlimited $items and more!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'You\'ve reached the free tier limit of $limit $items. Upgrade to Premium for unlimited $items.';
  }

  @override
  String get premiumLimitWallets => 'wallets';

  @override
  String get premiumLimitCategories => 'custom categories';

  @override
  String get premiumLimitBudgets => 'active budgets';

  @override
  String get premiumLimitObjectives => 'active objectives';

  @override
  String get premiumLimitPaymentMethods => 'payment methods';

  @override
  String get backupErrNotJson =>
      'This file is not a backup — it could not be read as JSON.';

  @override
  String get backupErrNotOurs =>
      'This file is not a backup from The Accountant.';

  @override
  String get backupErrNewerVersion =>
      'This backup was written by a newer version of the app. Update The Accountant and try again.';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'This backup is from an older version of the app than this one can read (database $version, oldest supported $oldest).';
  }

  @override
  String get backupErrNoData => 'This backup has no data in it.';

  @override
  String backupErrSectionDamaged(String section) {
    return 'The \"$section\" section of this backup is damaged.';
  }

  @override
  String get backupErrNoHeader =>
      'This backup is missing the header that says what it is.';

  @override
  String get backupErrNoSchemaVersion =>
      'This backup does not say which database version it was taken from, so it cannot be restored safely.';

  @override
  String get backupErrNoDate => 'This backup does not say when it was taken.';

  @override
  String get backupErrDamaged => 'This backup file is damaged.';

  @override
  String get backupErrWrongKey =>
      'This backup belongs to a different account, or the file has been changed. Sign in with the account that made it to restore it.';

  @override
  String get backupErrNoPassphraseLock =>
      'This backup cannot be opened with a passphrase.';

  @override
  String get backupErrNeedsSecret =>
      'This backup is protected with a passphrase. Enter it, or the recovery code, to restore it.';

  @override
  String get backupErrWrongSecret =>
      'That passphrase or recovery code does not open this backup.';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'This backup was made by a newer version of the app (database $version, this build reads up to $supported). Update The Accountant and try again.';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Drive could not be reached: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant is not allowed to use Google Drive yet.';

  @override
  String get backupDriveNoFolder =>
      'Google Drive would not make a folder to keep backups in.';

  @override
  String get backupDriveNoFileId =>
      'Google Drive accepted the backup but did not say where it put it.';

  @override
  String get backupDriveTimeout =>
      'Google Drive is taking too long to answer. Try again later.';

  @override
  String get backupDriveOffline =>
      'No connection to Google Drive. Try again once you are online.';

  @override
  String get backupDriveDenied =>
      'Google Drive turned the request down. Grant access again and retry.';

  @override
  String get backupDriveFileGone => 'That backup is no longer in Google Drive.';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive answered $status. $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'Try again in a moment.';

  @override
  String backupTakeFailed(String error) {
    return 'The backup could not be taken: $error';
  }

  @override
  String get backupUnrestorableNewer =>
      'Written by a newer version of the app.';

  @override
  String get backupUnrestorableOlder =>
      'Older than this version of the app can read.';

  @override
  String get backupKeyUnusable =>
      'The server sent an unusable encryption key. Try again later.';

  @override
  String get backupKeyNeedsSignIn =>
      'Sign in to make or restore a backup — backups are encrypted with your account.';

  @override
  String get backupKeyNeedsInternet =>
      'Connect to the internet once so your data can be encrypted, then try again.';

  @override
  String get backupKeyLocked =>
      'Your data is protected with a passphrase. Unlock it on this device first.';

  @override
  String get backupFrequencyManual => 'Only when I ask';

  @override
  String get backupFrequencyDaily => 'Every day';

  @override
  String get backupFrequencyWeekly => 'Every week';

  @override
  String get backupFrequencyMonthly => 'Every month';

  @override
  String get backupIntro =>
      'A backup is a single file holding everything on this device — every transaction, account, budget and goal. Keep one somewhere safe and nothing here is ever lost for good.';

  @override
  String get backupSectionOnDevice => 'ON THIS DEVICE';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'BACKUPS IN DRIVE';

  @override
  String backupBackedUpCount(int count) {
    return 'Backed up $count records.';
  }

  @override
  String get backupSaveDialogTitle => 'Save backup';

  @override
  String get backupChooseFileTitle => 'Choose a backup file';

  @override
  String backupFileUnreadable(String error) {
    return 'That file could not be read: $error';
  }

  @override
  String backupTakenOn(String date) {
    return 'Taken $date.';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return 'Taken $date on $device.';
  }

  @override
  String backupBelongedTo(String email) {
    return 'It belonged to $email.';
  }

  @override
  String get backupDifferentAccountWarning =>
      'That is not the account signed in here. Restoring will put someone else\'s records on this device.';

  @override
  String get backupRestoreEraseWarning =>
      'Everything currently on this device is erased and replaced. Anything that has not synced yet is lost. This cannot be undone.';

  @override
  String backupRestoredCount(int count) {
    return 'Restored $count records.';
  }

  @override
  String backupRestoredPartial(int count) {
    return 'Restored $count records. Some of the file did not fit this version and was left out.';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'Nothing was changed — the restore failed: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'Backups go in a private folder only this app can open. Your other files are never read.';

  @override
  String get backupDriveConnectedTitle => 'Google Drive connected';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'Backups from this device will go to a folder called \"$folder\" in your Drive.';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'Backups go to \"$folder\" in your Drive.';
  }

  @override
  String get backupNoneYet => 'No backup has gone up from this device yet';

  @override
  String backupLastBackedUp(String date) {
    return 'Last backed up $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count backups — older ones are removed after a new one lands';
  }

  @override
  String get backupDisconnectSubtitle =>
      'Stops automatic backups. Nothing already saved is deleted.';

  @override
  String backupListFailed(String error) {
    return 'Could not list your backups: $error';
  }

  @override
  String get backupDriveNotGranted => 'Google Drive access was not granted.';

  @override
  String get backupDriveConnected => 'Google Drive connected.';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Drive could not be connected: $error';
  }

  @override
  String get backupDisconnectBody =>
      'Automatic backups stop. The backups already in Drive stay where they are, and you can reconnect at any time.';

  @override
  String backupSavedToDrive(String name) {
    return 'Saved $name to Google Drive.';
  }

  @override
  String backupCopyFailed(String error) {
    return 'That backup could not be saved: $error';
  }

  @override
  String get backupDeleteBody => 'It is removed from Google Drive for good.';

  @override
  String get backupRefresh => 'Refresh';

  @override
  String get ppErrKdfParams => 'Unacceptable key-derivation parameters.';

  @override
  String get ppErrKdfAlgorithm => 'Unknown key-derivation algorithm.';

  @override
  String get onboardingIntroAccountsTitle => 'Every account, one balance';

  @override
  String get onboardingIntroAccountsBody =>
      'Keep cash, cards and savings side by side, and see what you actually have left.';

  @override
  String get onboardingIntroBudgetsTitle => 'Budgets that tell you early';

  @override
  String get onboardingIntroBudgetsBody =>
      'Set a limit per category. The app watches the total and warns you before you pass it, not after.';

  @override
  String get onboardingIntroAskTitle => 'Ask about your own spending';

  @override
  String get onboardingIntroAskBody =>
      'Scan a receipt, or ask where the money went last month, and get an answer drawn from your records.';

  @override
  String get onboardingIntroThemeTitle => 'Make it look like yours';

  @override
  String get onboardingIntroThemeBody =>
      'Pick a theme now, or change it whenever you like from settings.';

  @override
  String get onboardingCreateYourAccount => 'Create your account';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingCurrencyInfo =>
      'This will be used as your primary currency. You can add accounts with different currencies later.';

  @override
  String get onboardingTypeCash => 'Cash';

  @override
  String get onboardingTypeBank => 'Bank Account';

  @override
  String get onboardingTypeCard => 'Credit Card';

  @override
  String get onboardingTypeDeposit => 'Deposit';

  @override
  String get onboardingTypeInvestment => 'Investment';

  @override
  String get onboardingTypeAsset => 'Asset';

  @override
  String onboardingDayN(int day) {
    return 'Day $day';
  }

  @override
  String get onboardingAllSet => 'You\'re All Set!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'Failed to complete onboarding: $error';
  }

  @override
  String get onboardingSkipFailed => 'Failed to skip onboarding';

  @override
  String get startupOfflineConfirmBody =>
      'Your data stays exactly where it is — nothing on this device or in the cloud will be deleted.\n\nBut if the account does have data saved, anything you add now will sit alongside it once you restore — you may end up with duplicates to tidy up.';

  @override
  String get startupDataInCloudTitle => 'Your data is waiting in the cloud';

  @override
  String get startupLoadFailedTitle =>
      'We couldn\'t finish loading your account';

  @override
  String get startupGenericReason =>
      'Something went wrong while checking this account.';

  @override
  String get startupUseWithoutRestoring => 'Use the app without restoring';

  @override
  String get legalTermsTab => 'Terms';

  @override
  String get legalConsent =>
      'I have read and agree to the Privacy Policy and Terms & Conditions';

  @override
  String get walkthroughGotIt => 'Got it!';

  @override
  String get settingsFaqSectionGettingStarted => 'Getting Started';

  @override
  String get settingsFaq01Question => 'How do I add a transaction?';

  @override
  String get settingsFaq01Answer =>
      'Tap the + button at the bottom of the home screen. Fill in the amount, select a category, choose a wallet, and optionally add notes. Tap Save to record your transaction.';

  @override
  String get settingsFaq02Question =>
      'What is the difference between wallets and categories?';

  @override
  String get settingsFaq02Answer =>
      'Wallets represent where your money is stored (e.g., Cash, Bank Account, Credit Card). Categories describe what the money was spent on or where it came from (e.g., Food, Salary, Entertainment).';

  @override
  String get settingsFaq03Question =>
      'How do I customize my date and number format?';

  @override
  String get settingsFaq03Answer =>
      'Go to Settings > Regional Settings. You can change your default currency, date format (e.g., DD/MM/YYYY or MM/DD/YYYY), and number format (e.g., 1,234.56 or 1.234,56). A live preview shows how your settings will look.';

  @override
  String get settingsFaqSectionTransactions => 'Transactions';

  @override
  String get settingsFaq04Question => 'Can I track recurring transactions?';

  @override
  String get settingsFaq04Answer =>
      'Yes! When adding a transaction, enable the \"Recurring\" option. You can set it to repeat daily, weekly, monthly, or yearly. The app will automatically create these transactions for you.';

  @override
  String get settingsFaq05Question =>
      'How do I transfer money between wallets?';

  @override
  String get settingsFaq05Answer =>
      'When adding a transaction, select \"Transfer\" as the type. Choose the source wallet, destination wallet, and enter the amount. The app will automatically deduct from one and add to the other.';

  @override
  String get settingsFaq06Question => 'What are upcoming transactions?';

  @override
  String get settingsFaq06Answer =>
      'Upcoming transactions are future expenses or income you expect but haven\'t paid yet. They won\'t affect your wallet balance until you mark them as paid. You can find overdue and upcoming items in the transactions section.';

  @override
  String get settingsFaq07Question => 'How do I track subscriptions?';

  @override
  String get settingsFaq07Answer =>
      'When adding a transaction, set the special type to Subscription. This marks it as a recurring service payment. You can view all your subscriptions in one place and track your monthly subscription spending.';

  @override
  String get settingsFaq08Question => 'How does credit and debt tracking work?';

  @override
  String get settingsFaq08Answer =>
      'Use Credit to track money you\'ve lent to someone, and Debt to track money you\'ve borrowed. Each entry tracks the amount, who owes whom, and payment progress. You can record partial payments and mark debts as settled when fully repaid.';

  @override
  String get settingsFaq09Question =>
      'Can I add notes or receipts to transactions?';

  @override
  String get settingsFaq09Answer =>
      'Yes! When adding or editing a transaction, you can type notes in the notes field. Premium users can also scan receipts using the AI-powered receipt scanner, which automatically extracts the amount and merchant details.';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'Wallets & Currencies';

  @override
  String get settingsFaq10Question =>
      'How do I manage multiple wallet accounts?';

  @override
  String get settingsFaq10Answer =>
      'The app supports four account types: Cash, Bank Account, Credit Card, and Subscription. To add a new account, go to \'Your Accounts\' on the dashboard and tap \'Add Account\'. Each account can have its own name, icon, color, and currency. Your first account is automatically set as the default. Credit card accounts also let you set a credit limit and billing cycle day so you can track available credit.';

  @override
  String get settingsFaq11Question => 'Can I use multiple currencies?';

  @override
  String get settingsFaq11Answer =>
      'Yes! Each wallet can have its own currency. The app supports automatic currency conversion using live exchange rates. You can also set custom exchange rates in Settings > Regional Settings.';

  @override
  String get settingsFaq12Question => 'How does currency conversion work?';

  @override
  String get settingsFaq12Answer =>
      'Each wallet can have a different currency, and the app automatically converts amounts using live exchange rates updated every few hours. You can also set custom exchange rates for any currency pair in Settings > Regional Settings. The app supports over 150 currencies with automatic rate fetching.';

  @override
  String get settingsFaq13Question =>
      'What happens if I delete a category with transactions?';

  @override
  String get settingsFaq13Answer =>
      'Those transactions will be moved to \"Uncategorized\". You can then reassign them to a different category or leave them uncategorized.';

  @override
  String get settingsFaq14Question =>
      'What are subcategories and how do I use them?';

  @override
  String get settingsFaq14Answer =>
      'You can create subcategories under any main category for more detailed tracking. For example, under \'Food\', you could have \'Groceries\', \'Restaurants\', and \'Coffee\'. Subcategories help you see exactly where your money goes.';

  @override
  String get settingsFaq15Question => 'What is a balance correction?';

  @override
  String get settingsFaq15Answer =>
      'A balance correction lets you adjust a wallet\'s balance when it doesn\'t match the actual amount. This creates a special transaction that brings your tracked balance in line with reality, without manually adding income or expense entries.';

  @override
  String get settingsFaqSectionBudgetsGoals => 'Budgets & Goals';

  @override
  String get settingsFaq16Question => 'How do I set up a budget?';

  @override
  String get settingsFaq16Answer =>
      'Go to the Budgets tab and tap \"Create Budget\". Choose a name, set your spending limit, select the time period (weekly/monthly), and pick which categories to track. The app will alert you when you approach your limit.';

  @override
  String get settingsFaq17Question => 'What are savings goals?';

  @override
  String get settingsFaq17Answer =>
      'Savings goals let you set a target amount you want to save. Create a goal in the Objectives section, set your target, and link transactions to track your progress. The app shows a progress bar and percentage toward your target.';

  @override
  String get settingsFaq18Question => 'How do I track a loan?';

  @override
  String get settingsFaq18Answer =>
      'Create a Loan objective in the Objectives section with the total amount owed. As you make payments, link those transactions to the loan to track your repayment progress. The app shows how much you\'ve paid and what remains.';

  @override
  String get settingsFaqSectionDataSync => 'Data & Sync';

  @override
  String get settingsFaq19Question => 'How does Cloud Sync work?';

  @override
  String get settingsFaq19Answer =>
      'Cloud Sync keeps your data synchronized across devices. Go to Settings > Data Management > Cloud Sync to enable it. Sync runs automatically every 15 minutes and when you open the app. You can also tap \'Sync Now\' for an immediate sync. This is a Premium feature.';

  @override
  String get settingsFaq20Question => 'How do I export my data?';

  @override
  String get settingsFaq20Answer =>
      'Go to Settings > Data Management > Export Data. Choose a date range, select CSV (for spreadsheets) or PDF (for a formatted report), and tap Export. You can include or exclude category and wallet breakdowns. This is a Premium feature.';

  @override
  String get settingsFaq21Question => 'What happens if I clear my data?';

  @override
  String get settingsFaq21Answer =>
      'Go to Settings > Privacy & Security. \'Clear Cache\' removes temporary data and forces a re-sync without deleting your transactions. \'Clear All Data\' permanently deletes everything — you\'ll need to type DELETE to confirm. This action cannot be undone.';

  @override
  String get settingsFaqSectionPremiumAiFeatures => 'Premium & AI Features';

  @override
  String get settingsFaq22Question => 'What features are included in Premium?';

  @override
  String get settingsFaq22Answer =>
      'Premium unlocks: unlimited AI (the coach, monthly summaries, receipt reading and Describe it) with no ads, Cloud Sync, PDF reports, Premium Themes, and removes limits on wallets, categories, budgets, goals, and payment methods. You also get priority support.';

  @override
  String get settingsFaq23Question => 'What are the free tier limits?';

  @override
  String get settingsFaq23Answer =>
      'Free users can create up to 3 wallets, 10 custom categories, 3 active budgets, 2 active goals/loans, and 5 payment methods. Upgrading to Premium removes all these limits.';

  @override
  String get settingsFaq24Question => 'What can the AI Assistant do?';

  @override
  String get settingsFaq24Answer =>
      'The money coach answers questions about your own money: where it went, whether you are on track with your budgets and goals, which bills are coming, and how to spend less or save more. It sees a summary of your figures (totals, categories, budgets, goals, bills and recent transactions) so its answers use your real numbers, and it suggests follow-up questions after each reply. It gives general guidance, not professional financial advice. Your conversations are saved so you can pick up where you left off, and you can delete them at any time.';

  @override
  String get settingsFaq25Question => 'How do AI Insights work?';

  @override
  String get settingsFaq25Answer =>
      'The monthly summary (Stats > Spending Insights) shows this month against last month: what you earned and spent, and how each category moved. Tap Write my summary and the AI picks out what stood out and suggests one thing to try. The numbers are free for everyone; the AI write-up uses one AI request.';

  @override
  String get settingsFaq26Question => 'What is Smart Categorization?';

  @override
  String get settingsFaq26Answer =>
      'When you file a transaction by hand, the app remembers which category that title belongs to and picks it for you next time (you can see and edit these under Naming rules). For something new, tap the sparkle button on the add screen and Describe it: type something like \'lunch 250 yesterday from bKash\' and the AI fills in the amount, date, category and account for you to check.';

  @override
  String get settingsFaq27Question => 'How does the AI receipt scanner work?';

  @override
  String get settingsFaq27Answer =>
      'Take or pick a photo of a receipt. Your phone reads the text on the device and suggests the merchant and total. Tap Read with AI and the AI works out the real total, the date, each item and the right category, even on a messy receipt; only the text is sent, never the photo. You can review and edit before saving. Reading with AI uses one AI request.';

  @override
  String get settingsFaq28Question =>
      'How many AI requests do I get, and what are the ads for?';

  @override
  String get settingsFaq28Answer =>
      'Everyone gets 10 free AI requests a month, and they come back on the 1st. If you want more, you can choose to watch a short ad for one extra request, up to 10 more a month. Ads can also unlock a 24-hour premium theme trial or a PDF export. An ad only ever plays after you tap a button and confirm; there are no banner ads and nothing appears on its own. Premium members get unlimited AI and everything else with no ads at all.';

  @override
  String get settingsFaq29Question => 'How do I manage my Premium purchase?';

  @override
  String get settingsFaq29Answer =>
      'Premium purchases are managed through Google Play. Go to your Google Play subscription settings to view or manage your plan. Premium is available as a monthly, yearly, or one-time lifetime purchase.';

  @override
  String get settingsFaqSectionPrivacySecurity => 'Privacy & Security';

  @override
  String get settingsFaq30Question => 'How do I set up biometric lock?';

  @override
  String get settingsFaq30Answer =>
      'Go to Settings > Privacy & Security and enable Biometric Lock. Once enabled, you\'ll need your fingerprint or face to open the app. You can also configure an auto-lock timer so the app locks after a period of inactivity.';

  @override
  String get settingsFaq31Question => 'Is my financial data secure?';

  @override
  String get settingsFaq31Answer =>
      'Yes. All your data is stored locally on your device. If you enable Cloud Sync, your data is encrypted during transfer. We never share your financial data with third parties. You can review our Privacy Policy in Settings > About.';

  @override
  String get txnLoadPaymentMethodsFailed => 'Failed to load payment methods';

  @override
  String get txnAddPaymentMethodFailed => 'Failed to add payment method';

  @override
  String get txnPaymentMethodNotFound => 'Payment method not found';

  @override
  String get txnUpdatePaymentMethodFailed => 'Failed to update payment method';

  @override
  String get txnDeletePaymentMethodFailed => 'Failed to delete payment method';

  @override
  String txnLoadFailed(String error) {
    return 'Failed to load transactions: $error';
  }

  @override
  String get txnAddFailed => 'Failed to add transaction';

  @override
  String txnAddFailedWithError(String error) {
    return 'Failed to add transaction: $error';
  }

  @override
  String get txnNotFound => 'Transaction not found';

  @override
  String get txnUpdateFailed => 'Failed to update transaction';

  @override
  String txnNotATransfer(String id) {
    return 'Transaction $id is not a transfer';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'Failed to update transfer: $error';
  }

  @override
  String get txnDeleteFailed => 'Failed to delete transaction';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'Failed to load transfers: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'Failed to create transfer: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'Failed to delete transfer: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'Failed to load data: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'Failed to mark as paid: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'Failed to mark as unpaid: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'Failed to skip transaction: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'Received: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'Paid: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'Reversed: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'Failed to mark as settled: $error';
  }

  @override
  String get creditPaymentMustBePositive => 'Payment amount must be positive';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'Failed to record payment: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'Failed to mark as pending: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'Payment of $amount recorded';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'Marked as collected from \"$title\"';
  }

  @override
  String get importFieldDescription => 'Description';

  @override
  String get importFieldDirection => 'Type (credit/debit)';

  @override
  String get importMissingDate => 'a date column';

  @override
  String get importMissingAmount => 'an amount column';

  @override
  String importColumnN(int index) {
    return 'Column $index';
  }

  @override
  String get importNoDate => 'No date';

  @override
  String importDateMismatch(String date, String format) {
    return 'The date \"$date\" does not match $format';
  }

  @override
  String get importAnyKnownFormat => 'any known format';

  @override
  String get importNoAmount => 'No amount';

  @override
  String get importIntro =>
      'Export a CSV from your bank and open it here. The columns are worked out for you, and nothing is added until you have seen exactly what it will be.';

  @override
  String get importSavedBanks => 'SAVED BANKS';

  @override
  String get importChooseStatement => 'Choose a statement';

  @override
  String get importNoRows => 'There are no rows in that file.';

  @override
  String importUsingSavedMapping(String name) {
    return 'Using your saved mapping for $name.';
  }

  @override
  String importCouldNotRead(String error) {
    return 'That file could not be read: $error';
  }

  @override
  String importForgetTitle(String name) {
    return 'Forget $name?';
  }

  @override
  String get importForgetBody =>
      'You will be asked to map the columns again next time.';

  @override
  String get importColumnsHeader => 'COLUMNS';

  @override
  String get importHowToRead => 'HOW TO READ THE VALUES';

  @override
  String get importWhereItGoes => 'WHERE IT GOES';

  @override
  String get importWhatWillBeAdded => 'WHAT WILL BE ADDED';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows',
      one: '1 row',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count columns',
      one: '1 column',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'separated by $separator';
  }

  @override
  String importMappedAs(String name) {
    return 'mapped as $name';
  }

  @override
  String get importDelimCommas => 'commas';

  @override
  String get importDelimSemicolons => 'semicolons';

  @override
  String get importDelimTabs => 'tabs';

  @override
  String get importDelimPipes => 'pipes';

  @override
  String get importRequired => 'Required';

  @override
  String get importNotImported => 'Not imported';

  @override
  String get importEmptySample => 'empty';

  @override
  String get importPickDateColumnFirst => 'Pick a date column first.';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" does not fit this format.';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" reads as $date';
  }

  @override
  String get importDecimalAuto => 'Worked out from the file';

  @override
  String get importDecimalFullStop => 'A full stop, as in 1,234.56';

  @override
  String get importDecimalComma => 'A comma, as in 1.234,56';

  @override
  String get importDuplicatesHint =>
      'Matches on the day, the amount and the description, so re-importing an overlapping statement does not double anything';

  @override
  String importStillNeeds(String item) {
    return 'Still needs $item.';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'Still needs $first and $second.';
  }

  @override
  String get importNothingReadable =>
      'Nothing in this file can be read with these settings. Check the date format and which column holds the amount.';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount in';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount out';
  }

  @override
  String importAndMore(int count) {
    return 'and $count more';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines will be skipped',
      one: '1 line will be skipped',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines will be skipped.',
      one: '1 line will be skipped.',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'Line $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'Add an account first';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count transactions',
      one: 'Import 1 transaction',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count transactions?',
      one: 'Import 1 transaction?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'They are added to your records and uploaded on the next sync.';

  @override
  String get importConfirmDuplicates =>
      'Anything already here on the same day, for the same amount and description, is left alone.';

  @override
  String importFailed(String error) {
    return 'The import failed: $error';
  }

  @override
  String importImportedTitle(int count) {
    return 'Imported $count';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count were already here and were left alone.';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines could not be read.',
      one: '1 line could not be read.',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'New categories: $names.';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'These account names had nothing here to match, so their rows went to the account you chose: $names.';
  }

  @override
  String get importRememberBody =>
      'The next file with these same columns will be mapped this way without asking.';

  @override
  String get importNoHeaderCannotSave =>
      'A file with no column titles cannot be recognised again, so there is nothing to match on.';

  @override
  String get importTemplateSaved =>
      'Saved. Files with these columns will use it from now on.';

  @override
  String get txnTransferSameWallet =>
      'Source and destination wallets must be different';

  @override
  String get txnTransferAmountPositive => 'Transfer amount must be positive';

  @override
  String get txnTransferFeeNegative => 'Transfer fee cannot be negative';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'Source wallet not found: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'Destination wallet not found: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'Transfer: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'Both wallets must exist to transfer between them (source: $source, destination: $destination).';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'A transfer within one currency moves one figure: $source and $destination are both in $currency, so the amount received cannot differ.';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'No rate is known between $from and $to, so enter what actually landed in $destination.';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'The amount received has to be more than zero. Enter what actually landed in $destination.';
  }

  @override
  String txnFeeTitle(String title) {
    return 'Fee: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'Transaction not found: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'Transaction is not a transfer (no paired transaction)';

  @override
  String txnPairedNotFound(String id) {
    return 'Paired transaction $id not found; refusing to edit half a transfer.';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'No such account: $id';
  }

  @override
  String get walletCorrectionTitle => 'Balance correction';

  @override
  String walletCorrectionNote(String name) {
    return 'Adjusted $name to match its real balance.';
  }

  @override
  String get walletMergeIntoItself =>
      'An account cannot be merged into itself.';

  @override
  String get walletMergeBothMustExist =>
      'Both accounts must exist to merge them.';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'No rate is known between $from and $to, so these accounts cannot be merged yet.';
  }

  @override
  String get walletMergeAdjustmentTitle => 'Merge adjustment';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'The rate a transfer between these accounts was made at differs from the rate $name was merged at. This records the difference so the total is unchanged.';
  }

  @override
  String get splitErrNoTotal => 'Enter the amount of the bill.';

  @override
  String get splitErrNoPeople => 'Add someone to split it with.';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name is not in on the bill.';
  }

  @override
  String get splitErrNothingToRecord =>
      'Someone else paid and you had none of it, so there is nothing to record.';

  @override
  String get splitErrGiveOwnShare => 'Give your own share.';

  @override
  String splitErrGiveShare(String name) {
    return 'Give $name\'s share.';
  }

  @override
  String get splitErrNegativeShare => 'A share cannot be negative.';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'The shares add up to $sum, not $total.';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'The percentages add up to $sum%, not 100%.';
  }

  @override
  String get splitErrNameTooLong => 'Keep names under 100 characters.';

  @override
  String splitErrDuplicateName(String name) {
    return '$name is on the bill twice.';
  }

  @override
  String get splitErrTitleTooLong => 'Keep the title under 200 characters.';

  @override
  String get splitErrChooseAccount => 'Choose the account it was paid from.';

  @override
  String get splitErrOrdinaryAccount => 'Choose an ordinary account.';

  @override
  String get splitErrYourShareNothing =>
      'Your share is nothing, so there is nothing owed.';

  @override
  String get splitErrEveryShareNothing => 'Every share is nothing.';

  @override
  String get recurringDaily => 'Daily';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every week',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Every month',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every year',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'Every $count $unit';
  }

  @override
  String get recurringUntitled => 'Recurring Transaction';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'Next week';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count weeks',
      one: 'In 1 week',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'Card';

  @override
  String get txnPmKindDigitalWallet => 'Digital wallet';

  @override
  String get txnPmEmptyHint =>
      'Add the cards and accounts you pay with, and you can pick one on a transaction.';

  @override
  String get txnPmDeleteBody =>
      'Transactions already filed against it keep their record. They simply stop naming a payment method.';

  @override
  String get txnPmNew => 'New payment method';

  @override
  String get txnPmEdit => 'Edit payment method';

  @override
  String get txnRecentlyDeletedFooter =>
      'Deleted transactions are kept for thirty days, then removed for good.';

  @override
  String get txnUnknownCategory => 'Unknown';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'Exactly this';

  @override
  String get txnRuleContaining => 'Anything containing this';

  @override
  String get txnRulesFooter =>
      'A rule matches anywhere in the title unless you make it exact. The app adds one for you each time you file something by hand.';

  @override
  String get txnRulesEmptyHint =>
      'Teach the app where something belongs once, and it files it that way from then on.';

  @override
  String get txnRuleNew => 'New rule';

  @override
  String get txnRuleEdit => 'Edit rule';

  @override
  String get txnRuleExactHint => 'Only titles that are exactly this';

  @override
  String get txnRuleContainingHint => 'Any title containing it';

  @override
  String get txnKindTransfer => 'Transfer between accounts';

  @override
  String get txnKindRecurring => 'From a repeating entry';

  @override
  String get txnMoneyIn => 'Money in';

  @override
  String get txnMoneyOut => 'Money out';

  @override
  String get txnNotYetPaid => 'Not yet paid';

  @override
  String get txnLentOut => 'Lent out';

  @override
  String get txnSettledInFull => 'Settled in full.';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid back, $owed still owed.';
  }

  @override
  String get txnUncategorised => 'Uncategorised';

  @override
  String get txnUnknownAccount => 'Unknown';

  @override
  String get txnTransferCannotCopy => 'A transfer cannot be copied on its own.';

  @override
  String get txnCopied => 'Copied.';

  @override
  String get txnDeleteOneBody =>
      'The account balance is recalculated. If this is one leg of a transfer, the other half goes with it.';

  @override
  String txnUpcomingTab(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'Overdue ($count)';
  }

  @override
  String get txnNoOverdue => 'No overdue transactions';

  @override
  String get txnNoUpcoming => 'No upcoming transactions';

  @override
  String get txnNoOverdueBody => 'All your payments are up to date!';

  @override
  String get txnNoUpcomingBody => 'You have no pending payments scheduled';

  @override
  String get txnTotalOverdue => 'Total Overdue';

  @override
  String get txnTotalUpcoming => 'Total Upcoming';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return 'Marked \"$title\" as paid';
  }

  @override
  String txnSkippedTitle(String title) {
    return 'Skipped \"$title\"';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'Today, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'Yesterday, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'Tomorrow, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'Error deleting transaction: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return 'Filter $title';
  }

  @override
  String get txnMonthlyIncome => 'Monthly Income';

  @override
  String get txnMonthlyExpenses => 'Monthly Expenses';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'transactions',
      one: 'transaction',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'avg per transaction';

  @override
  String get txnNoPlannedIncome => 'No planned income';

  @override
  String get txnNoPlannedExpenses => 'No planned expenses';

  @override
  String txnAddFutureIncome(String month) {
    return 'Add future income for $month';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'Add future expenses for $month';
  }

  @override
  String get txnNoIncomeYet => 'No income yet this month';

  @override
  String get txnNoExpensesYet => 'No expenses yet this month';

  @override
  String get txnStartTrackingIncome => 'Start tracking your income this month';

  @override
  String get txnStartTrackingExpenses =>
      'Start tracking your expenses this month';

  @override
  String txnNoIncomeIn(String month) {
    return 'No income in $month';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'No expenses in $month';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'No records for $month';
  }

  @override
  String get txnOtherCategory => 'Other';

  @override
  String get txnSearchIncome => 'Search income';

  @override
  String get txnSearchExpenses => 'Search expenses';

  @override
  String txnErrorWith(String error) {
    return 'Error: $error';
  }

  @override
  String get txnTapToEditAmount => 'Tap to edit amount';

  @override
  String get txnTapToEnterAmount => 'Tap to enter amount';

  @override
  String get txnSpecialDefault => 'Default';

  @override
  String get txnSpecialRepetitive => 'Repetitive';

  @override
  String get txnRepeatSettings => 'Repeat Settings';

  @override
  String get txnSubscriptionSettings => 'Subscription Settings';

  @override
  String txnEndsOn(String date) {
    return 'Ends: $date';
  }

  @override
  String get txnNoEndDate => 'No end date';

  @override
  String get txnEditTransaction => 'Edit Transaction';

  @override
  String get txnNewTransaction => 'New Transaction';

  @override
  String get txnFromAccount => 'From account';

  @override
  String get txnToAccount => 'To account';

  @override
  String get txnAmountReceived => 'Amount received';

  @override
  String txnAmountReceivedHint(String account) {
    return 'These accounts count in different currencies. Enter what actually landed in $account, or leave it blank to use the app\'s rate.';
  }

  @override
  String txnInCurrency(String currency) {
    return 'In $currency';
  }

  @override
  String get txnTransferTitleHint => 'e.g. Move to savings (optional)';

  @override
  String get txnTitleHint => 'What was it for?';

  @override
  String get txnUpdate => 'Update';

  @override
  String get txnSelectCategory => 'Select category';

  @override
  String get txnSearchTransactions => 'Search transactions';

  @override
  String get txnSpecialRegular => 'Regular';

  @override
  String get txnSpecialLend => 'Lend';

  @override
  String get txnSpecialBorrow => 'Borrow';

  @override
  String get txnSpecialRegularDesc => 'Normal transaction';

  @override
  String get txnSpecialUpcomingDesc => 'Future payment to track';

  @override
  String get txnSpecialSubscriptionDesc => 'Recurring service payment';

  @override
  String get txnSpecialRepetitiveDesc => 'Repeating transaction';

  @override
  String get txnSpecialLendDesc => 'Money you lent (they owe you)';

  @override
  String get txnSpecialBorrowDesc => 'Money you borrowed (you owe them)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'The lower bound is above the upper one, so nothing can match. $min to $max.';
  }

  @override
  String get walletMyWallet => 'My Wallet';

  @override
  String walletCreateFailed(String error) {
    return 'Failed to create wallet: $error';
  }

  @override
  String get walletTypeBankAccount => 'Bank Account';

  @override
  String get walletTypeCreditCard => 'Credit Card';

  @override
  String get walletTypeSubscription => 'Subscription';

  @override
  String get walletTypeDeposit => 'Deposit';

  @override
  String get walletTypeInvestment => 'Investment';

  @override
  String get walletTypeAsset => 'Asset';

  @override
  String get walletEnterAccountName => 'Please enter an account name';

  @override
  String get walletCreditLimitRequired => 'Credit limit is required';

  @override
  String get walletEnterValidCreditLimit => 'Please enter a valid credit limit';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'Please enter a valid credit limit greater than 0';

  @override
  String get walletEditWallet => 'Edit Wallet';

  @override
  String get walletAddNewWallet => 'Add New Wallet';

  @override
  String get walletEnterWalletNameError => 'Please enter a wallet name';

  @override
  String get walletEnterValidNumber => 'Please enter a valid number';

  @override
  String get walletShowCents => 'Show cents (e.g., \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'Whole numbers only (e.g., \$1,235)';

  @override
  String get walletCreateWallet => 'Create Wallet';

  @override
  String get walletClosedPill =>
      'Closed. Its history is kept, but it is not offered or counted.';

  @override
  String get walletExcludedPill => 'Left out of the total across accounts.';

  @override
  String get walletReopen => 'Reopen';

  @override
  String get walletCloseAccount => 'Close account';

  @override
  String get walletReopenSubtitle => 'Offer it again and count it';

  @override
  String get walletCloseAccountSubtitle => 'Keep its history, stop counting it';

  @override
  String get walletIncludeInTotal => 'Include in the total';

  @override
  String get walletLeaveOutOfTotal => 'Leave out of the total';

  @override
  String get walletAlreadyTheBalance => 'That is already the balance.';

  @override
  String get walletCorrectionRecorded =>
      'Recorded the difference as a correction.';

  @override
  String walletMergeConfirmBody(String name) {
    return 'Everything filed against $name moves across, and $name is closed. Nothing is deleted.';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'Amounts are converted from $from to $to as they move. Nothing is deleted, and $name is closed rather than removed.';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount in credit · $available available';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount owed · $available still available';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return 'Enter what $name really holds. The difference is recorded as a transaction, so the account still adds up to its own history.';
  }

  @override
  String get apiUpdateRequired =>
      'Update The Accountant to keep syncing. Everything stays on this phone until you do.';

  @override
  String get apiAccountExistsLink =>
      'An account with this email already exists. Please link your accounts.';

  @override
  String get apiServerTrouble =>
      'Our server is having trouble right now. Everything is safe on this phone; try again in a few minutes.';

  @override
  String apiRequestFailedHttp(String status) {
    return 'Request failed (HTTP $status).';
  }

  @override
  String get apiServerTimeout =>
      'Our server took too long to answer. Check your connection, or try again in a few minutes.';

  @override
  String get apiCannotReachServer =>
      'Cannot reach our server. Check your connection; if you are online, try again in a few minutes.';

  @override
  String get apiSomethingWentWrong =>
      'Something went wrong talking to our server. Please try again.';

  @override
  String get syncAlreadyInProgress => 'Sync already in progress';

  @override
  String get syncRequiresPremium => 'Cloud sync requires Premium subscription';

  @override
  String get syncNoInternet => 'No internet connection';

  @override
  String get syncNotAuthenticated => 'Not authenticated';

  @override
  String get syncCouldNotFetchCloud =>
      'Could not fetch your cloud data. Local data is unchanged.';

  @override
  String get syncAccountUnknown =>
      'Could not determine the signed-in account; sync cancelled.';

  @override
  String get syncStoreOtherAccount =>
      'This device\'s data belongs to a different account. Sign in as that account, or clear the local data, before syncing.';

  @override
  String syncRecordsNotSaved(String record) {
    return 'Some cloud records could not be saved on this device: $record. They will be retried on the next sync.';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'Some cloud records could not be saved on this device: $record (and $count more). They will be retried on the next sync.';
  }

  @override
  String notifCardStatementReady(String name) {
    return '$name statement is ready';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'It came to $amount, already paid. Nothing more is due.';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount is due by $date.';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$paid of $owed is already paid.';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return '$name bill is due tomorrow';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return '$name bill is due in $days days';
  }

  @override
  String notifPayBy(String amount, String date) {
    return 'Pay $amount by $date.';
  }

  @override
  String notifCardDueToday(String name) {
    return '$name bill is due today';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount is still unpaid.$paidSoFar Paying today avoids a late fee.';
  }

  @override
  String get notifWhenToday => 'today';

  @override
  String get notifWhenTomorrow => 'tomorrow';

  @override
  String notifWhenInDays(int days) {
    return 'in $days days';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name pays out $when';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount is due to $account on $date.';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name matures $when';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount comes back to $account on $date.';
  }

  @override
  String notifPlanInstallmentDue(
    String name,
    String kind,
    int number,
    int total,
    String when,
  ) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'dps': 'deposit',
      'insurance': 'premium',
      'sip': 'SIP',
      'other': 'installment',
    });
    return '$name: $_temp0 $number of $total due $when';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return 'Invest $amount by $date.';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount will be invested from $account on $date.';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount will be recorded from $account on $date.';
  }

  @override
  String get notifYourAccount => 'your account';

  @override
  String get notifPlansUpdatedTitle => 'EMI and savings updated';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plan entries recorded on their day.',
      one: '1 plan entry recorded on its day.',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'Recurring transactions recorded';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recurring transactions recorded.',
      one: '1 recurring transaction recorded.',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments to confirm',
      one: '1 payment to confirm',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'Confirm what was charged, or skip it, in Upcoming.';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — confirm what was charged, or skip it, in Upcoming.';
  }

  @override
  String get notifUpcomingFallbackTitle => 'Upcoming Transaction';

  @override
  String notifUpcomingTitle(String title) {
    return 'Upcoming: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return 'Income of $amount is due soon.';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return 'Expense of $amount is due soon.';
  }

  @override
  String get notifCreditFallback => 'Credit';

  @override
  String get notifDebtFallback => 'Debt';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'Overdue Credit: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'Overdue Debt: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount is still outstanding. Tap to review.';
  }

  @override
  String get notifRecurringFallbackTitle => 'Recurring Transaction';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'Upcoming Recurring: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount due on $date.';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'Credit Due: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'Debt Due: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'Subscription Due: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'Bill Due: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'Due Soon: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'Repetitive Bill';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount is due soon. Tap to review.';
  }

  @override
  String get notifChannelRecurring => 'Recurring Transactions';

  @override
  String get notifChannelRecurringDesc =>
      'Notifications for auto-created recurring transactions';

  @override
  String get notifChannelUpcoming => 'Upcoming Reminders';

  @override
  String get notifChannelUpcomingDesc => 'Reminders for upcoming transactions';

  @override
  String get notifChannelLoan => 'Loan Reminders';

  @override
  String get notifChannelLoanDesc => 'Reminders for overdue credits and debts';

  @override
  String get notifChannelDueDate => 'Due Date Reminders';

  @override
  String get notifChannelDueDateDesc =>
      'One-off reminders for specific transaction due dates';

  @override
  String get notifChannelBillsDesc =>
      'Credit card bills and plan installments coming due';

  @override
  String get notifOffset1Hour => '1 hour before';

  @override
  String get notifOffset1Day => '1 day before';

  @override
  String get notifOffset3Days => '3 days before';

  @override
  String get notifOffset1Week => '1 week before';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes minutes before';
  }

  @override
  String get notifChannelGeneral => 'General';

  @override
  String get notifChannelGeneralDesc => 'Account and app notifications';

  @override
  String get notifChannelReminders => 'Daily reminders';

  @override
  String get notifChannelRemindersDesc => 'A nudge to log the day\'s spending';

  @override
  String get notifChannelBillsStatementsDesc =>
      'Credit card statements and due dates';

  @override
  String get notifChannelBudgets => 'Budget alerts';

  @override
  String get notifChannelBudgetsDesc =>
      'When a budget is nearly or fully spent';

  @override
  String notifOverBudgetTitle(String name) {
    return 'Over budget: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'Budget alert: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'You have spent $percent% of your $name budget for this period.';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'You have used $percent% of your $name budget.';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium is ending soon';

  @override
  String get notifPremiumEndsTomorrow =>
      'Your Premium ends tomorrow. Renew to keep your Premium features.';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'Your Premium ends in $days days. Renew to keep your Premium features.';
  }

  @override
  String get notifLargeIncomeTitle => 'Large Income Alert';

  @override
  String get notifLargeExpenseTitle => 'Large Expense Alert';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return 'Income of $amount recorded: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return 'Income of $amount recorded';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return 'Expense of $amount recorded: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return 'Expense of $amount recorded';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'Daily expense reminder notifications';

  @override
  String get notifDailyReminderTitle => 'Daily Expense Reminder';

  @override
  String get notifDailyReminderBody =>
      'Don\'t forget to log your expenses today! Keep track of your spending.';

  @override
  String get notifTestTitle => 'Test Notification';

  @override
  String get notifTestBody => 'If you see this, notifications are working!';

  @override
  String get notifActionSnooze1Day => 'Snooze 1d';

  @override
  String get notifActionSnooze1Week => 'Snooze 1w';

  @override
  String get notifGroupThisWeek => 'This Week';

  @override
  String get notifGroupThisMonth => 'This Month';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String notifHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String notifDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get notifPrimerSheetBody =>
      'Turn on notifications and we\'ll give you a heads-up on the things that matter.';

  @override
  String get notifPrimerBudgetsBody => 'Know before you overspend a budget.';

  @override
  String get notifPrimerBillsTitle => 'Bill & subscription reminders';

  @override
  String get notifPrimerBillsBody => 'Never miss a recurring payment.';

  @override
  String get notifPrimerLargeTitle => 'Large transactions';

  @override
  String get notifPrimerLargeBody => 'Get notified about unusual activity.';

  @override
  String get notifLoadFailed => 'Failed to load notifications';

  @override
  String get startupReasonSomethingWrong =>
      'Something went wrong while starting up. Your data is safe on this device.';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'Could not open the local data for this account.';

  @override
  String get startupReasonSetupFailed =>
      'We could not finish setting up this account on this device. Nothing has been deleted.';

  @override
  String get startupReasonOffline =>
      'We couldn\'t reach your account, and this device doesn\'t have its data yet. If you\'ve used The Accountant before, connect to the internet and we\'ll bring your data back. New here? You can start on this device now.';

  @override
  String get startupReasonNeedsSubscription =>
      'This account has data saved in the cloud. Restoring it needs an active subscription. Nothing has been deleted.';

  @override
  String get startupReasonConfirmingSubscription =>
      'This account has data in the cloud. We are still confirming your subscription so it can be restored.';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'This account has data in the cloud but it could not be restored yet.';

  @override
  String get commonBiometricReason => 'Authenticate to unlock The Accountant';

  @override
  String get commonLoadCurrenciesFailed => 'Failed to load currencies';

  @override
  String get commonLoadRatesFailed => 'Failed to load exchange rates';

  @override
  String get commonRefreshRatesFailed => 'Failed to refresh exchange rates';

  @override
  String get commonAllCategories => 'All categories';

  @override
  String commonCategoryCount(int count) {
    return '$count categories';
  }

  @override
  String get commonTierFree => 'Free';

  @override
  String get commonTierMonthly => 'Premium Monthly';

  @override
  String get commonTierYearly => 'Premium Yearly';

  @override
  String get commonTierLifetime => 'Premium Lifetime';

  @override
  String get commonCategoryMergeSelf =>
      'A category cannot be merged into itself.';

  @override
  String get commonCategoryMergeMissing =>
      'Both categories must exist to merge them.';

  @override
  String get commonCategoryMergeSystem =>
      'The app\'s own categories cannot be merged.';

  @override
  String get commonCategoryMergeKinds =>
      'Income and spending categories cannot be merged.';

  @override
  String get commonCategoryOneLevel =>
      'That category is inside another one, and categories are one level deep.';

  @override
  String get commonCategoryMoveSame =>
      'Pick a different category to move them to.';

  @override
  String get commonCategoryMoveMissing =>
      'Both categories must exist to move between them.';

  @override
  String get commonCategoryMoveSystem =>
      'The app\'s own categories cannot be moved between.';

  @override
  String get commonCategoryMoveKinds =>
      'Income and spending transactions cannot swap categories.';

  @override
  String get commonCategoryGone => 'That category no longer exists.';

  @override
  String get commonCategoryParentSystem =>
      'The app\'s own categories cannot be moved.';

  @override
  String get commonCategoryParentSelf => 'A category cannot sit inside itself.';

  @override
  String get commonCategoryParentIntoSystem =>
      'Nothing can be filed inside the app\'s own categories.';

  @override
  String get commonCategoryParentKinds =>
      'An income category and a spending one cannot be nested.';

  @override
  String get commonCategoryHasChildren =>
      'This category has subcategories of its own, so it stays at the top level.';

  @override
  String get commonTapToChange => 'Tap to change';

  @override
  String get commonSelectColor => 'Select color';

  @override
  String get commonShowPalette => 'Show palette';

  @override
  String get commonCustomColor => 'Custom color';

  @override
  String get commonSelectCurrency => 'Select currency';

  @override
  String get commonEnableCryptoHint =>
      'Enable \'Include crypto currencies\' to search crypto tokens.';

  @override
  String get commonSearchHint => 'Search...';

  @override
  String get aiLoadConversationsFailed => 'Failed to load conversations.';

  @override
  String get aiLoadHistoryFailed => 'Failed to load chat history.';

  @override
  String get aiPremiumRequired =>
      'Premium subscription required for AI Assistant';

  @override
  String get aiUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get aiResponseFailed => 'Failed to get AI response. Please try again.';

  @override
  String get aiServiceNotAnswering => 'The AI service is not answering.';

  @override
  String get aiReplyCutOff => 'The reply was cut off. Please try again.';

  @override
  String get aiCouldNotReachServer =>
      'Could not reach the server. Check your connection and try again.';

  @override
  String get aiSomethingWentWrong => 'Something went wrong.';

  @override
  String get aiOpenConversationFailed => 'Failed to open conversation.';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your $count changes were saved, but the coach could not finish its reply. Check them in your records before asking again.',
      one:
          'Your change was saved, but the coach could not finish its reply. Check it in your records before asking again.',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'The AI service is not answering right now. Please try again.';

  @override
  String aiMinutesShort(int count) {
    return '${count}m';
  }

  @override
  String aiHoursShort(int count) {
    return '${count}h';
  }

  @override
  String aiDaysShort(int count) {
    return '${count}d';
  }

  @override
  String get aiOcrTextFailed => 'Failed to extract text from image';

  @override
  String get aiOcrReceiptFailed => 'Failed to extract receipt data from image';

  @override
  String get coachYes => 'yes';

  @override
  String get coachNo => 'no';

  @override
  String get coachTradeBuy => 'buy';

  @override
  String get coachTradeSell => 'sell';

  @override
  String get coachTradeDividend => 'dividend';

  @override
  String get planAccountGone => 'That account no longer exists.';

  @override
  String get planPaidFromOrdinary =>
      'A plan is paid from an ordinary account, not from a deposit.';

  @override
  String get planSipChooseHolding => 'Choose the fund or share the SIP buys.';

  @override
  String get planSipPayFromOther => 'Pay for the SIP from another account.';

  @override
  String get planNeedNameError => 'Give the plan a name.';

  @override
  String get planInstallmentCountRange =>
      'The number of installments must be 1 to 1200.';

  @override
  String get planIntervalMin => 'The interval must be at least 1.';

  @override
  String get planRateRange => 'The rate must be between 0 and 100 percent.';

  @override
  String get planTaxRange => 'The tax must be between 0 and 100 percent.';

  @override
  String get planProviderTooLong =>
      'Keep the company and number under 100 characters.';

  @override
  String get planNeedPremium => 'Enter the premium.';

  @override
  String get planNeedInstallmentAmount =>
      'Enter the amount of each installment.';

  @override
  String get planNeedDeposited => 'Enter the amount deposited.';

  @override
  String get planTermMonthsOrYears => 'It runs for months or years.';

  @override
  String get planAmountNotNegative => 'The amount cannot be negative.';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name matures on $date. To take the money out before then, close it early.';
  }

  @override
  String get planNoLongerExists => 'That plan no longer exists.';

  @override
  String get planReminderDaysRange =>
      'Reminders can be 0 (off) to 30 days before.';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name still holds money. Close it first, which moves the money back to $account.';
  }

  @override
  String get planItsAccount => 'its account';

  @override
  String planAlreadyEnded(String name) {
    return '$name has already ended.';
  }

  @override
  String get investNeedName => 'Give the investment a name.';

  @override
  String get investNameTooLong => 'Keep the name under 100 characters.';

  @override
  String get investSymbolTooLong => 'Keep the symbol under 20 characters.';

  @override
  String get investPriceNotNegative => 'A price cannot be negative.';

  @override
  String investAlreadyTracked(String name) {
    return '$name is already tracked.';
  }

  @override
  String get investNeedPaid => 'Enter what was paid.';

  @override
  String get investUnitsBoughtPositive =>
      'Units bought must be more than zero.';

  @override
  String get investPayFromOther => 'Pay for it from another account.';

  @override
  String get investNeedSaleAmount => 'Enter what the sale brought in.';

  @override
  String get investUnitsSoldPositive => 'Units sold must be more than zero.';

  @override
  String get investSellIntoOther => 'Sell into another account.';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'Only $units units of $name are held.';
  }

  @override
  String get investNeedDividend => 'Enter the dividend received.';

  @override
  String get investReceiveIntoOrdinary =>
      'Receive it into an ordinary account.';

  @override
  String get investPricePositive => 'A price must be more than zero.';

  @override
  String get investUnitsPositive => 'Units must be more than zero.';

  @override
  String get investNotATrade => 'That is not a trade of an investment.';

  @override
  String investStillHoldsUnits(String name) {
    return '$name still holds units. Sell them first.';
  }

  @override
  String get investNoLongerExists => 'That investment no longer exists.';

  @override
  String get networthNeedAssetName => 'Give the asset a name.';

  @override
  String get networthValueNotNegative => 'A value cannot be negative.';

  @override
  String get networthNeedPaidFor => 'Enter what was paid for it.';

  @override
  String get networthPayFromOrdinary => 'Pay for it from an ordinary account.';

  @override
  String get networthNeedWorth => 'Enter what it is worth.';

  @override
  String get networthNeedSoldFor => 'Enter what it was sold for.';

  @override
  String get networthReceiveIntoOrdinary =>
      'Receive the money into an ordinary account.';

  @override
  String networthStillWorth(String name) {
    return '$name is still worth something. Sell it, or set its value to zero, first.';
  }

  @override
  String get networthAssetGone => 'That asset is no longer tracked.';

  @override
  String get zakatNeedAmountPaid => 'Enter the amount paid.';

  @override
  String get zakatPayFromOrdinary => 'Pay it from an ordinary account.';

  @override
  String get zakatReminderTitleToday => 'Your zakat is due today';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakat due in $count days',
      one: 'Zakat due in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'Your zakat year completes today. Tap to see what is due.';

  @override
  String zakatReminderBodyOn(String date) {
    return 'Your zakat year completes on $date. Tap to see what is due.';
  }

  @override
  String get budgetCheckFailed => 'Failed to check budgets';

  @override
  String get budgetLoadFailed => 'Failed to load budgets';

  @override
  String get budgetAddFailed => 'Failed to add budget';

  @override
  String get budgetNotFound => 'Budget not found';

  @override
  String get budgetUpdateFailed => 'Failed to update budget';

  @override
  String get budgetDeleteFailed => 'Failed to delete budget';

  @override
  String get budgetEdit => 'Edit budget';

  @override
  String get budgetNeedName => 'Give the budget a name';

  @override
  String get budgetEnterAmount => 'Enter an amount';

  @override
  String get budgetAmountMoreThanZero => 'The amount must be more than zero';

  @override
  String get budgetTrackingEarnings => 'Tracking earnings';

  @override
  String get budgetTrackingSpending => 'Tracking spending';

  @override
  String get budgetRepeats => 'Repeats';

  @override
  String get budgetTooBig => 'Too big';

  @override
  String get budgetStarts => 'Starts';

  @override
  String get budgetEnds => 'Ends';

  @override
  String get budgetStopsRepeating => 'Stops repeating';

  @override
  String get budgetNever => 'Never';

  @override
  String get budgetCategoriesAll => 'Categories: all of them';

  @override
  String budgetCategoriesSelected(int count) {
    return 'Categories: $count selected';
  }

  @override
  String get budgetNoIncomeCategories => 'No income categories yet.';

  @override
  String get budgetNoExpenseCategories => 'No expense categories yet.';

  @override
  String get budgetCategoriesHint =>
      'Leave empty to watch every category. Anything filed inside a chosen category counts toward it too.';

  @override
  String get budgetAccountsAll => 'Accounts: all of them';

  @override
  String budgetAccountsSelected(int count) {
    return 'Accounts: $count selected';
  }

  @override
  String get budgetRolloverHint =>
      'Anything unspent is added to the next period. Going over does not carry a debt forward.';

  @override
  String get budgetPeriodDaily => 'Daily';

  @override
  String get budgetPeriodFortnightly => 'Fortnightly';

  @override
  String get budgetPeriodOneOff => 'One-off';

  @override
  String get budgetUnitDays => 'days';

  @override
  String get budgetUnitWeeks => 'weeks';

  @override
  String get budgetUnitFortnights => 'fortnights';

  @override
  String get budgetUnitMonths => 'months';

  @override
  String get budgetUnitYears => 'years';

  @override
  String get budgetOneOffNeedsEnd => 'A one-off budget needs an end date.';

  @override
  String get budgetEndAfterStart =>
      'The end date has to come after the start date.';

  @override
  String get budgetSaveFailed => 'Could not save the budget.';

  @override
  String get budgetThisPeriod => 'This period';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count periods ago',
      one: '1 period ago',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'of $limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'of $limit including $carried carried over';
  }

  @override
  String get budgetUncategorised => 'Uncategorised';

  @override
  String budgetOverTheLimit(String amount) {
    return '$amount over the limit.';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left left, about $daily a day.';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left left.';
  }

  @override
  String budgetAveraging(String amount) {
    return 'Averaging $amount a period.';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'Heading for $amount over';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'At this rate, and counting $scheduled already scheduled before the period ends.';
  }

  @override
  String get budgetForecastPlain => 'At this rate, by the end of the period.';

  @override
  String get budgetCapsExplain =>
      'A budget says whether the period is overspent. A cap says where: a food budget on track overall can still be mostly takeaway.';

  @override
  String get budgetPercentOfBudget => 'Percent of budget';

  @override
  String get budgetArchivedTitle => 'Archived budgets';

  @override
  String get budgetShowActive => 'Show active';

  @override
  String get budgetShowArchived => 'Show archived';

  @override
  String get budgetUnpin => 'Unpin';

  @override
  String get budgetPinToTop => 'Pin to top';

  @override
  String get budgetStartCounting => 'Start counting it again';

  @override
  String get budgetStopCounting => 'Keep its history, stop counting it';

  @override
  String get budgetDeleteBody =>
      'The budget goes, your transactions stay. Nothing you have recorded is removed.';

  @override
  String get budgetNothingArchived => 'Nothing archived';

  @override
  String get budgetNoneYet => 'No budgets yet';

  @override
  String get budgetArchivedEmptyHint => 'Budgets you archive are kept here.';

  @override
  String get budgetEmptyHint =>
      'Set a limit for a category and see how the month is going.';

  @override
  String dashLoadFailed(String error) {
    return 'Failed to load financial data: $error';
  }

  @override
  String get categoryUnknown => 'Unknown';

  @override
  String dashCardAvailable(String amount) {
    return 'Available: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'In credit · Available: $amount';
  }

  @override
  String get dashTypeBank => 'Bank';

  @override
  String get dashTypeCredit => 'Credit';

  @override
  String get dashTypeSubs => 'Subs';

  @override
  String get dashTypeDeposit => 'Deposit';

  @override
  String get dashTypeInvest => 'Invest';

  @override
  String get dashTypeAsset => 'Asset';

  @override
  String get dashAddAccountTile => 'Add\nAccount';

  @override
  String get categoryLoadFailed => 'Failed to load categories';

  @override
  String get categoryAddFailed => 'Failed to add category';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String get categoryUpdateFailed => 'Failed to update category';

  @override
  String get categoryCannotDeleteSystem =>
      'Cannot delete the app\'s own categories';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'Cannot delete a category with transactions; move or delete them first';

  @override
  String get categoryDeleteFailed => 'Failed to delete category';

  @override
  String categorySaveFailed(String error) {
    return 'Failed to save category: $error';
  }

  @override
  String get categoryEditTitle => 'Edit Category';

  @override
  String get categoryNewTitle => 'New Category';

  @override
  String get categoryPartOf => 'Part of';

  @override
  String get categoryNamePlaceholder => 'Category Name';

  @override
  String get categoryUpdate => 'Update Category';

  @override
  String get categoryCreate => 'Create Category';

  @override
  String reportLoadFailed(String error) {
    return 'Failed to load reports: $error';
  }

  @override
  String get goalEdit => 'Edit goal';

  @override
  String get goalNeedName => 'Give the goal a name';

  @override
  String get goalTargetMoreThanZero => 'The target must be more than zero';

  @override
  String get goalNoDeadline => 'No deadline';

  @override
  String get goalTargetDateAfterStart =>
      'The target date has to come after the start date.';

  @override
  String get goalSaveFailed => 'Could not save the goal.';

  @override
  String get goalArchivedTitle => 'Archived goals';

  @override
  String get goalHideFromHome => 'Hide from home';

  @override
  String get goalShowOnHome => 'Show on home';

  @override
  String get goalReached => 'Reached';

  @override
  String goalToGo(String amount) {
    return '$amount to go';
  }

  @override
  String get goalNoneYet => 'No goals yet';

  @override
  String get goalArchivedEmptyHint => 'Goals you archive are kept here.';

  @override
  String get goalEmptyHint =>
      'Name something you are saving for, then link the transactions that go toward it.';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$saved of $target';
  }

  @override
  String goalOfTarget(String target) {
    return 'of $target';
  }

  @override
  String get goalReachedNicelyDone => 'Reached. Nicely done.';

  @override
  String goalStillToGo(String amount) {
    return '$amount still to go.';
  }

  @override
  String goalDailyToArrive(String amount) {
    return '$amount a day to arrive on time.';
  }

  @override
  String get goalNothingLinked =>
      'Nothing linked yet. Pick this goal on a transaction and it will show up here.';

  @override
  String get goalDeleteBody =>
      'The goal goes, your transactions stay. They are simply no longer counted toward it.';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments of $amount',
      one: '1 payment of $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'Finishing around $date.';
  }

  @override
  String goalNotFound(String id) {
    return 'Objective not found: $id';
  }

  @override
  String get goalPaidOff => 'Paid off!';

  @override
  String get goalCompleted => 'Completed!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% complete';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks left',
      one: '1 week left',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months left',
      one: '1 month left',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return '$years years left';
  }

  @override
  String get subRecurringBill => 'Recurring Bill';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every 1 day',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every 1 week',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Every 1 month',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every 1 year',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'Every $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'Failed to load subscriptions: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'Failed to pause subscription: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'Failed to resume subscription: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'Failed to update subscription: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'Failed to cancel subscription: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'Active ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'Paused ($count)';
  }

  @override
  String get subEmptyTitle => 'No subscriptions or bills';

  @override
  String get subEmptyBody =>
      'Add subscription or recurring bill transactions to track them here';

  @override
  String get subRecurringCost => 'Recurring Cost';

  @override
  String subPerYear(String amount) {
    return '$amount / year';
  }

  @override
  String get subActive => 'Active';

  @override
  String subNext(String date) {
    return 'Next $date';
  }

  @override
  String get subResume => 'Resume';

  @override
  String get subPause => 'Pause';

  @override
  String get subCancelBillTitle => 'Cancel Recurring Bill';

  @override
  String get subCancelSubTitle => 'Cancel Subscription';

  @override
  String subCancelConfirm(String name) {
    return 'Are you sure you want to cancel \"$name\"? This will stop all future recurring payments.';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" cancelled';
  }

  @override
  String subSaveError(String error) {
    return 'Error: $error';
  }

  @override
  String get subEditBill => 'Edit Recurring Bill';

  @override
  String get subEditSub => 'Edit Subscription';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'Ends: $date';
  }

  @override
  String get subNoEndDate => 'No end date';
}
