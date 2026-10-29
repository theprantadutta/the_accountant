// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class L10nHi extends L10n {
  L10nHi([String locale = 'hi']) : super(locale);

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get dateToday => 'आज';

  @override
  String get dateYesterday => 'कल';

  @override
  String get dateTomorrow => 'आने वाला कल';

  @override
  String get navTransactions => 'लेन-देन';

  @override
  String get settingsRegionalTitle => 'क्षेत्रीय सेटिंग्स';

  @override
  String get settingsSectionCurrency => 'मुद्रा';

  @override
  String get settingsSectionDisplayFormat => 'डिस्प्ले फ़ॉर्मेट';

  @override
  String get settingsSectionLanguage => 'भाषा';

  @override
  String get settingsDefaultCurrency => 'डिफ़ॉल्ट मुद्रा';

  @override
  String get settingsExchangeRates => 'विनिमय दरें';

  @override
  String get settingsExchangeRatesSubtitle => 'मुद्रा बदलने की दरें संभालें';

  @override
  String get settingsDateFormat => 'तारीख़ फ़ॉर्मेट';

  @override
  String get settingsNumberFormat => 'संख्या फ़ॉर्मेट';

  @override
  String get settingsCurrencySymbol => 'मुद्रा चिह्न';

  @override
  String get settingsTimeFormat => 'समय फ़ॉर्मेट';

  @override
  String get settingsFirstDayOfWeek => 'हफ़्ते का पहला दिन';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsPreview => 'पूर्वावलोकन';

  @override
  String get previewDate => 'तारीख़';

  @override
  String get previewTime => 'समय';

  @override
  String get previewAmount => 'राशि';

  @override
  String get previewWeekStarts => 'यह हफ़्ता शुरू होता है';

  @override
  String get choiceMatchMyPhone => 'फ़ोन के अनुसार';

  @override
  String get symbolBeforeAmount => 'राशि से पहले';

  @override
  String get symbolAfterAmount => 'राशि के बाद';

  @override
  String get time12Hour => '12-घंटे (1:30 PM)';

  @override
  String get time24Hour => '24-घंटे (13:30)';

  @override
  String get weekdayMonday => 'सोमवार';

  @override
  String get weekdaySaturday => 'शनिवार';

  @override
  String get weekdaySunday => 'रविवार';

  @override
  String get selectDateFormat => 'तारीख़ फ़ॉर्मेट चुनें';

  @override
  String get selectNumberFormat => 'संख्या फ़ॉर्मेट चुनें';

  @override
  String get selectCurrency => 'मुद्रा चुनें';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get languageSystem => 'फ़ोन के अनुसार';

  @override
  String get sectionAccount => 'खाता';

  @override
  String get sectionDataManagement => 'डेटा प्रबंधन';

  @override
  String get sectionHelpSupport => 'मदद और सहायता';

  @override
  String get settingsAppearance => 'रूप-रंग';

  @override
  String get settingsBackupRestore => 'बैकअप और रिस्टोर';

  @override
  String get settingsBackupRestoreSubtitle =>
      'आपके पास रखी फ़ाइल, या Google Drive में अपने-आप बनी कॉपी';

  @override
  String get settingsImportStatement => 'स्टेटमेंट इम्पोर्ट करें';

  @override
  String get settingsImportStatementSubtitle =>
      'अपने बैंक की CSV लाएँ, एक बार मैप करें और वह याद रहेगी';

  @override
  String get settingsExportData => 'डेटा एक्सपोर्ट करें';

  @override
  String get settingsRecentlyDeleted => 'हाल ही में हटाए गए';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'पिछले तीस दिनों में हटाई गई चीज़ वापस लाएँ';

  @override
  String get themePremiumHeading => 'Premium थीम';

  @override
  String get actionRetry => 'फिर से कोशिश करें';

  @override
  String get dashCreditDebt => 'उधार और कर्ज़';

  @override
  String get dashSubscriptions => 'सब्सक्रिप्शन';

  @override
  String get moneyIncome => 'आय';

  @override
  String get dashExpenses => 'ख़र्च';

  @override
  String get dashSpendingOverview => 'ख़र्च का सारांश';

  @override
  String get dashBudgetProgress => 'बजट प्रगति';

  @override
  String get actionDelete => 'हटाएँ';

  @override
  String txDeleteManyTitle(int count) {
    return '$count लेन-देन हटाएँ?';
  }

  @override
  String get txDeleteManyBody =>
      'बैलेंस दोबारा गिने जाएँगे। इनमें कोई ट्रांसफ़र हो तो उसका दूसरा हिस्सा भी हट जाएगा।';

  @override
  String get txMoveToAccount => 'खाते में ले जाएँ';

  @override
  String get txDeleted => 'लेन-देन हटाया गया';

  @override
  String txDeleteFailed(String error) {
    return 'यह लेन-देन हटाया नहीं जा सका: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get txActions => 'कार्रवाइयाँ';

  @override
  String get txChangeCategory => 'श्रेणी बदलें';

  @override
  String get txChangeDate => 'तारीख़ बदलें';

  @override
  String get txMarkAsPaid => 'भुगतान हुआ मानें';

  @override
  String get txMarkAsCorrection => 'बैलेंस सुधार मानें';

  @override
  String get txMarkAsCorrectionTitle => 'न आय, न ख़र्च?';

  @override
  String get txMarkAsCorrectionBody =>
      'इसे उस पैसे के लिए इस्तेमाल करें जो न कमाया गया, न ख़र्च हुआ, जैसे कार्ड की लिमिट बढ़ना। बैलेंस वही रहता है; बस यह आय या ख़र्च में नहीं गिना जाता।';

  @override
  String get txMarkedAsCorrection => 'अब यह बैलेंस सुधार है।';

  @override
  String get txMarkAsCorrectionFailed => 'इसे सुधार नहीं बनाया जा सकता।';

  @override
  String get txDuplicate => 'डुप्लिकेट';

  @override
  String get filterTitle => 'फ़िल्टर';

  @override
  String get filterDirection => 'दिशा';

  @override
  String get filterState => 'स्थिति';

  @override
  String get filterKind => 'प्रकार';

  @override
  String get filterTransfers => 'ट्रांसफ़र';

  @override
  String get filterAccounts => 'खाते';

  @override
  String get filterCategories => 'श्रेणियाँ';

  @override
  String get filterDates => 'तारीख़ें';

  @override
  String get filterBudget => 'बजट';

  @override
  String get filterGoal => 'लक्ष्य';

  @override
  String get filterNone => 'कोई नहीं';

  @override
  String get filterThisMonth => 'इस महीने';

  @override
  String get filterLastMonth => 'पिछले महीने';

  @override
  String get filterLast3Months => 'पिछले 3 महीने';

  @override
  String get filterThisYear => 'इस साल';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन दिखाएँ',
      one: '1 लेन-देन दिखाएँ',
      zero: 'कोई लेन-देन मेल नहीं खाता',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'साफ़ करें';

  @override
  String get filterNoMatches => 'कोई मेल नहीं';

  @override
  String get filterAny => 'कोई भी';

  @override
  String get filterSpent => 'ख़र्च किया';

  @override
  String get filterEarned => 'कमाया';

  @override
  String get filterHidden => 'छिपा हुआ';

  @override
  String get filterIncluded => 'शामिल';

  @override
  String get filterOnly => 'केवल';

  @override
  String get filterFrom => 'से';

  @override
  String get filterTo => 'तक';

  @override
  String get actionApply => 'लागू करें';

  @override
  String get filterPaid => 'भुगतान हुआ';

  @override
  String get filterNotYet => 'अभी नहीं';

  @override
  String get filterSkipped => 'छोड़ा गया';

  @override
  String get filterAmount => 'राशि';

  @override
  String get actionEdit => 'बदलें';

  @override
  String get entityBudget => 'बजट';

  @override
  String get budgetGone => 'यह बजट अब मौजूद नहीं है।';

  @override
  String get budgetEarlier => 'पहले';

  @override
  String get budgetLater => 'बाद में';

  @override
  String get budgetWhereItWent => 'पैसा कहाँ गया';

  @override
  String get budgetRecentPeriods => 'हाल की अवधियाँ';

  @override
  String get budgetCaps => 'सीमाएँ';

  @override
  String get actionAdd => 'जोड़ें';

  @override
  String get budgetNoCategoriesToCap =>
      'इस बजट में अभी सीमा लगाने के लिए कोई श्रेणी नहीं है।';

  @override
  String get budgetCapACategory => 'श्रेणी पर सीमा लगाएँ';

  @override
  String get entityCategory => 'श्रेणी';

  @override
  String get budgetAsShare => 'बजट के हिस्से के रूप में';

  @override
  String get budgetAsShareHint => 'बजट बदलने पर यह भी बदलता है';

  @override
  String get actionSet => 'सेट करें';

  @override
  String get budgetAcrossPeriod => 'पूरी अवधि में';

  @override
  String get budgetPreviousPeriod => 'पिछली अवधि';

  @override
  String get budgetEvenPace => 'बराबर रफ़्तार';

  @override
  String get budgetNew => 'नया बजट';

  @override
  String get budgetCreate => 'बजट बनाएँ';

  @override
  String budgetDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get entityAccount => 'खाता';

  @override
  String get entityTransaction => 'लेन-देन';

  @override
  String get walletGone => 'यह खाता अब मौजूद नहीं है।';

  @override
  String get walletCorrectBalance => 'बैलेंस सुधारें';

  @override
  String get walletCorrectBalanceSubtitle =>
      'असली रक़म से जो अंतर है, उसे दर्ज करें';

  @override
  String get walletMergeInto => 'दूसरे खाते में मिलाएँ';

  @override
  String get walletInThisMonth => 'इस महीने आया';

  @override
  String get walletOutThisMonth => 'इस महीने गया';

  @override
  String get walletRecentActivity => 'हाल की गतिविधि';

  @override
  String get walletNoOtherAccount => 'मिलाने के लिए कोई दूसरा खाता नहीं है।';

  @override
  String get walletMergeIntoTitle => 'इसमें मिलाएँ';

  @override
  String get walletMergeAction => 'मिलाएँ';

  @override
  String walletMerged(int count, String target) {
    return '$count को $target में ले जाया गया।';
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
      other: 'दोनों खातों के बीच के $removed ट्रांसफ़र हटा दिए गए',
      one: 'दोनों खातों के बीच का एक ट्रांसफ़र हटा दिया गया',
    );
    return '$count को $target में ले जाया गया। $_temp0, क्योंकि उनके अब दो सिरे नहीं रहे।';
  }

  @override
  String get walletRealBalance => 'असली बैलेंस';

  @override
  String get walletCorrectAction => 'सुधारें';

  @override
  String get txGone => 'यह लेन-देन अब मौजूद नहीं है।';

  @override
  String get txKind => 'प्रकार';

  @override
  String get txState => 'स्थिति';

  @override
  String get txWasDue => 'देय था';

  @override
  String get txNotes => 'नोट्स';

  @override
  String get txDeleteOneTitle => 'यह लेन-देन हटाएँ?';

  @override
  String get rulesTitle => 'नामकरण नियम';

  @override
  String get rulesAdd => 'नियम जोड़ें';

  @override
  String rulesRemoved(String title) {
    return '$title का नियम हटाया गया';
  }

  @override
  String get rulesWhenTitleSays => 'जब शीर्षक में लिखा हो';

  @override
  String get rulesMatchExactly => 'पूरी तरह मेल खाए';

  @override
  String get rulesChooseCategory => 'श्रेणी चुनें';

  @override
  String get actionSave => 'सेव करें';

  @override
  String get goalNew => 'नया लक्ष्य';

  @override
  String get goalLoadFailed => 'आपके लक्ष्य लोड नहीं हो सके।';

  @override
  String get goalCreate => 'लक्ष्य बनाएँ';

  @override
  String get trashTitle => 'हाल ही में हटाए गए';

  @override
  String get trashRestore => 'वापस लाएँ';

  @override
  String get trashRestored => 'वापस लाया गया।';

  @override
  String get payTitle => 'भुगतान के तरीक़े';

  @override
  String get payDefault => 'डिफ़ॉल्ट';

  @override
  String get payAddOne => 'एक जोड़ें';

  @override
  String payDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get payName => 'नाम';

  @override
  String get payNameHint => 'रोज़ का डेबिट कार्ड';

  @override
  String get payKind => 'प्रकार';

  @override
  String get payBankOrIssuer => 'बैंक या जारीकर्ता';

  @override
  String get payLastFour => 'आख़िरी चार अंक';

  @override
  String get payUseByDefault => 'डिफ़ॉल्ट रूप से इस्तेमाल करें';

  @override
  String get backupChecking => 'जाँच हो रही है…';

  @override
  String get backupLoading => 'लोड हो रहा है…';

  @override
  String get backupSaveACopy => 'कॉपी सेव करें';

  @override
  String get backupAutomaticBackups => 'अपने-आप बैकअप';

  @override
  String get backupHowManyBackupsToKeep => 'कितने बैकअप रखें';

  @override
  String get backupSaveABackupFile => 'बैकअप फ़ाइल सेव करें';

  @override
  String get backupShareItToFilesEmail =>
      'इसे Files, ईमेल या कहीं भी शेयर करें';

  @override
  String get backupRestoreFromAFile => 'फ़ाइल से रिस्टोर करें';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'इस डिवाइस पर मौजूद सब कुछ बदल देगा';

  @override
  String get backupRestoreThisBackup => 'यह बैकअप रिस्टोर करें?';

  @override
  String get backupEraseRestore => 'मिटाएँ और रिस्टोर करें';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive उपलब्ध नहीं है';

  @override
  String get backupConnectGoogleDrive => 'Google Drive जोड़ें';

  @override
  String get backupBackUpNow => 'अभी बैकअप लें';

  @override
  String get backupKeep => 'रखें';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'पिछला अपने-आप होने वाला बैकअप नहीं चला';

  @override
  String get backupDisconnectGoogleDrive => 'Google Drive हटाएँ';

  @override
  String get backupDisconnectGoogleDrive2 => 'Google Drive से कनेक्शन हटाएँ?';

  @override
  String get backupDisconnect => 'कनेक्शन हटाएँ';

  @override
  String get backupDeleteThisBackup => 'यह बैकअप हटाएँ?';

  @override
  String get importChooseACsvFile => 'CSV फ़ाइल चुनें';

  @override
  String get importRememberTheseSettingsForThis =>
      'इस बैंक के लिए ये सेटिंग्स याद रखें';

  @override
  String get importChange => 'बदलें';

  @override
  String get importAuto => 'ऑटो';

  @override
  String get importDone => 'हो गया';

  @override
  String get importRememberThisBank => 'यह बैंक याद रखें';

  @override
  String get importForget => 'भूल जाएँ';

  @override
  String get importImport => 'इम्पोर्ट करें';

  @override
  String get settingsAbout => 'परिचय';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsTermsOfService => 'सेवा की शर्तें';

  @override
  String get settingsRefundPolicy => 'रिफ़ंड नीति';

  @override
  String get settingsOpenSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get settingsMeetTheDeveloper => 'डेवलपर से मिलें';

  @override
  String get settingsContactSupport => 'सहायता से संपर्क करें';

  @override
  String get settingsSubject => 'विषय';

  @override
  String get settingsMessage => 'संदेश';

  @override
  String get settingsSendMessage => 'संदेश भेजें';

  @override
  String get settingsUseApiRate => 'API दर इस्तेमाल करें';

  @override
  String get settingsRefreshRates => 'दरें ताज़ा करें';

  @override
  String get settingsSearchCurrencies => 'मुद्राएँ खोजें...';

  @override
  String get settingsCustomRate => 'अपनी दर';

  @override
  String get settingsSetCustomRate => 'अपनी दर सेट करें';

  @override
  String get settingsNotNow => 'अभी नहीं';

  @override
  String get settingsGoPremium => 'Premium लें';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Excel, Google Sheets के लिए स्प्रेडशीट फ़ॉर्मेट';

  @override
  String get settingsPdfReport => 'PDF रिपोर्ट';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'ब्योरे के साथ व्यवस्थित सारांश';

  @override
  String get settingsAllIncomeAndExpenseRecords => 'आय और ख़र्च के सभी रिकॉर्ड';

  @override
  String get settingsCategories => 'श्रेणियाँ';

  @override
  String get settingsCategoryBreakdownAndTotals => 'श्रेणी-वार ब्योरा और कुल';

  @override
  String get settingsWallets => 'वॉलेट';

  @override
  String get settingsWalletBalancesAndHistory => 'वॉलेट बैलेंस और इतिहास';

  @override
  String get settingsHelpFaq => 'मदद और FAQ';

  @override
  String get settingsNotifications => 'सूचनाएँ';

  @override
  String get settingsLargeTransactionThreshold => 'बड़े लेन-देन की सीमा';

  @override
  String get settingsRemindMeBeforeDueDate => 'नियत तारीख़ से पहले याद दिलाएँ';

  @override
  String get settingsDailyReminders => 'रोज़ के रिमाइंडर';

  @override
  String get settingsDailyReminders2 => 'रोज़ के रिमाइंडर';

  @override
  String get settingsGetRemindedToTrackYour =>
      'अपने ख़र्च दर्ज करने की याद पाएँ';

  @override
  String get settingsBudgetAlerts => 'बजट अलर्ट';

  @override
  String get settingsBudgetAlerts2 => 'बजट अलर्ट';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'बजट सीमा के क़रीब पहुँचने पर बताएँ';

  @override
  String get settingsWarningThreshold => 'चेतावनी सीमा';

  @override
  String get settingsTransactionAlerts => 'लेन-देन अलर्ट';

  @override
  String get settingsLargeTransactionAlerts => 'बड़े लेन-देन के अलर्ट';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'सीमा से ऊपर के लेन-देन पर बताएँ';

  @override
  String get settingsRecurringTransactionReminders =>
      'दोहराए जाने वाले लेन-देन के रिमाइंडर';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'आने वाले नियमित भुगतानों की याद दिलाएँ';

  @override
  String get settingsOtherNotifications => 'अन्य सूचनाएँ';

  @override
  String get settingsSubscriptionExpiryAlerts => 'सब्सक्रिप्शन समाप्ति अलर्ट';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Premium ख़त्म होने से पहले सूचना पाएँ';

  @override
  String get settingsPromotionalNotifications => 'प्रचार सूचनाएँ';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'ऑफ़र और नए फ़ीचर की जानकारी पाएँ';

  @override
  String get settingsTurnOnDailyReminders => 'रोज़ के रिमाइंडर चालू करें?';

  @override
  String get settingsEnterAmount => 'राशि डालें';

  @override
  String get settingsReminderTime => 'रिमाइंडर का समय';

  @override
  String get settingsPrivacySecurity => 'गोपनीयता और सुरक्षा';

  @override
  String get settingsSecurity => 'सुरक्षा';

  @override
  String get settingsBiometricLock => 'बायोमेट्रिक लॉक';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'फ़िंगरप्रिंट या चेहरे से अनलॉक करें';

  @override
  String get settingsAutoLock => 'ऑटो-लॉक';

  @override
  String get settingsDataPrivacy => 'डेटा गोपनीयता';

  @override
  String get settingsClearCache => 'कैश साफ़ करें';

  @override
  String get settingsClearCachedDataAndForce =>
      'कैश डेटा साफ़ करें और दोबारा सिंक करें';

  @override
  String get settingsClearAllData => 'सारा डेटा साफ़ करें';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'सभी लेन-देन, बजट और सेटिंग्स हटाएँ';

  @override
  String get settingsDangerZone => 'ख़तरनाक क्षेत्र';

  @override
  String get settingsDeleteAccount => 'खाता हटाएँ';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'अपना खाता और सारा डेटा हमेशा के लिए हटाएँ';

  @override
  String get settingsAutoLockTimeout => 'ऑटो-लॉक समय';

  @override
  String get settingsDeleteEverything => 'सब कुछ हटाएँ';

  @override
  String get settingsAreYouAbsolutelySure => 'क्या आप पूरी तरह पक्का हैं?';

  @override
  String get settingsYesDeleteAll => 'हाँ, सब हटाएँ';

  @override
  String get settingsContinue => 'जारी रखें';

  @override
  String get settingsEditProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get settingsDisplayName => 'दिखने वाला नाम';

  @override
  String get settingsEmailAddress => 'ईमेल पता';

  @override
  String get settingsUnsavedChanges => 'बिना सेव किए बदलाव';

  @override
  String get settingsStay => 'रुकें';

  @override
  String get settingsLeave => 'छोड़ें';

  @override
  String get settingsSearchByCodeOrName => 'कोड या नाम से खोजें...';

  @override
  String get settingsSearchSettings => 'सेटिंग्स खोजें...';

  @override
  String get settingsSubscription => 'सब्सक्रिप्शन';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsGoals => 'लक्ष्य';

  @override
  String get settingsCardsInNetWorth => 'नेट वर्थ में क्रेडिट कार्ड गिनें';

  @override
  String get settingsCardsInNetWorthSub =>
      'बंद: केवल आपके पास का पैसा गिना जाता है, कार्ड बैलेंस नहीं।';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'किसी चीज़ के लिए बचत करें और देखें कितना पहुँचे';

  @override
  String get settingsBudgets => 'बजट';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'सीमाएँ तय करें और देखें अवधि कैसी चल रही है';

  @override
  String get settingsUpcomingAndOverdue => 'आने वाले और बकाया';

  @override
  String get settingsWhatIsDueAndWhat => 'क्या देय है, और क्या छूट गया';

  @override
  String get settingsAccounts => 'खाते';

  @override
  String get settingsAddReorderAndEditYour =>
      'अपने खाते जोड़ें, क्रम बदलें और संपादित करें';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'जिन कार्ड और खातों से आप भुगतान करते हैं';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'नाम के आधार पर कोई चीज़ कहाँ जाए';

  @override
  String get settingsNotificationSettings => 'सूचना सेटिंग्स';

  @override
  String get settingsCloudSync => 'क्लाउड सिंक';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'अपना डेटा सभी डिवाइस पर सिंक करें';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV मुफ़्त है · PDF रिपोर्ट Premium है';

  @override
  String get settingsQuestionsComplaintsOrFeedback => 'सवाल, शिकायत या सुझाव';

  @override
  String get settingsRateTheApp => 'ऐप को रेट करें';

  @override
  String get settingsShareWithFriends => 'दोस्तों के साथ शेयर करें';

  @override
  String get settingsReplayAppTour => 'ऐप टूर फिर से देखें';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'फ़ीचर की जानकारी फिर से देखें';

  @override
  String get settingsAboutTheAccountant => 'The Accountant के बारे में';

  @override
  String get settingsVersionLicensesAndMore => 'वर्ज़न, लाइसेंस और बहुत कुछ';

  @override
  String get settingsTestCrash => 'टेस्ट क्रैश';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Crashlytics के लिए टेस्ट एक्सेप्शन चलाएँ';

  @override
  String get settingsDeveloper => 'डेवलपर';

  @override
  String get settingsRestoreFromCloud => 'क्लाउड से रिस्टोर करें?';

  @override
  String get settingsSyncing => 'सिंक हो रहा है...';

  @override
  String get settingsSynced => 'सिंक हो गया';

  @override
  String get settingsSyncError => 'सिंक त्रुटि';

  @override
  String get syncBackgroundFailed =>
      'सिंक नहीं हो सका। आपके बदलाव इस डिवाइस पर सुरक्षित हैं और बाद में सिंक होंगे।';

  @override
  String get settingsOffline => 'ऑफ़लाइन';

  @override
  String get settingsReady => 'तैयार';

  @override
  String get settingsYesUseThis => 'हाँ, यही इस्तेमाल करें';

  @override
  String get settingsKeepThemSeparate => 'इन्हें अलग रखें?';

  @override
  String get settingsCurrentPassword => 'मौजूदा पासवर्ड';

  @override
  String get settingsNewPassword => 'नया पासवर्ड';

  @override
  String get settingsConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get walletEGPersonalSavingsBusiness => 'जैसे, निजी, बचत, कारोबार';

  @override
  String get walletEnterCreditLimit => 'क्रेडिट लिमिट डालें';

  @override
  String get walletSelectBillingDay => 'बिलिंग का दिन चुनें';

  @override
  String get walletCreateAccount => 'खाता बनाएँ';

  @override
  String get walletWalletCreatedSuccessfully => 'वॉलेट बन गया';

  @override
  String get walletAccountUpdatedSuccessfully => 'खाता अपडेट हो गया';

  @override
  String get walletEditAccount => 'खाता बदलें';

  @override
  String get walletSetAsDefault => 'डिफ़ॉल्ट बनाएँ';

  @override
  String get walletUseDecimals => 'दशमलव इस्तेमाल करें';

  @override
  String get walletEnterWalletName => 'वॉलेट का नाम डालें';

  @override
  String get walletCurrency => 'मुद्रा';

  @override
  String get walletIcon => 'आइकन';

  @override
  String get walletColor => 'रंग';

  @override
  String get walletWalletName => 'वॉलेट का नाम';

  @override
  String get walletInitialBalance => 'शुरुआती बैलेंस';

  @override
  String get txAddATransferFee => 'ट्रांसफ़र शुल्क जोड़ें';

  @override
  String get txRemove => 'हटाएँ';

  @override
  String get txPaymentMethod => 'भुगतान का तरीक़ा';

  @override
  String get txObjective => 'उद्देश्य';

  @override
  String get txTitle => 'शीर्षक';

  @override
  String get txTesco => 'बिग बाज़ार';

  @override
  String get txAll => 'सभी';

  @override
  String get txSkip => 'छोड़ें';

  @override
  String get txMarkAsPaid2 => 'भुगतान हुआ मानें';

  @override
  String get txConfirmPayment => 'भुगतान की पुष्टि करें';

  @override
  String get txAmountCharged => 'कटी हुई राशि';

  @override
  String get txUndo => 'पूर्ववत करें';

  @override
  String get txNoLoan => 'कोई लोन नहीं';

  @override
  String get txLentMoney => 'उधार दिया पैसा';

  @override
  String get txBorrowedMoney => 'उधार लिया पैसा';

  @override
  String get goalShowOnTheHomeScreen => 'होम स्क्रीन पर दिखाएँ';

  @override
  String get goalWhatAreYouSavingFor => 'आप किसके लिए बचत कर रहे हैं?';

  @override
  String get goalNewLaptop => 'नया लैपटॉप';

  @override
  String get goalTarget => 'लक्ष्य राशि';

  @override
  String get goalColour => 'रंग';

  @override
  String get goalClear => 'साफ़ करें';

  @override
  String get goalGoal => 'लक्ष्य';

  @override
  String get goalThisGoalNoLongerExists => 'यह लक्ष्य अब मौजूद नहीं है।';

  @override
  String get goalAddToGoal => 'लक्ष्य में जोड़ें';

  @override
  String get goalUnlink => 'अलग करें';

  @override
  String get reportUpgrade => 'अपग्रेड करें';

  @override
  String get budgetSpending => 'ख़र्च';

  @override
  String get budgetEarnings => 'कमाई';

  @override
  String get budgetEvery => 'हर';

  @override
  String get budgetCarryOverWhatIsLeft => 'बचा हुआ आगे ले जाएँ';

  @override
  String get budgetGroceries => 'किराना';

  @override
  String get authLinkYourAccount => 'अपना खाता जोड़ें';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authLinkAccount => 'खाता जोड़ें';

  @override
  String get authEmailAddress => 'ईमेल पता';

  @override
  String get authSendResetCode => 'रीसेट कोड भेजें';

  @override
  String get authResetCode => 'रीसेट कोड';

  @override
  String get authResetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get authWelcomeBack => 'फिर से स्वागत है';

  @override
  String get authSignInToContinueYour =>
      'अपना वित्तीय सफ़र जारी रखने के लिए साइन इन करें';

  @override
  String get authSignIn => 'साइन इन';

  @override
  String get authJoinUsToStartYour =>
      'अपना वित्तीय सफ़र शुरू करने के लिए जुड़ें';

  @override
  String get authFullName => 'पूरा नाम';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'मासिक';

  @override
  String get premiumYearly => 'सालाना';

  @override
  String get premiumLifetime => 'आजीवन';

  @override
  String get premiumNotNow => 'अभी नहीं';

  @override
  String get aiRename => 'नाम बदलें';

  @override
  String get aiRenameChat => 'चैट का नाम बदलें';

  @override
  String get aiDeleteChat => 'चैट हटाएँ?';

  @override
  String get aiChatName => 'चैट का नाम';

  @override
  String get aiScanReceipt => 'रसीद स्कैन करें';

  @override
  String get aiCamera => 'कैमरा';

  @override
  String get aiGallery => 'गैलरी';

  @override
  String get aiMerchantTitle => 'दुकान / शीर्षक';

  @override
  String get aiSaveAsTransaction => 'लेन-देन के रूप में सेव करें';

  @override
  String get onboardBrowseThemes => 'थीम देखें';

  @override
  String get onboardBack => 'वापस';

  @override
  String get onboardGetStarted => 'शुरू करें';

  @override
  String get onboardMainAccount => 'मुख्य खाता';

  @override
  String get creditRecordPayment => 'भुगतान दर्ज करें';

  @override
  String get creditPleaseEnterAValidAmount => 'कृपया सही राशि डालें';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'राशि बाक़ी बैलेंस से ज़्यादा है';

  @override
  String get creditPaymentAmount => 'भुगतान राशि';

  @override
  String get creditPaidOn => 'भुगतान की तारीख़';

  @override
  String get creditFullAmount => 'पूरी राशि';

  @override
  String get subSubscriptionName => 'सब्सक्रिप्शन का नाम';

  @override
  String get subAskBeforeEachPayment => 'हर भुगतान दर्ज करने से पहले पूछें';

  @override
  String get subAskBeforeEachPaymentHint =>
      'हर भुगतान \'आने वाले\' में तब तक रुका रहता है जब तक आप कटी राशि की पुष्टि न करें, या उसे छोड़ न दें। बदलती रक़म वाले चार्ज के लिए सबसे अच्छा, जैसे दूसरी मुद्रा में भुगतान वाला कार्ड।';

  @override
  String get subChangesApplyFromNext =>
      'नई राशि या खाता अगले भुगतान से लागू होगा। पहले हो चुके भुगतान वैसे ही रहेंगे।';

  @override
  String get catPleaseEnterACategoryName => 'कृपया श्रेणी का नाम डालें';

  @override
  String get catEnterCategoryName => 'श्रेणी का नाम डालें';

  @override
  String get catSearch => 'श्रेणियाँ खोजें';

  @override
  String get catNoMatch => 'कोई श्रेणी मेल नहीं खाती।';

  @override
  String get catUseEmoji => 'इमोजी इस्तेमाल करें';

  @override
  String get catEmojiHint => 'एक इमोजी लिखें या चुनें';

  @override
  String get catArchive => 'संग्रह करें';

  @override
  String get catMergeInto => 'इसमें मिलाएँ…';

  @override
  String catMergeIntoTitle(String name) {
    return '$name को इसमें मिलाएँ';
  }

  @override
  String get catMergeBuiltIn => 'पहले से मौजूद';

  @override
  String get catMergeNoTargets =>
      'मिलाने के लिए उसी प्रकार की कोई दूसरी श्रेणी नहीं है।';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return '$from को $to में मिलाएँ?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return '$from के सभी लेन-देन, बजट और उप-श्रेणियाँ $to में चली जाएँगी, और $from हट जाएगी। यह आपके दूसरे डिवाइस पर भी सिंक होगा।';
  }

  @override
  String get catMergeAction => 'मिलाएँ';

  @override
  String catMerged(String from, String to) {
    return '$from को $to में मिला दिया।';
  }

  @override
  String get catExpenseSection => 'ख़र्च की श्रेणियाँ';

  @override
  String get catIncomeSection => 'आय की श्रेणियाँ';

  @override
  String get catSectionEmpty => 'अभी कोई नहीं';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उप-श्रेणियाँ',
      one: '1 उप-श्रेणी',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन',
      one: '1 लेन-देन',
      zero: 'कोई लेन-देन नहीं',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return '$name में';
  }

  @override
  String get catAddSubcategory => 'उप-श्रेणी जोड़ें';

  @override
  String get catNoSubcategoriesYet => 'अभी कोई उप-श्रेणी नहीं। एक जोड़ें';

  @override
  String get catMoveTo => 'यहाँ ले जाएँ…';

  @override
  String catMoveToTitle(String name) {
    return '$name को यहाँ ले जाएँ';
  }

  @override
  String get catTopLevel => 'सबसे ऊपरी स्तर';

  @override
  String get catTopLevelHint => 'किसी श्रेणी के अंदर नहीं';

  @override
  String catMovedInto(String name, String parent) {
    return '$name अब $parent में है।';
  }

  @override
  String catMovedToTop(String name) {
    return '$name अब ऊपरी स्तर की श्रेणी है।';
  }

  @override
  String get catMoveNoParents => 'ऐसी कोई श्रेणी नहीं जिसके अंदर यह जा सके।';

  @override
  String get catMoveTransactions => 'लेन-देन ले जाएँ…';

  @override
  String catMoveTransactionsTitle(String name) {
    return '$name के लेन-देन यहाँ ले जाएँ';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन $to में ले जाएँ?',
      one: '1 लेन-देन $to में ले जाएँ?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'केवल लेन-देन जाएँगे। $from अपने बजट और उप-श्रेणियों के साथ बनी रहेगी। यह आपके दूसरे डिवाइस पर भी सिंक होगा।';
  }

  @override
  String get catMoveAction => 'ले जाएँ';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन $to में ले जाए गए।',
      one: '1 लेन-देन $to में ले जाया गया।',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name में ले जाने के लिए कोई लेन-देन नहीं है।';
  }

  @override
  String get catNoMoveTargets =>
      'इन्हें ले जाने के लिए उसी प्रकार की कोई दूसरी श्रेणी नहीं है।';

  @override
  String catDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get catDeleteEmptyBody =>
      'इसमें कोई लेन-देन नहीं है, इसलिए और कुछ नहीं बदलेगा।';

  @override
  String get catDeleteChildrenNote =>
      'इसकी उप-श्रेणियाँ ऊपरी स्तर पर चली जाएँगी।';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इसमें $count लेन-देन हैं। उनका क्या करें?',
      one: 'इसमें 1 लेन-देन है। उसका क्या करें?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'दूसरी श्रेणी में ले जाएँ';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'फिर $name हटा दी जाएगी। इसे इस्तेमाल करने वाले बजट भी साथ जाएँगे।';
  }

  @override
  String get catDeleteThemToo => 'लेन-देन भी हटाएँ';

  @override
  String get catDeleteThemTooHint =>
      'वे \'हाल ही में हटाए गए\' में जाएँगे, जहाँ से आप 30 दिन तक वापस ला सकते हैं।';

  @override
  String catDeleted(String name) {
    return '$name हटा दी गई।';
  }

  @override
  String get catActionFailed => 'यह नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get catStaysTopLevel =>
      'इस श्रेणी की अपनी उप-श्रेणियाँ हैं, इसलिए यह ऊपरी स्तर पर ही रहेगी।';

  @override
  String get catUnarchive => 'संग्रह से निकालें';

  @override
  String get catArchivedSection => 'संग्रहित';

  @override
  String get catArchivedHint =>
      'इतिहास के लिए रखी गई हैं, पर लेन-देन जोड़ते समय नहीं दिखतीं।';

  @override
  String get catNothingItsOwnCategory => 'कुछ नहीं — अपनी अलग श्रेणी';

  @override
  String get notifEnableNotifications => 'सूचनाएँ चालू करें';

  @override
  String get startupContinueWithoutChecking => 'बिना जाँचे जारी रखें?';

  @override
  String get startupContinueOffline => 'ऑफ़लाइन जारी रखें';

  @override
  String get startupViewSubscriptionOptions => 'सब्सक्रिप्शन विकल्प देखें';

  @override
  String get sharedWelcomeBack => 'फिर से स्वागत है';

  @override
  String get sharedRestoringYourDataFromThe =>
      'क्लाउड से आपका डेटा रिस्टोर हो रहा है…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return '$source को $target में मिलाएँ?';
  }

  @override
  String get backupNothingHereYet => 'यहाँ अभी कुछ नहीं है।';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'जब फ़ाइल में ये कॉलम हों, तो अपने-आप लागू होगा';

  @override
  String get importDateFormat => 'तारीख़ फ़ॉर्मेट';

  @override
  String get importChooseOne => 'एक चुनें';

  @override
  String get importDecimalPoint => 'दशमलव चिह्न';

  @override
  String get importFlipTheSigns => 'चिह्न उलट दें';

  @override
  String get importForExportsThatWriteA =>
      'उन एक्सपोर्ट के लिए जो ख़र्च को धनात्मक लिखते हैं';

  @override
  String get importWhereRowsGoWhenThe =>
      'जब फ़ाइल में आपके किसी खाते का नाम न हो, तो पंक्तियाँ कहाँ जाएँ';

  @override
  String get importSkipWhatIsAlreadyHere => 'जो पहले से है उसे छोड़ें';

  @override
  String get importCreateCategoriesTheFileNames =>
      'फ़ाइल में दी गई श्रेणियाँ बनाएँ';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'नहीं तो वे पंक्तियाँ बिना श्रेणी के आएँगी';

  @override
  String get importCategoriesInThisFile => 'इस फ़ाइल की श्रेणियाँ';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'निजी वित्त के लिए प्यार से बनाया गया';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'विकसित और संचालित:';

  @override
  String get settingsPrantaDutta => 'प्रांत दत्त';

  @override
  String get settingsClose => 'बंद करें';

  @override
  String get settingsGetInTouch => 'संपर्क करें';

  @override
  String get settingsAsAPremiumMemberYour =>
      'Premium सदस्य होने के नाते आपके अनुरोध को प्राथमिकता मिलेगी।';

  @override
  String get settingsWhatToInclude => 'क्या-क्या लिखें';

  @override
  String get settingsNoCurrenciesFound => 'कोई मुद्रा नहीं मिली';

  @override
  String get settingsExportYourFinancialDataTo =>
      'अपना वित्तीय डेटा एक्सपोर्ट करें ताकि दूसरे ऐप में विश्लेषण कर सकें या बैकअप रख सकें।';

  @override
  String get settingsDateRange => 'तारीख़ की अवधि';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'PDF रिपोर्ट';

  @override
  String get settingsGettingStarted => 'शुरुआत';

  @override
  String get settingsStillNeedHelp => 'अब भी मदद चाहिए?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'हमारी सहायता टीम आपकी मदद के लिए है';

  @override
  String get settingsAppLocked => 'ऐप लॉक है';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'The Accountant खोलने के लिए अनलॉक करें';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'तय करें कि The Accountant आपको ख़र्च दर्ज करने की याद कब और कैसे दिलाए।';

  @override
  String get settingsYourEmailIsUsedTo =>
      'आपका ईमेल साइन इन के लिए है और यहाँ बदला नहीं जा सकता।';

  @override
  String get settingsYourDataIsOnThis => 'आपका डेटा केवल इसी डिवाइस पर है';

  @override
  String get settingsUpgradeForCloudSync => 'क्लाउड सिंक के लिए अपग्रेड करें';

  @override
  String get settingsNoSettingsFound => 'कोई सेटिंग नहीं मिली';

  @override
  String get settingsTryADifferentSearchTerm => 'कोई दूसरा शब्द खोजें';

  @override
  String get settingsSyncStatus => 'सिंक स्थिति';

  @override
  String get settingsSyncNow => 'अभी सिंक करें';

  @override
  String get settingsRestoreFromCloud2 => 'क्लाउड से रिस्टोर करें';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'आपकी पुष्टि ज़रूरी है';

  @override
  String get walletCreateYourFirstAccount => 'अपना पहला खाता बनाएँ';

  @override
  String get walletYouNeedAtLeastOne =>
      'अपने पैसों का हिसाब रखने के लिए कम से कम एक खाता चाहिए';

  @override
  String get walletAccountType => 'खाते का प्रकार';

  @override
  String get walletAccountName => 'खाते का नाम';

  @override
  String get walletCreditLimit => 'क्रेडिट लिमिट';

  @override
  String get walletCreditLimitHelp =>
      'लिमिट बढ़ गई? यहाँ बदलें। नई लिमिट आय नहीं है।';

  @override
  String get walletAmountOwed => 'बकाया राशि';

  @override
  String get walletAmountOwedHelp =>
      'अभी कार्ड पर आपका कितना बकाया है। चुका दिया हो तो 0 डालें।';

  @override
  String get walletCurrentBalance => 'मौजूदा बैलेंस';

  @override
  String get walletCurrentBalanceHelp =>
      'बदलाव बैलेंस सुधार के रूप में सेव होता है, ताकि आपका इतिहास सही बैठे।';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'इस कार्ड पर $amount क्या है?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'बची हुई क्रेडिट';

  @override
  String get walletCardBalanceOwed => 'मेरा बकाया';

  @override
  String get walletCardBalanceChoose =>
      'चुनें कि यह राशि क्या है, ताकि कर्ज़ सही निकले।';

  @override
  String get walletBillingCycleDayOptional => 'बिलिंग साइकिल का दिन (वैकल्पिक)';

  @override
  String get walletThisWillBeYourDefault => 'यह आपका डिफ़ॉल्ट खाता होगा';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'इस खाते में अभी कुछ दर्ज नहीं है।';

  @override
  String get walletAddAccount => 'खाता जोड़ें';

  @override
  String get walletYourAccounts => 'आपके खाते';

  @override
  String get walletNoAccountsYet => 'अभी कोई खाता नहीं';

  @override
  String get walletOutstanding => 'बकाया';

  @override
  String get walletAvailable => 'उपलब्ध';

  @override
  String get walletLimit => 'लिमिट';

  @override
  String get walletBalance => 'बैलेंस';

  @override
  String get walletUseThisWalletForNew =>
      'नए लेन-देन के लिए यह वॉलेट इस्तेमाल करें';

  @override
  String get walletSelectIcon => 'आइकन चुनें';

  @override
  String get walletSelectColor => 'रंग चुनें';

  @override
  String get txYouNeedAtLeast2 => 'ट्रांसफ़र के लिए कम से कम 2 खाते चाहिए';

  @override
  String get txNoAccountTitle => 'इसे दर्ज करने के लिए कोई खाता नहीं';

  @override
  String get txNoAccountBody =>
      'एक खाता जोड़ें, या बंद खाता फिर से खोलें, फिर यह फ़ॉर्म इस्तेमाल के लिए तैयार है।';

  @override
  String get txNoAccountAction => 'खाते संभालें';

  @override
  String get txDeleteTransaction => 'लेन-देन हटाएँ';

  @override
  String get txAreYouSureYouWant => 'क्या आप यह लेन-देन हटाना चाहते हैं?';

  @override
  String get txTransactionType => 'लेन-देन का प्रकार';

  @override
  String get txTransferFee => 'ट्रांसफ़र शुल्क';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'अलग से लिया जाता है, ताकि ट्रांसफ़र ख़ुद बराबर रहे।';

  @override
  String get txDeductedFrom => 'यहाँ से कटा';

  @override
  String get txNoPaymentMethods => 'कोई भुगतान तरीक़ा नहीं';

  @override
  String get txNothingDeletedRecently => 'हाल में कुछ नहीं हटाया गया';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'आप जो भी हटाते हैं, वह तीस दिन तक यहाँ दिखता है।';

  @override
  String get txNoRulesYet => 'अभी कोई नियम नहीं';

  @override
  String get txClearAll => 'सब साफ़ करें';

  @override
  String get txApplyFilters => 'फ़िल्टर लागू करें';

  @override
  String get txUpcomingOverdue => 'आने वाले और बकाया';

  @override
  String get txNew => 'नया';

  @override
  String get txLoan => 'लोन';

  @override
  String get goalStarted => 'शुरू हुआ';

  @override
  String get goalTargetDate => 'लक्ष्य तारीख़';

  @override
  String get goalWithADateTheGoal =>
      'तारीख़ देने पर लक्ष्य बताएगा कि हर दिन कितना अलग रखना है।';

  @override
  String get goalCountedTowardThisGoal => 'इस लक्ष्य में गिना गया';

  @override
  String get goalGettingThere => 'पहुँच रहे हैं';

  @override
  String get goalSetATargetDateAnd =>
      'लक्ष्य तारीख़ सेट करें, यह बता देगा कितना अलग रखना है।';

  @override
  String get reportSpendingInsights => 'ख़र्च की जानकारी';

  @override
  String get reportNoSpendingDataForThis => 'इस अवधि का कोई ख़र्च डेटा नहीं';

  @override
  String get reportNoCategorySpendingData => 'श्रेणी-वार ख़र्च का डेटा नहीं';

  @override
  String get reportNoSpendingDataAvailable => 'कोई ख़र्च डेटा उपलब्ध नहीं';

  @override
  String get reportBudgetVsActual => 'बजट बनाम असल';

  @override
  String get reportNoActiveBudgets => 'कोई सक्रिय बजट नहीं';

  @override
  String get reportCreateABudgetToTrack =>
      'अपने ख़र्च पर नज़र रखने के लिए बजट बनाएँ';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'समय से तेज़ ख़र्च हो रहा है।';

  @override
  String get budgetNothingRecordedInThisPeriod => 'इस अवधि में कुछ दर्ज नहीं।';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $limit में से $spent इस्तेमाल';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount बाक़ी';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount ज़्यादा';
  }

  @override
  String get budgetPeriodEnded => 'अवधि ख़त्म';

  @override
  String get budgetPaceOver => 'ज़्यादा';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन बाक़ी',
      one: '1 दिन बाक़ी',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'पासवर्ड रीसेट हो गया। कृपया साइन इन करें।';

  @override
  String get authResendCode => 'कोड फिर से भेजें';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authOrContinueWith => 'या इसके साथ जारी रखें';

  @override
  String get authContinueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get authContinueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get authSignUp => 'साइन अप';

  @override
  String get authPleaseAcceptTheTermsAnd => 'कृपया नियम और शर्तें स्वीकार करें';

  @override
  String get authPasswordStrength => 'पासवर्ड की मज़बूती';

  @override
  String get authAlreadyHaveAnAccount => 'पहले से खाता है? ';

  @override
  String get authPersonalInformation => 'निजी जानकारी';

  @override
  String get authUpgradeToPremium => 'Premium में अपग्रेड करें';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'असीमित बजट, एडवांस्ड विश्लेषण और बहुत कुछ पाएँ!';

  @override
  String get authUpgradeNow => 'अभी अपग्रेड करें';

  @override
  String get authPremiumMember => 'Premium सदस्य';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'सभी Premium फ़ीचर का आनंद ले रहे हैं';

  @override
  String get authSaveChanges => 'बदलाव सेव करें';

  @override
  String get authAreYouSureYouWant =>
      'क्या आप अपने खाते से साइन आउट करना चाहते हैं?';

  @override
  String get authChangeProfilePhoto => 'प्रोफ़ाइल फ़ोटो बदलें';

  @override
  String get authTakePhoto => 'फ़ोटो लें';

  @override
  String get authUseYourCamera => 'अपना कैमरा इस्तेमाल करें';

  @override
  String get authChooseFromGallery => 'गैलरी से चुनें';

  @override
  String get authSelectAnExistingPhoto => 'मौजूदा फ़ोटो चुनें';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'फ़ोटो चुनी गई! अपलोड फ़ीचर जल्द आ रहा है।';

  @override
  String get authNameCannotBeEmpty => 'नाम ख़ाली नहीं हो सकता';

  @override
  String get authProfileUpdatedSuccessfully => 'प्रोफ़ाइल अपडेट हो गई!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'गोपनीयता और शर्तें';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'आगे बढ़ने से पहले इन्हें देख लें।';

  @override
  String get premiumLimitReached => 'सीमा पूरी हुई';

  @override
  String get aiChats => 'चैट';

  @override
  String get aiNewChat => 'नई चैट';

  @override
  String get aiNoConversationsYet => 'अभी कोई बातचीत नहीं';

  @override
  String get aiStartChattingAndYourThreads =>
      'चैट शुरू करें, आपकी बातचीत यहाँ दिखेगी।';

  @override
  String get aiScanAReceipt => 'रसीद स्कैन करें';

  @override
  String get aiReadingYourReceipt => 'आपकी रसीद पढ़ी जा रही है…';

  @override
  String get aiReviewSave => 'देखें और सेव करें';

  @override
  String get aiWeReadThisFromYour =>
      'यह आपकी रसीद से पढ़ा गया है — सेव करने से पहले जाँचें और जो चाहें बदलें।';

  @override
  String get dashErrorLoadingFinancialData =>
      'वित्तीय डेटा लोड करने में त्रुटि';

  @override
  String get dashNoSpendingDataYet => 'अभी कोई ख़र्च डेटा नहीं';

  @override
  String get dashManage => 'संभालें';

  @override
  String get dashAvailable => 'उपलब्ध: ****';

  @override
  String get onboardWelcome => 'स्वागत है!';

  @override
  String get onboardSelectYourDefaultCurrency => 'अपनी डिफ़ॉल्ट मुद्रा चुनें';

  @override
  String get onboardLoadingCurrencies => 'मुद्राएँ लोड हो रही हैं...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'अपना मुख्य वॉलेट सेट करें';

  @override
  String get onboardInitialBalanceOptional => 'शुरुआती बैलेंस (वैकल्पिक)';

  @override
  String get onboardYourAccountIsReadyTo =>
      'आपका खाता इस्तेमाल के लिए तैयार है';

  @override
  String get onboardTipYouCanAddMore =>
      'सुझाव: आप वॉलेट सेक्शन से कभी भी अलग-अलग मुद्राओं वाले और खाते जोड़ सकते हैं।';

  @override
  String get creditSettled => 'चुकता';

  @override
  String get creditOverdue => 'बकाया';

  @override
  String creditTabCredit(int count) {
    return 'उधार दिया ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'उधार लिया ($count)';
  }

  @override
  String get creditNetOutstanding => 'कुल बकाया';

  @override
  String get creditAllSettled => 'सब चुकता';

  @override
  String get creditOthersOweYou => 'दूसरों पर आपका बकाया';

  @override
  String get creditYouOweOthers => 'आप पर दूसरों का बकाया';

  @override
  String creditOverdueCount(int count) {
    return '$count बकाया';
  }

  @override
  String get creditEmptyAll => 'कोई पैसा उधार दिया या लिया नहीं';

  @override
  String get creditEmptyLent => 'कोई पैसा उधार नहीं दिया';

  @override
  String get creditEmptyBorrowed => 'कोई पैसा उधार नहीं लिया';

  @override
  String get creditEmptyAllSettled => 'सब कुछ चुकता है।';

  @override
  String get creditEmptyHint =>
      'उधार दिया या लिया पैसा जोड़ें, ताकि पता रहे किसका किस पर बकाया है।';

  @override
  String get creditShowAll => 'सब दिखाएँ';

  @override
  String get creditShowUnpaid => 'केवल बिना चुकाए दिखाएँ';

  @override
  String get creditMoneyLent => 'उधार दिया पैसा';

  @override
  String get creditMoneyBorrowed => 'उधार लिया पैसा';

  @override
  String get creditTheyOweYou => 'उन पर आपका बकाया';

  @override
  String get creditYouOwe => 'आप पर बकाया';

  @override
  String get creditCollected => 'वसूला गया';

  @override
  String creditPaidOf(String paid, String total) {
    return '$total में से $paid चुकाया';
  }

  @override
  String get creditRecord => 'दर्ज करें';

  @override
  String get subRecurring => 'नियमित';

  @override
  String get subPaused => 'रुका हुआ';

  @override
  String get subAsksFirst => 'पहले पूछता है';

  @override
  String get subFrequency => 'आवृत्ति';

  @override
  String get notifMarkAllRead => 'सब पढ़ा हुआ मानें';

  @override
  String get notifTryAgain => 'फिर से कोशिश करें';

  @override
  String get notifStayOnTopOfYour => 'अपने पैसों पर नज़र रखें';

  @override
  String get notifNoNotificationsYet => 'अभी कोई सूचना नहीं';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'जब आपको सूचनाएँ मिलेंगी, वे यहाँ दिखेंगी।';

  @override
  String get startupNothingHasBeenChangedOr =>
      'कुछ भी बदला या हटाया नहीं गया है।';

  @override
  String get sharedIncludeCryptoCurrencies => 'क्रिप्टो मुद्राएँ शामिल करें';

  @override
  String get sharedTotalBalance => 'कुल बैलेंस';

  @override
  String get heatmapTitle => 'रोज़ का पैटर्न';

  @override
  String get heatmapSpentMore => 'ज़्यादा ख़र्च';

  @override
  String get heatmapEarnedMore => 'ज़्यादा कमाई';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count लेन-देन नहीं दिखाए गए: उनके खातों की मुद्राओं और $currency के बीच कोई दर ज्ञात नहीं',
      one:
          'एक लेन-देन नहीं दिखाया गया: उसके खाते की मुद्रा और $currency के बीच कोई दर ज्ञात नहीं',
    );
    return '$_temp0।';
  }

  @override
  String get heatmapNothingYet => 'इस अवधि में अभी कुछ दर्ज नहीं।';

  @override
  String get heatmapNetForRange => 'इस अवधि का शुद्ध';

  @override
  String get layoutTitle => 'होम लेआउट';

  @override
  String get layoutSubtitle =>
      'होम स्क्रीन का क्रम बदलें, या जो इस्तेमाल नहीं करते उसे छिपाएँ';

  @override
  String get layoutExplain =>
      'क्रम बदलने के लिए खींचें। जो बंद किया गया है वह अपनी जगह रहता है, ताकि वापस चालू करने पर वहीं आए जहाँ छोड़ा था।';

  @override
  String get layoutReset => 'डिफ़ॉल्ट पर लौटें';

  @override
  String get layoutAllHidden => 'हर सेक्शन छिपा है। होम स्क्रीन ख़ाली रहेगी।';

  @override
  String get layoutSectionGreeting => 'अभिवादन';

  @override
  String get layoutSectionAccounts => 'खाते';

  @override
  String get layoutSectionQuickStats => 'आय और ख़र्च';

  @override
  String get layoutSectionQuickLinks => 'शॉर्टकट';

  @override
  String get layoutSectionSpendingChart => 'ख़र्च का सारांश';

  @override
  String get layoutSectionRecent => 'हाल के लेन-देन';

  @override
  String get layoutSectionBudgets => 'बजट प्रगति';

  @override
  String get layoutSectionGoals => 'पिन किए लक्ष्य';

  @override
  String get shortcutAddExpense => 'ख़र्च जोड़ें';

  @override
  String get shortcutAddIncome => 'आय जोड़ें';

  @override
  String get shortcutScanReceipt => 'रसीद स्कैन करें';

  @override
  String get shortcutTransactions => 'लेन-देन';

  @override
  String get backupBusySyncing =>
      'सिंक चल रहा है। रिस्टोर करने से पहले उसके पूरा होने तक रुकें।';

  @override
  String get appearanceTitle => 'रूप-रंग';

  @override
  String get themeSunriseLight => 'सनराइज़ लाइट';

  @override
  String get themeSunriseDark => 'सनराइज़ डार्क';

  @override
  String get themeMatchSystem => 'सिस्टम के अनुसार';

  @override
  String get themeMatchSystemHint => 'फ़ोन के साथ लाइट और डार्क बदले';

  @override
  String get themeUnlockAll => 'सभी थीम अनलॉक करें';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'सनराइज़';

  @override
  String get themeAccentSapphire => 'नीलम';

  @override
  String get themeAccentEmerald => 'पन्ना';

  @override
  String get themeAccentRuby => 'माणिक';

  @override
  String get themeAccentAmethyst => 'जामुनी';

  @override
  String get themeAccentGraphite => 'ग्रेफ़ाइट';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'आज';

  @override
  String get navAdd => 'जोड़ें';

  @override
  String get navStats => 'आँकड़े';

  @override
  String get navMore => 'और';

  @override
  String get walkthroughTodayTitle => 'आपका दिन एक नज़र में';

  @override
  String get walkthroughTodayBody =>
      'नेट वर्थ, आपने क्या कमाया और ख़र्च किया, और आज की गतिविधि।';

  @override
  String get walkthroughAddTitle => 'सेकंडों में जोड़ें';

  @override
  String get walkthroughAddBody =>
      'ख़र्च, आय या ट्रांसफ़र दर्ज करने के लिए \'जोड़ें\' दबाएँ।';

  @override
  String get walkthroughTransactionsTitle => 'आपके लेन-देन';

  @override
  String get walkthroughTransactionsBody =>
      'हर लेन-देन, महीने-दर-महीने। कुछ भी ढूँढने के लिए खोजें और फ़िल्टर करें।';

  @override
  String get walkthroughStatsTitle => 'देखें पैसा कहाँ जाता है';

  @override
  String get walkthroughStatsBody =>
      'हफ़्ते, महीने और साल के चार्ट, श्रेणी के अनुसार।';

  @override
  String get walkthroughBellTitle => 'जानकारी में रहें';

  @override
  String get walkthroughBellBody =>
      'बजट अलर्ट और रिमाइंडर यहाँ दिखते हैं। आप तैयार हैं!';

  @override
  String get walkthroughBalanceTitle => 'आपकी नेट वर्थ';

  @override
  String get walkthroughBalanceBody =>
      'हर वॉलेट यहाँ जुड़ता है, साथ में एक बार दिखाता है कि कैसे बँटा है।';

  @override
  String get txTransfer => 'ट्रांसफ़र';

  @override
  String get txUncategorized => 'बिना श्रेणी';

  @override
  String todayGoodMorning(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String get todayGoodMorningPlain => 'सुप्रभात';

  @override
  String get todayGoodAfternoonPlain => 'नमस्ते';

  @override
  String get todayGoodEveningPlain => 'शुभ संध्या';

  @override
  String get todayNetWorth => 'नेट वर्थ';

  @override
  String todayThisMonthDelta(String amount) {
    return 'इस महीने $amount';
  }

  @override
  String get todayEarned => 'कमाया';

  @override
  String get todaySpent => 'ख़र्च किया';

  @override
  String get todayTitle => 'आज';

  @override
  String get todayRecent => 'हाल के';

  @override
  String get todayAllActivity => 'सारी गतिविधि';

  @override
  String get todayNothingYet => 'आज अभी कुछ नहीं';

  @override
  String get todayNothingYetBody =>
      'अपना पहला लेन-देन दर्ज करने के लिए \'जोड़ें\' दबाएँ।';

  @override
  String todayMoreWallets(int count) {
    return '+$count और';
  }

  @override
  String get todayCoachTitle => 'अपने मनी कोच से पूछें';

  @override
  String get todayCoachBody => 'आपके अपने ख़र्च से जवाब और सुझाव';

  @override
  String get todayNotifications => 'सूचनाएँ';

  @override
  String get todayWithinBudget => 'बजट के अंदर';

  @override
  String get todayOverBudget => 'बजट से ज़्यादा';

  @override
  String get todayNetCredit => 'शुद्ध लेनदारी';

  @override
  String get todayNetDebt => 'शुद्ध कर्ज़';

  @override
  String get todayMonthly => 'मासिक';

  @override
  String get walletsTitle => 'वॉलेट';

  @override
  String get walletsNew => 'नया';

  @override
  String get walletsAddHint => 'बैंक, नकद, बचत जोड़ें…';

  @override
  String get walletsPlanning => 'योजना';

  @override
  String get walletsUpcoming => 'आने वाले';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count देय · $amount';
  }

  @override
  String get walletsUpcomingNone => 'जल्द कुछ देय नहीं';

  @override
  String get walletsLendBorrow => 'उधार लेन-देन';

  @override
  String get splitTitle => 'बिल बाँटें';

  @override
  String get splitSubtitle =>
      'दोस्तों के साथ बिल बाँटें; उनका बकाया \'उधार लेन-देन\' में जाता है';

  @override
  String get splitWhatFor => 'किसके लिए था';

  @override
  String get splitTotal => 'कुल';

  @override
  String get splitPeople => 'लोग';

  @override
  String get splitYou => 'आप';

  @override
  String get splitIncludeMe => 'मेरा भी हिस्सा था';

  @override
  String get splitIncludeMeSub =>
      'बंद करें अगर आपने केवल दूसरों के लिए भुगतान किया';

  @override
  String get splitAddPerson => 'व्यक्ति जोड़ें';

  @override
  String get splitPersonName => 'नाम';

  @override
  String get splitKnownPeople => '\'उधार लेन-देन\' से';

  @override
  String get splitRemove => 'हटाएँ';

  @override
  String get splitPaidBy => 'भुगतान किसने किया';

  @override
  String get splitHow => 'कैसे बाँटें';

  @override
  String get splitEqual => 'बराबर';

  @override
  String get splitExact => 'राशि से';

  @override
  String get splitPercent => 'प्रतिशत';

  @override
  String get splitShares => 'हिस्से';

  @override
  String get splitYourShare => 'आपका हिस्सा';

  @override
  String get splitOwesYou => 'आपका बकाया';

  @override
  String splitYouOwe(String name) {
    return 'आप पर $name का बकाया';
  }

  @override
  String get splitPaidTheBill => 'बिल चुकाया';

  @override
  String splitSettlesWith(String name) {
    return '$name से हिसाब बराबर';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return 'आपके खाते से $total; $owed आपको वापस मिलना है';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'अभी आपके खाते से कुछ नहीं जाता; आप पर $name के $amount बकाया';
  }

  @override
  String get splitPercentLabel => 'बिल का प्रतिशत';

  @override
  String get splitSave => 'बाँटें';

  @override
  String get splitSaved => 'बँटवारा दर्ज हुआ';

  @override
  String get splitNeedCategory => 'पहले श्रेणी चुनें।';

  @override
  String get splitThisBill => 'यह बिल बाँटें';

  @override
  String get splitThisBillSub =>
      'दोस्तों के साथ; उनका बकाया \'उधार लेन-देन\' में जाता है';

  @override
  String get splitPartOf => 'बँटा हुआ बिल';

  @override
  String walletsOwedToYou(String amount) {
    return 'आपको $amount मिलने हैं';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'आप पर $amount बकाया';
  }

  @override
  String get walletsAllSettled => 'सब चुकता';

  @override
  String get walletsGoals => 'लक्ष्य';

  @override
  String walletsGoalsSub(int count) {
    return '$count सक्रिय';
  }

  @override
  String get walletsBudgets => 'बजट';

  @override
  String get walletsSubscriptions => 'सब्सक्रिप्शन';

  @override
  String get walletsTransfer => 'वॉलेट के बीच ट्रांसफ़र';

  @override
  String get walletsArchived => 'संग्रहित';

  @override
  String walletsDeleteMessage(String name) {
    return '“$name” हटाएँ? इस खाते का हर लेन-देन भी साथ में हट जाएगा।';
  }

  @override
  String walletsDeleted(String name) {
    return '$name हटाया गया';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name अब आपका डिफ़ॉल्ट है';
  }

  @override
  String get walletsCreateFailed =>
      'खाता नहीं बन सका। कृपया फिर से कोशिश करें।';

  @override
  String get walletsEmptyBody => 'हिसाब शुरू करने के लिए अपना पहला खाता बनाएँ।';

  @override
  String get walletsTypeBank => 'बैंक खाता';

  @override
  String get walletsTypeCard => 'क्रेडिट कार्ड';

  @override
  String get walletsTypeCash => 'नकद';

  @override
  String get walletsTypeOther => 'खाता';

  @override
  String get moreTitle => 'और';

  @override
  String get moreGoPremium => 'Premium लें';

  @override
  String get moreGoPremiumBody => 'AI सहायक, क्लाउड सिंक, थीम';

  @override
  String get moreUnlock => 'अनलॉक करें';

  @override
  String get morePremiumActive => 'Premium सक्रिय है';

  @override
  String get morePremiumThanks => 'The Accountant का साथ देने के लिए धन्यवाद';

  @override
  String get sectionPreferences => 'पसंद';

  @override
  String get sectionTools => 'पैसों के टूल';

  @override
  String get moreAiAssistant => 'AI सहायक';

  @override
  String get moreAiAssistantSub => 'अपने पैसों के बारे में सवाल पूछें';

  @override
  String get moreSignOutConfirm => 'इस डिवाइस पर अपने खाते से साइन आउट करें?';

  @override
  String get moreSignOutFailed =>
      'साइन आउट नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get moreDeviceOnlyBody =>
      'मुफ़्त खातों का क्लाउड पर बैकअप नहीं होता, इसलिए दोबारा इंस्टॉल करने या फ़ोन बदलने पर डेटा खो सकता है। क्लाउड सिंक के लिए अपग्रेड करें, या नियमित रूप से बैकअप एक्सपोर्ट करें।';

  @override
  String get moreUpgradeToPremium => 'Premium में अपग्रेड करें';

  @override
  String get moreUser => 'आप';

  @override
  String get statsTitle => 'आँकड़े';

  @override
  String get statsWeek => 'हफ़्ता';

  @override
  String get statsMonth => 'महीना';

  @override
  String get statsYear => 'साल';

  @override
  String get statsSpending => 'ख़र्च';

  @override
  String get statsIncome => 'आय';

  @override
  String get statsCategories => 'श्रेणियाँ';

  @override
  String get statsSpent => 'ख़र्च किया';

  @override
  String get statsEarned => 'कमाया';

  @override
  String get statsNet => 'शुद्ध';

  @override
  String get statsThisMonth => 'इस महीने';

  @override
  String statsVsLastMonth(String change) {
    return 'पिछले महीने के मुक़ाबले $change';
  }

  @override
  String get statsInsightsSub => 'इस महीने का सारांश, रुझान और सुझाव';

  @override
  String get statsAskCoach => 'इसके बारे में AI कोच से पूछें';

  @override
  String statsOverBy(String amount) {
    return '$amount ज़्यादा';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% बाक़ी';
  }

  @override
  String get activityAll => 'सभी';

  @override
  String get activitySpent => 'ख़र्च';

  @override
  String get activityEarned => 'कमाई';

  @override
  String get activityTransfers => 'ट्रांसफ़र';

  @override
  String activitySoFar(String month) {
    return '$month अब तक';
  }

  @override
  String activityNet(String amount) {
    return '$amount शुद्ध';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी महीनों में $count मेल',
      one: 'सभी महीनों में 1 मेल',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'पिछले 7 दिन';

  @override
  String get statsPeriodThisMonth => 'इस महीने';

  @override
  String get statsPeriodThisYear => 'इस साल';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन',
      one: '1 लेन-देन',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return '“$query” से कुछ मेल नहीं खाता';
  }

  @override
  String get activitySearchNothingBody =>
      'हर महीना खोजा गया। कम शब्द, दूसरी वर्तनी आज़माएँ, या कोई फ़िल्टर हटाएँ।';

  @override
  String get activityIn => 'आया';

  @override
  String get activityOut => 'गया';

  @override
  String get activityToday => 'आज';

  @override
  String get activityYesterday => 'कल';

  @override
  String get activityTomorrow => 'आने वाला कल';

  @override
  String get activityEmptyFutureTitle => 'कोई योजनाबद्ध लेन-देन नहीं';

  @override
  String activityEmptyFutureBody(String month) {
    return '$month के लिए आगे के भुगतान जोड़ें';
  }

  @override
  String get activityEmptyNowTitle => 'अभी कोई लेन-देन नहीं';

  @override
  String get activityEmptyNowBody => 'इस महीने अपने ख़र्च का हिसाब शुरू करें';

  @override
  String get activityEmptyPastTitle => 'कोई लेन-देन नहीं मिला';

  @override
  String activityEmptyPastBody(String month) {
    return '$month का कोई रिकॉर्ड नहीं';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन हटाए गए',
      one: '1 लेन-देन हटाया गया',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count को $name में ले जाया गया';
  }

  @override
  String get activityMixedCurrencies =>
      'ये अलग-अलग मुद्राओं में हैं, इसलिए कोई एक खाता नहीं जिसमें सब जा सकें। एक ही मुद्रा की पंक्तियाँ चुनें।';

  @override
  String activityMovedPartial(int count) {
    return '$count ले जाए गए; ट्रांसफ़र अपनी जगह छोड़ दिए गए';
  }

  @override
  String activityMoved(int count) {
    return '$count दूसरे खाते में ले जाए गए';
  }

  @override
  String activityRedated(int count) {
    return '$count की तारीख़ बदली गई';
  }

  @override
  String get activityNothingToPay => 'भुगतान के लिए कुछ बाक़ी नहीं था';

  @override
  String activityMarkedPaid(int count) {
    return '$count को भुगतान हुआ माना गया';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count कॉपी हुए; ट्रांसफ़र अकेले कॉपी नहीं हो सकते';
  }

  @override
  String activityCopied(int count) {
    return '$count कॉपी हुए';
  }

  @override
  String get activityDeleteOneBody =>
      'यह आपके रिकॉर्ड से हट जाएगा और आपका बैलेंस दोबारा गिना जाएगा।';

  @override
  String get activitySearch => 'खोजें';

  @override
  String get addNewExpense => 'नया ख़र्च';

  @override
  String get addNewIncome => 'नई आय';

  @override
  String get addNewTransfer => 'नया ट्रांसफ़र';

  @override
  String get addEditTitle => 'लेन-देन बदलें';

  @override
  String get addAmount => 'राशि';

  @override
  String get addCategory => 'श्रेणी';

  @override
  String get addMore => 'और';

  @override
  String get addWallet => 'वॉलेट';

  @override
  String addChangeDate(String date) {
    return 'तारीख़ बदलें, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'समय बदलें, $time';
  }

  @override
  String get addSwapAccounts => 'दोनों खाते आपस में बदलें';

  @override
  String get notifCheckTitle => 'सूचनाएँ जाँचें';

  @override
  String get notifAllowed => 'सूचनाओं की अनुमति है';

  @override
  String get notifAllowedHint => 'रिमाइंडर इस फ़ोन तक पहुँच सकते हैं';

  @override
  String get notifBlocked => 'सूचनाएँ बंद हैं';

  @override
  String get notifBlockedHint =>
      'अनुमति देने के लिए टैप करें, नहीं तो कुछ भी आप तक नहीं पहुँचेगा';

  @override
  String get notifSendTest => 'टेस्ट सूचना भेजें';

  @override
  String get notifSendTestHint =>
      'हमारे सर्वर से भेजी जाती है, जैसे रिमाइंडर आते हैं';

  @override
  String get notifSending => 'भेजा जा रहा है…';

  @override
  String get notifTestSent =>
      'भेज दी गई। कुछ सेकंड में दिखनी चाहिए, और आपके इनबॉक्स में भी।';

  @override
  String notifTestFailed(String reason) {
    return 'यह भेजी नहीं जा सकी: $reason';
  }

  @override
  String get notifTestOffline => 'सर्वर से कनेक्शन नहीं';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant आपके चुने समय पर रोज़ ख़र्च दर्ज करने की हल्की-सी याद दिलाएगा। इसके लिए सूचनाएँ दिखाने की अनुमति चाहिए।';

  @override
  String get notifPrimerShow => 'रिमाइंडर सूचनाएँ दिखाएँ';

  @override
  String get notifPrimerTime => 'आपके चुने समय पर आएँगी';

  @override
  String get notifPrimerOff => 'आप इसे कभी भी बंद कर सकते हैं';

  @override
  String get notifPrimerAllow => 'अनुमति दें';

  @override
  String get cardBillsTitle => 'कार्ड बिल';

  @override
  String get cardBillsSubtitle =>
      'क्रेडिट कार्ड स्टेटमेंट, नियत तारीख़ और रिमाइंडर';

  @override
  String get cardBillsEmptyTitle => 'अभी कोई क्रेडिट कार्ड नहीं';

  @override
  String get cardBillsEmptyBody =>
      'क्रेडिट कार्ड प्रकार का खाता जोड़ें, उसका स्टेटमेंट दिन और नियत दिन सेट करें, फिर उसके बिल यहाँ दिखेंगे।';

  @override
  String get cardBillsAddCard => 'कार्ड जोड़ें';

  @override
  String get cardStatementDay => 'स्टेटमेंट का दिन';

  @override
  String get cardStatementDayHint =>
      'हर महीने वह दिन जब बिल बनता है। उस दिन के अंत तक का सब कुछ उसमें होता है।';

  @override
  String get cardDueDay => 'भुगतान का नियत दिन';

  @override
  String get cardDueDayHint =>
      'बिल चुकाने का आख़िरी दिन, स्टेटमेंट के बाद पहली बार आने वाला वह दिन।';

  @override
  String get cardRemindTitle => 'मुझे याद दिलाएँ';

  @override
  String get cardRemindHint =>
      'नियत तारीख़ से पहले, अगर बिल का कुछ हिस्सा अब भी बाक़ी हो। सुबह लगभग 9 बजे भेजा जाता है।';

  @override
  String get cardRemindOff => 'बंद';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन पहले',
      one: 'एक दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'सेट नहीं';

  @override
  String cardDayOfMonth(int day) {
    return '$day तारीख़';
  }

  @override
  String get cardSetUpBody =>
      'इस कार्ड के बिल देखने और नियत तारीख़ से पहले याद पाने के लिए स्टेटमेंट दिन और नियत दिन सेट करें।';

  @override
  String get cardSetUp => 'तारीख़ें सेट करें';

  @override
  String cardDueBy(String date) {
    return '$date तक चुकाना बाक़ी';
  }

  @override
  String get cardLeftToPay => 'चुकाना बाक़ी';

  @override
  String cardStatementClosed(String date) {
    return '$date का स्टेटमेंट';
  }

  @override
  String get cardPaidSince => 'तब से चुकाया';

  @override
  String cardThisCycle(String date) {
    return 'तब से ख़र्च, अगला स्टेटमेंट $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return '$card बिल भुगतान';
  }

  @override
  String get cardEdit => 'कार्ड बदलें';

  @override
  String get cardEarlierStatements => 'पिछले स्टेटमेंट';

  @override
  String get cardPaidShort => 'चुकाया';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount बाक़ी';
  }

  @override
  String get cardStatusNotSetUp => 'तारीख़ें सेट नहीं';

  @override
  String get cardStatusNothingDue => 'कुछ देय नहीं';

  @override
  String get cardStatusPaid => 'चुकाया';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में देय',
      one: 'कल देय',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'आज देय';

  @override
  String get cardStatusOverdue => 'बकाया';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$owed में से $paid चुकाया';
  }

  @override
  String get cardPayBill => 'बिल चुकाएँ';

  @override
  String cardPayTitle(String card) {
    return '$card चुकाएँ';
  }

  @override
  String get cardPayHint =>
      'पूरा या कुछ हिस्सा चुकाएँ। आप जो भी चुकाते हैं वह इस बिल में गिना जाता है, और बाक़ी देय रहता है।';

  @override
  String cardPayFull(String amount) {
    return 'पूरा चुकाएँ, $amount';
  }

  @override
  String get cardPayFullHint => 'इस बिल पर बचा सब कुछ';

  @override
  String get cardPayOther => 'दूसरी राशि चुकाएँ';

  @override
  String get cardPayOtherHint => 'आंशिक भुगतान, या बिल से ज़्यादा';

  @override
  String get addNoteHint => 'नोट जोड़ें';

  @override
  String get addRepeatMonthly => 'हर महीने दोहराएँ';

  @override
  String get addMoreOptions => 'और विकल्प';

  @override
  String get addScanReceipt => 'रसीद स्कैन करें';

  @override
  String get addDelete => 'लेन-देन हटाएँ';

  @override
  String get addTypeExpense => 'ख़र्च';

  @override
  String get addTypeIncome => 'आय';

  @override
  String get addTypeTransfer => 'ट्रांसफ़र';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Premium से अनलॉक करें';

  @override
  String get gateFootnote => 'आजीवन या सब्सक्रिप्शन · कभी भी रिस्टोर करें';

  @override
  String get aiCoachTitle => 'मिलिए अपने मनी कोच से';

  @override
  String get aiCoachBody =>
      'आसान शब्दों में पूछें। आपके अपने ख़र्च से बने जवाब, सुझाव और योजनाएँ पाएँ।';

  @override
  String get aiAssistantTitle => 'AI सहायक';

  @override
  String get aiAskAnything => 'अपने पैसों के बारे में पूछें…';

  @override
  String get aiSend => 'भेजें';

  @override
  String get aiCopy => 'कॉपी करें';

  @override
  String get aiCopied => 'कॉपी हो गया';

  @override
  String get aiRetry => 'फिर से कोशिश करें';

  @override
  String get aiDismiss => 'हटाएँ';

  @override
  String get aiTyping => 'कोच लिख रहा है';

  @override
  String aiStarterCategory(String category) {
    return 'मेरा $category का पैसा कहाँ गया?';
  }

  @override
  String get aiStarterBudgets => 'क्या मैं अपने बजट के हिसाब से चल रहा हूँ?';

  @override
  String get aiStarterUpcoming => 'कौन-से बिल आने वाले हैं?';

  @override
  String get aiStarterAnalyze => 'मेरे हाल के ख़र्च के पैटर्न का विश्लेषण करें';

  @override
  String get aiStarterBudgetTips => 'बेहतर बजट बनाने के सुझाव दें';

  @override
  String get aiStarterSave => 'मैं और पैसे कैसे बचा सकता हूँ?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” हमेशा के लिए हट जाएगी।';
  }

  @override
  String get aiJustNow => 'अभी-अभी';

  @override
  String get aiErrorTitle => 'कोच जवाब नहीं दे सका';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'ऐप जो कुछ कर सकता है, सब आपके लिए।';

  @override
  String get paywallActiveTitle => 'Premium सक्रिय है';

  @override
  String get paywallActiveTagline => 'आपके साथ के लिए धन्यवाद!';

  @override
  String get paywallRestore => 'रिस्टोर करें';

  @override
  String get paywallProcessing => 'प्रोसेस हो रहा है…';

  @override
  String paywallTriggered(String feature) {
    return '$feature एक Premium फ़ीचर है';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days दिन बाक़ी';
  }

  @override
  String get paywallFeatSync => 'क्लाउड सिंक';

  @override
  String get paywallFeatSyncSub => 'सभी डिवाइस';

  @override
  String get paywallFeatAi => 'AI सहायक';

  @override
  String get paywallFeatAiSub => 'असीमित, बिना विज्ञापन';

  @override
  String get paywallFeatOcr => 'रसीद स्कैन';

  @override
  String get paywallFeatOcrSub => 'AI के साथ OCR';

  @override
  String get paywallFeatInsights => 'ख़र्च की जानकारी';

  @override
  String get paywallFeatInsightsSub => 'मासिक रुझान';

  @override
  String get paywallFeatThemes => '5 थीम';

  @override
  String get paywallFeatThemesSub => 'ख़ास';

  @override
  String get paywallFeatPdf => 'PDF रिपोर्ट';

  @override
  String get paywallFeatPdfSub => 'CSV मुफ़्त रहेगा';

  @override
  String get paywallFeatUnlimited => 'असीमित';

  @override
  String get paywallFeatUnlimitedSub => 'वॉलेट, बजट';

  @override
  String get paywallFeatSupport => 'प्राथमिक सहायता';

  @override
  String get paywallFeatSupportSub => 'जल्दी जवाब';

  @override
  String get paywallPerMonth => '/महीना';

  @override
  String get paywallPerYear => '/साल';

  @override
  String get paywallOnce => 'एक बार';

  @override
  String get paywallBestValue => 'सबसे फ़ायदेमंद';

  @override
  String get paywallForever => 'हमेशा के लिए';

  @override
  String get paywallMonthlyDesc => 'हर महीने बिल';

  @override
  String get paywallYearlyDesc => 'हर साल बिल';

  @override
  String get paywallLifetimeDesc => 'एक बार चुकाएँ, हमेशा रखें';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial मुफ़्त, फिर $rest';
  }

  @override
  String get paywallCtaLifetime => 'आजीवन एक्सेस लें';

  @override
  String get paywallCtaYearly => 'सालाना प्लान शुरू करें';

  @override
  String get paywallCtaMonthly => 'मासिक प्लान शुरू करें';

  @override
  String get paywallFootLifetime => 'एक बार की ख़रीद · कोई सब्सक्रिप्शन नहीं';

  @override
  String get paywallFootSubscription =>
      'अपने-आप रिन्यू होता है · स्टोर में कभी भी रद्द करें';

  @override
  String get paywallTerms =>
      'सब्सक्रिप्शन का शुल्क आपके App Store या Google Play खाते से लिया जाता है और मौजूदा अवधि ख़त्म होने से कम से कम 24 घंटे पहले रद्द न करने पर अपने-आप रिन्यू हो जाता है।';

  @override
  String get paywallIapUnavailable =>
      'इस डिवाइस पर इन-ऐप ख़रीद उपलब्ध नहीं है। पक्का करें कि Google Play Services इंस्टॉल है और ऐप Play Store से आया है।';

  @override
  String get paywallLoadingPlans => 'प्लान लोड हो रहे हैं…';

  @override
  String get paywallPlansFailed =>
      'प्लान लोड नहीं हो सके। अपना कनेक्शन जाँचें और फिर से कोशिश करें।';

  @override
  String get paywallTryAgain => 'फिर से कोशिश करें';

  @override
  String get paywallRestored => 'ख़रीदारी रिस्टोर हो गई';

  @override
  String get paywallPurchased => 'Premium में स्वागत है!';

  @override
  String get paywallLifetimeNever => 'आजीवन एक्सेस कभी ख़त्म नहीं होता';

  @override
  String get helpSearchQuestions => 'सवाल खोजें';

  @override
  String get helpStepWallets => 'वॉलेट जोड़ें';

  @override
  String get helpStepCategories => 'श्रेणियाँ चुनें';

  @override
  String get helpStepTrack => 'रोज़ हिसाब रखें';

  @override
  String get splashTagline => 'पैसा, और रौशन।';

  @override
  String get introStep1 => 'आपके सिक्के गिने जा रहे हैं…';

  @override
  String get introStep2 => 'आपके वॉलेट जगाए जा रहे हैं…';

  @override
  String get introStep3 => 'चार्ट चमकाए जा रहे हैं…';

  @override
  String get introStep4 => 'बस पहुँच ही गए…';

  @override
  String get introTipLabel => 'पैसों का सुझाव';

  @override
  String get introTip1 =>
      'पहले ख़ुद को भुगतान करें: जिस दिन सैलरी आए, उसी दिन बचत अलग कर दें।';

  @override
  String get introTip2 =>
      'रोज़ के छोटे ख़र्च जुड़ते जाते हैं। उन्हें दर्ज करना आधी जीत है।';

  @override
  String get introTip3 =>
      '3 महीने का इमरजेंसी फ़ंड अचानक की मुसीबत को बस थोड़ी असुविधा बना देता है।';

  @override
  String get introTip4 =>
      'हर महीने सब्सक्रिप्शन देखें: जो इस्तेमाल नहीं किया, उसे रद्द करें।';

  @override
  String get introTip5 => 'महीना शुरू होने से पहले हर रुपये को एक काम दें।';

  @override
  String get introTip6 => 'किसी भी बिना सोची ख़रीद से पहले 24 घंटे रुकें।';

  @override
  String get introTip7 =>
      'बजट रोक नहीं है, यह ज़रूरी चीज़ों पर ख़र्च करने की इजाज़त है।';

  @override
  String get introTip8 =>
      'छोटी जीत का जश्न मनाएँ: हर लक्ष्य पहली जमा से शुरू होता है।';

  @override
  String get adConfirmTitleAiCall => 'एक और AI अनुरोध पाएँ';

  @override
  String get adConfirmTitleTheme => '24 घंटे के लिए Premium थीम आज़माएँ';

  @override
  String get adConfirmTitlePdf => 'एक PDF रिपोर्ट एक्सपोर्ट करें';

  @override
  String get adConfirmBodyAiCall =>
      'आपने इस महीने के मुफ़्त AI अनुरोध इस्तेमाल कर लिए हैं। एक छोटा विज्ञापन देखें और एक और पाएँ।';

  @override
  String get adConfirmBodyTheme =>
      'एक छोटा विज्ञापन देखें और अगले 24 घंटे के लिए हर Premium थीम आपकी।';

  @override
  String get adConfirmBodyPdf =>
      'एक PDF रिपोर्ट एक्सपोर्ट करने के लिए एक छोटा विज्ञापन देखें।';

  @override
  String get adConfirmWarning => 'आप एक विज्ञापन देखने वाले हैं। जारी रखें?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस महीने $count और विज्ञापन उपलब्ध',
      one: 'इस महीने 1 और विज्ञापन उपलब्ध',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Premium सदस्यों को असीमित AI, हर थीम और PDF रिपोर्ट मिलती है, बिल्कुल बिना विज्ञापन।';

  @override
  String get adWatch => 'विज्ञापन देखें';

  @override
  String get adGetPremium => 'Premium लें';

  @override
  String get adNotNow => 'अभी नहीं';

  @override
  String get adLoading => 'विज्ञापन लोड हो रहा है…';

  @override
  String get adVerifying => 'आपका इनाम पक्का किया जा रहा है…';

  @override
  String get adUnavailable =>
      'अभी कोई विज्ञापन उपलब्ध नहीं है। कृपया थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get adSkipped =>
      'विज्ञापन पूरा होने से पहले बंद हो गया, इसलिए कुछ अनलॉक नहीं हुआ।';

  @override
  String get adRewardAiCall => 'हो गया! आपके पास एक और AI अनुरोध है।';

  @override
  String get adRewardTheme => 'Premium थीम 24 घंटे के लिए अनलॉक।';

  @override
  String get adRewardPdf => 'एक PDF एक्सपोर्ट अनलॉक।';

  @override
  String get adMonthlyCapReached =>
      'इस महीने के सारे विज्ञापन हो गए। आपके मुफ़्त अनुरोध 1 तारीख़ को वापस आएँगे, या असीमित के लिए Premium लें।';

  @override
  String get adRewardPending => 'धन्यवाद! आपका इनाम कुछ ही पल में दिखेगा।';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस महीने $count मुफ़्त AI अनुरोध बचे',
      one: 'इस महीने 1 मुफ़्त AI अनुरोध बचा',
      zero: 'इस महीने कोई मुफ़्त AI अनुरोध नहीं बचा',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: असीमित';

  @override
  String get aiToolSearching => 'आपके लेन-देन खोजे जा रहे हैं…';

  @override
  String get aiToolSummarizing => 'आँकड़े जोड़े जा रहे हैं…';

  @override
  String get aiToolAccounts => 'आपके खाते जाँचे जा रहे हैं…';

  @override
  String get aiToolCategories => 'आपकी श्रेणियाँ देखी जा रही हैं…';

  @override
  String get aiToolCards => 'कार्ड बिल जाँचे जा रहे हैं…';

  @override
  String get aiToolPlans => 'EMI और बचत जाँची जा रही है…';

  @override
  String get aiToolSaving => 'सेव हो रहा है…';

  @override
  String get aiActionAddTitle => 'यह लेन-देन जोड़ें?';

  @override
  String get aiActionUpdateTitle => 'यह लेन-देन बदलें?';

  @override
  String get aiActionDeleteTitle => 'यह लेन-देन हटाएँ?';

  @override
  String get aiActionPayCardTitle => 'कार्ड बिल चुकाएँ';

  @override
  String get aiActionCardSettingsTitle => 'कार्ड की तारीख़ें बदलें';

  @override
  String get aiActionCreatePlanTitle => 'प्लान शुरू करें';

  @override
  String get aiActionPayPlanTitle => 'प्लान भुगतान दर्ज करें';

  @override
  String get aiActionClosePlanTitle => 'प्लान जल्दी बंद करें';

  @override
  String get aiActionUpdatePlanTitle => 'प्लान बदलें';

  @override
  String get aiActionCreateInvestmentTitle => 'निवेश जोड़ें';

  @override
  String get aiActionTradeInvestmentTitle => 'ट्रेड दर्ज करें';

  @override
  String get aiActionUpdateInvestmentTitle => 'भाव अपडेट करें';

  @override
  String get aiActionConfirm => 'पुष्टि करें';

  @override
  String get aiActionClosePlan => 'बंद करें';

  @override
  String get aiActionFrom => 'से';

  @override
  String get aiActionTo => 'को';

  @override
  String get aiActionBill => 'बिल';

  @override
  String get aiActionLeftAfter => 'बाद में बाक़ी';

  @override
  String get aiActionRemindDays => 'याद दिलाएँ, कितने दिन पहले';

  @override
  String get aiActionPay => 'चुकाएँ';

  @override
  String get plansTitle => 'EMI, लोन और बचत';

  @override
  String get investmentsTitle => 'निवेश';

  @override
  String get investmentsSubtitle =>
      'म्यूचुअल फ़ंड, शेयर और SIP, उनके ताज़ा भाव पर';

  @override
  String get forecastTitle => 'कैश फ़्लो अनुमान';

  @override
  String get forecastSubtitle =>
      'आपका नकद और बैंक का पैसा किधर जा रहा है, और किस दिन कम पड़ेगा';

  @override
  String forecastRangeDays(int days) {
    return '$days दिन';
  }

  @override
  String get forecastNow => 'अभी नकद और बैंक';

  @override
  String get forecastMoneyIn => 'आने वाला';

  @override
  String get forecastMoneyOut => 'जाने वाला';

  @override
  String get forecastLowest => 'सबसे कम';

  @override
  String forecastLowestOn(String date) {
    return '$date को';
  }

  @override
  String get forecastChartTitle => 'अनुमानित बैलेंस';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return '$date को आपके पास $amount कम पड़ेंगे';
  }

  @override
  String get forecastShortfallCause => 'उस दिन जाने वाला:';

  @override
  String get forecastAlreadyShort =>
      'आपके नकद और बैंक खाते पहले से ही शून्य से नीचे हैं।';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'अगले $days दिनों में कोई कमी नहीं';
  }

  @override
  String get forecastAllCoveredBody =>
      'जो तय है, वह आपके नकद और बैंक के पैसे से पूरा हो जाता है।';

  @override
  String get forecastScheduledOnly =>
      'केवल तय चीज़ें गिनी जाती हैं: प्लान, कार्ड बिल, सब्सक्रिप्शन, दोहराए जाने वाले और आने वाले भुगतान, और नियत तारीख़ वाले लोन। रोज़ का ख़र्च शामिल नहीं है।';

  @override
  String get forecastEventsTitle => 'आने वाले';

  @override
  String forecastDayBalance(String amount) {
    return 'बैलेंस $amount';
  }

  @override
  String get forecastEmptyTitle => 'कुछ तय नहीं';

  @override
  String get forecastEmptyBody =>
      'इस अवधि के प्लान, कार्ड बिल, सब्सक्रिप्शन और आने वाले भुगतान यहाँ दिखते हैं।';

  @override
  String get forecastOverdue => 'बकाया';

  @override
  String get forecastExpected => 'अपेक्षित';

  @override
  String get forecastEventWhen => 'कब';

  @override
  String get forecastEventKind => 'प्रकार';

  @override
  String get forecastEventAccount => 'खाता';

  @override
  String get forecastEventOpen => 'खोलें';

  @override
  String get forecastEventOverdueNote =>
      'इसकी तारीख़ निकल चुकी है और यह अब भी बाक़ी है, इसलिए इसे आज देय माना गया है।';

  @override
  String get forecastKindInstallment => 'किस्त';

  @override
  String get forecastKindPremium => 'प्रीमियम';

  @override
  String get forecastKindDeposit => 'जमा';

  @override
  String get forecastKindSipBuy => 'SIP ख़रीद';

  @override
  String get forecastKindProfit => 'मुनाफ़ा';

  @override
  String get forecastKindMaturity => 'मैच्योरिटी';

  @override
  String get forecastKindCardBill => 'कार्ड बिल';

  @override
  String get forecastKindCardBillNext => 'अगला कार्ड बिल, अब तक';

  @override
  String get forecastKindSubscription => 'सब्सक्रिप्शन';

  @override
  String get forecastKindRecurringBill => 'दोहराया जाने वाला भुगतान';

  @override
  String get forecastKindRecurringIncome => 'दोहराई जाने वाली आय';

  @override
  String get forecastKindUpcoming => 'आने वाला';

  @override
  String get forecastKindBorrowed => 'चुकाना है लोन';

  @override
  String get forecastKindLent => 'उधार दिया, वापस आना है';

  @override
  String forecastHomeWarning(String date, String amount) {
    return '$date को आपके पास $amount कम पड़ सकते हैं';
  }

  @override
  String get forecastHomeWarningBody => 'देखें क्या आने वाला है';

  @override
  String get forecastDismiss => 'हटाएँ';

  @override
  String forecastNotifTitle(String day) {
    return '$day को पैसे कम पड़ सकते हैं';
  }

  @override
  String get settingsBillReminders => 'बिल और किस्त रिमाइंडर';

  @override
  String get settingsBillRemindersSub =>
      'देय कार्ड बिल, और आने वाली EMI या बचत की किस्तें';

  @override
  String get forecastNotifNowTitle => 'आज आपके पास पैसे कम हैं';

  @override
  String forecastNotifNowBody(String amount) {
    return 'अभी जो देय है वह आपके खातों में मौजूद पैसे से $amount ज़्यादा है। आने वाली चीज़ें देखने के लिए टैप करें।';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'तय भुगतानों के बाद आपके पास $amount कम पड़ेंगे। आने वाली चीज़ें देखने के लिए टैप करें।';
  }

  @override
  String get investmentsEmptyTitle => 'अभी कोई निवेश नहीं';

  @override
  String get investmentsEmptyBody =>
      'म्यूचुअल फ़ंड, शेयर या सोने का हिसाब रखें: आपने कितना दिया, अभी कितने का है, और कितना फ़ायदा हुआ।';

  @override
  String get investmentsSold => 'बेचे गए';

  @override
  String get investmentsWorth => 'अभी की क़ीमत';

  @override
  String get investmentNew => 'नया निवेश';

  @override
  String get investmentNewHint =>
      'फ़ंड की यूनिट, किसी कंपनी के शेयर, या यूनिट के हिसाब से ख़रीदी गई कोई भी चीज़, जैसे ग्राम के हिसाब से सोना।';

  @override
  String get investmentKindFund => 'फ़ंड';

  @override
  String get investmentKindStock => 'शेयर';

  @override
  String get investmentKindOther => 'अन्य';

  @override
  String get investmentNameHintFund => 'जैसे, SBI ब्लूचिप फ़ंड';

  @override
  String get investmentNameHintStock => 'जैसे, रिलायंस इंडस्ट्रीज़';

  @override
  String get investmentNameHintOther => 'जैसे, सोना, 22 कैरेट';

  @override
  String get investmentSymbol => 'सिंबल या कोड (वैकल्पिक)';

  @override
  String get investmentFirstBuy => 'आपने क्या ख़रीदा';

  @override
  String get investmentFirstBuyHint =>
      'अभी कुछ ख़रीदे बिना जोड़ने के लिए राशि ख़ाली छोड़ें।';

  @override
  String get investmentPaid => 'चुकाया';

  @override
  String get investmentReceived => 'मिला';

  @override
  String get investmentPaidInto => 'किस खाते में आया';

  @override
  String get investmentFee => 'शुल्क या कमीशन';

  @override
  String get investmentUnits => 'यूनिट';

  @override
  String get investmentUnitsSold => 'बेची गई यूनिट';

  @override
  String investmentUnitsShort(String units) {
    return '$units यूनिट';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price प्रति यूनिट';
  }

  @override
  String get investmentNeedUnits => 'बताएँ कितनी यूनिट ख़रीदी गईं।';

  @override
  String get investmentSave => 'निवेश जोड़ें';

  @override
  String get investmentAdded => 'निवेश जोड़ा गया';

  @override
  String get investmentGone => 'यह निवेश हटा दिया गया।';

  @override
  String get netWorthSubtitle =>
      'आपकी सारी संपत्ति, बकाया घटाकर, और यह कैसे बदली';

  @override
  String get netWorthToday => 'आपकी नेट वर्थ';

  @override
  String netWorthSinceLastMonth(String amount) {
    return 'पिछले महीने से $amount';
  }

  @override
  String get netWorthBreakdown => 'यह किससे बनी है';

  @override
  String get netWorthCash => 'नकद और बैंक';

  @override
  String get netWorthCards => 'क्रेडिट कार्ड';

  @override
  String get netWorthDeposits => 'बचत जमा';

  @override
  String get netWorthAssets => 'संपत्तियाँ';

  @override
  String get netWorthLent => 'दूसरों को उधार';

  @override
  String get netWorthBorrowed => 'उधार लिया';

  @override
  String get netWorthLoansNote =>
      'उधार दिया पैसा वापस मिलने तक आपका गिना जाता है, और उधार लिया पैसा चुकाने तक आपके ख़िलाफ़ गिना जाता है।';

  @override
  String get netWorthCardsLeftOut =>
      'क्रेडिट कार्ड नहीं गिने जाते; आप इसे सेटिंग्स में बदल सकते हैं।';

  @override
  String get netWorthHistory => 'हर महीने के अंत में';

  @override
  String get netWorthSixMonths => '6 महीने';

  @override
  String get netWorthOneYear => '1 साल';

  @override
  String get netWorthAllTime => 'सभी';

  @override
  String get netWorthHistoryEmpty =>
      'आपके रिकॉर्ड के साथ एक महीना पूरा होने पर लाइन शुरू होगी।';

  @override
  String get assetNew => 'संपत्ति जोड़ें';

  @override
  String get assetNewHint =>
      'ज़मीन, फ़्लैट या घर, गाड़ी, सोना या आपकी कोई भी चीज़। इसकी क़ीमत आपकी नेट वर्थ में गिनी जाती है।';

  @override
  String get assetKind => 'यह क्या है';

  @override
  String get assetKindLand => 'ज़मीन';

  @override
  String get assetKindHome => 'फ़्लैट या घर';

  @override
  String get assetKindCar => 'गाड़ी';

  @override
  String get assetKindGold => 'सोना और गहने';

  @override
  String get assetKindOther => 'कुछ और';

  @override
  String get assetNameHintLand => 'जैसे, नोएडा में प्लॉट';

  @override
  String get assetNameHintHome => 'जैसे, पुणे में फ़्लैट';

  @override
  String get assetNameHintCar => 'जैसे, मारुति स्विफ़्ट';

  @override
  String get assetNameHintGold => 'जैसे, शादी के गहने';

  @override
  String get assetNameHintOther => 'जैसे, कैमरा';

  @override
  String get assetWorthNow => 'अभी की क़ीमत';

  @override
  String get assetBoughtNow => 'किसी खाते से भुगतान किया';

  @override
  String get assetBoughtNowHint =>
      'बंद: यह पहले से आपकी है, और कोई पैसा नहीं जाता।';

  @override
  String get assetSave => 'संपत्ति जोड़ें';

  @override
  String get assetAdded => 'संपत्ति जोड़ी गई';

  @override
  String get assetsEmptyTitle => 'अभी कोई संपत्ति नहीं';

  @override
  String get assetsEmptyBody =>
      'अपनी पूरी नेट वर्थ देखने के लिए ज़मीन, घर, गाड़ी या सोना जोड़ें।';

  @override
  String get assetsSold => 'बेची गई';

  @override
  String assetCostLine(String amount) {
    return 'लागत $amount';
  }

  @override
  String get assetUpdateValue => 'क़ीमत अपडेट करें';

  @override
  String get assetSell => 'बेचें';

  @override
  String get assetDelete => 'हटाएँ';

  @override
  String get assetValueUpdated => 'क़ीमत अपडेट हुई';

  @override
  String get assetSold => 'बेच दी गई, और पैसा दर्ज हुआ';

  @override
  String assetDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get assetDeleteBody =>
      'अब यह नहीं गिनी जाएगी। इसका इतिहास आपके रिकॉर्ड में रहेगा।';

  @override
  String get assetDeleted => 'संपत्ति हटाई गई';

  @override
  String get aiActionCreateAssetTitle => 'संपत्ति जोड़ें';

  @override
  String get aiActionUpdateAssetTitle => 'संपत्ति की क़ीमत अपडेट करें';

  @override
  String get aiActionSellAssetTitle => 'संपत्ति बेचें';

  @override
  String get investmentWorthNow => 'अभी की क़ीमत';

  @override
  String investmentGainLine(String gain) {
    return 'कुल $gain';
  }

  @override
  String get investmentPrice => 'भाव';

  @override
  String get investmentPutIn => 'लगाया';

  @override
  String get investmentTakenOut => 'निकाला';

  @override
  String get investmentBuy => 'ख़रीदें';

  @override
  String get investmentSell => 'बेचें';

  @override
  String investmentBuyTitle(String name) {
    return '$name ख़रीदें';
  }

  @override
  String investmentSellTitle(String name) {
    return '$name बेचें';
  }

  @override
  String investmentDividendTitle(String name) {
    return '$name से डिविडेंड';
  }

  @override
  String get investmentDividend => 'डिविडेंड';

  @override
  String get investmentRecordDividend => 'डिविडेंड दर्ज करें';

  @override
  String investmentHeldNow(String units) {
    return 'अभी $units यूनिट हैं।';
  }

  @override
  String get investmentRecorded => 'दर्ज हुआ';

  @override
  String get investmentUpdatePrice => 'भाव अपडेट करें';

  @override
  String get investmentUpdatePriceHint => 'आज का NAV या शेयर भाव, एक यूनिट का';

  @override
  String get investmentPriceUpdated => 'भाव अपडेट हुआ';

  @override
  String get investmentStartSip => 'SIP शुरू करें';

  @override
  String get investmentStartSipHint => 'हर महीने एक तय राशि अपने-आप ख़रीदें';

  @override
  String get investmentHistory => 'इतिहास';

  @override
  String investmentBought(String units) {
    return '$units यूनिट ख़रीदीं';
  }

  @override
  String investmentSold(String units) {
    return '$units यूनिट बेचीं';
  }

  @override
  String get investmentPriceRose => 'भाव बढ़ा';

  @override
  String get investmentPriceFell => 'भाव घटा';

  @override
  String get investmentUnitsUnknown =>
      'यूनिट अभी पता नहीं, जोड़ने के लिए टैप करें';

  @override
  String get investmentCorrectUnits => 'इस ट्रेड की यूनिट';

  @override
  String get investmentCorrectUnitsHint =>
      'जैसा आपके फ़ंड या ब्रोकर स्टेटमेंट में लिखा है।';

  @override
  String get investmentUnitsCorrected => 'यूनिट सुधारी गईं';

  @override
  String get investmentDelete => 'यह निवेश हटाएँ';

  @override
  String investmentDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get investmentDeleteBody =>
      'इसके ट्रेड आपके इतिहास में रहेंगे। सब कुछ बिक जाने के बाद ही संभव है।';

  @override
  String get investmentDeleted => 'निवेश हटाया गया';

  @override
  String get plansSubtitle =>
      'EMI, लोन, DPS, FDR, बीमा, बॉन्ड और SIP, समय पर चुकाए और वसूले गए';

  @override
  String get planNew => 'प्लान शुरू करें';

  @override
  String get planNewTitle => 'आप क्या शुरू कर रहे हैं?';

  @override
  String get plansEmptyTitle => 'अभी कोई EMI, लोन या बचत नहीं';

  @override
  String get plansEmptyBody =>
      'किस्तों पर ख़रीदी चीज़, लोन, DPS या FDR का हिसाब रखें। किस्तें अपने दिन पर दर्ज होती हैं और हर एक से पहले आपको याद दिलाया जाता है।';

  @override
  String get plansEnded => 'पूरे हुए';

  @override
  String get planKindEmi => 'EMI';

  @override
  String get planKindLoan => 'लोन';

  @override
  String get planKindDps => 'DPS';

  @override
  String get planKindFdr => 'FDR';

  @override
  String get planKindInsurance => 'बीमा';

  @override
  String get planKindBond => 'बॉन्ड या सर्टिफ़िकेट';

  @override
  String get planKindSip => 'SIP';

  @override
  String get planKindEmiHint =>
      'किस्तों पर ख़रीदी गई चीज़, नकद, बैंक खाते या कार्ड से चुकाई जाती है';

  @override
  String get planKindLoanHint =>
      'उधार लिया पैसा, ब्याज के साथ किस्तों में चुकाया जाता है';

  @override
  String get planKindDpsHint =>
      'तय समय तक हर महीने एक तय राशि बचाएँ, और मुनाफ़े के साथ वापस पाएँ (RD जैसा)';

  @override
  String get planKindFdrHint =>
      'बैंक में एक राशि तय समय के लिए रखें, मुनाफ़ा हर महीने, हर तीन महीने या अंत में (FD जैसा)';

  @override
  String get planKindInsuranceHint =>
      'एक पॉलिसी जिसका प्रीमियम हर महीने, तिमाही या साल में जाता है, और अगर हो तो अंत में भुगतान मिलता है';

  @override
  String get planKindBondHint =>
      'बॉन्ड या बचत सर्टिफ़िकेट: एक राशि सालों तक रखी जाती है, मुनाफ़ा हर महीने, हर तीन महीने या अंत में, टैक्स के बाद';

  @override
  String get planKindSipHint =>
      'हर महीने एक तय राशि फ़ंड या शेयर में, ताज़ा भाव पर ख़रीदी जाती है';

  @override
  String get planWeekly => 'साप्ताहिक';

  @override
  String get planMonthly => 'मासिक';

  @override
  String get planQuarterly => 'तिमाही';

  @override
  String get planHalfYearly => 'छमाही';

  @override
  String get planYearly => 'सालाना';

  @override
  String get planMonths => 'महीने';

  @override
  String get planYears => 'साल';

  @override
  String planFdrLine(String amount, String date) {
    return '$date तक $amount';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$total में से $saved बचाए';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$total में से $paid चुकाए';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'अगला: $date को $amount';
  }

  @override
  String get planStatusCompleted => 'पूरा हुआ';

  @override
  String get planStatusClosed => 'बंद';

  @override
  String get planStatusOverdue => 'बकाया';

  @override
  String get planStatusRunning => 'चालू';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$total में से $done';
  }

  @override
  String get planGone => 'यह प्लान हटा दिया गया है।';

  @override
  String get planAccount => 'खाता';

  @override
  String get planAccountEmi => 'यहाँ से चुकाया';

  @override
  String get planAccountLoan => 'यहाँ आया और यहीं से चुकाया';

  @override
  String get planAccountSaving => 'खाते से';

  @override
  String get planPrice => 'क़ीमत';

  @override
  String get planBorrowed => 'उधार ली गई राशि';

  @override
  String get planDeposited => 'जमा की गई राशि';

  @override
  String get planDeposit => 'हर जमा';

  @override
  String get planInstallment => 'हर किस्त';

  @override
  String get planWorkedOut => 'क़ीमत, दर और अवधि से निकाला गया';

  @override
  String get planProgress => 'पूरा हुआ';

  @override
  String get planSavedSoFar => 'अब तक बचाया';

  @override
  String get planPaidSoFar => 'अब तक चुकाया';

  @override
  String get planLeft => 'बाक़ी';

  @override
  String get planTotal => 'कुल मिलाकर';

  @override
  String get planInterestCharges => 'ब्याज और शुल्क';

  @override
  String get planRate => 'दर';

  @override
  String get planRateLabel => 'दर % सालाना';

  @override
  String get planRateOptional => 'वैकल्पिक';

  @override
  String get planPayout => 'मुनाफ़े का भुगतान';

  @override
  String get planPayoutMonthly => 'हर महीने';

  @override
  String get planPayoutQuarterly => 'हर 3 महीने';

  @override
  String get planPayoutAtMaturity => 'अंत में';

  @override
  String get planMaturesOn => 'मैच्योरिटी की तारीख़';

  @override
  String get planMaturity => 'अंत में वापस मिलता है';

  @override
  String get planEstimated =>
      'दर से अनुमानित; बैंक की राशि डालने के लिए टैप करें';

  @override
  String get planHolding => 'अभी जमा में';

  @override
  String get planEnds => 'आख़िरी किस्त';

  @override
  String planTakeMaturity(String amount) {
    return 'मैच्योरिटी लें, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'मुनाफ़ा दर्ज करें, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'किस्त $number अभी चुकाएँ, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'प्रीमियम $number अभी चुकाएँ, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'जमा $number अभी करें, $amount';
  }

  @override
  String get planRecorded => 'दर्ज हुआ।';

  @override
  String get planSaved => 'सेव हुआ।';

  @override
  String get planPayOff => 'जल्दी चुका दें';

  @override
  String get planEncash => 'जल्दी भुनाएँ';

  @override
  String get planSurrender => 'पॉलिसी सरेंडर करें';

  @override
  String planSurrenderTitle(String name) {
    return '$name सरेंडर करें?';
  }

  @override
  String get planSurrenderBody =>
      'प्रीमियम रुक जाएँगे। बीमा कंपनी जो भी वापस देगी, वह आय के रूप में दर्ज होगा।';

  @override
  String get planSurrenderNothing => 'कुछ वापस नहीं मिला';

  @override
  String get planSurrenderValue => 'सरेंडर वैल्यू डालें';

  @override
  String get planSurrenderValueLabel => 'सरेंडर वैल्यू';

  @override
  String get planStopSip => 'SIP रोकें';

  @override
  String planStopSipTitle(String name) {
    return '$name रोकें?';
  }

  @override
  String get planStopSipBody =>
      'अब और ख़रीद नहीं। जो ख़रीदा गया वह निवेश में रहेगा।';

  @override
  String get planSipStopped => 'SIP रोकी गई';

  @override
  String get planSave => 'सेव करें';

  @override
  String get planSurrendered => 'पॉलिसी सरेंडर हुई';

  @override
  String planPayOffTitle(String name) {
    return '$name चुका दें?';
  }

  @override
  String get planPayOffHint => 'बाक़ी के लिए एक भुगतान, और प्लान ख़त्म।';

  @override
  String planPayOffLeft(String amount) {
    return 'बाक़ी चुकाएँ, $amount';
  }

  @override
  String get planPayOffOther => 'लोन देने वाले ने दूसरी राशि बताई';

  @override
  String planEncashTitle(String name) {
    return '$name भुनाएँ?';
  }

  @override
  String get planEncashBody =>
      'जमा में जो है वह अपने खाते में वापस जाएगा, और प्लान ख़त्म होगा।';

  @override
  String get planEncashNoProfit => 'भुनाएँ, बिना मुनाफ़े के';

  @override
  String get planEncashWithProfit => 'भुनाएँ, बैंक के दिए मुनाफ़े के साथ';

  @override
  String get planEncashed => 'भुना लिया। पैसा अपने खाते में वापस आ गया।';

  @override
  String get planPaidOff => 'चुका दिया।';

  @override
  String get planAutoCollect => 'अपने-आप दर्ज करें';

  @override
  String get planAutoCollectHint =>
      'हर किस्त, मुनाफ़ा और मैच्योरिटी अपने दिन पर दर्ज होती है';

  @override
  String get planSchedule => 'शेड्यूल';

  @override
  String get planDelete => 'यह प्लान हटाएँ';

  @override
  String planDeleteTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get planDeleteBody =>
      'इसने जो दर्ज किया वह आपके लेन-देन में रहेगा। आगे कुछ दर्ज नहीं होगा और कोई याद नहीं दिलाई जाएगी।';

  @override
  String get planDeleted => 'हटा दिया गया।';

  @override
  String planEventInstallment(int number, int total) {
    return '$total में से किस्त $number';
  }

  @override
  String planEventPremium(int number, int total) {
    return '$total में से प्रीमियम $number';
  }

  @override
  String get planEventPayout => 'पॉलिसी का भुगतान';

  @override
  String planEventProfit(int number) {
    return 'मुनाफ़ा, महीना $number';
  }

  @override
  String get planEventMaturity => 'मैच्योरिटी';

  @override
  String get planEventDone => 'हो गया';

  @override
  String get planEventLate => 'बकाया';

  @override
  String get planEventUpcoming => 'आने वाला';

  @override
  String get planNeedAccount => 'पहले खाता चुनें।';

  @override
  String get planCreated =>
      'शुरू हो गया। जो पहले से देय था, वह दर्ज कर दिया गया है।';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, जिसमें $interest ब्याज और शुल्क है।';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, बिना ब्याज।';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'आप $deposited जमा करते हैं और $date को लगभग $maturity वापस पाते हैं।';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal बढ़कर $date तक लगभग $maturity हो जाएगा।';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'हर महीने $profit मुनाफ़ा, और $date को $principal वापस।';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$premium के $count प्रीमियम, कुल $total।';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$premium के $count प्रीमियम, कुल $total, और $date को $payout वापस।';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'हर तीन महीने $profit मुनाफ़ा, और $date को $principal वापस।';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$fund में $count × $amount, कुल $total।';
  }

  @override
  String planNewKind(String kind) {
    return 'नया $kind';
  }

  @override
  String get planName => 'नाम';

  @override
  String get planNameHintEmi => 'जैसे, Flipkart से फ़ोन';

  @override
  String get planNameHintLoan => 'जैसे, बाइक लोन';

  @override
  String get planNameHintDps => 'जैसे, पोस्ट ऑफ़िस RD';

  @override
  String get planNameHintFdr => 'जैसे, SBI FD';

  @override
  String get planNameHintInsurance => 'जैसे, जीवन बीमा पॉलिसी';

  @override
  String get planNameHintBond => 'जैसे, 5 साल का NSC';

  @override
  String get planNameHintSip => 'जैसे, मासिक फ़ंड SIP';

  @override
  String get planSipFund => 'ख़रीदता है';

  @override
  String get planSipAmount => 'हर SIP';

  @override
  String get planSipNoFund => 'पहले निवेश में फ़ंड या शेयर जोड़ें।';

  @override
  String get planProvider => 'बैंक या कंपनी';

  @override
  String get planReference => 'पॉलिसी या खाता नं.';

  @override
  String get planSumAssured => 'बीमा राशि';

  @override
  String get planPremium => 'प्रीमियम';

  @override
  String get planPremiums => 'प्रीमियम';

  @override
  String get planTaxLabel => 'स्रोत पर टैक्स (TDS) %';

  @override
  String get planTax => 'स्रोत पर टैक्स (TDS)';

  @override
  String get planFirstPremium => 'पहला प्रीमियम';

  @override
  String get planLastPremium => 'आख़िरी प्रीमियम';

  @override
  String get planInsurancePayout => 'अंत में वापस मिलता है';

  @override
  String get planNone => 'कोई नहीं';

  @override
  String get planHowMany => 'कितने';

  @override
  String get planTerm => 'अवधि';

  @override
  String get planOpenedOn => 'खोलने की तारीख़';

  @override
  String get planFirstDue => 'पहली किस्त';

  @override
  String get planCategory => 'श्रेणी';

  @override
  String get planCategoryDefault => 'लोन भुगतान';

  @override
  String get planCategoryInsurance => 'बीमा';

  @override
  String get planLoanReceived => 'पैसा इस खाते में आया';

  @override
  String get planLoanReceivedHint => 'बंद करें अगर सीधे विक्रेता को गया';

  @override
  String get planStart => 'शुरू करें';

  @override
  String get aiActionDeleteNote =>
      'यह \'हाल ही में हटाए गए\' में जाएगा, जहाँ से आप 30 दिन तक वापस ला सकते हैं।';

  @override
  String get aiActionAdd => 'जोड़ें';

  @override
  String get aiActionSave => 'बदलाव सेव करें';

  @override
  String get aiActionDelete => 'हटाएँ';

  @override
  String get aiActionCancel => 'नहीं, रहने दें';

  @override
  String get aiActionAmount => 'राशि';

  @override
  String get aiActionKind => 'प्रकार';

  @override
  String get aiActionTitle => 'शीर्षक';

  @override
  String get aiActionCategory => 'श्रेणी';

  @override
  String get aiActionAccount => 'खाता';

  @override
  String get aiActionDate => 'तारीख़';

  @override
  String get aiActionNotes => 'नोट्स';

  @override
  String get aiReport => 'समस्या बताएँ';

  @override
  String get aiReportWrongAnswer => 'कोच ने कुछ ग़लत बताया';

  @override
  String get aiReportWrongAnswerHint =>
      'ग़लत संख्या, गढ़ी हुई बात, या ऐसा बदलाव जो आपने माँगा नहीं';

  @override
  String get aiReportWrongAnswerSubject => 'मनी कोच: ग़लत जवाब';

  @override
  String get aiReportBug => 'बग बताएँ';

  @override
  String get aiReportBugHint => 'कुछ टूटा, अटका या लोड नहीं हुआ';

  @override
  String get aiReportBugSubject => 'मनी कोच: बग रिपोर्ट';

  @override
  String get aiAboutCoach => 'कोच कैसे काम करता है';

  @override
  String get aiDisclaimerTitle => 'कोच से पूछने से पहले';

  @override
  String get aiDisclaimerMistakes =>
      'कोच एक AI है। यह कोई संख्या ग़लत बता सकता है, सवाल ग़लत समझ सकता है या कोई ग़लत बात कह सकता है, इसलिए ज़रूरी चीज़ें अपने लेन-देन से मिला लें।';

  @override
  String get aiDisclaimerData =>
      'आपके आँकड़े आपके फ़ोन पर पढ़े जाते हैं। जवाब देने के लिए ऐप आपका सवाल और ज़रूरी आँकड़े हमारे सर्वर और उसके AI मॉडल को भेजता है।';

  @override
  String get aiDisclaimerChanges =>
      'यह कभी अपने-आप आपके पैसों में बदलाव नहीं करता। हर जोड़ना, बदलना या हटाना पहले आपको दिखाया जाता है और आपकी पुष्टि के बाद ही होता है।';

  @override
  String get aiDisclaimerReport =>
      'अगर कोई जवाब ग़लत लगे, तो हमें बताने के लिए ऊपर फ़्लैग पर टैप करें।';

  @override
  String get aiDisclaimerAccept => 'मैं समझ गया';

  @override
  String get aiOutOfRequestsTitle =>
      'आपने इस महीने के मुफ़्त अनुरोध इस्तेमाल कर लिए हैं';

  @override
  String get aiOutOfRequestsBody =>
      'यह सवाल पूछने के लिए एक छोटा विज्ञापन देखें, या बिना विज्ञापन असीमित जवाबों के लिए Premium लें। मुफ़्त अनुरोध 1 तारीख़ को वापस आते हैं।';

  @override
  String get ocrNoCamera => 'कैमरा नहीं खुल सका।';

  @override
  String get ocrNoGallery => 'गैलरी नहीं खुल सकी।';

  @override
  String get ocrScanTitle => 'रसीद स्कैन करें';

  @override
  String get ocrScanAnother => 'एक और स्कैन करें';

  @override
  String get ocrScanBody =>
      'फ़ोटो लें या चुनें। ऐप उसे पढ़ता है और AI ब्योरा भर देता है।';

  @override
  String get ocrReadingWithAi => 'AI आपकी रसीद पढ़ रहा है…';

  @override
  String get ocrNothingRead =>
      'उस फ़ोटो से कोई टेक्स्ट नहीं पढ़ा जा सका। बेहतर रोशनी में, पूरी रसीद दिखाते हुए फिर कोशिश करें।';

  @override
  String get ocrAiOfferTitle => 'AI से ठीक से पढ़वाएँ';

  @override
  String get ocrAiOfferBody =>
      'यह असली कुल, तारीख़, हर आइटम और सही श्रेणी ढूँढ लेता है, बिखरी रसीद पर भी।';

  @override
  String get ocrReadWithAi => 'AI से पढ़ें';

  @override
  String get ocrReadByAi => 'AI द्वारा पढ़ा गया। सेव करने से पहले जाँच लें।';

  @override
  String get ocrItems => 'आइटम';

  @override
  String get quickAddTitle => 'बताइए';

  @override
  String get quickAddSubtitle =>
      'वैसे ही लिखें जैसे आप बोलते हैं। AI फ़ॉर्म भर देगा, आप जाँच लें।';

  @override
  String get quickAddHint => 'जैसे, कल का लंच 250 bKash से';

  @override
  String get quickAddFill => 'भर दें';

  @override
  String get summaryTitle => 'मासिक सारांश';

  @override
  String get summarySpent => 'इस महीने ख़र्च';

  @override
  String summaryEarned(String amount) {
    return 'कमाई $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return 'पिछले महीने से $percent% कम';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return 'पिछले महीने से $percent% ज़्यादा';
  }

  @override
  String get summaryAiTitle => 'आपका महीना, संक्षेप में';

  @override
  String get summaryAiBody =>
      'AI आपके इस महीने की तुलना पिछले महीने से करता है और ख़ास बातें चुनता है, साथ में आज़माने के लिए एक सुझाव।';

  @override
  String get summaryWrite => 'मेरा सारांश लिखें';

  @override
  String get summaryOutdated =>
      'यह सारांश लिखे जाने के बाद आपके लेन-देन बदल गए हैं।';

  @override
  String get summaryUpdate => 'मेरा सारांश अपडेट करें';

  @override
  String get summaryWriting => 'आपका सारांश लिखा जा रहा है…';

  @override
  String get summaryByCategory => 'श्रेणी के अनुसार';

  @override
  String get summaryNoSpending => 'इस महीने अभी कोई ख़र्च दर्ज नहीं।';

  @override
  String themeTrialUntil(String time) {
    return 'Premium थीम $time तक अनलॉक';
  }

  @override
  String get zakatTitle => 'ज़कात';

  @override
  String get zakatSubtitle =>
      'अपनी दौलत पर देय ज़कात निकालें, और जो चुकाएँ उसे दर्ज करें';

  @override
  String get zakatSubtitleOff =>
      'आप ज़कात नहीं देते। फिर भी देखने के लिए टैप करें';

  @override
  String get zakatAskTitle => 'क्या आप ज़कात देते हैं?';

  @override
  String get zakatAskBody =>
      'हर कोई नहीं देता। अगर आप नहीं देते, तो ऐप ज़कात को आपके रास्ते से हटा देता है: कुछ देय नहीं और कोई रिमाइंडर नहीं।';

  @override
  String get zakatIPay => 'मैं ज़कात देता हूँ';

  @override
  String get zakatIDontPay => 'मैं ज़कात नहीं देता';

  @override
  String get zakatOffTitle => 'आप ज़कात नहीं देते';

  @override
  String get zakatOffBody =>
      'इसलिए ज़कात के बारे में कुछ भी देय नहीं दिखता, और कोई ज़कात रिमाइंडर नहीं हैं। आप कभी भी देख सकते हैं कि कितनी बनती; देखने से आपका जवाब नहीं बदलता।';

  @override
  String get zakatOffPeek => 'देखें कितनी बनती';

  @override
  String get zakatPeekBanner => 'बस एक झलक। आपने कहा है कि आप ज़कात नहीं देते।';

  @override
  String get zakatOptOutTitle => 'ज़कात का हिसाब बंद करें?';

  @override
  String get zakatOptOutBody =>
      'कुछ भी देय नहीं दिखेगा और कोई ज़कात रिमाइंडर नहीं होगा। आपके आँकड़े रखे रहेंगे, और आप यहाँ कभी भी देख सकते हैं।';

  @override
  String get zakatDue => 'देय ज़कात';

  @override
  String zakatAboveNisab(String amount) {
    return 'निसाब से ऊपर: $amount शुद्ध दौलत का 2.5%';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'निसाब से $amount कम, इसलिए कोई ज़कात देय नहीं';
  }

  @override
  String get zakatNeedPrice => 'निसाब जाँचने के लिए प्रति ग्राम भाव डालें';

  @override
  String get zakatPaidSoFar => 'इस साल चुकाई';

  @override
  String get zakatLeftToPay => 'चुकाना बाक़ी';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ज़कात की तारीख़ $date, $days दिन में',
      one: 'ज़कात की तारीख़ कल, $date',
      zero: 'आपकी ज़कात की तारीख़ आज है',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'साल का हिसाब रखने और रिमाइंडर पाने के लिए अपनी ज़कात की तारीख़ सेट करें';

  @override
  String get zakatPay => 'ज़कात चुकाएँ';

  @override
  String get zakatNisab => 'निसाब';

  @override
  String get zakatBasisGold => 'सोना';

  @override
  String get zakatBasisSilver => 'चाँदी';

  @override
  String get zakatBasisHint =>
      'चाँदी से निसाब कम आता है और जब आपकी दौलत ज़्यादातर नकद हो तो यह ज़्यादा सावधानी वाला विकल्प है। एक ग्राम का आज का स्थानीय भाव डालें।';

  @override
  String zakatPricePerGram(String metal) {
    return 'प्रति ग्राम भाव ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return 'उस भाव पर $grams ग्राम';
  }

  @override
  String get zakatGroupCash => 'नकद और बैंक';

  @override
  String get zakatGroupDeposits => 'बचत जमा';

  @override
  String get zakatGroupInvestments => 'निवेश';

  @override
  String get zakatGroupMetals => 'सोना और चाँदी';

  @override
  String get zakatGroupLent => 'दूसरों को उधार दिया पैसा';

  @override
  String get zakatGroupOtherAssets => 'अन्य संपत्तियाँ';

  @override
  String get zakatGroupPaid => 'इस साल चुकाई ज़कात';

  @override
  String get zakatGroupManual => 'आपके द्वारा जोड़ा गया';

  @override
  String get zakatGroupBorrowed => 'घटाएँ: आप पर बकाया पैसा';

  @override
  String get zakatGroupCards => 'घटाएँ: क्रेडिट कार्ड बकाया';

  @override
  String get zakatOtherAssetsNote =>
      'ज़मीन, घर या इस्तेमाल की गाड़ी पर ज़कात नहीं लगती। इसे तभी चालू करें जब आप इसे व्यापार के लिए रखते हों।';

  @override
  String get zakatPaidNote =>
      'वापस जोड़ा गया, क्योंकि साल की दौलत गिनने के बाद यह आपके खातों से गया।';

  @override
  String get zakatNoMetals =>
      'कोई सोना या चाँदी दर्ज नहीं है। इसे संपत्ति के रूप में जोड़ें, या नीचे इसकी क़ीमत जोड़ें।';

  @override
  String get zakatAddAmount => 'राशि जोड़ें';

  @override
  String get zakatAmountLabel => 'यह क्या है?';

  @override
  String get zakatAmountHint => 'कारोबार का स्टॉक, घर में नकद…';

  @override
  String get zakatAmountDeduct => 'यह अभी देय कर्ज़ है';

  @override
  String get zakatWealth => 'ज़कात योग्य दौलत';

  @override
  String get zakatDeductions => 'अभी देय कर्ज़';

  @override
  String get zakatNet => 'शुद्ध दौलत';

  @override
  String get zakatRate => 'शुद्ध दौलत का 2.5%';

  @override
  String get zakatYear => 'ज़कात का साल';

  @override
  String get zakatDate => 'ज़कात की तारीख़';

  @override
  String get zakatDateHint =>
      'जिस दिन आपका ज़कात साल पूरा होता है। यह हर चंद्र वर्ष, 354 दिन में आता है।';

  @override
  String get zakatRemind => 'मुझे याद दिलाएँ';

  @override
  String get zakatRemindHint => '3 दिन पहले, और उसी दिन';

  @override
  String get zakatDisclaimer =>
      'यह ज़कात निकालने में मदद के लिए एक गाइड है, धार्मिक फ़ैसला नहीं। कुछ बातों पर विद्वानों की राय अलग है; शक हो तो किसी स्थानीय आलिम से पूछें।';

  @override
  String get zakatPayNote =>
      'ज़कात के तहत ख़र्च के रूप में दर्ज, और इस साल में गिना गया।';

  @override
  String get zakatPayRecord => 'भुगतान दर्ज करें';

  @override
  String get zakatPaidSnack => 'ज़कात दर्ज हुई';

  @override
  String get aiToolZakat => 'ज़कात निकाली जा रही है…';

  @override
  String get voiceButton => 'लेन-देन बोलें';

  @override
  String get voiceTitle => 'बोलिए';

  @override
  String get voiceUnlimited => 'असीमित';

  @override
  String get voiceTapToTalk => 'गोले पर टैप करें और बताएँ क्या ख़र्च किया';

  @override
  String get voiceListening => 'सुन रहा है…';

  @override
  String get voiceStop => 'सुनना बंद करें';

  @override
  String get voiceTypeInstead => 'लिखें';

  @override
  String get voiceSpeakInstead => 'बोलें';

  @override
  String get voiceSend => 'हो गया';

  @override
  String get voiceTrySaying => 'ऐसे बोलकर देखें';

  @override
  String get voiceExample1 => 'लंच 250, रिक्शा 60';

  @override
  String get voiceExample2 => 'सैलरी मिली, 45,000';

  @override
  String get voiceExample3 => 'कल की चाय 30 थी, 20 नहीं';

  @override
  String get voiceExample4 => 'आज का लंच हटाओ';

  @override
  String get voiceTypeHint => 'लंच 250 और रिक्शा 60 bKash से';

  @override
  String get voiceThinking => 'समझा जा रहा है…';

  @override
  String get voiceTryAgain => 'फिर से';

  @override
  String get voiceSaving => 'सेव हो रहा है…';

  @override
  String get voiceEdit => 'बदलें';

  @override
  String get voiceNeedsYou => 'आपकी ज़रूरत है';

  @override
  String get voiceNew => 'नया';

  @override
  String get voiceChange => 'बदलाव';

  @override
  String get voiceRemove => 'हटाएँ';

  @override
  String get voiceNeedsAmount =>
      'कोई राशि नहीं बोली गई। इसे जोड़ने के लिए राशि भरें।';

  @override
  String get voiceAdjust => 'ठीक करें';

  @override
  String get voiceFillIn => 'भरें';

  @override
  String get voiceTime => 'समय';

  @override
  String get voiceUndo => 'पूर्ववत करें';

  @override
  String get voiceUndone => 'पहले जैसा कर दिया';

  @override
  String get voiceNoSpeech =>
      'मैं समझ नहीं पाया। फिर से कोशिश करें, या लिख दें।';

  @override
  String get voiceMicOff =>
      'माइक्रोफ़ोन की अनुमति बंद है। सेटिंग्स में अनुमति दें, या लिख दें।';

  @override
  String get voiceUnavailable =>
      'इस फ़ोन पर आवाज़ की सुविधा उपलब्ध नहीं है। आप लिख सकते हैं।';

  @override
  String get voiceSomethingWrong => 'कुछ गड़बड़ हो गई। फिर से कोशिश करें।';

  @override
  String get voiceFabSetting => '\'आज\' पर तैरता माइक';

  @override
  String get amountHidden => 'छिपी राशि';

  @override
  String get privacyShowAmounts => 'राशि दिखाएँ';

  @override
  String get privacyHideAmounts => 'राशि छिपाएँ';

  @override
  String get privacyAmounts => 'स्क्रीन पर राशि';

  @override
  String get privacyAmountsFooter =>
      'बैलेंस और कुल धुंधले कर दिए जाते हैं ताकि आस-पास के लोग न पढ़ सकें। अलग-अलग लेन-देन दिखते रहते हैं। \'आज\' पर आँख का आइकन भी इन्हें दिखाता या छिपाता है।';

  @override
  String get privacyHideTitle => 'बैलेंस और कुल छिपाएँ';

  @override
  String get privacyHideSub => 'जब तक आप न दिखाएँ, धुंधला रखें';

  @override
  String get privacyTapTitle => 'छिपी राशि दिखाने के लिए उस पर टैप करें';

  @override
  String get privacyTapSub =>
      'नहीं तो केवल \'आज\' पर आँख का आइकन इन्हें दिखाता है';

  @override
  String get privacyStartTitle => 'जब ऐप खुले';

  @override
  String get privacyStartHidden => 'छिपा हुआ';

  @override
  String get privacyStartHiddenSub => 'हमेशा बैलेंस और कुल छिपाकर खोलें';

  @override
  String get privacyStartShown => 'दिखता हुआ';

  @override
  String get privacyStartShownSub => 'हमेशा बैलेंस और कुल दिखाकर खोलें';

  @override
  String get privacyStartRemember => 'जैसा छोड़ा था';

  @override
  String get privacyStartRememberSub =>
      'आँख का आइकन जैसा आख़िरी बार छोड़ा था, वैसे खोलें';

  @override
  String get privacyIntroTitle => 'नया: अपने बैलेंस छिपाएँ';

  @override
  String get privacyIntroBody =>
      'बैलेंस और कुल अब छिपे रहते हैं, ताकि आस-पास के लोग न पढ़ सकें। दिखाने या छिपाने के लिए \'आज\' पर आँख के आइकन पर टैप करें; ऐप याद रखता है आपने कैसे छोड़ा। ऐप कैसे खुले, यह आप सेटिंग्स में चुन सकते हैं।';

  @override
  String get privacyIntroOk => 'समझ गया';

  @override
  String get privacyIntroSettings => 'सेटिंग्स में चुनें';

  @override
  String get voiceFabSettingSub =>
      '\'आज\' के ऊपर तैरता एक माइक, लेन-देन बोलने के लिए';

  @override
  String get voiceFabAskTitle => 'अपनी \'आज\' स्क्रीन पर माइक जोड़ें?';

  @override
  String get voiceFabAskBody =>
      'इस पर टैप करें और बताएँ क्या ख़र्च किया, जैसे \"लंच 250 और रिक्शा 60\"। सेव होने से पहले आप सब कुछ जाँचते हैं। इसे जहाँ चाहें खींचकर रखें।';

  @override
  String get voiceFabAskYes => 'हाँ, माइक जोड़ें';

  @override
  String get voiceFabAskNo => 'अभी नहीं';

  @override
  String get voiceFabAskLater =>
      'आप इसे \'और\' में कभी भी चालू या बंद कर सकते हैं।';

  @override
  String get voiceFabHideTitle => 'तैरता माइक छिपाएँ?';

  @override
  String get voiceFabHideBody =>
      '\'आज\' के ऊपर वाला माइक बना रहेगा। आप इसे \'और\' में वापस ला सकते हैं।';

  @override
  String get voiceFabHide => 'छिपाएँ';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेव के लिए तैयार',
      one: '1 सेव के लिए तैयार',
      zero: 'कुछ तैयार नहीं',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेव करें',
      one: '1 सेव करें',
      zero: 'कुछ नहीं चुना',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन सेव हुए',
      one: '1 लेन-देन सेव हुआ',
    );
    return '$_temp0';
  }
}
