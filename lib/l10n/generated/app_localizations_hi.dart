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
  String get settingsBillRemindersNote =>
      'कार्ड बिल और प्लान की किस्तों के रिमाइंडर ऐप आपके फ़ोन पर ही तैयार करता है, ताकि आपकी रकम निजी रहे। अगर आप कुछ दिन ऐप नहीं खोलते, तो कोई रिमाइंडर देर से आ सकता है या छूट सकता है।';

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
  String get voiceNeedsConnection =>
      'वॉइस के लिए कनेक्शन चाहिए। आप टाइप भी कर सकते हैं।';

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
  String get ppTitle => 'पासफ़्रेज़ सुरक्षा';

  @override
  String get ppRowOn => 'चालू';

  @override
  String get ppRowOff => 'बंद';

  @override
  String get ppRowLocked => 'इस फ़ोन पर लॉक है';

  @override
  String get ppIntro =>
      'आपका डेटा इस फ़ोन पर और आपके बैकअप में पहले से एन्क्रिप्ट है। पासफ़्रेज़ एक और ताला जोड़ता है, ताकि आपका सिंक किया गया डेटा और बैकअप सिर्फ़ आप खोल सकें — हम भी नहीं।';

  @override
  String get ppWithoutTitle => 'पासफ़्रेज़ के बिना (अभी जैसा है)';

  @override
  String get ppWithout1 => 'इस फ़ोन पर सब कुछ एन्क्रिप्ट है।';

  @override
  String get ppWithout2 =>
      'बैकअप और सिंक किया गया डेटा आपके खाते से जुड़ी एक कुंजी से एन्क्रिप्ट होता है।';

  @override
  String get ppWithout3 =>
      'नए फ़ोन पर साइन इन करें और सब कुछ वापस आ जाता है, कुछ भी याद रखने की ज़रूरत नहीं।';

  @override
  String get ppWithout4 =>
      'वह कुंजी हमारे सर्वर पर रहती है, इसलिए सैद्धांतिक रूप से हम आपका सिंक किया गया डेटा खोल सकते हैं।';

  @override
  String get ppWithTitle => 'पासफ़्रेज़ के साथ';

  @override
  String get ppWith1 =>
      'सिर्फ़ आपका पासफ़्रेज़ या रिकवरी कोड ही आपका सिंक किया गया डेटा और बैकअप खोल सकता है।';

  @override
  String get ppWith2 =>
      'हमारा सर्वर आपकी कुंजी की सिर्फ़ लॉक की हुई कॉपी रखता है। हम आपका डेटा नहीं पढ़ सकते, और हमारे सर्वर में सेंध लगाने वाला कोई भी नहीं पढ़ सकता।';

  @override
  String get ppWith3 =>
      'नए फ़ोन पर, या दोबारा इंस्टॉल करने के बाद, आपको एक बार अपना पासफ़्रेज़ डालना होगा।';

  @override
  String get ppWith4 =>
      'यह फ़ोन ठीक वैसे ही काम करता रहेगा जैसे अभी करता है, ऑफ़लाइन भी।';

  @override
  String get ppCatchTitle => 'ध्यान रखें';

  @override
  String get ppCatchBody =>
      'अगर आप अपना पासफ़्रेज़ भूल जाते हैं और रिकवरी कोड भी खो देते हैं, तो आपका सिंक किया गया डेटा या बैकअप कोई वापस नहीं ला सकता — न हम, न कोई और। इस फ़ोन पर जो पहले से है, वह यहाँ पढ़ा जा सकेगा।';

  @override
  String get ppAiNote =>
      'AI फ़ीचर जवाब देने के लिए अब भी आपके वित्त का एक सारांश भेजते हैं। पासफ़्रेज़ से इसमें कोई बदलाव नहीं होता।';

  @override
  String get ppSetButton => 'पासफ़्रेज़ सेट करें';

  @override
  String get ppSetTitle => 'पासफ़्रेज़ चुनें';

  @override
  String get ppSetHint =>
      'कम से कम 10 अक्षर इस्तेमाल करें। कुछ आपस में असंबंधित शब्द याद रखने में आसान और अंदाज़ा लगाने में मुश्किल होते हैं।';

  @override
  String get ppPassphraseLabel => 'पासफ़्रेज़';

  @override
  String get ppConfirmLabel => 'फिर से लिखें';

  @override
  String get ppTooShort => 'कम से कम 10 अक्षर इस्तेमाल करें।';

  @override
  String get ppMismatch => 'दोनों पासफ़्रेज़ मेल नहीं खाते।';

  @override
  String get ppUnderstand =>
      'मुझे पता है कि अगर मेरा पासफ़्रेज़ और रिकवरी कोड दोनों खो गए, तो मेरा सिंक किया गया डेटा और बैकअप वापस नहीं लाया जा सकेगा।';

  @override
  String get ppTurnOn => 'सुरक्षा चालू करें';

  @override
  String get ppWorking =>
      'आपकी कुंजी लॉक की जा रही है। इसमें कुछ सेकंड लगते हैं…';

  @override
  String get ppMaybeSaved =>
      'कनेक्शन टूट गया, इसलिए हो सकता है सर्वर ने इसे पहले ही सेव कर लिया हो। रिकवरी कोड दिखने तक इसे दोबारा करें, और वही कोड संभालकर रखें।';

  @override
  String get ppRecoveryTitle => 'आपका रिकवरी कोड';

  @override
  String get ppRecoveryBody =>
      'पासफ़्रेज़ भूल जाने पर आपके डेटा तक पहुँचने का यही एकमात्र दूसरा तरीका है। इसे लिख लें या किसी पासवर्ड मैनेजर में रखें — इस फ़ोन के अलावा कहीं और।';

  @override
  String get ppCopy => 'कॉपी करें';

  @override
  String get ppCopied => 'रिकवरी कोड कॉपी हो गया';

  @override
  String get ppSavedIt =>
      'मैंने अपना रिकवरी कोड किसी सुरक्षित जगह सेव कर लिया है';

  @override
  String get ppDone => 'हो गया';

  @override
  String get ppOnTitle => 'सुरक्षा चालू है';

  @override
  String get ppOnBody =>
      'सिर्फ़ आपका पासफ़्रेज़ या रिकवरी कोड ही आपका सिंक किया गया डेटा और बैकअप खोल सकता है।';

  @override
  String get ppChange => 'पासफ़्रेज़ बदलें';

  @override
  String get ppNewCode => 'नया रिकवरी कोड पाएँ';

  @override
  String get ppNewCodeWarn =>
      'आपका मौजूदा रिकवरी कोड काम करना बंद कर देगा। नया कोड ज़रूर सेव कर लें।';

  @override
  String get ppTurnOff => 'सुरक्षा बंद करें';

  @override
  String get ppTurnOffBody =>
      'पहले की तरह हमारा सर्वर फिर से आपकी कुंजी रखेगा। आपका डेटा एन्क्रिप्ट ही रहेगा, लेकिन सैद्धांतिक रूप से हम आपका सिंक किया गया डेटा खोल सकेंगे।';

  @override
  String get ppLockedTitle => 'अपना डेटा अनलॉक करें';

  @override
  String get ppLockedBody =>
      'आपका डेटा पासफ़्रेज़ से सुरक्षित है। अपना सिंक किया गया डेटा और बैकअप खोलने के लिए इसे इस फ़ोन पर एक बार डालें।';

  @override
  String get ppUnlock => 'अनलॉक करें';

  @override
  String get ppUseRecovery => 'इसके बजाय मेरा रिकवरी कोड इस्तेमाल करें';

  @override
  String get ppUsePassphrase => 'इसके बजाय मेरा पासफ़्रेज़ इस्तेमाल करें';

  @override
  String get ppRecoveryLabel => 'रिकवरी कोड';

  @override
  String get ppWrongPassphrase => 'यह पासफ़्रेज़ सही नहीं है।';

  @override
  String get ppWrongRecovery => 'यह रिकवरी कोड सही नहीं है।';

  @override
  String get ppUnlocked => 'इस फ़ोन पर अनलॉक हो गया';

  @override
  String get ppChanged => 'पासफ़्रेज़ बदल गया';

  @override
  String get ppTurnedOn => 'सुरक्षा चालू है';

  @override
  String get ppTurnedOff => 'सुरक्षा बंद कर दी गई';

  @override
  String get encIntroTitle => 'आपका डेटा अब एन्क्रिप्टेड है';

  @override
  String get encIntroBody =>
      'इस फ़ोन पर सब कुछ एन्क्रिप्ट करके रखा जाता है, और आपके बैकअप और सिंक किया गया डेटा फ़ोन से बाहर जाने से पहले एन्क्रिप्ट हो जाते हैं। आपको कुछ करने की ज़रूरत नहीं है।';

  @override
  String get encIntroPassphrase =>
      'एक और ताला चाहिए? पासफ़्रेज़ सेट करें, फिर सिंक किया गया डेटा और बैकअप सिर्फ़ आप खोल पाएंगे — हम भी नहीं। यह वैकल्पिक है; पासफ़्रेज़ और उसका रिकवरी कोड दोनों खो जाने पर वह डेटा वापस नहीं मिल सकता।';

  @override
  String get encIntroSetUp => 'पासफ़्रेज़ सेट करें';

  @override
  String get encIntroNotNow => 'अभी नहीं';

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

  @override
  String get ppNeedsConnection =>
      'पासफ़्रेज़ सेटिंग्स के लिए इंटरनेट कनेक्शन चाहिए। किसी नेटवर्क से जुड़ें और इसे फिर से खोलें।';

  @override
  String get offlineToast =>
      'आप ऑफ़लाइन हैं। आप जो भी जोड़ेंगे वह इसी फ़ोन पर सेव रहेगा और ऑनलाइन आने पर सिंक हो जाएगा।';

  @override
  String get backupLockedTitle => 'यह बैकअप अनलॉक करें';

  @override
  String get backupLockedBody =>
      'यह बैकअप एक पासफ़्रेज़ से सुरक्षित है। इसे खोलने के लिए वह या अपना रिकवरी कोड डालें। यह इंटरनेट कनेक्शन के बिना भी काम करता है।';

  @override
  String get settingsSupportDescribeFirst => 'कृपया पहले अपनी समस्या बताएँ';

  @override
  String get settingsSupportSent => 'धन्यवाद! आपका संदेश भेज दिया गया है।';

  @override
  String get settingsSupportSendFailed =>
      'अभी भेजा नहीं जा सका। कृपया फिर से कोशिश करें या हमें सीधे ईमेल करें।';

  @override
  String get settingsSupportSubjectHint => 'यह किस बारे में है?';

  @override
  String get settingsSupportMessageHint => 'अपना सवाल, समस्या या सुझाव लिखें…';

  @override
  String get settingsSupportHeroBody =>
      'सवाल, बग या सुझाव — हमें भेजें और हम आपसे संपर्क करेंगे।';

  @override
  String get settingsSupportTipDescription => 'आपकी समस्या का साफ़ विवरण';

  @override
  String get settingsSupportTipSteps => 'समस्या दोहराने के चरण (अगर यह बग है)';

  @override
  String get settingsSupportTipDevice => 'आपके डिवाइस का मॉडल और Android वर्शन';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'ईमेल पसंद है? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'ईमेल क्लिपबोर्ड पर कॉपी हो गया';

  @override
  String get settingsAboutTagline => 'आपका निजी वित्त साथी';

  @override
  String settingsAboutVersion(String version) {
    return 'वर्शन: $version';
  }

  @override
  String get settingsAboutDescription =>
      'निजी वित्त ऐप, जिसमें गोपनीयता\nऔर सुंदर UI/UX पर ध्यान है।';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'मूल मुद्रा: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'आख़िरी अपडेट: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'दर बदलें: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'मौजूदा API दर: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String settingsHoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String settingsDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get settingsExportSectionDateRange => 'तारीख़ की अवधि';

  @override
  String get settingsExportSectionFormat => 'फ़ॉर्मैट';

  @override
  String get settingsExportSectionInclude => 'शामिल करें';

  @override
  String get settingsExportAllTime => 'पूरा समय';

  @override
  String get settingsExportThisMonth => 'इस महीने';

  @override
  String get settingsExportLastMonth => 'पिछले महीने';

  @override
  String get settingsExportLast3Months => 'पिछले 3 महीने';

  @override
  String get settingsExportThisYear => 'इस साल';

  @override
  String get settingsExportPdfPremiumBody =>
      'CSV एक्सपोर्ट मुफ़्त है — आपका डेटा हमेशा आपका है। सारांश और श्रेणी व वॉलेट के ब्योरे वाली फ़ॉर्मैट की हुई PDF रिपोर्ट एक Premium फ़ीचर है।';

  @override
  String settingsExportButton(String format) {
    return '$format एक्सपोर्ट करें';
  }

  @override
  String settingsExportFailed(String error) {
    return 'एक्सपोर्ट नहीं हो सका: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - एक्सपोर्ट';

  @override
  String settingsExportedCount(int count) {
    return '$count लेन-देन एक्सपोर्ट किए गए';
  }

  @override
  String get settingsExportPdfShareSubject =>
      'The Accountant - वित्तीय रिपोर्ट';

  @override
  String settingsExportPdfGenerated(int count) {
    return '$count लेन-देन के साथ PDF रिपोर्ट बन गई';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'हज़ार के लिए कॉमा';

  @override
  String get settingsNumberFormatDotThousands => 'हज़ार के लिए डॉट';

  @override
  String get settingsNumberFormatSpaceThousands => 'हज़ार के लिए स्पेस';

  @override
  String get settingsNumberFormatNoSeparator => 'कोई सेपरेटर नहीं';

  @override
  String get settingsAutoLockImmediately => 'तुरंत';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट',
      one: '1 मिनट',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'कभी नहीं';

  @override
  String get settingsBiometricUnavailable =>
      'इस डिवाइस पर बायोमेट्रिक ऑथेंटिकेशन उपलब्ध नहीं है';

  @override
  String get settingsSetPassword => 'पासवर्ड सेट करें';

  @override
  String get settingsChangePassword => 'पासवर्ड बदलें';

  @override
  String get settingsAddPasswordSubtitle => 'अपने खाते में पासवर्ड जोड़ें';

  @override
  String get settingsPasswordChanged => 'पासवर्ड बदल गया';

  @override
  String get settingsPasswordSet => 'पासवर्ड सेट हो गया';

  @override
  String get settingsClearCacheBody =>
      'इससे कैश किया गया डेटा साफ़ होगा और अगली बार ऐप खोलने पर फिर से सिंक होगा। आपका डेटा नहीं हटेगा।';

  @override
  String get settingsClearingCache => 'कैश साफ़ हो रहा है...';

  @override
  String get settingsCacheCleared => 'कैश साफ़ हो गया और सिंक शुरू हो गया';

  @override
  String get settingsClearCacheFailed => 'कैश साफ़ नहीं हो सका';

  @override
  String get settingsClearAllDataBody =>
      'इससे आपके सभी लेन-देन, बजट, वॉलेट, श्रेणियाँ और सेटिंग्स हमेशा के लिए हट जाएँगी। इसे वापस नहीं किया जा सकता!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'आपका सारा वित्तीय डेटा हमेशा के लिए मिट जाएगा।';

  @override
  String get settingsClearingAllData => 'सारा डेटा साफ़ हो रहा है...';

  @override
  String get settingsAllDataCleared => 'सारा डेटा साफ़ हो गया';

  @override
  String settingsClearDataFailed(String error) {
    return 'डेटा साफ़ नहीं हो सका: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'आपको खाता हटाने का अनुरोध करने के लिए एक फ़ॉर्म पर ले जाया जाएगा। इस प्रक्रिया में कुछ दिन लगते हैं। पूरा होने पर सर्वर का सारा डेटा हमेशा के लिए हट जाएगा।';

  @override
  String get settingsLockAuthFailed =>
      'ऑथेंटिकेशन नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get settingsLockError => 'कोई गड़बड़ी हुई। कृपया फिर से कोशिश करें।';

  @override
  String get settingsLockAuthenticating => 'ऑथेंटिकेट किया जा रहा है...';

  @override
  String get settingsProfileNameEmpty => 'नाम ख़ाली नहीं हो सकता';

  @override
  String get settingsProfileUpdated => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String get settingsProfileUpdateFailed => 'प्रोफ़ाइल अपडेट नहीं हो सकी';

  @override
  String get settingsProfileSaveChanges => 'बदलाव सेव करें';

  @override
  String get settingsProfileSaved => 'सेव हो गया';

  @override
  String get settingsProfilePhotoSoon => 'फ़ोटो अपलोड जल्द आ रहा है';

  @override
  String get settingsProfileAccountInformation => 'खाते की जानकारी';

  @override
  String get settingsProfileMemberSince => 'सदस्य कब से';

  @override
  String get settingsProfileUnknown => 'अज्ञात';

  @override
  String get settingsProfileFree => 'मुफ़्त';

  @override
  String get settingsProfileUserId => 'यूज़र ID';

  @override
  String get settingsProfileUserIdCopied => 'यूज़र ID कॉपी हो गई';

  @override
  String get settingsPremiumMonthly => 'Premium मासिक';

  @override
  String get settingsPremiumYearly => 'Premium वार्षिक';

  @override
  String get settingsPremiumLifetime => 'Premium लाइफ़टाइम';

  @override
  String get settingsUnsavedChangesBody =>
      'आपके कुछ बदलाव सेव नहीं हुए हैं। क्या आप सच में जाना चाहते हैं?';

  @override
  String settingsShareAppText(String url) {
    return 'The Accountant देखें - एक सुंदर निजी वित्त ऐप!\n\n$url';
  }

  @override
  String get settingsShareAppSubject => 'The Accountant - निजी वित्त ऐप';

  @override
  String get settingsCloudSyncGateBody =>
      'अपना वित्तीय डेटा अपने सभी डिवाइस पर सिंक रखें। फिर कभी अपना डेटा न खोएँ।';

  @override
  String settingsSyncPushed(int count) {
    return '$count भेजे गए';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$count लाए गए';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count टकराव';
  }

  @override
  String get settingsSyncNowSubtitle => 'सारे बदलाव भेजें और लाएँ';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'सिंक पूरा — $pushed भेजे, $pulled लाए';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'सिंक अधूरा — $count रिकॉर्ड सेव नहीं हो सके, उन्हें फिर से आज़माया जाएगा। $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'सिंक नहीं हो सका: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'इस डिवाइस के डेटा की जगह अपना क्लाउड डेटा रखें';

  @override
  String get settingsRestoreFromCloudBody =>
      'इससे इस डिवाइस का सारा डेटा मिट जाएगा और उसकी जगह आपका क्लाउड डेटा आ जाएगा। इस डिवाइस के जो बदलाव अभी सिंक नहीं हुए हैं, वे खो जाएँगे। इसे वापस नहीं किया जा सकता।';

  @override
  String settingsRestoredFromCloud(int count) {
    return 'क्लाउड से $count आइटम रिस्टोर किए गए';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'रिस्टोर रद्द किया गया — आपका लोकल डेटा जैसा था वैसा ही है। $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'रिस्टोर नहीं हो सका: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'आपका डेटा हर 15 मिनट में और ऐप खोलने पर अपने-आप सिंक होता है। रकम, नाम और नोट्स सिंक होने से पहले इसी फ़ोन पर एन्क्रिप्ट होते हैं, इसलिए हमारा सर्वर उन्हें नहीं पढ़ सकता।';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return '$seconds सेकंड में पूरा हुआ';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return '$minutes मिनट $seconds सेकंड में पूरा हुआ';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'क्या यह आपकी “$name” श्रेणी है?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'सेव हो गया। यह अगली बार सिंक करने पर लागू होगा।';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपके खाते में पहले से “$name” नाम की $count श्रेणियाँ हैं। बताएँ कि इनमें से किसी एक को बिल्ट-इन श्रेणी के रूप में इस्तेमाल करें या अलग रखें। जब तक आप नहीं चुनते, कुछ नहीं बदलेगा।',
      one:
          'आपके खाते में पहले से “$name” नाम की एक श्रेणी है। बताएँ कि इसे बिल्ट-इन श्रेणी के रूप में इस्तेमाल करें या अलग रखें। जब तक आप नहीं चुनते, कुछ नहीं बदलेगा।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'नहीं — मेरी वाली रखें और एक अलग जोड़ें';

  @override
  String get settingsReconcileNoneOfThese =>
      'इनमें से कोई नहीं — एक अलग जोड़ें';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपकी मौजूदा “$name” श्रेणियाँ अपने सभी लेन-देन के साथ बिल्कुल वैसी ही रहेंगी। उनके साथ एक नई बिल्ट-इन “$name” जोड़ी जाएगी।',
      one:
          'आपकी मौजूदा “$name” श्रेणी अपने सभी लेन-देन के साथ बिल्कुल वैसी ही रहेगी। उसके साथ एक नई बिल्ट-इन “$name” जोड़ी जाएगी।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'अलग रखें';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return '“$name” इस्तेमाल करें?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'यह बिल्ट-इन “$name” श्रेणी बन जाएगी और इसके सभी $count लेन-देन, इसकी उप-श्रेणियों के साथ, बने रहेंगे। कुछ भी नहीं हटेगा।',
      zero:
          'यह बिल्ट-इन “$name” श्रेणी बन जाएगी और इसमें दर्ज सब कुछ, इसकी उप-श्रेणियों के साथ, बना रहेगा। कुछ भी नहीं हटेगा।',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'यही इस्तेमाल करें';

  @override
  String settingsReconcileWillUse(String name) {
    return '“$name” इस्तेमाल होगी।';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'एक अलग “$name” जोड़ी जाएगी।';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'अपना मौजूदा पासवर्ड डालें और नया चुनें';

  @override
  String get settingsSetPasswordSubtitle =>
      'अतिरिक्त सुरक्षा के लिए अपने खाते में पासवर्ड जोड़ें';

  @override
  String get settingsEnterCurrentPassword => 'कृपया अपना मौजूदा पासवर्ड डालें';

  @override
  String get settingsEnterNewPassword => 'कृपया नया पासवर्ड डालें';

  @override
  String get settingsPasswordMinLength =>
      'पासवर्ड कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get settingsConfirmYourPassword => 'कृपया अपने पासवर्ड की पुष्टि करें';

  @override
  String get settingsPasswordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get settingsPleaseWait => 'कृपया इंतज़ार करें...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'पुष्टि के लिए “$word” लिखें';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return 'बजट का $percent%';
  }

  @override
  String get authTooManyAttempts =>
      'बहुत ज़्यादा कोशिशें हुईं। कृपया एक मिनट रुककर फिर से कोशिश करें।';

  @override
  String get authServerDown =>
      'हम अपने सर्वर तक नहीं पहुँच सके। गड़बड़ी हमारी तरफ़ से है — कृपया कुछ मिनट बाद फिर से कोशिश करें।';

  @override
  String get authInitFailed => 'ऑथेंटिकेशन शुरू नहीं हो सका';

  @override
  String get authSignInError => 'साइन इन के दौरान कोई गड़बड़ी हुई';

  @override
  String get authSignUpError => 'साइन अप के दौरान कोई गड़बड़ी हुई';

  @override
  String get authGoogleCancelled => 'Google साइन-इन रद्द हुआ या नहीं हो सका';

  @override
  String get authFirebaseTokenFailed => 'Firebase ID टोकन नहीं मिल सका';

  @override
  String get authGoogleSignInError => 'Google साइन इन के दौरान कोई गड़बड़ी हुई';

  @override
  String get authAccountExistsDifferentCredential =>
      'इसी ईमेल पते से एक खाता पहले से मौजूद है, लेकिन उसकी साइन-इन जानकारी अलग है।';

  @override
  String get authInvalidCredential =>
      'दी गई साइन-इन जानकारी ग़लत है या उसकी अवधि ख़त्म हो गई है।';

  @override
  String get authGoogleDisabled => 'Google साइन-इन बंद है।';

  @override
  String get authUserDisabled => 'यह यूज़र खाता बंद कर दिया गया है।';

  @override
  String get authAppleSignInError => 'Apple साइन इन के दौरान कोई गड़बड़ी हुई';

  @override
  String get authAppleDisabled => 'Apple साइन-इन बंद है।';

  @override
  String get authNoPendingLink => 'लिंक करने के लिए कोई खाता बाक़ी नहीं है';

  @override
  String get authLinkFailed => 'खाता लिंक नहीं हो सका';

  @override
  String get authIncorrectPassword =>
      'पासवर्ड ग़लत है। कृपया फिर से कोशिश करें।';

  @override
  String get authSignOutError => 'साइन आउट के दौरान कोई गड़बड़ी हुई';

  @override
  String get authLinkSubtitle =>
      'इस ईमेल से एक खाता पहले से मौजूद है। अपना Google खाता लिंक करने के लिए अपना पासवर्ड डालें।';

  @override
  String get authEnterYourPasswordHint => 'अपना पासवर्ड डालें';

  @override
  String get authEnterYourPassword => 'कृपया अपना पासवर्ड डालें';

  @override
  String get authLinkInfo =>
      'लिंक करने के बाद आप ईमेल/पासवर्ड या Google, किसी से भी साइन इन कर सकते हैं।';

  @override
  String get authEnterYourEmail => 'कृपया अपना ईमेल डालें';

  @override
  String get authEnterValidEmail => 'कृपया सही ईमेल डालें';

  @override
  String get authPasswordMin6 => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get authNoAccountPrompt => 'खाता नहीं है? ';

  @override
  String get authForgotPasswordTitle => 'पासवर्ड भूल गए';

  @override
  String get authCheckYourEmail => 'अपना ईमेल देखें';

  @override
  String get authForgotPasswordSubtitle =>
      'अपना ईमेल डालें, हम आपको पासवर्ड रीसेट करने के लिए एक कोड भेजेंगे।';

  @override
  String authCodeSentSubtitle(String email) {
    return 'हमने $email पर 6 अंकों का कोड भेजा है। उसे नीचे अपने नए पासवर्ड के साथ डालें।';
  }

  @override
  String get authEnterYourEmailHint => 'अपना ईमेल डालें';

  @override
  String get authSixDigitCodeHint => '6 अंकों का कोड';

  @override
  String get authEnterTheCode => 'कृपया कोड डालें';

  @override
  String get authCodeIsSixDigits => 'कोड 6 अंकों का है';

  @override
  String get authCreateNewPasswordHint => 'नया पासवर्ड बनाएँ';

  @override
  String get authReenterNewPasswordHint => 'अपना नया पासवर्ड फिर से डालें';

  @override
  String get authEnterYourNameHint => 'अपना नाम डालें';

  @override
  String get authEnterFullName => 'कृपया अपना पूरा नाम डालें';

  @override
  String get authNameMin2 => 'नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get authCreatePasswordHint => 'पासवर्ड बनाएँ';

  @override
  String get authPasswordComplexity =>
      'इसमें बड़ा अक्षर, छोटा अक्षर और अंक होना चाहिए';

  @override
  String get authReenterPasswordHint => 'अपना पासवर्ड फिर से डालें';

  @override
  String get authStrengthWeak => 'कमज़ोर';

  @override
  String get authStrengthFair => 'ठीक-ठाक';

  @override
  String get authStrengthGood => 'अच्छा';

  @override
  String get authStrengthStrong => 'मज़बूत';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'मैं $terms और $privacy से सहमत हूँ';
  }

  @override
  String get authDefaultUserName => 'यूज़र';

  @override
  String authMemberSince(String date) {
    return '$date से सदस्य';
  }

  @override
  String get authFieldRequired => 'यह फ़ील्ड ज़रूरी है';

  @override
  String authSignOutFailed(String error) {
    return 'साइन आउट नहीं हो सका: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'इमेज नहीं चुनी जा सकी: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'प्रोफ़ाइल अपडेट नहीं हो सकी: $error';
  }

  @override
  String get premiumSaveAbout44 => '~44% बचाएँ';

  @override
  String get premiumBestValue => 'सबसे फ़ायदेमंद';

  @override
  String get premiumIapUnavailable => 'IAP उपलब्ध नहीं है';

  @override
  String get premiumProductNotFound => 'प्रोडक्ट नहीं मिला';

  @override
  String get premiumPlanUnavailable =>
      'यह प्लान अभी आपके खाते पर उपलब्ध नहीं है';

  @override
  String get premiumRestoreFailed => 'ख़रीदारी रिस्टोर नहीं हो सकी';

  @override
  String get premiumPurchaseFailed => 'ख़रीदारी नहीं हो सकी';

  @override
  String get premiumVerificationFailed => 'पुष्टि नहीं हो सकी';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count हफ़्ते',
      one: '1 हफ़्ता',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने',
      one: '1 महीना',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल',
      one: '1 साल',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'आपने $limit मुफ़्त $items में से $count इस्तेमाल कर लिए हैं।';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'असीमित $items और बहुत कुछ के लिए Premium लें!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'आप मुफ़्त प्लान की $limit $items की सीमा तक पहुँच गए हैं। असीमित $items के लिए Premium लें।';
  }

  @override
  String get premiumLimitWallets => 'वॉलेट';

  @override
  String get premiumLimitCategories => 'कस्टम श्रेणियाँ';

  @override
  String get premiumLimitBudgets => 'सक्रिय बजट';

  @override
  String get premiumLimitObjectives => 'सक्रिय उद्देश्य';

  @override
  String get premiumLimitPaymentMethods => 'भुगतान के तरीक़े';

  @override
  String get backupErrNotJson =>
      'यह फ़ाइल बैकअप नहीं है — इसे JSON के रूप में पढ़ा नहीं जा सका।';

  @override
  String get backupErrNotOurs => 'यह फ़ाइल The Accountant का बैकअप नहीं है।';

  @override
  String get backupErrNewerVersion =>
      'यह बैकअप ऐप के नए वर्शन से बना है। The Accountant अपडेट करें और फिर से कोशिश करें।';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'यह बैकअप ऐप के इतने पुराने वर्शन का है कि यह वर्शन उसे पढ़ नहीं सकता (डेटाबेस $version, सबसे पुराना समर्थित $oldest)।';
  }

  @override
  String get backupErrNoData => 'इस बैकअप में कोई डेटा नहीं है।';

  @override
  String backupErrSectionDamaged(String section) {
    return 'इस बैकअप का “$section” हिस्सा ख़राब है।';
  }

  @override
  String get backupErrNoHeader =>
      'इस बैकअप में वह हेडर नहीं है जो बताता है कि यह क्या है।';

  @override
  String get backupErrNoSchemaVersion =>
      'यह बैकअप नहीं बताता कि यह किस डेटाबेस वर्शन से लिया गया था, इसलिए इसे सुरक्षित रूप से रिस्टोर नहीं किया जा सकता।';

  @override
  String get backupErrNoDate => 'यह बैकअप नहीं बताता कि यह कब लिया गया था।';

  @override
  String get backupErrDamaged => 'यह बैकअप फ़ाइल ख़राब है।';

  @override
  String get backupErrWrongKey =>
      'यह बैकअप किसी दूसरे खाते का है, या फ़ाइल बदली गई है। इसे रिस्टोर करने के लिए उसी खाते से साइन इन करें जिससे यह बना था।';

  @override
  String get backupErrNoPassphraseLock =>
      'यह बैकअप पासफ़्रेज़ से नहीं खोला जा सकता।';

  @override
  String get backupErrNeedsSecret =>
      'यह बैकअप पासफ़्रेज़ से सुरक्षित है। इसे रिस्टोर करने के लिए पासफ़्रेज़ या रिकवरी कोड डालें।';

  @override
  String get backupErrWrongSecret =>
      'यह पासफ़्रेज़ या रिकवरी कोड इस बैकअप को नहीं खोलता।';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'यह बैकअप ऐप के नए वर्शन से बना है (डेटाबेस $version, यह बिल्ड $supported तक पढ़ सकता है)। The Accountant अपडेट करें और फिर से कोशिश करें।';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Drive तक नहीं पहुँचा जा सका: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant को अभी Google Drive इस्तेमाल करने की अनुमति नहीं है।';

  @override
  String get backupDriveNoFolder =>
      'Google Drive ने बैकअप रखने के लिए फ़ोल्डर नहीं बनाने दिया।';

  @override
  String get backupDriveNoFileId =>
      'Google Drive ने बैकअप ले लिया, पर यह नहीं बताया कि उसे कहाँ रखा।';

  @override
  String get backupDriveTimeout =>
      'Google Drive जवाब देने में बहुत समय ले रहा है। बाद में फिर से कोशिश करें।';

  @override
  String get backupDriveOffline =>
      'Google Drive से कनेक्शन नहीं है। ऑनलाइन होने पर फिर से कोशिश करें।';

  @override
  String get backupDriveDenied =>
      'Google Drive ने अनुरोध ठुकरा दिया। फिर से एक्सेस दें और दोबारा कोशिश करें।';

  @override
  String get backupDriveFileGone => 'वह बैकअप अब Google Drive में नहीं है।';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive ने $status जवाब दिया। $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'थोड़ी देर में फिर से कोशिश करें।';

  @override
  String backupTakeFailed(String error) {
    return 'बैकअप नहीं लिया जा सका: $error';
  }

  @override
  String get backupUnrestorableNewer => 'ऐप के नए वर्शन से बना है।';

  @override
  String get backupUnrestorableOlder =>
      'इतना पुराना है कि ऐप का यह वर्शन इसे नहीं पढ़ सकता।';

  @override
  String get backupKeyUnusable =>
      'सर्वर ने ऐसी एन्क्रिप्शन कुंजी भेजी जो काम की नहीं है। बाद में फिर से कोशिश करें।';

  @override
  String get backupKeyNeedsSignIn =>
      'बैकअप बनाने या रिस्टोर करने के लिए साइन इन करें — बैकअप आपके खाते से एन्क्रिप्ट होते हैं।';

  @override
  String get backupKeyNeedsInternet =>
      'एक बार इंटरनेट से जुड़ें ताकि आपका डेटा एन्क्रिप्ट हो सके, फिर से कोशिश करें।';

  @override
  String get backupKeyLocked =>
      'आपका डेटा पासफ़्रेज़ से सुरक्षित है। पहले इसे इस डिवाइस पर अनलॉक करें।';

  @override
  String get backupFrequencyManual => 'सिर्फ़ जब मैं कहूँ';

  @override
  String get backupFrequencyDaily => 'हर दिन';

  @override
  String get backupFrequencyWeekly => 'हर हफ़्ते';

  @override
  String get backupFrequencyMonthly => 'हर महीने';

  @override
  String get backupIntro =>
      'बैकअप एक फ़ाइल है जिसमें इस डिवाइस का सब कुछ होता है — हर लेन-देन, खाता, बजट और लक्ष्य। इसे किसी सुरक्षित जगह रखें, तो यहाँ का कुछ भी हमेशा के लिए नहीं खोएगा।';

  @override
  String get backupSectionOnDevice => 'इस डिवाइस पर';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'DRIVE में बैकअप';

  @override
  String backupBackedUpCount(int count) {
    return '$count रिकॉर्ड का बैकअप लिया गया।';
  }

  @override
  String get backupSaveDialogTitle => 'बैकअप सेव करें';

  @override
  String get backupChooseFileTitle => 'बैकअप फ़ाइल चुनें';

  @override
  String backupFileUnreadable(String error) {
    return 'वह फ़ाइल पढ़ी नहीं जा सकी: $error';
  }

  @override
  String backupTakenOn(String date) {
    return '$date को लिया गया।';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return '$date को $device पर लिया गया।';
  }

  @override
  String backupBelongedTo(String email) {
    return 'यह $email का था।';
  }

  @override
  String get backupDifferentAccountWarning =>
      'यह वह खाता नहीं है जिससे यहाँ साइन इन है। रिस्टोर करने पर इस डिवाइस पर किसी और के रिकॉर्ड आ जाएँगे।';

  @override
  String get backupRestoreEraseWarning =>
      'इस डिवाइस पर अभी जो कुछ है, सब मिटाकर बदल दिया जाएगा। जो अभी सिंक नहीं हुआ, वह खो जाएगा। इसे वापस नहीं किया जा सकता।';

  @override
  String backupRestoredCount(int count) {
    return '$count रिकॉर्ड रिस्टोर किए गए।';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$count रिकॉर्ड रिस्टोर किए गए। फ़ाइल का कुछ हिस्सा इस वर्शन में फ़िट नहीं हुआ, इसलिए छोड़ दिया गया।';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'कुछ नहीं बदला — रिस्टोर नहीं हो सका: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'बैकअप एक निजी फ़ोल्डर में जाते हैं जिसे सिर्फ़ यह ऐप खोल सकता है। आपकी दूसरी फ़ाइलें कभी नहीं पढ़ी जातीं।';

  @override
  String get backupDriveConnectedTitle => 'Google Drive जुड़ गया';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'इस डिवाइस के बैकअप आपके Drive में “$folder” नाम के फ़ोल्डर में जाएँगे।';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'बैकअप आपके Drive में “$folder” में जाते हैं।';
  }

  @override
  String get backupNoneYet => 'इस डिवाइस से अभी तक कोई बैकअप नहीं गया है';

  @override
  String backupLastBackedUp(String date) {
    return 'आख़िरी बैकअप $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count बैकअप — नया बैकअप आने पर पुराने हटा दिए जाते हैं';
  }

  @override
  String get backupDisconnectSubtitle =>
      'अपने-आप बैकअप बंद हो जाएँगे। पहले से सेव कुछ भी नहीं हटेगा।';

  @override
  String backupListFailed(String error) {
    return 'आपके बैकअप की सूची नहीं मिल सकी: $error';
  }

  @override
  String get backupDriveNotGranted => 'Google Drive एक्सेस नहीं दिया गया।';

  @override
  String get backupDriveConnected => 'Google Drive जुड़ गया।';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Drive नहीं जुड़ सका: $error';
  }

  @override
  String get backupDisconnectBody =>
      'अपने-आप बैकअप बंद हो जाएँगे। Drive में पहले से मौजूद बैकअप वहीं रहेंगे, और आप कभी भी फिर से जोड़ सकते हैं।';

  @override
  String backupSavedToDrive(String name) {
    return '$name Google Drive में सेव हो गया।';
  }

  @override
  String backupCopyFailed(String error) {
    return 'वह बैकअप सेव नहीं हो सका: $error';
  }

  @override
  String get backupDeleteBody => 'यह Google Drive से हमेशा के लिए हट जाएगा।';

  @override
  String get backupRefresh => 'रीफ़्रेश करें';

  @override
  String get ppErrKdfParams =>
      'कुंजी बनाने के पैरामीटर स्वीकार करने लायक़ नहीं हैं।';

  @override
  String get ppErrKdfAlgorithm => 'कुंजी बनाने का अनजान एल्गोरिदम।';

  @override
  String get onboardingIntroAccountsTitle => 'हर खाता, एक बैलेंस';

  @override
  String get onboardingIntroAccountsBody =>
      'नकद, कार्ड और बचत एक साथ रखें, और देखें कि असल में आपके पास कितना बचा है।';

  @override
  String get onboardingIntroBudgetsTitle => 'बजट जो पहले ही बता दें';

  @override
  String get onboardingIntroBudgetsBody =>
      'हर श्रेणी के लिए सीमा तय करें। ऐप कुल रकम पर नज़र रखता है और सीमा पार होने से पहले आपको चेतावनी देता है, बाद में नहीं।';

  @override
  String get onboardingIntroAskTitle => 'अपने ख़र्च के बारे में पूछें';

  @override
  String get onboardingIntroAskBody =>
      'रसीद स्कैन करें, या पूछें कि पिछले महीने पैसा कहाँ गया, और अपने रिकॉर्ड से जवाब पाएँ।';

  @override
  String get onboardingIntroThemeTitle => 'इसे अपने अंदाज़ में सजाएँ';

  @override
  String get onboardingIntroThemeBody =>
      'अभी थीम चुनें, या जब चाहें सेटिंग्स से बदलें।';

  @override
  String get onboardingCreateYourAccount => 'अपना खाता बनाएँ';

  @override
  String get onboardingNext => 'आगे';

  @override
  String get onboardingCurrencyInfo =>
      'यह आपकी मुख्य मुद्रा होगी। आप बाद में दूसरी मुद्राओं वाले खाते जोड़ सकते हैं।';

  @override
  String get onboardingTypeCash => 'नकद';

  @override
  String get onboardingTypeBank => 'बैंक खाता';

  @override
  String get onboardingTypeCard => 'क्रेडिट कार्ड';

  @override
  String get onboardingTypeDeposit => 'जमा';

  @override
  String get onboardingTypeInvestment => 'निवेश';

  @override
  String get onboardingTypeAsset => 'संपत्ति';

  @override
  String onboardingDayN(int day) {
    return 'दिन $day';
  }

  @override
  String get onboardingAllSet => 'सब तैयार है!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'ऑनबोर्डिंग पूरी नहीं हो सकी: $error';
  }

  @override
  String get onboardingSkipFailed => 'ऑनबोर्डिंग छोड़ी नहीं जा सकी';

  @override
  String get startupOfflineConfirmBody =>
      'आपका डेटा जहाँ है वहीं रहेगा — इस डिवाइस पर या क्लाउड में कुछ भी नहीं हटेगा।\n\nलेकिन अगर उस खाते में डेटा सेव है, तो अभी आप जो भी जोड़ेंगे वह रिस्टोर करने के बाद उसके साथ मिल जाएगा — हो सकता है आपको कुछ डुप्लिकेट साफ़ करने पड़ें।';

  @override
  String get startupDataInCloudTitle =>
      'आपका डेटा क्लाउड में आपका इंतज़ार कर रहा है';

  @override
  String get startupLoadFailedTitle => 'हम आपका खाता पूरी तरह लोड नहीं कर सके';

  @override
  String get startupGenericReason =>
      'इस खाते की जाँच करते समय कुछ गड़बड़ हो गई।';

  @override
  String get startupUseWithoutRestoring => 'रिस्टोर किए बिना ऐप इस्तेमाल करें';

  @override
  String get legalTermsTab => 'शर्तें';

  @override
  String get legalConsent =>
      'मैंने गोपनीयता नीति और नियम व शर्तें पढ़ ली हैं और मैं उनसे सहमत हूँ';

  @override
  String get walkthroughGotIt => 'समझ गया!';

  @override
  String get settingsFaqSectionGettingStarted => 'शुरुआत';

  @override
  String get settingsFaq01Question => 'लेन-देन कैसे जोड़ें?';

  @override
  String get settingsFaq01Answer =>
      'होम स्क्रीन के नीचे + बटन पर टैप करें। रकम भरें, श्रेणी चुनें, वॉलेट चुनें और चाहें तो नोट्स जोड़ें। लेन-देन दर्ज करने के लिए सेव करें पर टैप करें।';

  @override
  String get settingsFaq02Question => 'वॉलेट और श्रेणी में क्या फ़र्क है?';

  @override
  String get settingsFaq02Answer =>
      'वॉलेट बताते हैं कि आपका पैसा कहाँ रखा है (जैसे नकद, बैंक खाता, क्रेडिट कार्ड)। श्रेणियाँ बताती हैं कि पैसा किस पर ख़र्च हुआ या कहाँ से आया (जैसे खाना, सैलरी, मनोरंजन)।';

  @override
  String get settingsFaq03Question => 'तारीख़ और नंबर का फ़ॉर्मेट कैसे बदलें?';

  @override
  String get settingsFaq03Answer =>
      'सेटिंग्स > क्षेत्रीय सेटिंग्स में जाएँ। यहाँ आप अपनी डिफ़ॉल्ट मुद्रा, तारीख़ का फ़ॉर्मेट (जैसे DD/MM/YYYY या MM/DD/YYYY) और नंबर का फ़ॉर्मेट (जैसे 1,234.56 या 1.234,56) बदल सकते हैं। लाइव प्रीव्यू में दिखता है कि आपकी सेटिंग्स कैसी दिखेंगी।';

  @override
  String get settingsFaqSectionTransactions => 'लेन-देन';

  @override
  String get settingsFaq04Question =>
      'क्या मैं बार-बार होने वाले लेन-देन ट्रैक कर सकता हूँ?';

  @override
  String get settingsFaq04Answer =>
      'हाँ! लेन-देन जोड़ते समय \"नियमित\" विकल्प चालू करें। आप इसे रोज़, हर हफ़्ते, हर महीने या हर साल दोहराने के लिए सेट कर सकते हैं। ऐप ये लेन-देन आपके लिए अपने-आप बना देगा।';

  @override
  String get settingsFaq05Question => 'वॉलेट के बीच पैसे कैसे ट्रांसफ़र करें?';

  @override
  String get settingsFaq05Answer =>
      'लेन-देन जोड़ते समय टाइप में \"ट्रांसफ़र\" चुनें। जिस वॉलेट से पैसा जाना है और जिसमें आना है, दोनों चुनें और रकम डालें। ऐप एक से रकम घटाकर दूसरे में अपने-आप जोड़ देगा।';

  @override
  String get settingsFaq06Question => 'आने वाले लेन-देन क्या हैं?';

  @override
  String get settingsFaq06Answer =>
      'आने वाले लेन-देन वे भविष्य के ख़र्च या आमदनी हैं जिनकी आपको उम्मीद है, पर जिनका भुगतान अभी नहीं हुआ। जब तक आप इन्हें भुगतान हुआ नहीं मानते, इनसे वॉलेट बैलेंस पर असर नहीं पड़ता। बकाया और आने वाले आइटम आपको लेन-देन वाले हिस्से में मिलेंगे।';

  @override
  String get settingsFaq07Question => 'सब्सक्रिप्शन कैसे ट्रैक करें?';

  @override
  String get settingsFaq07Answer =>
      'लेन-देन जोड़ते समय ख़ास टाइप को सब्सक्रिप्शन पर सेट करें। इससे यह किसी सेवा का नियमित भुगतान माना जाएगा। आप अपने सारे सब्सक्रिप्शन एक जगह देख सकते हैं और हर महीने इन पर होने वाला ख़र्च ट्रैक कर सकते हैं।';

  @override
  String get settingsFaq08Question =>
      'उधार और कर्ज़ की ट्रैकिंग कैसे काम करती है?';

  @override
  String get settingsFaq08Answer =>
      'जो पैसा आपने किसी को दिया है उसके लिए उधार, और जो पैसा आपने लिया है उसके लिए कर्ज़ इस्तेमाल करें। हर एंट्री में रकम, किसे किसको देना है और कितना चुकाया गया, यह दर्ज रहता है। आप आंशिक भुगतान दर्ज कर सकते हैं और पूरा चुक जाने पर कर्ज़ को चुकता मार्क कर सकते हैं।';

  @override
  String get settingsFaq09Question =>
      'क्या मैं लेन-देन में नोट्स या रसीद जोड़ सकता हूँ?';

  @override
  String get settingsFaq09Answer =>
      'हाँ! लेन-देन जोड़ते या बदलते समय आप नोट्स वाले फ़ील्ड में नोट्स लिख सकते हैं। Premium यूज़र AI रसीद स्कैनर से रसीद भी स्कैन कर सकते हैं, जो रकम और दुकान की जानकारी अपने-आप निकाल लेता है।';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'वॉलेट और मुद्राएँ';

  @override
  String get settingsFaq10Question => 'कई खाते कैसे संभालें?';

  @override
  String get settingsFaq10Answer =>
      'ऐप में चार तरह के खाते हैं: नकद, बैंक खाता, क्रेडिट कार्ड और सब्सक्रिप्शन। नया खाता जोड़ने के लिए डैशबोर्ड पर \'आपके खाते\' में जाएँ और \'खाता जोड़ें\' पर टैप करें। हर खाते का अपना नाम, आइकन, रंग और मुद्रा हो सकती है। आपका पहला खाता अपने-आप डिफ़ॉल्ट बन जाता है। क्रेडिट कार्ड खातों में आप क्रेडिट लिमिट और बिलिंग की तारीख़ भी सेट कर सकते हैं, ताकि बचा हुआ क्रेडिट दिखता रहे।';

  @override
  String get settingsFaq11Question =>
      'क्या मैं कई मुद्राएँ इस्तेमाल कर सकता हूँ?';

  @override
  String get settingsFaq11Answer =>
      'हाँ! हर वॉलेट की अपनी मुद्रा हो सकती है। ऐप लाइव विनिमय दरों से मुद्राएँ अपने-आप बदल देता है। आप सेटिंग्स > क्षेत्रीय सेटिंग्स में अपनी विनिमय दरें भी सेट कर सकते हैं।';

  @override
  String get settingsFaq12Question => 'मुद्रा बदलना कैसे काम करता है?';

  @override
  String get settingsFaq12Answer =>
      'हर वॉलेट की मुद्रा अलग हो सकती है, और ऐप हर कुछ घंटों में अपडेट होने वाली लाइव विनिमय दरों से रकम अपने-आप बदल देता है। आप सेटिंग्स > क्षेत्रीय सेटिंग्स में किसी भी मुद्रा जोड़ी के लिए अपनी दरें भी सेट कर सकते हैं। ऐप 150 से ज़्यादा मुद्राओं को सपोर्ट करता है और दरें अपने-आप लाता है।';

  @override
  String get settingsFaq13Question =>
      'लेन-देन वाली श्रेणी हटाने पर क्या होता है?';

  @override
  String get settingsFaq13Answer =>
      'वे लेन-देन \"बिना श्रेणी\" में चले जाएँगे। फिर आप उन्हें किसी दूसरी श्रेणी में डाल सकते हैं या बिना श्रेणी ही रहने दे सकते हैं।';

  @override
  String get settingsFaq14Question =>
      'उप-श्रेणियाँ क्या हैं और इन्हें कैसे इस्तेमाल करें?';

  @override
  String get settingsFaq14Answer =>
      'ज़्यादा बारीकी से ट्रैक करने के लिए आप किसी भी मुख्य श्रेणी के अंदर उप-श्रेणियाँ बना सकते हैं। जैसे \'खाना\' के अंदर \'राशन\', \'रेस्टोरेंट\' और \'कॉफ़ी\'। उप-श्रेणियों से साफ़ दिखता है कि आपका पैसा ठीक कहाँ जा रहा है।';

  @override
  String get settingsFaq15Question => 'बैलेंस सुधार क्या है?';

  @override
  String get settingsFaq15Answer =>
      'जब वॉलेट का बैलेंस असली रकम से मेल नहीं खाता, तब बैलेंस सुधार से आप उसे ठीक कर सकते हैं। इससे एक ख़ास लेन-देन बनता है जो ट्रैक किए गए बैलेंस को असली बैलेंस के बराबर कर देता है, बिना हाथ से आमदनी या ख़र्च जोड़े।';

  @override
  String get settingsFaqSectionBudgetsGoals => 'बजट और लक्ष्य';

  @override
  String get settingsFaq16Question => 'बजट कैसे बनाएँ?';

  @override
  String get settingsFaq16Answer =>
      'बजट टैब में जाएँ और \"नया बजट\" पर टैप करें। नाम रखें, ख़र्च की सीमा तय करें, समय चुनें (हफ़्तेवार/मासिक) और ट्रैक करने के लिए श्रेणियाँ चुनें। सीमा के पास पहुँचने पर ऐप आपको बता देगा।';

  @override
  String get settingsFaq17Question => 'बचत के लक्ष्य क्या हैं?';

  @override
  String get settingsFaq17Answer =>
      'बचत के लक्ष्य से आप वह रकम तय करते हैं जो आप बचाना चाहते हैं। लक्ष्य वाले हिस्से में एक लक्ष्य बनाएँ, अपनी रकम तय करें और प्रगति देखने के लिए लेन-देन जोड़ें। ऐप एक प्रगति बार और लक्ष्य तक पहुँचने का प्रतिशत दिखाता है।';

  @override
  String get settingsFaq18Question => 'लोन कैसे ट्रैक करें?';

  @override
  String get settingsFaq18Answer =>
      'लक्ष्य वाले हिस्से में कुल बकाया रकम के साथ एक लोन बनाएँ। जैसे-जैसे आप भुगतान करें, उन लेन-देन को लोन से जोड़ें ताकि चुकाने की प्रगति दिखे। ऐप दिखाता है कि आपने कितना चुका दिया और कितना बाकी है।';

  @override
  String get settingsFaqSectionDataSync => 'डेटा और सिंक';

  @override
  String get settingsFaq19Question => 'क्लाउड सिंक कैसे काम करता है?';

  @override
  String get settingsFaq19Answer =>
      'क्लाउड सिंक आपके डेटा को सभी डिवाइस पर एक जैसा रखता है। इसे चालू करने के लिए सेटिंग्स > डेटा प्रबंधन > क्लाउड सिंक में जाएँ। सिंक हर 15 मिनट में और ऐप खोलने पर अपने-आप चलता है। तुरंत सिंक के लिए आप \'अभी सिंक करें\' पर भी टैप कर सकते हैं। यह Premium फ़ीचर है।';

  @override
  String get settingsFaq20Question => 'अपना डेटा एक्सपोर्ट कैसे करें?';

  @override
  String get settingsFaq20Answer =>
      'सेटिंग्स > डेटा प्रबंधन > डेटा एक्सपोर्ट करें में जाएँ। तारीख़ की अवधि चुनें, CSV (स्प्रेडशीट के लिए) या PDF (फ़ॉर्मेट की हुई रिपोर्ट के लिए) चुनें और एक्सपोर्ट पर टैप करें। आप श्रेणी और वॉलेट के हिसाब से ब्योरा शामिल कर सकते हैं या हटा सकते हैं। यह Premium फ़ीचर है।';

  @override
  String get settingsFaq21Question => 'डेटा साफ़ करने पर क्या होता है?';

  @override
  String get settingsFaq21Answer =>
      'सेटिंग्स > गोपनीयता और सुरक्षा में जाएँ। \'कैश साफ़ करें\' अस्थायी डेटा हटाता है और आपके लेन-देन मिटाए बिना फिर से सिंक करवाता है। \'सारा डेटा साफ़ करें\' सब कुछ हमेशा के लिए मिटा देता है — पक्का करने के लिए आपको DELETE टाइप करना होगा। यह काम वापस नहीं हो सकता।';

  @override
  String get settingsFaqSectionPremiumAiFeatures => 'Premium और AI फ़ीचर';

  @override
  String get settingsFaq22Question => 'Premium में क्या-क्या मिलता है?';

  @override
  String get settingsFaq22Answer =>
      'Premium से मिलता है: बिना विज्ञापन असीमित AI (कोच, मासिक सारांश, रसीद पढ़ना और बताइए), क्लाउड सिंक, PDF रिपोर्ट, Premium थीम, और वॉलेट, श्रेणियों, बजट, लक्ष्यों व भुगतान के तरीक़ों की सीमा हट जाती है। साथ में प्राथमिकता वाली सहायता भी मिलती है।';

  @override
  String get settingsFaq23Question => 'मुफ़्त वर्ज़न की सीमाएँ क्या हैं?';

  @override
  String get settingsFaq23Answer =>
      'मुफ़्त यूज़र 3 वॉलेट, 10 अपनी श्रेणियाँ, 3 सक्रिय बजट, 2 सक्रिय लक्ष्य/लोन और 5 भुगतान के तरीक़े तक बना सकते हैं। Premium लेने पर ये सारी सीमाएँ हट जाती हैं।';

  @override
  String get settingsFaq24Question => 'AI असिस्टेंट क्या कर सकता है?';

  @override
  String get settingsFaq24Answer =>
      'मनी कोच आपके अपने पैसों के बारे में सवालों के जवाब देता है: पैसा कहाँ गया, आप बजट और लक्ष्यों के हिसाब से ठीक चल रहे हैं या नहीं, कौन-से बिल आने वाले हैं, और कम ख़र्च या ज़्यादा बचत कैसे करें। यह आपके आँकड़ों का सारांश देखता है (कुल रकम, श्रेणियाँ, बजट, लक्ष्य, बिल और हाल के लेन-देन), ताकि जवाब आपके असली नंबरों पर हों, और हर जवाब के बाद आगे के सवाल सुझाता है। यह आम सलाह देता है, पेशेवर वित्तीय सलाह नहीं। आपकी बातचीत सेव रहती है ताकि आप वहीं से शुरू कर सकें जहाँ छोड़ा था, और आप इसे कभी भी मिटा सकते हैं।';

  @override
  String get settingsFaq25Question => 'AI इनसाइट्स कैसे काम करती हैं?';

  @override
  String get settingsFaq25Answer =>
      'मासिक सारांश (आँकड़े > ख़र्च की जानकारी) इस महीने की तुलना पिछले महीने से करता है: आपने कितना कमाया और ख़र्च किया, और हर श्रेणी में क्या बदला। मेरा सारांश लिखें पर टैप करें, और AI बताएगा कि क्या ख़ास रहा और आज़माने के लिए एक चीज़ सुझाएगा। आँकड़े सबके लिए मुफ़्त हैं; AI का लिखा सारांश एक AI अनुरोध लेता है।';

  @override
  String get settingsFaq26Question => 'स्मार्ट श्रेणी चुनाव क्या है?';

  @override
  String get settingsFaq26Answer =>
      'जब आप किसी लेन-देन की श्रेणी ख़ुद चुनते हैं, तो ऐप याद रखता है कि उस शीर्षक की श्रेणी क्या है और अगली बार अपने-आप चुन देता है (इन्हें आप नामकरण नियम में देख और बदल सकते हैं)। किसी नई चीज़ के लिए जोड़ने वाली स्क्रीन पर चमक वाले बटन पर टैप करें और बताइए इस्तेमाल करें: कुछ ऐसा लिखें \'कल bKash से लंच 250\', और AI रकम, तारीख़, श्रेणी और खाता भर देगा, आप बस जाँच लें।';

  @override
  String get settingsFaq27Question => 'AI रसीद स्कैनर कैसे काम करता है?';

  @override
  String get settingsFaq27Answer =>
      'रसीद की फ़ोटो लें या चुनें। आपका फ़ोन डिवाइस पर ही टेक्स्ट पढ़कर दुकान और कुल रकम सुझाता है। AI से पढ़ें पर टैप करें, और AI असली कुल रकम, तारीख़, हर आइटम और सही श्रेणी निकाल लेता है, रसीद गड़बड़ हो तब भी; सिर्फ़ टेक्स्ट भेजा जाता है, फ़ोटो कभी नहीं। सेव करने से पहले आप सब जाँच और बदल सकते हैं। AI से पढ़ना एक AI अनुरोध लेता है।';

  @override
  String get settingsFaq28Question =>
      'मुझे कितने AI अनुरोध मिलते हैं, और विज्ञापन किसलिए हैं?';

  @override
  String get settingsFaq28Answer =>
      'हर किसी को महीने में 10 मुफ़्त AI अनुरोध मिलते हैं, जो 1 तारीख़ को फिर मिल जाते हैं। ज़्यादा चाहिए तो आप चाहें तो एक छोटा विज्ञापन देखकर एक और अनुरोध पा सकते हैं, महीने में 10 और तक। विज्ञापन से 24 घंटे के लिए Premium थीम आज़माने या एक PDF एक्सपोर्ट भी अनलॉक हो सकता है। विज्ञापन तभी चलता है जब आप बटन पर टैप करके पक्का करें; कोई बैनर विज्ञापन नहीं है और कुछ भी अपने-आप नहीं आता। Premium सदस्यों को असीमित AI और बाकी सब कुछ बिल्कुल बिना विज्ञापन मिलता है।';

  @override
  String get settingsFaq29Question => 'अपनी Premium ख़रीद कैसे संभालें?';

  @override
  String get settingsFaq29Answer =>
      'Premium ख़रीद Google Play से संभाली जाती है। अपना प्लान देखने या बदलने के लिए Google Play की सब्सक्रिप्शन सेटिंग्स में जाएँ। Premium मासिक, सालाना या एक बार की आजीवन ख़रीद के रूप में मिलता है।';

  @override
  String get settingsFaqSectionPrivacySecurity => 'गोपनीयता और सुरक्षा';

  @override
  String get settingsFaq30Question => 'बायोमेट्रिक लॉक कैसे सेट करें?';

  @override
  String get settingsFaq30Answer =>
      'सेटिंग्स > गोपनीयता और सुरक्षा में जाएँ और बायोमेट्रिक लॉक चालू करें। इसके बाद ऐप खोलने के लिए आपके फ़िंगरप्रिंट या चेहरे की ज़रूरत होगी। आप ऑटो-लॉक टाइमर भी सेट कर सकते हैं, ताकि कुछ देर इस्तेमाल न होने पर ऐप लॉक हो जाए।';

  @override
  String get settingsFaq31Question => 'क्या मेरा वित्तीय डेटा सुरक्षित है?';

  @override
  String get settingsFaq31Answer =>
      'हाँ। आपका सारा डेटा आपके डिवाइस पर ही रहता है। अगर आप क्लाउड सिंक चालू करते हैं, तो भेजते समय आपका डेटा एन्क्रिप्ट रहता है। हम आपका वित्तीय डेटा कभी किसी तीसरे पक्ष से साझा नहीं करते। आप हमारी गोपनीयता नीति सेटिंग्स > परिचय में देख सकते हैं।';

  @override
  String get txnLoadPaymentMethodsFailed => 'भुगतान तरीक़े लोड नहीं हो सके';

  @override
  String get txnAddPaymentMethodFailed => 'भुगतान तरीक़ा जोड़ा नहीं जा सका';

  @override
  String get txnPaymentMethodNotFound => 'भुगतान तरीक़ा नहीं मिला';

  @override
  String get txnUpdatePaymentMethodFailed => 'भुगतान तरीक़ा अपडेट नहीं हो सका';

  @override
  String get txnDeletePaymentMethodFailed => 'भुगतान तरीक़ा हटाया नहीं जा सका';

  @override
  String txnLoadFailed(String error) {
    return 'लेन-देन लोड नहीं हो सके: $error';
  }

  @override
  String get txnAddFailed => 'लेन-देन जोड़ा नहीं जा सका';

  @override
  String txnAddFailedWithError(String error) {
    return 'लेन-देन जोड़ा नहीं जा सका: $error';
  }

  @override
  String get txnNotFound => 'लेन-देन नहीं मिला';

  @override
  String get txnUpdateFailed => 'लेन-देन अपडेट नहीं हो सका';

  @override
  String txnNotATransfer(String id) {
    return 'लेन-देन $id ट्रांसफ़र नहीं है';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'ट्रांसफ़र अपडेट नहीं हो सका: $error';
  }

  @override
  String get txnDeleteFailed => 'लेन-देन हटाया नहीं जा सका';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'ट्रांसफ़र लोड नहीं हो सके: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'ट्रांसफ़र नहीं बन सका: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'ट्रांसफ़र हटाया नहीं जा सका: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'डेटा लोड नहीं हो सका: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'भुगतान हुआ चिह्नित नहीं हो सका: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'भुगतान नहीं हुआ चिह्नित नहीं हो सका: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'लेन-देन छोड़ा नहीं जा सका: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'मिला: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'चुकाया: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'पलटा गया: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'चुकता चिह्नित नहीं हो सका: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'भुगतान राशि शून्य से ज़्यादा होनी चाहिए';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'भुगतान दर्ज नहीं हो सका: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'बाक़ी चिह्नित नहीं हो सका: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'बाक़ी: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return '$amount का भुगतान दर्ज हुआ';
  }

  @override
  String creditMarkedCollected(String title) {
    return '\"$title\" से वसूल हुआ चिह्नित किया';
  }

  @override
  String get importFieldDescription => 'विवरण';

  @override
  String get importFieldDirection => 'प्रकार (जमा/नामे)';

  @override
  String get importMissingDate => 'एक तारीख़ कॉलम';

  @override
  String get importMissingAmount => 'एक रकम कॉलम';

  @override
  String importColumnN(int index) {
    return 'कॉलम $index';
  }

  @override
  String get importNoDate => 'तारीख़ नहीं';

  @override
  String importDateMismatch(String date, String format) {
    return 'तारीख़ \"$date\" $format से मेल नहीं खाती';
  }

  @override
  String get importAnyKnownFormat => 'किसी भी जाने-पहचाने फ़ॉर्मैट';

  @override
  String get importNoAmount => 'रकम नहीं';

  @override
  String get importIntro =>
      'अपने बैंक से CSV निकालें और यहाँ खोलें। कॉलम आपके लिए पहचाने जाते हैं, और जब तक आप ठीक-ठीक न देख लें कि क्या जुड़ेगा, कुछ नहीं जुड़ता।';

  @override
  String get importSavedBanks => 'सहेजे गए बैंक';

  @override
  String get importChooseStatement => 'स्टेटमेंट चुनें';

  @override
  String get importNoRows => 'उस फ़ाइल में कोई पंक्ति नहीं है।';

  @override
  String importUsingSavedMapping(String name) {
    return '$name के लिए आपकी सहेजी मैपिंग इस्तेमाल हो रही है।';
  }

  @override
  String importCouldNotRead(String error) {
    return 'वह फ़ाइल पढ़ी नहीं जा सकी: $error';
  }

  @override
  String importForgetTitle(String name) {
    return '$name भूल जाएँ?';
  }

  @override
  String get importForgetBody =>
      'अगली बार आपसे फिर से कॉलम मिलाने को कहा जाएगा।';

  @override
  String get importColumnsHeader => 'कॉलम';

  @override
  String get importHowToRead => 'मान कैसे पढ़ें';

  @override
  String get importWhereItGoes => 'कहाँ जाएगा';

  @override
  String get importWhatWillBeAdded => 'क्या जुड़ेगा';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पंक्तियाँ',
      one: '1 पंक्ति',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कॉलम',
      one: '1 कॉलम',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return '$separator से अलग';
  }

  @override
  String importMappedAs(String name) {
    return '$name के रूप में मैप';
  }

  @override
  String get importDelimCommas => 'कॉमा';

  @override
  String get importDelimSemicolons => 'सेमीकोलन';

  @override
  String get importDelimTabs => 'टैब';

  @override
  String get importDelimPipes => 'पाइप (|)';

  @override
  String get importRequired => 'ज़रूरी';

  @override
  String get importNotImported => 'इम्पोर्ट नहीं होगा';

  @override
  String get importEmptySample => 'ख़ाली';

  @override
  String get importPickDateColumnFirst => 'पहले एक तारीख़ कॉलम चुनें।';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" इस फ़ॉर्मैट में नहीं बैठता।';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" को $date पढ़ा जाता है';
  }

  @override
  String get importDecimalAuto => 'फ़ाइल से पता लगाया गया';

  @override
  String get importDecimalFullStop => 'पूर्ण विराम, जैसे 1,234.56';

  @override
  String get importDecimalComma => 'कॉमा, जैसे 1.234,56';

  @override
  String get importDuplicatesHint =>
      'दिन, रकम और विवरण से मिलान करता है, इसलिए ओवरलैप वाला स्टेटमेंट फिर से इम्पोर्ट करने पर कुछ दोगुना नहीं होता';

  @override
  String importStillNeeds(String item) {
    return 'अभी $item चाहिए।';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'अभी $first और $second चाहिए।';
  }

  @override
  String get importNothingReadable =>
      'इन सेटिंग से इस फ़ाइल का कुछ भी नहीं पढ़ा जा सकता। तारीख़ का फ़ॉर्मैट और रकम वाला कॉलम जाँचें।';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन',
      one: '1 लेन-देन',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount आय';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount ख़र्च';
  }

  @override
  String importAndMore(int count) {
    return 'और $count और';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लाइनें छोड़ी जाएँगी',
      one: '1 लाइन छोड़ी जाएगी',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लाइनें छोड़ी जाएँगी।',
      one: '1 लाइन छोड़ी जाएगी।',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'लाइन $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'पहले एक खाता जोड़ें';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन इम्पोर्ट करें',
      one: '1 लेन-देन इम्पोर्ट करें',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लेन-देन इम्पोर्ट करें?',
      one: '1 लेन-देन इम्पोर्ट करें?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'ये आपके रिकॉर्ड में जुड़ेंगे और अगले सिंक पर अपलोड होंगे।';

  @override
  String get importConfirmDuplicates =>
      'जो पहले से उसी दिन, उसी रकम और विवरण के साथ है, उसे छुआ नहीं जाएगा।';

  @override
  String importFailed(String error) {
    return 'इम्पोर्ट विफल रहा: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count इम्पोर्ट हुए';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count पहले से थे और छुए नहीं गए।';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लाइनें पढ़ी नहीं जा सकीं।',
      one: '1 लाइन पढ़ी नहीं जा सकी।',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'नई श्रेणियाँ: $names।';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'इन खाता नामों से यहाँ कुछ मेल नहीं खाया, इसलिए उनकी पंक्तियाँ आपके चुने खाते में गईं: $names।';
  }

  @override
  String get importRememberBody =>
      'इन्हीं कॉलम वाली अगली फ़ाइल बिना पूछे इसी तरह मैप होगी।';

  @override
  String get importNoHeaderCannotSave =>
      'बिना कॉलम शीर्षक वाली फ़ाइल फिर से पहचानी नहीं जा सकती, इसलिए मिलाने को कुछ नहीं है।';

  @override
  String get importTemplateSaved =>
      'सहेजा गया। इन कॉलम वाली फ़ाइलें अब से इसे इस्तेमाल करेंगी।';

  @override
  String get txnTransferSameWallet => 'स्रोत और गंतव्य वॉलेट अलग होने चाहिए';

  @override
  String get txnTransferAmountPositive =>
      'ट्रांसफ़र राशि शून्य से ज़्यादा होनी चाहिए';

  @override
  String get txnTransferFeeNegative => 'ट्रांसफ़र शुल्क ऋणात्मक नहीं हो सकता';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'स्रोत वॉलेट नहीं मिला: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'गंतव्य वॉलेट नहीं मिला: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'ट्रांसफ़र: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'ट्रांसफ़र के लिए दोनों वॉलेट मौजूद होने चाहिए (स्रोत: $source, गंतव्य: $destination)।';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'एक ही मुद्रा में ट्रांसफ़र एक ही रकम ले जाता है: $source और $destination दोनों $currency में हैं, इसलिए मिली रकम अलग नहीं हो सकती।';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return '$from और $to के बीच कोई दर पता नहीं है, इसलिए $destination में असल में जितना पहुँचा वह दर्ज करें।';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'मिली रकम शून्य से ज़्यादा होनी चाहिए। $destination में असल में जितना पहुँचा वह दर्ज करें।';
  }

  @override
  String txnFeeTitle(String title) {
    return 'शुल्क: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'लेन-देन नहीं मिला: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'लेन-देन ट्रांसफ़र नहीं है (कोई जोड़ीदार लेन-देन नहीं)';

  @override
  String txnPairedNotFound(String id) {
    return 'जोड़ीदार लेन-देन $id नहीं मिला; आधा ट्रांसफ़र नहीं बदला जाएगा।';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'ऐसा कोई खाता नहीं: $id';
  }

  @override
  String get walletCorrectionTitle => 'बैलेंस सुधार';

  @override
  String walletCorrectionNote(String name) {
    return '$name को उसके असली बैलेंस से मिलाया गया।';
  }

  @override
  String get walletMergeIntoItself => 'कोई खाता ख़ुद में नहीं मिलाया जा सकता।';

  @override
  String get walletMergeBothMustExist =>
      'मिलाने के लिए दोनों खाते मौजूद होने चाहिए।';

  @override
  String walletMergeNoRate(String from, String to) {
    return '$from और $to के बीच कोई दर पता नहीं है, इसलिए ये खाते अभी नहीं मिलाए जा सकते।';
  }

  @override
  String get walletMergeAdjustmentTitle => 'मिलान समायोजन';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'इन खातों के बीच हुए ट्रांसफ़र की दर उस दर से अलग है जिस पर $name मिलाया गया। कुल रकम न बदले, इसलिए यह अंतर दर्ज करता है।';
  }

  @override
  String get splitErrNoTotal => 'बिल की रकम दर्ज करें।';

  @override
  String get splitErrNoPeople => 'बाँटने के लिए किसी को जोड़ें।';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name इस बिल में शामिल नहीं है।';
  }

  @override
  String get splitErrNothingToRecord =>
      'किसी और ने भुगतान किया और आपका कोई हिस्सा नहीं था, इसलिए दर्ज करने को कुछ नहीं है।';

  @override
  String get splitErrGiveOwnShare => 'अपना हिस्सा दर्ज करें।';

  @override
  String splitErrGiveShare(String name) {
    return '$name का हिस्सा दर्ज करें।';
  }

  @override
  String get splitErrNegativeShare => 'कोई हिस्सा ऋणात्मक नहीं हो सकता।';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'हिस्सों का जोड़ $sum है, $total नहीं।';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'प्रतिशतों का जोड़ $sum% है, 100% नहीं।';
  }

  @override
  String get splitErrNameTooLong => 'नाम 100 अक्षरों से कम रखें।';

  @override
  String splitErrDuplicateName(String name) {
    return '$name बिल में दो बार है।';
  }

  @override
  String get splitErrTitleTooLong => 'शीर्षक 200 अक्षरों से कम रखें।';

  @override
  String get splitErrChooseAccount => 'वह खाता चुनें जिससे भुगतान हुआ।';

  @override
  String get splitErrOrdinaryAccount => 'कोई सामान्य खाता चुनें।';

  @override
  String get splitErrYourShareNothing =>
      'आपका हिस्सा शून्य है, इसलिए कोई बकाया नहीं।';

  @override
  String get splitErrEveryShareNothing => 'सभी हिस्से शून्य हैं।';

  @override
  String get recurringDaily => 'रोज़ाना';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count दिन',
      one: 'हर दिन',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count हफ़्ते',
      one: 'हर हफ़्ते',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count महीने',
      one: 'हर महीने',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count साल',
      one: 'हर साल',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'हर $count $unit';
  }

  @override
  String get recurringUntitled => 'दोहराया जाने वाला लेन-देन';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन में',
      one: '1 दिन में',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'अगले हफ़्ते';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count हफ़्ते में',
      one: '1 हफ़्ते में',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'कार्ड';

  @override
  String get txnPmKindDigitalWallet => 'डिजिटल वॉलेट';

  @override
  String get txnPmEmptyHint =>
      'जिन कार्ड और खातों से आप भुगतान करते हैं उन्हें जोड़ें, फिर लेन-देन पर उनमें से एक चुन सकते हैं।';

  @override
  String get txnPmDeleteBody =>
      'इससे पहले दर्ज लेन-देन बने रहेंगे। बस उनमें अब कोई भुगतान तरीक़ा नहीं दिखेगा।';

  @override
  String get txnPmNew => 'नया भुगतान तरीक़ा';

  @override
  String get txnPmEdit => 'भुगतान तरीक़ा बदलें';

  @override
  String get txnRecentlyDeletedFooter =>
      'हटाए गए लेन-देन तीस दिन रखे जाते हैं, फिर हमेशा के लिए मिट जाते हैं।';

  @override
  String get txnUnknownCategory => 'अज्ञात';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'बिल्कुल यही';

  @override
  String get txnRuleContaining => 'जिसमें भी यह हो';

  @override
  String get txnRulesFooter =>
      'नियम को सटीक न बनाएँ तो वह शीर्षक में कहीं भी मेल खाता है। जब भी आप कुछ हाथ से श्रेणी में रखते हैं, ऐप आपके लिए एक नियम जोड़ देता है।';

  @override
  String get txnRulesEmptyHint =>
      'ऐप को एक बार बताएँ कि कोई चीज़ कहाँ जाती है, फिर वह हमेशा वैसे ही रखेगा।';

  @override
  String get txnRuleNew => 'नया नियम';

  @override
  String get txnRuleEdit => 'नियम बदलें';

  @override
  String get txnRuleExactHint => 'सिर्फ़ वही शीर्षक जो बिल्कुल यही हों';

  @override
  String get txnRuleContainingHint => 'कोई भी शीर्षक जिसमें यह हो';

  @override
  String get txnKindTransfer => 'खातों के बीच ट्रांसफ़र';

  @override
  String get txnKindRecurring => 'दोहराई जाने वाली एंट्री से';

  @override
  String get txnMoneyIn => 'पैसा आया';

  @override
  String get txnMoneyOut => 'पैसा गया';

  @override
  String get txnNotYetPaid => 'अभी भुगतान नहीं हुआ';

  @override
  String get txnLentOut => 'उधार दिया';

  @override
  String get txnSettledInFull => 'पूरा चुकता हो गया।';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid वापस, $owed अभी बाक़ी।';
  }

  @override
  String get txnUncategorised => 'बिना श्रेणी';

  @override
  String get txnUnknownAccount => 'अज्ञात';

  @override
  String get txnTransferCannotCopy =>
      'ट्रांसफ़र को अकेले कॉपी नहीं किया जा सकता।';

  @override
  String get txnCopied => 'कॉपी हो गया।';

  @override
  String get txnDeleteOneBody =>
      'खाते का बैलेंस फिर से गिना जाएगा। अगर यह किसी ट्रांसफ़र का एक हिस्सा है, तो दूसरा हिस्सा भी साथ जाएगा।';

  @override
  String txnUpcomingTab(int count) {
    return 'आने वाले ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'बकाया ($count)';
  }

  @override
  String get txnNoOverdue => 'कोई बकाया लेन-देन नहीं';

  @override
  String get txnNoUpcoming => 'कोई आने वाला लेन-देन नहीं';

  @override
  String get txnNoOverdueBody => 'आपके सभी भुगतान समय पर हैं!';

  @override
  String get txnNoUpcomingBody => 'आपका कोई बाक़ी भुगतान तय नहीं है';

  @override
  String get txnTotalOverdue => 'कुल बकाया';

  @override
  String get txnTotalUpcoming => 'कुल आने वाले';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन बकाया',
      one: '1 दिन बकाया',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '\"$title\" को भुगतान हुआ चिह्नित किया';
  }

  @override
  String txnSkippedTitle(String title) {
    return '\"$title\" छोड़ा गया';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'आज, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'कल, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'कल, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'लेन-देन हटाने में त्रुटि: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return '$title फ़िल्टर करें';
  }

  @override
  String get txnMonthlyIncome => 'मासिक आय';

  @override
  String get txnMonthlyExpenses => 'मासिक ख़र्च';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'लेन-देन',
      one: 'लेन-देन',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'प्रति लेन-देन औसत';

  @override
  String get txnNoPlannedIncome => 'कोई योजनाबद्ध आय नहीं';

  @override
  String get txnNoPlannedExpenses => 'कोई योजनाबद्ध ख़र्च नहीं';

  @override
  String txnAddFutureIncome(String month) {
    return '$month के लिए आगे की आय जोड़ें';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return '$month के लिए आगे के ख़र्च जोड़ें';
  }

  @override
  String get txnNoIncomeYet => 'इस महीने अभी कोई आय नहीं';

  @override
  String get txnNoExpensesYet => 'इस महीने अभी कोई ख़र्च नहीं';

  @override
  String get txnStartTrackingIncome =>
      'इस महीने अपनी आय का हिसाब रखना शुरू करें';

  @override
  String get txnStartTrackingExpenses =>
      'इस महीने अपने ख़र्च का हिसाब रखना शुरू करें';

  @override
  String txnNoIncomeIn(String month) {
    return '$month में कोई आय नहीं';
  }

  @override
  String txnNoExpensesIn(String month) {
    return '$month में कोई ख़र्च नहीं';
  }

  @override
  String txnNoRecordsFor(String month) {
    return '$month के लिए कोई रिकॉर्ड नहीं';
  }

  @override
  String get txnOtherCategory => 'अन्य';

  @override
  String get txnSearchIncome => 'आय खोजें';

  @override
  String get txnSearchExpenses => 'ख़र्च खोजें';

  @override
  String txnErrorWith(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get txnTapToEditAmount => 'रकम बदलने के लिए टैप करें';

  @override
  String get txnTapToEnterAmount => 'रकम डालने के लिए टैप करें';

  @override
  String get txnSpecialDefault => 'सामान्य';

  @override
  String get txnSpecialRepetitive => 'दोहराने वाला';

  @override
  String get txnRepeatSettings => 'दोहराने की सेटिंग';

  @override
  String get txnSubscriptionSettings => 'सब्सक्रिप्शन सेटिंग';

  @override
  String txnEndsOn(String date) {
    return 'समाप्ति: $date';
  }

  @override
  String get txnNoEndDate => 'कोई समाप्ति तिथि नहीं';

  @override
  String get txnEditTransaction => 'लेन-देन बदलें';

  @override
  String get txnNewTransaction => 'नया लेन-देन';

  @override
  String get txnFromAccount => 'किस खाते से';

  @override
  String get txnToAccount => 'किस खाते में';

  @override
  String get txnAmountReceived => 'मिली रकम';

  @override
  String txnAmountReceivedHint(String account) {
    return 'ये खाते अलग-अलग मुद्राओं में हैं। $account में असल में जितना पहुँचा वह दर्ज करें, या ऐप की दर इस्तेमाल करने के लिए ख़ाली छोड़ें।';
  }

  @override
  String txnInCurrency(String currency) {
    return '$currency में';
  }

  @override
  String get txnTransferTitleHint => 'जैसे बचत में डालना (वैकल्पिक)';

  @override
  String get txnTitleHint => 'यह किसलिए था?';

  @override
  String get txnUpdate => 'अपडेट करें';

  @override
  String get txnSelectCategory => 'श्रेणी चुनें';

  @override
  String get txnSearchTransactions => 'लेन-देन खोजें';

  @override
  String get txnSpecialRegular => 'सामान्य';

  @override
  String get txnSpecialLend => 'उधार दें';

  @override
  String get txnSpecialBorrow => 'उधार लें';

  @override
  String get txnSpecialRegularDesc => 'सामान्य लेन-देन';

  @override
  String get txnSpecialUpcomingDesc => 'आगे का भुगतान जिस पर नज़र रखनी है';

  @override
  String get txnSpecialSubscriptionDesc => 'सेवा का नियमित भुगतान';

  @override
  String get txnSpecialRepetitiveDesc => 'दोहराया जाने वाला लेन-देन';

  @override
  String get txnSpecialLendDesc => 'आपका उधार दिया पैसा (वे आपके कर्ज़दार हैं)';

  @override
  String get txnSpecialBorrowDesc =>
      'आपका उधार लिया पैसा (आप उनके कर्ज़दार हैं)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'निचली सीमा ऊपरी से ज़्यादा है, इसलिए कुछ भी मेल नहीं खा सकता। $min से $max।';
  }

  @override
  String get walletMyWallet => 'मेरा वॉलेट';

  @override
  String walletCreateFailed(String error) {
    return 'वॉलेट नहीं बन सका: $error';
  }

  @override
  String get walletTypeBankAccount => 'बैंक खाता';

  @override
  String get walletTypeCreditCard => 'क्रेडिट कार्ड';

  @override
  String get walletTypeSubscription => 'सब्सक्रिप्शन';

  @override
  String get walletTypeDeposit => 'जमा';

  @override
  String get walletTypeInvestment => 'निवेश';

  @override
  String get walletTypeAsset => 'संपत्ति';

  @override
  String get walletEnterAccountName => 'कृपया खाते का नाम दर्ज करें';

  @override
  String get walletCreditLimitRequired => 'क्रेडिट लिमिट ज़रूरी है';

  @override
  String get walletEnterValidCreditLimit => 'कृपया सही क्रेडिट लिमिट दर्ज करें';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'कृपया 0 से ज़्यादा सही क्रेडिट लिमिट दर्ज करें';

  @override
  String get walletEditWallet => 'वॉलेट बदलें';

  @override
  String get walletAddNewWallet => 'नया वॉलेट जोड़ें';

  @override
  String get walletEnterWalletNameError => 'कृपया वॉलेट का नाम दर्ज करें';

  @override
  String get walletEnterValidNumber => 'कृपया सही संख्या दर्ज करें';

  @override
  String get walletShowCents => 'पैसे दिखाएँ (जैसे \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'सिर्फ़ पूर्ण संख्याएँ (जैसे \$1,235)';

  @override
  String get walletCreateWallet => 'वॉलेट बनाएँ';

  @override
  String get walletClosedPill =>
      'बंद। इसका इतिहास रखा गया है, पर यह न दिखाया जाता है न गिना जाता है।';

  @override
  String get walletExcludedPill => 'सभी खातों के कुल से बाहर रखा गया।';

  @override
  String get walletReopen => 'फिर से खोलें';

  @override
  String get walletCloseAccount => 'खाता बंद करें';

  @override
  String get walletReopenSubtitle => 'फिर से दिखाएँ और गिनें';

  @override
  String get walletCloseAccountSubtitle => 'इतिहास रखें, गिनना बंद करें';

  @override
  String get walletIncludeInTotal => 'कुल में शामिल करें';

  @override
  String get walletLeaveOutOfTotal => 'कुल से बाहर रखें';

  @override
  String get walletAlreadyTheBalance => 'यही पहले से बैलेंस है।';

  @override
  String get walletCorrectionRecorded =>
      'अंतर को सुधार के रूप में दर्ज किया गया।';

  @override
  String walletMergeConfirmBody(String name) {
    return '$name में दर्ज सब कुछ चला जाएगा, और $name बंद हो जाएगा। कुछ भी नहीं हटेगा।';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'रकम ले जाते समय $from से $to में बदली जाती है। कुछ भी नहीं हटेगा, और $name हटाने के बजाय बंद होगा।';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount जमा · $available उपलब्ध';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount बकाया · $available अभी उपलब्ध';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return '$name में असल में जितना है वह दर्ज करें। अंतर एक लेन-देन के रूप में दर्ज होगा, ताकि खाता अपने इतिहास से मेल खाए।';
  }

  @override
  String get apiUpdateRequired =>
      'सिंक जारी रखने के लिए The Accountant अपडेट करें। तब तक सब कुछ इसी फ़ोन पर रहेगा।';

  @override
  String get apiAccountExistsLink =>
      'इस ईमेल से एक खाता पहले से मौजूद है। कृपया अपने खाते लिंक करें।';

  @override
  String get apiServerTrouble =>
      'हमारे सर्वर में अभी दिक्कत है। सब कुछ इस फ़ोन पर सुरक्षित है; कुछ मिनट बाद फिर कोशिश करें।';

  @override
  String apiRequestFailedHttp(String status) {
    return 'अनुरोध विफल रहा (HTTP $status)।';
  }

  @override
  String get apiServerTimeout =>
      'हमारे सर्वर ने जवाब देने में बहुत देर की। अपना कनेक्शन जाँचें, या कुछ मिनट बाद फिर कोशिश करें।';

  @override
  String get apiCannotReachServer =>
      'हमारे सर्वर तक नहीं पहुँच पा रहे। अपना कनेक्शन जाँचें; अगर आप ऑनलाइन हैं, तो कुछ मिनट बाद फिर कोशिश करें।';

  @override
  String get apiSomethingWentWrong =>
      'हमारे सर्वर से बात करते समय कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get syncAlreadyInProgress => 'सिंक पहले से चल रहा है';

  @override
  String get syncRequiresPremium => 'क्लाउड सिंक के लिए Premium सदस्यता चाहिए';

  @override
  String get syncNoInternet => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get syncNotAuthenticated => 'साइन इन नहीं है';

  @override
  String get syncCouldNotFetchCloud =>
      'आपका क्लाउड डेटा नहीं लाया जा सका। लोकल डेटा में कोई बदलाव नहीं हुआ।';

  @override
  String get syncAccountUnknown =>
      'साइन इन किया गया खाता पता नहीं चल सका; सिंक रद्द कर दिया गया।';

  @override
  String get syncStoreOtherAccount =>
      'इस डिवाइस का डेटा किसी दूसरे खाते का है। सिंक करने से पहले उस खाते से साइन इन करें, या लोकल डेटा साफ़ करें।';

  @override
  String syncRecordsNotSaved(String record) {
    return 'कुछ क्लाउड रिकॉर्ड इस डिवाइस पर सेव नहीं हो सके: $record। अगले सिंक में फिर कोशिश की जाएगी।';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'कुछ क्लाउड रिकॉर्ड इस डिवाइस पर सेव नहीं हो सके: $record (और $count अन्य)। अगले सिंक में फिर कोशिश की जाएगी।';
  }

  @override
  String notifCardStatementReady(String name) {
    return '$name का स्टेटमेंट तैयार है';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'कुल $amount था, पहले ही चुका दिया गया। अब कुछ बाकी नहीं।';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount का भुगतान $date तक करना है।';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$owed में से $paid पहले ही चुका दिया गया है।';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return '$name का बिल कल देय है';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return '$name का बिल $days दिन में देय है';
  }

  @override
  String notifPayBy(String amount, String date) {
    return '$date तक $amount चुकाएँ।';
  }

  @override
  String notifCardDueToday(String name) {
    return '$name का बिल आज देय है';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount अभी भी बाकी है।$paidSoFar आज भुगतान करने से लेट फ़ीस से बचेंगे।';
  }

  @override
  String get notifWhenToday => 'आज';

  @override
  String get notifWhenTomorrow => 'कल';

  @override
  String notifWhenInDays(int days) {
    return '$days दिन में';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name $when भुगतान करेगा';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$date को $amount $account में आना है।';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name $when मैच्योर होगा';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$date को $amount $account में वापस आएगा।';
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
      'dps': 'जमा',
      'insurance': 'प्रीमियम',
      'sip': 'SIP',
      'other': 'किस्त',
    });
    return '$name: $total में से $_temp0 $number $when देय';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return '$date तक $amount निवेश करें।';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$date को $account से $amount निवेश किया जाएगा।';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$date को $account से $amount दर्ज किया जाएगा।';
  }

  @override
  String get notifYourAccount => 'आपका खाता';

  @override
  String get notifPlansUpdatedTitle => 'EMI और बचत अपडेट हो गई';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्लान एंट्रियाँ अपने दिन पर दर्ज की गईं।',
      one: '1 प्लान एंट्री अपने दिन पर दर्ज की गई।',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'आवर्ती लेन-देन दर्ज हो गए';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आवर्ती लेन-देन दर्ज हुए।',
      one: '1 आवर्ती लेन-देन दर्ज हुआ।',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count भुगतानों की पुष्टि करनी है',
      one: '1 भुगतान की पुष्टि करनी है',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'आने वाले में जाकर पुष्टि करें कि कितना कटा, या इसे छोड़ दें।';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — आने वाले में जाकर पुष्टि करें कि कितना कटा, या इसे छोड़ दें।';
  }

  @override
  String get notifUpcomingFallbackTitle => 'आने वाला लेन-देन';

  @override
  String notifUpcomingTitle(String title) {
    return 'आने वाला: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return '$amount की आय जल्द आने वाली है।';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return '$amount का खर्च जल्द देय है।';
  }

  @override
  String get notifCreditFallback => 'उधार';

  @override
  String get notifDebtFallback => 'कर्ज़';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'बकाया उधार: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'बकाया कर्ज़: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount अभी बाकी है। देखने के लिए टैप करें।';
  }

  @override
  String get notifRecurringFallbackTitle => 'आवर्ती लेन-देन';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'आने वाला आवर्ती: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$date को $amount देय।';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'उधार देय: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'कर्ज़ देय: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'सब्सक्रिप्शन देय: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'बिल देय: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'जल्द देय: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'आवर्ती बिल';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount जल्द देय है। देखने के लिए टैप करें।';
  }

  @override
  String get notifChannelRecurring => 'आवर्ती लेन-देन';

  @override
  String get notifChannelRecurringDesc =>
      'अपने-आप बने आवर्ती लेन-देन की सूचनाएँ';

  @override
  String get notifChannelUpcoming => 'आने वाले रिमाइंडर';

  @override
  String get notifChannelUpcomingDesc => 'आने वाले लेन-देन के रिमाइंडर';

  @override
  String get notifChannelLoan => 'उधार के रिमाइंडर';

  @override
  String get notifChannelLoanDesc => 'बकाया उधार और कर्ज़ के रिमाइंडर';

  @override
  String get notifChannelDueDate => 'देय तिथि के रिमाइंडर';

  @override
  String get notifChannelDueDateDesc =>
      'किसी खास लेन-देन की देय तिथि के लिए एक बार का रिमाइंडर';

  @override
  String get notifChannelBillsDesc =>
      'आने वाले क्रेडिट कार्ड बिल और प्लान की किस्तें';

  @override
  String get notifOffset1Hour => '1 घंटा पहले';

  @override
  String get notifOffset1Day => '1 दिन पहले';

  @override
  String get notifOffset3Days => '3 दिन पहले';

  @override
  String get notifOffset1Week => '1 हफ़्ता पहले';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes मिनट पहले';
  }

  @override
  String get notifChannelGeneral => 'सामान्य';

  @override
  String get notifChannelGeneralDesc => 'खाते और ऐप की सूचनाएँ';

  @override
  String get notifChannelReminders => 'रोज़ के रिमाइंडर';

  @override
  String get notifChannelRemindersDesc => 'दिन का खर्च दर्ज करने की याद';

  @override
  String get notifChannelBillsStatementsDesc =>
      'क्रेडिट कार्ड स्टेटमेंट और देय तिथियाँ';

  @override
  String get notifChannelBudgets => 'बजट अलर्ट';

  @override
  String get notifChannelBudgetsDesc => 'जब कोई बजट लगभग या पूरा खर्च हो जाए';

  @override
  String notifOverBudgetTitle(String name) {
    return 'बजट से ज़्यादा: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'बजट अलर्ट: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'आपने इस अवधि के लिए अपने $name बजट का $percent% खर्च कर दिया है।';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'आपने अपने $name बजट का $percent% इस्तेमाल कर लिया है।';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium जल्द खत्म हो रहा है';

  @override
  String get notifPremiumEndsTomorrow =>
      'आपका Premium कल खत्म हो रहा है। Premium सुविधाएँ बनाए रखने के लिए रिन्यू करें।';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'आपका Premium $days दिन में खत्म हो रहा है। Premium सुविधाएँ बनाए रखने के लिए रिन्यू करें।';
  }

  @override
  String get notifLargeIncomeTitle => 'बड़ी आय का अलर्ट';

  @override
  String get notifLargeExpenseTitle => 'बड़े खर्च का अलर्ट';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return '$amount की आय दर्ज हुई: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return '$amount की आय दर्ज हुई';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return '$amount का खर्च दर्ज हुआ: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return '$amount का खर्च दर्ज हुआ';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'रोज़ के खर्च की रिमाइंडर सूचनाएँ';

  @override
  String get notifDailyReminderTitle => 'रोज़ के खर्च का रिमाइंडर';

  @override
  String get notifDailyReminderBody =>
      'आज के खर्च दर्ज करना न भूलें! अपने खर्च पर नज़र रखें।';

  @override
  String get notifTestTitle => 'टेस्ट सूचना';

  @override
  String get notifTestBody =>
      'अगर आप यह देख रहे हैं, तो सूचनाएँ काम कर रही हैं!';

  @override
  String get notifActionSnooze1Day => '1 दिन बाद';

  @override
  String get notifActionSnooze1Week => '1 हफ़्ते बाद';

  @override
  String get notifGroupThisWeek => 'इस हफ़्ते';

  @override
  String get notifGroupThisMonth => 'इस महीने';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date, $time बजे';
  }

  @override
  String notifMinutesAgo(int count) {
    return '$count मि. पहले';
  }

  @override
  String notifHoursAgo(int count) {
    return '$count घं. पहले';
  }

  @override
  String notifDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get notifPrimerSheetBody =>
      'सूचनाएँ चालू करें, ज़रूरी बातों के बारे में हम आपको पहले से बता देंगे।';

  @override
  String get notifPrimerBudgetsBody =>
      'बजट से ज़्यादा खर्च करने से पहले जान लें।';

  @override
  String get notifPrimerBillsTitle => 'बिल और सब्सक्रिप्शन के रिमाइंडर';

  @override
  String get notifPrimerBillsBody => 'कोई भी आवर्ती भुगतान न छूटे।';

  @override
  String get notifPrimerLargeTitle => 'बड़े लेन-देन';

  @override
  String get notifPrimerLargeBody => 'असामान्य गतिविधि की सूचना पाएँ।';

  @override
  String get notifLoadFailed => 'सूचनाएँ लोड नहीं हो सकीं';

  @override
  String get startupReasonSomethingWrong =>
      'शुरू होते समय कुछ गड़बड़ हो गई। आपका डेटा इस डिवाइस पर सुरक्षित है।';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'इस खाते का लोकल डेटा नहीं खुल सका।';

  @override
  String get startupReasonSetupFailed =>
      'हम इस डिवाइस पर इस खाते की सेटिंग पूरी नहीं कर सके। कुछ भी डिलीट नहीं हुआ है।';

  @override
  String get startupReasonOffline =>
      'हम आपके खाते तक नहीं पहुँच सके, और इस डिवाइस पर अभी इसका डेटा नहीं है। अगर आपने पहले The Accountant इस्तेमाल किया है, तो इंटरनेट से जुड़ें और हम आपका डेटा वापस ले आएँगे। नए हैं? आप अभी इस डिवाइस पर शुरू कर सकते हैं।';

  @override
  String get startupReasonNeedsSubscription =>
      'इस खाते का डेटा क्लाउड में सेव है। उसे वापस लाने के लिए सक्रिय सदस्यता चाहिए। कुछ भी डिलीट नहीं हुआ है।';

  @override
  String get startupReasonConfirmingSubscription =>
      'इस खाते का डेटा क्लाउड में है। उसे वापस लाने के लिए हम अभी आपकी सदस्यता की पुष्टि कर रहे हैं।';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'रीस्टोर विफल रहा: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'इस खाते का डेटा क्लाउड में है, लेकिन अभी उसे वापस नहीं लाया जा सका।';

  @override
  String get commonBiometricReason =>
      'The Accountant अनलॉक करने के लिए पहचान की पुष्टि करें';

  @override
  String get commonLoadCurrenciesFailed => 'मुद्राएँ लोड नहीं हो सकीं';

  @override
  String get commonLoadRatesFailed => 'विनिमय दरें लोड नहीं हो सकीं';

  @override
  String get commonRefreshRatesFailed => 'विनिमय दरें रीफ़्रेश नहीं हो सकीं';

  @override
  String get commonAllCategories => 'सभी श्रेणियाँ';

  @override
  String commonCategoryCount(int count) {
    return '$count श्रेणियाँ';
  }

  @override
  String get commonTierFree => 'मुफ़्त';

  @override
  String get commonTierMonthly => 'Premium मासिक';

  @override
  String get commonTierYearly => 'Premium वार्षिक';

  @override
  String get commonTierLifetime => 'Premium लाइफ़टाइम';

  @override
  String get commonCategoryMergeSelf =>
      'किसी श्रेणी को खुद में नहीं मिलाया जा सकता।';

  @override
  String get commonCategoryMergeMissing =>
      'मिलाने के लिए दोनों श्रेणियाँ मौजूद होनी चाहिए।';

  @override
  String get commonCategoryMergeSystem =>
      'ऐप की अपनी श्रेणियाँ नहीं मिलाई जा सकतीं।';

  @override
  String get commonCategoryMergeKinds =>
      'आय और खर्च की श्रेणियाँ नहीं मिलाई जा सकतीं।';

  @override
  String get commonCategoryOneLevel =>
      'वह श्रेणी किसी दूसरी के अंदर है, और श्रेणियाँ सिर्फ़ एक स्तर तक होती हैं।';

  @override
  String get commonCategoryMoveSame => 'ले जाने के लिए कोई दूसरी श्रेणी चुनें।';

  @override
  String get commonCategoryMoveMissing =>
      'ले जाने के लिए दोनों श्रेणियाँ मौजूद होनी चाहिए।';

  @override
  String get commonCategoryMoveSystem =>
      'ऐप की अपनी श्रेणियों के बीच कुछ नहीं ले जाया जा सकता।';

  @override
  String get commonCategoryMoveKinds =>
      'आय और खर्च के लेन-देन आपस में श्रेणी नहीं बदल सकते।';

  @override
  String get commonCategoryGone => 'वह श्रेणी अब मौजूद नहीं है।';

  @override
  String get commonCategoryParentSystem =>
      'ऐप की अपनी श्रेणियाँ नहीं हटाई-बढ़ाई जा सकतीं।';

  @override
  String get commonCategoryParentSelf => 'कोई श्रेणी खुद के अंदर नहीं हो सकती।';

  @override
  String get commonCategoryParentIntoSystem =>
      'ऐप की अपनी श्रेणियों के अंदर कुछ नहीं रखा जा सकता।';

  @override
  String get commonCategoryParentKinds =>
      'आय की श्रेणी और खर्च की श्रेणी एक-दूसरे के अंदर नहीं रखी जा सकतीं।';

  @override
  String get commonCategoryHasChildren =>
      'इस श्रेणी की अपनी उप-श्रेणियाँ हैं, इसलिए यह ऊपरी स्तर पर ही रहेगी।';

  @override
  String get commonTapToChange => 'बदलने के लिए टैप करें';

  @override
  String get commonSelectColor => 'रंग चुनें';

  @override
  String get commonShowPalette => 'पैलेट दिखाएँ';

  @override
  String get commonCustomColor => 'अपना रंग';

  @override
  String get commonSelectCurrency => 'मुद्रा चुनें';

  @override
  String get commonEnableCryptoHint =>
      'क्रिप्टो टोकन खोजने के लिए \'क्रिप्टो मुद्राएँ शामिल करें\' चालू करें।';

  @override
  String get commonSearchHint => 'खोजें...';

  @override
  String get aiLoadConversationsFailed => 'बातचीत लोड नहीं हो सकीं।';

  @override
  String get aiLoadHistoryFailed => 'चैट का इतिहास लोड नहीं हो सका।';

  @override
  String get aiPremiumRequired => 'AI असिस्टेंट के लिए Premium सदस्यता चाहिए';

  @override
  String get aiUnexpectedError =>
      'एक अनपेक्षित गड़बड़ी हुई। कृपया फिर कोशिश करें।';

  @override
  String get aiResponseFailed =>
      'AI का जवाब नहीं मिल सका। कृपया फिर कोशिश करें।';

  @override
  String get aiServiceNotAnswering => 'AI सेवा जवाब नहीं दे रही है।';

  @override
  String get aiReplyCutOff => 'जवाब बीच में कट गया। कृपया फिर कोशिश करें।';

  @override
  String get aiCouldNotReachServer =>
      'सर्वर तक नहीं पहुँच सके। अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get aiSomethingWentWrong => 'कुछ गड़बड़ हो गई।';

  @override
  String get aiOpenConversationFailed => 'बातचीत नहीं खुल सकी।';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपके $count बदलाव सेव हो गए, लेकिन कोच अपना जवाब पूरा नहीं कर सका। दोबारा पूछने से पहले इन्हें अपने रिकॉर्ड में देख लें।',
      one:
          'आपका बदलाव सेव हो गया, लेकिन कोच अपना जवाब पूरा नहीं कर सका। दोबारा पूछने से पहले इसे अपने रिकॉर्ड में देख लें।',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'AI सेवा अभी जवाब नहीं दे रही है। कृपया फिर कोशिश करें।';

  @override
  String aiMinutesShort(int count) {
    return '$count मि.';
  }

  @override
  String aiHoursShort(int count) {
    return '$count घं.';
  }

  @override
  String aiDaysShort(int count) {
    return '$count दिन';
  }

  @override
  String get aiOcrTextFailed => 'तस्वीर से टेक्स्ट नहीं निकाला जा सका';

  @override
  String get aiOcrReceiptFailed =>
      'तस्वीर से रसीद की जानकारी नहीं निकाली जा सकी';

  @override
  String get coachYes => 'हाँ';

  @override
  String get coachNo => 'नहीं';

  @override
  String get coachTradeBuy => 'ख़रीद';

  @override
  String get coachTradeSell => 'बिक्री';

  @override
  String get coachTradeDividend => 'लाभांश';

  @override
  String get planAccountGone => 'वह खाता अब मौजूद नहीं है।';

  @override
  String get planPaidFromOrdinary =>
      'प्लान का भुगतान सामान्य खाते से होता है, जमा खाते से नहीं।';

  @override
  String get planSipChooseHolding => 'SIP जो फ़ंड या शेयर ख़रीदेगा, उसे चुनें।';

  @override
  String get planSipPayFromOther => 'SIP का भुगतान किसी दूसरे खाते से करें।';

  @override
  String get planNeedNameError => 'प्लान को एक नाम दें।';

  @override
  String get planInstallmentCountRange =>
      'किस्तों की संख्या 1 से 1200 के बीच होनी चाहिए।';

  @override
  String get planIntervalMin => 'अंतराल कम से कम 1 होना चाहिए।';

  @override
  String get planRateRange => 'दर 0 से 100 प्रतिशत के बीच होनी चाहिए।';

  @override
  String get planTaxRange => 'टैक्स 0 से 100 प्रतिशत के बीच होना चाहिए।';

  @override
  String get planProviderTooLong => 'कंपनी और नंबर 100 अक्षरों से कम रखें।';

  @override
  String get planNeedPremium => 'प्रीमियम दर्ज करें।';

  @override
  String get planNeedInstallmentAmount => 'हर किस्त की राशि दर्ज करें।';

  @override
  String get planNeedDeposited => 'जमा की गई राशि दर्ज करें।';

  @override
  String get planTermMonthsOrYears => 'इसकी अवधि महीनों या सालों में होती है।';

  @override
  String get planAmountNotNegative => 'राशि ऋणात्मक नहीं हो सकती।';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name की मैच्योरिटी $date को है। उससे पहले पैसा निकालने के लिए इसे पहले ही बंद करें।';
  }

  @override
  String get planNoLongerExists => 'वह प्लान अब मौजूद नहीं है।';

  @override
  String get planReminderDaysRange =>
      'रिमाइंडर 0 (बंद) से 30 दिन पहले तक हो सकते हैं।';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name में अभी पैसा है। पहले इसे बंद करें, इससे पैसा $account में वापस चला जाएगा।';
  }

  @override
  String get planItsAccount => 'उसका खाता';

  @override
  String planAlreadyEnded(String name) {
    return '$name पहले ही ख़त्म हो चुका है।';
  }

  @override
  String get investNeedName => 'निवेश को एक नाम दें।';

  @override
  String get investNameTooLong => 'नाम 100 अक्षरों से कम रखें।';

  @override
  String get investSymbolTooLong => 'सिंबल 20 अक्षरों से कम रखें।';

  @override
  String get investPriceNotNegative => 'क़ीमत ऋणात्मक नहीं हो सकती।';

  @override
  String investAlreadyTracked(String name) {
    return '$name पहले से ट्रैक हो रहा है।';
  }

  @override
  String get investNeedPaid => 'जितना भुगतान हुआ, वह दर्ज करें।';

  @override
  String get investUnitsBoughtPositive =>
      'ख़रीदी गई यूनिट शून्य से ज़्यादा होनी चाहिए।';

  @override
  String get investPayFromOther => 'किसी दूसरे खाते से भुगतान करें।';

  @override
  String get investNeedSaleAmount => 'बिक्री से जितना मिला, वह दर्ज करें।';

  @override
  String get investUnitsSoldPositive =>
      'बेची गई यूनिट शून्य से ज़्यादा होनी चाहिए।';

  @override
  String get investSellIntoOther => 'बिक्री का पैसा किसी दूसरे खाते में लें।';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return '$name की सिर्फ़ $units यूनिट हैं।';
  }

  @override
  String get investNeedDividend => 'मिला डिविडेंड दर्ज करें।';

  @override
  String get investReceiveIntoOrdinary => 'इसे किसी सामान्य खाते में लें।';

  @override
  String get investPricePositive => 'क़ीमत शून्य से ज़्यादा होनी चाहिए।';

  @override
  String get investUnitsPositive => 'यूनिट शून्य से ज़्यादा होनी चाहिए।';

  @override
  String get investNotATrade => 'यह किसी निवेश की ख़रीद-बिक्री नहीं है।';

  @override
  String investStillHoldsUnits(String name) {
    return '$name में अभी यूनिट हैं। पहले उन्हें बेचें।';
  }

  @override
  String get investNoLongerExists => 'वह निवेश अब मौजूद नहीं है।';

  @override
  String get networthNeedAssetName => 'संपत्ति को एक नाम दें।';

  @override
  String get networthValueNotNegative => 'क़ीमत ऋणात्मक नहीं हो सकती।';

  @override
  String get networthNeedPaidFor => 'इसके लिए जितना भुगतान हुआ, वह दर्ज करें।';

  @override
  String get networthPayFromOrdinary => 'किसी सामान्य खाते से भुगतान करें।';

  @override
  String get networthNeedWorth => 'इसकी क़ीमत दर्ज करें।';

  @override
  String get networthNeedSoldFor => 'यह जितने में बिका, वह दर्ज करें।';

  @override
  String get networthReceiveIntoOrdinary => 'पैसा किसी सामान्य खाते में लें।';

  @override
  String networthStillWorth(String name) {
    return '$name की अभी भी कुछ क़ीमत है। पहले इसे बेचें, या इसकी क़ीमत शून्य करें।';
  }

  @override
  String get networthAssetGone => 'वह संपत्ति अब ट्रैक नहीं हो रही।';

  @override
  String get zakatNeedAmountPaid => 'भुगतान की गई राशि दर्ज करें।';

  @override
  String get zakatPayFromOrdinary => 'इसे किसी सामान्य खाते से चुकाएँ।';

  @override
  String get zakatReminderTitleToday => 'आपकी ज़कात आज देय है';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ज़कात $count दिन में देय',
      one: 'ज़कात 1 दिन में देय',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'आपका ज़कात साल आज पूरा हो रहा है। देय राशि देखने के लिए टैप करें।';

  @override
  String zakatReminderBodyOn(String date) {
    return 'आपका ज़कात साल $date को पूरा होगा। देय राशि देखने के लिए टैप करें।';
  }

  @override
  String get budgetCheckFailed => 'बजट जाँचे नहीं जा सके';

  @override
  String get budgetLoadFailed => 'बजट लोड नहीं हो सके';

  @override
  String get budgetAddFailed => 'बजट जोड़ा नहीं जा सका';

  @override
  String get budgetNotFound => 'बजट नहीं मिला';

  @override
  String get budgetUpdateFailed => 'बजट अपडेट नहीं हो सका';

  @override
  String get budgetDeleteFailed => 'बजट हटाया नहीं जा सका';

  @override
  String get budgetEdit => 'बजट बदलें';

  @override
  String get budgetNeedName => 'बजट को एक नाम दें';

  @override
  String get budgetEnterAmount => 'राशि दर्ज करें';

  @override
  String get budgetAmountMoreThanZero => 'राशि शून्य से ज़्यादा होनी चाहिए';

  @override
  String get budgetTrackingEarnings => 'कमाई पर नज़र';

  @override
  String get budgetTrackingSpending => 'ख़र्च पर नज़र';

  @override
  String get budgetRepeats => 'दोहराव';

  @override
  String get budgetTooBig => 'बहुत बड़ा';

  @override
  String get budgetStarts => 'शुरू';

  @override
  String get budgetEnds => 'ख़त्म';

  @override
  String get budgetStopsRepeating => 'दोहराव बंद';

  @override
  String get budgetNever => 'कभी नहीं';

  @override
  String get budgetCategoriesAll => 'श्रेणियाँ: सभी';

  @override
  String budgetCategoriesSelected(int count) {
    return 'श्रेणियाँ: $count चुनी गईं';
  }

  @override
  String get budgetNoIncomeCategories => 'अभी कोई आय श्रेणी नहीं है।';

  @override
  String get budgetNoExpenseCategories => 'अभी कोई ख़र्च श्रेणी नहीं है।';

  @override
  String get budgetCategoriesHint =>
      'हर श्रेणी पर नज़र रखने के लिए ख़ाली छोड़ें। चुनी गई श्रेणी के अंदर दर्ज हर चीज़ भी इसमें गिनी जाती है।';

  @override
  String get budgetAccountsAll => 'खाते: सभी';

  @override
  String budgetAccountsSelected(int count) {
    return 'खाते: $count चुने गए';
  }

  @override
  String get budgetRolloverHint =>
      'जो ख़र्च नहीं हुआ, वह अगली अवधि में जुड़ जाता है। सीमा पार करने पर कोई कमी आगे नहीं जाती।';

  @override
  String get budgetPeriodDaily => 'रोज़ाना';

  @override
  String get budgetPeriodFortnightly => 'हर दो हफ़्ते';

  @override
  String get budgetPeriodOneOff => 'एक बार';

  @override
  String get budgetUnitDays => 'दिन';

  @override
  String get budgetUnitWeeks => 'हफ़्ते';

  @override
  String get budgetUnitFortnights => 'पखवाड़े';

  @override
  String get budgetUnitMonths => 'महीने';

  @override
  String get budgetUnitYears => 'साल';

  @override
  String get budgetOneOffNeedsEnd =>
      'एक बार के बजट के लिए आख़िरी तारीख़ ज़रूरी है।';

  @override
  String get budgetEndAfterStart =>
      'आख़िरी तारीख़ शुरू की तारीख़ के बाद होनी चाहिए।';

  @override
  String get budgetSaveFailed => 'बजट सेव नहीं हो सका।';

  @override
  String get budgetThisPeriod => 'यह अवधि';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अवधि पहले',
      one: '1 अवधि पहले',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start से $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return '$limit में से';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return '$limit में से, जिसमें $carried पिछली बार से आया';
  }

  @override
  String get budgetUncategorised => 'बिना श्रेणी';

  @override
  String budgetOverTheLimit(String amount) {
    return 'सीमा से $amount ज़्यादा।';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left बचा है, लगभग $daily रोज़।';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left बचा है।';
  }

  @override
  String budgetAveraging(String amount) {
    return 'औसतन हर अवधि में $amount।';
  }

  @override
  String budgetHeadingOver(String amount) {
    return '$amount ज़्यादा होने की ओर';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'इस रफ़्तार से, और अवधि ख़त्म होने से पहले पहले से तय $scheduled को गिनकर।';
  }

  @override
  String get budgetForecastPlain => 'इस रफ़्तार से, अवधि के अंत तक।';

  @override
  String get budgetCapsExplain =>
      'बजट बताता है कि अवधि में ज़्यादा ख़र्च हुआ या नहीं। सीमा बताती है कहाँ: खाने का बजट कुल मिलाकर ठीक हो, फिर भी उसका ज़्यादातर हिस्सा बाहर के खाने पर जा सकता है।';

  @override
  String get budgetPercentOfBudget => 'बजट का प्रतिशत';

  @override
  String get budgetArchivedTitle => 'संग्रहित बजट';

  @override
  String get budgetShowActive => 'सक्रिय दिखाएँ';

  @override
  String get budgetShowArchived => 'संग्रहित दिखाएँ';

  @override
  String get budgetUnpin => 'पिन हटाएँ';

  @override
  String get budgetPinToTop => 'ऊपर पिन करें';

  @override
  String get budgetStartCounting => 'फिर से गिनना शुरू करें';

  @override
  String get budgetStopCounting => 'इतिहास रखें, गिनना बंद करें';

  @override
  String get budgetDeleteBody =>
      'बजट हटेगा, आपके लेन-देन रहेंगे। आपका दर्ज किया कुछ भी नहीं हटेगा।';

  @override
  String get budgetNothingArchived => 'कुछ भी संग्रहित नहीं';

  @override
  String get budgetNoneYet => 'अभी कोई बजट नहीं';

  @override
  String get budgetArchivedEmptyHint =>
      'आप जो बजट संग्रहित करेंगे, वे यहाँ रहेंगे।';

  @override
  String get budgetEmptyHint =>
      'किसी श्रेणी के लिए सीमा तय करें और देखें महीना कैसा चल रहा है।';

  @override
  String dashLoadFailed(String error) {
    return 'वित्तीय डेटा लोड नहीं हो सका: $error';
  }

  @override
  String get categoryUnknown => 'अज्ञात';

  @override
  String dashCardAvailable(String amount) {
    return 'उपलब्ध: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'क्रेडिट में · उपलब्ध: $amount';
  }

  @override
  String get dashTypeBank => 'बैंक';

  @override
  String get dashTypeCredit => 'क्रेडिट';

  @override
  String get dashTypeSubs => 'सब्सक्रिप्शन';

  @override
  String get dashTypeDeposit => 'जमा';

  @override
  String get dashTypeInvest => 'निवेश';

  @override
  String get dashTypeAsset => 'संपत्ति';

  @override
  String get dashAddAccountTile => 'खाता\nजोड़ें';

  @override
  String get categoryLoadFailed => 'श्रेणियाँ लोड नहीं हो सकीं';

  @override
  String get categoryAddFailed => 'श्रेणी जोड़ी नहीं जा सकी';

  @override
  String get categoryNotFound => 'श्रेणी नहीं मिली';

  @override
  String get categoryUpdateFailed => 'श्रेणी अपडेट नहीं हो सकी';

  @override
  String get categoryCannotDeleteSystem =>
      'ऐप की अपनी श्रेणियाँ हटाई नहीं जा सकतीं';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'लेन-देन वाली श्रेणी हटाई नहीं जा सकती; पहले उन्हें दूसरी जगह ले जाएँ या हटाएँ';

  @override
  String get categoryDeleteFailed => 'श्रेणी हटाई नहीं जा सकी';

  @override
  String categorySaveFailed(String error) {
    return 'श्रेणी सेव नहीं हो सकी: $error';
  }

  @override
  String get categoryEditTitle => 'श्रेणी बदलें';

  @override
  String get categoryNewTitle => 'नई श्रेणी';

  @override
  String get categoryPartOf => 'इसका हिस्सा';

  @override
  String get categoryNamePlaceholder => 'श्रेणी का नाम';

  @override
  String get categoryUpdate => 'श्रेणी अपडेट करें';

  @override
  String get categoryCreate => 'श्रेणी बनाएँ';

  @override
  String reportLoadFailed(String error) {
    return 'रिपोर्ट लोड नहीं हो सकीं: $error';
  }

  @override
  String get goalEdit => 'लक्ष्य बदलें';

  @override
  String get goalNeedName => 'लक्ष्य को एक नाम दें';

  @override
  String get goalTargetMoreThanZero =>
      'लक्ष्य राशि शून्य से ज़्यादा होनी चाहिए';

  @override
  String get goalNoDeadline => 'कोई समय-सीमा नहीं';

  @override
  String get goalTargetDateAfterStart =>
      'लक्ष्य की तारीख़ शुरू की तारीख़ के बाद होनी चाहिए।';

  @override
  String get goalSaveFailed => 'लक्ष्य सेव नहीं हो सका।';

  @override
  String get goalArchivedTitle => 'संग्रहित लक्ष्य';

  @override
  String get goalHideFromHome => 'होम से छिपाएँ';

  @override
  String get goalShowOnHome => 'होम पर दिखाएँ';

  @override
  String get goalReached => 'पूरा हुआ';

  @override
  String goalToGo(String amount) {
    return '$amount बाकी';
  }

  @override
  String get goalNoneYet => 'अभी कोई लक्ष्य नहीं';

  @override
  String get goalArchivedEmptyHint =>
      'आप जो लक्ष्य संग्रहित करेंगे, वे यहाँ रहेंगे।';

  @override
  String get goalEmptyHint =>
      'जिसके लिए बचत कर रहे हैं उसका नाम दें, फिर उसकी ओर जाने वाले लेन-देन जोड़ें।';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$target में से $saved';
  }

  @override
  String goalOfTarget(String target) {
    return '$target में से';
  }

  @override
  String get goalReachedNicelyDone => 'पूरा हुआ। बहुत बढ़िया।';

  @override
  String goalStillToGo(String amount) {
    return 'अभी $amount बाकी है।';
  }

  @override
  String goalDailyToArrive(String amount) {
    return 'समय पर पहुँचने के लिए रोज़ $amount।';
  }

  @override
  String get goalNothingLinked =>
      'अभी कुछ नहीं जुड़ा। किसी लेन-देन पर यह लक्ष्य चुनें, वह यहाँ दिखेगा।';

  @override
  String get goalDeleteBody =>
      'लक्ष्य हटेगा, आपके लेन-देन रहेंगे। बस वे अब इसमें नहीं गिने जाएँगे।';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$amount के $count भुगतान',
      one: '$amount का 1 भुगतान',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'लगभग $date तक पूरा।';
  }

  @override
  String goalNotFound(String id) {
    return 'लक्ष्य नहीं मिला: $id';
  }

  @override
  String get goalPaidOff => 'चुका दिया!';

  @override
  String get goalCompleted => 'पूरा हुआ!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% पूरा';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count हफ़्ते बाकी',
      one: '1 हफ़्ता बाकी',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने बाकी',
      one: '1 महीना बाकी',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return '$years साल बाकी';
  }

  @override
  String get subRecurringBill => 'नियमित बिल';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count दिन',
      one: 'हर 1 दिन',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count हफ़्ते',
      one: 'हर 1 हफ़्ते',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count महीने',
      one: 'हर 1 महीने',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count साल',
      one: 'हर 1 साल',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'हर $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'सब्सक्रिप्शन लोड नहीं हो सके: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'सब्सक्रिप्शन रोका नहीं जा सका: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'सब्सक्रिप्शन फिर शुरू नहीं हो सका: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'सब्सक्रिप्शन अपडेट नहीं हो सका: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'सब्सक्रिप्शन रद्द नहीं हो सका: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'सक्रिय ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'रुके हुए ($count)';
  }

  @override
  String get subEmptyTitle => 'कोई सब्सक्रिप्शन या बिल नहीं';

  @override
  String get subEmptyBody =>
      'यहाँ ट्रैक करने के लिए सब्सक्रिप्शन या नियमित बिल वाले लेन-देन जोड़ें';

  @override
  String get subRecurringCost => 'नियमित ख़र्च';

  @override
  String subPerYear(String amount) {
    return '$amount / साल';
  }

  @override
  String get subActive => 'सक्रिय';

  @override
  String subNext(String date) {
    return 'अगला $date';
  }

  @override
  String get subResume => 'फिर शुरू करें';

  @override
  String get subPause => 'रोकें';

  @override
  String get subCancelBillTitle => 'नियमित बिल रद्द करें';

  @override
  String get subCancelSubTitle => 'सब्सक्रिप्शन रद्द करें';

  @override
  String subCancelConfirm(String name) {
    return 'क्या आप सच में \"$name\" रद्द करना चाहते हैं? इससे आगे के सभी नियमित भुगतान रुक जाएँगे।';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" रद्द हुआ';
  }

  @override
  String subSaveError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get subEditBill => 'नियमित बिल बदलें';

  @override
  String get subEditSub => 'सब्सक्रिप्शन बदलें';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'दिन',
      one: 'दिन',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हफ़्ते',
      one: 'हफ़्ता',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'महीने',
      one: 'महीना',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'साल',
      one: 'साल',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'ख़त्म: $date';
  }

  @override
  String get subNoEndDate => 'कोई आख़िरी तारीख़ नहीं';
}
