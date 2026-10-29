// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class L10nSw extends L10n {
  L10nSw([String locale = 'sw']) : super(locale);

  @override
  String get actionCancel => 'Ghairi';

  @override
  String get actionConfirm => 'Thibitisha';

  @override
  String get dateToday => 'Leo';

  @override
  String get dateYesterday => 'Jana';

  @override
  String get dateTomorrow => 'Kesho';

  @override
  String get navTransactions => 'Miamala';

  @override
  String get settingsRegionalTitle => 'Mipangilio ya Eneo';

  @override
  String get settingsSectionCurrency => 'SARAFU';

  @override
  String get settingsSectionDisplayFormat => 'MUUNDO WA KUONYESHA';

  @override
  String get settingsSectionLanguage => 'LUGHA';

  @override
  String get settingsDefaultCurrency => 'Sarafu Chaguomsingi';

  @override
  String get settingsExchangeRates => 'Viwango vya Ubadilishaji';

  @override
  String get settingsExchangeRatesSubtitle =>
      'Dhibiti viwango vya kubadilisha sarafu';

  @override
  String get settingsDateFormat => 'Muundo wa Tarehe';

  @override
  String get settingsNumberFormat => 'Muundo wa Namba';

  @override
  String get settingsCurrencySymbol => 'Alama ya Sarafu';

  @override
  String get settingsTimeFormat => 'Muundo wa Saa';

  @override
  String get settingsFirstDayOfWeek => 'Siku ya Kwanza ya Wiki';

  @override
  String get settingsLanguage => 'Lugha';

  @override
  String get settingsPreview => 'Onyesho la Awali';

  @override
  String get previewDate => 'Tarehe';

  @override
  String get previewTime => 'Saa';

  @override
  String get previewAmount => 'Kiasi';

  @override
  String get previewWeekStarts => 'Wiki hii inaanza';

  @override
  String get choiceMatchMyPhone => 'Kama simu yangu';

  @override
  String get symbolBeforeAmount => 'Kabla ya kiasi';

  @override
  String get symbolAfterAmount => 'Baada ya kiasi';

  @override
  String get time12Hour => 'Saa 12 (1:30 PM)';

  @override
  String get time24Hour => 'Saa 24 (13:30)';

  @override
  String get weekdayMonday => 'Jumatatu';

  @override
  String get weekdaySaturday => 'Jumamosi';

  @override
  String get weekdaySunday => 'Jumapili';

  @override
  String get selectDateFormat => 'Chagua Muundo wa Tarehe';

  @override
  String get selectNumberFormat => 'Chagua Muundo wa Namba';

  @override
  String get selectCurrency => 'Chagua Sarafu';

  @override
  String get themeLight => 'Mwanga';

  @override
  String get themeDark => 'Giza';

  @override
  String get languageSystem => 'Kama simu yangu';

  @override
  String get sectionAccount => 'AKAUNTI';

  @override
  String get sectionDataManagement => 'USIMAMIZI WA DATA';

  @override
  String get sectionHelpSupport => 'MSAADA';

  @override
  String get settingsAppearance => 'Mwonekano';

  @override
  String get settingsBackupRestore => 'Hifadhi na Rejesha';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Faili unayohifadhi, au nakala za kiotomatiki kwenye Google Drive';

  @override
  String get settingsImportStatement => 'Leta taarifa ya benki';

  @override
  String get settingsImportStatementSubtitle =>
      'Leta CSV kutoka benki yako, panga mara moja na ikumbukwe';

  @override
  String get settingsExportData => 'Hamisha Data';

  @override
  String get settingsRecentlyDeleted => 'Vilivyofutwa karibuni';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'Rudisha kitu kilichofutwa ndani ya siku thelathini zilizopita';

  @override
  String get themePremiumHeading => 'Mandhari za Premium';

  @override
  String get actionRetry => 'Jaribu tena';

  @override
  String get dashCreditDebt => 'Mikopo na Madeni';

  @override
  String get dashSubscriptions => 'Usajili';

  @override
  String get moneyIncome => 'Mapato';

  @override
  String get dashExpenses => 'Matumizi';

  @override
  String get dashSpendingOverview => 'Muhtasari wa Matumizi';

  @override
  String get dashBudgetProgress => 'Maendeleo ya Bajeti';

  @override
  String get actionDelete => 'Futa';

  @override
  String txDeleteManyTitle(int count) {
    return 'Futa miamala $count?';
  }

  @override
  String get txDeleteManyBody =>
      'Salio litahesabiwa upya. Uhamisho wowote kati yake utaondoka pamoja na upande wake mwingine.';

  @override
  String get txMoveToAccount => 'Hamishia akaunti';

  @override
  String get txDeleted => 'Muamala umefutwa';

  @override
  String txDeleteFailed(String error) {
    return 'Imeshindwa kufuta muamala huo: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count zimechaguliwa';
  }

  @override
  String get txActions => 'Vitendo';

  @override
  String get txChangeCategory => 'Badilisha kundi';

  @override
  String get txChangeDate => 'Badilisha tarehe';

  @override
  String get txMarkAsPaid => 'Weka kama imelipwa';

  @override
  String get txMarkAsCorrection => 'Weka kama marekebisho ya salio';

  @override
  String get txMarkAsCorrectionTitle => 'Si mapato wala matumizi?';

  @override
  String get txMarkAsCorrectionBody =>
      'Tumia hii kwa pesa ambayo haikupatwa wala kutumika, kama kikomo cha kadi kuongezeka. Salio linabaki vilevile; linaacha tu kuhesabiwa kama mapato au matumizi.';

  @override
  String get txMarkedAsCorrection => 'Sasa ni marekebisho ya salio.';

  @override
  String get txMarkAsCorrectionFailed => 'Huu hauwezi kuwa marekebisho.';

  @override
  String get txDuplicate => 'Nakili';

  @override
  String get filterTitle => 'Chuja';

  @override
  String get filterDirection => 'Mwelekeo';

  @override
  String get filterState => 'Hali';

  @override
  String get filterKind => 'Aina';

  @override
  String get filterTransfers => 'Uhamisho';

  @override
  String get filterAccounts => 'Akaunti';

  @override
  String get filterCategories => 'Makundi';

  @override
  String get filterDates => 'Tarehe';

  @override
  String get filterBudget => 'Bajeti';

  @override
  String get filterGoal => 'Lengo';

  @override
  String get filterNone => 'Hakuna';

  @override
  String get filterThisMonth => 'Mwezi huu';

  @override
  String get filterLastMonth => 'Mwezi uliopita';

  @override
  String get filterLast3Months => 'Miezi 3 iliyopita';

  @override
  String get filterThisYear => 'Mwaka huu';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Onyesha miamala $count',
      one: 'Onyesha muamala 1',
      zero: 'Hakuna muamala unaolingana',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Futa';

  @override
  String get filterNoMatches => 'Hakuna vinavyolingana';

  @override
  String get filterAny => 'Yoyote';

  @override
  String get filterSpent => 'Imetumika';

  @override
  String get filterEarned => 'Imepatikana';

  @override
  String get filterHidden => 'Imefichwa';

  @override
  String get filterIncluded => 'Imejumuishwa';

  @override
  String get filterOnly => 'Pekee';

  @override
  String get filterFrom => 'Kuanzia';

  @override
  String get filterTo => 'Hadi';

  @override
  String get actionApply => 'Tumia';

  @override
  String get filterPaid => 'Imelipwa';

  @override
  String get filterNotYet => 'Bado';

  @override
  String get filterSkipped => 'Imerukwa';

  @override
  String get filterAmount => 'Kiasi';

  @override
  String get actionEdit => 'Hariri';

  @override
  String get entityBudget => 'Bajeti';

  @override
  String get budgetGone => 'Bajeti hii haipo tena.';

  @override
  String get budgetEarlier => 'Awali';

  @override
  String get budgetLater => 'Baadaye';

  @override
  String get budgetWhereItWent => 'Pesa zilikoenda';

  @override
  String get budgetRecentPeriods => 'Vipindi vya karibuni';

  @override
  String get budgetCaps => 'Vikomo';

  @override
  String get actionAdd => 'Ongeza';

  @override
  String get budgetNoCategoriesToCap =>
      'Bajeti hii bado haina makundi ya kuwekea kikomo.';

  @override
  String get budgetCapACategory => 'Wekea kundi kikomo';

  @override
  String get entityCategory => 'Kundi';

  @override
  String get budgetAsShare => 'Kama sehemu ya bajeti';

  @override
  String get budgetAsShareHint => 'Hubadilika pamoja na bajeti unapoibadilisha';

  @override
  String get actionSet => 'Weka';

  @override
  String get budgetAcrossPeriod => 'Katika kipindi chote';

  @override
  String get budgetPreviousPeriod => 'Kipindi kilichopita';

  @override
  String get budgetEvenPace => 'Kasi sawa';

  @override
  String get budgetNew => 'Bajeti mpya';

  @override
  String get budgetCreate => 'Unda bajeti';

  @override
  String budgetDeleteTitle(String name) {
    return 'Futa $name?';
  }

  @override
  String get entityAccount => 'Akaunti';

  @override
  String get entityTransaction => 'Muamala';

  @override
  String get walletGone => 'Akaunti hii haipo tena.';

  @override
  String get walletCorrectBalance => 'Rekebisha salio';

  @override
  String get walletCorrectBalanceSubtitle => 'Rekodi tofauti na kiasi halisi';

  @override
  String get walletMergeInto => 'Unganisha na akaunti nyingine';

  @override
  String get walletInThisMonth => 'Ingizo mwezi huu';

  @override
  String get walletOutThisMonth => 'Toleo mwezi huu';

  @override
  String get walletRecentActivity => 'Shughuli za karibuni';

  @override
  String get walletNoOtherAccount => 'Hakuna akaunti nyingine ya kuunganisha.';

  @override
  String get walletMergeIntoTitle => 'Unganisha na';

  @override
  String get walletMergeAction => 'Unganisha';

  @override
  String walletMerged(int count, String target) {
    return '$count zimehamishiwa $target.';
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
      other: 'Uhamisho $removed kati ya akaunti hizi mbili umeondolewa',
      one: 'Uhamisho mmoja kati ya akaunti hizi mbili umeondolewa',
    );
    return '$count zimehamishiwa $target. $_temp0, kwa kuwa haukuwa tena na pande mbili.';
  }

  @override
  String get walletRealBalance => 'Salio halisi';

  @override
  String get walletCorrectAction => 'Rekebisha';

  @override
  String get txGone => 'Muamala huu haupo tena.';

  @override
  String get txKind => 'Aina';

  @override
  String get txState => 'Hali';

  @override
  String get txWasDue => 'Ulipaswa kulipwa';

  @override
  String get txNotes => 'Maelezo';

  @override
  String get txDeleteOneTitle => 'Futa muamala huu?';

  @override
  String get rulesTitle => 'Kanuni za majina';

  @override
  String get rulesAdd => 'Ongeza kanuni';

  @override
  String rulesRemoved(String title) {
    return 'Kanuni ya $title imeondolewa';
  }

  @override
  String get rulesWhenTitleSays => 'Kichwa kikisema';

  @override
  String get rulesMatchExactly => 'Linganisha kikamilifu';

  @override
  String get rulesChooseCategory => 'Chagua kundi';

  @override
  String get actionSave => 'Hifadhi';

  @override
  String get goalNew => 'Lengo jipya';

  @override
  String get goalLoadFailed => 'Imeshindwa kupakia malengo yako.';

  @override
  String get goalCreate => 'Unda lengo';

  @override
  String get trashTitle => 'Vilivyofutwa karibuni';

  @override
  String get trashRestore => 'Rejesha';

  @override
  String get trashRestored => 'Imerejeshwa.';

  @override
  String get payTitle => 'Njia za malipo';

  @override
  String get payDefault => 'Chaguomsingi';

  @override
  String get payAddOne => 'Ongeza moja';

  @override
  String payDeleteTitle(String name) {
    return 'Futa $name?';
  }

  @override
  String get payName => 'Jina';

  @override
  String get payNameHint => 'Debit ya kila siku';

  @override
  String get payKind => 'Aina';

  @override
  String get payBankOrIssuer => 'Benki au mtoaji';

  @override
  String get payLastFour => 'Tarakimu nne za mwisho';

  @override
  String get payUseByDefault => 'Tumia kama chaguomsingi';

  @override
  String get backupChecking => 'Inakagua…';

  @override
  String get backupLoading => 'Inapakia…';

  @override
  String get backupSaveACopy => 'Hifadhi nakala';

  @override
  String get backupAutomaticBackups => 'Nakala za kiotomatiki';

  @override
  String get backupHowManyBackupsToKeep => 'Idadi ya nakala za kuhifadhi';

  @override
  String get backupSaveABackupFile => 'Hifadhi faili ya nakala';

  @override
  String get backupShareItToFilesEmail =>
      'Ishiriki kwenye Files, barua pepe, au popote upendapo';

  @override
  String get backupRestoreFromAFile => 'Rejesha kutoka faili';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Inabadilisha kila kitu kilichopo kwenye kifaa hiki';

  @override
  String get backupRestoreThisBackup => 'Rejesha nakala hii?';

  @override
  String get backupEraseRestore => 'Futa na Rejesha';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive haipatikani';

  @override
  String get backupConnectGoogleDrive => 'Unganisha Google Drive';

  @override
  String get backupBackUpNow => 'Hifadhi sasa';

  @override
  String get backupKeep => 'Hifadhi';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'Nakala ya kiotomatiki iliyopita haikufanyika';

  @override
  String get backupDisconnectGoogleDrive => 'Tenganisha Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'Tenganisha Google Drive?';

  @override
  String get backupDisconnect => 'Tenganisha';

  @override
  String get backupDeleteThisBackup => 'Futa nakala hii?';

  @override
  String get importChooseACsvFile => 'Chagua faili ya CSV';

  @override
  String get importRememberTheseSettingsForThis =>
      'Kumbuka mipangilio hii kwa benki hii';

  @override
  String get importChange => 'Badilisha';

  @override
  String get importAuto => 'Otomatiki';

  @override
  String get importDone => 'Imekamilika';

  @override
  String get importRememberThisBank => 'Kumbuka benki hii';

  @override
  String get importForget => 'Sahau';

  @override
  String get importImport => 'Leta';

  @override
  String get settingsAbout => 'Kuhusu';

  @override
  String get settingsPrivacyPolicy => 'Sera ya Faragha';

  @override
  String get settingsTermsOfService => 'Masharti ya Huduma';

  @override
  String get settingsRefundPolicy => 'Sera ya Kurejesha Pesa';

  @override
  String get settingsOpenSourceLicenses => 'Leseni za Open Source';

  @override
  String get settingsMeetTheDeveloper => 'Mfahamu Msanidi';

  @override
  String get settingsContactSupport => 'Wasiliana na Msaada';

  @override
  String get settingsSubject => 'Mada';

  @override
  String get settingsMessage => 'Ujumbe';

  @override
  String get settingsSendMessage => 'Tuma ujumbe';

  @override
  String get settingsUseApiRate => 'Tumia Kiwango cha API';

  @override
  String get settingsRefreshRates => 'Sasisha viwango';

  @override
  String get settingsSearchCurrencies => 'Tafuta sarafu...';

  @override
  String get settingsCustomRate => 'Kiwango maalum';

  @override
  String get settingsSetCustomRate => 'Weka kiwango maalum';

  @override
  String get settingsNotNow => 'Si sasa';

  @override
  String get settingsGoPremium => 'Pata Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Muundo wa jedwali kwa Excel, Google Sheets';

  @override
  String get settingsPdfReport => 'Ripoti ya PDF';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Muhtasari uliopangwa wenye uchanganuzi';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'Rekodi zote za mapato na matumizi';

  @override
  String get settingsCategories => 'Makundi';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Uchanganuzi wa makundi na jumla';

  @override
  String get settingsWallets => 'Pochi';

  @override
  String get settingsWalletBalancesAndHistory => 'Salio la pochi na historia';

  @override
  String get settingsHelpFaq => 'Msaada na Maswali';

  @override
  String get settingsNotifications => 'Arifa';

  @override
  String get settingsLargeTransactionThreshold => 'Kiwango cha Muamala Mkubwa';

  @override
  String get settingsRemindMeBeforeDueDate =>
      'Nikumbushe Kabla ya Tarehe ya Malipo';

  @override
  String get settingsDailyReminders => 'VIKUMBUSHO VYA KILA SIKU';

  @override
  String get settingsDailyReminders2 => 'Vikumbusho vya Kila Siku';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Kumbushwa kurekodi matumizi yako';

  @override
  String get settingsBudgetAlerts => 'ARIFA ZA BAJETI';

  @override
  String get settingsBudgetAlerts2 => 'Arifa za Bajeti';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'Arifu ukikaribia kikomo cha bajeti';

  @override
  String get settingsWarningThreshold => 'Kiwango cha Onyo';

  @override
  String get settingsTransactionAlerts => 'ARIFA ZA MIAMALA';

  @override
  String get settingsLargeTransactionAlerts => 'Arifa za Miamala Mikubwa';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'Arifu kwa miamala inayozidi kiwango';

  @override
  String get settingsRecurringTransactionReminders =>
      'Vikumbusho vya Miamala ya Kujirudia';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'Kumbusha kuhusu malipo yanayojirudia yanayokuja';

  @override
  String get settingsOtherNotifications => 'ARIFA NYINGINE';

  @override
  String get settingsSubscriptionExpiryAlerts => 'Arifa za Kuisha kwa Usajili';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Pata arifa kabla Premium yako haijaisha';

  @override
  String get settingsPromotionalNotifications => 'Arifa za Matangazo';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Pokea ofa na habari za vipengele vipya';

  @override
  String get settingsTurnOnDailyReminders => 'Washa vikumbusho vya kila siku?';

  @override
  String get settingsEnterAmount => 'Weka kiasi';

  @override
  String get settingsReminderTime => 'Muda wa Kikumbusho';

  @override
  String get settingsPrivacySecurity => 'Faragha na Usalama';

  @override
  String get settingsSecurity => 'USALAMA';

  @override
  String get settingsBiometricLock => 'Kufuli ya Bayometriki';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Tumia alama ya kidole au uso kufungua';

  @override
  String get settingsAutoLock => 'Funga kiotomatiki';

  @override
  String get settingsDataPrivacy => 'FARAGHA YA DATA';

  @override
  String get settingsClearCache => 'Futa Akiba';

  @override
  String get settingsClearCachedDataAndForce =>
      'Futa data ya akiba na lazimisha kusawazisha upya';

  @override
  String get settingsClearAllData => 'Futa Data Yote';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Futa miamala, bajeti na mipangilio yote';

  @override
  String get settingsDangerZone => 'ENEO LA HATARI';

  @override
  String get settingsDeleteAccount => 'Futa Akaunti';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Futa kabisa akaunti yako na data yote';

  @override
  String get settingsAutoLockTimeout => 'Muda wa Kufunga Kiotomatiki';

  @override
  String get settingsDeleteEverything => 'Futa Kila Kitu';

  @override
  String get settingsAreYouAbsolutelySure => 'Una uhakika kabisa?';

  @override
  String get settingsYesDeleteAll => 'Ndiyo, Futa Zote';

  @override
  String get settingsContinue => 'Endelea';

  @override
  String get settingsEditProfile => 'Hariri Wasifu';

  @override
  String get settingsDisplayName => 'Jina la kuonyesha';

  @override
  String get settingsEmailAddress => 'Barua pepe';

  @override
  String get settingsUnsavedChanges => 'Mabadiliko Hayajahifadhiwa';

  @override
  String get settingsStay => 'Baki';

  @override
  String get settingsLeave => 'Ondoka';

  @override
  String get settingsSearchByCodeOrName => 'Tafuta kwa msimbo au jina...';

  @override
  String get settingsSearchSettings => 'Tafuta mipangilio...';

  @override
  String get settingsSubscription => 'Usajili';

  @override
  String get settingsSignOut => 'Toka';

  @override
  String get settingsGoals => 'Malengo';

  @override
  String get settingsCardsInNetWorth =>
      'Hesabu kadi za mkopo kwenye utajiri halisi';

  @override
  String get settingsCardsInNetWorthSub =>
      'Imezimwa: pesa ulizonazo pekee ndizo huhesabiwa, si salio la kadi.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Weka akiba kwa ajili ya kitu na fuatilia umefika wapi';

  @override
  String get settingsBudgets => 'Bajeti';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Weka vikomo na uone kipindi kinavyokwenda';

  @override
  String get settingsUpcomingAndOverdue => 'Yanayokuja na yaliyochelewa';

  @override
  String get settingsWhatIsDueAndWhat =>
      'Kinachopaswa kulipwa, na kilichokosekana';

  @override
  String get settingsAccounts => 'Akaunti';

  @override
  String get settingsAddReorderAndEditYour =>
      'Ongeza, panga upya na hariri akaunti zako';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'Kadi na akaunti unazolipia nazo';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Kitu kinapoenda, kulingana na jina lake';

  @override
  String get settingsNotificationSettings => 'Mipangilio ya Arifa';

  @override
  String get settingsCloudSync => 'Usawazishaji wa Wingu';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Sawazisha data yako kwenye vifaa vyote';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV ni bure · Ripoti ya PDF ni Premium';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Maswali, malalamiko au maoni';

  @override
  String get settingsRateTheApp => 'Kadiria Programu';

  @override
  String get settingsShareWithFriends => 'Shiriki na Marafiki';

  @override
  String get settingsReplayAppTour => 'Rudia Ziara ya Programu';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'Ona tena maelezo ya vipengele';

  @override
  String get settingsAboutTheAccountant => 'Kuhusu The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Toleo, leseni na zaidi';

  @override
  String get settingsTestCrash => 'Jaribu Hitilafu';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Sababisha hitilafu ya majaribio kwa Crashlytics';

  @override
  String get settingsDeveloper => 'MSANIDI';

  @override
  String get settingsRestoreFromCloud => 'Rejesha kutoka Wingu?';

  @override
  String get settingsSyncing => 'Inasawazisha...';

  @override
  String get settingsSynced => 'Imesawazishwa';

  @override
  String get settingsSyncError => 'Hitilafu ya Usawazishaji';

  @override
  String get syncBackgroundFailed =>
      'Imeshindwa kusawazisha. Mabadiliko yako yako salama kwenye kifaa hiki na yatasawazishwa baadaye.';

  @override
  String get settingsOffline => 'Nje ya mtandao';

  @override
  String get settingsReady => 'Tayari';

  @override
  String get settingsYesUseThis => 'Ndiyo, tumia hii';

  @override
  String get settingsKeepThemSeparate => 'Ziweke tofauti?';

  @override
  String get settingsCurrentPassword => 'Nenosiri la Sasa';

  @override
  String get settingsNewPassword => 'Nenosiri Jipya';

  @override
  String get settingsConfirmPassword => 'Thibitisha Nenosiri';

  @override
  String get walletEGPersonalSavingsBusiness => 'mf., Binafsi, Akiba, Biashara';

  @override
  String get walletEnterCreditLimit => 'Weka kikomo cha mkopo';

  @override
  String get walletSelectBillingDay => 'Chagua siku ya bili';

  @override
  String get walletCreateAccount => 'Unda Akaunti';

  @override
  String get walletWalletCreatedSuccessfully => 'Pochi imeundwa';

  @override
  String get walletAccountUpdatedSuccessfully => 'Akaunti imesasishwa';

  @override
  String get walletEditAccount => 'Hariri Akaunti';

  @override
  String get walletSetAsDefault => 'Weka kama Chaguomsingi';

  @override
  String get walletUseDecimals => 'Tumia Desimali';

  @override
  String get walletEnterWalletName => 'Weka jina la pochi';

  @override
  String get walletCurrency => 'Sarafu';

  @override
  String get walletIcon => 'Ikoni';

  @override
  String get walletColor => 'Rangi';

  @override
  String get walletWalletName => 'Jina la Pochi';

  @override
  String get walletInitialBalance => 'Salio la Mwanzo';

  @override
  String get txAddATransferFee => 'Ongeza ada ya uhamisho';

  @override
  String get txRemove => 'Ondoa';

  @override
  String get txPaymentMethod => 'Njia ya Malipo';

  @override
  String get txObjective => 'Lengo';

  @override
  String get txTitle => 'Kichwa';

  @override
  String get txTesco => 'Naivas';

  @override
  String get txAll => 'Zote';

  @override
  String get txSkip => 'Ruka';

  @override
  String get txMarkAsPaid2 => 'Weka kama Imelipwa';

  @override
  String get txConfirmPayment => 'Thibitisha malipo';

  @override
  String get txAmountCharged => 'Kiasi kilichotozwa';

  @override
  String get txUndo => 'Tendua';

  @override
  String get txNoLoan => 'Hakuna mkopo';

  @override
  String get txLentMoney => 'Pesa Nilizokopesha';

  @override
  String get txBorrowedMoney => 'Pesa Nilizokopa';

  @override
  String get goalShowOnTheHomeScreen => 'Onyesha kwenye skrini ya mwanzo';

  @override
  String get goalWhatAreYouSavingFor => 'Unawekea akiba nini?';

  @override
  String get goalNewLaptop => 'Laptop mpya';

  @override
  String get goalTarget => 'Lengo';

  @override
  String get goalColour => 'Rangi';

  @override
  String get goalClear => 'Futa';

  @override
  String get goalGoal => 'Lengo';

  @override
  String get goalThisGoalNoLongerExists => 'Lengo hili halipo tena.';

  @override
  String get goalAddToGoal => 'Ongeza kwenye lengo';

  @override
  String get goalUnlink => 'Tenganisha';

  @override
  String get reportUpgrade => 'Pandisha daraja';

  @override
  String get budgetSpending => 'Matumizi';

  @override
  String get budgetEarnings => 'Mapato';

  @override
  String get budgetEvery => 'Kila';

  @override
  String get budgetCarryOverWhatIsLeft => 'Hamisha kilichobaki kipindi kijacho';

  @override
  String get budgetGroceries => 'Mahitaji ya nyumbani';

  @override
  String get authLinkYourAccount => 'Unganisha Akaunti Yako';

  @override
  String get authPassword => 'Nenosiri';

  @override
  String get authLinkAccount => 'Unganisha Akaunti';

  @override
  String get authEmailAddress => 'Barua Pepe';

  @override
  String get authSendResetCode => 'Tuma Msimbo wa Kuweka Upya';

  @override
  String get authResetCode => 'Msimbo wa Kuweka Upya';

  @override
  String get authResetPassword => 'Weka Upya Nenosiri';

  @override
  String get authWelcomeBack => 'Karibu Tena';

  @override
  String get authSignInToContinueYour =>
      'Ingia ili kuendelea na safari yako ya kifedha';

  @override
  String get authSignIn => 'Ingia';

  @override
  String get authJoinUsToStartYour =>
      'Jiunge nasi kuanza safari yako ya kifedha';

  @override
  String get authFullName => 'Jina Kamili';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Kila Mwezi';

  @override
  String get premiumYearly => 'Kila Mwaka';

  @override
  String get premiumLifetime => 'Maisha Yote';

  @override
  String get premiumNotNow => 'Si Sasa';

  @override
  String get aiRename => 'Badilisha jina';

  @override
  String get aiRenameChat => 'Badilisha jina la gumzo';

  @override
  String get aiDeleteChat => 'Futa gumzo?';

  @override
  String get aiChatName => 'Jina la gumzo';

  @override
  String get aiScanReceipt => 'Changanua Risiti';

  @override
  String get aiCamera => 'Kamera';

  @override
  String get aiGallery => 'Matunzio';

  @override
  String get aiMerchantTitle => 'Mfanyabiashara / kichwa';

  @override
  String get aiSaveAsTransaction => 'Hifadhi kama muamala';

  @override
  String get onboardBrowseThemes => 'Vinjari mandhari';

  @override
  String get onboardBack => 'Rudi';

  @override
  String get onboardGetStarted => 'Anza';

  @override
  String get onboardMainAccount => 'Akaunti Kuu';

  @override
  String get creditRecordPayment => 'Rekodi Malipo';

  @override
  String get creditPleaseEnterAValidAmount => 'Tafadhali weka kiasi sahihi';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'Kiasi kinazidi salio lililobaki';

  @override
  String get creditPaymentAmount => 'Kiasi cha Malipo';

  @override
  String get creditPaidOn => 'Ililipwa tarehe';

  @override
  String get creditFullAmount => 'Kiasi chote';

  @override
  String get subSubscriptionName => 'Jina la usajili';

  @override
  String get subAskBeforeEachPayment => 'Uliza kabla ya kurekodi kila malipo';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Kila malipo yanasubiri kwenye Yanayokuja hadi uthibitishe kilichotozwa, au uyaruke. Bora kwa malipo yanayobadilika, kama kadi inayolipwa kwa sarafu nyingine.';

  @override
  String get subChangesApplyFromNext =>
      'Kiasi kipya au akaunti mpya itatumika kuanzia malipo yajayo. Malipo yaliyokwisha fanyika yanabaki kama yalivyo.';

  @override
  String get catPleaseEnterACategoryName => 'Tafadhali weka jina la kundi';

  @override
  String get catEnterCategoryName => 'Weka jina la kundi';

  @override
  String get catSearch => 'Tafuta makundi';

  @override
  String get catNoMatch => 'Hakuna kundi linalolingana.';

  @override
  String get catUseEmoji => 'Tumia emoji';

  @override
  String get catEmojiHint => 'Andika au chagua emoji moja';

  @override
  String get catArchive => 'Hifadhi kumbukumbu';

  @override
  String get catMergeInto => 'Unganisha na…';

  @override
  String catMergeIntoTitle(String name) {
    return 'Unganisha $name na';
  }

  @override
  String get catMergeBuiltIn => 'Iliyojengwa ndani';

  @override
  String get catMergeNoTargets =>
      'Hakuna kundi lingine la aina hiyo la kuunganisha.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return 'Unganisha $from na $to?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Kila muamala, bajeti na kundi dogo katika $from litahamia $to, na $from litaondolewa. Hii itasawazishwa kwenye vifaa vyako vingine.';
  }

  @override
  String get catMergeAction => 'Unganisha';

  @override
  String catMerged(String from, String to) {
    return '$from imeunganishwa na $to.';
  }

  @override
  String get catExpenseSection => 'Makundi ya matumizi';

  @override
  String get catIncomeSection => 'Makundi ya mapato';

  @override
  String get catSectionEmpty => 'Bado hakuna';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Makundi madogo $count',
      one: 'Kundi dogo 1',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count',
      one: 'Muamala 1',
      zero: 'Hakuna miamala',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'Ndani ya $name';
  }

  @override
  String get catAddSubcategory => 'Ongeza kundi dogo';

  @override
  String get catNoSubcategoriesYet => 'Bado hakuna makundi madogo. Ongeza moja';

  @override
  String get catMoveTo => 'Hamishia…';

  @override
  String catMoveToTitle(String name) {
    return 'Hamisha $name kwenda';
  }

  @override
  String get catTopLevel => 'Ngazi ya juu';

  @override
  String get catTopLevelHint => 'Haiko ndani ya kundi lolote';

  @override
  String catMovedInto(String name, String parent) {
    return '$name sasa iko ndani ya $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name sasa ni kundi la ngazi ya juu.';
  }

  @override
  String get catMoveNoParents => 'Hakuna kundi linaloweza kuliweka ndani.';

  @override
  String get catMoveTransactions => 'Hamisha miamala…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Hamisha miamala ya $name kwenda';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hamisha miamala $count kwenda $to?',
      one: 'Hamisha muamala 1 kwenda $to?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Miamala pekee ndiyo itahamishwa. $from litabaki, pamoja na bajeti na makundi yake madogo. Hii itasawazishwa kwenye vifaa vyako vingine.';
  }

  @override
  String get catMoveAction => 'Hamisha';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count imehamishiwa $to.',
      one: 'Muamala 1 umehamishiwa $to.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name haina miamala ya kuhamisha.';
  }

  @override
  String get catNoMoveTargets =>
      'Hakuna kundi lingine la aina hiyo la kuihamishia.';

  @override
  String catDeleteTitle(String name) {
    return 'Futa $name?';
  }

  @override
  String get catDeleteEmptyBody =>
      'Halina miamala, kwa hiyo hakuna kingine kinachobadilika.';

  @override
  String get catDeleteChildrenNote =>
      'Makundi yake madogo yatahamia ngazi ya juu.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count imewekwa chini yake. Ifanyiwe nini?',
      one: 'Muamala 1 umewekwa chini yake. Ufanyiwe nini?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'Hamishia kundi lingine';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Kisha $name litafutwa. Bajeti zilizolitumia zitahamia pia.';
  }

  @override
  String get catDeleteThemToo => 'Futa miamala pia';

  @override
  String get catDeleteThemTooHint =>
      'Itaenda kwenye Vilivyofutwa karibuni, ambapo unaweza kuirejesha ndani ya siku 30.';

  @override
  String catDeleted(String name) {
    return '$name imefutwa.';
  }

  @override
  String get catActionFailed => 'Imeshindikana. Jaribu tena.';

  @override
  String get catStaysTopLevel =>
      'Kundi hili lina makundi yake madogo, kwa hiyo linabaki ngazi ya juu.';

  @override
  String get catUnarchive => 'Rudisha kutoka kumbukumbu';

  @override
  String get catArchivedSection => 'Kumbukumbu';

  @override
  String get catArchivedHint =>
      'Yanahifadhiwa kwa historia, lakini hayaonyeshwi unapoongeza muamala.';

  @override
  String get catNothingItsOwnCategory => 'Hakuna — ni kundi lake lenyewe';

  @override
  String get notifEnableNotifications => 'Washa Arifa';

  @override
  String get startupContinueWithoutChecking => 'Endelea bila kukagua?';

  @override
  String get startupContinueOffline => 'Endelea nje ya mtandao';

  @override
  String get startupViewSubscriptionOptions => 'Ona chaguo za usajili';

  @override
  String get sharedWelcomeBack => 'Karibu tena';

  @override
  String get sharedRestoringYourDataFromThe =>
      'Inarejesha data yako kutoka wingu…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return 'Unganisha $source na $target?';
  }

  @override
  String get backupNothingHereYet => 'Bado hakuna kitu hapa.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Inatumika kiotomatiki faili ikiwa na safu hizi';

  @override
  String get importDateFormat => 'Muundo wa tarehe';

  @override
  String get importChooseOne => 'Chagua moja';

  @override
  String get importDecimalPoint => 'Nukta ya desimali';

  @override
  String get importFlipTheSigns => 'Geuza alama';

  @override
  String get importForExportsThatWriteA =>
      'Kwa faili zinazoandika matumizi kama chanya';

  @override
  String get importWhereRowsGoWhenThe =>
      'Safu zinapoenda faili isipotaja akaunti yako';

  @override
  String get importSkipWhatIsAlreadyHere => 'Ruka kilichopo tayari';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Unda makundi yaliyotajwa kwenye faili';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Vinginevyo safu hizo zitaingia bila kundi';

  @override
  String get importCategoriesInThisFile => 'Makundi katika faili hii';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Imetengenezwa kwa upendo kwa fedha binafsi';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'Imetengenezwa na Kusimamiwa na:';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Funga';

  @override
  String get settingsGetInTouch => 'Wasiliana nasi';

  @override
  String get settingsAsAPremiumMemberYour =>
      'Kama mwanachama wa Premium, ombi lako linapewa kipaumbele.';

  @override
  String get settingsWhatToInclude => 'Cha kujumuisha';

  @override
  String get settingsNoCurrenciesFound => 'Hakuna sarafu iliyopatikana';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Hamisha data yako ya fedha ili kuichambua kwenye programu nyingine au kuiweka kama nakala.';

  @override
  String get settingsDateRange => 'Kipindi cha Tarehe';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'Ripoti za PDF';

  @override
  String get settingsGettingStarted => 'Kuanza';

  @override
  String get settingsStillNeedHelp => 'Bado unahitaji msaada?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'Timu yetu ya msaada iko hapa kukusaidia';

  @override
  String get settingsAppLocked => 'Programu Imefungwa';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Fungua ili kutumia The Accountant';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Weka lini na jinsi The Accountant inavyokukumbusha kurekodi matumizi yako.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'Barua pepe yako hutumika kuingia na haiwezi kubadilishwa hapa.';

  @override
  String get settingsYourDataIsOnThis =>
      'Data yako iko kwenye kifaa hiki pekee';

  @override
  String get settingsUpgradeForCloudSync =>
      'Pandisha daraja kwa usawazishaji wa wingu';

  @override
  String get settingsNoSettingsFound => 'Hakuna mipangilio iliyopatikana';

  @override
  String get settingsTryADifferentSearchTerm =>
      'Jaribu neno lingine la kutafuta';

  @override
  String get settingsSyncStatus => 'HALI YA USAWAZISHAJI';

  @override
  String get settingsSyncNow => 'Sawazisha Sasa';

  @override
  String get settingsRestoreFromCloud2 => 'Rejesha kutoka Wingu';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'INAHITAJI UTHIBITISHO WAKO';

  @override
  String get walletCreateYourFirstAccount => 'Unda Akaunti Yako ya Kwanza';

  @override
  String get walletYouNeedAtLeastOne =>
      'Unahitaji angalau akaunti moja kuanza kufuatilia fedha zako';

  @override
  String get walletAccountType => 'Aina ya Akaunti';

  @override
  String get walletAccountName => 'Jina la Akaunti';

  @override
  String get walletCreditLimit => 'Kikomo cha Mkopo';

  @override
  String get walletCreditLimitHelp =>
      'Kikomo kimeongezeka? Kibadilishe hapa. Kikomo kipya si mapato.';

  @override
  String get walletAmountOwed => 'Kiasi unachodaiwa';

  @override
  String get walletAmountOwedHelp =>
      'Unachodaiwa kwenye kadi sasa hivi. Weka 0 kama umelipa yote.';

  @override
  String get walletCurrentBalance => 'Salio la sasa';

  @override
  String get walletCurrentBalanceHelp =>
      'Badiliko huhifadhiwa kama marekebisho ya salio, ili historia yako ilingane.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return '$amount kwenye kadi hii ni nini?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Mkopo uliobaki';

  @override
  String get walletCardBalanceOwed => 'Ninachodaiwa';

  @override
  String get walletCardBalanceChoose =>
      'Chagua kiasi hiki ni nini, ili deni lihesabiwe sawasawa.';

  @override
  String get walletBillingCycleDayOptional =>
      'Siku ya Mzunguko wa Bili (si lazima)';

  @override
  String get walletThisWillBeYourDefault =>
      'Hii itakuwa akaunti yako chaguomsingi';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Bado hakuna kilichorekodiwa kwenye akaunti hii.';

  @override
  String get walletAddAccount => 'Ongeza Akaunti';

  @override
  String get walletYourAccounts => 'Akaunti Zako';

  @override
  String get walletNoAccountsYet => 'Bado hakuna akaunti';

  @override
  String get walletOutstanding => 'Deni lililobaki';

  @override
  String get walletAvailable => 'Inapatikana';

  @override
  String get walletLimit => 'Kikomo';

  @override
  String get walletBalance => 'Salio';

  @override
  String get walletUseThisWalletForNew => 'Tumia pochi hii kwa miamala mipya';

  @override
  String get walletSelectIcon => 'Chagua Ikoni';

  @override
  String get walletSelectColor => 'Chagua Rangi';

  @override
  String get txYouNeedAtLeast2 =>
      'Unahitaji angalau akaunti 2 kufanya uhamisho';

  @override
  String get txNoAccountTitle => 'Hakuna akaunti ya kurekodi hili';

  @override
  String get txNoAccountBody =>
      'Ongeza akaunti, au fungua upya iliyofungwa, na fomu hii itakuwa tayari kutumika.';

  @override
  String get txNoAccountAction => 'Dhibiti akaunti';

  @override
  String get txDeleteTransaction => 'Futa Muamala';

  @override
  String get txAreYouSureYouWant => 'Una uhakika unataka kufuta muamala huu?';

  @override
  String get txTransactionType => 'Aina ya Muamala';

  @override
  String get txTransferFee => 'Ada ya uhamisho';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Inatozwa tofauti, ili uhamisho wenyewe ubaki sawa.';

  @override
  String get txDeductedFrom => 'Imekatwa kutoka';

  @override
  String get txNoPaymentMethods => 'Hakuna njia za malipo';

  @override
  String get txNothingDeletedRecently => 'Hakuna kilichofutwa karibuni';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Chochote unachofuta kinaonekana hapa kwa siku thelathini.';

  @override
  String get txNoRulesYet => 'Bado hakuna kanuni';

  @override
  String get txClearAll => 'Futa Zote';

  @override
  String get txApplyFilters => 'Tumia Vichujio';

  @override
  String get txUpcomingOverdue => 'Yanayokuja na Yaliyochelewa';

  @override
  String get txNew => 'Mpya';

  @override
  String get txLoan => 'Mkopo';

  @override
  String get goalStarted => 'Ilianza';

  @override
  String get goalTargetDate => 'Tarehe ya lengo';

  @override
  String get goalWithADateTheGoal =>
      'Ukiweka tarehe, lengo litakokotoa kiasi cha kuweka kando kila siku.';

  @override
  String get goalCountedTowardThisGoal => 'Kimehesabiwa kwenye lengo hili';

  @override
  String get goalGettingThere => 'Unakaribia';

  @override
  String get goalSetATargetDateAnd =>
      'Weka tarehe ya lengo na hii itakokotoa kiasi cha kuweka kando.';

  @override
  String get reportSpendingInsights => 'Uchambuzi wa Matumizi';

  @override
  String get reportNoSpendingDataForThis =>
      'Hakuna data ya matumizi kwa kipindi hiki';

  @override
  String get reportNoCategorySpendingData =>
      'Hakuna data ya matumizi kwa makundi';

  @override
  String get reportNoSpendingDataAvailable => 'Hakuna data ya matumizi';

  @override
  String get reportBudgetVsActual => 'Bajeti dhidi ya Halisi';

  @override
  String get reportNoActiveBudgets => 'Hakuna bajeti zinazotumika';

  @override
  String get reportCreateABudgetToTrack =>
      'Unda bajeti kufuatilia matumizi yako';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Unatumia haraka kuliko kipindi kinavyopita.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'Hakuna kilichorekodiwa katika kipindi hiki.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent kati ya $limit imetumika';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount imebaki';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount zaidi';
  }

  @override
  String get budgetPeriodEnded => 'Kipindi kimeisha';

  @override
  String get budgetPaceOver => 'Umezidi';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Siku $days zimebaki',
      one: 'Siku 1 imebaki',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Nenosiri limewekwa upya. Tafadhali ingia.';

  @override
  String get authResendCode => 'Tuma msimbo tena';

  @override
  String get authForgotPassword => 'Umesahau Nenosiri?';

  @override
  String get authOrContinueWith => 'Au endelea na';

  @override
  String get authContinueWithGoogle => 'Endelea na Google';

  @override
  String get authContinueWithApple => 'Endelea na Apple';

  @override
  String get authSignUp => 'Jisajili';

  @override
  String get authPleaseAcceptTheTermsAnd =>
      'Tafadhali kubali sheria na masharti';

  @override
  String get authPasswordStrength => 'Uimara wa Nenosiri';

  @override
  String get authAlreadyHaveAnAccount => 'Tayari una akaunti? ';

  @override
  String get authPersonalInformation => 'Taarifa Binafsi';

  @override
  String get authUpgradeToPremium => 'Pandisha hadi Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Fungua bajeti zisizo na kikomo, uchambuzi wa kina na zaidi!';

  @override
  String get authUpgradeNow => 'Pandisha Sasa';

  @override
  String get authPremiumMember => 'Mwanachama wa Premium';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'Unafurahia vipengele vyote vya Premium';

  @override
  String get authSaveChanges => 'Hifadhi Mabadiliko';

  @override
  String get authAreYouSureYouWant =>
      'Una uhakika unataka kutoka kwenye akaunti yako?';

  @override
  String get authChangeProfilePhoto => 'Badilisha Picha ya Wasifu';

  @override
  String get authTakePhoto => 'Piga Picha';

  @override
  String get authUseYourCamera => 'Tumia kamera yako';

  @override
  String get authChooseFromGallery => 'Chagua kutoka Matunzio';

  @override
  String get authSelectAnExistingPhoto => 'Chagua picha iliyopo';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Picha imechaguliwa! Kipengele cha kupakia kinakuja hivi karibuni.';

  @override
  String get authNameCannotBeEmpty => 'Jina haliwezi kuwa tupu';

  @override
  String get authProfileUpdatedSuccessfully => 'Wasifu umesasishwa!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Faragha na Masharti';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Pitia haya kabla ya kuendelea.';

  @override
  String get premiumLimitReached => 'Kikomo Kimefikiwa';

  @override
  String get aiChats => 'Gumzo';

  @override
  String get aiNewChat => 'Gumzo jipya';

  @override
  String get aiNoConversationsYet => 'Bado hakuna mazungumzo';

  @override
  String get aiStartChattingAndYourThreads =>
      'Anza kuzungumza na mazungumzo yako yataonekana hapa.';

  @override
  String get aiScanAReceipt => 'Changanua risiti';

  @override
  String get aiReadingYourReceipt => 'Inasoma risiti yako…';

  @override
  String get aiReviewSave => 'Kagua na hifadhi';

  @override
  String get aiWeReadThisFromYour =>
      'Tumesoma hii kutoka kwenye risiti yako — ikague na uhariri chochote kabla ya kuhifadhi.';

  @override
  String get dashErrorLoadingFinancialData =>
      'Hitilafu katika kupakia data ya fedha';

  @override
  String get dashNoSpendingDataYet => 'Bado hakuna data ya matumizi';

  @override
  String get dashManage => 'Dhibiti';

  @override
  String get dashAvailable => 'Inapatikana: ****';

  @override
  String get onboardWelcome => 'Karibu!';

  @override
  String get onboardSelectYourDefaultCurrency =>
      'Chagua sarafu yako chaguomsingi';

  @override
  String get onboardLoadingCurrencies => 'Inapakia sarafu...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'Weka pochi yako kuu';

  @override
  String get onboardInitialBalanceOptional => 'Salio la Mwanzo (si lazima)';

  @override
  String get onboardYourAccountIsReadyTo => 'Akaunti yako iko tayari kutumika';

  @override
  String get onboardTipYouCanAddMore =>
      'Dokezo: Unaweza kuongeza akaunti zaidi zenye sarafu tofauti wakati wowote kutoka sehemu ya Pochi.';

  @override
  String get creditSettled => 'Imelipwa';

  @override
  String get creditOverdue => 'Imechelewa';

  @override
  String creditTabCredit(int count) {
    return 'Nilizokopesha ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Nilizokopa ($count)';
  }

  @override
  String get creditNetOutstanding => 'Salio halisi la madeni';

  @override
  String get creditAllSettled => 'Yote yamelipwa';

  @override
  String get creditOthersOweYou => 'Wengine wanakudai';

  @override
  String get creditYouOweOthers => 'Unadaiwa na wengine';

  @override
  String creditOverdueCount(int count) {
    return '$count zimechelewa';
  }

  @override
  String get creditEmptyAll => 'Hakuna pesa iliyokopeshwa wala kukopwa';

  @override
  String get creditEmptyLent => 'Hakuna pesa iliyokopeshwa';

  @override
  String get creditEmptyBorrowed => 'Hakuna pesa iliyokopwa';

  @override
  String get creditEmptyAllSettled => 'Kila kitu kimelipwa.';

  @override
  String get creditEmptyHint =>
      'Ongeza pesa ulizokopesha au kukopa ili kufuatilia nani anadaiwa na nani.';

  @override
  String get creditShowAll => 'Onyesha zote';

  @override
  String get creditShowUnpaid => 'Onyesha zisizolipwa tu';

  @override
  String get creditMoneyLent => 'Pesa zilizokopeshwa';

  @override
  String get creditMoneyBorrowed => 'Pesa zilizokopwa';

  @override
  String get creditTheyOweYou => 'Wanakudai';

  @override
  String get creditYouOwe => 'Unadaiwa';

  @override
  String get creditCollected => 'Imekusanywa';

  @override
  String creditPaidOf(String paid, String total) {
    return 'Imelipwa $paid kati ya $total';
  }

  @override
  String get creditRecord => 'Rekodi';

  @override
  String get subRecurring => 'Inajirudia';

  @override
  String get subPaused => 'Imesitishwa';

  @override
  String get subAsksFirst => 'Huuliza kwanza';

  @override
  String get subFrequency => 'Marudio';

  @override
  String get notifMarkAllRead => 'Weka zote zimesomwa';

  @override
  String get notifTryAgain => 'Jaribu tena';

  @override
  String get notifStayOnTopOfYour => 'Dhibiti pesa zako vizuri';

  @override
  String get notifNoNotificationsYet => 'Bado hakuna arifa';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'Ukipokea arifa, zitaonekana hapa.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Hakuna kilichobadilishwa wala kufutwa.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Jumuisha sarafu za kidijitali';

  @override
  String get sharedTotalBalance => 'Jumla ya Salio';

  @override
  String get heatmapTitle => 'Mwenendo wa kila siku';

  @override
  String get heatmapSpentMore => 'Ulitumia zaidi';

  @override
  String get heatmapEarnedMore => 'Ulipata zaidi';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Miamala $count haijaonyeshwa: hakuna kiwango kinachojulikana kati ya sarafu za akaunti zake na $currency',
      one:
          'Muamala mmoja haujaonyeshwa: hakuna kiwango kinachojulikana kati ya sarafu ya akaunti yake na $currency',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet =>
      'Bado hakuna kilichorekodiwa katika kipindi hiki.';

  @override
  String get heatmapNetForRange => 'Jumla halisi katika kipindi hiki';

  @override
  String get layoutTitle => 'Mpangilio wa mwanzo';

  @override
  String get layoutSubtitle =>
      'Panga upya skrini ya mwanzo, au ficha usichotumia';

  @override
  String get layoutExplain =>
      'Buruta kupanga upya. Kilichozimwa kinabaki mahali pake, hivyo ukikiwasha tena kinarudi ulipokiacha.';

  @override
  String get layoutReset => 'Rudisha chaguomsingi';

  @override
  String get layoutAllHidden =>
      'Kila sehemu imefichwa. Skrini ya mwanzo itakuwa tupu.';

  @override
  String get layoutSectionGreeting => 'Salamu';

  @override
  String get layoutSectionAccounts => 'Akaunti';

  @override
  String get layoutSectionQuickStats => 'Mapato na matumizi';

  @override
  String get layoutSectionQuickLinks => 'Njia za mkato';

  @override
  String get layoutSectionSpendingChart => 'Muhtasari wa matumizi';

  @override
  String get layoutSectionRecent => 'Miamala ya karibuni';

  @override
  String get layoutSectionBudgets => 'Maendeleo ya bajeti';

  @override
  String get layoutSectionGoals => 'Malengo yaliyobandikwa';

  @override
  String get shortcutAddExpense => 'Ongeza matumizi';

  @override
  String get shortcutAddIncome => 'Ongeza mapato';

  @override
  String get shortcutScanReceipt => 'Changanua risiti';

  @override
  String get shortcutTransactions => 'Miamala';

  @override
  String get backupBusySyncing =>
      'Usawazishaji unaendelea. Subiri ukamilike kabla ya kurejesha.';

  @override
  String get appearanceTitle => 'Mwonekano';

  @override
  String get themeSunriseLight => 'Macheo Mwanga';

  @override
  String get themeSunriseDark => 'Macheo Giza';

  @override
  String get themeMatchSystem => 'Kama mfumo';

  @override
  String get themeMatchSystemHint =>
      'Badilisha kati ya mwanga na giza pamoja na simu yako';

  @override
  String get themeUnlockAll => 'Fungua mandhari zote';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Macheo';

  @override
  String get themeAccentSapphire => 'Samawati';

  @override
  String get themeAccentEmerald => 'Zumaridi';

  @override
  String get themeAccentRuby => 'Yakuti';

  @override
  String get themeAccentAmethyst => 'Urujuani';

  @override
  String get themeAccentGraphite => 'Kijivu';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Leo';

  @override
  String get navAdd => 'Ongeza';

  @override
  String get navStats => 'Takwimu';

  @override
  String get navMore => 'Zaidi';

  @override
  String get walkthroughTodayTitle => 'Siku yako kwa haraka';

  @override
  String get walkthroughTodayBody =>
      'Utajiri halisi, ulichopata na ulichotumia, na shughuli za leo.';

  @override
  String get walkthroughAddTitle => 'Ongeza kwa sekunde';

  @override
  String get walkthroughAddBody =>
      'Gusa Ongeza kurekodi matumizi, mapato au uhamisho.';

  @override
  String get walkthroughTransactionsTitle => 'Miamala yako';

  @override
  String get walkthroughTransactionsBody =>
      'Kila muamala, mwezi kwa mwezi. Tafuta na chuja kupata chochote.';

  @override
  String get walkthroughStatsTitle => 'Ona pesa zinakoenda';

  @override
  String get walkthroughStatsBody =>
      'Chati kwa wiki, mwezi na mwaka, kwa kundi.';

  @override
  String get walkthroughBellTitle => 'Pata taarifa';

  @override
  String get walkthroughBellBody =>
      'Arifa za bajeti na vikumbusho vitaonekana hapa. Uko tayari!';

  @override
  String get walkthroughBalanceTitle => 'Utajiri wako halisi';

  @override
  String get walkthroughBalanceBody =>
      'Kila pochi inajumlishwa hapa, na upau unaoonyesha mgawanyo.';

  @override
  String get txTransfer => 'Uhamisho';

  @override
  String get txUncategorized => 'Bila kundi';

  @override
  String todayGoodMorning(String name) {
    return 'Habari za asubuhi, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Habari za mchana, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Habari za jioni, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Habari za asubuhi';

  @override
  String get todayGoodAfternoonPlain => 'Habari za mchana';

  @override
  String get todayGoodEveningPlain => 'Habari za jioni';

  @override
  String get todayNetWorth => 'Utajiri halisi';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount mwezi huu';
  }

  @override
  String get todayEarned => 'Mapato';

  @override
  String get todaySpent => 'Matumizi';

  @override
  String get todayTitle => 'Leo';

  @override
  String get todayRecent => 'Karibuni';

  @override
  String get todayAllActivity => 'Shughuli zote';

  @override
  String get todayNothingYet => 'Bado hakuna kitu leo';

  @override
  String get todayNothingYetBody => 'Gusa Ongeza kurekodi wa kwanza.';

  @override
  String todayMoreWallets(int count) {
    return '+$count zaidi';
  }

  @override
  String get todayCoachTitle => 'Muulize mshauri wako wa pesa';

  @override
  String get todayCoachBody => 'Majibu na ushauri kutoka kwenye matumizi yako';

  @override
  String get todayNotifications => 'Arifa';

  @override
  String get todayWithinBudget => 'Ndani ya bajeti';

  @override
  String get todayOverBudget => 'Zaidi ya bajeti';

  @override
  String get todayNetCredit => 'Mkopo halisi';

  @override
  String get todayNetDebt => 'Deni halisi';

  @override
  String get todayMonthly => 'Kila mwezi';

  @override
  String get walletsTitle => 'Pochi';

  @override
  String get walletsNew => 'Mpya';

  @override
  String get walletsAddHint => 'Ongeza benki, taslimu, akiba…';

  @override
  String get walletsPlanning => 'Mipango';

  @override
  String get walletsUpcoming => 'Yanayokuja';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count yanadaiwa · $amount';
  }

  @override
  String get walletsUpcomingNone => 'Hakuna malipo yanayokaribia';

  @override
  String get walletsLendBorrow => 'Kopesha na kopa';

  @override
  String get splitTitle => 'Gawanya bili';

  @override
  String get splitSubtitle =>
      'Gawana bili na marafiki; wanachodaiwa kinaenda kwenye Kopesha na kopa';

  @override
  String get splitWhatFor => 'Ilikuwa ya nini';

  @override
  String get splitTotal => 'Jumla';

  @override
  String get splitPeople => 'Watu';

  @override
  String get splitYou => 'Wewe';

  @override
  String get splitIncludeMe => 'Nilikuwa na sehemu';

  @override
  String get splitIncludeMeSub => 'Zima kama uliwalipia wengine tu';

  @override
  String get splitAddPerson => 'Ongeza mtu';

  @override
  String get splitPersonName => 'Jina';

  @override
  String get splitKnownPeople => 'Kutoka Kopesha na kopa';

  @override
  String get splitRemove => 'Ondoa';

  @override
  String get splitPaidBy => 'Imelipwa na';

  @override
  String get splitHow => 'Jinsi ya kugawanya';

  @override
  String get splitEqual => 'Sawasawa';

  @override
  String get splitExact => 'Viasi';

  @override
  String get splitPercent => 'Asilimia';

  @override
  String get splitShares => 'Hisa';

  @override
  String get splitYourShare => 'Sehemu yako';

  @override
  String get splitOwesYou => 'Anakudai';

  @override
  String splitYouOwe(String name) {
    return 'Unadaiwa na $name';
  }

  @override
  String get splitPaidTheBill => 'Alilipa bili';

  @override
  String splitSettlesWith(String name) {
    return 'Analipana na $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total kutoka akaunti yako; $owed unadai kurudishiwa';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Hakuna kinachotoka kwenye akaunti yako sasa; unadaiwa na $name $amount';
  }

  @override
  String get splitPercentLabel => 'Asilimia ya bili';

  @override
  String get splitSave => 'Gawanya';

  @override
  String get splitSaved => 'Mgawanyo umerekodiwa';

  @override
  String get splitNeedCategory => 'Chagua kundi kwanza.';

  @override
  String get splitThisBill => 'Gawanya bili hii';

  @override
  String get splitThisBillSub =>
      'Na marafiki; wanachodaiwa kinaenda kwenye Kopesha na kopa';

  @override
  String get splitPartOf => 'Bili iliyogawanywa';

  @override
  String walletsOwedToYou(String amount) {
    return 'Unadai $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'Unadaiwa $amount';
  }

  @override
  String get walletsAllSettled => 'Yote yamelipwa';

  @override
  String get walletsGoals => 'Malengo';

  @override
  String walletsGoalsSub(int count) {
    return '$count yanaendelea';
  }

  @override
  String get walletsBudgets => 'Bajeti';

  @override
  String get walletsSubscriptions => 'Usajili';

  @override
  String get walletsTransfer => 'Hamisha kati ya pochi';

  @override
  String get walletsArchived => 'Kumbukumbu';

  @override
  String walletsDeleteMessage(String name) {
    return 'Futa “$name”? Kila muamala katika akaunti hii utafutwa pamoja nayo.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name imefutwa';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name sasa ni chaguomsingi lako';
  }

  @override
  String get walletsCreateFailed =>
      'Imeshindwa kuunda akaunti. Tafadhali jaribu tena.';

  @override
  String get walletsEmptyBody =>
      'Unda akaunti yako ya kwanza kuanza kufuatilia.';

  @override
  String get walletsTypeBank => 'Akaunti ya benki';

  @override
  String get walletsTypeCard => 'Kadi ya mkopo';

  @override
  String get walletsTypeCash => 'Taslimu';

  @override
  String get walletsTypeOther => 'Akaunti';

  @override
  String get moreTitle => 'Zaidi';

  @override
  String get moreGoPremium => 'Pata Premium';

  @override
  String get moreGoPremiumBody =>
      'Msaidizi wa AI, usawazishaji wa wingu, mandhari';

  @override
  String get moreUnlock => 'Fungua';

  @override
  String get morePremiumActive => 'Premium inatumika';

  @override
  String get morePremiumThanks => 'Asante kwa kuiunga mkono The Accountant';

  @override
  String get sectionPreferences => 'MAPENDELEO';

  @override
  String get sectionTools => 'ZANA ZA PESA';

  @override
  String get moreAiAssistant => 'Msaidizi wa AI';

  @override
  String get moreAiAssistantSub => 'Uliza maswali kuhusu pesa zako';

  @override
  String get moreSignOutConfirm =>
      'Toka kwenye akaunti yako kwenye kifaa hiki?';

  @override
  String get moreSignOutFailed => 'Imeshindwa kutoka. Tafadhali jaribu tena.';

  @override
  String get moreDeviceOnlyBody =>
      'Akaunti za bure hazihifadhiwi kwenye wingu, hivyo kusakinisha upya au kubadilisha simu kunaweza kupoteza data yako. Pandisha daraja kwa usawazishaji wa wingu, au hamisha nakala mara kwa mara.';

  @override
  String get moreUpgradeToPremium => 'Pandisha hadi Premium';

  @override
  String get moreUser => 'Wewe';

  @override
  String get statsTitle => 'Takwimu';

  @override
  String get statsWeek => 'Wiki';

  @override
  String get statsMonth => 'Mwezi';

  @override
  String get statsYear => 'Mwaka';

  @override
  String get statsSpending => 'Matumizi';

  @override
  String get statsIncome => 'Mapato';

  @override
  String get statsCategories => 'Makundi';

  @override
  String get statsSpent => 'Imetumika';

  @override
  String get statsEarned => 'Imepatikana';

  @override
  String get statsNet => 'Halisi';

  @override
  String get statsThisMonth => 'Mwezi huu';

  @override
  String statsVsLastMonth(String change) {
    return '$change ukilinganisha na mwezi uliopita';
  }

  @override
  String get statsInsightsSub => 'Muhtasari wa mwezi huu, mwenendo na vidokezo';

  @override
  String get statsAskCoach => 'Muulize mshauri wa AI kuhusu hili';

  @override
  String statsOverBy(String amount) {
    return 'Imezidi kwa $amount';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% imebaki';
  }

  @override
  String get activityAll => 'Zote';

  @override
  String get activitySpent => 'Matumizi';

  @override
  String get activityEarned => 'Mapato';

  @override
  String get activityTransfers => 'Uhamisho';

  @override
  String activitySoFar(String month) {
    return '$month hadi sasa';
  }

  @override
  String activityNet(String amount) {
    return '$amount halisi';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matokeo $count katika miezi yote',
      one: 'Tokeo 1 katika miezi yote',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'Siku 7 zilizopita';

  @override
  String get statsPeriodThisMonth => 'Mwezi huu';

  @override
  String get statsPeriodThisYear => 'Mwaka huu';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miamala $count',
      one: 'muamala 1',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Hakuna kinacholingana na “$query”';
  }

  @override
  String get activitySearchNothingBody =>
      'Miezi yote imetafutwa. Jaribu maneno machache, tahajia nyingine, au ondoa kichujio.';

  @override
  String get activityIn => 'Ingizo';

  @override
  String get activityOut => 'Toleo';

  @override
  String get activityToday => 'Leo';

  @override
  String get activityYesterday => 'Jana';

  @override
  String get activityTomorrow => 'Kesho';

  @override
  String get activityEmptyFutureTitle => 'Hakuna miamala iliyopangwa';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Ongeza malipo ya baadaye ya $month';
  }

  @override
  String get activityEmptyNowTitle => 'Bado hakuna miamala';

  @override
  String get activityEmptyNowBody => 'Anza kufuatilia matumizi yako mwezi huu';

  @override
  String get activityEmptyPastTitle => 'Hakuna miamala iliyopatikana';

  @override
  String activityEmptyPastBody(String month) {
    return 'Hakuna rekodi za $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count imefutwa',
      one: 'Muamala 1 umefutwa',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count zimehamishiwa $name';
  }

  @override
  String get activityMixedCurrencies =>
      'Hizi ziko katika sarafu tofauti, hivyo hakuna akaunti moja zinazoweza kuhamia zote. Chagua safu za sarafu moja.';

  @override
  String activityMovedPartial(int count) {
    return '$count zimehamishwa; uhamisho umeachwa ulipo';
  }

  @override
  String activityMoved(int count) {
    return '$count zimehamishiwa akaunti nyingine';
  }

  @override
  String activityRedated(int count) {
    return 'Tarehe ya $count imebadilishwa';
  }

  @override
  String get activityNothingToPay => 'Hakuna kilichokuwa kinasubiri kulipwa';

  @override
  String activityMarkedPaid(int count) {
    return '$count zimewekwa kama zimelipwa';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count zimenakiliwa; uhamisho hauwezi kunakiliwa peke yake';
  }

  @override
  String activityCopied(int count) {
    return '$count zimenakiliwa';
  }

  @override
  String get activityDeleteOneBody =>
      'Utaondolewa kwenye rekodi zako na salio lako litahesabiwa upya.';

  @override
  String get activitySearch => 'Tafuta';

  @override
  String get addNewExpense => 'Matumizi mapya';

  @override
  String get addNewIncome => 'Mapato mapya';

  @override
  String get addNewTransfer => 'Uhamisho mpya';

  @override
  String get addEditTitle => 'Hariri muamala';

  @override
  String get addAmount => 'Kiasi';

  @override
  String get addCategory => 'Kundi';

  @override
  String get addMore => 'Zaidi';

  @override
  String get addWallet => 'Pochi';

  @override
  String addChangeDate(String date) {
    return 'Badilisha tarehe, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Badilisha saa, $time';
  }

  @override
  String get addSwapAccounts => 'Badilishana akaunti mbili';

  @override
  String get notifCheckTitle => 'Kagua arifa';

  @override
  String get notifAllowed => 'Arifa zimeruhusiwa';

  @override
  String get notifAllowedHint => 'Vikumbusho vinaweza kufika kwenye simu hii';

  @override
  String get notifBlocked => 'Arifa zimezimwa';

  @override
  String get notifBlockedHint =>
      'Gusa kuziruhusu, la sivyo hakuna kitakachokufikia';

  @override
  String get notifSendTest => 'Tuma arifa ya majaribio';

  @override
  String get notifSendTestHint =>
      'Inatumwa kutoka seva yetu, kama vikumbusho vinavyokuja';

  @override
  String get notifSending => 'Inatuma…';

  @override
  String get notifTestSent =>
      'Imetumwa. Inapaswa kuonekana baada ya sekunde chache, na kwenye kikasha chako.';

  @override
  String notifTestFailed(String reason) {
    return 'Imeshindwa kutumwa: $reason';
  }

  @override
  String get notifTestOffline => 'hakuna muunganisho na seva';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant itakutumia kikumbusho kidogo kila siku kurekodi matumizi yako, kwa muda unaouchagua. Inahitaji ruhusa ya kuonyesha arifa.';

  @override
  String get notifPrimerShow => 'Onyesha arifa za vikumbusho';

  @override
  String get notifPrimerTime => 'Zifike kwa muda uliouchagua';

  @override
  String get notifPrimerOff => 'Unaweza kuzima hii wakati wowote';

  @override
  String get notifPrimerAllow => 'Ruhusu';

  @override
  String get cardBillsTitle => 'Bili za kadi';

  @override
  String get cardBillsSubtitle =>
      'Taarifa za kadi ya mkopo, tarehe za malipo na vikumbusho';

  @override
  String get cardBillsEmptyTitle => 'Bado hakuna kadi za mkopo';

  @override
  String get cardBillsEmptyBody =>
      'Ongeza akaunti ya aina ya Kadi ya mkopo, weka siku ya taarifa na siku ya malipo, na bili zake zitaonekana hapa.';

  @override
  String get cardBillsAddCard => 'Ongeza kadi';

  @override
  String get cardStatementDay => 'Siku ya taarifa';

  @override
  String get cardStatementDayHint =>
      'Siku ya kila mwezi bili inapotolewa. Kila kitu hadi mwisho wa siku hiyo kiko ndani yake.';

  @override
  String get cardDueDay => 'Siku ya mwisho ya malipo';

  @override
  String get cardDueDayHint =>
      'Siku ya mwisho ya kulipa bili, mara ya kwanza siku hiyo inapofika baada ya taarifa.';

  @override
  String get cardRemindTitle => 'Nikumbushe';

  @override
  String get cardRemindHint =>
      'Kabla ya tarehe ya malipo, kama sehemu yoyote ya bili bado haijalipwa. Inatumwa karibu saa 3 asubuhi.';

  @override
  String get cardRemindOff => 'Imezimwa';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Siku $days kabla',
      one: 'Siku moja kabla',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Haijawekwa';

  @override
  String cardDayOfMonth(int day) {
    return 'Siku ya $day';
  }

  @override
  String get cardSetUpBody =>
      'Weka siku ya taarifa na siku ya malipo ili kuona bili za kadi hii na kukumbushwa kabla ya muda wake.';

  @override
  String get cardSetUp => 'Weka tarehe';

  @override
  String cardDueBy(String date) {
    return 'Imebaki kulipa kabla ya $date';
  }

  @override
  String get cardLeftToPay => 'Imebaki kulipa';

  @override
  String cardStatementClosed(String date) {
    return 'Taarifa ya $date';
  }

  @override
  String get cardPaidSince => 'Imelipwa tangu';

  @override
  String cardThisCycle(String date) {
    return 'Imetumika tangu, taarifa ijayo $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'Malipo ya bili ya $card';
  }

  @override
  String get cardEdit => 'Hariri kadi';

  @override
  String get cardEarlierStatements => 'TAARIFA ZA AWALI';

  @override
  String get cardPaidShort => 'imelipwa';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount haijalipwa';
  }

  @override
  String get cardStatusNotSetUp => 'Tarehe hazijawekwa';

  @override
  String get cardStatusNothingDue => 'Hakuna deni';

  @override
  String get cardStatusPaid => 'Imelipwa';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Inadaiwa baada ya siku $days',
      one: 'Inadaiwa kesho',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'Inadaiwa leo';

  @override
  String get cardStatusOverdue => 'Imechelewa';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid kati ya $owed imelipwa';
  }

  @override
  String get cardPayBill => 'Lipa bili';

  @override
  String cardPayTitle(String card) {
    return 'Lipa $card';
  }

  @override
  String get cardPayHint =>
      'Lipa yote au sehemu. Chochote unacholipa kinahesabiwa kwenye bili hii, na kilichobaki kinaendelea kudaiwa.';

  @override
  String cardPayFull(String amount) {
    return 'Lipa yote, $amount';
  }

  @override
  String get cardPayFullHint => 'Kila kilichobaki kwenye bili hii';

  @override
  String get cardPayOther => 'Lipa kiasi kingine';

  @override
  String get cardPayOtherHint => 'Malipo ya sehemu, au zaidi ya bili';

  @override
  String get addNoteHint => 'Ongeza maelezo';

  @override
  String get addRepeatMonthly => 'Rudia kila mwezi';

  @override
  String get addMoreOptions => 'Chaguo zaidi';

  @override
  String get addScanReceipt => 'Changanua risiti';

  @override
  String get addDelete => 'Futa muamala';

  @override
  String get addTypeExpense => 'Matumizi';

  @override
  String get addTypeIncome => 'Mapato';

  @override
  String get addTypeTransfer => 'Uhamisho';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Fungua kwa Premium';

  @override
  String get gateFootnote => 'Maisha yote au usajili · Rejesha wakati wowote';

  @override
  String get aiCoachTitle => 'Mfahamu mshauri wako wa pesa';

  @override
  String get aiCoachBody =>
      'Uliza kwa maneno ya kawaida. Pata majibu, ushauri na mipango kutoka kwenye matumizi yako.';

  @override
  String get aiAssistantTitle => 'Msaidizi wa AI';

  @override
  String get aiAskAnything => 'Uliza kuhusu pesa zako…';

  @override
  String get aiSend => 'Tuma';

  @override
  String get aiCopy => 'Nakili';

  @override
  String get aiCopied => 'Imenakiliwa';

  @override
  String get aiRetry => 'Jaribu tena';

  @override
  String get aiDismiss => 'Ondoa';

  @override
  String get aiTyping => 'Mshauri anaandika';

  @override
  String aiStarterCategory(String category) {
    return 'Pesa zangu za $category zilienda wapi?';
  }

  @override
  String get aiStarterBudgets => 'Je, niko sawa na bajeti zangu?';

  @override
  String get aiStarterUpcoming => 'Bili gani zinakuja?';

  @override
  String get aiStarterAnalyze =>
      'Chambua mwenendo wa matumizi yangu ya karibuni';

  @override
  String get aiStarterBudgetTips => 'Nipe vidokezo vya kupanga bajeti vizuri';

  @override
  String get aiStarterSave => 'Ninawezaje kuweka akiba zaidi?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” litafutwa kabisa.';
  }

  @override
  String get aiJustNow => 'Sasa hivi';

  @override
  String get aiErrorTitle => 'Mshauri ameshindwa kujibu';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline =>
      'Kila kitu programu inachoweza kufanya, kwa ajili yako.';

  @override
  String get paywallActiveTitle => 'Premium inatumika';

  @override
  String get paywallActiveTagline => 'Asante kwa msaada wako!';

  @override
  String get paywallRestore => 'Rejesha';

  @override
  String get paywallProcessing => 'Inashughulikia…';

  @override
  String paywallTriggered(String feature) {
    return '$feature ni kipengele cha Premium';
  }

  @override
  String paywallDaysRemaining(int days) {
    return 'Siku $days zimebaki';
  }

  @override
  String get paywallFeatSync => 'Usawazishaji wa wingu';

  @override
  String get paywallFeatSyncSub => 'Vifaa vyote';

  @override
  String get paywallFeatAi => 'Msaidizi wa AI';

  @override
  String get paywallFeatAiSub => 'Bila kikomo, bila matangazo';

  @override
  String get paywallFeatOcr => 'Kuchanganua risiti';

  @override
  String get paywallFeatOcrSub => 'OCR kwa AI';

  @override
  String get paywallFeatInsights => 'Uchambuzi wa matumizi';

  @override
  String get paywallFeatInsightsSub => 'Mwenendo wa kila mwezi';

  @override
  String get paywallFeatThemes => 'Mandhari 5';

  @override
  String get paywallFeatThemesSub => 'Za kipekee';

  @override
  String get paywallFeatPdf => 'Ripoti za PDF';

  @override
  String get paywallFeatPdfSub => 'CSV inabaki bure';

  @override
  String get paywallFeatUnlimited => 'Bila kikomo';

  @override
  String get paywallFeatUnlimitedSub => 'Pochi, bajeti';

  @override
  String get paywallFeatSupport => 'Msaada wa kipaumbele';

  @override
  String get paywallFeatSupportSub => 'Majibu ya haraka';

  @override
  String get paywallPerMonth => '/mwezi';

  @override
  String get paywallPerYear => '/mwaka';

  @override
  String get paywallOnce => 'mara moja';

  @override
  String get paywallBestValue => 'THAMANI BORA';

  @override
  String get paywallForever => 'MILELE';

  @override
  String get paywallMonthlyDesc => 'Hulipwa kila mwezi';

  @override
  String get paywallYearlyDesc => 'Hulipwa kila mwaka';

  @override
  String get paywallLifetimeDesc => 'Lipa mara moja, miliki milele';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial bure, kisha $rest';
  }

  @override
  String get paywallCtaLifetime => 'Pata ufikiaji wa maisha yote';

  @override
  String get paywallCtaYearly => 'Anza mpango wa mwaka';

  @override
  String get paywallCtaMonthly => 'Anza mpango wa mwezi';

  @override
  String get paywallFootLifetime => 'Ununuzi wa mara moja · Hakuna usajili';

  @override
  String get paywallFootSubscription =>
      'Hujisasisha kiotomatiki · Ghairi wakati wowote kwenye duka';

  @override
  String get paywallTerms =>
      'Usajili hutozwa kwenye akaunti yako ya App Store au Google Play na hujisasisha kiotomatiki usipoghairi angalau saa 24 kabla ya mwisho wa kipindi cha sasa.';

  @override
  String get paywallIapUnavailable =>
      'Ununuzi ndani ya programu haupatikani kwenye kifaa hiki. Hakikisha Google Play Services imesakinishwa na programu ilipakuliwa kutoka Play Store.';

  @override
  String get paywallLoadingPlans => 'Inapakia mipango…';

  @override
  String get paywallPlansFailed =>
      'Imeshindwa kupakia mipango. Kagua muunganisho wako na ujaribu tena.';

  @override
  String get paywallTryAgain => 'Jaribu tena';

  @override
  String get paywallRestored => 'Ununuzi umerejeshwa';

  @override
  String get paywallPurchased => 'Karibu Premium!';

  @override
  String get paywallLifetimeNever => 'Ufikiaji wa maisha yote hauishi kamwe';

  @override
  String get helpSearchQuestions => 'Tafuta maswali';

  @override
  String get helpStepWallets => 'Ongeza pochi';

  @override
  String get helpStepCategories => 'Chagua makundi';

  @override
  String get helpStepTrack => 'Fuatilia kila siku';

  @override
  String get splashTagline => 'Pesa, kwa uwazi zaidi.';

  @override
  String get introStep1 => 'Inahesabu sarafu zako…';

  @override
  String get introStep2 => 'Inaamsha pochi zako…';

  @override
  String get introStep3 => 'Inang\'arisha chati…';

  @override
  String get introStep4 => 'Karibu tayari…';

  @override
  String get introTipLabel => 'Dokezo la pesa';

  @override
  String get introTip1 =>
      'Jilipe kwanza: weka akiba siku ile ile mshahara unapoingia.';

  @override
  String get introTip2 =>
      'Matumizi madogo ya kila siku hujumlika. Kuyarekodi ni nusu ya ushindi.';

  @override
  String get introTip3 =>
      'Akiba ya dharura ya miezi 3 hugeuza mshangao kuwa usumbufu mdogo tu.';

  @override
  String get introTip4 => 'Pitia usajili kila mwezi: ghairi usichotumia.';

  @override
  String get introTip5 => 'Ipe kila shilingi kazi kabla mwezi haujaanza.';

  @override
  String get introTip6 => 'Subiri saa 24 kabla ya ununuzi wowote usiopangwa.';

  @override
  String get introTip7 =>
      'Bajeti si vikwazo, ni ruhusa ya kutumia kwa kilicho muhimu.';

  @override
  String get introTip8 =>
      'Sherehekea ushindi mdogo: kila lengo linaanza na amana ya kwanza.';

  @override
  String get adConfirmTitleAiCall => 'Pata ombi moja zaidi la AI';

  @override
  String get adConfirmTitleTheme => 'Jaribu mandhari za Premium kwa saa 24';

  @override
  String get adConfirmTitlePdf => 'Hamisha ripoti moja ya PDF';

  @override
  String get adConfirmBodyAiCall =>
      'Umetumia maombi ya bure ya AI ya mwezi huu. Tazama tangazo fupi upate moja zaidi.';

  @override
  String get adConfirmBodyTheme =>
      'Tazama tangazo fupi na mandhari zote za Premium ni zako kwa saa 24 zijazo.';

  @override
  String get adConfirmBodyPdf =>
      'Tazama tangazo fupi kuhamisha ripoti moja ya PDF.';

  @override
  String get adConfirmWarning => 'Unakaribia kutazama tangazo. Endelea?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matangazo $count zaidi yanapatikana mwezi huu',
      one: 'Tangazo 1 zaidi linapatikana mwezi huu',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Wanachama wa Premium wanapata AI bila kikomo, mandhari zote na ripoti za PDF, bila matangazo kabisa.';

  @override
  String get adWatch => 'Tazama tangazo';

  @override
  String get adGetPremium => 'Pata Premium';

  @override
  String get adNotNow => 'Si sasa';

  @override
  String get adLoading => 'Inapakia tangazo…';

  @override
  String get adVerifying => 'Inathibitisha zawadi yako…';

  @override
  String get adUnavailable =>
      'Hakuna tangazo kwa sasa. Tafadhali jaribu tena baada ya muda mfupi.';

  @override
  String get adSkipped =>
      'Tangazo lilifungwa kabla ya mwisho, kwa hiyo hakuna kilichofunguliwa.';

  @override
  String get adRewardAiCall => 'Tayari! Una ombi moja zaidi la AI.';

  @override
  String get adRewardTheme => 'Mandhari za Premium zimefunguliwa kwa saa 24.';

  @override
  String get adRewardPdf => 'Uhamishaji mmoja wa PDF umefunguliwa.';

  @override
  String get adMonthlyCapReached =>
      'Hayo ndiyo matangazo yote ya mwezi huu. Maombi yako ya bure yanarudi tarehe 1, au pata Premium bila kikomo.';

  @override
  String get adRewardPending =>
      'Asante! Zawadi yako itaonekana baada ya muda mfupi.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maombi $count ya bure ya AI yamebaki mwezi huu',
      one: 'Ombi 1 la bure la AI limebaki mwezi huu',
      zero: 'Hakuna maombi ya bure ya AI yaliyobaki mwezi huu',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: bila kikomo';

  @override
  String get aiToolSearching => 'Inatafuta miamala yako…';

  @override
  String get aiToolSummarizing => 'Inajumlisha namba…';

  @override
  String get aiToolAccounts => 'Inakagua akaunti zako…';

  @override
  String get aiToolCategories => 'Inaangalia makundi yako…';

  @override
  String get aiToolCards => 'Inakagua bili za kadi…';

  @override
  String get aiToolPlans => 'Inakagua marejesho na akiba…';

  @override
  String get aiToolSaving => 'Inahifadhi…';

  @override
  String get aiActionAddTitle => 'Ongeza muamala huu?';

  @override
  String get aiActionUpdateTitle => 'Badilisha muamala huu?';

  @override
  String get aiActionDeleteTitle => 'Futa muamala huu?';

  @override
  String get aiActionPayCardTitle => 'Lipa bili ya kadi';

  @override
  String get aiActionCardSettingsTitle => 'Badilisha tarehe za kadi';

  @override
  String get aiActionCreatePlanTitle => 'Anzisha mpango';

  @override
  String get aiActionPayPlanTitle => 'Rekodi malipo ya mpango';

  @override
  String get aiActionClosePlanTitle => 'Maliza mpango mapema';

  @override
  String get aiActionUpdatePlanTitle => 'Badilisha mpango';

  @override
  String get aiActionCreateInvestmentTitle => 'Ongeza uwekezaji';

  @override
  String get aiActionTradeInvestmentTitle => 'Rekodi biashara';

  @override
  String get aiActionUpdateInvestmentTitle => 'Sasisha bei';

  @override
  String get aiActionConfirm => 'Thibitisha';

  @override
  String get aiActionClosePlan => 'Maliza';

  @override
  String get aiActionFrom => 'Kutoka';

  @override
  String get aiActionTo => 'Kwenda';

  @override
  String get aiActionBill => 'Bili';

  @override
  String get aiActionLeftAfter => 'Kitakachobaki';

  @override
  String get aiActionRemindDays => 'Kumbusha, siku kabla';

  @override
  String get aiActionPay => 'Lipa';

  @override
  String get plansTitle => 'Marejesho, mikopo na akiba';

  @override
  String get investmentsTitle => 'Uwekezaji';

  @override
  String get investmentsSubtitle =>
      'Mifuko ya uwekezaji, hisa na SIP, kwa bei yao ya karibuni';

  @override
  String get forecastTitle => 'Utabiri wa mtiririko wa pesa';

  @override
  String get forecastSubtitle =>
      'Pesa zako za taslimu na benki zinakoelekea, na siku yoyote zitakapopungua';

  @override
  String forecastRangeDays(int days) {
    return 'Siku $days';
  }

  @override
  String get forecastNow => 'Taslimu na benki sasa';

  @override
  String get forecastMoneyIn => 'Zinazoingia';

  @override
  String get forecastMoneyOut => 'Zinazotoka';

  @override
  String get forecastLowest => 'Chini kabisa';

  @override
  String forecastLowestOn(String date) {
    return 'tarehe $date';
  }

  @override
  String get forecastChartTitle => 'Salio linalotarajiwa';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'Tarehe $date utapungukiwa na $amount';
  }

  @override
  String get forecastShortfallCause => 'Zinazotoka siku hiyo:';

  @override
  String get forecastAlreadyShort =>
      'Akaunti zako za taslimu na benki tayari ziko chini ya sifuri.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'Hakuna upungufu katika siku $days zijazo';
  }

  @override
  String get forecastAllCoveredBody =>
      'Kilichopangwa kinatoshelezwa na pesa zako za taslimu na benki.';

  @override
  String get forecastScheduledOnly =>
      'Inahesabu kilichopangwa tu: mipango, bili za kadi, usajili, malipo yanayojirudia na yanayokuja, na mikopo yenye tarehe ya malipo. Matumizi ya kila siku hayajumuishwi.';

  @override
  String get forecastEventsTitle => 'Yanayokuja';

  @override
  String forecastDayBalance(String amount) {
    return 'Salio $amount';
  }

  @override
  String get forecastEmptyTitle => 'Hakuna kilichopangwa';

  @override
  String get forecastEmptyBody =>
      'Mipango, bili za kadi, usajili na malipo yanayokuja katika kipindi hiki yataonekana hapa.';

  @override
  String get forecastOverdue => 'Imechelewa';

  @override
  String get forecastExpected => 'Inatarajiwa';

  @override
  String get forecastEventWhen => 'Lini';

  @override
  String get forecastEventKind => 'Aina';

  @override
  String get forecastEventAccount => 'Akaunti';

  @override
  String get forecastEventOpen => 'Fungua';

  @override
  String get forecastEventOverdueNote =>
      'Tarehe yake imepita na bado haijalipwa, kwa hiyo inahesabiwa kama inadaiwa leo.';

  @override
  String get forecastKindInstallment => 'Rejesho';

  @override
  String get forecastKindPremium => 'Ada ya bima';

  @override
  String get forecastKindDeposit => 'Amana';

  @override
  String get forecastKindSipBuy => 'Ununuzi wa SIP';

  @override
  String get forecastKindProfit => 'Faida';

  @override
  String get forecastKindMaturity => 'Kukomaa';

  @override
  String get forecastKindCardBill => 'Bili ya kadi';

  @override
  String get forecastKindCardBillNext => 'Bili ijayo ya kadi, hadi sasa';

  @override
  String get forecastKindSubscription => 'Usajili';

  @override
  String get forecastKindRecurringBill => 'Malipo yanayojirudia';

  @override
  String get forecastKindRecurringIncome => 'Mapato yanayojirudia';

  @override
  String get forecastKindUpcoming => 'Yanayokuja';

  @override
  String get forecastKindBorrowed => 'Mkopo wa kulipa';

  @override
  String get forecastKindLent => 'Ulichokopesha, kinarudi';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'Huenda ukapungukiwa na $amount tarehe $date';
  }

  @override
  String get forecastHomeWarningBody => 'Ona yanayokuja';

  @override
  String get forecastDismiss => 'Ondoa';

  @override
  String forecastNotifTitle(String day) {
    return 'Huenda ukapungukiwa pesa $day';
  }

  @override
  String get settingsBillReminders => 'Vikumbusho vya bili na marejesho';

  @override
  String get settingsBillRemindersSub =>
      'Bili za kadi zinazodaiwa, na marejesho ya mkopo au akiba yanayokuja';

  @override
  String get forecastNotifNowTitle => 'Umepungukiwa pesa leo';

  @override
  String forecastNotifNowBody(String amount) {
    return 'Kinachodaiwa sasa ni $amount zaidi ya kilichopo kwenye akaunti zako. Gusa kuona yanayokuja.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Malipo yaliyopangwa yatakuacha ukipungukiwa na $amount. Gusa kuona yanayokuja.';
  }

  @override
  String get investmentsEmptyTitle => 'Bado hakuna uwekezaji';

  @override
  String get investmentsEmptyBody =>
      'Fuatilia mfuko wa uwekezaji, hisa au dhahabu: ulicholipa, thamani yake sasa, na faida.';

  @override
  String get investmentsSold => 'Imeuzwa';

  @override
  String get investmentsWorth => 'Thamani sasa';

  @override
  String get investmentNew => 'Uwekezaji mpya';

  @override
  String get investmentNewHint =>
      'Vipande vya mfuko, hisa za kampuni, au kitu kingine kinachonunuliwa kwa kipimo, kama dhahabu kwa gramu.';

  @override
  String get investmentKindFund => 'Mfuko';

  @override
  String get investmentKindStock => 'Hisa';

  @override
  String get investmentKindOther => 'Nyingine';

  @override
  String get investmentNameHintFund => 'mf. CIC Money Market Fund';

  @override
  String get investmentNameHintStock => 'mf. Safaricom';

  @override
  String get investmentNameHintOther => 'mf. Dhahabu, karati 22';

  @override
  String get investmentSymbol => 'Alama au msimbo (si lazima)';

  @override
  String get investmentFirstBuy => 'Ulichonunua';

  @override
  String get investmentFirstBuyHint =>
      'Acha kiasi tupu kuiongeza bila kununua chochote bado.';

  @override
  String get investmentPaid => 'Ulicholipa';

  @override
  String get investmentReceived => 'Ulichopokea';

  @override
  String get investmentPaidInto => 'Imelipwa kwenda';

  @override
  String get investmentFee => 'Ada au kamisheni';

  @override
  String get investmentUnits => 'Vipande';

  @override
  String get investmentUnitsSold => 'Vipande vilivyouzwa';

  @override
  String investmentUnitsShort(String units) {
    return 'Vipande $units';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price kwa kipande';
  }

  @override
  String get investmentNeedUnits => 'Weka idadi ya vipande vilivyonunuliwa.';

  @override
  String get investmentSave => 'Ongeza uwekezaji';

  @override
  String get investmentAdded => 'Uwekezaji umeongezwa';

  @override
  String get investmentGone => 'Uwekezaji huu umefutwa.';

  @override
  String get netWorthSubtitle =>
      'Kila unachomiliki, ukiondoa unachodaiwa, na jinsi kilivyobadilika';

  @override
  String get netWorthToday => 'Utajiri wako ni';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount tangu mwezi uliopita';
  }

  @override
  String get netWorthBreakdown => 'Unaundwa na nini';

  @override
  String get netWorthCash => 'Taslimu na benki';

  @override
  String get netWorthCards => 'Kadi za mkopo';

  @override
  String get netWorthDeposits => 'Amana za akiba';

  @override
  String get netWorthAssets => 'Mali';

  @override
  String get netWorthLent => 'Ulichowakopesha wengine';

  @override
  String get netWorthBorrowed => 'Ulichokopa';

  @override
  String get netWorthLoansNote =>
      'Pesa uliyokopesha inahesabiwa kuwa yako hadi irudishwe, na pesa uliyokopa inahesabiwa dhidi yako hadi uilipe.';

  @override
  String get netWorthCardsLeftOut =>
      'Kadi za mkopo hazihesabiwi; unaweza kubadilisha hilo kwenye Mipangilio.';

  @override
  String get netWorthHistory => 'Mwishoni mwa kila mwezi';

  @override
  String get netWorthSixMonths => 'Miezi 6';

  @override
  String get netWorthOneYear => 'Mwaka 1';

  @override
  String get netWorthAllTime => 'Zote';

  @override
  String get netWorthHistoryEmpty =>
      'Mstari unaanza mwezi mmoja ukishaisha ukiwa na rekodi zako.';

  @override
  String get assetNew => 'Ongeza mali';

  @override
  String get assetNewHint =>
      'Ardhi, nyumba, gari, dhahabu au kitu kingine chochote unachomiliki. Thamani yake inahesabiwa kwenye utajiri wako halisi.';

  @override
  String get assetKind => 'Ni nini';

  @override
  String get assetKindLand => 'Ardhi';

  @override
  String get assetKindHome => 'Nyumba';

  @override
  String get assetKindCar => 'Gari';

  @override
  String get assetKindGold => 'Dhahabu na vito';

  @override
  String get assetKindOther => 'Kitu kingine';

  @override
  String get assetNameHintLand => 'mf. Kiwanja Kitengela';

  @override
  String get assetNameHintHome => 'mf. Nyumba Kilimani';

  @override
  String get assetNameHintCar => 'mf. Toyota Axio';

  @override
  String get assetNameHintGold => 'mf. Vito vya harusi';

  @override
  String get assetNameHintOther => 'mf. Kamera';

  @override
  String get assetWorthNow => 'Thamani sasa';

  @override
  String get assetBoughtNow => 'Nimelipia kutoka kwenye akaunti';

  @override
  String get assetBoughtNowHint =>
      'Imezimwa: tayari unaimiliki, na hakuna pesa inayohamishwa.';

  @override
  String get assetSave => 'Ongeza mali';

  @override
  String get assetAdded => 'Mali imeongezwa';

  @override
  String get assetsEmptyTitle => 'Bado hakuna mali';

  @override
  String get assetsEmptyBody =>
      'Ongeza ardhi, nyumba, gari au dhahabu kuona utajiri wako wote.';

  @override
  String get assetsSold => 'Zilizouzwa';

  @override
  String assetCostLine(String amount) {
    return 'Gharama $amount';
  }

  @override
  String get assetUpdateValue => 'Sasisha thamani';

  @override
  String get assetSell => 'Uza';

  @override
  String get assetDelete => 'Ondoa';

  @override
  String get assetValueUpdated => 'Thamani imesasishwa';

  @override
  String get assetSold => 'Imeuzwa, na pesa imerekodiwa';

  @override
  String assetDeleteTitle(String name) {
    return 'Ondoa $name?';
  }

  @override
  String get assetDeleteBody =>
      'Haitahesabiwa tena. Historia yake inabaki kwenye rekodi zako.';

  @override
  String get assetDeleted => 'Mali imeondolewa';

  @override
  String get aiActionCreateAssetTitle => 'Ongeza mali';

  @override
  String get aiActionUpdateAssetTitle => 'Sasisha thamani ya mali';

  @override
  String get aiActionSellAssetTitle => 'Uza mali';

  @override
  String get investmentWorthNow => 'Thamani sasa';

  @override
  String investmentGainLine(String gain) {
    return '$gain kwa jumla';
  }

  @override
  String get investmentPrice => 'Bei';

  @override
  String get investmentPutIn => 'Ulichoweka';

  @override
  String get investmentTakenOut => 'Ulichotoa';

  @override
  String get investmentBuy => 'Nunua';

  @override
  String get investmentSell => 'Uza';

  @override
  String investmentBuyTitle(String name) {
    return 'Nunua $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'Uza $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Gawio kutoka $name';
  }

  @override
  String get investmentDividend => 'Gawio';

  @override
  String get investmentRecordDividend => 'Rekodi gawio';

  @override
  String investmentHeldNow(String units) {
    return 'Vipande $units unavyomiliki sasa.';
  }

  @override
  String get investmentRecorded => 'Imerekodiwa';

  @override
  String get investmentUpdatePrice => 'Sasisha bei';

  @override
  String get investmentUpdatePriceHint =>
      'NAV ya leo au bei ya hisa, kwa kipande kimoja';

  @override
  String get investmentPriceUpdated => 'Bei imesasishwa';

  @override
  String get investmentStartSip => 'Anzisha SIP';

  @override
  String get investmentStartSipHint =>
      'Nunua kiasi maalum kila mwezi, kiotomatiki';

  @override
  String get investmentHistory => 'Historia';

  @override
  String investmentBought(String units) {
    return 'Vipande $units vimenunuliwa';
  }

  @override
  String investmentSold(String units) {
    return 'Vipande $units vimeuzwa';
  }

  @override
  String get investmentPriceRose => 'Bei ilipanda';

  @override
  String get investmentPriceFell => 'Bei ilishuka';

  @override
  String get investmentUnitsUnknown =>
      'vipande havijulikani bado, gusa kuongeza';

  @override
  String get investmentCorrectUnits => 'Vipande kwenye biashara hii';

  @override
  String get investmentCorrectUnitsHint =>
      'Kama taarifa ya mfuko au dalali wako inavyoonyesha.';

  @override
  String get investmentUnitsCorrected => 'Vipande vimerekebishwa';

  @override
  String get investmentDelete => 'Futa uwekezaji huu';

  @override
  String investmentDeleteTitle(String name) {
    return 'Futa $name?';
  }

  @override
  String get investmentDeleteBody =>
      'Biashara zake zinabaki kwenye historia yako. Inawezekana tu baada ya kuuza kila kitu.';

  @override
  String get investmentDeleted => 'Uwekezaji umefutwa';

  @override
  String get plansSubtitle =>
      'Marejesho, mikopo, akiba, amana, bima, hati fungani na SIP, zinazolipwa na kukusanywa kwa wakati';

  @override
  String get planNew => 'Anzisha mpango';

  @override
  String get planNewTitle => 'Unaanzisha nini?';

  @override
  String get plansEmptyTitle => 'Bado hakuna marejesho, mikopo wala akiba';

  @override
  String get plansEmptyBody =>
      'Fuatilia kitu kilichonunuliwa kwa awamu, mkopo, akiba ya kila mwezi au amana ya muda maalum. Awamu zinarekodiwa siku yake na unakumbushwa kabla ya kila moja.';

  @override
  String get plansEnded => 'Imekamilika';

  @override
  String get planKindEmi => 'Awamu';

  @override
  String get planKindLoan => 'Mkopo';

  @override
  String get planKindDps => 'Akiba ya mwezi';

  @override
  String get planKindFdr => 'Amana maalum';

  @override
  String get planKindInsurance => 'Bima';

  @override
  String get planKindBond => 'Hati fungani';

  @override
  String get planKindSip => 'SIP';

  @override
  String get planKindEmiHint =>
      'Kitu kilichonunuliwa kwa awamu, kinacholipwa kwa taslimu, akaunti ya benki au kadi';

  @override
  String get planKindLoanHint =>
      'Pesa iliyokopwa na kulipwa kwa awamu, pamoja na riba';

  @override
  String get planKindDpsHint =>
      'Weka kiasi maalum kila mwezi kwa muda maalum, na upokee pamoja na faida';

  @override
  String get planKindFdrHint =>
      'Weka kiasi benki kwa muda maalum, na faida kila mwezi, kila miezi mitatu au mwishoni';

  @override
  String get planKindInsuranceHint =>
      'Sera yenye ada kila mwezi, robo mwaka au mwaka, na malipo mwishoni kama ipo';

  @override
  String get planKindBondHint =>
      'Hati fungani au cheti cha akiba: kiasi kimoja kwa miaka, na faida kila mwezi, kila miezi mitatu au mwishoni, baada ya kodi';

  @override
  String get planKindSipHint =>
      'Kiasi maalum kwenye mfuko au hisa kila mwezi, kwa bei ya karibuni';

  @override
  String get planWeekly => 'Kila wiki';

  @override
  String get planMonthly => 'Kila mwezi';

  @override
  String get planQuarterly => 'Kila robo mwaka';

  @override
  String get planHalfYearly => 'Kila nusu mwaka';

  @override
  String get planYearly => 'Kila mwaka';

  @override
  String get planMonths => 'Miezi';

  @override
  String get planYears => 'Miaka';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount hadi $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved kati ya $total imewekwa';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid kati ya $total imelipwa';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Ijayo: $amount tarehe $date';
  }

  @override
  String get planStatusCompleted => 'Imekamilika';

  @override
  String get planStatusClosed => 'Imefungwa';

  @override
  String get planStatusOverdue => 'Imechelewa';

  @override
  String get planStatusRunning => 'Inaendelea';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done kati ya $total';
  }

  @override
  String get planGone => 'Mpango huu umefutwa.';

  @override
  String get planAccount => 'Akaunti';

  @override
  String get planAccountEmi => 'Inalipwa kutoka';

  @override
  String get planAccountLoan => 'Inapokelewa na kulipwa kutoka';

  @override
  String get planAccountSaving => 'Kutoka akaunti';

  @override
  String get planPrice => 'Bei';

  @override
  String get planBorrowed => 'Kiasi kilichokopwa';

  @override
  String get planDeposited => 'Kiasi kilichowekwa';

  @override
  String get planDeposit => 'Kila amana';

  @override
  String get planInstallment => 'Kila awamu';

  @override
  String get planWorkedOut => 'Imekokotolewa kutoka bei, riba na muda';

  @override
  String get planProgress => 'Imefanyika';

  @override
  String get planSavedSoFar => 'Akiba hadi sasa';

  @override
  String get planPaidSoFar => 'Imelipwa hadi sasa';

  @override
  String get planLeft => 'Imebaki';

  @override
  String get planTotal => 'Jumla';

  @override
  String get planInterestCharges => 'Riba na ada';

  @override
  String get planRate => 'Riba';

  @override
  String get planRateLabel => 'Riba % kwa mwaka';

  @override
  String get planRateOptional => 'Si lazima';

  @override
  String get planPayout => 'Faida inayolipwa';

  @override
  String get planPayoutMonthly => 'Kila mwezi';

  @override
  String get planPayoutQuarterly => 'Kila miezi 3';

  @override
  String get planPayoutAtMaturity => 'Mwishoni';

  @override
  String get planMaturesOn => 'Inakomaa tarehe';

  @override
  String get planMaturity => 'Inarudishwa mwishoni';

  @override
  String get planEstimated =>
      'Imekadiriwa kutoka riba; gusa kuweka kiasi cha benki';

  @override
  String get planHolding => 'Kwenye amana sasa';

  @override
  String get planEnds => 'Awamu ya mwisho';

  @override
  String planTakeMaturity(String amount) {
    return 'Chukua malipo ya mwisho, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Rekodi faida, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Lipa awamu ya $number sasa, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Lipa ada ya $number sasa, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Weka amana ya $number sasa, $amount';
  }

  @override
  String get planRecorded => 'Imerekodiwa.';

  @override
  String get planSaved => 'Imehifadhiwa.';

  @override
  String get planPayOff => 'Maliza kulipa mapema';

  @override
  String get planEncash => 'Toa pesa mapema';

  @override
  String get planSurrender => 'Sitisha sera';

  @override
  String planSurrenderTitle(String name) {
    return 'Sitisha $name?';
  }

  @override
  String get planSurrenderBody =>
      'Ada zinasimama. Chochote kampuni ya bima itakachorudisha kinarekodiwa kama mapato.';

  @override
  String get planSurrenderNothing => 'Hakuna kilichorudishwa';

  @override
  String get planSurrenderValue => 'Weka thamani ya kusitisha';

  @override
  String get planSurrenderValueLabel => 'Thamani ya kusitisha';

  @override
  String get planStopSip => 'Simamisha SIP';

  @override
  String planStopSipTitle(String name) {
    return 'Simamisha $name?';
  }

  @override
  String get planStopSipBody =>
      'Hakuna manunuzi zaidi. Kilichonunuliwa kinabaki kwenye uwekezaji.';

  @override
  String get planSipStopped => 'SIP imesimamishwa';

  @override
  String get planSave => 'Hifadhi';

  @override
  String get planSurrendered => 'Sera imesitishwa';

  @override
  String planPayOffTitle(String name) {
    return 'Maliza kulipa $name?';
  }

  @override
  String get planPayOffHint =>
      'Malipo moja kwa kilichobaki, na mpango unaisha.';

  @override
  String planPayOffLeft(String amount) {
    return 'Lipa kilichobaki, $amount';
  }

  @override
  String get planPayOffOther => 'Mkopeshaji alitaja kiasi tofauti';

  @override
  String planEncashTitle(String name) {
    return 'Toa pesa za $name?';
  }

  @override
  String get planEncashBody =>
      'Kilichopo kwenye amana kinarudi kwenye akaunti yake, na mpango unaisha.';

  @override
  String get planEncashNoProfit => 'Toa, bila faida';

  @override
  String get planEncashWithProfit => 'Toa, pamoja na faida iliyolipwa na benki';

  @override
  String get planEncashed => 'Imetolewa. Pesa imerudi kwenye akaunti yake.';

  @override
  String get planPaidOff => 'Imelipwa yote.';

  @override
  String get planAutoCollect => 'Rekodi kiotomatiki';

  @override
  String get planAutoCollectHint =>
      'Kila awamu, faida na malipo ya mwisho yanarekodiwa siku yake';

  @override
  String get planSchedule => 'RATIBA';

  @override
  String get planDelete => 'Futa mpango huu';

  @override
  String planDeleteTitle(String name) {
    return 'Futa $name?';
  }

  @override
  String get planDeleteBody =>
      'Ulichorekodi kinabaki kwenye miamala yako. Hakuna kingine kitakachorekodiwa wala kukumbushwa.';

  @override
  String get planDeleted => 'Imefutwa.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Awamu $number kati ya $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Ada $number kati ya $total';
  }

  @override
  String get planEventPayout => 'Sera inalipa';

  @override
  String planEventProfit(int number) {
    return 'Faida, mwezi wa $number';
  }

  @override
  String get planEventMaturity => 'Kukomaa';

  @override
  String get planEventDone => 'Imefanyika';

  @override
  String get planEventLate => 'Imechelewa';

  @override
  String get planEventUpcoming => 'Inakuja';

  @override
  String get planNeedAccount => 'Chagua akaunti kwanza.';

  @override
  String get planCreated =>
      'Umeanzishwa. Chochote kilichokwisha kudaiwa kimerekodiwa.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, ambapo $interest ni riba na ada.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, bila riba.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'Unaweka $deposited na unapokea takriban $maturity tarehe $date.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal inakua hadi takriban $maturity kufikia $date.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'Faida ya $profit kila mwezi, na $principal inarudi tarehe $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return 'Ada $count za $premium, jumla $total.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return 'Ada $count za $premium, jumla $total, na $payout inarudi tarehe $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'Faida ya $profit kila miezi mitatu, na $principal inarudi tarehe $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount kwenye $fund, jumla $total.';
  }

  @override
  String planNewKind(String kind) {
    return '$kind mpya';
  }

  @override
  String get planName => 'Jina';

  @override
  String get planNameHintEmi => 'mf. Simu kutoka Jumia';

  @override
  String get planNameHintLoan => 'mf. Mkopo wa pikipiki';

  @override
  String get planNameHintDps => 'mf. Akiba ya KCB';

  @override
  String get planNameHintFdr => 'mf. Amana ya Equity';

  @override
  String get planNameHintInsurance => 'mf. Bima ya maisha';

  @override
  String get planNameHintBond => 'mf. Hati fungani ya serikali ya miaka 5';

  @override
  String get planNameHintSip => 'mf. SIP ya mfuko kila mwezi';

  @override
  String get planSipFund => 'Inanunua';

  @override
  String get planSipAmount => 'Kila SIP';

  @override
  String get planSipNoFund => 'Ongeza mfuko au hisa kwenye Uwekezaji kwanza.';

  @override
  String get planProvider => 'Benki au kampuni';

  @override
  String get planReference => 'Namba ya sera au akaunti';

  @override
  String get planSumAssured => 'Kiasi kilichowekewa bima';

  @override
  String get planPremium => 'Ada ya bima';

  @override
  String get planPremiums => 'Ada za bima';

  @override
  String get planTaxLabel => 'Kodi ya zuio %';

  @override
  String get planTax => 'Kodi ya zuio';

  @override
  String get planFirstPremium => 'Ada ya kwanza';

  @override
  String get planLastPremium => 'Ada ya mwisho';

  @override
  String get planInsurancePayout => 'Inarudishwa mwishoni';

  @override
  String get planNone => 'Hakuna';

  @override
  String get planHowMany => 'Ngapi';

  @override
  String get planTerm => 'Muda';

  @override
  String get planOpenedOn => 'Ilifunguliwa tarehe';

  @override
  String get planFirstDue => 'Awamu ya kwanza';

  @override
  String get planCategory => 'Kundi';

  @override
  String get planCategoryDefault => 'Malipo ya Mkopo';

  @override
  String get planCategoryInsurance => 'Bima';

  @override
  String get planLoanReceived => 'Pesa ilipokelewa kwenye akaunti hii';

  @override
  String get planLoanReceivedHint =>
      'Zima kama ilienda moja kwa moja kwa muuzaji';

  @override
  String get planStart => 'Anza';

  @override
  String get aiActionDeleteNote =>
      'Itaenda kwenye Vilivyofutwa karibuni, ambapo unaweza kuirejesha ndani ya siku 30.';

  @override
  String get aiActionAdd => 'Iongeze';

  @override
  String get aiActionSave => 'Hifadhi badiliko';

  @override
  String get aiActionDelete => 'Ifute';

  @override
  String get aiActionCancel => 'Hapana, iache';

  @override
  String get aiActionAmount => 'Kiasi';

  @override
  String get aiActionKind => 'Aina';

  @override
  String get aiActionTitle => 'Kichwa';

  @override
  String get aiActionCategory => 'Kundi';

  @override
  String get aiActionAccount => 'Akaunti';

  @override
  String get aiActionDate => 'Tarehe';

  @override
  String get aiActionNotes => 'Maelezo';

  @override
  String get aiReport => 'Ripoti tatizo';

  @override
  String get aiReportWrongAnswer => 'Mshauri amekosea kitu';

  @override
  String get aiReportWrongAnswerHint =>
      'Namba isiyo sahihi, ukweli wa kubuni, au badiliko usilouomba';

  @override
  String get aiReportWrongAnswerSubject =>
      'Mshauri wa pesa: jibu lisilo sahihi';

  @override
  String get aiReportBug => 'Ripoti hitilafu';

  @override
  String get aiReportBugHint => 'Kitu kimeharibika, kimekwama au hakikupakia';

  @override
  String get aiReportBugSubject => 'Mshauri wa pesa: ripoti ya hitilafu';

  @override
  String get aiAboutCoach => 'Jinsi mshauri anavyofanya kazi';

  @override
  String get aiDisclaimerTitle => 'Kabla ya kumuuliza mshauri';

  @override
  String get aiDisclaimerMistakes =>
      'Mshauri ni AI. Anaweza kukosea namba, kuelewa vibaya swali au kusema kitu kisicho kweli, kwa hiyo hakiki chochote muhimu dhidi ya miamala yako.';

  @override
  String get aiDisclaimerData =>
      'Takwimu zako zinasomwa kwenye simu yako. Ili kujibu, programu inatuma swali lako na takwimu zinazohitajika kwenye seva yetu na modeli yake ya AI.';

  @override
  String get aiDisclaimerChanges =>
      'Hatabadilisha pesa zako peke yake. Kila kuongeza, kuhariri au kufuta kunaonyeshwa kwako kwanza na kunafanyika tu ukithibitisha.';

  @override
  String get aiDisclaimerReport =>
      'Jibu likionekana si sahihi, gusa bendera iliyo juu kutujulisha.';

  @override
  String get aiDisclaimerAccept => 'Nimeelewa';

  @override
  String get aiOutOfRequestsTitle => 'Umetumia maombi ya bure ya mwezi huu';

  @override
  String get aiOutOfRequestsBody =>
      'Tazama tangazo fupi kuuliza hili, au pata Premium kwa majibu bila kikomo na bila matangazo. Maombi ya bure yanarudi tarehe 1.';

  @override
  String get ocrNoCamera => 'Imeshindwa kufungua kamera.';

  @override
  String get ocrNoGallery => 'Imeshindwa kufungua matunzio.';

  @override
  String get ocrScanTitle => 'Changanua risiti';

  @override
  String get ocrScanAnother => 'Changanua nyingine';

  @override
  String get ocrScanBody =>
      'Piga picha au chagua moja. Programu inaisoma na AI inajaza maelezo.';

  @override
  String get ocrReadingWithAi => 'AI inasoma risiti yako…';

  @override
  String get ocrNothingRead =>
      'Hakuna maandishi yaliyosomeka kwenye picha hiyo. Jaribu tena kwenye mwanga mzuri, risiti yote ikionekana.';

  @override
  String get ocrAiOfferTitle => 'Acha AI iisome vizuri';

  @override
  String get ocrAiOfferBody =>
      'Inapata jumla halisi, tarehe, kila bidhaa na kundi sahihi, hata kwenye risiti iliyochafuka.';

  @override
  String get ocrReadWithAi => 'Soma kwa AI';

  @override
  String get ocrReadByAi => 'Imesomwa na AI. Ikague kabla ya kuhifadhi.';

  @override
  String get ocrItems => 'Bidhaa';

  @override
  String get quickAddTitle => 'Ieleze';

  @override
  String get quickAddSubtitle =>
      'Andika kama unavyoongea. AI inajaza fomu ili uikague.';

  @override
  String get quickAddHint => 'mf. chakula cha mchana 250 jana kutoka bKash';

  @override
  String get quickAddFill => 'Ijaze';

  @override
  String get summaryTitle => 'Muhtasari wa mwezi';

  @override
  String get summarySpent => 'Matumizi ya mwezi huu';

  @override
  String summaryEarned(String amount) {
    return 'Mapato $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent% chini ya mwezi uliopita';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent% zaidi ya mwezi uliopita';
  }

  @override
  String get summaryAiTitle => 'Mwezi wako, kwa ufupi';

  @override
  String get summaryAiBody =>
      'AI inalinganisha mwezi wako na mwezi uliopita na kuchagua kilichojitokeza, pamoja na jambo moja la kujaribu.';

  @override
  String get summaryWrite => 'Andika muhtasari wangu';

  @override
  String get summaryOutdated =>
      'Miamala yako imebadilika tangu muhtasari huu ulipoandikwa.';

  @override
  String get summaryUpdate => 'Sasisha muhtasari wangu';

  @override
  String get summaryWriting => 'Inaandika muhtasari wako…';

  @override
  String get summaryByCategory => 'Kwa kundi';

  @override
  String get summaryNoSpending =>
      'Bado hakuna matumizi yaliyorekodiwa mwezi huu.';

  @override
  String themeTrialUntil(String time) {
    return 'Mandhari za Premium zimefunguliwa hadi $time';
  }

  @override
  String get zakatTitle => 'Zaka';

  @override
  String get zakatSubtitle =>
      'Kokotoa zaka inayodaiwa kwenye mali yako, na rekodi unacholipa';

  @override
  String get zakatSubtitleOff => 'Hulipi zaka. Gusa kuikagua hata hivyo';

  @override
  String get zakatAskTitle => 'Je, unalipa zaka?';

  @override
  String get zakatAskBody =>
      'Si kila mtu analipa. Usipolipa, programu inaiweka zaka mbali nawe: hakuna deni wala vikumbusho.';

  @override
  String get zakatIPay => 'Ninalipa zaka';

  @override
  String get zakatIDontPay => 'Silipi zaka';

  @override
  String get zakatOffTitle => 'Hulipi zaka';

  @override
  String get zakatOffBody =>
      'Kwa hiyo hakuna zaka inayoonyeshwa kama deni, na hakuna vikumbusho vya zaka. Bado unaweza kuona ingekuwa kiasi gani, wakati wowote; kuangalia hakubadilishi jibu lako.';

  @override
  String get zakatOffPeek => 'Ona ingekuwa kiasi gani';

  @override
  String get zakatPeekBanner => 'Ni kuangalia tu. Umesema hulipi zaka.';

  @override
  String get zakatOptOutTitle => 'Acha kufuatilia zaka?';

  @override
  String get zakatOptOutBody =>
      'Hakuna kitakachoonyeshwa kama deni na hakutakuwa na vikumbusho vya zaka. Takwimu zako zinahifadhiwa, na unaweza kuzikagua hapa wakati wowote.';

  @override
  String get zakatDue => 'Zaka inayodaiwa';

  @override
  String zakatAboveNisab(String amount) {
    return 'Juu ya nisabu: 2.5% ya mali halisi ya $amount';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'Chini ya nisabu kwa $amount, kwa hiyo hakuna zaka inayodaiwa';
  }

  @override
  String get zakatNeedPrice => 'Weka bei kwa gramu ili kukagua nisabu';

  @override
  String get zakatPaidSoFar => 'Iliyolipwa mwaka huu';

  @override
  String get zakatLeftToPay => 'Imebaki kulipa';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tarehe ya zaka $date, baada ya siku $days',
      one: 'Tarehe ya zaka ni kesho, $date',
      zero: 'Tarehe yako ya zaka ni leo',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Weka tarehe yako ya zaka kufuatilia mwaka na kupata kikumbusho';

  @override
  String get zakatPay => 'Lipa zaka';

  @override
  String get zakatNisab => 'Nisabu';

  @override
  String get zakatBasisGold => 'Dhahabu';

  @override
  String get zakatBasisSilver => 'Fedha';

  @override
  String get zakatBasisHint =>
      'Fedha inatoa nisabu ya chini na ni chaguo la tahadhari zaidi mali yako ikiwa kwa kiasi kikubwa ni taslimu. Weka bei ya leo ya eneo lako kwa gramu moja.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Bei kwa gramu ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return 'Gramu $grams kwa bei hiyo';
  }

  @override
  String get zakatGroupCash => 'Taslimu na benki';

  @override
  String get zakatGroupDeposits => 'Amana za akiba';

  @override
  String get zakatGroupInvestments => 'Uwekezaji';

  @override
  String get zakatGroupMetals => 'Dhahabu na fedha';

  @override
  String get zakatGroupLent => 'Pesa ulizowakopesha wengine';

  @override
  String get zakatGroupOtherAssets => 'Mali nyingine';

  @override
  String get zakatGroupPaid => 'Zaka iliyolipwa mwaka huu';

  @override
  String get zakatGroupManual => 'Uliyoongeza wewe';

  @override
  String get zakatGroupBorrowed => 'Toa: pesa unazodaiwa';

  @override
  String get zakatGroupCards => 'Toa: madeni ya kadi ya mkopo';

  @override
  String get zakatOtherAssetsNote =>
      'Ardhi, nyumba au gari unalotumia halitozwi zaka. Washa kimoja tu kama unakimiliki kwa biashara.';

  @override
  String get zakatPaidNote =>
      'Imeongezwa tena, kwa sababu ilitoka kwenye akaunti zako baada ya mali ya mwaka kuhesabiwa.';

  @override
  String get zakatNoMetals =>
      'Hakuna dhahabu wala fedha iliyorekodiwa. Iongeze kama mali, au ongeza thamani yake hapa chini.';

  @override
  String get zakatAddAmount => 'Ongeza kiasi';

  @override
  String get zakatAmountLabel => 'Ni nini?';

  @override
  String get zakatAmountHint => 'Bidhaa za biashara, taslimu nyumbani…';

  @override
  String get zakatAmountDeduct => 'Ni deni linalodaiwa sasa';

  @override
  String get zakatWealth => 'Mali inayotozwa zaka';

  @override
  String get zakatDeductions => 'Madeni yanayodaiwa sasa';

  @override
  String get zakatNet => 'Mali halisi';

  @override
  String get zakatRate => '2.5% ya mali halisi';

  @override
  String get zakatYear => 'Mwaka wa zaka';

  @override
  String get zakatDate => 'Tarehe ya zaka';

  @override
  String get zakatDateHint =>
      'Siku mwaka wako wa zaka unapokamilika. Inarudi kila mwaka wa mwezi mwandamo, siku 354.';

  @override
  String get zakatRemind => 'Nikumbushe';

  @override
  String get zakatRemindHint => 'Siku 3 kabla, na siku yenyewe';

  @override
  String get zakatDisclaimer =>
      'Huu ni mwongozo wa kukusaidia kukokotoa zaka, si hukumu ya kidini. Wanazuoni wanatofautiana katika baadhi ya mambo; ukiwa na shaka, muulize mwanazuoni wa eneo lako.';

  @override
  String get zakatPayNote =>
      'Imerekodiwa kama matumizi chini ya Zaka, na kuhesabiwa kwa mwaka huu.';

  @override
  String get zakatPayRecord => 'Rekodi malipo';

  @override
  String get zakatPaidSnack => 'Zaka imerekodiwa';

  @override
  String get aiToolZakat => 'Inakokotoa zaka…';

  @override
  String get voiceButton => 'Sema muamala';

  @override
  String get voiceTitle => 'Sema';

  @override
  String get voiceUnlimited => 'Bila kikomo';

  @override
  String get voiceTapToTalk => 'Gusa duara na useme ulichotumia';

  @override
  String get voiceListening => 'Inasikiliza…';

  @override
  String get voiceStop => 'Acha kusikiliza';

  @override
  String get voiceTypeInstead => 'Andika';

  @override
  String get voiceSpeakInstead => 'Ongea';

  @override
  String get voiceSend => 'Tayari';

  @override
  String get voiceTrySaying => 'Jaribu kusema';

  @override
  String get voiceExample1 => 'Chakula cha mchana 250, bodaboda 60';

  @override
  String get voiceExample2 => 'Nimepokea mshahara, 45,000';

  @override
  String get voiceExample3 => 'Chai ya jana ilikuwa 30, si 20';

  @override
  String get voiceExample4 => 'Futa chakula cha mchana cha leo';

  @override
  String get voiceTypeHint =>
      'Chakula cha mchana 250 na bodaboda 60 kutoka bKash';

  @override
  String get voiceThinking => 'Inashughulikia…';

  @override
  String get voiceTryAgain => 'Tena';

  @override
  String get voiceSaving => 'Inahifadhi…';

  @override
  String get voiceEdit => 'Hariri';

  @override
  String get voiceNeedsYou => 'Inakuhitaji';

  @override
  String get voiceNew => 'Mpya';

  @override
  String get voiceChange => 'Badiliko';

  @override
  String get voiceRemove => 'Ondoa';

  @override
  String get voiceNeedsAmount =>
      'Hakuna kiasi kilichotajwa. Kijaze ili kuongeza huu.';

  @override
  String get voiceAdjust => 'Rekebisha';

  @override
  String get voiceFillIn => 'Jaza';

  @override
  String get voiceTime => 'Saa';

  @override
  String get voiceUndo => 'Tendua';

  @override
  String get voiceUndone => 'Imerudishwa kama ilivyokuwa';

  @override
  String get voiceNoSpeech => 'Sikusikia vizuri. Jaribu tena, au andika.';

  @override
  String get voiceMicOff =>
      'Ufikiaji wa maikrofoni umezimwa. Uruhusu kwenye Mipangilio, au andika badala yake.';

  @override
  String get voiceUnavailable =>
      'Sauti haipatikani kwenye simu hii. Unaweza kuandika badala yake.';

  @override
  String get voiceSomethingWrong => 'Kuna hitilafu. Jaribu tena.';

  @override
  String get voiceFabSetting => 'Maikrofoni inayoelea kwenye Leo';

  @override
  String get amountHidden => 'Kiasi kimefichwa';

  @override
  String get privacyShowAmounts => 'Onyesha viasi';

  @override
  String get privacyHideAmounts => 'Ficha viasi';

  @override
  String get privacyAmounts => 'Viasi kwenye skrini';

  @override
  String get privacyAmountsFooter =>
      'Salio na jumla zinafifishwa ili watu walio karibu wasiweze kuzisoma. Miamala moja moja inabaki kuonekana. Jicho kwenye Leo pia linaziwonyesha au kuzificha.';

  @override
  String get privacyHideTitle => 'Ficha salio na jumla';

  @override
  String get privacyHideSub => 'Zififishe hadi uchague kuzionyesha';

  @override
  String get privacyTapTitle => 'Gusa kiasi kilichofichwa kukionyesha';

  @override
  String get privacyTapSub =>
      'Vinginevyo jicho kwenye Leo pekee ndilo linaloviwonyesha';

  @override
  String get privacyStartTitle => 'Programu inapofunguka';

  @override
  String get privacyStartHidden => 'Vimefichwa';

  @override
  String get privacyStartHiddenSub =>
      'Fungua kila mara salio na jumla zikiwa zimefichwa';

  @override
  String get privacyStartShown => 'Vinaonekana';

  @override
  String get privacyStartShownSub =>
      'Fungua kila mara salio na jumla zikionekana';

  @override
  String get privacyStartRemember => 'Kama nilivyoacha';

  @override
  String get privacyStartRememberSub =>
      'Fungua kama jicho lilivyoachwa mara ya mwisho';

  @override
  String get privacyIntroTitle => 'Mpya: ficha salio lako';

  @override
  String get privacyIntroBody =>
      'Salio na jumla sasa zimefichwa, ili watu walio karibu wasiweze kuzisoma. Gusa jicho kwenye Leo kuzionyesha au kuzificha; programu inakumbuka ulivyoacha. Unaweza kuchagua jinsi programu inavyofunguka kwenye Mipangilio.';

  @override
  String get privacyIntroOk => 'Nimeelewa';

  @override
  String get privacyIntroSettings => 'Chagua kwenye Mipangilio';

  @override
  String get voiceFabSettingSub =>
      'Maikrofoni inayoelea juu ya Leo, kwa kusema muamala';

  @override
  String get voiceFabAskTitle => 'Ongeza maikrofoni kwenye skrini yako ya Leo?';

  @override
  String get voiceFabAskBody =>
      'Igusa na useme ulichotumia, kama \"chakula cha mchana 250 na bodaboda 60\". Unakagua kila kitu kabla hakijahifadhiwa. Iburute popote upendapo.';

  @override
  String get voiceFabAskYes => 'Ndiyo, ongeza maikrofoni';

  @override
  String get voiceFabAskNo => 'Si sasa';

  @override
  String get voiceFabAskLater =>
      'Unaweza kuiwasha au kuizima wakati wowote kwenye Zaidi.';

  @override
  String get voiceFabHideTitle => 'Ficha maikrofoni inayoelea?';

  @override
  String get voiceFabHideBody =>
      'Maikrofoni iliyo juu ya Leo inabaki. Unaweza kurudisha hii kwenye Zaidi.';

  @override
  String get voiceFabHide => 'Ificha';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count TAYARI KUHIFADHIWA',
      one: '1 TAYARI KUHIFADHIWA',
      zero: 'HAKUNA KILICHO TAYARI',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hifadhi $count',
      one: 'Hifadhi 1',
      zero: 'Hakuna kilichochaguliwa',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count imehifadhiwa',
      one: 'Muamala 1 umehifadhiwa',
    );
    return '$_temp0';
  }
}
