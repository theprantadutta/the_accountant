// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class L10nMs extends L10n {
  L10nMs([String locale = 'ms']) : super(locale);

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionConfirm => 'Sahkan';

  @override
  String get dateToday => 'Hari ini';

  @override
  String get dateYesterday => 'Semalam';

  @override
  String get dateTomorrow => 'Esok';

  @override
  String get navTransactions => 'Transaksi';

  @override
  String get settingsRegionalTitle => 'Tetapan Serantau';

  @override
  String get settingsSectionCurrency => 'MATA WANG';

  @override
  String get settingsSectionDisplayFormat => 'FORMAT PAPARAN';

  @override
  String get settingsSectionLanguage => 'BAHASA';

  @override
  String get settingsDefaultCurrency => 'Mata Wang Lalai';

  @override
  String get settingsExchangeRates => 'Kadar Pertukaran';

  @override
  String get settingsExchangeRatesSubtitle => 'Urus kadar penukaran mata wang';

  @override
  String get settingsDateFormat => 'Format Tarikh';

  @override
  String get settingsNumberFormat => 'Format Nombor';

  @override
  String get settingsCurrencySymbol => 'Simbol Mata Wang';

  @override
  String get settingsTimeFormat => 'Format Masa';

  @override
  String get settingsFirstDayOfWeek => 'Hari Pertama Minggu';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsPreview => 'Pratonton';

  @override
  String get previewDate => 'Tarikh';

  @override
  String get previewTime => 'Masa';

  @override
  String get previewAmount => 'Jumlah';

  @override
  String get previewWeekStarts => 'Minggu ini bermula';

  @override
  String get choiceMatchMyPhone => 'Ikut telefon saya';

  @override
  String get symbolBeforeAmount => 'Sebelum jumlah';

  @override
  String get symbolAfterAmount => 'Selepas jumlah';

  @override
  String get time12Hour => '12 jam (1:30 PTG)';

  @override
  String get time24Hour => '24 jam (13:30)';

  @override
  String get weekdayMonday => 'Isnin';

  @override
  String get weekdaySaturday => 'Sabtu';

  @override
  String get weekdaySunday => 'Ahad';

  @override
  String get selectDateFormat => 'Pilih Format Tarikh';

  @override
  String get selectNumberFormat => 'Pilih Format Nombor';

  @override
  String get selectCurrency => 'Pilih Mata Wang';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get languageSystem => 'Ikut telefon saya';

  @override
  String get sectionAccount => 'AKAUN';

  @override
  String get sectionDataManagement => 'PENGURUSAN DATA';

  @override
  String get sectionHelpSupport => 'BANTUAN & SOKONGAN';

  @override
  String get settingsAppearance => 'Penampilan';

  @override
  String get settingsBackupRestore => 'Sandaran & Pemulihan';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Fail yang anda simpan, atau salinan automatik dalam Google Drive';

  @override
  String get settingsImportStatement => 'Import penyata';

  @override
  String get settingsImportStatementSubtitle =>
      'Bawa masuk CSV daripada bank anda, dipetakan sekali dan diingati';

  @override
  String get settingsExportData => 'Eksport Data';

  @override
  String get settingsRecentlyDeleted => 'Dipadam baru-baru ini';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'Pulihkan item yang dipadam dalam tiga puluh hari lalu';

  @override
  String get themePremiumHeading => 'Tema Premium';

  @override
  String get actionRetry => 'Cuba lagi';

  @override
  String get dashCreditDebt => 'Kredit & Hutang';

  @override
  String get dashSubscriptions => 'Langganan';

  @override
  String get moneyIncome => 'Pendapatan';

  @override
  String get dashExpenses => 'Perbelanjaan';

  @override
  String get dashSpendingOverview => 'Gambaran Perbelanjaan';

  @override
  String get dashBudgetProgress => 'Kemajuan Bajet';

  @override
  String get actionDelete => 'Padam';

  @override
  String txDeleteManyTitle(int count) {
    return 'Padam $count transaksi?';
  }

  @override
  String get txDeleteManyBody =>
      'Baki akan dikira semula. Sebarang pindahan di antaranya turut membawa separuh lagi bersamanya.';

  @override
  String get txMoveToAccount => 'Pindah ke akaun';

  @override
  String get txDeleted => 'Transaksi dipadam';

  @override
  String txDeleteFailed(String error) {
    return 'Tidak dapat memadam transaksi itu: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get txActions => 'Tindakan';

  @override
  String get txChangeCategory => 'Tukar kategori';

  @override
  String get txChangeDate => 'Tukar tarikh';

  @override
  String get txMarkAsPaid => 'Tandakan sudah dibayar';

  @override
  String get txMarkAsCorrection => 'Tandakan sebagai pembetulan baki';

  @override
  String get txMarkAsCorrectionTitle => 'Bukan pendapatan atau perbelanjaan?';

  @override
  String get txMarkAsCorrectionBody =>
      'Gunakan ini untuk wang yang tidak diperoleh atau dibelanjakan, seperti had kad yang dinaikkan. Baki kekal sama; ia cuma tidak lagi dikira sebagai pendapatan atau perbelanjaan.';

  @override
  String get txMarkedAsCorrection => 'Kini pembetulan baki.';

  @override
  String get txMarkAsCorrectionFailed =>
      'Transaksi ini tidak boleh dijadikan pembetulan.';

  @override
  String get txDuplicate => 'Pendua';

  @override
  String get filterTitle => 'Tapis';

  @override
  String get filterDirection => 'Arah';

  @override
  String get filterState => 'Status';

  @override
  String get filterKind => 'Jenis';

  @override
  String get filterTransfers => 'Pindahan';

  @override
  String get filterAccounts => 'Akaun';

  @override
  String get filterCategories => 'Kategori';

  @override
  String get filterDates => 'Tarikh';

  @override
  String get filterBudget => 'Bajet';

  @override
  String get filterGoal => 'Matlamat';

  @override
  String get filterNone => 'Tiada';

  @override
  String get filterThisMonth => 'Bulan ini';

  @override
  String get filterLastMonth => 'Bulan lepas';

  @override
  String get filterLast3Months => '3 bulan lepas';

  @override
  String get filterThisYear => 'Tahun ini';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tunjuk $count transaksi',
      one: 'Tunjuk 1 transaksi',
      zero: 'Tiada transaksi sepadan',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Kosongkan';

  @override
  String get filterNoMatches => 'Tiada padanan';

  @override
  String get filterAny => 'Mana-mana';

  @override
  String get filterSpent => 'Dibelanjakan';

  @override
  String get filterEarned => 'Diperoleh';

  @override
  String get filterHidden => 'Tersembunyi';

  @override
  String get filterIncluded => 'Disertakan';

  @override
  String get filterOnly => 'Sahaja';

  @override
  String get filterFrom => 'Dari';

  @override
  String get filterTo => 'Hingga';

  @override
  String get actionApply => 'Guna';

  @override
  String get filterPaid => 'Dibayar';

  @override
  String get filterNotYet => 'Belum';

  @override
  String get filterSkipped => 'Dilangkau';

  @override
  String get filterAmount => 'Jumlah';

  @override
  String get actionEdit => 'Sunting';

  @override
  String get entityBudget => 'Bajet';

  @override
  String get budgetGone => 'Bajet ini tidak wujud lagi.';

  @override
  String get budgetEarlier => 'Sebelumnya';

  @override
  String get budgetLater => 'Kemudian';

  @override
  String get budgetWhereItWent => 'Ke mana ia pergi';

  @override
  String get budgetRecentPeriods => 'Tempoh terkini';

  @override
  String get budgetCaps => 'Had';

  @override
  String get actionAdd => 'Tambah';

  @override
  String get budgetNoCategoriesToCap =>
      'Bajet ini belum ada kategori untuk dihadkan.';

  @override
  String get budgetCapACategory => 'Hadkan kategori';

  @override
  String get entityCategory => 'Kategori';

  @override
  String get budgetAsShare => 'Sebagai bahagian bajet';

  @override
  String get budgetAsShareHint =>
      'Berubah bersama bajet apabila anda mengubahnya';

  @override
  String get actionSet => 'Tetapkan';

  @override
  String get budgetAcrossPeriod => 'Sepanjang tempoh';

  @override
  String get budgetPreviousPeriod => 'Tempoh sebelumnya';

  @override
  String get budgetEvenPace => 'Kadar sekata';

  @override
  String get budgetNew => 'Bajet baharu';

  @override
  String get budgetCreate => 'Cipta bajet';

  @override
  String budgetDeleteTitle(String name) {
    return 'Padam $name?';
  }

  @override
  String get entityAccount => 'Akaun';

  @override
  String get entityTransaction => 'Transaksi';

  @override
  String get walletGone => 'Akaun ini tidak wujud lagi.';

  @override
  String get walletCorrectBalance => 'Betulkan baki';

  @override
  String get walletCorrectBalanceSubtitle =>
      'Rekodkan perbezaan daripada angka sebenar';

  @override
  String get walletMergeInto => 'Gabung ke akaun lain';

  @override
  String get walletInThisMonth => 'Masuk bulan ini';

  @override
  String get walletOutThisMonth => 'Keluar bulan ini';

  @override
  String get walletRecentActivity => 'Aktiviti terkini';

  @override
  String get walletNoOtherAccount => 'Tiada akaun lain untuk digabungkan.';

  @override
  String get walletMergeIntoTitle => 'Gabung ke';

  @override
  String get walletMergeAction => 'Gabung';

  @override
  String walletMerged(int count, String target) {
    return '$count dipindahkan ke $target.';
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
      other: '$removed pindahan antara kedua-dua akaun telah dibuang',
      one: 'Satu pindahan antara kedua-dua akaun telah dibuang',
    );
    return '$count dipindahkan ke $target. $_temp0, kerana ia tidak lagi mempunyai dua hujung.';
  }

  @override
  String get walletRealBalance => 'Baki sebenar';

  @override
  String get walletCorrectAction => 'Betulkan';

  @override
  String get txGone => 'Transaksi ini tidak wujud lagi.';

  @override
  String get txKind => 'Jenis';

  @override
  String get txState => 'Status';

  @override
  String get txWasDue => 'Tarikh matang';

  @override
  String get txNotes => 'Nota';

  @override
  String get txDeleteOneTitle => 'Padam transaksi ini?';

  @override
  String get rulesTitle => 'Peraturan penamaan';

  @override
  String get rulesAdd => 'Tambah peraturan';

  @override
  String rulesRemoved(String title) {
    return 'Peraturan untuk $title dibuang';
  }

  @override
  String get rulesWhenTitleSays => 'Apabila tajuk menyebut';

  @override
  String get rulesMatchExactly => 'Padanan tepat';

  @override
  String get rulesChooseCategory => 'Pilih kategori';

  @override
  String get actionSave => 'Simpan';

  @override
  String get goalNew => 'Matlamat baharu';

  @override
  String get goalLoadFailed => 'Tidak dapat memuatkan matlamat anda.';

  @override
  String get goalCreate => 'Cipta matlamat';

  @override
  String get trashTitle => 'Dipadam baru-baru ini';

  @override
  String get trashRestore => 'Pulihkan';

  @override
  String get trashRestored => 'Dipulihkan.';

  @override
  String get payTitle => 'Kaedah pembayaran';

  @override
  String get payDefault => 'Lalai';

  @override
  String get payAddOne => 'Tambah satu';

  @override
  String payDeleteTitle(String name) {
    return 'Padam $name?';
  }

  @override
  String get payName => 'Nama';

  @override
  String get payNameHint => 'Debit harian';

  @override
  String get payKind => 'Jenis';

  @override
  String get payBankOrIssuer => 'Bank atau pengeluar';

  @override
  String get payLastFour => 'Empat digit terakhir';

  @override
  String get payUseByDefault => 'Guna secara lalai';

  @override
  String get backupChecking => 'Menyemak…';

  @override
  String get backupLoading => 'Memuatkan…';

  @override
  String get backupSaveACopy => 'Simpan salinan';

  @override
  String get backupAutomaticBackups => 'Sandaran automatik';

  @override
  String get backupHowManyBackupsToKeep => 'Bilangan sandaran untuk disimpan';

  @override
  String get backupSaveABackupFile => 'Simpan fail sandaran';

  @override
  String get backupShareItToFilesEmail =>
      'Kongsi ke Fail, e-mel, atau mana-mana tempat';

  @override
  String get backupRestoreFromAFile => 'Pulihkan daripada fail';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Menggantikan semua data pada peranti ini';

  @override
  String get backupRestoreThisBackup => 'Pulihkan sandaran ini?';

  @override
  String get backupEraseRestore => 'Padam & Pulihkan';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive tidak tersedia';

  @override
  String get backupConnectGoogleDrive => 'Sambung Google Drive';

  @override
  String get backupBackUpNow => 'Sandar sekarang';

  @override
  String get backupKeep => 'Simpan';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'Sandaran automatik terakhir tidak berjalan';

  @override
  String get backupDisconnectGoogleDrive => 'Putuskan Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'Putuskan sambungan Google Drive?';

  @override
  String get backupDisconnect => 'Putuskan';

  @override
  String get backupDeleteThisBackup => 'Padam sandaran ini?';

  @override
  String get importChooseACsvFile => 'Pilih fail CSV';

  @override
  String get importRememberTheseSettingsForThis =>
      'Ingat tetapan ini untuk bank ini';

  @override
  String get importChange => 'Tukar';

  @override
  String get importAuto => 'Auto';

  @override
  String get importDone => 'Selesai';

  @override
  String get importRememberThisBank => 'Ingat bank ini';

  @override
  String get importForget => 'Lupakan';

  @override
  String get importImport => 'Import';

  @override
  String get settingsAbout => 'Perihal';

  @override
  String get settingsPrivacyPolicy => 'Dasar Privasi';

  @override
  String get settingsTermsOfService => 'Terma Perkhidmatan';

  @override
  String get settingsRefundPolicy => 'Dasar Bayaran Balik';

  @override
  String get settingsOpenSourceLicenses => 'Lesen Sumber Terbuka';

  @override
  String get settingsMeetTheDeveloper => 'Kenali Pembangun';

  @override
  String get settingsContactSupport => 'Hubungi Sokongan';

  @override
  String get settingsSubject => 'Subjek';

  @override
  String get settingsMessage => 'Mesej';

  @override
  String get settingsSendMessage => 'Hantar mesej';

  @override
  String get settingsUseApiRate => 'Guna Kadar API';

  @override
  String get settingsRefreshRates => 'Muat semula kadar';

  @override
  String get settingsSearchCurrencies => 'Cari mata wang...';

  @override
  String get settingsCustomRate => 'Kadar tersuai';

  @override
  String get settingsSetCustomRate => 'Tetapkan kadar tersuai';

  @override
  String get settingsNotNow => 'Bukan sekarang';

  @override
  String get settingsGoPremium => 'Langgan Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Format hamparan untuk Excel, Google Sheets';

  @override
  String get settingsPdfReport => 'Laporan PDF';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Ringkasan berformat dengan pecahan';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'Semua rekod pendapatan dan perbelanjaan';

  @override
  String get settingsCategories => 'Kategori';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Pecahan dan jumlah mengikut kategori';

  @override
  String get settingsWallets => 'Dompet';

  @override
  String get settingsWalletBalancesAndHistory => 'Baki dan sejarah dompet';

  @override
  String get settingsHelpFaq => 'Bantuan & Soalan Lazim';

  @override
  String get settingsNotifications => 'Pemberitahuan';

  @override
  String get settingsLargeTransactionThreshold => 'Had Transaksi Besar';

  @override
  String get settingsRemindMeBeforeDueDate => 'Ingatkan Sebelum Tarikh Akhir';

  @override
  String get settingsDailyReminders => 'PERINGATAN HARIAN';

  @override
  String get settingsDailyReminders2 => 'Peringatan Harian';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Dapatkan peringatan untuk merekod perbelanjaan';

  @override
  String get settingsBudgetAlerts => 'AMARAN BAJET';

  @override
  String get settingsBudgetAlerts2 => 'Amaran Bajet';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'Maklumkan apabila menghampiri had bajet';

  @override
  String get settingsWarningThreshold => 'Ambang Amaran';

  @override
  String get settingsTransactionAlerts => 'AMARAN TRANSAKSI';

  @override
  String get settingsLargeTransactionAlerts => 'Amaran Transaksi Besar';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'Maklumkan transaksi melebihi ambang';

  @override
  String get settingsRecurringTransactionReminders =>
      'Peringatan Transaksi Berulang';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'Ingatkan tentang bayaran berulang yang akan datang';

  @override
  String get settingsOtherNotifications => 'PEMBERITAHUAN LAIN';

  @override
  String get settingsSubscriptionExpiryAlerts => 'Amaran Tamat Langganan';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Dapatkan makluman sebelum Premium anda tamat';

  @override
  String get settingsPromotionalNotifications => 'Pemberitahuan Promosi';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Terima tawaran dan kemas kini ciri';

  @override
  String get settingsTurnOnDailyReminders => 'Hidupkan peringatan harian?';

  @override
  String get settingsEnterAmount => 'Masukkan jumlah';

  @override
  String get settingsReminderTime => 'Masa Peringatan';

  @override
  String get settingsPrivacySecurity => 'Privasi & Keselamatan';

  @override
  String get settingsSecurity => 'KESELAMATAN';

  @override
  String get settingsBiometricLock => 'Kunci Biometrik';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Guna cap jari atau wajah untuk membuka kunci';

  @override
  String get settingsAutoLock => 'Kunci automatik';

  @override
  String get settingsDataPrivacy => 'PRIVASI DATA';

  @override
  String get settingsClearCache => 'Kosongkan Cache';

  @override
  String get settingsClearCachedDataAndForce =>
      'Kosongkan data cache dan paksa segerak semula';

  @override
  String get settingsClearAllData => 'Kosongkan Semua Data';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Padam semua transaksi, bajet dan tetapan';

  @override
  String get settingsDangerZone => 'ZON BAHAYA';

  @override
  String get settingsDeleteAccount => 'Padam Akaun';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Padam akaun anda dan semua data secara kekal';

  @override
  String get settingsAutoLockTimeout => 'Tempoh Kunci Automatik';

  @override
  String get settingsDeleteEverything => 'Padam Semuanya';

  @override
  String get settingsAreYouAbsolutelySure => 'Anda benar-benar pasti?';

  @override
  String get settingsYesDeleteAll => 'Ya, Padam Semua';

  @override
  String get settingsContinue => 'Teruskan';

  @override
  String get settingsEditProfile => 'Sunting Profil';

  @override
  String get settingsDisplayName => 'Nama paparan';

  @override
  String get settingsEmailAddress => 'Alamat e-mel';

  @override
  String get settingsUnsavedChanges => 'Perubahan Belum Disimpan';

  @override
  String get settingsStay => 'Kekal';

  @override
  String get settingsLeave => 'Keluar';

  @override
  String get settingsSearchByCodeOrName => 'Cari mengikut kod atau nama...';

  @override
  String get settingsSearchSettings => 'Cari tetapan...';

  @override
  String get settingsSubscription => 'Langganan';

  @override
  String get settingsSignOut => 'Log Keluar';

  @override
  String get settingsGoals => 'Matlamat';

  @override
  String get settingsCardsInNetWorth => 'Kira kad kredit dalam nilai bersih';

  @override
  String get settingsCardsInNetWorthSub =>
      'Mati: hanya wang yang anda ada dikira, bukan baki kad.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Simpan untuk sesuatu dan jejaki sejauh mana kemajuan anda';

  @override
  String get settingsBudgets => 'Bajet';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Tetapkan had dan lihat perkembangan tempoh ini';

  @override
  String get settingsUpcomingAndOverdue => 'Akan datang dan tertunggak';

  @override
  String get settingsWhatIsDueAndWhat =>
      'Apa yang perlu dibayar, dan apa yang terlepas';

  @override
  String get settingsAccounts => 'Akaun';

  @override
  String get settingsAddReorderAndEditYour =>
      'Tambah, susun semula dan sunting akaun anda';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'Kad dan akaun yang anda guna untuk membayar';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Ke mana sesuatu pergi, berdasarkan namanya';

  @override
  String get settingsNotificationSettings => 'Tetapan Pemberitahuan';

  @override
  String get settingsCloudSync => 'Segerak Awan';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Segerakkan data anda merentas peranti';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV percuma · Laporan PDF untuk Premium';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Soalan, aduan atau maklum balas';

  @override
  String get settingsRateTheApp => 'Nilaikan Aplikasi';

  @override
  String get settingsShareWithFriends => 'Kongsi dengan Rakan';

  @override
  String get settingsReplayAppTour => 'Main Semula Lawatan Aplikasi';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'Lihat panduan ciri sekali lagi';

  @override
  String get settingsAboutTheAccountant => 'Perihal The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Versi, lesen dan lain-lain';

  @override
  String get settingsTestCrash => 'Uji Ranap';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Cetuskan pengecualian ujian untuk Crashlytics';

  @override
  String get settingsDeveloper => 'PEMBANGUN';

  @override
  String get settingsRestoreFromCloud => 'Pulihkan daripada Awan?';

  @override
  String get settingsSyncing => 'Menyegerak...';

  @override
  String get settingsSynced => 'Disegerakkan';

  @override
  String get settingsSyncError => 'Ralat Segerak';

  @override
  String get syncBackgroundFailed =>
      'Tidak dapat menyegerak. Perubahan anda selamat pada peranti ini dan akan disegerakkan kemudian.';

  @override
  String get settingsOffline => 'Luar talian';

  @override
  String get settingsReady => 'Sedia';

  @override
  String get settingsYesUseThis => 'Ya, guna ini';

  @override
  String get settingsKeepThemSeparate => 'Asingkan kedua-duanya?';

  @override
  String get settingsCurrentPassword => 'Kata Laluan Semasa';

  @override
  String get settingsNewPassword => 'Kata Laluan Baharu';

  @override
  String get settingsConfirmPassword => 'Sahkan Kata Laluan';

  @override
  String get walletEGPersonalSavingsBusiness =>
      'cth., Peribadi, Simpanan, Perniagaan';

  @override
  String get walletEnterCreditLimit => 'Masukkan had kredit';

  @override
  String get walletSelectBillingDay => 'Pilih hari bil';

  @override
  String get walletCreateAccount => 'Cipta Akaun';

  @override
  String get walletWalletCreatedSuccessfully => 'Dompet berjaya dicipta';

  @override
  String get walletAccountUpdatedSuccessfully => 'Akaun berjaya dikemas kini';

  @override
  String get walletEditAccount => 'Sunting Akaun';

  @override
  String get walletSetAsDefault => 'Jadikan Lalai';

  @override
  String get walletUseDecimals => 'Guna Perpuluhan';

  @override
  String get walletEnterWalletName => 'Masukkan nama dompet';

  @override
  String get walletCurrency => 'Mata Wang';

  @override
  String get walletIcon => 'Ikon';

  @override
  String get walletColor => 'Warna';

  @override
  String get walletWalletName => 'Nama Dompet';

  @override
  String get walletInitialBalance => 'Baki Permulaan';

  @override
  String get txAddATransferFee => 'Tambah caj pindahan';

  @override
  String get txRemove => 'Buang';

  @override
  String get txPaymentMethod => 'Kaedah Pembayaran';

  @override
  String get txObjective => 'Objektif';

  @override
  String get txTitle => 'Tajuk';

  @override
  String get txTesco => 'Tesco';

  @override
  String get txAll => 'Semua';

  @override
  String get txSkip => 'Langkau';

  @override
  String get txMarkAsPaid2 => 'Tandakan Dibayar';

  @override
  String get txConfirmPayment => 'Sahkan pembayaran';

  @override
  String get txAmountCharged => 'Jumlah dicaj';

  @override
  String get txUndo => 'Buat asal';

  @override
  String get txNoLoan => 'Tiada pinjaman';

  @override
  String get txLentMoney => 'Wang Dipinjamkan';

  @override
  String get txBorrowedMoney => 'Wang Dipinjam';

  @override
  String get goalShowOnTheHomeScreen => 'Tunjuk di skrin utama';

  @override
  String get goalWhatAreYouSavingFor => 'Anda menyimpan untuk apa?';

  @override
  String get goalNewLaptop => 'Komputer riba baharu';

  @override
  String get goalTarget => 'Sasaran';

  @override
  String get goalColour => 'Warna';

  @override
  String get goalClear => 'Kosongkan';

  @override
  String get goalGoal => 'Matlamat';

  @override
  String get goalThisGoalNoLongerExists => 'Matlamat ini tidak wujud lagi.';

  @override
  String get goalAddToGoal => 'Tambah ke matlamat';

  @override
  String get goalUnlink => 'Nyahpaut';

  @override
  String get reportUpgrade => 'Naik taraf';

  @override
  String get budgetSpending => 'Perbelanjaan';

  @override
  String get budgetEarnings => 'Pendapatan';

  @override
  String get budgetEvery => 'Setiap';

  @override
  String get budgetCarryOverWhatIsLeft => 'Bawa ke hadapan baki yang tinggal';

  @override
  String get budgetGroceries => 'Barangan runcit';

  @override
  String get authLinkYourAccount => 'Pautkan Akaun Anda';

  @override
  String get authPassword => 'Kata Laluan';

  @override
  String get authLinkAccount => 'Pautkan Akaun';

  @override
  String get authEmailAddress => 'Alamat E-mel';

  @override
  String get authSendResetCode => 'Hantar Kod Set Semula';

  @override
  String get authResetCode => 'Kod Set Semula';

  @override
  String get authResetPassword => 'Set Semula Kata Laluan';

  @override
  String get authWelcomeBack => 'Selamat Kembali';

  @override
  String get authSignInToContinueYour =>
      'Log masuk untuk meneruskan perjalanan kewangan anda';

  @override
  String get authSignIn => 'Log Masuk';

  @override
  String get authJoinUsToStartYour =>
      'Sertai kami untuk memulakan perjalanan kewangan anda';

  @override
  String get authFullName => 'Nama Penuh';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Bulanan';

  @override
  String get premiumYearly => 'Tahunan';

  @override
  String get premiumLifetime => 'Seumur Hidup';

  @override
  String get premiumNotNow => 'Bukan Sekarang';

  @override
  String get aiRename => 'Namakan semula';

  @override
  String get aiRenameChat => 'Namakan semula sembang';

  @override
  String get aiDeleteChat => 'Padam sembang?';

  @override
  String get aiChatName => 'Nama sembang';

  @override
  String get aiScanReceipt => 'Imbas Resit';

  @override
  String get aiCamera => 'Kamera';

  @override
  String get aiGallery => 'Galeri';

  @override
  String get aiMerchantTitle => 'Peniaga / tajuk';

  @override
  String get aiSaveAsTransaction => 'Simpan sebagai transaksi';

  @override
  String get onboardBrowseThemes => 'Lihat tema';

  @override
  String get onboardBack => 'Kembali';

  @override
  String get onboardGetStarted => 'Mula';

  @override
  String get onboardMainAccount => 'Akaun Utama';

  @override
  String get creditRecordPayment => 'Rekod Pembayaran';

  @override
  String get creditPleaseEnterAValidAmount => 'Sila masukkan jumlah yang sah';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'Jumlah melebihi baki yang tinggal';

  @override
  String get creditPaymentAmount => 'Jumlah Pembayaran';

  @override
  String get creditPaidOn => 'Dibayar pada';

  @override
  String get creditFullAmount => 'Jumlah penuh';

  @override
  String get subSubscriptionName => 'Nama langganan';

  @override
  String get subAskBeforeEachPayment =>
      'Tanya sebelum merekod setiap pembayaran';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Setiap pembayaran menunggu dalam Akan Datang sehingga anda mengesahkan jumlah yang dicaj, atau melangkaunya. Sesuai untuk caj yang berubah-ubah, seperti kad yang dibayar dalam mata wang lain.';

  @override
  String get subChangesApplyFromNext =>
      'Jumlah atau akaun baharu terpakai mulai bayaran seterusnya. Bayaran yang telah dibuat kekal seperti asal.';

  @override
  String get catPleaseEnterACategoryName => 'Sila masukkan nama kategori';

  @override
  String get catEnterCategoryName => 'Masukkan nama kategori';

  @override
  String get catSearch => 'Cari kategori';

  @override
  String get catNoMatch => 'Tiada kategori yang sepadan.';

  @override
  String get catUseEmoji => 'Guna emoji';

  @override
  String get catEmojiHint => 'Taip atau pilih satu emoji';

  @override
  String get catArchive => 'Arkib';

  @override
  String get catMergeInto => 'Gabung ke…';

  @override
  String catMergeIntoTitle(String name) {
    return 'Gabung $name ke';
  }

  @override
  String get catMergeBuiltIn => 'Terbina dalam';

  @override
  String get catMergeNoTargets =>
      'Tiada kategori lain yang sama jenis untuk digabungkan.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return 'Gabung $from ke $to?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Setiap transaksi, bajet dan subkategori dalam $from dipindahkan ke $to, dan $from dibuang. Ini disegerakkan ke peranti anda yang lain.';
  }

  @override
  String get catMergeAction => 'Gabung';

  @override
  String catMerged(String from, String to) {
    return '$from digabungkan ke $to.';
  }

  @override
  String get catExpenseSection => 'Kategori perbelanjaan';

  @override
  String get catIncomeSection => 'Kategori pendapatan';

  @override
  String get catSectionEmpty => 'Belum ada';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subkategori',
      one: '1 subkategori',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi',
      one: '1 transaksi',
      zero: 'Tiada transaksi',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'Dalam $name';
  }

  @override
  String get catAddSubcategory => 'Tambah subkategori';

  @override
  String get catNoSubcategoriesYet => 'Belum ada subkategori. Tambah satu';

  @override
  String get catMoveTo => 'Pindah ke…';

  @override
  String catMoveToTitle(String name) {
    return 'Pindahkan $name ke';
  }

  @override
  String get catTopLevel => 'Peringkat atas';

  @override
  String get catTopLevelHint => 'Tidak berada dalam mana-mana kategori';

  @override
  String catMovedInto(String name, String parent) {
    return '$name kini dalam $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name kini kategori peringkat atas.';
  }

  @override
  String get catMoveNoParents => 'Tiada kategori yang boleh menempatkannya.';

  @override
  String get catMoveTransactions => 'Pindahkan transaksi…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Pindahkan transaksi $name ke';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pindahkan $count transaksi ke $to?',
      one: 'Pindahkan 1 transaksi ke $to?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Hanya transaksi yang dipindahkan. $from kekal, bersama bajet dan subkategorinya. Ini disegerakkan ke peranti anda yang lain.';
  }

  @override
  String get catMoveAction => 'Pindah';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi dipindahkan ke $to.',
      one: '1 transaksi dipindahkan ke $to.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name tiada transaksi untuk dipindahkan.';
  }

  @override
  String get catNoMoveTargets =>
      'Tiada kategori lain yang sama jenis untuk menerimanya.';

  @override
  String catDeleteTitle(String name) {
    return 'Padam $name?';
  }

  @override
  String get catDeleteEmptyBody =>
      'Ia tiada transaksi, jadi tiada apa-apa lagi yang berubah.';

  @override
  String get catDeleteChildrenNote =>
      'Subkategorinya dipindahkan ke peringkat atas.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transaksi difailkan di bawahnya. Apa yang patut dilakukan padanya?',
      one:
          '1 transaksi difailkan di bawahnya. Apa yang patut dilakukan padanya?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'Pindah ke kategori lain';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Kemudian $name dipadam. Bajet yang menggunakannya turut dipindahkan.';
  }

  @override
  String get catDeleteThemToo => 'Padam transaksi juga';

  @override
  String get catDeleteThemTooHint =>
      'Ia masuk ke Dipadam baru-baru ini, di mana anda boleh memulihkannya dalam 30 hari.';

  @override
  String catDeleted(String name) {
    return '$name dipadam.';
  }

  @override
  String get catActionFailed => 'Itu tidak dapat dilakukan. Cuba lagi.';

  @override
  String get catStaysTopLevel =>
      'Kategori ini mempunyai subkategori sendiri, jadi ia kekal di peringkat atas.';

  @override
  String get catUnarchive => 'Nyaharkib';

  @override
  String get catArchivedSection => 'Diarkibkan';

  @override
  String get catArchivedHint =>
      'Disimpan untuk sejarahnya, tetapi tidak ditawarkan semasa anda menambah transaksi.';

  @override
  String get catNothingItsOwnCategory => 'Tiada — kategorinya sendiri';

  @override
  String get notifEnableNotifications => 'Dayakan Pemberitahuan';

  @override
  String get startupContinueWithoutChecking => 'Teruskan tanpa menyemak?';

  @override
  String get startupContinueOffline => 'Teruskan di luar talian';

  @override
  String get startupViewSubscriptionOptions => 'Lihat pilihan langganan';

  @override
  String get sharedWelcomeBack => 'Selamat kembali';

  @override
  String get sharedRestoringYourDataFromThe =>
      'Memulihkan data anda daripada awan…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return 'Gabung $source ke $target?';
  }

  @override
  String get backupNothingHereYet => 'Belum ada apa-apa di sini.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Digunakan secara automatik apabila fail mempunyai lajur ini';

  @override
  String get importDateFormat => 'Format tarikh';

  @override
  String get importChooseOne => 'Pilih satu';

  @override
  String get importDecimalPoint => 'Titik perpuluhan';

  @override
  String get importFlipTheSigns => 'Terbalikkan tanda';

  @override
  String get importForExportsThatWriteA =>
      'Untuk eksport yang menulis perbelanjaan sebagai positif';

  @override
  String get importWhereRowsGoWhenThe =>
      'Ke mana baris pergi apabila fail tidak menamakan akaun anda';

  @override
  String get importSkipWhatIsAlreadyHere => 'Langkau yang sudah ada di sini';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Cipta kategori yang dinamakan dalam fail';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Jika tidak, baris itu masuk tanpa kategori';

  @override
  String get importCategoriesInThisFile => 'Kategori dalam fail ini';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Dibuat dengan kasih sayang untuk kewangan peribadi';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy =>
      'Dibangunkan & Diselenggara Oleh:';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Tutup';

  @override
  String get settingsGetInTouch => 'Hubungi kami';

  @override
  String get settingsAsAPremiumMemberYour =>
      'Sebagai ahli Premium, permintaan anda ditandakan sebagai keutamaan.';

  @override
  String get settingsWhatToInclude => 'Apa yang perlu disertakan';

  @override
  String get settingsNoCurrenciesFound => 'Tiada mata wang ditemui';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Eksport data kewangan anda untuk dianalisis dalam aplikasi lain atau disimpan sebagai sandaran.';

  @override
  String get settingsDateRange => 'Julat Tarikh';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'Laporan PDF';

  @override
  String get settingsGettingStarted => 'Bermula';

  @override
  String get settingsStillNeedHelp => 'Masih perlukan bantuan?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'Pasukan sokongan kami sedia membantu anda';

  @override
  String get settingsAppLocked => 'Aplikasi Dikunci';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Buka kunci untuk mengakses The Accountant';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Tetapkan bila dan bagaimana The Accountant mengingatkan anda untuk merekod perbelanjaan.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'E-mel anda digunakan untuk log masuk dan tidak boleh ditukar di sini.';

  @override
  String get settingsYourDataIsOnThis => 'Data anda hanya ada pada peranti ini';

  @override
  String get settingsUpgradeForCloudSync => 'Naik taraf untuk segerak awan';

  @override
  String get settingsNoSettingsFound => 'Tiada tetapan ditemui';

  @override
  String get settingsTryADifferentSearchTerm => 'Cuba istilah carian lain';

  @override
  String get settingsSyncStatus => 'STATUS SEGERAK';

  @override
  String get settingsSyncNow => 'Segerak Sekarang';

  @override
  String get settingsRestoreFromCloud2 => 'Pulihkan daripada Awan';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'PERLU PENGESAHAN ANDA';

  @override
  String get walletCreateYourFirstAccount => 'Cipta Akaun Pertama Anda';

  @override
  String get walletYouNeedAtLeastOne =>
      'Anda perlukan sekurang-kurangnya satu akaun untuk mula menjejak kewangan anda';

  @override
  String get walletAccountType => 'Jenis Akaun';

  @override
  String get walletAccountName => 'Nama Akaun';

  @override
  String get walletCreditLimit => 'Had Kredit';

  @override
  String get walletCreditLimitHelp =>
      'Had dinaikkan? Tukar di sini. Had baharu bukan pendapatan.';

  @override
  String get walletAmountOwed => 'Jumlah terhutang';

  @override
  String get walletAmountOwedHelp =>
      'Jumlah yang anda hutang pada kad sekarang. Guna 0 jika sudah dilunaskan.';

  @override
  String get walletCurrentBalance => 'Baki semasa';

  @override
  String get walletCurrentBalanceHelp =>
      'Perubahan disimpan sebagai pembetulan baki, jadi sejarah anda tetap seimbang.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'Apakah $amount pada kad ini?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Kredit yang masih ada';

  @override
  String get walletCardBalanceOwed => 'Yang saya hutang';

  @override
  String get walletCardBalanceChoose =>
      'Pilih maksud jumlah ini, supaya hutang dikira dengan betul.';

  @override
  String get walletBillingCycleDayOptional => 'Hari Kitaran Bil (pilihan)';

  @override
  String get walletThisWillBeYourDefault => 'Ini akan menjadi akaun lalai anda';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Belum ada rekod untuk akaun ini.';

  @override
  String get walletAddAccount => 'Tambah Akaun';

  @override
  String get walletYourAccounts => 'Akaun Anda';

  @override
  String get walletNoAccountsYet => 'Belum ada akaun';

  @override
  String get walletOutstanding => 'Tertunggak';

  @override
  String get walletAvailable => 'Tersedia';

  @override
  String get walletLimit => 'Had';

  @override
  String get walletBalance => 'Baki';

  @override
  String get walletUseThisWalletForNew =>
      'Guna dompet ini untuk transaksi baharu';

  @override
  String get walletSelectIcon => 'Pilih Ikon';

  @override
  String get walletSelectColor => 'Pilih Warna';

  @override
  String get txYouNeedAtLeast2 =>
      'Anda perlukan sekurang-kurangnya 2 akaun untuk membuat pindahan';

  @override
  String get txNoAccountTitle => 'Tiada akaun untuk merekodkan ini';

  @override
  String get txNoAccountBody =>
      'Tambah akaun, atau buka semula akaun yang ditutup, dan borang ini sedia digunakan.';

  @override
  String get txNoAccountAction => 'Urus akaun';

  @override
  String get txDeleteTransaction => 'Padam Transaksi';

  @override
  String get txAreYouSureYouWant =>
      'Adakah anda pasti mahu memadam transaksi ini?';

  @override
  String get txTransactionType => 'Jenis Transaksi';

  @override
  String get txTransferFee => 'Caj pindahan';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Dicaj berasingan, supaya pindahan itu sendiri kekal seimbang.';

  @override
  String get txDeductedFrom => 'Ditolak daripada';

  @override
  String get txNoPaymentMethods => 'Tiada kaedah pembayaran';

  @override
  String get txNothingDeletedRecently => 'Tiada apa-apa dipadam baru-baru ini';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Apa sahaja yang anda padam muncul di sini selama tiga puluh hari.';

  @override
  String get txNoRulesYet => 'Belum ada peraturan';

  @override
  String get txClearAll => 'Kosongkan Semua';

  @override
  String get txApplyFilters => 'Guna Penapis';

  @override
  String get txUpcomingOverdue => 'Akan Datang & Tertunggak';

  @override
  String get txNew => 'Baharu';

  @override
  String get txLoan => 'Pinjaman';

  @override
  String get goalStarted => 'Dimulakan';

  @override
  String get goalTargetDate => 'Tarikh sasaran';

  @override
  String get goalWithADateTheGoal =>
      'Dengan tarikh, matlamat mengira berapa banyak perlu diketepikan setiap hari.';

  @override
  String get goalCountedTowardThisGoal => 'Dikira untuk matlamat ini';

  @override
  String get goalGettingThere => 'Hampir sampai';

  @override
  String get goalSetATargetDateAnd =>
      'Tetapkan tarikh sasaran dan ini mengira berapa yang perlu diketepikan.';

  @override
  String get reportSpendingInsights => 'Analisis Perbelanjaan';

  @override
  String get reportNoSpendingDataForThis =>
      'Tiada data perbelanjaan untuk tempoh ini';

  @override
  String get reportNoCategorySpendingData => 'Tiada data perbelanjaan kategori';

  @override
  String get reportNoSpendingDataAvailable =>
      'Tiada data perbelanjaan tersedia';

  @override
  String get reportBudgetVsActual => 'Bajet vs Sebenar';

  @override
  String get reportNoActiveBudgets => 'Tiada bajet aktif';

  @override
  String get reportCreateABudgetToTrack =>
      'Cipta bajet untuk menjejak perbelanjaan anda';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Berbelanja lebih pantas daripada tempoh berlalu.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'Tiada rekod dalam tempoh ini.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent daripada $limit digunakan';
  }

  @override
  String budgetAmountLeft(String amount) {
    return 'Baki $amount';
  }

  @override
  String budgetAmountOver(String amount) {
    return 'Lebih $amount';
  }

  @override
  String get budgetPeriodEnded => 'Tempoh tamat';

  @override
  String get budgetPaceOver => 'Lebih';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tinggal $days hari',
      one: 'Tinggal 1 hari',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Kata laluan berjaya ditetapkan semula. Sila log masuk.';

  @override
  String get authResendCode => 'Hantar semula kod';

  @override
  String get authForgotPassword => 'Lupa Kata Laluan?';

  @override
  String get authOrContinueWith => 'Atau teruskan dengan';

  @override
  String get authContinueWithGoogle => 'Teruskan dengan Google';

  @override
  String get authContinueWithApple => 'Teruskan dengan Apple';

  @override
  String get authSignUp => 'Daftar';

  @override
  String get authPleaseAcceptTheTermsAnd => 'Sila terima terma dan syarat';

  @override
  String get authPasswordStrength => 'Kekuatan Kata Laluan';

  @override
  String get authAlreadyHaveAnAccount => 'Sudah ada akaun? ';

  @override
  String get authPersonalInformation => 'Maklumat Peribadi';

  @override
  String get authUpgradeToPremium => 'Naik Taraf ke Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Buka bajet tanpa had, analisis lanjutan dan banyak lagi!';

  @override
  String get authUpgradeNow => 'Naik Taraf Sekarang';

  @override
  String get authPremiumMember => 'Ahli Premium';

  @override
  String get authEnjoyingAllPremiumFeatures => 'Menikmati semua ciri premium';

  @override
  String get authSaveChanges => 'Simpan Perubahan';

  @override
  String get authAreYouSureYouWant =>
      'Adakah anda pasti mahu log keluar daripada akaun anda?';

  @override
  String get authChangeProfilePhoto => 'Tukar Foto Profil';

  @override
  String get authTakePhoto => 'Ambil Foto';

  @override
  String get authUseYourCamera => 'Guna kamera anda';

  @override
  String get authChooseFromGallery => 'Pilih dari Galeri';

  @override
  String get authSelectAnExistingPhoto => 'Pilih foto sedia ada';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Foto dipilih! Ciri muat naik akan datang tidak lama lagi.';

  @override
  String get authNameCannotBeEmpty => 'Nama tidak boleh kosong';

  @override
  String get authProfileUpdatedSuccessfully => 'Profil berjaya dikemas kini!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Privasi & Terma';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Semak ini sebelum anda meneruskan.';

  @override
  String get premiumLimitReached => 'Had Dicapai';

  @override
  String get aiChats => 'Sembang';

  @override
  String get aiNewChat => 'Sembang baharu';

  @override
  String get aiNoConversationsYet => 'Belum ada perbualan';

  @override
  String get aiStartChattingAndYourThreads =>
      'Mula bersembang dan perbualan anda akan muncul di sini.';

  @override
  String get aiScanAReceipt => 'Imbas resit';

  @override
  String get aiReadingYourReceipt => 'Membaca resit anda…';

  @override
  String get aiReviewSave => 'Semak & simpan';

  @override
  String get aiWeReadThisFromYour =>
      'Kami membaca ini daripada resit anda — semak dan sunting apa-apa sebelum menyimpan.';

  @override
  String get dashErrorLoadingFinancialData => 'Ralat memuatkan data kewangan';

  @override
  String get dashNoSpendingDataYet => 'Belum ada data perbelanjaan';

  @override
  String get dashManage => 'Urus';

  @override
  String get dashAvailable => 'Tersedia: ****';

  @override
  String get onboardWelcome => 'Selamat datang!';

  @override
  String get onboardSelectYourDefaultCurrency => 'Pilih mata wang lalai anda';

  @override
  String get onboardLoadingCurrencies => 'Memuatkan mata wang...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'Sediakan dompet utama anda';

  @override
  String get onboardInitialBalanceOptional => 'Baki Permulaan (pilihan)';

  @override
  String get onboardYourAccountIsReadyTo => 'Akaun anda sedia digunakan';

  @override
  String get onboardTipYouCanAddMore =>
      'Petua: Anda boleh menambah lebih banyak akaun dengan mata wang berbeza pada bila-bila masa dari bahagian Dompet.';

  @override
  String get creditSettled => 'Selesai';

  @override
  String get creditOverdue => 'Tertunggak';

  @override
  String creditTabCredit(int count) {
    return 'Dipinjamkan ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Dipinjam ($count)';
  }

  @override
  String get creditNetOutstanding => 'Baki bersih tertunggak';

  @override
  String get creditAllSettled => 'Semua selesai';

  @override
  String get creditOthersOweYou => 'Orang lain berhutang dengan anda';

  @override
  String get creditYouOweOthers => 'Anda berhutang dengan orang lain';

  @override
  String creditOverdueCount(int count) {
    return '$count tertunggak';
  }

  @override
  String get creditEmptyAll => 'Tiada wang dipinjamkan atau dipinjam';

  @override
  String get creditEmptyLent => 'Tiada wang dipinjamkan';

  @override
  String get creditEmptyBorrowed => 'Tiada wang dipinjam';

  @override
  String get creditEmptyAllSettled => 'Semuanya sudah selesai.';

  @override
  String get creditEmptyHint =>
      'Tambah wang yang anda pinjamkan atau pinjam untuk menjejak siapa berhutang dengan siapa.';

  @override
  String get creditShowAll => 'Tunjuk semua';

  @override
  String get creditShowUnpaid => 'Tunjuk yang belum dibayar sahaja';

  @override
  String get creditMoneyLent => 'Wang dipinjamkan';

  @override
  String get creditMoneyBorrowed => 'Wang dipinjam';

  @override
  String get creditTheyOweYou => 'Mereka berhutang dengan anda';

  @override
  String get creditYouOwe => 'Anda berhutang';

  @override
  String get creditCollected => 'Dikutip';

  @override
  String creditPaidOf(String paid, String total) {
    return 'Dibayar $paid daripada $total';
  }

  @override
  String get creditRecord => 'Rekod';

  @override
  String get subRecurring => 'Berulang';

  @override
  String get subPaused => 'Dijeda';

  @override
  String get subAsksFirst => 'Tanya dahulu';

  @override
  String get subFrequency => 'Kekerapan';

  @override
  String get notifMarkAllRead => 'Tandakan semua dibaca';

  @override
  String get notifTryAgain => 'Cuba lagi';

  @override
  String get notifStayOnTopOfYour => 'Kawal wang anda sentiasa';

  @override
  String get notifNoNotificationsYet => 'Belum ada pemberitahuan';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'Apabila anda menerima pemberitahuan, ia akan muncul di sini.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Tiada apa-apa yang diubah atau dipadam.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Sertakan mata wang kripto';

  @override
  String get sharedTotalBalance => 'Jumlah Baki';

  @override
  String get heatmapTitle => 'Rentak harian';

  @override
  String get heatmapSpentMore => 'Lebih berbelanja';

  @override
  String get heatmapEarnedMore => 'Lebih memperoleh';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transaksi tidak ditunjukkan: tiada kadar diketahui antara mata wang akaunnya dan $currency',
      one:
          'Satu transaksi tidak ditunjukkan: tiada kadar diketahui antara mata wang akaunnya dan $currency',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet => 'Belum ada rekod dalam tempoh ini.';

  @override
  String get heatmapNetForRange => 'Bersih dalam julat ini';

  @override
  String get layoutTitle => 'Susun atur utama';

  @override
  String get layoutSubtitle =>
      'Susun semula skrin utama, atau sembunyikan yang tidak anda guna';

  @override
  String get layoutExplain =>
      'Seret untuk menyusun semula. Apa sahaja yang dimatikan mengekalkan tempatnya, jadi menghidupkannya semula meletakkannya di tempat asal.';

  @override
  String get layoutReset => 'Set semula ke lalai';

  @override
  String get layoutAllHidden =>
      'Setiap bahagian disembunyikan. Skrin utama akan kosong.';

  @override
  String get layoutSectionGreeting => 'Ucapan';

  @override
  String get layoutSectionAccounts => 'Akaun';

  @override
  String get layoutSectionQuickStats => 'Pendapatan dan perbelanjaan';

  @override
  String get layoutSectionQuickLinks => 'Pintasan';

  @override
  String get layoutSectionSpendingChart => 'Gambaran perbelanjaan';

  @override
  String get layoutSectionRecent => 'Transaksi terkini';

  @override
  String get layoutSectionBudgets => 'Kemajuan bajet';

  @override
  String get layoutSectionGoals => 'Matlamat disemat';

  @override
  String get shortcutAddExpense => 'Tambah perbelanjaan';

  @override
  String get shortcutAddIncome => 'Tambah pendapatan';

  @override
  String get shortcutScanReceipt => 'Imbas resit';

  @override
  String get shortcutTransactions => 'Transaksi';

  @override
  String get backupBusySyncing =>
      'Penyegerakan sedang berjalan. Tunggu sehingga selesai sebelum memulihkan.';

  @override
  String get appearanceTitle => 'Penampilan';

  @override
  String get themeSunriseLight => 'Fajar Cerah';

  @override
  String get themeSunriseDark => 'Fajar Gelap';

  @override
  String get themeMatchSystem => 'Ikut sistem';

  @override
  String get themeMatchSystemHint =>
      'Tukar antara cerah dan gelap mengikut telefon anda';

  @override
  String get themeUnlockAll => 'Buka semua tema';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Fajar';

  @override
  String get themeAccentSapphire => 'Nilam';

  @override
  String get themeAccentEmerald => 'Zamrud';

  @override
  String get themeAccentRuby => 'Delima';

  @override
  String get themeAccentAmethyst => 'Kecubung';

  @override
  String get themeAccentGraphite => 'Grafit';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Hari ini';

  @override
  String get navAdd => 'Tambah';

  @override
  String get navStats => 'Statistik';

  @override
  String get navMore => 'Lagi';

  @override
  String get walkthroughTodayTitle => 'Hari anda sepintas lalu';

  @override
  String get walkthroughTodayBody =>
      'Nilai bersih, pendapatan dan perbelanjaan anda, serta aktiviti hari ini.';

  @override
  String get walkthroughAddTitle => 'Tambah dalam beberapa saat';

  @override
  String get walkthroughAddBody =>
      'Ketik Tambah untuk merekod perbelanjaan, pendapatan atau pindahan.';

  @override
  String get walkthroughTransactionsTitle => 'Transaksi anda';

  @override
  String get walkthroughTransactionsBody =>
      'Setiap transaksi, bulan demi bulan. Cari dan tapis untuk menemui apa sahaja.';

  @override
  String get walkthroughStatsTitle => 'Lihat ke mana ia pergi';

  @override
  String get walkthroughStatsBody =>
      'Carta mingguan, bulanan dan tahunan, mengikut kategori.';

  @override
  String get walkthroughBellTitle => 'Sentiasa dimaklumkan';

  @override
  String get walkthroughBellBody =>
      'Amaran bajet dan peringatan muncul di sini. Anda sudah bersedia!';

  @override
  String get walkthroughBalanceTitle => 'Nilai bersih anda';

  @override
  String get walkthroughBalanceBody =>
      'Setiap dompet dijumlahkan di sini, dengan bar yang menunjukkan pembahagiannya.';

  @override
  String get txTransfer => 'Pindahan';

  @override
  String get txUncategorized => 'Tiada kategori';

  @override
  String todayGoodMorning(String name) {
    return 'Selamat pagi, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Selamat petang, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Selamat malam, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Selamat pagi';

  @override
  String get todayGoodAfternoonPlain => 'Selamat petang';

  @override
  String get todayGoodEveningPlain => 'Selamat malam';

  @override
  String get todayNetWorth => 'Nilai bersih';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount bulan ini';
  }

  @override
  String get todayEarned => 'Diperoleh';

  @override
  String get todaySpent => 'Dibelanjakan';

  @override
  String get todayTitle => 'Hari ini';

  @override
  String get todayRecent => 'Terkini';

  @override
  String get todayAllActivity => 'Semua aktiviti';

  @override
  String get todayNothingYet => 'Belum ada apa-apa hari ini';

  @override
  String get todayNothingYetBody => 'Ketik Tambah untuk merekod yang pertama.';

  @override
  String todayMoreWallets(int count) {
    return '+$count lagi';
  }

  @override
  String get todayCoachTitle => 'Tanya jurulatih kewangan anda';

  @override
  String get todayCoachBody =>
      'Jawapan dan dorongan daripada perbelanjaan anda sendiri';

  @override
  String get todayNotifications => 'Pemberitahuan';

  @override
  String get todayWithinBudget => 'Dalam bajet';

  @override
  String get todayOverBudget => 'Melebihi bajet';

  @override
  String get todayNetCredit => 'Kredit bersih';

  @override
  String get todayNetDebt => 'Hutang bersih';

  @override
  String get todayMonthly => 'Bulanan';

  @override
  String get walletsTitle => 'Dompet';

  @override
  String get walletsNew => 'Baharu';

  @override
  String get walletsAddHint => 'Tambah bank, tunai, simpanan…';

  @override
  String get walletsPlanning => 'Perancangan';

  @override
  String get walletsUpcoming => 'Akan datang';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count perlu dibayar · $amount';
  }

  @override
  String get walletsUpcomingNone =>
      'Tiada yang perlu dibayar dalam masa terdekat';

  @override
  String get walletsLendBorrow => 'Pinjam & beri pinjam';

  @override
  String get splitTitle => 'Bahagi bil';

  @override
  String get splitSubtitle =>
      'Kongsi bil dengan rakan; jumlah hutang mereka masuk ke Pinjam & beri pinjam';

  @override
  String get splitWhatFor => 'Untuk apa';

  @override
  String get splitTotal => 'Jumlah';

  @override
  String get splitPeople => 'Orang';

  @override
  String get splitYou => 'Anda';

  @override
  String get splitIncludeMe => 'Saya ada bahagian';

  @override
  String get splitIncludeMeSub =>
      'Matikan jika anda hanya membayar untuk orang lain';

  @override
  String get splitAddPerson => 'Tambah orang';

  @override
  String get splitPersonName => 'Nama';

  @override
  String get splitKnownPeople => 'Dari Pinjam & beri pinjam';

  @override
  String get splitRemove => 'Buang';

  @override
  String get splitPaidBy => 'Dibayar oleh';

  @override
  String get splitHow => 'Cara membahagi';

  @override
  String get splitEqual => 'Sama rata';

  @override
  String get splitExact => 'Jumlah';

  @override
  String get splitPercent => 'Peratus';

  @override
  String get splitShares => 'Bahagian';

  @override
  String get splitYourShare => 'Bahagian anda';

  @override
  String get splitOwesYou => 'Berhutang dengan anda';

  @override
  String splitYouOwe(String name) {
    return 'Anda berhutang dengan $name';
  }

  @override
  String get splitPaidTheBill => 'Membayar bil';

  @override
  String splitSettlesWith(String name) {
    return 'Menyelesaikan dengan $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total daripada akaun anda; $owed akan dibayar balik kepada anda';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Tiada wang keluar dari akaun anda sekarang; anda berhutang $amount dengan $name';
  }

  @override
  String get splitPercentLabel => 'Peratus bil';

  @override
  String get splitSave => 'Bahagikan';

  @override
  String get splitSaved => 'Pembahagian direkodkan';

  @override
  String get splitNeedCategory => 'Pilih kategori dahulu.';

  @override
  String get splitThisBill => 'Bahagi bil ini';

  @override
  String get splitThisBillSub =>
      'Dengan rakan; jumlah hutang mereka masuk ke Pinjam & beri pinjam';

  @override
  String get splitPartOf => 'Bil dibahagi';

  @override
  String walletsOwedToYou(String amount) {
    return 'Anda dihutang $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'Anda berhutang $amount';
  }

  @override
  String get walletsAllSettled => 'Semua selesai';

  @override
  String get walletsGoals => 'Matlamat';

  @override
  String walletsGoalsSub(int count) {
    return '$count aktif';
  }

  @override
  String get walletsBudgets => 'Bajet';

  @override
  String get walletsSubscriptions => 'Langganan';

  @override
  String get walletsTransfer => 'Pindahan antara dompet';

  @override
  String get walletsArchived => 'Diarkibkan';

  @override
  String walletsDeleteMessage(String name) {
    return 'Padam “$name”? Setiap transaksi dalam akaun ini turut dipadam.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name dipadam';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name kini akaun lalai anda';
  }

  @override
  String get walletsCreateFailed =>
      'Tidak dapat mencipta akaun. Sila cuba lagi.';

  @override
  String get walletsEmptyBody =>
      'Cipta akaun pertama anda untuk mula menjejak.';

  @override
  String get walletsTypeBank => 'Akaun bank';

  @override
  String get walletsTypeCard => 'Kad kredit';

  @override
  String get walletsTypeCash => 'Tunai';

  @override
  String get walletsTypeOther => 'Akaun';

  @override
  String get moreTitle => 'Lagi';

  @override
  String get moreGoPremium => 'Langgan Premium';

  @override
  String get moreGoPremiumBody => 'Pembantu AI, segerak awan, tema';

  @override
  String get moreUnlock => 'Buka';

  @override
  String get morePremiumActive => 'Premium aktif';

  @override
  String get morePremiumThanks =>
      'Terima kasih kerana menyokong The Accountant';

  @override
  String get sectionPreferences => 'KEUTAMAAN';

  @override
  String get sectionTools => 'ALAT KEWANGAN';

  @override
  String get moreAiAssistant => 'Pembantu AI';

  @override
  String get moreAiAssistantSub => 'Tanya soalan tentang wang anda';

  @override
  String get moreSignOutConfirm => 'Log keluar akaun anda pada peranti ini?';

  @override
  String get moreSignOutFailed => 'Tidak dapat log keluar. Sila cuba lagi.';

  @override
  String get moreDeviceOnlyBody =>
      'Akaun percuma tidak disandarkan ke awan, jadi memasang semula atau menukar telefon boleh menyebabkan data hilang. Naik taraf untuk segerak awan, atau eksport sandaran secara berkala.';

  @override
  String get moreUpgradeToPremium => 'Naik Taraf ke Premium';

  @override
  String get moreUser => 'Anda';

  @override
  String get statsTitle => 'Statistik';

  @override
  String get statsWeek => 'Minggu';

  @override
  String get statsMonth => 'Bulan';

  @override
  String get statsYear => 'Tahun';

  @override
  String get statsSpending => 'Perbelanjaan';

  @override
  String get statsIncome => 'Pendapatan';

  @override
  String get statsCategories => 'Kategori';

  @override
  String get statsSpent => 'Dibelanjakan';

  @override
  String get statsEarned => 'Diperoleh';

  @override
  String get statsNet => 'Bersih';

  @override
  String get statsThisMonth => 'Bulan ini';

  @override
  String statsVsLastMonth(String change) {
    return '$change berbanding bulan lepas';
  }

  @override
  String get statsInsightsSub => 'Ringkasan, trend & petua bulan ini';

  @override
  String get statsAskCoach => 'Tanya jurulatih AI tentang ini';

  @override
  String statsOverBy(String amount) {
    return 'Lebih $amount';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% berbaki';
  }

  @override
  String get activityAll => 'Semua';

  @override
  String get activitySpent => 'Dibelanjakan';

  @override
  String get activityEarned => 'Diperoleh';

  @override
  String get activityTransfers => 'Pindahan';

  @override
  String activitySoFar(String month) {
    return '$month setakat ini';
  }

  @override
  String activityNet(String amount) {
    return '$amount bersih';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count padanan merentas semua bulan',
      one: '1 padanan merentas semua bulan',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => '7 hari lepas';

  @override
  String get statsPeriodThisMonth => 'Bulan ini';

  @override
  String get statsPeriodThisYear => 'Tahun ini';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi',
      one: '1 transaksi',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Tiada yang sepadan dengan “$query”';
  }

  @override
  String get activitySearchNothingBody =>
      'Setiap bulan telah dicari. Cuba kurangkan perkataan, ejaan lain, atau kosongkan penapis.';

  @override
  String get activityIn => 'Masuk';

  @override
  String get activityOut => 'Keluar';

  @override
  String get activityToday => 'Hari ini';

  @override
  String get activityYesterday => 'Semalam';

  @override
  String get activityTomorrow => 'Esok';

  @override
  String get activityEmptyFutureTitle => 'Tiada transaksi dirancang';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Tambah bayaran akan datang untuk $month';
  }

  @override
  String get activityEmptyNowTitle => 'Belum ada transaksi';

  @override
  String get activityEmptyNowBody =>
      'Mula menjejak perbelanjaan anda bulan ini';

  @override
  String get activityEmptyPastTitle => 'Tiada transaksi ditemui';

  @override
  String activityEmptyPastBody(String month) {
    return 'Tiada rekod untuk $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi dipadam',
      one: '1 transaksi dipadam',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count dipindahkan ke $name';
  }

  @override
  String get activityMixedCurrencies =>
      'Ini disimpan dalam mata wang berbeza, jadi tiada satu akaun yang boleh menerima semuanya. Pilih baris daripada satu mata wang.';

  @override
  String activityMovedPartial(int count) {
    return '$count dipindahkan; pindahan dibiarkan di tempatnya';
  }

  @override
  String activityMoved(int count) {
    return '$count dipindahkan ke akaun lain';
  }

  @override
  String activityRedated(int count) {
    return '$count ditukar tarikh';
  }

  @override
  String get activityNothingToPay =>
      'Tiada apa-apa yang menunggu untuk dibayar';

  @override
  String activityMarkedPaid(int count) {
    return '$count ditandakan dibayar';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count disalin; pindahan tidak boleh disalin secara berasingan';
  }

  @override
  String activityCopied(int count) {
    return '$count disalin';
  }

  @override
  String get activityDeleteOneBody =>
      'Ia akan dibuang daripada rekod anda dan baki anda akan dikira semula.';

  @override
  String get activitySearch => 'Cari';

  @override
  String get addNewExpense => 'Perbelanjaan baharu';

  @override
  String get addNewIncome => 'Pendapatan baharu';

  @override
  String get addNewTransfer => 'Pindahan baharu';

  @override
  String get addEditTitle => 'Sunting transaksi';

  @override
  String get addAmount => 'Jumlah';

  @override
  String get addCategory => 'Kategori';

  @override
  String get addMore => 'Lagi';

  @override
  String get addWallet => 'Dompet';

  @override
  String addChangeDate(String date) {
    return 'Tukar tarikh, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Tukar masa, $time';
  }

  @override
  String get addSwapAccounts => 'Tukar kedudukan dua akaun';

  @override
  String get notifCheckTitle => 'Semak pemberitahuan';

  @override
  String get notifAllowed => 'Pemberitahuan dibenarkan';

  @override
  String get notifAllowedHint => 'Peringatan boleh sampai ke telefon ini';

  @override
  String get notifBlocked => 'Pemberitahuan dimatikan';

  @override
  String get notifBlockedHint =>
      'Ketik untuk membenarkan, jika tidak tiada apa-apa boleh sampai kepada anda';

  @override
  String get notifSendTest => 'Hantar pemberitahuan ujian';

  @override
  String get notifSendTestHint =>
      'Dihantar dari pelayan kami, sama seperti peringatan';

  @override
  String get notifSending => 'Menghantar…';

  @override
  String get notifTestSent =>
      'Dihantar. Ia sepatutnya muncul dalam beberapa saat, dan dalam peti masuk anda.';

  @override
  String notifTestFailed(String reason) {
    return 'Tidak dapat dihantar: $reason';
  }

  @override
  String get notifTestOffline => 'tiada sambungan ke pelayan';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant akan menghantar peringatan harian yang lembut untuk merekod perbelanjaan anda, pada masa yang anda pilih. Ia perlukan kebenaran untuk menunjukkan pemberitahuan.';

  @override
  String get notifPrimerShow => 'Tunjuk pemberitahuan peringatan';

  @override
  String get notifPrimerTime => 'Tiba pada masa pilihan anda';

  @override
  String get notifPrimerOff => 'Anda boleh mematikannya bila-bila masa';

  @override
  String get notifPrimerAllow => 'Benarkan';

  @override
  String get cardBillsTitle => 'Bil kad';

  @override
  String get cardBillsSubtitle =>
      'Penyata kad kredit, tarikh akhir dan peringatan';

  @override
  String get cardBillsEmptyTitle => 'Belum ada kad kredit';

  @override
  String get cardBillsEmptyBody =>
      'Tambah akaun jenis Kad kredit, tetapkan hari penyata dan hari akhir bayaran, dan bilnya akan muncul di sini.';

  @override
  String get cardBillsAddCard => 'Tambah kad';

  @override
  String get cardStatementDay => 'Hari penyata';

  @override
  String get cardStatementDayHint =>
      'Hari setiap bulan bil dikeluarkan. Semua hingga akhir hari itu termasuk di dalamnya.';

  @override
  String get cardDueDay => 'Hari akhir bayaran';

  @override
  String get cardDueDayHint =>
      'Hari terakhir untuk membayar bil, kali pertama hari itu tiba selepas penyata.';

  @override
  String get cardRemindTitle => 'Ingatkan saya';

  @override
  String get cardRemindHint =>
      'Sebelum tarikh akhir, jika sebahagian bil masih belum dibayar. Dihantar sekitar 9 PG.';

  @override
  String get cardRemindOff => 'Mati';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari sebelum',
      one: 'Sehari sebelum',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Belum ditetapkan';

  @override
  String cardDayOfMonth(int day) {
    return 'Hari $day';
  }

  @override
  String get cardSetUpBody =>
      'Tetapkan hari penyata dan hari akhir bayaran untuk melihat bil kad ini dan dapatkan peringatan sebelum tarikh akhir.';

  @override
  String get cardSetUp => 'Tetapkan tarikh';

  @override
  String cardDueBy(String date) {
    return 'Perlu dibayar sebelum $date';
  }

  @override
  String get cardLeftToPay => 'Perlu dibayar';

  @override
  String cardStatementClosed(String date) {
    return 'Penyata $date';
  }

  @override
  String get cardPaidSince => 'Dibayar sejak';

  @override
  String cardThisCycle(String date) {
    return 'Dibelanjakan sejak, penyata seterusnya $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'Bayaran bil $card';
  }

  @override
  String get cardEdit => 'Sunting kad';

  @override
  String get cardEarlierStatements => 'PENYATA TERDAHULU';

  @override
  String get cardPaidShort => 'dibayar';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount belum dibayar';
  }

  @override
  String get cardStatusNotSetUp => 'Tarikh belum ditetapkan';

  @override
  String get cardStatusNothingDue => 'Tiada yang perlu dibayar';

  @override
  String get cardStatusPaid => 'Dibayar';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Perlu dibayar dalam $days hari',
      one: 'Perlu dibayar esok',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'Perlu dibayar hari ini';

  @override
  String get cardStatusOverdue => 'Tertunggak';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid daripada $owed dibayar';
  }

  @override
  String get cardPayBill => 'Bayar bil';

  @override
  String cardPayTitle(String card) {
    return 'Bayar $card';
  }

  @override
  String get cardPayHint =>
      'Bayar semua atau sebahagian. Apa sahaja yang anda bayar dikira untuk bil ini, dan bakinya kekal perlu dibayar.';

  @override
  String cardPayFull(String amount) {
    return 'Bayar penuh, $amount';
  }

  @override
  String get cardPayFullHint => 'Semua yang berbaki pada bil ini';

  @override
  String get cardPayOther => 'Bayar jumlah lain';

  @override
  String get cardPayOtherHint => 'Bayaran separa, atau lebih daripada bil';

  @override
  String get addNoteHint => 'Tambah nota';

  @override
  String get addRepeatMonthly => 'Ulang setiap bulan';

  @override
  String get addMoreOptions => 'Lagi pilihan';

  @override
  String get addScanReceipt => 'Imbas resit';

  @override
  String get addDelete => 'Padam transaksi';

  @override
  String get addTypeExpense => 'Perbelanjaan';

  @override
  String get addTypeIncome => 'Pendapatan';

  @override
  String get addTypeTransfer => 'Pindahan';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Buka dengan Premium';

  @override
  String get gateFootnote =>
      'Seumur hidup atau langganan · Pulihkan bila-bila masa';

  @override
  String get aiCoachTitle => 'Kenali jurulatih kewangan anda';

  @override
  String get aiCoachBody =>
      'Tanya dalam bahasa mudah. Dapatkan jawapan, dorongan dan pelan berdasarkan perbelanjaan anda sendiri.';

  @override
  String get aiAssistantTitle => 'Pembantu AI';

  @override
  String get aiAskAnything => 'Tanya tentang wang anda…';

  @override
  String get aiSend => 'Hantar';

  @override
  String get aiCopy => 'Salin';

  @override
  String get aiCopied => 'Disalin';

  @override
  String get aiRetry => 'Cuba lagi';

  @override
  String get aiDismiss => 'Ketepikan';

  @override
  String get aiTyping => 'Jurulatih sedang menaip';

  @override
  String aiStarterCategory(String category) {
    return 'Ke mana perginya wang $category saya?';
  }

  @override
  String get aiStarterBudgets => 'Adakah bajet saya di landasan yang betul?';

  @override
  String get aiStarterUpcoming => 'Bil apa yang akan datang?';

  @override
  String get aiStarterAnalyze => 'Analisis corak perbelanjaan terkini saya';

  @override
  String get aiStarterBudgetTips =>
      'Beri saya petua untuk berbajet dengan lebih baik';

  @override
  String get aiStarterSave =>
      'Bagaimana saya boleh menyimpan lebih banyak wang?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” akan dipadam secara kekal.';
  }

  @override
  String get aiJustNow => 'Baru sahaja';

  @override
  String get aiErrorTitle => 'Jurulatih tidak dapat menjawab';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'Semua yang aplikasi boleh lakukan, untuk anda.';

  @override
  String get paywallActiveTitle => 'Premium aktif';

  @override
  String get paywallActiveTagline => 'Terima kasih atas sokongan anda!';

  @override
  String get paywallRestore => 'Pulihkan';

  @override
  String get paywallProcessing => 'Memproses…';

  @override
  String paywallTriggered(String feature) {
    return '$feature ialah ciri Premium';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days hari berbaki';
  }

  @override
  String get paywallFeatSync => 'Segerak awan';

  @override
  String get paywallFeatSyncSub => 'Semua peranti';

  @override
  String get paywallFeatAi => 'Pembantu AI';

  @override
  String get paywallFeatAiSub => 'Tanpa had, tanpa iklan';

  @override
  String get paywallFeatOcr => 'Imbas resit';

  @override
  String get paywallFeatOcrSub => 'OCR dengan AI';

  @override
  String get paywallFeatInsights => 'Analisis perbelanjaan';

  @override
  String get paywallFeatInsightsSub => 'Trend bulanan';

  @override
  String get paywallFeatThemes => '5 tema';

  @override
  String get paywallFeatThemesSub => 'Eksklusif';

  @override
  String get paywallFeatPdf => 'Laporan PDF';

  @override
  String get paywallFeatPdfSub => 'CSV kekal percuma';

  @override
  String get paywallFeatUnlimited => 'Tanpa had';

  @override
  String get paywallFeatUnlimitedSub => 'Dompet, bajet';

  @override
  String get paywallFeatSupport => 'Bantuan keutamaan';

  @override
  String get paywallFeatSupportSub => 'Balasan lebih pantas';

  @override
  String get paywallPerMonth => '/bulan';

  @override
  String get paywallPerYear => '/tahun';

  @override
  String get paywallOnce => 'sekali';

  @override
  String get paywallBestValue => 'NILAI TERBAIK';

  @override
  String get paywallForever => 'SELAMANYA';

  @override
  String get paywallMonthlyDesc => 'Dibil bulanan';

  @override
  String get paywallYearlyDesc => 'Dibil tahunan';

  @override
  String get paywallLifetimeDesc => 'Bayar sekali, milik selamanya';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial percuma, kemudian $rest';
  }

  @override
  String get paywallCtaLifetime => 'Dapatkan akses seumur hidup';

  @override
  String get paywallCtaYearly => 'Mulakan pelan tahunan';

  @override
  String get paywallCtaMonthly => 'Mulakan pelan bulanan';

  @override
  String get paywallFootLifetime => 'Pembelian sekali · Tiada langganan';

  @override
  String get paywallFootSubscription =>
      'Diperbaharui secara automatik · Batal bila-bila masa di kedai';

  @override
  String get paywallTerms =>
      'Langganan dicaj ke akaun App Store atau Google Play anda dan diperbaharui secara automatik melainkan dibatalkan sekurang-kurangnya 24 jam sebelum tamat tempoh semasa.';

  @override
  String get paywallIapUnavailable =>
      'Pembelian dalam aplikasi tidak tersedia pada peranti ini. Pastikan Perkhidmatan Google Play dipasang dan aplikasi dimuat turun dari Play Store.';

  @override
  String get paywallLoadingPlans => 'Memuatkan pelan…';

  @override
  String get paywallPlansFailed =>
      'Tidak dapat memuatkan pelan. Semak sambungan anda dan cuba lagi.';

  @override
  String get paywallTryAgain => 'Cuba lagi';

  @override
  String get paywallRestored => 'Pembelian dipulihkan';

  @override
  String get paywallPurchased => 'Selamat datang ke Premium!';

  @override
  String get paywallLifetimeNever => 'Akses seumur hidup tidak akan tamat';

  @override
  String get helpSearchQuestions => 'Cari soalan';

  @override
  String get helpStepWallets => 'Tambah dompet';

  @override
  String get helpStepCategories => 'Pilih kategori';

  @override
  String get helpStepTrack => 'Rekod setiap hari';

  @override
  String get splashTagline => 'Wang, lebih ceria.';

  @override
  String get introStep1 => 'Mengira syiling anda…';

  @override
  String get introStep2 => 'Mengejutkan dompet anda…';

  @override
  String get introStep3 => 'Menggilap carta…';

  @override
  String get introStep4 => 'Hampir siap…';

  @override
  String get introTipLabel => 'Petua kewangan';

  @override
  String get introTip1 =>
      'Bayar diri anda dahulu: pindahkan simpanan pada hari gaji masuk.';

  @override
  String get introTip2 =>
      'Perbelanjaan kecil harian bertambah. Merekodnya separuh daripada perjuangan.';

  @override
  String get introTip3 =>
      'Dana kecemasan 3 bulan mengubah kejutan menjadi sekadar kesulitan kecil.';

  @override
  String get introTip4 =>
      'Semak langganan setiap bulan: batalkan yang tidak anda guna.';

  @override
  String get introTip5 => 'Beri setiap ringgit tugasnya sebelum bulan bermula.';

  @override
  String get introTip6 =>
      'Tunggu 24 jam sebelum sebarang pembelian yang tidak dirancang.';

  @override
  String get introTip7 =>
      'Bajet bukan sekatan, ia kebenaran untuk berbelanja pada perkara yang penting.';

  @override
  String get introTip8 =>
      'Raikan kejayaan kecil: setiap matlamat bermula dengan simpanan pertama.';

  @override
  String get adConfirmTitleAiCall => 'Dapatkan satu lagi permintaan AI';

  @override
  String get adConfirmTitleTheme => 'Cuba tema premium selama 24 jam';

  @override
  String get adConfirmTitlePdf => 'Eksport satu laporan PDF';

  @override
  String get adConfirmBodyAiCall =>
      'Anda telah menggunakan permintaan AI percuma bulan ini. Tonton iklan pendek dan dapatkan satu lagi.';

  @override
  String get adConfirmBodyTheme =>
      'Tonton iklan pendek dan setiap tema premium milik anda selama 24 jam akan datang.';

  @override
  String get adConfirmBodyPdf =>
      'Tonton iklan pendek untuk mengeksport satu laporan PDF.';

  @override
  String get adConfirmWarning => 'Anda akan menonton iklan. Teruskan?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lagi iklan tersedia bulan ini',
      one: '1 lagi iklan tersedia bulan ini',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Ahli Premium mendapat AI tanpa had, semua tema dan laporan PDF, tanpa iklan langsung.';

  @override
  String get adWatch => 'Tonton iklan';

  @override
  String get adGetPremium => 'Dapatkan Premium';

  @override
  String get adNotNow => 'Bukan sekarang';

  @override
  String get adLoading => 'Memuatkan iklan…';

  @override
  String get adVerifying => 'Mengesahkan ganjaran anda…';

  @override
  String get adUnavailable =>
      'Tiada iklan tersedia sekarang. Sila cuba lagi sebentar lagi.';

  @override
  String get adSkipped =>
      'Iklan ditutup sebelum tamat, jadi tiada apa-apa dibuka.';

  @override
  String get adRewardAiCall => 'Selesai! Anda ada satu lagi permintaan AI.';

  @override
  String get adRewardTheme => 'Tema premium dibuka selama 24 jam.';

  @override
  String get adRewardPdf => 'Satu eksport PDF dibuka.';

  @override
  String get adMonthlyCapReached =>
      'Itu semua iklan untuk bulan ini. Permintaan percuma anda kembali pada 1 haribulan, atau langgan Premium untuk tanpa had.';

  @override
  String get adRewardPending =>
      'Terima kasih! Ganjaran anda akan muncul sebentar lagi.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permintaan AI percuma berbaki bulan ini',
      one: '1 permintaan AI percuma berbaki bulan ini',
      zero: 'Tiada lagi permintaan AI percuma bulan ini',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: tanpa had';

  @override
  String get aiToolSearching => 'Mencari transaksi anda…';

  @override
  String get aiToolSummarizing => 'Menjumlahkan angka…';

  @override
  String get aiToolAccounts => 'Menyemak akaun anda…';

  @override
  String get aiToolCategories => 'Melihat kategori anda…';

  @override
  String get aiToolCards => 'Menyemak bil kad…';

  @override
  String get aiToolPlans => 'Menyemak ansuran dan simpanan…';

  @override
  String get aiToolSaving => 'Menyimpan…';

  @override
  String get aiActionAddTitle => 'Tambah transaksi ini?';

  @override
  String get aiActionUpdateTitle => 'Ubah transaksi ini?';

  @override
  String get aiActionDeleteTitle => 'Padam transaksi ini?';

  @override
  String get aiActionPayCardTitle => 'Bayar bil kad';

  @override
  String get aiActionCardSettingsTitle => 'Tukar tarikh kad';

  @override
  String get aiActionCreatePlanTitle => 'Mulakan pelan';

  @override
  String get aiActionPayPlanTitle => 'Rekod bayaran pelan';

  @override
  String get aiActionClosePlanTitle => 'Tamatkan pelan lebih awal';

  @override
  String get aiActionUpdatePlanTitle => 'Ubah pelan';

  @override
  String get aiActionCreateInvestmentTitle => 'Tambah pelaburan';

  @override
  String get aiActionTradeInvestmentTitle => 'Rekod dagangan';

  @override
  String get aiActionUpdateInvestmentTitle => 'Kemas kini harga';

  @override
  String get aiActionConfirm => 'Sahkan';

  @override
  String get aiActionClosePlan => 'Tamatkan';

  @override
  String get aiActionFrom => 'Dari';

  @override
  String get aiActionTo => 'Ke';

  @override
  String get aiActionBill => 'Bil';

  @override
  String get aiActionLeftAfter => 'Baki selepas';

  @override
  String get aiActionRemindDays => 'Ingatkan, hari sebelum';

  @override
  String get aiActionPay => 'Bayar';

  @override
  String get plansTitle => 'Ansuran, pinjaman & simpanan';

  @override
  String get investmentsTitle => 'Pelaburan';

  @override
  String get investmentsSubtitle =>
      'Unit amanah, saham dan SIP, dinilai pada harga terkini';

  @override
  String get forecastTitle => 'Ramalan aliran tunai';

  @override
  String get forecastSubtitle =>
      'Ke mana wang tunai dan bank anda menuju, dan hari ia tidak mencukupi';

  @override
  String forecastRangeDays(int days) {
    return '$days hari';
  }

  @override
  String get forecastNow => 'Tunai dan bank sekarang';

  @override
  String get forecastMoneyIn => 'Masuk';

  @override
  String get forecastMoneyOut => 'Keluar';

  @override
  String get forecastLowest => 'Terendah';

  @override
  String forecastLowestOn(String date) {
    return 'pada $date';
  }

  @override
  String get forecastChartTitle => 'Baki unjuran';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'Pada $date anda akan kekurangan $amount';
  }

  @override
  String get forecastShortfallCause => 'Keluar pada hari itu:';

  @override
  String get forecastAlreadyShort =>
      'Akaun tunai dan bank anda sudah di bawah sifar.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'Tiada kekurangan dalam $days hari akan datang';
  }

  @override
  String get forecastAllCoveredBody =>
      'Apa yang dijadualkan dapat ditampung oleh wang tunai dan bank anda.';

  @override
  String get forecastScheduledOnly =>
      'Hanya mengira yang dijadualkan: pelan, bil kad, langganan, bayaran berulang dan akan datang, serta pinjaman dengan tarikh akhir. Perbelanjaan harian tidak termasuk.';

  @override
  String get forecastEventsTitle => 'Akan datang';

  @override
  String forecastDayBalance(String amount) {
    return 'Baki $amount';
  }

  @override
  String get forecastEmptyTitle => 'Tiada yang dijadualkan';

  @override
  String get forecastEmptyBody =>
      'Pelan, bil kad, langganan dan bayaran akan datang dalam tempoh ini ditunjukkan di sini.';

  @override
  String get forecastOverdue => 'Tertunggak';

  @override
  String get forecastExpected => 'Dijangka';

  @override
  String get forecastEventWhen => 'Bila';

  @override
  String get forecastEventKind => 'Jenis';

  @override
  String get forecastEventAccount => 'Akaun';

  @override
  String get forecastEventOpen => 'Buka';

  @override
  String get forecastEventOverdueNote =>
      'Tarikhnya telah berlalu dan ia masih terbuka, jadi ia dikira perlu dibayar hari ini.';

  @override
  String get forecastKindInstallment => 'Ansuran';

  @override
  String get forecastKindPremium => 'Premium';

  @override
  String get forecastKindDeposit => 'Deposit';

  @override
  String get forecastKindSipBuy => 'Pembelian SIP';

  @override
  String get forecastKindProfit => 'Keuntungan';

  @override
  String get forecastKindMaturity => 'Matang';

  @override
  String get forecastKindCardBill => 'Bil kad';

  @override
  String get forecastKindCardBillNext => 'Bil kad seterusnya, setakat ini';

  @override
  String get forecastKindSubscription => 'Langganan';

  @override
  String get forecastKindRecurringBill => 'Bayaran berulang';

  @override
  String get forecastKindRecurringIncome => 'Pendapatan berulang';

  @override
  String get forecastKindUpcoming => 'Akan datang';

  @override
  String get forecastKindBorrowed => 'Pinjaman perlu dibayar balik';

  @override
  String get forecastKindLent => 'Dipinjamkan, perlu dipulangkan';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'Anda mungkin kekurangan $amount pada $date';
  }

  @override
  String get forecastHomeWarningBody => 'Lihat apa yang akan datang';

  @override
  String get forecastDismiss => 'Ketepikan';

  @override
  String forecastNotifTitle(String day) {
    return 'Anda mungkin kekurangan wang pada $day';
  }

  @override
  String get settingsBillReminders => 'Peringatan bil dan ansuran';

  @override
  String get settingsBillRemindersSub =>
      'Bil kad perlu dibayar, dan ansuran atau simpanan yang akan datang';

  @override
  String get forecastNotifNowTitle => 'Anda kekurangan wang hari ini';

  @override
  String forecastNotifNowBody(String amount) {
    return 'Jumlah yang perlu dibayar sekarang $amount lebih daripada baki akaun anda. Ketik untuk melihat apa yang akan datang.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Bayaran berjadual akan menyebabkan anda kekurangan $amount. Ketik untuk melihat apa yang akan datang.';
  }

  @override
  String get investmentsEmptyTitle => 'Belum ada pelaburan';

  @override
  String get investmentsEmptyBody =>
      'Jejak unit amanah, saham atau emas: harga yang anda bayar, nilainya sekarang, dan keuntungannya.';

  @override
  String get investmentsSold => 'Dijual';

  @override
  String get investmentsWorth => 'Nilai sekarang';

  @override
  String get investmentNew => 'Pelaburan baharu';

  @override
  String get investmentNewHint =>
      'Unit dana, saham syarikat, atau apa sahaja yang dibeli mengikut unit, seperti emas mengikut gram.';

  @override
  String get investmentKindFund => 'Dana';

  @override
  String get investmentKindStock => 'Saham';

  @override
  String get investmentKindOther => 'Lain-lain';

  @override
  String get investmentNameHintFund => 'cth. Dana Amanah Pendapatan';

  @override
  String get investmentNameHintStock => 'cth. Maybank';

  @override
  String get investmentNameHintOther => 'cth. Emas, 22 karat';

  @override
  String get investmentSymbol => 'Simbol atau kod (pilihan)';

  @override
  String get investmentFirstBuy => 'Apa yang anda beli';

  @override
  String get investmentFirstBuyHint =>
      'Biarkan jumlah kosong untuk menambahnya tanpa membeli apa-apa lagi.';

  @override
  String get investmentPaid => 'Dibayar';

  @override
  String get investmentReceived => 'Diterima';

  @override
  String get investmentPaidInto => 'Dibayar ke';

  @override
  String get investmentFee => 'Yuran atau komisen';

  @override
  String get investmentUnits => 'Unit';

  @override
  String get investmentUnitsSold => 'Unit dijual';

  @override
  String investmentUnitsShort(String units) {
    return '$units unit';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price seunit';
  }

  @override
  String get investmentNeedUnits => 'Masukkan bilangan unit yang dibeli.';

  @override
  String get investmentSave => 'Tambah pelaburan';

  @override
  String get investmentAdded => 'Pelaburan ditambah';

  @override
  String get investmentGone => 'Pelaburan ini telah dipadam.';

  @override
  String get netWorthSubtitle =>
      'Semua yang anda miliki, tolak hutang anda, dan perubahannya';

  @override
  String get netWorthToday => 'Nilai anda';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount sejak bulan lepas';
  }

  @override
  String get netWorthBreakdown => 'Komposisinya';

  @override
  String get netWorthCash => 'Tunai & bank';

  @override
  String get netWorthCards => 'Kad kredit';

  @override
  String get netWorthDeposits => 'Deposit simpanan';

  @override
  String get netWorthAssets => 'Aset';

  @override
  String get netWorthLent => 'Dipinjamkan kepada orang lain';

  @override
  String get netWorthBorrowed => 'Dipinjam';

  @override
  String get netWorthLoansNote =>
      'Wang yang anda pinjamkan dikira milik anda sehingga dibayar balik, dan wang yang anda pinjam ditolak sehingga anda membayarnya balik.';

  @override
  String get netWorthCardsLeftOut =>
      'Kad kredit tidak dikira; anda boleh menukarnya dalam Tetapan.';

  @override
  String get netWorthHistory => 'Pada setiap hujung bulan';

  @override
  String get netWorthSixMonths => '6 bulan';

  @override
  String get netWorthOneYear => '1 tahun';

  @override
  String get netWorthAllTime => 'Semua';

  @override
  String get netWorthHistoryEmpty =>
      'Garisan bermula sebaik sahaja sebulan berakhir dengan rekod anda di dalamnya.';

  @override
  String get assetNew => 'Tambah aset';

  @override
  String get assetNewHint =>
      'Tanah, rumah atau pangsapuri, kereta, emas atau apa sahaja yang anda miliki. Nilainya dikira dalam nilai bersih anda.';

  @override
  String get assetKind => 'Apakah ia';

  @override
  String get assetKindLand => 'Tanah';

  @override
  String get assetKindHome => 'Pangsapuri atau rumah';

  @override
  String get assetKindCar => 'Kenderaan';

  @override
  String get assetKindGold => 'Emas & barang kemas';

  @override
  String get assetKindOther => 'Lain-lain';

  @override
  String get assetNameHintLand => 'cth. Lot tanah di Kajang';

  @override
  String get assetNameHintHome => 'cth. Kondo di Cheras';

  @override
  String get assetNameHintCar => 'cth. Proton Saga';

  @override
  String get assetNameHintGold => 'cth. Barang kemas perkahwinan';

  @override
  String get assetNameHintOther => 'cth. Kamera';

  @override
  String get assetWorthNow => 'Nilai sekarang';

  @override
  String get assetBoughtNow => 'Dibayar daripada akaun';

  @override
  String get assetBoughtNowHint =>
      'Mati: anda sudah memilikinya, dan tiada wang bergerak.';

  @override
  String get assetSave => 'Tambah aset';

  @override
  String get assetAdded => 'Aset ditambah';

  @override
  String get assetsEmptyTitle => 'Belum ada aset';

  @override
  String get assetsEmptyBody =>
      'Tambah tanah, rumah, kereta atau emas untuk melihat jumlah nilai anda.';

  @override
  String get assetsSold => 'Dijual';

  @override
  String assetCostLine(String amount) {
    return 'Kos $amount';
  }

  @override
  String get assetUpdateValue => 'Kemas kini nilai';

  @override
  String get assetSell => 'Jual';

  @override
  String get assetDelete => 'Buang';

  @override
  String get assetValueUpdated => 'Nilai dikemas kini';

  @override
  String get assetSold => 'Dijual, dan wang direkodkan';

  @override
  String assetDeleteTitle(String name) {
    return 'Buang $name?';
  }

  @override
  String get assetDeleteBody =>
      'Ia tidak lagi dikira. Sejarahnya kekal dalam rekod anda.';

  @override
  String get assetDeleted => 'Aset dibuang';

  @override
  String get aiActionCreateAssetTitle => 'Tambah aset';

  @override
  String get aiActionUpdateAssetTitle => 'Kemas kini nilai aset';

  @override
  String get aiActionSellAssetTitle => 'Jual aset';

  @override
  String get investmentWorthNow => 'Nilai sekarang';

  @override
  String investmentGainLine(String gain) {
    return '$gain keseluruhan';
  }

  @override
  String get investmentPrice => 'Harga';

  @override
  String get investmentPutIn => 'Dimasukkan';

  @override
  String get investmentTakenOut => 'Dikeluarkan';

  @override
  String get investmentBuy => 'Beli';

  @override
  String get investmentSell => 'Jual';

  @override
  String investmentBuyTitle(String name) {
    return 'Beli $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'Jual $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Dividen daripada $name';
  }

  @override
  String get investmentDividend => 'Dividen';

  @override
  String get investmentRecordDividend => 'Rekod dividen';

  @override
  String investmentHeldNow(String units) {
    return '$units unit dipegang sekarang.';
  }

  @override
  String get investmentRecorded => 'Direkodkan';

  @override
  String get investmentUpdatePrice => 'Kemas kini harga';

  @override
  String get investmentUpdatePriceHint =>
      'NAV atau harga saham hari ini, untuk satu unit';

  @override
  String get investmentPriceUpdated => 'Harga dikemas kini';

  @override
  String get investmentStartSip => 'Mulakan SIP';

  @override
  String get investmentStartSipHint =>
      'Beli jumlah tetap setiap bulan, secara automatik';

  @override
  String get investmentHistory => 'Sejarah';

  @override
  String investmentBought(String units) {
    return 'Membeli $units unit';
  }

  @override
  String investmentSold(String units) {
    return 'Menjual $units unit';
  }

  @override
  String get investmentPriceRose => 'Harga naik';

  @override
  String get investmentPriceFell => 'Harga turun';

  @override
  String get investmentUnitsUnknown =>
      'unit belum diketahui, ketik untuk tambah';

  @override
  String get investmentCorrectUnits => 'Unit pada dagangan ini';

  @override
  String get investmentCorrectUnitsHint =>
      'Seperti yang ditunjukkan dalam penyata dana atau broker anda.';

  @override
  String get investmentUnitsCorrected => 'Unit dibetulkan';

  @override
  String get investmentDelete => 'Padam pelaburan ini';

  @override
  String investmentDeleteTitle(String name) {
    return 'Padam $name?';
  }

  @override
  String get investmentDeleteBody =>
      'Dagangannya kekal dalam sejarah anda. Hanya boleh selepas semuanya dijual.';

  @override
  String get investmentDeleted => 'Pelaburan dipadam';

  @override
  String get plansSubtitle =>
      'Ansuran, pinjaman, DPS, FDR, insurans, bon dan SIP, dibayar dan dikutip tepat pada masanya';

  @override
  String get planNew => 'Mulakan pelan';

  @override
  String get planNewTitle => 'Apa yang anda mulakan?';

  @override
  String get plansEmptyTitle => 'Belum ada ansuran, pinjaman atau simpanan';

  @override
  String get plansEmptyBody =>
      'Jejak barang yang dibeli secara ansuran, pinjaman, DPS atau FDR. Ansuran direkodkan pada harinya dan anda diingatkan sebelum setiap satu.';

  @override
  String get plansEnded => 'Selesai';

  @override
  String get planKindEmi => 'Ansuran';

  @override
  String get planKindLoan => 'Pinjaman';

  @override
  String get planKindDps => 'DPS';

  @override
  String get planKindFdr => 'FDR';

  @override
  String get planKindInsurance => 'Insurans';

  @override
  String get planKindBond => 'Bon atau sijil';

  @override
  String get planKindSip => 'SIP';

  @override
  String get planKindEmiHint =>
      'Barang yang dibeli secara ansuran, dibayar dengan tunai, akaun bank atau kad';

  @override
  String get planKindLoanHint =>
      'Wang yang dipinjam dan dibayar balik secara ansuran, dengan faedah';

  @override
  String get planKindDpsHint =>
      'Simpan jumlah tetap setiap bulan untuk tempoh tetap, dan dapatkannya semula dengan keuntungan';

  @override
  String get planKindFdrHint =>
      'Simpan sejumlah wang di bank untuk tempoh tetap, dengan keuntungan bulanan, setiap tiga bulan atau pada akhirnya';

  @override
  String get planKindInsuranceHint =>
      'Polisi dengan premium setiap bulan, suku tahun atau tahun, dan bayaran pada akhirnya jika ada';

  @override
  String get planKindBondHint =>
      'Bon atau sijil simpanan: satu jumlah dipegang bertahun-tahun, dengan keuntungan bulanan, setiap tiga bulan atau pada akhirnya, selepas cukai';

  @override
  String get planKindSipHint =>
      'Jumlah tetap ke dalam dana atau saham setiap bulan, dibeli pada harga terkini';

  @override
  String get planWeekly => 'Mingguan';

  @override
  String get planMonthly => 'Bulanan';

  @override
  String get planQuarterly => 'Suku tahunan';

  @override
  String get planHalfYearly => 'Setengah tahunan';

  @override
  String get planYearly => 'Tahunan';

  @override
  String get planMonths => 'Bulan';

  @override
  String get planYears => 'Tahun';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount hingga $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved daripada $total disimpan';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid daripada $total dibayar';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Seterusnya: $amount pada $date';
  }

  @override
  String get planStatusCompleted => 'Selesai';

  @override
  String get planStatusClosed => 'Ditutup';

  @override
  String get planStatusOverdue => 'Tertunggak';

  @override
  String get planStatusRunning => 'Berjalan';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done daripada $total';
  }

  @override
  String get planGone => 'Pelan ini telah dipadam.';

  @override
  String get planAccount => 'Akaun';

  @override
  String get planAccountEmi => 'Dibayar daripada';

  @override
  String get planAccountLoan => 'Diterima ke dan dibayar daripada';

  @override
  String get planAccountSaving => 'Daripada akaun';

  @override
  String get planPrice => 'Harga';

  @override
  String get planBorrowed => 'Jumlah dipinjam';

  @override
  String get planDeposited => 'Jumlah didepositkan';

  @override
  String get planDeposit => 'Setiap deposit';

  @override
  String get planInstallment => 'Setiap ansuran';

  @override
  String get planWorkedOut => 'Dikira daripada harga, kadar dan tempoh';

  @override
  String get planProgress => 'Selesai';

  @override
  String get planSavedSoFar => 'Disimpan setakat ini';

  @override
  String get planPaidSoFar => 'Dibayar setakat ini';

  @override
  String get planLeft => 'Baki';

  @override
  String get planTotal => 'Keseluruhan';

  @override
  String get planInterestCharges => 'Faedah dan caj';

  @override
  String get planRate => 'Kadar';

  @override
  String get planRateLabel => 'Kadar % setahun';

  @override
  String get planRateOptional => 'Pilihan';

  @override
  String get planPayout => 'Keuntungan dibayar';

  @override
  String get planPayoutMonthly => 'Setiap bulan';

  @override
  String get planPayoutQuarterly => 'Setiap 3 bulan';

  @override
  String get planPayoutAtMaturity => 'Pada akhirnya';

  @override
  String get planMaturesOn => 'Matang pada';

  @override
  String get planMaturity => 'Dibayar balik pada akhirnya';

  @override
  String get planEstimated =>
      'Anggaran daripada kadar; ketik untuk memasukkan angka bank';

  @override
  String get planHolding => 'Dalam deposit sekarang';

  @override
  String get planEnds => 'Ansuran terakhir';

  @override
  String planTakeMaturity(String amount) {
    return 'Ambil wang matang, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Rekod keuntungan, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Bayar ansuran $number sekarang, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Bayar premium $number sekarang, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Buat deposit $number sekarang, $amount';
  }

  @override
  String get planRecorded => 'Direkodkan.';

  @override
  String get planSaved => 'Disimpan.';

  @override
  String get planPayOff => 'Langsaikan awal';

  @override
  String get planEncash => 'Tunaikan awal';

  @override
  String get planSurrender => 'Serahkan polisi';

  @override
  String planSurrenderTitle(String name) {
    return 'Serahkan $name?';
  }

  @override
  String get planSurrenderBody =>
      'Premium berhenti. Apa sahaja yang dibayar balik oleh syarikat insurans direkodkan sebagai pendapatan.';

  @override
  String get planSurrenderNothing => 'Tiada bayaran balik';

  @override
  String get planSurrenderValue => 'Masukkan nilai serahan';

  @override
  String get planSurrenderValueLabel => 'Nilai serahan';

  @override
  String get planStopSip => 'Hentikan SIP';

  @override
  String planStopSipTitle(String name) {
    return 'Hentikan $name?';
  }

  @override
  String get planStopSipBody =>
      'Tiada lagi pembelian. Apa yang telah dibeli kekal dalam pelaburan.';

  @override
  String get planSipStopped => 'SIP dihentikan';

  @override
  String get planSave => 'Simpan';

  @override
  String get planSurrendered => 'Polisi diserahkan';

  @override
  String planPayOffTitle(String name) {
    return 'Langsaikan $name?';
  }

  @override
  String get planPayOffHint => 'Satu bayaran untuk baki, dan pelan tamat.';

  @override
  String planPayOffLeft(String amount) {
    return 'Bayar baki, $amount';
  }

  @override
  String get planPayOffOther => 'Pemberi pinjaman menyebut jumlah berbeza';

  @override
  String planEncashTitle(String name) {
    return 'Tunaikan $name?';
  }

  @override
  String get planEncashBody =>
      'Wang dalam deposit kembali ke akaunnya, dan pelan tamat.';

  @override
  String get planEncashNoProfit => 'Tunaikan, tanpa keuntungan';

  @override
  String get planEncashWithProfit =>
      'Tunaikan, dengan keuntungan yang dibayar bank';

  @override
  String get planEncashed => 'Ditunaikan. Wang telah kembali ke akaunnya.';

  @override
  String get planPaidOff => 'Dilangsaikan.';

  @override
  String get planAutoCollect => 'Rekod secara automatik';

  @override
  String get planAutoCollectHint =>
      'Setiap ansuran, keuntungan dan wang matang direkodkan pada harinya';

  @override
  String get planSchedule => 'JADUAL';

  @override
  String get planDelete => 'Padam pelan ini';

  @override
  String planDeleteTitle(String name) {
    return 'Padam $name?';
  }

  @override
  String get planDeleteBody =>
      'Apa yang telah direkodkan kekal dalam transaksi anda. Tiada lagi rekod atau peringatan.';

  @override
  String get planDeleted => 'Dipadam.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Ansuran $number daripada $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Premium $number daripada $total';
  }

  @override
  String get planEventPayout => 'Bayaran polisi';

  @override
  String planEventProfit(int number) {
    return 'Keuntungan, bulan $number';
  }

  @override
  String get planEventMaturity => 'Matang';

  @override
  String get planEventDone => 'Selesai';

  @override
  String get planEventLate => 'Tertunggak';

  @override
  String get planEventUpcoming => 'Akan datang';

  @override
  String get planNeedAccount => 'Pilih akaun dahulu.';

  @override
  String get planCreated =>
      'Dimulakan. Apa sahaja yang sudah perlu dibayar telah direkodkan.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, termasuk $interest faedah dan caj.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, tanpa faedah.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'Anda memasukkan $deposited dan mendapat kembali kira-kira $maturity pada $date.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal bertambah menjadi kira-kira $maturity menjelang $date.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'Keuntungan $profit setiap bulan, dan $principal dikembalikan pada $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count premium sebanyak $premium, $total keseluruhan.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count premium sebanyak $premium, $total keseluruhan, dan $payout dikembalikan pada $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'Keuntungan $profit setiap tiga bulan, dan $principal dikembalikan pada $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount ke dalam $fund, $total keseluruhan.';
  }

  @override
  String planNewKind(String kind) {
    return '$kind baharu';
  }

  @override
  String get planName => 'Nama';

  @override
  String get planNameHintEmi => 'cth. Telefon dari Shopee';

  @override
  String get planNameHintLoan => 'cth. Pinjaman motosikal';

  @override
  String get planNameHintDps => 'cth. DPS Maybank';

  @override
  String get planNameHintFdr => 'cth. FDR CIMB';

  @override
  String get planNameHintInsurance => 'cth. Polisi hayat';

  @override
  String get planNameHintBond => 'cth. Sijil simpanan 5 tahun';

  @override
  String get planNameHintSip => 'cth. SIP dana bulanan';

  @override
  String get planSipFund => 'Membeli';

  @override
  String get planSipAmount => 'Setiap SIP';

  @override
  String get planSipNoFund => 'Tambah dana atau saham dalam Pelaburan dahulu.';

  @override
  String get planProvider => 'Bank atau syarikat';

  @override
  String get planReference => 'No. polisi atau akaun';

  @override
  String get planSumAssured => 'Jumlah diinsuranskan';

  @override
  String get planPremium => 'Premium';

  @override
  String get planPremiums => 'Premium';

  @override
  String get planTaxLabel => 'Cukai di sumber %';

  @override
  String get planTax => 'Cukai di sumber';

  @override
  String get planFirstPremium => 'Premium pertama';

  @override
  String get planLastPremium => 'Premium terakhir';

  @override
  String get planInsurancePayout => 'Dibayar balik pada akhirnya';

  @override
  String get planNone => 'Tiada';

  @override
  String get planHowMany => 'Berapa banyak';

  @override
  String get planTerm => 'Tempoh';

  @override
  String get planOpenedOn => 'Dibuka pada';

  @override
  String get planFirstDue => 'Ansuran pertama';

  @override
  String get planCategory => 'Kategori';

  @override
  String get planCategoryDefault => 'Bayaran Pinjaman';

  @override
  String get planCategoryInsurance => 'Insurans';

  @override
  String get planLoanReceived => 'Wang diterima ke akaun ini';

  @override
  String get planLoanReceivedHint => 'Mati jika ia terus kepada penjual';

  @override
  String get planStart => 'Mula';

  @override
  String get aiActionDeleteNote =>
      'Ia masuk ke Dipadam baru-baru ini, di mana anda boleh memulihkannya dalam 30 hari.';

  @override
  String get aiActionAdd => 'Tambahkan';

  @override
  String get aiActionSave => 'Simpan perubahan';

  @override
  String get aiActionDelete => 'Padamkan';

  @override
  String get aiActionCancel => 'Tidak, biarkan';

  @override
  String get aiActionAmount => 'Jumlah';

  @override
  String get aiActionKind => 'Jenis';

  @override
  String get aiActionTitle => 'Tajuk';

  @override
  String get aiActionCategory => 'Kategori';

  @override
  String get aiActionAccount => 'Akaun';

  @override
  String get aiActionDate => 'Tarikh';

  @override
  String get aiActionNotes => 'Nota';

  @override
  String get aiReport => 'Laporkan masalah';

  @override
  String get aiReportWrongAnswer => 'Jurulatih tersilap';

  @override
  String get aiReportWrongAnswerHint =>
      'Nombor salah, fakta rekaan, atau perubahan yang tidak anda minta';

  @override
  String get aiReportWrongAnswerSubject => 'Jurulatih kewangan: jawapan salah';

  @override
  String get aiReportBug => 'Laporkan pepijat';

  @override
  String get aiReportBugHint => 'Sesuatu rosak, beku atau tidak dimuatkan';

  @override
  String get aiReportBugSubject => 'Jurulatih kewangan: laporan pepijat';

  @override
  String get aiAboutCoach => 'Cara jurulatih berfungsi';

  @override
  String get aiDisclaimerTitle => 'Sebelum anda bertanya kepada jurulatih';

  @override
  String get aiDisclaimerMistakes =>
      'Jurulatih ialah AI. Ia boleh tersilap nombor, salah faham soalan atau menyatakan sesuatu yang tidak benar, jadi semak apa-apa yang penting dengan transaksi anda sendiri.';

  @override
  String get aiDisclaimerData =>
      'Angka anda dibaca pada telefon anda. Untuk menjawab, aplikasi menghantar soalan anda dan angka yang diperlukan ke pelayan kami dan model AI-nya.';

  @override
  String get aiDisclaimerChanges =>
      'Ia tidak pernah mengubah wang anda dengan sendirinya. Setiap penambahan, suntingan atau pemadaman ditunjukkan kepada anda dahulu dan hanya berlaku jika anda mengesahkannya.';

  @override
  String get aiDisclaimerReport =>
      'Jika jawapan kelihatan salah, ketik bendera di atas untuk memberitahu kami.';

  @override
  String get aiDisclaimerAccept => 'Saya faham';

  @override
  String get aiOutOfRequestsTitle =>
      'Anda telah menggunakan permintaan percuma bulan ini';

  @override
  String get aiOutOfRequestsBody =>
      'Tonton iklan pendek untuk bertanya soalan ini, atau langgan Premium untuk jawapan tanpa had tanpa iklan. Permintaan percuma kembali pada 1 haribulan.';

  @override
  String get ocrNoCamera => 'Tidak dapat membuka kamera.';

  @override
  String get ocrNoGallery => 'Tidak dapat membuka galeri.';

  @override
  String get ocrScanTitle => 'Imbas resit';

  @override
  String get ocrScanAnother => 'Imbas lagi';

  @override
  String get ocrScanBody =>
      'Ambil foto atau pilih satu. Aplikasi membacanya dan AI mengisi butirannya.';

  @override
  String get ocrReadingWithAi => 'AI sedang membaca resit anda…';

  @override
  String get ocrNothingRead =>
      'Tiada teks dapat dibaca daripada foto itu. Cuba lagi dalam cahaya lebih terang, dengan seluruh resit kelihatan.';

  @override
  String get ocrAiOfferTitle => 'Biar AI membacanya dengan betul';

  @override
  String get ocrAiOfferBody =>
      'Ia mencari jumlah sebenar, tarikh, setiap item dan kategori yang betul, walaupun pada resit yang bersepah.';

  @override
  String get ocrReadWithAi => 'Baca dengan AI';

  @override
  String get ocrReadByAi => 'Dibaca oleh AI. Semak sebelum menyimpan.';

  @override
  String get ocrItems => 'Item';

  @override
  String get quickAddTitle => 'Terangkan';

  @override
  String get quickAddSubtitle =>
      'Taip seperti anda menyebutnya. AI mengisi borang untuk anda semak.';

  @override
  String get quickAddHint => 'cth. makan tengah hari 25 semalam dari bKash';

  @override
  String get quickAddFill => 'Isikan';

  @override
  String get summaryTitle => 'Ringkasan bulanan';

  @override
  String get summarySpent => 'Dibelanjakan bulan ini';

  @override
  String summaryEarned(String amount) {
    return 'Diperoleh $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent% kurang daripada bulan lepas';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent% lebih daripada bulan lepas';
  }

  @override
  String get summaryAiTitle => 'Bulan anda, secara ringkas';

  @override
  String get summaryAiBody =>
      'AI membandingkan bulan anda dengan bulan lepas dan memilih apa yang menonjol, dengan satu perkara untuk dicuba.';

  @override
  String get summaryWrite => 'Tulis ringkasan saya';

  @override
  String get summaryOutdated =>
      'Transaksi anda telah berubah sejak ringkasan ini ditulis.';

  @override
  String get summaryUpdate => 'Kemas kini ringkasan saya';

  @override
  String get summaryWriting => 'Menulis ringkasan anda…';

  @override
  String get summaryByCategory => 'Mengikut kategori';

  @override
  String get summaryNoSpending =>
      'Belum ada perbelanjaan direkodkan bulan ini.';

  @override
  String themeTrialUntil(String time) {
    return 'Tema premium dibuka sehingga $time';
  }

  @override
  String get zakatTitle => 'Zakat';

  @override
  String get zakatSubtitle =>
      'Kira zakat yang wajib atas harta anda, dan rekod apa yang anda bayar';

  @override
  String get zakatSubtitleOff =>
      'Anda tidak membayar zakat. Ketik untuk menyemaknya juga';

  @override
  String get zakatAskTitle => 'Adakah anda membayar zakat?';

  @override
  String get zakatAskBody =>
      'Bukan semua orang membayarnya. Jika tidak, aplikasi tidak akan mengganggu anda tentang zakat: tiada yang perlu dibayar dan tiada peringatan.';

  @override
  String get zakatIPay => 'Saya membayar zakat';

  @override
  String get zakatIDontPay => 'Saya tidak membayar zakat';

  @override
  String get zakatOffTitle => 'Anda tidak membayar zakat';

  @override
  String get zakatOffBody =>
      'Jadi tiada zakat ditunjukkan sebagai perlu dibayar, dan tiada peringatan zakat. Anda masih boleh melihat jumlahnya pada bila-bila masa; melihat tidak mengubah jawapan anda.';

  @override
  String get zakatOffPeek => 'Lihat jumlahnya';

  @override
  String get zakatPeekBanner =>
      'Sekadar melihat. Anda telah menyatakan anda tidak membayar zakat.';

  @override
  String get zakatOptOutTitle => 'Berhenti menjejak zakat?';

  @override
  String get zakatOptOutBody =>
      'Tiada apa-apa akan ditunjukkan sebagai perlu dibayar dan tiada peringatan zakat. Angka anda disimpan, dan anda boleh menyemaknya di sini bila-bila masa.';

  @override
  String get zakatDue => 'Zakat wajib';

  @override
  String zakatAboveNisab(String amount) {
    return 'Melebihi nisab: 2.5% daripada harta bersih $amount';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'Di bawah nisab sebanyak $amount, jadi tiada zakat wajib';
  }

  @override
  String get zakatNeedPrice => 'Masukkan harga segram untuk menyemak nisab';

  @override
  String get zakatPaidSoFar => 'Dibayar tahun ini';

  @override
  String get zakatLeftToPay => 'Perlu dibayar';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tarikh zakat $date, dalam $days hari',
      one: 'Tarikh zakat esok, $date',
      zero: 'Tarikh zakat anda hari ini',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Tetapkan tarikh zakat anda untuk menjejak haul dan dapatkan peringatan';

  @override
  String get zakatPay => 'Bayar zakat';

  @override
  String get zakatNisab => 'Nisab';

  @override
  String get zakatBasisGold => 'Emas';

  @override
  String get zakatBasisSilver => 'Perak';

  @override
  String get zakatBasisHint =>
      'Perak memberikan nisab yang lebih rendah dan merupakan pilihan lebih berhati-hati apabila harta anda kebanyakannya tunai. Masukkan harga tempatan hari ini untuk satu gram.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Harga segram ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams g pada harga itu';
  }

  @override
  String get zakatGroupCash => 'Tunai dan bank';

  @override
  String get zakatGroupDeposits => 'Deposit simpanan';

  @override
  String get zakatGroupInvestments => 'Pelaburan';

  @override
  String get zakatGroupMetals => 'Emas dan perak';

  @override
  String get zakatGroupLent => 'Wang dipinjamkan kepada orang lain';

  @override
  String get zakatGroupOtherAssets => 'Aset lain';

  @override
  String get zakatGroupPaid => 'Zakat dibayar tahun ini';

  @override
  String get zakatGroupManual => 'Ditambah oleh anda';

  @override
  String get zakatGroupBorrowed => 'Tolak: wang yang anda hutang';

  @override
  String get zakatGroupCards => 'Tolak: tunggakan kad kredit';

  @override
  String get zakatOtherAssetsNote =>
      'Tanah, rumah atau kereta yang anda gunakan tidak dikenakan zakat. Hidupkan hanya jika anda memegangnya untuk perniagaan.';

  @override
  String get zakatPaidNote =>
      'Ditambah semula, kerana ia keluar dari akaun anda selepas harta tahun ini dikira.';

  @override
  String get zakatNoMetals =>
      'Tiada emas atau perak direkodkan. Tambahkannya sebagai aset, atau tambah nilainya di bawah.';

  @override
  String get zakatAddAmount => 'Tambah jumlah';

  @override
  String get zakatAmountLabel => 'Apakah ia?';

  @override
  String get zakatAmountHint => 'Stok perniagaan, tunai di rumah…';

  @override
  String get zakatAmountDeduct => 'Ia hutang yang perlu dibayar sekarang';

  @override
  String get zakatWealth => 'Harta yang dikenakan zakat';

  @override
  String get zakatDeductions => 'Hutang perlu dibayar sekarang';

  @override
  String get zakatNet => 'Harta bersih';

  @override
  String get zakatRate => '2.5% daripada harta bersih';

  @override
  String get zakatYear => 'Haul zakat';

  @override
  String get zakatDate => 'Tarikh zakat';

  @override
  String get zakatDateHint =>
      'Hari haul zakat anda genap. Ia berulang setiap tahun hijrah, 354 hari.';

  @override
  String get zakatRemind => 'Ingatkan saya';

  @override
  String get zakatRemindHint => '3 hari sebelum, dan pada hari itu';

  @override
  String get zakatDisclaimer =>
      'Ini panduan untuk membantu anda mengira zakat, bukan fatwa. Ulama berbeza pendapat dalam beberapa perincian; jika ragu, tanya ustaz atau pejabat zakat tempatan.';

  @override
  String get zakatPayNote =>
      'Direkodkan sebagai perbelanjaan di bawah Zakat, dan dikira untuk tahun ini.';

  @override
  String get zakatPayRecord => 'Rekod bayaran';

  @override
  String get zakatPaidSnack => 'Zakat direkodkan';

  @override
  String get aiToolZakat => 'Mengira zakat…';

  @override
  String get voiceButton => 'Sebut transaksi';

  @override
  String get voiceTitle => 'Sebutkan';

  @override
  String get voiceUnlimited => 'Tanpa had';

  @override
  String get voiceTapToTalk => 'Ketik bola dan sebut apa yang anda belanjakan';

  @override
  String get voiceListening => 'Mendengar…';

  @override
  String get voiceStop => 'Berhenti mendengar';

  @override
  String get voiceTypeInstead => 'Taip';

  @override
  String get voiceSpeakInstead => 'Cakap';

  @override
  String get voiceSend => 'Selesai';

  @override
  String get voiceTrySaying => 'Cuba sebut';

  @override
  String get voiceExample1 => 'Makan tengah hari 25, Grab 12';

  @override
  String get voiceExample2 => 'Dapat gaji, 4,500';

  @override
  String get voiceExample3 => 'Teh semalam 3, bukan 2';

  @override
  String get voiceExample4 => 'Padam makan tengah hari hari ini';

  @override
  String get voiceTypeHint => 'Makan tengah hari 25 dan Grab 12 dari bKash';

  @override
  String get voiceThinking => 'Sedang mengira…';

  @override
  String get voiceTryAgain => 'Sekali lagi';

  @override
  String get voiceSaving => 'Menyimpan…';

  @override
  String get voiceEdit => 'Sunting';

  @override
  String get voiceNeedsYou => 'Perlu tindakan';

  @override
  String get voiceNew => 'Baharu';

  @override
  String get voiceChange => 'Tukar';

  @override
  String get voiceRemove => 'Buang';

  @override
  String get voiceNeedsAmount =>
      'Tiada jumlah disebut. Isikan untuk menambah yang ini.';

  @override
  String get voiceAdjust => 'Laraskan';

  @override
  String get voiceFillIn => 'Isikan';

  @override
  String get voiceTime => 'Masa';

  @override
  String get voiceUndo => 'Buat asal';

  @override
  String get voiceUndone => 'Kembalikan seperti asal';

  @override
  String get voiceNoSpeech =>
      'Saya tidak dapat menangkapnya. Cuba lagi, atau taipkan.';

  @override
  String get voiceMicOff =>
      'Akses mikrofon dimatikan. Benarkan dalam Tetapan, atau taip sahaja.';

  @override
  String get voiceUnavailable =>
      'Suara tidak tersedia pada telefon ini. Anda boleh menaip sebagai ganti.';

  @override
  String get voiceSomethingWrong => 'Ada sesuatu yang tidak kena. Cuba lagi.';

  @override
  String get voiceFabSetting => 'Mikrofon terapung pada Hari ini';

  @override
  String get amountHidden => 'Jumlah tersembunyi';

  @override
  String get privacyShowAmounts => 'Tunjuk jumlah';

  @override
  String get privacyHideAmounts => 'Sembunyikan jumlah';

  @override
  String get privacyAmounts => 'Jumlah pada skrin';

  @override
  String get privacyAmountsFooter =>
      'Baki dan jumlah dikaburkan supaya orang berdekatan tidak dapat membacanya. Transaksi individu kekal kelihatan. Ikon mata pada Hari ini juga menunjukkan atau menyembunyikannya.';

  @override
  String get privacyHideTitle => 'Sembunyikan baki dan jumlah';

  @override
  String get privacyHideSub =>
      'Kaburkan sehingga anda memilih untuk menunjukkannya';

  @override
  String get privacyTapTitle => 'Ketik jumlah tersembunyi untuk menunjukkannya';

  @override
  String get privacyTapSub =>
      'Jika tidak, hanya ikon mata pada Hari ini menunjukkannya';

  @override
  String get privacyStartTitle => 'Apabila aplikasi dibuka';

  @override
  String get privacyStartHidden => 'Tersembunyi';

  @override
  String get privacyStartHiddenSub =>
      'Sentiasa buka dengan baki dan jumlah tersembunyi';

  @override
  String get privacyStartShown => 'Ditunjukkan';

  @override
  String get privacyStartShownSub =>
      'Sentiasa buka dengan baki dan jumlah ditunjukkan';

  @override
  String get privacyStartRemember => 'Seperti saya tinggalkan';

  @override
  String get privacyStartRememberSub =>
      'Buka mengikut keadaan terakhir ikon mata';

  @override
  String get privacyIntroTitle => 'Baharu: sembunyikan baki anda';

  @override
  String get privacyIntroBody =>
      'Baki dan jumlah kini disembunyikan, supaya orang berdekatan tidak dapat membacanya. Ketik ikon mata pada Hari ini untuk menunjukkan atau menyembunyikannya; aplikasi mengingati pilihan anda. Anda boleh memilih cara aplikasi dibuka dalam Tetapan.';

  @override
  String get privacyIntroOk => 'Faham';

  @override
  String get privacyIntroSettings => 'Pilih dalam Tetapan';

  @override
  String get voiceFabSettingSub =>
      'Mikrofon yang terapung di atas Hari ini, untuk menyebut transaksi';

  @override
  String get voiceFabAskTitle => 'Tambah mikrofon ke skrin Hari ini?';

  @override
  String get voiceFabAskBody =>
      'Ketik dan sebut apa yang anda belanjakan, seperti \"makan tengah hari 25 dan Grab 12\". Anda menyemak semuanya sebelum disimpan. Seret ke mana-mana sahaja.';

  @override
  String get voiceFabAskYes => 'Ya, tambah mikrofon';

  @override
  String get voiceFabAskNo => 'Bukan sekarang';

  @override
  String get voiceFabAskLater =>
      'Anda boleh menghidupkan atau mematikannya bila-bila masa dalam Lagi.';

  @override
  String get voiceFabHideTitle => 'Sembunyikan mikrofon terapung?';

  @override
  String get voiceFabHideBody =>
      'Mikrofon di bahagian atas Hari ini kekal. Anda boleh mengembalikan yang ini dalam Lagi.';

  @override
  String get voiceFabHide => 'Sembunyikan';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SEDIA DISIMPAN',
      one: '1 SEDIA DISIMPAN',
      zero: 'TIADA YANG SEDIA',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Simpan $count',
      one: 'Simpan 1',
      zero: 'Tiada dipilih',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi disimpan',
      one: '1 transaksi disimpan',
    );
    return '$_temp0';
  }
}
