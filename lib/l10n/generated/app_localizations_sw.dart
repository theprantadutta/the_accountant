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
  String get settingsBillRemindersNote =>
      'Vikumbusho vya bili za kadi na awamu za mipango hukokotolewa na programu kwenye simu yako, ili kiasi chako kibaki cha faragha. Usipofungua programu kwa siku chache, kikumbusho kinaweza kuchelewa au kukosekana.';

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
  String get voiceNeedsConnection =>
      'Sauti inahitaji muunganisho. Unaweza kuandika badala yake.';

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
  String get ppTitle => 'Ulinzi wa kaulisiri';

  @override
  String get ppRowOn => 'Imewashwa';

  @override
  String get ppRowOff => 'Imezimwa';

  @override
  String get ppRowLocked => 'Imefungwa kwenye simu hii';

  @override
  String get ppIntro =>
      'Data yako tayari imesimbwa kwa njia fiche kwenye simu hii na kwenye nakala zako. Kaulisiri inaongeza kufuli moja zaidi, ili wewe pekee uweze kufungua data yako iliyosawazishwa na nakala zako — hata sisi hatuwezi.';

  @override
  String get ppWithoutTitle => 'Bila kaulisiri (hali ilivyo sasa)';

  @override
  String get ppWithout1 =>
      'Kila kitu kwenye simu hii kimesimbwa kwa njia fiche.';

  @override
  String get ppWithout2 =>
      'Nakala na data iliyosawazishwa zimesimbwa kwa njia fiche kwa ufunguo unaohusishwa na akaunti yako.';

  @override
  String get ppWithout3 =>
      'Ingia kwenye simu mpya na kila kitu kinarudi, bila kuhitaji kukumbuka chochote.';

  @override
  String get ppWithout4 =>
      'Seva yetu inashikilia ufunguo huo, kwa hivyo kinadharia tungeweza kufungua data yako iliyosawazishwa.';

  @override
  String get ppWithTitle => 'Ukiwa na kaulisiri';

  @override
  String get ppWith1 =>
      'Ni kaulisiri yako au msimbo wako wa urejeshaji pekee unaoweza kufungua data yako iliyosawazishwa na nakala zako.';

  @override
  String get ppWith2 =>
      'Seva yetu inahifadhi nakala zilizofungwa za ufunguo wako pekee. Hatuwezi kusoma data yako, na hata mtu yeyote atakayevamia seva zetu hawezi.';

  @override
  String get ppWith3 =>
      'Kwenye simu mpya, au baada ya kusakinisha upya, unaandika kaulisiri yako mara moja tu.';

  @override
  String get ppWith4 =>
      'Simu hii inaendelea kufanya kazi kama inavyofanya sasa, hata bila mtandao.';

  @override
  String get ppCatchTitle => 'Tahadhari';

  @override
  String get ppCatchBody =>
      'Ukisahau kaulisiri yako na pia ukapoteza msimbo wako wa urejeshaji, hakuna anayeweza kurejesha data yako iliyosawazishwa au nakala zako — si sisi, si mtu yeyote. Kilichopo tayari kwenye simu hii kinaendelea kusomeka hapa.';

  @override
  String get ppAiNote =>
      'Vipengele vya AI bado vinatuma muhtasari wa fedha zako ili viweze kukujibu. Kaulisiri haibadilishi hilo.';

  @override
  String get ppSetButton => 'Weka kaulisiri';

  @override
  String get ppSetTitle => 'Chagua kaulisiri';

  @override
  String get ppSetHint =>
      'Tumia angalau herufi 10. Maneno machache yasiyohusiana ni rahisi kukumbuka na magumu kubahatisha.';

  @override
  String get ppPassphraseLabel => 'Kaulisiri';

  @override
  String get ppConfirmLabel => 'Iandike tena';

  @override
  String get ppTooShort => 'Tumia angalau herufi 10.';

  @override
  String get ppMismatch => 'Kaulisiri hizo mbili hazilingani.';

  @override
  String get ppUnderstand =>
      'Ninaelewa kwamba nikipoteza kaulisiri yangu na msimbo wangu wa urejeshaji, data yangu iliyosawazishwa na nakala zangu haziwezi kurejeshwa.';

  @override
  String get ppTurnOn => 'Washa ulinzi';

  @override
  String get ppWorking =>
      'Inafunga ufunguo wako. Hii inachukua sekunde chache…';

  @override
  String get ppMaybeSaved =>
      'Muunganisho ulikatika, kwa hivyo seva huenda tayari imehifadhi hili. Rudia hadi uone msimbo wa kurejesha, na uhifadhi huo.';

  @override
  String get ppRecoveryTitle => 'Msimbo wako wa urejeshaji';

  @override
  String get ppRecoveryBody =>
      'Hii ndiyo njia nyingine pekee ya kufikia data yako ukisahau kaulisiri yako. Iandike au uihifadhi kwenye kidhibiti cha manenosiri — mahali pengine tofauti na simu hii.';

  @override
  String get ppCopy => 'Nakili';

  @override
  String get ppCopied => 'Msimbo wa urejeshaji umenakiliwa';

  @override
  String get ppSavedIt =>
      'Nimehifadhi msimbo wangu wa urejeshaji mahali salama';

  @override
  String get ppDone => 'Imekamilika';

  @override
  String get ppOnTitle => 'Ulinzi umewashwa';

  @override
  String get ppOnBody =>
      'Ni kaulisiri yako au msimbo wako wa urejeshaji pekee unaoweza kufungua data yako iliyosawazishwa na nakala zako.';

  @override
  String get ppChange => 'Badilisha kaulisiri';

  @override
  String get ppNewCode => 'Pata msimbo mpya wa urejeshaji';

  @override
  String get ppNewCodeWarn =>
      'Msimbo wako wa sasa wa urejeshaji utaacha kufanya kazi. Hakikisha umehifadhi msimbo mpya.';

  @override
  String get ppTurnOff => 'Zima ulinzi';

  @override
  String get ppTurnOffBody =>
      'Seva yetu itashikilia ufunguo wako tena, kama awali. Data yako inabaki imesimbwa kwa njia fiche, lakini kinadharia tungeweza kufungua data yako iliyosawazishwa.';

  @override
  String get ppLockedTitle => 'Fungua data yako';

  @override
  String get ppLockedBody =>
      'Data yako inalindwa kwa kaulisiri. Iweke mara moja kwenye simu hii ili kufungua data yako iliyosawazishwa na nakala zako.';

  @override
  String get ppUnlock => 'Fungua';

  @override
  String get ppUseRecovery => 'Tumia msimbo wangu wa urejeshaji badala yake';

  @override
  String get ppUsePassphrase => 'Tumia kaulisiri yangu badala yake';

  @override
  String get ppRecoveryLabel => 'Msimbo wa urejeshaji';

  @override
  String get ppWrongPassphrase => 'Kaulisiri hiyo si sahihi.';

  @override
  String get ppWrongRecovery => 'Msimbo huo wa urejeshaji si sahihi.';

  @override
  String get ppUnlocked => 'Imefunguliwa kwenye simu hii';

  @override
  String get ppChanged => 'Kaulisiri imebadilishwa';

  @override
  String get ppTurnedOn => 'Ulinzi umewashwa';

  @override
  String get ppTurnedOff => 'Ulinzi umezimwa';

  @override
  String get encIntroTitle => 'Data yako sasa imesimbwa fiche';

  @override
  String get encIntroBody =>
      'Kila kitu kwenye simu hii huhifadhiwa kwa usimbaji fiche, na nakala rudufu na data iliyosawazishwa husimbwa fiche kabla ya kuondoka humo. Huhitaji kufanya chochote.';

  @override
  String get encIntroPassphrase =>
      'Unataka kufuli ya ziada? Weka kaulisiri na wewe tu utaweza kufungua data iliyosawazishwa na nakala rudufu — hata sisi hatutaweza. Ni hiari; ukipoteza kaulisiri na msimbo wake wa urejeshaji vyote, data hiyo haiwezi kurejeshwa.';

  @override
  String get encIntroSetUp => 'Weka kaulisiri';

  @override
  String get encIntroNotNow => 'Si sasa';

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

  @override
  String get ppNeedsConnection =>
      'Mipangilio ya kaulisiri inahitaji muunganisho wa intaneti. Unganisha kwenye mtandao kisha ufungue tena.';

  @override
  String get offlineToast =>
      'Uko nje ya mtandao. Kila unachoongeza kinahifadhiwa kwenye simu hii na kitasawazishwa utakaporudi mtandaoni.';

  @override
  String get backupLockedTitle => 'Fungua nakala hii rudufu';

  @override
  String get backupLockedBody =>
      'Nakala hii rudufu imelindwa kwa kaulisiri. Iweke, au msimbo wako wa kurejesha, ili kuifungua. Hii inafanya kazi bila muunganisho wa intaneti.';

  @override
  String get settingsSupportDescribeFirst =>
      'Tafadhali eleza tatizo lako kwanza';

  @override
  String get settingsSupportSent => 'Asante! Ujumbe wako umetumwa.';

  @override
  String get settingsSupportSendFailed =>
      'Imeshindwa kutuma sasa hivi. Tafadhali jaribu tena au tutumie barua pepe moja kwa moja.';

  @override
  String get settingsSupportSubjectHint => 'Hii inahusu nini?';

  @override
  String get settingsSupportMessageHint => 'Eleza swali, tatizo au maoni yako…';

  @override
  String get settingsSupportHeroBody =>
      'Maswali, hitilafu au maoni — tutumie na tutakujibu.';

  @override
  String get settingsSupportTipDescription => 'Maelezo wazi ya tatizo lako';

  @override
  String get settingsSupportTipSteps =>
      'Hatua za kurudia tatizo (ikiwa ni hitilafu)';

  @override
  String get settingsSupportTipDevice =>
      'Muundo wa kifaa chako na toleo la Android';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'Unapendelea barua pepe? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'Barua pepe imenakiliwa';

  @override
  String get settingsAboutTagline => 'Mwenzako wa Fedha Binafsi';

  @override
  String settingsAboutVersion(String version) {
    return 'Toleo: $version';
  }

  @override
  String get settingsAboutDescription =>
      'Programu ya fedha binafsi inayozingatia\nfaragha na muundo mzuri.';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'Sarafu ya Msingi: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'Ilisasishwa mwisho: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'Hariri Kiwango: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'Kiwango cha sasa cha API: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return 'dakika $count zilizopita';
  }

  @override
  String settingsHoursAgo(int count) {
    return 'saa $count zilizopita';
  }

  @override
  String settingsDaysAgo(int count) {
    return 'siku $count zilizopita';
  }

  @override
  String get settingsExportSectionDateRange => 'KIPINDI CHA TAREHE';

  @override
  String get settingsExportSectionFormat => 'MUUNDO';

  @override
  String get settingsExportSectionInclude => 'JUMUISHA';

  @override
  String get settingsExportAllTime => 'Muda Wote';

  @override
  String get settingsExportThisMonth => 'Mwezi Huu';

  @override
  String get settingsExportLastMonth => 'Mwezi Uliopita';

  @override
  String get settingsExportLast3Months => 'Miezi 3 Iliyopita';

  @override
  String get settingsExportThisYear => 'Mwaka Huu';

  @override
  String get settingsExportPdfPremiumBody =>
      'Kuhamisha CSV ni bure — data yako ni yako daima. Ripoti ya PDF iliyopangwa, yenye muhtasari na mgawanyo kwa kundi na pochi, ni kipengele cha Premium.';

  @override
  String settingsExportButton(String format) {
    return 'Hamisha $format';
  }

  @override
  String settingsExportFailed(String error) {
    return 'Kuhamisha kumeshindwa: $error';
  }

  @override
  String get settingsExportShareSubject =>
      'The Accountant - Data Iliyohamishwa';

  @override
  String settingsExportedCount(int count) {
    return 'Miamala $count imehamishwa';
  }

  @override
  String get settingsExportPdfShareSubject =>
      'The Accountant - Ripoti ya Fedha';

  @override
  String settingsExportPdfGenerated(int count) {
    return 'Ripoti ya PDF imeundwa ikiwa na miamala $count';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'Koma kwa maelfu';

  @override
  String get settingsNumberFormatDotThousands => 'Nukta kwa maelfu';

  @override
  String get settingsNumberFormatSpaceThousands => 'Nafasi kwa maelfu';

  @override
  String get settingsNumberFormatNoSeparator => 'Bila kitenganishi';

  @override
  String get settingsAutoLockImmediately => 'Papo hapo';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dakika $count',
      one: 'dakika 1',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'Kamwe';

  @override
  String get settingsBiometricUnavailable =>
      'Uthibitishaji wa bayometriki haupatikani kwenye kifaa hiki';

  @override
  String get settingsSetPassword => 'Weka Nenosiri';

  @override
  String get settingsChangePassword => 'Badilisha Nenosiri';

  @override
  String get settingsAddPasswordSubtitle =>
      'Ongeza nenosiri kwenye akaunti yako';

  @override
  String get settingsPasswordChanged => 'Nenosiri limebadilishwa';

  @override
  String get settingsPasswordSet => 'Nenosiri limewekwa';

  @override
  String get settingsClearCacheBody =>
      'Hii itafuta data ya akiba na kulazimisha kusawazisha upya programu itakapofunguliwa tena. Data yako haitafutwa.';

  @override
  String get settingsClearingCache => 'Inafuta akiba...';

  @override
  String get settingsCacheCleared =>
      'Akiba imefutwa na usawazishaji umeanzishwa';

  @override
  String get settingsClearCacheFailed => 'Imeshindwa kufuta akiba';

  @override
  String get settingsClearAllDataBody =>
      'Hii itafuta kabisa miamala, bajeti, pochi, makundi na mipangilio yako YOTE. Kitendo hiki hakiwezi kutenduliwa!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'Data yako yote ya fedha itafutwa kabisa.';

  @override
  String get settingsClearingAllData => 'Inafuta data yote...';

  @override
  String get settingsAllDataCleared => 'Data yote imefutwa';

  @override
  String settingsClearDataFailed(String error) {
    return 'Imeshindwa kufuta data: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'Utapelekwa kwenye fomu ya kuomba kufutwa kwa akaunti. Mchakato huchukua siku chache. Ukishakamilika, data yote kwenye seva itafutwa kabisa.';

  @override
  String get settingsLockAuthFailed =>
      'Uthibitishaji umeshindwa. Tafadhali jaribu tena.';

  @override
  String get settingsLockError => 'Hitilafu imetokea. Tafadhali jaribu tena.';

  @override
  String get settingsLockAuthenticating => 'Inathibitisha...';

  @override
  String get settingsProfileNameEmpty => 'Jina haliwezi kuwa tupu';

  @override
  String get settingsProfileUpdated => 'Wasifu umesasishwa';

  @override
  String get settingsProfileUpdateFailed => 'Imeshindwa kusasisha wasifu';

  @override
  String get settingsProfileSaveChanges => 'Hifadhi mabadiliko';

  @override
  String get settingsProfileSaved => 'Imehifadhiwa';

  @override
  String get settingsProfilePhotoSoon => 'Kupakia picha kunakuja hivi karibuni';

  @override
  String get settingsProfileAccountInformation => 'Taarifa za Akaunti';

  @override
  String get settingsProfileMemberSince => 'Mwanachama Tangu';

  @override
  String get settingsProfileUnknown => 'Haijulikani';

  @override
  String get settingsProfileFree => 'Bure';

  @override
  String get settingsProfileUserId => 'Kitambulisho cha Mtumiaji';

  @override
  String get settingsProfileUserIdCopied =>
      'Kitambulisho cha mtumiaji kimenakiliwa';

  @override
  String get settingsPremiumMonthly => 'Premium ya Kila Mwezi';

  @override
  String get settingsPremiumYearly => 'Premium ya Kila Mwaka';

  @override
  String get settingsPremiumLifetime => 'Premium ya Maisha Yote';

  @override
  String get settingsUnsavedChangesBody =>
      'Una mabadiliko ambayo hayajahifadhiwa. Una uhakika unataka kuondoka?';

  @override
  String settingsShareAppText(String url) {
    return 'Angalia The Accountant - programu nzuri ya fedha binafsi!\n\n$url';
  }

  @override
  String get settingsShareAppSubject =>
      'The Accountant - Programu ya Fedha Binafsi';

  @override
  String get settingsCloudSyncGateBody =>
      'Weka data yako ya fedha ikiwa imesawazishwa kwenye vifaa vyako vyote. Usipoteze data yako tena.';

  @override
  String settingsSyncPushed(int count) {
    return 'Zimetumwa $count';
  }

  @override
  String settingsSyncPulled(int count) {
    return 'Zimepokelewa $count';
  }

  @override
  String settingsSyncConflicts(int count) {
    return 'Migongano $count';
  }

  @override
  String get settingsSyncNowSubtitle => 'Tuma na pokea mabadiliko yote';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'Usawazishaji umekamilika — zimetumwa $pushed, zimepokelewa $pulled';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'Usawazishaji haujakamilika — rekodi $count hazikuweza kuhifadhiwa na zitajaribiwa tena. $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'Usawazishaji umeshindwa: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'Badilisha data ya kifaa hiki kwa data yako ya wingu';

  @override
  String get settingsRestoreFromCloudBody =>
      'Hii inafuta data YOTE kwenye kifaa hiki na kuweka data yako ya wingu badala yake. Mabadiliko yoyote kwenye kifaa hiki ambayo bado hayajasawazishwa yatapotea. Hili haliwezi kutenduliwa.';

  @override
  String settingsRestoredFromCloud(int count) {
    return 'Vipengee $count vimerejeshwa kutoka wingu';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'Urejeshaji umeghairiwa — data ya kifaa chako haijaguswa. $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'Urejeshaji umeshindwa: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'Data yako husawazishwa kiotomatiki kila baada ya dakika 15 na unapofungua programu. Kiasi, majina na maelezo husimbwa kwa njia fiche kwenye simu hii kabla ya kusawazishwa, kwa hivyo seva yetu haiwezi kuyasoma.';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'Imekamilika kwa ${seconds}s';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'Imekamilika kwa ${minutes}m ${seconds}s';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'Je, hili ni kundi lako la \"$name\"?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'Imehifadhiwa. Hili litatumika utakaposawazisha tena.';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Akaunti yako tayari ina makundi $count yanayoitwa \"$name\". Tuambie kama tutumie mojawapo kama kundi la kawaida, au tuyaache tofauti. Hakuna kinachobadilika hadi uchague.',
      one:
          'Akaunti yako tayari ina kundi linaloitwa \"$name\". Tuambie kama tulitumie kama kundi la kawaida, au tuliache tofauti. Hakuna kinachobadilika hadi uchague.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'Hapana — baki na langu na uongeze jingine tofauti';

  @override
  String get settingsReconcileNoneOfThese =>
      'Hakuna kati ya haya — ongeza jingine tofauti';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Makundi yako ya \"$name\" yanabaki kama yalivyo, pamoja na miamala yake yote. \"$name\" mpya ya kawaida itaongezwa kando yake.',
      one:
          'Kundi lako la \"$name\" linabaki kama lilivyo, pamoja na miamala yake yote. \"$name\" mpya ya kawaida itaongezwa kando yake.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'Acha tofauti';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return 'Tumia \"$name\"?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Linakuwa kundi la kawaida la \"$name\" na linabaki na miamala yake yote $count, pamoja na makundi yake madogo. Hakuna kinachofutwa.',
      zero:
          'Linakuwa kundi la kawaida la \"$name\" na linabaki na kila kitu kilichowekwa chini yake, pamoja na makundi yake madogo. Hakuna kinachofutwa.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'Tumia hili';

  @override
  String settingsReconcileWillUse(String name) {
    return 'Itatumia \"$name\".';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'Itaongeza \"$name\" tofauti.';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'Weka nenosiri lako la sasa na uchague jipya';

  @override
  String get settingsSetPasswordSubtitle =>
      'Ongeza nenosiri kwenye akaunti yako kwa usalama zaidi';

  @override
  String get settingsEnterCurrentPassword =>
      'Tafadhali weka nenosiri lako la sasa';

  @override
  String get settingsEnterNewPassword => 'Tafadhali weka nenosiri jipya';

  @override
  String get settingsPasswordMinLength =>
      'Nenosiri lazima liwe na angalau herufi 8';

  @override
  String get settingsConfirmYourPassword =>
      'Tafadhali thibitisha nenosiri lako';

  @override
  String get settingsPasswordsDoNotMatch => 'Manenosiri hayalingani';

  @override
  String get settingsPleaseWait => 'Tafadhali subiri...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'Andika \"$word\" ili kuthibitisha';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return '$percent% ya bajeti';
  }

  @override
  String get authTooManyAttempts =>
      'Majaribio mengi mno. Tafadhali subiri dakika moja kisha ujaribu tena.';

  @override
  String get authServerDown =>
      'Hatukuweza kufikia seva zetu. Tatizo liko upande wetu — tafadhali jaribu tena baada ya dakika chache.';

  @override
  String get authInitFailed => 'Imeshindwa kuanzisha uthibitishaji';

  @override
  String get authSignInError => 'Hitilafu imetokea wakati wa kuingia';

  @override
  String get authSignUpError => 'Hitilafu imetokea wakati wa kujisajili';

  @override
  String get authGoogleCancelled =>
      'Kuingia kwa Google kumeghairiwa au kumeshindwa';

  @override
  String get authFirebaseTokenFailed =>
      'Imeshindwa kupata tokeni ya kitambulisho ya Firebase';

  @override
  String get authGoogleSignInError =>
      'Hitilafu imetokea wakati wa kuingia kwa Google';

  @override
  String get authAccountExistsDifferentCredential =>
      'Tayari kuna akaunti yenye barua pepe hiyo hiyo lakini njia tofauti ya kuingia.';

  @override
  String get authInvalidCredential =>
      'Kitambulisho cha kuingia kilichotolewa si sahihi au muda wake umeisha.';

  @override
  String get authGoogleDisabled => 'Kuingia kwa Google kumezimwa.';

  @override
  String get authUserDisabled => 'Akaunti hii ya mtumiaji imezimwa.';

  @override
  String get authAppleSignInError =>
      'Hitilafu imetokea wakati wa kuingia kwa Apple';

  @override
  String get authAppleDisabled => 'Kuingia kwa Apple kumezimwa.';

  @override
  String get authNoPendingLink => 'Hakuna akaunti inayosubiri kuunganishwa';

  @override
  String get authLinkFailed => 'Imeshindwa kuunganisha akaunti';

  @override
  String get authIncorrectPassword =>
      'Nenosiri si sahihi. Tafadhali jaribu tena.';

  @override
  String get authSignOutError => 'Hitilafu imetokea wakati wa kutoka';

  @override
  String get authLinkSubtitle =>
      'Tayari kuna akaunti yenye barua pepe hii. Weka nenosiri lako ili kuunganisha akaunti yako ya Google.';

  @override
  String get authEnterYourPasswordHint => 'Weka nenosiri lako';

  @override
  String get authEnterYourPassword => 'Tafadhali weka nenosiri lako';

  @override
  String get authLinkInfo =>
      'Baada ya kuunganisha, unaweza kuingia kwa barua pepe/nenosiri au kwa Google.';

  @override
  String get authEnterYourEmail => 'Tafadhali weka barua pepe yako';

  @override
  String get authEnterValidEmail => 'Tafadhali weka barua pepe sahihi';

  @override
  String get authPasswordMin6 => 'Nenosiri lazima liwe na angalau herufi 6';

  @override
  String get authNoAccountPrompt => 'Huna akaunti? ';

  @override
  String get authForgotPasswordTitle => 'Umesahau Nenosiri';

  @override
  String get authCheckYourEmail => 'Angalia Barua Pepe Yako';

  @override
  String get authForgotPasswordSubtitle =>
      'Weka barua pepe yako na tutakutumia msimbo wa kuweka upya nenosiri lako.';

  @override
  String authCodeSentSubtitle(String email) {
    return 'Tumetuma msimbo wa tarakimu 6 kwa $email. Uweke hapa chini pamoja na nenosiri lako jipya.';
  }

  @override
  String get authEnterYourEmailHint => 'Weka barua pepe yako';

  @override
  String get authSixDigitCodeHint => 'Msimbo wa tarakimu 6';

  @override
  String get authEnterTheCode => 'Tafadhali weka msimbo';

  @override
  String get authCodeIsSixDigits => 'Msimbo una tarakimu 6';

  @override
  String get authCreateNewPasswordHint => 'Unda nenosiri jipya';

  @override
  String get authReenterNewPasswordHint => 'Weka tena nenosiri lako jipya';

  @override
  String get authEnterYourNameHint => 'Weka jina lako';

  @override
  String get authEnterFullName => 'Tafadhali weka jina lako kamili';

  @override
  String get authNameMin2 => 'Jina lazima liwe na angalau herufi 2';

  @override
  String get authCreatePasswordHint => 'Unda nenosiri';

  @override
  String get authPasswordComplexity =>
      'Lazima liwe na herufi kubwa, herufi ndogo na namba';

  @override
  String get authReenterPasswordHint => 'Weka tena nenosiri lako';

  @override
  String get authStrengthWeak => 'Dhaifu';

  @override
  String get authStrengthFair => 'Wastani';

  @override
  String get authStrengthGood => 'Nzuri';

  @override
  String get authStrengthStrong => 'Imara';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'Ninakubali $terms na $privacy';
  }

  @override
  String get authDefaultUserName => 'Mtumiaji';

  @override
  String authMemberSince(String date) {
    return 'Mwanachama tangu $date';
  }

  @override
  String get authFieldRequired => 'Sehemu hii inahitajika';

  @override
  String authSignOutFailed(String error) {
    return 'Imeshindwa kutoka: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'Imeshindwa kuchagua picha: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'Imeshindwa kusasisha wasifu: $error';
  }

  @override
  String get premiumSaveAbout44 => 'Okoa ~44%';

  @override
  String get premiumBestValue => 'Thamani Bora';

  @override
  String get premiumIapUnavailable => 'IAP haipatikani';

  @override
  String get premiumProductNotFound => 'Bidhaa haikupatikana';

  @override
  String get premiumPlanUnavailable =>
      'Mpango huu haupatikani kwa akaunti yako kwa sasa';

  @override
  String get premiumRestoreFailed => 'Imeshindwa kurejesha ununuzi';

  @override
  String get premiumPurchaseFailed => 'Ununuzi umeshindwa';

  @override
  String get premiumVerificationFailed => 'Uthibitishaji umeshindwa';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'siku $count',
      one: 'siku 1',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wiki $count',
      one: 'wiki 1',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miezi $count',
      one: 'mwezi 1',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miaka $count',
      one: 'mwaka 1',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'Umetumia $count kati ya $items $limit za bure.';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'Pandisha hadi Premium upate $items bila kikomo na mengine zaidi!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'Umefikia kikomo cha bure cha $items $limit. Pandisha hadi Premium upate $items bila kikomo.';
  }

  @override
  String get premiumLimitWallets => 'pochi';

  @override
  String get premiumLimitCategories => 'makundi maalum';

  @override
  String get premiumLimitBudgets => 'bajeti zinazotumika';

  @override
  String get premiumLimitObjectives => 'malengo yanayoendelea';

  @override
  String get premiumLimitPaymentMethods => 'njia za malipo';

  @override
  String get backupErrNotJson =>
      'Faili hii si nakala — haikuweza kusomwa kama JSON.';

  @override
  String get backupErrNotOurs => 'Faili hii si nakala kutoka The Accountant.';

  @override
  String get backupErrNewerVersion =>
      'Nakala hii iliundwa na toleo jipya zaidi la programu. Sasisha The Accountant kisha ujaribu tena.';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'Nakala hii ni ya toleo la zamani zaidi ya kile toleo hili linaweza kusoma (hifadhidata $version, la zamani zaidi linalokubalika $oldest).';
  }

  @override
  String get backupErrNoData => 'Nakala hii haina data yoyote.';

  @override
  String backupErrSectionDamaged(String section) {
    return 'Sehemu ya \"$section\" ya nakala hii imeharibika.';
  }

  @override
  String get backupErrNoHeader =>
      'Nakala hii haina kichwa kinachoeleza ni nini.';

  @override
  String get backupErrNoSchemaVersion =>
      'Nakala hii haielezi ilichukuliwa kutoka toleo gani la hifadhidata, kwa hivyo haiwezi kurejeshwa kwa usalama.';

  @override
  String get backupErrNoDate => 'Nakala hii haielezi ilichukuliwa lini.';

  @override
  String get backupErrDamaged => 'Faili hii ya nakala imeharibika.';

  @override
  String get backupErrWrongKey =>
      'Nakala hii ni ya akaunti nyingine, au faili imebadilishwa. Ingia kwa akaunti iliyoiunda ili kuirejesha.';

  @override
  String get backupErrNoPassphraseLock =>
      'Nakala hii haiwezi kufunguliwa kwa kaulisiri.';

  @override
  String get backupErrNeedsSecret =>
      'Nakala hii imelindwa kwa kaulisiri. Iweke, au msimbo wa urejeshaji, ili kuirejesha.';

  @override
  String get backupErrWrongSecret =>
      'Kaulisiri au msimbo huo wa urejeshaji haufungui nakala hii.';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'Nakala hii iliundwa na toleo jipya zaidi la programu (hifadhidata $version, toleo hili husoma hadi $supported). Sasisha The Accountant kisha ujaribu tena.';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Drive haikuweza kufikiwa: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant bado haijaruhusiwa kutumia Google Drive.';

  @override
  String get backupDriveNoFolder =>
      'Google Drive haikuunda folda ya kuhifadhi nakala.';

  @override
  String get backupDriveNoFileId =>
      'Google Drive ilipokea nakala lakini haikueleza imeiweka wapi.';

  @override
  String get backupDriveTimeout =>
      'Google Drive inachukua muda mrefu mno kujibu. Jaribu tena baadaye.';

  @override
  String get backupDriveOffline =>
      'Hakuna muunganisho na Google Drive. Jaribu tena ukiwa mtandaoni.';

  @override
  String get backupDriveDenied =>
      'Google Drive imekataa ombi. Toa ruhusa tena kisha ujaribu.';

  @override
  String get backupDriveFileGone =>
      'Nakala hiyo haipo tena kwenye Google Drive.';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive imejibu $status. $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'Jaribu tena baada ya muda mfupi.';

  @override
  String backupTakeFailed(String error) {
    return 'Nakala haikuweza kuchukuliwa: $error';
  }

  @override
  String get backupUnrestorableNewer =>
      'Iliundwa na toleo jipya zaidi la programu.';

  @override
  String get backupUnrestorableOlder =>
      'Ni ya zamani zaidi ya kile toleo hili la programu linaweza kusoma.';

  @override
  String get backupKeyUnusable =>
      'Seva imetuma ufunguo wa usimbaji fiche usiotumika. Jaribu tena baadaye.';

  @override
  String get backupKeyNeedsSignIn =>
      'Ingia ili kuhifadhi au kurejesha nakala — nakala husimbwa kwa njia fiche kwa akaunti yako.';

  @override
  String get backupKeyNeedsInternet =>
      'Unganisha kwenye intaneti mara moja ili data yako isimbwe kwa njia fiche, kisha ujaribu tena.';

  @override
  String get backupKeyLocked =>
      'Data yako imelindwa kwa kaulisiri. Ifungue kwenye kifaa hiki kwanza.';

  @override
  String get backupFrequencyManual => 'Pale tu ninapoomba';

  @override
  String get backupFrequencyDaily => 'Kila siku';

  @override
  String get backupFrequencyWeekly => 'Kila wiki';

  @override
  String get backupFrequencyMonthly => 'Kila mwezi';

  @override
  String get backupIntro =>
      'Nakala ni faili moja inayobeba kila kitu kilicho kwenye kifaa hiki — kila muamala, akaunti, bajeti na lengo. Weka moja mahali salama na hakuna kitu hapa kitakachopotea milele.';

  @override
  String get backupSectionOnDevice => 'KWENYE KIFAA HIKI';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'NAKALA KWENYE DRIVE';

  @override
  String backupBackedUpCount(int count) {
    return 'Rekodi $count zimehifadhiwa.';
  }

  @override
  String get backupSaveDialogTitle => 'Hifadhi nakala';

  @override
  String get backupChooseFileTitle => 'Chagua faili ya nakala';

  @override
  String backupFileUnreadable(String error) {
    return 'Faili hiyo haikuweza kusomwa: $error';
  }

  @override
  String backupTakenOn(String date) {
    return 'Ilichukuliwa $date.';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return 'Ilichukuliwa $date kwenye $device.';
  }

  @override
  String backupBelongedTo(String email) {
    return 'Ilikuwa ya $email.';
  }

  @override
  String get backupDifferentAccountWarning =>
      'Hiyo si akaunti iliyoingia hapa. Kurejesha kutaweka rekodi za mtu mwingine kwenye kifaa hiki.';

  @override
  String get backupRestoreEraseWarning =>
      'Kila kitu kilicho kwenye kifaa hiki sasa kitafutwa na kubadilishwa. Chochote ambacho bado hakijasawazishwa kitapotea. Hili haliwezi kutenduliwa.';

  @override
  String backupRestoredCount(int count) {
    return 'Rekodi $count zimerejeshwa.';
  }

  @override
  String backupRestoredPartial(int count) {
    return 'Rekodi $count zimerejeshwa. Sehemu ya faili haikuendana na toleo hili na imeachwa.';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'Hakuna kilichobadilishwa — urejeshaji umeshindwa: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'Nakala huwekwa kwenye folda ya faragha ambayo programu hii pekee inaweza kufungua. Faili zako nyingine hazisomwi kamwe.';

  @override
  String get backupDriveConnectedTitle => 'Google Drive imeunganishwa';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'Nakala kutoka kifaa hiki zitaenda kwenye folda inayoitwa \"$folder\" kwenye Drive yako.';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'Nakala huenda kwenye \"$folder\" kwenye Drive yako.';
  }

  @override
  String get backupNoneYet =>
      'Bado hakuna nakala iliyopakiwa kutoka kifaa hiki';

  @override
  String backupLastBackedUp(String date) {
    return 'Nakala ya mwisho $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return 'Nakala $count — za zamani huondolewa nakala mpya inapofika';
  }

  @override
  String get backupDisconnectSubtitle =>
      'Inasimamisha nakala za kiotomatiki. Hakuna kilichokwisha hifadhiwa kitakachofutwa.';

  @override
  String backupListFailed(String error) {
    return 'Imeshindwa kuorodhesha nakala zako: $error';
  }

  @override
  String get backupDriveNotGranted => 'Ruhusa ya Google Drive haikutolewa.';

  @override
  String get backupDriveConnected => 'Google Drive imeunganishwa.';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Drive haikuweza kuunganishwa: $error';
  }

  @override
  String get backupDisconnectBody =>
      'Nakala za kiotomatiki zinasimama. Nakala zilizopo tayari kwenye Drive zinabaki zilipo, na unaweza kuunganisha tena wakati wowote.';

  @override
  String backupSavedToDrive(String name) {
    return '$name imehifadhiwa kwenye Google Drive.';
  }

  @override
  String backupCopyFailed(String error) {
    return 'Nakala hiyo haikuweza kuhifadhiwa: $error';
  }

  @override
  String get backupDeleteBody => 'Itaondolewa kwenye Google Drive kabisa.';

  @override
  String get backupRefresh => 'Onyesha upya';

  @override
  String get ppErrKdfParams => 'Vigezo vya kutengeneza ufunguo havikubaliki.';

  @override
  String get ppErrKdfAlgorithm =>
      'Algoriti ya kutengeneza ufunguo haijulikani.';

  @override
  String get onboardingIntroAccountsTitle => 'Kila akaunti, salio moja';

  @override
  String get onboardingIntroAccountsBody =>
      'Weka taslimu, kadi na akiba pamoja, na uone kiasi ulichobakiwa nacho kwa kweli.';

  @override
  String get onboardingIntroBudgetsTitle => 'Bajeti zinazokuonya mapema';

  @override
  String get onboardingIntroBudgetsBody =>
      'Weka kikomo kwa kila kundi. Programu inafuatilia jumla na kukuonya kabla hujakivuka, si baadaye.';

  @override
  String get onboardingIntroAskTitle => 'Uliza kuhusu matumizi yako mwenyewe';

  @override
  String get onboardingIntroAskBody =>
      'Changanua risiti, au uliza pesa zilienda wapi mwezi uliopita, na upate jibu kutoka kwenye rekodi zako.';

  @override
  String get onboardingIntroThemeTitle => 'Ifanye ionekane yako';

  @override
  String get onboardingIntroThemeBody =>
      'Chagua mandhari sasa, au uibadilishe wakati wowote kwenye mipangilio.';

  @override
  String get onboardingCreateYourAccount => 'Fungua akaunti yako';

  @override
  String get onboardingNext => 'Endelea';

  @override
  String get onboardingCurrencyInfo =>
      'Hii itatumika kama sarafu yako kuu. Unaweza kuongeza akaunti zenye sarafu tofauti baadaye.';

  @override
  String get onboardingTypeCash => 'Taslimu';

  @override
  String get onboardingTypeBank => 'Akaunti ya Benki';

  @override
  String get onboardingTypeCard => 'Kadi ya Mkopo';

  @override
  String get onboardingTypeDeposit => 'Amana';

  @override
  String get onboardingTypeInvestment => 'Uwekezaji';

  @override
  String get onboardingTypeAsset => 'Mali';

  @override
  String onboardingDayN(int day) {
    return 'Siku $day';
  }

  @override
  String get onboardingAllSet => 'Uko Tayari!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'Imeshindwa kukamilisha usanidi: $error';
  }

  @override
  String get onboardingSkipFailed => 'Imeshindwa kuruka usanidi';

  @override
  String get startupOfflineConfirmBody =>
      'Data yako inabaki pale ilipo — hakuna kitakachofutwa kwenye kifaa hiki wala kwenye wingu.\n\nLakini kama akaunti hiyo ina data iliyohifadhiwa, chochote utakachoongeza sasa kitakaa pamoja nayo utakaporejesha — huenda ukawa na nakala rudufu za kupanga.';

  @override
  String get startupDataInCloudTitle => 'Data yako inakusubiri kwenye wingu';

  @override
  String get startupLoadFailedTitle =>
      'Hatukuweza kumaliza kupakia akaunti yako';

  @override
  String get startupGenericReason =>
      'Kuna kitu kimeharibika wakati wa kukagua akaunti hii.';

  @override
  String get startupUseWithoutRestoring => 'Tumia programu bila kurejesha';

  @override
  String get legalTermsTab => 'Masharti';

  @override
  String get legalConsent =>
      'Nimesoma na ninakubali Sera ya Faragha na Sheria na Masharti';

  @override
  String get walkthroughGotIt => 'Nimeelewa!';

  @override
  String get settingsFaqSectionGettingStarted => 'Kuanza';

  @override
  String get settingsFaq01Question => 'Ninaongezaje muamala?';

  @override
  String get settingsFaq01Answer =>
      'Gusa kitufe cha + chini ya skrini ya mwanzo. Jaza kiasi, chagua kundi, chagua pochi, na ukipenda ongeza maelezo. Gusa Hifadhi ili kurekodi muamala wako.';

  @override
  String get settingsFaq02Question =>
      'Kuna tofauti gani kati ya pochi na makundi?';

  @override
  String get settingsFaq02Answer =>
      'Pochi zinaonyesha pesa zako zimehifadhiwa wapi (k.m. Taslimu, Akaunti ya benki, Kadi ya mkopo). Makundi yanaeleza pesa zilitumika kwa nini au zilitoka wapi (k.m. Chakula, Mshahara, Burudani).';

  @override
  String get settingsFaq03Question =>
      'Ninabadilishaje muundo wa tarehe na namba?';

  @override
  String get settingsFaq03Answer =>
      'Nenda Mipangilio > Mipangilio ya Eneo. Unaweza kubadilisha sarafu chaguomsingi, muundo wa tarehe (k.m. DD/MM/YYYY au MM/DD/YYYY) na muundo wa namba (k.m. 1,234.56 au 1.234,56). Onyesho la moja kwa moja linaonyesha mipangilio yako itakavyoonekana.';

  @override
  String get settingsFaqSectionTransactions => 'Miamala';

  @override
  String get settingsFaq04Question =>
      'Je, ninaweza kufuatilia miamala inayojirudia?';

  @override
  String get settingsFaq04Answer =>
      'Ndiyo! Unapoongeza muamala, washa chaguo la \"Inajirudia\". Unaweza kuiweka ijirudie kila siku, kila wiki, kila mwezi au kila mwaka. Programu itaunda miamala hiyo yenyewe kwa ajili yako.';

  @override
  String get settingsFaq05Question => 'Ninahamishaje pesa kati ya pochi?';

  @override
  String get settingsFaq05Answer =>
      'Unapoongeza muamala, chagua \"Uhamisho\" kama aina. Chagua pochi ya kutoa, pochi ya kupokea, kisha weka kiasi. Programu itatoa kiasi kwenye pochi moja na kukiongeza kwenye nyingine yenyewe.';

  @override
  String get settingsFaq06Question => 'Miamala inayokuja ni nini?';

  @override
  String get settingsFaq06Answer =>
      'Miamala inayokuja ni matumizi au mapato ya baadaye unayoyatarajia lakini bado hujayalipa. Haiathiri salio la pochi yako hadi uiweke kuwa imelipwa. Unaweza kupata yaliyochelewa na yanayokuja kwenye sehemu ya miamala.';

  @override
  String get settingsFaq07Question => 'Ninafuatiliaje usajili?';

  @override
  String get settingsFaq07Answer =>
      'Unapoongeza muamala, weka aina maalum kuwa Usajili. Hii inauweka kama malipo ya huduma yanayojirudia. Unaweza kuona usajili wako wote sehemu moja na kufuatilia matumizi yako ya usajili kila mwezi.';

  @override
  String get settingsFaq08Question =>
      'Ufuatiliaji wa mikopo na madeni unafanyaje kazi?';

  @override
  String get settingsFaq08Answer =>
      'Tumia Mkopo kufuatilia pesa ulizomkopesha mtu, na Deni kufuatilia pesa ulizokopa. Kila kumbukumbu inafuatilia kiasi, nani anamdai nani, na malipo yalipofikia. Unaweza kurekodi malipo ya sehemu na kuweka deni kuwa limemalizika likilipwa lote.';

  @override
  String get settingsFaq09Question =>
      'Je, ninaweza kuongeza maelezo au risiti kwenye miamala?';

  @override
  String get settingsFaq09Answer =>
      'Ndiyo! Unapoongeza au kuhariri muamala, unaweza kuandika maelezo kwenye sehemu ya maelezo. Watumiaji wa Premium pia wanaweza kuchanganua risiti kwa kichanganuzi cha risiti cha AI, kinachotoa kiasi na taarifa za mfanyabiashara chenyewe.';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'Pochi na Sarafu';

  @override
  String get settingsFaq10Question => 'Ninasimamiaje akaunti kadhaa?';

  @override
  String get settingsFaq10Answer =>
      'Programu ina aina nne za akaunti: Taslimu, Akaunti ya benki, Kadi ya mkopo na Usajili. Ili kuongeza akaunti mpya, nenda \"Akaunti Zako\" kwenye dashibodi na uguse \"Ongeza Akaunti\". Kila akaunti inaweza kuwa na jina, ikoni, rangi na sarafu yake. Akaunti yako ya kwanza inawekwa kuwa chaguomsingi yenyewe. Kwa kadi za mkopo unaweza pia kuweka kikomo cha mkopo na siku ya bili ili kufuatilia mkopo uliobaki.';

  @override
  String get settingsFaq11Question => 'Je, ninaweza kutumia sarafu kadhaa?';

  @override
  String get settingsFaq11Answer =>
      'Ndiyo! Kila pochi inaweza kuwa na sarafu yake. Programu inabadilisha sarafu yenyewe kwa viwango vya ubadilishaji vya sasa. Unaweza pia kuweka viwango vyako vya ubadilishaji katika Mipangilio > Mipangilio ya Eneo.';

  @override
  String get settingsFaq12Question => 'Ubadilishaji wa sarafu unafanyaje kazi?';

  @override
  String get settingsFaq12Answer =>
      'Kila pochi inaweza kuwa na sarafu tofauti, na programu inabadilisha kiasi yenyewe kwa viwango vya ubadilishaji vya sasa vinavyosasishwa kila baada ya saa chache. Unaweza pia kuweka viwango vyako kwa jozi yoyote ya sarafu katika Mipangilio > Mipangilio ya Eneo. Programu inatumia zaidi ya sarafu 150 na huleta viwango yenyewe.';

  @override
  String get settingsFaq13Question =>
      'Nini hutokea nikifuta kundi lenye miamala?';

  @override
  String get settingsFaq13Answer =>
      'Miamala hiyo itahamishiwa \"Bila kundi\". Kisha unaweza kuiweka kwenye kundi jingine au kuiacha bila kundi.';

  @override
  String get settingsFaq14Question =>
      'Makundi madogo ni nini na ninayatumiaje?';

  @override
  String get settingsFaq14Answer =>
      'Unaweza kuunda makundi madogo chini ya kundi kuu lolote ili kufuatilia kwa undani zaidi. Kwa mfano, chini ya \"Chakula\" unaweza kuwa na \"Mahitaji ya nyumbani\", \"Mikahawa\" na \"Kahawa\". Makundi madogo yanakusaidia kuona hasa pesa zako zinakwenda wapi.';

  @override
  String get settingsFaq15Question => 'Marekebisho ya salio ni nini?';

  @override
  String get settingsFaq15Answer =>
      'Marekebisho ya salio yanakuwezesha kurekebisha salio la pochi lisipolingana na kiasi halisi. Hii huunda muamala maalum unaolinganisha salio unalofuatilia na hali halisi, bila kuongeza mapato au matumizi kwa mkono.';

  @override
  String get settingsFaqSectionBudgetsGoals => 'Bajeti na Malengo';

  @override
  String get settingsFaq16Question => 'Ninawekaje bajeti?';

  @override
  String get settingsFaq16Answer =>
      'Nenda kwenye kichupo cha Bajeti na uguse \"Bajeti mpya\". Chagua jina, weka kikomo cha matumizi, chagua kipindi (kila wiki/kila mwezi) na uchague makundi ya kufuatilia. Programu itakuarifu unapokaribia kikomo chako.';

  @override
  String get settingsFaq17Question => 'Malengo ya akiba ni nini?';

  @override
  String get settingsFaq17Answer =>
      'Malengo ya akiba yanakuwezesha kuweka kiasi unachotaka kuweka akiba. Unda lengo kwenye sehemu ya Malengo, weka kiasi lengwa, na uunganishe miamala ili kufuatilia maendeleo yako. Programu inaonyesha upau wa maendeleo na asilimia uliyofikia.';

  @override
  String get settingsFaq18Question => 'Ninafuatiliaje mkopo?';

  @override
  String get settingsFaq18Answer =>
      'Unda lengo la aina ya Mkopo kwenye sehemu ya Malengo na jumla ya kiasi unachodaiwa. Kila unapolipa, unganisha miamala hiyo na mkopo ili kufuatilia ulipaji wako. Programu inaonyesha kiasi ulicholipa na kilichobaki.';

  @override
  String get settingsFaqSectionDataSync => 'Data na Usawazishaji';

  @override
  String get settingsFaq19Question => 'Usawazishaji wa Wingu unafanyaje kazi?';

  @override
  String get settingsFaq19Answer =>
      'Usawazishaji wa Wingu unaweka data yako sawa kwenye vifaa vyako vyote. Nenda Mipangilio > Usimamizi wa Data > Usawazishaji wa Wingu ili kuuwasha. Usawazishaji unaendeshwa wenyewe kila dakika 15 na unapofungua programu. Unaweza pia kugusa \"Sawazisha Sasa\" kusawazisha papo hapo. Hiki ni kipengele cha Premium.';

  @override
  String get settingsFaq20Question => 'Ninahamishaje data yangu?';

  @override
  String get settingsFaq20Answer =>
      'Nenda Mipangilio > Usimamizi wa Data > Hamisha Data. Chagua kipindi cha tarehe, chagua CSV (kwa lahajedwali) au PDF (kwa ripoti iliyopangwa), kisha gusa Hamisha. Unaweza kujumuisha au kuacha mgawanyo kwa makundi na pochi. Hiki ni kipengele cha Premium.';

  @override
  String get settingsFaq21Question => 'Nini hutokea nikifuta data yangu?';

  @override
  String get settingsFaq21Answer =>
      'Nenda Mipangilio > Faragha na Usalama. \"Futa Akiba\" huondoa data ya muda na kulazimisha usawazishaji upya bila kufuta miamala yako. \"Futa Data Yote\" hufuta kila kitu kabisa — utahitaji kuandika DELETE kuthibitisha. Kitendo hiki hakiwezi kutenduliwa.';

  @override
  String get settingsFaqSectionPremiumAiFeatures =>
      'Premium na Vipengele vya AI';

  @override
  String get settingsFaq22Question => 'Premium ina vipengele gani?';

  @override
  String get settingsFaq22Answer =>
      'Premium inafungua: AI bila kikomo (mshauri, muhtasari wa kila mwezi, kusoma risiti na Ieleze) bila matangazo, Usawazishaji wa Wingu, ripoti za PDF, Mandhari za Premium, na inaondoa vikomo vya pochi, makundi, bajeti, malengo na njia za malipo. Pia unapata msaada wa kipaumbele.';

  @override
  String get settingsFaq23Question => 'Vikomo vya toleo la bure ni vipi?';

  @override
  String get settingsFaq23Answer =>
      'Watumiaji wa bure wanaweza kuunda hadi pochi 3, makundi 10 yao wenyewe, bajeti 3 zinazotumika, malengo/mikopo 2 inayotumika na njia 5 za malipo. Kupandisha hadi Premium kunaondoa vikomo hivi vyote.';

  @override
  String get settingsFaq24Question => 'Msaidizi wa AI anaweza kufanya nini?';

  @override
  String get settingsFaq24Answer =>
      'Mshauri wa pesa anajibu maswali kuhusu pesa zako mwenyewe: zimekwenda wapi, kama uko sawa na bajeti na malengo yako, bili zipi zinakuja, na jinsi ya kutumia kidogo au kuweka akiba zaidi. Anaona muhtasari wa takwimu zako (jumla, makundi, bajeti, malengo, bili na miamala ya hivi karibuni) ili majibu yake yatumie namba zako halisi, na anapendekeza maswali ya kufuatilia baada ya kila jibu. Anatoa mwongozo wa jumla, si ushauri wa kitaalamu wa fedha. Mazungumzo yako yanahifadhiwa ili uendelee ulipoishia, na unaweza kuyafuta wakati wowote.';

  @override
  String get settingsFaq25Question => 'Uchambuzi wa AI unafanyaje kazi?';

  @override
  String get settingsFaq25Answer =>
      'Muhtasari wa mwezi (Takwimu > Uchambuzi wa Matumizi) unalinganisha mwezi huu na mwezi uliopita: ulichopata na ulichotumia, na jinsi kila kundi lilivyobadilika. Gusa Andika muhtasari wangu na AI itataja yaliyojitokeza na kupendekeza jambo moja la kujaribu. Takwimu ni bure kwa kila mtu; maandishi ya AI yanatumia ombi moja la AI.';

  @override
  String get settingsFaq26Question => 'Upangaji wa Makundi Mahiri ni nini?';

  @override
  String get settingsFaq26Answer =>
      'Unapoweka muamala kwenye kundi kwa mkono, programu inakumbuka jina hilo ni la kundi gani na kulichagua kwa ajili yako wakati ujao (unaweza kuona na kuhariri haya chini ya Kanuni za majina). Kwa kitu kipya, gusa kitufe cha kung\'aa kwenye skrini ya kuongeza na utumie Ieleze: andika kitu kama \"chakula cha mchana 250 jana kutoka bKash\" na AI itajaza kiasi, tarehe, kundi na akaunti ili uhakiki.';

  @override
  String get settingsFaq27Question =>
      'Kichanganuzi cha risiti cha AI kinafanyaje kazi?';

  @override
  String get settingsFaq27Answer =>
      'Piga au chagua picha ya risiti. Simu yako inasoma maandishi kwenye kifaa chenyewe na kupendekeza mfanyabiashara na jumla. Gusa Soma kwa AI na AI itapata jumla halisi, tarehe, kila bidhaa na kundi sahihi, hata kwenye risiti iliyochafuka; maandishi pekee ndiyo yanatumwa, kamwe si picha. Unaweza kukagua na kuhariri kabla ya kuhifadhi. Kusoma kwa AI kunatumia ombi moja la AI.';

  @override
  String get settingsFaq28Question =>
      'Ninapata maombi mangapi ya AI, na matangazo ni ya nini?';

  @override
  String get settingsFaq28Answer =>
      'Kila mtu anapata maombi 10 ya bure ya AI kila mwezi, na yanarudi tarehe 1. Ukitaka zaidi, unaweza kuchagua kutazama tangazo fupi upate ombi moja la ziada, hadi 10 zaidi kwa mwezi. Matangazo yanaweza pia kufungua majaribio ya saa 24 ya mandhari ya premium au uhamishaji mmoja wa PDF. Tangazo huchezwa tu baada ya wewe kugusa kitufe na kuthibitisha; hakuna matangazo ya bango na hakuna kinachojitokeza chenyewe. Wanachama wa Premium wanapata AI bila kikomo na kila kitu kingine bila matangazo kabisa.';

  @override
  String get settingsFaq29Question => 'Ninasimamiaje ununuzi wangu wa Premium?';

  @override
  String get settingsFaq29Answer =>
      'Ununuzi wa Premium unasimamiwa kupitia Google Play. Nenda kwenye mipangilio ya usajili ya Google Play ili kuona au kusimamia mpango wako. Premium inapatikana kwa malipo ya kila mwezi, kila mwaka, au ununuzi wa mara moja wa maisha yote.';

  @override
  String get settingsFaqSectionPrivacySecurity => 'Faragha na Usalama';

  @override
  String get settingsFaq30Question => 'Ninawekaje kufuli ya bayometriki?';

  @override
  String get settingsFaq30Answer =>
      'Nenda Mipangilio > Faragha na Usalama na uwashe Kufuli ya Bayometriki. Ikishawashwa, utahitaji alama ya kidole au uso wako kufungua programu. Unaweza pia kuweka kipima muda cha kufunga kiotomatiki ili programu ijifunge baada ya muda bila kutumika.';

  @override
  String get settingsFaq31Question => 'Je, data yangu ya fedha iko salama?';

  @override
  String get settingsFaq31Answer =>
      'Ndiyo. Data yako yote imehifadhiwa kwenye kifaa chako. Ukiwasha Usawazishaji wa Wingu, data yako husimbwa fiche wakati wa kuhamishwa. Hatushiriki kamwe data yako ya fedha na watu wengine. Unaweza kusoma Sera yetu ya Faragha katika Mipangilio > Kuhusu.';

  @override
  String get txnLoadPaymentMethodsFailed => 'Imeshindwa kupakia njia za malipo';

  @override
  String get txnAddPaymentMethodFailed => 'Imeshindwa kuongeza njia ya malipo';

  @override
  String get txnPaymentMethodNotFound => 'Njia ya malipo haikupatikana';

  @override
  String get txnUpdatePaymentMethodFailed =>
      'Imeshindwa kusasisha njia ya malipo';

  @override
  String get txnDeletePaymentMethodFailed => 'Imeshindwa kufuta njia ya malipo';

  @override
  String txnLoadFailed(String error) {
    return 'Imeshindwa kupakia miamala: $error';
  }

  @override
  String get txnAddFailed => 'Imeshindwa kuongeza muamala';

  @override
  String txnAddFailedWithError(String error) {
    return 'Imeshindwa kuongeza muamala: $error';
  }

  @override
  String get txnNotFound => 'Muamala haukupatikana';

  @override
  String get txnUpdateFailed => 'Imeshindwa kusasisha muamala';

  @override
  String txnNotATransfer(String id) {
    return 'Muamala $id si uhamisho';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'Imeshindwa kusasisha uhamisho: $error';
  }

  @override
  String get txnDeleteFailed => 'Imeshindwa kufuta muamala';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'Imeshindwa kupakia uhamisho: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'Imeshindwa kuunda uhamisho: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'Imeshindwa kufuta uhamisho: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'Imeshindwa kupakia data: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'Imeshindwa kuweka alama kuwa imelipwa: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'Imeshindwa kuweka alama kuwa haijalipwa: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'Imeshindwa kuruka muamala: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'Imepokelewa: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'Imelipwa: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'Imebatilishwa: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'Imeshindwa kuweka alama kuwa imelipwa yote: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'Kiasi cha malipo lazima kiwe zaidi ya sifuri';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'Imeshindwa kurekodi malipo: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'Imeshindwa kuweka alama kuwa inasubiri: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'Iliyobaki: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'Malipo ya $amount yamerekodiwa';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'Imewekwa alama kuwa imekusanywa kutoka \"$title\"';
  }

  @override
  String get importFieldDescription => 'Maelezo';

  @override
  String get importFieldDirection => 'Aina (kuingia/kutoka)';

  @override
  String get importMissingDate => 'safu ya tarehe';

  @override
  String get importMissingAmount => 'safu ya kiasi';

  @override
  String importColumnN(int index) {
    return 'Safu $index';
  }

  @override
  String get importNoDate => 'Hakuna tarehe';

  @override
  String importDateMismatch(String date, String format) {
    return 'Tarehe \"$date\" hailingani na $format';
  }

  @override
  String get importAnyKnownFormat => 'muundo wowote unaojulikana';

  @override
  String get importNoAmount => 'Hakuna kiasi';

  @override
  String get importIntro =>
      'Hamisha CSV kutoka benki yako na uifungue hapa. Safu zinatambuliwa kwa ajili yako, na hakuna kinachoongezwa hadi uone hasa kitakachoongezwa.';

  @override
  String get importSavedBanks => 'BENKI ZILIZOHIFADHIWA';

  @override
  String get importChooseStatement => 'Chagua taarifa ya benki';

  @override
  String get importNoRows => 'Faili hiyo haina safu mlalo.';

  @override
  String importUsingSavedMapping(String name) {
    return 'Inatumia ramani uliyohifadhi ya $name.';
  }

  @override
  String importCouldNotRead(String error) {
    return 'Faili hiyo haikuweza kusomwa: $error';
  }

  @override
  String importForgetTitle(String name) {
    return 'Usahau $name?';
  }

  @override
  String get importForgetBody => 'Wakati ujao utaombwa kulinganisha safu tena.';

  @override
  String get importColumnsHeader => 'SAFU';

  @override
  String get importHowToRead => 'JINSI YA KUSOMA THAMANI';

  @override
  String get importWhereItGoes => 'KINAKWENDA WAPI';

  @override
  String get importWhatWillBeAdded => 'KITAKACHOONGEZWA';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Safu mlalo $count',
      one: 'Safu mlalo 1',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Safu $count',
      one: 'Safu 1',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'zimetenganishwa kwa $separator';
  }

  @override
  String importMappedAs(String name) {
    return 'imelinganishwa kama $name';
  }

  @override
  String get importDelimCommas => 'koma';

  @override
  String get importDelimSemicolons => 'semikoloni';

  @override
  String get importDelimTabs => 'vichupo';

  @override
  String get importDelimPipes => 'mistari wima (|)';

  @override
  String get importRequired => 'Inahitajika';

  @override
  String get importNotImported => 'Haiingizwi';

  @override
  String get importEmptySample => 'tupu';

  @override
  String get importPickDateColumnFirst => 'Chagua safu ya tarehe kwanza.';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" hailingani na muundo huu.';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" inasomeka kama $date';
  }

  @override
  String get importDecimalAuto => 'Imetambuliwa kutoka kwa faili';

  @override
  String get importDecimalFullStop => 'Nukta, kama 1,234.56';

  @override
  String get importDecimalComma => 'Koma, kama 1.234,56';

  @override
  String get importDuplicatesHint =>
      'Hulinganisha kwa siku, kiasi na maelezo, kwa hiyo kuingiza tena taarifa inayoingiliana hakurudufu chochote';

  @override
  String importStillNeeds(String item) {
    return 'Bado inahitaji $item.';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'Bado inahitaji $first na $second.';
  }

  @override
  String get importNothingReadable =>
      'Hakuna kitu katika faili hii kinachoweza kusomwa kwa mipangilio hii. Kagua muundo wa tarehe na safu yenye kiasi.';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count',
      one: 'Muamala 1',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount ndani';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount nje';
  }

  @override
  String importAndMore(int count) {
    return 'na $count zaidi';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count itarukwa',
      one: 'Mstari 1 utarukwa',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count itarukwa.',
      one: 'Mstari 1 utarukwa.',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'Mstari $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'Ongeza akaunti kwanza';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ingiza miamala $count',
      one: 'Ingiza muamala 1',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ingiza miamala $count?',
      one: 'Ingiza muamala 1?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'Zinaongezwa kwenye rekodi zako na kupakiwa kwenye usawazishaji ujao.';

  @override
  String get importConfirmDuplicates =>
      'Chochote kilichopo tayari siku hiyo hiyo, kwa kiasi na maelezo yale yale, kinaachwa.';

  @override
  String importFailed(String error) {
    return 'Kuingiza kumeshindwa: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count zimeingizwa';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count zilikuwepo tayari na ziliachwa.';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mistari $count haikuweza kusomwa.',
      one: 'Mstari 1 haukuweza kusomwa.',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'Kategoria mpya: $names.';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'Majina haya ya akaunti hayakuwa na kinacholingana hapa, kwa hiyo safu zake zilienda kwenye akaunti uliyochagua: $names.';
  }

  @override
  String get importRememberBody =>
      'Faili inayofuata yenye safu hizi hizi italinganishwa hivi bila kuuliza.';

  @override
  String get importNoHeaderCannotSave =>
      'Faili isiyo na vichwa vya safu haiwezi kutambuliwa tena, kwa hiyo hakuna cha kulinganisha.';

  @override
  String get importTemplateSaved =>
      'Imehifadhiwa. Faili zenye safu hizi zitaitumia kuanzia sasa.';

  @override
  String get txnTransferSameWallet =>
      'Pochi ya chanzo na ya mwisho lazima ziwe tofauti';

  @override
  String get txnTransferAmountPositive =>
      'Kiasi cha uhamisho lazima kiwe zaidi ya sifuri';

  @override
  String get txnTransferFeeNegative => 'Ada ya uhamisho haiwezi kuwa hasi';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'Pochi ya chanzo haikupatikana: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'Pochi ya mwisho haikupatikana: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'Uhamisho: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'Pochi zote mbili lazima ziwepo ili kuhamisha kati yao (chanzo: $source, mwisho: $destination).';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'Uhamisho ndani ya sarafu moja huhamisha kiasi kimoja: $source na $destination zote ziko kwa $currency, kwa hiyo kiasi kilichopokelewa hakiwezi kutofautiana.';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'Hakuna kiwango kinachojulikana kati ya $from na $to, kwa hiyo weka kiasi kilichofika kweli kwenye $destination.';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'Kiasi kilichopokelewa lazima kiwe zaidi ya sifuri. Weka kiasi kilichofika kweli kwenye $destination.';
  }

  @override
  String txnFeeTitle(String title) {
    return 'Ada: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'Muamala haukupatikana: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'Muamala si uhamisho (hakuna muamala unaoambatana)';

  @override
  String txnPairedNotFound(String id) {
    return 'Muamala unaoambatana $id haukupatikana; nusu ya uhamisho haitahaririwa.';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'Hakuna akaunti kama hiyo: $id';
  }

  @override
  String get walletCorrectionTitle => 'Marekebisho ya salio';

  @override
  String walletCorrectionNote(String name) {
    return '$name imerekebishwa ili ilingane na salio lake halisi.';
  }

  @override
  String get walletMergeIntoItself =>
      'Akaunti haiwezi kuunganishwa na yenyewe.';

  @override
  String get walletMergeBothMustExist =>
      'Akaunti zote mbili lazima ziwepo ili kuziunganisha.';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'Hakuna kiwango kinachojulikana kati ya $from na $to, kwa hiyo akaunti hizi haziwezi kuunganishwa bado.';
  }

  @override
  String get walletMergeAdjustmentTitle => 'Marekebisho ya kuunganisha';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'Kiwango cha uhamisho kati ya akaunti hizi kinatofautiana na kiwango ambacho $name iliunganishwa. Hiki kinarekodi tofauti ili jumla isibadilike.';
  }

  @override
  String get splitErrNoTotal => 'Weka kiasi cha bili.';

  @override
  String get splitErrNoPeople => 'Ongeza mtu wa kugawana naye.';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name hayumo kwenye bili hii.';
  }

  @override
  String get splitErrNothingToRecord =>
      'Mtu mwingine alilipa na hukuwa na sehemu yoyote, kwa hiyo hakuna cha kurekodi.';

  @override
  String get splitErrGiveOwnShare => 'Weka sehemu yako mwenyewe.';

  @override
  String splitErrGiveShare(String name) {
    return 'Weka sehemu ya $name.';
  }

  @override
  String get splitErrNegativeShare => 'Sehemu haiwezi kuwa hasi.';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'Sehemu zinajumlisha $sum, si $total.';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'Asilimia zinajumlisha $sum%, si 100%.';
  }

  @override
  String get splitErrNameTooLong => 'Majina yawe chini ya herufi 100.';

  @override
  String splitErrDuplicateName(String name) {
    return '$name yumo mara mbili kwenye bili.';
  }

  @override
  String get splitErrTitleTooLong => 'Kichwa kiwe chini ya herufi 200.';

  @override
  String get splitErrChooseAccount => 'Chagua akaunti iliyotumika kulipa.';

  @override
  String get splitErrOrdinaryAccount => 'Chagua akaunti ya kawaida.';

  @override
  String get splitErrYourShareNothing =>
      'Sehemu yako ni sifuri, kwa hiyo hakuna deni.';

  @override
  String get splitErrEveryShareNothing => 'Kila sehemu ni sifuri.';

  @override
  String get recurringDaily => 'Kila siku';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila siku $count',
      one: 'Kila siku',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila wiki $count',
      one: 'Kila wiki',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila miezi $count',
      one: 'Kila mwezi',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila miaka $count',
      one: 'Kila mwaka',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'Kila $unit $count';
  }

  @override
  String get recurringUntitled => 'Muamala Unaojirudia';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baada ya siku $count',
      one: 'Baada ya siku 1',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'Wiki ijayo';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baada ya wiki $count',
      one: 'Baada ya wiki 1',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'Kadi';

  @override
  String get txnPmKindDigitalWallet => 'Pochi ya kidijitali';

  @override
  String get txnPmEmptyHint =>
      'Ongeza kadi na akaunti unazolipia, kisha unaweza kuchagua moja kwenye muamala.';

  @override
  String get txnPmDeleteBody =>
      'Miamala iliyokwisha kurekodiwa nayo inabaki. Haitaonyesha tena njia ya malipo tu.';

  @override
  String get txnPmNew => 'Njia mpya ya malipo';

  @override
  String get txnPmEdit => 'Hariri njia ya malipo';

  @override
  String get txnRecentlyDeletedFooter =>
      'Miamala iliyofutwa huhifadhiwa kwa siku thelathini, kisha huondolewa kabisa.';

  @override
  String get txnUnknownCategory => 'Haijulikani';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'Hiki hasa';

  @override
  String get txnRuleContaining => 'Chochote chenye hiki';

  @override
  String get txnRulesFooter =>
      'Kanuni hulingana popote kwenye kichwa isipokuwa ukiifanya kamili. Programu huongeza moja kila unapopanga kitu kwa mkono.';

  @override
  String get txnRulesEmptyHint =>
      'Fundisha programu mara moja kitu kinapoenda, na itakipanga hivyo kuanzia hapo.';

  @override
  String get txnRuleNew => 'Kanuni mpya';

  @override
  String get txnRuleEdit => 'Hariri kanuni';

  @override
  String get txnRuleExactHint => 'Vichwa vilivyo hiki hasa tu';

  @override
  String get txnRuleContainingHint => 'Kichwa chochote chenye hiki';

  @override
  String get txnKindTransfer => 'Uhamisho kati ya akaunti';

  @override
  String get txnKindRecurring => 'Kutoka kwa ingizo linalojirudia';

  @override
  String get txnMoneyIn => 'Pesa ndani';

  @override
  String get txnMoneyOut => 'Pesa nje';

  @override
  String get txnNotYetPaid => 'Bado haijalipwa';

  @override
  String get txnLentOut => 'Imekopeshwa';

  @override
  String get txnSettledInFull => 'Imelipwa yote.';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid imerudishwa, $owed bado inadaiwa.';
  }

  @override
  String get txnUncategorised => 'Haina kategoria';

  @override
  String get txnUnknownAccount => 'Haijulikani';

  @override
  String get txnTransferCannotCopy => 'Uhamisho hauwezi kunakiliwa peke yake.';

  @override
  String get txnCopied => 'Imenakiliwa.';

  @override
  String get txnDeleteOneBody =>
      'Salio la akaunti litahesabiwa upya. Ikiwa hii ni sehemu moja ya uhamisho, nusu nyingine inaenda pamoja nayo.';

  @override
  String txnUpcomingTab(int count) {
    return 'Yanayokuja ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'Imechelewa ($count)';
  }

  @override
  String get txnNoOverdue => 'Hakuna miamala iliyochelewa';

  @override
  String get txnNoUpcoming => 'Hakuna miamala inayokuja';

  @override
  String get txnNoOverdueBody => 'Malipo yako yote yako sawa!';

  @override
  String get txnNoUpcomingBody => 'Huna malipo yanayosubiri yaliyopangwa';

  @override
  String get txnTotalOverdue => 'Jumla Iliyochelewa';

  @override
  String get txnTotalUpcoming => 'Jumla Inayokuja';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipengee $count',
      one: 'Kipengee 1',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imechelewa siku $count',
      one: 'Imechelewa siku 1',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '\"$title\" imewekwa alama kuwa imelipwa';
  }

  @override
  String txnSkippedTitle(String title) {
    return '\"$title\" imerukwa';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'Leo, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'Jana, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'Kesho, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'Hitilafu katika kufuta muamala: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return 'Chuja $title';
  }

  @override
  String get txnMonthlyIncome => 'Mapato ya Mwezi';

  @override
  String get txnMonthlyExpenses => 'Matumizi ya Mwezi';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miamala',
      one: 'muamala',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'wastani kwa muamala';

  @override
  String get txnNoPlannedIncome => 'Hakuna mapato yaliyopangwa';

  @override
  String get txnNoPlannedExpenses => 'Hakuna matumizi yaliyopangwa';

  @override
  String txnAddFutureIncome(String month) {
    return 'Ongeza mapato yajayo ya $month';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'Ongeza matumizi yajayo ya $month';
  }

  @override
  String get txnNoIncomeYet => 'Bado hakuna mapato mwezi huu';

  @override
  String get txnNoExpensesYet => 'Bado hakuna matumizi mwezi huu';

  @override
  String get txnStartTrackingIncome => 'Anza kufuatilia mapato yako mwezi huu';

  @override
  String get txnStartTrackingExpenses =>
      'Anza kufuatilia matumizi yako mwezi huu';

  @override
  String txnNoIncomeIn(String month) {
    return 'Hakuna mapato mwezi wa $month';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'Hakuna matumizi mwezi wa $month';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'Hakuna rekodi za $month';
  }

  @override
  String get txnOtherCategory => 'Nyingine';

  @override
  String get txnSearchIncome => 'Tafuta mapato';

  @override
  String get txnSearchExpenses => 'Tafuta matumizi';

  @override
  String txnErrorWith(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String get txnTapToEditAmount => 'Gusa kuhariri kiasi';

  @override
  String get txnTapToEnterAmount => 'Gusa kuweka kiasi';

  @override
  String get txnSpecialDefault => 'Kawaida';

  @override
  String get txnSpecialRepetitive => 'Inayojirudia';

  @override
  String get txnRepeatSettings => 'Mipangilio ya Kurudia';

  @override
  String get txnSubscriptionSettings => 'Mipangilio ya Usajili';

  @override
  String txnEndsOn(String date) {
    return 'Inaisha: $date';
  }

  @override
  String get txnNoEndDate => 'Hakuna tarehe ya mwisho';

  @override
  String get txnEditTransaction => 'Hariri Muamala';

  @override
  String get txnNewTransaction => 'Muamala Mpya';

  @override
  String get txnFromAccount => 'Kutoka akaunti';

  @override
  String get txnToAccount => 'Kwenda akaunti';

  @override
  String get txnAmountReceived => 'Kiasi kilichopokelewa';

  @override
  String txnAmountReceivedHint(String account) {
    return 'Akaunti hizi zinatumia sarafu tofauti. Weka kiasi kilichofika kweli kwenye $account, au acha wazi ili kutumia kiwango cha programu.';
  }

  @override
  String txnInCurrency(String currency) {
    return 'Kwa $currency';
  }

  @override
  String get txnTransferTitleHint => 'mf. Hamishia akiba (si lazima)';

  @override
  String get txnTitleHint => 'Ilikuwa ya nini?';

  @override
  String get txnUpdate => 'Sasisha';

  @override
  String get txnSelectCategory => 'Chagua kategoria';

  @override
  String get txnSearchTransactions => 'Tafuta miamala';

  @override
  String get txnSpecialRegular => 'Kawaida';

  @override
  String get txnSpecialLend => 'Kopesha';

  @override
  String get txnSpecialBorrow => 'Kopa';

  @override
  String get txnSpecialRegularDesc => 'Muamala wa kawaida';

  @override
  String get txnSpecialUpcomingDesc => 'Malipo yajayo ya kufuatilia';

  @override
  String get txnSpecialSubscriptionDesc => 'Malipo ya huduma yanayojirudia';

  @override
  String get txnSpecialRepetitiveDesc => 'Muamala unaojirudia';

  @override
  String get txnSpecialLendDesc => 'Pesa uliyokopesha (wanakudai)';

  @override
  String get txnSpecialBorrowDesc => 'Pesa uliyokopa (unawadai)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'Kikomo cha chini kiko juu ya cha juu, kwa hiyo hakuna kinacholingana. $min hadi $max.';
  }

  @override
  String get walletMyWallet => 'Pochi Yangu';

  @override
  String walletCreateFailed(String error) {
    return 'Imeshindwa kuunda pochi: $error';
  }

  @override
  String get walletTypeBankAccount => 'Akaunti ya Benki';

  @override
  String get walletTypeCreditCard => 'Kadi ya Mkopo';

  @override
  String get walletTypeSubscription => 'Usajili';

  @override
  String get walletTypeDeposit => 'Amana';

  @override
  String get walletTypeInvestment => 'Uwekezaji';

  @override
  String get walletTypeAsset => 'Mali';

  @override
  String get walletEnterAccountName => 'Tafadhali weka jina la akaunti';

  @override
  String get walletCreditLimitRequired => 'Kikomo cha mkopo kinahitajika';

  @override
  String get walletEnterValidCreditLimit =>
      'Tafadhali weka kikomo halali cha mkopo';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'Tafadhali weka kikomo halali cha mkopo zaidi ya 0';

  @override
  String get walletEditWallet => 'Hariri Pochi';

  @override
  String get walletAddNewWallet => 'Ongeza Pochi Mpya';

  @override
  String get walletEnterWalletNameError => 'Tafadhali weka jina la pochi';

  @override
  String get walletEnterValidNumber => 'Tafadhali weka nambari halali';

  @override
  String get walletShowCents => 'Onyesha senti (mf. \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'Nambari kamili tu (mf. \$1,235)';

  @override
  String get walletCreateWallet => 'Unda Pochi';

  @override
  String get walletClosedPill =>
      'Imefungwa. Historia yake imehifadhiwa, lakini haitolewi wala haihesabiwi.';

  @override
  String get walletExcludedPill => 'Imeachwa nje ya jumla ya akaunti zote.';

  @override
  String get walletReopen => 'Fungua tena';

  @override
  String get walletCloseAccount => 'Funga akaunti';

  @override
  String get walletReopenSubtitle => 'Itoe tena na uihesabu';

  @override
  String get walletCloseAccountSubtitle =>
      'Hifadhi historia yake, acha kuihesabu';

  @override
  String get walletIncludeInTotal => 'Jumuisha kwenye jumla';

  @override
  String get walletLeaveOutOfTotal => 'Acha nje ya jumla';

  @override
  String get walletAlreadyTheBalance => 'Hilo tayari ndilo salio.';

  @override
  String get walletCorrectionRecorded =>
      'Tofauti imerekodiwa kama marekebisho.';

  @override
  String walletMergeConfirmBody(String name) {
    return 'Kila kilichorekodiwa kwenye $name kinahamishwa, na $name inafungwa. Hakuna kinachofutwa.';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'Kiasi kinabadilishwa kutoka $from kwenda $to kinapohamishwa. Hakuna kinachofutwa, na $name inafungwa badala ya kuondolewa.';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount kwenye salio · $available inapatikana';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount deni · $available bado inapatikana';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return 'Weka kiasi ambacho $name inacho kweli. Tofauti inarekodiwa kama muamala, ili akaunti bado ilingane na historia yake.';
  }

  @override
  String get apiUpdateRequired =>
      'Sasisha The Accountant ili kuendelea kusawazisha. Kila kitu kinabaki kwenye simu hii hadi utakaposasisha.';

  @override
  String get apiAccountExistsLink =>
      'Akaunti yenye barua pepe hii tayari ipo. Tafadhali unganisha akaunti zako.';

  @override
  String get apiServerTrouble =>
      'Seva yetu ina tatizo kwa sasa. Kila kitu kiko salama kwenye simu hii; jaribu tena baada ya dakika chache.';

  @override
  String apiRequestFailedHttp(String status) {
    return 'Ombi limeshindwa (HTTP $status).';
  }

  @override
  String get apiServerTimeout =>
      'Seva yetu imechukua muda mrefu kujibu. Angalia muunganisho wako, au jaribu tena baada ya dakika chache.';

  @override
  String get apiCannotReachServer =>
      'Haiwezekani kufikia seva yetu. Angalia muunganisho wako; kama uko mtandaoni, jaribu tena baada ya dakika chache.';

  @override
  String get apiSomethingWentWrong =>
      'Hitilafu imetokea wakati wa kuwasiliana na seva yetu. Tafadhali jaribu tena.';

  @override
  String get syncAlreadyInProgress => 'Usawazishaji tayari unaendelea';

  @override
  String get syncRequiresPremium =>
      'Usawazishaji wa wingu unahitaji usajili wa Premium';

  @override
  String get syncNoInternet => 'Hakuna muunganisho wa intaneti';

  @override
  String get syncNotAuthenticated => 'Hujaingia';

  @override
  String get syncCouldNotFetchCloud =>
      'Imeshindwa kupata data yako ya wingu. Data ya kifaa hiki haijabadilika.';

  @override
  String get syncAccountUnknown =>
      'Imeshindwa kutambua akaunti iliyoingia; usawazishaji umesitishwa.';

  @override
  String get syncStoreOtherAccount =>
      'Data ya kifaa hiki ni ya akaunti nyingine. Ingia kwa akaunti hiyo, au futa data ya kifaa, kabla ya kusawazisha.';

  @override
  String syncRecordsNotSaved(String record) {
    return 'Baadhi ya rekodi za wingu hazikuweza kuhifadhiwa kwenye kifaa hiki: $record. Zitajaribiwa tena katika usawazishaji ujao.';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'Baadhi ya rekodi za wingu hazikuweza kuhifadhiwa kwenye kifaa hiki: $record (na nyingine $count). Zitajaribiwa tena katika usawazishaji ujao.';
  }

  @override
  String notifCardStatementReady(String name) {
    return 'Taarifa ya $name iko tayari';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'Ilifikia $amount, tayari imelipwa. Hakuna kingine kinachodaiwa.';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount inadaiwa kufikia $date.';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$paid kati ya $owed tayari imelipwa.';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return 'Bili ya $name inadaiwa kesho';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return 'Bili ya $name inadaiwa baada ya siku $days';
  }

  @override
  String notifPayBy(String amount, String date) {
    return 'Lipa $amount kufikia $date.';
  }

  @override
  String notifCardDueToday(String name) {
    return 'Bili ya $name inadaiwa leo';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount bado haijalipwa.$paidSoFar Kulipa leo kunaepusha faini ya kuchelewa.';
  }

  @override
  String get notifWhenToday => 'leo';

  @override
  String get notifWhenTomorrow => 'kesho';

  @override
  String notifWhenInDays(int days) {
    return 'baada ya siku $days';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name inalipa $when';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount inatarajiwa kuingia $account tarehe $date.';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name inakomaa $when';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount inarudi kwenye $account tarehe $date.';
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
      'dps': 'amana',
      'insurance': 'ada ya bima',
      'sip': 'SIP',
      'other': 'rejesho',
    });
    return '$name: $_temp0 $number kati ya $total inadaiwa $when';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return 'Wekeza $amount kufikia $date.';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount itawekezwa kutoka $account tarehe $date.';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount itarekodiwa kutoka $account tarehe $date.';
  }

  @override
  String get notifYourAccount => 'akaunti yako';

  @override
  String get notifPlansUpdatedTitle => 'Marejesho na akiba vimesasishwa';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maingizo $count ya mpango yamerekodiwa siku zake.',
      one: 'Ingizo 1 la mpango limerekodiwa siku yake.',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'Miamala inayojirudia imerekodiwa';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miamala $count inayojirudia imerekodiwa.',
      one: 'Muamala 1 unaojirudia umerekodiwa.',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Malipo $count ya kuthibitisha',
      one: 'Malipo 1 ya kuthibitisha',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'Thibitisha kilichokatwa, au kiruke, kwenye Yanayokuja.';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — thibitisha kilichokatwa, au kiruke, kwenye Yanayokuja.';
  }

  @override
  String get notifUpcomingFallbackTitle => 'Muamala Unaokuja';

  @override
  String notifUpcomingTitle(String title) {
    return 'Inakuja: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return 'Mapato ya $amount yanatarajiwa hivi karibuni.';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return 'Matumizi ya $amount yanadaiwa hivi karibuni.';
  }

  @override
  String get notifCreditFallback => 'Mkopo';

  @override
  String get notifDebtFallback => 'Deni';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'Mkopo Uliochelewa: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'Deni Lililochelewa: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount bado inadaiwa. Gusa ili kukagua.';
  }

  @override
  String get notifRecurringFallbackTitle => 'Muamala Unaojirudia';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'Inayojirudia Inakuja: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount inadaiwa tarehe $date.';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'Mkopo Unadaiwa: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'Deni Linadaiwa: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'Usajili Unadaiwa: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'Bili Inadaiwa: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'Inadaiwa Karibuni: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'Bili Inayojirudia';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount inadaiwa hivi karibuni. Gusa ili kukagua.';
  }

  @override
  String get notifChannelRecurring => 'Miamala Inayojirudia';

  @override
  String get notifChannelRecurringDesc =>
      'Arifa za miamala inayojirudia iliyoundwa yenyewe';

  @override
  String get notifChannelUpcoming => 'Vikumbusho vya Yanayokuja';

  @override
  String get notifChannelUpcomingDesc => 'Vikumbusho vya miamala inayokuja';

  @override
  String get notifChannelLoan => 'Vikumbusho vya Mikopo';

  @override
  String get notifChannelLoanDesc =>
      'Vikumbusho vya mikopo na madeni yaliyochelewa';

  @override
  String get notifChannelDueDate => 'Vikumbusho vya Tarehe ya Malipo';

  @override
  String get notifChannelDueDateDesc =>
      'Vikumbusho vya mara moja kwa tarehe maalum za malipo';

  @override
  String get notifChannelBillsDesc =>
      'Bili za kadi ya mkopo na marejesho ya mipango yanayokaribia';

  @override
  String get notifOffset1Hour => 'Saa 1 kabla';

  @override
  String get notifOffset1Day => 'Siku 1 kabla';

  @override
  String get notifOffset3Days => 'Siku 3 kabla';

  @override
  String get notifOffset1Week => 'Wiki 1 kabla';

  @override
  String notifOffsetMinutes(int minutes) {
    return 'Dakika $minutes kabla';
  }

  @override
  String get notifChannelGeneral => 'Jumla';

  @override
  String get notifChannelGeneralDesc => 'Arifa za akaunti na programu';

  @override
  String get notifChannelReminders => 'Vikumbusho vya kila siku';

  @override
  String get notifChannelRemindersDesc =>
      'Kikumbusho cha kurekodi matumizi ya siku';

  @override
  String get notifChannelBillsStatementsDesc =>
      'Taarifa na tarehe za malipo za kadi ya mkopo';

  @override
  String get notifChannelBudgets => 'Arifa za bajeti';

  @override
  String get notifChannelBudgetsDesc => 'Bajeti inapokaribia kuisha au imeisha';

  @override
  String notifOverBudgetTitle(String name) {
    return 'Bajeti imezidi: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'Arifa ya bajeti: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'Umetumia $percent% ya bajeti yako ya $name kwa kipindi hiki.';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'Umetumia $percent% ya bajeti yako ya $name.';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium inaisha hivi karibuni';

  @override
  String get notifPremiumEndsTomorrow =>
      'Premium yako inaisha kesho. Fanya upya ili kubaki na vipengele vya Premium.';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'Premium yako inaisha baada ya siku $days. Fanya upya ili kubaki na vipengele vya Premium.';
  }

  @override
  String get notifLargeIncomeTitle => 'Arifa ya Mapato Makubwa';

  @override
  String get notifLargeExpenseTitle => 'Arifa ya Matumizi Makubwa';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return 'Mapato ya $amount yamerekodiwa: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return 'Mapato ya $amount yamerekodiwa';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return 'Matumizi ya $amount yamerekodiwa: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return 'Matumizi ya $amount yamerekodiwa';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'Arifa za kikumbusho cha matumizi ya kila siku';

  @override
  String get notifDailyReminderTitle => 'Kikumbusho cha Matumizi ya Kila Siku';

  @override
  String get notifDailyReminderBody =>
      'Usisahau kurekodi matumizi yako ya leo! Fuatilia matumizi yako.';

  @override
  String get notifTestTitle => 'Arifa ya Majaribio';

  @override
  String get notifTestBody => 'Ukiona hii, arifa zinafanya kazi!';

  @override
  String get notifActionSnooze1Day => 'Ahirisha siku 1';

  @override
  String get notifActionSnooze1Week => 'Ahirisha wiki 1';

  @override
  String get notifGroupThisWeek => 'Wiki Hii';

  @override
  String get notifGroupThisMonth => 'Mwezi Huu';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date saa $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return 'dakika $count zilizopita';
  }

  @override
  String notifHoursAgo(int count) {
    return 'saa $count zilizopita';
  }

  @override
  String notifDaysAgo(int count) {
    return 'siku $count zilizopita';
  }

  @override
  String get notifPrimerSheetBody =>
      'Washa arifa nasi tutakujulisha mapema kuhusu mambo muhimu.';

  @override
  String get notifPrimerBudgetsBody => 'Jua kabla hujazidisha bajeti.';

  @override
  String get notifPrimerBillsTitle => 'Vikumbusho vya bili na usajili';

  @override
  String get notifPrimerBillsBody => 'Usikose malipo yanayojirudia kamwe.';

  @override
  String get notifPrimerLargeTitle => 'Miamala mikubwa';

  @override
  String get notifPrimerLargeBody =>
      'Pata arifa kuhusu shughuli zisizo za kawaida.';

  @override
  String get notifLoadFailed => 'Imeshindwa kupakia arifa';

  @override
  String get startupReasonSomethingWrong =>
      'Hitilafu imetokea wakati wa kuanzisha. Data yako iko salama kwenye kifaa hiki.';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'Imeshindwa kufungua data ya kifaa ya akaunti hii.';

  @override
  String get startupReasonSetupFailed =>
      'Hatukuweza kumaliza kuandaa akaunti hii kwenye kifaa hiki. Hakuna kilichofutwa.';

  @override
  String get startupReasonOffline =>
      'Hatukuweza kufikia akaunti yako, na kifaa hiki bado hakina data yake. Kama umewahi kutumia The Accountant, unganisha intaneti nasi tutarudisha data yako. Mgeni hapa? Unaweza kuanza kwenye kifaa hiki sasa.';

  @override
  String get startupReasonNeedsSubscription =>
      'Akaunti hii ina data iliyohifadhiwa kwenye wingu. Kuirejesha kunahitaji usajili unaotumika. Hakuna kilichofutwa.';

  @override
  String get startupReasonConfirmingSubscription =>
      'Akaunti hii ina data kwenye wingu. Bado tunathibitisha usajili wako ili irejeshwe.';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'Kurejesha kumeshindwa: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'Akaunti hii ina data kwenye wingu lakini bado haijaweza kurejeshwa.';

  @override
  String get commonBiometricReason =>
      'Thibitisha utambulisho ili kufungua The Accountant';

  @override
  String get commonLoadCurrenciesFailed => 'Imeshindwa kupakia sarafu';

  @override
  String get commonLoadRatesFailed =>
      'Imeshindwa kupakia viwango vya kubadilisha fedha';

  @override
  String get commonRefreshRatesFailed =>
      'Imeshindwa kusasisha viwango vya kubadilisha fedha';

  @override
  String get commonAllCategories => 'Makundi yote';

  @override
  String commonCategoryCount(int count) {
    return 'Makundi $count';
  }

  @override
  String get commonTierFree => 'Bure';

  @override
  String get commonTierMonthly => 'Premium ya Mwezi';

  @override
  String get commonTierYearly => 'Premium ya Mwaka';

  @override
  String get commonTierLifetime => 'Premium ya Maisha';

  @override
  String get commonCategoryMergeSelf =>
      'Kundi haliwezi kuunganishwa na lenyewe.';

  @override
  String get commonCategoryMergeMissing =>
      'Makundi yote mawili lazima yawepo ili kuyaunganisha.';

  @override
  String get commonCategoryMergeSystem =>
      'Makundi ya programu yenyewe hayawezi kuunganishwa.';

  @override
  String get commonCategoryMergeKinds =>
      'Makundi ya mapato na ya matumizi hayawezi kuunganishwa.';

  @override
  String get commonCategoryOneLevel =>
      'Kundi hilo liko ndani ya jingine, na makundi yana ngazi moja tu.';

  @override
  String get commonCategoryMoveSame => 'Chagua kundi jingine la kuyahamishia.';

  @override
  String get commonCategoryMoveMissing =>
      'Makundi yote mawili lazima yawepo ili kuhamisha kati yao.';

  @override
  String get commonCategoryMoveSystem =>
      'Haiwezekani kuhamisha kati ya makundi ya programu yenyewe.';

  @override
  String get commonCategoryMoveKinds =>
      'Miamala ya mapato na ya matumizi haiwezi kubadilishana makundi.';

  @override
  String get commonCategoryGone => 'Kundi hilo halipo tena.';

  @override
  String get commonCategoryParentSystem =>
      'Makundi ya programu yenyewe hayawezi kuhamishwa.';

  @override
  String get commonCategoryParentSelf =>
      'Kundi haliwezi kuwa ndani ya lenyewe.';

  @override
  String get commonCategoryParentIntoSystem =>
      'Hakuna kinachoweza kuwekwa ndani ya makundi ya programu yenyewe.';

  @override
  String get commonCategoryParentKinds =>
      'Kundi la mapato na la matumizi haviwezi kuwekwa kimoja ndani ya kingine.';

  @override
  String get commonCategoryHasChildren =>
      'Kundi hili lina makundi madogo yake, kwa hiyo linabaki ngazi ya juu.';

  @override
  String get commonTapToChange => 'Gusa ili kubadilisha';

  @override
  String get commonSelectColor => 'Chagua rangi';

  @override
  String get commonShowPalette => 'Onyesha rangi';

  @override
  String get commonCustomColor => 'Rangi maalum';

  @override
  String get commonSelectCurrency => 'Chagua sarafu';

  @override
  String get commonEnableCryptoHint =>
      'Washa \'Jumuisha sarafu za kidijitali\' ili kutafuta tokeni za kidijitali.';

  @override
  String get commonSearchHint => 'Tafuta...';

  @override
  String get aiLoadConversationsFailed => 'Imeshindwa kupakia mazungumzo.';

  @override
  String get aiLoadHistoryFailed => 'Imeshindwa kupakia historia ya gumzo.';

  @override
  String get aiPremiumRequired =>
      'Usajili wa Premium unahitajika kwa Msaidizi wa AI';

  @override
  String get aiUnexpectedError =>
      'Hitilafu isiyotarajiwa imetokea. Tafadhali jaribu tena.';

  @override
  String get aiResponseFailed =>
      'Imeshindwa kupata jibu la AI. Tafadhali jaribu tena.';

  @override
  String get aiServiceNotAnswering => 'Huduma ya AI haijibu.';

  @override
  String get aiReplyCutOff => 'Jibu limekatika. Tafadhali jaribu tena.';

  @override
  String get aiCouldNotReachServer =>
      'Imeshindwa kufikia seva. Angalia muunganisho wako na ujaribu tena.';

  @override
  String get aiSomethingWentWrong => 'Hitilafu imetokea.';

  @override
  String get aiOpenConversationFailed => 'Imeshindwa kufungua mazungumzo.';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Mabadiliko yako $count yamehifadhiwa, lakini mshauri ameshindwa kumaliza jibu lake. Yakague kwenye rekodi zako kabla ya kuuliza tena.',
      one:
          'Badiliko lako limehifadhiwa, lakini mshauri ameshindwa kumaliza jibu lake. Likague kwenye rekodi zako kabla ya kuuliza tena.',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'Huduma ya AI haijibu kwa sasa. Tafadhali jaribu tena.';

  @override
  String aiMinutesShort(int count) {
    return 'dak $count';
  }

  @override
  String aiHoursShort(int count) {
    return 'saa $count';
  }

  @override
  String aiDaysShort(int count) {
    return 'siku $count';
  }

  @override
  String get aiOcrTextFailed => 'Imeshindwa kutoa maandishi kwenye picha';

  @override
  String get aiOcrReceiptFailed =>
      'Imeshindwa kutoa taarifa za risiti kwenye picha';

  @override
  String get coachYes => 'ndiyo';

  @override
  String get coachNo => 'hapana';

  @override
  String get coachTradeBuy => 'kununua';

  @override
  String get coachTradeSell => 'kuuza';

  @override
  String get coachTradeDividend => 'gawio';

  @override
  String get planAccountGone => 'Akaunti hiyo haipo tena.';

  @override
  String get planPaidFromOrdinary =>
      'Mpango hulipwa kutoka akaunti ya kawaida, si kutoka kwenye amana.';

  @override
  String get planSipChooseHolding =>
      'Chagua mfuko au hisa ambayo SIP inanunua.';

  @override
  String get planSipPayFromOther => 'Lipia SIP kutoka akaunti nyingine.';

  @override
  String get planNeedNameError => 'Upe mpango jina.';

  @override
  String get planInstallmentCountRange =>
      'Idadi ya marejesho lazima iwe kati ya 1 na 1200.';

  @override
  String get planIntervalMin => 'Muda kati lazima uwe angalau 1.';

  @override
  String get planRateRange => 'Kiwango lazima kiwe kati ya asilimia 0 na 100.';

  @override
  String get planTaxRange => 'Kodi lazima iwe kati ya asilimia 0 na 100.';

  @override
  String get planProviderTooLong =>
      'Weka jina la kampuni na namba chini ya herufi 100.';

  @override
  String get planNeedPremium => 'Weka ada ya bima.';

  @override
  String get planNeedInstallmentAmount => 'Weka kiasi cha kila awamu.';

  @override
  String get planNeedDeposited => 'Weka kiasi kilichowekwa.';

  @override
  String get planTermMonthsOrYears => 'Huchukua miezi au miaka.';

  @override
  String get planAmountNotNegative => 'Kiasi hakiwezi kuwa hasi.';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name inakomaa tarehe $date. Ili kutoa pesa kabla ya hapo, ifunge mapema.';
  }

  @override
  String get planNoLongerExists => 'Mpango huo haupo tena.';

  @override
  String get planReminderDaysRange =>
      'Vikumbusho vinaweza kuwa siku 0 (vimezimwa) hadi 30 kabla.';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name bado ina pesa. Ifunge kwanza, jambo litakalorudisha pesa kwenye $account.';
  }

  @override
  String get planItsAccount => 'akaunti yake';

  @override
  String planAlreadyEnded(String name) {
    return '$name tayari umeisha.';
  }

  @override
  String get investNeedName => 'Upe uwekezaji jina.';

  @override
  String get investNameTooLong => 'Weka jina chini ya herufi 100.';

  @override
  String get investSymbolTooLong => 'Weka alama chini ya herufi 20.';

  @override
  String get investPriceNotNegative => 'Bei haiwezi kuwa hasi.';

  @override
  String investAlreadyTracked(String name) {
    return '$name tayari inafuatiliwa.';
  }

  @override
  String get investNeedPaid => 'Weka kiasi kilicholipwa.';

  @override
  String get investUnitsBoughtPositive =>
      'Vipande vilivyonunuliwa lazima viwe zaidi ya sifuri.';

  @override
  String get investPayFromOther => 'Lipia kutoka akaunti nyingine.';

  @override
  String get investNeedSaleAmount => 'Weka kiasi ulichopata kwa mauzo.';

  @override
  String get investUnitsSoldPositive =>
      'Vipande vilivyouzwa lazima viwe zaidi ya sifuri.';

  @override
  String get investSellIntoOther => 'Uza kwenda akaunti nyingine.';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'Vipande $units tu vya $name vinashikiliwa.';
  }

  @override
  String get investNeedDividend => 'Weka gawio lililopokelewa.';

  @override
  String get investReceiveIntoOrdinary => 'Pokea kwenye akaunti ya kawaida.';

  @override
  String get investPricePositive => 'Bei lazima iwe zaidi ya sifuri.';

  @override
  String get investUnitsPositive => 'Vipande lazima viwe zaidi ya sifuri.';

  @override
  String get investNotATrade => 'Huo si muamala wa uwekezaji.';

  @override
  String investStillHoldsUnits(String name) {
    return '$name bado ina vipande. Viuze kwanza.';
  }

  @override
  String get investNoLongerExists => 'Uwekezaji huo haupo tena.';

  @override
  String get networthNeedAssetName => 'Ipe mali jina.';

  @override
  String get networthValueNotNegative => 'Thamani haiwezi kuwa hasi.';

  @override
  String get networthNeedPaidFor => 'Weka kiasi kilicholipwa kwa ajili yake.';

  @override
  String get networthPayFromOrdinary => 'Lipia kutoka akaunti ya kawaida.';

  @override
  String get networthNeedWorth => 'Weka thamani yake.';

  @override
  String get networthNeedSoldFor => 'Weka bei iliyouzwa.';

  @override
  String get networthReceiveIntoOrdinary =>
      'Pokea pesa kwenye akaunti ya kawaida.';

  @override
  String networthStillWorth(String name) {
    return '$name bado ina thamani. Iuze kwanza, au weka thamani yake kuwa sifuri.';
  }

  @override
  String get networthAssetGone => 'Mali hiyo haifuatiliwi tena.';

  @override
  String get zakatNeedAmountPaid => 'Weka kiasi kilicholipwa.';

  @override
  String get zakatPayFromOrdinary => 'Ilipe kutoka akaunti ya kawaida.';

  @override
  String get zakatReminderTitleToday => 'Zaka yako inadaiwa leo';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zaka inadaiwa baada ya siku $count',
      one: 'Zaka inadaiwa baada ya siku 1',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'Mwaka wako wa zaka unakamilika leo. Gusa kuona kinachodaiwa.';

  @override
  String zakatReminderBodyOn(String date) {
    return 'Mwaka wako wa zaka unakamilika $date. Gusa kuona kinachodaiwa.';
  }

  @override
  String get budgetCheckFailed => 'Imeshindwa kukagua bajeti';

  @override
  String get budgetLoadFailed => 'Imeshindwa kupakia bajeti';

  @override
  String get budgetAddFailed => 'Imeshindwa kuongeza bajeti';

  @override
  String get budgetNotFound => 'Bajeti haikupatikana';

  @override
  String get budgetUpdateFailed => 'Imeshindwa kusasisha bajeti';

  @override
  String get budgetDeleteFailed => 'Imeshindwa kufuta bajeti';

  @override
  String get budgetEdit => 'Hariri bajeti';

  @override
  String get budgetNeedName => 'Ipe bajeti jina';

  @override
  String get budgetEnterAmount => 'Weka kiasi';

  @override
  String get budgetAmountMoreThanZero => 'Kiasi lazima kiwe zaidi ya sifuri';

  @override
  String get budgetTrackingEarnings => 'Kufuatilia mapato';

  @override
  String get budgetTrackingSpending => 'Kufuatilia matumizi';

  @override
  String get budgetRepeats => 'Inajirudia';

  @override
  String get budgetTooBig => 'Kubwa mno';

  @override
  String get budgetStarts => 'Inaanza';

  @override
  String get budgetEnds => 'Inaisha';

  @override
  String get budgetStopsRepeating => 'Inaacha kujirudia';

  @override
  String get budgetNever => 'Kamwe';

  @override
  String get budgetCategoriesAll => 'Makundi: yote';

  @override
  String budgetCategoriesSelected(int count) {
    return 'Makundi: $count yamechaguliwa';
  }

  @override
  String get budgetNoIncomeCategories => 'Bado hakuna makundi ya mapato.';

  @override
  String get budgetNoExpenseCategories => 'Bado hakuna makundi ya matumizi.';

  @override
  String get budgetCategoriesHint =>
      'Acha wazi ili kufuatilia kila kundi. Chochote kilichowekwa ndani ya kundi lililochaguliwa nacho kinahesabiwa.';

  @override
  String get budgetAccountsAll => 'Akaunti: zote';

  @override
  String budgetAccountsSelected(int count) {
    return 'Akaunti: $count zimechaguliwa';
  }

  @override
  String get budgetRolloverHint =>
      'Chochote kisichotumika huongezwa kwenye kipindi kijacho. Kuzidi hakuhamishi deni mbele.';

  @override
  String get budgetPeriodDaily => 'Kila siku';

  @override
  String get budgetPeriodFortnightly => 'Kila wiki mbili';

  @override
  String get budgetPeriodOneOff => 'Mara moja';

  @override
  String get budgetUnitDays => 'siku';

  @override
  String get budgetUnitWeeks => 'wiki';

  @override
  String get budgetUnitFortnights => 'wiki mbili';

  @override
  String get budgetUnitMonths => 'miezi';

  @override
  String get budgetUnitYears => 'miaka';

  @override
  String get budgetOneOffNeedsEnd =>
      'Bajeti ya mara moja inahitaji tarehe ya mwisho.';

  @override
  String get budgetEndAfterStart =>
      'Tarehe ya mwisho lazima iwe baada ya tarehe ya kuanza.';

  @override
  String get budgetSaveFailed => 'Imeshindwa kuhifadhi bajeti.';

  @override
  String get budgetThisPeriod => 'Kipindi hiki';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vipindi $count vilivyopita',
      one: 'Kipindi 1 kilichopita',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start hadi $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'kati ya $limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'kati ya $limit ikijumuisha $carried kilichohamishwa';
  }

  @override
  String get budgetUncategorised => 'Bila kundi';

  @override
  String budgetOverTheLimit(String amount) {
    return '$amount zaidi ya kikomo.';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left imebaki, takriban $daily kwa siku.';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left imebaki.';
  }

  @override
  String budgetAveraging(String amount) {
    return 'Wastani wa $amount kwa kipindi.';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'Inaelekea kuzidi kwa $amount';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'Kwa kasi hii, ukihesabu $scheduled kilichopangwa kabla kipindi hakijaisha.';
  }

  @override
  String get budgetForecastPlain => 'Kwa kasi hii, kufikia mwisho wa kipindi.';

  @override
  String get budgetCapsExplain =>
      'Bajeti inaonyesha kama kipindi kimezidi matumizi. Kikomo kinaonyesha wapi: bajeti ya chakula iliyo sawa kwa jumla bado inaweza kuwa zaidi chakula cha kununua nje.';

  @override
  String get budgetPercentOfBudget => 'Asilimia ya bajeti';

  @override
  String get budgetArchivedTitle => 'Bajeti zilizohifadhiwa';

  @override
  String get budgetShowActive => 'Onyesha zinazotumika';

  @override
  String get budgetShowArchived => 'Onyesha zilizohifadhiwa';

  @override
  String get budgetUnpin => 'Bandua';

  @override
  String get budgetPinToTop => 'Bandika juu';

  @override
  String get budgetStartCounting => 'Anza kuihesabu tena';

  @override
  String get budgetStopCounting => 'Hifadhi historia yake, acha kuihesabu';

  @override
  String get budgetDeleteBody =>
      'Bajeti inaondoka, miamala yako inabaki. Hakuna ulichorekodi kitakachoondolewa.';

  @override
  String get budgetNothingArchived => 'Hakuna kilichohifadhiwa';

  @override
  String get budgetNoneYet => 'Bado hakuna bajeti';

  @override
  String get budgetArchivedEmptyHint => 'Bajeti unazohifadhi zinawekwa hapa.';

  @override
  String get budgetEmptyHint =>
      'Weka kikomo kwa kundi na uone mwezi unavyokwenda.';

  @override
  String dashLoadFailed(String error) {
    return 'Imeshindwa kupakia data za fedha: $error';
  }

  @override
  String get categoryUnknown => 'Haijulikani';

  @override
  String dashCardAvailable(String amount) {
    return 'Inayopatikana: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'Ina salio la ziada · Inayopatikana: $amount';
  }

  @override
  String get dashTypeBank => 'Benki';

  @override
  String get dashTypeCredit => 'Mkopo';

  @override
  String get dashTypeSubs => 'Usajili';

  @override
  String get dashTypeDeposit => 'Amana';

  @override
  String get dashTypeInvest => 'Uwekezaji';

  @override
  String get dashTypeAsset => 'Mali';

  @override
  String get dashAddAccountTile => 'Ongeza\nAkaunti';

  @override
  String get categoryLoadFailed => 'Imeshindwa kupakia makundi';

  @override
  String get categoryAddFailed => 'Imeshindwa kuongeza kundi';

  @override
  String get categoryNotFound => 'Kundi halikupatikana';

  @override
  String get categoryUpdateFailed => 'Imeshindwa kusasisha kundi';

  @override
  String get categoryCannotDeleteSystem =>
      'Huwezi kufuta makundi ya programu yenyewe';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'Huwezi kufuta kundi lenye miamala; ihamishe au uifute kwanza';

  @override
  String get categoryDeleteFailed => 'Imeshindwa kufuta kundi';

  @override
  String categorySaveFailed(String error) {
    return 'Imeshindwa kuhifadhi kundi: $error';
  }

  @override
  String get categoryEditTitle => 'Hariri Kundi';

  @override
  String get categoryNewTitle => 'Kundi Jipya';

  @override
  String get categoryPartOf => 'Sehemu ya';

  @override
  String get categoryNamePlaceholder => 'Jina la Kundi';

  @override
  String get categoryUpdate => 'Sasisha Kundi';

  @override
  String get categoryCreate => 'Unda Kundi';

  @override
  String reportLoadFailed(String error) {
    return 'Imeshindwa kupakia ripoti: $error';
  }

  @override
  String get goalEdit => 'Hariri lengo';

  @override
  String get goalNeedName => 'Lipe lengo jina';

  @override
  String get goalTargetMoreThanZero => 'Lengo lazima liwe zaidi ya sifuri';

  @override
  String get goalNoDeadline => 'Hakuna tarehe ya mwisho';

  @override
  String get goalTargetDateAfterStart =>
      'Tarehe ya lengo lazima iwe baada ya tarehe ya kuanza.';

  @override
  String get goalSaveFailed => 'Imeshindwa kuhifadhi lengo.';

  @override
  String get goalArchivedTitle => 'Malengo yaliyohifadhiwa';

  @override
  String get goalHideFromHome => 'Ficha kwenye mwanzo';

  @override
  String get goalShowOnHome => 'Onyesha kwenye mwanzo';

  @override
  String get goalReached => 'Limefikiwa';

  @override
  String goalToGo(String amount) {
    return '$amount zimebaki';
  }

  @override
  String get goalNoneYet => 'Bado hakuna malengo';

  @override
  String get goalArchivedEmptyHint => 'Malengo unayohifadhi yanawekwa hapa.';

  @override
  String get goalEmptyHint =>
      'Taja kitu unachoweka akiba kwa ajili yake, kisha unganisha miamala inayokichangia.';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$saved kati ya $target';
  }

  @override
  String goalOfTarget(String target) {
    return 'kati ya $target';
  }

  @override
  String get goalReachedNicelyDone => 'Limefikiwa. Hongera.';

  @override
  String goalStillToGo(String amount) {
    return 'Bado $amount zimebaki.';
  }

  @override
  String goalDailyToArrive(String amount) {
    return '$amount kwa siku ili kufika kwa wakati.';
  }

  @override
  String get goalNothingLinked =>
      'Bado hakuna kilichounganishwa. Chagua lengo hili kwenye muamala nao utaonekana hapa.';

  @override
  String get goalDeleteBody =>
      'Lengo linaondoka, miamala yako inabaki. Haitahesabiwa tena kwa lengo hilo.';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Malipo $count ya $amount',
      one: 'Malipo 1 ya $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'Itakamilika karibu $date.';
  }

  @override
  String goalNotFound(String id) {
    return 'Lengo halikupatikana: $id';
  }

  @override
  String get goalPaidOff => 'Imelipwa yote!';

  @override
  String get goalCompleted => 'Imekamilika!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% imekamilika';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wiki $count zimebaki',
      one: 'Wiki 1 imebaki',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Miezi $count imebaki',
      one: 'Mwezi 1 umebaki',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return 'Miaka $years imebaki';
  }

  @override
  String get subRecurringBill => 'Bili Inayojirudia';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila siku $count',
      one: 'Kila siku 1',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila wiki $count',
      one: 'Kila wiki 1',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila miezi $count',
      one: 'Kila mwezi 1',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kila miaka $count',
      one: 'Kila mwaka 1',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'Kila $unit $count';
  }

  @override
  String subLoadFailed(String error) {
    return 'Imeshindwa kupakia usajili: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'Imeshindwa kusitisha usajili: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'Imeshindwa kuendeleza usajili: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'Imeshindwa kusasisha usajili: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'Imeshindwa kughairi usajili: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'Zinazotumika ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'Zimesitishwa ($count)';
  }

  @override
  String get subEmptyTitle => 'Hakuna usajili wala bili';

  @override
  String get subEmptyBody =>
      'Ongeza miamala ya usajili au bili zinazojirudia ili kuzifuatilia hapa';

  @override
  String get subRecurringCost => 'Gharama Zinazojirudia';

  @override
  String subPerYear(String amount) {
    return '$amount / mwaka';
  }

  @override
  String get subActive => 'Zinazotumika';

  @override
  String subNext(String date) {
    return 'Inayofuata $date';
  }

  @override
  String get subResume => 'Endeleza';

  @override
  String get subPause => 'Sitisha';

  @override
  String get subCancelBillTitle => 'Ghairi Bili Inayojirudia';

  @override
  String get subCancelSubTitle => 'Ghairi Usajili';

  @override
  String subCancelConfirm(String name) {
    return 'Una uhakika unataka kughairi \"$name\"? Hii itasimamisha malipo yote yanayojirudia ya baadaye.';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" imeghairiwa';
  }

  @override
  String subSaveError(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String get subEditBill => 'Hariri Bili Inayojirudia';

  @override
  String get subEditSub => 'Hariri Usajili';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'siku',
      one: 'siku',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wiki',
      one: 'wiki',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miezi',
      one: 'mwezi',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miaka',
      one: 'mwaka',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'Inaisha: $date';
  }

  @override
  String get subNoEndDate => 'Hakuna tarehe ya mwisho';
}
