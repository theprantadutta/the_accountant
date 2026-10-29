// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class L10nBn extends L10n {
  L10nBn([String locale = 'bn']) : super(locale);

  @override
  String get actionCancel => 'বাতিল';

  @override
  String get actionConfirm => 'নিশ্চিত করুন';

  @override
  String get dateToday => 'আজ';

  @override
  String get dateYesterday => 'গতকাল';

  @override
  String get dateTomorrow => 'আগামীকাল';

  @override
  String get navTransactions => 'লেনদেন';

  @override
  String get settingsRegionalTitle => 'আঞ্চলিক সেটিংস';

  @override
  String get settingsSectionCurrency => 'মুদ্রা';

  @override
  String get settingsSectionDisplayFormat => 'প্রদর্শন বিন্যাস';

  @override
  String get settingsSectionLanguage => 'ভাষা';

  @override
  String get settingsDefaultCurrency => 'ডিফল্ট মুদ্রা';

  @override
  String get settingsExchangeRates => 'বিনিময় হার';

  @override
  String get settingsExchangeRatesSubtitle =>
      'মুদ্রা রূপান্তরের হার পরিচালনা করুন';

  @override
  String get settingsDateFormat => 'তারিখের বিন্যাস';

  @override
  String get settingsNumberFormat => 'সংখ্যার বিন্যাস';

  @override
  String get settingsCurrencySymbol => 'মুদ্রার প্রতীক';

  @override
  String get settingsTimeFormat => 'সময়ের বিন্যাস';

  @override
  String get settingsFirstDayOfWeek => 'সপ্তাহের প্রথম দিন';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsPreview => 'প্রিভিউ';

  @override
  String get previewDate => 'তারিখ';

  @override
  String get previewTime => 'সময়';

  @override
  String get previewAmount => 'পরিমাণ';

  @override
  String get previewWeekStarts => 'এই সপ্তাহ শুরু';

  @override
  String get choiceMatchMyPhone => 'ফোনের সেটিং অনুসরণ করুন';

  @override
  String get symbolBeforeAmount => 'পরিমাণের আগে';

  @override
  String get symbolAfterAmount => 'পরিমাণের পরে';

  @override
  String get time12Hour => '১২-ঘণ্টা (1:30 PM)';

  @override
  String get time24Hour => '২৪-ঘণ্টা (13:30)';

  @override
  String get weekdayMonday => 'সোমবার';

  @override
  String get weekdaySaturday => 'শনিবার';

  @override
  String get weekdaySunday => 'রবিবার';

  @override
  String get selectDateFormat => 'তারিখের বিন্যাস বাছুন';

  @override
  String get selectNumberFormat => 'সংখ্যার বিন্যাস বাছুন';

  @override
  String get selectCurrency => 'মুদ্রা বাছুন';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get languageSystem => 'ফোনের ভাষা অনুসরণ করুন';

  @override
  String get sectionAccount => 'অ্যাকাউন্ট';

  @override
  String get sectionDataManagement => 'ডেটা ব্যবস্থাপনা';

  @override
  String get sectionHelpSupport => 'সহায়তা';

  @override
  String get settingsAppearance => 'চেহারা';

  @override
  String get settingsBackupRestore => 'ব্যাকআপ ও পুনরুদ্ধার';

  @override
  String get settingsBackupRestoreSubtitle =>
      'আপনার রাখা একটি ফাইল, বা Google Drive-এ স্বয়ংক্রিয় কপি';

  @override
  String get settingsImportStatement => 'স্টেটমেন্ট আমদানি করুন';

  @override
  String get settingsImportStatementSubtitle =>
      'ব্যাংকের CSV আনুন — একবার মিলিয়ে দিন, মনে রাখা হবে';

  @override
  String get settingsExportData => 'ডেটা রপ্তানি';

  @override
  String get settingsRecentlyDeleted => 'সম্প্রতি মুছে ফেলা';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'গত ত্রিশ দিনে সরানো কিছু ফিরিয়ে আনুন';

  @override
  String get themePremiumHeading => 'প্রিমিয়াম থিম';

  @override
  String get actionRetry => 'আবার চেষ্টা করুন';

  @override
  String get dashCreditDebt => 'ধার ও দেনা';

  @override
  String get dashSubscriptions => 'সাবস্ক্রিপশন';

  @override
  String get moneyIncome => 'আয়';

  @override
  String get dashExpenses => 'ব্যয়';

  @override
  String get dashSpendingOverview => 'খরচের সারসংক্ষেপ';

  @override
  String get dashBudgetProgress => 'বাজেটের অগ্রগতি';

  @override
  String get actionDelete => 'মুছুন';

  @override
  String txDeleteManyTitle(int count) {
    return '$countটি লেনদেন মুছবেন?';
  }

  @override
  String get txDeleteManyBody =>
      'ব্যালেন্স আবার হিসাব করা হবে। এর মধ্যে কোনো স্থানান্তর থাকলে তার অন্য অংশটিও সঙ্গে যাবে।';

  @override
  String get txMoveToAccount => 'অ্যাকাউন্টে সরান';

  @override
  String get txDeleted => 'লেনদেন মুছে ফেলা হয়েছে';

  @override
  String txDeleteFailed(String error) {
    return 'লেনদেনটি মোছা যায়নি: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$countটি নির্বাচিত';
  }

  @override
  String get txActions => 'কাজ';

  @override
  String get txChangeCategory => 'ক্যাটাগরি বদলান';

  @override
  String get txChangeDate => 'তারিখ বদলান';

  @override
  String get txMarkAsPaid => 'পরিশোধিত হিসেবে চিহ্নিত করুন';

  @override
  String get txMarkAsCorrection => 'ব্যালেন্স সংশোধন হিসেবে চিহ্নিত করুন';

  @override
  String get txMarkAsCorrectionTitle => 'এটি আয় বা খরচ নয়?';

  @override
  String get txMarkAsCorrectionBody =>
      'যে টাকা আয়ও নয়, খরচও নয় — যেমন কার্ডের সীমা বাড়া — তার জন্য এটি ব্যবহার করুন। ব্যালেন্স একই থাকে; শুধু এটি আর আয় বা খরচ হিসেবে গোনা হয় না।';

  @override
  String get txMarkedAsCorrection => 'এখন এটি একটি ব্যালেন্স সংশোধন।';

  @override
  String get txMarkAsCorrectionFailed => 'এটিকে সংশোধন করা যায় না।';

  @override
  String get txDuplicate => 'নকল তৈরি করুন';

  @override
  String get filterTitle => 'ফিল্টার';

  @override
  String get filterDirection => 'দিক';

  @override
  String get filterState => 'অবস্থা';

  @override
  String get filterKind => 'ধরন';

  @override
  String get filterTransfers => 'ট্রান্সফার';

  @override
  String get filterAccounts => 'অ্যাকাউন্ট';

  @override
  String get filterCategories => 'ক্যাটাগরি';

  @override
  String get filterDates => 'তারিখ';

  @override
  String get filterBudget => 'বাজেট';

  @override
  String get filterGoal => 'লক্ষ্য';

  @override
  String get filterNone => 'কোনোটি নয়';

  @override
  String get filterThisMonth => 'এই মাস';

  @override
  String get filterLastMonth => 'গত মাস';

  @override
  String get filterLast3Months => 'গত ৩ মাস';

  @override
  String get filterThisYear => 'এই বছর';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন দেখুন',
      one: '১টি লেনদেন দেখুন',
      zero: 'কোনো লেনদেন মেলেনি',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'মুছুন';

  @override
  String get filterNoMatches => 'কিছু মেলেনি';

  @override
  String get filterAny => 'যেকোনো';

  @override
  String get filterSpent => 'খরচ';

  @override
  String get filterEarned => 'আয়';

  @override
  String get filterHidden => 'লুকানো';

  @override
  String get filterIncluded => 'অন্তর্ভুক্ত';

  @override
  String get filterOnly => 'কেবল';

  @override
  String get filterFrom => 'থেকে';

  @override
  String get filterTo => 'পর্যন্ত';

  @override
  String get actionApply => 'প্রয়োগ করুন';

  @override
  String get filterPaid => 'পরিশোধিত';

  @override
  String get filterNotYet => 'এখনও নয়';

  @override
  String get filterSkipped => 'বাদ দেওয়া';

  @override
  String get filterAmount => 'পরিমাণ';

  @override
  String get actionEdit => 'সম্পাদনা';

  @override
  String get entityBudget => 'বাজেট';

  @override
  String get budgetGone => 'এই বাজেটটি আর নেই।';

  @override
  String get budgetEarlier => 'আগের';

  @override
  String get budgetLater => 'পরের';

  @override
  String get budgetWhereItWent => 'কোথায় গেল';

  @override
  String get budgetRecentPeriods => 'সাম্প্রতিক সময়কাল';

  @override
  String get budgetCaps => 'সীমা';

  @override
  String get actionAdd => 'যোগ করুন';

  @override
  String get budgetNoCategoriesToCap =>
      'এই বাজেটে সীমা দেওয়ার মতো কোনো ক্যাটাগরি এখনও নেই।';

  @override
  String get budgetCapACategory => 'একটি ক্যাটাগরিতে সীমা দিন';

  @override
  String get entityCategory => 'ক্যাটাগরি';

  @override
  String get budgetAsShare => 'বাজেটের অংশ হিসেবে';

  @override
  String get budgetAsShareHint => 'বাজেট বদলালে এটিও সঙ্গে বদলাবে';

  @override
  String get actionSet => 'নির্ধারণ করুন';

  @override
  String get budgetAcrossPeriod => 'পুরো সময়কাল জুড়ে';

  @override
  String get budgetPreviousPeriod => 'আগের সময়কাল';

  @override
  String get budgetEvenPace => 'সমান গতি';

  @override
  String get budgetNew => 'নতুন বাজেট';

  @override
  String get budgetCreate => 'একটি বাজেট তৈরি করুন';

  @override
  String budgetDeleteTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get entityAccount => 'অ্যাকাউন্ট';

  @override
  String get entityTransaction => 'লেনদেন';

  @override
  String get walletGone => 'এই অ্যাকাউন্টটি আর নেই।';

  @override
  String get walletCorrectBalance => 'ব্যালেন্স সংশোধন করুন';

  @override
  String get walletCorrectBalanceSubtitle =>
      'প্রকৃত অঙ্কের সঙ্গে পার্থক্যটি লিখে রাখুন';

  @override
  String get walletMergeInto => 'অন্য অ্যাকাউন্টে মেলান';

  @override
  String get walletInThisMonth => 'এই মাসে এসেছে';

  @override
  String get walletOutThisMonth => 'এই মাসে গেছে';

  @override
  String get walletRecentActivity => 'সাম্প্রতিক কার্যকলাপ';

  @override
  String get walletNoOtherAccount => 'মেলানোর মতো অন্য কোনো অ্যাকাউন্ট নেই।';

  @override
  String get walletMergeIntoTitle => 'কোথায় মেলাবেন';

  @override
  String get walletMergeAction => 'মেলান';

  @override
  String walletMerged(int count, String target) {
    return '$countটি $target-এ সরানো হয়েছে।';
  }

  @override
  String walletMergedWithTransfersRemoved(
    int count,
    String target,
    int removed,
  ) {
    return '$countটি $target-এ সরানো হয়েছে। দুই অ্যাকাউন্টের মধ্যেকার $removedটি ট্রান্সফার সরিয়ে ফেলা হয়েছে, কারণ সেগুলোর আর দুটি প্রান্ত ছিল না।';
  }

  @override
  String get walletRealBalance => 'প্রকৃত ব্যালেন্স';

  @override
  String get walletCorrectAction => 'সংশোধন করুন';

  @override
  String get txGone => 'এই লেনদেনটি আর নেই।';

  @override
  String get txKind => 'ধরন';

  @override
  String get txState => 'অবস্থা';

  @override
  String get txWasDue => 'নির্ধারিত ছিল';

  @override
  String get txNotes => 'নোট';

  @override
  String get txDeleteOneTitle => 'এই লেনদেনটি মুছবেন?';

  @override
  String get rulesTitle => 'নামকরণের নিয়ম';

  @override
  String get rulesAdd => 'নিয়ম যোগ করুন';

  @override
  String rulesRemoved(String title) {
    return '$title-এর নিয়মটি সরানো হয়েছে';
  }

  @override
  String get rulesWhenTitleSays => 'শিরোনামে যা থাকলে';

  @override
  String get rulesMatchExactly => 'হুবহু মিলতে হবে';

  @override
  String get rulesChooseCategory => 'ক্যাটাগরি বাছুন';

  @override
  String get actionSave => 'সংরক্ষণ';

  @override
  String get goalNew => 'নতুন লক্ষ্য';

  @override
  String get goalLoadFailed => 'আপনার লক্ষ্যগুলি আনা যায়নি।';

  @override
  String get goalCreate => 'একটি লক্ষ্য তৈরি করুন';

  @override
  String get trashTitle => 'সম্প্রতি মুছে ফেলা';

  @override
  String get trashRestore => 'ফিরিয়ে আনুন';

  @override
  String get trashRestored => 'ফিরিয়ে আনা হয়েছে।';

  @override
  String get payTitle => 'পেমেন্ট পদ্ধতি';

  @override
  String get payDefault => 'ডিফল্ট';

  @override
  String get payAddOne => 'একটি যোগ করুন';

  @override
  String payDeleteTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get payName => 'নাম';

  @override
  String get payNameHint => 'প্রতিদিনের ডেবিট';

  @override
  String get payKind => 'ধরন';

  @override
  String get payBankOrIssuer => 'ব্যাংক বা ইস্যুকারী';

  @override
  String get payLastFour => 'শেষ চার অঙ্ক';

  @override
  String get payUseByDefault => 'ডিফল্ট হিসেবে ব্যবহার করুন';

  @override
  String get backupChecking => 'দেখা হচ্ছে…';

  @override
  String get backupLoading => 'আনা হচ্ছে…';

  @override
  String get backupSaveACopy => 'একটি কপি রাখুন';

  @override
  String get backupAutomaticBackups => 'স্বয়ংক্রিয় ব্যাকআপ';

  @override
  String get backupHowManyBackupsToKeep => 'কতগুলি ব্যাকআপ রাখা হবে';

  @override
  String get backupSaveABackupFile => 'ব্যাকআপ ফাইল সংরক্ষণ করুন';

  @override
  String get backupShareItToFilesEmail =>
      'ফাইলস, ইমেল বা আপনার পছন্দমতো জায়গায় পাঠান';

  @override
  String get backupRestoreFromAFile => 'ফাইল থেকে ফিরিয়ে আনুন';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'এই ডিভাইসে এখন যা আছে সবই বদলে যাবে';

  @override
  String get backupRestoreThisBackup => 'এই ব্যাকআপটি ফিরিয়ে আনবেন?';

  @override
  String get backupEraseRestore => 'মুছে ফিরিয়ে আনুন';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive পাওয়া যাচ্ছে না';

  @override
  String get backupConnectGoogleDrive => 'Google Drive যুক্ত করুন';

  @override
  String get backupBackUpNow => 'এখনই ব্যাকআপ নিন';

  @override
  String get backupKeep => 'রাখুন';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'শেষ স্বয়ংক্রিয় ব্যাকআপটি চলেনি';

  @override
  String get backupDisconnectGoogleDrive => 'Google Drive সংযোগ বিচ্ছিন্ন করুন';

  @override
  String get backupDisconnectGoogleDrive2 =>
      'Google Drive সংযোগ বিচ্ছিন্ন করবেন?';

  @override
  String get backupDisconnect => 'বিচ্ছিন্ন করুন';

  @override
  String get backupDeleteThisBackup => 'এই ব্যাকআপটি মুছবেন?';

  @override
  String get importChooseACsvFile => 'একটি CSV ফাইল বাছুন';

  @override
  String get importRememberTheseSettingsForThis =>
      'এই ব্যাংকের জন্য এই সেটিংস মনে রাখুন';

  @override
  String get importChange => 'বদলান';

  @override
  String get importAuto => 'স্বয়ংক্রিয়';

  @override
  String get importDone => 'হয়ে গেছে';

  @override
  String get importRememberThisBank => 'এই ব্যাংকটি মনে রাখুন';

  @override
  String get importForget => 'ভুলে যান';

  @override
  String get importImport => 'আমদানি করুন';

  @override
  String get settingsAbout => 'সম্পর্কে';

  @override
  String get settingsPrivacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get settingsTermsOfService => 'ব্যবহারের শর্তাবলী';

  @override
  String get settingsRefundPolicy => 'ফেরত নীতি';

  @override
  String get settingsOpenSourceLicenses => 'ওপেন সোর্স লাইসেন্স';

  @override
  String get settingsMeetTheDeveloper => 'ডেভেলপারের সঙ্গে পরিচিত হন';

  @override
  String get settingsContactSupport => 'সহায়তায় যোগাযোগ করুন';

  @override
  String get settingsSubject => 'বিষয়';

  @override
  String get settingsMessage => 'বার্তা';

  @override
  String get settingsSendMessage => 'বার্তা পাঠান';

  @override
  String get settingsUseApiRate => 'API হার ব্যবহার করুন';

  @override
  String get settingsRefreshRates => 'হার হালনাগাদ করুন';

  @override
  String get settingsSearchCurrencies => 'মুদ্রা খুঁজুন...';

  @override
  String get settingsCustomRate => 'নিজের হার';

  @override
  String get settingsSetCustomRate => 'নিজের হার নির্ধারণ করুন';

  @override
  String get settingsNotNow => 'এখন নয়';

  @override
  String get settingsGoPremium => 'প্রিমিয়াম নিন';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Excel ও Google Sheets-এর জন্য স্প্রেডশিট বিন্যাস';

  @override
  String get settingsPdfReport => 'PDF রিপোর্ট';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'বিভাজনসহ সাজানো সারসংক্ষেপ';

  @override
  String get settingsAllIncomeAndExpenseRecords => 'সমস্ত আয় ও ব্যয়ের হিসাব';

  @override
  String get settingsCategories => 'ক্যাটাগরি';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'ক্যাটাগরিভিত্তিক বিভাজন ও মোট';

  @override
  String get settingsWallets => 'ওয়ালেট';

  @override
  String get settingsWalletBalancesAndHistory => 'ওয়ালেটের ব্যালেন্স ও ইতিহাস';

  @override
  String get settingsHelpFaq => 'সহায়তা ও সাধারণ প্রশ্ন';

  @override
  String get settingsNotifications => 'বিজ্ঞপ্তি';

  @override
  String get settingsLargeTransactionThreshold => 'বড় লেনদেনের সীমা';

  @override
  String get settingsRemindMeBeforeDueDate =>
      'নির্ধারিত তারিখের আগে মনে করিয়ে দিন';

  @override
  String get settingsDailyReminders => 'দৈনিক অনুস্মারক';

  @override
  String get settingsDailyReminders2 => 'দৈনিক অনুস্মারক';

  @override
  String get settingsGetRemindedToTrackYour =>
      'খরচ লিখে রাখার কথা মনে করিয়ে দেওয়া হবে';

  @override
  String get settingsBudgetAlerts => 'বাজেট সতর্কতা';

  @override
  String get settingsBudgetAlerts2 => 'বাজেট সতর্কতা';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'বাজেটের সীমার কাছে গেলে জানান';

  @override
  String get settingsWarningThreshold => 'সতর্কতার সীমা';

  @override
  String get settingsTransactionAlerts => 'লেনদেন সতর্কতা';

  @override
  String get settingsLargeTransactionAlerts => 'বড় লেনদেনের সতর্কতা';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'সীমার বেশি লেনদেনে জানান';

  @override
  String get settingsRecurringTransactionReminders =>
      'নিয়মিত লেনদেনের অনুস্মারক';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'আসন্ন নিয়মিত পরিশোধের কথা মনে করিয়ে দিন';

  @override
  String get settingsOtherNotifications => 'অন্যান্য বিজ্ঞপ্তি';

  @override
  String get settingsSubscriptionExpiryAlerts =>
      'সাবস্ক্রিপশন শেষ হওয়ার সতর্কতা';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'আপনার প্রিমিয়াম শেষ হওয়ার আগে জানানো হবে';

  @override
  String get settingsPromotionalNotifications => 'প্রচারমূলক বিজ্ঞপ্তি';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'অফার ও নতুন সুবিধার খবর পান';

  @override
  String get settingsTurnOnDailyReminders => 'দৈনিক অনুস্মারক চালু করবেন?';

  @override
  String get settingsEnterAmount => 'পরিমাণ লিখুন';

  @override
  String get settingsReminderTime => 'অনুস্মারকের সময়';

  @override
  String get settingsPrivacySecurity => 'গোপনীয়তা ও নিরাপত্তা';

  @override
  String get settingsSecurity => 'নিরাপত্তা';

  @override
  String get settingsBiometricLock => 'বায়োমেট্রিক লক';

  @override
  String get settingsUseFingerprintOrFaceTo => 'আঙুলের ছাপ বা মুখ দিয়ে খুলুন';

  @override
  String get settingsAutoLock => 'স্বয়ংক্রিয় লক';

  @override
  String get settingsDataPrivacy => 'ডেটার গোপনীয়তা';

  @override
  String get settingsClearCache => 'ক্যাশ পরিষ্কার করুন';

  @override
  String get settingsClearCachedDataAndForce =>
      'ক্যাশ করা ডেটা মুছে আবার সিঙ্ক করান';

  @override
  String get settingsClearAllData => 'সমস্ত ডেটা মুছুন';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'সমস্ত লেনদেন, বাজেট ও সেটিংস মুছে ফেলুন';

  @override
  String get settingsDangerZone => 'বিপজ্জনক অংশ';

  @override
  String get settingsDeleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'আপনার অ্যাকাউন্ট ও সমস্ত ডেটা চিরতরে মুছে ফেলুন';

  @override
  String get settingsAutoLockTimeout => 'স্বয়ংক্রিয় লকের সময়';

  @override
  String get settingsDeleteEverything => 'সবকিছু মুছুন';

  @override
  String get settingsAreYouAbsolutelySure => 'আপনি কি একেবারে নিশ্চিত?';

  @override
  String get settingsYesDeleteAll => 'হ্যাঁ, সব মুছুন';

  @override
  String get settingsContinue => 'চালিয়ে যান';

  @override
  String get settingsEditProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get settingsDisplayName => 'প্রদর্শিত নাম';

  @override
  String get settingsEmailAddress => 'ইমেল ঠিকানা';

  @override
  String get settingsUnsavedChanges => 'সংরক্ষণ করা হয়নি';

  @override
  String get settingsStay => 'থাকুন';

  @override
  String get settingsLeave => 'চলে যান';

  @override
  String get settingsSearchByCodeOrName => 'কোড বা নাম দিয়ে খুঁজুন...';

  @override
  String get settingsSearchSettings => 'সেটিংস খুঁজুন...';

  @override
  String get settingsSubscription => 'সাবস্ক্রিপশন';

  @override
  String get settingsSignOut => 'সাইন আউট';

  @override
  String get settingsGoals => 'লক্ষ্য';

  @override
  String get settingsCardsInNetWorth => 'নেট সম্পদে ক্রেডিট কার্ড ধরুন';

  @override
  String get settingsCardsInNetWorthSub =>
      'বন্ধ থাকলে: শুধু আপনার টাকা ধরা হয়, কার্ডের ব্যালেন্স নয়।';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'কোনো কিছুর জন্য জমান এবং কতদূর এগোলেন দেখুন';

  @override
  String get settingsBudgets => 'বাজেট';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'সীমা দিন এবং সময়কালটি কেমন যাচ্ছে দেখুন';

  @override
  String get settingsUpcomingAndOverdue => 'আসন্ন ও বকেয়া';

  @override
  String get settingsWhatIsDueAndWhat => 'কী বাকি আছে, আর কী বাদ পড়েছে';

  @override
  String get settingsAccounts => 'অ্যাকাউন্ট';

  @override
  String get settingsAddReorderAndEditYour =>
      'আপনার অ্যাকাউন্ট যোগ করুন, সাজান ও সম্পাদনা করুন';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'যে কার্ড ও অ্যাকাউন্ট দিয়ে আপনি পরিশোধ করেন';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'নাম দেখে কোন খাতে যাবে তা ঠিক করুন';

  @override
  String get settingsNotificationSettings => 'বিজ্ঞপ্তির সেটিংস';

  @override
  String get settingsCloudSync => 'ক্লাউড সিঙ্ক';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'সব ডিভাইসে আপনার ডেটা মিলিয়ে রাখুন';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV বিনামূল্যে · PDF রিপোর্ট প্রিমিয়াম';

  @override
  String get settingsQuestionsComplaintsOrFeedback => 'প্রশ্ন, অভিযোগ বা মতামত';

  @override
  String get settingsRateTheApp => 'অ্যাপটিকে রেটিং দিন';

  @override
  String get settingsShareWithFriends => 'বন্ধুদের সঙ্গে ভাগ করুন';

  @override
  String get settingsReplayAppTour => 'অ্যাপ পরিচিতি আবার দেখুন';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'সুবিধাগুলির পরিচিতি আবার দেখুন';

  @override
  String get settingsAboutTheAccountant => 'The Accountant সম্পর্কে';

  @override
  String get settingsVersionLicensesAndMore => 'সংস্করণ, লাইসেন্স ও আরও';

  @override
  String get settingsTestCrash => 'পরীক্ষামূলক ক্র্যাশ';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Crashlytics-এর জন্য একটি পরীক্ষামূলক ত্রুটি ঘটান';

  @override
  String get settingsDeveloper => 'ডেভেলপার';

  @override
  String get settingsRestoreFromCloud => 'ক্লাউড থেকে ফিরিয়ে আনবেন?';

  @override
  String get settingsSyncing => 'সিঙ্ক হচ্ছে...';

  @override
  String get settingsSynced => 'সিঙ্ক হয়েছে';

  @override
  String get settingsSyncError => 'সিঙ্কে ত্রুটি';

  @override
  String get syncBackgroundFailed =>
      'সিঙ্ক করা যায়নি। আপনার পরিবর্তনগুলো এই ডিভাইসে নিরাপদ আছে, পরে সিঙ্ক হবে।';

  @override
  String get settingsOffline => 'অফলাইন';

  @override
  String get settingsReady => 'প্রস্তুত';

  @override
  String get settingsYesUseThis => 'হ্যাঁ, এটিই ব্যবহার করুন';

  @override
  String get settingsKeepThemSeparate => 'আলাদা রাখবেন?';

  @override
  String get settingsCurrentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get settingsNewPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get settingsConfirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get walletEGPersonalSavingsBusiness =>
      'যেমন: ব্যক্তিগত, সঞ্চয়, ব্যবসা';

  @override
  String get walletEnterCreditLimit => 'ক্রেডিট সীমা লিখুন';

  @override
  String get walletSelectBillingDay => 'বিলের দিন বাছুন';

  @override
  String get walletCreateAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get walletWalletCreatedSuccessfully => 'ওয়ালেট তৈরি হয়েছে';

  @override
  String get walletAccountUpdatedSuccessfully => 'অ্যাকাউন্ট হালনাগাদ হয়েছে';

  @override
  String get walletEditAccount => 'অ্যাকাউন্ট সম্পাদনা';

  @override
  String get walletSetAsDefault => 'ডিফল্ট হিসেবে রাখুন';

  @override
  String get walletUseDecimals => 'দশমিক ব্যবহার করুন';

  @override
  String get walletEnterWalletName => 'ওয়ালেটের নাম লিখুন';

  @override
  String get walletCurrency => 'মুদ্রা';

  @override
  String get walletIcon => 'আইকন';

  @override
  String get walletColor => 'রঙ';

  @override
  String get walletWalletName => 'ওয়ালেটের নাম';

  @override
  String get walletInitialBalance => 'শুরুর ব্যালেন্স';

  @override
  String get txAddATransferFee => 'স্থানান্তরের ফি যোগ করুন';

  @override
  String get txRemove => 'সরান';

  @override
  String get txPaymentMethod => 'পেমেন্ট পদ্ধতি';

  @override
  String get txObjective => 'লক্ষ্য';

  @override
  String get txTitle => 'শিরোনাম';

  @override
  String get txTesco => 'মীনা বাজার';

  @override
  String get txAll => 'সব';

  @override
  String get txSkip => 'বাদ দিন';

  @override
  String get txMarkAsPaid2 => 'পরিশোধিত হিসেবে চিহ্নিত করুন';

  @override
  String get txConfirmPayment => 'পেমেন্ট নিশ্চিত করুন';

  @override
  String get txAmountCharged => 'চার্জ হওয়া পরিমাণ';

  @override
  String get txUndo => 'ফেরান';

  @override
  String get txNoLoan => 'কোনো ঋণ নয়';

  @override
  String get txLentMoney => 'ধার দেওয়া টাকা';

  @override
  String get txBorrowedMoney => 'ধার নেওয়া টাকা';

  @override
  String get goalShowOnTheHomeScreen => 'হোম স্ক্রিনে দেখান';

  @override
  String get goalWhatAreYouSavingFor => 'কীসের জন্য জমাচ্ছেন?';

  @override
  String get goalNewLaptop => 'নতুন ল্যাপটপ';

  @override
  String get goalTarget => 'লক্ষ্যমাত্রা';

  @override
  String get goalColour => 'রঙ';

  @override
  String get goalClear => 'মুছুন';

  @override
  String get goalGoal => 'লক্ষ্য';

  @override
  String get goalThisGoalNoLongerExists => 'এই লক্ষ্যটি আর নেই।';

  @override
  String get goalAddToGoal => 'লক্ষ্যে যোগ করুন';

  @override
  String get goalUnlink => 'সংযোগ ছাড়ান';

  @override
  String get reportUpgrade => 'আপগ্রেড করুন';

  @override
  String get budgetSpending => 'খরচ';

  @override
  String get budgetEarnings => 'আয়';

  @override
  String get budgetEvery => 'প্রতি';

  @override
  String get budgetCarryOverWhatIsLeft => 'যা বাকি থাকে পরের বার নিয়ে যান';

  @override
  String get budgetGroceries => 'বাজার-সদাই';

  @override
  String get authLinkYourAccount => 'আপনার অ্যাকাউন্ট যুক্ত করুন';

  @override
  String get authPassword => 'পাসওয়ার্ড';

  @override
  String get authLinkAccount => 'অ্যাকাউন্ট যুক্ত করুন';

  @override
  String get authEmailAddress => 'ইমেল ঠিকানা';

  @override
  String get authSendResetCode => 'রিসেট কোড পাঠান';

  @override
  String get authResetCode => 'রিসেট কোড';

  @override
  String get authResetPassword => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get authWelcomeBack => 'আবার স্বাগতম';

  @override
  String get authSignInToContinueYour =>
      'আপনার আর্থিক যাত্রা চালিয়ে যেতে সাইন ইন করুন';

  @override
  String get authSignIn => 'সাইন ইন';

  @override
  String get authJoinUsToStartYour => 'আপনার আর্থিক যাত্রা শুরু করতে যোগ দিন';

  @override
  String get authFullName => 'পুরো নাম';

  @override
  String get premiumPremium => 'প্রিমিয়াম';

  @override
  String get premiumMonthly => 'মাসিক';

  @override
  String get premiumYearly => 'বার্ষিক';

  @override
  String get premiumLifetime => 'আজীবন';

  @override
  String get premiumNotNow => 'এখন নয়';

  @override
  String get aiRename => 'নাম বদলান';

  @override
  String get aiRenameChat => 'চ্যাটের নাম বদলান';

  @override
  String get aiDeleteChat => 'চ্যাট মুছবেন?';

  @override
  String get aiChatName => 'চ্যাটের নাম';

  @override
  String get aiScanReceipt => 'রসিদ স্ক্যান করুন';

  @override
  String get aiCamera => 'ক্যামেরা';

  @override
  String get aiGallery => 'গ্যালারি';

  @override
  String get aiMerchantTitle => 'দোকান / শিরোনাম';

  @override
  String get aiSaveAsTransaction => 'লেনদেন হিসেবে সংরক্ষণ করুন';

  @override
  String get onboardBrowseThemes => 'থিম দেখুন';

  @override
  String get onboardBack => 'পেছনে';

  @override
  String get onboardGetStarted => 'শুরু করুন';

  @override
  String get onboardMainAccount => 'প্রধান অ্যাকাউন্ট';

  @override
  String get creditRecordPayment => 'পরিশোধ লিখে রাখুন';

  @override
  String get creditPleaseEnterAValidAmount => 'একটি সঠিক পরিমাণ লিখুন';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'পরিমাণটি বাকি ব্যালেন্সের চেয়ে বেশি';

  @override
  String get creditPaymentAmount => 'পরিশোধের পরিমাণ';

  @override
  String get creditPaidOn => 'পরিশোধের তারিখ';

  @override
  String get creditFullAmount => 'পুরো পরিমাণ';

  @override
  String get subSubscriptionName => 'সাবস্ক্রিপশনের নাম';

  @override
  String get subAskBeforeEachPayment =>
      'প্রতিটি পেমেন্ট রেকর্ড করার আগে জিজ্ঞাসা করুন';

  @override
  String get subAskBeforeEachPaymentHint =>
      'প্রতিটি পেমেন্ট আসন্ন তালিকায় অপেক্ষা করবে, যতক্ষণ না আপনি আসলে কত চার্জ হয়েছে তা নিশ্চিত করেন বা এড়িয়ে যান। যেসব চার্জ বদলায়, যেমন অন্য মুদ্রায় কার্ডে পরিশোধ, সেগুলোর জন্য উপযুক্ত।';

  @override
  String get subChangesApplyFromNext =>
      'নতুন পরিমাণ বা অ্যাকাউন্ট পরবর্তী পেমেন্ট থেকে প্রযোজ্য হবে। আগের পেমেন্টগুলো যেমন ছিল তেমনই থাকবে।';

  @override
  String get catPleaseEnterACategoryName => 'একটি ক্যাটাগরির নাম লিখুন';

  @override
  String get catEnterCategoryName => 'ক্যাটাগরির নাম লিখুন';

  @override
  String get catSearch => 'ক্যাটাগরি খুঁজুন';

  @override
  String get catNoMatch => 'এর সাথে মেলে এমন কোনো ক্যাটাগরি নেই।';

  @override
  String get catUseEmoji => 'ইমোজি ব্যবহার করুন';

  @override
  String get catEmojiHint => 'একটি ইমোজি লিখুন বা বেছে নিন';

  @override
  String get catArchive => 'আর্কাইভ করুন';

  @override
  String get catMergeInto => 'অন্যটির সাথে মেলান…';

  @override
  String catMergeIntoTitle(String name) {
    return '$name কোনটির সাথে মেলাবেন';
  }

  @override
  String get catMergeBuiltIn => 'অ্যাপের নিজস্ব';

  @override
  String get catMergeNoTargets =>
      'মেলানোর মতো একই ধরনের অন্য কোনো ক্যাটাগরি নেই।';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return '$from কে $to এর সাথে মেলাবেন?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return '$from এর সব লেনদেন, বাজেট ও সাব-ক্যাটাগরি $to তে চলে যাবে, আর $from সরিয়ে দেওয়া হবে। এটি আপনার অন্য ডিভাইসেও সিঙ্ক হবে।';
  }

  @override
  String get catMergeAction => 'মেলান';

  @override
  String catMerged(String from, String to) {
    return '$from কে $to এর সাথে মেলানো হয়েছে।';
  }

  @override
  String get catExpenseSection => 'খরচের ক্যাটাগরি';

  @override
  String get catIncomeSection => 'আয়ের ক্যাটাগরি';

  @override
  String get catSectionEmpty => 'এখনো কিছু নেই';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সাব-ক্যাটাগরি',
      one: '১টি সাব-ক্যাটাগরি',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন',
      one: '১টি লেনদেন',
      zero: 'কোনো লেনদেন নেই',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return '$name এর ভেতরে';
  }

  @override
  String get catAddSubcategory => 'সাব-ক্যাটাগরি যোগ করুন';

  @override
  String get catMoveTo => 'অন্য জায়গায় সরান…';

  @override
  String catMoveToTitle(String name) {
    return '$name কোথায় সরাবেন';
  }

  @override
  String get catTopLevel => 'মূল তালিকায়';

  @override
  String get catTopLevelHint => 'কোনো ক্যাটাগরির ভেতরে নয়';

  @override
  String catMovedInto(String name, String parent) {
    return '$name এখন $parent এর ভেতরে।';
  }

  @override
  String catMovedToTop(String name) {
    return '$name এখন মূল তালিকার ক্যাটাগরি।';
  }

  @override
  String get catMoveNoParents => 'এটি রাখার মতো কোনো ক্যাটাগরি নেই।';

  @override
  String get catMoveTransactions => 'লেনদেন সরান…';

  @override
  String catMoveTransactionsTitle(String name) {
    return '$name এর লেনদেন কোথায় সরাবেন';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন $to তে সরাবেন?',
      one: '১টি লেনদেন $to তে সরাবেন?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'শুধু লেনদেনগুলো সরবে। $from থাকবে, এর বাজেট ও সাব-ক্যাটাগরিসহ। এটি আপনার অন্য ডিভাইসেও সিঙ্ক হবে।';
  }

  @override
  String get catMoveAction => 'সরান';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন $to তে সরানো হয়েছে।',
      one: '১টি লেনদেন $to তে সরানো হয়েছে।',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name এ সরানোর মতো কোনো লেনদেন নেই।';
  }

  @override
  String get catNoMoveTargets =>
      'সরানোর মতো একই ধরনের অন্য কোনো ক্যাটাগরি নেই।';

  @override
  String catDeleteTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get catDeleteEmptyBody =>
      'এতে কোনো লেনদেন নেই, তাই আর কিছু বদলাবে না।';

  @override
  String get catDeleteChildrenNote =>
      'এর সাব-ক্যাটাগরিগুলো মূল তালিকায় চলে যাবে।';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এতে $countটি লেনদেন আছে। সেগুলোর কী হবে?',
      one: 'এতে ১টি লেনদেন আছে। সেটির কী হবে?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'অন্য ক্যাটাগরিতে সরান';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'তারপর $name মুছে যাবে। যে বাজেটে এটি ছিল সেগুলোও সরে যাবে।';
  }

  @override
  String get catDeleteThemToo => 'লেনদেনগুলোও মুছে দিন';

  @override
  String get catDeleteThemTooHint =>
      'এগুলো সম্প্রতি মুছে ফেলায় যাবে, ৩০ দিন পর্যন্ত ফিরিয়ে আনতে পারবেন।';

  @override
  String catDeleted(String name) {
    return '$name মুছে ফেলা হয়েছে।';
  }

  @override
  String get catActionFailed => 'এটি করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get catStaysTopLevel =>
      'এই ক্যাটাগরির নিজেরই সাব-ক্যাটাগরি আছে, তাই এটি মূল তালিকায় থাকবে।';

  @override
  String get catUnarchive => 'আর্কাইভ থেকে ফেরান';

  @override
  String get catArchivedSection => 'আর্কাইভ করা';

  @override
  String get catArchivedHint =>
      'ইতিহাসের জন্য রাখা আছে, তবে নতুন লেনদেন যোগ করার সময় দেখানো হবে না।';

  @override
  String get catNothingItsOwnCategory => 'কিছু নয় — এটি নিজেই একটি ক্যাটাগরি';

  @override
  String get notifEnableNotifications => 'বিজ্ঞপ্তি চালু করুন';

  @override
  String get startupContinueWithoutChecking => 'না দেখে চালিয়ে যাবেন?';

  @override
  String get startupContinueOffline => 'অফলাইনে চালিয়ে যান';

  @override
  String get startupViewSubscriptionOptions => 'সাবস্ক্রিপশনের বিকল্প দেখুন';

  @override
  String get sharedWelcomeBack => 'আবার স্বাগতম';

  @override
  String get sharedRestoringYourDataFromThe =>
      'ক্লাউড থেকে আপনার ডেটা ফেরানো হচ্ছে…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return '$source কে $target-এ মেলাবেন?';
  }

  @override
  String get backupNothingHereYet => 'এখানে এখনও কিছু নেই।';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'এই কলামগুলি থাকলে ফাইলে স্বয়ংক্রিয়ভাবে প্রয়োগ হবে';

  @override
  String get importDateFormat => 'তারিখের বিন্যাস';

  @override
  String get importChooseOne => 'একটি বাছুন';

  @override
  String get importDecimalPoint => 'দশমিক চিহ্ন';

  @override
  String get importFlipTheSigns => 'চিহ্ন উল্টে দিন';

  @override
  String get importForExportsThatWriteA =>
      'যে ফাইলে খরচকে ধনাত্মক লেখা হয় তার জন্য';

  @override
  String get importWhereRowsGoWhenThe =>
      'ফাইলে আপনার কোনো অ্যাকাউন্টের নাম না থাকলে সারিগুলি কোথায় যাবে';

  @override
  String get importSkipWhatIsAlreadyHere => 'যা ইতিমধ্যে আছে তা বাদ দিন';

  @override
  String get importCreateCategoriesTheFileNames =>
      'ফাইলে উল্লেখ করা ক্যাটাগরি তৈরি করুন';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'না হলে সারিগুলি ক্যাটাগরি ছাড়াই আসবে';

  @override
  String get importCategoriesInThisFile => 'এই ফাইলের ক্যাটাগরিগুলি';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'ব্যক্তিগত অর্থব্যবস্থাপনার জন্য যত্ন নিয়ে তৈরি';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'তৈরি ও রক্ষণাবেক্ষণে:';

  @override
  String get settingsPrantaDutta => 'প্রান্ত দত্ত';

  @override
  String get settingsClose => 'বন্ধ করুন';

  @override
  String get settingsGetInTouch => 'যোগাযোগ করুন';

  @override
  String get settingsAsAPremiumMemberYour =>
      'প্রিমিয়াম সদস্য হিসেবে আপনার অনুরোধটি অগ্রাধিকার পাবে।';

  @override
  String get settingsWhatToInclude => 'কী কী থাকবে';

  @override
  String get settingsNoCurrenciesFound => 'কোনো মুদ্রা পাওয়া যায়নি';

  @override
  String get settingsExportYourFinancialDataTo =>
      'অন্য অ্যাপে বিশ্লেষণ করতে বা ব্যাকআপ হিসেবে রাখতে আপনার আর্থিক তথ্য রপ্তানি করুন।';

  @override
  String get settingsDateRange => 'তারিখের পরিসর';

  @override
  String get settingsPremium => 'প্রিমিয়াম';

  @override
  String get settingsPdfReports => 'PDF রিপোর্ট';

  @override
  String get settingsGettingStarted => 'শুরু করা';

  @override
  String get settingsStillNeedHelp => 'আরও সাহায্য দরকার?';

  @override
  String get settingsOurSupportTeamIsHere => 'আমাদের সহায়তা দল আপনার পাশে আছে';

  @override
  String get settingsAppLocked => 'অ্যাপ লক করা';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'The Accountant খুলতে আনলক করুন';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'খরচ লিখে রাখার কথা The Accountant কখন ও কীভাবে মনে করিয়ে দেবে তা ঠিক করুন।';

  @override
  String get settingsYourEmailIsUsedTo =>
      'আপনার ইমেল দিয়ে সাইন ইন করা হয়, এখানে সেটি বদলানো যাবে না।';

  @override
  String get settingsYourDataIsOnThis => 'আপনার তথ্য কেবল এই ডিভাইসেই আছে';

  @override
  String get settingsUpgradeForCloudSync => 'ক্লাউড সিঙ্কের জন্য আপগ্রেড করুন';

  @override
  String get settingsNoSettingsFound => 'কোনো সেটিং পাওয়া যায়নি';

  @override
  String get settingsTryADifferentSearchTerm => 'অন্য শব্দ দিয়ে খুঁজে দেখুন';

  @override
  String get settingsSyncStatus => 'সিঙ্কের অবস্থা';

  @override
  String get settingsSyncNow => 'এখনই সিঙ্ক করুন';

  @override
  String get settingsRestoreFromCloud2 => 'ক্লাউড থেকে ফিরিয়ে আনুন';

  @override
  String get settingsPro => 'প্রো';

  @override
  String get settingsNeedsYourConfirmation => 'আপনার নিশ্চিতকরণ প্রয়োজন';

  @override
  String get walletCreateYourFirstAccount => 'আপনার প্রথম অ্যাকাউন্ট তৈরি করুন';

  @override
  String get walletYouNeedAtLeastOne =>
      'হিসাব রাখা শুরু করতে অন্তত একটি অ্যাকাউন্ট দরকার';

  @override
  String get walletAccountType => 'অ্যাকাউন্টের ধরন';

  @override
  String get walletAccountName => 'অ্যাকাউন্টের নাম';

  @override
  String get walletCreditLimit => 'ক্রেডিট সীমা';

  @override
  String get walletCreditLimitHelp =>
      'সীমা বেড়েছে? এখানে বদলান। নতুন সীমা আয় নয়।';

  @override
  String get walletAmountOwed => 'বকেয়া';

  @override
  String get walletAmountOwedHelp =>
      'এই মুহূর্তে কার্ডে আপনার যত বকেয়া। পরিশোধ হয়ে থাকলে ০ দিন।';

  @override
  String get walletCurrentBalance => 'বর্তমান ব্যালেন্স';

  @override
  String get walletCurrentBalanceHelp =>
      'পরিবর্তনটি ব্যালেন্স সংশোধন হিসেবে সংরক্ষিত হয়, তাই আপনার হিসাব মিলে থাকে।';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'এই কার্ডে $amount আসলে কী?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'বাকি থাকা ক্রেডিট';

  @override
  String get walletCardBalanceOwed => 'আমার বকেয়া';

  @override
  String get walletCardBalanceChoose =>
      'এই অঙ্কটি কী তা বেছে নিন, যাতে বকেয়া ঠিকভাবে হিসাব হয়।';

  @override
  String get walletBillingCycleDayOptional => 'বিল চক্রের দিন (ঐচ্ছিক)';

  @override
  String get walletThisWillBeYourDefault => 'এটিই আপনার ডিফল্ট অ্যাকাউন্ট হবে';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'এই অ্যাকাউন্টে এখনও কিছু লেখা হয়নি।';

  @override
  String get walletAddAccount => 'অ্যাকাউন্ট যোগ করুন';

  @override
  String get walletYourAccounts => 'আপনার অ্যাকাউন্টগুলি';

  @override
  String get walletNoAccountsYet => 'এখনও কোনো অ্যাকাউন্ট নেই';

  @override
  String get walletOutstanding => 'বকেয়া';

  @override
  String get walletAvailable => 'ব্যবহারযোগ্য';

  @override
  String get walletLimit => 'সীমা';

  @override
  String get walletBalance => 'ব্যালেন্স';

  @override
  String get walletUseThisWalletForNew =>
      'নতুন লেনদেনের জন্য এই ওয়ালেট ব্যবহার করুন';

  @override
  String get walletSelectIcon => 'আইকন বাছুন';

  @override
  String get walletSelectColor => 'রঙ বাছুন';

  @override
  String get txYouNeedAtLeast2 => 'স্থানান্তর করতে অন্তত ২টি অ্যাকাউন্ট দরকার';

  @override
  String get txNoAccountTitle => 'এটি রেকর্ড করার মতো কোনো অ্যাকাউন্ট নেই';

  @override
  String get txNoAccountBody =>
      'একটি অ্যাকাউন্ট যোগ করুন, বা বন্ধ করা অ্যাকাউন্ট আবার চালু করুন — তাহলেই এই ফরমটি ব্যবহার করা যাবে।';

  @override
  String get txNoAccountAction => 'অ্যাকাউন্ট পরিচালনা';

  @override
  String get txDeleteTransaction => 'লেনদেন মুছুন';

  @override
  String get txAreYouSureYouWant => 'আপনি কি নিশ্চিত যে এই লেনদেনটি মুছতে চান?';

  @override
  String get txTransactionType => 'লেনদেনের ধরন';

  @override
  String get txTransferFee => 'স্থানান্তরের ফি';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'আলাদাভাবে ধরা হয়, তাই স্থানান্তরটি নিজে ভারসাম্যে থাকে।';

  @override
  String get txDeductedFrom => 'যেখান থেকে কাটা হবে';

  @override
  String get txNoPaymentMethods => 'কোনো পেমেন্ট পদ্ধতি নেই';

  @override
  String get txNothingDeletedRecently => 'সম্প্রতি কিছু মোছা হয়নি';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'আপনি যা মুছবেন তা ত্রিশ দিন এখানে থাকবে।';

  @override
  String get txNoRulesYet => 'এখনও কোনো নিয়ম নেই';

  @override
  String get txClearAll => 'সব মুছুন';

  @override
  String get txApplyFilters => 'ফিল্টার প্রয়োগ করুন';

  @override
  String get txUpcomingOverdue => 'আসন্ন ও বকেয়া';

  @override
  String get txNew => 'নতুন';

  @override
  String get txLoan => 'ঋণ';

  @override
  String get goalStarted => 'শুরু';

  @override
  String get goalTargetDate => 'লক্ষ্যের তারিখ';

  @override
  String get goalWithADateTheGoal =>
      'তারিখ দিলে প্রতিদিন কত সরিয়ে রাখতে হবে তা হিসাব করে দেওয়া হয়।';

  @override
  String get goalCountedTowardThisGoal => 'এই লক্ষ্যের হিসাবে ধরা হয়েছে';

  @override
  String get goalGettingThere => 'এগোচ্ছে';

  @override
  String get goalSetATargetDateAnd =>
      'একটি লক্ষ্যের তারিখ দিন, কত সরিয়ে রাখতে হবে তা বলে দেওয়া হবে।';

  @override
  String get reportSpendingInsights => 'খরচের বিশ্লেষণ';

  @override
  String get reportNoSpendingDataForThis => 'এই সময়কালে খরচের কোনো তথ্য নেই';

  @override
  String get reportNoCategorySpendingData => 'ক্যাটাগরিভিত্তিক খরচের তথ্য নেই';

  @override
  String get reportNoSpendingDataAvailable => 'খরচের কোনো তথ্য নেই';

  @override
  String get reportBudgetVsActual => 'বাজেট বনাম বাস্তব';

  @override
  String get reportNoActiveBudgets => 'চালু কোনো বাজেট নেই';

  @override
  String get reportCreateABudgetToTrack =>
      'খরচের হিসাব রাখতে একটি বাজেট তৈরি করুন';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'সময়কাল যত এগোচ্ছে খরচ তার চেয়ে দ্রুত হচ্ছে।';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'এই সময়কালে কিছু লেখা হয়নি।';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $limit-এর মধ্যে $spent খরচ হয়েছে';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount বাকি';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount বেশি';
  }

  @override
  String get budgetPeriodEnded => 'সময়কাল শেষ';

  @override
  String get budgetPaceOver => 'সীমা পার';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন বাকি',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'পাসওয়ার্ড বদলানো হয়েছে। এবার সাইন ইন করুন।';

  @override
  String get authResendCode => 'কোড আবার পাঠান';

  @override
  String get authForgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get authOrContinueWith => 'অথবা চালিয়ে যান';

  @override
  String get authContinueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get authContinueWithApple => 'Apple দিয়ে চালিয়ে যান';

  @override
  String get authSignUp => 'সাইন আপ';

  @override
  String get authPleaseAcceptTheTermsAnd => 'শর্তাবলী মেনে নিন';

  @override
  String get authPasswordStrength => 'পাসওয়ার্ডের শক্তি';

  @override
  String get authAlreadyHaveAnAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে? ';

  @override
  String get authPersonalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get authUpgradeToPremium => 'প্রিমিয়ামে আপগ্রেড করুন';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'সীমাহীন বাজেট, উন্নত বিশ্লেষণ ও আরও অনেক কিছু খুলে নিন!';

  @override
  String get authUpgradeNow => 'এখনই আপগ্রেড করুন';

  @override
  String get authPremiumMember => 'প্রিমিয়াম সদস্য';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'সমস্ত প্রিমিয়াম সুবিধা উপভোগ করছেন';

  @override
  String get authSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get authAreYouSureYouWant => 'আপনি কি নিশ্চিত যে সাইন আউট করতে চান?';

  @override
  String get authChangeProfilePhoto => 'প্রোফাইল ছবি বদলান';

  @override
  String get authTakePhoto => 'ছবি তুলুন';

  @override
  String get authUseYourCamera => 'আপনার ক্যামেরা ব্যবহার করুন';

  @override
  String get authChooseFromGallery => 'গ্যালারি থেকে বাছুন';

  @override
  String get authSelectAnExistingPhoto => 'আগের একটি ছবি বাছুন';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'ছবি বাছা হয়েছে! আপলোডের সুবিধা শীঘ্রই আসছে।';

  @override
  String get authNameCannotBeEmpty => 'নাম খালি রাখা যাবে না';

  @override
  String get authProfileUpdatedSuccessfully => 'প্রোফাইল হালনাগাদ হয়েছে!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'গোপনীয়তা ও শর্তাবলী';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'চালিয়ে যাওয়ার আগে এগুলি দেখে নিন।';

  @override
  String get premiumLimitReached => 'সীমায় পৌঁছে গেছে';

  @override
  String get aiChats => 'চ্যাট';

  @override
  String get aiNewChat => 'নতুন চ্যাট';

  @override
  String get aiNoConversationsYet => 'এখনও কোনো কথোপকথন নেই';

  @override
  String get aiStartChattingAndYourThreads =>
      'কথা বলা শুরু করুন, আপনার আলাপগুলি এখানে দেখা যাবে।';

  @override
  String get aiScanAReceipt => 'একটি রসিদ স্ক্যান করুন';

  @override
  String get aiReadingYourReceipt => 'আপনার রসিদ পড়া হচ্ছে…';

  @override
  String get aiReviewSave => 'দেখে নিয়ে সংরক্ষণ করুন';

  @override
  String get aiWeReadThisFromYour =>
      'আপনার রসিদ থেকে এটি পড়া হয়েছে — সংরক্ষণের আগে দেখে নিন ও দরকারে বদলান।';

  @override
  String get dashErrorLoadingFinancialData => 'আর্থিক তথ্য আনতে সমস্যা হয়েছে';

  @override
  String get dashNoSpendingDataYet => 'এখনও খরচের কোনো তথ্য নেই';

  @override
  String get dashManage => 'পরিচালনা';

  @override
  String get dashAvailable => 'ব্যবহারযোগ্য: ****';

  @override
  String get onboardWelcome => 'স্বাগতম!';

  @override
  String get onboardSelectYourDefaultCurrency => 'আপনার ডিফল্ট মুদ্রা বাছুন';

  @override
  String get onboardLoadingCurrencies => 'মুদ্রা আনা হচ্ছে...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'আপনার প্রধান ওয়ালেটটি সাজান';

  @override
  String get onboardInitialBalanceOptional => 'শুরুর ব্যালেন্স (ঐচ্ছিক)';

  @override
  String get onboardYourAccountIsReadyTo =>
      'আপনার অ্যাকাউন্ট ব্যবহারের জন্য প্রস্তুত';

  @override
  String get onboardTipYouCanAddMore =>
      'পরামর্শ: ওয়ালেট অংশ থেকে যেকোনো সময় ভিন্ন মুদ্রার আরও অ্যাকাউন্ট যোগ করতে পারেন।';

  @override
  String get creditSettled => 'মিটে গেছে';

  @override
  String get creditOverdue => 'মেয়াদ পেরিয়েছে';

  @override
  String creditTabCredit(int count) {
    return 'ধার দেওয়া ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'ধার নেওয়া ($count)';
  }

  @override
  String get creditNetOutstanding => 'মোট বাকি';

  @override
  String get creditAllSettled => 'সব শোধ হয়েছে';

  @override
  String get creditOthersOweYou => 'অন্যরা আপনাকে দেবে';

  @override
  String get creditYouOweOthers => 'আপনি অন্যদের দেবেন';

  @override
  String creditOverdueCount(int count) {
    return '$countটি মেয়াদ পেরিয়েছে';
  }

  @override
  String get creditEmptyAll => 'কোনো ধার দেওয়া বা নেওয়া নেই';

  @override
  String get creditEmptyLent => 'কোনো ধার দেওয়া নেই';

  @override
  String get creditEmptyBorrowed => 'কোনো ধার নেওয়া নেই';

  @override
  String get creditEmptyAllSettled => 'সব শোধ হয়ে গেছে।';

  @override
  String get creditEmptyHint =>
      'কে কাকে কত দেবে মনে রাখতে ধার দেওয়া বা নেওয়া টাকা যোগ করুন।';

  @override
  String get creditShowAll => 'সব দেখান';

  @override
  String get creditShowUnpaid => 'শুধু বাকিগুলো দেখান';

  @override
  String get creditMoneyLent => 'ধার দেওয়া টাকা';

  @override
  String get creditMoneyBorrowed => 'ধার নেওয়া টাকা';

  @override
  String get creditTheyOweYou => 'আপনি পাবেন';

  @override
  String get creditYouOwe => 'আপনি দেবেন';

  @override
  String get creditCollected => 'পাওয়া গেছে';

  @override
  String creditPaidOf(String paid, String total) {
    return '$total এর মধ্যে $paid শোধ';
  }

  @override
  String get creditRecord => 'লিখে রাখুন';

  @override
  String get subRecurring => 'নিয়মিত';

  @override
  String get subPaused => 'থামানো';

  @override
  String get subAsksFirst => 'আগে জিজ্ঞাসা করে';

  @override
  String get subFrequency => 'কত ঘন ঘন';

  @override
  String get notifMarkAllRead => 'সব পড়া হিসেবে চিহ্নিত করুন';

  @override
  String get notifTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get notifStayOnTopOfYour => 'আপনার টাকার খবর রাখুন';

  @override
  String get notifNoNotificationsYet => 'এখনও কোনো বিজ্ঞপ্তি নেই';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'বিজ্ঞপ্তি এলে সেগুলি এখানে দেখা যাবে।';

  @override
  String get startupNothingHasBeenChangedOr => 'কিছুই বদলানো বা মোছা হয়নি।';

  @override
  String get sharedIncludeCryptoCurrencies => 'ক্রিপ্টো মুদ্রাও দেখান';

  @override
  String get sharedTotalBalance => 'মোট ব্যালেন্স';

  @override
  String get heatmapTitle => 'প্রতিদিনের ছন্দ';

  @override
  String get heatmapSpentMore => 'বেশি খরচ';

  @override
  String get heatmapEarnedMore => 'বেশি আয়';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    return '$countটি লেনদেন দেখানো হয়নি: সেগুলোর অ্যাকাউন্টের মুদ্রা ও $currency-এর মধ্যে কোনো বিনিময় হার জানা নেই।';
  }

  @override
  String get heatmapNothingYet => 'এই সময়কালে এখনও কিছু লেখা হয়নি।';

  @override
  String get heatmapNetForRange => 'এই সময়ে নিট';

  @override
  String get layoutTitle => 'হোম বিন্যাস';

  @override
  String get layoutSubtitle =>
      'হোম স্ক্রিন সাজান, বা যা ব্যবহার করেন না তা লুকান';

  @override
  String get layoutExplain =>
      'সাজাতে টেনে নিন। বন্ধ করা অংশ নিজের জায়গা ধরে রাখে, তাই আবার চালু করলে যেখানে ছিল সেখানেই ফিরে আসে।';

  @override
  String get layoutReset => 'ডিফল্টে ফিরিয়ে আনুন';

  @override
  String get layoutAllHidden => 'সব অংশ লুকানো আছে। হোম স্ক্রিন খালি থাকবে।';

  @override
  String get layoutSectionGreeting => 'শুভেচ্ছা';

  @override
  String get layoutSectionAccounts => 'অ্যাকাউন্ট';

  @override
  String get layoutSectionQuickStats => 'আয় ও ব্যয়';

  @override
  String get layoutSectionQuickLinks => 'শর্টকাট';

  @override
  String get layoutSectionSpendingChart => 'খরচের সারসংক্ষেপ';

  @override
  String get layoutSectionRecent => 'সাম্প্রতিক লেনদেন';

  @override
  String get layoutSectionBudgets => 'বাজেটের অগ্রগতি';

  @override
  String get layoutSectionGoals => 'পিন করা লক্ষ্য';

  @override
  String get shortcutAddExpense => 'খরচ যোগ করুন';

  @override
  String get shortcutAddIncome => 'আয় যোগ করুন';

  @override
  String get shortcutScanReceipt => 'রসিদ স্ক্যান করুন';

  @override
  String get shortcutTransactions => 'লেনদেন';

  @override
  String get backupBusySyncing =>
      'একটি সিঙ্ক চলছে। ফিরিয়ে আনার আগে সেটি শেষ হতে দিন।';

  @override
  String get appearanceTitle => 'চেহারা';

  @override
  String get themeSunriseLight => 'সানরাইজ লাইট';

  @override
  String get themeSunriseDark => 'সানরাইজ ডার্ক';

  @override
  String get themeMatchSystem => 'ফোনের সেটিং অনুসরণ';

  @override
  String get themeMatchSystemHint => 'ফোনের সাথে লাইট ও ডার্ক বদলাবে';

  @override
  String get themeUnlockAll => 'সব থিম আনলক করুন';

  @override
  String get themeProBadge => 'প্রো';

  @override
  String get themeAccentSunrise => 'সানরাইজ';

  @override
  String get themeAccentSapphire => 'স্যাফায়ার';

  @override
  String get themeAccentEmerald => 'এমারেল্ড';

  @override
  String get themeAccentRuby => 'রুবি';

  @override
  String get themeAccentAmethyst => 'অ্যামেথিস্ট';

  @override
  String get themeAccentGraphite => 'গ্রাফাইট';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'আজ';

  @override
  String get navAdd => 'যোগ';

  @override
  String get navStats => 'পরিসংখ্যান';

  @override
  String get navMore => 'আরও';

  @override
  String get walkthroughTodayTitle => 'এক নজরে আপনার দিন';

  @override
  String get walkthroughTodayBody => 'নেট সম্পদ, আয়-ব্যয় আর আজকের লেনদেন।';

  @override
  String get walkthroughAddTitle => 'সেকেন্ডে যোগ করুন';

  @override
  String get walkthroughAddBody => 'খরচ, আয় বা ট্রান্সফার লিখতে যোগ চাপুন।';

  @override
  String get walkthroughTransactionsTitle => 'আপনার লেনদেন';

  @override
  String get walkthroughTransactionsBody =>
      'মাস অনুযায়ী সব লেনদেন। যেকোনো কিছু খুঁজে পেতে সার্চ ও ফিল্টার করুন।';

  @override
  String get walkthroughStatsTitle => 'টাকা কোথায় যায় দেখুন';

  @override
  String get walkthroughStatsBody =>
      'সপ্তাহ, মাস ও বছর অনুযায়ী ক্যাটাগরি চার্ট।';

  @override
  String get walkthroughBellTitle => 'খবর রাখুন';

  @override
  String get walkthroughBellBody =>
      'বাজেট সতর্কতা ও রিমাইন্ডার এখানে আসবে। সব প্রস্তুত!';

  @override
  String get walkthroughBalanceTitle => 'আপনার নেট সম্পদ';

  @override
  String get walkthroughBalanceBody =>
      'সব ওয়ালেটের মোট এখানে, ভাগটা দেখায় বারে।';

  @override
  String get txTransfer => 'ট্রান্সফার';

  @override
  String get txUncategorized => 'শ্রেণিহীন';

  @override
  String todayGoodMorning(String name) {
    return 'সুপ্রভাত, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'শুভ অপরাহ্ন, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'শুভ সন্ধ্যা, $name';
  }

  @override
  String get todayGoodMorningPlain => 'সুপ্রভাত';

  @override
  String get todayGoodAfternoonPlain => 'শুভ অপরাহ্ন';

  @override
  String get todayGoodEveningPlain => 'শুভ সন্ধ্যা';

  @override
  String get todayNetWorth => 'নেট সম্পদ';

  @override
  String todayThisMonthDelta(String amount) {
    return 'এই মাসে $amount';
  }

  @override
  String get todayEarned => 'আয়';

  @override
  String get todaySpent => 'ব্যয়';

  @override
  String get todayTitle => 'আজ';

  @override
  String get todayRecent => 'সাম্প্রতিক';

  @override
  String get todayAllActivity => 'সব লেনদেন';

  @override
  String get todayNothingYet => 'আজ এখনো কিছু নেই';

  @override
  String get todayNothingYetBody => 'প্রথমটি লিখতে যোগ চাপুন।';

  @override
  String todayMoreWallets(int count) {
    return '+আরও $countটি';
  }

  @override
  String get todayCoachTitle => 'আপনার মানি কোচকে জিজ্ঞেস করুন';

  @override
  String get todayCoachBody => 'আপনার নিজের খরচ থেকে উত্তর ও পরামর্শ';

  @override
  String get todayNotifications => 'নোটিফিকেশন';

  @override
  String get todayWithinBudget => 'বাজেটের মধ্যে';

  @override
  String get todayOverBudget => 'বাজেট ছাড়িয়েছে';

  @override
  String get todayNetCredit => 'নিট পাওনা';

  @override
  String get todayNetDebt => 'নিট দেনা';

  @override
  String get todayMonthly => 'মাসিক';

  @override
  String get walletsTitle => 'ওয়ালেট';

  @override
  String get walletsNew => 'নতুন';

  @override
  String get walletsAddHint => 'ব্যাংক, ক্যাশ, সঞ্চয় যোগ করুন…';

  @override
  String get walletsPlanning => 'পরিকল্পনা';

  @override
  String get walletsUpcoming => 'আসন্ন';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$countটি বাকি · $amount';
  }

  @override
  String get walletsUpcomingNone => 'শিগগির কিছু বাকি নেই';

  @override
  String get walletsLendBorrow => 'ধার ও দেনা';

  @override
  String get splitTitle => 'বিল ভাগ';

  @override
  String get splitSubtitle =>
      'বন্ধুদের সাথে বিল ভাগ করুন; কার কাছে কত পাওনা, তা ধার ও দেনায় থাকবে';

  @override
  String get splitWhatFor => 'কিসের বিল';

  @override
  String get splitTotal => 'মোট বিল';

  @override
  String get splitPeople => 'যাদের সাথে ভাগ';

  @override
  String get splitYou => 'আপনি';

  @override
  String get splitIncludeMe => 'আমারও ভাগ আছে';

  @override
  String get splitIncludeMeSub => 'শুধু অন্যদের জন্য দিলে বন্ধ করুন';

  @override
  String get splitAddPerson => 'একজন যোগ করুন';

  @override
  String get splitPersonName => 'নাম';

  @override
  String get splitKnownPeople => 'ধার ও দেনা থেকে';

  @override
  String get splitRemove => 'সরান';

  @override
  String get splitPaidBy => 'কে বিল দিয়েছেন';

  @override
  String get splitHow => 'কীভাবে ভাগ হবে';

  @override
  String get splitEqual => 'সমান';

  @override
  String get splitExact => 'টাকায়';

  @override
  String get splitPercent => 'শতাংশে';

  @override
  String get splitShares => 'ভাগগুলো';

  @override
  String get splitYourShare => 'আপনার ভাগ';

  @override
  String get splitOwesYou => 'আপনার পাওনা';

  @override
  String splitYouOwe(String name) {
    return '$name-কে দিতে হবে';
  }

  @override
  String get splitPaidTheBill => 'বিল দিয়েছেন';

  @override
  String splitSettlesWith(String name) {
    return '$name-এর সাথে তাঁদের হিসাব';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return 'আপনার অ্যাকাউন্ট থেকে $total; আপনার পাওনা $owed';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'এখন আপনার অ্যাকাউন্ট থেকে কিছু যাবে না; $name-কে দিতে হবে $amount';
  }

  @override
  String get splitPercentLabel => 'বিলের কত শতাংশ';

  @override
  String get splitSave => 'ভাগ করুন';

  @override
  String get splitSaved => 'বিল ভাগ হয়েছে';

  @override
  String get splitNeedCategory => 'আগে একটি ক্যাটাগরি বাছুন।';

  @override
  String get splitThisBill => 'এই বিল ভাগ করুন';

  @override
  String get splitThisBillSub => 'বন্ধুদের সাথে; তাদের দেনা যাবে ধার ও দেনায়';

  @override
  String get splitPartOf => 'ভাগ করা বিল';

  @override
  String walletsOwedToYou(String amount) {
    return 'আপনি পাবেন $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'আপনার দেনা $amount';
  }

  @override
  String get walletsAllSettled => 'সব মিটে গেছে';

  @override
  String get walletsGoals => 'লক্ষ্য';

  @override
  String walletsGoalsSub(int count) {
    return '$countটি চলমান';
  }

  @override
  String get walletsBudgets => 'বাজেট';

  @override
  String get walletsSubscriptions => 'সাবস্ক্রিপশন';

  @override
  String get walletsTransfer => 'ওয়ালেটের মধ্যে ট্রান্সফার';

  @override
  String get walletsArchived => 'আর্কাইভ';

  @override
  String walletsDeleteMessage(String name) {
    return '“$name” মুছবেন? এই অ্যাকাউন্টের সব লেনদেনও মুছে যাবে।';
  }

  @override
  String walletsDeleted(String name) {
    return '$name মুছে ফেলা হয়েছে';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name এখন ডিফল্ট';
  }

  @override
  String get walletsCreateFailed => 'অ্যাকাউন্ট তৈরি হয়নি। আবার চেষ্টা করুন।';

  @override
  String get walletsEmptyBody =>
      'ট্র্যাকিং শুরু করতে প্রথম অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get walletsTypeBank => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get walletsTypeCard => 'ক্রেডিট কার্ড';

  @override
  String get walletsTypeCash => 'ক্যাশ';

  @override
  String get walletsTypeOther => 'অ্যাকাউন্ট';

  @override
  String get moreTitle => 'আরও';

  @override
  String get moreGoPremium => 'প্রিমিয়াম নিন';

  @override
  String get moreGoPremiumBody => 'এআই সহকারী, ক্লাউড সিঙ্ক, থিম';

  @override
  String get moreUnlock => 'আনলক';

  @override
  String get morePremiumActive => 'প্রিমিয়াম চালু আছে';

  @override
  String get morePremiumThanks =>
      'দ্য অ্যাকাউন্ট্যান্টকে সমর্থনের জন্য ধন্যবাদ';

  @override
  String get sectionPreferences => 'পছন্দ';

  @override
  String get sectionTools => 'টাকার টুলস';

  @override
  String get moreAiAssistant => 'এআই সহকারী';

  @override
  String get moreAiAssistantSub => 'আপনার টাকা নিয়ে প্রশ্ন করুন';

  @override
  String get moreSignOutConfirm => 'এই ডিভাইস থেকে সাইন আউট করবেন?';

  @override
  String get moreSignOutFailed => 'সাইন আউট হয়নি। আবার চেষ্টা করুন।';

  @override
  String get moreDeviceOnlyBody =>
      'ফ্রি অ্যাকাউন্টের ডেটা ক্লাউডে ব্যাকআপ হয় না, তাই রিইনস্টল বা ফোন বদলালে ডেটা হারাতে পারে। ক্লাউড সিঙ্কের জন্য আপগ্রেড করুন, বা নিয়মিত ব্যাকআপ এক্সপোর্ট করুন।';

  @override
  String get moreUpgradeToPremium => 'প্রিমিয়ামে আপগ্রেড করুন';

  @override
  String get moreUser => 'আপনি';

  @override
  String get statsTitle => 'পরিসংখ্যান';

  @override
  String get statsWeek => 'সপ্তাহ';

  @override
  String get statsMonth => 'মাস';

  @override
  String get statsYear => 'বছর';

  @override
  String get statsSpending => 'ব্যয়';

  @override
  String get statsIncome => 'আয়';

  @override
  String get statsCategories => 'ক্যাটাগরি';

  @override
  String get statsSpent => 'ব্যয়';

  @override
  String get statsEarned => 'আয়';

  @override
  String get statsNet => 'নিট';

  @override
  String get statsThisMonth => 'এই মাসে';

  @override
  String statsVsLastMonth(String change) {
    return 'গত মাসের তুলনায় $change';
  }

  @override
  String get statsInsightsSub => 'এই মাসের সারাংশ, প্রবণতা ও পরামর্শ';

  @override
  String get statsAskCoach => 'এ নিয়ে এআই কোচকে জিজ্ঞেস করুন';

  @override
  String statsOverBy(String amount) {
    return '$amount বেশি';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% বাকি';
  }

  @override
  String get activityAll => 'সব';

  @override
  String get activitySpent => 'ব্যয়';

  @override
  String get activityEarned => 'আয়';

  @override
  String get activityTransfers => 'ট্রান্সফার';

  @override
  String activitySoFar(String month) {
    return '$month এ পর্যন্ত';
  }

  @override
  String activityNet(String amount) {
    return 'নিট $amount';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সব মাস মিলিয়ে $countটি মিল',
      one: 'সব মাস মিলিয়ে ১টি মিল',
    );
    return '$_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return '“$query” এর সাথে কিছু মেলেনি';
  }

  @override
  String get activitySearchNothingBody =>
      'সব মাস খোঁজা হয়েছে। কম শব্দ, অন্য বানান চেষ্টা করুন, বা একটি ফিল্টার সরান।';

  @override
  String get activityIn => 'আয়';

  @override
  String get activityOut => 'ব্যয়';

  @override
  String get activityToday => 'আজ';

  @override
  String get activityYesterday => 'গতকাল';

  @override
  String get activityTomorrow => 'আগামীকাল';

  @override
  String get activityEmptyFutureTitle => 'পরিকল্পিত কোনো লেনদেন নেই';

  @override
  String activityEmptyFutureBody(String month) {
    return '$month এর আগাম পেমেন্ট যোগ করুন';
  }

  @override
  String get activityEmptyNowTitle => 'এখনো কোনো লেনদেন নেই';

  @override
  String get activityEmptyNowBody => 'এই মাসের খরচ লিখতে শুরু করুন';

  @override
  String get activityEmptyPastTitle => 'কোনো লেনদেন পাওয়া যায়নি';

  @override
  String activityEmptyPastBody(String month) {
    return '$month এ কোনো রেকর্ড নেই';
  }

  @override
  String activityDeletedCount(int count) {
    return '$countটি লেনদেন মুছে ফেলা হয়েছে';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$countটি $name এ সরানো হয়েছে';
  }

  @override
  String get activityMixedCurrencies =>
      'এগুলো ভিন্ন মুদ্রায় আছে, তাই একটি অ্যাকাউন্টে সরানো যাবে না। একই মুদ্রার লেনদেন বাছুন।';

  @override
  String activityMovedPartial(int count) {
    return '$countটি সরানো হয়েছে; ট্রান্সফার যেমন ছিল তেমনই আছে';
  }

  @override
  String activityMoved(int count) {
    return '$countটি অন্য অ্যাকাউন্টে সরানো হয়েছে';
  }

  @override
  String activityRedated(int count) {
    return '$countটির তারিখ বদলানো হয়েছে';
  }

  @override
  String get activityNothingToPay => 'পরিশোধের অপেক্ষায় কিছু ছিল না';

  @override
  String activityMarkedPaid(int count) {
    return '$countটি পরিশোধিত হিসেবে চিহ্নিত';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$countটি কপি হয়েছে; ট্রান্সফার আলাদাভাবে কপি হয় না';
  }

  @override
  String activityCopied(int count) {
    return '$countটি কপি হয়েছে';
  }

  @override
  String get activityDeleteOneBody =>
      'এটি আপনার রেকর্ড থেকে মুছে যাবে এবং ব্যালান্স আবার হিসাব হবে।';

  @override
  String get activitySearch => 'খুঁজুন';

  @override
  String get addNewExpense => 'নতুন খরচ';

  @override
  String get addNewIncome => 'নতুন আয়';

  @override
  String get addNewTransfer => 'নতুন ট্রান্সফার';

  @override
  String get addEditTitle => 'লেনদেন সম্পাদনা';

  @override
  String get addAmount => 'পরিমাণ';

  @override
  String get addCategory => 'ক্যাটাগরি';

  @override
  String get addMore => 'আরও';

  @override
  String get addWallet => 'ওয়ালেট';

  @override
  String addChangeDate(String date) {
    return 'তারিখ বদলান, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'সময় বদলান, $time';
  }

  @override
  String get addSwapAccounts => 'দুটি অ্যাকাউন্ট অদলবদল করুন';

  @override
  String get notifCheckTitle => 'নোটিফিকেশন যাচাই';

  @override
  String get notifAllowed => 'নোটিফিকেশন চালু আছে';

  @override
  String get notifAllowedHint => 'রিমাইন্ডার এই ফোনে আসতে পারবে';

  @override
  String get notifBlocked => 'নোটিফিকেশন বন্ধ আছে';

  @override
  String get notifBlockedHint => 'চালু করতে ট্যাপ করুন, নইলে কিছুই আসবে না';

  @override
  String get notifSendTest => 'একটি টেস্ট নোটিফিকেশন পাঠান';

  @override
  String get notifSendTestHint => 'আমাদের সার্ভার থেকে, রিমাইন্ডার যেভাবে আসে';

  @override
  String get notifSending => 'পাঠানো হচ্ছে…';

  @override
  String get notifTestSent =>
      'পাঠানো হয়েছে। কয়েক সেকেন্ডের মধ্যে এটি আসবে, ইনবক্সেও থাকবে।';

  @override
  String notifTestFailed(String reason) {
    return 'পাঠানো যায়নি: $reason';
  }

  @override
  String get notifTestOffline => 'সার্ভারের সাথে সংযোগ নেই';

  @override
  String get notifDailyPrimerBody =>
      'দ্য অ্যাকাউন্ট্যান্ট আপনার বেছে নেওয়া সময়ে খরচ লিখে রাখার একটি ছোট রিমাইন্ডার পাঠাবে। এর জন্য নোটিফিকেশন দেখানোর অনুমতি লাগবে।';

  @override
  String get notifPrimerShow => 'রিমাইন্ডার নোটিফিকেশন দেখাবে';

  @override
  String get notifPrimerTime => 'আপনার বেছে নেওয়া সময়ে আসবে';

  @override
  String get notifPrimerOff => 'যেকোনো সময় বন্ধ করতে পারবেন';

  @override
  String get notifPrimerAllow => 'অনুমতি দিন';

  @override
  String get cardBillsTitle => 'কার্ডের বিল';

  @override
  String get cardBillsSubtitle =>
      'ক্রেডিট কার্ডের স্টেটমেন্ট, শেষ তারিখ ও রিমাইন্ডার';

  @override
  String get cardBillsEmptyTitle => 'এখনো কোনো ক্রেডিট কার্ড নেই';

  @override
  String get cardBillsEmptyBody =>
      'ক্রেডিট কার্ড ধরনের একটি অ্যাকাউন্ট যোগ করুন, স্টেটমেন্টের দিন ও পরিশোধের শেষ দিন দিন, তাহলে এর বিল এখানে দেখাবে।';

  @override
  String get cardBillsAddCard => 'কার্ড যোগ করুন';

  @override
  String get cardStatementDay => 'স্টেটমেন্টের দিন';

  @override
  String get cardStatementDayHint =>
      'প্রতি মাসের যেদিন বিল তৈরি হয়। সেদিনের শেষ পর্যন্ত সব খরচ এতে থাকে।';

  @override
  String get cardDueDay => 'পরিশোধের শেষ দিন';

  @override
  String get cardDueDayHint =>
      'বিল পরিশোধের শেষ দিন, স্টেটমেন্টের পর প্রথম যেদিন এই তারিখ আসে।';

  @override
  String get cardRemindTitle => 'মনে করিয়ে দিন';

  @override
  String get cardRemindHint =>
      'শেষ তারিখের আগে, যদি বিলের কিছু বাকি থাকে। সকাল ৯টার দিকে পাঠানো হয়।';

  @override
  String get cardRemindOff => 'বন্ধ';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন আগে',
      one: 'আগের দিন',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'দেওয়া হয়নি';

  @override
  String cardDayOfMonth(int day) {
    return '$day তারিখ';
  }

  @override
  String get cardSetUpBody =>
      'এই কার্ডের বিল দেখতে ও শেষ তারিখের আগে রিমাইন্ডার পেতে স্টেটমেন্টের দিন ও পরিশোধের শেষ দিন দিন।';

  @override
  String get cardSetUp => 'তারিখ দিন';

  @override
  String cardDueBy(String date) {
    return '$date এর মধ্যে বাকি পরিশোধ';
  }

  @override
  String get cardLeftToPay => 'বাকি';

  @override
  String cardStatementClosed(String date) {
    return '$date এর স্টেটমেন্ট';
  }

  @override
  String get cardPaidSince => 'এরপর পরিশোধ';

  @override
  String cardThisCycle(String date) {
    return 'এরপর খরচ, পরের স্টেটমেন্ট $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return '$card বিল পরিশোধ';
  }

  @override
  String get cardEdit => 'কার্ড সম্পাদনা';

  @override
  String get cardEarlierStatements => 'আগের স্টেটমেন্ট';

  @override
  String get cardPaidShort => 'পরিশোধিত';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount বাকি';
  }

  @override
  String get cardStatusNotSetUp => 'তারিখ দেওয়া হয়নি';

  @override
  String get cardStatusNothingDue => 'কিছু বাকি নেই';

  @override
  String get cardStatusPaid => 'পরিশোধিত';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন বাকি',
      one: 'কাল শেষ দিন',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'আজ শেষ দিন';

  @override
  String get cardStatusOverdue => 'সময় পেরিয়ে গেছে';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$owed এর মধ্যে $paid পরিশোধিত';
  }

  @override
  String get cardPayBill => 'বিল পরিশোধ';

  @override
  String cardPayTitle(String card) {
    return '$card পরিশোধ';
  }

  @override
  String get cardPayHint =>
      'পুরোটা বা কিছু অংশ পরিশোধ করুন। যা দেবেন তা এই বিলে ধরা হবে, বাকিটা বাকি থাকবে।';

  @override
  String cardPayFull(String amount) {
    return 'পুরোটা পরিশোধ, $amount';
  }

  @override
  String get cardPayFullHint => 'এই বিলের যা বাকি সব';

  @override
  String get cardPayOther => 'অন্য পরিমাণ পরিশোধ';

  @override
  String get cardPayOtherHint => 'আংশিক পরিশোধ, বা বিলের চেয়ে বেশি';

  @override
  String get addNoteHint => 'একটি নোট যোগ করুন';

  @override
  String get addRepeatMonthly => 'প্রতি মাসে পুনরাবৃত্তি';

  @override
  String get addMoreOptions => 'আরও অপশন';

  @override
  String get addScanReceipt => 'রসিদ স্ক্যান';

  @override
  String get addDelete => 'লেনদেন মুছুন';

  @override
  String get addTypeExpense => 'খরচ';

  @override
  String get addTypeIncome => 'আয়';

  @override
  String get addTypeTransfer => 'ট্রান্সফার';

  @override
  String get gatePremium => 'প্রিমিয়াম';

  @override
  String get gateUnlock => 'প্রিমিয়াম দিয়ে আনলক করুন';

  @override
  String get gateFootnote => 'লাইফটাইম বা সাবস্ক্রিপশন · যেকোনো সময় রিস্টোর';

  @override
  String get aiCoachTitle => 'আপনার মানি কোচের সাথে পরিচিত হোন';

  @override
  String get aiCoachBody =>
      'সহজ ভাষায় জিজ্ঞেস করুন। নিজের খরচ থেকে উত্তর, পরামর্শ আর পরিকল্পনা পান।';

  @override
  String get aiAssistantTitle => 'এআই সহকারী';

  @override
  String get aiAskAnything => 'আপনার টাকা নিয়ে জিজ্ঞেস করুন…';

  @override
  String get aiSend => 'পাঠান';

  @override
  String get aiCopy => 'কপি';

  @override
  String get aiCopied => 'কপি হয়েছে';

  @override
  String get aiRetry => 'আবার চেষ্টা';

  @override
  String get aiDismiss => 'বন্ধ করুন';

  @override
  String get aiTyping => 'কোচ লিখছে';

  @override
  String aiStarterCategory(String category) {
    return 'আমার $category খরচ কোথায় গেল?';
  }

  @override
  String get aiStarterBudgets => 'আমার বাজেট কি ঠিকঠাক চলছে?';

  @override
  String get aiStarterUpcoming => 'কোন বিলগুলো আসছে?';

  @override
  String get aiStarterAnalyze => 'আমার সাম্প্রতিক খরচের ধরন বিশ্লেষণ করুন';

  @override
  String get aiStarterBudgetTips => 'ভালো বাজেটের জন্য টিপস দিন';

  @override
  String get aiStarterSave => 'কীভাবে আরও টাকা সঞ্চয় করতে পারি?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” স্থায়ীভাবে মুছে যাবে।';
  }

  @override
  String get aiJustNow => 'এইমাত্র';

  @override
  String get aiErrorTitle => 'কোচ উত্তর দিতে পারেনি';

  @override
  String get paywallTitle => 'অ্যাকাউন্ট্যান্ট প্রিমিয়াম';

  @override
  String get paywallTagline => 'অ্যাপের সবকিছু, আপনার জন্য।';

  @override
  String get paywallActiveTitle => 'প্রিমিয়াম চালু আছে';

  @override
  String get paywallActiveTagline => 'আপনার সমর্থনের জন্য ধন্যবাদ!';

  @override
  String get paywallRestore => 'রিস্টোর';

  @override
  String get paywallProcessing => 'প্রক্রিয়াকরণ…';

  @override
  String paywallTriggered(String feature) {
    return '$feature একটি প্রিমিয়াম ফিচার';
  }

  @override
  String paywallDaysRemaining(int days) {
    return 'আর $days দিন বাকি';
  }

  @override
  String get paywallFeatSync => 'ক্লাউড সিঙ্ক';

  @override
  String get paywallFeatSyncSub => 'সব ডিভাইসে';

  @override
  String get paywallFeatAi => 'এআই সহকারী';

  @override
  String get paywallFeatAiSub => 'সীমাহীন, বিজ্ঞাপন নেই';

  @override
  String get paywallFeatOcr => 'রসিদ স্ক্যান';

  @override
  String get paywallFeatOcrSub => 'এআই দিয়ে ওসিআর';

  @override
  String get paywallFeatInsights => 'খরচের বিশ্লেষণ';

  @override
  String get paywallFeatInsightsSub => 'মাসিক প্রবণতা';

  @override
  String get paywallFeatThemes => '৫টি থিম';

  @override
  String get paywallFeatThemesSub => 'এক্সক্লুসিভ';

  @override
  String get paywallFeatPdf => 'পিডিএফ রিপোর্ট';

  @override
  String get paywallFeatPdfSub => 'সিএসভি ফ্রি থাকছে';

  @override
  String get paywallFeatUnlimited => 'আনলিমিটেড';

  @override
  String get paywallFeatUnlimitedSub => 'ওয়ালেট, বাজেট';

  @override
  String get paywallFeatSupport => 'অগ্রাধিকার সহায়তা';

  @override
  String get paywallFeatSupportSub => 'দ্রুত উত্তর';

  @override
  String get paywallPerMonth => '/মাস';

  @override
  String get paywallPerYear => '/বছর';

  @override
  String get paywallOnce => 'একবার';

  @override
  String get paywallBestValue => 'সেরা মূল্য';

  @override
  String get paywallForever => 'চিরকাল';

  @override
  String get paywallMonthlyDesc => 'মাসিক বিল';

  @override
  String get paywallYearlyDesc => 'বার্ষিক বিল';

  @override
  String get paywallLifetimeDesc => 'একবার দিন, চিরকাল রাখুন';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial ফ্রি, তারপর $rest';
  }

  @override
  String get paywallCtaLifetime => 'লাইফটাইম অ্যাক্সেস নিন';

  @override
  String get paywallCtaYearly => 'বার্ষিক প্ল্যান শুরু করুন';

  @override
  String get paywallCtaMonthly => 'মাসিক প্ল্যান শুরু করুন';

  @override
  String get paywallFootLifetime => 'এককালীন কেনা · কোনো সাবস্ক্রিপশন নেই';

  @override
  String get paywallFootSubscription =>
      'স্বয়ংক্রিয়ভাবে নবায়ন · স্টোরে যেকোনো সময় বাতিল';

  @override
  String get paywallTerms =>
      'সাবস্ক্রিপশনের চার্জ আপনার অ্যাপ স্টোর বা গুগল প্লে অ্যাকাউন্টে হবে এবং বর্তমান মেয়াদ শেষ হওয়ার অন্তত ২৪ ঘণ্টা আগে বাতিল না করলে স্বয়ংক্রিয়ভাবে নবায়ন হবে।';

  @override
  String get paywallIapUnavailable =>
      'এই ডিভাইসে ইন-অ্যাপ কেনাকাটা পাওয়া যাচ্ছে না। গুগল প্লে সার্ভিস আছে এবং অ্যাপটি প্লে স্টোর থেকে নেওয়া কিনা দেখুন।';

  @override
  String get paywallLoadingPlans => 'প্ল্যান লোড হচ্ছে…';

  @override
  String get paywallPlansFailed =>
      'প্ল্যান লোড হয়নি। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get paywallTryAgain => 'আবার চেষ্টা';

  @override
  String get paywallRestored => 'কেনাকাটা রিস্টোর হয়েছে';

  @override
  String get paywallPurchased => 'প্রিমিয়ামে স্বাগতম!';

  @override
  String get paywallLifetimeNever => 'লাইফটাইম অ্যাক্সেসের মেয়াদ শেষ হয় না';

  @override
  String get helpSearchQuestions => 'প্রশ্ন খুঁজুন';

  @override
  String get helpStepWallets => 'ওয়ালেট যোগ করুন';

  @override
  String get helpStepCategories => 'ক্যাটাগরি বাছুন';

  @override
  String get helpStepTrack => 'প্রতিদিন লিখুন';

  @override
  String get splashTagline => 'টাকা, আরও উজ্জ্বল।';

  @override
  String get introStep1 => 'আপনার কয়েন গুনছি…';

  @override
  String get introStep2 => 'ওয়ালেটগুলো জাগাচ্ছি…';

  @override
  String get introStep3 => 'চার্টগুলো ঝকঝকে করছি…';

  @override
  String get introStep4 => 'প্রায় হয়ে গেছে…';

  @override
  String get introTipLabel => 'টাকার টিপস';

  @override
  String get introTip1 => 'আগে নিজেকে দিন: বেতন এলেই সঞ্চয় আলাদা করে রাখুন।';

  @override
  String get introTip2 => 'ছোট দৈনিক খরচ মিলে বড় হয়। লিখে রাখাই অর্ধেক কাজ।';

  @override
  String get introTip3 => '৩ মাসের জরুরি তহবিল বিপদকে ঝামেলায় বদলে দেয়।';

  @override
  String get introTip4 =>
      'প্রতি মাসে সাবস্ক্রিপশন দেখুন: যা ব্যবহার করেননি তা বাদ দিন।';

  @override
  String get introTip5 => 'মাস শুরুর আগে প্রতিটি টাকার একটা কাজ ঠিক করুন।';

  @override
  String get introTip6 => 'অপরিকল্পিত কেনাকাটার আগে ২৪ ঘণ্টা অপেক্ষা করুন।';

  @override
  String get introTip7 =>
      'বাজেট মানে বাধা নয়, গুরুত্বপূর্ণ জিনিসে খরচের অনুমতি।';

  @override
  String get introTip8 =>
      'ছোট জয় উদযাপন করুন: প্রতিটি লক্ষ্য শুরু হয় প্রথম জমা থেকে।';

  @override
  String get adConfirmTitleAiCall => 'আরও একটি এআই অনুরোধ নিন';

  @override
  String get adConfirmTitleTheme =>
      '২৪ ঘণ্টার জন্য প্রিমিয়াম থিম ব্যবহার করুন';

  @override
  String get adConfirmTitlePdf => 'একটি পিডিএফ রিপোর্ট এক্সপোর্ট করুন';

  @override
  String get adConfirmBodyAiCall =>
      'এই মাসের বিনামূল্যের এআই অনুরোধ শেষ। একটি ছোট বিজ্ঞাপন দেখলে আরও একটি পাবেন।';

  @override
  String get adConfirmBodyTheme =>
      'একটি ছোট বিজ্ঞাপন দেখলে পরের ২৪ ঘণ্টা সব প্রিমিয়াম থিম আপনার।';

  @override
  String get adConfirmBodyPdf =>
      'একটি পিডিএফ রিপোর্ট এক্সপোর্ট করতে একটি ছোট বিজ্ঞাপন দেখুন।';

  @override
  String get adConfirmWarning =>
      'আপনি একটি বিজ্ঞাপন দেখতে যাচ্ছেন। চালিয়ে যাবেন?';

  @override
  String adConfirmLeft(int count) {
    return 'এই মাসে আরও $countটি বিজ্ঞাপন দেখা যাবে';
  }

  @override
  String get adPremiumPitch =>
      'প্রিমিয়াম সদস্যরা কোনো বিজ্ঞাপন ছাড়াই সীমাহীন এআই, সব থিম ও পিডিএফ রিপোর্ট পান।';

  @override
  String get adWatch => 'বিজ্ঞাপন দেখুন';

  @override
  String get adGetPremium => 'প্রিমিয়াম নিন';

  @override
  String get adNotNow => 'এখন না';

  @override
  String get adLoading => 'বিজ্ঞাপন লোড হচ্ছে…';

  @override
  String get adVerifying => 'আপনার পুরস্কার নিশ্চিত করা হচ্ছে…';

  @override
  String get adUnavailable =>
      'এই মুহূর্তে কোনো বিজ্ঞাপন নেই। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get adSkipped =>
      'বিজ্ঞাপন শেষ হওয়ার আগে বন্ধ করা হয়েছে, তাই কিছু আনলক হয়নি।';

  @override
  String get adRewardAiCall => 'হয়ে গেছে! আপনি আরও একটি এআই অনুরোধ পেয়েছেন।';

  @override
  String get adRewardTheme => '২৪ ঘণ্টার জন্য প্রিমিয়াম থিম আনলক হয়েছে।';

  @override
  String get adRewardPdf => 'একটি পিডিএফ এক্সপোর্ট আনলক হয়েছে।';

  @override
  String get adMonthlyCapReached =>
      'এই মাসের সব বিজ্ঞাপন দেখা হয়ে গেছে। ১ তারিখে বিনামূল্যের অনুরোধ আবার পাবেন, অথবা সীমাহীনের জন্য প্রিমিয়াম নিন।';

  @override
  String get adRewardPending =>
      'ধন্যবাদ! আপনার পুরস্কার কিছুক্ষণের মধ্যে দেখা যাবে।';

  @override
  String aiQuotaLeft(int count) {
    return 'এই মাসে $countটি বিনামূল্যের এআই অনুরোধ বাকি';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'প্রিমিয়াম: সীমাহীন';

  @override
  String get aiToolSearching => 'আপনার লেনদেন খোঁজা হচ্ছে…';

  @override
  String get aiToolSummarizing => 'হিসাব যোগ করা হচ্ছে…';

  @override
  String get aiToolAccounts => 'আপনার অ্যাকাউন্ট দেখা হচ্ছে…';

  @override
  String get aiToolCategories => 'আপনার ক্যাটাগরি দেখা হচ্ছে…';

  @override
  String get aiToolCards => 'কার্ডের বিল দেখা হচ্ছে…';

  @override
  String get aiToolPlans => 'ইএমআই ও সঞ্চয় দেখা হচ্ছে…';

  @override
  String get aiToolSaving => 'সংরক্ষণ করা হচ্ছে…';

  @override
  String get aiActionAddTitle => 'এই লেনদেনটি যোগ করবেন?';

  @override
  String get aiActionUpdateTitle => 'এই লেনদেনটি বদলাবেন?';

  @override
  String get aiActionDeleteTitle => 'এই লেনদেনটি মুছবেন?';

  @override
  String get aiActionPayCardTitle => 'কার্ডের বিল পরিশোধ';

  @override
  String get aiActionCardSettingsTitle => 'কার্ডের তারিখ বদলানো';

  @override
  String get aiActionCreatePlanTitle => 'পরিকল্পনা শুরু';

  @override
  String get aiActionPayPlanTitle => 'পরিকল্পনার কিস্তি লেখা';

  @override
  String get aiActionClosePlanTitle => 'পরিকল্পনা আগেই শেষ';

  @override
  String get aiActionUpdatePlanTitle => 'পরিকল্পনা বদলানো';

  @override
  String get aiActionCreateInvestmentTitle => 'বিনিয়োগ যোগ';

  @override
  String get aiActionTradeInvestmentTitle => 'লেনদেন লিখুন';

  @override
  String get aiActionUpdateInvestmentTitle => 'দাম হালনাগাদ';

  @override
  String get aiActionConfirm => 'নিশ্চিত করুন';

  @override
  String get aiActionClosePlan => 'শেষ করুন';

  @override
  String get aiActionFrom => 'থেকে';

  @override
  String get aiActionTo => 'যেখানে';

  @override
  String get aiActionBill => 'বিল';

  @override
  String get aiActionLeftAfter => 'এরপর বাকি';

  @override
  String get aiActionRemindDays => 'কত দিন আগে মনে করাবে';

  @override
  String get aiActionPay => 'পরিশোধ';

  @override
  String get plansTitle => 'ইএমআই, ঋণ ও সঞ্চয়';

  @override
  String get investmentsTitle => 'বিনিয়োগ';

  @override
  String get investmentsSubtitle =>
      'মিউচুয়াল ফান্ড, শেয়ার ও এসআইপি, সর্বশেষ দামে';

  @override
  String get forecastTitle => 'নগদ প্রবাহের পূর্বাভাস';

  @override
  String get forecastSubtitle =>
      'নগদ ও ব্যাংকের টাকা কোন দিকে যাচ্ছে, আর কোন দিন কম পড়বে';

  @override
  String forecastRangeDays(int days) {
    return '$days দিন';
  }

  @override
  String get forecastNow => 'এখন নগদ ও ব্যাংকে';

  @override
  String get forecastMoneyIn => 'আসবে';

  @override
  String get forecastMoneyOut => 'যাবে';

  @override
  String get forecastLowest => 'সর্বনিম্ন';

  @override
  String forecastLowestOn(String date) {
    return '$date তারিখে';
  }

  @override
  String get forecastChartTitle => 'সম্ভাব্য ব্যালান্স';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return '$date তারিখে আপনার $amount কম পড়বে';
  }

  @override
  String get forecastShortfallCause => 'সেদিন যা যাবে:';

  @override
  String get forecastAlreadyShort =>
      'আপনার নগদ ও ব্যাংক অ্যাকাউন্ট এখনই শূন্যের নিচে।';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'আগামী $days দিনে কোনো ঘাটতি নেই';
  }

  @override
  String get forecastAllCoveredBody =>
      'নির্ধারিত সব পেমেন্ট আপনার নগদ ও ব্যাংকের টাকায় মেটানো যাবে।';

  @override
  String get forecastScheduledOnly =>
      'শুধু নির্ধারিত লেনদেন ধরা হয়েছে: প্ল্যান, কার্ডের বিল, সাবস্ক্রিপশন, পুনরাবৃত্ত ও আসন্ন পেমেন্ট, এবং নির্দিষ্ট তারিখের ধার। দৈনন্দিন খরচ ধরা হয়নি।';

  @override
  String get forecastEventsTitle => 'সামনে যা আছে';

  @override
  String forecastDayBalance(String amount) {
    return 'ব্যালান্স $amount';
  }

  @override
  String get forecastEmptyTitle => 'কিছু নির্ধারিত নেই';

  @override
  String get forecastEmptyBody =>
      'এই সময়ের প্ল্যান, কার্ডের বিল, সাবস্ক্রিপশন ও আসন্ন পেমেন্ট এখানে দেখা যাবে।';

  @override
  String get forecastOverdue => 'মেয়াদোত্তীর্ণ';

  @override
  String get forecastExpected => 'প্রত্যাশিত';

  @override
  String get forecastKindInstallment => 'কিস্তি';

  @override
  String get forecastKindPremium => 'প্রিমিয়াম';

  @override
  String get forecastKindDeposit => 'জমা';

  @override
  String get forecastKindSipBuy => 'এসআইপি কেনা';

  @override
  String get forecastKindProfit => 'মুনাফা';

  @override
  String get forecastKindMaturity => 'মেয়াদপূর্তি';

  @override
  String get forecastKindCardBill => 'কার্ডের বিল';

  @override
  String get forecastKindCardBillNext => 'পরের কার্ড বিল, এখন পর্যন্ত';

  @override
  String get forecastKindSubscription => 'সাবস্ক্রিপশন';

  @override
  String get forecastKindRecurringBill => 'পুনরাবৃত্ত পেমেন্ট';

  @override
  String get forecastKindRecurringIncome => 'পুনরাবৃত্ত আয়';

  @override
  String get forecastKindUpcoming => 'আসন্ন';

  @override
  String get forecastKindBorrowed => 'শোধ করার ধার';

  @override
  String get forecastKindLent => 'ধার দেওয়া, ফেরত পাওনা';

  @override
  String forecastHomeWarning(String date, String amount) {
    return '$date তারিখে আপনার $amount কম পড়তে পারে';
  }

  @override
  String get forecastHomeWarningBody => 'সামনে কী আছে দেখুন';

  @override
  String get forecastDismiss => 'সরিয়ে দিন';

  @override
  String forecastNotifTitle(String day) {
    return '$day তারিখে টাকা কম পড়তে পারে';
  }

  @override
  String get settingsBillReminders => 'বিল ও কিস্তির রিমাইন্ডার';

  @override
  String get settingsBillRemindersSub =>
      'কার্ডের বিল, আর সামনের EMI বা সঞ্চয়ের কিস্তি';

  @override
  String get forecastNotifNowTitle => 'আজ আপনার টাকা কম পড়ছে';

  @override
  String forecastNotifNowBody(String amount) {
    return 'এখন যা পরিশোধ বাকি তা আপনার অ্যাকাউন্টের চেয়ে $amount বেশি। সামনে কী আছে দেখতে ট্যাপ করুন।';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'নির্ধারিত পেমেন্টের পর আপনার $amount কম পড়বে। সামনে কী আছে দেখতে ট্যাপ করুন।';
  }

  @override
  String get investmentsEmptyTitle => 'এখনও কোনো বিনিয়োগ নেই';

  @override
  String get investmentsEmptyBody =>
      'মিউচুয়াল ফান্ড, শেয়ার বা সোনা হিসাব রাখুন: কত দিয়েছেন, এখন দাম কত, আর লাভ কত।';

  @override
  String get investmentsSold => 'বিক্রি হয়ে গেছে';

  @override
  String get investmentsWorth => 'এখনকার মূল্য';

  @override
  String get investmentNew => 'নতুন বিনিয়োগ';

  @override
  String get investmentNewHint =>
      'ফান্ডের ইউনিট, কোনো কোম্পানির শেয়ার, বা ইউনিটে কেনা অন্য কিছু, যেমন গ্রামে সোনা।';

  @override
  String get investmentKindFund => 'ফান্ড';

  @override
  String get investmentKindStock => 'শেয়ার';

  @override
  String get investmentKindOther => 'অন্যান্য';

  @override
  String get investmentNameHintFund => 'যেমন ইউসিবি ইনকাম প্লাস ফান্ড';

  @override
  String get investmentNameHintStock => 'যেমন গ্রামীণফোন';

  @override
  String get investmentNameHintOther => 'যেমন সোনা, ২২ ক্যারেট';

  @override
  String get investmentSymbol => 'প্রতীক বা কোড (ঐচ্ছিক)';

  @override
  String get investmentFirstBuy => 'যা কিনেছেন';

  @override
  String get investmentFirstBuyHint =>
      'এখনই কিছু না কিনে যোগ করতে টাকার ঘর ফাঁকা রাখুন।';

  @override
  String get investmentPaid => 'দিয়েছেন';

  @override
  String get investmentReceived => 'পেয়েছেন';

  @override
  String get investmentPaidInto => 'যে হিসাবে জমা';

  @override
  String get investmentFee => 'ফি বা কমিশন';

  @override
  String get investmentUnits => 'ইউনিট';

  @override
  String get investmentUnitsSold => 'বিক্রি করা ইউনিট';

  @override
  String investmentUnitsShort(String units) {
    return '$units ইউনিট';
  }

  @override
  String investmentPerUnit(String price) {
    return 'প্রতি ইউনিট $price';
  }

  @override
  String get investmentNeedUnits => 'কত ইউনিট কেনা হয়েছে লিখুন।';

  @override
  String get investmentSave => 'বিনিয়োগ যোগ করুন';

  @override
  String get investmentAdded => 'বিনিয়োগ যোগ হয়েছে';

  @override
  String get investmentGone => 'এই বিনিয়োগটি মুছে ফেলা হয়েছে।';

  @override
  String get netWorthSubtitle =>
      'আপনার সব সম্পদ, দেনা বাদে, আর সময়ের সাথে তার ওঠানামা';

  @override
  String get netWorthToday => 'আপনার মোট সম্পদ';

  @override
  String netWorthSinceLastMonth(String amount) {
    return 'গত মাস থেকে $amount';
  }

  @override
  String get netWorthBreakdown => 'যা দিয়ে গঠিত';

  @override
  String get netWorthCash => 'নগদ ও ব্যাংক';

  @override
  String get netWorthCards => 'ক্রেডিট কার্ড';

  @override
  String get netWorthDeposits => 'সঞ্চয় আমানত';

  @override
  String get netWorthAssets => 'সম্পত্তি';

  @override
  String get netWorthLent => 'অন্যকে ধার দেওয়া';

  @override
  String get netWorthBorrowed => 'ধার নেওয়া';

  @override
  String get netWorthLoansNote =>
      'ধার দেওয়া টাকা ফেরত না আসা পর্যন্ত আপনারই ধরা হয়, আর ধার নেওয়া টাকা শোধ না করা পর্যন্ত আপনার দেনা হিসেবে বাদ যায়।';

  @override
  String get netWorthCardsLeftOut =>
      'ক্রেডিট কার্ড ধরা হয়নি; সেটিংসে এটি বদলাতে পারেন।';

  @override
  String get netWorthHistory => 'প্রতি মাসের শেষে';

  @override
  String get netWorthSixMonths => '৬ মাস';

  @override
  String get netWorthOneYear => '১ বছর';

  @override
  String get netWorthAllTime => 'সব';

  @override
  String get netWorthHistoryEmpty =>
      'আপনার হিসাবসহ একটি মাস শেষ হলে এখানে রেখা দেখা যাবে।';

  @override
  String get assetNew => 'সম্পত্তি যোগ করুন';

  @override
  String get assetNewHint =>
      'জমি, ফ্ল্যাট বা বাড়ি, গাড়ি, সোনা বা আপনার মালিকানার অন্য কিছু। এর মূল্য আপনার নেট সম্পদে ধরা হয়।';

  @override
  String get assetKind => 'ধরন';

  @override
  String get assetKindLand => 'জমি';

  @override
  String get assetKindHome => 'ফ্ল্যাট বা বাড়ি';

  @override
  String get assetKindCar => 'গাড়ি';

  @override
  String get assetKindGold => 'সোনা ও গয়না';

  @override
  String get assetKindOther => 'অন্য কিছু';

  @override
  String get assetNameHintLand => 'যেমন সাভারের প্লট';

  @override
  String get assetNameHintHome => 'যেমন মিরপুরের ফ্ল্যাট';

  @override
  String get assetNameHintCar => 'যেমন টয়োটা এক্সিও';

  @override
  String get assetNameHintGold => 'যেমন বিয়ের গয়না';

  @override
  String get assetNameHintOther => 'যেমন ক্যামেরা';

  @override
  String get assetWorthNow => 'এখনকার মূল্য';

  @override
  String get assetBoughtNow => 'একটি অ্যাকাউন্ট থেকে কেনা';

  @override
  String get assetBoughtNowHint =>
      'বন্ধ থাকলে: এটি আগে থেকেই আপনার, কোনো টাকা সরবে না।';

  @override
  String get assetSave => 'সম্পত্তি যোগ করুন';

  @override
  String get assetAdded => 'সম্পত্তি যোগ হয়েছে';

  @override
  String get assetsEmptyTitle => 'এখনো কোনো সম্পত্তি নেই';

  @override
  String get assetsEmptyBody =>
      'আপনার পুরো সম্পদ দেখতে জমি, বাড়ি, গাড়ি বা সোনা যোগ করুন।';

  @override
  String get assetsSold => 'বিক্রি হয়েছে';

  @override
  String assetCostLine(String amount) {
    return 'খরচ $amount';
  }

  @override
  String get assetUpdateValue => 'মূল্য হালনাগাদ করুন';

  @override
  String get assetSell => 'বিক্রি করুন';

  @override
  String get assetDelete => 'সরিয়ে দিন';

  @override
  String get assetValueUpdated => 'মূল্য হালনাগাদ হয়েছে';

  @override
  String get assetSold => 'বিক্রি হয়েছে, টাকা হিসাবে উঠেছে';

  @override
  String assetDeleteTitle(String name) {
    return '$name সরিয়ে দেবেন?';
  }

  @override
  String get assetDeleteBody =>
      'এটি আর ধরা হবে না। এর ইতিহাস আপনার হিসাবে থেকে যাবে।';

  @override
  String get assetDeleted => 'সম্পত্তি সরানো হয়েছে';

  @override
  String get aiActionCreateAssetTitle => 'সম্পত্তি যোগ';

  @override
  String get aiActionUpdateAssetTitle => 'সম্পত্তির মূল্য হালনাগাদ';

  @override
  String get aiActionSellAssetTitle => 'সম্পত্তি বিক্রি';

  @override
  String get investmentWorthNow => 'এখনকার মূল্য';

  @override
  String investmentGainLine(String gain) {
    return 'মোট $gain';
  }

  @override
  String get investmentPrice => 'দাম';

  @override
  String get investmentPutIn => 'বিনিয়োগ করেছেন';

  @override
  String get investmentTakenOut => 'তুলেছেন';

  @override
  String get investmentBuy => 'কিনুন';

  @override
  String get investmentSell => 'বিক্রি করুন';

  @override
  String investmentBuyTitle(String name) {
    return '$name কিনুন';
  }

  @override
  String investmentSellTitle(String name) {
    return '$name বিক্রি করুন';
  }

  @override
  String investmentDividendTitle(String name) {
    return '$name থেকে লভ্যাংশ';
  }

  @override
  String get investmentDividend => 'লভ্যাংশ';

  @override
  String get investmentRecordDividend => 'লভ্যাংশ লিখুন';

  @override
  String investmentHeldNow(String units) {
    return 'এখন $units ইউনিট আছে।';
  }

  @override
  String get investmentRecorded => 'লেখা হয়েছে';

  @override
  String get investmentUpdatePrice => 'দাম হালনাগাদ করুন';

  @override
  String get investmentUpdatePriceHint =>
      'আজকের এনএভি বা শেয়ারের দাম, এক ইউনিটের';

  @override
  String get investmentPriceUpdated => 'দাম হালনাগাদ হয়েছে';

  @override
  String get investmentStartSip => 'এসআইপি শুরু করুন';

  @override
  String get investmentStartSipHint =>
      'প্রতি মাসে নির্দিষ্ট টাকায় নিজে থেকেই কিনুন';

  @override
  String get investmentHistory => 'ইতিহাস';

  @override
  String investmentBought(String units) {
    return '$units ইউনিট কেনা';
  }

  @override
  String investmentSold(String units) {
    return '$units ইউনিট বিক্রি';
  }

  @override
  String get investmentPriceRose => 'দাম বেড়েছে';

  @override
  String get investmentPriceFell => 'দাম কমেছে';

  @override
  String get investmentUnitsUnknown => 'ইউনিট এখনও জানা নেই, যোগ করতে চাপুন';

  @override
  String get investmentCorrectUnits => 'এই লেনদেনের ইউনিট';

  @override
  String get investmentCorrectUnitsHint =>
      'আপনার ফান্ড বা ব্রোকারের স্টেটমেন্ট অনুযায়ী।';

  @override
  String get investmentUnitsCorrected => 'ইউনিট ঠিক করা হয়েছে';

  @override
  String get investmentDelete => 'এই বিনিয়োগ মুছুন';

  @override
  String investmentDeleteTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get investmentDeleteBody =>
      'এর লেনদেন ইতিহাসে থাকবে। সব বিক্রি হলে তবেই মোছা যাবে।';

  @override
  String get investmentDeleted => 'বিনিয়োগ মুছে ফেলা হয়েছে';

  @override
  String get plansSubtitle =>
      'ইএমআই, ঋণ, ডিপিএস, এফডিআর, বীমা, বন্ড ও এসআইপি, সময়মতো পরিশোধ ও জমা';

  @override
  String get planNew => 'নতুন পরিকল্পনা';

  @override
  String get planNewTitle => 'কী শুরু করছেন?';

  @override
  String get plansEmptyTitle => 'এখনো কোনো ইএমআই, ঋণ বা সঞ্চয় নেই';

  @override
  String get plansEmptyBody =>
      'কিস্তিতে কেনা জিনিস, ঋণ, ডিপিএস বা এফডিআর রাখুন। প্রতিটি কিস্তি তার দিনে লেখা হবে, আর আগেই মনে করিয়ে দেওয়া হবে।';

  @override
  String get plansEnded => 'শেষ হয়েছে';

  @override
  String get planKindEmi => 'ইএমআই';

  @override
  String get planKindLoan => 'ঋণ';

  @override
  String get planKindDps => 'ডিপিএস';

  @override
  String get planKindFdr => 'এফডিআর';

  @override
  String get planKindInsurance => 'বীমা';

  @override
  String get planKindBond => 'বন্ড বা সঞ্চয়পত্র';

  @override
  String get planKindSip => 'এসআইপি';

  @override
  String get planKindEmiHint =>
      'কিস্তিতে কেনা কিছু, নগদ, ব্যাংক অ্যাকাউন্ট বা কার্ড থেকে পরিশোধ';

  @override
  String get planKindLoanHint => 'ধার নেওয়া টাকা, সুদসহ কিস্তিতে ফেরত';

  @override
  String get planKindDpsHint =>
      'নির্দিষ্ট সময় ধরে প্রতি মাসে নির্দিষ্ট টাকা জমা, শেষে মুনাফাসহ ফেরত';

  @override
  String get planKindFdrHint =>
      'নির্দিষ্ট সময়ের জন্য ব্যাংকে একটি টাকা রাখা, মুনাফা মাসে মাসে, তিন মাসে বা শেষে';

  @override
  String get planKindInsuranceHint =>
      'প্রতি মাসে, তিন মাসে বা বছরে প্রিমিয়াম দেওয়া একটি পলিসি, আর থাকলে শেষে ফেরত';

  @override
  String get planKindBondHint =>
      'বন্ড বা সঞ্চয়পত্র: এককালীন টাকা কয়েক বছরের জন্য, কর কেটে মুনাফা প্রতি মাসে, তিন মাসে বা শেষে';

  @override
  String get planKindSipHint =>
      'প্রতি মাসে নির্দিষ্ট টাকা কোনো ফান্ড বা শেয়ারে, সর্বশেষ দামে কেনা';

  @override
  String get planWeekly => 'সাপ্তাহিক';

  @override
  String get planMonthly => 'মাসিক';

  @override
  String get planQuarterly => 'ত্রৈমাসিক';

  @override
  String get planHalfYearly => 'ষাণ্মাসিক';

  @override
  String get planYearly => 'বার্ষিক';

  @override
  String get planMonths => 'মাস';

  @override
  String get planYears => 'বছর';

  @override
  String planFdrLine(String amount, String date) {
    return '$date পর্যন্ত $amount';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$total এর মধ্যে $saved জমা';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$total এর মধ্যে $paid পরিশোধ';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'পরের: $date এ $amount';
  }

  @override
  String get planStatusCompleted => 'সম্পন্ন';

  @override
  String get planStatusClosed => 'বন্ধ';

  @override
  String get planStatusOverdue => 'সময় পেরিয়েছে';

  @override
  String get planStatusRunning => 'চলছে';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$total এর $done';
  }

  @override
  String get planGone => 'এই পরিকল্পনাটি মুছে ফেলা হয়েছে।';

  @override
  String get planAccount => 'অ্যাকাউন্ট';

  @override
  String get planAccountEmi => 'যেখান থেকে পরিশোধ';

  @override
  String get planAccountLoan => 'যেখানে পেয়েছেন ও যেখান থেকে পরিশোধ';

  @override
  String get planAccountSaving => 'যে অ্যাকাউন্ট থেকে';

  @override
  String get planPrice => 'দাম';

  @override
  String get planBorrowed => 'ধারের পরিমাণ';

  @override
  String get planDeposited => 'জমার পরিমাণ';

  @override
  String get planDeposit => 'প্রতি জমা';

  @override
  String get planInstallment => 'প্রতি কিস্তি';

  @override
  String get planWorkedOut => 'দাম, হার ও মেয়াদ থেকে হিসাব করা';

  @override
  String get planProgress => 'হয়েছে';

  @override
  String get planSavedSoFar => 'এখন পর্যন্ত জমা';

  @override
  String get planPaidSoFar => 'এখন পর্যন্ত পরিশোধ';

  @override
  String get planLeft => 'বাকি';

  @override
  String get planTotal => 'মোট';

  @override
  String get planInterestCharges => 'সুদ ও চার্জ';

  @override
  String get planRate => 'হার';

  @override
  String get planRateLabel => 'বার্ষিক হার %';

  @override
  String get planRateOptional => 'ঐচ্ছিক';

  @override
  String get planPayout => 'মুনাফা পাবেন';

  @override
  String get planPayoutMonthly => 'প্রতি মাসে';

  @override
  String get planPayoutQuarterly => 'প্রতি ৩ মাসে';

  @override
  String get planPayoutAtMaturity => 'শেষে';

  @override
  String get planMaturesOn => 'মেয়াদ শেষ';

  @override
  String get planMaturity => 'শেষে ফেরত';

  @override
  String get planEstimated =>
      'হার থেকে আনুমানিক; ব্যাংকের হিসাব দিতে ট্যাপ করুন';

  @override
  String get planHolding => 'এখন জমা আছে';

  @override
  String get planEnds => 'শেষ কিস্তি';

  @override
  String planTakeMaturity(String amount) {
    return 'মেয়াদপূর্তির টাকা নিন, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'মুনাফা লিখুন, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return '$number নম্বর কিস্তি এখন দিন, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'প্রিমিয়াম $number এখন দিন, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return '$number নম্বর জমা এখন দিন, $amount';
  }

  @override
  String get planRecorded => 'লেখা হয়েছে।';

  @override
  String get planSaved => 'সংরক্ষিত।';

  @override
  String get planPayOff => 'আগেই পুরো পরিশোধ';

  @override
  String get planEncash => 'আগেই ভাঙান';

  @override
  String get planSurrender => 'পলিসি সমর্পণ করুন';

  @override
  String planSurrenderTitle(String name) {
    return '$name সমর্পণ করবেন?';
  }

  @override
  String get planSurrenderBody =>
      'প্রিমিয়াম বন্ধ হবে। বীমা কোম্পানি যা ফেরত দেয় তা আয় হিসেবে লেখা হবে।';

  @override
  String get planSurrenderNothing => 'কিছু ফেরত পাইনি';

  @override
  String get planSurrenderValue => 'সমর্পণ মূল্য লিখুন';

  @override
  String get planSurrenderValueLabel => 'সমর্পণ মূল্য';

  @override
  String get planStopSip => 'এসআইপি বন্ধ করুন';

  @override
  String planStopSipTitle(String name) {
    return '$name বন্ধ করবেন?';
  }

  @override
  String get planStopSipBody =>
      'আর কেনা হবে না। যা কেনা হয়েছে তা বিনিয়োগেই থাকবে।';

  @override
  String get planSipStopped => 'এসআইপি বন্ধ হয়েছে';

  @override
  String get planSave => 'সংরক্ষণ';

  @override
  String get planSurrendered => 'পলিসি সমর্পণ করা হয়েছে';

  @override
  String planPayOffTitle(String name) {
    return '$name পুরো পরিশোধ করবেন?';
  }

  @override
  String get planPayOffHint => 'বাকিটা এক কিস্তিতে, তারপর পরিকল্পনা শেষ।';

  @override
  String planPayOffLeft(String amount) {
    return 'বাকিটা দিন, $amount';
  }

  @override
  String get planPayOffOther => 'ঋণদাতা অন্য পরিমাণ বলেছেন';

  @override
  String planEncashTitle(String name) {
    return '$name ভাঙাবেন?';
  }

  @override
  String get planEncashBody =>
      'জমার টাকা তার অ্যাকাউন্টে ফিরে যাবে, আর পরিকল্পনা শেষ হবে।';

  @override
  String get planEncashNoProfit => 'মুনাফা ছাড়া ভাঙান';

  @override
  String get planEncashWithProfit => 'ব্যাংকের দেওয়া মুনাফাসহ ভাঙান';

  @override
  String get planEncashed => 'ভাঙানো হয়েছে। টাকা অ্যাকাউন্টে ফিরেছে।';

  @override
  String get planPaidOff => 'পুরো পরিশোধ হয়েছে।';

  @override
  String get planAutoCollect => 'নিজে থেকে লিখুন';

  @override
  String get planAutoCollectHint =>
      'প্রতিটি কিস্তি, মুনাফা ও মেয়াদপূর্তি তার দিনে লেখা হবে';

  @override
  String get planSchedule => 'সময়সূচি';

  @override
  String get planDelete => 'এই পরিকল্পনা মুছুন';

  @override
  String planDeleteTitle(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get planDeleteBody =>
      'যা লেখা হয়েছে তা লেনদেনে থাকবে। আর কিছু লেখা বা মনে করানো হবে না।';

  @override
  String get planDeleted => 'মুছে ফেলা হয়েছে।';

  @override
  String planEventInstallment(int number, int total) {
    return '$total এর $number নম্বর কিস্তি';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'প্রিমিয়াম $number/$total';
  }

  @override
  String get planEventPayout => 'পলিসির টাকা ফেরত';

  @override
  String planEventProfit(int number) {
    return 'মুনাফা, $number মাস';
  }

  @override
  String get planEventMaturity => 'মেয়াদপূর্তি';

  @override
  String get planEventDone => 'হয়েছে';

  @override
  String get planEventLate => 'সময় পেরিয়েছে';

  @override
  String get planEventUpcoming => 'আসছে';

  @override
  String get planNeedAccount => 'আগে একটি অ্যাকাউন্ট বাছুন।';

  @override
  String get planCreated => 'শুরু হয়েছে। যা বকেয়া ছিল তা লেখা হয়েছে।';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, এর মধ্যে $interest সুদ ও চার্জ।';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, কোনো সুদ ছাড়া।';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'আপনি দেবেন $deposited, $date এ ফেরত পাবেন প্রায় $maturity।';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal বেড়ে $date এর মধ্যে প্রায় $maturity হবে।';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'প্রতি মাসে $profit মুনাফা, আর $date এ $principal ফেরত।';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$premium করে $countটি প্রিমিয়াম, মোট $total।';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$premium করে $countটি প্রিমিয়াম, মোট $total, আর $date এ $payout ফেরত।';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'প্রতি তিন মাসে $profit মুনাফা, আর $date এ $principal ফেরত।';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$fund-এ $amount করে $count বার, মোট $total।';
  }

  @override
  String planNewKind(String kind) {
    return 'নতুন $kind';
  }

  @override
  String get planName => 'নাম';

  @override
  String get planNameHintEmi => 'যেমন দারাজ থেকে ফোন';

  @override
  String get planNameHintLoan => 'যেমন বাইক লোন';

  @override
  String get planNameHintDps => 'যেমন ব্র্যাক ডিপিএস';

  @override
  String get planNameHintFdr => 'যেমন সিটি ব্যাংক এফডিআর';

  @override
  String get planNameHintInsurance => 'যেমন জীবন বীমা পলিসি';

  @override
  String get planNameHintBond => 'যেমন ৫ বছর মেয়াদি সঞ্চয়পত্র';

  @override
  String get planNameHintSip => 'যেমন মাসিক ফান্ড এসআইপি';

  @override
  String get planSipFund => 'যা কেনে';

  @override
  String get planSipAmount => 'প্রতি এসআইপি';

  @override
  String get planSipNoFund => 'আগে বিনিয়োগে ফান্ড বা শেয়ারটি যোগ করুন।';

  @override
  String get planProvider => 'ব্যাংক বা প্রতিষ্ঠান';

  @override
  String get planReference => 'পলিসি বা হিসাব নম্বর';

  @override
  String get planSumAssured => 'বীমার অঙ্ক';

  @override
  String get planPremium => 'প্রিমিয়াম';

  @override
  String get planPremiums => 'প্রিমিয়াম সংখ্যা';

  @override
  String get planTaxLabel => 'উৎসে কর %';

  @override
  String get planTax => 'উৎসে কর';

  @override
  String get planFirstPremium => 'প্রথম প্রিমিয়াম';

  @override
  String get planLastPremium => 'শেষ প্রিমিয়াম';

  @override
  String get planInsurancePayout => 'শেষে ফেরত';

  @override
  String get planNone => 'নেই';

  @override
  String get planHowMany => 'কতগুলো';

  @override
  String get planTerm => 'মেয়াদ';

  @override
  String get planOpenedOn => 'খোলার তারিখ';

  @override
  String get planFirstDue => 'প্রথম কিস্তি';

  @override
  String get planCategory => 'ক্যাটাগরি';

  @override
  String get planCategoryDefault => 'ঋণ পরিশোধ';

  @override
  String get planCategoryInsurance => 'বীমা';

  @override
  String get planLoanReceived => 'টাকা এই অ্যাকাউন্টে এসেছে';

  @override
  String get planLoanReceivedHint => 'সরাসরি বিক্রেতার কাছে গেলে বন্ধ রাখুন';

  @override
  String get planStart => 'শুরু করুন';

  @override
  String get aiActionDeleteNote =>
      'এটি সম্প্রতি মোছা তালিকায় যাবে, যেখান থেকে ৩০ দিন পর্যন্ত ফিরিয়ে আনতে পারবেন।';

  @override
  String get aiActionAdd => 'যোগ করুন';

  @override
  String get aiActionSave => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get aiActionDelete => 'মুছে ফেলুন';

  @override
  String get aiActionCancel => 'না, থাক';

  @override
  String get aiActionAmount => 'পরিমাণ';

  @override
  String get aiActionKind => 'ধরন';

  @override
  String get aiActionTitle => 'শিরোনাম';

  @override
  String get aiActionCategory => 'ক্যাটাগরি';

  @override
  String get aiActionAccount => 'অ্যাকাউন্ট';

  @override
  String get aiActionDate => 'তারিখ';

  @override
  String get aiActionNotes => 'নোট';

  @override
  String get aiReport => 'সমস্যা জানান';

  @override
  String get aiReportWrongAnswer => 'কোচ কিছু ভুল বলেছে';

  @override
  String get aiReportWrongAnswerHint =>
      'ভুল সংখ্যা, বানানো তথ্য, বা না চাওয়া কোনো পরিবর্তন';

  @override
  String get aiReportWrongAnswerSubject => 'মানি কোচ: ভুল উত্তর';

  @override
  String get aiReportBug => 'বাগ রিপোর্ট করুন';

  @override
  String get aiReportBugHint => 'কিছু ভেঙে গেছে, আটকে গেছে বা লোড হয়নি';

  @override
  String get aiReportBugSubject => 'মানি কোচ: বাগ রিপোর্ট';

  @override
  String get aiAboutCoach => 'কোচ কীভাবে কাজ করে';

  @override
  String get aiDisclaimerTitle => 'কোচকে প্রশ্ন করার আগে';

  @override
  String get aiDisclaimerMistakes =>
      'কোচ একটি এআই। এটি ভুল সংখ্যা দিতে পারে, প্রশ্ন ভুল বুঝতে পারে বা সত্য নয় এমন কিছু বলতে পারে, তাই গুরুত্বপূর্ণ কিছু নিজের লেনদেনের সাথে মিলিয়ে নিন।';

  @override
  String get aiDisclaimerData =>
      'আপনার হিসাব আপনার ফোনেই পড়া হয়। উত্তর দিতে অ্যাপটি আপনার প্রশ্ন ও প্রয়োজনীয় হিসাব আমাদের সার্ভার ও এর এআই মডেলে পাঠায়।';

  @override
  String get aiDisclaimerChanges =>
      'এটি নিজে থেকে কখনো আপনার হিসাব বদলায় না। প্রতিটি যোগ, পরিবর্তন বা মোছা আগে আপনাকে দেখানো হয় এবং আপনি নিশ্চিত করলেই হয়।';

  @override
  String get aiDisclaimerReport =>
      'কোনো উত্তর ভুল মনে হলে উপরের পতাকায় ট্যাপ করে আমাদের জানান।';

  @override
  String get aiDisclaimerAccept => 'বুঝেছি';

  @override
  String get aiOutOfRequestsTitle => 'এই মাসের বিনামূল্যের অনুরোধ শেষ';

  @override
  String get aiOutOfRequestsBody =>
      'এই প্রশ্নটি করতে একটি ছোট বিজ্ঞাপন দেখুন, অথবা বিজ্ঞাপন ছাড়া সীমাহীন উত্তরের জন্য প্রিমিয়াম নিন। ১ তারিখে বিনামূল্যের অনুরোধ আবার পাবেন।';

  @override
  String get ocrNoCamera => 'ক্যামেরা খোলা যায়নি।';

  @override
  String get ocrNoGallery => 'গ্যালারি খোলা যায়নি।';

  @override
  String get ocrScanTitle => 'রসিদ স্ক্যান করুন';

  @override
  String get ocrScanAnother => 'আরেকটি স্ক্যান করুন';

  @override
  String get ocrScanBody =>
      'ছবি তুলুন বা বেছে নিন। অ্যাপ এটি পড়বে এবং এআই বিস্তারিত পূরণ করবে।';

  @override
  String get ocrReadingWithAi => 'এআই আপনার রসিদ পড়ছে…';

  @override
  String get ocrNothingRead =>
      'ছবি থেকে কোনো লেখা পড়া যায়নি। ভালো আলোতে পুরো রসিদটি রেখে আবার চেষ্টা করুন।';

  @override
  String get ocrAiOfferTitle => 'এআই দিয়ে ঠিকভাবে পড়ান';

  @override
  String get ocrAiOfferBody =>
      'এলোমেলো রসিদ থেকেও এটি আসল মোট, তারিখ, প্রতিটি আইটেম ও সঠিক ক্যাটাগরি খুঁজে নেয়।';

  @override
  String get ocrReadWithAi => 'এআই দিয়ে পড়ুন';

  @override
  String get ocrReadByAi => 'এআই পড়েছে। সেভ করার আগে মিলিয়ে নিন।';

  @override
  String get ocrItems => 'আইটেম';

  @override
  String get quickAddTitle => 'লিখে বলুন';

  @override
  String get quickAddSubtitle =>
      'যেভাবে বলেন সেভাবে লিখুন। এআই ফর্মটি পূরণ করবে, আপনি মিলিয়ে নেবেন।';

  @override
  String get quickAddHint => 'যেমন: গতকাল বিকাশ থেকে দুপুরের খাবার ২৫০';

  @override
  String get quickAddFill => 'পূরণ করুন';

  @override
  String get summaryTitle => 'মাসিক সারাংশ';

  @override
  String get summarySpent => 'এই মাসে খরচ';

  @override
  String summaryEarned(String amount) {
    return 'আয় $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return 'গত মাসের চেয়ে $percent% কম';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return 'গত মাসের চেয়ে $percent% বেশি';
  }

  @override
  String get summaryAiTitle => 'এক নজরে আপনার মাস';

  @override
  String get summaryAiBody =>
      'এআই আপনার এই মাসকে গত মাসের সাথে মিলিয়ে উল্লেখযোগ্য বিষয়গুলো তুলে ধরে, সাথে একটি পরামর্শ দেয়।';

  @override
  String get summaryWrite => 'আমার সারাংশ লিখুন';

  @override
  String get summaryWriting => 'আপনার সারাংশ লেখা হচ্ছে…';

  @override
  String get summaryByCategory => 'ক্যাটাগরি অনুযায়ী';

  @override
  String get summaryNoSpending => 'এই মাসে এখনো কোনো খরচ লেখা হয়নি।';

  @override
  String themeTrialUntil(String time) {
    return '$time পর্যন্ত প্রিমিয়াম থিম আনলক';
  }

  @override
  String get zakatTitle => 'যাকাত';

  @override
  String get zakatSubtitle =>
      'আপনার সম্পদে কত যাকাত দিতে হবে হিসাব করুন, আর যা দিলেন তা লিখে রাখুন';

  @override
  String get zakatSubtitleOff => 'আপনি যাকাত দেন না। তবুও দেখতে ট্যাপ করুন';

  @override
  String get zakatAskTitle => 'আপনি কি যাকাত দেন?';

  @override
  String get zakatAskBody =>
      'সবাই দেন না। না দিলে অ্যাপ যাকাত নিয়ে কিছু দেখাবে না: কোনো বকেয়া নেই, কোনো রিমাইন্ডারও নেই।';

  @override
  String get zakatIPay => 'আমি যাকাত দিই';

  @override
  String get zakatIDontPay => 'আমি যাকাত দিই না';

  @override
  String get zakatOffTitle => 'আপনি যাকাত দেন না';

  @override
  String get zakatOffBody =>
      'তাই যাকাত বকেয়া হিসেবে কিছু দেখানো হবে না, কোনো যাকাত রিমাইন্ডারও আসবে না। চাইলে যেকোনো সময় হিসাবটা দেখতে পারবেন; দেখলে আপনার উত্তর বদলাবে না।';

  @override
  String get zakatOffPeek => 'হিসাবটা কত হতো দেখুন';

  @override
  String get zakatPeekBanner => 'শুধু দেখছেন। আপনি বলেছেন যাকাত দেন না।';

  @override
  String get zakatOptOutTitle => 'যাকাত হিসাব বন্ধ করবেন?';

  @override
  String get zakatOptOutBody =>
      'কোনো বকেয়া দেখানো হবে না, যাকাত রিমাইন্ডারও আসবে না। আপনার হিসাব থেকে যাবে, যেকোনো সময় এখানে দেখতে পারবেন।';

  @override
  String get zakatDue => 'দেয় যাকাত';

  @override
  String zakatAboveNisab(String amount) {
    return 'নিসাবের ওপরে: নিট সম্পদ $amount-এর ২.৫%';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'নিসাবের চেয়ে $amount কম, তাই যাকাত দিতে হবে না';
  }

  @override
  String get zakatNeedPrice => 'নিসাব যাচাই করতে প্রতি গ্রামের দাম লিখুন';

  @override
  String get zakatPaidSoFar => 'এ বছর দেওয়া হয়েছে';

  @override
  String get zakatLeftToPay => 'দিতে বাকি';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'যাকাতের তারিখ $date, আর $days দিন পর',
      one: 'আগামীকাল যাকাতের তারিখ, $date',
      zero: 'আজ আপনার যাকাতের তারিখ',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'বছরের হিসাব রাখতে ও মনে করিয়ে দিতে আপনার যাকাতের তারিখ ঠিক করুন';

  @override
  String get zakatPay => 'যাকাত দিন';

  @override
  String get zakatNisab => 'নিসাব';

  @override
  String get zakatBasisGold => 'সোনা';

  @override
  String get zakatBasisSilver => 'রুপা';

  @override
  String get zakatBasisHint =>
      'রুপার নিসাব কম, তাই সম্পদ বেশিরভাগ নগদ হলে এটিই বেশি সতর্ক পছন্দ। এক গ্রামের আজকের স্থানীয় দাম লিখুন।';

  @override
  String zakatPricePerGram(String metal) {
    return 'প্রতি গ্রামের দাম ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return 'ওই দামে $grams গ্রাম';
  }

  @override
  String get zakatGroupCash => 'নগদ ও ব্যাংক';

  @override
  String get zakatGroupDeposits => 'সঞ্চয় আমানত';

  @override
  String get zakatGroupInvestments => 'বিনিয়োগ';

  @override
  String get zakatGroupMetals => 'সোনা ও রুপা';

  @override
  String get zakatGroupLent => 'অন্যকে দেওয়া ধার';

  @override
  String get zakatGroupOtherAssets => 'অন্যান্য সম্পদ';

  @override
  String get zakatGroupPaid => 'এ বছর দেওয়া যাকাত';

  @override
  String get zakatGroupManual => 'আপনার যোগ করা';

  @override
  String get zakatGroupBorrowed => 'বাদ: আপনার নেওয়া ধার';

  @override
  String get zakatGroupCards => 'বাদ: ক্রেডিট কার্ডের বকেয়া';

  @override
  String get zakatOtherAssetsNote =>
      'নিজের ব্যবহারের জমি, বাড়ি বা গাড়িতে যাকাত নেই। ব্যবসার জন্য রাখলে তবেই চালু করুন।';

  @override
  String get zakatPaidNote =>
      'আবার যোগ করা হয়েছে, কারণ বছরের সম্পদ হিসাবের পরে এটি আপনার অ্যাকাউন্ট থেকে গেছে।';

  @override
  String get zakatNoMetals =>
      'কোনো সোনা বা রুপা লেখা নেই। সম্পদ হিসেবে যোগ করুন, অথবা নিচে এর মূল্য যোগ করুন।';

  @override
  String get zakatAddAmount => 'একটি পরিমাণ যোগ করুন';

  @override
  String get zakatAmountLabel => 'এটি কী?';

  @override
  String get zakatAmountHint => 'ব্যবসার মাল, ঘরে রাখা নগদ…';

  @override
  String get zakatAmountDeduct => 'এটি এখন পরিশোধযোগ্য দেনা';

  @override
  String get zakatWealth => 'যাকাতযোগ্য সম্পদ';

  @override
  String get zakatDeductions => 'এখন পরিশোধযোগ্য দেনা';

  @override
  String get zakatNet => 'নিট সম্পদ';

  @override
  String get zakatRate => 'নিট সম্পদের ২.৫%';

  @override
  String get zakatYear => 'যাকাতের বছর';

  @override
  String get zakatDate => 'যাকাতের তারিখ';

  @override
  String get zakatDateHint =>
      'যেদিন আপনার যাকাতের বছর পূর্ণ হয়। প্রতি চান্দ্র বছরে, ৩৫৪ দিন পরপর, এটি ফিরে আসে।';

  @override
  String get zakatRemind => 'মনে করিয়ে দিন';

  @override
  String get zakatRemindHint => '৩ দিন আগে, এবং সেদিন';

  @override
  String get zakatDisclaimer =>
      'এটি যাকাত হিসাবের একটি সহায়িকা, কোনো ধর্মীয় ফতোয়া নয়। কিছু বিষয়ে আলেমদের মতভেদ আছে; নিশ্চিত না হলে স্থানীয় একজন আলেমকে জিজ্ঞেস করুন।';

  @override
  String get zakatPayNote =>
      'যাকাত ক্যাটাগরিতে খরচ হিসেবে লেখা হবে, আর এ বছরের হিসাবে ধরা হবে।';

  @override
  String get zakatPayRecord => 'পরিশোধ লিখুন';

  @override
  String get zakatPaidSnack => 'যাকাত লেখা হয়েছে';

  @override
  String get aiToolZakat => 'যাকাতের হিসাব হচ্ছে…';

  @override
  String get voiceButton => 'লেনদেন বলুন';

  @override
  String get voiceTitle => 'বলে দিন';

  @override
  String get voiceUnlimited => 'সীমাহীন';

  @override
  String get voiceTapToTalk => 'গোলকটিতে চাপ দিয়ে খরচের কথা বলুন';

  @override
  String get voiceListening => 'শুনছি…';

  @override
  String get voiceStop => 'শোনা বন্ধ করুন';

  @override
  String get voiceTypeInstead => 'লিখুন';

  @override
  String get voiceSpeakInstead => 'বলুন';

  @override
  String get voiceSend => 'হয়েছে';

  @override
  String get voiceTrySaying => 'এভাবে বলে দেখুন';

  @override
  String get voiceExample1 => 'দুপুরের খাবার ২৫০, রিকশা ৬০';

  @override
  String get voiceExample2 => 'বেতন পেয়েছি ৪৫,০০০';

  @override
  String get voiceExample3 => 'গতকালের চা ২০ না, ৩০ ছিল';

  @override
  String get voiceExample4 => 'আজকের দুপুরের খাবারটা মুছে দাও';

  @override
  String get voiceTypeHint => 'দুপুরের খাবার ২৫০, বিকাশ থেকে রিকশা ৬০';

  @override
  String get voiceThinking => 'বুঝে নিচ্ছি…';

  @override
  String get voiceTryAgain => 'আবার';

  @override
  String get voiceSaving => 'সংরক্ষণ হচ্ছে…';

  @override
  String get voiceEdit => 'বদলান';

  @override
  String get voiceNeedsYou => 'আপনাকে দেখতে হবে';

  @override
  String get voiceNew => 'নতুন';

  @override
  String get voiceChange => 'পরিবর্তন';

  @override
  String get voiceRemove => 'মুছুন';

  @override
  String get voiceNeedsAmount =>
      'টাকার পরিমাণ বলা হয়নি। যোগ করতে পরিমাণটি লিখুন।';

  @override
  String get voiceAdjust => 'ঠিক করুন';

  @override
  String get voiceFillIn => 'পূরণ করুন';

  @override
  String get voiceTime => 'সময়';

  @override
  String get voiceUndo => 'ফিরিয়ে নিন';

  @override
  String get voiceUndone => 'আগের মতো করা হয়েছে';

  @override
  String get voiceNoSpeech => 'শুনতে পাইনি। আবার বলুন, অথবা লিখে দিন।';

  @override
  String get voiceMicOff =>
      'মাইক্রোফোনের অনুমতি বন্ধ। সেটিংসে চালু করুন, অথবা লিখে দিন।';

  @override
  String get voiceUnavailable => 'এই ফোনে ভয়েস চলে না। আপনি লিখে দিতে পারেন।';

  @override
  String get voiceSomethingWrong => 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get voiceFabSetting => 'আজকের পাতায় ভাসমান মাইক';

  @override
  String get voiceFabSettingSub =>
      'আজকের পাতায় ভেসে থাকা একটি মাইক, লেনদেন বলে দেওয়ার জন্য';

  @override
  String get voiceFabAskTitle => 'আজকের পাতায় একটি মাইক রাখবেন?';

  @override
  String get voiceFabAskBody =>
      'চাপ দিয়ে খরচের কথা বলুন, যেমন \"দুপুরের খাবার ২৫০ আর রিকশা ৬০\"। সংরক্ষণের আগে সব আপনি দেখে নেবেন। যেখানে খুশি টেনে সরাতে পারবেন।';

  @override
  String get voiceFabAskYes => 'হ্যাঁ, মাইক রাখুন';

  @override
  String get voiceFabAskNo => 'এখন না';

  @override
  String get voiceFabAskLater =>
      'আরও অংশ থেকে যেকোনো সময় চালু বা বন্ধ করতে পারবেন।';

  @override
  String get voiceFabHideTitle => 'ভাসমান মাইক লুকাবেন?';

  @override
  String get voiceFabHideBody =>
      'আজকের পাতার উপরের মাইকটি থাকবে। এটি আরও অংশ থেকে আবার ফিরিয়ে আনতে পারবেন।';

  @override
  String get voiceFabHide => 'লুকান';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সংরক্ষণের জন্য $countটি প্রস্তুত',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সংরক্ষণ করুন',
      zero: 'কিছু বাছাই করা নেই',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন সংরক্ষিত',
    );
    return '$_temp0';
  }
}
