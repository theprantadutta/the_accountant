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
  String filterShowAll(int count) {
    return 'Show all ($count)';
  }

  @override
  String get filterShowLess => 'Show less';

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
  String get addDate => 'Date';

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
  String get summaryWriting => 'Writing your summary…';

  @override
  String get summaryByCategory => 'By category';

  @override
  String get summaryNoSpending => 'No spending recorded this month yet.';

  @override
  String themeTrialUntil(String time) {
    return 'Premium themes unlocked until $time';
  }
}
