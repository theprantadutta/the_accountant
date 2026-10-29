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
}
