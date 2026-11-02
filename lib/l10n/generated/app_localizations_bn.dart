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
  String get catNoSubcategoriesYet =>
      'এখনো কোনো সাব-ক্যাটাগরি নেই। একটি যোগ করুন';

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
  String get statsPeriodLast7Days => 'গত ৭ দিন';

  @override
  String get statsPeriodThisMonth => 'এই মাস';

  @override
  String get statsPeriodThisYear => 'এই বছর';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন',
    );
    return '$period · $_temp0';
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
  String get forecastEventWhen => 'কবে';

  @override
  String get forecastEventKind => 'ধরন';

  @override
  String get forecastEventAccount => 'অ্যাকাউন্ট';

  @override
  String get forecastEventOpen => 'খুলুন';

  @override
  String get forecastEventOverdueNote =>
      'তারিখ পার হয়ে গেছে কিন্তু এখনো বাকি, তাই আজকের পাওনা হিসেবে ধরা হয়েছে।';

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
  String get settingsBillRemindersNote =>
      'কার্ডের বিল আর প্ল্যানের কিস্তির রিমাইন্ডার আপনার ফোনেই অ্যাপ হিসাব করে, তাই আপনার টাকার অঙ্ক গোপন থাকে। কয়েক দিন অ্যাপ না খুললে কোনো রিমাইন্ডার দেরিতে আসতে পারে বা বাদ পড়তে পারে।';

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
  String get summaryOutdated => 'এই সারাংশ লেখার পর আপনার লেনদেন বদলেছে।';

  @override
  String get summaryUpdate => 'সারাংশ হালনাগাদ করুন';

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
  String get voiceNeedsConnection =>
      'ভয়েসের জন্য ইন্টারনেট সংযোগ লাগে। চাইলে টাইপ করতে পারেন।';

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
  String get amountHidden => 'লুকানো পরিমাণ';

  @override
  String get privacyShowAmounts => 'পরিমাণ দেখান';

  @override
  String get privacyHideAmounts => 'পরিমাণ লুকান';

  @override
  String get privacyAmounts => 'স্ক্রিনে পরিমাণ';

  @override
  String get privacyAmountsFooter =>
      'ব্যালেন্স আর মোট হিসাব ঝাপসা থাকে, যাতে আশেপাশের কেউ পড়তে না পারে। আলাদা লেনদেনগুলো দেখা যায়। আজকের পাতার চোখ আইকন দিয়েও দেখানো বা লুকানো যায়।';

  @override
  String get privacyHideTitle => 'ব্যালেন্স ও মোট হিসাব লুকান';

  @override
  String get privacyHideSub => 'আপনি না দেখানো পর্যন্ত ঝাপসা থাকবে';

  @override
  String get privacyTapTitle => 'লুকানো পরিমাণে চাপ দিলে দেখাবে';

  @override
  String get privacyTapSub => 'নইলে শুধু আজকের পাতার চোখ আইকন দিয়ে দেখা যাবে';

  @override
  String get privacyStartTitle => 'অ্যাপ খুললে';

  @override
  String get privacyStartHidden => 'লুকানো';

  @override
  String get privacyStartHiddenSub =>
      'সবসময় ব্যালেন্স ও মোট হিসাব লুকিয়ে খুলবে';

  @override
  String get privacyStartShown => 'দেখানো';

  @override
  String get privacyStartShownSub =>
      'সবসময় ব্যালেন্স ও মোট হিসাব দেখিয়ে খুলবে';

  @override
  String get privacyStartRemember => 'যেমন রেখেছিলাম';

  @override
  String get privacyStartRememberSub => 'চোখ আইকন শেষবার যেমন ছিল তেমন খুলবে';

  @override
  String get privacyIntroTitle => 'নতুন: ব্যালেন্স লুকান';

  @override
  String get privacyIntroBody =>
      'ব্যালেন্স ও মোট হিসাব এখন লুকানো থাকে, যাতে আশেপাশের কেউ পড়তে না পারে। আজকের পাতার চোখ আইকনে চাপ দিয়ে দেখান বা লুকান; আপনি যেমন রাখবেন অ্যাপ তা মনে রাখবে। অ্যাপ কীভাবে খুলবে তা সেটিংসে বেছে নিতে পারবেন।';

  @override
  String get privacyIntroOk => 'বুঝেছি';

  @override
  String get privacyIntroSettings => 'সেটিংসে বেছে নিন';

  @override
  String get ppTitle => 'পাসফ্রেজ সুরক্ষা';

  @override
  String get ppRowOn => 'চালু';

  @override
  String get ppRowOff => 'বন্ধ';

  @override
  String get ppRowLocked => 'এই ফোনে লক করা';

  @override
  String get ppIntro =>
      'আপনার ডেটা এই ফোনে এবং আপনার ব্যাকআপে আগে থেকেই এনক্রিপ্ট করা আছে। পাসফ্রেজ আরও একটি তালা যোগ করে, যাতে আপনার সিঙ্ক করা ডেটা ও ব্যাকআপ শুধু আপনিই খুলতে পারেন — এমনকি আমরাও না।';

  @override
  String get ppWithoutTitle => 'পাসফ্রেজ ছাড়া (এখন যেমন আছে)';

  @override
  String get ppWithout1 => 'এই ফোনের সবকিছু এনক্রিপ্ট করা।';

  @override
  String get ppWithout2 =>
      'ব্যাকআপ ও সিঙ্ক করা ডেটা আপনার অ্যাকাউন্টের সাথে যুক্ত একটি কী দিয়ে এনক্রিপ্ট করা।';

  @override
  String get ppWithout3 =>
      'নতুন ফোনে সাইন ইন করলেই সবকিছু ফিরে আসে, কিছুই মনে রাখতে হয় না।';

  @override
  String get ppWithout4 =>
      'সেই কী আমাদের সার্ভারে থাকে, তাই নীতিগতভাবে আমরা আপনার সিঙ্ক করা ডেটা খুলতে পারি।';

  @override
  String get ppWithTitle => 'পাসফ্রেজ থাকলে';

  @override
  String get ppWith1 =>
      'শুধু আপনার পাসফ্রেজ বা রিকভারি কোড দিয়েই আপনার সিঙ্ক করা ডেটা ও ব্যাকআপ খোলা যায়।';

  @override
  String get ppWith2 =>
      'আমাদের সার্ভারে আপনার কী-এর শুধু লক করা কপি থাকে। আমরা আপনার ডেটা পড়তে পারি না, আর আমাদের সার্ভারে কেউ অনুপ্রবেশ করলেও সে পারবে না।';

  @override
  String get ppWith3 =>
      'নতুন ফোনে, বা আবার ইনস্টল করার পর, একবার আপনার পাসফ্রেজ লিখতে হবে।';

  @override
  String get ppWith4 => 'এই ফোন এখন যেমন চলছে ঠিক তেমনই চলবে, অফলাইনেও।';

  @override
  String get ppCatchTitle => 'যা জেনে রাখা জরুরি';

  @override
  String get ppCatchBody =>
      'আপনি যদি পাসফ্রেজ ভুলে যান এবং রিকভারি কোডও হারিয়ে ফেলেন, তাহলে আপনার সিঙ্ক করা ডেটা বা ব্যাকআপ কেউই ফিরিয়ে আনতে পারবে না — আমরাও না, অন্য কেউও না। এই ফোনে যা আগে থেকে আছে, তা এখানে পড়া যাবে।';

  @override
  String get ppAiNote =>
      'এআই ফিচারগুলো উত্তর দেওয়ার জন্য এখনও আপনার আর্থিক তথ্যের একটি সারাংশ পাঠায়। পাসফ্রেজ এতে কোনো পরিবর্তন আনে না।';

  @override
  String get ppSetButton => 'পাসফ্রেজ সেট করুন';

  @override
  String get ppSetTitle => 'একটি পাসফ্রেজ বেছে নিন';

  @override
  String get ppSetHint =>
      'অন্তত ১০টি অক্ষর ব্যবহার করুন। পরস্পর সম্পর্কহীন কয়েকটি শব্দ মনে রাখা সহজ, কিন্তু অনুমান করা কঠিন।';

  @override
  String get ppPassphraseLabel => 'পাসফ্রেজ';

  @override
  String get ppConfirmLabel => 'আবার লিখুন';

  @override
  String get ppTooShort => 'অন্তত ১০টি অক্ষর ব্যবহার করুন।';

  @override
  String get ppMismatch => 'দুটি পাসফ্রেজ মিলছে না।';

  @override
  String get ppUnderstand =>
      'আমি বুঝেছি যে পাসফ্রেজ ও রিকভারি কোড দুটোই হারালে আমার সিঙ্ক করা ডেটা ও ব্যাকআপ আর ফিরিয়ে আনা যাবে না।';

  @override
  String get ppTurnOn => 'সুরক্ষা চালু করুন';

  @override
  String get ppWorking => 'আপনার কী লক করা হচ্ছে। এতে কয়েক সেকেন্ড লাগে…';

  @override
  String get ppMaybeSaved =>
      'সংযোগ বিচ্ছিন্ন হয়েছে, তাই সার্ভার হয়তো এটি আগেই সেভ করেছে। রিকভারি কোড না দেখা পর্যন্ত আবার করুন, আর সেই কোডটিই রেখে দিন।';

  @override
  String get ppRecoveryTitle => 'আপনার রিকভারি কোড';

  @override
  String get ppRecoveryBody =>
      'পাসফ্রেজ ভুলে গেলে আপনার ডেটায় ঢোকার এটিই একমাত্র বিকল্প উপায়। এটি লিখে রাখুন বা কোনো পাসওয়ার্ড ম্যানেজারে রাখুন — এই ফোন ছাড়া অন্য কোথাও।';

  @override
  String get ppCopy => 'কপি করুন';

  @override
  String get ppCopied => 'রিকভারি কোড কপি হয়েছে';

  @override
  String get ppSavedIt => 'আমি রিকভারি কোডটি নিরাপদ কোনো জায়গায় রেখেছি';

  @override
  String get ppDone => 'সম্পন্ন';

  @override
  String get ppOnTitle => 'সুরক্ষা চালু আছে';

  @override
  String get ppOnBody =>
      'শুধু আপনার পাসফ্রেজ বা রিকভারি কোড দিয়েই আপনার সিঙ্ক করা ডেটা ও ব্যাকআপ খোলা যায়।';

  @override
  String get ppChange => 'পাসফ্রেজ বদলান';

  @override
  String get ppNewCode => 'নতুন রিকভারি কোড নিন';

  @override
  String get ppNewCodeWarn =>
      'আপনার বর্তমান রিকভারি কোড আর কাজ করবে না। নতুনটি অবশ্যই সংরক্ষণ করে রাখুন।';

  @override
  String get ppTurnOff => 'সুরক্ষা বন্ধ করুন';

  @override
  String get ppTurnOffBody =>
      'আগের মতো আমাদের সার্ভার আবার আপনার কী রাখবে। আপনার ডেটা এনক্রিপ্ট করাই থাকবে, তবে নীতিগতভাবে আমরা আপনার সিঙ্ক করা ডেটা খুলতে পারব।';

  @override
  String get ppLockedTitle => 'আপনার ডেটা আনলক করুন';

  @override
  String get ppLockedBody =>
      'আপনার ডেটা পাসফ্রেজ দিয়ে সুরক্ষিত। আপনার সিঙ্ক করা ডেটা ও ব্যাকআপ খুলতে এই ফোনে একবার এটি লিখুন।';

  @override
  String get ppUnlock => 'আনলক করুন';

  @override
  String get ppUseRecovery => 'এর বদলে আমার রিকভারি কোড ব্যবহার করুন';

  @override
  String get ppUsePassphrase => 'এর বদলে আমার পাসফ্রেজ ব্যবহার করুন';

  @override
  String get ppRecoveryLabel => 'রিকভারি কোড';

  @override
  String get ppWrongPassphrase => 'পাসফ্রেজটি সঠিক নয়।';

  @override
  String get ppWrongRecovery => 'রিকভারি কোডটি সঠিক নয়।';

  @override
  String get ppUnlocked => 'এই ফোনে আনলক হয়েছে';

  @override
  String get ppChanged => 'পাসফ্রেজ বদলানো হয়েছে';

  @override
  String get ppTurnedOn => 'সুরক্ষা চালু হয়েছে';

  @override
  String get ppTurnedOff => 'সুরক্ষা বন্ধ হয়েছে';

  @override
  String get encIntroTitle => 'আপনার ডেটা এখন এনক্রিপ্টেড';

  @override
  String get encIntroBody =>
      'এই ফোনের সবকিছু এনক্রিপ্ট করে রাখা হয়, আর আপনার ব্যাকআপ ও সিঙ্ক করা ডেটা ফোন থেকে বের হওয়ার আগেই এনক্রিপ্ট হয়। আপনাকে কিছুই করতে হবে না।';

  @override
  String get encIntroPassphrase =>
      'আরও একটা তালা চান? একটি পাসফ্রেজ দিন, তাহলে সিঙ্ক করা ডেটা ও ব্যাকআপ শুধু আপনিই খুলতে পারবেন — আমরাও না। এটা ঐচ্ছিক; পাসফ্রেজ আর তার রিকভারি কোড দুটোই হারালে সেই ডেটা আর ফেরত পাওয়া যাবে না।';

  @override
  String get encIntroSetUp => 'পাসফ্রেজ সেট করুন';

  @override
  String get encIntroNotNow => 'এখন না';

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

  @override
  String get ppNeedsConnection =>
      'পাসফ্রেজ সেটিংসের জন্য ইন্টারনেট সংযোগ লাগে। কোনো নেটওয়ার্কে যুক্ত হয়ে আবার খুলুন।';

  @override
  String get offlineToast =>
      'আপনি অফলাইনে আছেন। যা যোগ করবেন সব এই ফোনে সেভ থাকবে, আবার অনলাইনে এলে সিঙ্ক হবে।';

  @override
  String get backupLockedTitle => 'এই ব্যাকআপটি আনলক করুন';

  @override
  String get backupLockedBody =>
      'এই ব্যাকআপটি একটি পাসফ্রেজ দিয়ে সুরক্ষিত। খুলতে সেটি বা আপনার রিকভারি কোড দিন। এটি ইন্টারনেট সংযোগ ছাড়াও কাজ করে।';

  @override
  String get settingsSupportDescribeFirst =>
      'অনুগ্রহ করে আগে আপনার সমস্যাটি লিখুন';

  @override
  String get settingsSupportSent => 'ধন্যবাদ! আপনার বার্তা পাঠানো হয়েছে।';

  @override
  String get settingsSupportSendFailed =>
      'এখন পাঠানো যায়নি। আবার চেষ্টা করুন বা সরাসরি আমাদের ইমেইল করুন।';

  @override
  String get settingsSupportSubjectHint => 'বিষয়টি কী নিয়ে?';

  @override
  String get settingsSupportMessageHint =>
      'আপনার প্রশ্ন, সমস্যা বা মতামত লিখুন…';

  @override
  String get settingsSupportHeroBody =>
      'প্রশ্ন, বাগ বা মতামত — পাঠিয়ে দিন, আমরা আপনাকে জানাব।';

  @override
  String get settingsSupportTipDescription =>
      'আপনার সমস্যার একটি পরিষ্কার বিবরণ';

  @override
  String get settingsSupportTipSteps =>
      'সমস্যাটি আবার ঘটানোর ধাপ (যদি বাগ হয়)';

  @override
  String get settingsSupportTipDevice => 'আপনার ডিভাইসের মডেল ও Android ভার্সন';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'ইমেইল পছন্দ? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'ইমেইল ক্লিপবোর্ডে কপি হয়েছে';

  @override
  String get settingsAboutTagline => 'আপনার ব্যক্তিগত অর্থ-সহায়ক';

  @override
  String settingsAboutVersion(String version) {
    return 'ভার্সন: $version';
  }

  @override
  String get settingsAboutDescription =>
      'গোপনীয়তা ও সুন্দর UI/UX-এর ওপর\nজোর দেওয়া একটি ব্যক্তিগত অর্থ অ্যাপ।';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'মূল মুদ্রা: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'সর্বশেষ আপডেট: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'রেট সম্পাদনা: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'বর্তমান API রেট: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String settingsHoursAgo(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String settingsDaysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String get settingsExportSectionDateRange => 'তারিখের পরিসর';

  @override
  String get settingsExportSectionFormat => 'ফরম্যাট';

  @override
  String get settingsExportSectionInclude => 'অন্তর্ভুক্ত করুন';

  @override
  String get settingsExportAllTime => 'সব সময়';

  @override
  String get settingsExportThisMonth => 'এই মাস';

  @override
  String get settingsExportLastMonth => 'গত মাস';

  @override
  String get settingsExportLast3Months => 'গত ৩ মাস';

  @override
  String get settingsExportThisYear => 'এই বছর';

  @override
  String get settingsExportPdfPremiumBody =>
      'CSV রপ্তানি বিনামূল্যে — আপনার ডেটা সবসময় আপনার। সারাংশ এবং ক্যাটাগরি ও ওয়ালেটভিত্তিক বিভাজনসহ সাজানো PDF রিপোর্ট একটি প্রিমিয়াম ফিচার।';

  @override
  String settingsExportButton(String format) {
    return '$format রপ্তানি করুন';
  }

  @override
  String settingsExportFailed(String error) {
    return 'রপ্তানি ব্যর্থ হয়েছে: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - রপ্তানি';

  @override
  String settingsExportedCount(int count) {
    return '$countটি লেনদেন রপ্তানি করা হয়েছে';
  }

  @override
  String get settingsExportPdfShareSubject => 'The Accountant - আর্থিক রিপোর্ট';

  @override
  String settingsExportPdfGenerated(int count) {
    return '$countটি লেনদেন নিয়ে PDF রিপোর্ট তৈরি হয়েছে';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'হাজারের জন্য কমা';

  @override
  String get settingsNumberFormatDotThousands => 'হাজারের জন্য ডট';

  @override
  String get settingsNumberFormatSpaceThousands => 'হাজারের জন্য স্পেস';

  @override
  String get settingsNumberFormatNoSeparator => 'কোনো বিভাজক নেই';

  @override
  String get settingsAutoLockImmediately => 'সঙ্গে সঙ্গে';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট',
      one: '১ মিনিট',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'কখনো না';

  @override
  String get settingsBiometricUnavailable =>
      'এই ডিভাইসে বায়োমেট্রিক যাচাই উপলভ্য নয়';

  @override
  String get settingsSetPassword => 'পাসওয়ার্ড সেট করুন';

  @override
  String get settingsChangePassword => 'পাসওয়ার্ড বদলান';

  @override
  String get settingsAddPasswordSubtitle =>
      'আপনার অ্যাকাউন্টে পাসওয়ার্ড যোগ করুন';

  @override
  String get settingsPasswordChanged => 'পাসওয়ার্ড বদলানো হয়েছে';

  @override
  String get settingsPasswordSet => 'পাসওয়ার্ড সেট হয়েছে';

  @override
  String get settingsClearCacheBody =>
      'এতে ক্যাশ করা ডেটা মুছে যাবে এবং পরের বার অ্যাপ খুললে আবার সিঙ্ক হবে। আপনার ডেটা মুছবে না।';

  @override
  String get settingsClearingCache => 'ক্যাশ পরিষ্কার হচ্ছে...';

  @override
  String get settingsCacheCleared =>
      'ক্যাশ পরিষ্কার হয়েছে এবং সিঙ্ক শুরু হয়েছে';

  @override
  String get settingsClearCacheFailed => 'ক্যাশ পরিষ্কার করা যায়নি';

  @override
  String get settingsClearAllDataBody =>
      'এতে আপনার সব লেনদেন, বাজেট, ওয়ালেট, ক্যাটাগরি ও সেটিংস স্থায়ীভাবে মুছে যাবে। এটি আর ফেরানো যাবে না!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'আপনার সব আর্থিক ডেটা স্থায়ীভাবে মুছে যাবে।';

  @override
  String get settingsClearingAllData => 'সব ডেটা মোছা হচ্ছে...';

  @override
  String get settingsAllDataCleared => 'সব ডেটা মুছে ফেলা হয়েছে';

  @override
  String settingsClearDataFailed(String error) {
    return 'ডেটা মোছা যায়নি: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'অ্যাকাউন্ট মোছার অনুরোধ করতে আপনাকে একটি ফর্মে নিয়ে যাওয়া হবে। প্রক্রিয়াটি শেষ হতে কয়েক দিন লাগে। শেষ হলে সার্ভারের সব ডেটা স্থায়ীভাবে মুছে যাবে।';

  @override
  String get settingsLockAuthFailed => 'যাচাই ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get settingsLockError => 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get settingsLockAuthenticating => 'যাচাই করা হচ্ছে...';

  @override
  String get settingsProfileNameEmpty => 'নাম খালি রাখা যাবে না';

  @override
  String get settingsProfileUpdated => 'প্রোফাইল আপডেট হয়েছে';

  @override
  String get settingsProfileUpdateFailed => 'প্রোফাইল আপডেট করা যায়নি';

  @override
  String get settingsProfileSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get settingsProfileSaved => 'সংরক্ষিত';

  @override
  String get settingsProfilePhotoSoon => 'ছবি আপলোড শিগগিরই আসছে';

  @override
  String get settingsProfileAccountInformation => 'অ্যাকাউন্টের তথ্য';

  @override
  String get settingsProfileMemberSince => 'সদস্য হয়েছেন';

  @override
  String get settingsProfileUnknown => 'অজানা';

  @override
  String get settingsProfileFree => 'ফ্রি';

  @override
  String get settingsProfileUserId => 'ইউজার আইডি';

  @override
  String get settingsProfileUserIdCopied => 'ইউজার আইডি কপি হয়েছে';

  @override
  String get settingsPremiumMonthly => 'প্রিমিয়াম মাসিক';

  @override
  String get settingsPremiumYearly => 'প্রিমিয়াম বার্ষিক';

  @override
  String get settingsPremiumLifetime => 'প্রিমিয়াম আজীবন';

  @override
  String get settingsUnsavedChangesBody =>
      'আপনার কিছু পরিবর্তন সংরক্ষণ করা হয়নি। আপনি কি সত্যিই চলে যেতে চান?';

  @override
  String settingsShareAppText(String url) {
    return 'The Accountant দেখুন - একটি সুন্দর ব্যক্তিগত অর্থ অ্যাপ!\n\n$url';
  }

  @override
  String get settingsShareAppSubject => 'The Accountant - ব্যক্তিগত অর্থ অ্যাপ';

  @override
  String get settingsCloudSyncGateBody =>
      'আপনার সব ডিভাইসে আর্থিক ডেটা সিঙ্ক রাখুন। আর কখনো ডেটা হারাবেন না।';

  @override
  String settingsSyncPushed(int count) {
    return '$countটি পাঠানো হয়েছে';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$countটি আনা হয়েছে';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$countটি দ্বন্দ্ব';
  }

  @override
  String get settingsSyncNowSubtitle => 'সব পরিবর্তন পাঠান ও আনুন';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'সিঙ্ক সম্পন্ন — $pushedটি পাঠানো, $pulledটি আনা হয়েছে';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'সিঙ্ক অসম্পূর্ণ — $countটি রেকর্ড সংরক্ষণ করা যায়নি, আবার চেষ্টা করা হবে। $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'সিঙ্ক ব্যর্থ হয়েছে: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'এই ডিভাইসের ডেটার জায়গায় আপনার ক্লাউড ডেটা আনুন';

  @override
  String get settingsRestoreFromCloudBody =>
      'এতে এই ডিভাইসের সব ডেটা মুছে আপনার ক্লাউড ডেটা বসানো হবে। এই ডিভাইসের যে পরিবর্তনগুলো এখনো সিঙ্ক হয়নি, সেগুলো হারিয়ে যাবে। এটি আর ফেরানো যাবে না।';

  @override
  String settingsRestoredFromCloud(int count) {
    return 'ক্লাউড থেকে $countটি আইটেম ফিরিয়ে আনা হয়েছে';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'ফিরিয়ে আনা বাতিল হয়েছে — আপনার ফোনের ডেটা আগের মতোই আছে। $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'ফিরিয়ে আনা ব্যর্থ হয়েছে: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'আপনার ডেটা প্রতি ১৫ মিনিটে এবং অ্যাপ খুললে নিজে থেকেই সিঙ্ক হয়। পরিমাণ, নাম ও নোট সিঙ্কের আগে এই ফোনেই এনক্রিপ্ট হয়, তাই আমাদের সার্ভার সেগুলো পড়তে পারে না।';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return '$seconds সেকেন্ডে সম্পন্ন';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return '$minutes মিনিট $seconds সেকেন্ডে সম্পন্ন';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'এটি কি আপনার “$name” ক্যাটাগরি?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'সংরক্ষিত। পরের বার সিঙ্ক করলে এটি কার্যকর হবে।';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'আপনার অ্যাকাউন্টে আগে থেকেই “$name” নামে $countটি ক্যাটাগরি আছে। এর একটিকে বিল্ট-ইন ক্যাটাগরি হিসেবে ব্যবহার করবেন, নাকি আলাদা রাখবেন, জানান। আপনি না বাছা পর্যন্ত কিছুই বদলাবে না।',
      one:
          'আপনার অ্যাকাউন্টে আগে থেকেই “$name” নামে একটি ক্যাটাগরি আছে। এটিকে বিল্ট-ইন ক্যাটাগরি হিসেবে ব্যবহার করবেন, নাকি আলাদা রাখবেন, জানান। আপনি না বাছা পর্যন্ত কিছুই বদলাবে না।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'না — আমারটা রাখুন এবং আলাদা একটি যোগ করুন';

  @override
  String get settingsReconcileNoneOfThese =>
      'এগুলোর কোনোটিই না — আলাদা একটি যোগ করুন';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'আপনার বর্তমান “$name” ক্যাটাগরিগুলো তাদের সব লেনদেনসহ ঠিক যেমন আছে তেমনই থাকবে। পাশে একটি নতুন বিল্ট-ইন “$name” যোগ হবে।',
      one:
          'আপনার বর্তমান “$name” ক্যাটাগরি তার সব লেনদেনসহ ঠিক যেমন আছে তেমনই থাকবে। পাশে একটি নতুন বিল্ট-ইন “$name” যোগ হবে।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'আলাদা রাখুন';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return '“$name” ব্যবহার করবেন?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'এটি বিল্ট-ইন “$name” ক্যাটাগরি হয়ে যাবে এবং এর $countটি লেনদেনই, এর সাব-ক্যাটাগরিসহ, থেকে যাবে। কিছুই মোছা হবে না।',
      zero:
          'এটি বিল্ট-ইন “$name” ক্যাটাগরি হয়ে যাবে এবং এর অধীনে রাখা সবকিছু, এর সাব-ক্যাটাগরিসহ, থেকে যাবে। কিছুই মোছা হবে না।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'এটিই ব্যবহার করুন';

  @override
  String settingsReconcileWillUse(String name) {
    return '“$name” ব্যবহার করা হবে।';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'আলাদা একটি “$name” যোগ করা হবে।';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'বর্তমান পাসওয়ার্ড লিখুন এবং একটি নতুন পাসওয়ার্ড বেছে নিন';

  @override
  String get settingsSetPasswordSubtitle =>
      'বাড়তি নিরাপত্তার জন্য আপনার অ্যাকাউন্টে একটি পাসওয়ার্ড যোগ করুন';

  @override
  String get settingsEnterCurrentPassword => 'আপনার বর্তমান পাসওয়ার্ড লিখুন';

  @override
  String get settingsEnterNewPassword => 'একটি নতুন পাসওয়ার্ড লিখুন';

  @override
  String get settingsPasswordMinLength => 'পাসওয়ার্ড অন্তত ৮ অক্ষরের হতে হবে';

  @override
  String get settingsConfirmYourPassword => 'আপনার পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get settingsPasswordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get settingsPleaseWait => 'অপেক্ষা করুন...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'নিশ্চিত করতে “$word” লিখুন';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return 'বাজেটের $percent%';
  }

  @override
  String get authTooManyAttempts =>
      'অনেকবার চেষ্টা করা হয়েছে। এক মিনিট অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get authServerDown =>
      'আমরা আমাদের সার্ভারে পৌঁছাতে পারিনি। সমস্যাটি আমাদের দিকে — কয়েক মিনিট পরে আবার চেষ্টা করুন।';

  @override
  String get authInitFailed => 'যাচাই প্রক্রিয়া শুরু করা যায়নি';

  @override
  String get authSignInError => 'সাইন ইন করার সময় একটি সমস্যা হয়েছে';

  @override
  String get authSignUpError => 'সাইন আপ করার সময় একটি সমস্যা হয়েছে';

  @override
  String get authGoogleCancelled => 'Google সাইন-ইন বাতিল বা ব্যর্থ হয়েছে';

  @override
  String get authFirebaseTokenFailed => 'Firebase ID টোকেন পাওয়া যায়নি';

  @override
  String get authGoogleSignInError =>
      'Google দিয়ে সাইন ইন করার সময় একটি সমস্যা হয়েছে';

  @override
  String get authAccountExistsDifferentCredential =>
      'একই ইমেইল ঠিকানায় আগে থেকেই একটি অ্যাকাউন্ট আছে, তবে তার সাইন-ইন তথ্য আলাদা।';

  @override
  String get authInvalidCredential =>
      'দেওয়া সাইন-ইন তথ্যটি ভুল বা মেয়াদোত্তীর্ণ।';

  @override
  String get authGoogleDisabled => 'Google সাইন-ইন বন্ধ আছে।';

  @override
  String get authUserDisabled => 'এই ইউজার অ্যাকাউন্টটি নিষ্ক্রিয় করা হয়েছে।';

  @override
  String get authAppleSignInError =>
      'Apple দিয়ে সাইন ইন করার সময় একটি সমস্যা হয়েছে';

  @override
  String get authAppleDisabled => 'Apple সাইন-ইন বন্ধ আছে।';

  @override
  String get authNoPendingLink => 'লিংক করার মতো কোনো অ্যাকাউন্ট বাকি নেই';

  @override
  String get authLinkFailed => 'অ্যাকাউন্ট লিংক করা যায়নি';

  @override
  String get authIncorrectPassword => 'পাসওয়ার্ড ভুল। আবার চেষ্টা করুন।';

  @override
  String get authSignOutError => 'সাইন আউট করার সময় একটি সমস্যা হয়েছে';

  @override
  String get authLinkSubtitle =>
      'এই ইমেইলে আগে থেকেই একটি অ্যাকাউন্ট আছে। আপনার Google অ্যাকাউন্ট লিংক করতে পাসওয়ার্ড লিখুন।';

  @override
  String get authEnterYourPasswordHint => 'আপনার পাসওয়ার্ড লিখুন';

  @override
  String get authEnterYourPassword => 'অনুগ্রহ করে আপনার পাসওয়ার্ড লিখুন';

  @override
  String get authLinkInfo =>
      'লিংক করার পর আপনি ইমেইল/পাসওয়ার্ড বা Google, যেকোনোটি দিয়ে সাইন ইন করতে পারবেন।';

  @override
  String get authEnterYourEmail => 'অনুগ্রহ করে আপনার ইমেইল লিখুন';

  @override
  String get authEnterValidEmail => 'একটি সঠিক ইমেইল লিখুন';

  @override
  String get authPasswordMin6 => 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';

  @override
  String get authNoAccountPrompt => 'অ্যাকাউন্ট নেই? ';

  @override
  String get authForgotPasswordTitle => 'পাসওয়ার্ড ভুলে গেছেন';

  @override
  String get authCheckYourEmail => 'আপনার ইমেইল দেখুন';

  @override
  String get authForgotPasswordSubtitle =>
      'আপনার ইমেইল লিখুন, পাসওয়ার্ড রিসেট করার জন্য আমরা আপনাকে একটি কোড পাঠাব।';

  @override
  String authCodeSentSubtitle(String email) {
    return 'আমরা $email-এ একটি ৬ সংখ্যার কোড পাঠিয়েছি। নিচে নতুন পাসওয়ার্ডসহ কোডটি লিখুন।';
  }

  @override
  String get authEnterYourEmailHint => 'আপনার ইমেইল লিখুন';

  @override
  String get authSixDigitCodeHint => '৬ সংখ্যার কোড';

  @override
  String get authEnterTheCode => 'অনুগ্রহ করে কোডটি লিখুন';

  @override
  String get authCodeIsSixDigits => 'কোডটি ৬ সংখ্যার';

  @override
  String get authCreateNewPasswordHint => 'একটি নতুন পাসওয়ার্ড তৈরি করুন';

  @override
  String get authReenterNewPasswordHint => 'নতুন পাসওয়ার্ডটি আবার লিখুন';

  @override
  String get authEnterYourNameHint => 'আপনার নাম লিখুন';

  @override
  String get authEnterFullName => 'অনুগ্রহ করে আপনার পুরো নাম লিখুন';

  @override
  String get authNameMin2 => 'নাম অন্তত ২ অক্ষরের হতে হবে';

  @override
  String get authCreatePasswordHint => 'একটি পাসওয়ার্ড তৈরি করুন';

  @override
  String get authPasswordComplexity =>
      'বড় হাতের অক্ষর, ছোট হাতের অক্ষর ও সংখ্যা থাকতে হবে';

  @override
  String get authReenterPasswordHint => 'পাসওয়ার্ডটি আবার লিখুন';

  @override
  String get authStrengthWeak => 'দুর্বল';

  @override
  String get authStrengthFair => 'মোটামুটি';

  @override
  String get authStrengthGood => 'ভালো';

  @override
  String get authStrengthStrong => 'শক্তিশালী';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'আমি $terms ও $privacy-তে সম্মত';
  }

  @override
  String get authDefaultUserName => 'ইউজার';

  @override
  String authMemberSince(String date) {
    return '$date থেকে সদস্য';
  }

  @override
  String get authFieldRequired => 'এই ঘরটি পূরণ করা আবশ্যক';

  @override
  String authSignOutFailed(String error) {
    return 'সাইন আউট করা যায়নি: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'ছবি বাছাই করা যায়নি: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'প্রোফাইল আপডেট করা যায়নি: $error';
  }

  @override
  String get premiumSaveAbout44 => '~৪৪% সাশ্রয়';

  @override
  String get premiumBestValue => 'সেরা মূল্য';

  @override
  String get premiumIapUnavailable => 'IAP উপলভ্য নয়';

  @override
  String get premiumProductNotFound => 'প্রোডাক্ট পাওয়া যায়নি';

  @override
  String get premiumPlanUnavailable =>
      'এই প্ল্যানটি এখন আপনার অ্যাকাউন্টে উপলভ্য নয়';

  @override
  String get premiumRestoreFailed => 'কেনাকাটা ফিরিয়ে আনা যায়নি';

  @override
  String get premiumPurchaseFailed => 'কেনাকাটা ব্যর্থ হয়েছে';

  @override
  String get premiumVerificationFailed => 'যাচাই ব্যর্থ হয়েছে';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন',
      one: '১ দিন',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সপ্তাহ',
      one: '১ সপ্তাহ',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মাস',
      one: '১ মাস',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বছর',
      one: '১ বছর',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'আপনি $limitটি ফ্রি $items-এর মধ্যে $countটি ব্যবহার করেছেন।';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'সীমাহীন $items ও আরও অনেক কিছুর জন্য প্রিমিয়াম নিন!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'আপনি ফ্রি প্ল্যানের $limitটি $items-এর সীমায় পৌঁছে গেছেন। সীমাহীন $items-এর জন্য প্রিমিয়াম নিন।';
  }

  @override
  String get premiumLimitWallets => 'ওয়ালেট';

  @override
  String get premiumLimitCategories => 'নিজস্ব ক্যাটাগরি';

  @override
  String get premiumLimitBudgets => 'সক্রিয় বাজেট';

  @override
  String get premiumLimitObjectives => 'সক্রিয় লক্ষ্য';

  @override
  String get premiumLimitPaymentMethods => 'পেমেন্ট পদ্ধতি';

  @override
  String get backupErrNotJson =>
      'এই ফাইলটি ব্যাকআপ নয় — এটি JSON হিসেবে পড়া যায়নি।';

  @override
  String get backupErrNotOurs => 'এই ফাইলটি The Accountant-এর ব্যাকআপ নয়।';

  @override
  String get backupErrNewerVersion =>
      'এই ব্যাকআপটি অ্যাপের নতুন ভার্সনে তৈরি। The Accountant আপডেট করে আবার চেষ্টা করুন।';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'এই ব্যাকআপটি অ্যাপের এত পুরোনো ভার্সনের যে এই ভার্সন এটি পড়তে পারে না (ডেটাবেস $version, সবচেয়ে পুরোনো সমর্থিত $oldest)।';
  }

  @override
  String get backupErrNoData => 'এই ব্যাকআপে কোনো ডেটা নেই।';

  @override
  String backupErrSectionDamaged(String section) {
    return 'এই ব্যাকআপের “$section” অংশটি নষ্ট।';
  }

  @override
  String get backupErrNoHeader => 'এই ব্যাকআপে সেই হেডার নেই যা বলে এটি কী।';

  @override
  String get backupErrNoSchemaVersion =>
      'এই ব্যাকআপটি কোন ডেটাবেস ভার্সন থেকে নেওয়া তা বলা নেই, তাই এটি নিরাপদে ফিরিয়ে আনা যাবে না।';

  @override
  String get backupErrNoDate => 'এই ব্যাকআপটি কবে নেওয়া হয়েছে তা বলা নেই।';

  @override
  String get backupErrDamaged => 'এই ব্যাকআপ ফাইলটি নষ্ট।';

  @override
  String get backupErrWrongKey =>
      'এই ব্যাকআপটি অন্য একটি অ্যাকাউন্টের, অথবা ফাইলটি বদলানো হয়েছে। এটি ফিরিয়ে আনতে যে অ্যাকাউন্ট দিয়ে এটি তৈরি হয়েছিল সেটি দিয়ে সাইন ইন করুন।';

  @override
  String get backupErrNoPassphraseLock =>
      'এই ব্যাকআপটি পাসফ্রেজ দিয়ে খোলা যায় না।';

  @override
  String get backupErrNeedsSecret =>
      'এই ব্যাকআপটি পাসফ্রেজ দিয়ে সুরক্ষিত। এটি ফিরিয়ে আনতে পাসফ্রেজ বা রিকভারি কোড লিখুন।';

  @override
  String get backupErrWrongSecret =>
      'এই পাসফ্রেজ বা রিকভারি কোড দিয়ে ব্যাকআপটি খোলে না।';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'এই ব্যাকআপটি অ্যাপের নতুন ভার্সনে তৈরি (ডেটাবেস $version, এই বিল্ড $supported পর্যন্ত পড়তে পারে)। The Accountant আপডেট করে আবার চেষ্টা করুন।';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Drive-এ পৌঁছানো যায়নি: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant-কে এখনো Google Drive ব্যবহারের অনুমতি দেওয়া হয়নি।';

  @override
  String get backupDriveNoFolder =>
      'Google Drive ব্যাকআপ রাখার ফোল্ডার তৈরি করতে দেয়নি।';

  @override
  String get backupDriveNoFileId =>
      'Google Drive ব্যাকআপটি নিয়েছে, কিন্তু কোথায় রেখেছে তা জানায়নি।';

  @override
  String get backupDriveTimeout =>
      'Google Drive উত্তর দিতে অনেক সময় নিচ্ছে। পরে আবার চেষ্টা করুন।';

  @override
  String get backupDriveOffline =>
      'Google Drive-এর সাথে সংযোগ নেই। অনলাইন হলে আবার চেষ্টা করুন।';

  @override
  String get backupDriveDenied =>
      'Google Drive অনুরোধটি প্রত্যাখ্যান করেছে। আবার অনুমতি দিয়ে চেষ্টা করুন।';

  @override
  String get backupDriveFileGone => 'সেই ব্যাকআপটি আর Google Drive-এ নেই।';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive $status উত্তর দিয়েছে। $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'একটু পরে আবার চেষ্টা করুন।';

  @override
  String backupTakeFailed(String error) {
    return 'ব্যাকআপ নেওয়া যায়নি: $error';
  }

  @override
  String get backupUnrestorableNewer => 'অ্যাপের নতুন ভার্সনে তৈরি।';

  @override
  String get backupUnrestorableOlder =>
      'এত পুরোনো যে অ্যাপের এই ভার্সন পড়তে পারে না।';

  @override
  String get backupKeyUnusable =>
      'সার্ভার একটি অব্যবহারযোগ্য এনক্রিপশন কী পাঠিয়েছে। পরে আবার চেষ্টা করুন।';

  @override
  String get backupKeyNeedsSignIn =>
      'ব্যাকআপ নিতে বা ফিরিয়ে আনতে সাইন ইন করুন — ব্যাকআপ আপনার অ্যাকাউন্ট দিয়ে এনক্রিপ্ট করা হয়।';

  @override
  String get backupKeyNeedsInternet =>
      'একবার ইন্টারনেটে যুক্ত হন যাতে আপনার ডেটা এনক্রিপ্ট করা যায়, তারপর আবার চেষ্টা করুন।';

  @override
  String get backupKeyLocked =>
      'আপনার ডেটা পাসফ্রেজ দিয়ে সুরক্ষিত। আগে এই ডিভাইসে এটি আনলক করুন।';

  @override
  String get backupFrequencyManual => 'শুধু আমি চাইলে';

  @override
  String get backupFrequencyDaily => 'প্রতিদিন';

  @override
  String get backupFrequencyWeekly => 'প্রতি সপ্তাহে';

  @override
  String get backupFrequencyMonthly => 'প্রতি মাসে';

  @override
  String get backupIntro =>
      'ব্যাকআপ হলো একটি ফাইল, যাতে এই ডিভাইসের সবকিছু থাকে — প্রতিটি লেনদেন, অ্যাকাউন্ট, বাজেট ও লক্ষ্য। এটি নিরাপদ কোথাও রাখুন, তাহলে এখানকার কিছুই চিরতরে হারাবে না।';

  @override
  String get backupSectionOnDevice => 'এই ডিভাইসে';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'DRIVE-এ থাকা ব্যাকআপ';

  @override
  String backupBackedUpCount(int count) {
    return '$countটি রেকর্ডের ব্যাকআপ নেওয়া হয়েছে।';
  }

  @override
  String get backupSaveDialogTitle => 'ব্যাকআপ সংরক্ষণ করুন';

  @override
  String get backupChooseFileTitle => 'একটি ব্যাকআপ ফাইল বেছে নিন';

  @override
  String backupFileUnreadable(String error) {
    return 'ফাইলটি পড়া যায়নি: $error';
  }

  @override
  String backupTakenOn(String date) {
    return '$date তারিখে নেওয়া।';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return '$date তারিখে $device-এ নেওয়া।';
  }

  @override
  String backupBelongedTo(String email) {
    return 'এটি $email-এর ছিল।';
  }

  @override
  String get backupDifferentAccountWarning =>
      'এটি এখানে সাইন ইন করা অ্যাকাউন্ট নয়। ফিরিয়ে আনলে এই ডিভাইসে অন্য কারও রেকর্ড চলে আসবে।';

  @override
  String get backupRestoreEraseWarning =>
      'এই ডিভাইসে এখন যা আছে, সব মুছে নতুন করে বসানো হবে। যা এখনো সিঙ্ক হয়নি, তা হারিয়ে যাবে। এটি আর ফেরানো যাবে না।';

  @override
  String backupRestoredCount(int count) {
    return '$countটি রেকর্ড ফিরিয়ে আনা হয়েছে।';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$countটি রেকর্ড ফিরিয়ে আনা হয়েছে। ফাইলের কিছু অংশ এই ভার্সনে মেলেনি, তাই বাদ দেওয়া হয়েছে।';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'কিছুই বদলায়নি — ফিরিয়ে আনা ব্যর্থ হয়েছে: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'ব্যাকআপ এমন একটি ব্যক্তিগত ফোল্ডারে যায় যা শুধু এই অ্যাপ খুলতে পারে। আপনার অন্য ফাইল কখনো পড়া হয় না।';

  @override
  String get backupDriveConnectedTitle => 'Google Drive যুক্ত হয়েছে';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'এই ডিভাইসের ব্যাকআপ আপনার Drive-এ “$folder” নামের একটি ফোল্ডারে যাবে।';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'ব্যাকআপ আপনার Drive-এ “$folder”-এ যায়।';
  }

  @override
  String get backupNoneYet => 'এই ডিভাইস থেকে এখনো কোনো ব্যাকআপ যায়নি';

  @override
  String backupLastBackedUp(String date) {
    return 'সর্বশেষ ব্যাকআপ $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$countটি ব্যাকআপ — নতুন একটি এলে পুরোনোগুলো সরিয়ে ফেলা হয়';
  }

  @override
  String get backupDisconnectSubtitle =>
      'স্বয়ংক্রিয় ব্যাকআপ বন্ধ হবে। আগে সংরক্ষিত কিছুই মুছবে না।';

  @override
  String backupListFailed(String error) {
    return 'আপনার ব্যাকআপের তালিকা আনা যায়নি: $error';
  }

  @override
  String get backupDriveNotGranted => 'Google Drive-এর অনুমতি দেওয়া হয়নি।';

  @override
  String get backupDriveConnected => 'Google Drive যুক্ত হয়েছে।';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Drive যুক্ত করা যায়নি: $error';
  }

  @override
  String get backupDisconnectBody =>
      'স্বয়ংক্রিয় ব্যাকআপ বন্ধ হবে। Drive-এ আগে থেকে থাকা ব্যাকআপ যেখানে আছে সেখানেই থাকবে, আর আপনি যেকোনো সময় আবার যুক্ত করতে পারবেন।';

  @override
  String backupSavedToDrive(String name) {
    return '$name Google Drive-এ সংরক্ষণ করা হয়েছে।';
  }

  @override
  String backupCopyFailed(String error) {
    return 'সেই ব্যাকআপটি সংরক্ষণ করা যায়নি: $error';
  }

  @override
  String get backupDeleteBody => 'এটি Google Drive থেকে চিরতরে মুছে যাবে।';

  @override
  String get backupRefresh => 'রিফ্রেশ করুন';

  @override
  String get ppErrKdfParams => 'কী তৈরির প্যারামিটারগুলো গ্রহণযোগ্য নয়।';

  @override
  String get ppErrKdfAlgorithm => 'কী তৈরির অ্যালগরিদমটি অজানা।';

  @override
  String get onboardingIntroAccountsTitle => 'সব অ্যাকাউন্ট, একটি ব্যালেন্স';

  @override
  String get onboardingIntroAccountsBody =>
      'ক্যাশ, কার্ড ও সঞ্চয় পাশাপাশি রাখুন, আর দেখুন আসলে আপনার কাছে কত বাকি আছে।';

  @override
  String get onboardingIntroBudgetsTitle => 'যে বাজেট আগেই সতর্ক করে';

  @override
  String get onboardingIntroBudgetsBody =>
      'প্রতিটি ক্যাটাগরির জন্য সীমা ঠিক করুন। অ্যাপ মোট খরচের দিকে নজর রাখে এবং সীমা পেরোনোর আগেই আপনাকে সতর্ক করে, পরে নয়।';

  @override
  String get onboardingIntroAskTitle => 'নিজের খরচ নিয়ে প্রশ্ন করুন';

  @override
  String get onboardingIntroAskBody =>
      'রসিদ স্ক্যান করুন, বা জিজ্ঞেস করুন গত মাসে টাকা কোথায় গেল, আর আপনার রেকর্ড থেকে উত্তর পান।';

  @override
  String get onboardingIntroThemeTitle => 'নিজের মতো করে সাজান';

  @override
  String get onboardingIntroThemeBody =>
      'এখনই একটি থিম বেছে নিন, বা যখন খুশি সেটিংস থেকে বদলান।';

  @override
  String get onboardingCreateYourAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get onboardingNext => 'পরবর্তী';

  @override
  String get onboardingCurrencyInfo =>
      'এটি আপনার প্রধান মুদ্রা হিসেবে ব্যবহার হবে। পরে আপনি অন্য মুদ্রার অ্যাকাউন্টও যোগ করতে পারবেন।';

  @override
  String get onboardingTypeCash => 'ক্যাশ';

  @override
  String get onboardingTypeBank => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get onboardingTypeCard => 'ক্রেডিট কার্ড';

  @override
  String get onboardingTypeDeposit => 'ডিপোজিট';

  @override
  String get onboardingTypeInvestment => 'বিনিয়োগ';

  @override
  String get onboardingTypeAsset => 'সম্পদ';

  @override
  String onboardingDayN(int day) {
    return 'দিন $day';
  }

  @override
  String get onboardingAllSet => 'সব প্রস্তুত!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'অনবোর্ডিং শেষ করা যায়নি: $error';
  }

  @override
  String get onboardingSkipFailed => 'অনবোর্ডিং এড়ানো যায়নি';

  @override
  String get startupOfflineConfirmBody =>
      'আপনার ডেটা যেখানে আছে ঠিক সেখানেই থাকবে — এই ডিভাইসে বা ক্লাউডে কিছুই মুছবে না।\n\nতবে অ্যাকাউন্টে যদি ডেটা সংরক্ষিত থাকে, তাহলে এখন যা যোগ করবেন তা ফিরিয়ে আনার পর সেগুলোর পাশাপাশি থাকবে — হয়তো কিছু ডুপ্লিকেট গুছিয়ে নিতে হবে।';

  @override
  String get startupDataInCloudTitle => 'আপনার ডেটা ক্লাউডে অপেক্ষা করছে';

  @override
  String get startupLoadFailedTitle =>
      'আমরা আপনার অ্যাকাউন্ট পুরোপুরি লোড করতে পারিনি';

  @override
  String get startupGenericReason =>
      'এই অ্যাকাউন্ট যাচাই করার সময় কিছু একটা সমস্যা হয়েছে।';

  @override
  String get startupUseWithoutRestoring => 'ফিরিয়ে না এনেই অ্যাপ ব্যবহার করুন';

  @override
  String get legalTermsTab => 'শর্তাবলী';

  @override
  String get legalConsent =>
      'আমি গোপনীয়তা নীতি ও শর্তাবলী পড়েছি এবং এতে সম্মত';

  @override
  String get walkthroughGotIt => 'বুঝেছি!';

  @override
  String get settingsFaqSectionGettingStarted => 'শুরু করা';

  @override
  String get settingsFaq01Question => 'কীভাবে লেনদেন যোগ করব?';

  @override
  String get settingsFaq01Answer =>
      'হোম স্ক্রিনের নিচে + বোতামে ট্যাপ করুন। পরিমাণ লিখুন, একটি ক্যাটাগরি ও একটি ওয়ালেট বেছে নিন, চাইলে নোট যোগ করুন। লেনদেনটি রাখতে সংরক্ষণ-এ ট্যাপ করুন।';

  @override
  String get settingsFaq02Question =>
      'ওয়ালেট আর ক্যাটাগরির মধ্যে পার্থক্য কী?';

  @override
  String get settingsFaq02Answer =>
      'ওয়ালেট দেখায় আপনার টাকা কোথায় আছে (যেমন ক্যাশ, ব্যাংক অ্যাকাউন্ট, ক্রেডিট কার্ড)। ক্যাটাগরি বলে টাকা কীসে খরচ হলো বা কোথা থেকে এল (যেমন খাবার, বেতন, বিনোদন)।';

  @override
  String get settingsFaq03Question => 'তারিখ আর সংখ্যার ফরম্যাট কীভাবে বদলাব?';

  @override
  String get settingsFaq03Answer =>
      'সেটিংস > আঞ্চলিক সেটিংস-এ যান। এখানে ডিফল্ট মুদ্রা, তারিখের ফরম্যাট (যেমন DD/MM/YYYY বা MM/DD/YYYY) এবং সংখ্যার ফরম্যাট (যেমন 1,234.56 বা 1.234,56) বদলাতে পারবেন। লাইভ প্রিভিউতে দেখা যায় আপনার সেটিংস কেমন দেখাবে।';

  @override
  String get settingsFaqSectionTransactions => 'লেনদেন';

  @override
  String get settingsFaq04Question => 'নিয়মিত লেনদেন কি ট্র্যাক করা যায়?';

  @override
  String get settingsFaq04Answer =>
      'হ্যাঁ! লেনদেন যোগ করার সময় \"নিয়মিত\" অপশনটি চালু করুন। এটি প্রতিদিন, প্রতি সপ্তাহে, প্রতি মাসে বা প্রতি বছর ফিরে আসার জন্য সেট করতে পারেন। অ্যাপ নিজেই এই লেনদেনগুলো তৈরি করে দেবে।';

  @override
  String get settingsFaq05Question =>
      'এক ওয়ালেট থেকে আরেক ওয়ালেটে টাকা কীভাবে পাঠাব?';

  @override
  String get settingsFaq05Answer =>
      'লেনদেন যোগ করার সময় ধরন হিসেবে \"ট্রান্সফার\" বেছে নিন। কোন ওয়ালেট থেকে যাবে আর কোন ওয়ালেটে যাবে বেছে নিয়ে পরিমাণ লিখুন। অ্যাপ নিজেই একটি থেকে কেটে অন্যটিতে যোগ করে দেবে।';

  @override
  String get settingsFaq06Question => 'আসন্ন লেনদেন কী?';

  @override
  String get settingsFaq06Answer =>
      'আসন্ন লেনদেন হলো ভবিষ্যতের খরচ বা আয়, যা আপনি আশা করছেন কিন্তু এখনো পরিশোধ হয়নি। পরিশোধিত হিসেবে চিহ্নিত না করা পর্যন্ত এগুলো আপনার ওয়ালেট ব্যালেন্সে প্রভাব ফেলে না। মেয়াদ পেরোনো ও আসন্ন সব আইটেম লেনদেন অংশে পাবেন।';

  @override
  String get settingsFaq07Question => 'সাবস্ক্রিপশন কীভাবে ট্র্যাক করব?';

  @override
  String get settingsFaq07Answer =>
      'লেনদেন যোগ করার সময় বিশেষ ধরন সাবস্ক্রিপশন সেট করুন। এতে এটি কোনো সেবার নিয়মিত পেমেন্ট হিসেবে চিহ্নিত হবে। সব সাবস্ক্রিপশন এক জায়গায় দেখতে পারবেন এবং মাসে সাবস্ক্রিপশনে কত খরচ হচ্ছে তা ট্র্যাক করতে পারবেন।';

  @override
  String get settingsFaq08Question => 'ধার ও দেনার হিসাব কীভাবে কাজ করে?';

  @override
  String get settingsFaq08Answer =>
      'কাউকে টাকা ধার দিলে ধার, আর আপনি টাকা ধার নিলে দেনা ব্যবহার করুন। প্রতিটি এন্ট্রিতে পরিমাণ, কে কার কাছে পাবে আর কতটা শোধ হয়েছে তা থাকে। আংশিক পেমেন্ট লিখে রাখতে পারবেন, আর পুরোটা শোধ হলে দেনা মিটে গেছে বলে চিহ্নিত করতে পারবেন।';

  @override
  String get settingsFaq09Question => 'লেনদেনে কি নোট বা রসিদ যোগ করা যায়?';

  @override
  String get settingsFaq09Answer =>
      'হ্যাঁ! লেনদেন যোগ বা সম্পাদনার সময় নোটের ঘরে নোট লিখতে পারবেন। প্রিমিয়াম ব্যবহারকারীরা এআই রসিদ স্ক্যানার দিয়ে রসিদও স্ক্যান করতে পারেন, যা নিজেই পরিমাণ আর দোকানের তথ্য বের করে নেয়।';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'ওয়ালেট ও মুদ্রা';

  @override
  String get settingsFaq10Question => 'একাধিক অ্যাকাউন্ট কীভাবে সামলাব?';

  @override
  String get settingsFaq10Answer =>
      'অ্যাপে চার ধরনের অ্যাকাউন্ট আছে: ক্যাশ, ব্যাংক অ্যাকাউন্ট, ক্রেডিট কার্ড ও সাবস্ক্রিপশন। নতুন অ্যাকাউন্ট যোগ করতে ড্যাশবোর্ডে \'আপনার অ্যাকাউন্টগুলি\'-তে গিয়ে \'অ্যাকাউন্ট যোগ করুন\'-এ ট্যাপ করুন। প্রতিটি অ্যাকাউন্টের আলাদা নাম, আইকন, রং ও মুদ্রা থাকতে পারে। আপনার প্রথম অ্যাকাউন্টটি নিজে থেকেই ডিফল্ট হয়ে যায়। ক্রেডিট কার্ড অ্যাকাউন্টে ক্রেডিট সীমা আর বিলিংয়ের দিনও সেট করতে পারবেন, যাতে কত ক্রেডিট বাকি আছে দেখা যায়।';

  @override
  String get settingsFaq11Question => 'একাধিক মুদ্রা কি ব্যবহার করা যায়?';

  @override
  String get settingsFaq11Answer =>
      'হ্যাঁ! প্রতিটি ওয়ালেটের নিজস্ব মুদ্রা থাকতে পারে। অ্যাপ লাইভ বিনিময় হার দিয়ে নিজেই মুদ্রা রূপান্তর করে। সেটিংস > আঞ্চলিক সেটিংস-এ নিজের বিনিময় হারও সেট করতে পারবেন।';

  @override
  String get settingsFaq12Question => 'মুদ্রা রূপান্তর কীভাবে কাজ করে?';

  @override
  String get settingsFaq12Answer =>
      'প্রতিটি ওয়ালেটের মুদ্রা আলাদা হতে পারে, আর অ্যাপ কয়েক ঘণ্টা পরপর আপডেট হওয়া লাইভ বিনিময় হার দিয়ে নিজেই পরিমাণ রূপান্তর করে। যেকোনো মুদ্রা জোড়ার জন্য নিজের হার সেটিংস > আঞ্চলিক সেটিংস-এ সেট করতে পারবেন। অ্যাপ ১৫০টির বেশি মুদ্রা সমর্থন করে এবং নিজেই হার নিয়ে আসে।';

  @override
  String get settingsFaq13Question =>
      'লেনদেনসহ কোনো ক্যাটাগরি মুছে ফেললে কী হয়?';

  @override
  String get settingsFaq13Answer =>
      'ওই লেনদেনগুলো \"শ্রেণিহীন\"-এ চলে যাবে। পরে সেগুলো অন্য ক্যাটাগরিতে দিতে পারবেন, বা শ্রেণিহীনই রেখে দিতে পারবেন।';

  @override
  String get settingsFaq14Question => 'সাব-ক্যাটাগরি কী আর কীভাবে ব্যবহার করব?';

  @override
  String get settingsFaq14Answer =>
      'আরও খুঁটিয়ে হিসাব রাখতে যেকোনো মূল ক্যাটাগরির ভেতরে সাব-ক্যাটাগরি বানাতে পারেন। যেমন \'খাবার\'-এর ভেতরে \'বাজার\', \'রেস্টুরেন্ট\' আর \'কফি\'। সাব-ক্যাটাগরি দিয়ে ঠিক কোথায় টাকা যাচ্ছে তা পরিষ্কার দেখা যায়।';

  @override
  String get settingsFaq15Question => 'ব্যালেন্স সংশোধন কী?';

  @override
  String get settingsFaq15Answer =>
      'ওয়ালেটের ব্যালেন্স আসল টাকার সাথে না মিললে ব্যালেন্স সংশোধন দিয়ে তা ঠিক করতে পারেন। এতে একটি বিশেষ লেনদেন তৈরি হয়, যা হাতে আয় বা খরচ না লিখেই আপনার হিসাবের ব্যালেন্সকে আসল ব্যালেন্সের সমান করে দেয়।';

  @override
  String get settingsFaqSectionBudgetsGoals => 'বাজেট ও লক্ষ্য';

  @override
  String get settingsFaq16Question => 'বাজেট কীভাবে সেট করব?';

  @override
  String get settingsFaq16Answer =>
      'বাজেট ট্যাবে গিয়ে \"নতুন বাজেট\"-এ ট্যাপ করুন। একটি নাম দিন, খরচের সীমা ঠিক করুন, সময়কাল (সাপ্তাহিক/মাসিক) বেছে নিন, আর কোন কোন ক্যাটাগরি ট্র্যাক হবে তা বেছে নিন। সীমার কাছাকাছি পৌঁছালে অ্যাপ আপনাকে জানিয়ে দেবে।';

  @override
  String get settingsFaq17Question => 'সঞ্চয়ের লক্ষ্য কী?';

  @override
  String get settingsFaq17Answer =>
      'সঞ্চয়ের লক্ষ্যে আপনি কত টাকা জমাতে চান তা ঠিক করে রাখতে পারেন। লক্ষ্য অংশে একটি লক্ষ্য তৈরি করুন, পরিমাণ ঠিক করুন, আর অগ্রগতি দেখতে লেনদেন যুক্ত করুন। অ্যাপ একটি অগ্রগতি বার আর লক্ষ্যের কত শতাংশ হলো তা দেখায়।';

  @override
  String get settingsFaq18Question => 'ঋণ কীভাবে ট্র্যাক করব?';

  @override
  String get settingsFaq18Answer =>
      'লক্ষ্য অংশে মোট কত টাকা দেনা তা দিয়ে একটি ঋণ তৈরি করুন। যখন কিস্তি দেবেন, সেই লেনদেনগুলো ঋণের সাথে যুক্ত করুন, তাহলে শোধের অগ্রগতি দেখা যাবে। অ্যাপ দেখায় কত শোধ হয়েছে আর কত বাকি।';

  @override
  String get settingsFaqSectionDataSync => 'ডেটা ও সিঙ্ক';

  @override
  String get settingsFaq19Question => 'ক্লাউড সিঙ্ক কীভাবে কাজ করে?';

  @override
  String get settingsFaq19Answer =>
      'ক্লাউড সিঙ্ক আপনার সব ডিভাইসে ডেটা একই রাখে। চালু করতে সেটিংস > ডেটা ব্যবস্থাপনা > ক্লাউড সিঙ্ক-এ যান। প্রতি ১৫ মিনিটে আর অ্যাপ খুললেই সিঙ্ক নিজে থেকে চলে। এখনই সিঙ্ক করতে \'এখনই সিঙ্ক করুন\'-এ ট্যাপ করতে পারেন। এটি একটি প্রিমিয়াম ফিচার।';

  @override
  String get settingsFaq20Question => 'আমার ডেটা কীভাবে রপ্তানি করব?';

  @override
  String get settingsFaq20Answer =>
      'সেটিংস > ডেটা ব্যবস্থাপনা > ডেটা রপ্তানি-তে যান। একটি তারিখের সীমা বেছে নিন, CSV (স্প্রেডশিটের জন্য) বা PDF (সাজানো রিপোর্টের জন্য) বেছে নিয়ে রপ্তানি-তে ট্যাপ করুন। ক্যাটাগরি ও ওয়ালেট অনুযায়ী ভাগ রাখতে বা বাদ দিতে পারবেন। এটি একটি প্রিমিয়াম ফিচার।';

  @override
  String get settingsFaq21Question => 'ডেটা মুছে ফেললে কী হয়?';

  @override
  String get settingsFaq21Answer =>
      'সেটিংস > গোপনীয়তা ও নিরাপত্তা-তে যান। \'ক্যাশ পরিষ্কার করুন\' অস্থায়ী ডেটা সরিয়ে আবার সিঙ্ক করায়, আপনার লেনদেন মোছে না। \'সমস্ত ডেটা মুছুন\' সবকিছু চিরতরে মুছে দেয় — নিশ্চিত করতে আপনাকে DELETE লিখতে হবে। এটি আর ফেরানো যায় না।';

  @override
  String get settingsFaqSectionPremiumAiFeatures => 'প্রিমিয়াম ও এআই ফিচার';

  @override
  String get settingsFaq22Question => 'প্রিমিয়ামে কী কী আছে?';

  @override
  String get settingsFaq22Answer =>
      'প্রিমিয়ামে পাবেন: কোনো বিজ্ঞাপন ছাড়া সীমাহীন এআই (কোচ, মাসিক সারাংশ, রসিদ পড়া আর লিখে বলুন), ক্লাউড সিঙ্ক, পিডিএফ রিপোর্ট, প্রিমিয়াম থিম, আর ওয়ালেট, ক্যাটাগরি, বাজেট, লক্ষ্য ও পেমেন্ট পদ্ধতির কোনো সীমা থাকে না। সাথে অগ্রাধিকার সহায়তাও পাবেন।';

  @override
  String get settingsFaq23Question => 'ফ্রি ব্যবহারে কী কী সীমা আছে?';

  @override
  String get settingsFaq23Answer =>
      'ফ্রি ব্যবহারকারীরা সর্বোচ্চ ৩টি ওয়ালেট, ১০টি নিজের ক্যাটাগরি, ৩টি চালু বাজেট, ২টি চালু লক্ষ্য/ঋণ আর ৫টি পেমেন্ট পদ্ধতি তৈরি করতে পারেন। প্রিমিয়াম নিলে এই সব সীমা উঠে যায়।';

  @override
  String get settingsFaq24Question => 'এআই সহকারী কী করতে পারে?';

  @override
  String get settingsFaq24Answer =>
      'মানি কোচ আপনার নিজের টাকা নিয়ে প্রশ্নের উত্তর দেয়: টাকা কোথায় গেল, বাজেট আর লক্ষ্যের হিসাবে ঠিক পথে আছেন কি না, কোন কোন বিল আসছে, আর কীভাবে কম খরচ বা বেশি সঞ্চয় করা যায়। এটি আপনার হিসাবের একটি সারাংশ দেখে (মোট, ক্যাটাগরি, বাজেট, লক্ষ্য, বিল আর সাম্প্রতিক লেনদেন), তাই উত্তরে আপনার আসল সংখ্যাই থাকে, আর প্রতিটি উত্তরের পর পরের প্রশ্ন সাজেস্ট করে। এটি সাধারণ পরামর্শ দেয়, পেশাদার আর্থিক পরামর্শ নয়। আপনার কথোপকথন সংরক্ষিত থাকে, তাই যেখানে থেমেছিলেন সেখান থেকে আবার শুরু করতে পারেন, আর যেকোনো সময় মুছে ফেলতে পারেন।';

  @override
  String get settingsFaq25Question => 'এআই বিশ্লেষণ কীভাবে কাজ করে?';

  @override
  String get settingsFaq25Answer =>
      'মাসিক সারাংশ (পরিসংখ্যান > খরচের বিশ্লেষণ) এই মাসকে গত মাসের সাথে তুলনা করে দেখায়: কত আয় আর খরচ হলো, আর প্রতিটি ক্যাটাগরি কীভাবে বদলাল। আমার সারাংশ লিখুন-এ ট্যাপ করলে এআই চোখে পড়ার মতো বিষয়গুলো তুলে ধরে আর চেষ্টা করার মতো একটি জিনিস সাজেস্ট করে। সংখ্যাগুলো সবার জন্য বিনামূল্যে; এআই-এর লেখা সারাংশে একটি এআই অনুরোধ লাগে।';

  @override
  String get settingsFaq26Question => 'স্মার্ট ক্যাটাগরি কী?';

  @override
  String get settingsFaq26Answer =>
      'আপনি নিজে কোনো লেনদেনের ক্যাটাগরি বেছে দিলে অ্যাপ মনে রাখে ওই শিরোনামটি কোন ক্যাটাগরির, আর পরের বার নিজেই সেটি বেছে দেয় (এগুলো নামকরণের নিয়ম-এ দেখতে ও বদলাতে পারবেন)। নতুন কিছুর জন্য যোগ করার স্ক্রিনে ঝিকিমিকি বোতামে ট্যাপ করে লিখে বলুন ব্যবহার করুন: যেমন লিখুন \'গতকাল bKash থেকে দুপুরের খাবার ২৫০\', আর এআই পরিমাণ, তারিখ, ক্যাটাগরি ও অ্যাকাউন্ট বসিয়ে দেবে, আপনি শুধু মিলিয়ে নেবেন।';

  @override
  String get settingsFaq27Question => 'এআই রসিদ স্ক্যানার কীভাবে কাজ করে?';

  @override
  String get settingsFaq27Answer =>
      'রসিদের ছবি তুলুন বা বেছে নিন। আপনার ফোন ডিভাইসেই লেখাটি পড়ে দোকান আর মোট টাকা সাজেস্ট করে। এআই দিয়ে পড়ুন-এ ট্যাপ করলে এআই আসল মোট, তারিখ, প্রতিটি আইটেম আর সঠিক ক্যাটাগরি বের করে, রসিদ এলোমেলো হলেও; শুধু লেখাটুকু পাঠানো হয়, ছবি কখনো নয়। সংরক্ষণের আগে সব দেখে নিয়ে বদলাতে পারবেন। এআই দিয়ে পড়তে একটি এআই অনুরোধ লাগে।';

  @override
  String get settingsFaq28Question =>
      'কতগুলো এআই অনুরোধ পাব, আর বিজ্ঞাপন কীসের জন্য?';

  @override
  String get settingsFaq28Answer =>
      'সবাই মাসে ১০টি বিনামূল্যের এআই অনুরোধ পান, যা ১ তারিখে আবার ফিরে আসে। আরও চাইলে নিজের ইচ্ছায় একটি ছোট বিজ্ঞাপন দেখে আরও একটি অনুরোধ নিতে পারেন, মাসে আরও ১০টি পর্যন্ত। বিজ্ঞাপন দেখে ২৪ ঘণ্টার জন্য প্রিমিয়াম থিম চালিয়ে দেখা বা একটি পিডিএফ রপ্তানিও আনলক করা যায়। আপনি বোতামে ট্যাপ করে নিশ্চিত করলে তবেই বিজ্ঞাপন চলে; কোনো ব্যানার বিজ্ঞাপন নেই, নিজে থেকে কিছুই আসে না। প্রিমিয়াম সদস্যরা কোনো বিজ্ঞাপন ছাড়াই সীমাহীন এআই আর বাকি সবকিছু পান।';

  @override
  String get settingsFaq29Question => 'আমার প্রিমিয়াম কেনাকাটা কীভাবে সামলাব?';

  @override
  String get settingsFaq29Answer =>
      'প্রিমিয়াম কেনাকাটা Google Play থেকে সামলানো হয়। আপনার প্ল্যান দেখতে বা বদলাতে Google Play-এর সাবস্ক্রিপশন সেটিংসে যান। প্রিমিয়াম মাসিক, বার্ষিক বা একবারের আজীবন কেনাকাটা হিসেবে পাওয়া যায়।';

  @override
  String get settingsFaqSectionPrivacySecurity => 'গোপনীয়তা ও নিরাপত্তা';

  @override
  String get settingsFaq30Question => 'বায়োমেট্রিক লক কীভাবে চালু করব?';

  @override
  String get settingsFaq30Answer =>
      'সেটিংস > গোপনীয়তা ও নিরাপত্তা-তে গিয়ে বায়োমেট্রিক লক চালু করুন। চালু হলে অ্যাপ খুলতে আঙুলের ছাপ বা মুখ লাগবে। কিছুক্ষণ ব্যবহার না করলে অ্যাপ যেন লক হয়ে যায়, সেজন্য স্বয়ংক্রিয় লকের সময়ও ঠিক করে দিতে পারেন।';

  @override
  String get settingsFaq31Question => 'আমার আর্থিক ডেটা কি নিরাপদ?';

  @override
  String get settingsFaq31Answer =>
      'হ্যাঁ। আপনার সব ডেটা আপনার ডিভাইসেই রাখা থাকে। ক্লাউড সিঙ্ক চালু করলে পাঠানোর সময় আপনার ডেটা এনক্রিপ্ট করা থাকে। আমরা কখনো আপনার আর্থিক ডেটা অন্য কারো সাথে শেয়ার করি না। আমাদের গোপনীয়তা নীতি সেটিংস > সম্পর্কে-তে দেখতে পারেন।';

  @override
  String get txnLoadPaymentMethodsFailed => 'পেমেন্ট পদ্ধতি লোড করা যায়নি';

  @override
  String get txnAddPaymentMethodFailed => 'পেমেন্ট পদ্ধতি যোগ করা যায়নি';

  @override
  String get txnPaymentMethodNotFound => 'পেমেন্ট পদ্ধতি পাওয়া যায়নি';

  @override
  String get txnUpdatePaymentMethodFailed => 'পেমেন্ট পদ্ধতি আপডেট করা যায়নি';

  @override
  String get txnDeletePaymentMethodFailed => 'পেমেন্ট পদ্ধতি মোছা যায়নি';

  @override
  String txnLoadFailed(String error) {
    return 'লেনদেন লোড করা যায়নি: $error';
  }

  @override
  String get txnAddFailed => 'লেনদেন যোগ করা যায়নি';

  @override
  String txnAddFailedWithError(String error) {
    return 'লেনদেন যোগ করা যায়নি: $error';
  }

  @override
  String get txnNotFound => 'লেনদেন পাওয়া যায়নি';

  @override
  String get txnUpdateFailed => 'লেনদেন আপডেট করা যায়নি';

  @override
  String txnNotATransfer(String id) {
    return 'লেনদেন $id কোনো ট্রান্সফার নয়';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'ট্রান্সফার আপডেট করা যায়নি: $error';
  }

  @override
  String get txnDeleteFailed => 'লেনদেন মোছা যায়নি';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'ট্রান্সফার লোড করা যায়নি: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'ট্রান্সফার তৈরি করা যায়নি: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'ট্রান্সফার মোছা যায়নি: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'ডেটা লোড করা যায়নি: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'পরিশোধিত হিসেবে চিহ্নিত করা যায়নি: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'অপরিশোধিত হিসেবে চিহ্নিত করা যায়নি: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'লেনদেন বাদ দেওয়া যায়নি: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'পাওয়া গেছে: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'পরিশোধ: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'ফেরত নেওয়া: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'নিষ্পত্তি হিসেবে চিহ্নিত করা যায়নি: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'পরিশোধের পরিমাণ শূন্যের বেশি হতে হবে';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'পরিশোধ লিখে রাখা যায়নি: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'বাকি হিসেবে চিহ্নিত করা যায়নি: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'বাকি: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return '$amount পরিশোধ লেখা হয়েছে';
  }

  @override
  String creditMarkedCollected(String title) {
    return '\"$title\" থেকে আদায় হয়েছে বলে চিহ্নিত';
  }

  @override
  String get importFieldDescription => 'বিবরণ';

  @override
  String get importFieldDirection => 'ধরন (জমা/খরচ)';

  @override
  String get importMissingDate => 'একটি তারিখের কলাম';

  @override
  String get importMissingAmount => 'একটি পরিমাণের কলাম';

  @override
  String importColumnN(int index) {
    return 'কলাম $index';
  }

  @override
  String get importNoDate => 'তারিখ নেই';

  @override
  String importDateMismatch(String date, String format) {
    return '\"$date\" তারিখটি $format-এর সাথে মেলে না';
  }

  @override
  String get importAnyKnownFormat => 'কোনো জানা ফরম্যাট';

  @override
  String get importNoAmount => 'পরিমাণ নেই';

  @override
  String get importIntro =>
      'আপনার ব্যাংক থেকে একটি CSV এক্সপোর্ট করে এখানে খুলুন। কলামগুলো আপনার জন্য চিনে নেওয়া হবে, আর ঠিক কী যোগ হবে তা দেখার আগে কিছুই যোগ হবে না।';

  @override
  String get importSavedBanks => 'সংরক্ষিত ব্যাংক';

  @override
  String get importChooseStatement => 'একটি স্টেটমেন্ট বাছুন';

  @override
  String get importNoRows => 'ওই ফাইলে কোনো সারি নেই।';

  @override
  String importUsingSavedMapping(String name) {
    return '$name-এর জন্য সংরক্ষিত ম্যাপিং ব্যবহার হচ্ছে।';
  }

  @override
  String importCouldNotRead(String error) {
    return 'ওই ফাইলটি পড়া যায়নি: $error';
  }

  @override
  String importForgetTitle(String name) {
    return '$name ভুলে যাবেন?';
  }

  @override
  String get importForgetBody => 'পরের বার আবার কলাম ম্যাপ করতে বলা হবে।';

  @override
  String get importColumnsHeader => 'কলাম';

  @override
  String get importHowToRead => 'মানগুলো কীভাবে পড়বে';

  @override
  String get importWhereItGoes => 'কোথায় যাবে';

  @override
  String get importWhatWillBeAdded => 'যা যোগ হবে';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সারি',
      one: '১টি সারি',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কলাম',
      one: '১টি কলাম',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return '$separator দিয়ে আলাদা';
  }

  @override
  String importMappedAs(String name) {
    return '$name হিসেবে ম্যাপ করা';
  }

  @override
  String get importDelimCommas => 'কমা';

  @override
  String get importDelimSemicolons => 'সেমিকোলন';

  @override
  String get importDelimTabs => 'ট্যাব';

  @override
  String get importDelimPipes => 'পাইপ (|)';

  @override
  String get importRequired => 'আবশ্যক';

  @override
  String get importNotImported => 'ইমপোর্ট হবে না';

  @override
  String get importEmptySample => 'খালি';

  @override
  String get importPickDateColumnFirst => 'আগে একটি তারিখের কলাম বাছুন।';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" এই ফরম্যাটে মেলে না।';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" পড়া হচ্ছে $date হিসেবে';
  }

  @override
  String get importDecimalAuto => 'ফাইল থেকে বের করা';

  @override
  String get importDecimalFullStop => 'দশমিক বিন্দু, যেমন 1,234.56';

  @override
  String get importDecimalComma => 'কমা, যেমন 1.234,56';

  @override
  String get importDuplicatesHint =>
      'দিন, পরিমাণ আর বিবরণ মিলিয়ে দেখে, তাই একই সময়ের স্টেটমেন্ট আবার ইমপোর্ট করলেও কিছু দ্বিগুণ হয় না';

  @override
  String importStillNeeds(String item) {
    return 'এখনও $item দরকার।';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'এখনও $first আর $second দরকার।';
  }

  @override
  String get importNothingReadable =>
      'এই সেটিংসে ফাইলের কিছুই পড়া যাচ্ছে না। তারিখের ফরম্যাট আর কোন কলামে পরিমাণ আছে তা দেখুন।';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন',
      one: '১টি লেনদেন',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount আয়';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount খরচ';
  }

  @override
  String importAndMore(int count) {
    return 'এবং আরও $countটি';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লাইন বাদ যাবে',
      one: '১টি লাইন বাদ যাবে',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লাইন বাদ যাবে।',
      one: '১টি লাইন বাদ যাবে।',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'লাইন $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'আগে একটি অ্যাকাউন্ট যোগ করুন';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন ইমপোর্ট করুন',
      one: '১টি লেনদেন ইমপোর্ট করুন',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন ইমপোর্ট করবেন?',
      one: '১টি লেনদেন ইমপোর্ট করবেন?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'এগুলো আপনার রেকর্ডে যোগ হবে এবং পরের সিঙ্কে আপলোড হবে।';

  @override
  String get importConfirmDuplicates =>
      'একই দিনে, একই পরিমাণ আর বিবরণে আগে থেকে যা আছে, তা ছোঁয়া হবে না।';

  @override
  String importFailed(String error) {
    return 'ইমপোর্ট ব্যর্থ হয়েছে: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$countটি ইমপোর্ট হয়েছে';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$countটি আগে থেকেই ছিল, তাই ছোঁয়া হয়নি।';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লাইন পড়া যায়নি।',
      one: '১টি লাইন পড়া যায়নি।',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'নতুন শ্রেণি: $names।';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'এই অ্যাকাউন্টের নামগুলোর সাথে এখানে কিছু মেলেনি, তাই সেগুলোর সারি আপনার বাছাই করা অ্যাকাউন্টে গেছে: $names।';
  }

  @override
  String get importRememberBody =>
      'এই একই কলামের পরের ফাইল জিজ্ঞেস না করেই এভাবে ম্যাপ হবে।';

  @override
  String get importNoHeaderCannotSave =>
      'কলামের শিরোনাম ছাড়া ফাইল আবার চেনা যায় না, তাই মেলানোর কিছু নেই।';

  @override
  String get importTemplateSaved =>
      'সংরক্ষিত। এই কলামের ফাইলগুলো এখন থেকে এটি ব্যবহার করবে।';

  @override
  String get txnTransferSameWallet => 'উৎস ও গন্তব্য ওয়ালেট আলাদা হতে হবে';

  @override
  String get txnTransferAmountPositive =>
      'ট্রান্সফারের পরিমাণ শূন্যের বেশি হতে হবে';

  @override
  String get txnTransferFeeNegative => 'ট্রান্সফার ফি ঋণাত্মক হতে পারে না';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'উৎস ওয়ালেট পাওয়া যায়নি: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'গন্তব্য ওয়ালেট পাওয়া যায়নি: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'ট্রান্সফার: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'ট্রান্সফারের জন্য দুটি ওয়ালেটই থাকতে হবে (উৎস: $source, গন্তব্য: $destination)।';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'একই মুদ্রার ট্রান্সফারে একটাই অঙ্ক যায়: $source আর $destination দুটোই $currency-এ, তাই পাওয়া পরিমাণ আলাদা হতে পারে না।';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return '$from আর $to-এর মধ্যে কোনো রেট জানা নেই, তাই $destination-এ আসলে কত এসেছে তা লিখুন।';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'পাওয়া পরিমাণ শূন্যের বেশি হতে হবে। $destination-এ আসলে কত এসেছে তা লিখুন।';
  }

  @override
  String txnFeeTitle(String title) {
    return 'ফি: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'লেনদেন পাওয়া যায়নি: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'লেনদেনটি ট্রান্সফার নয় (জোড়া লেনদেন নেই)';

  @override
  String txnPairedNotFound(String id) {
    return 'জোড়া লেনদেন $id পাওয়া যায়নি; ট্রান্সফারের অর্ধেক এডিট করা হবে না।';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'এমন কোনো অ্যাকাউন্ট নেই: $id';
  }

  @override
  String get walletCorrectionTitle => 'ব্যালেন্স সংশোধন';

  @override
  String walletCorrectionNote(String name) {
    return '$name-এর আসল ব্যালেন্সের সাথে মেলাতে সংশোধন করা হয়েছে।';
  }

  @override
  String get walletMergeIntoItself =>
      'কোনো অ্যাকাউন্ট নিজের সাথে মেলানো যায় না।';

  @override
  String get walletMergeBothMustExist =>
      'মেলাতে হলে দুটি অ্যাকাউন্টই থাকতে হবে।';

  @override
  String walletMergeNoRate(String from, String to) {
    return '$from আর $to-এর মধ্যে কোনো রেট জানা নেই, তাই এই অ্যাকাউন্টগুলো এখনও মেলানো যাবে না।';
  }

  @override
  String get walletMergeAdjustmentTitle => 'মেলানোর সমন্বয়';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'এই অ্যাকাউন্টগুলোর মধ্যে ট্রান্সফারের রেট আর $name মেলানোর রেট আলাদা। মোট যাতে না বদলায়, তাই পার্থক্যটা এখানে লেখা হলো।';
  }

  @override
  String get splitErrNoTotal => 'বিলের পরিমাণ লিখুন।';

  @override
  String get splitErrNoPeople => 'ভাগ করার জন্য কাউকে যোগ করুন।';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name এই বিলে নেই।';
  }

  @override
  String get splitErrNothingToRecord =>
      'অন্য কেউ দিয়েছে আর আপনার কোনো ভাগ নেই, তাই লেখার কিছু নেই।';

  @override
  String get splitErrGiveOwnShare => 'আপনার নিজের ভাগ লিখুন।';

  @override
  String splitErrGiveShare(String name) {
    return '$name-এর ভাগ লিখুন।';
  }

  @override
  String get splitErrNegativeShare => 'কোনো ভাগ ঋণাত্মক হতে পারে না।';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'ভাগগুলোর যোগফল $sum, $total নয়।';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'শতাংশগুলোর যোগফল $sum%, 100% নয়।';
  }

  @override
  String get splitErrNameTooLong => 'নাম ১০০ অক্ষরের কম রাখুন।';

  @override
  String splitErrDuplicateName(String name) {
    return '$name বিলে দুবার আছে।';
  }

  @override
  String get splitErrTitleTooLong => 'শিরোনাম ২০০ অক্ষরের কম রাখুন।';

  @override
  String get splitErrChooseAccount =>
      'কোন অ্যাকাউন্ট থেকে দেওয়া হয়েছে তা বাছুন।';

  @override
  String get splitErrOrdinaryAccount => 'একটি সাধারণ অ্যাকাউন্ট বাছুন।';

  @override
  String get splitErrYourShareNothing => 'আপনার ভাগ শূন্য, তাই কোনো পাওনা নেই।';

  @override
  String get splitErrEveryShareNothing => 'সব ভাগই শূন্য।';

  @override
  String get recurringDaily => 'প্রতিদিন';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count দিনে',
      one: 'প্রতিদিন',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count সপ্তাহে',
      one: 'প্রতি সপ্তাহে',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count মাসে',
      one: 'প্রতি মাসে',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count বছরে',
      one: 'প্রতি বছরে',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'প্রতি $count $unit';
  }

  @override
  String get recurringUntitled => 'পুনরাবৃত্ত লেনদেন';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিনে',
      one: '১ দিনে',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'আগামী সপ্তাহে';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সপ্তাহে',
      one: '১ সপ্তাহে',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'কার্ড';

  @override
  String get txnPmKindDigitalWallet => 'ডিজিটাল ওয়ালেট';

  @override
  String get txnPmEmptyHint =>
      'যে কার্ড আর অ্যাকাউন্ট দিয়ে পেমেন্ট করেন সেগুলো যোগ করুন, তাহলে লেনদেনে একটি বেছে নিতে পারবেন।';

  @override
  String get txnPmDeleteBody =>
      'এর সাথে আগে লেখা লেনদেনগুলোর রেকর্ড থেকে যাবে। শুধু সেগুলোতে আর কোনো পেমেন্ট পদ্ধতির নাম থাকবে না।';

  @override
  String get txnPmNew => 'নতুন পেমেন্ট পদ্ধতি';

  @override
  String get txnPmEdit => 'পেমেন্ট পদ্ধতি এডিট করুন';

  @override
  String get txnRecentlyDeletedFooter =>
      'মোছা লেনদেন ত্রিশ দিন রাখা হয়, তারপর চিরতরে মুছে যায়।';

  @override
  String get txnUnknownCategory => 'অজানা';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'হুবহু এটি';

  @override
  String get txnRuleContaining => 'যেকোনো কিছু যাতে এটি আছে';

  @override
  String get txnRulesFooter =>
      'নিয়মকে হুবহু না করলে শিরোনামের যেকোনো জায়গায় মিললেই কাজ করে। হাতে কিছু সাজালে অ্যাপ প্রতিবার আপনার জন্য একটি নিয়ম যোগ করে।';

  @override
  String get txnRulesEmptyHint =>
      'কোনটা কোথায় যাবে অ্যাপকে একবার শিখিয়ে দিন, তারপর থেকে সেভাবেই সাজাবে।';

  @override
  String get txnRuleNew => 'নতুন নিয়ম';

  @override
  String get txnRuleEdit => 'নিয়ম এডিট করুন';

  @override
  String get txnRuleExactHint => 'শুধু যেসব শিরোনাম হুবহু এটি';

  @override
  String get txnRuleContainingHint => 'যেকোনো শিরোনাম যাতে এটি আছে';

  @override
  String get txnKindTransfer => 'অ্যাকাউন্টের মধ্যে ট্রান্সফার';

  @override
  String get txnKindRecurring => 'পুনরাবৃত্ত এন্ট্রি থেকে';

  @override
  String get txnMoneyIn => 'টাকা এসেছে';

  @override
  String get txnMoneyOut => 'টাকা গেছে';

  @override
  String get txnNotYetPaid => 'এখনও পরিশোধ হয়নি';

  @override
  String get txnLentOut => 'ধার দেওয়া';

  @override
  String get txnSettledInFull => 'পুরোটা মিটে গেছে।';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid ফেরত এসেছে, $owed এখনও বাকি।';
  }

  @override
  String get txnUncategorised => 'শ্রেণিহীন';

  @override
  String get txnUnknownAccount => 'অজানা';

  @override
  String get txnTransferCannotCopy => 'ট্রান্সফার আলাদাভাবে কপি করা যায় না।';

  @override
  String get txnCopied => 'কপি হয়েছে।';

  @override
  String get txnDeleteOneBody =>
      'অ্যাকাউন্টের ব্যালেন্স আবার হিসাব হবে। এটি কোনো ট্রান্সফারের এক অংশ হলে, অন্য অংশটিও সাথে যাবে।';

  @override
  String txnUpcomingTab(int count) {
    return 'আসন্ন ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'মেয়াদ পেরিয়েছে ($count)';
  }

  @override
  String get txnNoOverdue => 'মেয়াদোত্তীর্ণ কোনো লেনদেন নেই';

  @override
  String get txnNoUpcoming => 'আসন্ন কোনো লেনদেন নেই';

  @override
  String get txnNoOverdueBody => 'আপনার সব পেমেন্ট সময়মতো আছে!';

  @override
  String get txnNoUpcomingBody => 'আপনার কোনো বাকি পেমেন্ট নির্ধারিত নেই';

  @override
  String get txnTotalOverdue => 'মোট মেয়াদোত্তীর্ণ';

  @override
  String get txnTotalUpcoming => 'মোট আসন্ন';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি আইটেম',
      one: '১টি আইটেম',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন পেরিয়েছে',
      one: '১ দিন পেরিয়েছে',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '\"$title\" পরিশোধিত হিসেবে চিহ্নিত হয়েছে';
  }

  @override
  String txnSkippedTitle(String title) {
    return '\"$title\" বাদ দেওয়া হয়েছে';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'আজ, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'গতকাল, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'আগামীকাল, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'লেনদেন মুছতে সমস্যা: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return '$title ফিল্টার';
  }

  @override
  String get txnMonthlyIncome => 'মাসিক আয়';

  @override
  String get txnMonthlyExpenses => 'মাসিক খরচ';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'লেনদেন',
      one: 'লেনদেন',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'প্রতি লেনদেনে গড়';

  @override
  String get txnNoPlannedIncome => 'কোনো পরিকল্পিত আয় নেই';

  @override
  String get txnNoPlannedExpenses => 'কোনো পরিকল্পিত খরচ নেই';

  @override
  String txnAddFutureIncome(String month) {
    return '$month-এর জন্য ভবিষ্যৎ আয় যোগ করুন';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return '$month-এর জন্য ভবিষ্যৎ খরচ যোগ করুন';
  }

  @override
  String get txnNoIncomeYet => 'এই মাসে এখনও কোনো আয় নেই';

  @override
  String get txnNoExpensesYet => 'এই মাসে এখনও কোনো খরচ নেই';

  @override
  String get txnStartTrackingIncome =>
      'এই মাসে আপনার আয়ের হিসাব রাখা শুরু করুন';

  @override
  String get txnStartTrackingExpenses =>
      'এই মাসে আপনার খরচের হিসাব রাখা শুরু করুন';

  @override
  String txnNoIncomeIn(String month) {
    return '$month-এ কোনো আয় নেই';
  }

  @override
  String txnNoExpensesIn(String month) {
    return '$month-এ কোনো খরচ নেই';
  }

  @override
  String txnNoRecordsFor(String month) {
    return '$month-এর কোনো রেকর্ড নেই';
  }

  @override
  String get txnOtherCategory => 'অন্যান্য';

  @override
  String get txnSearchIncome => 'আয় খুঁজুন';

  @override
  String get txnSearchExpenses => 'খরচ খুঁজুন';

  @override
  String txnErrorWith(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get txnTapToEditAmount => 'পরিমাণ এডিট করতে ট্যাপ করুন';

  @override
  String get txnTapToEnterAmount => 'পরিমাণ লিখতে ট্যাপ করুন';

  @override
  String get txnSpecialDefault => 'সাধারণ';

  @override
  String get txnSpecialRepetitive => 'পুনরাবৃত্ত';

  @override
  String get txnRepeatSettings => 'পুনরাবৃত্তির সেটিংস';

  @override
  String get txnSubscriptionSettings => 'সাবস্ক্রিপশন সেটিংস';

  @override
  String txnEndsOn(String date) {
    return 'শেষ: $date';
  }

  @override
  String get txnNoEndDate => 'শেষ তারিখ নেই';

  @override
  String get txnEditTransaction => 'লেনদেন এডিট করুন';

  @override
  String get txnNewTransaction => 'নতুন লেনদেন';

  @override
  String get txnFromAccount => 'যে অ্যাকাউন্ট থেকে';

  @override
  String get txnToAccount => 'যে অ্যাকাউন্টে';

  @override
  String get txnAmountReceived => 'পাওয়া পরিমাণ';

  @override
  String txnAmountReceivedHint(String account) {
    return 'এই অ্যাকাউন্টগুলো আলাদা মুদ্রায় হিসাব রাখে। $account-এ আসলে কত এসেছে লিখুন, অথবা অ্যাপের রেট ব্যবহার করতে ফাঁকা রাখুন।';
  }

  @override
  String txnInCurrency(String currency) {
    return '$currency-এ';
  }

  @override
  String get txnTransferTitleHint => 'যেমন সঞ্চয়ে সরানো (ঐচ্ছিক)';

  @override
  String get txnTitleHint => 'কীসের জন্য ছিল?';

  @override
  String get txnUpdate => 'আপডেট';

  @override
  String get txnSelectCategory => 'শ্রেণি বাছুন';

  @override
  String get txnSearchTransactions => 'লেনদেন খুঁজুন';

  @override
  String get txnSpecialRegular => 'সাধারণ';

  @override
  String get txnSpecialLend => 'ধার দিন';

  @override
  String get txnSpecialBorrow => 'ধার নিন';

  @override
  String get txnSpecialRegularDesc => 'সাধারণ লেনদেন';

  @override
  String get txnSpecialUpcomingDesc => 'ভবিষ্যতের পেমেন্ট যা ট্র্যাক করবেন';

  @override
  String get txnSpecialSubscriptionDesc => 'নিয়মিত সার্ভিসের পেমেন্ট';

  @override
  String get txnSpecialRepetitiveDesc => 'পুনরাবৃত্ত লেনদেন';

  @override
  String get txnSpecialLendDesc =>
      'আপনার ধার দেওয়া টাকা (তারা আপনার কাছে ঋণী)';

  @override
  String get txnSpecialBorrowDesc =>
      'আপনার ধার নেওয়া টাকা (আপনি তাদের কাছে ঋণী)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'নিচের সীমা উপরের সীমার চেয়ে বেশি, তাই কিছুই মিলবে না। $min থেকে $max।';
  }

  @override
  String get walletMyWallet => 'আমার ওয়ালেট';

  @override
  String walletCreateFailed(String error) {
    return 'ওয়ালেট তৈরি করা যায়নি: $error';
  }

  @override
  String get walletTypeBankAccount => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get walletTypeCreditCard => 'ক্রেডিট কার্ড';

  @override
  String get walletTypeSubscription => 'সাবস্ক্রিপশন';

  @override
  String get walletTypeDeposit => 'ডিপোজিট';

  @override
  String get walletTypeInvestment => 'বিনিয়োগ';

  @override
  String get walletTypeAsset => 'সম্পদ';

  @override
  String get walletEnterAccountName => 'অনুগ্রহ করে অ্যাকাউন্টের নাম লিখুন';

  @override
  String get walletCreditLimitRequired => 'ক্রেডিট লিমিট দিতে হবে';

  @override
  String get walletEnterValidCreditLimit =>
      'অনুগ্রহ করে সঠিক ক্রেডিট লিমিট লিখুন';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'অনুগ্রহ করে ০-এর বেশি সঠিক ক্রেডিট লিমিট লিখুন';

  @override
  String get walletEditWallet => 'ওয়ালেট এডিট করুন';

  @override
  String get walletAddNewWallet => 'নতুন ওয়ালেট যোগ করুন';

  @override
  String get walletEnterWalletNameError => 'অনুগ্রহ করে ওয়ালেটের নাম লিখুন';

  @override
  String get walletEnterValidNumber => 'অনুগ্রহ করে সঠিক সংখ্যা লিখুন';

  @override
  String get walletShowCents => 'পয়সা দেখান (যেমন \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'শুধু পূর্ণ সংখ্যা (যেমন \$1,235)';

  @override
  String get walletCreateWallet => 'ওয়ালেট তৈরি করুন';

  @override
  String get walletClosedPill =>
      'বন্ধ। এর ইতিহাস রাখা আছে, কিন্তু এটি আর দেখানো বা গোনা হয় না।';

  @override
  String get walletExcludedPill => 'সব অ্যাকাউন্টের মোট থেকে বাদ রাখা হয়েছে।';

  @override
  String get walletReopen => 'আবার খুলুন';

  @override
  String get walletCloseAccount => 'অ্যাকাউন্ট বন্ধ করুন';

  @override
  String get walletReopenSubtitle => 'আবার দেখান এবং গুনুন';

  @override
  String get walletCloseAccountSubtitle => 'ইতিহাস রাখুন, গোনা বন্ধ করুন';

  @override
  String get walletIncludeInTotal => 'মোটে যোগ করুন';

  @override
  String get walletLeaveOutOfTotal => 'মোট থেকে বাদ দিন';

  @override
  String get walletAlreadyTheBalance => 'এটাই এখনকার ব্যালেন্স।';

  @override
  String get walletCorrectionRecorded =>
      'পার্থক্যটি সংশোধন হিসেবে লেখা হয়েছে।';

  @override
  String walletMergeConfirmBody(String name) {
    return '$name-এর সবকিছু সরে যাবে, আর $name বন্ধ হবে। কিছুই মোছা হবে না।';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'সরানোর সময় পরিমাণ $from থেকে $to-এ রূপান্তর হবে। কিছুই মোছা হবে না, আর $name মুছে না দিয়ে বন্ধ করা হবে।';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount জমা · $available পাওয়া যাবে';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount দেনা · $available এখনও পাওয়া যাবে';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return '$name-এ আসলে কত আছে লিখুন। পার্থক্যটি একটি লেনদেন হিসেবে লেখা হবে, যাতে অ্যাকাউন্টের হিসাব তার ইতিহাসের সাথে মেলে।';
  }

  @override
  String get apiUpdateRequired =>
      'সিঙ্ক চালু রাখতে The Accountant আপডেট করুন। আপডেট না করা পর্যন্ত সবকিছু এই ফোনেই থাকবে।';

  @override
  String get apiAccountExistsLink =>
      'এই ইমেইল দিয়ে আগে থেকেই একটি অ্যাকাউন্ট আছে। অনুগ্রহ করে আপনার অ্যাকাউন্টগুলো লিংক করুন।';

  @override
  String get apiServerTrouble =>
      'আমাদের সার্ভারে এই মুহূর্তে সমস্যা হচ্ছে। সবকিছু এই ফোনে নিরাপদ আছে; কয়েক মিনিট পরে আবার চেষ্টা করুন।';

  @override
  String apiRequestFailedHttp(String status) {
    return 'অনুরোধ ব্যর্থ হয়েছে (HTTP $status)।';
  }

  @override
  String get apiServerTimeout =>
      'আমাদের সার্ভার উত্তর দিতে অনেক দেরি করেছে। আপনার সংযোগ দেখুন, অথবা কয়েক মিনিট পরে আবার চেষ্টা করুন।';

  @override
  String get apiCannotReachServer =>
      'আমাদের সার্ভারে পৌঁছানো যাচ্ছে না। আপনার সংযোগ দেখুন; অনলাইনে থাকলে কয়েক মিনিট পরে আবার চেষ্টা করুন।';

  @override
  String get apiSomethingWentWrong =>
      'আমাদের সার্ভারের সাথে যোগাযোগে কিছু ভুল হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get syncAlreadyInProgress => 'সিঙ্ক ইতিমধ্যে চলছে';

  @override
  String get syncRequiresPremium =>
      'ক্লাউড সিঙ্কের জন্য প্রিমিয়াম সাবস্ক্রিপশন লাগবে';

  @override
  String get syncNoInternet => 'ইন্টারনেট সংযোগ নেই';

  @override
  String get syncNotAuthenticated => 'সাইন ইন করা নেই';

  @override
  String get syncCouldNotFetchCloud =>
      'আপনার ক্লাউড ডেটা আনা যায়নি। এই ডিভাইসের ডেটা অপরিবর্তিত আছে।';

  @override
  String get syncAccountUnknown =>
      'সাইন-ইন করা অ্যাকাউন্টটি বোঝা যায়নি; সিঙ্ক বাতিল করা হয়েছে।';

  @override
  String get syncStoreOtherAccount =>
      'এই ডিভাইসের ডেটা অন্য একটি অ্যাকাউন্টের। সিঙ্ক করার আগে সেই অ্যাকাউন্টে সাইন ইন করুন, অথবা এই ডিভাইসের ডেটা মুছে ফেলুন।';

  @override
  String syncRecordsNotSaved(String record) {
    return 'কিছু ক্লাউড রেকর্ড এই ডিভাইসে সেভ করা যায়নি: $record। পরের সিঙ্কে আবার চেষ্টা করা হবে।';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'কিছু ক্লাউড রেকর্ড এই ডিভাইসে সেভ করা যায়নি: $record (এবং আরও $countটি)। পরের সিঙ্কে আবার চেষ্টা করা হবে।';
  }

  @override
  String notifCardStatementReady(String name) {
    return '$name-এর স্টেটমেন্ট তৈরি';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'মোট $amount, আগেই পরিশোধ হয়েছে। আর কিছু বাকি নেই।';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$date-এর মধ্যে $amount পরিশোধ করতে হবে।';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$owed-এর মধ্যে $paid আগেই পরিশোধ হয়েছে।';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return '$name-এর বিল কাল পরিশোধের শেষ দিন';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return '$name-এর বিল $days দিন পরে পরিশোধ করতে হবে';
  }

  @override
  String notifPayBy(String amount, String date) {
    return '$date-এর মধ্যে $amount পরিশোধ করুন।';
  }

  @override
  String notifCardDueToday(String name) {
    return '$name-এর বিল আজ পরিশোধের শেষ দিন';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount এখনও বাকি।$paidSoFar আজ পরিশোধ করলে লেট ফি এড়ানো যাবে।';
  }

  @override
  String get notifWhenToday => 'আজ';

  @override
  String get notifWhenTomorrow => 'কাল';

  @override
  String notifWhenInDays(int days) {
    return '$days দিন পরে';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name $when টাকা দেবে';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$date তারিখে $amount $account-এ আসার কথা।';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name-এর মেয়াদ $when পূর্ণ হবে';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$date তারিখে $amount $account-এ ফিরে আসবে।';
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
      'dps': 'জমা',
      'insurance': 'প্রিমিয়াম',
      'sip': 'SIP',
      'other': 'কিস্তি',
    });
    return '$name: $totalটির মধ্যে $number নম্বর $_temp0 $when দিতে হবে';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return '$date-এর মধ্যে $amount বিনিয়োগ করুন।';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$date তারিখে $account থেকে $amount বিনিয়োগ করা হবে।';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$date তারিখে $account থেকে $amount লেখা হবে।';
  }

  @override
  String get notifYourAccount => 'আপনার অ্যাকাউন্ট';

  @override
  String get notifPlansUpdatedTitle => 'EMI ও সঞ্চয় আপডেট হয়েছে';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি প্ল্যান এন্ট্রি নির্ধারিত দিনে লেখা হয়েছে।',
      one: '১টি প্ল্যান এন্ট্রি নির্ধারিত দিনে লেখা হয়েছে।',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'পুনরাবৃত্ত লেনদেন লেখা হয়েছে';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পুনরাবৃত্ত লেনদেন লেখা হয়েছে।',
      one: '১টি পুনরাবৃত্ত লেনদেন লেখা হয়েছে।',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পেমেন্ট নিশ্চিত করতে হবে',
      one: '১টি পেমেন্ট নিশ্চিত করতে হবে',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'আসন্ন-তে গিয়ে কত কাটা হয়েছে তা নিশ্চিত করুন, অথবা বাদ দিন।';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — আসন্ন-তে গিয়ে কত কাটা হয়েছে তা নিশ্চিত করুন, অথবা বাদ দিন।';
  }

  @override
  String get notifUpcomingFallbackTitle => 'আসন্ন লেনদেন';

  @override
  String notifUpcomingTitle(String title) {
    return 'আসন্ন: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return '$amount আয় শিগগিরই আসার কথা।';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return '$amount খরচ শিগগিরই দিতে হবে।';
  }

  @override
  String get notifCreditFallback => 'ধার';

  @override
  String get notifDebtFallback => 'দেনা';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'বকেয়া ধার: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'বকেয়া দেনা: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount এখনও বাকি আছে। দেখতে ট্যাপ করুন।';
  }

  @override
  String get notifRecurringFallbackTitle => 'পুনরাবৃত্ত লেনদেন';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'আসন্ন পুনরাবৃত্ত: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$date তারিখে $amount দিতে হবে।';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'ধার ফেরতের সময়: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'দেনা শোধের সময়: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'সাবস্ক্রিপশনের পেমেন্ট: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'বিল দেওয়ার সময়: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'শিগগিরই দিতে হবে: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'পুনরাবৃত্ত বিল';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount শিগগিরই দিতে হবে। দেখতে ট্যাপ করুন।';
  }

  @override
  String get notifChannelRecurring => 'পুনরাবৃত্ত লেনদেন';

  @override
  String get notifChannelRecurringDesc =>
      'নিজে থেকে তৈরি পুনরাবৃত্ত লেনদেনের নোটিফিকেশন';

  @override
  String get notifChannelUpcoming => 'আসন্ন অনুস্মারক';

  @override
  String get notifChannelUpcomingDesc => 'আসন্ন লেনদেনের অনুস্মারক';

  @override
  String get notifChannelLoan => 'ধার-দেনার অনুস্মারক';

  @override
  String get notifChannelLoanDesc => 'বকেয়া ধার ও দেনার অনুস্মারক';

  @override
  String get notifChannelDueDate => 'নির্ধারিত তারিখের অনুস্মারক';

  @override
  String get notifChannelDueDateDesc =>
      'নির্দিষ্ট লেনদেনের তারিখের জন্য একবারের অনুস্মারক';

  @override
  String get notifChannelBillsDesc =>
      'সামনের ক্রেডিট কার্ডের বিল ও প্ল্যানের কিস্তি';

  @override
  String get notifOffset1Hour => '১ ঘণ্টা আগে';

  @override
  String get notifOffset1Day => '১ দিন আগে';

  @override
  String get notifOffset3Days => '৩ দিন আগে';

  @override
  String get notifOffset1Week => '১ সপ্তাহ আগে';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes মিনিট আগে';
  }

  @override
  String get notifChannelGeneral => 'সাধারণ';

  @override
  String get notifChannelGeneralDesc => 'অ্যাকাউন্ট ও অ্যাপের নোটিফিকেশন';

  @override
  String get notifChannelReminders => 'দৈনিক অনুস্মারক';

  @override
  String get notifChannelRemindersDesc => 'দিনের খরচ লিখে রাখার একটি তাগিদ';

  @override
  String get notifChannelBillsStatementsDesc =>
      'ক্রেডিট কার্ডের স্টেটমেন্ট ও পরিশোধের তারিখ';

  @override
  String get notifChannelBudgets => 'বাজেট সতর্কতা';

  @override
  String get notifChannelBudgetsDesc =>
      'যখন কোনো বাজেট প্রায় বা পুরোপুরি খরচ হয়ে যায়';

  @override
  String notifOverBudgetTitle(String name) {
    return 'বাজেট ছাড়িয়েছে: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'বাজেট সতর্কতা: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'এই সময়ের জন্য আপনার $name বাজেটের $percent% খরচ করেছেন।';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'আপনার $name বাজেটের $percent% ব্যবহার হয়ে গেছে।';
  }

  @override
  String get notifPremiumEndingTitle => 'প্রিমিয়ামের মেয়াদ শিগগিরই শেষ হবে';

  @override
  String get notifPremiumEndsTomorrow =>
      'আপনার প্রিমিয়াম কাল শেষ হবে। প্রিমিয়াম ফিচারগুলো রাখতে রিনিউ করুন।';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'আপনার প্রিমিয়াম $days দিন পরে শেষ হবে। প্রিমিয়াম ফিচারগুলো রাখতে রিনিউ করুন।';
  }

  @override
  String get notifLargeIncomeTitle => 'বড় আয়ের সতর্কতা';

  @override
  String get notifLargeExpenseTitle => 'বড় খরচের সতর্কতা';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return '$amount আয় লেখা হয়েছে: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return '$amount আয় লেখা হয়েছে';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return '$amount খরচ লেখা হয়েছে: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return '$amount খরচ লেখা হয়েছে';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'দৈনিক খরচের অনুস্মারক নোটিফিকেশন';

  @override
  String get notifDailyReminderTitle => 'দৈনিক খরচের অনুস্মারক';

  @override
  String get notifDailyReminderBody =>
      'আজকের খরচগুলো লিখতে ভুলবেন না! খরচের হিসাব রাখুন।';

  @override
  String get notifTestTitle => 'টেস্ট নোটিফিকেশন';

  @override
  String get notifTestBody => 'এটি দেখতে পেলে নোটিফিকেশন কাজ করছে!';

  @override
  String get notifActionSnooze1Day => '১ দিন পরে';

  @override
  String get notifActionSnooze1Week => '১ সপ্তাহ পরে';

  @override
  String get notifGroupThisWeek => 'এই সপ্তাহ';

  @override
  String get notifGroupThisMonth => 'এই মাস';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return '$count মি. আগে';
  }

  @override
  String notifHoursAgo(int count) {
    return '$count ঘ. আগে';
  }

  @override
  String notifDaysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String get notifPrimerSheetBody =>
      'নোটিফিকেশন চালু করুন, জরুরি বিষয়ে আমরা আগেভাগে জানিয়ে দেব।';

  @override
  String get notifPrimerBudgetsBody => 'বাজেটের বেশি খরচ করার আগেই জানুন।';

  @override
  String get notifPrimerBillsTitle => 'বিল ও সাবস্ক্রিপশনের অনুস্মারক';

  @override
  String get notifPrimerBillsBody => 'কোনো পুনরাবৃত্ত পেমেন্ট আর মিস হবে না।';

  @override
  String get notifPrimerLargeTitle => 'বড় লেনদেন';

  @override
  String get notifPrimerLargeBody => 'অস্বাভাবিক লেনদেন হলে জানতে পারবেন।';

  @override
  String get notifLoadFailed => 'নোটিফিকেশন লোড করা যায়নি';

  @override
  String get startupReasonSomethingWrong =>
      'চালু হওয়ার সময় কিছু ভুল হয়েছে। আপনার ডেটা এই ডিভাইসে নিরাপদ আছে।';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'এই অ্যাকাউন্টের এই ডিভাইসের ডেটা খোলা যায়নি।';

  @override
  String get startupReasonSetupFailed =>
      'এই ডিভাইসে এই অ্যাকাউন্ট সেটআপ শেষ করা যায়নি। কিছুই মুছে ফেলা হয়নি।';

  @override
  String get startupReasonOffline =>
      'আপনার অ্যাকাউন্টে পৌঁছানো যায়নি, আর এই ডিভাইসে এখনও এর ডেটা নেই। আগে The Accountant ব্যবহার করে থাকলে ইন্টারনেটে যুক্ত হন, আমরা আপনার ডেটা ফিরিয়ে আনব। নতুন? এখনই এই ডিভাইসে শুরু করতে পারেন।';

  @override
  String get startupReasonNeedsSubscription =>
      'এই অ্যাকাউন্টের ডেটা ক্লাউডে সেভ করা আছে। ফিরিয়ে আনতে সক্রিয় সাবস্ক্রিপশন লাগবে। কিছুই মুছে ফেলা হয়নি।';

  @override
  String get startupReasonConfirmingSubscription =>
      'এই অ্যাকাউন্টের ডেটা ক্লাউডে আছে। ফিরিয়ে আনার জন্য আমরা এখনও আপনার সাবস্ক্রিপশন যাচাই করছি।';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'ফিরিয়ে আনা যায়নি: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'এই অ্যাকাউন্টের ডেটা ক্লাউডে আছে, কিন্তু এখনও ফিরিয়ে আনা যায়নি।';

  @override
  String get commonBiometricReason =>
      'The Accountant আনলক করতে পরিচয় যাচাই করুন';

  @override
  String get commonLoadCurrenciesFailed => 'মুদ্রার তালিকা লোড করা যায়নি';

  @override
  String get commonLoadRatesFailed => 'বিনিময় হার লোড করা যায়নি';

  @override
  String get commonRefreshRatesFailed => 'বিনিময় হার রিফ্রেশ করা যায়নি';

  @override
  String get commonAllCategories => 'সব ক্যাটাগরি';

  @override
  String commonCategoryCount(int count) {
    return '$countটি ক্যাটাগরি';
  }

  @override
  String get commonTierFree => 'ফ্রি';

  @override
  String get commonTierMonthly => 'প্রিমিয়াম মাসিক';

  @override
  String get commonTierYearly => 'প্রিমিয়াম বার্ষিক';

  @override
  String get commonTierLifetime => 'প্রিমিয়াম লাইফটাইম';

  @override
  String get commonCategoryMergeSelf =>
      'কোনো ক্যাটাগরিকে নিজের সাথে মেলানো যায় না।';

  @override
  String get commonCategoryMergeMissing =>
      'মেলাতে হলে দুটি ক্যাটাগরিই থাকতে হবে।';

  @override
  String get commonCategoryMergeSystem =>
      'অ্যাপের নিজস্ব ক্যাটাগরিগুলো মেলানো যায় না।';

  @override
  String get commonCategoryMergeKinds =>
      'আয় ও খরচের ক্যাটাগরি মেলানো যায় না।';

  @override
  String get commonCategoryOneLevel =>
      'ওই ক্যাটাগরিটি আরেকটির ভেতরে আছে, আর ক্যাটাগরি কেবল এক স্তর গভীর হতে পারে।';

  @override
  String get commonCategoryMoveSame =>
      'সরানোর জন্য অন্য একটি ক্যাটাগরি বেছে নিন।';

  @override
  String get commonCategoryMoveMissing =>
      'সরাতে হলে দুটি ক্যাটাগরিই থাকতে হবে।';

  @override
  String get commonCategoryMoveSystem =>
      'অ্যাপের নিজস্ব ক্যাটাগরির মধ্যে সরানো যায় না।';

  @override
  String get commonCategoryMoveKinds =>
      'আয় ও খরচের লেনদেন একে অপরের ক্যাটাগরিতে যেতে পারে না।';

  @override
  String get commonCategoryGone => 'ওই ক্যাটাগরিটি আর নেই।';

  @override
  String get commonCategoryParentSystem =>
      'অ্যাপের নিজস্ব ক্যাটাগরি সরানো যায় না।';

  @override
  String get commonCategoryParentSelf =>
      'কোনো ক্যাটাগরি নিজের ভেতরে থাকতে পারে না।';

  @override
  String get commonCategoryParentIntoSystem =>
      'অ্যাপের নিজস্ব ক্যাটাগরির ভেতরে কিছু রাখা যায় না।';

  @override
  String get commonCategoryParentKinds =>
      'আয়ের ক্যাটাগরি আর খরচের ক্যাটাগরি একটির ভেতরে আরেকটি রাখা যায় না।';

  @override
  String get commonCategoryHasChildren =>
      'এই ক্যাটাগরির নিজস্ব সাব-ক্যাটাগরি আছে, তাই এটি উপরের স্তরেই থাকবে।';

  @override
  String get commonTapToChange => 'বদলাতে ট্যাপ করুন';

  @override
  String get commonSelectColor => 'রং বেছে নিন';

  @override
  String get commonShowPalette => 'প্যালেট দেখান';

  @override
  String get commonCustomColor => 'নিজের রং';

  @override
  String get commonSelectCurrency => 'মুদ্রা বেছে নিন';

  @override
  String get commonEnableCryptoHint =>
      'ক্রিপ্টো টোকেন খুঁজতে \'ক্রিপ্টো মুদ্রাও দেখান\' চালু করুন।';

  @override
  String get commonSearchHint => 'খুঁজুন...';

  @override
  String get aiLoadConversationsFailed => 'কথোপকথনগুলো লোড করা যায়নি।';

  @override
  String get aiLoadHistoryFailed => 'চ্যাটের ইতিহাস লোড করা যায়নি।';

  @override
  String get aiPremiumRequired =>
      'AI সহকারীর জন্য প্রিমিয়াম সাবস্ক্রিপশন লাগবে';

  @override
  String get aiUnexpectedError =>
      'অপ্রত্যাশিত একটি সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get aiResponseFailed =>
      'AI-এর উত্তর পাওয়া যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get aiServiceNotAnswering => 'AI পরিষেবা উত্তর দিচ্ছে না।';

  @override
  String get aiReplyCutOff =>
      'উত্তরটি মাঝপথে থেমে গেছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get aiCouldNotReachServer =>
      'সার্ভারে পৌঁছানো যায়নি। আপনার সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get aiSomethingWentWrong => 'কিছু একটা ভুল হয়েছে।';

  @override
  String get aiOpenConversationFailed => 'কথোপকথনটি খোলা যায়নি।';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'আপনার $countটি পরিবর্তন সেভ হয়েছে, কিন্তু কোচ উত্তর শেষ করতে পারেনি। আবার জিজ্ঞেস করার আগে আপনার হিসাবে এগুলো দেখে নিন।',
      one:
          'আপনার পরিবর্তনটি সেভ হয়েছে, কিন্তু কোচ উত্তর শেষ করতে পারেনি। আবার জিজ্ঞেস করার আগে আপনার হিসাবে এটি দেখে নিন।',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'AI পরিষেবা এই মুহূর্তে উত্তর দিচ্ছে না। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String aiMinutesShort(int count) {
    return '$count মি.';
  }

  @override
  String aiHoursShort(int count) {
    return '$count ঘ.';
  }

  @override
  String aiDaysShort(int count) {
    return '$count দিন';
  }

  @override
  String get aiOcrTextFailed => 'ছবি থেকে লেখা বের করা যায়নি';

  @override
  String get aiOcrReceiptFailed => 'ছবি থেকে রসিদের তথ্য বের করা যায়নি';

  @override
  String get coachYes => 'হ্যাঁ';

  @override
  String get coachNo => 'না';

  @override
  String get coachTradeBuy => 'কেনা';

  @override
  String get coachTradeSell => 'বিক্রি';

  @override
  String get coachTradeDividend => 'লভ্যাংশ';

  @override
  String get planAccountGone => 'ওই অ্যাকাউন্টটি আর নেই।';

  @override
  String get planPaidFromOrdinary =>
      'প্ল্যানের টাকা সাধারণ অ্যাকাউন্ট থেকে দেওয়া হয়, ডিপোজিট থেকে নয়।';

  @override
  String get planSipChooseHolding =>
      'এসআইপি কোন ফান্ড বা শেয়ার কিনবে তা বেছে নিন।';

  @override
  String get planSipPayFromOther => 'অন্য অ্যাকাউন্ট থেকে এসআইপির টাকা দিন।';

  @override
  String get planNeedNameError => 'প্ল্যানের একটি নাম দিন।';

  @override
  String get planInstallmentCountRange =>
      'কিস্তির সংখ্যা ১ থেকে ১২০০-এর মধ্যে হতে হবে।';

  @override
  String get planIntervalMin => 'ব্যবধান কমপক্ষে ১ হতে হবে।';

  @override
  String get planRateRange => 'হার ০ থেকে ১০০ শতাংশের মধ্যে হতে হবে।';

  @override
  String get planTaxRange => 'কর ০ থেকে ১০০ শতাংশের মধ্যে হতে হবে।';

  @override
  String get planProviderTooLong =>
      'কোম্পানির নাম ও নম্বর ১০০ অক্ষরের কম রাখুন।';

  @override
  String get planNeedPremium => 'প্রিমিয়ামের পরিমাণ লিখুন।';

  @override
  String get planNeedInstallmentAmount => 'প্রতি কিস্তির পরিমাণ লিখুন।';

  @override
  String get planNeedDeposited => 'জমা দেওয়া পরিমাণ লিখুন।';

  @override
  String get planTermMonthsOrYears => 'এর মেয়াদ মাস বা বছরে হয়।';

  @override
  String get planAmountNotNegative => 'পরিমাণ ঋণাত্মক হতে পারে না।';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name-এর মেয়াদ পূর্ণ হবে $date-এ। তার আগে টাকা তুলতে চাইলে আগেভাগে বন্ধ করুন।';
  }

  @override
  String get planNoLongerExists => 'ওই প্ল্যানটি আর নেই।';

  @override
  String get planReminderDaysRange =>
      'রিমাইন্ডার ০ (বন্ধ) থেকে ৩০ দিন আগে পর্যন্ত হতে পারে।';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name-এ এখনো টাকা আছে। আগে এটি বন্ধ করুন, তাতে টাকা $account-এ ফিরে যাবে।';
  }

  @override
  String get planItsAccount => 'এর অ্যাকাউন্ট';

  @override
  String planAlreadyEnded(String name) {
    return '$name ইতিমধ্যে শেষ হয়ে গেছে।';
  }

  @override
  String get investNeedName => 'বিনিয়োগটির একটি নাম দিন।';

  @override
  String get investNameTooLong => 'নাম ১০০ অক্ষরের কম রাখুন।';

  @override
  String get investSymbolTooLong => 'সিম্বল ২০ অক্ষরের কম রাখুন।';

  @override
  String get investPriceNotNegative => 'দাম ঋণাত্মক হতে পারে না।';

  @override
  String investAlreadyTracked(String name) {
    return '$name আগে থেকেই ট্র্যাক করা হচ্ছে।';
  }

  @override
  String get investNeedPaid => 'কত টাকা দেওয়া হয়েছে লিখুন।';

  @override
  String get investUnitsBoughtPositive => 'কেনা ইউনিট শূন্যের বেশি হতে হবে।';

  @override
  String get investPayFromOther => 'অন্য অ্যাকাউন্ট থেকে টাকা দিন।';

  @override
  String get investNeedSaleAmount => 'বিক্রি থেকে কত টাকা এসেছে লিখুন।';

  @override
  String get investUnitsSoldPositive =>
      'বিক্রি করা ইউনিট শূন্যের বেশি হতে হবে।';

  @override
  String get investSellIntoOther => 'অন্য অ্যাকাউন্টে বিক্রির টাকা নিন।';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return '$name-এর মাত্র $units ইউনিট আছে।';
  }

  @override
  String get investNeedDividend => 'পাওয়া লভ্যাংশ লিখুন।';

  @override
  String get investReceiveIntoOrdinary => 'সাধারণ কোনো অ্যাকাউন্টে টাকা নিন।';

  @override
  String get investPricePositive => 'দাম শূন্যের বেশি হতে হবে।';

  @override
  String get investUnitsPositive => 'ইউনিট শূন্যের বেশি হতে হবে।';

  @override
  String get investNotATrade => 'এটি কোনো বিনিয়োগের কেনাবেচা নয়।';

  @override
  String investStillHoldsUnits(String name) {
    return '$name-এ এখনো ইউনিট আছে। আগে সেগুলো বিক্রি করুন।';
  }

  @override
  String get investNoLongerExists => 'ওই বিনিয়োগটি আর নেই।';

  @override
  String get networthNeedAssetName => 'সম্পত্তিটির একটি নাম দিন।';

  @override
  String get networthValueNotNegative => 'মূল্য ঋণাত্মক হতে পারে না।';

  @override
  String get networthNeedPaidFor => 'এর জন্য কত টাকা দেওয়া হয়েছে লিখুন।';

  @override
  String get networthPayFromOrdinary => 'সাধারণ কোনো অ্যাকাউন্ট থেকে টাকা দিন।';

  @override
  String get networthNeedWorth => 'এর বর্তমান মূল্য লিখুন।';

  @override
  String get networthNeedSoldFor => 'কত টাকায় বিক্রি হয়েছে লিখুন।';

  @override
  String get networthReceiveIntoOrdinary => 'সাধারণ কোনো অ্যাকাউন্টে টাকা নিন।';

  @override
  String networthStillWorth(String name) {
    return '$name-এর এখনো মূল্য আছে। আগে এটি বিক্রি করুন, অথবা মূল্য শূন্য করে দিন।';
  }

  @override
  String get networthAssetGone => 'ওই সম্পত্তি আর ট্র্যাক করা হচ্ছে না।';

  @override
  String get zakatNeedAmountPaid => 'পরিশোধিত পরিমাণ লিখুন।';

  @override
  String get zakatPayFromOrdinary => 'সাধারণ কোনো অ্যাকাউন্ট থেকে পরিশোধ করুন।';

  @override
  String get zakatReminderTitleToday => 'আজ আপনার যাকাত দেওয়ার দিন';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন পর যাকাত দেওয়ার দিন',
      one: '১ দিন পর যাকাত দেওয়ার দিন',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'আজ আপনার যাকাত বছর পূর্ণ হচ্ছে। কত দিতে হবে দেখতে ট্যাপ করুন।';

  @override
  String zakatReminderBodyOn(String date) {
    return 'আপনার যাকাত বছর পূর্ণ হবে $date-এ। কত দিতে হবে দেখতে ট্যাপ করুন।';
  }

  @override
  String get budgetCheckFailed => 'বাজেট যাচাই করা যায়নি';

  @override
  String get budgetLoadFailed => 'বাজেট লোড করা যায়নি';

  @override
  String get budgetAddFailed => 'বাজেট যোগ করা যায়নি';

  @override
  String get budgetNotFound => 'বাজেট পাওয়া যায়নি';

  @override
  String get budgetUpdateFailed => 'বাজেট হালনাগাদ করা যায়নি';

  @override
  String get budgetDeleteFailed => 'বাজেট মুছে ফেলা যায়নি';

  @override
  String get budgetEdit => 'বাজেট সম্পাদনা';

  @override
  String get budgetNeedName => 'বাজেটের একটি নাম দিন';

  @override
  String get budgetEnterAmount => 'একটি পরিমাণ লিখুন';

  @override
  String get budgetAmountMoreThanZero => 'পরিমাণ শূন্যের বেশি হতে হবে';

  @override
  String get budgetTrackingEarnings => 'আয় ট্র্যাক করা হচ্ছে';

  @override
  String get budgetTrackingSpending => 'খরচ ট্র্যাক করা হচ্ছে';

  @override
  String get budgetRepeats => 'পুনরাবৃত্তি';

  @override
  String get budgetTooBig => 'অনেক বড়';

  @override
  String get budgetStarts => 'শুরু';

  @override
  String get budgetEnds => 'শেষ';

  @override
  String get budgetStopsRepeating => 'পুনরাবৃত্তি বন্ধ';

  @override
  String get budgetNever => 'কখনো না';

  @override
  String get budgetCategoriesAll => 'ক্যাটাগরি: সবগুলো';

  @override
  String budgetCategoriesSelected(int count) {
    return 'ক্যাটাগরি: $countটি বাছাই করা';
  }

  @override
  String get budgetNoIncomeCategories => 'এখনো কোনো আয়ের ক্যাটাগরি নেই।';

  @override
  String get budgetNoExpenseCategories => 'এখনো কোনো খরচের ক্যাটাগরি নেই।';

  @override
  String get budgetCategoriesHint =>
      'সব ক্যাটাগরি দেখতে ফাঁকা রাখুন। বাছাই করা ক্যাটাগরির ভেতরে রাখা সবকিছুও এর মধ্যে গণ্য হবে।';

  @override
  String get budgetAccountsAll => 'অ্যাকাউন্ট: সবগুলো';

  @override
  String budgetAccountsSelected(int count) {
    return 'অ্যাকাউন্ট: $countটি বাছাই করা';
  }

  @override
  String get budgetRolloverHint =>
      'যা খরচ হয়নি তা পরের সময়কালে যোগ হবে। সীমা ছাড়ালে সেই ঘাটতি পরের সময়কালে যায় না।';

  @override
  String get budgetPeriodDaily => 'দৈনিক';

  @override
  String get budgetPeriodFortnightly => 'পাক্ষিক';

  @override
  String get budgetPeriodOneOff => 'একবারের';

  @override
  String get budgetUnitDays => 'দিন';

  @override
  String get budgetUnitWeeks => 'সপ্তাহ';

  @override
  String get budgetUnitFortnights => 'পক্ষ';

  @override
  String get budgetUnitMonths => 'মাস';

  @override
  String get budgetUnitYears => 'বছর';

  @override
  String get budgetOneOffNeedsEnd => 'একবারের বাজেটের একটি শেষ তারিখ লাগবে।';

  @override
  String get budgetEndAfterStart => 'শেষ তারিখ শুরুর তারিখের পরে হতে হবে।';

  @override
  String get budgetSaveFailed => 'বাজেট সেভ করা যায়নি।';

  @override
  String get budgetThisPeriod => 'এই সময়কাল';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সময়কাল আগে',
      one: '১টি সময়কাল আগে',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start থেকে $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return '$limit-এর মধ্যে';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return '$limit-এর মধ্যে, আগের থেকে আসা $carried সহ';
  }

  @override
  String get budgetUncategorised => 'শ্রেণিহীন';

  @override
  String budgetOverTheLimit(String amount) {
    return 'সীমার চেয়ে $amount বেশি।';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left বাকি, দিনে প্রায় $daily।';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left বাকি।';
  }

  @override
  String budgetAveraging(String amount) {
    return 'গড়ে প্রতি সময়কালে $amount।';
  }

  @override
  String budgetHeadingOver(String amount) {
    return '$amount বেশি হওয়ার পথে';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'এই হারে, এবং সময়কাল শেষের আগে আগে থেকেই নির্ধারিত $scheduled ধরে।';
  }

  @override
  String get budgetForecastPlain => 'এই হারে, সময়কাল শেষ হতে হতে।';

  @override
  String get budgetCapsExplain =>
      'বাজেট জানায় সময়কালে বেশি খরচ হয়েছে কি না। সীমা জানায় কোথায়: খাবারের বাজেট সামগ্রিকভাবে ঠিক থাকলেও তার বেশিরভাগ হয়তো বাইরের খাবারে গেছে।';

  @override
  String get budgetPercentOfBudget => 'বাজেটের শতাংশ';

  @override
  String get budgetArchivedTitle => 'আর্কাইভ করা বাজেট';

  @override
  String get budgetShowActive => 'সক্রিয়গুলো দেখান';

  @override
  String get budgetShowArchived => 'আর্কাইভ করা দেখান';

  @override
  String get budgetUnpin => 'পিন সরান';

  @override
  String get budgetPinToTop => 'উপরে পিন করুন';

  @override
  String get budgetStartCounting => 'আবার গণনা শুরু করুন';

  @override
  String get budgetStopCounting => 'ইতিহাস থাকবে, গণনা বন্ধ হবে';

  @override
  String get budgetDeleteBody =>
      'বাজেট মুছে যাবে, আপনার লেনদেন থাকবে। আপনার লেখা কিছুই মুছবে না।';

  @override
  String get budgetNothingArchived => 'কিছু আর্কাইভ করা নেই';

  @override
  String get budgetNoneYet => 'এখনো কোনো বাজেট নেই';

  @override
  String get budgetArchivedEmptyHint =>
      'আপনি যেসব বাজেট আর্কাইভ করবেন, সেগুলো এখানে থাকবে।';

  @override
  String get budgetEmptyHint =>
      'কোনো ক্যাটাগরির জন্য সীমা ঠিক করুন আর দেখুন মাস কেমন যাচ্ছে।';

  @override
  String dashLoadFailed(String error) {
    return 'আর্থিক তথ্য লোড করা যায়নি: $error';
  }

  @override
  String get categoryUnknown => 'অজানা';

  @override
  String dashCardAvailable(String amount) {
    return 'ব্যবহারযোগ্য: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'উদ্বৃত্তে · ব্যবহারযোগ্য: $amount';
  }

  @override
  String get dashTypeBank => 'ব্যাংক';

  @override
  String get dashTypeCredit => 'ক্রেডিট';

  @override
  String get dashTypeSubs => 'সাবস্ক্রিপশন';

  @override
  String get dashTypeDeposit => 'ডিপোজিট';

  @override
  String get dashTypeInvest => 'বিনিয়োগ';

  @override
  String get dashTypeAsset => 'সম্পত্তি';

  @override
  String get dashAddAccountTile => 'অ্যাকাউন্ট\nযোগ করুন';

  @override
  String get categoryLoadFailed => 'ক্যাটাগরি লোড করা যায়নি';

  @override
  String get categoryAddFailed => 'ক্যাটাগরি যোগ করা যায়নি';

  @override
  String get categoryNotFound => 'ক্যাটাগরি পাওয়া যায়নি';

  @override
  String get categoryUpdateFailed => 'ক্যাটাগরি হালনাগাদ করা যায়নি';

  @override
  String get categoryCannotDeleteSystem =>
      'অ্যাপের নিজস্ব ক্যাটাগরি মুছে ফেলা যায় না';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'লেনদেন আছে এমন ক্যাটাগরি মুছে ফেলা যায় না; আগে সেগুলো সরান বা মুছে ফেলুন';

  @override
  String get categoryDeleteFailed => 'ক্যাটাগরি মুছে ফেলা যায়নি';

  @override
  String categorySaveFailed(String error) {
    return 'ক্যাটাগরি সেভ করা যায়নি: $error';
  }

  @override
  String get categoryEditTitle => 'ক্যাটাগরি সম্পাদনা';

  @override
  String get categoryNewTitle => 'নতুন ক্যাটাগরি';

  @override
  String get categoryPartOf => 'যার অংশ';

  @override
  String get categoryNamePlaceholder => 'ক্যাটাগরির নাম';

  @override
  String get categoryUpdate => 'ক্যাটাগরি হালনাগাদ করুন';

  @override
  String get categoryCreate => 'ক্যাটাগরি তৈরি করুন';

  @override
  String reportLoadFailed(String error) {
    return 'রিপোর্ট লোড করা যায়নি: $error';
  }

  @override
  String get goalEdit => 'লক্ষ্য সম্পাদনা';

  @override
  String get goalNeedName => 'লক্ষ্যের একটি নাম দিন';

  @override
  String get goalTargetMoreThanZero => 'লক্ষ্যমাত্রা শূন্যের বেশি হতে হবে';

  @override
  String get goalNoDeadline => 'কোনো সময়সীমা নেই';

  @override
  String get goalTargetDateAfterStart =>
      'লক্ষ্যের তারিখ শুরুর তারিখের পরে হতে হবে।';

  @override
  String get goalSaveFailed => 'লক্ষ্য সেভ করা যায়নি।';

  @override
  String get goalArchivedTitle => 'আর্কাইভ করা লক্ষ্য';

  @override
  String get goalHideFromHome => 'হোম থেকে লুকান';

  @override
  String get goalShowOnHome => 'হোমে দেখান';

  @override
  String get goalReached => 'পূর্ণ হয়েছে';

  @override
  String goalToGo(String amount) {
    return 'আর $amount বাকি';
  }

  @override
  String get goalNoneYet => 'এখনো কোনো লক্ষ্য নেই';

  @override
  String get goalArchivedEmptyHint =>
      'আপনি যেসব লক্ষ্য আর্কাইভ করবেন, সেগুলো এখানে থাকবে।';

  @override
  String get goalEmptyHint =>
      'যার জন্য টাকা জমাচ্ছেন তার নাম দিন, তারপর সেদিকে যাওয়া লেনদেনগুলো যুক্ত করুন।';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$target-এর মধ্যে $saved';
  }

  @override
  String goalOfTarget(String target) {
    return '$target-এর মধ্যে';
  }

  @override
  String get goalReachedNicelyDone => 'পূর্ণ হয়েছে। দারুণ!';

  @override
  String goalStillToGo(String amount) {
    return 'এখনো $amount বাকি।';
  }

  @override
  String goalDailyToArrive(String amount) {
    return 'সময়মতো পৌঁছাতে দিনে $amount।';
  }

  @override
  String get goalNothingLinked =>
      'এখনো কিছু যুক্ত হয়নি। কোনো লেনদেনে এই লক্ষ্য বেছে নিন, তাহলে এখানে দেখা যাবে।';

  @override
  String get goalDeleteBody =>
      'লক্ষ্য মুছে যাবে, আপনার লেনদেন থাকবে। শুধু সেগুলো আর এর মধ্যে গণ্য হবে না।';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পেমেন্ট, $amount করে',
      one: '১টি পেমেন্ট, $amount করে',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return '$date-এর কাছাকাছি শেষ হবে।';
  }

  @override
  String goalNotFound(String id) {
    return 'লক্ষ্য পাওয়া যায়নি: $id';
  }

  @override
  String get goalPaidOff => 'পরিশোধ হয়ে গেছে!';

  @override
  String get goalCompleted => 'সম্পূর্ণ!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% সম্পূর্ণ';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সপ্তাহ বাকি',
      one: '১ সপ্তাহ বাকি',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মাস বাকি',
      one: '১ মাস বাকি',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return '$years বছর বাকি';
  }

  @override
  String get subRecurringBill => 'নিয়মিত বিল';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count দিনে',
      one: 'প্রতি ১ দিনে',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count সপ্তাহে',
      one: 'প্রতি ১ সপ্তাহে',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count মাসে',
      one: 'প্রতি ১ মাসে',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'প্রতি $count বছরে',
      one: 'প্রতি ১ বছরে',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'প্রতি $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'সাবস্ক্রিপশন লোড করা যায়নি: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'সাবস্ক্রিপশন থামানো যায়নি: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'সাবস্ক্রিপশন আবার চালু করা যায়নি: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'সাবস্ক্রিপশন হালনাগাদ করা যায়নি: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'সাবস্ক্রিপশন বাতিল করা যায়নি: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'সক্রিয় ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'থামানো ($count)';
  }

  @override
  String get subEmptyTitle => 'কোনো সাবস্ক্রিপশন বা বিল নেই';

  @override
  String get subEmptyBody =>
      'এখানে ট্র্যাক করতে সাবস্ক্রিপশন বা নিয়মিত বিলের লেনদেন যোগ করুন';

  @override
  String get subRecurringCost => 'নিয়মিত খরচ';

  @override
  String subPerYear(String amount) {
    return '$amount / বছর';
  }

  @override
  String get subActive => 'সক্রিয়';

  @override
  String subNext(String date) {
    return 'পরবর্তী $date';
  }

  @override
  String get subResume => 'আবার চালু করুন';

  @override
  String get subPause => 'থামান';

  @override
  String get subCancelBillTitle => 'নিয়মিত বিল বাতিল করুন';

  @override
  String get subCancelSubTitle => 'সাবস্ক্রিপশন বাতিল করুন';

  @override
  String subCancelConfirm(String name) {
    return 'আপনি কি নিশ্চিত যে \"$name\" বাতিল করতে চান? এতে ভবিষ্যতের সব নিয়মিত পেমেন্ট বন্ধ হয়ে যাবে।';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" বাতিল হয়েছে';
  }

  @override
  String subSaveError(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get subEditBill => 'নিয়মিত বিল সম্পাদনা';

  @override
  String get subEditSub => 'সাবস্ক্রিপশন সম্পাদনা';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'দিন',
      one: 'দিন',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সপ্তাহ',
      one: 'সপ্তাহ',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'মাস',
      one: 'মাস',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'বছর',
      one: 'বছর',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'শেষ: $date';
  }

  @override
  String get subNoEndDate => 'কোনো শেষ তারিখ নেই';
}
