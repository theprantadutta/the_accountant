// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class L10nAm extends L10n {
  L10nAm([String locale = 'am']) : super(locale);

  @override
  String get actionCancel => 'ይቅር';

  @override
  String get actionConfirm => 'አረጋግጥ';

  @override
  String get dateToday => 'ዛሬ';

  @override
  String get dateYesterday => 'ትናንት';

  @override
  String get dateTomorrow => 'ነገ';

  @override
  String get navTransactions => 'ግብይቶች';

  @override
  String get settingsRegionalTitle => 'የክልል ቅንብሮች';

  @override
  String get settingsSectionCurrency => 'ምንዛሪ';

  @override
  String get settingsSectionDisplayFormat => 'የማሳያ ቅርጸት';

  @override
  String get settingsSectionLanguage => 'ቋንቋ';

  @override
  String get settingsDefaultCurrency => 'ነባሪ ምንዛሪ';

  @override
  String get settingsExchangeRates => 'የምንዛሪ ተመኖች';

  @override
  String get settingsExchangeRatesSubtitle => 'የምንዛሪ መለወጫ ተመኖችን ያስተዳድሩ';

  @override
  String get settingsDateFormat => 'የቀን ቅርጸት';

  @override
  String get settingsNumberFormat => 'የቁጥር ቅርጸት';

  @override
  String get settingsCurrencySymbol => 'የምንዛሪ ምልክት';

  @override
  String get settingsTimeFormat => 'የሰዓት ቅርጸት';

  @override
  String get settingsFirstDayOfWeek => 'የሳምንቱ የመጀመሪያ ቀን';

  @override
  String get settingsLanguage => 'ቋንቋ';

  @override
  String get settingsPreview => 'ቅድመ እይታ';

  @override
  String get previewDate => 'ቀን';

  @override
  String get previewTime => 'ሰዓት';

  @override
  String get previewAmount => 'መጠን';

  @override
  String get previewWeekStarts => 'ይህ ሳምንት የሚጀምረው';

  @override
  String get choiceMatchMyPhone => 'እንደ ስልኬ';

  @override
  String get symbolBeforeAmount => 'ከመጠኑ በፊት';

  @override
  String get symbolAfterAmount => 'ከመጠኑ በኋላ';

  @override
  String get time12Hour => '12 ሰዓት (1:30 PM)';

  @override
  String get time24Hour => '24 ሰዓት (13:30)';

  @override
  String get weekdayMonday => 'ሰኞ';

  @override
  String get weekdaySaturday => 'ቅዳሜ';

  @override
  String get weekdaySunday => 'እሑድ';

  @override
  String get selectDateFormat => 'የቀን ቅርጸት ይምረጡ';

  @override
  String get selectNumberFormat => 'የቁጥር ቅርጸት ይምረጡ';

  @override
  String get selectCurrency => 'ምንዛሪ ይምረጡ';

  @override
  String get themeLight => 'ብሩህ';

  @override
  String get themeDark => 'ጨለማ';

  @override
  String get languageSystem => 'እንደ ስልኬ';

  @override
  String get sectionAccount => 'መለያ';

  @override
  String get sectionDataManagement => 'የውሂብ አስተዳደር';

  @override
  String get sectionHelpSupport => 'እገዛ እና ድጋፍ';

  @override
  String get settingsAppearance => 'ገጽታ';

  @override
  String get settingsBackupRestore => 'ምትኬ እና መመለስ';

  @override
  String get settingsBackupRestoreSubtitle =>
      'እርስዎ የሚያስቀምጡት ፋይል፣ ወይም በGoogle Drive ውስጥ ራስ-ሰር ቅጂዎች';

  @override
  String get settingsImportStatement => 'የሂሳብ መግለጫ አስገባ';

  @override
  String get settingsImportStatementSubtitle =>
      'ከባንክዎ CSV ያስገቡ፤ አንዴ ተዛምዶ ይታወሳል';

  @override
  String get settingsExportData => 'ውሂብ ላክ';

  @override
  String get settingsRecentlyDeleted => 'በቅርቡ የተሰረዙ';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'ባለፉት ሠላሳ ቀናት የተሰረዘን ነገር መልሰው ያስቀምጡ';

  @override
  String get themePremiumHeading => 'Premium ገጽታዎች';

  @override
  String get actionRetry => 'እንደገና ሞክር';

  @override
  String get dashCreditDebt => 'ብድር እና ዕዳ';

  @override
  String get dashSubscriptions => 'ምዝገባዎች';

  @override
  String get moneyIncome => 'ገቢ';

  @override
  String get dashExpenses => 'ወጪዎች';

  @override
  String get dashSpendingOverview => 'የወጪ አጠቃላይ እይታ';

  @override
  String get dashBudgetProgress => 'የበጀት ሂደት';

  @override
  String get actionDelete => 'ሰርዝ';

  @override
  String txDeleteManyTitle(int count) {
    return '$count ግብይቶች ይሰረዙ?';
  }

  @override
  String get txDeleteManyBody =>
      'ቀሪ ሂሳቦች እንደገና ይሰላሉ። በመካከላቸው ያለ ማንኛውም ዝውውር ሌላውን ግማሹን ይዞ ይሰረዛል።';

  @override
  String get txMoveToAccount => 'ወደ ሂሳብ አዛውር';

  @override
  String get txDeleted => 'ግብይቱ ተሰርዟል';

  @override
  String txDeleteFailed(String error) {
    return 'ግብይቱን መሰረዝ አልተቻለም፦ $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count ተመርጠዋል';
  }

  @override
  String get txActions => 'ድርጊቶች';

  @override
  String get txChangeCategory => 'ምድብ ቀይር';

  @override
  String get txChangeDate => 'ቀን ቀይር';

  @override
  String get txMarkAsPaid => 'እንደተከፈለ ምልክት አድርግ';

  @override
  String get txMarkAsCorrection => 'እንደ ቀሪ ሂሳብ ማስተካከያ ምልክት አድርግ';

  @override
  String get txMarkAsCorrectionTitle => 'ገቢም ወጪም አይደለም?';

  @override
  String get txMarkAsCorrectionBody =>
      'ይህን ያልተገኘ ወይም ያልወጣ ገንዘብ ለማመልከት ይጠቀሙ፤ ለምሳሌ የካርድ ገደብ ሲጨምር። ቀሪ ሂሳቡ አይቀየርም፤ እንደ ገቢ ወይም ወጪ መቆጠሩ ብቻ ይቆማል።';

  @override
  String get txMarkedAsCorrection => 'አሁን የቀሪ ሂሳብ ማስተካከያ ነው።';

  @override
  String get txMarkAsCorrectionFailed => 'ይህ ማስተካከያ መሆን አይችልም።';

  @override
  String get txDuplicate => 'አባዛ';

  @override
  String get filterTitle => 'ማጣሪያ';

  @override
  String get filterDirection => 'አቅጣጫ';

  @override
  String get filterState => 'ሁኔታ';

  @override
  String get filterKind => 'ዓይነት';

  @override
  String get filterTransfers => 'ዝውውሮች';

  @override
  String get filterAccounts => 'ሂሳቦች';

  @override
  String get filterCategories => 'ምድቦች';

  @override
  String get filterDates => 'ቀናት';

  @override
  String get filterBudget => 'በጀት';

  @override
  String get filterGoal => 'ግብ';

  @override
  String get filterNone => 'ምንም';

  @override
  String get filterThisMonth => 'በዚህ ወር';

  @override
  String get filterLastMonth => 'ባለፈው ወር';

  @override
  String get filterLast3Months => 'ያለፉት 3 ወራት';

  @override
  String get filterThisYear => 'በዚህ ዓመት';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶችን አሳይ',
      one: '1 ግብይት አሳይ',
      zero: 'የሚዛመድ ግብይት የለም',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'አጽዳ';

  @override
  String get filterNoMatches => 'ምንም አልተገኘም';

  @override
  String get filterAny => 'ማንኛውም';

  @override
  String get filterSpent => 'የወጣ';

  @override
  String get filterEarned => 'የተገኘ';

  @override
  String get filterHidden => 'የተደበቀ';

  @override
  String get filterIncluded => 'የተካተተ';

  @override
  String get filterOnly => 'ብቻ';

  @override
  String get filterFrom => 'ከ';

  @override
  String get filterTo => 'እስከ';

  @override
  String get actionApply => 'ተግብር';

  @override
  String get filterPaid => 'የተከፈለ';

  @override
  String get filterNotYet => 'ገና ያልተከፈለ';

  @override
  String get filterSkipped => 'የታለፈ';

  @override
  String get filterAmount => 'መጠን';

  @override
  String get actionEdit => 'አርትዕ';

  @override
  String get entityBudget => 'በጀት';

  @override
  String get budgetGone => 'ይህ በጀት ከአሁን በኋላ የለም።';

  @override
  String get budgetEarlier => 'ቀደም ያለ';

  @override
  String get budgetLater => 'ኋላ ያለ';

  @override
  String get budgetWhereItWent => 'ገንዘቡ የት ሄደ';

  @override
  String get budgetRecentPeriods => 'የቅርብ ጊዜያት';

  @override
  String get budgetCaps => 'ገደቦች';

  @override
  String get actionAdd => 'አክል';

  @override
  String get budgetNoCategoriesToCap => 'ይህ በጀት እስካሁን ገደብ የሚጣልበት ምድብ የለውም።';

  @override
  String get budgetCapACategory => 'ለምድብ ገደብ አድርግ';

  @override
  String get entityCategory => 'ምድብ';

  @override
  String get budgetAsShare => 'ከበጀቱ እንደ ድርሻ';

  @override
  String get budgetAsShareHint => 'በጀቱን ሲቀይሩ አብሮ ይቀየራል';

  @override
  String get actionSet => 'አዘጋጅ';

  @override
  String get budgetAcrossPeriod => 'በጊዜው ሁሉ';

  @override
  String get budgetPreviousPeriod => 'ያለፈው ጊዜ';

  @override
  String get budgetEvenPace => 'እኩል ፍጥነት';

  @override
  String get budgetNew => 'አዲስ በጀት';

  @override
  String get budgetCreate => 'በጀት ፍጠር';

  @override
  String budgetDeleteTitle(String name) {
    return '$name ይሰረዝ?';
  }

  @override
  String get entityAccount => 'ሂሳብ';

  @override
  String get entityTransaction => 'ግብይት';

  @override
  String get walletGone => 'ይህ ሂሳብ ከአሁን በኋላ የለም።';

  @override
  String get walletCorrectBalance => 'ቀሪ ሂሳቡን አስተካክል';

  @override
  String get walletCorrectBalanceSubtitle => 'ከእውነተኛው አሃዝ ያለውን ልዩነት ይመዝግቡ';

  @override
  String get walletMergeInto => 'ከሌላ ሂሳብ ጋር አዋህድ';

  @override
  String get walletInThisMonth => 'በዚህ ወር የገባ';

  @override
  String get walletOutThisMonth => 'በዚህ ወር የወጣ';

  @override
  String get walletRecentActivity => 'የቅርብ እንቅስቃሴ';

  @override
  String get walletNoOtherAccount => 'የሚዋሀድበት ሌላ ሂሳብ የለም።';

  @override
  String get walletMergeIntoTitle => 'አዋህድ ወደ';

  @override
  String get walletMergeAction => 'አዋህድ';

  @override
  String walletMerged(int count, String target) {
    return '$count ወደ $target ተዛውረዋል።';
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
      other: 'በሁለቱ ሂሳቦች መካከል የነበሩ $removed ዝውውሮች ተወግደዋል',
      one: 'በሁለቱ ሂሳቦች መካከል የነበረ አንድ ዝውውር ተወግዷል',
    );
    return '$count ወደ $target ተዛውረዋል። $_temp0፤ ምክንያቱም ከእንግዲህ ሁለት ጫፎች የሉትም።';
  }

  @override
  String get walletRealBalance => 'እውነተኛ ቀሪ ሂሳብ';

  @override
  String get walletCorrectAction => 'አስተካክል';

  @override
  String get txGone => 'ይህ ግብይት ከአሁን በኋላ የለም።';

  @override
  String get txKind => 'ዓይነት';

  @override
  String get txState => 'ሁኔታ';

  @override
  String get txWasDue => 'የመክፈያ ጊዜው';

  @override
  String get txNotes => 'ማስታወሻዎች';

  @override
  String get txDeleteOneTitle => 'ይህ ግብይት ይሰረዝ?';

  @override
  String get rulesTitle => 'የስያሜ ደንቦች';

  @override
  String get rulesAdd => 'ደንብ አክል';

  @override
  String rulesRemoved(String title) {
    return 'የ$title ደንብ ተወግዷል';
  }

  @override
  String get rulesWhenTitleSays => 'ርዕሱ እንዲህ ሲል';

  @override
  String get rulesMatchExactly => 'በትክክል አዛምድ';

  @override
  String get rulesChooseCategory => 'ምድብ ይምረጡ';

  @override
  String get actionSave => 'አስቀምጥ';

  @override
  String get goalNew => 'አዲስ ግብ';

  @override
  String get goalLoadFailed => 'ግቦችዎን መጫን አልተቻለም።';

  @override
  String get goalCreate => 'ግብ ፍጠር';

  @override
  String get trashTitle => 'በቅርቡ የተሰረዙ';

  @override
  String get trashRestore => 'መልስ';

  @override
  String get trashRestored => 'ተመልሷል።';

  @override
  String get payTitle => 'የመክፈያ ዘዴዎች';

  @override
  String get payDefault => 'ነባሪ';

  @override
  String get payAddOne => 'አንድ አክል';

  @override
  String payDeleteTitle(String name) {
    return '$name ይሰረዝ?';
  }

  @override
  String get payName => 'ስም';

  @override
  String get payNameHint => 'የዕለት ዴቢት';

  @override
  String get payKind => 'ዓይነት';

  @override
  String get payBankOrIssuer => 'ባንክ ወይም አውጪ';

  @override
  String get payLastFour => 'የመጨረሻ አራት አሃዞች';

  @override
  String get payUseByDefault => 'በነባሪ ተጠቀም';

  @override
  String get backupChecking => 'በማረጋገጥ ላይ…';

  @override
  String get backupLoading => 'በመጫን ላይ…';

  @override
  String get backupSaveACopy => 'ቅጂ አስቀምጥ';

  @override
  String get backupAutomaticBackups => 'ራስ-ሰር ምትኬዎች';

  @override
  String get backupHowManyBackupsToKeep => 'ስንት ምትኬዎች ይቀመጡ';

  @override
  String get backupSaveABackupFile => 'የምትኬ ፋይል አስቀምጥ';

  @override
  String get backupShareItToFilesEmail => 'ወደ Files፣ ኢሜይል ወይም ወደፈለጉት ቦታ ያጋሩት';

  @override
  String get backupRestoreFromAFile => 'ከፋይል መልስ';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'አሁን በዚህ መሣሪያ ላይ ያለውን ሁሉ ይተካል';

  @override
  String get backupRestoreThisBackup => 'ይህ ምትኬ ይመለስ?';

  @override
  String get backupEraseRestore => 'አጥፋና መልስ';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive አይገኝም';

  @override
  String get backupConnectGoogleDrive => 'Google Drive አገናኝ';

  @override
  String get backupBackUpNow => 'አሁን ምትኬ አስቀምጥ';

  @override
  String get backupKeep => 'አቆይ';

  @override
  String get backupTheLastAutomaticBackupDid => 'የመጨረሻው ራስ-ሰር ምትኬ አልተካሄደም';

  @override
  String get backupDisconnectGoogleDrive => 'Google Drive ን አቋርጥ';

  @override
  String get backupDisconnectGoogleDrive2 => 'Google Drive ይቋረጥ?';

  @override
  String get backupDisconnect => 'አቋርጥ';

  @override
  String get backupDeleteThisBackup => 'ይህ ምትኬ ይሰረዝ?';

  @override
  String get importChooseACsvFile => 'የCSV ፋይል ይምረጡ';

  @override
  String get importRememberTheseSettingsForThis => 'ለዚህ ባንክ እነዚህን ቅንብሮች አስታውስ';

  @override
  String get importChange => 'ቀይር';

  @override
  String get importAuto => 'ራስ-ሰር';

  @override
  String get importDone => 'ተጠናቋል';

  @override
  String get importRememberThisBank => 'ይህን ባንክ አስታውስ';

  @override
  String get importForget => 'እርሳ';

  @override
  String get importImport => 'አስገባ';

  @override
  String get settingsAbout => 'ስለ';

  @override
  String get settingsPrivacyPolicy => 'የግላዊነት ፖሊሲ';

  @override
  String get settingsTermsOfService => 'የአገልግሎት ውሎች';

  @override
  String get settingsRefundPolicy => 'የተመላሽ ገንዘብ ፖሊሲ';

  @override
  String get settingsOpenSourceLicenses => 'የክፍት ምንጭ ፈቃዶች';

  @override
  String get settingsMeetTheDeveloper => 'ገንቢውን ይተዋወቁ';

  @override
  String get settingsContactSupport => 'ድጋፍ ያግኙ';

  @override
  String get settingsSubject => 'ርዕሰ ጉዳይ';

  @override
  String get settingsMessage => 'መልዕክት';

  @override
  String get settingsSendMessage => 'መልዕክት ላክ';

  @override
  String get settingsUseApiRate => 'የAPI ተመን ተጠቀም';

  @override
  String get settingsRefreshRates => 'ተመኖችን አድስ';

  @override
  String get settingsSearchCurrencies => 'ምንዛሪዎችን ፈልግ...';

  @override
  String get settingsCustomRate => 'ብጁ ተመን';

  @override
  String get settingsSetCustomRate => 'ብጁ ተመን አዘጋጅ';

  @override
  String get settingsNotNow => 'አሁን አይደለም';

  @override
  String get settingsGoPremium => 'ወደ Premium ይሻገሩ';

  @override
  String get settingsCsv => 'CSV ፋይል';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'ለExcel እና Google Sheets የሰንጠረዥ ቅርጸት';

  @override
  String get settingsPdfReport => 'PDF ሪፖርት';

  @override
  String get settingsFormattedSummaryWithBreakdowns => 'ዝርዝር ያለው የተቀረጸ ማጠቃለያ';

  @override
  String get settingsAllIncomeAndExpenseRecords => 'ሁሉም የገቢ እና የወጪ መዝገቦች';

  @override
  String get settingsCategories => 'ምድቦች';

  @override
  String get settingsCategoryBreakdownAndTotals => 'የምድብ ዝርዝር እና ድምሮች';

  @override
  String get settingsWallets => 'ቦርሳዎች';

  @override
  String get settingsWalletBalancesAndHistory => 'የቦርሳ ቀሪ ሂሳቦች እና ታሪክ';

  @override
  String get settingsHelpFaq => 'እገዛ እና ተደጋጋሚ ጥያቄዎች';

  @override
  String get settingsNotifications => 'ማሳወቂያዎች';

  @override
  String get settingsLargeTransactionThreshold => 'የትልቅ ግብይት ወሰን';

  @override
  String get settingsRemindMeBeforeDueDate => 'ከመክፈያ ቀኑ በፊት አስታውሰኝ';

  @override
  String get settingsDailyReminders => 'ዕለታዊ አስታዋሾች';

  @override
  String get settingsDailyReminders2 => 'ዕለታዊ አስታዋሾች';

  @override
  String get settingsGetRemindedToTrackYour => 'ወጪዎችዎን እንዲመዘግቡ ይታወሱ';

  @override
  String get settingsBudgetAlerts => 'የበጀት ማንቂያዎች';

  @override
  String get settingsBudgetAlerts2 => 'የበጀት ማንቂያዎች';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit => 'የበጀት ገደብ ሲቃረብ አሳውቅ';

  @override
  String get settingsWarningThreshold => 'የማስጠንቀቂያ ወሰን';

  @override
  String get settingsTransactionAlerts => 'የግብይት ማንቂያዎች';

  @override
  String get settingsLargeTransactionAlerts => 'የትልቅ ግብይት ማንቂያዎች';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'ከወሰኑ በላይ ለሆኑ ግብይቶች አሳውቅ';

  @override
  String get settingsRecurringTransactionReminders => 'የተደጋጋሚ ግብይት አስታዋሾች';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'ስለሚመጡ ተደጋጋሚ ክፍያዎች አስታውስ';

  @override
  String get settingsOtherNotifications => 'ሌሎች ማሳወቂያዎች';

  @override
  String get settingsSubscriptionExpiryAlerts => 'የምዝገባ ማብቂያ ማንቂያዎች';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Premium ዎ ከማብቃቱ በፊት ማሳወቂያ ያግኙ';

  @override
  String get settingsPromotionalNotifications => 'የማስተዋወቂያ ማሳወቂያዎች';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'ቅናሾችን እና የባህሪ ዝማኔዎችን ይቀበሉ';

  @override
  String get settingsTurnOnDailyReminders => 'ዕለታዊ አስታዋሾች ይብሩ?';

  @override
  String get settingsEnterAmount => 'መጠን ያስገቡ';

  @override
  String get settingsReminderTime => 'የማስታወሻ ሰዓት';

  @override
  String get settingsPrivacySecurity => 'ግላዊነት እና ደህንነት';

  @override
  String get settingsSecurity => 'ደህንነት';

  @override
  String get settingsBiometricLock => 'ባዮሜትሪክ ቁልፍ';

  @override
  String get settingsUseFingerprintOrFaceTo => 'ለመክፈት የጣት አሻራ ወይም ፊት ይጠቀሙ';

  @override
  String get settingsAutoLock => 'ራስ-ሰር ቁልፍ';

  @override
  String get settingsDataPrivacy => 'የውሂብ ግላዊነት';

  @override
  String get settingsClearCache => 'መሸጎጫ አጽዳ';

  @override
  String get settingsClearCachedDataAndForce => 'የተሸጎጠ ውሂብ አጽድተህ እንደገና አመሳስል';

  @override
  String get settingsClearAllData => 'ሁሉንም ውሂብ አጽዳ';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'ሁሉንም ግብይቶች፣ በጀቶች እና ቅንብሮች ሰርዝ';

  @override
  String get settingsDangerZone => 'አደገኛ ቀጠና';

  @override
  String get settingsDeleteAccount => 'መለያ ሰርዝ';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'መለያዎን እና ሁሉንም ውሂብ እስከመጨረሻው ይሰርዙ';

  @override
  String get settingsAutoLockTimeout => 'የራስ-ሰር ቁልፍ ጊዜ';

  @override
  String get settingsDeleteEverything => 'ሁሉንም ሰርዝ';

  @override
  String get settingsAreYouAbsolutelySure => 'በእርግጥ እርግጠኛ ነዎት?';

  @override
  String get settingsYesDeleteAll => 'አዎ፣ ሁሉንም ሰርዝ';

  @override
  String get settingsContinue => 'ቀጥል';

  @override
  String get settingsEditProfile => 'መገለጫ አርትዕ';

  @override
  String get settingsDisplayName => 'የሚታይ ስም';

  @override
  String get settingsEmailAddress => 'የኢሜይል አድራሻ';

  @override
  String get settingsUnsavedChanges => 'ያልተቀመጡ ለውጦች';

  @override
  String get settingsStay => 'ቆይ';

  @override
  String get settingsLeave => 'ውጣ';

  @override
  String get settingsSearchByCodeOrName => 'በኮድ ወይም በስም ፈልግ...';

  @override
  String get settingsSearchSettings => 'ቅንብሮችን ፈልግ...';

  @override
  String get settingsSubscription => 'ምዝገባ';

  @override
  String get settingsSignOut => 'ውጣ';

  @override
  String get settingsGoals => 'ግቦች';

  @override
  String get settingsCardsInNetWorth => 'ክሬዲት ካርዶችን በተጣራ ሀብት ውስጥ ቁጠር';

  @override
  String get settingsCardsInNetWorthSub =>
      'ጠፍቶ ከሆነ፦ ያለዎት ገንዘብ ብቻ ይቆጠራል፤ የካርድ ቀሪ ሂሳቦች አይቆጠሩም።';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'ለአንድ ነገር ይቆጥቡ፤ ምን ያህል እንደደረሱም ይከታተሉ';

  @override
  String get settingsBudgets => 'በጀቶች';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'ገደቦችን ያዘጋጁ፤ ጊዜው እንዴት እየሄደ እንደሆነ ይመልከቱ';

  @override
  String get settingsUpcomingAndOverdue => 'መጪ እና ያለፈባቸው';

  @override
  String get settingsWhatIsDueAndWhat => 'የሚከፈለው ምንድን ነው፣ ያመለጠውስ';

  @override
  String get settingsAccounts => 'ሂሳቦች';

  @override
  String get settingsAddReorderAndEditYour => 'ሂሳቦችዎን ያክሉ፣ ያደራጁ እና ያርትዑ';

  @override
  String get settingsTheCardsAndAccountsYou => 'የሚከፍሉባቸው ካርዶች እና ሂሳቦች';

  @override
  String get settingsWhereSomethingGoesBasedOn => 'አንድ ነገር በስሙ መሠረት የት እንደሚገባ';

  @override
  String get settingsNotificationSettings => 'የማሳወቂያ ቅንብሮች';

  @override
  String get settingsCloudSync => 'የደመና ማመሳሰል';

  @override
  String get settingsSyncYourDataAcrossDevices => 'ውሂብዎን በመሣሪያዎች መካከል ያመሳስሉ';

  @override
  String get settingsCsvIsFreePdfReport => 'CSV ነፃ ነው · PDF ሪፖርት Premium ነው';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'ጥያቄዎች፣ ቅሬታዎች ወይም አስተያየቶች';

  @override
  String get settingsRateTheApp => 'መተግበሪያውን ይገምግሙ';

  @override
  String get settingsShareWithFriends => 'ለጓደኞች ያጋሩ';

  @override
  String get settingsReplayAppTour => 'የመተግበሪያ ጉብኝቱን ድገም';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'የባህሪያት ማብራሪያውን እንደገና ይመልከቱ';

  @override
  String get settingsAboutTheAccountant => 'ስለ The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'ስሪት፣ ፈቃዶች እና ሌሎችም';

  @override
  String get settingsTestCrash => 'የሙከራ ብልሽት';

  @override
  String get settingsTriggerATestExceptionFor => 'ለCrashlytics የሙከራ ስህተት አስነሳ';

  @override
  String get settingsDeveloper => 'ገንቢ';

  @override
  String get settingsRestoreFromCloud => 'ከደመና ይመለስ?';

  @override
  String get settingsSyncing => 'በማመሳሰል ላይ...';

  @override
  String get settingsSynced => 'ተመሳስሏል';

  @override
  String get settingsSyncError => 'የማመሳሰል ስህተት';

  @override
  String get syncBackgroundFailed =>
      'ማመሳሰል አልተቻለም። ለውጦችዎ በዚህ መሣሪያ ላይ ደህና ናቸው፤ በኋላ ይመሳሰላሉ።';

  @override
  String get settingsOffline => 'ከመስመር ውጭ';

  @override
  String get settingsReady => 'ዝግጁ';

  @override
  String get settingsYesUseThis => 'አዎ፣ ይህን ተጠቀም';

  @override
  String get settingsKeepThemSeparate => 'ለየብቻ ይቆዩ?';

  @override
  String get settingsCurrentPassword => 'የአሁኑ የይለፍ ቃል';

  @override
  String get settingsNewPassword => 'አዲስ የይለፍ ቃል';

  @override
  String get settingsConfirmPassword => 'የይለፍ ቃል አረጋግጥ';

  @override
  String get walletEGPersonalSavingsBusiness => 'ለምሳሌ፦ የግል፣ ቁጠባ፣ ንግድ';

  @override
  String get walletEnterCreditLimit => 'የብድር ገደብ ያስገቡ';

  @override
  String get walletSelectBillingDay => 'የሂሳብ መጠየቂያ ቀን ይምረጡ';

  @override
  String get walletCreateAccount => 'ሂሳብ ፍጠር';

  @override
  String get walletWalletCreatedSuccessfully => 'ቦርሳው በተሳካ ሁኔታ ተፈጥሯል';

  @override
  String get walletAccountUpdatedSuccessfully => 'ሂሳቡ በተሳካ ሁኔታ ተዘምኗል';

  @override
  String get walletEditAccount => 'ሂሳብ አርትዕ';

  @override
  String get walletSetAsDefault => 'ነባሪ አድርግ';

  @override
  String get walletUseDecimals => 'አስርዮሽ ተጠቀም';

  @override
  String get walletEnterWalletName => 'የቦርሳ ስም ያስገቡ';

  @override
  String get walletCurrency => 'ምንዛሪ';

  @override
  String get walletIcon => 'አዶ';

  @override
  String get walletColor => 'ቀለም';

  @override
  String get walletWalletName => 'የቦርሳ ስም';

  @override
  String get walletInitialBalance => 'የመነሻ ቀሪ ሂሳብ';

  @override
  String get txAddATransferFee => 'የዝውውር ክፍያ አክል';

  @override
  String get txRemove => 'አስወግድ';

  @override
  String get txPaymentMethod => 'የመክፈያ ዘዴ';

  @override
  String get txObjective => 'ዓላማ';

  @override
  String get txTitle => 'ርዕስ';

  @override
  String get txTesco => 'ሱፐርማርኬት';

  @override
  String get txAll => 'ሁሉም';

  @override
  String get txSkip => 'እለፍ';

  @override
  String get txMarkAsPaid2 => 'እንደተከፈለ ምልክት አድርግ';

  @override
  String get txConfirmPayment => 'ክፍያን አረጋግጥ';

  @override
  String get txAmountCharged => 'የተከፈለው መጠን';

  @override
  String get txUndo => 'ቀልብስ';

  @override
  String get txNoLoan => 'ብድር የለም';

  @override
  String get txLentMoney => 'ያበደርኩት ገንዘብ';

  @override
  String get txBorrowedMoney => 'የተበደርኩት ገንዘብ';

  @override
  String get goalShowOnTheHomeScreen => 'በመነሻ ገጽ ላይ አሳይ';

  @override
  String get goalWhatAreYouSavingFor => 'ለምን እየቆጠቡ ነው?';

  @override
  String get goalNewLaptop => 'አዲስ ላፕቶፕ';

  @override
  String get goalTarget => 'ዒላማ';

  @override
  String get goalColour => 'ቀለም';

  @override
  String get goalClear => 'አጽዳ';

  @override
  String get goalGoal => 'ግብ';

  @override
  String get goalThisGoalNoLongerExists => 'ይህ ግብ ከአሁን በኋላ የለም።';

  @override
  String get goalAddToGoal => 'ወደ ግብ አክል';

  @override
  String get goalUnlink => 'አላቅቅ';

  @override
  String get reportUpgrade => 'አሻሽል';

  @override
  String get budgetSpending => 'ወጪ';

  @override
  String get budgetEarnings => 'ገቢዎች';

  @override
  String get budgetEvery => 'በየ';

  @override
  String get budgetCarryOverWhatIsLeft => 'የቀረውን ወደሚቀጥለው አስተላልፍ';

  @override
  String get budgetGroceries => 'የምግብ ሸቀጦች';

  @override
  String get authLinkYourAccount => 'መለያዎን ያገናኙ';

  @override
  String get authPassword => 'የይለፍ ቃል';

  @override
  String get authLinkAccount => 'መለያ አገናኝ';

  @override
  String get authEmailAddress => 'የኢሜይል አድራሻ';

  @override
  String get authSendResetCode => 'የዳግም ማስጀመሪያ ኮድ ላክ';

  @override
  String get authResetCode => 'የዳግም ማስጀመሪያ ኮድ';

  @override
  String get authResetPassword => 'የይለፍ ቃል ዳግም አስጀምር';

  @override
  String get authWelcomeBack => 'እንኳን ደህና ተመለሱ';

  @override
  String get authSignInToContinueYour => 'የፋይናንስ ጉዞዎን ለመቀጠል ይግቡ';

  @override
  String get authSignIn => 'ግባ';

  @override
  String get authJoinUsToStartYour => 'የፋይናንስ ጉዞዎን ለመጀመር ይቀላቀሉን';

  @override
  String get authFullName => 'ሙሉ ስም';

  @override
  String get premiumPremium => 'Premium ዕቅድ';

  @override
  String get premiumMonthly => 'ወርሃዊ';

  @override
  String get premiumYearly => 'ዓመታዊ';

  @override
  String get premiumLifetime => 'የዕድሜ ልክ';

  @override
  String get premiumNotNow => 'አሁን አይደለም';

  @override
  String get aiRename => 'እንደገና ሰይም';

  @override
  String get aiRenameChat => 'ውይይቱን እንደገና ሰይም';

  @override
  String get aiDeleteChat => 'ውይይቱ ይሰረዝ?';

  @override
  String get aiChatName => 'የውይይት ስም';

  @override
  String get aiScanReceipt => 'ደረሰኝ ቃኝ';

  @override
  String get aiCamera => 'ካሜራ';

  @override
  String get aiGallery => 'ማዕከለ ምስል';

  @override
  String get aiMerchantTitle => 'ነጋዴ / ርዕስ';

  @override
  String get aiSaveAsTransaction => 'እንደ ግብይት አስቀምጥ';

  @override
  String get onboardBrowseThemes => 'ገጽታዎችን ይመልከቱ';

  @override
  String get onboardBack => 'ተመለስ';

  @override
  String get onboardGetStarted => 'እንጀምር';

  @override
  String get onboardMainAccount => 'ዋና ሂሳብ';

  @override
  String get creditRecordPayment => 'ክፍያ መዝግብ';

  @override
  String get creditPleaseEnterAValidAmount => 'እባክዎ ትክክለኛ መጠን ያስገቡ';

  @override
  String get creditAmountExceedsRemainingBalance => 'መጠኑ ከቀሪው ሂሳብ ይበልጣል';

  @override
  String get creditPaymentAmount => 'የክፍያ መጠን';

  @override
  String get creditPaidOn => 'የተከፈለበት ቀን';

  @override
  String get creditFullAmount => 'ሙሉ መጠን';

  @override
  String get subSubscriptionName => 'የምዝገባ ስም';

  @override
  String get subAskBeforeEachPayment => 'እያንዳንዱን ክፍያ ከመመዝገብ በፊት ጠይቅ';

  @override
  String get subAskBeforeEachPaymentHint =>
      'እያንዳንዱ ክፍያ የተከፈለውን እስኪያረጋግጡ ወይም እስኪያልፉት ድረስ በመጪ ውስጥ ይጠብቃል። ለሚለዋወጡ ክፍያዎች ምርጥ ነው፤ ለምሳሌ በሌላ ምንዛሪ የሚከፈል ካርድ።';

  @override
  String get subChangesApplyFromNext =>
      'አዲስ መጠን ወይም ሂሳብ ከሚቀጥለው ክፍያ ጀምሮ ይሠራል። ቀድሞ የተፈጸሙ ክፍያዎች እንደነበሩ ይቆያሉ።';

  @override
  String get catPleaseEnterACategoryName => 'እባክዎ የምድብ ስም ያስገቡ';

  @override
  String get catEnterCategoryName => 'የምድብ ስም ያስገቡ';

  @override
  String get catSearch => 'ምድቦችን ፈልግ';

  @override
  String get catNoMatch => 'የሚዛመድ ምድብ የለም።';

  @override
  String get catUseEmoji => 'ኢሞጂ ተጠቀም';

  @override
  String get catEmojiHint => 'አንድ ኢሞጂ ይጻፉ ወይም ይምረጡ';

  @override
  String get catArchive => 'ወደ ማህደር';

  @override
  String get catMergeInto => 'አዋህድ ወደ…';

  @override
  String catMergeIntoTitle(String name) {
    return '$nameን አዋህድ ወደ';
  }

  @override
  String get catMergeBuiltIn => 'አብሮ የተሰራ';

  @override
  String get catMergeNoTargets => 'የሚዋሀድበት ተመሳሳይ ዓይነት ያለው ሌላ ምድብ የለም።';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return '$from ወደ $to ይዋሀድ?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'በ$from ውስጥ ያሉ ሁሉም ግብይቶች፣ በጀቶች እና ንዑስ ምድቦች ወደ $to ይዛወራሉ፤ $from ይወገዳል። ይህ ወደ ሌሎች መሣሪያዎችዎ ይመሳሰላል።';
  }

  @override
  String get catMergeAction => 'አዋህድ';

  @override
  String catMerged(String from, String to) {
    return '$from ወደ $to ተዋህዷል።';
  }

  @override
  String get catExpenseSection => 'የወጪ ምድቦች';

  @override
  String get catIncomeSection => 'የገቢ ምድቦች';

  @override
  String get catSectionEmpty => 'እስካሁን የለም';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ንዑስ ምድቦች',
      one: '1 ንዑስ ምድብ',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች',
      one: '1 ግብይት',
      zero: 'ግብይት የለም',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'በ$name ውስጥ';
  }

  @override
  String get catAddSubcategory => 'ንዑስ ምድብ አክል';

  @override
  String get catNoSubcategoriesYet => 'እስካሁን ንዑስ ምድብ የለም። አንድ ያክሉ';

  @override
  String get catMoveTo => 'አዛውር ወደ…';

  @override
  String catMoveToTitle(String name) {
    return '$nameን አዛውር ወደ';
  }

  @override
  String get catTopLevel => 'ከፍተኛ ደረጃ';

  @override
  String get catTopLevelHint => 'በየትኛውም ምድብ ውስጥ አይደለም';

  @override
  String catMovedInto(String name, String parent) {
    return '$name አሁን በ$parent ውስጥ ነው።';
  }

  @override
  String catMovedToTop(String name) {
    return '$name አሁን ከፍተኛ ደረጃ ምድብ ነው።';
  }

  @override
  String get catMoveNoParents => 'ሊገባበት የሚችል ምድብ የለም።';

  @override
  String get catMoveTransactions => 'ግብይቶችን አዛውር…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'የ$name ግብይቶችን አዛውር ወደ';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች ወደ $to ይዛወሩ?',
      one: '1 ግብይት ወደ $to ይዛወር?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'የሚዛወሩት ግብይቶቹ ብቻ ናቸው። $from ከበጀቶቹ እና ከንዑስ ምድቦቹ ጋር ይቆያል። ይህ ወደ ሌሎች መሣሪያዎችዎ ይመሳሰላል።';
  }

  @override
  String get catMoveAction => 'አዛውር';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች ወደ $to ተዛውረዋል።',
      one: '1 ግብይት ወደ $to ተዛውሯል።',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name የሚዛወር ግብይት የለውም።';
  }

  @override
  String get catNoMoveTargets => 'የሚዛወሩበት ተመሳሳይ ዓይነት ያለው ሌላ ምድብ የለም።';

  @override
  String catDeleteTitle(String name) {
    return '$name ይሰረዝ?';
  }

  @override
  String get catDeleteEmptyBody => 'ምንም ግብይት የለውም፤ ስለዚህ ሌላ ምንም አይቀየርም።';

  @override
  String get catDeleteChildrenNote => 'ንዑስ ምድቦቹ ወደ ከፍተኛ ደረጃ ይዛወራሉ።';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በሥሩ $count ግብይቶች አሉ። ምን ይደረጉ?',
      one: 'በሥሩ 1 ግብይት አለ። ምን ይደረግ?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'ወደ ሌላ ምድብ አዛውር';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'ከዚያ $name ይሰረዛል። የተጠቀሙበት በጀቶችም አብረው ይዛወራሉ።';
  }

  @override
  String get catDeleteThemToo => 'ግብይቶቹንም ሰርዝ';

  @override
  String get catDeleteThemTooHint =>
      'ወደ በቅርቡ የተሰረዙ ይሄዳሉ፤ እዚያም ለ30 ቀናት መመለስ ይችላሉ።';

  @override
  String catDeleted(String name) {
    return '$name ተሰርዟል።';
  }

  @override
  String get catActionFailed => 'ያ ሊከናወን አልቻለም። እንደገና ይሞክሩ።';

  @override
  String get catStaysTopLevel => 'ይህ ምድብ የራሱ ንዑስ ምድቦች ስላሉት በከፍተኛ ደረጃ ይቆያል።';

  @override
  String get catUnarchive => 'ከማህደር አውጣ';

  @override
  String get catArchivedSection => 'በማህደር የተቀመጡ';

  @override
  String get catArchivedHint => 'ለታሪካቸው ተቀምጠዋል፤ ግብይት ሲያክሉ ግን አይቀርቡም።';

  @override
  String get catNothingItsOwnCategory => 'ምንም — የራሱ ምድብ';

  @override
  String get notifEnableNotifications => 'ማሳወቂያዎችን አንቃ';

  @override
  String get startupContinueWithoutChecking => 'ሳይረጋገጥ ይቀጥል?';

  @override
  String get startupContinueOffline => 'ከመስመር ውጭ ቀጥል';

  @override
  String get startupViewSubscriptionOptions => 'የምዝገባ አማራጮችን ይመልከቱ';

  @override
  String get sharedWelcomeBack => 'እንኳን ደህና ተመለሱ';

  @override
  String get sharedRestoringYourDataFromThe => 'ውሂብዎ ከደመና እየተመለሰ ነው…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return '$source ወደ $target ይዋሀድ?';
  }

  @override
  String get backupNothingHereYet => 'እስካሁን እዚህ ምንም የለም።';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'ፋይሉ እነዚህ ዓምዶች ሲኖሩት በራስ-ሰር ይተገበራል';

  @override
  String get importDateFormat => 'የቀን ቅርጸት';

  @override
  String get importChooseOne => 'አንዱን ይምረጡ';

  @override
  String get importDecimalPoint => 'የአስርዮሽ ነጥብ';

  @override
  String get importFlipTheSigns => 'ምልክቶቹን ገልብጥ';

  @override
  String get importForExportsThatWriteA => 'ወጪን እንደ አዎንታዊ ለሚጽፉ ፋይሎች';

  @override
  String get importWhereRowsGoWhenThe => 'ፋይሉ የእርስዎን ሂሳብ ካልጠቀሰ ረድፎቹ የሚገቡበት';

  @override
  String get importSkipWhatIsAlreadyHere => 'ቀድሞ ያለውን እለፍ';

  @override
  String get importCreateCategoriesTheFileNames => 'ፋይሉ የጠቀሳቸውን ምድቦች ፍጠር';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'አለበለዚያ እነዚያ ረድፎች ያለ ምድብ ይገባሉ';

  @override
  String get importCategoriesInThisFile => 'በዚህ ፋይል ውስጥ ያሉ ምድቦች';

  @override
  String get settingsMadeWithLoveForPersonal => 'ለግል ፋይናንስ በፍቅር የተሰራ';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'ያዘጋጀውና የሚንከባከበው፦';

  @override
  String get settingsPrantaDutta => 'ፕራንታ ዱታ';

  @override
  String get settingsClose => 'ዝጋ';

  @override
  String get settingsGetInTouch => 'ያግኙን';

  @override
  String get settingsAsAPremiumMemberYour =>
      'የPremium አባል እንደመሆንዎ ጥያቄዎ ቅድሚያ ይሰጠዋል።';

  @override
  String get settingsWhatToInclude => 'ምን ይካተት';

  @override
  String get settingsNoCurrenciesFound => 'ምንም ምንዛሪ አልተገኘም';

  @override
  String get settingsExportYourFinancialDataTo =>
      'የፋይናንስ ውሂብዎን በሌሎች መተግበሪያዎች ለመተንተን ወይም እንደ ምትኬ ለማቆየት ይላኩ።';

  @override
  String get settingsDateRange => 'የቀን ክልል';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'PDF ሪፖርቶች';

  @override
  String get settingsGettingStarted => 'መጀመር';

  @override
  String get settingsStillNeedHelp => 'አሁንም እገዛ ይፈልጋሉ?';

  @override
  String get settingsOurSupportTeamIsHere => 'የድጋፍ ቡድናችን እርስዎን ለመርዳት ዝግጁ ነው';

  @override
  String get settingsAppLocked => 'መተግበሪያው ተቆልፏል';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'The Accountant ን ለመጠቀም ይክፈቱ';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'The Accountant ወጪዎችዎን እንዲመዘግቡ መቼ እና እንዴት እንደሚያስታውስዎ ያዋቅሩ።';

  @override
  String get settingsYourEmailIsUsedTo => 'ኢሜይልዎ ለመግባት ያገለግላል፤ እዚህ ሊቀየር አይችልም።';

  @override
  String get settingsYourDataIsOnThis => 'ውሂብዎ በዚህ መሣሪያ ላይ ብቻ ነው';

  @override
  String get settingsUpgradeForCloudSync => 'ለደመና ማመሳሰል ያሻሽሉ';

  @override
  String get settingsNoSettingsFound => 'ምንም ቅንብር አልተገኘም';

  @override
  String get settingsTryADifferentSearchTerm => 'ሌላ የፍለጋ ቃል ይሞክሩ';

  @override
  String get settingsSyncStatus => 'የማመሳሰል ሁኔታ';

  @override
  String get settingsSyncNow => 'አሁን አመሳስል';

  @override
  String get settingsRestoreFromCloud2 => 'ከደመና መልስ';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'የእርስዎን ማረጋገጫ ይፈልጋል';

  @override
  String get walletCreateYourFirstAccount => 'የመጀመሪያ ሂሳብዎን ይፍጠሩ';

  @override
  String get walletYouNeedAtLeastOne =>
      'ፋይናንስዎን መከታተል ለመጀመር ቢያንስ አንድ ሂሳብ ያስፈልግዎታል';

  @override
  String get walletAccountType => 'የሂሳብ ዓይነት';

  @override
  String get walletAccountName => 'የሂሳብ ስም';

  @override
  String get walletCreditLimit => 'የብድር ገደብ';

  @override
  String get walletCreditLimitHelp => 'ገደቡ ጨምሯል? እዚህ ይቀይሩት። አዲስ ገደብ ገቢ አይደለም።';

  @override
  String get walletAmountOwed => 'ያለብዎት ዕዳ';

  @override
  String get walletAmountOwedHelp => 'አሁን በካርዱ ላይ ያለብዎት። ተከፍሎ ካለቀ 0 ያስገቡ።';

  @override
  String get walletCurrentBalance => 'የአሁኑ ቀሪ ሂሳብ';

  @override
  String get walletCurrentBalanceHelp =>
      'ለውጡ እንደ ቀሪ ሂሳብ ማስተካከያ ይቀመጣል፤ ስለዚህ ታሪክዎ ትክክል ሆኖ ይቆያል።';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'በዚህ ካርድ ላይ ያለው $amount ምንድን ነው?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'የቀረኝ ብድር';

  @override
  String get walletCardBalanceOwed => 'ያለብኝ ዕዳ';

  @override
  String get walletCardBalanceChoose => 'ዕዳው በትክክል እንዲሰላ ይህ መጠን ምን እንደሆነ ይምረጡ።';

  @override
  String get walletBillingCycleDayOptional => 'የሂሳብ ዑደት ቀን (አማራጭ)';

  @override
  String get walletThisWillBeYourDefault => 'ይህ ነባሪ ሂሳብዎ ይሆናል';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'በዚህ ሂሳብ ላይ እስካሁን ምንም አልተመዘገበም።';

  @override
  String get walletAddAccount => 'ሂሳብ አክል';

  @override
  String get walletYourAccounts => 'ሂሳቦችዎ';

  @override
  String get walletNoAccountsYet => 'እስካሁን ሂሳብ የለም';

  @override
  String get walletOutstanding => 'ያልተከፈለ';

  @override
  String get walletAvailable => 'ያለ';

  @override
  String get walletLimit => 'ገደብ';

  @override
  String get walletBalance => 'ቀሪ ሂሳብ';

  @override
  String get walletUseThisWalletForNew => 'ለአዳዲስ ግብይቶች ይህን ቦርሳ ተጠቀም';

  @override
  String get walletSelectIcon => 'አዶ ይምረጡ';

  @override
  String get walletSelectColor => 'ቀለም ይምረጡ';

  @override
  String get txYouNeedAtLeast2 => 'ዝውውር ለማድረግ ቢያንስ 2 ሂሳቦች ያስፈልጉዎታል';

  @override
  String get txNoAccountTitle => 'ይህን የሚመዘግቡበት ሂሳብ የለም';

  @override
  String get txNoAccountBody =>
      'ሂሳብ ያክሉ ወይም የተዘጋውን እንደገና ይክፈቱ፤ ከዚያ ይህ ቅጽ ለአገልግሎት ዝግጁ ይሆናል።';

  @override
  String get txNoAccountAction => 'ሂሳቦችን አስተዳድር';

  @override
  String get txDeleteTransaction => 'ግብይት ሰርዝ';

  @override
  String get txAreYouSureYouWant => 'ይህን ግብይት መሰረዝ እንደሚፈልጉ እርግጠኛ ነዎት?';

  @override
  String get txTransactionType => 'የግብይት ዓይነት';

  @override
  String get txTransferFee => 'የዝውውር ክፍያ';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'ለብቻው ይከፈላል፤ ስለዚህ ዝውውሩ ራሱ ሚዛኑን ይጠብቃል።';

  @override
  String get txDeductedFrom => 'የተቀነሰበት';

  @override
  String get txNoPaymentMethods => 'የመክፈያ ዘዴ የለም';

  @override
  String get txNothingDeletedRecently => 'በቅርቡ ምንም አልተሰረዘም';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'የሚሰርዙት ማንኛውም ነገር ለሠላሳ ቀናት እዚህ ይታያል።';

  @override
  String get txNoRulesYet => 'እስካሁን ደንብ የለም';

  @override
  String get txClearAll => 'ሁሉንም አጽዳ';

  @override
  String get txApplyFilters => 'ማጣሪያዎችን ተግብር';

  @override
  String get txUpcomingOverdue => 'መጪ እና ያለፈባቸው';

  @override
  String get txNew => 'አዲስ';

  @override
  String get txLoan => 'ብድር';

  @override
  String get goalStarted => 'የተጀመረበት';

  @override
  String get goalTargetDate => 'የዒላማ ቀን';

  @override
  String get goalWithADateTheGoal => 'ቀን ካለው ግቡ በየቀኑ ምን ያህል መቆጠብ እንዳለብዎ ያሰላል።';

  @override
  String get goalCountedTowardThisGoal => 'ለዚህ ግብ የተቆጠረ';

  @override
  String get goalGettingThere => 'እየደረሱ ነው';

  @override
  String get goalSetATargetDateAnd =>
      'የዒላማ ቀን ያዘጋጁ፤ ይህም ምን ያህል መቆጠብ እንዳለብዎ ያሰላል።';

  @override
  String get reportSpendingInsights => 'የወጪ ግንዛቤዎች';

  @override
  String get reportNoSpendingDataForThis => 'ለዚህ ጊዜ የወጪ ውሂብ የለም';

  @override
  String get reportNoCategorySpendingData => 'የምድብ ወጪ ውሂብ የለም';

  @override
  String get reportNoSpendingDataAvailable => 'የወጪ ውሂብ የለም';

  @override
  String get reportBudgetVsActual => 'በጀት ከትክክለኛው ጋር';

  @override
  String get reportNoActiveBudgets => 'ንቁ በጀት የለም';

  @override
  String get reportCreateABudgetToTrack => 'ወጪዎን ለመከታተል በጀት ይፍጠሩ';

  @override
  String get budgetSpendingFasterThanThePeriod => 'ወጪው ከጊዜው ፍጥነት በላይ እየሄደ ነው።';

  @override
  String get budgetNothingRecordedInThisPeriod => 'በዚህ ጊዜ ውስጥ ምንም አልተመዘገበም።';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name፣ ከ$limit $spent ጥቅም ላይ ውሏል';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount ቀርቷል';
  }

  @override
  String budgetAmountOver(String amount) {
    return 'በ$amount በልጧል';
  }

  @override
  String get budgetPeriodEnded => 'ጊዜው አብቅቷል';

  @override
  String get budgetPaceOver => 'በልጧል';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ቀናት ቀርተዋል',
      one: '1 ቀን ቀርቷል',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'የይለፍ ቃሉ በተሳካ ሁኔታ ዳግም ተጀምሯል። እባክዎ ይግቡ።';

  @override
  String get authResendCode => 'ኮዱን እንደገና ላክ';

  @override
  String get authForgotPassword => 'የይለፍ ቃል ረሱ?';

  @override
  String get authOrContinueWith => 'ወይም በዚህ ይቀጥሉ';

  @override
  String get authContinueWithGoogle => 'በGoogle ይቀጥሉ';

  @override
  String get authContinueWithApple => 'በApple ይቀጥሉ';

  @override
  String get authSignUp => 'ይመዝገቡ';

  @override
  String get authPleaseAcceptTheTermsAnd => 'እባክዎ ውሎቹን እና ሁኔታዎቹን ይቀበሉ';

  @override
  String get authPasswordStrength => 'የይለፍ ቃል ጥንካሬ';

  @override
  String get authAlreadyHaveAnAccount => 'መለያ አለዎት? ';

  @override
  String get authPersonalInformation => 'የግል መረጃ';

  @override
  String get authUpgradeToPremium => 'ወደ Premium ያሻሽሉ';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'ያልተገደቡ በጀቶችን፣ የላቁ ትንታኔዎችን እና ሌሎችንም ይክፈቱ!';

  @override
  String get authUpgradeNow => 'አሁን አሻሽል';

  @override
  String get authPremiumMember => 'የPremium አባል';

  @override
  String get authEnjoyingAllPremiumFeatures => 'ሁሉንም የPremium ባህሪያት እየተጠቀሙ ነው';

  @override
  String get authSaveChanges => 'ለውጦችን አስቀምጥ';

  @override
  String get authAreYouSureYouWant => 'ከመለያዎ መውጣት እንደሚፈልጉ እርግጠኛ ነዎት?';

  @override
  String get authChangeProfilePhoto => 'የመገለጫ ፎቶ ቀይር';

  @override
  String get authTakePhoto => 'ፎቶ አንሳ';

  @override
  String get authUseYourCamera => 'ካሜራዎን ይጠቀሙ';

  @override
  String get authChooseFromGallery => 'ከማዕከለ ምስል ይምረጡ';

  @override
  String get authSelectAnExistingPhoto => 'ያለ ፎቶ ይምረጡ';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'ፎቶ ተመርጧል! የመስቀል ባህሪው በቅርቡ ይመጣል።';

  @override
  String get authNameCannotBeEmpty => 'ስም ባዶ ሊሆን አይችልም';

  @override
  String get authProfileUpdatedSuccessfully => 'መገለጫው በተሳካ ሁኔታ ተዘምኗል!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'ግላዊነት እና ውሎች';

  @override
  String get legalReviewTheseBeforeYouContinue => 'ከመቀጠልዎ በፊት እነዚህን ይገምግሙ።';

  @override
  String get premiumLimitReached => 'ገደቡ ደርሷል';

  @override
  String get aiChats => 'ውይይቶች';

  @override
  String get aiNewChat => 'አዲስ ውይይት';

  @override
  String get aiNoConversationsYet => 'እስካሁን ውይይት የለም';

  @override
  String get aiStartChattingAndYourThreads => 'መወያየት ይጀምሩ፤ ውይይቶችዎ እዚህ ይታያሉ።';

  @override
  String get aiScanAReceipt => 'ደረሰኝ ቃኝ';

  @override
  String get aiReadingYourReceipt => 'ደረሰኝዎን በማንበብ ላይ…';

  @override
  String get aiReviewSave => 'ገምግምና አስቀምጥ';

  @override
  String get aiWeReadThisFromYour =>
      'ይህን ከደረሰኝዎ አንብበናል — ከማስቀመጥዎ በፊት ያረጋግጡ እና ማንኛውንም ያርትዑ።';

  @override
  String get dashErrorLoadingFinancialData => 'የፋይናንስ ውሂብ በመጫን ላይ ስህተት ተፈጥሯል';

  @override
  String get dashNoSpendingDataYet => 'እስካሁን የወጪ ውሂብ የለም';

  @override
  String get dashManage => 'አስተዳድር';

  @override
  String get dashAvailable => 'ያለ፦ ****';

  @override
  String get onboardWelcome => 'እንኳን ደህና መጡ!';

  @override
  String get onboardSelectYourDefaultCurrency => 'ነባሪ ምንዛሪዎን ይምረጡ';

  @override
  String get onboardLoadingCurrencies => 'ምንዛሪዎችን በመጫን ላይ...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'ዋና ቦርሳዎን ያዘጋጁ';

  @override
  String get onboardInitialBalanceOptional => 'የመነሻ ቀሪ ሂሳብ (አማራጭ)';

  @override
  String get onboardYourAccountIsReadyTo => 'ሂሳብዎ ለአገልግሎት ዝግጁ ነው';

  @override
  String get onboardTipYouCanAddMore =>
      'ጠቃሚ ምክር፦ ከቦርሳዎች ክፍል በማንኛውም ጊዜ የተለያዩ ምንዛሪዎች ያሏቸው ተጨማሪ ሂሳቦችን ማከል ይችላሉ።';

  @override
  String get creditSettled => 'ተከፍሎ አልቋል';

  @override
  String get creditOverdue => 'ጊዜው ያለፈበት';

  @override
  String creditTabCredit(int count) {
    return 'ያበደርኩት ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'የተበደርኩት ($count)';
  }

  @override
  String get creditNetOutstanding => 'የተጣራ ያልተከፈለ';

  @override
  String get creditAllSettled => 'ሁሉም ተከፍሏል';

  @override
  String get creditOthersOweYou => 'ሌሎች ለእርስዎ ያለባቸው';

  @override
  String get creditYouOweOthers => 'ለሌሎች ያለብዎት';

  @override
  String creditOverdueCount(int count) {
    return '$count ጊዜ ያለፈባቸው';
  }

  @override
  String get creditEmptyAll => 'ያበደሩት ወይም የተበደሩት ገንዘብ የለም';

  @override
  String get creditEmptyLent => 'ያበደሩት ገንዘብ የለም';

  @override
  String get creditEmptyBorrowed => 'የተበደሩት ገንዘብ የለም';

  @override
  String get creditEmptyAllSettled => 'ሁሉም ተከፍሎ አልቋል።';

  @override
  String get creditEmptyHint =>
      'ማን ለማን እንዳለበት ለመከታተል ያበደሩትን ወይም የተበደሩትን ገንዘብ ያክሉ።';

  @override
  String get creditShowAll => 'ሁሉንም አሳይ';

  @override
  String get creditShowUnpaid => 'ያልተከፈሉትን ብቻ አሳይ';

  @override
  String get creditMoneyLent => 'ያበደርኩት ገንዘብ';

  @override
  String get creditMoneyBorrowed => 'የተበደርኩት ገንዘብ';

  @override
  String get creditTheyOweYou => 'እነሱ አለባቸው';

  @override
  String get creditYouOwe => 'እርስዎ አለብዎት';

  @override
  String get creditCollected => 'የተሰበሰበ';

  @override
  String creditPaidOf(String paid, String total) {
    return 'ከ$total $paid ተከፍሏል';
  }

  @override
  String get creditRecord => 'መዝግብ';

  @override
  String get subRecurring => 'ተደጋጋሚ';

  @override
  String get subPaused => 'ቆሟል';

  @override
  String get subAsksFirst => 'መጀመሪያ ይጠይቃል';

  @override
  String get subFrequency => 'ድግግሞሽ';

  @override
  String get notifMarkAllRead => 'ሁሉንም እንደተነበበ ምልክት አድርግ';

  @override
  String get notifTryAgain => 'እንደገና ሞክር';

  @override
  String get notifStayOnTopOfYour => 'ገንዘብዎን በቅርበት ይከታተሉ';

  @override
  String get notifNoNotificationsYet => 'እስካሁን ማሳወቂያ የለም';

  @override
  String get notifWhenYouReceiveNotificationsThey => 'ማሳወቂያዎች ሲደርሱዎት እዚህ ይታያሉ።';

  @override
  String get startupNothingHasBeenChangedOr => 'ምንም ነገር አልተቀየረም ወይም አልተሰረዘም።';

  @override
  String get sharedIncludeCryptoCurrencies => 'የክሪፕቶ ምንዛሪዎችን አካትት';

  @override
  String get sharedTotalBalance => 'ጠቅላላ ቀሪ ሂሳብ';

  @override
  String get heatmapTitle => 'ዕለታዊ ምት';

  @override
  String get heatmapSpentMore => 'ብዙ የወጣበት';

  @override
  String get heatmapEarnedMore => 'ብዙ የተገኘበት';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ግብይቶች አልታዩም፦ በሂሳቦቻቸው ምንዛሪዎች እና በ$currency መካከል የሚታወቅ ተመን የለም',
      one: 'አንድ ግብይት አልታየም፦ በሂሳቡ ምንዛሪ እና በ$currency መካከል የሚታወቅ ተመን የለም',
    );
    return '$_temp0።';
  }

  @override
  String get heatmapNothingYet => 'በዚህ ጊዜ ውስጥ እስካሁን ምንም አልተመዘገበም።';

  @override
  String get heatmapNetForRange => 'በዚህ ክልል ያለው የተጣራ';

  @override
  String get layoutTitle => 'የመነሻ ገጽ አቀማመጥ';

  @override
  String get layoutSubtitle => 'የመነሻ ገጹን እንደገና ያደራጁ፣ ወይም የማይጠቀሙበትን ይደብቁ';

  @override
  String get layoutExplain =>
      'ለማደራጀት ይጎትቱ። የጠፋ ማንኛውም ነገር ቦታውን ይይዛል፤ ስለዚህ መልሰው ሲያበሩት በተዉት ቦታ ይመለሳል።';

  @override
  String get layoutReset => 'ወደ ነባሪ መልስ';

  @override
  String get layoutAllHidden => 'ሁሉም ክፍሎች ተደብቀዋል። የመነሻ ገጹ ባዶ ይሆናል።';

  @override
  String get layoutSectionGreeting => 'ሰላምታ';

  @override
  String get layoutSectionAccounts => 'ሂሳቦች';

  @override
  String get layoutSectionQuickStats => 'ገቢ እና ወጪ';

  @override
  String get layoutSectionQuickLinks => 'አቋራጮች';

  @override
  String get layoutSectionSpendingChart => 'የወጪ አጠቃላይ እይታ';

  @override
  String get layoutSectionRecent => 'የቅርብ ግብይቶች';

  @override
  String get layoutSectionBudgets => 'የበጀት ሂደት';

  @override
  String get layoutSectionGoals => 'የተሰኩ ግቦች';

  @override
  String get shortcutAddExpense => 'ወጪ አክል';

  @override
  String get shortcutAddIncome => 'ገቢ አክል';

  @override
  String get shortcutScanReceipt => 'ደረሰኝ ቃኝ';

  @override
  String get shortcutTransactions => 'ግብይቶች';

  @override
  String get backupBusySyncing => 'ማመሳሰል እየተካሄደ ነው። ከመመለስዎ በፊት እስኪጠናቀቅ ይጠብቁ።';

  @override
  String get appearanceTitle => 'ገጽታ';

  @override
  String get themeSunriseLight => 'የንጋት ብሩህ';

  @override
  String get themeSunriseDark => 'የንጋት ጨለማ';

  @override
  String get themeMatchSystem => 'እንደ ሲስተሙ';

  @override
  String get themeMatchSystemHint => 'ከስልክዎ ጋር በብሩህ እና በጨለማ መካከል ይቀያየራል';

  @override
  String get themeUnlockAll => 'ሁሉንም ገጽታዎች ክፈት';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'ንጋት';

  @override
  String get themeAccentSapphire => 'ሰንፔር';

  @override
  String get themeAccentEmerald => 'መረግድ';

  @override
  String get themeAccentRuby => 'ሩቢ';

  @override
  String get themeAccentAmethyst => 'አሜቴስጢኖስ';

  @override
  String get themeAccentGraphite => 'ግራፋይት';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'ዛሬ';

  @override
  String get navAdd => 'አክል';

  @override
  String get navStats => 'ስታቲስቲክስ';

  @override
  String get navMore => 'ተጨማሪ';

  @override
  String get walkthroughTodayTitle => 'ቀንዎ በአንድ እይታ';

  @override
  String get walkthroughTodayBody => 'የተጣራ ሀብት፣ ያገኙት እና ያወጡት፣ እና የዛሬ እንቅስቃሴ።';

  @override
  String get walkthroughAddTitle => 'በሰከንዶች ውስጥ ያክሉ';

  @override
  String get walkthroughAddBody => 'ወጪ፣ ገቢ ወይም ዝውውር ለመመዝገብ አክል የሚለውን ይንኩ።';

  @override
  String get walkthroughTransactionsTitle => 'ግብይቶችዎ';

  @override
  String get walkthroughTransactionsBody =>
      'እያንዳንዱ ግብይት፣ በየወሩ። ማንኛውንም ለማግኘት ይፈልጉ እና ያጣሩ።';

  @override
  String get walkthroughStatsTitle => 'ገንዘብዎ የት እንደሚሄድ ይመልከቱ';

  @override
  String get walkthroughStatsBody => 'በሳምንት፣ በወር እና በዓመት፣ በምድብ የተዘጋጁ ገበታዎች።';

  @override
  String get walkthroughBellTitle => 'መረጃ ያግኙ';

  @override
  String get walkthroughBellBody => 'የበጀት ማንቂያዎች እና አስታዋሾች እዚህ ይታያሉ። ዝግጁ ነዎት!';

  @override
  String get walkthroughBalanceTitle => 'የተጣራ ሀብትዎ';

  @override
  String get walkthroughBalanceBody =>
      'ሁሉም ቦርሳዎች እዚህ ይደመራሉ፤ አከፋፈሉን የሚያሳይ አሞሌም አለ።';

  @override
  String get txTransfer => 'ዝውውር';

  @override
  String get txUncategorized => 'ያልተመደበ';

  @override
  String todayGoodMorning(String name) {
    return 'እንደምን አደሩ፣ $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'እንደምን ዋሉ፣ $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'እንደምን አመሹ፣ $name';
  }

  @override
  String get todayGoodMorningPlain => 'እንደምን አደሩ';

  @override
  String get todayGoodAfternoonPlain => 'እንደምን ዋሉ';

  @override
  String get todayGoodEveningPlain => 'እንደምን አመሹ';

  @override
  String get todayNetWorth => 'የተጣራ ሀብት';

  @override
  String todayThisMonthDelta(String amount) {
    return 'በዚህ ወር $amount';
  }

  @override
  String get todayEarned => 'የተገኘ';

  @override
  String get todaySpent => 'የወጣ';

  @override
  String get todayTitle => 'ዛሬ';

  @override
  String get todayRecent => 'የቅርብ';

  @override
  String get todayAllActivity => 'ሁሉም እንቅስቃሴ';

  @override
  String get todayNothingYet => 'ዛሬ እስካሁን ምንም የለም';

  @override
  String get todayNothingYetBody => 'የመጀመሪያውን ለመመዝገብ አክል የሚለውን ይንኩ።';

  @override
  String todayMoreWallets(int count) {
    return '+$count ተጨማሪ';
  }

  @override
  String get todayCoachTitle => 'የገንዘብ አማካሪዎን ይጠይቁ';

  @override
  String get todayCoachBody => 'ከራስዎ ወጪ የተገኙ መልሶች እና ምክሮች';

  @override
  String get todayNotifications => 'ማሳወቂያዎች';

  @override
  String get todayWithinBudget => 'በበጀት ውስጥ';

  @override
  String get todayOverBudget => 'ከበጀት በላይ';

  @override
  String get todayNetCredit => 'የተጣራ ብድር';

  @override
  String get todayNetDebt => 'የተጣራ ዕዳ';

  @override
  String get todayMonthly => 'ወርሃዊ';

  @override
  String get walletsTitle => 'ቦርሳዎች';

  @override
  String get walletsNew => 'አዲስ';

  @override
  String get walletsAddHint => 'ባንክ፣ ጥሬ ገንዘብ፣ ቁጠባ ያክሉ…';

  @override
  String get walletsPlanning => 'ዕቅድ';

  @override
  String get walletsUpcoming => 'መጪ';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count የሚከፈሉ · $amount';
  }

  @override
  String get walletsUpcomingNone => 'በቅርቡ የሚከፈል የለም';

  @override
  String get walletsLendBorrow => 'ብድር መስጠት እና መበደር';

  @override
  String get splitTitle => 'ሂሳብ ተካፈል';

  @override
  String get splitSubtitle =>
      'ሂሳብን ከጓደኞች ጋር ይካፈሉ፤ ያለባቸው ወደ ብድር መስጠት እና መበደር ይገባል';

  @override
  String get splitWhatFor => 'ለምን ነበር';

  @override
  String get splitTotal => 'ድምር';

  @override
  String get splitPeople => 'ሰዎች';

  @override
  String get splitYou => 'እርስዎ';

  @override
  String get splitIncludeMe => 'የእኔም ድርሻ ነበረኝ';

  @override
  String get splitIncludeMeSub => 'ለሌሎቹ ብቻ ከከፈሉ ያጥፉት';

  @override
  String get splitAddPerson => 'ሰው አክል';

  @override
  String get splitPersonName => 'ስም';

  @override
  String get splitKnownPeople => 'ከብድር መስጠት እና መበደር';

  @override
  String get splitRemove => 'አስወግድ';

  @override
  String get splitPaidBy => 'የከፈለው';

  @override
  String get splitHow => 'እንዴት ይከፈል';

  @override
  String get splitEqual => 'በእኩል';

  @override
  String get splitExact => 'በመጠን';

  @override
  String get splitPercent => 'በመቶኛ';

  @override
  String get splitShares => 'በድርሻ';

  @override
  String get splitYourShare => 'የእርስዎ ድርሻ';

  @override
  String get splitOwesYou => 'ያለበት ለእርስዎ';

  @override
  String splitYouOwe(String name) {
    return 'ለ$name አለብዎት';
  }

  @override
  String get splitPaidTheBill => 'ሂሳቡን ከፍሏል';

  @override
  String splitSettlesWith(String name) {
    return 'ከ$name ጋር ሂሳብ ያወራርዳል';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total ከሂሳብዎ፤ $owed ለእርስዎ ይመለሳል';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'አሁን ከሂሳብዎ ምንም አይወጣም፤ ለ$name $amount አለብዎት';
  }

  @override
  String get splitPercentLabel => 'ከሂሳቡ መቶኛ';

  @override
  String get splitSave => 'ተካፈል';

  @override
  String get splitSaved => 'ክፍፍሉ ተመዝግቧል';

  @override
  String get splitNeedCategory => 'መጀመሪያ ምድብ ይምረጡ።';

  @override
  String get splitThisBill => 'ይህን ሂሳብ ተካፈል';

  @override
  String get splitThisBillSub => 'ከጓደኞች ጋር፤ ያለባቸው ወደ ብድር መስጠት እና መበደር ይገባል';

  @override
  String get splitPartOf => 'የተካፈለ ሂሳብ';

  @override
  String walletsOwedToYou(String amount) {
    return 'ለእርስዎ $amount አለ';
  }

  @override
  String walletsYouOwe(String amount) {
    return '$amount አለብዎት';
  }

  @override
  String get walletsAllSettled => 'ሁሉም ተከፍሏል';

  @override
  String get walletsGoals => 'ግቦች';

  @override
  String walletsGoalsSub(int count) {
    return '$count ንቁ';
  }

  @override
  String get walletsBudgets => 'በጀቶች';

  @override
  String get walletsSubscriptions => 'ምዝገባዎች';

  @override
  String get walletsTransfer => 'በቦርሳዎች መካከል አዛውር';

  @override
  String get walletsArchived => 'በማህደር የተቀመጡ';

  @override
  String walletsDeleteMessage(String name) {
    return '“$name” ይሰረዝ? በዚህ ሂሳብ ውስጥ ያለ እያንዳንዱ ግብይት አብሮ ይሰረዛል።';
  }

  @override
  String walletsDeleted(String name) {
    return '$name ተሰርዟል';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name አሁን ነባሪዎ ነው';
  }

  @override
  String get walletsCreateFailed => 'ሂሳቡን መፍጠር አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get walletsEmptyBody => 'መከታተል ለመጀመር የመጀመሪያ ሂሳብዎን ይፍጠሩ።';

  @override
  String get walletsTypeBank => 'የባንክ ሂሳብ';

  @override
  String get walletsTypeCard => 'ክሬዲት ካርድ';

  @override
  String get walletsTypeCash => 'ጥሬ ገንዘብ';

  @override
  String get walletsTypeOther => 'ሂሳብ';

  @override
  String get moreTitle => 'ተጨማሪ';

  @override
  String get moreGoPremium => 'ወደ Premium ይሻገሩ';

  @override
  String get moreGoPremiumBody => 'AI ረዳት፣ የደመና ማመሳሰል፣ ገጽታዎች';

  @override
  String get moreUnlock => 'ክፈት';

  @override
  String get morePremiumActive => 'Premium ንቁ ነው';

  @override
  String get morePremiumThanks => 'The Accountant ን ስለደገፉ እናመሰግናለን';

  @override
  String get sectionPreferences => 'ምርጫዎች';

  @override
  String get sectionTools => 'የገንዘብ መሣሪያዎች';

  @override
  String get moreAiAssistant => 'AI ረዳት';

  @override
  String get moreAiAssistantSub => 'ስለ ገንዘብዎ ጥያቄዎችን ይጠይቁ';

  @override
  String get moreSignOutConfirm => 'በዚህ መሣሪያ ላይ ከመለያዎ ይውጡ?';

  @override
  String get moreSignOutFailed => 'መውጣት አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get moreDeviceOnlyBody =>
      'ነፃ መለያዎች ወደ ደመና ምትኬ አይቀመጥላቸውም፤ ስለዚህ እንደገና መጫን ወይም ስልክ መቀየር ውሂብዎን ሊያሳጣዎት ይችላል። ለደመና ማመሳሰል ያሻሽሉ፣ ወይም በየጊዜው ምትኬ ይላኩ።';

  @override
  String get moreUpgradeToPremium => 'ወደ Premium ያሻሽሉ';

  @override
  String get moreUser => 'እርስዎ';

  @override
  String get statsTitle => 'ስታቲስቲክስ';

  @override
  String get statsWeek => 'ሳምንት';

  @override
  String get statsMonth => 'ወር';

  @override
  String get statsYear => 'ዓመት';

  @override
  String get statsSpending => 'ወጪ';

  @override
  String get statsIncome => 'ገቢ';

  @override
  String get statsCategories => 'ምድቦች';

  @override
  String get statsSpent => 'የወጣ';

  @override
  String get statsEarned => 'የተገኘ';

  @override
  String get statsNet => 'የተጣራ';

  @override
  String get statsThisMonth => 'በዚህ ወር';

  @override
  String statsVsLastMonth(String change) {
    return 'ከባለፈው ወር ጋር ሲነጻጸር $change';
  }

  @override
  String get statsInsightsSub => 'የዚህ ወር ማጠቃለያ፣ አዝማሚያዎች እና ምክሮች';

  @override
  String get statsAskCoach => 'ስለዚህ የAI አማካሪውን ይጠይቁ';

  @override
  String statsOverBy(String amount) {
    return 'በ$amount በልጧል';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% ቀርቷል';
  }

  @override
  String get activityAll => 'ሁሉም';

  @override
  String get activitySpent => 'የወጣ';

  @override
  String get activityEarned => 'የተገኘ';

  @override
  String get activityTransfers => 'ዝውውሮች';

  @override
  String activitySoFar(String month) {
    return '$month እስካሁን';
  }

  @override
  String activityNet(String amount) {
    return '$amount የተጣራ';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በሁሉም ወራት $count ውጤቶች',
      one: 'በሁሉም ወራት 1 ውጤት',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'ያለፉት 7 ቀናት';

  @override
  String get statsPeriodThisMonth => 'በዚህ ወር';

  @override
  String get statsPeriodThisYear => 'በዚህ ዓመት';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች',
      one: '1 ግብይት',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'ከ“$query” ጋር የሚዛመድ የለም';
  }

  @override
  String get activitySearchNothingBody =>
      'ሁሉም ወራት ተፈልገዋል። ጥቂት ቃላትን፣ ሌላ አጻጻፍን ይሞክሩ ወይም ማጣሪያን ያጽዱ።';

  @override
  String get activityIn => 'ገቢ';

  @override
  String get activityOut => 'ወጪ';

  @override
  String get activityToday => 'ዛሬ';

  @override
  String get activityYesterday => 'ትናንት';

  @override
  String get activityTomorrow => 'ነገ';

  @override
  String get activityEmptyFutureTitle => 'የታቀዱ ግብይቶች የሉም';

  @override
  String activityEmptyFutureBody(String month) {
    return 'ለ$month የወደፊት ክፍያዎችን ያክሉ';
  }

  @override
  String get activityEmptyNowTitle => 'እስካሁን ግብይት የለም';

  @override
  String get activityEmptyNowBody => 'በዚህ ወር ወጪዎችዎን መከታተል ይጀምሩ';

  @override
  String get activityEmptyPastTitle => 'ምንም ግብይት አልተገኘም';

  @override
  String activityEmptyPastBody(String month) {
    return 'ለ$month ምንም መዝገብ የለም';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች ተሰርዘዋል',
      one: '1 ግብይት ተሰርዟል',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count ወደ $name ተዛውረዋል';
  }

  @override
  String get activityMixedCurrencies =>
      'እነዚህ በተለያዩ ምንዛሪዎች የተያዙ ስለሆኑ ሁሉም የሚዛወሩበት አንድ ሂሳብ የለም። ከአንድ ምንዛሪ ረድፎችን ይምረጡ።';

  @override
  String activityMovedPartial(int count) {
    return '$count ተዛውረዋል፤ ዝውውሮች ባሉበት ቀርተዋል';
  }

  @override
  String activityMoved(int count) {
    return '$count ወደ ሌላ ሂሳብ ተዛውረዋል';
  }

  @override
  String activityRedated(int count) {
    return 'የ$count ቀን ተቀይሯል';
  }

  @override
  String get activityNothingToPay => 'ለመከፈል የሚጠብቅ ምንም አልነበረም';

  @override
  String activityMarkedPaid(int count) {
    return '$count እንደተከፈሉ ምልክት ተደርጓል';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count ተቀድተዋል፤ ዝውውሮች ለብቻቸው ሊቀዱ አይችሉም';
  }

  @override
  String activityCopied(int count) {
    return '$count ተቀድተዋል';
  }

  @override
  String get activityDeleteOneBody => 'ከመዝገቦችዎ ይወገዳል፤ ቀሪ ሂሳብዎም እንደገና ይሰላል።';

  @override
  String get activitySearch => 'ፈልግ';

  @override
  String get addNewExpense => 'አዲስ ወጪ';

  @override
  String get addNewIncome => 'አዲስ ገቢ';

  @override
  String get addNewTransfer => 'አዲስ ዝውውር';

  @override
  String get addEditTitle => 'ግብይት አርትዕ';

  @override
  String get addAmount => 'መጠን';

  @override
  String get addCategory => 'ምድብ';

  @override
  String get addMore => 'ተጨማሪ';

  @override
  String get addWallet => 'ቦርሳ';

  @override
  String addChangeDate(String date) {
    return 'ቀን ቀይር፣ $date';
  }

  @override
  String addChangeTime(String time) {
    return 'ሰዓት ቀይር፣ $time';
  }

  @override
  String get addSwapAccounts => 'ሁለቱን ሂሳቦች አቀያይር';

  @override
  String get notifCheckTitle => 'ማሳወቂያዎችን ፈትሽ';

  @override
  String get notifAllowed => 'ማሳወቂያዎች ተፈቅደዋል';

  @override
  String get notifAllowedHint => 'አስታዋሾች ይህ ስልክ ላይ መድረስ ይችላሉ';

  @override
  String get notifBlocked => 'ማሳወቂያዎች ጠፍተዋል';

  @override
  String get notifBlockedHint => 'ለመፍቀድ ይንኩ፤ አለበለዚያ ምንም ሊደርስዎት አይችልም';

  @override
  String get notifSendTest => 'የሙከራ ማሳወቂያ ላክ';

  @override
  String get notifSendTestHint => 'አስታዋሾች በሚመጡበት መንገድ ከአገልጋያችን ይላካል';

  @override
  String get notifSending => 'በመላክ ላይ…';

  @override
  String get notifTestSent =>
      'ተልኳል። በጥቂት ሰከንዶች ውስጥ እና በገቢ መልዕክት ሳጥንዎ ውስጥ መታየት አለበት።';

  @override
  String notifTestFailed(String reason) {
    return 'መላክ አልተቻለም፦ $reason';
  }

  @override
  String get notifTestOffline => 'ከአገልጋዩ ጋር ግንኙነት የለም';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant ወጪዎን እንዲመዘግቡ በመረጡት ሰዓት ለስላሳ ዕለታዊ ማስታወሻ ይልካል። ማሳወቂያዎችን ለማሳየት ፈቃድ ያስፈልገዋል።';

  @override
  String get notifPrimerShow => 'የማስታወሻ ማሳወቂያዎችን አሳይ';

  @override
  String get notifPrimerTime => 'በመረጡት ሰዓት ይደርሳል';

  @override
  String get notifPrimerOff => 'በማንኛውም ጊዜ ማጥፋት ይችላሉ';

  @override
  String get notifPrimerAllow => 'ፍቀድ';

  @override
  String get cardBillsTitle => 'የካርድ ሂሳቦች';

  @override
  String get cardBillsSubtitle => 'የክሬዲት ካርድ መግለጫዎች፣ የመክፈያ ቀናት እና አስታዋሾች';

  @override
  String get cardBillsEmptyTitle => 'እስካሁን ክሬዲት ካርድ የለም';

  @override
  String get cardBillsEmptyBody =>
      'የክሬዲት ካርድ ዓይነት ሂሳብ ያክሉ፣ የመግለጫ ቀኑን እና የመክፈያ ቀኑን ያዘጋጁ፤ ሂሳቦቹም እዚህ ይታያሉ።';

  @override
  String get cardBillsAddCard => 'ካርድ አክል';

  @override
  String get cardStatementDay => 'የመግለጫ ቀን';

  @override
  String get cardStatementDayHint =>
      'በየወሩ ሂሳቡ የሚዘጋጅበት ቀን። እስከዚያ ቀን መጨረሻ ያለው ሁሉ በውስጡ ይካተታል።';

  @override
  String get cardDueDay => 'የመክፈያ ቀን';

  @override
  String get cardDueDayHint =>
      'ሂሳቡን ለመክፈል የመጨረሻው ቀን፤ ከመግለጫው በኋላ ያ ቀን ለመጀመሪያ ጊዜ ሲደርስ።';

  @override
  String get cardRemindTitle => 'አስታውሰኝ';

  @override
  String get cardRemindHint => 'ከመክፈያ ቀኑ በፊት፣ ከሂሳቡ ያልተከፈለ ካለ። 9 AM አካባቢ ይላካል።';

  @override
  String get cardRemindOff => 'ጠፍቷል';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ቀናት በፊት',
      one: 'አንድ ቀን በፊት',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'አልተዘጋጀም';

  @override
  String cardDayOfMonth(int day) {
    return 'ቀን $day';
  }

  @override
  String get cardSetUpBody =>
      'የዚህን ካርድ ሂሳቦች ለማየት እና ከመክፈያ ቀናቸው በፊት ለመታወስ የመግለጫ ቀኑን እና የመክፈያ ቀኑን ያዘጋጁ።';

  @override
  String get cardSetUp => 'ቀናቱን አዘጋጅ';

  @override
  String cardDueBy(String date) {
    return 'እስከ $date የሚከፈል የቀረ';
  }

  @override
  String get cardLeftToPay => 'የሚከፈል የቀረ';

  @override
  String cardStatementClosed(String date) {
    return 'የ$date መግለጫ';
  }

  @override
  String get cardPaidSince => 'ከዚያ ወዲህ የተከፈለ';

  @override
  String cardThisCycle(String date) {
    return 'ከዚያ ወዲህ የወጣ፣ ቀጣይ መግለጫ $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'የ$card ሂሳብ ክፍያ';
  }

  @override
  String get cardEdit => 'ካርድ አርትዕ';

  @override
  String get cardEarlierStatements => 'የቀድሞ መግለጫዎች';

  @override
  String get cardPaidShort => 'ተከፍሏል';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount ያልተከፈለ';
  }

  @override
  String get cardStatusNotSetUp => 'ቀናት አልተዘጋጁም';

  @override
  String get cardStatusNothingDue => 'የሚከፈል የለም';

  @override
  String get cardStatusPaid => 'ተከፍሏል';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'በ$days ቀናት ውስጥ ይከፈላል',
      one: 'ነገ ይከፈላል',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'ዛሬ ይከፈላል';

  @override
  String get cardStatusOverdue => 'ጊዜው አልፏል';

  @override
  String cardPaidOf(String paid, String owed) {
    return 'ከ$owed $paid ተከፍሏል';
  }

  @override
  String get cardPayBill => 'ሂሳብ ክፈል';

  @override
  String cardPayTitle(String card) {
    return '$card ክፈል';
  }

  @override
  String get cardPayHint =>
      'ሙሉውን ወይም ከፊሉን ይክፈሉ። የሚከፍሉት ማንኛውም ነገር ለዚህ ሂሳብ ይቆጠራል፤ የቀረውም እንደሚከፈል ይቆያል።';

  @override
  String cardPayFull(String amount) {
    return 'ሙሉውን ክፈል፣ $amount';
  }

  @override
  String get cardPayFullHint => 'በዚህ ሂሳብ ላይ የቀረው ሁሉ';

  @override
  String get cardPayOther => 'ሌላ መጠን ክፈል';

  @override
  String get cardPayOtherHint => 'ከፊል ክፍያ፣ ወይም ከሂሳቡ በላይ';

  @override
  String get addNoteHint => 'ማስታወሻ አክል';

  @override
  String get addRepeatMonthly => 'በየወሩ ድገም';

  @override
  String get addMoreOptions => 'ተጨማሪ አማራጮች';

  @override
  String get addScanReceipt => 'ደረሰኝ ቃኝ';

  @override
  String get addDelete => 'ግብይት ሰርዝ';

  @override
  String get addTypeExpense => 'ወጪ';

  @override
  String get addTypeIncome => 'ገቢ';

  @override
  String get addTypeTransfer => 'ዝውውር';

  @override
  String get gatePremium => 'Premium ዕቅድ';

  @override
  String get gateUnlock => 'በPremium ክፈት';

  @override
  String get gateFootnote => 'የዕድሜ ልክ ወይም ምዝገባ · በማንኛውም ጊዜ ይመልሱ';

  @override
  String get aiCoachTitle => 'የገንዘብ አማካሪዎን ይተዋወቁ';

  @override
  String get aiCoachBody =>
      'በቀላል ቃላት ይጠይቁ። ከራስዎ ወጪ የተገነቡ መልሶችን፣ ምክሮችን እና ዕቅዶችን ያግኙ።';

  @override
  String get aiAssistantTitle => 'AI ረዳት';

  @override
  String get aiAskAnything => 'ስለ ገንዘብዎ ይጠይቁ…';

  @override
  String get aiSend => 'ላክ';

  @override
  String get aiCopy => 'ቅዳ';

  @override
  String get aiCopied => 'ተቀድቷል';

  @override
  String get aiRetry => 'እንደገና ሞክር';

  @override
  String get aiDismiss => 'አሰናብት';

  @override
  String get aiTyping => 'አማካሪው እየጻፈ ነው';

  @override
  String aiStarterCategory(String category) {
    return 'የ$category ገንዘቤ የት ሄደ?';
  }

  @override
  String get aiStarterBudgets => 'በበጀቶቼ ላይ በትክክለኛው መንገድ ነኝ?';

  @override
  String get aiStarterUpcoming => 'የትኞቹ ሂሳቦች እየመጡ ነው?';

  @override
  String get aiStarterAnalyze => 'የቅርብ ጊዜ የወጪ ልማዶቼን ተንትን';

  @override
  String get aiStarterBudgetTips => 'ለተሻለ በጀት አወጣጥ ምክሮችን ስጠኝ';

  @override
  String get aiStarterSave => 'እንዴት ተጨማሪ ገንዘብ መቆጠብ እችላለሁ?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” እስከመጨረሻው ይሰረዛል።';
  }

  @override
  String get aiJustNow => 'አሁን';

  @override
  String get aiErrorTitle => 'አማካሪው መመለስ አልቻለም';

  @override
  String get paywallTitle => 'Accountant Premium ዕቅድ';

  @override
  String get paywallTagline => 'መተግበሪያው የሚችለው ሁሉ፣ ለእርስዎ።';

  @override
  String get paywallActiveTitle => 'Premium ንቁ ነው';

  @override
  String get paywallActiveTagline => 'ስለ ድጋፍዎ እናመሰግናለን!';

  @override
  String get paywallRestore => 'መልስ';

  @override
  String get paywallProcessing => 'በሂደት ላይ…';

  @override
  String paywallTriggered(String feature) {
    return '$feature የPremium ባህሪ ነው';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days ቀናት ቀርተዋል';
  }

  @override
  String get paywallFeatSync => 'የደመና ማመሳሰል';

  @override
  String get paywallFeatSyncSub => 'በሁሉም መሣሪያዎች';

  @override
  String get paywallFeatAi => 'AI ረዳት';

  @override
  String get paywallFeatAiSub => 'ያልተገደበ፣ ያለ ማስታወቂያ';

  @override
  String get paywallFeatOcr => 'ደረሰኝ ቅኝት';

  @override
  String get paywallFeatOcrSub => 'OCR ከAI ጋር';

  @override
  String get paywallFeatInsights => 'የወጪ ግንዛቤዎች';

  @override
  String get paywallFeatInsightsSub => 'ወርሃዊ አዝማሚያዎች';

  @override
  String get paywallFeatThemes => '5 ገጽታዎች';

  @override
  String get paywallFeatThemesSub => 'ልዩ';

  @override
  String get paywallFeatPdf => 'PDF ሪፖርቶች';

  @override
  String get paywallFeatPdfSub => 'CSV ነፃ ሆኖ ይቆያል';

  @override
  String get paywallFeatUnlimited => 'ያልተገደበ';

  @override
  String get paywallFeatUnlimitedSub => 'ቦርሳዎች፣ በጀቶች';

  @override
  String get paywallFeatSupport => 'ቅድሚያ እገዛ';

  @override
  String get paywallFeatSupportSub => 'ፈጣን ምላሾች';

  @override
  String get paywallPerMonth => '/በወር';

  @override
  String get paywallPerYear => '/በዓመት';

  @override
  String get paywallOnce => 'አንድ ጊዜ';

  @override
  String get paywallBestValue => 'ምርጥ ዋጋ';

  @override
  String get paywallForever => 'ለዘላለም';

  @override
  String get paywallMonthlyDesc => 'በየወሩ ይከፈላል';

  @override
  String get paywallYearlyDesc => 'በየዓመቱ ይከፈላል';

  @override
  String get paywallLifetimeDesc => 'አንድ ጊዜ ይክፈሉ፣ ለዘላለም ይጠቀሙ';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial ነፃ፣ ከዚያ $rest';
  }

  @override
  String get paywallCtaLifetime => 'የዕድሜ ልክ መዳረሻ ያግኙ';

  @override
  String get paywallCtaYearly => 'ዓመታዊ ዕቅድ ጀምር';

  @override
  String get paywallCtaMonthly => 'ወርሃዊ ዕቅድ ጀምር';

  @override
  String get paywallFootLifetime => 'የአንድ ጊዜ ግዢ · ምዝገባ የለም';

  @override
  String get paywallFootSubscription =>
      'በራስ-ሰር ይታደሳል · በመደብሩ ውስጥ በማንኛውም ጊዜ ይሰርዙ';

  @override
  String get paywallTerms =>
      'ምዝገባዎች ከApp Store ወይም ከGoogle Play መለያዎ ይከፈላሉ፤ አሁን ያለው ጊዜ ከማብቃቱ ቢያንስ 24 ሰዓታት በፊት ካልተሰረዙ በራስ-ሰር ይታደሳሉ።';

  @override
  String get paywallIapUnavailable =>
      'በዚህ መሣሪያ ላይ የመተግበሪያ ውስጥ ግዢዎች አይገኙም። Google Play Services መጫኑን እና መተግበሪያው ከPlay Store መምጣቱን ያረጋግጡ።';

  @override
  String get paywallLoadingPlans => 'ዕቅዶችን በመጫን ላይ…';

  @override
  String get paywallPlansFailed =>
      'ዕቅዶችን መጫን አልተቻለም። ግንኙነትዎን ይፈትሹ እና እንደገና ይሞክሩ።';

  @override
  String get paywallTryAgain => 'እንደገና ሞክር';

  @override
  String get paywallRestored => 'ግዢዎች ተመልሰዋል';

  @override
  String get paywallPurchased => 'ወደ Premium እንኳን ደህና መጡ!';

  @override
  String get paywallLifetimeNever => 'የዕድሜ ልክ መዳረሻ ጊዜው አያልፍም';

  @override
  String get helpSearchQuestions => 'ጥያቄዎችን ፈልግ';

  @override
  String get helpStepWallets => 'ቦርሳዎችን ያክሉ';

  @override
  String get helpStepCategories => 'ምድቦችን ይምረጡ';

  @override
  String get helpStepTrack => 'በየቀኑ ይከታተሉ';

  @override
  String get splashTagline => 'ገንዘብ፣ በብሩህ።';

  @override
  String get introStep1 => 'ሳንቲሞችዎን በመቁጠር ላይ…';

  @override
  String get introStep2 => 'ቦርሳዎችዎን በማንቃት ላይ…';

  @override
  String get introStep3 => 'ገበታዎቹን በማሳመር ላይ…';

  @override
  String get introStep4 => 'ልንደርስ ነው…';

  @override
  String get introTipLabel => 'የገንዘብ ምክር';

  @override
  String get introTip1 => 'መጀመሪያ ለራስዎ ይክፈሉ፦ ደሞዝዎ በገባበት ቀን ቁጠባውን ያውጡ።';

  @override
  String get introTip2 => 'ትናንሽ ዕለታዊ ወጪዎች ይደማመራሉ። መመዝገባቸው የትግሉ ግማሽ ነው።';

  @override
  String get introTip3 => 'የ3 ወር የአደጋ ጊዜ ፈንድ ድንገተኛ ነገሮችን ወደ ቀላል ችግሮች ይቀይራል።';

  @override
  String get introTip4 => 'ምዝገባዎችን በየወሩ ይገምግሙ፦ ያልተጠቀሙበትን ይሰርዙ።';

  @override
  String get introTip5 => 'ወሩ ከመጀመሩ በፊት ለእያንዳንዱ ብር ሥራ ይስጡት።';

  @override
  String get introTip6 => 'ካልታቀደ ማንኛውም ግዢ በፊት 24 ሰዓት ይጠብቁ።';

  @override
  String get introTip7 => 'በጀቶች ገደቦች አይደሉም፤ ለሚያስፈልገው ነገር ለማውጣት የሚሰጡ ፈቃዶች ናቸው።';

  @override
  String get introTip8 => 'ትናንሽ ስኬቶችን ያክብሩ፦ እያንዳንዱ ግብ በመጀመሪያው ተቀማጭ ይጀምራል።';

  @override
  String get adConfirmTitleAiCall => 'አንድ ተጨማሪ የAI ጥያቄ ያግኙ';

  @override
  String get adConfirmTitleTheme => 'የPremium ገጽታዎችን ለ24 ሰዓት ይሞክሩ';

  @override
  String get adConfirmTitlePdf => 'አንድ PDF ሪፖርት ይላኩ';

  @override
  String get adConfirmBodyAiCall =>
      'የዚህን ወር ነፃ የAI ጥያቄዎች ተጠቅመዋል። አጭር ማስታወቂያ ይመልከቱ እና አንድ ተጨማሪ ያግኙ።';

  @override
  String get adConfirmBodyTheme =>
      'አጭር ማስታወቂያ ይመልከቱ፤ ሁሉም የPremium ገጽታዎች ለሚቀጥሉት 24 ሰዓታት የእርስዎ ናቸው።';

  @override
  String get adConfirmBodyPdf => 'አንድ PDF ሪፖርት ለመላክ አጭር ማስታወቂያ ይመልከቱ።';

  @override
  String get adConfirmWarning => 'ማስታወቂያ ሊመለከቱ ነው። ይቀጥሉ?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በዚህ ወር $count ተጨማሪ ማስታወቂያዎች አሉ',
      one: 'በዚህ ወር 1 ተጨማሪ ማስታወቂያ አለ',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'የPremium አባላት ያልተገደበ AI፣ ሁሉንም ገጽታዎች እና PDF ሪፖርቶችን ያገኛሉ፤ ምንም ማስታወቂያ የለም።';

  @override
  String get adWatch => 'ማስታወቂያ ተመልከት';

  @override
  String get adGetPremium => 'Premium ያግኙ';

  @override
  String get adNotNow => 'አሁን አይደለም';

  @override
  String get adLoading => 'ማስታወቂያውን በመጫን ላይ…';

  @override
  String get adVerifying => 'ሽልማትዎን በማረጋገጥ ላይ…';

  @override
  String get adUnavailable => 'አሁን ምንም ማስታወቂያ የለም። እባክዎ ትንሽ ቆይተው እንደገና ይሞክሩ።';

  @override
  String get adSkipped => 'ማስታወቂያው ከማለቁ በፊት ተዘግቷል፤ ስለዚህ ምንም አልተከፈተም።';

  @override
  String get adRewardAiCall => 'ተጠናቋል! አንድ ተጨማሪ የAI ጥያቄ አለዎት።';

  @override
  String get adRewardTheme => 'የPremium ገጽታዎች ለ24 ሰዓት ተከፍተዋል።';

  @override
  String get adRewardPdf => 'አንድ PDF መላክ ተከፍቷል።';

  @override
  String get adMonthlyCapReached =>
      'የዚህ ወር ማስታወቂያዎች አልቀዋል። ነፃ ጥያቄዎችዎ በወሩ 1ኛ ቀን ይመለሳሉ፤ ወይም ላልተገደበ አገልግሎት ወደ Premium ይሻገሩ።';

  @override
  String get adRewardPending => 'እናመሰግናለን! ሽልማትዎ በቅጽበት ይታያል።';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በዚህ ወር $count ነፃ የAI ጥያቄዎች ቀርተዋል',
      one: 'በዚህ ወር 1 ነፃ የAI ጥያቄ ቀርቷል',
      zero: 'በዚህ ወር ነፃ የAI ጥያቄ አልቀረም',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium፦ ያልተገደበ';

  @override
  String get aiToolSearching => 'ግብይቶችዎን በመፈለግ ላይ…';

  @override
  String get aiToolSummarizing => 'ቁጥሮቹን በመደመር ላይ…';

  @override
  String get aiToolAccounts => 'ሂሳቦችዎን በመፈተሽ ላይ…';

  @override
  String get aiToolCategories => 'ምድቦችዎን በመመልከት ላይ…';

  @override
  String get aiToolCards => 'የካርድ ሂሳቦችን በመፈተሽ ላይ…';

  @override
  String get aiToolPlans => 'ክፍያዎችን እና ቁጠባዎችን በመፈተሽ ላይ…';

  @override
  String get aiToolSaving => 'በማስቀመጥ ላይ…';

  @override
  String get aiActionAddTitle => 'ይህ ግብይት ይጨመር?';

  @override
  String get aiActionUpdateTitle => 'ይህ ግብይት ይቀየር?';

  @override
  String get aiActionDeleteTitle => 'ይህ ግብይት ይሰረዝ?';

  @override
  String get aiActionPayCardTitle => 'የካርድ ሂሳብ ክፈል';

  @override
  String get aiActionCardSettingsTitle => 'የካርድ ቀናትን ቀይር';

  @override
  String get aiActionCreatePlanTitle => 'ዕቅድ ጀምር';

  @override
  String get aiActionPayPlanTitle => 'የዕቅድ ክፍያ መዝግብ';

  @override
  String get aiActionClosePlanTitle => 'ዕቅድን ቀደም ብለህ አጠናቅ';

  @override
  String get aiActionUpdatePlanTitle => 'ዕቅድ ቀይር';

  @override
  String get aiActionCreateInvestmentTitle => 'ኢንቨስትመንት አክል';

  @override
  String get aiActionTradeInvestmentTitle => 'የንግድ ልውውጥ መዝግብ';

  @override
  String get aiActionUpdateInvestmentTitle => 'ዋጋ አዘምን';

  @override
  String get aiActionConfirm => 'አረጋግጥ';

  @override
  String get aiActionClosePlan => 'አጠናቅ';

  @override
  String get aiActionFrom => 'ከ';

  @override
  String get aiActionTo => 'ወደ';

  @override
  String get aiActionBill => 'ሂሳብ';

  @override
  String get aiActionLeftAfter => 'ከዚያ በኋላ የሚቀር';

  @override
  String get aiActionRemindDays => 'አስታውስ፣ ቀናት በፊት';

  @override
  String get aiActionPay => 'ክፈል';

  @override
  String get plansTitle => 'የተከፋፈለ ክፍያ፣ ብድሮች እና ቁጠባ';

  @override
  String get investmentsTitle => 'ኢንቨስትመንቶች';

  @override
  String get investmentsSubtitle => 'የጋራ ፈንዶች፣ አክሲዮኖች እና SIP፣ በቅርብ ዋጋቸው የተገመቱ';

  @override
  String get forecastTitle => 'የገንዘብ ፍሰት ትንበያ';

  @override
  String get forecastSubtitle =>
      'የጥሬ ገንዘብዎ እና የባንክ ገንዘብዎ አቅጣጫ፣ እና የሚያጥርበት ማንኛውም ቀን';

  @override
  String forecastRangeDays(int days) {
    return '$days ቀናት';
  }

  @override
  String get forecastNow => 'አሁን ያለ ጥሬ ገንዘብ እና ባንክ';

  @override
  String get forecastMoneyIn => 'የሚገባ';

  @override
  String get forecastMoneyOut => 'የሚወጣ';

  @override
  String get forecastLowest => 'ዝቅተኛው';

  @override
  String forecastLowestOn(String date) {
    return 'በ$date';
  }

  @override
  String get forecastChartTitle => 'የተገመተ ቀሪ ሂሳብ';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'በ$date $amount ይጎድልዎታል';
  }

  @override
  String get forecastShortfallCause => 'በዚያ ቀን የሚወጣ፦';

  @override
  String get forecastAlreadyShort =>
      'የጥሬ ገንዘብ እና የባንክ ሂሳቦችዎ ቀድሞውንም ከዜሮ በታች ናቸው።';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'በሚቀጥሉት $days ቀናት ጉድለት የለም';
  }

  @override
  String get forecastAllCoveredBody => 'የታቀደው በጥሬ ገንዘብዎ እና በባንክ ገንዘብዎ ይሸፈናል።';

  @override
  String get forecastScheduledOnly =>
      'የሚቆጥረው የታቀደውን ብቻ ነው፦ ዕቅዶች፣ የካርድ ሂሳቦች፣ ምዝገባዎች፣ ተደጋጋሚ እና መጪ ክፍያዎች፣ እና የመክፈያ ቀን ያላቸው ብድሮች። የዕለት ወጪ አልተካተተም።';

  @override
  String get forecastEventsTitle => 'የሚመጡ';

  @override
  String forecastDayBalance(String amount) {
    return 'ቀሪ ሂሳብ $amount';
  }

  @override
  String get forecastEmptyTitle => 'ምንም የታቀደ የለም';

  @override
  String get forecastEmptyBody =>
      'በዚህ ጊዜ ውስጥ ያሉ ዕቅዶች፣ የካርድ ሂሳቦች፣ ምዝገባዎች እና መጪ ክፍያዎች እዚህ ይታያሉ።';

  @override
  String get forecastOverdue => 'ጊዜው ያለፈበት';

  @override
  String get forecastExpected => 'የሚጠበቅ';

  @override
  String get forecastEventWhen => 'መቼ';

  @override
  String get forecastEventKind => 'ዓይነት';

  @override
  String get forecastEventAccount => 'ሂሳብ';

  @override
  String get forecastEventOpen => 'ክፈት';

  @override
  String get forecastEventOverdueNote =>
      'ቀኑ አልፏል፤ አሁንም ክፍት ስለሆነ ዛሬ እንደሚከፈል ይቆጠራል።';

  @override
  String get forecastKindInstallment => 'የክፍያ ክፍል';

  @override
  String get forecastKindPremium => 'የኢንሹራንስ አረቦን';

  @override
  String get forecastKindDeposit => 'ተቀማጭ';

  @override
  String get forecastKindSipBuy => 'የSIP ግዢ';

  @override
  String get forecastKindProfit => 'ትርፍ';

  @override
  String get forecastKindMaturity => 'የብስለት ጊዜ';

  @override
  String get forecastKindCardBill => 'የካርድ ሂሳብ';

  @override
  String get forecastKindCardBillNext => 'ቀጣይ የካርድ ሂሳብ፣ እስካሁን';

  @override
  String get forecastKindSubscription => 'ምዝገባ';

  @override
  String get forecastKindRecurringBill => 'ተደጋጋሚ ክፍያ';

  @override
  String get forecastKindRecurringIncome => 'ተደጋጋሚ ገቢ';

  @override
  String get forecastKindUpcoming => 'መጪ';

  @override
  String get forecastKindBorrowed => 'የሚመለስ ብድር';

  @override
  String get forecastKindLent => 'ያበደሩት፣ የሚመለስ';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'በ$date $amount ሊጎድልዎት ይችላል';
  }

  @override
  String get forecastHomeWarningBody => 'የሚመጣውን ይመልከቱ';

  @override
  String get forecastDismiss => 'አሰናብት';

  @override
  String forecastNotifTitle(String day) {
    return 'በ$day ገንዘብ ሊያጥርዎት ይችላል';
  }

  @override
  String get settingsBillReminders => 'የሂሳብ እና የክፍያ ክፍል አስታዋሾች';

  @override
  String get settingsBillRemindersSub =>
      'የሚከፈሉ የካርድ ሂሳቦች፣ እና የሚመጡ የተከፋፈለ ክፍያ ወይም የቁጠባ ክፍሎች';

  @override
  String get settingsBillRemindersNote =>
      'የካርድ ሂሳብና የዕቅድ ክፍያ አስታዋሾች በስልክዎ ላይ በመተግበሪያው ይሰላሉ፤ ስለዚህ መጠኖችዎ ግላዊ ሆነው ይቆያሉ። መተግበሪያውን ለጥቂት ቀናት ካልከፈቱ፣ አስታዋሽ ሊዘገይ ወይም ሊያመልጥ ይችላል።';

  @override
  String get forecastNotifNowTitle => 'ዛሬ ገንዘብ አጥሮዎታል';

  @override
  String forecastNotifNowBody(String amount) {
    return 'አሁን የሚከፈለው ሂሳቦችዎ ከያዙት በ$amount ይበልጣል። የሚመጣውን ለማየት ይንኩ።';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'የታቀዱ ክፍያዎች $amount ያጎድሉዎታል። የሚመጣውን ለማየት ይንኩ።';
  }

  @override
  String get investmentsEmptyTitle => 'እስካሁን ኢንቨስትመንት የለም';

  @override
  String get investmentsEmptyBody =>
      'የጋራ ፈንድ፣ አክሲዮን ወይም ወርቅ ይከታተሉ፦ የከፈሉትን፣ አሁን ያለውን ዋጋ እና ትርፉን።';

  @override
  String get investmentsSold => 'የተሸጠ';

  @override
  String get investmentsWorth => 'የአሁን ዋጋ';

  @override
  String get investmentNew => 'አዲስ ኢንቨስትመንት';

  @override
  String get investmentNewHint =>
      'የፈንድ ዩኒቶች፣ የኩባንያ አክሲዮኖች ወይም በዩኒት የሚገዛ ሌላ ነገር፣ ለምሳሌ ወርቅ በግራም።';

  @override
  String get investmentKindFund => 'ፈንድ';

  @override
  String get investmentKindStock => 'አክሲዮኖች';

  @override
  String get investmentKindOther => 'ሌላ';

  @override
  String get investmentNameHintFund => 'ለምሳሌ፦ የቁጠባ ፈንድ';

  @override
  String get investmentNameHintStock => 'ለምሳሌ፦ ኢትዮ ቴሌኮም';

  @override
  String get investmentNameHintOther => 'ለምሳሌ፦ ወርቅ፣ 22 ካራት';

  @override
  String get investmentSymbol => 'ምልክት ወይም ኮድ (አማራጭ)';

  @override
  String get investmentFirstBuy => 'የገዙት';

  @override
  String get investmentFirstBuyHint => 'ገና ምንም ሳይገዙ ለማከል መጠኑን ባዶ ይተዉት።';

  @override
  String get investmentPaid => 'የተከፈለ';

  @override
  String get investmentReceived => 'የተቀበሉት';

  @override
  String get investmentPaidInto => 'የገባበት';

  @override
  String get investmentFee => 'ክፍያ ወይም ኮሚሽን';

  @override
  String get investmentUnits => 'ዩኒቶች';

  @override
  String get investmentUnitsSold => 'የተሸጡ ዩኒቶች';

  @override
  String investmentUnitsShort(String units) {
    return '$units ዩኒቶች';
  }

  @override
  String investmentPerUnit(String price) {
    return 'በዩኒት $price';
  }

  @override
  String get investmentNeedUnits => 'ስንት ዩኒቶች እንደተገዙ ያስገቡ።';

  @override
  String get investmentSave => 'ኢንቨስትመንት አክል';

  @override
  String get investmentAdded => 'ኢንቨስትመንቱ ታክሏል';

  @override
  String get investmentGone => 'ይህ ኢንቨስትመንት ተሰርዟል።';

  @override
  String get netWorthSubtitle => 'ያለዎት ሁሉ፣ ያለብዎት ሲቀነስ፣ እና እንዴት እንደተለወጠ';

  @override
  String get netWorthToday => 'ሀብትዎ';

  @override
  String netWorthSinceLastMonth(String amount) {
    return 'ከባለፈው ወር ወዲህ $amount';
  }

  @override
  String get netWorthBreakdown => 'ከምን ተሰራ';

  @override
  String get netWorthCash => 'ጥሬ ገንዘብ እና ባንክ';

  @override
  String get netWorthCards => 'ክሬዲት ካርዶች';

  @override
  String get netWorthDeposits => 'የቁጠባ ተቀማጮች';

  @override
  String get netWorthAssets => 'ንብረቶች';

  @override
  String get netWorthLent => 'ለሌሎች ያበደሩት';

  @override
  String get netWorthBorrowed => 'የተበደሩት';

  @override
  String get netWorthLoansNote =>
      'ያበደሩት ገንዘብ እስኪመለስ ድረስ እንደ የእርስዎ ይቆጠራል፤ የተበደሩት ገንዘብ ደግሞ እስኪመልሱ ድረስ ከእርስዎ ይቀነሳል።';

  @override
  String get netWorthCardsLeftOut =>
      'ክሬዲት ካርዶች አይቆጠሩም፤ ይህን በቅንብሮች ውስጥ መቀየር ይችላሉ።';

  @override
  String get netWorthHistory => 'በእያንዳንዱ ወር መጨረሻ';

  @override
  String get netWorthSixMonths => '6 ወራት';

  @override
  String get netWorthOneYear => '1 ዓመት';

  @override
  String get netWorthAllTime => 'ሁሉም';

  @override
  String get netWorthHistoryEmpty => 'መስመሩ የሚጀምረው መዝገቦችዎ ያሉበት አንድ ወር ሲያበቃ ነው።';

  @override
  String get assetNew => 'ንብረት አክል';

  @override
  String get assetNewHint =>
      'መሬት፣ አፓርታማ ወይም ቤት፣ መኪና፣ ወርቅ ወይም ያለዎት ሌላ ማንኛውም ነገር። ዋጋው ለተጣራ ሀብትዎ ይቆጠራል።';

  @override
  String get assetKind => 'ምንድን ነው';

  @override
  String get assetKindLand => 'መሬት';

  @override
  String get assetKindHome => 'አፓርታማ ወይም ቤት';

  @override
  String get assetKindCar => 'ተሽከርካሪ';

  @override
  String get assetKindGold => 'ወርቅ እና ጌጣጌጥ';

  @override
  String get assetKindOther => 'ሌላ ነገር';

  @override
  String get assetNameHintLand => 'ለምሳሌ፦ በቢሾፍቱ ያለ ቦታ';

  @override
  String get assetNameHintHome => 'ለምሳሌ፦ በቦሌ ያለ አፓርታማ';

  @override
  String get assetNameHintCar => 'ለምሳሌ፦ ቶዮታ ቪትዝ';

  @override
  String get assetNameHintGold => 'ለምሳሌ፦ የሠርግ ጌጣጌጥ';

  @override
  String get assetNameHintOther => 'ለምሳሌ፦ ካሜራ';

  @override
  String get assetWorthNow => 'የአሁን ዋጋ';

  @override
  String get assetBoughtNow => 'ከሂሳብ ተከፍሎበታል';

  @override
  String get assetBoughtNowHint =>
      'ጠፍቶ ከሆነ፦ ቀድሞውኑ የእርስዎ ነው፤ ምንም ገንዘብ አይንቀሳቀስም።';

  @override
  String get assetSave => 'ንብረት አክል';

  @override
  String get assetAdded => 'ንብረቱ ታክሏል';

  @override
  String get assetsEmptyTitle => 'እስካሁን ንብረት የለም';

  @override
  String get assetsEmptyBody => 'ጠቅላላ ሀብትዎን ለማየት መሬት፣ ቤት፣ መኪና ወይም ወርቅ ያክሉ።';

  @override
  String get assetsSold => 'የተሸጠ';

  @override
  String assetCostLine(String amount) {
    return 'ወጪ $amount';
  }

  @override
  String get assetUpdateValue => 'ዋጋ አዘምን';

  @override
  String get assetSell => 'ሽጥ';

  @override
  String get assetDelete => 'አስወግድ';

  @override
  String get assetValueUpdated => 'ዋጋው ተዘምኗል';

  @override
  String get assetSold => 'ተሽጧል፤ ገንዘቡም ተመዝግቧል';

  @override
  String assetDeleteTitle(String name) {
    return '$name ይወገድ?';
  }

  @override
  String get assetDeleteBody => 'ከእንግዲህ አይቆጠርም። ታሪኩ ከመዝገቦችዎ ጋር ይቆያል።';

  @override
  String get assetDeleted => 'ንብረቱ ተወግዷል';

  @override
  String get aiActionCreateAssetTitle => 'ንብረት አክል';

  @override
  String get aiActionUpdateAssetTitle => 'የንብረት ዋጋ አዘምን';

  @override
  String get aiActionSellAssetTitle => 'ንብረት ሽጥ';

  @override
  String get investmentWorthNow => 'የአሁን ዋጋ';

  @override
  String investmentGainLine(String gain) {
    return 'በአጠቃላይ $gain';
  }

  @override
  String get investmentPrice => 'ዋጋ';

  @override
  String get investmentPutIn => 'የገባ';

  @override
  String get investmentTakenOut => 'የወጣ';

  @override
  String get investmentBuy => 'ግዛ';

  @override
  String get investmentSell => 'ሽጥ';

  @override
  String investmentBuyTitle(String name) {
    return '$name ግዛ';
  }

  @override
  String investmentSellTitle(String name) {
    return '$name ሽጥ';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'ከ$name የተገኘ ትርፍ ድርሻ';
  }

  @override
  String get investmentDividend => 'የትርፍ ድርሻ';

  @override
  String get investmentRecordDividend => 'የትርፍ ድርሻ መዝግብ';

  @override
  String investmentHeldNow(String units) {
    return 'አሁን $units ዩኒቶች ተይዘዋል።';
  }

  @override
  String get investmentRecorded => 'ተመዝግቧል';

  @override
  String get investmentUpdatePrice => 'ዋጋውን አዘምን';

  @override
  String get investmentUpdatePriceHint => 'የዛሬ NAV ወይም የአክሲዮን ዋጋ፣ ለአንድ ዩኒት';

  @override
  String get investmentPriceUpdated => 'ዋጋው ተዘምኗል';

  @override
  String get investmentStartSip => 'SIP ጀምር';

  @override
  String get investmentStartSipHint => 'በየወሩ የተወሰነ መጠን በራሱ ይግዙ';

  @override
  String get investmentHistory => 'ታሪክ';

  @override
  String investmentBought(String units) {
    return '$units ዩኒቶች ተገዝተዋል';
  }

  @override
  String investmentSold(String units) {
    return '$units ዩኒቶች ተሽጠዋል';
  }

  @override
  String get investmentPriceRose => 'ዋጋው ጨምሯል';

  @override
  String get investmentPriceFell => 'ዋጋው ቀንሷል';

  @override
  String get investmentUnitsUnknown => 'ዩኒቶች ገና አልታወቁም፤ ለማከል ይንኩ';

  @override
  String get investmentCorrectUnits => 'በዚህ ግብይት ላይ ያሉ ዩኒቶች';

  @override
  String get investmentCorrectUnitsHint => 'የፈንድዎ ወይም የደላላዎ መግለጫ እንደሚያሳየው።';

  @override
  String get investmentUnitsCorrected => 'ዩኒቶቹ ተስተካክለዋል';

  @override
  String get investmentDelete => 'ይህን ኢንቨስትመንት ሰርዝ';

  @override
  String investmentDeleteTitle(String name) {
    return '$name ይሰረዝ?';
  }

  @override
  String get investmentDeleteBody =>
      'ግብይቶቹ በታሪክዎ ውስጥ ይቆያሉ። የሚቻለው ሁሉም ከተሸጠ በኋላ ብቻ ነው።';

  @override
  String get investmentDeleted => 'ኢንቨስትመንቱ ተሰርዟል';

  @override
  String get plansSubtitle =>
      'የተከፋፈሉ ክፍያዎች፣ ብድሮች፣ ቁጠባዎች፣ የጊዜ ተቀማጮች፣ ኢንሹራንስ፣ ቦንዶች እና SIP፣ በጊዜው የተከፈሉ እና የተሰበሰቡ';

  @override
  String get planNew => 'ዕቅድ ጀምር';

  @override
  String get planNewTitle => 'ምን እየጀመሩ ነው?';

  @override
  String get plansEmptyTitle => 'እስካሁን የተከፋፈለ ክፍያ፣ ብድር ወይም ቁጠባ የለም';

  @override
  String get plansEmptyBody =>
      'በክፍያ የተገዛ ነገር፣ ብድር፣ የጊዜ ቁጠባ ወይም የጊዜ ተቀማጭ ይከታተሉ። ክፍያዎች በቀናቸው ይመዘገባሉ፤ ከእያንዳንዱ በፊትም ይታወሳሉ።';

  @override
  String get plansEnded => 'የተጠናቀቁ';

  @override
  String get planKindEmi => 'በክፍያ ግዢ';

  @override
  String get planKindLoan => 'ብድር';

  @override
  String get planKindDps => 'የጊዜ ቁጠባ';

  @override
  String get planKindFdr => 'የጊዜ ተቀማጭ';

  @override
  String get planKindInsurance => 'ኢንሹራንስ';

  @override
  String get planKindBond => 'ቦንድ ወይም ሰርተፍኬት';

  @override
  String get planKindSip => 'SIP ዕቅድ';

  @override
  String get planKindEmiHint =>
      'በክፍያ የተገዛ ነገር፣ ከጥሬ ገንዘብ፣ ከባንክ ሂሳብ ወይም ከካርድ የሚከፈል';

  @override
  String get planKindLoanHint => 'የተበደሩት እና በወለድ በክፍያ የሚመለስ ገንዘብ';

  @override
  String get planKindDpsHint =>
      'ለተወሰነ ጊዜ በየወሩ የተወሰነ መጠን ይቆጥቡ፤ ከትርፍ ጋር መልሰው ያግኙት';

  @override
  String get planKindFdrHint =>
      'አንድ ገንዘብ ለተወሰነ ጊዜ በባንክ ያስቀምጡ፤ ትርፍ በየወሩ፣ በየሦስት ወሩ ወይም መጨረሻ ላይ';

  @override
  String get planKindInsuranceHint =>
      'በየወሩ፣ በየሩብ ዓመቱ ወይም በየዓመቱ አረቦን ያለው ፖሊሲ፤ ካለው መጨረሻ ላይ ክፍያ';

  @override
  String get planKindBondHint =>
      'ቦንድ ወይም የቁጠባ ሰርተፍኬት፦ ለዓመታት የሚቆይ አንድ ገንዘብ፣ ትርፍ በየወሩ፣ በየሦስት ወሩ ወይም መጨረሻ ላይ፣ ከግብር በኋላ';

  @override
  String get planKindSipHint =>
      'በየወሩ የተወሰነ ገንዘብ ወደ ፈንድ ወይም አክሲዮን፣ በቅርብ ዋጋ የሚገዛ';

  @override
  String get planWeekly => 'ሳምንታዊ';

  @override
  String get planMonthly => 'ወርሃዊ';

  @override
  String get planQuarterly => 'በየሩብ ዓመቱ';

  @override
  String get planHalfYearly => 'በየግማሽ ዓመቱ';

  @override
  String get planYearly => 'ዓመታዊ';

  @override
  String get planMonths => 'ወራት';

  @override
  String get planYears => 'ዓመታት';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount እስከ $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return 'ከ$total $saved ተቆጥቧል';
  }

  @override
  String planPaidLine(String paid, String total) {
    return 'ከ$total $paid ተከፍሏል';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'ቀጣይ፦ $amount በ$date';
  }

  @override
  String get planStatusCompleted => 'ተጠናቋል';

  @override
  String get planStatusClosed => 'ተዘግቷል';

  @override
  String get planStatusOverdue => 'ጊዜው አልፏል';

  @override
  String get planStatusRunning => 'በሂደት ላይ';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done ከ$total';
  }

  @override
  String get planGone => 'ይህ ዕቅድ ተሰርዟል።';

  @override
  String get planAccount => 'ሂሳብ';

  @override
  String get planAccountEmi => 'የተከፈለበት';

  @override
  String get planAccountLoan => 'የገባበት እና የሚከፈልበት';

  @override
  String get planAccountSaving => 'ከሂሳብ';

  @override
  String get planPrice => 'ዋጋ';

  @override
  String get planBorrowed => 'የተበደሩት መጠን';

  @override
  String get planDeposited => 'የተቀመጠው መጠን';

  @override
  String get planDeposit => 'እያንዳንዱ ተቀማጭ';

  @override
  String get planInstallment => 'እያንዳንዱ ክፍያ';

  @override
  String get planWorkedOut => 'ከዋጋው፣ ከወለድ መጠኑ እና ከጊዜው የተሰላ';

  @override
  String get planProgress => 'የተጠናቀቀ';

  @override
  String get planSavedSoFar => 'እስካሁን የተቆጠበ';

  @override
  String get planPaidSoFar => 'እስካሁን የተከፈለ';

  @override
  String get planLeft => 'የቀረ';

  @override
  String get planTotal => 'በአጠቃላይ';

  @override
  String get planInterestCharges => 'ወለድ እና ክፍያዎች';

  @override
  String get planRate => 'የወለድ መጠን';

  @override
  String get planRateLabel => 'የዓመት ወለድ %';

  @override
  String get planRateOptional => 'አማራጭ';

  @override
  String get planPayout => 'የተከፈለ ትርፍ';

  @override
  String get planPayoutMonthly => 'በየወሩ';

  @override
  String get planPayoutQuarterly => 'በየ3 ወሩ';

  @override
  String get planPayoutAtMaturity => 'መጨረሻ ላይ';

  @override
  String get planMaturesOn => 'የሚበስልበት ቀን';

  @override
  String get planMaturity => 'መጨረሻ ላይ የሚመለስ';

  @override
  String get planEstimated => 'ከወለድ መጠኑ የተገመተ፤ የባንኩን አሃዝ ለማስገባት ይንኩ';

  @override
  String get planHolding => 'አሁን በተቀማጩ ውስጥ ያለ';

  @override
  String get planEnds => 'የመጨረሻ ክፍያ';

  @override
  String planTakeMaturity(String amount) {
    return 'የብስለት ገንዘቡን ውሰድ፣ $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'ትርፉን መዝግብ፣ $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'ክፍያ $numberን አሁን ክፈል፣ $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'አረቦን $numberን አሁን ክፈል፣ $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'ተቀማጭ $numberን አሁን አስቀምጥ፣ $amount';
  }

  @override
  String get planRecorded => 'ተመዝግቧል።';

  @override
  String get planSaved => 'ተቀምጧል።';

  @override
  String get planPayOff => 'ቀደም ብለህ ጨርሰህ ክፈል';

  @override
  String get planEncash => 'ቀደም ብለህ አውጣ';

  @override
  String get planSurrender => 'ፖሊሲውን አቋርጥ';

  @override
  String planSurrenderTitle(String name) {
    return '$name ይቋረጥ?';
  }

  @override
  String get planSurrenderBody =>
      'አረቦኖች ይቆማሉ። ኢንሹራንሱ የሚመልሰው ማንኛውም ገንዘብ እንደ ገቢ ይመዘገባል።';

  @override
  String get planSurrenderNothing => 'ምንም አልተመለሰም';

  @override
  String get planSurrenderValue => 'የማቋረጫ ዋጋውን ያስገቡ';

  @override
  String get planSurrenderValueLabel => 'የማቋረጫ ዋጋ';

  @override
  String get planStopSip => 'SIP ን አቁም';

  @override
  String planStopSipTitle(String name) {
    return '$name ይቁም?';
  }

  @override
  String get planStopSipBody => 'ተጨማሪ ግዢ የለም። የተገዛው በኢንቨስትመንቱ ውስጥ ይቆያል።';

  @override
  String get planSipStopped => 'SIP ቆሟል';

  @override
  String get planSave => 'አስቀምጥ';

  @override
  String get planSurrendered => 'ፖሊሲው ተቋርጧል';

  @override
  String planPayOffTitle(String name) {
    return '$name ተከፍሎ ይጠናቀቅ?';
  }

  @override
  String get planPayOffHint => 'ለቀረው አንድ ክፍያ፣ እና ዕቅዱ ያበቃል።';

  @override
  String planPayOffLeft(String amount) {
    return 'የቀረውን ክፈል፣ $amount';
  }

  @override
  String get planPayOffOther => 'አበዳሪው የተለየ መጠን ጠቅሷል';

  @override
  String planEncashTitle(String name) {
    return '$name ይውጣ?';
  }

  @override
  String get planEncashBody => 'በተቀማጩ ውስጥ ያለው ወደ ሂሳቡ ይመለሳል፤ ዕቅዱም ያበቃል።';

  @override
  String get planEncashNoProfit => 'ያለ ትርፍ አውጣ';

  @override
  String get planEncashWithProfit => 'ባንኩ ከከፈለው ትርፍ ጋር አውጣ';

  @override
  String get planEncashed => 'ወጥቷል። ገንዘቡ ወደ ሂሳቡ ተመልሷል።';

  @override
  String get planPaidOff => 'ተከፍሎ አልቋል።';

  @override
  String get planAutoCollect => 'በራሱ መዝግብ';

  @override
  String get planAutoCollectHint => 'እያንዳንዱ ክፍያ፣ ትርፍ እና ብስለት በቀኑ ይመዘገባል';

  @override
  String get planSchedule => 'መርሐ ግብር';

  @override
  String get planDelete => 'ይህን ዕቅድ ሰርዝ';

  @override
  String planDeleteTitle(String name) {
    return '$name ይሰረዝ?';
  }

  @override
  String get planDeleteBody =>
      'የመዘገበው በግብይቶችዎ ውስጥ ይቆያል። ከዚህ በኋላ ምንም አይመዘገብም ወይም አይታወስም።';

  @override
  String get planDeleted => 'ተሰርዟል።';

  @override
  String planEventInstallment(int number, int total) {
    return 'ክፍያ $number ከ$total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'አረቦን $number ከ$total';
  }

  @override
  String get planEventPayout => 'ፖሊሲው ይከፍላል';

  @override
  String planEventProfit(int number) {
    return 'ትርፍ፣ ወር $number';
  }

  @override
  String get planEventMaturity => 'ብስለት';

  @override
  String get planEventDone => 'ተጠናቋል';

  @override
  String get planEventLate => 'ጊዜው አልፏል';

  @override
  String get planEventUpcoming => 'መጪ';

  @override
  String get planNeedAccount => 'መጀመሪያ ሂሳብ ይምረጡ።';

  @override
  String get planCreated => 'ተጀምሯል። ቀድሞ የደረሰ ማንኛውም ነገር ተመዝግቧል።';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total፤ ከዚህ ውስጥ $interest ወለድ እና ክፍያዎች ነው።';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total፣ ያለ ወለድ።';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return '$deposited ያስገባሉ፤ በ$date ወደ $maturity ገደማ ይመለስልዎታል።';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal በ$date ወደ $maturity ገደማ ያድጋል።';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'በየወሩ $profit ትርፍ፣ እና በ$date $principal ይመለሳል።';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count አረቦኖች በ$premium፣ በአጠቃላይ $total።';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count አረቦኖች በ$premium፣ በአጠቃላይ $total፣ እና በ$date $payout ይመለሳል።';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'በየሦስት ወሩ $profit ትርፍ፣ እና በ$date $principal ይመለሳል።';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount ወደ $fund፣ በአጠቃላይ $total።';
  }

  @override
  String planNewKind(String kind) {
    return 'አዲስ $kind';
  }

  @override
  String get planName => 'ስም';

  @override
  String get planNameHintEmi => 'ለምሳሌ፦ በክፍያ የተገዛ ስልክ';

  @override
  String get planNameHintLoan => 'ለምሳሌ፦ የሞተር ብስክሌት ብድር';

  @override
  String get planNameHintDps => 'ለምሳሌ፦ የንግድ ባንክ ቁጠባ';

  @override
  String get planNameHintFdr => 'ለምሳሌ፦ የአቢሲንያ ባንክ የጊዜ ተቀማጭ';

  @override
  String get planNameHintInsurance => 'ለምሳሌ፦ የሕይወት ፖሊሲ';

  @override
  String get planNameHintBond => 'ለምሳሌ፦ የ5 ዓመት የመንግሥት ቦንድ';

  @override
  String get planNameHintSip => 'ለምሳሌ፦ ወርሃዊ የፈንድ SIP';

  @override
  String get planSipFund => 'የሚገዛው';

  @override
  String get planSipAmount => 'እያንዳንዱ SIP';

  @override
  String get planSipNoFund => 'መጀመሪያ ፈንዱን ወይም አክሲዮኑን በኢንቨስትመንቶች ውስጥ ያክሉ።';

  @override
  String get planProvider => 'ባንክ ወይም ኩባንያ';

  @override
  String get planReference => 'የፖሊሲ ወይም የሂሳብ ቁጥር';

  @override
  String get planSumAssured => 'የመድን ገንዘብ';

  @override
  String get planPremium => 'አረቦን';

  @override
  String get planPremiums => 'አረቦኖች';

  @override
  String get planTaxLabel => 'ከምንጩ የሚቀነስ ግብር %';

  @override
  String get planTax => 'ከምንጩ የሚቀነስ ግብር';

  @override
  String get planFirstPremium => 'የመጀመሪያ አረቦን';

  @override
  String get planLastPremium => 'የመጨረሻ አረቦን';

  @override
  String get planInsurancePayout => 'መጨረሻ ላይ የሚመለስ';

  @override
  String get planNone => 'ምንም';

  @override
  String get planHowMany => 'ስንት';

  @override
  String get planTerm => 'ጊዜ';

  @override
  String get planOpenedOn => 'የተከፈተበት ቀን';

  @override
  String get planFirstDue => 'የመጀመሪያ ክፍያ';

  @override
  String get planCategory => 'ምድብ';

  @override
  String get planCategoryDefault => 'የብድር ክፍያ';

  @override
  String get planCategoryInsurance => 'ኢንሹራንስ';

  @override
  String get planLoanReceived => 'ገንዘቡ ወደዚህ ሂሳብ ገብቷል';

  @override
  String get planLoanReceivedHint => 'በቀጥታ ወደ ሻጭ ከሄደ ያጥፉት';

  @override
  String get planStart => 'ጀምር';

  @override
  String get aiActionDeleteNote =>
      'ወደ በቅርቡ የተሰረዙ ይሄዳል፤ እዚያም ለ30 ቀናት መመለስ ይችላሉ።';

  @override
  String get aiActionAdd => 'አክለው';

  @override
  String get aiActionSave => 'ለውጡን አስቀምጥ';

  @override
  String get aiActionDelete => 'ሰርዘው';

  @override
  String get aiActionCancel => 'አይ፣ ተወው';

  @override
  String get aiActionAmount => 'መጠን';

  @override
  String get aiActionKind => 'ዓይነት';

  @override
  String get aiActionTitle => 'ርዕስ';

  @override
  String get aiActionCategory => 'ምድብ';

  @override
  String get aiActionAccount => 'ሂሳብ';

  @override
  String get aiActionDate => 'ቀን';

  @override
  String get aiActionNotes => 'ማስታወሻዎች';

  @override
  String get aiReport => 'ችግር ሪፖርት አድርግ';

  @override
  String get aiReportWrongAnswer => 'አማካሪው ስህተት ሠርቷል';

  @override
  String get aiReportWrongAnswerHint => 'የተሳሳተ ቁጥር፣ የተፈጠረ መረጃ ወይም ያልጠየቁት ለውጥ';

  @override
  String get aiReportWrongAnswerSubject => 'የገንዘብ አማካሪ፦ የተሳሳተ መልስ';

  @override
  String get aiReportBug => 'ስህተት (ባግ) ሪፖርት አድርግ';

  @override
  String get aiReportBugHint => 'የተበላሸ፣ የቀዘቀዘ ወይም ያልተጫነ ነገር';

  @override
  String get aiReportBugSubject => 'የገንዘብ አማካሪ፦ የስህተት ሪፖርት';

  @override
  String get aiAboutCoach => 'አማካሪው እንዴት ይሠራል';

  @override
  String get aiDisclaimerTitle => 'አማካሪውን ከመጠየቅዎ በፊት';

  @override
  String get aiDisclaimerMistakes =>
      'አማካሪው AI ነው። ቁጥርን ሊሳሳት፣ ጥያቄን በተሳሳተ መንገድ ሊረዳ ወይም እውነት ያልሆነ ነገር ሊናገር ይችላል፤ ስለዚህ አስፈላጊ የሆነውን ከራስዎ ግብይቶች ጋር ያረጋግጡ።';

  @override
  String get aiDisclaimerData =>
      'አሃዞችዎ በስልክዎ ላይ ይነበባሉ። ለመመለስ መተግበሪያው ጥያቄዎን እና የሚያስፈልጉትን አሃዞች ወደ አገልጋያችን እና ወደ AI ሞዴሉ ይልካል።';

  @override
  String get aiDisclaimerChanges =>
      'በራሱ ገንዘብዎን በጭራሽ አይቀይርም። እያንዳንዱ መጨመር፣ ማረም ወይም መሰረዝ መጀመሪያ ይታይዎታል፤ የሚፈጸመውም እርስዎ ካረጋገጡ ብቻ ነው።';

  @override
  String get aiDisclaimerReport => 'መልሱ የተሳሳተ ከመሰለ እንዲያሳውቁን ከላይ ያለውን ባንዲራ ይንኩ።';

  @override
  String get aiDisclaimerAccept => 'ገብቶኛል';

  @override
  String get aiOutOfRequestsTitle => 'የዚህን ወር ነፃ ጥያቄዎች ተጠቅመዋል';

  @override
  String get aiOutOfRequestsBody =>
      'ይህን ለመጠየቅ አጭር ማስታወቂያ ይመልከቱ፣ ወይም ያለ ማስታወቂያ ያልተገደቡ መልሶችን ለማግኘት ወደ Premium ይሻገሩ። ነፃ ጥያቄዎች በወሩ 1ኛ ቀን ይመለሳሉ።';

  @override
  String get ocrNoCamera => 'ካሜራውን መክፈት አልተቻለም።';

  @override
  String get ocrNoGallery => 'ማዕከለ ምስሉን መክፈት አልተቻለም።';

  @override
  String get ocrScanTitle => 'ደረሰኝ ቃኝ';

  @override
  String get ocrScanAnother => 'ሌላ ቃኝ';

  @override
  String get ocrScanBody =>
      'ፎቶ ያንሱ ወይም ይምረጡ። መተግበሪያው ያነበዋል፤ AI ደግሞ ዝርዝሩን ይሞላል።';

  @override
  String get ocrReadingWithAi => 'AI ደረሰኝዎን እያነበበ ነው…';

  @override
  String get ocrNothingRead =>
      'ከዚያ ፎቶ ምንም ጽሑፍ ማንበብ አልተቻለም። ሙሉው ደረሰኝ እንዲታይ አድርገው በተሻለ ብርሃን እንደገና ይሞክሩ።';

  @override
  String get ocrAiOfferTitle => 'AI በትክክል እንዲያነበው ይፍቀዱ';

  @override
  String get ocrAiOfferBody =>
      'በተዘበራረቀ ደረሰኝ ላይም ቢሆን እውነተኛውን ድምር፣ ቀኑን፣ እያንዳንዱን ዕቃ እና ትክክለኛውን ምድብ ያገኛል።';

  @override
  String get ocrReadWithAi => 'በAI አንብብ';

  @override
  String get ocrReadByAi => 'በAI የተነበበ። ከማስቀመጥዎ በፊት ያረጋግጡ።';

  @override
  String get ocrItems => 'ዕቃዎች';

  @override
  String get quickAddTitle => 'ይግለጹት';

  @override
  String get quickAddSubtitle => 'እንደሚናገሩት ይጻፉት። AI ቅጹን ይሞላልዎታል፤ እርስዎ ያረጋግጣሉ።';

  @override
  String get quickAddHint => 'ለምሳሌ፦ ምሳ 250 ትናንት ከbKash';

  @override
  String get quickAddFill => 'ሙላው';

  @override
  String get summaryTitle => 'ወርሃዊ ማጠቃለያ';

  @override
  String get summarySpent => 'በዚህ ወር የወጣ';

  @override
  String summaryEarned(String amount) {
    return '$amount ተገኝቷል';
  }

  @override
  String summaryLessThanLast(int percent) {
    return 'ከባለፈው ወር $percent% ያነሰ';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return 'ከባለፈው ወር $percent% የበለጠ';
  }

  @override
  String get summaryAiTitle => 'ወርዎ፣ በአጭሩ';

  @override
  String get summaryAiBody =>
      'AI ወርዎን ከባለፈው ወር ጋር ያነጻጽራል፤ ጎልተው የወጡትን ይመርጣል፤ የሚሞክሩትንም አንድ ነገር ይጠቁማል።';

  @override
  String get summaryWrite => 'ማጠቃለያዬን ጻፍ';

  @override
  String get summaryOutdated => 'ይህ ማጠቃለያ ከተጻፈ በኋላ ግብይቶችዎ ተቀይረዋል።';

  @override
  String get summaryUpdate => 'ማጠቃለያዬን አዘምን';

  @override
  String get summaryWriting => 'ማጠቃለያዎን በመጻፍ ላይ…';

  @override
  String get summaryByCategory => 'በምድብ';

  @override
  String get summaryNoSpending => 'በዚህ ወር እስካሁን የተመዘገበ ወጪ የለም።';

  @override
  String themeTrialUntil(String time) {
    return 'የPremium ገጽታዎች እስከ $time ተከፍተዋል';
  }

  @override
  String get zakatTitle => 'ዘካ';

  @override
  String get zakatSubtitle => 'በሀብትዎ ላይ የሚገባውን ያሰሉ፤ የሚከፍሉትንም ይመዝግቡ';

  @override
  String get zakatSubtitleOff => 'ዘካ አይከፍሉም። ቢሆንም ለማየት ይንኩ';

  @override
  String get zakatAskTitle => 'ዘካ ይከፍላሉ?';

  @override
  String get zakatAskBody =>
      'ሁሉም ሰው አይከፍልም። ካልከፈሉ መተግበሪያው ዘካን ከመንገድዎ ያርቃል፦ የሚከፈል ነገርም ሆነ አስታዋሽ የለም።';

  @override
  String get zakatIPay => 'ዘካ እከፍላለሁ';

  @override
  String get zakatIDontPay => 'ዘካ አልከፍልም';

  @override
  String get zakatOffTitle => 'ዘካ አይከፍሉም';

  @override
  String get zakatOffBody =>
      'ስለዚህ ስለ ዘካ ምንም የሚከፈል ነገር አይታይም፤ የዘካ አስታዋሾችም የሉም። ምን ያህል እንደሚሆን በማንኛውም ጊዜ ማየት ይችላሉ፤ ማየት መልስዎን አይቀይርም።';

  @override
  String get zakatOffPeek => 'ምን ያህል እንደሚሆን ይመልከቱ';

  @override
  String get zakatPeekBanner => 'ለማየት ብቻ። ዘካ እንደማይከፍሉ ተናግረዋል።';

  @override
  String get zakatOptOutTitle => 'ዘካ መከታተል ይቁም?';

  @override
  String get zakatOptOutBody =>
      'ምንም እንደሚከፈል አይታይም፤ የዘካ አስታዋሾችም አይኖሩም። አሃዞችዎ ይቀመጣሉ፤ በማንኛውም ጊዜ እዚህ ማየት ይችላሉ።';

  @override
  String get zakatDue => 'የሚከፈል ዘካ';

  @override
  String zakatAboveNisab(String amount) {
    return 'ከኒሳብ በላይ፦ ከ$amount የተጣራ ሀብት 2.5%';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'ከኒሳብ በ$amount ያነሰ፤ ስለዚህ ዘካ አይከፈልም';
  }

  @override
  String get zakatNeedPrice => 'ኒሳብን ለማረጋገጥ የአንድ ግራም ዋጋ ያስገቡ';

  @override
  String get zakatPaidSoFar => 'በዚህ ዓመት የተከፈለ';

  @override
  String get zakatLeftToPay => 'የሚከፈል የቀረ';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'የዘካ ቀን $date፣ በ$days ቀናት ውስጥ',
      one: 'የዘካ ቀን ነገ፣ $date',
      zero: 'የዘካ ቀንዎ ዛሬ ነው',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate => 'ዓመቱን ለመከታተል እና አስታዋሽ ለማግኘት የዘካ ቀንዎን ያዘጋጁ';

  @override
  String get zakatPay => 'ዘካ ክፈል';

  @override
  String get zakatNisab => 'ኒሳብ';

  @override
  String get zakatBasisGold => 'ወርቅ';

  @override
  String get zakatBasisSilver => 'ብር (ማዕድን)';

  @override
  String get zakatBasisHint =>
      'ብር (ማዕድኑ) ዝቅተኛውን ኒሳብ ይሰጣል፤ ሀብትዎ በአብዛኛው ጥሬ ገንዘብ ሲሆን የበለጠ ጥንቁቅ ምርጫ ነው። የዛሬውን የአንድ ግራም የአካባቢ ዋጋ ያስገቡ።';

  @override
  String zakatPricePerGram(String metal) {
    return 'የአንድ ግራም ዋጋ ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams ግ በዚያ ዋጋ';
  }

  @override
  String get zakatGroupCash => 'ጥሬ ገንዘብ እና ባንክ';

  @override
  String get zakatGroupDeposits => 'የቁጠባ ተቀማጮች';

  @override
  String get zakatGroupInvestments => 'ኢንቨስትመንቶች';

  @override
  String get zakatGroupMetals => 'ወርቅ እና ብር';

  @override
  String get zakatGroupLent => 'ለሌሎች ያበደሩት ገንዘብ';

  @override
  String get zakatGroupOtherAssets => 'ሌሎች ንብረቶች';

  @override
  String get zakatGroupPaid => 'በዚህ ዓመት የተከፈለ ዘካ';

  @override
  String get zakatGroupManual => 'በእርስዎ የታከለ';

  @override
  String get zakatGroupBorrowed => 'ሲቀነስ፦ ያለብዎት ገንዘብ';

  @override
  String get zakatGroupCards => 'ሲቀነስ፦ የክሬዲት ካርድ ዕዳ';

  @override
  String get zakatOtherAssetsNote =>
      'የሚጠቀሙበት መሬት፣ ቤት ወይም መኪና ዘካ አይከፈልበትም። ለንግድ ከያዙት ብቻ ያብሩት።';

  @override
  String get zakatPaidNote => 'የዓመቱ ሀብት ከተቆጠረ በኋላ ከሂሳቦችዎ ስለወጣ ተመልሶ ተደምሯል።';

  @override
  String get zakatNoMetals =>
      'ምንም ወርቅ ወይም ብር አልተመዘገበም። እንደ ንብረት ያክሉት፣ ወይም ዋጋውን ከታች ያክሉ።';

  @override
  String get zakatAddAmount => 'መጠን አክል';

  @override
  String get zakatAmountLabel => 'ምንድን ነው?';

  @override
  String get zakatAmountHint => 'የንግድ ዕቃ፣ ቤት ያለ ጥሬ ገንዘብ…';

  @override
  String get zakatAmountDeduct => 'አሁን የሚከፈል ዕዳ ነው';

  @override
  String get zakatWealth => 'ዘካ የሚከፈልበት ሀብት';

  @override
  String get zakatDeductions => 'አሁን የሚከፈሉ ዕዳዎች';

  @override
  String get zakatNet => 'የተጣራ ሀብት';

  @override
  String get zakatRate => 'ከተጣራ ሀብት 2.5%';

  @override
  String get zakatYear => 'የዘካ ዓመት';

  @override
  String get zakatDate => 'የዘካ ቀን';

  @override
  String get zakatDateHint => 'የዘካ ዓመትዎ የሚጠናቀቅበት ቀን። በየጨረቃ ዓመቱ፣ በ354 ቀናት ይመጣል።';

  @override
  String get zakatRemind => 'አስታውሰኝ';

  @override
  String get zakatRemindHint => '3 ቀናት በፊት፣ እና በዕለቱ';

  @override
  String get zakatDisclaimer =>
      'ይህ ዘካን ለማስላት የሚረዳ መመሪያ ነው እንጂ ሃይማኖታዊ ፈትዋ አይደለም። ምሁራን በአንዳንድ ዝርዝሮች ይለያያሉ፤ ጥርጣሬ ሲኖርዎት የአካባቢዎን ዓሊም ይጠይቁ።';

  @override
  String get zakatPayNote => 'በዘካ ሥር እንደ ወጪ ይመዘገባል፤ ለዚህ ዓመትም ይቆጠራል።';

  @override
  String get zakatPayRecord => 'ክፍያ መዝግብ';

  @override
  String get zakatPaidSnack => 'ዘካ ተመዝግቧል';

  @override
  String get aiToolZakat => 'ዘካን በማስላት ላይ…';

  @override
  String get voiceButton => 'ግብይት በድምፅ ይናገሩ';

  @override
  String get voiceTitle => 'ይናገሩት';

  @override
  String get voiceUnlimited => 'ያልተገደበ';

  @override
  String get voiceTapToTalk => 'ክቡን ይንኩ እና ያወጡትን ይናገሩ';

  @override
  String get voiceListening => 'በማዳመጥ ላይ…';

  @override
  String get voiceStop => 'ማዳመጥ አቁም';

  @override
  String get voiceTypeInstead => 'ጻፍ';

  @override
  String get voiceSpeakInstead => 'ተናገር';

  @override
  String get voiceSend => 'ተጠናቋል';

  @override
  String get voiceTrySaying => 'እንዲህ ብለው ይሞክሩ';

  @override
  String get voiceExample1 => 'ምሳ 250፣ ባጃጅ 60';

  @override
  String get voiceExample2 => 'ደሞዜ ገባ፣ 45,000';

  @override
  String get voiceExample3 => 'የትናንቱ ሻይ 30 ነበር እንጂ 20 አይደለም';

  @override
  String get voiceExample4 => 'የዛሬውን ምሳ ሰርዝ';

  @override
  String get voiceTypeHint => 'ምሳ 250 እና ባጃጅ 60 ከbKash';

  @override
  String get voiceThinking => 'በማስላት ላይ…';

  @override
  String get voiceTryAgain => 'እንደገና';

  @override
  String get voiceSaving => 'በማስቀመጥ ላይ…';

  @override
  String get voiceEdit => 'አርትዕ';

  @override
  String get voiceNeedsYou => 'እርስዎን ይፈልጋል';

  @override
  String get voiceNew => 'አዲስ';

  @override
  String get voiceChange => 'ቀይር';

  @override
  String get voiceRemove => 'አስወግድ';

  @override
  String get voiceNeedsAmount => 'ምንም መጠን አልተነገረም። ይህን ለማከል ይሙሉት።';

  @override
  String get voiceAdjust => 'አስተካክል';

  @override
  String get voiceFillIn => 'ሙላ';

  @override
  String get voiceTime => 'ሰዓት';

  @override
  String get voiceUndo => 'ቀልብስ';

  @override
  String get voiceUndone => 'እንደነበረ ተመልሷል';

  @override
  String get voiceNoSpeech => 'አልሰማሁትም። እንደገና ይሞክሩ፣ ወይም ይጻፉት።';

  @override
  String get voiceNeedsConnection => 'ድምፅ ግንኙነት ያስፈልገዋል። በምትኩ መተየብ ይችላሉ።';

  @override
  String get voiceMicOff => 'የማይክሮፎን ፈቃድ ጠፍቷል። በቅንብሮች ውስጥ ይፍቀዱት፣ ወይም ይጻፉ።';

  @override
  String get voiceUnavailable => 'በዚህ ስልክ ላይ ድምፅ አይገኝም። መጻፍ ይችላሉ።';

  @override
  String get voiceSomethingWrong => 'የሆነ ችግር ተፈጥሯል። እንደገና ይሞክሩ።';

  @override
  String get voiceFabSetting => 'በዛሬ ገጽ ላይ ተንሳፋፊ ማይክ';

  @override
  String get amountHidden => 'የተደበቀ መጠን';

  @override
  String get privacyShowAmounts => 'መጠኖችን አሳይ';

  @override
  String get privacyHideAmounts => 'መጠኖችን ደብቅ';

  @override
  String get privacyAmounts => 'በማያ ገጹ ላይ ያሉ መጠኖች';

  @override
  String get privacyAmountsFooter =>
      'በአቅራቢያ ያሉ ሰዎች እንዳያነቧቸው ቀሪ ሂሳቦች እና ድምሮች ይደበዝዛሉ። ነጠላ ግብይቶች እንደሚታዩ ይቆያሉ። በዛሬ ገጽ ላይ ያለው ዓይንም ያሳያቸዋል ወይም ይደብቃቸዋል።';

  @override
  String get privacyHideTitle => 'ቀሪ ሂሳቦችን እና ድምሮችን ደብቅ';

  @override
  String get privacyHideSub => 'ለማሳየት እስኪመርጡ ድረስ አደብዝዛቸው';

  @override
  String get privacyTapTitle => 'የተደበቀ መጠንን ለማሳየት ይንኩት';

  @override
  String get privacyTapSub => 'አለበለዚያ የሚያሳያቸው በዛሬ ገጽ ላይ ያለው ዓይን ብቻ ነው';

  @override
  String get privacyStartTitle => 'መተግበሪያው ሲከፈት';

  @override
  String get privacyStartHidden => 'ተደብቆ';

  @override
  String get privacyStartHiddenSub => 'ሁልጊዜ ቀሪ ሂሳቦች እና ድምሮች ተደብቀው ይከፈት';

  @override
  String get privacyStartShown => 'ታይቶ';

  @override
  String get privacyStartShownSub => 'ሁልጊዜ ቀሪ ሂሳቦች እና ድምሮች እየታዩ ይከፈት';

  @override
  String get privacyStartRemember => 'እንደተውኩት';

  @override
  String get privacyStartRememberSub => 'ዓይኑ ለመጨረሻ ጊዜ በተተወበት ሁኔታ ይከፈት';

  @override
  String get privacyIntroTitle => 'አዲስ፦ ቀሪ ሂሳቦችዎን ይደብቁ';

  @override
  String get privacyIntroBody =>
      'በአቅራቢያ ያሉ ሰዎች እንዳያነቧቸው ቀሪ ሂሳቦች እና ድምሮች አሁን ተደብቀዋል። ለማሳየት ወይም ለመደበቅ በዛሬ ገጽ ላይ ያለውን ዓይን ይንኩ፤ መተግበሪያው እንዴት እንደተዉት ያስታውሳል። መተግበሪያው እንዴት እንደሚከፈት በቅንብሮች ውስጥ መምረጥ ይችላሉ።';

  @override
  String get privacyIntroOk => 'ገብቶኛል';

  @override
  String get privacyIntroSettings => 'በቅንብሮች ውስጥ ይምረጡ';

  @override
  String get ppTitle => 'የይለፍ ሐረግ ጥበቃ';

  @override
  String get ppRowOn => 'በርቷል';

  @override
  String get ppRowOff => 'ጠፍቷል';

  @override
  String get ppRowLocked => 'በዚህ ስልክ ላይ ተቆልፏል';

  @override
  String get ppIntro =>
      'ውሂብዎ በዚህ ስልክ ላይ እና በምትኬዎችዎ ውስጥ አስቀድሞ ተመስጥሯል። የይለፍ ሐረግ አንድ ተጨማሪ መቆለፊያ ያክላል፤ በዚህም የተመሳሰለ ውሂብዎን እና ምትኬዎችዎን መክፈት የሚችሉት እርስዎ ብቻ ይሆናሉ — እኛም እንኳ አንችልም።';

  @override
  String get ppWithoutTitle => 'የይለፍ ሐረግ ሳይኖር (አሁን ያለው ሁኔታ)';

  @override
  String get ppWithout1 => 'በዚህ ስልክ ላይ ያለው ሁሉ ተመስጥሯል።';

  @override
  String get ppWithout2 => 'ምትኬዎች እና የተመሳሰለ ውሂብ ከመለያዎ ጋር በተያያዘ ቁልፍ ተመስጥረዋል።';

  @override
  String get ppWithout3 => 'በአዲስ ስልክ ላይ ይግቡ፤ ምንም ማስታወስ ሳያስፈልግዎ ሁሉም ነገር ይመለሳል።';

  @override
  String get ppWithout4 =>
      'ያንን ቁልፍ የሚይዘው አገልጋያችን ነው፤ ስለዚህ በመርህ ደረጃ የተመሳሰለ ውሂብዎን ልንከፍት እንችላለን።';

  @override
  String get ppWithTitle => 'የይለፍ ሐረግ ሲኖር';

  @override
  String get ppWith1 =>
      'የተመሳሰለ ውሂብዎን እና ምትኬዎችዎን መክፈት የሚችሉት የይለፍ ሐረግዎ ወይም የመልሶ ማግኛ ኮድዎ ብቻ ናቸው።';

  @override
  String get ppWith2 =>
      'አገልጋያችን የሚያስቀምጠው የቁልፍዎን የተቆለፉ ቅጂዎች ብቻ ነው። እኛ ውሂብዎን ማንበብ አንችልም፤ አገልጋዮቻችንን ሰብሮ የሚገባ ማንኛውም ሰውም አይችልም።';

  @override
  String get ppWith3 =>
      'በአዲስ ስልክ ላይ፣ ወይም መተግበሪያውን እንደገና ከጫኑ በኋላ፣ የይለፍ ሐረግዎን አንድ ጊዜ ብቻ ይተይባሉ።';

  @override
  String get ppWith4 => 'ይህ ስልክ ልክ አሁን እንደሚሠራው መሥራቱን ይቀጥላል፤ ከመስመር ውጭም ቢሆን።';

  @override
  String get ppCatchTitle => 'ልብ ሊሉት የሚገባ';

  @override
  String get ppCatchBody =>
      'የይለፍ ሐረግዎን ከረሱ እና የመልሶ ማግኛ ኮድዎንም ካጡ፣ የተመሳሰለ ውሂብዎን ወይም ምትኬዎችዎን ማንም መመለስ አይችልም — እኛም ሆንን ሌላ ማንም። አስቀድሞ በዚህ ስልክ ላይ ያለው ግን እዚሁ መነበቡን ይቀጥላል።';

  @override
  String get ppAiNote =>
      'የAI ባህሪያት ምላሽ ሊሰጡዎት እንዲችሉ አሁንም የገንዘብ ሁኔታዎን ማጠቃለያ ይልካሉ። የይለፍ ሐረግ ይህንን አይለውጥም።';

  @override
  String get ppSetButton => 'የይለፍ ሐረግ አዘጋጅ';

  @override
  String get ppSetTitle => 'የይለፍ ሐረግ ይምረጡ';

  @override
  String get ppSetHint =>
      'ቢያንስ 10 ቁምፊዎችን ይጠቀሙ። እርስ በርስ የማይዛመዱ ጥቂት ቃላት ለማስታወስ ቀላል፣ ለመገመት ግን ከባድ ናቸው።';

  @override
  String get ppPassphraseLabel => 'የይለፍ ሐረግ';

  @override
  String get ppConfirmLabel => 'እንደገና ይተይቡት';

  @override
  String get ppTooShort => 'ቢያንስ 10 ቁምፊዎችን ይጠቀሙ።';

  @override
  String get ppMismatch => 'ሁለቱ የይለፍ ሐረጎች አይዛመዱም።';

  @override
  String get ppUnderstand =>
      'የይለፍ ሐረጌንም የመልሶ ማግኛ ኮዴንም ካጣሁ፣ የተመሳሰለ ውሂቤ እና ምትኬዎቼ መመለስ እንደማይችሉ ተረድቻለሁ።';

  @override
  String get ppTurnOn => 'ጥበቃን አብራ';

  @override
  String get ppWorking => 'ቁልፍዎን በመቆለፍ ላይ። ይህ ጥቂት ሰከንዶች ይወስዳል…';

  @override
  String get ppMaybeSaved =>
      'ግንኙነቱ ስለተቋረጠ አገልጋዩ ይህንን አስቀድሞ አስቀምጦት ሊሆን ይችላል። የመልሶ ማግኛ ኮድ እስኪያዩ ድረስ እንደገና ያድርጉት፣ ያንንም ያስቀምጡ።';

  @override
  String get ppRecoveryTitle => 'የመልሶ ማግኛ ኮድዎ';

  @override
  String get ppRecoveryBody =>
      'የይለፍ ሐረግዎን ከረሱ ወደ ውሂብዎ የሚያስገባው ብቸኛው ሌላ መንገድ ይህ ነው። ይጻፉት ወይም በይለፍ ቃል አስተዳዳሪ ውስጥ ያስቀምጡት — ከዚህ ስልክ ውጭ በሆነ ቦታ።';

  @override
  String get ppCopy => 'ቅዳ';

  @override
  String get ppCopied => 'የመልሶ ማግኛ ኮዱ ተቀድቷል';

  @override
  String get ppSavedIt => 'የመልሶ ማግኛ ኮዴን ደህንነቱ በተጠበቀ ቦታ አስቀምጫለሁ';

  @override
  String get ppDone => 'ተጠናቋል';

  @override
  String get ppOnTitle => 'ጥበቃው በርቷል';

  @override
  String get ppOnBody =>
      'የተመሳሰለ ውሂብዎን እና ምትኬዎችዎን መክፈት የሚችሉት የይለፍ ሐረግዎ ወይም የመልሶ ማግኛ ኮድዎ ብቻ ናቸው።';

  @override
  String get ppChange => 'የይለፍ ሐረግ ቀይር';

  @override
  String get ppNewCode => 'አዲስ የመልሶ ማግኛ ኮድ አግኝ';

  @override
  String get ppNewCodeWarn =>
      'የአሁኑ የመልሶ ማግኛ ኮድዎ መሥራት ያቆማል። አዲሱን ማስቀመጥዎን ያረጋግጡ።';

  @override
  String get ppTurnOff => 'ጥበቃን አጥፋ';

  @override
  String get ppTurnOffBody =>
      'እንደቀድሞው አገልጋያችን ቁልፍዎን እንደገና ይይዛል። ውሂብዎ እንደተመሰጠረ ይቆያል፤ ነገር ግን በመርህ ደረጃ የተመሳሰለ ውሂብዎን ልንከፍት እንችላለን።';

  @override
  String get ppLockedTitle => 'ውሂብዎን ይክፈቱ';

  @override
  String get ppLockedBody =>
      'ውሂብዎ በይለፍ ሐረግ የተጠበቀ ነው። የተመሳሰለ ውሂብዎን እና ምትኬዎችዎን ለመክፈት በዚህ ስልክ ላይ አንድ ጊዜ ያስገቡት።';

  @override
  String get ppUnlock => 'ክፈት';

  @override
  String get ppUseRecovery => 'በምትኩ የመልሶ ማግኛ ኮዴን ልጠቀም';

  @override
  String get ppUsePassphrase => 'በምትኩ የይለፍ ሐረጌን ልጠቀም';

  @override
  String get ppRecoveryLabel => 'የመልሶ ማግኛ ኮድ';

  @override
  String get ppWrongPassphrase => 'ያ የይለፍ ሐረግ ትክክል አይደለም።';

  @override
  String get ppWrongRecovery => 'ያ የመልሶ ማግኛ ኮድ ትክክል አይደለም።';

  @override
  String get ppUnlocked => 'በዚህ ስልክ ላይ ተከፍቷል';

  @override
  String get ppChanged => 'የይለፍ ሐረጉ ተቀይሯል';

  @override
  String get ppTurnedOn => 'ጥበቃው በርቷል';

  @override
  String get ppTurnedOff => 'ጥበቃው ጠፍቷል';

  @override
  String get encIntroTitle => 'ውሂብዎ አሁን ተመስጥሯል';

  @override
  String get encIntroBody =>
      'በዚህ ስልክ ላይ ያለው ሁሉ ተመስጥሮ ይቀመጣል፤ ምትኬዎችዎና የተመሳሰለው ውሂብዎም ከስልኩ ከመውጣታቸው በፊት ይመሰጠራሉ። ምንም ማድረግ አያስፈልግዎትም።';

  @override
  String get encIntroPassphrase =>
      'ተጨማሪ ቁልፍ ይፈልጋሉ? የይለፍ ሐረግ ያዘጋጁ፤ ከዚያ የተመሳሰለ ውሂብና ምትኬዎችን እርስዎ ብቻ ይከፍታሉ — እኛም አንችልም። አማራጭ ነው፤ የይለፍ ሐረጉንና የመልሶ ማግኛ ኮዱን ሁለቱንም ካጡ ውሂቡ ሊመለስ አይችልም።';

  @override
  String get encIntroSetUp => 'የይለፍ ሐረግ ያዘጋጁ';

  @override
  String get encIntroNotNow => 'አሁን አይደለም';

  @override
  String get voiceFabSettingSub => 'ግብይትን ለመናገር በዛሬ ገጽ ላይ የሚንሳፈፍ ማይክ';

  @override
  String get voiceFabAskTitle => 'በዛሬ ገጽዎ ላይ ማይክ ይጨመር?';

  @override
  String get voiceFabAskBody =>
      'ይንኩት እና ያወጡትን ይናገሩ፣ ለምሳሌ \"ምሳ 250 እና ባጃጅ 60\"። ከመቀመጡ በፊት ሁሉንም ያረጋግጣሉ። ወደፈለጉት ቦታ ይጎትቱት።';

  @override
  String get voiceFabAskYes => 'አዎ፣ ማይኩን አክል';

  @override
  String get voiceFabAskNo => 'አሁን አይደለም';

  @override
  String get voiceFabAskLater => 'በተጨማሪ ውስጥ በማንኛውም ጊዜ ማብራት ወይም ማጥፋት ይችላሉ።';

  @override
  String get voiceFabHideTitle => 'ተንሳፋፊው ማይክ ይደበቅ?';

  @override
  String get voiceFabHideBody =>
      'በዛሬ ገጽ አናት ላይ ያለው ማይክ ይቆያል። ይህን በተጨማሪ ውስጥ መልሰው ማምጣት ይችላሉ።';

  @override
  String get voiceFabHide => 'ደብቀው';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ለማስቀመጥ ዝግጁ',
      one: '1 ለማስቀመጥ ዝግጁ',
      zero: 'ምንም ዝግጁ የለም',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count አስቀምጥ',
      one: '1 አስቀምጥ',
      zero: 'ምንም አልተመረጠም',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች ተቀምጠዋል',
      one: '1 ግብይት ተቀምጧል',
    );
    return '$_temp0';
  }

  @override
  String get ppNeedsConnection =>
      'የይለፍ ሐረግ ቅንብሮች የበይነመረብ ግንኙነት ያስፈልጋቸዋል። ከአውታረ መረብ ጋር ተገናኝተው ይህንን እንደገና ይክፈቱ።';

  @override
  String get offlineToast =>
      'ከመስመር ውጭ ነዎት። የሚያክሉት ሁሉ በዚህ ስልክ ላይ ይቀመጣል፣ ተመልሰው መስመር ላይ ሲሆኑም ይመሳሰላል።';

  @override
  String get backupLockedTitle => 'ይህን ምትኬ ይክፈቱ';

  @override
  String get backupLockedBody =>
      'ይህ ምትኬ በይለፍ ሐረግ የተጠበቀ ነው። ለመክፈት እሱን ወይም የመልሶ ማግኛ ኮድዎን ያስገቡ። ይህ ያለ በይነመረብ ግንኙነት ይሰራል።';

  @override
  String get settingsSupportDescribeFirst => 'እባክዎ መጀመሪያ ችግርዎን ይግለጹ';

  @override
  String get settingsSupportSent => 'እናመሰግናለን! መልእክትዎ ተልኳል።';

  @override
  String get settingsSupportSendFailed =>
      'አሁን መላክ አልተቻለም። እባክዎ እንደገና ይሞክሩ ወይም በቀጥታ ኢሜይል ይላኩልን።';

  @override
  String get settingsSupportSubjectHint => 'ስለ ምንድን ነው?';

  @override
  String get settingsSupportMessageHint => 'ጥያቄዎን፣ ችግርዎን ወይም አስተያየትዎን ይግለጹ…';

  @override
  String get settingsSupportHeroBody =>
      'ጥያቄዎች፣ ስህተቶች ወይም አስተያየቶች — ይላኩልን፣ እኛም መልስ እንሰጥዎታለን።';

  @override
  String get settingsSupportTipDescription => 'የችግርዎ ግልጽ መግለጫ';

  @override
  String get settingsSupportTipSteps =>
      'ችግሩን እንደገና ለመፍጠር የሚረዱ ደረጃዎች (ስህተት ከሆነ)';

  @override
  String get settingsSupportTipDevice => 'የመሣሪያዎ ሞዴል እና የAndroid ስሪት';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'ኢሜይል ይመርጣሉ? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'ኢሜይሉ ወደ ቅንጥብ ሰሌዳ ተቀድቷል';

  @override
  String get settingsAboutTagline => 'የግል ፋይናንስ አጋርዎ';

  @override
  String settingsAboutVersion(String version) {
    return 'ስሪት፦ $version';
  }

  @override
  String get settingsAboutDescription =>
      'በግላዊነት እና በሚያምር UI/UX ላይ\nያተኮረ የግል ፋይናንስ መተግበሪያ።';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'መሠረታዊ ምንዛሪ፦ $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'ለመጨረሻ ጊዜ የዘመነው፦ $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'ተመን አርትዕ፦ $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'የአሁኑ የAPI ተመን፦ $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return 'ከ$count ደቂቃ በፊት';
  }

  @override
  String settingsHoursAgo(int count) {
    return 'ከ$count ሰዓት በፊት';
  }

  @override
  String settingsDaysAgo(int count) {
    return 'ከ$count ቀን በፊት';
  }

  @override
  String get settingsExportSectionDateRange => 'የቀን ክልል';

  @override
  String get settingsExportSectionFormat => 'ቅርጸት';

  @override
  String get settingsExportSectionInclude => 'የሚካተቱ';

  @override
  String get settingsExportAllTime => 'ሁሉም ጊዜ';

  @override
  String get settingsExportThisMonth => 'በዚህ ወር';

  @override
  String get settingsExportLastMonth => 'ያለፈው ወር';

  @override
  String get settingsExportLast3Months => 'ያለፉት 3 ወራት';

  @override
  String get settingsExportThisYear => 'በዚህ ዓመት';

  @override
  String get settingsExportPdfPremiumBody =>
      'CSV መላክ ነፃ ነው — ውሂብዎ ሁልጊዜ የእርስዎ ነው። ማጠቃለያዎችን እና የምድብ እና የቦርሳ ዝርዝሮችን የያዘው የተቀናጀ PDF ሪፖርት የPremium ባህሪ ነው።';

  @override
  String settingsExportButton(String format) {
    return '$format ላክ';
  }

  @override
  String settingsExportFailed(String error) {
    return 'መላክ አልተሳካም፦ $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - የተላከ ውሂብ';

  @override
  String settingsExportedCount(int count) {
    return '$count ግብይቶች ተልከዋል';
  }

  @override
  String get settingsExportPdfShareSubject => 'The Accountant - የፋይናንስ ሪፖርት';

  @override
  String settingsExportPdfGenerated(int count) {
    return '$count ግብይቶችን የያዘ PDF ሪፖርት ተዘጋጅቷል';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'ለሺዎች ኮማ';

  @override
  String get settingsNumberFormatDotThousands => 'ለሺዎች ነጥብ';

  @override
  String get settingsNumberFormatSpaceThousands => 'ለሺዎች ክፍተት';

  @override
  String get settingsNumberFormatNoSeparator => 'መለያ ምልክት የለም';

  @override
  String get settingsAutoLockImmediately => 'ወዲያውኑ';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ደቂቃዎች',
      one: '1 ደቂቃ',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'በጭራሽ';

  @override
  String get settingsBiometricUnavailable => 'በዚህ መሣሪያ ላይ የባዮሜትሪክ ማረጋገጫ አይገኝም';

  @override
  String get settingsSetPassword => 'የይለፍ ቃል አዘጋጅ';

  @override
  String get settingsChangePassword => 'የይለፍ ቃል ቀይር';

  @override
  String get settingsAddPasswordSubtitle => 'ለመለያዎ የይለፍ ቃል ያክሉ';

  @override
  String get settingsPasswordChanged => 'የይለፍ ቃሉ በተሳካ ሁኔታ ተቀይሯል';

  @override
  String get settingsPasswordSet => 'የይለፍ ቃሉ በተሳካ ሁኔታ ተዘጋጅቷል';

  @override
  String get settingsClearCacheBody =>
      'ይህ የተሸጎጠ ውሂብን ያጸዳል፤ መተግበሪያው በሚቀጥለው ሲከፈት እንደገና ያመሳስላል። ውሂብዎ አይሰረዝም።';

  @override
  String get settingsClearingCache => 'መሸጎጫ በማጽዳት ላይ...';

  @override
  String get settingsCacheCleared => 'መሸጎጫው ጸድቷል፣ ማመሳሰልም ተጀምሯል';

  @override
  String get settingsClearCacheFailed => 'መሸጎጫውን ማጽዳት አልተቻለም';

  @override
  String get settingsClearAllDataBody =>
      'ይህ ሁሉንም ግብይቶችዎን፣ በጀቶችዎን፣ ቦርሳዎችዎን፣ ምድቦችዎን እና ቅንብሮችዎን እስከመጨረሻው ይሰርዛል። ይህ ሊቀለበስ አይችልም!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'ሁሉም የፋይናንስ ውሂብዎ እስከመጨረሻው ይጠፋል።';

  @override
  String get settingsClearingAllData => 'ሁሉንም ውሂብ በማጽዳት ላይ...';

  @override
  String get settingsAllDataCleared => 'ሁሉም ውሂብ በተሳካ ሁኔታ ጸድቷል';

  @override
  String settingsClearDataFailed(String error) {
    return 'ውሂቡን ማጽዳት አልተቻለም፦ $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'መለያ እንዲሰረዝ ለመጠየቅ ወደ አንድ ቅጽ ይወሰዳሉ። ሂደቱ ለመጠናቀቅ ጥቂት ቀናት ይወስዳል። ከተጠናቀቀ በኋላ በአገልጋዩ ላይ ያለው ሁሉም ውሂብ እስከመጨረሻው ይሰረዛል።';

  @override
  String get settingsLockAuthFailed => 'ማረጋገጥ አልተሳካም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get settingsLockError => 'ስህተት ተፈጥሯል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get settingsLockAuthenticating => 'በማረጋገጥ ላይ...';

  @override
  String get settingsProfileNameEmpty => 'ስም ባዶ ሊሆን አይችልም';

  @override
  String get settingsProfileUpdated => 'መገለጫው በተሳካ ሁኔታ ዘምኗል';

  @override
  String get settingsProfileUpdateFailed => 'መገለጫውን ማዘመን አልተቻለም';

  @override
  String get settingsProfileSaveChanges => 'ለውጦችን አስቀምጥ';

  @override
  String get settingsProfileSaved => 'ተቀምጧል';

  @override
  String get settingsProfilePhotoSoon => 'ፎቶ መስቀል በቅርቡ ይመጣል';

  @override
  String get settingsProfileAccountInformation => 'የመለያ መረጃ';

  @override
  String get settingsProfileMemberSince => 'አባል የሆኑበት';

  @override
  String get settingsProfileUnknown => 'ያልታወቀ';

  @override
  String get settingsProfileFree => 'ነፃ';

  @override
  String get settingsProfileUserId => 'የተጠቃሚ መታወቂያ';

  @override
  String get settingsProfileUserIdCopied => 'የተጠቃሚ መታወቂያ ተቀድቷል';

  @override
  String get settingsPremiumMonthly => 'Premium ወርሃዊ';

  @override
  String get settingsPremiumYearly => 'Premium ዓመታዊ';

  @override
  String get settingsPremiumLifetime => 'Premium የዕድሜ ልክ';

  @override
  String get settingsUnsavedChangesBody =>
      'ያልተቀመጡ ለውጦች አሉዎት። እርግጠኛ ነዎት መውጣት ይፈልጋሉ?';

  @override
  String settingsShareAppText(String url) {
    return 'The Accountantን ይመልከቱ - የሚያምር የግል ፋይናንስ መተግበሪያ!\n\n$url';
  }

  @override
  String get settingsShareAppSubject => 'The Accountant - የግል ፋይናንስ መተግበሪያ';

  @override
  String get settingsCloudSyncGateBody =>
      'የፋይናንስ ውሂብዎን በሁሉም መሣሪያዎችዎ ላይ ተመሳስሎ ያቆዩ። ውሂብዎን ዳግመኛ አያጡም።';

  @override
  String settingsSyncPushed(int count) {
    return '$count ተልከዋል';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$count መጥተዋል';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count ግጭቶች';
  }

  @override
  String get settingsSyncNowSubtitle => 'ሁሉንም ለውጦች ላክ እና አምጣ';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'ማመሳሰል ተጠናቋል — $pushed ተልከዋል፣ $pulled መጥተዋል';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'ማመሳሰል አልተጠናቀቀም — $count መዝገብ(ቦች) ሊቀመጡ አልቻሉም፤ እንደገና ይሞከራሉ። $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'ማመሳሰል አልተሳካም፦ $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle => 'የዚህን መሣሪያ ውሂብ በደመና ውሂብዎ ይተኩ';

  @override
  String get settingsRestoreFromCloudBody =>
      'ይህ በዚህ መሣሪያ ላይ ያለውን ሁሉንም ውሂብ አጥፍቶ በደመና ውሂብዎ ይተካዋል። በዚህ መሣሪያ ላይ ገና ያልተመሳሰሉ ለውጦች ይጠፋሉ። ይህ ሊቀለበስ አይችልም።';

  @override
  String settingsRestoredFromCloud(int count) {
    return '$count ንጥሎች ከደመና ተመልሰዋል';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'መመለሱ ተሰርዟል — በስልኩ ላይ ያለው ውሂብዎ አልተቀየረም። $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'መመለስ አልተሳካም፦ $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'ውሂብዎ በየ15 ደቂቃው እና መተግበሪያውን ሲከፍቱ በራስ-ሰር ይመሳሰላል። መጠኖች፣ ስሞች እና ማስታወሻዎች ከመመሳሰላቸው በፊት በዚህ ስልክ ላይ ይመሰጠራሉ፤ ስለዚህ አገልጋያችን ሊያነባቸው አይችልም።';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'በ$seconds ሰከንድ ተጠናቋል';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'በ$minutes ደቂቃ $seconds ሰከንድ ተጠናቋል';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'ይህ የእርስዎ “$name” ምድብ ነው?';
  }

  @override
  String get settingsReconcileSavedPending => 'ተቀምጧል። በሚቀጥለው ጊዜ ሲያመሳስሉ ይተገበራል።';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'መለያዎ “$name” የሚባሉ $count ምድቦች አስቀድሞ አሉት። ከእነሱ አንዱን እንደ አብሮ የተሠራ ምድብ እንጠቀም ወይስ ለየብቻ እናቆየው ይንገሩን። እስኪመርጡ ድረስ ምንም አይቀየርም።',
      one:
          'መለያዎ “$name” የሚባል ምድብ አስቀድሞ አለው። እንደ አብሮ የተሠራ ምድብ እንጠቀምበት ወይስ ለየብቻ እናቆየው ይንገሩን። እስኪመርጡ ድረስ ምንም አይቀየርም።',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine => 'አይ — የእኔን አቆይና ለየብቻ ሌላ አክል';

  @override
  String get settingsReconcileNoneOfThese => 'ከእነዚህ አንዱም አይደለም — ለየብቻ ሌላ አክል';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ያሉት “$name” ምድቦችዎ ከሁሉም ግብይቶቻቸው ጋር እንዳሉ ይቆያሉ። ከጎናቸው አዲስ አብሮ የተሠራ “$name” ይታከላል።',
      one:
          'ያለው “$name” ምድብዎ ከሁሉም ግብይቶቹ ጋር እንዳለ ይቆያል። ከጎኑ አዲስ አብሮ የተሠራ “$name” ይታከላል።',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'ለየብቻ አቆይ';

  @override
  String settingsReconcileTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች',
      one: '1 ግብይት',
      zero: 'ምንም ግብይት የለም',
    );
    return '$_temp0';
  }

  @override
  String settingsReconcileUseTitle(String name) {
    return '“$name” ይጠቀሙ?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'አብሮ የተሠራው “$name” ምድብ ይሆናል፤ ሁሉም $count ግብይቶቹ ከንዑስ ምድቦቹ ጋር ይቆያሉ። ምንም አይሰረዝም።',
      zero:
          'አብሮ የተሠራው “$name” ምድብ ይሆናል፤ በሥሩ የተመዘገበው ሁሉ ከንዑስ ምድቦቹ ጋር ይቆያል። ምንም አይሰረዝም።',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'ይህንን ተጠቀም';

  @override
  String settingsReconcileWillUse(String name) {
    return '“$name” ጥቅም ላይ ይውላል።';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'ለየብቻ “$name” ይታከላል።';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'የአሁኑን የይለፍ ቃልዎን ያስገቡ እና አዲስ ይምረጡ';

  @override
  String get settingsSetPasswordSubtitle => 'ለተጨማሪ ደህንነት ለመለያዎ የይለፍ ቃል ያክሉ';

  @override
  String get settingsEnterCurrentPassword => 'እባክዎ የአሁኑን የይለፍ ቃልዎን ያስገቡ';

  @override
  String get settingsEnterNewPassword => 'እባክዎ አዲስ የይለፍ ቃል ያስገቡ';

  @override
  String get settingsPasswordMinLength => 'የይለፍ ቃል ቢያንስ 8 ቁምፊዎች መሆን አለበት';

  @override
  String get settingsConfirmYourPassword => 'እባክዎ የይለፍ ቃልዎን ያረጋግጡ';

  @override
  String get settingsPasswordsDoNotMatch => 'የይለፍ ቃሎቹ አይዛመዱም';

  @override
  String get settingsPleaseWait => 'እባክዎ ይጠብቁ...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'ለማረጋገጥ “$word” ብለው ይተይቡ';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return 'ከበጀቱ $percent%';
  }

  @override
  String get authTooManyAttempts =>
      'በጣም ብዙ ሙከራዎች። እባክዎ አንድ ደቂቃ ጠብቀው እንደገና ይሞክሩ።';

  @override
  String get authServerDown =>
      'አገልጋዮቻችንን ማግኘት አልቻልንም። ችግሩ በእኛ በኩል ነው — እባክዎ ከጥቂት ደቂቃዎች በኋላ እንደገና ይሞክሩ።';

  @override
  String get authInitFailed => 'ማረጋገጫን ማስጀመር አልተቻለም';

  @override
  String get authSignInError => 'በመግባት ላይ ሳለ ስህተት ተፈጥሯል';

  @override
  String get authSignUpError => 'በመመዝገብ ላይ ሳለ ስህተት ተፈጥሯል';

  @override
  String get authGoogleCancelled => 'በGoogle መግባት ተሰርዟል ወይም አልተሳካም';

  @override
  String get authFirebaseTokenFailed => 'የFirebase ID ቶከን ማግኘት አልተቻለም';

  @override
  String get authGoogleSignInError => 'በGoogle በመግባት ላይ ሳለ ስህተት ተፈጥሯል';

  @override
  String get authAccountExistsDifferentCredential =>
      'በዚሁ ኢሜይል አድራሻ ግን በተለየ የመግቢያ መረጃ የተከፈተ መለያ አስቀድሞ አለ።';

  @override
  String get authInvalidCredential =>
      'የቀረበው የመግቢያ መረጃ የተበላሸ ነው ወይም ጊዜው አልፎበታል።';

  @override
  String get authGoogleDisabled => 'በGoogle መግባት ተሰናክሏል።';

  @override
  String get authUserDisabled => 'ይህ የተጠቃሚ መለያ ተሰናክሏል።';

  @override
  String get authAppleSignInError => 'በApple በመግባት ላይ ሳለ ስህተት ተፈጥሯል';

  @override
  String get authAppleDisabled => 'በApple መግባት ተሰናክሏል።';

  @override
  String get authNoPendingLink => 'ለማገናኘት የሚጠብቅ መለያ የለም';

  @override
  String get authLinkFailed => 'መለያውን ማገናኘት አልተቻለም';

  @override
  String get authIncorrectPassword => 'የይለፍ ቃሉ ትክክል አይደለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get authSignOutError => 'በመውጣት ላይ ሳለ ስህተት ተፈጥሯል';

  @override
  String get authLinkSubtitle =>
      'በዚህ ኢሜይል የተከፈተ መለያ አስቀድሞ አለ። የGoogle መለያዎን ለማገናኘት የይለፍ ቃልዎን ያስገቡ።';

  @override
  String get authEnterYourPasswordHint => 'የይለፍ ቃልዎን ያስገቡ';

  @override
  String get authEnterYourPassword => 'እባክዎ የይለፍ ቃልዎን ያስገቡ';

  @override
  String get authLinkInfo => 'ካገናኙ በኋላ በኢሜይል/የይለፍ ቃል ወይም በGoogle መግባት ይችላሉ።';

  @override
  String get authEnterYourEmail => 'እባክዎ ኢሜይልዎን ያስገቡ';

  @override
  String get authEnterValidEmail => 'እባክዎ ትክክለኛ ኢሜይል ያስገቡ';

  @override
  String get authPasswordMin6 => 'የይለፍ ቃል ቢያንስ 6 ቁምፊዎች መሆን አለበት';

  @override
  String get authNoAccountPrompt => 'መለያ የለዎትም? ';

  @override
  String get authForgotPasswordTitle => 'የይለፍ ቃል ረሱ';

  @override
  String get authCheckYourEmail => 'ኢሜይልዎን ይመልከቱ';

  @override
  String get authForgotPasswordSubtitle =>
      'ኢሜይልዎን ያስገቡ፤ የይለፍ ቃልዎን ዳግም ለማስጀመር ኮድ እንልክልዎታለን።';

  @override
  String authCodeSentSubtitle(String email) {
    return 'ወደ $email ባለ 6 አሃዝ ኮድ ልከናል። ከአዲሱ የይለፍ ቃልዎ ጋር ከታች ያስገቡት።';
  }

  @override
  String get authEnterYourEmailHint => 'ኢሜይልዎን ያስገቡ';

  @override
  String get authSixDigitCodeHint => 'ባለ 6 አሃዝ ኮድ';

  @override
  String get authEnterTheCode => 'እባክዎ ኮዱን ያስገቡ';

  @override
  String get authCodeIsSixDigits => 'ኮዱ 6 አሃዝ ነው';

  @override
  String get authCreateNewPasswordHint => 'አዲስ የይለፍ ቃል ይፍጠሩ';

  @override
  String get authReenterNewPasswordHint => 'አዲሱን የይለፍ ቃልዎን እንደገና ያስገቡ';

  @override
  String get authEnterYourNameHint => 'ስምዎን ያስገቡ';

  @override
  String get authEnterFullName => 'እባክዎ ሙሉ ስምዎን ያስገቡ';

  @override
  String get authNameMin2 => 'ስም ቢያንስ 2 ቁምፊዎች መሆን አለበት';

  @override
  String get authCreatePasswordHint => 'የይለፍ ቃል ይፍጠሩ';

  @override
  String get authPasswordComplexity => 'ትልቅ ፊደል፣ ትንሽ ፊደል እና ቁጥር መያዝ አለበት';

  @override
  String get authReenterPasswordHint => 'የይለፍ ቃልዎን እንደገና ያስገቡ';

  @override
  String get authStrengthWeak => 'ደካማ';

  @override
  String get authStrengthFair => 'መካከለኛ';

  @override
  String get authStrengthGood => 'ጥሩ';

  @override
  String get authStrengthStrong => 'ጠንካራ';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'በ$terms እና በ$privacy እስማማለሁ';
  }

  @override
  String get authDefaultUserName => 'ተጠቃሚ';

  @override
  String authMemberSince(String date) {
    return 'ከ$date ጀምሮ አባል';
  }

  @override
  String get authFieldRequired => 'ይህ መስክ ያስፈልጋል';

  @override
  String authSignOutFailed(String error) {
    return 'መውጣት አልተቻለም፦ $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'ምስል መምረጥ አልተቻለም፦ $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'መገለጫውን ማዘመን አልተቻለም፦ $error';
  }

  @override
  String get premiumSaveAbout44 => '~44% ይቆጥቡ';

  @override
  String get premiumBestValue => 'ምርጥ ዋጋ';

  @override
  String get premiumIapUnavailable => 'IAP አይገኝም';

  @override
  String get premiumProductNotFound => 'ምርቱ አልተገኘም';

  @override
  String get premiumPlanUnavailable => 'ይህ ዕቅድ አሁን በመለያዎ ላይ አይገኝም';

  @override
  String get premiumRestoreFailed => 'ግዢዎችን መመለስ አልተቻለም';

  @override
  String get premiumPurchaseFailed => 'ግዢው አልተሳካም';

  @override
  String get premiumVerificationFailed => 'ማረጋገጫው አልተሳካም';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ቀናት',
      one: '1 ቀን',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ሳምንታት',
      one: '1 ሳምንት',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ወራት',
      one: '1 ወር',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ዓመታት',
      one: '1 ዓመት',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'ከ$limit ነፃ $items ውስጥ $countቱን ተጠቅመዋል።';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'ገደብ ለሌላቸው $items እና ለሌሎችም ወደ Premium ያሻሽሉ!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'የነፃው ዕቅድ ገደብ የሆነውን $limit $items ደርሰዋል። ገደብ ለሌላቸው $items ወደ Premium ያሻሽሉ።';
  }

  @override
  String get premiumLimitWallets => 'ቦርሳዎች';

  @override
  String get premiumLimitCategories => 'የራስዎ ምድቦች';

  @override
  String get premiumLimitBudgets => 'ንቁ በጀቶች';

  @override
  String get premiumLimitObjectives => 'ንቁ ዓላማዎች';

  @override
  String get premiumLimitPaymentMethods => 'የመክፈያ ዘዴዎች';

  @override
  String get backupErrNotJson => 'ይህ ፋይል ምትኬ አይደለም — እንደ JSON ሊነበብ አልቻለም።';

  @override
  String get backupErrNotOurs => 'ይህ ፋይል የThe Accountant ምትኬ አይደለም።';

  @override
  String get backupErrNewerVersion =>
      'ይህ ምትኬ የተሠራው በአዲስ የመተግበሪያው ስሪት ነው። The Accountantን አዘምነው እንደገና ይሞክሩ።';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'ይህ ምትኬ ይህ ስሪት ሊያነበው ከሚችለው በላይ የቆየ የመተግበሪያው ስሪት ነው (የውሂብ ጎታ $version፣ የሚደገፈው በጣም የቆየ $oldest)።';
  }

  @override
  String get backupErrNoData => 'ይህ ምትኬ ምንም ውሂብ የለውም።';

  @override
  String backupErrSectionDamaged(String section) {
    return 'የዚህ ምትኬ “$section” ክፍል ተበላሽቷል።';
  }

  @override
  String get backupErrNoHeader => 'ይህ ምትኬ ምን እንደሆነ የሚገልጸው ራስጌ ይጎድለዋል።';

  @override
  String get backupErrNoSchemaVersion =>
      'ይህ ምትኬ ከየትኛው የውሂብ ጎታ ስሪት እንደተወሰደ አይገልጽም፤ ስለዚህ በደህና ሊመለስ አይችልም።';

  @override
  String get backupErrNoDate => 'ይህ ምትኬ መቼ እንደተወሰደ አይገልጽም።';

  @override
  String get backupErrDamaged => 'ይህ የምትኬ ፋይል ተበላሽቷል።';

  @override
  String get backupErrWrongKey =>
      'ይህ ምትኬ የሌላ መለያ ነው፣ ወይም ፋይሉ ተቀይሯል። ለመመለስ በሠራው መለያ ይግቡ።';

  @override
  String get backupErrNoPassphraseLock => 'ይህ ምትኬ በይለፍ ሐረግ ሊከፈት አይችልም።';

  @override
  String get backupErrNeedsSecret =>
      'ይህ ምትኬ በይለፍ ሐረግ የተጠበቀ ነው። ለመመለስ የይለፍ ሐረጉን ወይም የመልሶ ማግኛ ኮዱን ያስገቡ።';

  @override
  String get backupErrWrongSecret =>
      'ያ የይለፍ ሐረግ ወይም የመልሶ ማግኛ ኮድ ይህንን ምትኬ አይከፍትም።';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'ይህ ምትኬ የተሠራው በአዲስ የመተግበሪያው ስሪት ነው (የውሂብ ጎታ $version፣ ይህ ስሪት እስከ $supported ድረስ ያነባል)። The Accountantን አዘምነው እንደገና ይሞክሩ።';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Driveን ማግኘት አልተቻለም፦ $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant Google Driveን እንዲጠቀም ገና አልተፈቀደለትም።';

  @override
  String get backupDriveNoFolder =>
      'Google Drive ምትኬዎችን የሚያስቀምጥበት አቃፊ መፍጠር አልፈቀደም።';

  @override
  String get backupDriveNoFileId =>
      'Google Drive ምትኬውን ተቀብሏል፤ ነገር ግን የት እንዳስቀመጠው አልገለጸም።';

  @override
  String get backupDriveTimeout =>
      'Google Drive ለመመለስ በጣም እየዘገየ ነው። ቆይተው እንደገና ይሞክሩ።';

  @override
  String get backupDriveOffline =>
      'ከGoogle Drive ጋር ግንኙነት የለም። መስመር ላይ ሲሆኑ እንደገና ይሞክሩ።';

  @override
  String get backupDriveDenied =>
      'Google Drive ጥያቄውን አልተቀበለም። እንደገና ፈቃድ ሰጥተው ይሞክሩ።';

  @override
  String get backupDriveFileGone => 'ያ ምትኬ ከአሁን በኋላ በGoogle Drive ውስጥ የለም።';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive $status የሚል ምላሽ ሰጥቷል። $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'ትንሽ ቆይተው እንደገና ይሞክሩ።';

  @override
  String backupTakeFailed(String error) {
    return 'ምትኬውን መውሰድ አልተቻለም፦ $error';
  }

  @override
  String get backupUnrestorableNewer => 'በአዲስ የመተግበሪያው ስሪት የተሠራ።';

  @override
  String get backupUnrestorableOlder => 'ይህ የመተግበሪያው ስሪት ሊያነበው ከሚችለው በላይ የቆየ።';

  @override
  String get backupKeyUnusable =>
      'አገልጋዩ ጥቅም ላይ ሊውል የማይችል የምስጠራ ቁልፍ ልኳል። ቆይተው እንደገና ይሞክሩ።';

  @override
  String get backupKeyNeedsSignIn =>
      'ምትኬ ለመሥራት ወይም ለመመለስ ይግቡ — ምትኬዎች በመለያዎ ይመሰጠራሉ።';

  @override
  String get backupKeyNeedsInternet =>
      'ውሂብዎ እንዲመሰጠር አንድ ጊዜ ከበይነመረብ ጋር ይገናኙ፣ ከዚያ እንደገና ይሞክሩ።';

  @override
  String get backupKeyLocked =>
      'ውሂብዎ በይለፍ ሐረግ የተጠበቀ ነው። መጀመሪያ በዚህ መሣሪያ ላይ ይክፈቱት።';

  @override
  String get backupFrequencyManual => 'ስጠይቅ ብቻ';

  @override
  String get backupFrequencyDaily => 'በየቀኑ';

  @override
  String get backupFrequencyWeekly => 'በየሳምንቱ';

  @override
  String get backupFrequencyMonthly => 'በየወሩ';

  @override
  String get backupIntro =>
      'ምትኬ በዚህ መሣሪያ ላይ ያለውን ሁሉ — እያንዳንዱን ግብይት፣ ሂሳብ፣ በጀት እና ግብ — የያዘ አንድ ፋይል ነው። አንዱን ደህንነቱ በተጠበቀ ቦታ ያስቀምጡ፤ እዚህ ያለ ምንም ነገር ለዘለቄታው አይጠፋም።';

  @override
  String get backupSectionOnDevice => 'በዚህ መሣሪያ ላይ';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'በDRIVE ውስጥ ያሉ ምትኬዎች';

  @override
  String backupBackedUpCount(int count) {
    return '$count መዝገቦች ምትኬ ተቀምጦላቸዋል።';
  }

  @override
  String get backupSaveDialogTitle => 'ምትኬ አስቀምጥ';

  @override
  String get backupChooseFileTitle => 'የምትኬ ፋይል ይምረጡ';

  @override
  String backupFileUnreadable(String error) {
    return 'ያ ፋይል ሊነበብ አልቻለም፦ $error';
  }

  @override
  String backupTakenOn(String date) {
    return '$date የተወሰደ።';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return '$date በ$device ላይ የተወሰደ።';
  }

  @override
  String backupBelongedTo(String email) {
    return 'የ$email ነበር።';
  }

  @override
  String get backupDifferentAccountWarning =>
      'ይህ እዚህ የገቡበት መለያ አይደለም። መመለስ የሌላ ሰውን መዝገቦች ወደዚህ መሣሪያ ያመጣል።';

  @override
  String get backupRestoreEraseWarning =>
      'አሁን በዚህ መሣሪያ ላይ ያለው ሁሉ ተሰርዞ ይተካል። ገና ያልተመሳሰለ ማንኛውም ነገር ይጠፋል። ይህ ሊቀለበስ አይችልም።';

  @override
  String backupRestoredCount(int count) {
    return '$count መዝገቦች ተመልሰዋል።';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$count መዝገቦች ተመልሰዋል። የፋይሉ የተወሰነ ክፍል ከዚህ ስሪት ጋር ስላልተስማማ ቀርቷል።';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'ምንም አልተቀየረም — መመለሱ አልተሳካም፦ $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'ምትኬዎች የሚቀመጡት ይህ መተግበሪያ ብቻ በሚከፍተው የግል አቃፊ ውስጥ ነው። ሌሎች ፋይሎችዎ በጭራሽ አይነበቡም።';

  @override
  String get backupDriveConnectedTitle => 'Google Drive ተገናኝቷል';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'ከዚህ መሣሪያ የሚወሰዱ ምትኬዎች በDriveዎ ውስጥ “$folder” ወደሚባል አቃፊ ይሄዳሉ።';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'ምትኬዎች በDriveዎ ውስጥ ወደ “$folder” ይሄዳሉ።';
  }

  @override
  String get backupNoneYet => 'ከዚህ መሣሪያ እስካሁን ምንም ምትኬ አልተላከም';

  @override
  String backupLastBackedUp(String date) {
    return 'የመጨረሻው ምትኬ $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count ምትኬዎች — አዲስ ሲገባ የቆዩት ይወገዳሉ';
  }

  @override
  String get backupDisconnectSubtitle =>
      'ራስ-ሰር ምትኬዎችን ያቆማል። አስቀድሞ የተቀመጠ ምንም ነገር አይሰረዝም።';

  @override
  String backupListFailed(String error) {
    return 'ምትኬዎችዎን መዘርዘር አልተቻለም፦ $error';
  }

  @override
  String get backupDriveNotGranted => 'የGoogle Drive ፈቃድ አልተሰጠም።';

  @override
  String get backupDriveConnected => 'Google Drive ተገናኝቷል።';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Driveን ማገናኘት አልተቻለም፦ $error';
  }

  @override
  String get backupDisconnectBody =>
      'ራስ-ሰር ምትኬዎች ይቆማሉ። አስቀድሞ በDrive ውስጥ ያሉ ምትኬዎች ባሉበት ይቆያሉ፤ በማንኛውም ጊዜ እንደገና ማገናኘት ይችላሉ።';

  @override
  String backupSavedToDrive(String name) {
    return '$name በGoogle Drive ተቀምጧል።';
  }

  @override
  String backupCopyFailed(String error) {
    return 'ያ ምትኬ ሊቀመጥ አልቻለም፦ $error';
  }

  @override
  String get backupDeleteBody => 'ከGoogle Drive እስከመጨረሻው ይወገዳል።';

  @override
  String get backupRefresh => 'አድስ';

  @override
  String get ppErrKdfParams => 'ተቀባይነት የሌላቸው የቁልፍ ማመንጫ መለኪያዎች።';

  @override
  String get ppErrKdfAlgorithm => 'ያልታወቀ የቁልፍ ማመንጫ ስልተ ቀመር።';

  @override
  String get onboardingIntroAccountsTitle => 'ሁሉም ሂሳቦች፣ አንድ ቀሪ ሂሳብ';

  @override
  String get onboardingIntroAccountsBody =>
      'ጥሬ ገንዘብን፣ ካርዶችን እና ቁጠባን ጎን ለጎን ያስቀምጡ፤ በእርግጥ ምን ያህል እንደቀረዎት ይመልከቱ።';

  @override
  String get onboardingIntroBudgetsTitle => 'አስቀድመው የሚያስጠነቅቁ በጀቶች';

  @override
  String get onboardingIntroBudgetsBody =>
      'ለእያንዳንዱ ምድብ ገደብ ያዘጋጁ። መተግበሪያው ድምሩን ይከታተላል፤ ገደቡን ከማለፍዎ በፊት ያስጠነቅቅዎታል፣ ካለፉ በኋላ ሳይሆን።';

  @override
  String get onboardingIntroAskTitle => 'ስለራስዎ ወጪ ይጠይቁ';

  @override
  String get onboardingIntroAskBody =>
      'ደረሰኝ ይቃኙ፣ ወይም ባለፈው ወር ገንዘቡ የት እንደሄደ ይጠይቁ፤ ከመዝገቦችዎ የተወሰደ መልስ ያግኙ።';

  @override
  String get onboardingIntroThemeTitle => 'እንደ ምርጫዎ ያድርጉት';

  @override
  String get onboardingIntroThemeBody =>
      'አሁን ገጽታ ይምረጡ፣ ወይም በፈለጉ ጊዜ ከቅንብሮች ይቀይሩት።';

  @override
  String get onboardingCreateYourAccount => 'መለያዎን ይፍጠሩ';

  @override
  String get onboardingNext => 'ቀጣይ';

  @override
  String get onboardingCurrencyInfo =>
      'ይህ እንደ ዋና ምንዛሪዎ ጥቅም ላይ ይውላል። በተለያዩ ምንዛሪዎች ያሉ ሂሳቦችን በኋላ ማከል ይችላሉ።';

  @override
  String get onboardingTypeCash => 'ጥሬ ገንዘብ';

  @override
  String get onboardingTypeBank => 'የባንክ ሂሳብ';

  @override
  String get onboardingTypeCard => 'ክሬዲት ካርድ';

  @override
  String get onboardingTypeDeposit => 'ተቀማጭ';

  @override
  String get onboardingTypeInvestment => 'ኢንቨስትመንት';

  @override
  String get onboardingTypeAsset => 'ንብረት';

  @override
  String onboardingDayN(int day) {
    return 'ቀን $day';
  }

  @override
  String get onboardingAllSet => 'ሁሉም ዝግጁ ነው!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'መግቢያውን ማጠናቀቅ አልተቻለም፦ $error';
  }

  @override
  String get onboardingSkipFailed => 'መግቢያውን መዝለል አልተቻለም';

  @override
  String get startupOfflineConfirmBody =>
      'ውሂብዎ ባለበት ይቆያል — በዚህ መሣሪያ ላይም ሆነ በደመና ውስጥ ምንም አይሰረዝም።\n\nነገር ግን መለያው የተቀመጠ ውሂብ ካለው፣ አሁን የሚያክሉት ሁሉ ሲመልሱ ከእሱ ጎን ይቀመጣል — የሚያስተካክሏቸው ድግግሞሾች ሊኖሩ ይችላሉ።';

  @override
  String get startupDataInCloudTitle => 'ውሂብዎ በደመና ውስጥ እየጠበቀዎት ነው';

  @override
  String get startupLoadFailedTitle => 'መለያዎን ጭነን መጨረስ አልቻልንም';

  @override
  String get startupGenericReason => 'ይህን መለያ በማረጋገጥ ላይ ሳለ የሆነ ችግር ተፈጥሯል።';

  @override
  String get startupUseWithoutRestoring => 'ሳይመልሱ መተግበሪያውን ይጠቀሙ';

  @override
  String get legalTermsTab => 'ውሎች';

  @override
  String get legalConsent => 'የግላዊነት ፖሊሲውን እና ውሎቹንና ሁኔታዎቹን አንብቤ ተስማምቻለሁ';

  @override
  String get walkthroughGotIt => 'ገባኝ!';

  @override
  String get settingsFaqSectionGettingStarted => 'መጀመሪያ';

  @override
  String get settingsFaq01Question => 'ግብይት እንዴት እጨምራለሁ?';

  @override
  String get settingsFaq01Answer =>
      'በመነሻ ገጹ ታች ያለውን + ቁልፍ ይንኩ። መጠኑን ያስገቡ፣ ምድብ ይምረጡ፣ ቦርሳ ይምረጡ፣ ከፈለጉም ማስታወሻ ያክሉ። ግብይቱን ለመመዝገብ አስቀምጥ የሚለውን ይንኩ።';

  @override
  String get settingsFaq02Question => 'በቦርሳዎች እና በምድቦች መካከል ያለው ልዩነት ምንድን ነው?';

  @override
  String get settingsFaq02Answer =>
      'ቦርሳዎች ገንዘብዎ የት እንዳለ ያሳያሉ (ለምሳሌ ጥሬ ገንዘብ፣ የባንክ ሂሳብ፣ ክሬዲት ካርድ)። ምድቦች ገንዘቡ ለምን እንደወጣ ወይም ከየት እንደመጣ ይገልጻሉ (ለምሳሌ ምግብ፣ ደመወዝ፣ መዝናኛ)።';

  @override
  String get settingsFaq03Question => 'የቀን እና የቁጥር ቅርጸትን እንዴት እቀይራለሁ?';

  @override
  String get settingsFaq03Answer =>
      'ወደ ቅንብሮች > የክልል ቅንብሮች ይሂዱ። ነባሪ ምንዛሪዎን፣ የቀን ቅርጸትን (ለምሳሌ DD/MM/YYYY ወይም MM/DD/YYYY) እና የቁጥር ቅርጸትን (ለምሳሌ 1,234.56 ወይም 1.234,56) መቀየር ይችላሉ። ቅንብሮችዎ ምን እንደሚመስሉ የቀጥታ ቅድመ እይታ ያሳያል።';

  @override
  String get settingsFaqSectionTransactions => 'ግብይቶች';

  @override
  String get settingsFaq04Question => 'ተደጋጋሚ ግብይቶችን መከታተል እችላለሁ?';

  @override
  String get settingsFaq04Answer =>
      'አዎ! ግብይት ሲጨምሩ «ተደጋጋሚ» የሚለውን አማራጭ ያብሩ። በየቀኑ፣ በየሳምንቱ፣ በየወሩ ወይም በየዓመቱ እንዲደገም ማድረግ ይችላሉ። መተግበሪያው እነዚህን ግብይቶች በራሱ ይፈጥርልዎታል።';

  @override
  String get settingsFaq05Question => 'በቦርሳዎች መካከል ገንዘብ እንዴት አዘዋውራለሁ?';

  @override
  String get settingsFaq05Answer =>
      'ግብይት ሲጨምሩ እንደ አይነት «ዝውውር» ይምረጡ። ገንዘቡ የሚወጣበትን እና የሚገባበትን ቦርሳ ይምረጡ፣ መጠኑንም ያስገቡ። መተግበሪያው ከአንዱ ቀንሶ ወደ ሌላው በራሱ ይጨምራል።';

  @override
  String get settingsFaq06Question => 'መጪ ግብይቶች ምንድን ናቸው?';

  @override
  String get settingsFaq06Answer =>
      'መጪ ግብይቶች የሚጠብቋቸው ግን ገና ያልተከፈሉ የወደፊት ወጪዎች ወይም ገቢዎች ናቸው። እንደተከፈሉ ምልክት እስኪያደርጉባቸው ድረስ የቦርሳዎን ቀሪ ሂሳብ አይነኩም። ጊዜያቸው ያለፈባቸውን እና መጪ ነገሮችን በግብይቶች ክፍል ውስጥ ያገኟቸዋል።';

  @override
  String get settingsFaq07Question => 'ምዝገባዎችን እንዴት እከታተላለሁ?';

  @override
  String get settingsFaq07Answer =>
      'ግብይት ሲጨምሩ ልዩ አይነቱን ምዝገባ ያድርጉት። ይህ እንደ ተደጋጋሚ የአገልግሎት ክፍያ ምልክት ያደርግበታል። ሁሉንም ምዝገባዎችዎን በአንድ ቦታ ማየት እና ለምዝገባዎች በወር የሚያወጡትን መከታተል ይችላሉ።';

  @override
  String get settingsFaq08Question => 'የብድር እና የዕዳ ክትትል እንዴት ይሰራል?';

  @override
  String get settingsFaq08Answer =>
      'ለሌላ ሰው ያበደሩትን ገንዘብ ለመከታተል ብድርን፣ የተበደሩትን ገንዘብ ለመከታተል ደግሞ ዕዳን ይጠቀሙ። እያንዳንዱ መዝገብ መጠኑን፣ ማን ለማን እንደሚከፍል እና ክፍያው የት እንደደረሰ ይይዛል። ከፊል ክፍያዎችን መመዝገብ እና ሙሉ በሙሉ ሲከፈሉ ዕዳዎችን እንደተዘጉ ምልክት ማድረግ ይችላሉ።';

  @override
  String get settingsFaq09Question => 'በግብይቶች ላይ ማስታወሻ ወይም ደረሰኝ ማከል እችላለሁ?';

  @override
  String get settingsFaq09Answer =>
      'አዎ! ግብይት ሲጨምሩ ወይም ሲያርትዑ በማስታወሻ ቦታው ላይ መጻፍ ይችላሉ። የPremium ተጠቃሚዎች ደግሞ መጠኑን እና የነጋዴውን ዝርዝር በራሱ በሚያወጣው የAI ደረሰኝ ቅኝት ደረሰኞችን መቃኘት ይችላሉ።';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'ቦርሳዎች እና ምንዛሪዎች';

  @override
  String get settingsFaq10Question => 'ብዙ ሂሳቦችን እንዴት አስተዳድራለሁ?';

  @override
  String get settingsFaq10Answer =>
      'መተግበሪያው አራት አይነት ሂሳቦችን ይደግፋል፦ ጥሬ ገንዘብ፣ የባንክ ሂሳብ፣ ክሬዲት ካርድ እና ምዝገባ። አዲስ ሂሳብ ለማከል በዳሽቦርዱ ላይ ወደ «ሂሳቦችዎ» ሄደው «ሂሳብ አክል» የሚለውን ይንኩ። እያንዳንዱ ሂሳብ የራሱ ስም፣ አዶ፣ ቀለም እና ምንዛሪ ሊኖረው ይችላል። የመጀመሪያው ሂሳብዎ በራሱ ነባሪ ይሆናል። ለክሬዲት ካርድ ሂሳቦች ደግሞ ያለዎትን ብድር ለመከታተል የብድር ገደብ እና የሂሳብ መክፈያ ቀን ማዘጋጀት ይችላሉ።';

  @override
  String get settingsFaq11Question => 'ብዙ ምንዛሪዎችን መጠቀም እችላለሁ?';

  @override
  String get settingsFaq11Answer =>
      'አዎ! እያንዳንዱ ቦርሳ የራሱ ምንዛሪ ሊኖረው ይችላል። መተግበሪያው ወቅታዊ የምንዛሪ ተመኖችን ተጠቅሞ በራሱ ይቀይራል። በቅንብሮች > የክልል ቅንብሮች ውስጥ የራስዎን የምንዛሪ ተመኖችም ማዘጋጀት ይችላሉ።';

  @override
  String get settingsFaq12Question => 'የምንዛሪ ልወጣ እንዴት ይሰራል?';

  @override
  String get settingsFaq12Answer =>
      'እያንዳንዱ ቦርሳ የተለየ ምንዛሪ ሊኖረው ይችላል፤ መተግበሪያው በየጥቂት ሰዓቱ የሚዘመኑ ወቅታዊ የምንዛሪ ተመኖችን ተጠቅሞ መጠኖችን በራሱ ይቀይራል። ለማንኛውም የምንዛሪ ጥንድ የራስዎን ተመን በቅንብሮች > የክልል ቅንብሮች ውስጥ ማዘጋጀት ይችላሉ። መተግበሪያው ከ150 በላይ ምንዛሪዎችን ይደግፋል፤ ተመኖችንም በራሱ ያመጣል።';

  @override
  String get settingsFaq13Question => 'ግብይቶች ያሉበትን ምድብ ብሰርዝ ምን ይሆናል?';

  @override
  String get settingsFaq13Answer =>
      'እነዚያ ግብይቶች ወደ «ያልተመደበ» ይዛወራሉ። ከዚያ ወደ ሌላ ምድብ መመደብ ወይም ሳይመደቡ መተው ይችላሉ።';

  @override
  String get settingsFaq14Question => 'ንዑስ ምድቦች ምንድን ናቸው፣ እንዴትስ እጠቀምባቸዋለሁ?';

  @override
  String get settingsFaq14Answer =>
      'በዝርዝር ለመከታተል በማንኛውም ዋና ምድብ ስር ንዑስ ምድቦችን መፍጠር ይችላሉ። ለምሳሌ በ«ምግብ» ስር «ሸቀጣሸቀጥ»፣ «ምግብ ቤቶች» እና «ቡና» ሊኖርዎት ይችላል። ንዑስ ምድቦች ገንዘብዎ በትክክል የት እንደሚሄድ ለማየት ይረዱዎታል።';

  @override
  String get settingsFaq15Question => 'የቀሪ ሂሳብ ማስተካከያ ምንድን ነው?';

  @override
  String get settingsFaq15Answer =>
      'የቀሪ ሂሳብ ማስተካከያ የቦርሳ ቀሪ ሂሳብ ከትክክለኛው መጠን ጋር በማይጣጣምበት ጊዜ እንዲያስተካክሉ ያስችልዎታል። ገቢ ወይም ወጪ በእጅ ሳያስገቡ የተመዘገበውን ቀሪ ሂሳብ ከእውነታው ጋር የሚያስተካክል ልዩ ግብይት ይፈጥራል።';

  @override
  String get settingsFaqSectionBudgetsGoals => 'በጀቶች እና ግቦች';

  @override
  String get settingsFaq16Question => 'በጀት እንዴት አዘጋጃለሁ?';

  @override
  String get settingsFaq16Answer =>
      'ወደ በጀቶች ትር ሄደው «አዲስ በጀት» የሚለውን ይንኩ። ስም ይምረጡ፣ የወጪ ገደብዎን ያስቀምጡ፣ የጊዜ ክፍሉን (ሳምንታዊ/ወርሃዊ) ይምረጡ፣ የሚከታተሉትንም ምድቦች ይምረጡ። ወደ ገደብዎ ሲቃረቡ መተግበሪያው ያሳውቅዎታል።';

  @override
  String get settingsFaq17Question => 'የቁጠባ ግቦች ምንድን ናቸው?';

  @override
  String get settingsFaq17Answer =>
      'የቁጠባ ግቦች መቆጠብ የሚፈልጉትን መጠን እንዲያስቀምጡ ያስችሉዎታል። በግቦች ክፍል ውስጥ ግብ ይፍጠሩ፣ ዒላማዎን ያስቀምጡ፣ እድገትዎን ለመከታተልም ግብይቶችን ያገናኙ። መተግበሪያው የእድገት አሞሌ እና ወደ ዒላማዎ የደረሱበትን መቶኛ ያሳያል።';

  @override
  String get settingsFaq18Question => 'ብድርን እንዴት እከታተላለሁ?';

  @override
  String get settingsFaq18Answer =>
      'በግቦች ክፍል ውስጥ ያለብዎትን ጠቅላላ መጠን የያዘ የብድር ግብ ይፍጠሩ። ክፍያ ሲፈጽሙ እነዚያን ግብይቶች ከብድሩ ጋር በማገናኘት የመመለስ እድገትዎን ይከታተሉ። መተግበሪያው ምን ያህል እንደከፈሉ እና ምን እንደቀረ ያሳያል።';

  @override
  String get settingsFaqSectionDataSync => 'ውሂብ እና ማመሳሰል';

  @override
  String get settingsFaq19Question => 'የደመና ማመሳሰል እንዴት ይሰራል?';

  @override
  String get settingsFaq19Answer =>
      'የደመና ማመሳሰል ውሂብዎን በሁሉም መሣሪያዎች ላይ አንድ አይነት ያደርጋል። ለማብራት ወደ ቅንብሮች > የውሂብ አስተዳደር > የደመና ማመሳሰል ይሂዱ። ማመሳሰሉ በየ15 ደቂቃው እና መተግበሪያውን ሲከፍቱ በራሱ ይሰራል። ወዲያውኑ ለማመሳሰል «አሁን አመሳስል» የሚለውንም መንካት ይችላሉ። ይህ የPremium ባህሪ ነው።';

  @override
  String get settingsFaq20Question => 'ውሂቤን እንዴት እልካለሁ?';

  @override
  String get settingsFaq20Answer =>
      'ወደ ቅንብሮች > የውሂብ አስተዳደር > ውሂብ ላክ ይሂዱ። የቀን ክልል ይምረጡ፣ CSV (ለተመን ሉሆች) ወይም PDF (ለተቀናጀ ሪፖርት) ይምረጡ፣ ከዚያ ላክ የሚለውን ይንኩ። በምድብ እና በቦርሳ የተከፋፈለ ዝርዝርን ማካተት ወይም መተው ይችላሉ። ይህ የPremium ባህሪ ነው።';

  @override
  String get settingsFaq21Question => 'ውሂቤን ባጸዳ ምን ይሆናል?';

  @override
  String get settingsFaq21Answer =>
      'ወደ ቅንብሮች > ግላዊነት እና ደህንነት ይሂዱ። «መሸጎጫ አጽዳ» ግብይቶችዎን ሳይሰርዝ ጊዜያዊ ውሂብን ያስወግዳል፣ ዳግም ማመሳሰልንም ያስገድዳል። «ሁሉንም ውሂብ አጽዳ» ሁሉንም ነገር እስከመጨረሻው ይሰርዛል — ለማረጋገጥ DELETE ብለው መተየብ ያስፈልግዎታል። ይህ ድርጊት ሊቀለበስ አይችልም።';

  @override
  String get settingsFaqSectionPremiumAiFeatures => 'Premium እና የAI ባህሪያት';

  @override
  String get settingsFaq22Question => 'Premium ምን ባህሪያትን ያካትታል?';

  @override
  String get settingsFaq22Answer =>
      'Premium የሚከፍተው፦ ያለ ማስታወቂያ ያልተገደበ AI (አማካሪው፣ ወርሃዊ ማጠቃለያዎች፣ ደረሰኝ ማንበብ እና ይግለጹት)፣ የደመና ማመሳሰል፣ PDF ሪፖርቶች፣ Premium ገጽታዎች፣ እንዲሁም በቦርሳዎች፣ በምድቦች፣ በበጀቶች፣ በግቦች እና በመክፈያ ዘዴዎች ላይ ያሉትን ገደቦች ያነሳል። ቅድሚያ የሚሰጠው ድጋፍም ያገኛሉ።';

  @override
  String get settingsFaq23Question => 'የነፃው ስሪት ገደቦች ምንድን ናቸው?';

  @override
  String get settingsFaq23Answer =>
      'ነፃ ተጠቃሚዎች እስከ 3 ቦርሳዎች፣ 10 የራሳቸው ምድቦች፣ 3 ንቁ በጀቶች፣ 2 ንቁ ግቦች/ብድሮች እና 5 የመክፈያ ዘዴዎች መፍጠር ይችላሉ። ወደ Premium ማሻሻል እነዚህን ሁሉ ገደቦች ያነሳል።';

  @override
  String get settingsFaq24Question => 'የAI ረዳቱ ምን ማድረግ ይችላል?';

  @override
  String get settingsFaq24Answer =>
      'የገንዘብ አማካሪው ስለ ራስዎ ገንዘብ ለሚያነሷቸው ጥያቄዎች መልስ ይሰጣል፦ ገንዘቡ የት እንደሄደ፣ በበጀቶችዎ እና በግቦችዎ ላይ በትክክለኛው መንገድ ላይ መሆንዎን፣ የትኞቹ ሂሳቦች እንደሚመጡ፣ እንዲሁም እንዴት ያነሰ ማውጣት ወይም የበለጠ መቆጠብ እንደሚችሉ። መልሶቹ እውነተኛ ቁጥሮችዎን እንዲጠቀሙ የቁጥሮችዎን ማጠቃለያ (ድምሮች፣ ምድቦች፣ በጀቶች፣ ግቦች፣ ሂሳቦች እና የቅርብ ጊዜ ግብይቶች) ያያል፤ ከእያንዳንዱ መልስ በኋላም ተከታይ ጥያቄዎችን ይጠቁማል። አጠቃላይ መመሪያ ይሰጣል እንጂ ሙያዊ የፋይናንስ ምክር አይደለም። ካቆሙበት እንዲቀጥሉ ውይይቶችዎ ይቀመጣሉ፤ በማንኛውም ጊዜ ሊሰርዟቸውም ይችላሉ።';

  @override
  String get settingsFaq25Question => 'የAI ግንዛቤዎች እንዴት ይሰራሉ?';

  @override
  String get settingsFaq25Answer =>
      'ወርሃዊ ማጠቃለያው (ስታቲስቲክስ > የወጪ ግንዛቤዎች) ይህን ወር ካለፈው ወር ጋር ያነጻጽራል፦ ምን እንዳገኙ እና ምን እንዳወጡ፣ እያንዳንዱ ምድብም እንዴት እንደተቀየረ። ማጠቃለያዬን ጻፍ የሚለውን ይንኩ፤ AI ጎልተው የታዩትን ነገሮች ያወጣል፣ የሚሞክሩትንም አንድ ነገር ይጠቁማል። ቁጥሮቹ ለሁሉም ነፃ ናቸው፤ የAI ጽሑፉ አንድ የAI ጥያቄ ይጠቀማል።';

  @override
  String get settingsFaq26Question => 'ብልህ ምደባ ምንድን ነው?';

  @override
  String get settingsFaq26Answer =>
      'ግብይትን በእጅ ሲመድቡ መተግበሪያው ያ ርዕስ የየትኛው ምድብ እንደሆነ ያስታውሳል፤ በሚቀጥለው ጊዜም በራሱ ይመርጥልዎታል (እነዚህን በየስያሜ ደንቦች ስር ማየት እና ማርትዕ ይችላሉ)። ለአዲስ ነገር በመጨመሪያ ገጹ ላይ ያለውን የብልጭታ ቁልፍ ይንኩ እና ይግለጹት የሚለውን ይጠቀሙ፦ ለምሳሌ «ምሳ 250 ትናንት ከbKash» ብለው ይጻፉ፤ AI መጠኑን፣ ቀኑን፣ ምድቡን እና ሂሳቡን እንዲያረጋግጡ ይሞላልዎታል።';

  @override
  String get settingsFaq27Question => 'የAI ደረሰኝ ቅኝት እንዴት ይሰራል?';

  @override
  String get settingsFaq27Answer =>
      'የደረሰኝ ፎቶ ያንሱ ወይም ይምረጡ። ስልክዎ ጽሑፉን በመሣሪያው ላይ አንብቦ ነጋዴውን እና ድምሩን ይጠቁማል። በAI አንብብ የሚለውን ይንኩ፤ AI ደረሰኙ የተዘበራረቀ ቢሆንም እውነተኛውን ድምር፣ ቀኑን፣ እያንዳንዱን ዕቃ እና ትክክለኛውን ምድብ ያወጣል፤ የሚላከው ጽሑፉ ብቻ ነው፣ ፎቶው በጭራሽ አይላክም። ከማስቀመጥዎ በፊት መገምገም እና ማርትዕ ይችላሉ። በAI ማንበብ አንድ የAI ጥያቄ ይጠቀማል።';

  @override
  String get settingsFaq28Question =>
      'ስንት የAI ጥያቄዎች አገኛለሁ? ማስታወቂያዎቹስ ለምንድን ናቸው?';

  @override
  String get settingsFaq28Answer =>
      'ሁሉም ሰው በወር 10 ነፃ የAI ጥያቄዎች ያገኛል፤ በወሩ 1ኛ ቀን ይመለሳሉ። ተጨማሪ ከፈለጉ አጭር ማስታወቂያ በማየት አንድ ተጨማሪ ጥያቄ ማግኘት ይችላሉ፤ በወር እስከ 10 ተጨማሪ። ማስታወቂያዎች የ24 ሰዓት የPremium ገጽታ ሙከራን ወይም አንድ PDF መላክን ሊከፍቱም ይችላሉ። ማስታወቂያ የሚጫወተው ቁልፍ ነክተው ካረጋገጡ በኋላ ብቻ ነው፤ የባነር ማስታወቂያዎች የሉም፣ ምንም ነገር በራሱ አይመጣም። የPremium አባላት ያልተገደበ AI እና ሌሎቹን ሁሉ ያለ ምንም ማስታወቂያ ያገኛሉ።';

  @override
  String get settingsFaq29Question => 'የPremium ግዢዬን እንዴት አስተዳድራለሁ?';

  @override
  String get settingsFaq29Answer =>
      'የPremium ግዢዎች የሚተዳደሩት በGoogle Play በኩል ነው። ዕቅድዎን ለማየት ወይም ለማስተዳደር ወደ Google Play የምዝገባ ቅንብሮች ይሂዱ። Premium በወርሃዊ፣ በዓመታዊ ወይም በአንድ ጊዜ የዕድሜ ልክ ግዢ ይገኛል።';

  @override
  String get settingsFaqSectionPrivacySecurity => 'ግላዊነት እና ደህንነት';

  @override
  String get settingsFaq30Question => 'ባዮሜትሪክ ቁልፍን እንዴት አዘጋጃለሁ?';

  @override
  String get settingsFaq30Answer =>
      'ወደ ቅንብሮች > ግላዊነት እና ደህንነት ሄደው ባዮሜትሪክ ቁልፍን ያብሩ። ከበራ በኋላ መተግበሪያውን ለመክፈት የጣት አሻራዎ ወይም ፊትዎ ያስፈልጋል። ለተወሰነ ጊዜ ጥቅም ላይ ካልዋለ መተግበሪያው እንዲቆለፍ የራስ-ሰር ቁልፍ ጊዜ ቆጣሪም ማዘጋጀት ይችላሉ።';

  @override
  String get settingsFaq31Question => 'የፋይናንስ ውሂቤ ደህንነቱ የተጠበቀ ነው?';

  @override
  String get settingsFaq31Answer =>
      'አዎ። ሁሉም ውሂብዎ በመሣሪያዎ ላይ ብቻ ይቀመጣል። የደመና ማመሳሰልን ካበሩ ውሂብዎ በሚተላለፍበት ጊዜ ይመሰጠራል። የፋይናንስ ውሂብዎን ለሶስተኛ ወገኖች በጭራሽ አናጋራም። የግላዊነት ፖሊሲያችንን በቅንብሮች > ስለ ውስጥ ማየት ይችላሉ።';

  @override
  String get txnLoadPaymentMethodsFailed => 'የመክፈያ ዘዴዎችን መጫን አልተቻለም';

  @override
  String get txnAddPaymentMethodFailed => 'የመክፈያ ዘዴ ማከል አልተቻለም';

  @override
  String get txnPaymentMethodNotFound => 'የመክፈያ ዘዴው አልተገኘም';

  @override
  String get txnUpdatePaymentMethodFailed => 'የመክፈያ ዘዴውን ማዘመን አልተቻለም';

  @override
  String get txnDeletePaymentMethodFailed => 'የመክፈያ ዘዴውን መሰረዝ አልተቻለም';

  @override
  String txnLoadFailed(String error) {
    return 'ግብይቶችን መጫን አልተቻለም፦ $error';
  }

  @override
  String get txnAddFailed => 'ግብይቱን ማከል አልተቻለም';

  @override
  String txnAddFailedWithError(String error) {
    return 'ግብይቱን ማከል አልተቻለም፦ $error';
  }

  @override
  String get txnNotFound => 'ግብይቱ አልተገኘም';

  @override
  String get txnUpdateFailed => 'ግብይቱን ማዘመን አልተቻለም';

  @override
  String txnNotATransfer(String id) {
    return 'ግብይት $id ዝውውር አይደለም';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'ዝውውሩን ማዘመን አልተቻለም፦ $error';
  }

  @override
  String get txnDeleteFailed => 'ግብይቱን መሰረዝ አልተቻለም';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'ዝውውሮችን መጫን አልተቻለም፦ $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'ዝውውሩን መፍጠር አልተቻለም፦ $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'ዝውውሩን መሰረዝ አልተቻለም፦ $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'መረጃ መጫን አልተቻለም፦ $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'እንደተከፈለ ምልክት ማድረግ አልተቻለም፦ $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'እንዳልተከፈለ ምልክት ማድረግ አልተቻለም፦ $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'ግብይቱን መዝለል አልተቻለም፦ $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'የተቀበልኩት፦ $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'የተከፈለ፦ $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'የተመለሰ፦ $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'እንደተጠናቀቀ ምልክት ማድረግ አልተቻለም፦ $error';
  }

  @override
  String get creditPaymentMustBePositive => 'የክፍያው መጠን ከዜሮ በላይ መሆን አለበት';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'ክፍያውን መመዝገብ አልተቻለም፦ $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'እንደ በመጠባበቅ ላይ ምልክት ማድረግ አልተቻለም፦ $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'ቀሪ፦ $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'የ$amount ክፍያ ተመዝግቧል';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'ከ\"$title\" እንደተሰበሰበ ምልክት ተደርጓል';
  }

  @override
  String get importFieldDescription => 'መግለጫ';

  @override
  String get importFieldDirection => 'ዓይነት (ገቢ/ወጪ)';

  @override
  String get importMissingDate => 'የቀን ዓምድ';

  @override
  String get importMissingAmount => 'የመጠን ዓምድ';

  @override
  String importColumnN(int index) {
    return 'ዓምድ $index';
  }

  @override
  String get importNoDate => 'ቀን የለም';

  @override
  String importDateMismatch(String date, String format) {
    return 'ቀኑ \"$date\" ከ$format ጋር አይዛመድም';
  }

  @override
  String get importAnyKnownFormat => 'ከማንኛውም የሚታወቅ ቅርጸት';

  @override
  String get importNoAmount => 'መጠን የለም';

  @override
  String get importIntro =>
      'ከባንክዎ CSV ያውጡ እና እዚህ ይክፈቱት። ዓምዶቹ ለእርስዎ ይለያሉ፣ እና ምን እንደሚጨመር በትክክል እስኪያዩ ድረስ ምንም አይጨመርም።';

  @override
  String get importSavedBanks => 'የተቀመጡ ባንኮች';

  @override
  String get importChooseStatement => 'የሂሳብ መግለጫ ይምረጡ';

  @override
  String get importNoRows => 'በዚያ ፋይል ውስጥ ረድፎች የሉም።';

  @override
  String importUsingSavedMapping(String name) {
    return 'ለ$name ያስቀመጡትን ካርታ በመጠቀም ላይ።';
  }

  @override
  String importCouldNotRead(String error) {
    return 'ያ ፋይል ሊነበብ አልቻለም፦ $error';
  }

  @override
  String importForgetTitle(String name) {
    return '$nameን ይርሱ?';
  }

  @override
  String get importForgetBody => 'በሚቀጥለው ጊዜ ዓምዶቹን እንደገና እንዲያዛምዱ ይጠየቃሉ።';

  @override
  String get importColumnsHeader => 'ዓምዶች';

  @override
  String get importHowToRead => 'እሴቶቹን እንዴት ማንበብ';

  @override
  String get importWhereItGoes => 'የሚሄድበት';

  @override
  String get importWhatWillBeAdded => 'የሚጨመረው';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ረድፎች',
      one: '1 ረድፍ',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ዓምዶች',
      one: '1 ዓምድ',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'በ$separator የተለየ';
  }

  @override
  String importMappedAs(String name) {
    return 'እንደ $name የተዛመደ';
  }

  @override
  String get importDelimCommas => 'ኮማዎች';

  @override
  String get importDelimSemicolons => 'ሴሚኮሎኖች';

  @override
  String get importDelimTabs => 'ታቦች';

  @override
  String get importDelimPipes => 'ቋሚ መስመሮች (|)';

  @override
  String get importRequired => 'ያስፈልጋል';

  @override
  String get importNotImported => 'አይመጣም';

  @override
  String get importEmptySample => 'ባዶ';

  @override
  String get importPickDateColumnFirst => 'መጀመሪያ የቀን ዓምድ ይምረጡ።';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" ከዚህ ቅርጸት ጋር አይስማማም።';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" እንደ $date ይነበባል';
  }

  @override
  String get importDecimalAuto => 'ከፋይሉ የተለየ';

  @override
  String get importDecimalFullStop => 'ነጥብ፣ ለምሳሌ 1,234.56';

  @override
  String get importDecimalComma => 'ኮማ፣ ለምሳሌ 1.234,56';

  @override
  String get importDuplicatesHint =>
      'በቀኑ፣ በመጠኑና በመግለጫው ይዛመዳል፣ ስለዚህ የሚደራረብ መግለጫ እንደገና ማስገባት ምንም አያባዛም';

  @override
  String importStillNeeds(String item) {
    return 'ገና $item ያስፈልጋል።';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'ገና $first እና $second ያስፈልጋሉ።';
  }

  @override
  String get importNothingReadable =>
      'በእነዚህ ቅንብሮች ከዚህ ፋይል ምንም ሊነበብ አይችልም። የቀን ቅርጸቱንና መጠኑ የትኛው ዓምድ እንዳለ ያረጋግጡ።';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች',
      one: '1 ግብይት',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount ገቢ';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount ወጪ';
  }

  @override
  String importAndMore(int count) {
    return 'እና ሌሎች $count';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count መስመሮች ይዘለላሉ',
      one: '1 መስመር ይዘለላል',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count መስመሮች ይዘለላሉ።',
      one: '1 መስመር ይዘለላል።',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'መስመር $line፦ $problem';
  }

  @override
  String get importAddAccountFirst => 'መጀመሪያ ሂሳብ ያክሉ';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶችን አስገባ',
      one: '1 ግብይት አስገባ',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግብይቶች ይግቡ?',
      one: '1 ግብይት ይግባ?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody => 'ወደ መዝገቦችዎ ይጨመራሉ እና በሚቀጥለው ሲንክ ይሰቀላሉ።';

  @override
  String get importConfirmDuplicates =>
      'በዚያው ቀን፣ በዚያው መጠንና መግለጫ ቀደም ብሎ ያለ ማንኛውም ነገር አይነካም።';

  @override
  String importFailed(String error) {
    return 'ማስገባቱ አልተሳካም፦ $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count ገብቷል';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count ቀደም ብለው ነበሩ እና አልተነኩም።';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count መስመሮች ሊነበቡ አልቻሉም።',
      one: '1 መስመር ሊነበብ አልቻለም።',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'አዲስ ምድቦች፦ $names።';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'እነዚህ የሂሳብ ስሞች እዚህ የሚዛመዱት አልነበራቸውም፣ ስለዚህ ረድፎቻቸው ወደ መረጡት ሂሳብ ሄደዋል፦ $names።';
  }

  @override
  String get importRememberBody =>
      'እነዚሁ ዓምዶች ያሉት ቀጣዩ ፋይል ሳይጠየቅ በዚህ መንገድ ይዛመዳል።';

  @override
  String get importNoHeaderCannotSave =>
      'የዓምድ ርዕሶች የሌሉት ፋይል እንደገና ሊታወቅ አይችልም፣ ስለዚህ የሚዛመድበት ነገር የለም።';

  @override
  String get importTemplateSaved =>
      'ተቀምጧል። እነዚህ ዓምዶች ያሏቸው ፋይሎች ከአሁን ጀምሮ ይጠቀሙበታል።';

  @override
  String get txnTransferSameWallet => 'መነሻውና መድረሻው ቦርሳ የተለያዩ መሆን አለባቸው';

  @override
  String get txnTransferAmountPositive => 'የዝውውሩ መጠን ከዜሮ በላይ መሆን አለበት';

  @override
  String get txnTransferFeeNegative => 'የዝውውር ክፍያ ከዜሮ በታች መሆን አይችልም';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'የመነሻ ቦርሳ አልተገኘም፦ $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'የመድረሻ ቦርሳ አልተገኘም፦ $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'ዝውውር፦ $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'በመካከላቸው ለማዛወር ሁለቱም ቦርሳዎች መኖር አለባቸው (መነሻ፦ $source፣ መድረሻ፦ $destination)።';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'በአንድ ምንዛሬ ውስጥ ያለ ዝውውር አንድ መጠን ብቻ ያንቀሳቅሳል፦ $source እና $destination ሁለቱም በ$currency ናቸው፣ ስለዚህ የተቀበለው መጠን ሊለያይ አይችልም።';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'በ$from እና በ$to መካከል የሚታወቅ ምንዛሬ ተመን የለም፣ ስለዚህ በ$destination ውስጥ በትክክል የገባውን ያስገቡ።';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'የተቀበለው መጠን ከዜሮ በላይ መሆን አለበት። በ$destination ውስጥ በትክክል የገባውን ያስገቡ።';
  }

  @override
  String txnFeeTitle(String title) {
    return 'ክፍያ፦ $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'ግብይቱ አልተገኘም፦ $id';
  }

  @override
  String get txnNotATransferNoPair => 'ግብይቱ ዝውውር አይደለም (ተጓዳኝ ግብይት የለም)';

  @override
  String txnPairedNotFound(String id) {
    return 'ተጓዳኝ ግብይት $id አልተገኘም፤ የዝውውርን ግማሽ ብቻ ማስተካከል አይቻልም።';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'እንዲህ ያለ ሂሳብ የለም፦ $id';
  }

  @override
  String get walletCorrectionTitle => 'የቀሪ ሂሳብ ማስተካከያ';

  @override
  String walletCorrectionNote(String name) {
    return '$name ከትክክለኛው ቀሪ ሂሳቡ ጋር እንዲመሳሰል ተስተካክሏል።';
  }

  @override
  String get walletMergeIntoItself => 'ሂሳብ ከራሱ ጋር ሊዋሀድ አይችልም።';

  @override
  String get walletMergeBothMustExist => 'ለማዋሀድ ሁለቱም ሂሳቦች መኖር አለባቸው።';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'በ$from እና በ$to መካከል የሚታወቅ ተመን የለም፣ ስለዚህ እነዚህ ሂሳቦች ገና ሊዋሀዱ አይችሉም።';
  }

  @override
  String get walletMergeAdjustmentTitle => 'የውህደት ማስተካከያ';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'በእነዚህ ሂሳቦች መካከል ዝውውር የተደረገበት ተመን $name ከተዋሀደበት ተመን ይለያል። ይህ ጠቅላላው እንዳይቀየር ልዩነቱን ይመዘግባል።';
  }

  @override
  String get splitErrNoTotal => 'የሂሳቡን መጠን ያስገቡ።';

  @override
  String get splitErrNoPeople => 'የሚካፈሉትን ሰው ያክሉ።';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name በሂሳቡ ውስጥ የለም።';
  }

  @override
  String get splitErrNothingToRecord =>
      'ሌላ ሰው ከፍሏል እና እርስዎ ምንም አልተካፈሉም፣ ስለዚህ የሚመዘገብ ነገር የለም።';

  @override
  String get splitErrGiveOwnShare => 'የራስዎን ድርሻ ያስገቡ።';

  @override
  String splitErrGiveShare(String name) {
    return 'የ$nameን ድርሻ ያስገቡ።';
  }

  @override
  String get splitErrNegativeShare => 'ድርሻ ከዜሮ በታች መሆን አይችልም።';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'ድርሻዎቹ ድምር $sum ነው፣ $total አይደለም።';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'መቶኛዎቹ ድምር $sum% ነው፣ 100% አይደለም።';
  }

  @override
  String get splitErrNameTooLong => 'ስሞች ከ100 ቁምፊ በታች ይሁኑ።';

  @override
  String splitErrDuplicateName(String name) {
    return '$name በሂሳቡ ላይ ሁለት ጊዜ አለ።';
  }

  @override
  String get splitErrTitleTooLong => 'ርዕሱ ከ200 ቁምፊ በታች ይሁን።';

  @override
  String get splitErrChooseAccount => 'የተከፈለበትን ሂሳብ ይምረጡ።';

  @override
  String get splitErrOrdinaryAccount => 'መደበኛ ሂሳብ ይምረጡ።';

  @override
  String get splitErrYourShareNothing => 'የእርስዎ ድርሻ ምንም ነው፣ ስለዚህ የሚከፈል ዕዳ የለም።';

  @override
  String get splitErrEveryShareNothing => 'ሁሉም ድርሻዎች ምንም ናቸው።';

  @override
  String get recurringDaily => 'በየቀኑ';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ቀኑ',
      one: 'በየቀኑ',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ሳምንቱ',
      one: 'በየሳምንቱ',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ወሩ',
      one: 'በየወሩ',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ዓመቱ',
      one: 'በየዓመቱ',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'በየ$count $unit';
  }

  @override
  String get recurringUntitled => 'ተደጋጋሚ ግብይት';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በ$count ቀናት ውስጥ',
      one: 'በ1 ቀን ውስጥ',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'በሚቀጥለው ሳምንት';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በ$count ሳምንታት ውስጥ',
      one: 'በ1 ሳምንት ውስጥ',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'ካርድ';

  @override
  String get txnPmKindDigitalWallet => 'ዲጂታል ቦርሳ';

  @override
  String get txnPmEmptyHint =>
      'የሚከፍሉባቸውን ካርዶችና ሂሳቦች ያክሉ፣ ከዚያ በግብይት ላይ አንዱን መምረጥ ይችላሉ።';

  @override
  String get txnPmDeleteBody =>
      'ቀደም ሲል በእሱ የተመዘገቡ ግብይቶች መዝገባቸውን ይይዛሉ። የመክፈያ ዘዴ መጥቀሳቸውን ብቻ ያቆማሉ።';

  @override
  String get txnPmNew => 'አዲስ የመክፈያ ዘዴ';

  @override
  String get txnPmEdit => 'የመክፈያ ዘዴ አስተካክል';

  @override
  String get txnRecentlyDeletedFooter =>
      'የተሰረዙ ግብይቶች ለሠላሳ ቀናት ይቆያሉ፣ ከዚያ ለዘለቄታው ይወገዳሉ።';

  @override
  String get txnUnknownCategory => 'ያልታወቀ';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'በትክክል ይህ';

  @override
  String get txnRuleContaining => 'ይህን የያዘ ማንኛውም';

  @override
  String get txnRulesFooter =>
      'ደንብ ትክክለኛ ካላደረጉት በርዕሱ ውስጥ በየትኛውም ቦታ ይዛመዳል። አንድን ነገር በእጅ በመደቡ ቁጥር መተግበሪያው አንድ ደንብ ያክልልዎታል።';

  @override
  String get txnRulesEmptyHint =>
      'አንድ ነገር የት እንደሚገባ ለመተግበሪያው አንድ ጊዜ ያስተምሩ፣ ከዚያ ጀምሮ በዚያው ይመድበዋል።';

  @override
  String get txnRuleNew => 'አዲስ ደንብ';

  @override
  String get txnRuleEdit => 'ደንብ አስተካክል';

  @override
  String get txnRuleExactHint => 'በትክክል ይህ የሆኑ ርዕሶች ብቻ';

  @override
  String get txnRuleContainingHint => 'ይህን የያዘ ማንኛውም ርዕስ';

  @override
  String get txnKindTransfer => 'በሂሳቦች መካከል ዝውውር';

  @override
  String get txnKindRecurring => 'ከተደጋጋሚ ግቤት';

  @override
  String get txnMoneyIn => 'ገቢ ገንዘብ';

  @override
  String get txnMoneyOut => 'ወጪ ገንዘብ';

  @override
  String get txnNotYetPaid => 'ገና አልተከፈለም';

  @override
  String get txnLentOut => 'የተበደረ';

  @override
  String get txnSettledInFull => 'ሙሉ በሙሉ ተከፍሏል።';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid ተመልሷል፣ $owed ገና ይቀራል።';
  }

  @override
  String get txnUncategorised => 'ምድብ የሌለው';

  @override
  String get txnUnknownAccount => 'ያልታወቀ';

  @override
  String get txnTransferCannotCopy => 'ዝውውር ብቻውን ሊቀዳ አይችልም።';

  @override
  String get txnCopied => 'ተቀድቷል።';

  @override
  String get txnDeleteOneBody =>
      'የሂሳቡ ቀሪ እንደገና ይሰላል። ይህ የዝውውር አንድ ክፍል ከሆነ፣ ሌላው ግማሽም አብሮ ይሄዳል።';

  @override
  String txnUpcomingTab(int count) {
    return 'መጪ ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'ጊዜው ያለፈበት ($count)';
  }

  @override
  String get txnNoOverdue => 'ጊዜው ያለፈበት ግብይት የለም';

  @override
  String get txnNoUpcoming => 'መጪ ግብይት የለም';

  @override
  String get txnNoOverdueBody => 'ሁሉም ክፍያዎችዎ በጊዜያቸው ናቸው!';

  @override
  String get txnNoUpcomingBody => 'የታቀደ በመጠባበቅ ላይ ያለ ክፍያ የለዎትም';

  @override
  String get txnTotalOverdue => 'ጠቅላላ ያለፈበት';

  @override
  String get txnTotalUpcoming => 'ጠቅላላ መጪ';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ንጥሎች',
      one: '1 ንጥል',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ቀናት አልፈዋል',
      one: '1 ቀን አልፏል',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '\"$title\" እንደተከፈለ ምልክት ተደርጓል';
  }

  @override
  String txnSkippedTitle(String title) {
    return '\"$title\" ታልፏል';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'ዛሬ፣ $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'ትናንት፣ $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'ነገ፣ $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'ግብይቱን በመሰረዝ ላይ ስህተት፦ $error';
  }

  @override
  String txnFilterTitle(String title) {
    return '$title አጣራ';
  }

  @override
  String get txnMonthlyIncome => 'ወርሃዊ ገቢ';

  @override
  String get txnMonthlyExpenses => 'ወርሃዊ ወጪዎች';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ግብይቶች',
      one: 'ግብይት',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'በአንድ ግብይት አማካይ';

  @override
  String get txnNoPlannedIncome => 'የታቀደ ገቢ የለም';

  @override
  String get txnNoPlannedExpenses => 'የታቀደ ወጪ የለም';

  @override
  String txnAddFutureIncome(String month) {
    return 'ለ$month የወደፊት ገቢ ያክሉ';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'ለ$month የወደፊት ወጪዎችን ያክሉ';
  }

  @override
  String get txnNoIncomeYet => 'በዚህ ወር ገና ገቢ የለም';

  @override
  String get txnNoExpensesYet => 'በዚህ ወር ገና ወጪ የለም';

  @override
  String get txnStartTrackingIncome => 'በዚህ ወር ገቢዎን መከታተል ይጀምሩ';

  @override
  String get txnStartTrackingExpenses => 'በዚህ ወር ወጪዎችዎን መከታተል ይጀምሩ';

  @override
  String txnNoIncomeIn(String month) {
    return 'በ$month ገቢ የለም';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'በ$month ወጪ የለም';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'ለ$month ምንም መዝገብ የለም';
  }

  @override
  String get txnOtherCategory => 'ሌላ';

  @override
  String get txnSearchIncome => 'ገቢ ፈልግ';

  @override
  String get txnSearchExpenses => 'ወጪዎችን ፈልግ';

  @override
  String txnErrorWith(String error) {
    return 'ስህተት፦ $error';
  }

  @override
  String get txnTapToEditAmount => 'መጠኑን ለማስተካከል ይንኩ';

  @override
  String get txnTapToEnterAmount => 'መጠን ለማስገባት ይንኩ';

  @override
  String get txnSpecialDefault => 'መደበኛ';

  @override
  String get txnSpecialRepetitive => 'ተደጋጋሚ';

  @override
  String get txnRepeatSettings => 'የድግግሞሽ ቅንብሮች';

  @override
  String get txnSubscriptionSettings => 'የምዝገባ ቅንብሮች';

  @override
  String txnEndsOn(String date) {
    return 'ያበቃል፦ $date';
  }

  @override
  String get txnNoEndDate => 'የማብቂያ ቀን የለም';

  @override
  String get txnEditTransaction => 'ግብይት አስተካክል';

  @override
  String get txnNewTransaction => 'አዲስ ግብይት';

  @override
  String get txnFromAccount => 'ከሂሳብ';

  @override
  String get txnToAccount => 'ወደ ሂሳብ';

  @override
  String get txnAmountReceived => 'የተቀበለው መጠን';

  @override
  String txnAmountReceivedHint(String account) {
    return 'እነዚህ ሂሳቦች በተለያዩ ምንዛሬዎች ይቆጥራሉ። በ$account ውስጥ በትክክል የገባውን ያስገቡ፣ ወይም የመተግበሪያውን ተመን ለመጠቀም ባዶ ይተዉት።';
  }

  @override
  String txnInCurrency(String currency) {
    return 'በ$currency';
  }

  @override
  String get txnTransferTitleHint => 'ለምሳሌ ወደ ቁጠባ ማዛወር (አማራጭ)';

  @override
  String get txnTitleHint => 'ለምን ነበር?';

  @override
  String get txnUpdate => 'አዘምን';

  @override
  String get txnSelectCategory => 'ምድብ ይምረጡ';

  @override
  String get txnSearchTransactions => 'ግብይቶችን ፈልግ';

  @override
  String get txnSpecialRegular => 'መደበኛ';

  @override
  String get txnSpecialLend => 'አበድር';

  @override
  String get txnSpecialBorrow => 'ተበደር';

  @override
  String get txnSpecialRegularDesc => 'መደበኛ ግብይት';

  @override
  String get txnSpecialUpcomingDesc => 'የሚከታተሉት የወደፊት ክፍያ';

  @override
  String get txnSpecialSubscriptionDesc => 'ተደጋጋሚ የአገልግሎት ክፍያ';

  @override
  String get txnSpecialRepetitiveDesc => 'ተደጋጋሚ ግብይት';

  @override
  String get txnSpecialLendDesc => 'ያበደሩት ገንዘብ (ዕዳ አለባቸው)';

  @override
  String get txnSpecialBorrowDesc => 'የተበደሩት ገንዘብ (ዕዳ አለብዎት)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'ዝቅተኛው ገደብ ከከፍተኛው በላይ ነው፣ ስለዚህ ምንም ሊዛመድ አይችልም። $min እስከ $max።';
  }

  @override
  String get walletMyWallet => 'የእኔ ቦርሳ';

  @override
  String walletCreateFailed(String error) {
    return 'ቦርሳውን መፍጠር አልተቻለም፦ $error';
  }

  @override
  String get walletTypeBankAccount => 'የባንክ ሂሳብ';

  @override
  String get walletTypeCreditCard => 'ክሬዲት ካርድ';

  @override
  String get walletTypeSubscription => 'ምዝገባ';

  @override
  String get walletTypeDeposit => 'ተቀማጭ';

  @override
  String get walletTypeInvestment => 'ኢንቨስትመንት';

  @override
  String get walletTypeAsset => 'ንብረት';

  @override
  String get walletEnterAccountName => 'እባክዎ የሂሳብ ስም ያስገቡ';

  @override
  String get walletCreditLimitRequired => 'የክሬዲት ገደብ ያስፈልጋል';

  @override
  String get walletEnterValidCreditLimit => 'እባክዎ ትክክለኛ የክሬዲት ገደብ ያስገቡ';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'እባክዎ ከ0 በላይ የሆነ ትክክለኛ የክሬዲት ገደብ ያስገቡ';

  @override
  String get walletEditWallet => 'ቦርሳ አስተካክል';

  @override
  String get walletAddNewWallet => 'አዲስ ቦርሳ ያክሉ';

  @override
  String get walletEnterWalletNameError => 'እባክዎ የቦርሳ ስም ያስገቡ';

  @override
  String get walletEnterValidNumber => 'እባክዎ ትክክለኛ ቁጥር ያስገቡ';

  @override
  String get walletShowCents => 'ሳንቲሞችን አሳይ (ለምሳሌ \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'ሙሉ ቁጥሮች ብቻ (ለምሳሌ \$1,235)';

  @override
  String get walletCreateWallet => 'ቦርሳ ፍጠር';

  @override
  String get walletClosedPill => 'ተዘግቷል። ታሪኩ ይቀመጣል፣ ግን አይቀርብም ወይም አይቆጠርም።';

  @override
  String get walletExcludedPill => 'ከሁሉም ሂሳቦች ጠቅላላ ውጭ ተደርጓል።';

  @override
  String get walletReopen => 'እንደገና ክፈት';

  @override
  String get walletCloseAccount => 'ሂሳብ ዝጋ';

  @override
  String get walletReopenSubtitle => 'እንደገና አቅርበው እና ቁጠረው';

  @override
  String get walletCloseAccountSubtitle => 'ታሪኩን አቆይ፣ መቁጠር አቁም';

  @override
  String get walletIncludeInTotal => 'በጠቅላላው ውስጥ አካት';

  @override
  String get walletLeaveOutOfTotal => 'ከጠቅላላው ውጭ አድርግ';

  @override
  String get walletAlreadyTheBalance => 'ይህ አስቀድሞ ቀሪ ሂሳቡ ነው።';

  @override
  String get walletCorrectionRecorded => 'ልዩነቱ እንደ ማስተካከያ ተመዝግቧል።';

  @override
  String walletMergeConfirmBody(String name) {
    return 'በ$name የተመዘገበው ሁሉ ይዛወራል፣ $name ይዘጋል። ምንም አይሰረዝም።';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'መጠኖች ሲዛወሩ ከ$from ወደ $to ይቀየራሉ። ምንም አይሰረዝም፣ $name ከመወገድ ይልቅ ይዘጋል።';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount በክሬዲት · $available ይገኛል';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount ዕዳ · $available ገና ይገኛል';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return '$name በትክክል የያዘውን ያስገቡ። ልዩነቱ እንደ ግብይት ይመዘገባል፣ ስለዚህ ሂሳቡ ከታሪኩ ጋር ይስማማል።';
  }

  @override
  String get apiUpdateRequired =>
      'ማመሳሰሉን ለመቀጠል The Accountantን ያዘምኑ። እስኪያዘምኑ ድረስ ሁሉም ነገር በዚህ ስልክ ላይ ይቆያል።';

  @override
  String get apiAccountExistsLink =>
      'በዚህ ኢሜይል መለያ አስቀድሞ አለ። እባክዎ መለያዎችዎን ያገናኙ።';

  @override
  String get apiServerTrouble =>
      'አገልጋያችን አሁን ችግር አጋጥሞታል። ሁሉም ነገር በዚህ ስልክ ላይ ደህና ነው፤ ከጥቂት ደቂቃዎች በኋላ እንደገና ይሞክሩ።';

  @override
  String apiRequestFailedHttp(String status) {
    return 'ጥያቄው አልተሳካም (HTTP $status)።';
  }

  @override
  String get apiServerTimeout =>
      'አገልጋያችን ለመመለስ በጣም ዘገየ። ግንኙነትዎን ያረጋግጡ፣ ወይም ከጥቂት ደቂቃዎች በኋላ እንደገና ይሞክሩ።';

  @override
  String get apiCannotReachServer =>
      'አገልጋያችንን ማግኘት አልተቻለም። ግንኙነትዎን ያረጋግጡ፤ ኢንተርኔት ካለዎት ከጥቂት ደቂቃዎች በኋላ እንደገና ይሞክሩ።';

  @override
  String get apiSomethingWentWrong =>
      'ከአገልጋያችን ጋር ስንገናኝ ችግር ተፈጥሯል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get syncAlreadyInProgress => 'ማመሳሰል አስቀድሞ በሂደት ላይ ነው';

  @override
  String get syncRequiresPremium => 'የክላውድ ማመሳሰል የPremium ምዝገባ ይፈልጋል';

  @override
  String get syncNoInternet => 'የኢንተርኔት ግንኙነት የለም';

  @override
  String get syncNotAuthenticated => 'አልገቡም';

  @override
  String get syncCouldNotFetchCloud =>
      'የክላውድ ውሂብዎን ማምጣት አልተቻለም። በስልኩ ያለው ውሂብ አልተለወጠም።';

  @override
  String get syncAccountUnknown => 'የገባውን መለያ መለየት አልተቻለም፤ ማመሳሰሉ ተሰርዟል።';

  @override
  String get syncStoreOtherAccount =>
      'የዚህ መሣሪያ ውሂብ የሌላ መለያ ነው። ከማመሳሰልዎ በፊት በዚያ መለያ ይግቡ፣ ወይም የመሣሪያውን ውሂብ ያጽዱ።';

  @override
  String syncRecordsNotSaved(String record) {
    return 'አንዳንድ የክላውድ መዝገቦች በዚህ መሣሪያ ላይ ሊቀመጡ አልቻሉም፦ $record። በሚቀጥለው ማመሳሰል እንደገና ይሞከራሉ።';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'አንዳንድ የክላውድ መዝገቦች በዚህ መሣሪያ ላይ ሊቀመጡ አልቻሉም፦ $record (እና ሌሎች $count)። በሚቀጥለው ማመሳሰል እንደገና ይሞከራሉ።';
  }

  @override
  String notifCardStatementReady(String name) {
    return 'የ$name መግለጫ ዝግጁ ነው';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'ድምሩ $amount ነው፤ አስቀድሞ ተከፍሏል። ሌላ የሚከፈል የለም።';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount እስከ $date መከፈል አለበት።';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return 'ከ$owed ውስጥ $paid አስቀድሞ ተከፍሏል።';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return 'የ$name ሂሳብ ነገ ይከፈላል';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return 'የ$name ሂሳብ በ$days ቀናት ውስጥ ይከፈላል';
  }

  @override
  String notifPayBy(String amount, String date) {
    return '$amount እስከ $date ይክፈሉ።';
  }

  @override
  String notifCardDueToday(String name) {
    return 'የ$name ሂሳብ ዛሬ ይከፈላል';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount ገና አልተከፈለም።$paidSoFar ዛሬ መክፈል የዘገየ ክፍያ ቅጣትን ያስቀራል።';
  }

  @override
  String get notifWhenToday => 'ዛሬ';

  @override
  String get notifWhenTomorrow => 'ነገ';

  @override
  String notifWhenInDays(int days) {
    return 'በ$days ቀናት ውስጥ';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name $when ይከፈላል';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount በ$date ወደ $account ይገባል።';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name $when ይበስላል';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount በ$date ወደ $account ይመለሳል።';
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
      'dps': 'ተቀማጭ',
      'insurance': 'የኢንሹራንስ ክፍያ',
      'sip': 'SIP',
      'other': 'ክፍያ',
    });
    return '$name፦ $_temp0 $number ከ$total $when ይከፈላል';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return '$amount እስከ $date ኢንቨስት ያድርጉ።';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount በ$date ከ$account ኢንቨስት ይደረጋል።';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount በ$date ከ$account ይመዘገባል።';
  }

  @override
  String get notifYourAccount => 'ሂሳብዎ';

  @override
  String get notifPlansUpdatedTitle => 'የተከፋፈለ ክፍያና ቁጠባ ተዘምኗል';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count የዕቅድ ግቤቶች በቀናቸው ተመዝግበዋል።',
      one: '1 የዕቅድ ግቤት በቀኑ ተመዝግቧል።',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'ተደጋጋሚ ግብይቶች ተመዝግበዋል';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ተደጋጋሚ ግብይቶች ተመዝግበዋል።',
      one: '1 ተደጋጋሚ ግብይት ተመዝግቧል።',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'የሚረጋገጡ $count ክፍያዎች',
      one: 'የሚረጋገጥ 1 ክፍያ',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody => 'የተቆረጠውን ያረጋግጡ፣ ወይም ይዝለሉት፣ በመጪ ውስጥ።';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — የተቆረጠውን ያረጋግጡ፣ ወይም ይዝለሉት፣ በመጪ ውስጥ።';
  }

  @override
  String get notifUpcomingFallbackTitle => 'መጪ ግብይት';

  @override
  String notifUpcomingTitle(String title) {
    return 'መጪ፦ $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return '$amount ገቢ በቅርቡ ይጠበቃል።';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return '$amount ወጪ በቅርቡ ይከፈላል።';
  }

  @override
  String get notifCreditFallback => 'ብድር';

  @override
  String get notifDebtFallback => 'ዕዳ';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'ጊዜው ያለፈበት ብድር፦ $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'ጊዜው ያለፈበት ዕዳ፦ $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount ገና አልተከፈለም። ለማየት ይንኩ።';
  }

  @override
  String get notifRecurringFallbackTitle => 'ተደጋጋሚ ግብይት';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'መጪ ተደጋጋሚ፦ $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount በ$date ይከፈላል።';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'የሚከፈል ብድር፦ $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'የሚከፈል ዕዳ፦ $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'የሚከፈል ምዝገባ፦ $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'የሚከፈል ሂሳብ፦ $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'በቅርቡ የሚከፈል፦ $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'ተደጋጋሚ ሂሳብ';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount በቅርቡ ይከፈላል። ለማየት ይንኩ።';
  }

  @override
  String get notifChannelRecurring => 'ተደጋጋሚ ግብይቶች';

  @override
  String get notifChannelRecurringDesc => 'በራሱ ለተፈጠሩ ተደጋጋሚ ግብይቶች ማሳወቂያዎች';

  @override
  String get notifChannelUpcoming => 'የመጪ አስታዋሾች';

  @override
  String get notifChannelUpcomingDesc => 'ለመጪ ግብይቶች አስታዋሾች';

  @override
  String get notifChannelLoan => 'የብድር አስታዋሾች';

  @override
  String get notifChannelLoanDesc => 'ጊዜያቸው ላለፈ ብድሮችና ዕዳዎች አስታዋሾች';

  @override
  String get notifChannelDueDate => 'የመክፈያ ቀን አስታዋሾች';

  @override
  String get notifChannelDueDateDesc => 'ለተወሰኑ የግብይት መክፈያ ቀናት የአንድ ጊዜ አስታዋሾች';

  @override
  String get notifChannelBillsDesc => 'የሚደርሱ የክሬዲት ካርድ ሂሳቦችና የዕቅድ ክፍያዎች';

  @override
  String get notifOffset1Hour => 'ከ1 ሰዓት በፊት';

  @override
  String get notifOffset1Day => 'ከ1 ቀን በፊት';

  @override
  String get notifOffset3Days => 'ከ3 ቀናት በፊት';

  @override
  String get notifOffset1Week => 'ከ1 ሳምንት በፊት';

  @override
  String notifOffsetMinutes(int minutes) {
    return 'ከ$minutes ደቂቃ በፊት';
  }

  @override
  String get notifChannelGeneral => 'አጠቃላይ';

  @override
  String get notifChannelGeneralDesc => 'የመለያ እና የመተግበሪያ ማሳወቂያዎች';

  @override
  String get notifChannelReminders => 'ዕለታዊ አስታዋሾች';

  @override
  String get notifChannelRemindersDesc => 'የዕለቱን ወጪ ለመመዝገብ ማስታወሻ';

  @override
  String get notifChannelBillsStatementsDesc => 'የክሬዲት ካርድ መግለጫዎችና የመክፈያ ቀናት';

  @override
  String get notifChannelBudgets => 'የበጀት ማንቂያዎች';

  @override
  String get notifChannelBudgetsDesc => 'በጀት ሊያልቅ ሲቃረብ ወይም ሲያልቅ';

  @override
  String notifOverBudgetTitle(String name) {
    return 'ከበጀት በላይ፦ $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'የበጀት ማንቂያ፦ $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'ለዚህ ጊዜ ከ$name በጀትዎ $percent% አውጥተዋል።';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'ከ$name በጀትዎ $percent% ተጠቅመዋል።';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium በቅርቡ ያበቃል';

  @override
  String get notifPremiumEndsTomorrow =>
      'Premiumዎ ነገ ያበቃል። የPremium ባህሪያትዎን ለማቆየት ያድሱ።';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'Premiumዎ በ$days ቀናት ውስጥ ያበቃል። የPremium ባህሪያትዎን ለማቆየት ያድሱ።';
  }

  @override
  String get notifLargeIncomeTitle => 'የትልቅ ገቢ ማንቂያ';

  @override
  String get notifLargeExpenseTitle => 'የትልቅ ወጪ ማንቂያ';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return '$amount ገቢ ተመዝግቧል፦ $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return '$amount ገቢ ተመዝግቧል';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return '$amount ወጪ ተመዝግቧል፦ $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return '$amount ወጪ ተመዝግቧል';
  }

  @override
  String get notifChannelDailyRemindersDesc => 'የዕለት ወጪ አስታዋሽ ማሳወቂያዎች';

  @override
  String get notifDailyReminderTitle => 'የዕለት ወጪ አስታዋሽ';

  @override
  String get notifDailyReminderBody => 'የዛሬ ወጪዎችዎን መመዝገብ አይርሱ! ወጪዎን ይከታተሉ።';

  @override
  String get notifTestTitle => 'የሙከራ ማሳወቂያ';

  @override
  String get notifTestBody => 'ይህን ካዩ፣ ማሳወቂያዎች እየሠሩ ነው!';

  @override
  String get notifActionSnooze1Day => '1 ቀን አቆይ';

  @override
  String get notifActionSnooze1Week => '1 ሳምንት አቆይ';

  @override
  String get notifGroupThisWeek => 'በዚህ ሳምንት';

  @override
  String get notifGroupThisMonth => 'በዚህ ወር';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date $time ላይ';
  }

  @override
  String notifMinutesAgo(int count) {
    return 'ከ$count ደቂቃ በፊት';
  }

  @override
  String notifHoursAgo(int count) {
    return 'ከ$count ሰዓት በፊት';
  }

  @override
  String notifDaysAgo(int count) {
    return 'ከ$count ቀን በፊት';
  }

  @override
  String get notifPrimerSheetBody =>
      'ማሳወቂያዎችን ያብሩ፤ አስፈላጊ ስለሆኑ ነገሮች አስቀድመን እናሳውቅዎታለን።';

  @override
  String get notifPrimerBudgetsBody => 'በጀትዎን ከማለፍዎ በፊት ይወቁ።';

  @override
  String get notifPrimerBillsTitle => 'የሂሳብ እና የምዝገባ አስታዋሾች';

  @override
  String get notifPrimerBillsBody => 'ተደጋጋሚ ክፍያ በጭራሽ አያምልጥዎ።';

  @override
  String get notifPrimerLargeTitle => 'ትልልቅ ግብይቶች';

  @override
  String get notifPrimerLargeBody => 'ስለ ያልተለመደ እንቅስቃሴ ማሳወቂያ ያግኙ።';

  @override
  String get notifLoadFailed => 'ማሳወቂያዎችን መጫን አልተቻለም';

  @override
  String get startupReasonSomethingWrong =>
      'በመጀመር ላይ ችግር ተፈጥሯል። ውሂብዎ በዚህ መሣሪያ ላይ ደህና ነው።';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'የዚህን መለያ የመሣሪያ ውሂብ መክፈት አልተቻለም።';

  @override
  String get startupReasonSetupFailed =>
      'ይህን መለያ በዚህ መሣሪያ ላይ ማዘጋጀት መጨረስ አልቻልንም። ምንም ነገር አልተሰረዘም።';

  @override
  String get startupReasonOffline =>
      'መለያዎን ማግኘት አልቻልንም፤ ይህ መሣሪያም ገና ውሂቡ የለውም። ከዚህ በፊት The Accountantን ከተጠቀሙ፣ ከኢንተርኔት ጋር ይገናኙ፤ ውሂብዎን እንመልሳለን። አዲስ ነዎት? አሁኑኑ በዚህ መሣሪያ መጀመር ይችላሉ።';

  @override
  String get startupReasonNeedsSubscription =>
      'ይህ መለያ በክላውድ የተቀመጠ ውሂብ አለው። ለመመለስ ንቁ ምዝገባ ያስፈልጋል። ምንም ነገር አልተሰረዘም።';

  @override
  String get startupReasonConfirmingSubscription =>
      'ይህ መለያ በክላውድ ውሂብ አለው። ለመመለስ እንዲቻል ምዝገባዎን ገና እያረጋገጥን ነው።';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'መመለስ አልተሳካም፦ $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'ይህ መለያ በክላውድ ውሂብ አለው፤ ግን ገና ሊመለስ አልቻለም።';

  @override
  String get commonBiometricReason => 'The Accountantን ለመክፈት ማንነትዎን ያረጋግጡ';

  @override
  String get commonLoadCurrenciesFailed => 'ምንዛሪዎችን መጫን አልተቻለም';

  @override
  String get commonLoadRatesFailed => 'የምንዛሪ ተመኖችን መጫን አልተቻለም';

  @override
  String get commonRefreshRatesFailed => 'የምንዛሪ ተመኖችን ማደስ አልተቻለም';

  @override
  String get commonAllCategories => 'ሁሉም ምድቦች';

  @override
  String commonCategoryCount(int count) {
    return '$count ምድቦች';
  }

  @override
  String get commonTierFree => 'ነፃ';

  @override
  String get commonTierMonthly => 'Premium ወርሃዊ';

  @override
  String get commonTierYearly => 'Premium ዓመታዊ';

  @override
  String get commonTierLifetime => 'Premium ዕድሜ ልክ';

  @override
  String get commonCategoryMergeSelf => 'ምድብ ከራሱ ጋር ሊዋሃድ አይችልም።';

  @override
  String get commonCategoryMergeMissing => 'ለማዋሃድ ሁለቱም ምድቦች መኖር አለባቸው።';

  @override
  String get commonCategoryMergeSystem => 'የመተግበሪያው የራሱ ምድቦች ሊዋሃዱ አይችሉም።';

  @override
  String get commonCategoryMergeKinds => 'የገቢ እና የወጪ ምድቦች ሊዋሃዱ አይችሉም።';

  @override
  String get commonCategoryOneLevel =>
      'ያ ምድብ በሌላ ምድብ ውስጥ ነው፤ ምድቦች አንድ ደረጃ ብቻ ናቸው።';

  @override
  String get commonCategoryMoveSame => 'ለማዛወር የተለየ ምድብ ይምረጡ።';

  @override
  String get commonCategoryMoveMissing => 'በመካከላቸው ለማዛወር ሁለቱም ምድቦች መኖር አለባቸው።';

  @override
  String get commonCategoryMoveSystem => 'በመተግበሪያው የራሱ ምድቦች መካከል ማዛወር አይቻልም።';

  @override
  String get commonCategoryMoveKinds => 'የገቢ እና የወጪ ግብይቶች ምድብ ሊለዋወጡ አይችሉም።';

  @override
  String get commonCategoryGone => 'ያ ምድብ ከእንግዲህ የለም።';

  @override
  String get commonCategoryParentSystem => 'የመተግበሪያው የራሱ ምድቦች ሊዛወሩ አይችሉም።';

  @override
  String get commonCategoryParentSelf => 'ምድብ በራሱ ውስጥ ሊሆን አይችልም።';

  @override
  String get commonCategoryParentIntoSystem =>
      'በመተግበሪያው የራሱ ምድቦች ውስጥ ምንም ማስቀመጥ አይቻልም።';

  @override
  String get commonCategoryParentKinds =>
      'የገቢ ምድብ እና የወጪ ምድብ አንዱ በሌላው ውስጥ ሊሆኑ አይችሉም።';

  @override
  String get commonCategoryHasChildren =>
      'ይህ ምድብ የራሱ ንዑስ ምድቦች ስላሉት በላይኛው ደረጃ ይቆያል።';

  @override
  String get commonTapToChange => 'ለመቀየር ይንኩ';

  @override
  String get commonSelectColor => 'ቀለም ይምረጡ';

  @override
  String get commonShowPalette => 'የቀለም ሰሌዳ አሳይ';

  @override
  String get commonCustomColor => 'ብጁ ቀለም';

  @override
  String get commonSelectCurrency => 'ምንዛሪ ይምረጡ';

  @override
  String get commonEnableCryptoHint =>
      'የክሪፕቶ ቶከኖችን ለመፈለግ \'የክሪፕቶ ምንዛሪዎችን አካትት\'ን ያብሩ።';

  @override
  String get commonSearchHint => 'ፈልግ...';

  @override
  String get aiLoadConversationsFailed => 'ውይይቶችን መጫን አልተቻለም።';

  @override
  String get aiLoadHistoryFailed => 'የውይይት ታሪክን መጫን አልተቻለም።';

  @override
  String get aiPremiumRequired => 'ለAI ረዳት የPremium ምዝገባ ያስፈልጋል';

  @override
  String get aiUnexpectedError => 'ያልተጠበቀ ስህተት ተፈጥሯል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get aiResponseFailed => 'የAI ምላሽ ማግኘት አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get aiServiceNotAnswering => 'የAI አገልግሎቱ እየመለሰ አይደለም።';

  @override
  String get aiReplyCutOff => 'ምላሹ ተቋርጧል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get aiCouldNotReachServer =>
      'አገልጋዩን ማግኘት አልተቻለም። ግንኙነትዎን ያረጋግጡና እንደገና ይሞክሩ።';

  @override
  String get aiSomethingWentWrong => 'ችግር ተፈጥሯል።';

  @override
  String get aiOpenConversationFailed => 'ውይይቱን መክፈት አልተቻለም።';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ለውጦችዎ ተቀምጠዋል፣ ግን አማካሪው ምላሹን መጨረስ አልቻለም። እንደገና ከመጠየቅዎ በፊት በመዝገቦችዎ ውስጥ ያረጋግጧቸው።',
      one:
          'ለውጥዎ ተቀምጧል፣ ግን አማካሪው ምላሹን መጨረስ አልቻለም። እንደገና ከመጠየቅዎ በፊት በመዝገቦችዎ ውስጥ ያረጋግጡት።',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'የAI አገልግሎቱ አሁን እየመለሰ አይደለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String aiMinutesShort(int count) {
    return '$count ደ';
  }

  @override
  String aiHoursShort(int count) {
    return '$count ሰ';
  }

  @override
  String aiDaysShort(int count) {
    return '$count ቀ';
  }

  @override
  String get aiOcrTextFailed => 'ከምስሉ ጽሑፍ ማውጣት አልተቻለም';

  @override
  String get aiOcrReceiptFailed => 'ከምስሉ የደረሰኝ መረጃ ማውጣት አልተቻለም';

  @override
  String get coachYes => 'አዎ';

  @override
  String get coachNo => 'አይ';

  @override
  String get coachTradeBuy => 'ግዢ';

  @override
  String get coachTradeSell => 'ሽያጭ';

  @override
  String get coachTradeDividend => 'ትርፍ ድርሻ';

  @override
  String get planAccountGone => 'ያ ሂሳብ ከእንግዲህ የለም።';

  @override
  String get planPaidFromOrdinary => 'ዕቅድ የሚከፈለው ከተራ ሂሳብ ነው፣ ከተቀማጭ አይደለም።';

  @override
  String get planSipChooseHolding => 'SIP የሚገዛውን ፈንድ ወይም አክሲዮን ይምረጡ።';

  @override
  String get planSipPayFromOther => 'ለSIP ከሌላ ሂሳብ ይክፈሉ።';

  @override
  String get planNeedNameError => 'ለዕቅዱ ስም ይስጡት።';

  @override
  String get planInstallmentCountRange => 'የክፍያ ክፍሎቹ ብዛት ከ1 እስከ 1200 መሆን አለበት።';

  @override
  String get planIntervalMin => 'ክፍተቱ ቢያንስ 1 መሆን አለበት።';

  @override
  String get planRateRange => 'መጠኑ ከ0 እስከ 100 በመቶ መሆን አለበት።';

  @override
  String get planTaxRange => 'ግብሩ ከ0 እስከ 100 በመቶ መሆን አለበት።';

  @override
  String get planProviderTooLong => 'የኩባንያውን ስም እና ቁጥሩን ከ100 ፊደላት በታች ያድርጉ።';

  @override
  String get planNeedPremium => 'አረቦኑን ያስገቡ።';

  @override
  String get planNeedInstallmentAmount => 'የእያንዳንዱን ክፍያ መጠን ያስገቡ።';

  @override
  String get planNeedDeposited => 'የተቀመጠውን መጠን ያስገቡ።';

  @override
  String get planTermMonthsOrYears => 'የሚቆየው ለወራት ወይም ለዓመታት ነው።';

  @override
  String get planAmountNotNegative => 'መጠኑ አሉታዊ መሆን አይችልም።';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name በ$date ይበስላል። ከዚያ በፊት ገንዘቡን ለማውጣት ቀደም ብለው ይዝጉት።';
  }

  @override
  String get planNoLongerExists => 'ያ ዕቅድ ከእንግዲህ የለም።';

  @override
  String get planReminderDaysRange =>
      'አስታዋሾች ከ0 (ጠፍቷል) እስከ 30 ቀናት በፊት ሊሆኑ ይችላሉ።';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name አሁንም ገንዘብ ይዟል። መጀመሪያ ይዝጉት፤ ይህም ገንዘቡን ወደ $account ይመልሰዋል።';
  }

  @override
  String get planItsAccount => 'ሂሳቡ';

  @override
  String planAlreadyEnded(String name) {
    return '$name አስቀድሞ አብቅቷል።';
  }

  @override
  String get investNeedName => 'ለኢንቨስትመንቱ ስም ይስጡት።';

  @override
  String get investNameTooLong => 'ስሙን ከ100 ፊደላት በታች ያድርጉ።';

  @override
  String get investSymbolTooLong => 'ምልክቱን ከ20 ፊደላት በታች ያድርጉ።';

  @override
  String get investPriceNotNegative => 'ዋጋ አሉታዊ መሆን አይችልም።';

  @override
  String investAlreadyTracked(String name) {
    return '$name አስቀድሞ እየተከታተለ ነው።';
  }

  @override
  String get investNeedPaid => 'የተከፈለውን ያስገቡ።';

  @override
  String get investUnitsBoughtPositive => 'የተገዙ ዩኒቶች ከዜሮ በላይ መሆን አለባቸው።';

  @override
  String get investPayFromOther => 'ከሌላ ሂሳብ ይክፈሉ።';

  @override
  String get investNeedSaleAmount => 'ሽያጩ ያስገኘውን ያስገቡ።';

  @override
  String get investUnitsSoldPositive => 'የተሸጡ ዩኒቶች ከዜሮ በላይ መሆን አለባቸው።';

  @override
  String get investSellIntoOther => 'ወደ ሌላ ሂሳብ ይሽጡ።';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'ከ$name የተያዙት $units ዩኒቶች ብቻ ናቸው።';
  }

  @override
  String get investNeedDividend => 'የተቀበሉትን ትርፍ ድርሻ ያስገቡ።';

  @override
  String get investReceiveIntoOrdinary => 'ወደ ተራ ሂሳብ ይቀበሉት።';

  @override
  String get investPricePositive => 'ዋጋ ከዜሮ በላይ መሆን አለበት።';

  @override
  String get investUnitsPositive => 'ዩኒቶች ከዜሮ በላይ መሆን አለባቸው።';

  @override
  String get investNotATrade => 'ያ የኢንቨስትመንት ግብይት አይደለም።';

  @override
  String investStillHoldsUnits(String name) {
    return '$name አሁንም ዩኒቶች አሉት። መጀመሪያ ይሽጧቸው።';
  }

  @override
  String get investNoLongerExists => 'ያ ኢንቨስትመንት ከእንግዲህ የለም።';

  @override
  String get networthNeedAssetName => 'ለንብረቱ ስም ይስጡት።';

  @override
  String get networthValueNotNegative => 'ዋጋ አሉታዊ መሆን አይችልም።';

  @override
  String get networthNeedPaidFor => 'ለእሱ የተከፈለውን ያስገቡ።';

  @override
  String get networthPayFromOrdinary => 'ከተራ ሂሳብ ይክፈሉ።';

  @override
  String get networthNeedWorth => 'ዋጋውን ያስገቡ።';

  @override
  String get networthNeedSoldFor => 'የተሸጠበትን ዋጋ ያስገቡ።';

  @override
  String get networthReceiveIntoOrdinary => 'ገንዘቡን ወደ ተራ ሂሳብ ይቀበሉ።';

  @override
  String networthStillWorth(String name) {
    return '$name አሁንም ዋጋ አለው። መጀመሪያ ይሽጡት ወይም ዋጋውን ዜሮ ያድርጉት።';
  }

  @override
  String get networthAssetGone => 'ያ ንብረት ከእንግዲህ አይከታተልም።';

  @override
  String get zakatNeedAmountPaid => 'የተከፈለውን መጠን ያስገቡ።';

  @override
  String get zakatPayFromOrdinary => 'ከተራ ሂሳብ ይክፈሉት።';

  @override
  String get zakatReminderTitleToday => 'ዘካዎ ዛሬ ይከፈላል';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ዘካ በ$count ቀናት ውስጥ ይከፈላል',
      one: 'ዘካ በ1 ቀን ውስጥ ይከፈላል',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday => 'የዘካ ዓመትዎ ዛሬ ይጠናቀቃል። የሚከፈለውን ለማየት ይንኩ።';

  @override
  String zakatReminderBodyOn(String date) {
    return 'የዘካ ዓመትዎ በ$date ይጠናቀቃል። የሚከፈለውን ለማየት ይንኩ።';
  }

  @override
  String get budgetCheckFailed => 'በጀቶችን መፈተሽ አልተሳካም';

  @override
  String get budgetLoadFailed => 'በጀቶችን መጫን አልተሳካም';

  @override
  String get budgetAddFailed => 'በጀት ማከል አልተሳካም';

  @override
  String get budgetNotFound => 'በጀቱ አልተገኘም';

  @override
  String get budgetUpdateFailed => 'በጀቱን ማዘመን አልተሳካም';

  @override
  String get budgetDeleteFailed => 'በጀቱን መሰረዝ አልተሳካም';

  @override
  String get budgetEdit => 'በጀት አርትዕ';

  @override
  String get budgetNeedName => 'ለበጀቱ ስም ይስጡት';

  @override
  String get budgetEnterAmount => 'መጠን ያስገቡ';

  @override
  String get budgetAmountMoreThanZero => 'መጠኑ ከዜሮ በላይ መሆን አለበት';

  @override
  String get budgetTrackingEarnings => 'ገቢን መከታተል';

  @override
  String get budgetTrackingSpending => 'ወጪን መከታተል';

  @override
  String get budgetRepeats => 'ይደገማል';

  @override
  String get budgetTooBig => 'በጣም ትልቅ';

  @override
  String get budgetStarts => 'ይጀምራል';

  @override
  String get budgetEnds => 'ያበቃል';

  @override
  String get budgetStopsRepeating => 'መደገም ያቆማል';

  @override
  String get budgetNever => 'በፍጹም';

  @override
  String get budgetCategoriesAll => 'ምድቦች፦ ሁሉም';

  @override
  String budgetCategoriesSelected(int count) {
    return 'ምድቦች፦ $count ተመርጠዋል';
  }

  @override
  String get budgetNoIncomeCategories => 'እስካሁን የገቢ ምድቦች የሉም።';

  @override
  String get budgetNoExpenseCategories => 'እስካሁን የወጪ ምድቦች የሉም።';

  @override
  String get budgetCategoriesHint =>
      'ሁሉንም ምድቦች ለመከታተል ባዶ ይተዉት። በተመረጠ ምድብ ውስጥ የተመዘገበ ማንኛውም ነገርም ይቆጠራል።';

  @override
  String get budgetAccountsAll => 'ሂሳቦች፦ ሁሉም';

  @override
  String budgetAccountsSelected(int count) {
    return 'ሂሳቦች፦ $count ተመርጠዋል';
  }

  @override
  String get budgetRolloverHint =>
      'ያልወጣ ማንኛውም ገንዘብ ወደሚቀጥለው ጊዜ ይጨመራል። ማለፍ ግን ዕዳን ወደፊት አያሸጋግርም።';

  @override
  String get budgetPeriodDaily => 'ዕለታዊ';

  @override
  String get budgetPeriodFortnightly => 'በየሁለት ሳምንቱ';

  @override
  String get budgetPeriodOneOff => 'አንድ ጊዜ';

  @override
  String get budgetUnitDays => 'ቀናት';

  @override
  String get budgetUnitWeeks => 'ሳምንታት';

  @override
  String get budgetUnitFortnights => 'ሁለት ሳምንታት';

  @override
  String get budgetUnitMonths => 'ወራት';

  @override
  String get budgetUnitYears => 'ዓመታት';

  @override
  String get budgetOneOffNeedsEnd => 'የአንድ ጊዜ በጀት የማብቂያ ቀን ያስፈልገዋል።';

  @override
  String get budgetEndAfterStart => 'የማብቂያ ቀኑ ከመጀመሪያው ቀን በኋላ መሆን አለበት።';

  @override
  String get budgetSaveFailed => 'በጀቱን ማስቀመጥ አልተቻለም።';

  @override
  String get budgetThisPeriod => 'ይህ ጊዜ';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ከ$count ጊዜያት በፊት',
      one: 'ከ1 ጊዜ በፊት',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return 'ከ$start እስከ $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'ከ$limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'ከ$limit፣ ከቀዳሚው የተሸጋገረ $carriedን ጨምሮ';
  }

  @override
  String get budgetUncategorised => 'ያልተመደበ';

  @override
  String budgetOverTheLimit(String amount) {
    return 'ከገደቡ $amount በላይ።';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left ቀርቷል፣ በቀን $daily ገደማ።';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left ቀርቷል።';
  }

  @override
  String budgetAveraging(String amount) {
    return 'በአማካይ በየጊዜው $amount።';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'ወደ $amount ብልጫ እያመራ ነው';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'በዚህ ፍጥነት፣ ጊዜው ከማብቃቱ በፊት አስቀድሞ የታቀደውን $scheduled ጨምሮ።';
  }

  @override
  String get budgetForecastPlain => 'በዚህ ፍጥነት፣ በጊዜው መጨረሻ።';

  @override
  String get budgetCapsExplain =>
      'በጀት ጊዜው ከመጠን በላይ ወጪ እንደተደረገበት ይነግራል። ገደብ ደግሞ የት እንደሆነ ይነግራል፦ በአጠቃላይ በትክክለኛ መንገድ ላይ ያለ የምግብ በጀት አብዛኛው አሁንም ከውጭ የታዘዘ ምግብ ሊሆን ይችላል።';

  @override
  String get budgetPercentOfBudget => 'የበጀቱ መቶኛ';

  @override
  String get budgetArchivedTitle => 'በማህደር የተቀመጡ በጀቶች';

  @override
  String get budgetShowActive => 'ንቁዎቹን አሳይ';

  @override
  String get budgetShowArchived => 'በማህደር የተቀመጡትን አሳይ';

  @override
  String get budgetUnpin => 'ንቀል';

  @override
  String get budgetPinToTop => 'ከላይ ሰካ';

  @override
  String get budgetStartCounting => 'እንደገና መቁጠር ጀምር';

  @override
  String get budgetStopCounting => 'ታሪኩን አቆይ፣ መቁጠሩን አቁም';

  @override
  String get budgetDeleteBody =>
      'በጀቱ ይሰረዛል፣ ግብይቶችዎ ይቀራሉ። የመዘገቡት ምንም ነገር አይወገድም።';

  @override
  String get budgetNothingArchived => 'በማህደር የተቀመጠ ነገር የለም';

  @override
  String get budgetNoneYet => 'እስካሁን በጀት የለም';

  @override
  String get budgetArchivedEmptyHint => 'በማህደር ያስቀመጧቸው በጀቶች እዚህ ይቀመጣሉ።';

  @override
  String get budgetEmptyHint =>
      'ለአንድ ምድብ ገደብ ያስቀምጡ እና ወሩ እንዴት እየሄደ እንደሆነ ይመልከቱ።';

  @override
  String dashLoadFailed(String error) {
    return 'የፋይናንስ መረጃን መጫን አልተሳካም፦ $error';
  }

  @override
  String get categoryUnknown => 'ያልታወቀ';

  @override
  String dashCardAvailable(String amount) {
    return 'ያለ፦ $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'በትርፍ ላይ · ያለ፦ $amount';
  }

  @override
  String get dashTypeBank => 'ባንክ';

  @override
  String get dashTypeCredit => 'ክሬዲት';

  @override
  String get dashTypeSubs => 'ምዝገባ';

  @override
  String get dashTypeDeposit => 'ተቀማጭ';

  @override
  String get dashTypeInvest => 'ኢንቨስት';

  @override
  String get dashTypeAsset => 'ንብረት';

  @override
  String get dashAddAccountTile => 'ሂሳብ\nአክል';

  @override
  String get categoryLoadFailed => 'ምድቦችን መጫን አልተሳካም';

  @override
  String get categoryAddFailed => 'ምድብ ማከል አልተሳካም';

  @override
  String get categoryNotFound => 'ምድቡ አልተገኘም';

  @override
  String get categoryUpdateFailed => 'ምድቡን ማዘመን አልተሳካም';

  @override
  String get categoryCannotDeleteSystem => 'የመተግበሪያውን የራሱ ምድቦች መሰረዝ አይቻልም';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'ግብይቶች ያሉበትን ምድብ መሰረዝ አይቻልም፤ መጀመሪያ ያዛውሯቸው ወይም ይሰርዟቸው';

  @override
  String get categoryDeleteFailed => 'ምድቡን መሰረዝ አልተሳካም';

  @override
  String categorySaveFailed(String error) {
    return 'ምድቡን ማስቀመጥ አልተሳካም፦ $error';
  }

  @override
  String get categoryEditTitle => 'ምድብ አርትዕ';

  @override
  String get categoryNewTitle => 'አዲስ ምድብ';

  @override
  String get categoryPartOf => 'የዚህ አካል';

  @override
  String get categoryNamePlaceholder => 'የምድብ ስም';

  @override
  String get categoryUpdate => 'ምድቡን አዘምን';

  @override
  String get categoryCreate => 'ምድብ ፍጠር';

  @override
  String reportLoadFailed(String error) {
    return 'ሪፖርቶችን መጫን አልተሳካም፦ $error';
  }

  @override
  String get goalEdit => 'ግብ አርትዕ';

  @override
  String get goalNeedName => 'ለግቡ ስም ይስጡት';

  @override
  String get goalTargetMoreThanZero => 'ዒላማው ከዜሮ በላይ መሆን አለበት';

  @override
  String get goalNoDeadline => 'የጊዜ ገደብ የለም';

  @override
  String get goalTargetDateAfterStart => 'የዒላማው ቀን ከመጀመሪያው ቀን በኋላ መሆን አለበት።';

  @override
  String get goalSaveFailed => 'ግቡን ማስቀመጥ አልተቻለም።';

  @override
  String get goalArchivedTitle => 'በማህደር የተቀመጡ ግቦች';

  @override
  String get goalHideFromHome => 'ከመነሻ ገጽ ደብቅ';

  @override
  String get goalShowOnHome => 'በመነሻ ገጽ አሳይ';

  @override
  String get goalReached => 'ደርሷል';

  @override
  String goalToGo(String amount) {
    return '$amount ቀርቷል';
  }

  @override
  String get goalNoneYet => 'እስካሁን ግብ የለም';

  @override
  String get goalArchivedEmptyHint => 'በማህደር ያስቀመጧቸው ግቦች እዚህ ይቀመጣሉ።';

  @override
  String get goalEmptyHint => 'የሚቆጥቡለትን ነገር ይሰይሙ፣ ከዚያ ወደ እሱ የሚሄዱትን ግብይቶች ያገናኙ።';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return 'ከ$target $saved';
  }

  @override
  String goalOfTarget(String target) {
    return 'ከ$target';
  }

  @override
  String get goalReachedNicelyDone => 'ደርሷል። ጥሩ ሠርተዋል።';

  @override
  String goalStillToGo(String amount) {
    return 'አሁንም $amount ቀርቷል።';
  }

  @override
  String goalDailyToArrive(String amount) {
    return 'በሰዓቱ ለመድረስ በቀን $amount።';
  }

  @override
  String get goalNothingLinked =>
      'እስካሁን ምንም አልተገናኘም። በአንድ ግብይት ላይ ይህን ግብ ይምረጡ፣ እዚህ ይታያል።';

  @override
  String get goalDeleteBody => 'ግቡ ይሰረዛል፣ ግብይቶችዎ ይቀራሉ። ከእንግዲህ ለእሱ አይቆጠሩም።';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ክፍያዎች፣ እያንዳንዱ $amount',
      one: '1 ክፍያ፣ $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'በ$date አካባቢ ይጠናቀቃል።';
  }

  @override
  String goalNotFound(String id) {
    return 'ግቡ አልተገኘም፦ $id';
  }

  @override
  String get goalPaidOff => 'ተከፍሎ አልቋል!';

  @override
  String get goalCompleted => 'ተጠናቋል!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% ተጠናቋል';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ሳምንታት ቀርተዋል',
      one: '1 ሳምንት ቀርቷል',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ወራት ቀርተዋል',
      one: '1 ወር ቀርቷል',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return '$years ዓመታት ቀርተዋል';
  }

  @override
  String get subRecurringBill => 'ተደጋጋሚ ሂሳብ';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ቀናት',
      one: 'በየ1 ቀኑ',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ሳምንታት',
      one: 'በየ1 ሳምንቱ',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ወራት',
      one: 'በየ1 ወሩ',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'በየ$count ዓመታት',
      one: 'በየ1 ዓመቱ',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'በየ$count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'ምዝገባዎችን መጫን አልተሳካም፦ $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'ምዝገባውን ማቆም አልተሳካም፦ $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'ምዝገባውን መቀጠል አልተሳካም፦ $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'ምዝገባውን ማዘመን አልተሳካም፦ $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'ምዝገባውን መሰረዝ አልተሳካም፦ $error';
  }

  @override
  String subActiveCount(int count) {
    return 'ንቁ ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'የቆሙ ($count)';
  }

  @override
  String get subEmptyTitle => 'ምዝገባዎች ወይም ሂሳቦች የሉም';

  @override
  String get subEmptyBody => 'እዚህ ለመከታተል የምዝገባ ወይም ተደጋጋሚ ሂሳብ ግብይቶችን ያክሉ';

  @override
  String get subRecurringCost => 'ተደጋጋሚ ወጪ';

  @override
  String subPerYear(String amount) {
    return '$amount / ዓመት';
  }

  @override
  String get subActive => 'ንቁ';

  @override
  String subNext(String date) {
    return 'ቀጣይ $date';
  }

  @override
  String get subResume => 'ቀጥል';

  @override
  String get subPause => 'አቁም';

  @override
  String get subCancelBillTitle => 'ተደጋጋሚ ሂሳብ ሰርዝ';

  @override
  String get subCancelSubTitle => 'ምዝገባ ሰርዝ';

  @override
  String subCancelConfirm(String name) {
    return '\"$name\"ን መሰረዝ እንደሚፈልጉ እርግጠኛ ነዎት? ይህ ሁሉንም የወደፊት ተደጋጋሚ ክፍያዎች ያቆማል።';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" ተሰርዟል';
  }

  @override
  String subSaveError(String error) {
    return 'ስህተት፦ $error';
  }

  @override
  String get subEditBill => 'ተደጋጋሚ ሂሳብ አርትዕ';

  @override
  String get subEditSub => 'ምዝገባ አርትዕ';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ቀናት',
      one: 'ቀን',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ሳምንታት',
      one: 'ሳምንት',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ወራት',
      one: 'ወር',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ዓመታት',
      one: 'ዓመት',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'ያበቃል፦ $date';
  }

  @override
  String get subNoEndDate => 'የማብቂያ ቀን የለም';
}
