// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get dateToday => 'Heute';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String get dateTomorrow => 'Morgen';

  @override
  String get navTransactions => 'Buchungen';

  @override
  String get settingsRegionalTitle => 'Regionale Einstellungen';

  @override
  String get settingsSectionCurrency => 'WÄHRUNG';

  @override
  String get settingsSectionDisplayFormat => 'ANZEIGEFORMAT';

  @override
  String get settingsSectionLanguage => 'SPRACHE';

  @override
  String get settingsDefaultCurrency => 'Standardwährung';

  @override
  String get settingsExchangeRates => 'Wechselkurse';

  @override
  String get settingsExchangeRatesSubtitle => 'Umrechnungskurse verwalten';

  @override
  String get settingsDateFormat => 'Datumsformat';

  @override
  String get settingsNumberFormat => 'Zahlenformat';

  @override
  String get settingsCurrencySymbol => 'Währungssymbol';

  @override
  String get settingsTimeFormat => 'Zeitformat';

  @override
  String get settingsFirstDayOfWeek => 'Erster Wochentag';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsPreview => 'Vorschau';

  @override
  String get previewDate => 'Datum';

  @override
  String get previewTime => 'Uhrzeit';

  @override
  String get previewAmount => 'Betrag';

  @override
  String get previewWeekStarts => 'Diese Woche beginnt';

  @override
  String get choiceMatchMyPhone => 'Wie auf meinem Handy';

  @override
  String get symbolBeforeAmount => 'Vor dem Betrag';

  @override
  String get symbolAfterAmount => 'Nach dem Betrag';

  @override
  String get time12Hour => '12 Std. (1:30 PM)';

  @override
  String get time24Hour => '24 Std. (13:30)';

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get selectDateFormat => 'Datumsformat wählen';

  @override
  String get selectNumberFormat => 'Zahlenformat wählen';

  @override
  String get selectCurrency => 'Währung wählen';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get languageSystem => 'Wie auf meinem Handy';

  @override
  String get sectionAccount => 'KONTO';

  @override
  String get sectionDataManagement => 'DATENVERWALTUNG';

  @override
  String get sectionHelpSupport => 'HILFE & SUPPORT';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsBackupRestore => 'Sichern & Wiederherstellen';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Eine Datei für dich oder automatische Kopien in Google Drive';

  @override
  String get settingsImportStatement => 'Kontoauszug importieren';

  @override
  String get settingsImportStatementSubtitle =>
      'CSV deiner Bank einlesen – einmal zuordnen, dann gemerkt';

  @override
  String get settingsExportData => 'Daten exportieren';

  @override
  String get settingsRecentlyDeleted => 'Zuletzt gelöscht';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'In den letzten dreißig Tagen Gelöschtes zurückholen';

  @override
  String get themePremiumHeading => 'Premium-Designs';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get dashCreditDebt => 'Forderungen & Schulden';

  @override
  String get dashSubscriptions => 'Abos';

  @override
  String get moneyIncome => 'Einnahmen';

  @override
  String get dashExpenses => 'Ausgaben';

  @override
  String get dashSpendingOverview => 'Ausgabenübersicht';

  @override
  String get dashBudgetProgress => 'Budgetfortschritt';

  @override
  String get actionDelete => 'Löschen';

  @override
  String txDeleteManyTitle(int count) {
    return '$count Buchungen löschen?';
  }

  @override
  String get txDeleteManyBody =>
      'Salden werden neu berechnet. Bei Umbuchungen darunter wird die Gegenbuchung mitgelöscht.';

  @override
  String get txMoveToAccount => 'In Konto verschieben';

  @override
  String get txDeleted => 'Buchung gelöscht';

  @override
  String txDeleteFailed(String error) {
    return 'Buchung konnte nicht gelöscht werden: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get txActions => 'Aktionen';

  @override
  String get txChangeCategory => 'Kategorie ändern';

  @override
  String get txChangeDate => 'Datum ändern';

  @override
  String get txMarkAsPaid => 'Als bezahlt markieren';

  @override
  String get txMarkAsCorrection => 'Als Saldokorrektur markieren';

  @override
  String get txMarkAsCorrectionTitle => 'Weder Einnahme noch Ausgabe?';

  @override
  String get txMarkAsCorrectionBody =>
      'Nutze das für Geld, das weder verdient noch ausgegeben wurde, z. B. ein erhöhtes Kartenlimit. Der Saldo bleibt gleich, es zählt nur nicht mehr als Einnahme oder Ausgabe.';

  @override
  String get txMarkedAsCorrection => 'Jetzt eine Saldokorrektur.';

  @override
  String get txMarkAsCorrectionFailed =>
      'Diese Buchung kann keine Korrektur sein.';

  @override
  String get txDuplicate => 'Duplizieren';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterDirection => 'Richtung';

  @override
  String get filterState => 'Status';

  @override
  String get filterKind => 'Art';

  @override
  String get filterTransfers => 'Umbuchungen';

  @override
  String get filterAccounts => 'Konten';

  @override
  String get filterCategories => 'Kategorien';

  @override
  String get filterDates => 'Zeitraum';

  @override
  String get filterBudget => 'Budget';

  @override
  String get filterGoal => 'Ziel';

  @override
  String get filterNone => 'Keine';

  @override
  String get filterThisMonth => 'Dieser Monat';

  @override
  String get filterLastMonth => 'Letzter Monat';

  @override
  String get filterLast3Months => 'Letzte 3 Monate';

  @override
  String get filterThisYear => 'Dieses Jahr';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen anzeigen',
      one: '1 Buchung anzeigen',
      zero: 'Keine passenden Buchungen',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Zurücksetzen';

  @override
  String get filterNoMatches => 'Keine Treffer';

  @override
  String get filterAny => 'Alle';

  @override
  String get filterSpent => 'Ausgegeben';

  @override
  String get filterEarned => 'Eingenommen';

  @override
  String get filterHidden => 'Ausgeblendet';

  @override
  String get filterIncluded => 'Einbezogen';

  @override
  String get filterOnly => 'Nur';

  @override
  String get filterFrom => 'Von';

  @override
  String get filterTo => 'Bis';

  @override
  String get actionApply => 'Anwenden';

  @override
  String get filterPaid => 'Bezahlt';

  @override
  String get filterNotYet => 'Noch nicht';

  @override
  String get filterSkipped => 'Übersprungen';

  @override
  String get filterAmount => 'Betrag';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get entityBudget => 'Budget';

  @override
  String get budgetGone => 'Dieses Budget existiert nicht mehr.';

  @override
  String get budgetEarlier => 'Früher';

  @override
  String get budgetLater => 'Später';

  @override
  String get budgetWhereItWent => 'Wohin es ging';

  @override
  String get budgetRecentPeriods => 'Letzte Zeiträume';

  @override
  String get budgetCaps => 'Limits';

  @override
  String get actionAdd => 'Hinzufügen';

  @override
  String get budgetNoCategoriesToCap =>
      'Dieses Budget hat noch keine Kategorien zum Begrenzen.';

  @override
  String get budgetCapACategory => 'Kategorie begrenzen';

  @override
  String get entityCategory => 'Kategorie';

  @override
  String get budgetAsShare => 'Als Anteil am Budget';

  @override
  String get budgetAsShareHint => 'Passt sich an, wenn du das Budget änderst';

  @override
  String get actionSet => 'Festlegen';

  @override
  String get budgetAcrossPeriod => 'Über den Zeitraum';

  @override
  String get budgetPreviousPeriod => 'Vorheriger Zeitraum';

  @override
  String get budgetEvenPace => 'Gleichmäßiges Tempo';

  @override
  String get budgetNew => 'Neues Budget';

  @override
  String get budgetCreate => 'Budget erstellen';

  @override
  String budgetDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get entityAccount => 'Konto';

  @override
  String get entityTransaction => 'Buchung';

  @override
  String get walletGone => 'Dieses Konto existiert nicht mehr.';

  @override
  String get walletCorrectBalance => 'Saldo korrigieren';

  @override
  String get walletCorrectBalanceSubtitle =>
      'Die Differenz zum echten Wert erfassen';

  @override
  String get walletMergeInto => 'Mit anderem Konto zusammenführen';

  @override
  String get walletInThisMonth => 'Eingang diesen Monat';

  @override
  String get walletOutThisMonth => 'Ausgang diesen Monat';

  @override
  String get walletRecentActivity => 'Letzte Aktivität';

  @override
  String get walletNoOtherAccount =>
      'Es gibt kein anderes Konto zum Zusammenführen.';

  @override
  String get walletMergeIntoTitle => 'Zusammenführen mit';

  @override
  String get walletMergeAction => 'Zusammenführen';

  @override
  String walletMerged(int count, String target) {
    return '$count nach $target verschoben.';
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
      other: '$removed Umbuchungen zwischen den beiden Konten wurden entfernt',
      one: 'Eine Umbuchung zwischen den beiden Konten wurde entfernt',
    );
    return '$count nach $target verschoben. $_temp0, da sie keine zwei Seiten mehr hatte.';
  }

  @override
  String get walletRealBalance => 'Echter Saldo';

  @override
  String get walletCorrectAction => 'Korrigieren';

  @override
  String get txGone => 'Diese Buchung existiert nicht mehr.';

  @override
  String get txKind => 'Art';

  @override
  String get txState => 'Status';

  @override
  String get txWasDue => 'War fällig';

  @override
  String get txNotes => 'Notizen';

  @override
  String get txDeleteOneTitle => 'Diese Buchung löschen?';

  @override
  String get rulesTitle => 'Benennungsregeln';

  @override
  String get rulesAdd => 'Regel hinzufügen';

  @override
  String rulesRemoved(String title) {
    return 'Regel für $title entfernt';
  }

  @override
  String get rulesWhenTitleSays => 'Wenn der Titel lautet';

  @override
  String get rulesMatchExactly => 'Exakt übereinstimmen';

  @override
  String get rulesChooseCategory => 'Kategorie wählen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get goalNew => 'Neues Ziel';

  @override
  String get goalLoadFailed => 'Deine Ziele konnten nicht geladen werden.';

  @override
  String get goalCreate => 'Ziel erstellen';

  @override
  String get trashTitle => 'Zuletzt gelöscht';

  @override
  String get trashRestore => 'Wiederherstellen';

  @override
  String get trashRestored => 'Wiederhergestellt.';

  @override
  String get payTitle => 'Zahlungsmethoden';

  @override
  String get payDefault => 'Standard';

  @override
  String get payAddOne => 'Hinzufügen';

  @override
  String payDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get payName => 'Name';

  @override
  String get payNameHint => 'Alltags-Debitkarte';

  @override
  String get payKind => 'Art';

  @override
  String get payBankOrIssuer => 'Bank oder Herausgeber';

  @override
  String get payLastFour => 'Letzte vier Ziffern';

  @override
  String get payUseByDefault => 'Standardmäßig verwenden';

  @override
  String get backupChecking => 'Wird geprüft…';

  @override
  String get backupLoading => 'Wird geladen…';

  @override
  String get backupSaveACopy => 'Kopie speichern';

  @override
  String get backupAutomaticBackups => 'Automatische Sicherungen';

  @override
  String get backupHowManyBackupsToKeep =>
      'Anzahl aufzubewahrender Sicherungen';

  @override
  String get backupSaveABackupFile => 'Sicherungsdatei speichern';

  @override
  String get backupShareItToFilesEmail =>
      'In Dateien, per E-Mail oder wohin du willst teilen';

  @override
  String get backupRestoreFromAFile => 'Aus Datei wiederherstellen';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Ersetzt alles, was sich gerade auf diesem Gerät befindet';

  @override
  String get backupRestoreThisBackup => 'Diese Sicherung wiederherstellen?';

  @override
  String get backupEraseRestore => 'Löschen & wiederherstellen';

  @override
  String get backupGoogleDriveIsUnavailable =>
      'Google Drive ist nicht verfügbar';

  @override
  String get backupConnectGoogleDrive => 'Google Drive verbinden';

  @override
  String get backupBackUpNow => 'Jetzt sichern';

  @override
  String get backupKeep => 'Behalten';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'Die letzte automatische Sicherung wurde nicht ausgeführt';

  @override
  String get backupDisconnectGoogleDrive => 'Google Drive trennen';

  @override
  String get backupDisconnectGoogleDrive2 => 'Google Drive trennen?';

  @override
  String get backupDisconnect => 'Trennen';

  @override
  String get backupDeleteThisBackup => 'Diese Sicherung löschen?';

  @override
  String get importChooseACsvFile => 'CSV-Datei wählen';

  @override
  String get importRememberTheseSettingsForThis =>
      'Diese Einstellungen für diese Bank merken';

  @override
  String get importChange => 'Ändern';

  @override
  String get importAuto => 'Auto';

  @override
  String get importDone => 'Fertig';

  @override
  String get importRememberThisBank => 'Diese Bank merken';

  @override
  String get importForget => 'Vergessen';

  @override
  String get importImport => 'Importieren';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsTermsOfService => 'Nutzungsbedingungen';

  @override
  String get settingsRefundPolicy => 'Erstattungsrichtlinie';

  @override
  String get settingsOpenSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get settingsMeetTheDeveloper => 'Der Entwickler';

  @override
  String get settingsContactSupport => 'Support kontaktieren';

  @override
  String get settingsSubject => 'Betreff';

  @override
  String get settingsMessage => 'Nachricht';

  @override
  String get settingsSendMessage => 'Nachricht senden';

  @override
  String get settingsUseApiRate => 'API-Kurs verwenden';

  @override
  String get settingsRefreshRates => 'Kurse aktualisieren';

  @override
  String get settingsSearchCurrencies => 'Währungen suchen...';

  @override
  String get settingsCustomRate => 'Eigener Kurs';

  @override
  String get settingsSetCustomRate => 'Eigenen Kurs festlegen';

  @override
  String get settingsNotNow => 'Nicht jetzt';

  @override
  String get settingsGoPremium => 'Premium holen';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Tabellenformat für Excel, Google Sheets';

  @override
  String get settingsPdfReport => 'PDF-Bericht';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Formatierte Übersicht mit Aufschlüsselungen';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'Alle Einnahmen und Ausgaben';

  @override
  String get settingsCategories => 'Kategorien';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Aufschlüsselung und Summen nach Kategorie';

  @override
  String get settingsWallets => 'Konten';

  @override
  String get settingsWalletBalancesAndHistory => 'Kontostände und Verlauf';

  @override
  String get settingsHelpFaq => 'Hilfe & FAQ';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsLargeTransactionThreshold =>
      'Schwelle für große Buchungen';

  @override
  String get settingsRemindMeBeforeDueDate => 'Vor Fälligkeit erinnern';

  @override
  String get settingsDailyReminders => 'TÄGLICHE ERINNERUNGEN';

  @override
  String get settingsDailyReminders2 => 'Tägliche Erinnerungen';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Lass dich ans Erfassen deiner Ausgaben erinnern';

  @override
  String get settingsBudgetAlerts => 'BUDGETWARNUNGEN';

  @override
  String get settingsBudgetAlerts2 => 'Budgetwarnungen';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'Benachrichtigen, wenn das Budgetlimit näher rückt';

  @override
  String get settingsWarningThreshold => 'Warnschwelle';

  @override
  String get settingsTransactionAlerts => 'BUCHUNGSWARNUNGEN';

  @override
  String get settingsLargeTransactionAlerts => 'Warnung bei großen Buchungen';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'Bei Buchungen über der Schwelle benachrichtigen';

  @override
  String get settingsRecurringTransactionReminders =>
      'Erinnerungen an wiederkehrende Buchungen';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'An anstehende wiederkehrende Zahlungen erinnern';

  @override
  String get settingsOtherNotifications => 'WEITERE BENACHRICHTIGUNGEN';

  @override
  String get settingsSubscriptionExpiryAlerts => 'Hinweis bei Abo-Ablauf';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Benachrichtigung, bevor dein Premium abläuft';

  @override
  String get settingsPromotionalNotifications => 'Werbe-Benachrichtigungen';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Angebote und Neuigkeiten erhalten';

  @override
  String get settingsTurnOnDailyReminders =>
      'Tägliche Erinnerungen aktivieren?';

  @override
  String get settingsEnterAmount => 'Betrag eingeben';

  @override
  String get settingsReminderTime => 'Erinnerungszeit';

  @override
  String get settingsPrivacySecurity => 'Datenschutz & Sicherheit';

  @override
  String get settingsSecurity => 'SICHERHEIT';

  @override
  String get settingsBiometricLock => 'Biometrische Sperre';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Mit Fingerabdruck oder Gesicht entsperren';

  @override
  String get settingsAutoLock => 'Automatische Sperre';

  @override
  String get settingsDataPrivacy => 'DATENSCHUTZ';

  @override
  String get settingsClearCache => 'Cache leeren';

  @override
  String get settingsClearCachedDataAndForce =>
      'Zwischengespeicherte Daten löschen und neu synchronisieren';

  @override
  String get settingsClearAllData => 'Alle Daten löschen';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Alle Buchungen, Budgets und Einstellungen löschen';

  @override
  String get settingsDangerZone => 'GEFAHRENBEREICH';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Dein Konto und alle Daten dauerhaft löschen';

  @override
  String get settingsAutoLockTimeout => 'Zeit bis zur Sperre';

  @override
  String get settingsDeleteEverything => 'Alles löschen';

  @override
  String get settingsAreYouAbsolutelySure => 'Bist du dir ganz sicher?';

  @override
  String get settingsYesDeleteAll => 'Ja, alles löschen';

  @override
  String get settingsContinue => 'Weiter';

  @override
  String get settingsEditProfile => 'Profil bearbeiten';

  @override
  String get settingsDisplayName => 'Anzeigename';

  @override
  String get settingsEmailAddress => 'E-Mail-Adresse';

  @override
  String get settingsUnsavedChanges => 'Ungespeicherte Änderungen';

  @override
  String get settingsStay => 'Bleiben';

  @override
  String get settingsLeave => 'Verlassen';

  @override
  String get settingsSearchByCodeOrName => 'Nach Code oder Name suchen...';

  @override
  String get settingsSearchSettings => 'Einstellungen durchsuchen...';

  @override
  String get settingsSubscription => 'Abo';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsGoals => 'Ziele';

  @override
  String get settingsCardsInNetWorth => 'Kreditkarten im Nettovermögen zählen';

  @override
  String get settingsCardsInNetWorthSub =>
      'Aus: Nur dein eigenes Geld zählt, keine Kartensalden.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Auf etwas sparen und den Fortschritt verfolgen';

  @override
  String get settingsBudgets => 'Budgets';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Limits setzen und sehen, wie der Zeitraum läuft';

  @override
  String get settingsUpcomingAndOverdue => 'Anstehend und überfällig';

  @override
  String get settingsWhatIsDueAndWhat =>
      'Was fällig ist und was verpasst wurde';

  @override
  String get settingsAccounts => 'Konten';

  @override
  String get settingsAddReorderAndEditYour =>
      'Konten hinzufügen, sortieren und bearbeiten';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'Die Karten und Konten, mit denen du zahlst';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Wohin etwas gehört – anhand seines Namens';

  @override
  String get settingsNotificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get settingsCloudSync => 'Cloud-Sync';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Deine Daten geräteübergreifend synchronisieren';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV ist kostenlos · PDF-Bericht ist Premium';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Fragen, Beschwerden oder Feedback';

  @override
  String get settingsRateTheApp => 'App bewerten';

  @override
  String get settingsShareWithFriends => 'Mit Freunden teilen';

  @override
  String get settingsReplayAppTour => 'App-Tour wiederholen';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'Die Funktionsübersicht noch einmal ansehen';

  @override
  String get settingsAboutTheAccountant => 'Über The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Version, Lizenzen und mehr';

  @override
  String get settingsTestCrash => 'Testabsturz';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Test-Ausnahme für Crashlytics auslösen';

  @override
  String get settingsDeveloper => 'ENTWICKLER';

  @override
  String get settingsRestoreFromCloud => 'Aus der Cloud wiederherstellen?';

  @override
  String get settingsSyncing => 'Synchronisiere...';

  @override
  String get settingsSynced => 'Synchronisiert';

  @override
  String get settingsSyncError => 'Sync-Fehler';

  @override
  String get syncBackgroundFailed =>
      'Sync fehlgeschlagen. Deine Änderungen sind auf diesem Gerät sicher und werden später synchronisiert.';

  @override
  String get settingsOffline => 'Offline';

  @override
  String get settingsReady => 'Bereit';

  @override
  String get settingsYesUseThis => 'Ja, verwenden';

  @override
  String get settingsKeepThemSeparate => 'Getrennt halten?';

  @override
  String get settingsCurrentPassword => 'Aktuelles Passwort';

  @override
  String get settingsNewPassword => 'Neues Passwort';

  @override
  String get settingsConfirmPassword => 'Passwort bestätigen';

  @override
  String get walletEGPersonalSavingsBusiness =>
      'z. B. Privat, Ersparnisse, Geschäft';

  @override
  String get walletEnterCreditLimit => 'Kreditlimit eingeben';

  @override
  String get walletSelectBillingDay => 'Abrechnungstag wählen';

  @override
  String get walletCreateAccount => 'Konto erstellen';

  @override
  String get walletWalletCreatedSuccessfully => 'Konto erstellt';

  @override
  String get walletAccountUpdatedSuccessfully => 'Konto aktualisiert';

  @override
  String get walletEditAccount => 'Konto bearbeiten';

  @override
  String get walletSetAsDefault => 'Als Standard festlegen';

  @override
  String get walletUseDecimals => 'Dezimalstellen verwenden';

  @override
  String get walletEnterWalletName => 'Kontoname eingeben';

  @override
  String get walletCurrency => 'Währung';

  @override
  String get walletIcon => 'Symbol';

  @override
  String get walletColor => 'Farbe';

  @override
  String get walletWalletName => 'Kontoname';

  @override
  String get walletInitialBalance => 'Anfangssaldo';

  @override
  String get txAddATransferFee => 'Überweisungsgebühr hinzufügen';

  @override
  String get txRemove => 'Entfernen';

  @override
  String get txPaymentMethod => 'Zahlungsmethode';

  @override
  String get txObjective => 'Zweck';

  @override
  String get txTitle => 'Titel';

  @override
  String get txTesco => 'Rewe';

  @override
  String get txAll => 'Alle';

  @override
  String get txSkip => 'Überspringen';

  @override
  String get txMarkAsPaid2 => 'Als bezahlt markieren';

  @override
  String get txConfirmPayment => 'Zahlung bestätigen';

  @override
  String get txAmountCharged => 'Abgebuchter Betrag';

  @override
  String get txUndo => 'Rückgängig';

  @override
  String get txNoLoan => 'Kein Darlehen';

  @override
  String get txLentMoney => 'Geld verliehen';

  @override
  String get txBorrowedMoney => 'Geld geliehen';

  @override
  String get goalShowOnTheHomeScreen => 'Auf dem Startbildschirm zeigen';

  @override
  String get goalWhatAreYouSavingFor => 'Wofür sparst du?';

  @override
  String get goalNewLaptop => 'Neuer Laptop';

  @override
  String get goalTarget => 'Zielbetrag';

  @override
  String get goalColour => 'Farbe';

  @override
  String get goalClear => 'Leeren';

  @override
  String get goalGoal => 'Ziel';

  @override
  String get goalThisGoalNoLongerExists => 'Dieses Ziel existiert nicht mehr.';

  @override
  String get goalAddToGoal => 'Zum Ziel hinzufügen';

  @override
  String get goalUnlink => 'Verknüpfung lösen';

  @override
  String get reportUpgrade => 'Upgrade';

  @override
  String get budgetSpending => 'Ausgaben';

  @override
  String get budgetEarnings => 'Einnahmen';

  @override
  String get budgetEvery => 'Alle';

  @override
  String get budgetCarryOverWhatIsLeft => 'Rest übertragen';

  @override
  String get budgetGroceries => 'Lebensmittel';

  @override
  String get authLinkYourAccount => 'Konto verknüpfen';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authLinkAccount => 'Konto verknüpfen';

  @override
  String get authEmailAddress => 'E-Mail-Adresse';

  @override
  String get authSendResetCode => 'Code zum Zurücksetzen senden';

  @override
  String get authResetCode => 'Code zum Zurücksetzen';

  @override
  String get authResetPassword => 'Passwort zurücksetzen';

  @override
  String get authWelcomeBack => 'Willkommen zurück';

  @override
  String get authSignInToContinueYour =>
      'Melde dich an, um deine Finanzreise fortzusetzen';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authJoinUsToStartYour => 'Starte jetzt deine Finanzreise';

  @override
  String get authFullName => 'Vollständiger Name';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Monatlich';

  @override
  String get premiumYearly => 'Jährlich';

  @override
  String get premiumLifetime => 'Lebenslang';

  @override
  String get premiumNotNow => 'Nicht jetzt';

  @override
  String get aiRename => 'Umbenennen';

  @override
  String get aiRenameChat => 'Chat umbenennen';

  @override
  String get aiDeleteChat => 'Chat löschen?';

  @override
  String get aiChatName => 'Chatname';

  @override
  String get aiScanReceipt => 'Beleg scannen';

  @override
  String get aiCamera => 'Kamera';

  @override
  String get aiGallery => 'Galerie';

  @override
  String get aiMerchantTitle => 'Händler / Titel';

  @override
  String get aiSaveAsTransaction => 'Als Buchung speichern';

  @override
  String get onboardBrowseThemes => 'Designs ansehen';

  @override
  String get onboardBack => 'Zurück';

  @override
  String get onboardGetStarted => 'Los geht\'s';

  @override
  String get onboardMainAccount => 'Hauptkonto';

  @override
  String get creditRecordPayment => 'Zahlung erfassen';

  @override
  String get creditPleaseEnterAValidAmount =>
      'Bitte gib einen gültigen Betrag ein';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'Betrag übersteigt den Restbetrag';

  @override
  String get creditPaymentAmount => 'Zahlungsbetrag';

  @override
  String get creditPaidOn => 'Bezahlt am';

  @override
  String get creditFullAmount => 'Voller Betrag';

  @override
  String get subSubscriptionName => 'Name des Abos';

  @override
  String get subAskBeforeEachPayment => 'Vor jeder Zahlung nachfragen';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Jede Zahlung wartet unter Anstehend, bis du den abgebuchten Betrag bestätigst oder sie überspringst. Ideal für schwankende Beträge, z. B. eine Karte, die in einer anderen Währung bezahlt wird.';

  @override
  String get subChangesApplyFromNext =>
      'Ein neuer Betrag oder ein neues Konto gilt ab der nächsten Zahlung. Bereits erfolgte Zahlungen bleiben unverändert.';

  @override
  String get catPleaseEnterACategoryName =>
      'Bitte gib einen Kategorienamen ein';

  @override
  String get catEnterCategoryName => 'Kategorienamen eingeben';

  @override
  String get catSearch => 'Kategorien suchen';

  @override
  String get catNoMatch => 'Keine passende Kategorie.';

  @override
  String get catUseEmoji => 'Emoji verwenden';

  @override
  String get catEmojiHint => 'Ein Emoji eingeben oder wählen';

  @override
  String get catArchive => 'Archivieren';

  @override
  String get catMergeInto => 'Zusammenführen mit…';

  @override
  String catMergeIntoTitle(String name) {
    return '$name zusammenführen mit';
  }

  @override
  String get catMergeBuiltIn => 'Vorgegeben';

  @override
  String get catMergeNoTargets =>
      'Es gibt keine andere Kategorie derselben Art zum Zusammenführen.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return '$from mit $to zusammenführen?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Alle Buchungen, Budgets und Unterkategorien aus $from wandern zu $to, und $from wird entfernt. Das wird mit deinen anderen Geräten synchronisiert.';
  }

  @override
  String get catMergeAction => 'Zusammenführen';

  @override
  String catMerged(String from, String to) {
    return '$from mit $to zusammengeführt.';
  }

  @override
  String get catExpenseSection => 'Ausgabekategorien';

  @override
  String get catIncomeSection => 'Einnahmekategorien';

  @override
  String get catSectionEmpty => 'Noch keine';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Unterkategorien',
      one: '1 Unterkategorie',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen',
      one: '1 Buchung',
      zero: 'Keine Buchungen',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'In $name';
  }

  @override
  String get catAddSubcategory => 'Unterkategorie hinzufügen';

  @override
  String get catNoSubcategoriesYet =>
      'Noch keine Unterkategorien. Füge eine hinzu';

  @override
  String get catMoveTo => 'Verschieben nach…';

  @override
  String catMoveToTitle(String name) {
    return '$name verschieben nach';
  }

  @override
  String get catTopLevel => 'Oberste Ebene';

  @override
  String get catTopLevelHint => 'In keiner Kategorie';

  @override
  String catMovedInto(String name, String parent) {
    return '$name liegt jetzt in $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name ist jetzt eine Hauptkategorie.';
  }

  @override
  String get catMoveNoParents => 'Es gibt keine Kategorie, in die sie passt.';

  @override
  String get catMoveTransactions => 'Buchungen verschieben…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Buchungen von $name verschieben nach';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen nach $to verschieben?',
      one: '1 Buchung nach $to verschieben?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Nur die Buchungen werden verschoben. $from bleibt mit seinen Budgets und Unterkategorien bestehen. Das wird mit deinen anderen Geräten synchronisiert.';
  }

  @override
  String get catMoveAction => 'Verschieben';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen nach $to verschoben.',
      one: '1 Buchung nach $to verschoben.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name hat keine Buchungen zum Verschieben.';
  }

  @override
  String get catNoMoveTargets =>
      'Es gibt keine andere Kategorie derselben Art als Ziel.';

  @override
  String catDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get catDeleteEmptyBody =>
      'Sie hat keine Buchungen, sonst ändert sich nichts.';

  @override
  String get catDeleteChildrenNote =>
      'Ihre Unterkategorien werden zu Hauptkategorien.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen sind hier abgelegt. Was soll damit passieren?',
      one: '1 Buchung ist hier abgelegt. Was soll damit passieren?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'In andere Kategorie verschieben';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Dann wird $name gelöscht. Budgets, die sie nutzen, ziehen mit um.';
  }

  @override
  String get catDeleteThemToo => 'Buchungen ebenfalls löschen';

  @override
  String get catDeleteThemTooHint =>
      'Sie landen unter Zuletzt gelöscht, wo du sie 30 Tage lang wiederherstellen kannst.';

  @override
  String catDeleted(String name) {
    return '$name gelöscht.';
  }

  @override
  String get catActionFailed =>
      'Das hat nicht geklappt. Versuch es noch einmal.';

  @override
  String get catStaysTopLevel =>
      'Diese Kategorie hat eigene Unterkategorien und bleibt daher auf oberster Ebene.';

  @override
  String get catUnarchive => 'Wiederherstellen';

  @override
  String get catArchivedSection => 'Archiviert';

  @override
  String get catArchivedHint =>
      'Für den Verlauf behalten, aber beim Hinzufügen einer Buchung nicht angeboten.';

  @override
  String get catNothingItsOwnCategory => 'Keine – eigene Kategorie';

  @override
  String get notifEnableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get startupContinueWithoutChecking => 'Ohne Prüfung fortfahren?';

  @override
  String get startupContinueOffline => 'Offline fortfahren';

  @override
  String get startupViewSubscriptionOptions => 'Abo-Optionen ansehen';

  @override
  String get sharedWelcomeBack => 'Willkommen zurück';

  @override
  String get sharedRestoringYourDataFromThe =>
      'Deine Daten werden aus der Cloud wiederhergestellt…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return '$source mit $target zusammenführen?';
  }

  @override
  String get backupNothingHereYet => 'Hier ist noch nichts.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Wird automatisch angewendet, wenn eine Datei diese Spalten hat';

  @override
  String get importDateFormat => 'Datumsformat';

  @override
  String get importChooseOne => 'Eins wählen';

  @override
  String get importDecimalPoint => 'Dezimaltrennzeichen';

  @override
  String get importFlipTheSigns => 'Vorzeichen umkehren';

  @override
  String get importForExportsThatWriteA =>
      'Für Exporte, die Ausgaben positiv schreiben';

  @override
  String get importWhereRowsGoWhenThe =>
      'Wohin Zeilen gehen, wenn die Datei keines deiner Konten nennt';

  @override
  String get importSkipWhatIsAlreadyHere => 'Bereits Vorhandenes überspringen';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Kategorien aus der Datei anlegen';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Sonst kommen diese Zeilen ohne Kategorie an';

  @override
  String get importCategoriesInThisFile => 'Kategorien in dieser Datei';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Mit Liebe für private Finanzen gemacht';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'Entwickelt & gepflegt von:';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Schließen';

  @override
  String get settingsGetInTouch => 'Kontakt aufnehmen';

  @override
  String get settingsAsAPremiumMemberYour =>
      'Als Premium-Mitglied wird deine Anfrage bevorzugt bearbeitet.';

  @override
  String get settingsWhatToInclude => 'Was enthalten sein soll';

  @override
  String get settingsNoCurrenciesFound => 'Keine Währungen gefunden';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Exportiere deine Finanzdaten zur Auswertung in anderen Apps oder als Sicherung.';

  @override
  String get settingsDateRange => 'Zeitraum';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'PDF-Berichte';

  @override
  String get settingsGettingStarted => 'Erste Schritte';

  @override
  String get settingsStillNeedHelp => 'Brauchst du noch Hilfe?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'Unser Support-Team hilft dir gern';

  @override
  String get settingsAppLocked => 'App gesperrt';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Entsperren, um The Accountant zu öffnen';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Lege fest, wann und wie The Accountant dich ans Erfassen deiner Ausgaben erinnert.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'Deine E-Mail dient zur Anmeldung und kann hier nicht geändert werden.';

  @override
  String get settingsYourDataIsOnThis =>
      'Deine Daten liegen nur auf diesem Gerät';

  @override
  String get settingsUpgradeForCloudSync => 'Upgrade für Cloud-Sync';

  @override
  String get settingsNoSettingsFound => 'Keine Einstellungen gefunden';

  @override
  String get settingsTryADifferentSearchTerm =>
      'Versuch einen anderen Suchbegriff';

  @override
  String get settingsSyncStatus => 'SYNC-STATUS';

  @override
  String get settingsSyncNow => 'Jetzt synchronisieren';

  @override
  String get settingsRestoreFromCloud2 => 'Aus der Cloud wiederherstellen';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'BRAUCHT DEINE BESTÄTIGUNG';

  @override
  String get walletCreateYourFirstAccount => 'Erstelle dein erstes Konto';

  @override
  String get walletYouNeedAtLeastOne =>
      'Du brauchst mindestens ein Konto, um deine Finanzen zu erfassen';

  @override
  String get walletAccountType => 'Kontoart';

  @override
  String get walletAccountName => 'Kontoname';

  @override
  String get walletCreditLimit => 'Kreditlimit';

  @override
  String get walletCreditLimitHelp =>
      'Limit erhöht? Hier ändern. Ein neues Limit ist keine Einnahme.';

  @override
  String get walletAmountOwed => 'Offener Betrag';

  @override
  String get walletAmountOwedHelp =>
      'Was du gerade auf der Karte schuldest. 0, wenn sie abbezahlt ist.';

  @override
  String get walletCurrentBalance => 'Aktueller Saldo';

  @override
  String get walletCurrentBalanceHelp =>
      'Eine Änderung wird als Saldokorrektur gespeichert, damit dein Verlauf stimmt.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'Was ist $amount auf dieser Karte?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Mein verfügbarer Rahmen';

  @override
  String get walletCardBalanceOwed => 'Was ich schulde';

  @override
  String get walletCardBalanceChoose =>
      'Wähle, was dieser Betrag ist, damit die Schuld richtig berechnet wird.';

  @override
  String get walletBillingCycleDayOptional => 'Abrechnungstag (optional)';

  @override
  String get walletThisWillBeYourDefault => 'Das wird dein Standardkonto';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Auf diesem Konto ist noch nichts erfasst.';

  @override
  String get walletAddAccount => 'Konto hinzufügen';

  @override
  String get walletYourAccounts => 'Deine Konten';

  @override
  String get walletNoAccountsYet => 'Noch keine Konten';

  @override
  String get walletOutstanding => 'Offen';

  @override
  String get walletAvailable => 'Verfügbar';

  @override
  String get walletLimit => 'Limit';

  @override
  String get walletBalance => 'Saldo';

  @override
  String get walletUseThisWalletForNew =>
      'Dieses Konto für neue Buchungen verwenden';

  @override
  String get walletSelectIcon => 'Symbol wählen';

  @override
  String get walletSelectColor => 'Farbe wählen';

  @override
  String get txYouNeedAtLeast2 =>
      'Für eine Umbuchung brauchst du mindestens 2 Konten';

  @override
  String get txNoAccountTitle => 'Kein Konto für diese Buchung';

  @override
  String get txNoAccountBody =>
      'Füge ein Konto hinzu oder öffne ein geschlossenes wieder, dann ist dieses Formular bereit.';

  @override
  String get txNoAccountAction => 'Konten verwalten';

  @override
  String get txDeleteTransaction => 'Buchung löschen';

  @override
  String get txAreYouSureYouWant =>
      'Möchtest du diese Buchung wirklich löschen?';

  @override
  String get txTransactionType => 'Buchungsart';

  @override
  String get txTransferFee => 'Überweisungsgebühr';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Separat berechnet, damit die Umbuchung selbst ausgeglichen bleibt.';

  @override
  String get txDeductedFrom => 'Abgezogen von';

  @override
  String get txNoPaymentMethods => 'Keine Zahlungsmethoden';

  @override
  String get txNothingDeletedRecently => 'Nichts kürzlich gelöscht';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Alles, was du löschst, erscheint hier dreißig Tage lang.';

  @override
  String get txNoRulesYet => 'Noch keine Regeln';

  @override
  String get txClearAll => 'Alle löschen';

  @override
  String get txApplyFilters => 'Filter anwenden';

  @override
  String get txUpcomingOverdue => 'Anstehend & überfällig';

  @override
  String get txNew => 'Neu';

  @override
  String get txLoan => 'Darlehen';

  @override
  String get goalStarted => 'Begonnen';

  @override
  String get goalTargetDate => 'Zieldatum';

  @override
  String get goalWithADateTheGoal =>
      'Mit einem Datum berechnet das Ziel, wie viel du täglich zurücklegen musst.';

  @override
  String get goalCountedTowardThisGoal => 'Auf dieses Ziel angerechnet';

  @override
  String get goalGettingThere => 'Auf dem Weg';

  @override
  String get goalSetATargetDateAnd =>
      'Lege ein Zieldatum fest, dann wird berechnet, was du zurücklegen musst.';

  @override
  String get reportSpendingInsights => 'Ausgabenanalyse';

  @override
  String get reportNoSpendingDataForThis => 'Keine Ausgaben in diesem Zeitraum';

  @override
  String get reportNoCategorySpendingData => 'Keine Ausgaben nach Kategorie';

  @override
  String get reportNoSpendingDataAvailable => 'Keine Ausgabendaten verfügbar';

  @override
  String get reportBudgetVsActual => 'Budget vs. Ist';

  @override
  String get reportNoActiveBudgets => 'Keine aktiven Budgets';

  @override
  String get reportCreateABudgetToTrack =>
      'Erstelle ein Budget, um deine Ausgaben zu verfolgen';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Du gibst schneller aus, als der Zeitraum vergeht.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'In diesem Zeitraum nichts erfasst.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent von $limit verbraucht';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount übrig';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount drüber';
  }

  @override
  String get budgetPeriodEnded => 'Zeitraum beendet';

  @override
  String get budgetPaceOver => 'Drüber';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Noch $days Tage',
      one: 'Noch 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Passwort zurückgesetzt. Bitte melde dich an.';

  @override
  String get authResendCode => 'Code erneut senden';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authOrContinueWith => 'Oder weiter mit';

  @override
  String get authContinueWithGoogle => 'Weiter mit Google';

  @override
  String get authContinueWithApple => 'Weiter mit Apple';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String get authPleaseAcceptTheTermsAnd =>
      'Bitte akzeptiere die Nutzungsbedingungen';

  @override
  String get authPasswordStrength => 'Passwortstärke';

  @override
  String get authAlreadyHaveAnAccount => 'Schon ein Konto? ';

  @override
  String get authPersonalInformation => 'Persönliche Daten';

  @override
  String get authUpgradeToPremium => 'Upgrade auf Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Unbegrenzte Budgets, erweiterte Analysen und mehr freischalten!';

  @override
  String get authUpgradeNow => 'Jetzt upgraden';

  @override
  String get authPremiumMember => 'Premium-Mitglied';

  @override
  String get authEnjoyingAllPremiumFeatures => 'Alle Premium-Funktionen aktiv';

  @override
  String get authSaveChanges => 'Änderungen speichern';

  @override
  String get authAreYouSureYouWant => 'Möchtest du dich wirklich abmelden?';

  @override
  String get authChangeProfilePhoto => 'Profilbild ändern';

  @override
  String get authTakePhoto => 'Foto aufnehmen';

  @override
  String get authUseYourCamera => 'Kamera verwenden';

  @override
  String get authChooseFromGallery => 'Aus Galerie wählen';

  @override
  String get authSelectAnExistingPhoto => 'Vorhandenes Foto auswählen';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Foto ausgewählt! Hochladen kommt bald.';

  @override
  String get authNameCannotBeEmpty => 'Name darf nicht leer sein';

  @override
  String get authProfileUpdatedSuccessfully => 'Profil aktualisiert!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Datenschutz & Bedingungen';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Lies dir das durch, bevor du fortfährst.';

  @override
  String get premiumLimitReached => 'Limit erreicht';

  @override
  String get aiChats => 'Chats';

  @override
  String get aiNewChat => 'Neuer Chat';

  @override
  String get aiNoConversationsYet => 'Noch keine Unterhaltungen';

  @override
  String get aiStartChattingAndYourThreads =>
      'Starte einen Chat, dann erscheinen deine Unterhaltungen hier.';

  @override
  String get aiScanAReceipt => 'Beleg scannen';

  @override
  String get aiReadingYourReceipt => 'Dein Beleg wird gelesen…';

  @override
  String get aiReviewSave => 'Prüfen & speichern';

  @override
  String get aiWeReadThisFromYour =>
      'Das haben wir aus deinem Beleg gelesen – prüfe es und bearbeite alles vor dem Speichern.';

  @override
  String get dashErrorLoadingFinancialData =>
      'Fehler beim Laden der Finanzdaten';

  @override
  String get dashNoSpendingDataYet => 'Noch keine Ausgaben';

  @override
  String get dashManage => 'Verwalten';

  @override
  String get dashAvailable => 'Verfügbar: ****';

  @override
  String get onboardWelcome => 'Willkommen!';

  @override
  String get onboardSelectYourDefaultCurrency => 'Wähle deine Standardwährung';

  @override
  String get onboardLoadingCurrencies => 'Währungen werden geladen...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'Richte dein Hauptkonto ein';

  @override
  String get onboardInitialBalanceOptional => 'Anfangssaldo (optional)';

  @override
  String get onboardYourAccountIsReadyTo => 'Dein Konto ist startklar';

  @override
  String get onboardTipYouCanAddMore =>
      'Tipp: Unter Konten kannst du jederzeit weitere Konten mit anderen Währungen hinzufügen.';

  @override
  String get creditSettled => 'Beglichen';

  @override
  String get creditOverdue => 'Überfällig';

  @override
  String creditTabCredit(int count) {
    return 'Verliehen ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Geliehen ($count)';
  }

  @override
  String get creditNetOutstanding => 'Netto offen';

  @override
  String get creditAllSettled => 'Alles beglichen';

  @override
  String get creditOthersOweYou => 'Andere schulden dir';

  @override
  String get creditYouOweOthers => 'Du schuldest anderen';

  @override
  String creditOverdueCount(int count) {
    return '$count überfällig';
  }

  @override
  String get creditEmptyAll => 'Kein Geld verliehen oder geliehen';

  @override
  String get creditEmptyLent => 'Kein Geld verliehen';

  @override
  String get creditEmptyBorrowed => 'Kein Geld geliehen';

  @override
  String get creditEmptyAllSettled => 'Alles ist beglichen.';

  @override
  String get creditEmptyHint =>
      'Erfasse verliehenes oder geliehenes Geld, um den Überblick zu behalten, wer wem was schuldet.';

  @override
  String get creditShowAll => 'Alle anzeigen';

  @override
  String get creditShowUnpaid => 'Nur offene anzeigen';

  @override
  String get creditMoneyLent => 'Verliehenes Geld';

  @override
  String get creditMoneyBorrowed => 'Geliehenes Geld';

  @override
  String get creditTheyOweYou => 'Schuldet dir';

  @override
  String get creditYouOwe => 'Du schuldest';

  @override
  String get creditCollected => 'Erhalten';

  @override
  String creditPaidOf(String paid, String total) {
    return '$paid von $total bezahlt';
  }

  @override
  String get creditRecord => 'Erfassen';

  @override
  String get subRecurring => 'Wiederkehrend';

  @override
  String get subPaused => 'Pausiert';

  @override
  String get subAsksFirst => 'Fragt vorher';

  @override
  String get subFrequency => 'Häufigkeit';

  @override
  String get notifMarkAllRead => 'Alle gelesen';

  @override
  String get notifTryAgain => 'Erneut versuchen';

  @override
  String get notifStayOnTopOfYour => 'Behalte dein Geld im Blick';

  @override
  String get notifNoNotificationsYet => 'Noch keine Benachrichtigungen';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'Neue Benachrichtigungen erscheinen hier.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Nichts wurde geändert oder gelöscht.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Kryptowährungen einbeziehen';

  @override
  String get sharedTotalBalance => 'Gesamtsaldo';

  @override
  String get heatmapTitle => 'Tagesrhythmus';

  @override
  String get heatmapSpentMore => 'Mehr ausgegeben';

  @override
  String get heatmapEarnedMore => 'Mehr eingenommen';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Buchungen werden nicht angezeigt: Es ist kein Kurs zwischen den Währungen ihrer Konten und $currency bekannt',
      one:
          'Eine Buchung wird nicht angezeigt: Es ist kein Kurs zwischen der Währung ihres Kontos und $currency bekannt',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet => 'In diesem Zeitraum noch nichts erfasst.';

  @override
  String get heatmapNetForRange => 'Netto in diesem Zeitraum';

  @override
  String get layoutTitle => 'Startseiten-Layout';

  @override
  String get layoutSubtitle =>
      'Startseite neu anordnen oder Ungenutztes ausblenden';

  @override
  String get layoutExplain =>
      'Zum Sortieren ziehen. Ausgeschaltetes behält seinen Platz und erscheint beim Einschalten wieder dort.';

  @override
  String get layoutReset => 'Auf Standard zurücksetzen';

  @override
  String get layoutAllHidden =>
      'Alle Bereiche sind ausgeblendet. Die Startseite bleibt leer.';

  @override
  String get layoutSectionGreeting => 'Begrüßung';

  @override
  String get layoutSectionAccounts => 'Konten';

  @override
  String get layoutSectionQuickStats => 'Einnahmen und Ausgaben';

  @override
  String get layoutSectionQuickLinks => 'Verknüpfungen';

  @override
  String get layoutSectionSpendingChart => 'Ausgabenübersicht';

  @override
  String get layoutSectionRecent => 'Letzte Buchungen';

  @override
  String get layoutSectionBudgets => 'Budgetfortschritt';

  @override
  String get layoutSectionGoals => 'Angeheftete Ziele';

  @override
  String get shortcutAddExpense => 'Ausgabe hinzufügen';

  @override
  String get shortcutAddIncome => 'Einnahme hinzufügen';

  @override
  String get shortcutScanReceipt => 'Beleg scannen';

  @override
  String get shortcutTransactions => 'Buchungen';

  @override
  String get backupBusySyncing =>
      'Eine Synchronisierung läuft. Warte, bis sie fertig ist, bevor du wiederherstellst.';

  @override
  String get appearanceTitle => 'Darstellung';

  @override
  String get themeSunriseLight => 'Sunrise Hell';

  @override
  String get themeSunriseDark => 'Sunrise Dunkel';

  @override
  String get themeMatchSystem => 'Wie System';

  @override
  String get themeMatchSystemHint =>
      'Mit deinem Handy zwischen hell und dunkel wechseln';

  @override
  String get themeUnlockAll => 'Alle Designs freischalten';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Sonnenaufgang';

  @override
  String get themeAccentSapphire => 'Saphir';

  @override
  String get themeAccentEmerald => 'Smaragd';

  @override
  String get themeAccentRuby => 'Rubin';

  @override
  String get themeAccentAmethyst => 'Amethyst';

  @override
  String get themeAccentGraphite => 'Graphit';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Heute';

  @override
  String get navAdd => 'Neu';

  @override
  String get navStats => 'Statistik';

  @override
  String get navMore => 'Mehr';

  @override
  String get walkthroughTodayTitle => 'Dein Tag auf einen Blick';

  @override
  String get walkthroughTodayBody =>
      'Nettovermögen, Einnahmen und Ausgaben sowie die heutige Aktivität.';

  @override
  String get walkthroughAddTitle => 'In Sekunden erfasst';

  @override
  String get walkthroughAddBody =>
      'Tippe auf Neu, um eine Ausgabe, Einnahme oder Umbuchung zu erfassen.';

  @override
  String get walkthroughTransactionsTitle => 'Deine Buchungen';

  @override
  String get walkthroughTransactionsBody =>
      'Jede Buchung, Monat für Monat. Suche und filtere, um alles zu finden.';

  @override
  String get walkthroughStatsTitle => 'Sieh, wohin es geht';

  @override
  String get walkthroughStatsBody =>
      'Diagramme nach Woche, Monat und Jahr, nach Kategorie.';

  @override
  String get walkthroughBellTitle => 'Bleib informiert';

  @override
  String get walkthroughBellBody =>
      'Budgetwarnungen und Erinnerungen erscheinen hier. Alles bereit!';

  @override
  String get walkthroughBalanceTitle => 'Dein Nettovermögen';

  @override
  String get walkthroughBalanceBody =>
      'Hier summieren sich alle Konten, mit einem Balken für die Aufteilung.';

  @override
  String get txTransfer => 'Umbuchung';

  @override
  String get txUncategorized => 'Ohne Kategorie';

  @override
  String todayGoodMorning(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Guten Tag, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Guten Abend, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Guten Morgen';

  @override
  String get todayGoodAfternoonPlain => 'Guten Tag';

  @override
  String get todayGoodEveningPlain => 'Guten Abend';

  @override
  String get todayNetWorth => 'Nettovermögen';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount diesen Monat';
  }

  @override
  String get todayEarned => 'Eingenommen';

  @override
  String get todaySpent => 'Ausgegeben';

  @override
  String get todayTitle => 'Heute';

  @override
  String get todayRecent => 'Zuletzt';

  @override
  String get todayAllActivity => 'Alle Aktivitäten';

  @override
  String get todayNothingYet => 'Heute noch nichts';

  @override
  String get todayNothingYetBody => 'Tippe auf Neu, um die erste zu erfassen.';

  @override
  String todayMoreWallets(int count) {
    return '+$count weitere';
  }

  @override
  String get todayCoachTitle => 'Frag deinen Finanzcoach';

  @override
  String get todayCoachBody =>
      'Antworten und Tipps aus deinen eigenen Ausgaben';

  @override
  String get todayNotifications => 'Benachrichtigungen';

  @override
  String get todayWithinBudget => 'Im Budget';

  @override
  String get todayOverBudget => 'Über Budget';

  @override
  String get todayNetCredit => 'Netto-Forderung';

  @override
  String get todayNetDebt => 'Netto-Schuld';

  @override
  String get todayMonthly => 'Monatlich';

  @override
  String get walletsTitle => 'Konten';

  @override
  String get walletsNew => 'Neu';

  @override
  String get walletsAddHint => 'Bank, Bargeld, Sparkonto hinzufügen…';

  @override
  String get walletsPlanning => 'Planung';

  @override
  String get walletsUpcoming => 'Anstehend';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count fällig · $amount';
  }

  @override
  String get walletsUpcomingNone => 'Bald nichts fällig';

  @override
  String get walletsLendBorrow => 'Verleihen & leihen';

  @override
  String get splitTitle => 'Rechnung teilen';

  @override
  String get splitSubtitle =>
      'Teile eine Rechnung mit Freunden; was sie schulden, landet unter Verleihen & leihen';

  @override
  String get splitWhatFor => 'Wofür war es';

  @override
  String get splitTotal => 'Gesamt';

  @override
  String get splitPeople => 'Personen';

  @override
  String get splitYou => 'Du';

  @override
  String get splitIncludeMe => 'Ich hatte einen Anteil';

  @override
  String get splitIncludeMeSub =>
      'Ausschalten, wenn du nur für die anderen bezahlt hast';

  @override
  String get splitAddPerson => 'Person hinzufügen';

  @override
  String get splitPersonName => 'Name';

  @override
  String get splitKnownPeople => 'Aus Verleihen & leihen';

  @override
  String get splitRemove => 'Entfernen';

  @override
  String get splitPaidBy => 'Bezahlt von';

  @override
  String get splitHow => 'Aufteilung';

  @override
  String get splitEqual => 'Gleich';

  @override
  String get splitExact => 'Beträge';

  @override
  String get splitPercent => 'Prozent';

  @override
  String get splitShares => 'Anteile';

  @override
  String get splitYourShare => 'Dein Anteil';

  @override
  String get splitOwesYou => 'Schuldet dir';

  @override
  String splitYouOwe(String name) {
    return 'Du schuldest $name';
  }

  @override
  String get splitPaidTheBill => 'Hat bezahlt';

  @override
  String splitSettlesWith(String name) {
    return 'Rechnet mit $name ab';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total von deinem Konto; $owed bekommst du zurück';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Jetzt geht nichts von deinem Konto ab; du schuldest $name $amount';
  }

  @override
  String get splitPercentLabel => 'Prozent der Rechnung';

  @override
  String get splitSave => 'Aufteilen';

  @override
  String get splitSaved => 'Aufteilung erfasst';

  @override
  String get splitNeedCategory => 'Wähle zuerst eine Kategorie.';

  @override
  String get splitThisBill => 'Diese Rechnung teilen';

  @override
  String get splitThisBillSub =>
      'Mit Freunden; was sie schulden, landet unter Verleihen & leihen';

  @override
  String get splitPartOf => 'Geteilte Rechnung';

  @override
  String walletsOwedToYou(String amount) {
    return 'Dir schuldet man $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'Du schuldest $amount';
  }

  @override
  String get walletsAllSettled => 'Alles beglichen';

  @override
  String get walletsGoals => 'Ziele';

  @override
  String walletsGoalsSub(int count) {
    return '$count aktiv';
  }

  @override
  String get walletsBudgets => 'Budgets';

  @override
  String get walletsSubscriptions => 'Abos';

  @override
  String get walletsTransfer => 'Umbuchung zwischen Konten';

  @override
  String get walletsArchived => 'Archiviert';

  @override
  String walletsDeleteMessage(String name) {
    return '„$name“ löschen? Alle Buchungen dieses Kontos werden mitgelöscht.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name gelöscht';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name ist jetzt dein Standard';
  }

  @override
  String get walletsCreateFailed =>
      'Konto konnte nicht erstellt werden. Bitte versuch es erneut.';

  @override
  String get walletsEmptyBody => 'Erstelle dein erstes Konto, um loszulegen.';

  @override
  String get walletsTypeBank => 'Bankkonto';

  @override
  String get walletsTypeCard => 'Kreditkarte';

  @override
  String get walletsTypeCash => 'Bargeld';

  @override
  String get walletsTypeOther => 'Konto';

  @override
  String get moreTitle => 'Mehr';

  @override
  String get moreGoPremium => 'Premium holen';

  @override
  String get moreGoPremiumBody => 'KI-Assistent, Cloud-Sync, Designs';

  @override
  String get moreUnlock => 'Freischalten';

  @override
  String get morePremiumActive => 'Premium ist aktiv';

  @override
  String get morePremiumThanks => 'Danke, dass du The Accountant unterstützt';

  @override
  String get sectionPreferences => 'EINSTELLUNGEN';

  @override
  String get sectionTools => 'FINANZTOOLS';

  @override
  String get moreAiAssistant => 'KI-Assistent';

  @override
  String get moreAiAssistantSub => 'Stell Fragen zu deinem Geld';

  @override
  String get moreSignOutConfirm =>
      'Auf diesem Gerät von deinem Konto abmelden?';

  @override
  String get moreSignOutFailed =>
      'Abmelden fehlgeschlagen. Bitte versuch es erneut.';

  @override
  String get moreDeviceOnlyBody =>
      'Kostenlose Konten werden nicht in der Cloud gesichert, bei Neuinstallation oder Handywechsel können Daten verloren gehen. Hol dir Cloud-Sync per Upgrade oder exportiere regelmäßig eine Sicherung.';

  @override
  String get moreUpgradeToPremium => 'Upgrade auf Premium';

  @override
  String get moreUser => 'Du';

  @override
  String get statsTitle => 'Statistik';

  @override
  String get statsWeek => 'Woche';

  @override
  String get statsMonth => 'Monat';

  @override
  String get statsYear => 'Jahr';

  @override
  String get statsSpending => 'Ausgaben';

  @override
  String get statsIncome => 'Einnahmen';

  @override
  String get statsCategories => 'Kategorien';

  @override
  String get statsSpent => 'Ausgegeben';

  @override
  String get statsEarned => 'Eingenommen';

  @override
  String get statsNet => 'Netto';

  @override
  String get statsThisMonth => 'Dieser Monat';

  @override
  String statsVsLastMonth(String change) {
    return '$change ggü. Vormonat';
  }

  @override
  String get statsInsightsSub =>
      'Zusammenfassung, Trends & Tipps dieses Monats';

  @override
  String get statsAskCoach => 'Den KI-Coach dazu fragen';

  @override
  String statsOverBy(String amount) {
    return '$amount drüber';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent % übrig';
  }

  @override
  String get activityAll => 'Alle';

  @override
  String get activitySpent => 'Ausgaben';

  @override
  String get activityEarned => 'Einnahmen';

  @override
  String get activityTransfers => 'Umbuchungen';

  @override
  String activitySoFar(String month) {
    return '$month bisher';
  }

  @override
  String activityNet(String amount) {
    return '$amount netto';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Treffer in allen Monaten',
      one: '1 Treffer in allen Monaten',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'Letzte 7 Tage';

  @override
  String get statsPeriodThisMonth => 'Dieser Monat';

  @override
  String get statsPeriodThisYear => 'Dieses Jahr';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen',
      one: '1 Buchung',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Nichts passt zu „$query“';
  }

  @override
  String get activitySearchNothingBody =>
      'Alle Monate wurden durchsucht. Versuch weniger Wörter, eine andere Schreibweise oder entferne einen Filter.';

  @override
  String get activityIn => 'Ein';

  @override
  String get activityOut => 'Aus';

  @override
  String get activityToday => 'Heute';

  @override
  String get activityYesterday => 'Gestern';

  @override
  String get activityTomorrow => 'Morgen';

  @override
  String get activityEmptyFutureTitle => 'Keine geplanten Buchungen';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Künftige Zahlungen für $month hinzufügen';
  }

  @override
  String get activityEmptyNowTitle => 'Noch keine Buchungen';

  @override
  String get activityEmptyNowBody => 'Erfasse deine Ausgaben in diesem Monat';

  @override
  String get activityEmptyPastTitle => 'Keine Buchungen gefunden';

  @override
  String activityEmptyPastBody(String month) {
    return 'Keine Einträge für $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen gelöscht',
      one: '1 Buchung gelöscht',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count nach $name verschoben';
  }

  @override
  String get activityMixedCurrencies =>
      'Diese liegen in verschiedenen Währungen, daher gibt es kein gemeinsames Zielkonto. Wähle Zeilen einer Währung.';

  @override
  String activityMovedPartial(int count) {
    return '$count verschoben; Umbuchungen blieben, wo sie sind';
  }

  @override
  String activityMoved(int count) {
    return '$count in ein anderes Konto verschoben';
  }

  @override
  String activityRedated(int count) {
    return 'Datum von $count geändert';
  }

  @override
  String get activityNothingToPay => 'Nichts wartete auf Bezahlung';

  @override
  String activityMarkedPaid(int count) {
    return '$count als bezahlt markiert';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count kopiert; Umbuchungen können nicht einzeln kopiert werden';
  }

  @override
  String activityCopied(int count) {
    return '$count kopiert';
  }

  @override
  String get activityDeleteOneBody =>
      'Sie wird aus deinen Einträgen entfernt und dein Saldo neu berechnet.';

  @override
  String get activitySearch => 'Suchen';

  @override
  String get addNewExpense => 'Neue Ausgabe';

  @override
  String get addNewIncome => 'Neue Einnahme';

  @override
  String get addNewTransfer => 'Neue Umbuchung';

  @override
  String get addEditTitle => 'Buchung bearbeiten';

  @override
  String get addAmount => 'Betrag';

  @override
  String get addCategory => 'Kategorie';

  @override
  String get addMore => 'Mehr';

  @override
  String get addWallet => 'Konto';

  @override
  String addChangeDate(String date) {
    return 'Datum ändern, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Uhrzeit ändern, $time';
  }

  @override
  String get addSwapAccounts => 'Die beiden Konten tauschen';

  @override
  String get notifCheckTitle => 'Benachrichtigungen prüfen';

  @override
  String get notifAllowed => 'Benachrichtigungen sind erlaubt';

  @override
  String get notifAllowedHint => 'Erinnerungen erreichen dieses Handy';

  @override
  String get notifBlocked => 'Benachrichtigungen sind aus';

  @override
  String get notifBlockedHint =>
      'Tippe, um sie zu erlauben, sonst erreicht dich nichts';

  @override
  String get notifSendTest => 'Testbenachrichtigung senden';

  @override
  String get notifSendTestHint =>
      'Von unserem Server gesendet, wie echte Erinnerungen';

  @override
  String get notifSending => 'Wird gesendet…';

  @override
  String get notifTestSent =>
      'Gesendet. Sie sollte in wenigen Sekunden erscheinen, auch in deinem Posteingang.';

  @override
  String notifTestFailed(String reason) {
    return 'Senden fehlgeschlagen: $reason';
  }

  @override
  String get notifTestOffline => 'keine Verbindung zum Server';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant erinnert dich täglich zur gewählten Zeit sanft daran, deine Ausgaben zu erfassen. Dafür braucht es die Berechtigung für Benachrichtigungen.';

  @override
  String get notifPrimerShow => 'Erinnerungen anzeigen';

  @override
  String get notifPrimerTime => 'Zu deiner gewählten Zeit';

  @override
  String get notifPrimerOff => 'Jederzeit abschaltbar';

  @override
  String get notifPrimerAllow => 'Erlauben';

  @override
  String get cardBillsTitle => 'Kartenabrechnungen';

  @override
  String get cardBillsSubtitle =>
      'Kreditkartenabrechnungen, Fälligkeiten und Erinnerungen';

  @override
  String get cardBillsEmptyTitle => 'Noch keine Kreditkarten';

  @override
  String get cardBillsEmptyBody =>
      'Füge ein Konto vom Typ Kreditkarte hinzu, lege Abrechnungs- und Fälligkeitstag fest, dann erscheinen die Abrechnungen hier.';

  @override
  String get cardBillsAddCard => 'Karte hinzufügen';

  @override
  String get cardStatementDay => 'Abrechnungstag';

  @override
  String get cardStatementDayHint =>
      'Der Tag im Monat, an dem abgerechnet wird. Alles bis Ende dieses Tages ist enthalten.';

  @override
  String get cardDueDay => 'Fälligkeitstag';

  @override
  String get cardDueDayHint =>
      'Der letzte Tag zum Bezahlen – das erste Mal, dass dieser Tag nach der Abrechnung kommt.';

  @override
  String get cardRemindTitle => 'Erinnern';

  @override
  String get cardRemindHint =>
      'Vor der Fälligkeit, falls noch etwas offen ist. Gesendet gegen 9 Uhr.';

  @override
  String get cardRemindOff => 'Aus';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage vorher',
      one: 'Am Tag davor',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Nicht festgelegt';

  @override
  String cardDayOfMonth(int day) {
    return 'Tag $day';
  }

  @override
  String get cardSetUpBody =>
      'Lege Abrechnungs- und Fälligkeitstag fest, um die Abrechnungen dieser Karte zu sehen und rechtzeitig erinnert zu werden.';

  @override
  String get cardSetUp => 'Daten festlegen';

  @override
  String cardDueBy(String date) {
    return 'Offen bis $date';
  }

  @override
  String get cardLeftToPay => 'Noch zu zahlen';

  @override
  String cardStatementClosed(String date) {
    return 'Abrechnung vom $date';
  }

  @override
  String get cardPaidSince => 'Seitdem bezahlt';

  @override
  String cardThisCycle(String date) {
    return 'Seitdem ausgegeben, nächste Abrechnung $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'Zahlung Abrechnung $card';
  }

  @override
  String get cardEdit => 'Karte bearbeiten';

  @override
  String get cardEarlierStatements => 'FRÜHERE ABRECHNUNGEN';

  @override
  String get cardPaidShort => 'bezahlt';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount offen';
  }

  @override
  String get cardStatusNotSetUp => 'Daten fehlen';

  @override
  String get cardStatusNothingDue => 'Nichts fällig';

  @override
  String get cardStatusPaid => 'Bezahlt';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Fällig in $days Tagen',
      one: 'Morgen fällig',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'Heute fällig';

  @override
  String get cardStatusOverdue => 'Überfällig';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid von $owed bezahlt';
  }

  @override
  String get cardPayBill => 'Bezahlen';

  @override
  String cardPayTitle(String card) {
    return '$card bezahlen';
  }

  @override
  String get cardPayHint =>
      'Zahle alles oder einen Teil. Jede Zahlung zählt für diese Abrechnung, der Rest bleibt fällig.';

  @override
  String cardPayFull(String amount) {
    return 'Komplett zahlen, $amount';
  }

  @override
  String get cardPayFullHint => 'Alles, was auf dieser Abrechnung offen ist';

  @override
  String get cardPayOther => 'Anderen Betrag zahlen';

  @override
  String get cardPayOtherHint =>
      'Eine Teilzahlung oder mehr als die Abrechnung';

  @override
  String get addNoteHint => 'Notiz hinzufügen';

  @override
  String get addRepeatMonthly => 'Monatlich wiederholen';

  @override
  String get addMoreOptions => 'Weitere Optionen';

  @override
  String get addScanReceipt => 'Beleg scannen';

  @override
  String get addDelete => 'Buchung löschen';

  @override
  String get addTypeExpense => 'Ausgabe';

  @override
  String get addTypeIncome => 'Einnahme';

  @override
  String get addTypeTransfer => 'Umbuchung';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Mit Premium freischalten';

  @override
  String get gateFootnote => 'Lebenslang oder Abo · Jederzeit wiederherstellen';

  @override
  String get aiCoachTitle => 'Dein Finanzcoach';

  @override
  String get aiCoachBody =>
      'Frag in einfachen Worten. Erhalte Antworten, Tipps und Pläne auf Basis deiner eigenen Ausgaben.';

  @override
  String get aiAssistantTitle => 'KI-Assistent';

  @override
  String get aiAskAnything => 'Frag zu deinem Geld…';

  @override
  String get aiSend => 'Senden';

  @override
  String get aiCopy => 'Kopieren';

  @override
  String get aiCopied => 'Kopiert';

  @override
  String get aiRetry => 'Erneut versuchen';

  @override
  String get aiDismiss => 'Schließen';

  @override
  String get aiTyping => 'Coach schreibt';

  @override
  String aiStarterCategory(String category) {
    return 'Wohin ist mein Geld für $category gegangen?';
  }

  @override
  String get aiStarterBudgets => 'Liege ich bei meinen Budgets im Plan?';

  @override
  String get aiStarterUpcoming => 'Welche Rechnungen stehen an?';

  @override
  String get aiStarterAnalyze => 'Analysiere meine letzten Ausgabenmuster';

  @override
  String get aiStarterBudgetTips => 'Gib mir Tipps für ein besseres Budget';

  @override
  String get aiStarterSave => 'Wie kann ich mehr Geld sparen?';

  @override
  String aiDeleteChatBody(String title) {
    return '„$title“ wird dauerhaft gelöscht.';
  }

  @override
  String get aiJustNow => 'Gerade eben';

  @override
  String get aiErrorTitle => 'Der Coach konnte nicht antworten';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'Alles, was die App kann – für dich.';

  @override
  String get paywallActiveTitle => 'Premium ist aktiv';

  @override
  String get paywallActiveTagline => 'Danke für deine Unterstützung!';

  @override
  String get paywallRestore => 'Wiederherstellen';

  @override
  String get paywallProcessing => 'Wird verarbeitet…';

  @override
  String paywallTriggered(String feature) {
    return '$feature ist eine Premium-Funktion';
  }

  @override
  String paywallDaysRemaining(int days) {
    return 'Noch $days Tage';
  }

  @override
  String get paywallFeatSync => 'Cloud-Sync';

  @override
  String get paywallFeatSyncSub => 'Alle Geräte';

  @override
  String get paywallFeatAi => 'KI-Assistent';

  @override
  String get paywallFeatAiSub => 'Unbegrenzt, ohne Werbung';

  @override
  String get paywallFeatOcr => 'Beleg-Scan';

  @override
  String get paywallFeatOcrSub => 'Texterkennung mit KI';

  @override
  String get paywallFeatInsights => 'Ausgabenanalyse';

  @override
  String get paywallFeatInsightsSub => 'Monatliche Trends';

  @override
  String get paywallFeatThemes => '5 Designs';

  @override
  String get paywallFeatThemesSub => 'Exklusiv';

  @override
  String get paywallFeatPdf => 'PDF-Berichte';

  @override
  String get paywallFeatPdfSub => 'CSV bleibt gratis';

  @override
  String get paywallFeatUnlimited => 'Unbegrenzt';

  @override
  String get paywallFeatUnlimitedSub => 'Konten, Budgets';

  @override
  String get paywallFeatSupport => 'Vorrangiger Support';

  @override
  String get paywallFeatSupportSub => 'Schnellere Antworten';

  @override
  String get paywallPerMonth => '/Monat';

  @override
  String get paywallPerYear => '/Jahr';

  @override
  String get paywallOnce => 'einmalig';

  @override
  String get paywallBestValue => 'BESTER WERT';

  @override
  String get paywallForever => 'FÜR IMMER';

  @override
  String get paywallMonthlyDesc => 'Monatliche Abrechnung';

  @override
  String get paywallYearlyDesc => 'Jährliche Abrechnung';

  @override
  String get paywallLifetimeDesc => 'Einmal zahlen, für immer behalten';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial gratis, dann $rest';
  }

  @override
  String get paywallCtaLifetime => 'Lebenslangen Zugang holen';

  @override
  String get paywallCtaYearly => 'Jahresabo starten';

  @override
  String get paywallCtaMonthly => 'Monatsabo starten';

  @override
  String get paywallFootLifetime => 'Einmalkauf · Kein Abo';

  @override
  String get paywallFootSubscription =>
      'Verlängert sich automatisch · Jederzeit im Store kündbar';

  @override
  String get paywallTerms =>
      'Abos werden über dein App-Store- oder Google-Play-Konto abgerechnet und verlängern sich automatisch, sofern sie nicht mindestens 24 Stunden vor Ende des aktuellen Zeitraums gekündigt werden.';

  @override
  String get paywallIapUnavailable =>
      'In-App-Käufe sind auf diesem Gerät nicht verfügbar. Stelle sicher, dass die Google Play-Dienste installiert sind und die App aus dem Play Store stammt.';

  @override
  String get paywallLoadingPlans => 'Tarife werden geladen…';

  @override
  String get paywallPlansFailed =>
      'Tarife konnten nicht geladen werden. Prüfe deine Verbindung und versuch es erneut.';

  @override
  String get paywallTryAgain => 'Erneut versuchen';

  @override
  String get paywallRestored => 'Käufe wiederhergestellt';

  @override
  String get paywallPurchased => 'Willkommen bei Premium!';

  @override
  String get paywallLifetimeNever => 'Lebenslanger Zugang läuft nie ab';

  @override
  String get helpSearchQuestions => 'Fragen durchsuchen';

  @override
  String get helpStepWallets => 'Konten anlegen';

  @override
  String get helpStepCategories => 'Kategorien wählen';

  @override
  String get helpStepTrack => 'Täglich erfassen';

  @override
  String get splashTagline => 'Geld, nur heller.';

  @override
  String get introStep1 => 'Münzen werden gezählt…';

  @override
  String get introStep2 => 'Konten werden geweckt…';

  @override
  String get introStep3 => 'Diagramme werden poliert…';

  @override
  String get introStep4 => 'Fast geschafft…';

  @override
  String get introTipLabel => 'Geldtipp';

  @override
  String get introTip1 =>
      'Bezahl dich zuerst selbst: Leg das Sparen am Tag des Gehaltseingangs zur Seite.';

  @override
  String get introTip2 =>
      'Kleine tägliche Ausgaben summieren sich. Sie zu erfassen ist schon die halbe Miete.';

  @override
  String get introTip3 =>
      'Ein Notgroschen für 3 Monate macht aus Überraschungen bloße Unannehmlichkeiten.';

  @override
  String get introTip4 =>
      'Prüfe deine Abos monatlich: Kündige, was du nicht genutzt hast.';

  @override
  String get introTip5 =>
      'Gib jedem Taka eine Aufgabe, bevor der Monat beginnt.';

  @override
  String get introTip6 => 'Warte vor jedem ungeplanten Kauf 24 Stunden.';

  @override
  String get introTip7 =>
      'Budgets sind keine Grenzen, sondern die Erlaubnis, für das Wichtige auszugeben.';

  @override
  String get introTip8 =>
      'Feier kleine Erfolge: Jedes Ziel beginnt mit der ersten Einzahlung.';

  @override
  String get adConfirmTitleAiCall => 'Eine weitere KI-Anfrage holen';

  @override
  String get adConfirmTitleTheme => 'Premium-Designs 24 Stunden testen';

  @override
  String get adConfirmTitlePdf => 'Einen PDF-Bericht exportieren';

  @override
  String get adConfirmBodyAiCall =>
      'Du hast die kostenlosen KI-Anfragen dieses Monats aufgebraucht. Sieh dir eine kurze Werbung an und du bekommst eine weitere.';

  @override
  String get adConfirmBodyTheme =>
      'Sieh dir eine kurze Werbung an und alle Premium-Designs gehören dir für die nächsten 24 Stunden.';

  @override
  String get adConfirmBodyPdf =>
      'Sieh dir eine kurze Werbung an, um einen PDF-Bericht zu exportieren.';

  @override
  String get adConfirmWarning => 'Gleich startet eine Werbung. Fortfahren?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Werbungen diesen Monat verfügbar',
      one: 'Noch 1 Werbung diesen Monat verfügbar',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Premium-Mitglieder bekommen unbegrenzte KI, alle Designs und PDF-Berichte – ganz ohne Werbung.';

  @override
  String get adWatch => 'Werbung ansehen';

  @override
  String get adGetPremium => 'Premium holen';

  @override
  String get adNotNow => 'Nicht jetzt';

  @override
  String get adLoading => 'Werbung wird geladen…';

  @override
  String get adVerifying => 'Belohnung wird bestätigt…';

  @override
  String get adUnavailable =>
      'Gerade ist keine Werbung verfügbar. Bitte versuch es später erneut.';

  @override
  String get adSkipped =>
      'Die Werbung wurde vorzeitig geschlossen, daher wurde nichts freigeschaltet.';

  @override
  String get adRewardAiCall => 'Fertig! Du hast eine weitere KI-Anfrage.';

  @override
  String get adRewardTheme => 'Premium-Designs für 24 Stunden freigeschaltet.';

  @override
  String get adRewardPdf => 'Ein PDF-Export freigeschaltet.';

  @override
  String get adMonthlyCapReached =>
      'Das waren alle Werbungen für diesen Monat. Deine kostenlosen Anfragen kommen am 1. zurück – oder hol dir Premium für unbegrenzte.';

  @override
  String get adRewardPending => 'Danke! Deine Belohnung erscheint gleich.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count kostenlose KI-Anfragen diesen Monat',
      one: 'Noch 1 kostenlose KI-Anfrage diesen Monat',
      zero: 'Keine kostenlosen KI-Anfragen mehr diesen Monat',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: unbegrenzt';

  @override
  String get aiToolSearching => 'Deine Buchungen werden durchsucht…';

  @override
  String get aiToolSummarizing => 'Zahlen werden addiert…';

  @override
  String get aiToolAccounts => 'Deine Konten werden geprüft…';

  @override
  String get aiToolCategories => 'Deine Kategorien werden angesehen…';

  @override
  String get aiToolCards => 'Kartenabrechnungen werden geprüft…';

  @override
  String get aiToolPlans => 'Raten und Ersparnisse werden geprüft…';

  @override
  String get aiToolSaving => 'Wird gespeichert…';

  @override
  String get aiActionAddTitle => 'Diese Buchung hinzufügen?';

  @override
  String get aiActionUpdateTitle => 'Diese Buchung ändern?';

  @override
  String get aiActionDeleteTitle => 'Diese Buchung löschen?';

  @override
  String get aiActionPayCardTitle => 'Kartenabrechnung bezahlen';

  @override
  String get aiActionCardSettingsTitle => 'Kartendaten ändern';

  @override
  String get aiActionCreatePlanTitle => 'Plan starten';

  @override
  String get aiActionPayPlanTitle => 'Planzahlung erfassen';

  @override
  String get aiActionClosePlanTitle => 'Plan vorzeitig beenden';

  @override
  String get aiActionUpdatePlanTitle => 'Plan ändern';

  @override
  String get aiActionCreateInvestmentTitle => 'Geldanlage hinzufügen';

  @override
  String get aiActionTradeInvestmentTitle => 'Handel erfassen';

  @override
  String get aiActionUpdateInvestmentTitle => 'Kurs aktualisieren';

  @override
  String get aiActionConfirm => 'Bestätigen';

  @override
  String get aiActionClosePlan => 'Beenden';

  @override
  String get aiActionFrom => 'Von';

  @override
  String get aiActionTo => 'An';

  @override
  String get aiActionBill => 'Abrechnung';

  @override
  String get aiActionLeftAfter => 'Danach offen';

  @override
  String get aiActionRemindDays => 'Tage vorher erinnern';

  @override
  String get aiActionPay => 'Zahlen';

  @override
  String get plansTitle => 'Raten, Kredite & Sparen';

  @override
  String get investmentsTitle => 'Geldanlagen';

  @override
  String get investmentsSubtitle =>
      'Fonds, Aktien und Sparpläne, zum letzten Kurs bewertet';

  @override
  String get forecastTitle => 'Liquiditätsprognose';

  @override
  String get forecastSubtitle =>
      'Wohin sich dein Bargeld und Bankguthaben entwickeln – und wann es knapp wird';

  @override
  String forecastRangeDays(int days) {
    return '$days Tage';
  }

  @override
  String get forecastNow => 'Bargeld und Bank jetzt';

  @override
  String get forecastMoneyIn => 'Eingänge';

  @override
  String get forecastMoneyOut => 'Ausgänge';

  @override
  String get forecastLowest => 'Tiefstwert';

  @override
  String forecastLowestOn(String date) {
    return 'am $date';
  }

  @override
  String get forecastChartTitle => 'Erwarteter Saldo';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'Am $date würden dir $amount fehlen';
  }

  @override
  String get forecastShortfallCause => 'Ausgänge an diesem Tag:';

  @override
  String get forecastAlreadyShort =>
      'Deine Bargeld- und Bankkonten sind bereits im Minus.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'Kein Engpass in den nächsten $days Tagen';
  }

  @override
  String get forecastAllCoveredBody =>
      'Alles Geplante ist durch dein Bargeld und Bankguthaben gedeckt.';

  @override
  String get forecastScheduledOnly =>
      'Zählt nur Geplantes: Pläne, Kartenabrechnungen, Abos, wiederkehrende und anstehende Zahlungen sowie Darlehen mit Fälligkeit. Alltägliche Ausgaben sind nicht enthalten.';

  @override
  String get forecastEventsTitle => 'Demnächst';

  @override
  String forecastDayBalance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String get forecastEmptyTitle => 'Nichts geplant';

  @override
  String get forecastEmptyBody =>
      'Pläne, Kartenabrechnungen, Abos und anstehende Zahlungen in diesem Zeitraum erscheinen hier.';

  @override
  String get forecastOverdue => 'Überfällig';

  @override
  String get forecastExpected => 'Erwartet';

  @override
  String get forecastEventWhen => 'Wann';

  @override
  String get forecastEventKind => 'Art';

  @override
  String get forecastEventAccount => 'Konto';

  @override
  String get forecastEventOpen => 'Öffnen';

  @override
  String get forecastEventOverdueNote =>
      'Das Datum ist vorbei und es ist noch offen, daher zählt es als heute fällig.';

  @override
  String get forecastKindInstallment => 'Rate';

  @override
  String get forecastKindPremium => 'Beitrag';

  @override
  String get forecastKindDeposit => 'Einzahlung';

  @override
  String get forecastKindSipBuy => 'Sparplan-Kauf';

  @override
  String get forecastKindProfit => 'Ertrag';

  @override
  String get forecastKindMaturity => 'Fälligkeit';

  @override
  String get forecastKindCardBill => 'Kartenabrechnung';

  @override
  String get forecastKindCardBillNext => 'Nächste Kartenabrechnung, bisher';

  @override
  String get forecastKindSubscription => 'Abo';

  @override
  String get forecastKindRecurringBill => 'Wiederkehrende Zahlung';

  @override
  String get forecastKindRecurringIncome => 'Wiederkehrende Einnahme';

  @override
  String get forecastKindUpcoming => 'Anstehend';

  @override
  String get forecastKindBorrowed => 'Darlehen zurückzahlen';

  @override
  String get forecastKindLent => 'Verliehen, Rückzahlung fällig';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'Am $date könnten dir $amount fehlen';
  }

  @override
  String get forecastHomeWarningBody => 'Sieh, was ansteht';

  @override
  String get forecastDismiss => 'Ausblenden';

  @override
  String forecastNotifTitle(String day) {
    return 'Am $day könnte es knapp werden';
  }

  @override
  String get settingsBillReminders => 'Erinnerungen an Rechnungen und Raten';

  @override
  String get settingsBillRemindersSub =>
      'Fällige Kartenabrechnungen und anstehende Raten oder Sparraten';

  @override
  String get forecastNotifNowTitle => 'Heute ist dein Geld knapp';

  @override
  String forecastNotifNowBody(String amount) {
    return 'Was jetzt fällig ist, übersteigt deine Konten um $amount. Tippe, um zu sehen, was ansteht.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Geplante Zahlungen würden dir $amount Fehlbetrag bringen. Tippe, um zu sehen, was ansteht.';
  }

  @override
  String get investmentsEmptyTitle => 'Noch keine Geldanlagen';

  @override
  String get investmentsEmptyBody =>
      'Verfolge einen Fonds, Aktien oder Gold: was du bezahlt hast, was es jetzt wert ist und den Gewinn.';

  @override
  String get investmentsSold => 'Verkauft';

  @override
  String get investmentsWorth => 'Aktueller Wert';

  @override
  String get investmentNew => 'Neue Geldanlage';

  @override
  String get investmentNewHint =>
      'Fondsanteile, Aktien einer Firma oder alles andere, was stückweise gekauft wird, z. B. Gold nach Gramm.';

  @override
  String get investmentKindFund => 'Fonds';

  @override
  String get investmentKindStock => 'Aktien';

  @override
  String get investmentKindOther => 'Sonstiges';

  @override
  String get investmentNameHintFund => 'z. B. MSCI World ETF';

  @override
  String get investmentNameHintStock => 'z. B. Siemens';

  @override
  String get investmentNameHintOther => 'z. B. Gold, 22 Karat';

  @override
  String get investmentSymbol => 'Symbol oder Kennung (optional)';

  @override
  String get investmentFirstBuy => 'Was du gekauft hast';

  @override
  String get investmentFirstBuyHint =>
      'Lass den Betrag leer, um sie ohne Kauf hinzuzufügen.';

  @override
  String get investmentPaid => 'Bezahlt';

  @override
  String get investmentReceived => 'Erhalten';

  @override
  String get investmentPaidInto => 'Eingezahlt auf';

  @override
  String get investmentFee => 'Gebühr oder Provision';

  @override
  String get investmentUnits => 'Anteile';

  @override
  String get investmentUnitsSold => 'Verkaufte Anteile';

  @override
  String investmentUnitsShort(String units) {
    return '$units Anteile';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price pro Anteil';
  }

  @override
  String get investmentNeedUnits => 'Gib an, wie viele Anteile gekauft wurden.';

  @override
  String get investmentSave => 'Geldanlage hinzufügen';

  @override
  String get investmentAdded => 'Geldanlage hinzugefügt';

  @override
  String get investmentGone => 'Diese Geldanlage wurde gelöscht.';

  @override
  String get netWorthSubtitle =>
      'Alles, was du besitzt, minus was du schuldest – und wie es sich entwickelt hat';

  @override
  String get netWorthToday => 'Dein Vermögen';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount seit letztem Monat';
  }

  @override
  String get netWorthBreakdown => 'Zusammensetzung';

  @override
  String get netWorthCash => 'Bargeld & Bank';

  @override
  String get netWorthCards => 'Kreditkarten';

  @override
  String get netWorthDeposits => 'Spareinlagen';

  @override
  String get netWorthAssets => 'Vermögenswerte';

  @override
  String get netWorthLent => 'An andere verliehen';

  @override
  String get netWorthBorrowed => 'Geliehen';

  @override
  String get netWorthLoansNote =>
      'Verliehenes Geld zählt als deins, bis es zurückgezahlt ist, und geliehenes Geld zählt gegen dich, bis du es zurückzahlst.';

  @override
  String get netWorthCardsLeftOut =>
      'Kreditkarten werden nicht gezählt; das kannst du in den Einstellungen ändern.';

  @override
  String get netWorthHistory => 'Zu jedem Monatsende';

  @override
  String get netWorthSixMonths => '6 Monate';

  @override
  String get netWorthOneYear => '1 Jahr';

  @override
  String get netWorthAllTime => 'Alle';

  @override
  String get netWorthHistoryEmpty =>
      'Die Linie beginnt, sobald ein Monat mit deinen Einträgen abgeschlossen ist.';

  @override
  String get assetNew => 'Vermögenswert hinzufügen';

  @override
  String get assetNewHint =>
      'Grundstück, Wohnung oder Haus, Auto, Gold oder alles andere, was dir gehört. Sein Wert zählt zu deinem Nettovermögen.';

  @override
  String get assetKind => 'Was es ist';

  @override
  String get assetKindLand => 'Grundstück';

  @override
  String get assetKindHome => 'Wohnung oder Haus';

  @override
  String get assetKindCar => 'Fahrzeug';

  @override
  String get assetKindGold => 'Gold & Schmuck';

  @override
  String get assetKindOther => 'Etwas anderes';

  @override
  String get assetNameHintLand => 'z. B. Grundstück in Potsdam';

  @override
  String get assetNameHintHome => 'z. B. Wohnung in Köln';

  @override
  String get assetNameHintCar => 'z. B. VW Golf';

  @override
  String get assetNameHintGold => 'z. B. Hochzeitsschmuck';

  @override
  String get assetNameHintOther => 'z. B. Kamera';

  @override
  String get assetWorthNow => 'Aktueller Wert';

  @override
  String get assetBoughtNow => 'Von einem Konto bezahlt';

  @override
  String get assetBoughtNowHint =>
      'Aus: Es gehört dir schon, es fließt kein Geld.';

  @override
  String get assetSave => 'Vermögenswert hinzufügen';

  @override
  String get assetAdded => 'Vermögenswert hinzugefügt';

  @override
  String get assetsEmptyTitle => 'Noch keine Vermögenswerte';

  @override
  String get assetsEmptyBody =>
      'Füge Grundstück, Wohnung, Auto oder Gold hinzu, um dein gesamtes Vermögen zu sehen.';

  @override
  String get assetsSold => 'Verkauft';

  @override
  String assetCostLine(String amount) {
    return 'Kosten $amount';
  }

  @override
  String get assetUpdateValue => 'Wert aktualisieren';

  @override
  String get assetSell => 'Verkaufen';

  @override
  String get assetDelete => 'Entfernen';

  @override
  String get assetValueUpdated => 'Wert aktualisiert';

  @override
  String get assetSold => 'Verkauft, Geld erfasst';

  @override
  String assetDeleteTitle(String name) {
    return '$name entfernen?';
  }

  @override
  String get assetDeleteBody =>
      'Es wird nicht mehr gezählt. Der Verlauf bleibt in deinen Einträgen.';

  @override
  String get assetDeleted => 'Vermögenswert entfernt';

  @override
  String get aiActionCreateAssetTitle => 'Vermögenswert hinzufügen';

  @override
  String get aiActionUpdateAssetTitle =>
      'Wert eines Vermögenswerts aktualisieren';

  @override
  String get aiActionSellAssetTitle => 'Vermögenswert verkaufen';

  @override
  String get investmentWorthNow => 'Aktueller Wert';

  @override
  String investmentGainLine(String gain) {
    return '$gain insgesamt';
  }

  @override
  String get investmentPrice => 'Kurs';

  @override
  String get investmentPutIn => 'Eingezahlt';

  @override
  String get investmentTakenOut => 'Entnommen';

  @override
  String get investmentBuy => 'Kaufen';

  @override
  String get investmentSell => 'Verkaufen';

  @override
  String investmentBuyTitle(String name) {
    return '$name kaufen';
  }

  @override
  String investmentSellTitle(String name) {
    return '$name verkaufen';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Dividende von $name';
  }

  @override
  String get investmentDividend => 'Dividende';

  @override
  String get investmentRecordDividend => 'Dividende erfassen';

  @override
  String investmentHeldNow(String units) {
    return 'Aktuell $units Anteile im Bestand.';
  }

  @override
  String get investmentRecorded => 'Erfasst';

  @override
  String get investmentUpdatePrice => 'Kurs aktualisieren';

  @override
  String get investmentUpdatePriceHint =>
      'Heutiger Anteilswert oder Aktienkurs, für einen Anteil';

  @override
  String get investmentPriceUpdated => 'Kurs aktualisiert';

  @override
  String get investmentStartSip => 'Sparplan starten';

  @override
  String get investmentStartSipHint =>
      'Jeden Monat automatisch einen festen Betrag kaufen';

  @override
  String get investmentHistory => 'Verlauf';

  @override
  String investmentBought(String units) {
    return '$units Anteile gekauft';
  }

  @override
  String investmentSold(String units) {
    return '$units Anteile verkauft';
  }

  @override
  String get investmentPriceRose => 'Kurs gestiegen';

  @override
  String get investmentPriceFell => 'Kurs gefallen';

  @override
  String get investmentUnitsUnknown =>
      'Anteile noch unbekannt, zum Hinzufügen tippen';

  @override
  String get investmentCorrectUnits => 'Anteile bei diesem Handel';

  @override
  String get investmentCorrectUnitsHint =>
      'So, wie sie auf deiner Fonds- oder Depotabrechnung stehen.';

  @override
  String get investmentUnitsCorrected => 'Anteile korrigiert';

  @override
  String get investmentDelete => 'Diese Geldanlage löschen';

  @override
  String investmentDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get investmentDeleteBody =>
      'Ihre Transaktionen bleiben im Verlauf. Nur möglich, wenn alles verkauft ist.';

  @override
  String get investmentDeleted => 'Geldanlage gelöscht';

  @override
  String get plansSubtitle =>
      'Raten, Kredite, DPS, FDR, Versicherungen, Anleihen und Sparpläne – pünktlich bezahlt und kassiert';

  @override
  String get planNew => 'Plan starten';

  @override
  String get planNewTitle => 'Was startest du?';

  @override
  String get plansEmptyTitle => 'Noch keine Raten, Kredite oder Sparpläne';

  @override
  String get plansEmptyBody =>
      'Verfolge einen Ratenkauf, einen Kredit, einen DPS oder einen FDR. Raten werden an ihrem Tag erfasst und du wirst vorher erinnert.';

  @override
  String get plansEnded => 'Abgeschlossen';

  @override
  String get planKindEmi => 'Ratenkauf';

  @override
  String get planKindLoan => 'Kredit';

  @override
  String get planKindDps => 'DPS';

  @override
  String get planKindFdr => 'FDR';

  @override
  String get planKindInsurance => 'Versicherung';

  @override
  String get planKindBond => 'Anleihe oder Zertifikat';

  @override
  String get planKindSip => 'Sparplan';

  @override
  String get planKindEmiHint =>
      'Etwas auf Raten gekauft, bezahlt mit Bargeld, Bankkonto oder Karte';

  @override
  String get planKindLoanHint =>
      'Geliehenes Geld, in Raten mit Zinsen zurückgezahlt';

  @override
  String get planKindDpsHint =>
      'Monatlich einen festen Betrag für eine feste Zeit sparen und mit Ertrag zurückbekommen';

  @override
  String get planKindFdrHint =>
      'Eine Summe für eine feste Zeit bei der Bank anlegen, mit Ertrag monatlich, vierteljährlich oder am Ende';

  @override
  String get planKindInsuranceHint =>
      'Eine Police mit monatlichem, vierteljährlichem oder jährlichem Beitrag und ggf. einer Auszahlung am Ende';

  @override
  String get planKindBondHint =>
      'Eine Anleihe oder ein Sparzertifikat: eine Summe über Jahre, mit Ertrag monatlich, vierteljährlich oder am Ende, nach Steuern';

  @override
  String get planKindSipHint =>
      'Jeden Monat ein fester Betrag in einen Fonds oder Aktien, zum letzten Kurs gekauft';

  @override
  String get planWeekly => 'Wöchentlich';

  @override
  String get planMonthly => 'Monatlich';

  @override
  String get planQuarterly => 'Vierteljährlich';

  @override
  String get planHalfYearly => 'Halbjährlich';

  @override
  String get planYearly => 'Jährlich';

  @override
  String get planMonths => 'Monate';

  @override
  String get planYears => 'Jahre';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount bis $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved von $total gespart';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid von $total bezahlt';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Nächste: $amount am $date';
  }

  @override
  String get planStatusCompleted => 'Abgeschlossen';

  @override
  String get planStatusClosed => 'Beendet';

  @override
  String get planStatusOverdue => 'Überfällig';

  @override
  String get planStatusRunning => 'Läuft';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done von $total';
  }

  @override
  String get planGone => 'Dieser Plan wurde gelöscht.';

  @override
  String get planAccount => 'Konto';

  @override
  String get planAccountEmi => 'Bezahlt von';

  @override
  String get planAccountLoan => 'Erhalten auf und bezahlt von';

  @override
  String get planAccountSaving => 'Vom Konto';

  @override
  String get planPrice => 'Preis';

  @override
  String get planBorrowed => 'Geliehener Betrag';

  @override
  String get planDeposited => 'Eingezahlter Betrag';

  @override
  String get planDeposit => 'Jede Einzahlung';

  @override
  String get planInstallment => 'Jede Rate';

  @override
  String get planWorkedOut => 'Aus Preis, Zinssatz und Laufzeit berechnet';

  @override
  String get planProgress => 'Erledigt';

  @override
  String get planSavedSoFar => 'Bisher gespart';

  @override
  String get planPaidSoFar => 'Bisher bezahlt';

  @override
  String get planLeft => 'Offen';

  @override
  String get planTotal => 'Insgesamt';

  @override
  String get planInterestCharges => 'Zinsen und Gebühren';

  @override
  String get planRate => 'Zinssatz';

  @override
  String get planRateLabel => 'Zinssatz % p. a.';

  @override
  String get planRateOptional => 'Optional';

  @override
  String get planPayout => 'Ertragsauszahlung';

  @override
  String get planPayoutMonthly => 'Monatlich';

  @override
  String get planPayoutQuarterly => 'Alle 3 Monate';

  @override
  String get planPayoutAtMaturity => 'Am Ende';

  @override
  String get planMaturesOn => 'Fällig am';

  @override
  String get planMaturity => 'Auszahlung am Ende';

  @override
  String get planEstimated =>
      'Aus dem Zinssatz geschätzt; tippe, um den Wert der Bank einzugeben';

  @override
  String get planHolding => 'Aktuell in der Einlage';

  @override
  String get planEnds => 'Letzte Rate';

  @override
  String planTakeMaturity(String amount) {
    return 'Auszahlung erhalten, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Ertrag erfassen, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Rate $number jetzt zahlen, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Beitrag $number jetzt zahlen, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Einzahlung $number jetzt leisten, $amount';
  }

  @override
  String get planRecorded => 'Erfasst.';

  @override
  String get planSaved => 'Gespeichert.';

  @override
  String get planPayOff => 'Vorzeitig tilgen';

  @override
  String get planEncash => 'Vorzeitig auflösen';

  @override
  String get planSurrender => 'Police kündigen';

  @override
  String planSurrenderTitle(String name) {
    return '$name kündigen?';
  }

  @override
  String get planSurrenderBody =>
      'Die Beiträge enden. Was der Versicherer zurückzahlt, wird als Einnahme erfasst.';

  @override
  String get planSurrenderNothing => 'Keine Rückzahlung';

  @override
  String get planSurrenderValue => 'Rückkaufswert eingeben';

  @override
  String get planSurrenderValueLabel => 'Rückkaufswert';

  @override
  String get planStopSip => 'Sparplan stoppen';

  @override
  String planStopSipTitle(String name) {
    return '$name stoppen?';
  }

  @override
  String get planStopSipBody =>
      'Keine weiteren Käufe. Bereits Gekauftes bleibt in der Geldanlage.';

  @override
  String get planSipStopped => 'Sparplan gestoppt';

  @override
  String get planSave => 'Speichern';

  @override
  String get planSurrendered => 'Police gekündigt';

  @override
  String planPayOffTitle(String name) {
    return '$name tilgen?';
  }

  @override
  String get planPayOffHint =>
      'Eine Zahlung für den Rest, dann endet der Plan.';

  @override
  String planPayOffLeft(String amount) {
    return 'Rest zahlen, $amount';
  }

  @override
  String get planPayOffOther => 'Der Kreditgeber nannte einen anderen Betrag';

  @override
  String planEncashTitle(String name) {
    return '$name auflösen?';
  }

  @override
  String get planEncashBody =>
      'Das Guthaben der Einlage geht zurück auf ihr Konto, und der Plan endet.';

  @override
  String get planEncashNoProfit => 'Auflösen, ohne Ertrag';

  @override
  String get planEncashWithProfit => 'Auflösen, mit dem Ertrag der Bank';

  @override
  String get planEncashed => 'Aufgelöst. Das Geld ist zurück auf seinem Konto.';

  @override
  String get planPaidOff => 'Getilgt.';

  @override
  String get planAutoCollect => 'Automatisch erfassen';

  @override
  String get planAutoCollectHint =>
      'Jede Rate, jeder Ertrag und die Auszahlung werden an ihrem Tag erfasst';

  @override
  String get planSchedule => 'ZAHLUNGSPLAN';

  @override
  String get planDelete => 'Diesen Plan löschen';

  @override
  String planDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get planDeleteBody =>
      'Bereits Erfasstes bleibt in deinen Buchungen. Es wird nichts mehr erfasst oder erinnert.';

  @override
  String get planDeleted => 'Gelöscht.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Rate $number von $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Beitrag $number von $total';
  }

  @override
  String get planEventPayout => 'Auszahlung der Police';

  @override
  String planEventProfit(int number) {
    return 'Ertrag, Monat $number';
  }

  @override
  String get planEventMaturity => 'Fälligkeit';

  @override
  String get planEventDone => 'Erledigt';

  @override
  String get planEventLate => 'Überfällig';

  @override
  String get planEventUpcoming => 'Anstehend';

  @override
  String get planNeedAccount => 'Wähle zuerst ein Konto.';

  @override
  String get planCreated => 'Gestartet. Bereits Fälliges wurde erfasst.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, davon $interest Zinsen und Gebühren.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, ohne Zinsen.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'Du zahlst $deposited ein und bekommst am $date etwa $maturity zurück.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal wächst bis $date auf etwa $maturity.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return '$profit Ertrag jeden Monat und $principal zurück am $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count Beiträge à $premium, insgesamt $total.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count Beiträge à $premium, insgesamt $total, und $payout zurück am $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return '$profit Ertrag alle drei Monate und $principal zurück am $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount in $fund, insgesamt $total.';
  }

  @override
  String planNewKind(String kind) {
    return 'Neu: $kind';
  }

  @override
  String get planName => 'Name';

  @override
  String get planNameHintEmi => 'z. B. Handy auf Raten';

  @override
  String get planNameHintLoan => 'z. B. Motorradkredit';

  @override
  String get planNameHintDps => 'z. B. Bank-DPS';

  @override
  String get planNameHintFdr => 'z. B. Festgeld bei der Bank';

  @override
  String get planNameHintInsurance => 'z. B. Lebensversicherung';

  @override
  String get planNameHintBond => 'z. B. 5-jähriger Sparbrief';

  @override
  String get planNameHintSip => 'z. B. Monatlicher Fondssparplan';

  @override
  String get planSipFund => 'Kauft';

  @override
  String get planSipAmount => 'Je Sparrate';

  @override
  String get planSipNoFund =>
      'Füge den Fonds oder die Aktien zuerst unter Geldanlagen hinzu.';

  @override
  String get planProvider => 'Bank oder Firma';

  @override
  String get planReference => 'Police- oder Kontonr.';

  @override
  String get planSumAssured => 'Versicherungssumme';

  @override
  String get planPremium => 'Beitrag';

  @override
  String get planPremiums => 'Beiträge';

  @override
  String get planTaxLabel => 'Quellensteuer %';

  @override
  String get planTax => 'Quellensteuer';

  @override
  String get planFirstPremium => 'Erster Beitrag';

  @override
  String get planLastPremium => 'Letzter Beitrag';

  @override
  String get planInsurancePayout => 'Auszahlung am Ende';

  @override
  String get planNone => 'Keine';

  @override
  String get planHowMany => 'Anzahl';

  @override
  String get planTerm => 'Laufzeit';

  @override
  String get planOpenedOn => 'Eröffnet am';

  @override
  String get planFirstDue => 'Erste Rate';

  @override
  String get planCategory => 'Kategorie';

  @override
  String get planCategoryDefault => 'Kreditrate';

  @override
  String get planCategoryInsurance => 'Versicherung';

  @override
  String get planLoanReceived => 'Geld auf dieses Konto erhalten';

  @override
  String get planLoanReceivedHint =>
      'Aus, wenn es direkt an einen Verkäufer ging';

  @override
  String get planStart => 'Starten';

  @override
  String get aiActionDeleteNote =>
      'Es landet unter Zuletzt gelöscht, wo du es 30 Tage lang wiederherstellen kannst.';

  @override
  String get aiActionAdd => 'Hinzufügen';

  @override
  String get aiActionSave => 'Änderung speichern';

  @override
  String get aiActionDelete => 'Löschen';

  @override
  String get aiActionCancel => 'Nein, so lassen';

  @override
  String get aiActionAmount => 'Betrag';

  @override
  String get aiActionKind => 'Art';

  @override
  String get aiActionTitle => 'Titel';

  @override
  String get aiActionCategory => 'Kategorie';

  @override
  String get aiActionAccount => 'Konto';

  @override
  String get aiActionDate => 'Datum';

  @override
  String get aiActionNotes => 'Notizen';

  @override
  String get aiReport => 'Problem melden';

  @override
  String get aiReportWrongAnswer => 'Der Coach lag falsch';

  @override
  String get aiReportWrongAnswerHint =>
      'Eine falsche Zahl, eine erfundene Tatsache oder eine Änderung, um die du nicht gebeten hast';

  @override
  String get aiReportWrongAnswerSubject => 'Finanzcoach: falsche Antwort';

  @override
  String get aiReportBug => 'Fehler melden';

  @override
  String get aiReportBugHint => 'Etwas ging kaputt, hing oder lud nicht';

  @override
  String get aiReportBugSubject => 'Finanzcoach: Fehlerbericht';

  @override
  String get aiAboutCoach => 'So funktioniert der Coach';

  @override
  String get aiDisclaimerTitle => 'Bevor du den Coach fragst';

  @override
  String get aiDisclaimerMistakes =>
      'Der Coach ist eine KI. Er kann sich bei Zahlen irren, eine Frage falsch verstehen oder etwas Unwahres sagen – prüfe Wichtiges also anhand deiner eigenen Buchungen.';

  @override
  String get aiDisclaimerData =>
      'Deine Zahlen werden auf deinem Handy gelesen. Für eine Antwort sendet die App deine Frage und die nötigen Zahlen an unseren Server und sein KI-Modell.';

  @override
  String get aiDisclaimerChanges =>
      'Er ändert nie eigenständig etwas an deinem Geld. Jedes Hinzufügen, Bearbeiten oder Löschen wird dir zuerst gezeigt und passiert nur, wenn du es bestätigst.';

  @override
  String get aiDisclaimerReport =>
      'Wirkt eine Antwort falsch, tippe oben auf die Flagge, um es uns zu melden.';

  @override
  String get aiDisclaimerAccept => 'Verstanden';

  @override
  String get aiOutOfRequestsTitle =>
      'Du hast die kostenlosen Anfragen dieses Monats aufgebraucht';

  @override
  String get aiOutOfRequestsBody =>
      'Sieh dir eine kurze Werbung an, um diese Frage zu stellen, oder hol dir Premium für unbegrenzte Antworten ohne Werbung. Kostenlose Anfragen kommen am 1. zurück.';

  @override
  String get ocrNoCamera => 'Kamera konnte nicht geöffnet werden.';

  @override
  String get ocrNoGallery => 'Galerie konnte nicht geöffnet werden.';

  @override
  String get ocrScanTitle => 'Beleg scannen';

  @override
  String get ocrScanAnother => 'Weiteren scannen';

  @override
  String get ocrScanBody =>
      'Mach ein Foto oder wähle eins. Die App liest es und die KI füllt die Details aus.';

  @override
  String get ocrReadingWithAi => 'Die KI liest deinen Beleg…';

  @override
  String get ocrNothingRead =>
      'Auf dem Foto konnte kein Text gelesen werden. Versuch es bei besserem Licht mit dem ganzen Beleg im Bild.';

  @override
  String get ocrAiOfferTitle => 'Lass die KI ihn richtig lesen';

  @override
  String get ocrAiOfferBody =>
      'Sie findet die echte Summe, das Datum, jeden Artikel und die passende Kategorie – auch bei einem unordentlichen Beleg.';

  @override
  String get ocrReadWithAi => 'Mit KI lesen';

  @override
  String get ocrReadByAi => 'Von KI gelesen. Vor dem Speichern prüfen.';

  @override
  String get ocrItems => 'Artikel';

  @override
  String get quickAddTitle => 'Beschreib es';

  @override
  String get quickAddSubtitle =>
      'Schreib es so, wie du es sagen würdest. Die KI füllt das Formular zum Prüfen aus.';

  @override
  String get quickAddHint => 'z. B. Mittagessen 12 gestern von bKash';

  @override
  String get quickAddFill => 'Ausfüllen';

  @override
  String get summaryTitle => 'Monatsübersicht';

  @override
  String get summarySpent => 'Diesen Monat ausgegeben';

  @override
  String summaryEarned(String amount) {
    return '$amount eingenommen';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent % weniger als letzten Monat';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent % mehr als letzten Monat';
  }

  @override
  String get summaryAiTitle => 'Dein Monat in Kürze';

  @override
  String get summaryAiBody =>
      'Die KI vergleicht deinen Monat mit dem Vormonat, hebt Auffälliges hervor und gibt dir einen Tipp.';

  @override
  String get summaryWrite => 'Zusammenfassung schreiben';

  @override
  String get summaryOutdated =>
      'Deine Buchungen haben sich seit dieser Zusammenfassung geändert.';

  @override
  String get summaryUpdate => 'Zusammenfassung aktualisieren';

  @override
  String get summaryWriting => 'Zusammenfassung wird geschrieben…';

  @override
  String get summaryByCategory => 'Nach Kategorie';

  @override
  String get summaryNoSpending => 'Diesen Monat noch keine Ausgaben erfasst.';

  @override
  String themeTrialUntil(String time) {
    return 'Premium-Designs freigeschaltet bis $time';
  }

  @override
  String get zakatTitle => 'Zakat';

  @override
  String get zakatSubtitle =>
      'Berechne, was auf dein Vermögen fällig ist, und erfasse, was du zahlst';

  @override
  String get zakatSubtitleOff =>
      'Du zahlst keine Zakat. Tippe, um trotzdem nachzusehen';

  @override
  String get zakatAskTitle => 'Zahlst du Zakat?';

  @override
  String get zakatAskBody =>
      'Nicht jeder tut das. Wenn nicht, hält die App Zakat aus dem Weg: nichts fällig, keine Erinnerungen.';

  @override
  String get zakatIPay => 'Ich zahle Zakat';

  @override
  String get zakatIDontPay => 'Ich zahle keine Zakat';

  @override
  String get zakatOffTitle => 'Du zahlst keine Zakat';

  @override
  String get zakatOffBody =>
      'Daher wird bei Zakat nichts als fällig angezeigt, und es gibt keine Zakat-Erinnerungen. Du kannst trotzdem jederzeit sehen, wie viel es wäre; das Nachsehen ändert deine Antwort nicht.';

  @override
  String get zakatOffPeek => 'Sehen, wie viel es wäre';

  @override
  String get zakatPeekBanner =>
      'Nur ein Blick. Du hast angegeben, keine Zakat zu zahlen.';

  @override
  String get zakatOptOutTitle => 'Zakat nicht mehr verfolgen?';

  @override
  String get zakatOptOutBody =>
      'Nichts wird als fällig angezeigt, und es gibt keine Zakat-Erinnerungen. Deine Zahlen bleiben erhalten, und du kannst sie hier jederzeit prüfen.';

  @override
  String get zakatDue => 'Fällige Zakat';

  @override
  String zakatAboveNisab(String amount) {
    return 'Über dem Nisab: 2,5 % von $amount Nettovermögen';
  }

  @override
  String zakatBelowNisab(String amount) {
    return '$amount unter dem Nisab, daher ist keine Zakat fällig';
  }

  @override
  String get zakatNeedPrice =>
      'Gib den Preis pro Gramm ein, um den Nisab zu prüfen';

  @override
  String get zakatPaidSoFar => 'Dieses Jahr gezahlt';

  @override
  String get zakatLeftToPay => 'Noch zu zahlen';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Zakat-Datum $date, in $days Tagen',
      one: 'Zakat-Datum morgen, $date',
      zero: 'Dein Zakat-Datum ist heute',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Lege dein Zakat-Datum fest, um das Jahr zu verfolgen und erinnert zu werden';

  @override
  String get zakatPay => 'Zakat zahlen';

  @override
  String get zakatNisab => 'Nisab';

  @override
  String get zakatBasisGold => 'Gold';

  @override
  String get zakatBasisSilver => 'Silber';

  @override
  String get zakatBasisHint =>
      'Silber ergibt den niedrigeren Nisab und ist die vorsichtigere Wahl, wenn dein Vermögen überwiegend aus Bargeld besteht. Gib den heutigen örtlichen Preis für ein Gramm ein.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Preis pro Gramm ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams g zu diesem Preis';
  }

  @override
  String get zakatGroupCash => 'Bargeld und Bank';

  @override
  String get zakatGroupDeposits => 'Spareinlagen';

  @override
  String get zakatGroupInvestments => 'Geldanlagen';

  @override
  String get zakatGroupMetals => 'Gold und Silber';

  @override
  String get zakatGroupLent => 'An andere verliehenes Geld';

  @override
  String get zakatGroupOtherAssets => 'Andere Vermögenswerte';

  @override
  String get zakatGroupPaid => 'Dieses Jahr gezahlte Zakat';

  @override
  String get zakatGroupManual => 'Von dir hinzugefügt';

  @override
  String get zakatGroupBorrowed => 'Abzüglich: Geld, das du schuldest';

  @override
  String get zakatGroupCards => 'Abzüglich: Kreditkartenschulden';

  @override
  String get zakatOtherAssetsNote =>
      'Grundstück, Wohnung oder Auto zum Eigengebrauch sind nicht zakatpflichtig. Schalte eins nur ein, wenn du es zum Handel hältst.';

  @override
  String get zakatPaidNote =>
      'Wieder hinzugerechnet, weil es deine Konten verlassen hat, nachdem das Jahresvermögen gezählt wurde.';

  @override
  String get zakatNoMetals =>
      'Kein Gold oder Silber erfasst. Füge es als Vermögenswert hinzu oder trage seinen Wert unten ein.';

  @override
  String get zakatAddAmount => 'Betrag hinzufügen';

  @override
  String get zakatAmountLabel => 'Was ist es?';

  @override
  String get zakatAmountHint => 'Warenbestand, Bargeld zu Hause…';

  @override
  String get zakatAmountDeduct => 'Es ist eine jetzt fällige Schuld';

  @override
  String get zakatWealth => 'Zakatpflichtiges Vermögen';

  @override
  String get zakatDeductions => 'Jetzt fällige Schulden';

  @override
  String get zakatNet => 'Nettovermögen';

  @override
  String get zakatRate => '2,5 % des Nettovermögens';

  @override
  String get zakatYear => 'Zakat-Jahr';

  @override
  String get zakatDate => 'Zakat-Datum';

  @override
  String get zakatDateHint =>
      'Der Tag, an dem dein Zakat-Jahr endet. Er kommt jedes Mondjahr wieder, nach 354 Tagen.';

  @override
  String get zakatRemind => 'Erinnern';

  @override
  String get zakatRemindHint => '3 Tage vorher und am Tag selbst';

  @override
  String get zakatDisclaimer =>
      'Dies ist eine Hilfe zur Berechnung der Zakat, kein religiöses Urteil. Gelehrte sind sich in manchen Details uneinig; frag im Zweifel einen Gelehrten vor Ort.';

  @override
  String get zakatPayNote =>
      'Als Ausgabe unter Zakat erfasst und diesem Jahr angerechnet.';

  @override
  String get zakatPayRecord => 'Zahlung erfassen';

  @override
  String get zakatPaidSnack => 'Zakat erfasst';

  @override
  String get aiToolZakat => 'Zakat wird berechnet…';

  @override
  String get voiceButton => 'Buchung sprechen';

  @override
  String get voiceTitle => 'Sag es';

  @override
  String get voiceUnlimited => 'Unbegrenzt';

  @override
  String get voiceTapToTalk =>
      'Tippe auf die Kugel und sag, was du ausgegeben hast';

  @override
  String get voiceListening => 'Höre zu…';

  @override
  String get voiceStop => 'Zuhören beenden';

  @override
  String get voiceTypeInstead => 'Tippen';

  @override
  String get voiceSpeakInstead => 'Sprechen';

  @override
  String get voiceSend => 'Fertig';

  @override
  String get voiceTrySaying => 'Sag zum Beispiel';

  @override
  String get voiceExample1 => 'Mittagessen 12, Bus 3';

  @override
  String get voiceExample2 => 'Gehalt bekommen, 2.500';

  @override
  String get voiceExample3 => 'Der Kaffee gestern war 4, nicht 3';

  @override
  String get voiceExample4 => 'Lösch das Mittagessen von heute';

  @override
  String get voiceTypeHint => 'Mittagessen 12 und Bus 3 von bKash';

  @override
  String get voiceThinking => 'Wird ausgewertet…';

  @override
  String get voiceTryAgain => 'Nochmal';

  @override
  String get voiceSaving => 'Wird gespeichert…';

  @override
  String get voiceEdit => 'Bearbeiten';

  @override
  String get voiceNeedsYou => 'Braucht dich';

  @override
  String get voiceNew => 'Neu';

  @override
  String get voiceChange => 'Ändern';

  @override
  String get voiceRemove => 'Entfernen';

  @override
  String get voiceNeedsAmount =>
      'Es wurde kein Betrag genannt. Trag ihn ein, um diese Buchung hinzuzufügen.';

  @override
  String get voiceAdjust => 'Anpassen';

  @override
  String get voiceFillIn => 'Ausfüllen';

  @override
  String get voiceTime => 'Uhrzeit';

  @override
  String get voiceUndo => 'Rückgängig';

  @override
  String get voiceUndone => 'Wiederhergestellt';

  @override
  String get voiceNoSpeech =>
      'Das habe ich nicht verstanden. Versuch es noch einmal oder tippe es.';

  @override
  String get voiceMicOff =>
      'Mikrofonzugriff ist aus. Erlaube ihn in den Einstellungen oder tippe stattdessen.';

  @override
  String get voiceUnavailable =>
      'Spracheingabe ist auf diesem Handy nicht verfügbar. Du kannst stattdessen tippen.';

  @override
  String get voiceSomethingWrong =>
      'Etwas ist schiefgelaufen. Versuch es erneut.';

  @override
  String get voiceFabSetting => 'Schwebendes Mikro auf Heute';

  @override
  String get amountHidden => 'Verborgener Betrag';

  @override
  String get privacyShowAmounts => 'Beträge zeigen';

  @override
  String get privacyHideAmounts => 'Beträge verbergen';

  @override
  String get privacyAmounts => 'Beträge auf dem Bildschirm';

  @override
  String get privacyAmountsFooter =>
      'Salden und Summen werden unscharf, damit Leute in der Nähe sie nicht lesen können. Einzelne Buchungen bleiben sichtbar. Das Auge auf Heute zeigt oder verbirgt sie ebenfalls.';

  @override
  String get privacyHideTitle => 'Salden und Summen verbergen';

  @override
  String get privacyHideSub => 'Unscharf, bis du sie einblendest';

  @override
  String get privacyTapTitle => 'Auf verborgenen Betrag tippen zum Zeigen';

  @override
  String get privacyTapSub => 'Sonst zeigt sie nur das Auge auf Heute';

  @override
  String get privacyStartTitle => 'Beim Öffnen der App';

  @override
  String get privacyStartHidden => 'Verborgen';

  @override
  String get privacyStartHiddenSub =>
      'Immer mit verborgenen Salden und Summen öffnen';

  @override
  String get privacyStartShown => 'Sichtbar';

  @override
  String get privacyStartShownSub =>
      'Immer mit sichtbaren Salden und Summen öffnen';

  @override
  String get privacyStartRemember => 'Wie zuletzt';

  @override
  String get privacyStartRememberSub => 'So öffnen, wie das Auge zuletzt stand';

  @override
  String get privacyIntroTitle => 'Neu: Salden verbergen';

  @override
  String get privacyIntroBody =>
      'Salden und Summen sind jetzt verborgen, damit Leute in der Nähe sie nicht lesen können. Tippe auf das Auge auf Heute, um sie zu zeigen oder zu verbergen; die App merkt sich deine Wahl. In den Einstellungen legst du fest, wie die App startet.';

  @override
  String get privacyIntroOk => 'Verstanden';

  @override
  String get privacyIntroSettings => 'In Einstellungen wählen';

  @override
  String get voiceFabSettingSub =>
      'Ein Mikro, das über Heute schwebt, um Buchungen zu sprechen';

  @override
  String get voiceFabAskTitle => 'Mikro zu deinem Heute-Bildschirm hinzufügen?';

  @override
  String get voiceFabAskBody =>
      'Tippe darauf und sag, was du ausgegeben hast, z. B. \"Mittagessen 12 und Bus 3\". Du prüfst alles vor dem Speichern. Zieh es, wohin du willst.';

  @override
  String get voiceFabAskYes => 'Ja, Mikro hinzufügen';

  @override
  String get voiceFabAskNo => 'Nicht jetzt';

  @override
  String get voiceFabAskLater =>
      'Du kannst es jederzeit unter Mehr ein- oder ausschalten.';

  @override
  String get voiceFabHideTitle => 'Schwebendes Mikro ausblenden?';

  @override
  String get voiceFabHideBody =>
      'Das Mikro oben auf Heute bleibt. Dieses kannst du unter Mehr zurückholen.';

  @override
  String get voiceFabHide => 'Ausblenden';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count BEREIT ZUM SPEICHERN',
      one: '1 BEREIT ZUM SPEICHERN',
      zero: 'NICHTS BEREIT',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count speichern',
      one: '1 speichern',
      zero: 'Nichts ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen gespeichert',
      one: '1 Buchung gespeichert',
    );
    return '$_temp0';
  }
}
