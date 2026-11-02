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
  String get settingsBillRemindersNote =>
      'Kreditkartenrechnungen und Planraten berechnet die App auf deinem Handy, damit deine Beträge privat bleiben. Wenn du die App ein paar Tage nicht öffnest, kann eine Erinnerung verspätet kommen oder ausbleiben.';

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
  String get voiceNeedsConnection =>
      'Sprache braucht eine Verbindung. Du kannst stattdessen tippen.';

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
  String get ppTitle => 'Passphrase-Schutz';

  @override
  String get ppRowOn => 'An';

  @override
  String get ppRowOff => 'Aus';

  @override
  String get ppRowLocked => 'Auf diesem Handy gesperrt';

  @override
  String get ppIntro =>
      'Deine Daten sind auf diesem Handy und in deinen Sicherungen bereits verschlüsselt. Eine Passphrase fügt ein weiteres Schloss hinzu, sodass nur du deine synchronisierten Daten und Sicherungen öffnen kannst – nicht einmal wir.';

  @override
  String get ppWithoutTitle => 'Ohne Passphrase (so wie jetzt)';

  @override
  String get ppWithout1 => 'Alles auf diesem Handy ist verschlüsselt.';

  @override
  String get ppWithout2 =>
      'Sicherungen und synchronisierte Daten werden mit einem Schlüssel verschlüsselt, der an dein Konto gebunden ist.';

  @override
  String get ppWithout3 =>
      'Melde dich auf einem neuen Handy an, und alles ist wieder da, ohne dass du dir etwas merken musst.';

  @override
  String get ppWithout4 =>
      'Unser Server verwahrt diesen Schlüssel, also könnten wir deine synchronisierten Daten grundsätzlich öffnen.';

  @override
  String get ppWithTitle => 'Mit Passphrase';

  @override
  String get ppWith1 =>
      'Nur deine Passphrase oder dein Wiederherstellungscode kann deine synchronisierten Daten und Sicherungen öffnen.';

  @override
  String get ppWith2 =>
      'Unser Server bewahrt nur gesperrte Kopien deines Schlüssels auf. Wir können deine Daten nicht lesen, und auch niemand, der in unsere Server eindringt.';

  @override
  String get ppWith3 =>
      'Auf einem neuen Handy oder nach einer Neuinstallation gibst du deine Passphrase einmal ein.';

  @override
  String get ppWith4 =>
      'Dieses Handy funktioniert genau wie bisher weiter, auch offline.';

  @override
  String get ppCatchTitle => 'Der Haken';

  @override
  String get ppCatchBody =>
      'Wenn du deine Passphrase vergisst und auch deinen Wiederherstellungscode verlierst, kann niemand deine synchronisierten Daten oder Sicherungen wiederherstellen – weder wir noch sonst jemand. Was bereits auf diesem Handy ist, bleibt hier lesbar.';

  @override
  String get ppAiNote =>
      'KI-Funktionen senden weiterhin eine Zusammenfassung deiner Finanzen, damit sie dir antworten können. Eine Passphrase ändert daran nichts.';

  @override
  String get ppSetButton => 'Passphrase festlegen';

  @override
  String get ppSetTitle => 'Passphrase wählen';

  @override
  String get ppSetHint =>
      'Verwende mindestens 10 Zeichen. Ein paar zusammenhanglose Wörter sind leicht zu merken und schwer zu erraten.';

  @override
  String get ppPassphraseLabel => 'Passphrase';

  @override
  String get ppConfirmLabel => 'Noch einmal eingeben';

  @override
  String get ppTooShort => 'Verwende mindestens 10 Zeichen.';

  @override
  String get ppMismatch => 'Die beiden Passphrasen stimmen nicht überein.';

  @override
  String get ppUnderstand =>
      'Mir ist klar: Wenn ich sowohl meine Passphrase als auch meinen Wiederherstellungscode verliere, können meine synchronisierten Daten und Sicherungen nicht wiederhergestellt werden.';

  @override
  String get ppTurnOn => 'Schutz aktivieren';

  @override
  String get ppWorking =>
      'Dein Schlüssel wird gesperrt. Das dauert ein paar Sekunden…';

  @override
  String get ppMaybeSaved =>
      'Die Verbindung ist abgebrochen, der Server hat das vielleicht schon gespeichert. Wiederhole es, bis du einen Wiederherstellungscode siehst, und bewahre diesen auf.';

  @override
  String get ppRecoveryTitle => 'Dein Wiederherstellungscode';

  @override
  String get ppRecoveryBody =>
      'Das ist der einzige andere Weg zu deinen Daten, falls du deine Passphrase vergisst. Schreib ihn auf oder bewahre ihn in einem Passwort-Manager auf – irgendwo anders als auf diesem Handy.';

  @override
  String get ppCopy => 'Kopieren';

  @override
  String get ppCopied => 'Wiederherstellungscode kopiert';

  @override
  String get ppSavedIt =>
      'Ich habe meinen Wiederherstellungscode sicher aufbewahrt';

  @override
  String get ppDone => 'Fertig';

  @override
  String get ppOnTitle => 'Schutz ist aktiv';

  @override
  String get ppOnBody =>
      'Nur deine Passphrase oder dein Wiederherstellungscode kann deine synchronisierten Daten und Sicherungen öffnen.';

  @override
  String get ppChange => 'Passphrase ändern';

  @override
  String get ppNewCode => 'Neuen Wiederherstellungscode erhalten';

  @override
  String get ppNewCodeWarn =>
      'Dein aktueller Wiederherstellungscode funktioniert dann nicht mehr. Bewahre den neuen unbedingt auf.';

  @override
  String get ppTurnOff => 'Schutz deaktivieren';

  @override
  String get ppTurnOffBody =>
      'Unser Server verwahrt deinen Schlüssel dann wieder wie zuvor. Deine Daten bleiben verschlüsselt, aber grundsätzlich könnten wir deine synchronisierten Daten öffnen.';

  @override
  String get ppLockedTitle => 'Daten entsperren';

  @override
  String get ppLockedBody =>
      'Deine Daten sind mit einer Passphrase geschützt. Gib sie einmal auf diesem Handy ein, um deine synchronisierten Daten und Sicherungen zu öffnen.';

  @override
  String get ppUnlock => 'Entsperren';

  @override
  String get ppUseRecovery => 'Stattdessen Wiederherstellungscode verwenden';

  @override
  String get ppUsePassphrase => 'Stattdessen Passphrase verwenden';

  @override
  String get ppRecoveryLabel => 'Wiederherstellungscode';

  @override
  String get ppWrongPassphrase => 'Diese Passphrase ist nicht richtig.';

  @override
  String get ppWrongRecovery =>
      'Dieser Wiederherstellungscode ist nicht richtig.';

  @override
  String get ppUnlocked => 'Auf diesem Handy entsperrt';

  @override
  String get ppChanged => 'Passphrase geändert';

  @override
  String get ppTurnedOn => 'Schutz ist aktiv';

  @override
  String get ppTurnedOff => 'Schutz deaktiviert';

  @override
  String get encIntroTitle => 'Deine Daten sind jetzt verschlüsselt';

  @override
  String get encIntroBody =>
      'Alles auf diesem Handy wird verschlüsselt gespeichert, und deine Backups und synchronisierten Daten werden verschlüsselt, bevor sie es verlassen. Du musst nichts tun.';

  @override
  String get encIntroPassphrase =>
      'Möchtest du ein zusätzliches Schloss? Lege eine Passphrase fest, dann kannst nur du deine synchronisierten Daten und Backups öffnen – nicht einmal wir. Das ist optional; wenn du die Passphrase und ihren Wiederherstellungscode beide verlierst, sind diese Daten nicht wiederherstellbar.';

  @override
  String get encIntroSetUp => 'Passphrase festlegen';

  @override
  String get encIntroNotNow => 'Nicht jetzt';

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

  @override
  String get ppNeedsConnection =>
      'Für die Passphrase-Einstellungen brauchst du eine Internetverbindung. Verbinde dich mit einem Netzwerk und öffne sie erneut.';

  @override
  String get offlineToast =>
      'Du bist offline. Alles, was du hinzufügst, wird auf diesem Handy gespeichert und synchronisiert, sobald du wieder online bist.';

  @override
  String get backupLockedTitle => 'Dieses Backup entsperren';

  @override
  String get backupLockedBody =>
      'Dieses Backup ist mit einer Passphrase geschützt. Gib sie oder deinen Wiederherstellungscode ein, um es zu öffnen. Das funktioniert auch ohne Internetverbindung.';

  @override
  String get settingsSupportDescribeFirst =>
      'Bitte beschreibe zuerst dein Anliegen';

  @override
  String get settingsSupportSent => 'Danke! Deine Nachricht wurde gesendet.';

  @override
  String get settingsSupportSendFailed =>
      'Senden gerade nicht möglich. Versuch es noch einmal oder schreib uns direkt eine E-Mail.';

  @override
  String get settingsSupportSubjectHint => 'Worum geht es?';

  @override
  String get settingsSupportMessageHint =>
      'Beschreibe deine Frage, dein Problem oder dein Feedback…';

  @override
  String get settingsSupportHeroBody =>
      'Fragen, Fehler oder Feedback – schick es uns, und wir melden uns bei dir.';

  @override
  String get settingsSupportTipDescription =>
      'Eine klare Beschreibung deines Problems';

  @override
  String get settingsSupportTipSteps =>
      'Schritte zum Nachstellen (bei einem Fehler)';

  @override
  String get settingsSupportTipDevice =>
      'Dein Gerätemodell und deine Android-Version';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'Lieber per E-Mail? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'E-Mail-Adresse kopiert';

  @override
  String get settingsAboutTagline => 'Dein persönlicher Finanzbegleiter';

  @override
  String settingsAboutVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get settingsAboutDescription =>
      'Eine Finanz-App mit Fokus\nauf Datenschutz und schönem Design.';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'Basiswährung: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'Zuletzt aktualisiert: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'Kurs bearbeiten: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'Aktueller API-Kurs: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return 'vor $count Minuten';
  }

  @override
  String settingsHoursAgo(int count) {
    return 'vor $count Stunden';
  }

  @override
  String settingsDaysAgo(int count) {
    return 'vor $count Tagen';
  }

  @override
  String get settingsExportSectionDateRange => 'ZEITRAUM';

  @override
  String get settingsExportSectionFormat => 'FORMAT';

  @override
  String get settingsExportSectionInclude => 'EINSCHLIESSEN';

  @override
  String get settingsExportAllTime => 'Gesamter Zeitraum';

  @override
  String get settingsExportThisMonth => 'Dieser Monat';

  @override
  String get settingsExportLastMonth => 'Letzter Monat';

  @override
  String get settingsExportLast3Months => 'Letzte 3 Monate';

  @override
  String get settingsExportThisYear => 'Dieses Jahr';

  @override
  String get settingsExportPdfPremiumBody =>
      'Der CSV-Export ist kostenlos – deine Daten gehören immer dir. Der formatierte PDF-Bericht mit Zusammenfassungen und Aufschlüsselung nach Kategorie und Konto ist eine Premium-Funktion.';

  @override
  String settingsExportButton(String format) {
    return '$format exportieren';
  }

  @override
  String settingsExportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant – Export';

  @override
  String settingsExportedCount(int count) {
    return '$count Buchungen exportiert';
  }

  @override
  String get settingsExportPdfShareSubject => 'The Accountant – Finanzbericht';

  @override
  String settingsExportPdfGenerated(int count) {
    return 'PDF-Bericht mit $count Buchungen erstellt';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'Komma für Tausender';

  @override
  String get settingsNumberFormatDotThousands => 'Punkt für Tausender';

  @override
  String get settingsNumberFormatSpaceThousands => 'Leerzeichen für Tausender';

  @override
  String get settingsNumberFormatNoSeparator => 'Kein Trennzeichen';

  @override
  String get settingsAutoLockImmediately => 'Sofort';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'Nie';

  @override
  String get settingsBiometricUnavailable =>
      'Biometrische Anmeldung ist auf diesem Gerät nicht verfügbar';

  @override
  String get settingsSetPassword => 'Passwort festlegen';

  @override
  String get settingsChangePassword => 'Passwort ändern';

  @override
  String get settingsAddPasswordSubtitle =>
      'Füge deinem Konto ein Passwort hinzu';

  @override
  String get settingsPasswordChanged => 'Passwort geändert';

  @override
  String get settingsPasswordSet => 'Passwort festgelegt';

  @override
  String get settingsClearCacheBody =>
      'Dadurch werden zwischengespeicherte Daten geleert und beim nächsten App-Start neu synchronisiert. Deine Daten werden nicht gelöscht.';

  @override
  String get settingsClearingCache => 'Cache wird geleert...';

  @override
  String get settingsCacheCleared =>
      'Cache geleert und Synchronisierung gestartet';

  @override
  String get settingsClearCacheFailed => 'Cache konnte nicht geleert werden';

  @override
  String get settingsClearAllDataBody =>
      'Dadurch werden ALLE deine Buchungen, Budgets, Konten, Kategorien und Einstellungen endgültig gelöscht. Das kann nicht rückgängig gemacht werden!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'Alle deine Finanzdaten werden endgültig gelöscht.';

  @override
  String get settingsClearingAllData => 'Alle Daten werden gelöscht...';

  @override
  String get settingsAllDataCleared => 'Alle Daten gelöscht';

  @override
  String settingsClearDataFailed(String error) {
    return 'Daten konnten nicht gelöscht werden: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'Du wirst zu einem Formular weitergeleitet, um die Löschung deines Kontos zu beantragen. Das dauert ein paar Tage. Danach werden alle Daten auf dem Server endgültig gelöscht.';

  @override
  String get settingsLockAuthFailed =>
      'Authentifizierung fehlgeschlagen. Bitte versuch es noch einmal.';

  @override
  String get settingsLockError =>
      'Ein Fehler ist aufgetreten. Bitte versuch es noch einmal.';

  @override
  String get settingsLockAuthenticating => 'Authentifizierung läuft...';

  @override
  String get settingsProfileNameEmpty => 'Der Name darf nicht leer sein';

  @override
  String get settingsProfileUpdated => 'Profil aktualisiert';

  @override
  String get settingsProfileUpdateFailed =>
      'Profil konnte nicht aktualisiert werden';

  @override
  String get settingsProfileSaveChanges => 'Änderungen speichern';

  @override
  String get settingsProfileSaved => 'Gespeichert';

  @override
  String get settingsProfilePhotoSoon => 'Foto-Upload kommt bald';

  @override
  String get settingsProfileAccountInformation => 'Kontoinformationen';

  @override
  String get settingsProfileMemberSince => 'Mitglied seit';

  @override
  String get settingsProfileUnknown => 'Unbekannt';

  @override
  String get settingsProfileFree => 'Kostenlos';

  @override
  String get settingsProfileUserId => 'Benutzer-ID';

  @override
  String get settingsProfileUserIdCopied => 'Benutzer-ID kopiert';

  @override
  String get settingsPremiumMonthly => 'Premium monatlich';

  @override
  String get settingsPremiumYearly => 'Premium jährlich';

  @override
  String get settingsPremiumLifetime => 'Premium lebenslang';

  @override
  String get settingsUnsavedChangesBody =>
      'Du hast ungespeicherte Änderungen. Möchtest du wirklich gehen?';

  @override
  String settingsShareAppText(String url) {
    return 'Schau dir The Accountant an – eine schöne App für deine Finanzen!\n\n$url';
  }

  @override
  String get settingsShareAppSubject =>
      'The Accountant – App für persönliche Finanzen';

  @override
  String get settingsCloudSyncGateBody =>
      'Halte deine Finanzdaten auf all deinen Geräten synchron. Verliere nie wieder deine Daten.';

  @override
  String settingsSyncPushed(int count) {
    return '$count gesendet';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$count empfangen';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count Konflikte';
  }

  @override
  String get settingsSyncNowSubtitle => 'Alle Änderungen senden und abrufen';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'Synchronisierung abgeschlossen – $pushed gesendet, $pulled empfangen';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'Synchronisierung unvollständig – $count Eintrag/Einträge konnten nicht gespeichert werden und werden erneut versucht. $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'Synchronisierung fehlgeschlagen: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'Daten auf diesem Gerät durch deine Cloud-Daten ersetzen';

  @override
  String get settingsRestoreFromCloudBody =>
      'Dadurch werden ALLE Daten auf diesem Gerät gelöscht und durch deine Cloud-Daten ersetzt. Noch nicht synchronisierte Änderungen auf diesem Gerät gehen verloren. Das kann nicht rückgängig gemacht werden.';

  @override
  String settingsRestoredFromCloud(int count) {
    return '$count Einträge aus der Cloud wiederhergestellt';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'Wiederherstellung abgebrochen – deine lokalen Daten bleiben unverändert. $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'Deine Daten werden alle 15 Minuten und beim Öffnen der App automatisch synchronisiert. Beträge, Namen und Notizen werden vor der Synchronisierung auf diesem Handy verschlüsselt, sodass unser Server sie nicht lesen kann.';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'Abgeschlossen in $seconds s';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'Abgeschlossen in $minutes min $seconds s';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'Ist das deine Kategorie „$name“?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'Gespeichert. Das wird bei der nächsten Synchronisierung übernommen.';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dein Konto hat bereits $count Kategorien namens „$name“. Sag uns, ob eine davon als integrierte Kategorie verwendet werden soll oder ob sie getrennt bleiben. Bis du dich entscheidest, ändert sich nichts.',
      one:
          'Dein Konto hat bereits eine Kategorie namens „$name“. Sag uns, ob sie als integrierte Kategorie verwendet werden oder getrennt bleiben soll. Bis du dich entscheidest, ändert sich nichts.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'Nein – meine behalten und eine separate hinzufügen';

  @override
  String get settingsReconcileNoneOfThese =>
      'Keine davon – eine separate hinzufügen';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Deine bestehenden Kategorien „$name“ bleiben genau so, wie sie sind, mit all ihren Buchungen. Eine neue integrierte Kategorie „$name“ wird daneben hinzugefügt.',
      one:
          'Deine bestehende Kategorie „$name“ bleibt genau so, wie sie ist, mit all ihren Buchungen. Eine neue integrierte Kategorie „$name“ wird daneben hinzugefügt.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'Getrennt halten';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return '„$name“ verwenden?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sie wird zur integrierten Kategorie „$name“ und behält alle $count Buchungen samt Unterkategorien. Nichts wird gelöscht.',
      zero:
          'Sie wird zur integrierten Kategorie „$name“ und behält alles, was darunter abgelegt ist, samt Unterkategorien. Nichts wird gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'Diese verwenden';

  @override
  String settingsReconcileWillUse(String name) {
    return '„$name“ wird verwendet.';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'Eine separate Kategorie „$name“ wird hinzugefügt.';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'Gib dein aktuelles Passwort ein und wähle ein neues';

  @override
  String get settingsSetPasswordSubtitle =>
      'Füge deinem Konto ein Passwort für zusätzliche Sicherheit hinzu';

  @override
  String get settingsEnterCurrentPassword =>
      'Bitte gib dein aktuelles Passwort ein';

  @override
  String get settingsEnterNewPassword => 'Bitte gib ein neues Passwort ein';

  @override
  String get settingsPasswordMinLength =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get settingsConfirmYourPassword => 'Bitte bestätige dein Passwort';

  @override
  String get settingsPasswordsDoNotMatch =>
      'Die Passwörter stimmen nicht überein';

  @override
  String get settingsPleaseWait => 'Bitte warten...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'Gib „$word“ zur Bestätigung ein';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return '$percent % des Budgets';
  }

  @override
  String get authTooManyAttempts =>
      'Zu viele Versuche. Bitte warte eine Minute und versuch es dann noch einmal.';

  @override
  String get authServerDown =>
      'Wir konnten unsere Server nicht erreichen. Das liegt an uns – bitte versuch es in ein paar Minuten noch einmal.';

  @override
  String get authInitFailed => 'Anmeldung konnte nicht initialisiert werden';

  @override
  String get authSignInError => 'Bei der Anmeldung ist ein Fehler aufgetreten';

  @override
  String get authSignUpError =>
      'Bei der Registrierung ist ein Fehler aufgetreten';

  @override
  String get authGoogleCancelled =>
      'Die Google-Anmeldung wurde abgebrochen oder ist fehlgeschlagen';

  @override
  String get authFirebaseTokenFailed =>
      'Firebase-ID-Token konnte nicht abgerufen werden';

  @override
  String get authGoogleSignInError =>
      'Bei der Google-Anmeldung ist ein Fehler aufgetreten';

  @override
  String get authAccountExistsDifferentCredential =>
      'Es gibt bereits ein Konto mit dieser E-Mail-Adresse, aber mit anderen Anmeldedaten.';

  @override
  String get authInvalidCredential =>
      'Die Anmeldedaten sind ungültig oder abgelaufen.';

  @override
  String get authGoogleDisabled => 'Die Google-Anmeldung ist deaktiviert.';

  @override
  String get authUserDisabled => 'Dieses Benutzerkonto wurde deaktiviert.';

  @override
  String get authAppleSignInError =>
      'Bei der Apple-Anmeldung ist ein Fehler aufgetreten';

  @override
  String get authAppleDisabled => 'Die Apple-Anmeldung ist deaktiviert.';

  @override
  String get authNoPendingLink => 'Kein Konto zum Verknüpfen vorhanden';

  @override
  String get authLinkFailed => 'Konto konnte nicht verknüpft werden';

  @override
  String get authIncorrectPassword =>
      'Falsches Passwort. Bitte versuch es noch einmal.';

  @override
  String get authSignOutError => 'Beim Abmelden ist ein Fehler aufgetreten';

  @override
  String get authLinkSubtitle =>
      'Mit dieser E-Mail-Adresse gibt es bereits ein Konto. Gib dein Passwort ein, um dein Google-Konto zu verknüpfen.';

  @override
  String get authEnterYourPasswordHint => 'Gib dein Passwort ein';

  @override
  String get authEnterYourPassword => 'Bitte gib dein Passwort ein';

  @override
  String get authLinkInfo =>
      'Nach dem Verknüpfen kannst du dich per E-Mail/Passwort oder mit Google anmelden.';

  @override
  String get authEnterYourEmail => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get authEnterValidEmail => 'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get authPasswordMin6 =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get authNoAccountPrompt => 'Noch kein Konto? ';

  @override
  String get authForgotPasswordTitle => 'Passwort vergessen';

  @override
  String get authCheckYourEmail => 'Prüfe deine E-Mails';

  @override
  String get authForgotPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein, und wir schicken dir einen Code zum Zurücksetzen deines Passworts.';

  @override
  String authCodeSentSubtitle(String email) {
    return 'Wir haben einen 6-stelligen Code an $email geschickt. Gib ihn unten zusammen mit deinem neuen Passwort ein.';
  }

  @override
  String get authEnterYourEmailHint => 'Gib deine E-Mail-Adresse ein';

  @override
  String get authSixDigitCodeHint => '6-stelliger Code';

  @override
  String get authEnterTheCode => 'Bitte gib den Code ein';

  @override
  String get authCodeIsSixDigits => 'Der Code hat 6 Ziffern';

  @override
  String get authCreateNewPasswordHint => 'Neues Passwort erstellen';

  @override
  String get authReenterNewPasswordHint => 'Neues Passwort erneut eingeben';

  @override
  String get authEnterYourNameHint => 'Gib deinen Namen ein';

  @override
  String get authEnterFullName => 'Bitte gib deinen vollständigen Namen ein';

  @override
  String get authNameMin2 => 'Der Name muss mindestens 2 Zeichen lang sein';

  @override
  String get authCreatePasswordHint => 'Passwort erstellen';

  @override
  String get authPasswordComplexity =>
      'Muss Groß- und Kleinbuchstaben sowie eine Zahl enthalten';

  @override
  String get authReenterPasswordHint => 'Passwort erneut eingeben';

  @override
  String get authStrengthWeak => 'Schwach';

  @override
  String get authStrengthFair => 'Mittel';

  @override
  String get authStrengthGood => 'Gut';

  @override
  String get authStrengthStrong => 'Stark';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'Ich stimme den $terms und der $privacy zu';
  }

  @override
  String get authDefaultUserName => 'Nutzer';

  @override
  String authMemberSince(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get authFieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String authSignOutFailed(String error) {
    return 'Abmelden fehlgeschlagen: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'Bild konnte nicht ausgewählt werden: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'Profil konnte nicht aktualisiert werden: $error';
  }

  @override
  String get premiumSaveAbout44 => 'Spare ca. 44 %';

  @override
  String get premiumBestValue => 'Bestes Angebot';

  @override
  String get premiumIapUnavailable => 'IAP nicht verfügbar';

  @override
  String get premiumProductNotFound => 'Produkt nicht gefunden';

  @override
  String get premiumPlanUnavailable =>
      'Dieser Tarif ist für dein Konto gerade nicht verfügbar';

  @override
  String get premiumRestoreFailed =>
      'Käufe konnten nicht wiederhergestellt werden';

  @override
  String get premiumPurchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get premiumVerificationFailed => 'Überprüfung fehlgeschlagen';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wochen',
      one: '1 Woche',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate',
      one: '1 Monat',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jahre',
      one: '1 Jahr',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'Du hast $count von $limit kostenlosen $items genutzt.';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'Hol dir Premium für unbegrenzte $items und mehr!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'Du hast das kostenlose Limit von $limit $items erreicht. Hol dir Premium für unbegrenzte $items.';
  }

  @override
  String get premiumLimitWallets => 'Konten';

  @override
  String get premiumLimitCategories => 'eigene Kategorien';

  @override
  String get premiumLimitBudgets => 'aktive Budgets';

  @override
  String get premiumLimitObjectives => 'aktive Ziele';

  @override
  String get premiumLimitPaymentMethods => 'Zahlungsmethoden';

  @override
  String get backupErrNotJson =>
      'Diese Datei ist keine Sicherung – sie konnte nicht als JSON gelesen werden.';

  @override
  String get backupErrNotOurs =>
      'Diese Datei ist keine Sicherung von The Accountant.';

  @override
  String get backupErrNewerVersion =>
      'Diese Sicherung stammt von einer neueren Version der App. Aktualisiere The Accountant und versuch es noch einmal.';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'Diese Sicherung stammt von einer älteren App-Version, als diese lesen kann (Datenbank $version, älteste unterstützte $oldest).';
  }

  @override
  String get backupErrNoData => 'Diese Sicherung enthält keine Daten.';

  @override
  String backupErrSectionDamaged(String section) {
    return 'Der Abschnitt „$section“ dieser Sicherung ist beschädigt.';
  }

  @override
  String get backupErrNoHeader =>
      'Dieser Sicherung fehlt die Kopfzeile, die angibt, was sie ist.';

  @override
  String get backupErrNoSchemaVersion =>
      'Diese Sicherung gibt nicht an, von welcher Datenbankversion sie stammt, und kann daher nicht sicher wiederhergestellt werden.';

  @override
  String get backupErrNoDate =>
      'Diese Sicherung gibt nicht an, wann sie erstellt wurde.';

  @override
  String get backupErrDamaged => 'Diese Sicherungsdatei ist beschädigt.';

  @override
  String get backupErrWrongKey =>
      'Diese Sicherung gehört zu einem anderen Konto, oder die Datei wurde verändert. Melde dich mit dem Konto an, mit dem sie erstellt wurde, um sie wiederherzustellen.';

  @override
  String get backupErrNoPassphraseLock =>
      'Diese Sicherung kann nicht mit einer Passphrase geöffnet werden.';

  @override
  String get backupErrNeedsSecret =>
      'Diese Sicherung ist mit einer Passphrase geschützt. Gib sie oder den Wiederherstellungscode ein, um sie wiederherzustellen.';

  @override
  String get backupErrWrongSecret =>
      'Diese Passphrase oder dieser Wiederherstellungscode öffnet diese Sicherung nicht.';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'Diese Sicherung wurde mit einer neueren Version der App erstellt (Datenbank $version, diese Version liest bis $supported). Aktualisiere The Accountant und versuch es noch einmal.';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Google Drive war nicht erreichbar: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant darf Google Drive noch nicht verwenden.';

  @override
  String get backupDriveNoFolder =>
      'Google Drive konnte keinen Ordner für Sicherungen anlegen.';

  @override
  String get backupDriveNoFileId =>
      'Google Drive hat die Sicherung angenommen, aber nicht mitgeteilt, wo sie liegt.';

  @override
  String get backupDriveTimeout =>
      'Google Drive antwortet zu langsam. Versuch es später noch einmal.';

  @override
  String get backupDriveOffline =>
      'Keine Verbindung zu Google Drive. Versuch es noch einmal, sobald du online bist.';

  @override
  String get backupDriveDenied =>
      'Google Drive hat die Anfrage abgelehnt. Erteile den Zugriff erneut und versuch es noch einmal.';

  @override
  String get backupDriveFileGone =>
      'Diese Sicherung ist nicht mehr in Google Drive.';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'Google Drive hat mit $status geantwortet. $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'Versuch es gleich noch einmal.';

  @override
  String backupTakeFailed(String error) {
    return 'Die Sicherung konnte nicht erstellt werden: $error';
  }

  @override
  String get backupUnrestorableNewer =>
      'Von einer neueren Version der App erstellt.';

  @override
  String get backupUnrestorableOlder =>
      'Älter, als diese Version der App lesen kann.';

  @override
  String get backupKeyUnusable =>
      'Der Server hat einen unbrauchbaren Schlüssel gesendet. Versuch es später noch einmal.';

  @override
  String get backupKeyNeedsSignIn =>
      'Melde dich an, um eine Sicherung zu erstellen oder wiederherzustellen – Sicherungen werden mit deinem Konto verschlüsselt.';

  @override
  String get backupKeyNeedsInternet =>
      'Verbinde dich einmal mit dem Internet, damit deine Daten verschlüsselt werden können, und versuch es dann noch einmal.';

  @override
  String get backupKeyLocked =>
      'Deine Daten sind mit einer Passphrase geschützt. Entsperre sie zuerst auf diesem Gerät.';

  @override
  String get backupFrequencyManual => 'Nur auf Anfrage';

  @override
  String get backupFrequencyDaily => 'Jeden Tag';

  @override
  String get backupFrequencyWeekly => 'Jede Woche';

  @override
  String get backupFrequencyMonthly => 'Jeden Monat';

  @override
  String get backupIntro =>
      'Eine Sicherung ist eine einzige Datei mit allem auf diesem Gerät – jeder Buchung, jedem Konto, jedem Budget und jedem Ziel. Bewahre eine an einem sicheren Ort auf, und nichts hier geht jemals endgültig verloren.';

  @override
  String get backupSectionOnDevice => 'AUF DIESEM GERÄT';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'SICHERUNGEN IN DRIVE';

  @override
  String backupBackedUpCount(int count) {
    return '$count Einträge gesichert.';
  }

  @override
  String get backupSaveDialogTitle => 'Sicherung speichern';

  @override
  String get backupChooseFileTitle => 'Sicherungsdatei auswählen';

  @override
  String backupFileUnreadable(String error) {
    return 'Diese Datei konnte nicht gelesen werden: $error';
  }

  @override
  String backupTakenOn(String date) {
    return 'Erstellt am $date.';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return 'Erstellt am $date auf $device.';
  }

  @override
  String backupBelongedTo(String email) {
    return 'Sie gehörte zu $email.';
  }

  @override
  String get backupDifferentAccountWarning =>
      'Das ist nicht das hier angemeldete Konto. Beim Wiederherstellen landen die Daten einer anderen Person auf diesem Gerät.';

  @override
  String get backupRestoreEraseWarning =>
      'Alles, was sich gerade auf diesem Gerät befindet, wird gelöscht und ersetzt. Noch nicht Synchronisiertes geht verloren. Das kann nicht rückgängig gemacht werden.';

  @override
  String backupRestoredCount(int count) {
    return '$count Einträge wiederhergestellt.';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$count Einträge wiederhergestellt. Ein Teil der Datei passte nicht zu dieser Version und wurde weggelassen.';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'Nichts wurde geändert – die Wiederherstellung ist fehlgeschlagen: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'Sicherungen landen in einem privaten Ordner, den nur diese App öffnen kann. Deine anderen Dateien werden nie gelesen.';

  @override
  String get backupDriveConnectedTitle => 'Google Drive verbunden';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'Sicherungen von diesem Gerät werden in einem Ordner namens „$folder“ in deinem Drive gespeichert.';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'Sicherungen werden in „$folder“ in deinem Drive gespeichert.';
  }

  @override
  String get backupNoneYet =>
      'Von diesem Gerät wurde noch keine Sicherung hochgeladen';

  @override
  String backupLastBackedUp(String date) {
    return 'Zuletzt gesichert: $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count Sicherungen – ältere werden entfernt, sobald eine neue ankommt';
  }

  @override
  String get backupDisconnectSubtitle =>
      'Beendet automatische Sicherungen. Bereits Gespeichertes wird nicht gelöscht.';

  @override
  String backupListFailed(String error) {
    return 'Deine Sicherungen konnten nicht aufgelistet werden: $error';
  }

  @override
  String get backupDriveNotGranted =>
      'Der Zugriff auf Google Drive wurde nicht erteilt.';

  @override
  String get backupDriveConnected => 'Google Drive verbunden.';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Google Drive konnte nicht verbunden werden: $error';
  }

  @override
  String get backupDisconnectBody =>
      'Automatische Sicherungen werden beendet. Die Sicherungen in Drive bleiben, wo sie sind, und du kannst dich jederzeit wieder verbinden.';

  @override
  String backupSavedToDrive(String name) {
    return '$name in Google Drive gespeichert.';
  }

  @override
  String backupCopyFailed(String error) {
    return 'Diese Sicherung konnte nicht gespeichert werden: $error';
  }

  @override
  String get backupDeleteBody =>
      'Sie wird endgültig aus Google Drive entfernt.';

  @override
  String get backupRefresh => 'Aktualisieren';

  @override
  String get ppErrKdfParams =>
      'Unzulässige Parameter für die Schlüsselableitung.';

  @override
  String get ppErrKdfAlgorithm =>
      'Unbekanntes Verfahren zur Schlüsselableitung.';

  @override
  String get onboardingIntroAccountsTitle => 'Alle Konten, ein Saldo';

  @override
  String get onboardingIntroAccountsBody =>
      'Behalte Bargeld, Karten und Ersparnisse nebeneinander im Blick und sieh, was dir wirklich bleibt.';

  @override
  String get onboardingIntroBudgetsTitle => 'Budgets, die rechtzeitig warnen';

  @override
  String get onboardingIntroBudgetsBody =>
      'Lege ein Limit pro Kategorie fest. Die App behält die Summe im Blick und warnt dich, bevor du es überschreitest, nicht erst danach.';

  @override
  String get onboardingIntroAskTitle => 'Frag nach deinen eigenen Ausgaben';

  @override
  String get onboardingIntroAskBody =>
      'Scanne einen Beleg oder frag, wohin das Geld letzten Monat gegangen ist, und erhalte eine Antwort aus deinen eigenen Einträgen.';

  @override
  String get onboardingIntroThemeTitle => 'Mach sie zu deiner';

  @override
  String get onboardingIntroThemeBody =>
      'Wähle jetzt ein Design oder ändere es jederzeit in den Einstellungen.';

  @override
  String get onboardingCreateYourAccount => 'Erstelle dein Konto';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingCurrencyInfo =>
      'Diese Währung wird deine Hauptwährung. Konten in anderen Währungen kannst du später hinzufügen.';

  @override
  String get onboardingTypeCash => 'Bargeld';

  @override
  String get onboardingTypeBank => 'Bankkonto';

  @override
  String get onboardingTypeCard => 'Kreditkarte';

  @override
  String get onboardingTypeDeposit => 'Festgeld';

  @override
  String get onboardingTypeInvestment => 'Investment';

  @override
  String get onboardingTypeAsset => 'Vermögenswert';

  @override
  String onboardingDayN(int day) {
    return 'Tag $day';
  }

  @override
  String get onboardingAllSet => 'Alles bereit!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'Einrichtung konnte nicht abgeschlossen werden: $error';
  }

  @override
  String get onboardingSkipFailed =>
      'Einrichtung konnte nicht übersprungen werden';

  @override
  String get startupOfflineConfirmBody =>
      'Deine Daten bleiben genau, wo sie sind – nichts auf diesem Gerät oder in der Cloud wird gelöscht.\n\nWenn das Konto aber bereits gespeicherte Daten hat, landet alles, was du jetzt hinzufügst, nach der Wiederherstellung daneben – eventuell musst du dann Duplikate aufräumen.';

  @override
  String get startupDataInCloudTitle => 'Deine Daten warten in der Cloud';

  @override
  String get startupLoadFailedTitle =>
      'Wir konnten dein Konto nicht fertig laden';

  @override
  String get startupGenericReason =>
      'Beim Prüfen dieses Kontos ist etwas schiefgelaufen.';

  @override
  String get startupUseWithoutRestoring =>
      'App ohne Wiederherstellung verwenden';

  @override
  String get legalTermsTab => 'Bedingungen';

  @override
  String get legalConsent =>
      'Ich habe die Datenschutzerklärung und die Nutzungsbedingungen gelesen und stimme ihnen zu';

  @override
  String get walkthroughGotIt => 'Verstanden!';

  @override
  String get settingsFaqSectionGettingStarted => 'Erste Schritte';

  @override
  String get settingsFaq01Question => 'Wie füge ich eine Buchung hinzu?';

  @override
  String get settingsFaq01Answer =>
      'Tippe auf die Schaltfläche + unten auf dem Startbildschirm. Gib den Betrag ein, wähle eine Kategorie und ein Konto und füge bei Bedarf Notizen hinzu. Tippe auf Speichern, um die Buchung zu erfassen.';

  @override
  String get settingsFaq02Question =>
      'Was ist der Unterschied zwischen Konten und Kategorien?';

  @override
  String get settingsFaq02Answer =>
      'Konten zeigen, wo dein Geld liegt (z. B. Bargeld, Bankkonto, Kreditkarte). Kategorien beschreiben, wofür das Geld ausgegeben wurde oder woher es kam (z. B. Essen, Gehalt, Unterhaltung).';

  @override
  String get settingsFaq03Question =>
      'Wie passe ich Datums- und Zahlenformat an?';

  @override
  String get settingsFaq03Answer =>
      'Geh zu Einstellungen > Regionale Einstellungen. Dort kannst du deine Standardwährung, das Datumsformat (z. B. DD/MM/YYYY oder MM/DD/YYYY) und das Zahlenformat (z. B. 1,234.56 oder 1.234,56) ändern. Eine Live-Vorschau zeigt, wie deine Einstellungen aussehen.';

  @override
  String get settingsFaqSectionTransactions => 'Buchungen';

  @override
  String get settingsFaq04Question =>
      'Kann ich wiederkehrende Buchungen erfassen?';

  @override
  String get settingsFaq04Answer =>
      'Ja! Aktiviere beim Hinzufügen einer Buchung die Option „Wiederkehrend“. Du kannst sie täglich, wöchentlich, monatlich oder jährlich wiederholen lassen. Die App legt diese Buchungen dann automatisch für dich an.';

  @override
  String get settingsFaq05Question => 'Wie buche ich Geld zwischen Konten um?';

  @override
  String get settingsFaq05Answer =>
      'Wähle beim Hinzufügen einer Buchung „Umbuchung“ als Typ. Wähle das Quellkonto und das Zielkonto und gib den Betrag ein. Die App zieht den Betrag automatisch von einem Konto ab und schreibt ihn dem anderen gut.';

  @override
  String get settingsFaq06Question => 'Was sind anstehende Buchungen?';

  @override
  String get settingsFaq06Answer =>
      'Anstehende Buchungen sind künftige Ausgaben oder Einnahmen, die du erwartest, aber noch nicht bezahlt hast. Sie wirken sich erst auf deinen Kontostand aus, wenn du sie als bezahlt markierst. Überfällige und anstehende Einträge findest du im Bereich Buchungen.';

  @override
  String get settingsFaq07Question => 'Wie behalte ich meine Abos im Blick?';

  @override
  String get settingsFaq07Answer =>
      'Setze beim Hinzufügen einer Buchung den Typ auf Abo. So wird sie als regelmäßige Zahlung für einen Dienst markiert. Du siehst alle deine Abos an einem Ort und behältst deine monatlichen Abo-Ausgaben im Blick.';

  @override
  String get settingsFaq08Question =>
      'Wie funktionieren Forderungen und Schulden?';

  @override
  String get settingsFaq08Answer =>
      'Nutze Forderung für Geld, das du jemandem geliehen hast, und Schuld für Geld, das du dir geliehen hast. Jeder Eintrag hält den Betrag fest, wer wem etwas schuldet und wie viel schon zurückgezahlt ist. Du kannst Teilzahlungen erfassen und Schulden als beglichen markieren, wenn alles zurückgezahlt ist.';

  @override
  String get settingsFaq09Question =>
      'Kann ich Buchungen Notizen oder Belege hinzufügen?';

  @override
  String get settingsFaq09Answer =>
      'Ja! Beim Hinzufügen oder Bearbeiten einer Buchung kannst du Notizen ins Notizfeld schreiben. Premium-Nutzer können außerdem Belege mit dem KI-Beleg-Scan erfassen, der Betrag und Händler automatisch ausliest.';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'Konten & Währungen';

  @override
  String get settingsFaq10Question => 'Wie verwalte ich mehrere Konten?';

  @override
  String get settingsFaq10Answer =>
      'Die App kennt vier Kontotypen: Bargeld, Bankkonto, Kreditkarte und Abo. Um ein neues Konto anzulegen, geh auf dem Dashboard zu „Deine Konten“ und tippe auf „Konto hinzufügen“. Jedes Konto kann einen eigenen Namen, ein Symbol, eine Farbe und eine Währung haben. Dein erstes Konto wird automatisch zum Standardkonto. Bei Kreditkarten kannst du außerdem ein Kreditlimit und den Abrechnungstag festlegen, damit du deinen verfügbaren Kredit im Blick hast.';

  @override
  String get settingsFaq11Question => 'Kann ich mehrere Währungen nutzen?';

  @override
  String get settingsFaq11Answer =>
      'Ja! Jedes Konto kann eine eigene Währung haben. Die App rechnet Währungen automatisch mit aktuellen Wechselkursen um. Eigene Wechselkurse kannst du unter Einstellungen > Regionale Einstellungen festlegen.';

  @override
  String get settingsFaq12Question =>
      'Wie funktioniert die Währungsumrechnung?';

  @override
  String get settingsFaq12Answer =>
      'Jedes Konto kann eine andere Währung haben, und die App rechnet Beträge automatisch mit aktuellen Wechselkursen um, die alle paar Stunden aktualisiert werden. Eigene Wechselkurse für jedes Währungspaar kannst du unter Einstellungen > Regionale Einstellungen festlegen. Die App unterstützt über 150 Währungen und ruft die Kurse automatisch ab.';

  @override
  String get settingsFaq13Question =>
      'Was passiert, wenn ich eine Kategorie mit Buchungen lösche?';

  @override
  String get settingsFaq13Answer =>
      'Diese Buchungen werden nach „Ohne Kategorie“ verschoben. Du kannst sie dann einer anderen Kategorie zuordnen oder ohne Kategorie lassen.';

  @override
  String get settingsFaq14Question =>
      'Was sind Unterkategorien und wie nutze ich sie?';

  @override
  String get settingsFaq14Answer =>
      'Du kannst unter jeder Hauptkategorie Unterkategorien anlegen, um genauer zu erfassen. Unter „Essen“ zum Beispiel „Lebensmittel“, „Restaurants“ und „Kaffee“. Mit Unterkategorien siehst du genau, wohin dein Geld geht.';

  @override
  String get settingsFaq15Question => 'Was ist eine Saldokorrektur?';

  @override
  String get settingsFaq15Answer =>
      'Mit einer Saldokorrektur passt du den Kontostand an, wenn er nicht mit dem tatsächlichen Betrag übereinstimmt. Dabei entsteht eine besondere Buchung, die deinen erfassten Stand an die Wirklichkeit angleicht, ohne dass du von Hand Einnahmen oder Ausgaben eintragen musst.';

  @override
  String get settingsFaqSectionBudgetsGoals => 'Budgets & Ziele';

  @override
  String get settingsFaq16Question => 'Wie lege ich ein Budget an?';

  @override
  String get settingsFaq16Answer =>
      'Geh zum Tab Budgets und tippe auf „Neues Budget“. Gib einen Namen ein, lege dein Ausgabenlimit fest, wähle den Zeitraum (wöchentlich/monatlich) und wähle die Kategorien, die erfasst werden sollen. Die App warnt dich, wenn du dich deinem Limit näherst.';

  @override
  String get settingsFaq17Question => 'Was sind Sparziele?';

  @override
  String get settingsFaq17Answer =>
      'Mit Sparzielen legst du einen Betrag fest, den du sparen möchtest. Erstelle im Bereich Ziele ein Ziel, lege den Zielbetrag fest und verknüpfe Buchungen, um deinen Fortschritt zu verfolgen. Die App zeigt einen Fortschrittsbalken und wie viel Prozent du schon erreicht hast.';

  @override
  String get settingsFaq18Question => 'Wie behalte ich ein Darlehen im Blick?';

  @override
  String get settingsFaq18Answer =>
      'Lege im Bereich Ziele ein Darlehen mit dem gesamten geschuldeten Betrag an. Verknüpfe deine Zahlungen mit dem Darlehen, um zu sehen, wie weit du mit der Rückzahlung bist. Die App zeigt, wie viel du schon gezahlt hast und was noch offen ist.';

  @override
  String get settingsFaqSectionDataSync => 'Daten & Sync';

  @override
  String get settingsFaq19Question => 'Wie funktioniert Cloud-Sync?';

  @override
  String get settingsFaq19Answer =>
      'Cloud-Sync hält deine Daten auf allen Geräten aktuell. Geh zu Einstellungen > Datenverwaltung > Cloud-Sync, um es einzuschalten. Die Synchronisierung läuft automatisch alle 15 Minuten und beim Öffnen der App. Du kannst auch auf „Jetzt synchronisieren“ tippen, um sofort zu synchronisieren. Das ist eine Premium-Funktion.';

  @override
  String get settingsFaq20Question => 'Wie exportiere ich meine Daten?';

  @override
  String get settingsFaq20Answer =>
      'Geh zu Einstellungen > Datenverwaltung > Daten exportieren. Wähle einen Zeitraum, dann CSV (für Tabellen) oder PDF (für einen formatierten Bericht) und tippe auf Exportieren. Du kannst Aufschlüsselungen nach Kategorie und Konto ein- oder ausblenden. Das ist eine Premium-Funktion.';

  @override
  String get settingsFaq21Question =>
      'Was passiert, wenn ich meine Daten lösche?';

  @override
  String get settingsFaq21Answer =>
      'Geh zu Einstellungen > Datenschutz & Sicherheit. „Cache leeren“ entfernt temporäre Daten und erzwingt eine neue Synchronisierung, ohne deine Buchungen zu löschen. „Alle Daten löschen“ löscht alles endgültig – zur Bestätigung musst du DELETE eintippen. Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsFaqSectionPremiumAiFeatures => 'Premium & KI-Funktionen';

  @override
  String get settingsFaq22Question => 'Was ist in Premium enthalten?';

  @override
  String get settingsFaq22Answer =>
      'Premium schaltet frei: unbegrenzte KI (Coach, Monatsübersichten, Belege lesen und Beschreib es) ohne Werbung, Cloud-Sync, PDF-Berichte und Premium-Designs, und es hebt die Limits für Konten, Kategorien, Budgets, Ziele und Zahlungsmethoden auf. Außerdem bekommst du bevorzugten Support.';

  @override
  String get settingsFaq23Question =>
      'Welche Limits gibt es in der kostenlosen Version?';

  @override
  String get settingsFaq23Answer =>
      'Kostenlos kannst du bis zu 3 Konten, 10 eigene Kategorien, 3 aktive Budgets, 2 aktive Ziele/Darlehen und 5 Zahlungsmethoden anlegen. Mit Premium fallen all diese Limits weg.';

  @override
  String get settingsFaq24Question => 'Was kann der KI-Assistent?';

  @override
  String get settingsFaq24Answer =>
      'Der Finanzcoach beantwortet Fragen zu deinem eigenen Geld: wohin es gegangen ist, ob du bei Budgets und Zielen auf Kurs bist, welche Rechnungen anstehen und wie du weniger ausgibst oder mehr sparst. Er sieht eine Zusammenfassung deiner Zahlen (Summen, Kategorien, Budgets, Ziele, Rechnungen und letzte Buchungen), damit seine Antworten mit deinen echten Zahlen arbeiten, und schlägt nach jeder Antwort Folgefragen vor. Er gibt allgemeine Tipps, keine professionelle Finanzberatung. Deine Unterhaltungen werden gespeichert, damit du dort weitermachen kannst, wo du aufgehört hast, und du kannst sie jederzeit löschen.';

  @override
  String get settingsFaq25Question => 'Wie funktionieren KI-Einblicke?';

  @override
  String get settingsFaq25Answer =>
      'Die Monatsübersicht (Statistik > Ausgabenanalyse) vergleicht diesen Monat mit dem letzten: was du eingenommen und ausgegeben hast und wie sich jede Kategorie verändert hat. Tippe auf Zusammenfassung schreiben, und die KI hebt hervor, was auffällt, und schlägt dir eine Sache zum Ausprobieren vor. Die Zahlen sind für alle kostenlos; der KI-Text verbraucht eine KI-Anfrage.';

  @override
  String get settingsFaq26Question =>
      'Was ist die intelligente Kategorisierung?';

  @override
  String get settingsFaq26Answer =>
      'Wenn du eine Buchung von Hand einordnest, merkt sich die App, zu welcher Kategorie dieser Titel gehört, und wählt sie beim nächsten Mal für dich aus (unter Benennungsregeln kannst du das ansehen und bearbeiten). Für etwas Neues tippst du auf dem Hinzufügen-Bildschirm auf die Glitzer-Schaltfläche und nutzt Beschreib es: Schreib etwa „Mittagessen 250 gestern von bKash“, und die KI füllt Betrag, Datum, Kategorie und Konto aus, damit du alles prüfen kannst.';

  @override
  String get settingsFaq27Question => 'Wie funktioniert der KI-Beleg-Scan?';

  @override
  String get settingsFaq27Answer =>
      'Mach ein Foto von einem Beleg oder wähle eines aus. Dein Handy liest den Text direkt auf dem Gerät und schlägt Händler und Summe vor. Tippe auf Mit KI lesen, und die KI ermittelt die echte Summe, das Datum, jeden Posten und die passende Kategorie, selbst bei einem unordentlichen Beleg; dabei wird nur der Text gesendet, nie das Foto. Vor dem Speichern kannst du alles prüfen und bearbeiten. Das Lesen mit KI verbraucht eine KI-Anfrage.';

  @override
  String get settingsFaq28Question =>
      'Wie viele KI-Anfragen bekomme ich, und wofür ist die Werbung?';

  @override
  String get settingsFaq28Answer =>
      'Alle bekommen 10 kostenlose KI-Anfragen pro Monat, die am 1. wieder aufgefüllt werden. Wenn du mehr möchtest, kannst du dir freiwillig eine kurze Werbung ansehen und bekommst dafür eine weitere Anfrage, bis zu 10 zusätzliche pro Monat. Mit Werbung kannst du auch ein Premium-Design 24 Stunden lang testen oder einen PDF-Export freischalten. Werbung läuft nur, nachdem du auf eine Schaltfläche getippt und bestätigt hast; es gibt keine Bannerwerbung und nichts erscheint von selbst. Premium-Mitglieder bekommen unbegrenzte KI und alles andere ganz ohne Werbung.';

  @override
  String get settingsFaq29Question => 'Wie verwalte ich meinen Premium-Kauf?';

  @override
  String get settingsFaq29Answer =>
      'Premium-Käufe werden über Google Play verwaltet. Öffne die Abo-Einstellungen in Google Play, um deinen Plan anzusehen oder zu verwalten. Premium gibt es monatlich, jährlich oder als einmaligen Kauf auf Lebenszeit.';

  @override
  String get settingsFaqSectionPrivacySecurity => 'Datenschutz & Sicherheit';

  @override
  String get settingsFaq30Question =>
      'Wie richte ich die biometrische Sperre ein?';

  @override
  String get settingsFaq30Answer =>
      'Geh zu Einstellungen > Datenschutz & Sicherheit und schalte die biometrische Sperre ein. Danach brauchst du deinen Fingerabdruck oder dein Gesicht, um die App zu öffnen. Du kannst auch eine automatische Sperre einstellen, damit sich die App nach einer Weile ohne Nutzung sperrt.';

  @override
  String get settingsFaq31Question => 'Sind meine Finanzdaten sicher?';

  @override
  String get settingsFaq31Answer =>
      'Ja. Alle deine Daten werden lokal auf deinem Gerät gespeichert. Wenn du Cloud-Sync nutzt, werden deine Daten bei der Übertragung verschlüsselt. Wir geben deine Finanzdaten nie an Dritte weiter. Unsere Datenschutzerklärung findest du unter Einstellungen > Über.';

  @override
  String get txnLoadPaymentMethodsFailed =>
      'Zahlungsmethoden konnten nicht geladen werden';

  @override
  String get txnAddPaymentMethodFailed =>
      'Zahlungsmethode konnte nicht hinzugefügt werden';

  @override
  String get txnPaymentMethodNotFound => 'Zahlungsmethode nicht gefunden';

  @override
  String get txnUpdatePaymentMethodFailed =>
      'Zahlungsmethode konnte nicht aktualisiert werden';

  @override
  String get txnDeletePaymentMethodFailed =>
      'Zahlungsmethode konnte nicht gelöscht werden';

  @override
  String txnLoadFailed(String error) {
    return 'Buchungen konnten nicht geladen werden: $error';
  }

  @override
  String get txnAddFailed => 'Buchung konnte nicht hinzugefügt werden';

  @override
  String txnAddFailedWithError(String error) {
    return 'Buchung konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get txnNotFound => 'Buchung nicht gefunden';

  @override
  String get txnUpdateFailed => 'Buchung konnte nicht aktualisiert werden';

  @override
  String txnNotATransfer(String id) {
    return 'Buchung $id ist keine Umbuchung';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'Umbuchung konnte nicht aktualisiert werden: $error';
  }

  @override
  String get txnDeleteFailed => 'Buchung konnte nicht gelöscht werden';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'Umbuchungen konnten nicht geladen werden: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'Umbuchung konnte nicht erstellt werden: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'Umbuchung konnte nicht gelöscht werden: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'Daten konnten nicht geladen werden: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'Konnte nicht als bezahlt markiert werden: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'Konnte nicht als unbezahlt markiert werden: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'Buchung konnte nicht übersprungen werden: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'Erhalten: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'Bezahlt: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'Storniert: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'Konnte nicht als beglichen markiert werden: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'Der Zahlungsbetrag muss größer als null sein';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'Zahlung konnte nicht erfasst werden: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'Konnte nicht als offen markiert werden: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'Offen: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'Zahlung von $amount erfasst';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'Als von „$title“ erhalten markiert';
  }

  @override
  String get importFieldDescription => 'Beschreibung';

  @override
  String get importFieldDirection => 'Art (Gutschrift/Lastschrift)';

  @override
  String get importMissingDate => 'eine Datumsspalte';

  @override
  String get importMissingAmount => 'eine Betragsspalte';

  @override
  String importColumnN(int index) {
    return 'Spalte $index';
  }

  @override
  String get importNoDate => 'Kein Datum';

  @override
  String importDateMismatch(String date, String format) {
    return 'Das Datum „$date“ passt nicht zu $format';
  }

  @override
  String get importAnyKnownFormat => 'einem bekannten Format';

  @override
  String get importNoAmount => 'Kein Betrag';

  @override
  String get importIntro =>
      'Exportiere eine CSV aus deiner Bank und öffne sie hier. Die Spalten werden für dich erkannt, und nichts wird hinzugefügt, bevor du genau gesehen hast, was es sein wird.';

  @override
  String get importSavedBanks => 'GESPEICHERTE BANKEN';

  @override
  String get importChooseStatement => 'Kontoauszug wählen';

  @override
  String get importNoRows => 'Diese Datei enthält keine Zeilen.';

  @override
  String importUsingSavedMapping(String name) {
    return 'Deine gespeicherte Zuordnung für $name wird verwendet.';
  }

  @override
  String importCouldNotRead(String error) {
    return 'Diese Datei konnte nicht gelesen werden: $error';
  }

  @override
  String importForgetTitle(String name) {
    return '$name vergessen?';
  }

  @override
  String get importForgetBody =>
      'Beim nächsten Mal wirst du erneut nach der Spaltenzuordnung gefragt.';

  @override
  String get importColumnsHeader => 'SPALTEN';

  @override
  String get importHowToRead => 'SO WERDEN DIE WERTE GELESEN';

  @override
  String get importWhereItGoes => 'WOHIN ES GEHT';

  @override
  String get importWhatWillBeAdded => 'WAS HINZUGEFÜGT WIRD';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen',
      one: '1 Zeile',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spalten',
      one: '1 Spalte',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'getrennt durch $separator';
  }

  @override
  String importMappedAs(String name) {
    return 'zugeordnet als $name';
  }

  @override
  String get importDelimCommas => 'Kommas';

  @override
  String get importDelimSemicolons => 'Semikolons';

  @override
  String get importDelimTabs => 'Tabulatoren';

  @override
  String get importDelimPipes => 'senkrechte Striche';

  @override
  String get importRequired => 'Erforderlich';

  @override
  String get importNotImported => 'Nicht importiert';

  @override
  String get importEmptySample => 'leer';

  @override
  String get importPickDateColumnFirst => 'Wähle zuerst eine Datumsspalte.';

  @override
  String importDateDoesNotFit(String sample) {
    return '„$sample“ passt nicht zu diesem Format.';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '„$sample“ wird als $date gelesen';
  }

  @override
  String get importDecimalAuto => 'Aus der Datei ermittelt';

  @override
  String get importDecimalFullStop => 'Ein Punkt, wie in 1,234.56';

  @override
  String get importDecimalComma => 'Ein Komma, wie in 1.234,56';

  @override
  String get importDuplicatesHint =>
      'Abgleich nach Tag, Betrag und Beschreibung, damit ein überlappender Auszug nichts doppelt importiert';

  @override
  String importStillNeeds(String item) {
    return 'Es fehlt noch $item.';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'Es fehlen noch $first und $second.';
  }

  @override
  String get importNothingReadable =>
      'Mit diesen Einstellungen lässt sich nichts aus dieser Datei lesen. Prüfe das Datumsformat und welche Spalte den Betrag enthält.';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen',
      one: '1 Buchung',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount rein';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount raus';
  }

  @override
  String importAndMore(int count) {
    return 'und $count weitere';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen werden übersprungen',
      one: '1 Zeile wird übersprungen',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen werden übersprungen.',
      one: '1 Zeile wird übersprungen.',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'Zeile $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'Füge zuerst ein Konto hinzu';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen importieren',
      one: '1 Buchung importieren',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Buchungen importieren?',
      one: '1 Buchung importieren?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'Sie werden deinen Einträgen hinzugefügt und bei der nächsten Synchronisierung hochgeladen.';

  @override
  String get importConfirmDuplicates =>
      'Was schon mit gleichem Tag, Betrag und gleicher Beschreibung vorhanden ist, bleibt unberührt.';

  @override
  String importFailed(String error) {
    return 'Der Import ist fehlgeschlagen: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count importiert';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count waren schon vorhanden und blieben unberührt.';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen konnten nicht gelesen werden.',
      one: '1 Zeile konnte nicht gelesen werden.',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'Neue Kategorien: $names.';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'Zu diesen Kontonamen gab es hier nichts Passendes, daher gingen ihre Zeilen auf das gewählte Konto: $names.';
  }

  @override
  String get importRememberBody =>
      'Die nächste Datei mit denselben Spalten wird ohne Nachfrage so zugeordnet.';

  @override
  String get importNoHeaderCannotSave =>
      'Eine Datei ohne Spaltentitel kann nicht wiedererkannt werden, es gibt also nichts zum Abgleichen.';

  @override
  String get importTemplateSaved =>
      'Gespeichert. Dateien mit diesen Spalten nutzen das ab jetzt.';

  @override
  String get txnTransferSameWallet =>
      'Quell- und Zielkonto müssen verschieden sein';

  @override
  String get txnTransferAmountPositive =>
      'Der Umbuchungsbetrag muss größer als null sein';

  @override
  String get txnTransferFeeNegative =>
      'Die Umbuchungsgebühr darf nicht negativ sein';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'Quellkonto nicht gefunden: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'Zielkonto nicht gefunden: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'Umbuchung: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'Für eine Umbuchung müssen beide Konten existieren (Quelle: $source, Ziel: $destination).';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'Eine Umbuchung in einer Währung bewegt einen Betrag: $source und $destination sind beide in $currency, daher kann der erhaltene Betrag nicht abweichen.';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'Zwischen $from und $to ist kein Kurs bekannt. Gib also ein, was tatsächlich auf $destination angekommen ist.';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'Der erhaltene Betrag muss größer als null sein. Gib ein, was tatsächlich auf $destination angekommen ist.';
  }

  @override
  String txnFeeTitle(String title) {
    return 'Gebühr: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'Buchung nicht gefunden: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'Die Buchung ist keine Umbuchung (keine Gegenbuchung)';

  @override
  String txnPairedNotFound(String id) {
    return 'Gegenbuchung $id nicht gefunden; eine halbe Umbuchung wird nicht bearbeitet.';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'Kein solches Konto: $id';
  }

  @override
  String get walletCorrectionTitle => 'Saldokorrektur';

  @override
  String walletCorrectionNote(String name) {
    return '$name an den tatsächlichen Saldo angepasst.';
  }

  @override
  String get walletMergeIntoItself =>
      'Ein Konto kann nicht mit sich selbst zusammengeführt werden.';

  @override
  String get walletMergeBothMustExist =>
      'Zum Zusammenführen müssen beide Konten existieren.';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'Zwischen $from und $to ist kein Kurs bekannt, daher können diese Konten noch nicht zusammengeführt werden.';
  }

  @override
  String get walletMergeAdjustmentTitle => 'Zusammenführungsausgleich';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'Der Kurs einer Umbuchung zwischen diesen Konten weicht vom Kurs ab, zu dem $name zusammengeführt wurde. Dies erfasst die Differenz, damit die Summe gleich bleibt.';
  }

  @override
  String get splitErrNoTotal => 'Gib den Rechnungsbetrag ein.';

  @override
  String get splitErrNoPeople => 'Füge jemanden hinzu, mit dem du teilst.';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name ist nicht an der Rechnung beteiligt.';
  }

  @override
  String get splitErrNothingToRecord =>
      'Jemand anderes hat bezahlt und du hattest nichts davon, also gibt es nichts zu erfassen.';

  @override
  String get splitErrGiveOwnShare => 'Gib deinen eigenen Anteil an.';

  @override
  String splitErrGiveShare(String name) {
    return 'Gib den Anteil von $name an.';
  }

  @override
  String get splitErrNegativeShare => 'Ein Anteil darf nicht negativ sein.';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'Die Anteile ergeben $sum, nicht $total.';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'Die Prozente ergeben $sum %, nicht 100 %.';
  }

  @override
  String get splitErrNameTooLong => 'Namen dürfen höchstens 100 Zeichen haben.';

  @override
  String splitErrDuplicateName(String name) {
    return '$name steht zweimal auf der Rechnung.';
  }

  @override
  String get splitErrTitleTooLong =>
      'Der Titel darf höchstens 200 Zeichen haben.';

  @override
  String get splitErrChooseAccount => 'Wähle das Konto, von dem bezahlt wurde.';

  @override
  String get splitErrOrdinaryAccount => 'Wähle ein normales Konto.';

  @override
  String get splitErrYourShareNothing =>
      'Dein Anteil ist null, also schuldest du nichts.';

  @override
  String get splitErrEveryShareNothing => 'Alle Anteile sind null.';

  @override
  String get recurringDaily => 'Täglich';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Tage',
      one: 'Jeden Tag',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Wochen',
      one: 'Jede Woche',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Monate',
      one: 'Jeden Monat',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Jahre',
      one: 'Jedes Jahr',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'Alle $count $unit';
  }

  @override
  String get recurringUntitled => 'Wiederkehrende Buchung';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count Tagen',
      one: 'In 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'Nächste Woche';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count Wochen',
      one: 'In 1 Woche',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'Karte';

  @override
  String get txnPmKindDigitalWallet => 'Digitale Geldbörse';

  @override
  String get txnPmEmptyHint =>
      'Füge die Karten und Konten hinzu, mit denen du bezahlst, dann kannst du bei einer Buchung eine auswählen.';

  @override
  String get txnPmDeleteBody =>
      'Bereits damit erfasste Buchungen bleiben erhalten. Sie nennen nur keine Zahlungsmethode mehr.';

  @override
  String get txnPmNew => 'Neue Zahlungsmethode';

  @override
  String get txnPmEdit => 'Zahlungsmethode bearbeiten';

  @override
  String get txnRecentlyDeletedFooter =>
      'Gelöschte Buchungen werden dreißig Tage aufbewahrt und dann endgültig entfernt.';

  @override
  String get txnUnknownCategory => 'Unbekannt';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'Genau das';

  @override
  String get txnRuleContaining => 'Alles, was das enthält';

  @override
  String get txnRulesFooter =>
      'Eine Regel greift überall im Titel, außer du machst sie exakt. Die App legt jedes Mal eine an, wenn du etwas von Hand einordnest.';

  @override
  String get txnRulesEmptyHint =>
      'Zeig der App einmal, wohin etwas gehört, und sie ordnet es ab dann so ein.';

  @override
  String get txnRuleNew => 'Neue Regel';

  @override
  String get txnRuleEdit => 'Regel bearbeiten';

  @override
  String get txnRuleExactHint => 'Nur Titel, die genau so lauten';

  @override
  String get txnRuleContainingHint => 'Jeder Titel, der es enthält';

  @override
  String get txnKindTransfer => 'Umbuchung zwischen Konten';

  @override
  String get txnKindRecurring => 'Aus einem wiederkehrenden Eintrag';

  @override
  String get txnMoneyIn => 'Geld rein';

  @override
  String get txnMoneyOut => 'Geld raus';

  @override
  String get txnNotYetPaid => 'Noch nicht bezahlt';

  @override
  String get txnLentOut => 'Verliehen';

  @override
  String get txnSettledInFull => 'Vollständig beglichen.';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid zurück, $owed noch offen.';
  }

  @override
  String get txnUncategorised => 'Ohne Kategorie';

  @override
  String get txnUnknownAccount => 'Unbekannt';

  @override
  String get txnTransferCannotCopy =>
      'Eine Umbuchung kann nicht einzeln kopiert werden.';

  @override
  String get txnCopied => 'Kopiert.';

  @override
  String get txnDeleteOneBody =>
      'Der Kontostand wird neu berechnet. Ist dies eine Seite einer Umbuchung, geht die andere mit.';

  @override
  String txnUpcomingTab(int count) {
    return 'Anstehend ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'Überfällig ($count)';
  }

  @override
  String get txnNoOverdue => 'Keine überfälligen Buchungen';

  @override
  String get txnNoUpcoming => 'Keine anstehenden Buchungen';

  @override
  String get txnNoOverdueBody =>
      'Alle deine Zahlungen sind auf dem aktuellen Stand!';

  @override
  String get txnNoUpcomingBody => 'Du hast keine offenen Zahlungen geplant';

  @override
  String get txnTotalOverdue => 'Überfällig gesamt';

  @override
  String get txnTotalUpcoming => 'Anstehend gesamt';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage überfällig',
      one: '1 Tag überfällig',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '„$title“ als bezahlt markiert';
  }

  @override
  String txnSkippedTitle(String title) {
    return '„$title“ übersprungen';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'Heute, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'Gestern, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'Morgen, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'Fehler beim Löschen der Buchung: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return '$title filtern';
  }

  @override
  String get txnMonthlyIncome => 'Monatliche Einnahmen';

  @override
  String get txnMonthlyExpenses => 'Monatliche Ausgaben';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Buchungen',
      one: 'Buchung',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'Ø pro Buchung';

  @override
  String get txnNoPlannedIncome => 'Keine geplanten Einnahmen';

  @override
  String get txnNoPlannedExpenses => 'Keine geplanten Ausgaben';

  @override
  String txnAddFutureIncome(String month) {
    return 'Füge künftige Einnahmen für $month hinzu';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'Füge künftige Ausgaben für $month hinzu';
  }

  @override
  String get txnNoIncomeYet => 'Diesen Monat noch keine Einnahmen';

  @override
  String get txnNoExpensesYet => 'Diesen Monat noch keine Ausgaben';

  @override
  String get txnStartTrackingIncome => 'Erfasse diesen Monat deine Einnahmen';

  @override
  String get txnStartTrackingExpenses => 'Erfasse diesen Monat deine Ausgaben';

  @override
  String txnNoIncomeIn(String month) {
    return 'Keine Einnahmen im $month';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'Keine Ausgaben im $month';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'Keine Einträge für $month';
  }

  @override
  String get txnOtherCategory => 'Sonstiges';

  @override
  String get txnSearchIncome => 'Einnahmen suchen';

  @override
  String get txnSearchExpenses => 'Ausgaben suchen';

  @override
  String txnErrorWith(String error) {
    return 'Fehler: $error';
  }

  @override
  String get txnTapToEditAmount => 'Tippen, um den Betrag zu ändern';

  @override
  String get txnTapToEnterAmount => 'Tippen, um einen Betrag einzugeben';

  @override
  String get txnSpecialDefault => 'Standard';

  @override
  String get txnSpecialRepetitive => 'Wiederkehrend';

  @override
  String get txnRepeatSettings => 'Wiederholung';

  @override
  String get txnSubscriptionSettings => 'Abo-Einstellungen';

  @override
  String txnEndsOn(String date) {
    return 'Endet: $date';
  }

  @override
  String get txnNoEndDate => 'Kein Enddatum';

  @override
  String get txnEditTransaction => 'Buchung bearbeiten';

  @override
  String get txnNewTransaction => 'Neue Buchung';

  @override
  String get txnFromAccount => 'Vom Konto';

  @override
  String get txnToAccount => 'Auf das Konto';

  @override
  String get txnAmountReceived => 'Erhaltener Betrag';

  @override
  String txnAmountReceivedHint(String account) {
    return 'Diese Konten rechnen in verschiedenen Währungen. Gib ein, was tatsächlich auf $account angekommen ist, oder lass es leer, um den Kurs der App zu nutzen.';
  }

  @override
  String txnInCurrency(String currency) {
    return 'In $currency';
  }

  @override
  String get txnTransferTitleHint => 'z. B. Aufs Sparkonto (optional)';

  @override
  String get txnTitleHint => 'Wofür war das?';

  @override
  String get txnUpdate => 'Aktualisieren';

  @override
  String get txnSelectCategory => 'Kategorie wählen';

  @override
  String get txnSearchTransactions => 'Buchungen suchen';

  @override
  String get txnSpecialRegular => 'Normal';

  @override
  String get txnSpecialLend => 'Verleihen';

  @override
  String get txnSpecialBorrow => 'Leihen';

  @override
  String get txnSpecialRegularDesc => 'Normale Buchung';

  @override
  String get txnSpecialUpcomingDesc => 'Künftige Zahlung zum Verfolgen';

  @override
  String get txnSpecialSubscriptionDesc =>
      'Wiederkehrende Zahlung für einen Dienst';

  @override
  String get txnSpecialRepetitiveDesc => 'Wiederkehrende Buchung';

  @override
  String get txnSpecialLendDesc =>
      'Geld, das du verliehen hast (man schuldet es dir)';

  @override
  String get txnSpecialBorrowDesc =>
      'Geld, das du geliehen hast (du schuldest es)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'Die Untergrenze liegt über der Obergrenze, daher passt nichts. $min bis $max.';
  }

  @override
  String get walletMyWallet => 'Mein Konto';

  @override
  String walletCreateFailed(String error) {
    return 'Konto konnte nicht erstellt werden: $error';
  }

  @override
  String get walletTypeBankAccount => 'Bankkonto';

  @override
  String get walletTypeCreditCard => 'Kreditkarte';

  @override
  String get walletTypeSubscription => 'Abo';

  @override
  String get walletTypeDeposit => 'Festgeld';

  @override
  String get walletTypeInvestment => 'Anlage';

  @override
  String get walletTypeAsset => 'Vermögenswert';

  @override
  String get walletEnterAccountName => 'Bitte gib einen Kontonamen ein';

  @override
  String get walletCreditLimitRequired => 'Kreditlimit ist erforderlich';

  @override
  String get walletEnterValidCreditLimit =>
      'Bitte gib ein gültiges Kreditlimit ein';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'Bitte gib ein gültiges Kreditlimit über 0 ein';

  @override
  String get walletEditWallet => 'Konto bearbeiten';

  @override
  String get walletAddNewWallet => 'Neues Konto hinzufügen';

  @override
  String get walletEnterWalletNameError => 'Bitte gib einen Kontonamen ein';

  @override
  String get walletEnterValidNumber => 'Bitte gib eine gültige Zahl ein';

  @override
  String get walletShowCents => 'Cent anzeigen (z. B. \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'Nur ganze Zahlen (z. B. \$1,235)';

  @override
  String get walletCreateWallet => 'Konto erstellen';

  @override
  String get walletClosedPill =>
      'Geschlossen. Der Verlauf bleibt, aber es wird weder angeboten noch gezählt.';

  @override
  String get walletExcludedPill =>
      'Nicht in der Gesamtsumme aller Konten enthalten.';

  @override
  String get walletReopen => 'Wieder öffnen';

  @override
  String get walletCloseAccount => 'Konto schließen';

  @override
  String get walletReopenSubtitle => 'Wieder anbieten und mitzählen';

  @override
  String get walletCloseAccountSubtitle =>
      'Verlauf behalten, nicht mehr zählen';

  @override
  String get walletIncludeInTotal => 'In die Summe aufnehmen';

  @override
  String get walletLeaveOutOfTotal => 'Aus der Summe ausnehmen';

  @override
  String get walletAlreadyTheBalance => 'Das ist bereits der Saldo.';

  @override
  String get walletCorrectionRecorded =>
      'Die Differenz wurde als Korrektur erfasst.';

  @override
  String walletMergeConfirmBody(String name) {
    return 'Alles, was auf $name gebucht ist, wird übertragen, und $name wird geschlossen. Nichts wird gelöscht.';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'Beträge werden beim Übertragen von $from in $to umgerechnet. Nichts wird gelöscht, und $name wird geschlossen statt entfernt.';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount Guthaben · $available verfügbar';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount offen · $available noch verfügbar';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return 'Gib ein, was $name wirklich enthält. Die Differenz wird als Buchung erfasst, damit das Konto zu seinem Verlauf passt.';
  }

  @override
  String get apiUpdateRequired =>
      'Aktualisiere The Accountant, um weiter zu synchronisieren. Bis dahin bleibt alles auf diesem Handy.';

  @override
  String get apiAccountExistsLink =>
      'Mit dieser E-Mail gibt es bereits ein Konto. Bitte verknüpfe deine Konten.';

  @override
  String get apiServerTrouble =>
      'Unser Server hat gerade Probleme. Auf diesem Handy ist alles sicher; versuch es in ein paar Minuten erneut.';

  @override
  String apiRequestFailedHttp(String status) {
    return 'Anfrage fehlgeschlagen (HTTP $status).';
  }

  @override
  String get apiServerTimeout =>
      'Unser Server hat zu lange gebraucht. Prüfe deine Verbindung oder versuch es in ein paar Minuten erneut.';

  @override
  String get apiCannotReachServer =>
      'Unser Server ist nicht erreichbar. Prüfe deine Verbindung; wenn du online bist, versuch es in ein paar Minuten erneut.';

  @override
  String get apiSomethingWentWrong =>
      'Bei der Verbindung mit unserem Server ist etwas schiefgelaufen. Bitte versuch es erneut.';

  @override
  String get syncAlreadyInProgress => 'Synchronisierung läuft bereits';

  @override
  String get syncRequiresPremium => 'Cloud-Sync erfordert ein Premium-Abo';

  @override
  String get syncNoInternet => 'Keine Internetverbindung';

  @override
  String get syncNotAuthenticated => 'Nicht angemeldet';

  @override
  String get syncCouldNotFetchCloud =>
      'Deine Cloud-Daten konnten nicht geladen werden. Die lokalen Daten sind unverändert.';

  @override
  String get syncAccountUnknown =>
      'Das angemeldete Konto konnte nicht ermittelt werden; Synchronisierung abgebrochen.';

  @override
  String get syncStoreOtherAccount =>
      'Die Daten auf diesem Gerät gehören zu einem anderen Konto. Melde dich mit diesem Konto an oder lösche die lokalen Daten, bevor du synchronisierst.';

  @override
  String syncRecordsNotSaved(String record) {
    return 'Einige Cloud-Einträge konnten auf diesem Gerät nicht gespeichert werden: $record. Beim nächsten Sync wird es erneut versucht.';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'Einige Cloud-Einträge konnten auf diesem Gerät nicht gespeichert werden: $record (und $count weitere). Beim nächsten Sync wird es erneut versucht.';
  }

  @override
  String notifCardStatementReady(String name) {
    return 'Abrechnung für $name ist fertig';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'Es waren $amount, bereits bezahlt. Nichts mehr fällig.';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount ist bis $date fällig.';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$paid von $owed sind bereits bezahlt.';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return 'Abrechnung für $name ist morgen fällig';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return 'Abrechnung für $name ist in $days Tagen fällig';
  }

  @override
  String notifPayBy(String amount, String date) {
    return 'Zahle $amount bis $date.';
  }

  @override
  String notifCardDueToday(String name) {
    return 'Abrechnung für $name ist heute fällig';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount sind noch offen.$paidSoFar Wenn du heute zahlst, vermeidest du eine Verzugsgebühr.';
  }

  @override
  String get notifWhenToday => 'heute';

  @override
  String get notifWhenTomorrow => 'morgen';

  @override
  String notifWhenInDays(int days) {
    return 'in $days Tagen';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name wird $when ausgezahlt';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount gehen am $date auf $account ein.';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name wird $when fällig';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount fließen am $date zurück auf $account.';
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
      'dps': 'Einzahlung',
      'insurance': 'Prämie',
      'sip': 'SIP-Rate',
      'other': 'Rate',
    });
    return '$name: $_temp0 $number von $total $when fällig';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return 'Investiere $amount bis $date.';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount werden am $date von $account investiert.';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount werden am $date von $account erfasst.';
  }

  @override
  String get notifYourAccount => 'dein Konto';

  @override
  String get notifPlansUpdatedTitle => 'Raten und Sparpläne aktualisiert';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Planeinträge an ihrem Tag erfasst.',
      one: '1 Planeintrag an seinem Tag erfasst.',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'Wiederkehrende Buchungen erfasst';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiederkehrende Buchungen erfasst.',
      one: '1 wiederkehrende Buchung erfasst.',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zahlungen zu bestätigen',
      one: '1 Zahlung zu bestätigen',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'Bestätige unter „Anstehend“, was abgebucht wurde, oder überspringe es.';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names – bestätige unter „Anstehend“, was abgebucht wurde, oder überspringe es.';
  }

  @override
  String get notifUpcomingFallbackTitle => 'Anstehende Buchung';

  @override
  String notifUpcomingTitle(String title) {
    return 'Anstehend: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return 'Einnahme von $amount ist bald fällig.';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return 'Ausgabe von $amount ist bald fällig.';
  }

  @override
  String get notifCreditFallback => 'Forderung';

  @override
  String get notifDebtFallback => 'Schuld';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'Überfällige Forderung: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'Überfällige Schuld: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount sind noch offen. Tippe zum Ansehen.';
  }

  @override
  String get notifRecurringFallbackTitle => 'Wiederkehrende Buchung';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'Anstehend (wiederkehrend): $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount fällig am $date.';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'Forderung fällig: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'Schuld fällig: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'Abo fällig: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'Rechnung fällig: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'Bald fällig: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'Wiederkehrende Rechnung';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount sind bald fällig. Tippe zum Ansehen.';
  }

  @override
  String get notifChannelRecurring => 'Wiederkehrende Buchungen';

  @override
  String get notifChannelRecurringDesc =>
      'Benachrichtigungen zu automatisch erstellten wiederkehrenden Buchungen';

  @override
  String get notifChannelUpcoming => 'Anstehende Erinnerungen';

  @override
  String get notifChannelUpcomingDesc => 'Erinnerungen an anstehende Buchungen';

  @override
  String get notifChannelLoan => 'Kredit-Erinnerungen';

  @override
  String get notifChannelLoanDesc =>
      'Erinnerungen an überfällige Forderungen und Schulden';

  @override
  String get notifChannelDueDate => 'Fälligkeits-Erinnerungen';

  @override
  String get notifChannelDueDateDesc =>
      'Einmalige Erinnerungen an bestimmte Fälligkeitstermine';

  @override
  String get notifChannelBillsDesc =>
      'Fällige Kreditkartenabrechnungen und Planraten';

  @override
  String get notifOffset1Hour => '1 Stunde vorher';

  @override
  String get notifOffset1Day => '1 Tag vorher';

  @override
  String get notifOffset3Days => '3 Tage vorher';

  @override
  String get notifOffset1Week => '1 Woche vorher';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes Minuten vorher';
  }

  @override
  String get notifChannelGeneral => 'Allgemein';

  @override
  String get notifChannelGeneralDesc => 'Konto- und App-Benachrichtigungen';

  @override
  String get notifChannelReminders => 'Tägliche Erinnerungen';

  @override
  String get notifChannelRemindersDesc =>
      'Ein Anstoß, die Ausgaben des Tages einzutragen';

  @override
  String get notifChannelBillsStatementsDesc =>
      'Kreditkartenabrechnungen und Fälligkeiten';

  @override
  String get notifChannelBudgets => 'Budgetwarnungen';

  @override
  String get notifChannelBudgetsDesc =>
      'Wenn ein Budget fast oder ganz aufgebraucht ist';

  @override
  String notifOverBudgetTitle(String name) {
    return 'Budget überschritten: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'Budgetwarnung: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'Du hast $percent% deines Budgets $name für diesen Zeitraum ausgegeben.';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'Du hast $percent% deines Budgets $name verbraucht.';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium endet bald';

  @override
  String get notifPremiumEndsTomorrow =>
      'Dein Premium endet morgen. Verlängere, um deine Premium-Funktionen zu behalten.';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'Dein Premium endet in $days Tagen. Verlängere, um deine Premium-Funktionen zu behalten.';
  }

  @override
  String get notifLargeIncomeTitle => 'Hohe Einnahme';

  @override
  String get notifLargeExpenseTitle => 'Hohe Ausgabe';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return 'Einnahme von $amount erfasst: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return 'Einnahme von $amount erfasst';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return 'Ausgabe von $amount erfasst: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return 'Ausgabe von $amount erfasst';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'Tägliche Erinnerungen an deine Ausgaben';

  @override
  String get notifDailyReminderTitle => 'Tägliche Ausgaben-Erinnerung';

  @override
  String get notifDailyReminderBody =>
      'Vergiss nicht, deine heutigen Ausgaben einzutragen! Behalte deine Ausgaben im Blick.';

  @override
  String get notifTestTitle => 'Testbenachrichtigung';

  @override
  String get notifTestBody =>
      'Wenn du das siehst, funktionieren Benachrichtigungen!';

  @override
  String get notifActionSnooze1Day => '1 T. später';

  @override
  String get notifActionSnooze1Week => '1 W. später';

  @override
  String get notifGroupThisWeek => 'Diese Woche';

  @override
  String get notifGroupThisMonth => 'Diesen Monat';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date um $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return 'vor $count Min.';
  }

  @override
  String notifHoursAgo(int count) {
    return 'vor $count Std.';
  }

  @override
  String notifDaysAgo(int count) {
    return 'vor $count T.';
  }

  @override
  String get notifPrimerSheetBody =>
      'Schalte Benachrichtigungen ein, und wir sagen dir Bescheid, wenn es darauf ankommt.';

  @override
  String get notifPrimerBudgetsBody =>
      'Wisse Bescheid, bevor du ein Budget überziehst.';

  @override
  String get notifPrimerBillsTitle => 'Erinnerungen an Rechnungen & Abos';

  @override
  String get notifPrimerBillsBody =>
      'Verpasse nie eine wiederkehrende Zahlung.';

  @override
  String get notifPrimerLargeTitle => 'Hohe Buchungen';

  @override
  String get notifPrimerLargeBody =>
      'Lass dich über ungewöhnliche Aktivitäten informieren.';

  @override
  String get notifLoadFailed =>
      'Benachrichtigungen konnten nicht geladen werden';

  @override
  String get startupReasonSomethingWrong =>
      'Beim Starten ist etwas schiefgelaufen. Deine Daten sind auf diesem Gerät sicher.';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'Die lokalen Daten für dieses Konto konnten nicht geöffnet werden.';

  @override
  String get startupReasonSetupFailed =>
      'Wir konnten dieses Konto auf diesem Gerät nicht fertig einrichten. Es wurde nichts gelöscht.';

  @override
  String get startupReasonOffline =>
      'Wir konnten dein Konto nicht erreichen, und dieses Gerät hat seine Daten noch nicht. Wenn du The Accountant schon genutzt hast, verbinde dich mit dem Internet, und wir holen deine Daten zurück. Neu hier? Du kannst jetzt auf diesem Gerät anfangen.';

  @override
  String get startupReasonNeedsSubscription =>
      'Dieses Konto hat Daten in der Cloud. Zum Wiederherstellen braucht es ein aktives Abo. Es wurde nichts gelöscht.';

  @override
  String get startupReasonConfirmingSubscription =>
      'Dieses Konto hat Daten in der Cloud. Wir prüfen noch dein Abo, damit sie wiederhergestellt werden können.';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'Dieses Konto hat Daten in der Cloud, aber sie konnten noch nicht wiederhergestellt werden.';

  @override
  String get commonBiometricReason =>
      'Bestätige deine Identität, um The Accountant zu entsperren';

  @override
  String get commonLoadCurrenciesFailed =>
      'Währungen konnten nicht geladen werden';

  @override
  String get commonLoadRatesFailed =>
      'Wechselkurse konnten nicht geladen werden';

  @override
  String get commonRefreshRatesFailed =>
      'Wechselkurse konnten nicht aktualisiert werden';

  @override
  String get commonAllCategories => 'Alle Kategorien';

  @override
  String commonCategoryCount(int count) {
    return '$count Kategorien';
  }

  @override
  String get commonTierFree => 'Kostenlos';

  @override
  String get commonTierMonthly => 'Premium monatlich';

  @override
  String get commonTierYearly => 'Premium jährlich';

  @override
  String get commonTierLifetime => 'Premium lebenslang';

  @override
  String get commonCategoryMergeSelf =>
      'Eine Kategorie kann nicht mit sich selbst zusammengeführt werden.';

  @override
  String get commonCategoryMergeMissing =>
      'Zum Zusammenführen müssen beide Kategorien existieren.';

  @override
  String get commonCategoryMergeSystem =>
      'Die eigenen Kategorien der App können nicht zusammengeführt werden.';

  @override
  String get commonCategoryMergeKinds =>
      'Einnahme- und Ausgabekategorien können nicht zusammengeführt werden.';

  @override
  String get commonCategoryOneLevel =>
      'Diese Kategorie liegt in einer anderen, und Kategorien haben nur eine Ebene.';

  @override
  String get commonCategoryMoveSame => 'Wähle eine andere Kategorie als Ziel.';

  @override
  String get commonCategoryMoveMissing =>
      'Zum Verschieben müssen beide Kategorien existieren.';

  @override
  String get commonCategoryMoveSystem =>
      'Zwischen den eigenen Kategorien der App kann nichts verschoben werden.';

  @override
  String get commonCategoryMoveKinds =>
      'Einnahmen und Ausgaben können ihre Kategorien nicht tauschen.';

  @override
  String get commonCategoryGone => 'Diese Kategorie gibt es nicht mehr.';

  @override
  String get commonCategoryParentSystem =>
      'Die eigenen Kategorien der App können nicht verschoben werden.';

  @override
  String get commonCategoryParentSelf =>
      'Eine Kategorie kann nicht in sich selbst liegen.';

  @override
  String get commonCategoryParentIntoSystem =>
      'In den eigenen Kategorien der App kann nichts abgelegt werden.';

  @override
  String get commonCategoryParentKinds =>
      'Eine Einnahme- und eine Ausgabekategorie können nicht ineinander liegen.';

  @override
  String get commonCategoryHasChildren =>
      'Diese Kategorie hat eigene Unterkategorien und bleibt daher auf der obersten Ebene.';

  @override
  String get commonTapToChange => 'Zum Ändern tippen';

  @override
  String get commonSelectColor => 'Farbe wählen';

  @override
  String get commonShowPalette => 'Palette anzeigen';

  @override
  String get commonCustomColor => 'Eigene Farbe';

  @override
  String get commonSelectCurrency => 'Währung wählen';

  @override
  String get commonEnableCryptoHint =>
      'Aktiviere „Kryptowährungen einbeziehen“, um nach Krypto-Token zu suchen.';

  @override
  String get commonSearchHint => 'Suchen...';

  @override
  String get aiLoadConversationsFailed =>
      'Unterhaltungen konnten nicht geladen werden.';

  @override
  String get aiLoadHistoryFailed => 'Chatverlauf konnte nicht geladen werden.';

  @override
  String get aiPremiumRequired =>
      'Für den KI-Assistenten ist ein Premium-Abo nötig';

  @override
  String get aiUnexpectedError =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuch es erneut.';

  @override
  String get aiResponseFailed =>
      'Keine Antwort von der KI erhalten. Bitte versuch es erneut.';

  @override
  String get aiServiceNotAnswering => 'Der KI-Dienst antwortet nicht.';

  @override
  String get aiReplyCutOff =>
      'Die Antwort wurde abgeschnitten. Bitte versuch es erneut.';

  @override
  String get aiCouldNotReachServer =>
      'Der Server ist nicht erreichbar. Prüfe deine Verbindung und versuch es erneut.';

  @override
  String get aiSomethingWentWrong => 'Etwas ist schiefgelaufen.';

  @override
  String get aiOpenConversationFailed =>
      'Unterhaltung konnte nicht geöffnet werden.';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Deine $count Änderungen wurden gespeichert, aber der Coach konnte seine Antwort nicht beenden. Prüfe sie in deinen Einträgen, bevor du erneut fragst.',
      one:
          'Deine Änderung wurde gespeichert, aber der Coach konnte seine Antwort nicht beenden. Prüfe sie in deinen Einträgen, bevor du erneut fragst.',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'Der KI-Dienst antwortet gerade nicht. Bitte versuch es erneut.';

  @override
  String aiMinutesShort(int count) {
    return '$count Min.';
  }

  @override
  String aiHoursShort(int count) {
    return '$count Std.';
  }

  @override
  String aiDaysShort(int count) {
    return '$count T.';
  }

  @override
  String get aiOcrTextFailed => 'Text konnte nicht aus dem Bild gelesen werden';

  @override
  String get aiOcrReceiptFailed =>
      'Belegdaten konnten nicht aus dem Bild gelesen werden';

  @override
  String get coachYes => 'ja';

  @override
  String get coachNo => 'nein';

  @override
  String get coachTradeBuy => 'Kauf';

  @override
  String get coachTradeSell => 'Verkauf';

  @override
  String get coachTradeDividend => 'Dividende';

  @override
  String get planAccountGone => 'Dieses Konto gibt es nicht mehr.';

  @override
  String get planPaidFromOrdinary =>
      'Ein Plan wird von einem normalen Konto bezahlt, nicht von einer Einlage.';

  @override
  String get planSipChooseHolding =>
      'Wähle den Fonds oder die Aktie, die der Sparplan kauft.';

  @override
  String get planSipPayFromOther =>
      'Bezahle den Sparplan von einem anderen Konto.';

  @override
  String get planNeedNameError => 'Gib dem Plan einen Namen.';

  @override
  String get planInstallmentCountRange =>
      'Die Anzahl der Raten muss zwischen 1 und 1200 liegen.';

  @override
  String get planIntervalMin => 'Der Abstand muss mindestens 1 sein.';

  @override
  String get planRateRange =>
      'Der Zinssatz muss zwischen 0 und 100 Prozent liegen.';

  @override
  String get planTaxRange =>
      'Die Steuer muss zwischen 0 und 100 Prozent liegen.';

  @override
  String get planProviderTooLong =>
      'Firma und Nummer dürfen höchstens 100 Zeichen lang sein.';

  @override
  String get planNeedPremium => 'Gib den Beitrag ein.';

  @override
  String get planNeedInstallmentAmount => 'Gib den Betrag jeder Rate ein.';

  @override
  String get planNeedDeposited => 'Gib den eingezahlten Betrag ein.';

  @override
  String get planTermMonthsOrYears =>
      'Die Laufzeit wird in Monaten oder Jahren angegeben.';

  @override
  String get planAmountNotNegative => 'Der Betrag darf nicht negativ sein.';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name wird am $date fällig. Um das Geld vorher zu entnehmen, beende den Plan vorzeitig.';
  }

  @override
  String get planNoLongerExists => 'Diesen Plan gibt es nicht mehr.';

  @override
  String get planReminderDaysRange =>
      'Erinnerungen sind 0 (aus) bis 30 Tage vorher möglich.';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name enthält noch Geld. Beende den Plan zuerst, dann geht das Geld zurück auf $account.';
  }

  @override
  String get planItsAccount => 'sein Konto';

  @override
  String planAlreadyEnded(String name) {
    return '$name ist bereits beendet.';
  }

  @override
  String get investNeedName => 'Gib der Geldanlage einen Namen.';

  @override
  String get investNameTooLong =>
      'Der Name darf höchstens 100 Zeichen lang sein.';

  @override
  String get investSymbolTooLong =>
      'Das Kürzel darf höchstens 20 Zeichen lang sein.';

  @override
  String get investPriceNotNegative => 'Ein Preis darf nicht negativ sein.';

  @override
  String investAlreadyTracked(String name) {
    return '$name wird bereits erfasst.';
  }

  @override
  String get investNeedPaid => 'Gib ein, was bezahlt wurde.';

  @override
  String get investUnitsBoughtPositive =>
      'Die gekauften Anteile müssen mehr als null sein.';

  @override
  String get investPayFromOther => 'Bezahle es von einem anderen Konto.';

  @override
  String get investNeedSaleAmount =>
      'Gib ein, was der Verkauf eingebracht hat.';

  @override
  String get investUnitsSoldPositive =>
      'Die verkauften Anteile müssen mehr als null sein.';

  @override
  String get investSellIntoOther => 'Verkaufe auf ein anderes Konto.';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'Von $name werden nur $units Anteile gehalten.';
  }

  @override
  String get investNeedDividend => 'Gib die erhaltene Dividende ein.';

  @override
  String get investReceiveIntoOrdinary =>
      'Lass es auf ein normales Konto gehen.';

  @override
  String get investPricePositive => 'Ein Preis muss mehr als null sein.';

  @override
  String get investUnitsPositive => 'Anteile müssen mehr als null sein.';

  @override
  String get investNotATrade =>
      'Das ist kein Kauf oder Verkauf einer Geldanlage.';

  @override
  String investStillHoldsUnits(String name) {
    return '$name hat noch Anteile. Verkaufe sie zuerst.';
  }

  @override
  String get investNoLongerExists => 'Diese Geldanlage gibt es nicht mehr.';

  @override
  String get networthNeedAssetName => 'Gib dem Vermögenswert einen Namen.';

  @override
  String get networthValueNotNegative => 'Ein Wert darf nicht negativ sein.';

  @override
  String get networthNeedPaidFor => 'Gib ein, was dafür bezahlt wurde.';

  @override
  String get networthPayFromOrdinary => 'Bezahle es von einem normalen Konto.';

  @override
  String get networthNeedWorth => 'Gib ein, was es wert ist.';

  @override
  String get networthNeedSoldFor => 'Gib ein, wofür es verkauft wurde.';

  @override
  String get networthReceiveIntoOrdinary =>
      'Lass das Geld auf ein normales Konto gehen.';

  @override
  String networthStillWorth(String name) {
    return '$name ist noch etwas wert. Verkaufe es zuerst oder setze seinen Wert auf null.';
  }

  @override
  String get networthAssetGone =>
      'Dieser Vermögenswert wird nicht mehr erfasst.';

  @override
  String get zakatNeedAmountPaid => 'Gib den gezahlten Betrag ein.';

  @override
  String get zakatPayFromOrdinary => 'Bezahle sie von einem normalen Konto.';

  @override
  String get zakatReminderTitleToday => 'Deine Zakat ist heute fällig';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakat in $count Tagen fällig',
      one: 'Zakat in 1 Tag fällig',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'Dein Zakat-Jahr endet heute. Tippe, um zu sehen, was fällig ist.';

  @override
  String zakatReminderBodyOn(String date) {
    return 'Dein Zakat-Jahr endet am $date. Tippe, um zu sehen, was fällig ist.';
  }

  @override
  String get budgetCheckFailed => 'Budgets konnten nicht geprüft werden';

  @override
  String get budgetLoadFailed => 'Budgets konnten nicht geladen werden';

  @override
  String get budgetAddFailed => 'Budget konnte nicht hinzugefügt werden';

  @override
  String get budgetNotFound => 'Budget nicht gefunden';

  @override
  String get budgetUpdateFailed => 'Budget konnte nicht aktualisiert werden';

  @override
  String get budgetDeleteFailed => 'Budget konnte nicht gelöscht werden';

  @override
  String get budgetEdit => 'Budget bearbeiten';

  @override
  String get budgetNeedName => 'Gib dem Budget einen Namen';

  @override
  String get budgetEnterAmount => 'Gib einen Betrag ein';

  @override
  String get budgetAmountMoreThanZero => 'Der Betrag muss mehr als null sein';

  @override
  String get budgetTrackingEarnings => 'Einnahmen verfolgen';

  @override
  String get budgetTrackingSpending => 'Ausgaben verfolgen';

  @override
  String get budgetRepeats => 'Wiederholung';

  @override
  String get budgetTooBig => 'Zu groß';

  @override
  String get budgetStarts => 'Beginnt';

  @override
  String get budgetEnds => 'Endet';

  @override
  String get budgetStopsRepeating => 'Wiederholung endet';

  @override
  String get budgetNever => 'Nie';

  @override
  String get budgetCategoriesAll => 'Kategorien: alle';

  @override
  String budgetCategoriesSelected(int count) {
    return 'Kategorien: $count ausgewählt';
  }

  @override
  String get budgetNoIncomeCategories => 'Noch keine Einnahmekategorien.';

  @override
  String get budgetNoExpenseCategories => 'Noch keine Ausgabenkategorien.';

  @override
  String get budgetCategoriesHint =>
      'Leer lassen, um alle Kategorien zu beobachten. Alles, was in einer gewählten Kategorie abgelegt ist, zählt ebenfalls dazu.';

  @override
  String get budgetAccountsAll => 'Konten: alle';

  @override
  String budgetAccountsSelected(int count) {
    return 'Konten: $count ausgewählt';
  }

  @override
  String get budgetRolloverHint =>
      'Nicht Ausgegebenes wird dem nächsten Zeitraum hinzugefügt. Ein Überziehen wird nicht als Schuld übertragen.';

  @override
  String get budgetPeriodDaily => 'Täglich';

  @override
  String get budgetPeriodFortnightly => 'Zweiwöchentlich';

  @override
  String get budgetPeriodOneOff => 'Einmalig';

  @override
  String get budgetUnitDays => 'Tage';

  @override
  String get budgetUnitWeeks => 'Wochen';

  @override
  String get budgetUnitFortnights => 'zwei Wochen';

  @override
  String get budgetUnitMonths => 'Monate';

  @override
  String get budgetUnitYears => 'Jahre';

  @override
  String get budgetOneOffNeedsEnd =>
      'Ein einmaliges Budget braucht ein Enddatum.';

  @override
  String get budgetEndAfterStart =>
      'Das Enddatum muss nach dem Startdatum liegen.';

  @override
  String get budgetSaveFailed => 'Das Budget konnte nicht gespeichert werden.';

  @override
  String get budgetThisPeriod => 'Dieser Zeitraum';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Zeiträumen',
      one: 'Vor 1 Zeitraum',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start bis $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'von $limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'von $limit, davon $carried übertragen';
  }

  @override
  String get budgetUncategorised => 'Ohne Kategorie';

  @override
  String budgetOverTheLimit(String amount) {
    return '$amount über dem Limit.';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left übrig, etwa $daily pro Tag.';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left übrig.';
  }

  @override
  String budgetAveraging(String amount) {
    return 'Im Schnitt $amount pro Zeitraum.';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'Auf dem Weg zu $amount drüber';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'Bei diesem Tempo, mitgezählt $scheduled, die vor Ende des Zeitraums schon geplant sind.';
  }

  @override
  String get budgetForecastPlain =>
      'Bei diesem Tempo, bis zum Ende des Zeitraums.';

  @override
  String get budgetCapsExplain =>
      'Ein Budget sagt, ob der Zeitraum überzogen ist. Ein Limit sagt, wo: Ein Essensbudget, das insgesamt im Plan ist, kann trotzdem größtenteils Lieferessen sein.';

  @override
  String get budgetPercentOfBudget => 'Prozent des Budgets';

  @override
  String get budgetArchivedTitle => 'Archivierte Budgets';

  @override
  String get budgetShowActive => 'Aktive anzeigen';

  @override
  String get budgetShowArchived => 'Archivierte anzeigen';

  @override
  String get budgetUnpin => 'Lösen';

  @override
  String get budgetPinToTop => 'Oben anheften';

  @override
  String get budgetStartCounting => 'Wieder mitzählen';

  @override
  String get budgetStopCounting => 'Verlauf behalten, nicht mehr mitzählen';

  @override
  String get budgetDeleteBody =>
      'Das Budget verschwindet, deine Buchungen bleiben. Nichts, was du erfasst hast, wird entfernt.';

  @override
  String get budgetNothingArchived => 'Nichts archiviert';

  @override
  String get budgetNoneYet => 'Noch keine Budgets';

  @override
  String get budgetArchivedEmptyHint =>
      'Archivierte Budgets werden hier aufbewahrt.';

  @override
  String get budgetEmptyHint =>
      'Leg ein Limit für eine Kategorie fest und sieh, wie der Monat läuft.';

  @override
  String dashLoadFailed(String error) {
    return 'Finanzdaten konnten nicht geladen werden: $error';
  }

  @override
  String get categoryUnknown => 'Unbekannt';

  @override
  String dashCardAvailable(String amount) {
    return 'Verfügbar: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'Im Guthaben · Verfügbar: $amount';
  }

  @override
  String get dashTypeBank => 'Bank';

  @override
  String get dashTypeCredit => 'Kredit';

  @override
  String get dashTypeSubs => 'Abos';

  @override
  String get dashTypeDeposit => 'Einlage';

  @override
  String get dashTypeInvest => 'Anlage';

  @override
  String get dashTypeAsset => 'Vermögen';

  @override
  String get dashAddAccountTile => 'Konto\nhinzufügen';

  @override
  String get categoryLoadFailed => 'Kategorien konnten nicht geladen werden';

  @override
  String get categoryAddFailed => 'Kategorie konnte nicht hinzugefügt werden';

  @override
  String get categoryNotFound => 'Kategorie nicht gefunden';

  @override
  String get categoryUpdateFailed =>
      'Kategorie konnte nicht aktualisiert werden';

  @override
  String get categoryCannotDeleteSystem =>
      'Die eigenen Kategorien der App können nicht gelöscht werden';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'Eine Kategorie mit Buchungen kann nicht gelöscht werden; verschiebe oder lösche sie zuerst';

  @override
  String get categoryDeleteFailed => 'Kategorie konnte nicht gelöscht werden';

  @override
  String categorySaveFailed(String error) {
    return 'Kategorie konnte nicht gespeichert werden: $error';
  }

  @override
  String get categoryEditTitle => 'Kategorie bearbeiten';

  @override
  String get categoryNewTitle => 'Neue Kategorie';

  @override
  String get categoryPartOf => 'Gehört zu';

  @override
  String get categoryNamePlaceholder => 'Kategoriename';

  @override
  String get categoryUpdate => 'Kategorie aktualisieren';

  @override
  String get categoryCreate => 'Kategorie erstellen';

  @override
  String reportLoadFailed(String error) {
    return 'Berichte konnten nicht geladen werden: $error';
  }

  @override
  String get goalEdit => 'Ziel bearbeiten';

  @override
  String get goalNeedName => 'Gib dem Ziel einen Namen';

  @override
  String get goalTargetMoreThanZero => 'Der Zielbetrag muss mehr als null sein';

  @override
  String get goalNoDeadline => 'Keine Frist';

  @override
  String get goalTargetDateAfterStart =>
      'Das Zieldatum muss nach dem Startdatum liegen.';

  @override
  String get goalSaveFailed => 'Das Ziel konnte nicht gespeichert werden.';

  @override
  String get goalArchivedTitle => 'Archivierte Ziele';

  @override
  String get goalHideFromHome => 'Auf Startseite ausblenden';

  @override
  String get goalShowOnHome => 'Auf Startseite zeigen';

  @override
  String get goalReached => 'Erreicht';

  @override
  String goalToGo(String amount) {
    return 'Noch $amount';
  }

  @override
  String get goalNoneYet => 'Noch keine Ziele';

  @override
  String get goalArchivedEmptyHint =>
      'Archivierte Ziele werden hier aufbewahrt.';

  @override
  String get goalEmptyHint =>
      'Benenne, wofür du sparst, und verknüpfe dann die Buchungen, die dazu beitragen.';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$saved von $target';
  }

  @override
  String goalOfTarget(String target) {
    return 'von $target';
  }

  @override
  String get goalReachedNicelyDone => 'Erreicht. Gut gemacht.';

  @override
  String goalStillToGo(String amount) {
    return 'Noch $amount bis zum Ziel.';
  }

  @override
  String goalDailyToArrive(String amount) {
    return '$amount pro Tag, um rechtzeitig anzukommen.';
  }

  @override
  String get goalNothingLinked =>
      'Noch nichts verknüpft. Wähle dieses Ziel bei einer Buchung, dann erscheint sie hier.';

  @override
  String get goalDeleteBody =>
      'Das Ziel verschwindet, deine Buchungen bleiben. Sie zählen nur nicht mehr dazu.';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zahlungen von $amount',
      one: '1 Zahlung von $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'Fertig etwa am $date.';
  }

  @override
  String goalNotFound(String id) {
    return 'Ziel nicht gefunden: $id';
  }

  @override
  String get goalPaidOff => 'Abbezahlt!';

  @override
  String get goalCompleted => 'Geschafft!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent % erreicht';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Wochen',
      one: 'Noch 1 Woche',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Monate',
      one: 'Noch 1 Monat',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return 'Noch $years Jahre';
  }

  @override
  String get subRecurringBill => 'Wiederkehrende Rechnung';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Tage',
      one: 'Jeden Tag',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Wochen',
      one: 'Jede Woche',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Monate',
      one: 'Jeden Monat',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Jahre',
      one: 'Jedes Jahr',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'Alle $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'Abos konnten nicht geladen werden: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'Abo konnte nicht pausiert werden: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'Abo konnte nicht fortgesetzt werden: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'Abo konnte nicht aktualisiert werden: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'Abo konnte nicht gekündigt werden: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'Aktiv ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'Pausiert ($count)';
  }

  @override
  String get subEmptyTitle => 'Keine Abos oder Rechnungen';

  @override
  String get subEmptyBody =>
      'Füge Abo- oder wiederkehrende Rechnungsbuchungen hinzu, um sie hier zu verfolgen';

  @override
  String get subRecurringCost => 'Wiederkehrende Kosten';

  @override
  String subPerYear(String amount) {
    return '$amount / Jahr';
  }

  @override
  String get subActive => 'Aktiv';

  @override
  String subNext(String date) {
    return 'Nächste $date';
  }

  @override
  String get subResume => 'Fortsetzen';

  @override
  String get subPause => 'Pausieren';

  @override
  String get subCancelBillTitle => 'Wiederkehrende Rechnung beenden';

  @override
  String get subCancelSubTitle => 'Abo kündigen';

  @override
  String subCancelConfirm(String name) {
    return 'Möchtest du \"$name\" wirklich beenden? Damit enden alle künftigen wiederkehrenden Zahlungen.';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" beendet';
  }

  @override
  String subSaveError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get subEditBill => 'Wiederkehrende Rechnung bearbeiten';

  @override
  String get subEditSub => 'Abo bearbeiten';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wochen',
      one: 'Woche',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Monate',
      one: 'Monat',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jahre',
      one: 'Jahr',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'Endet: $date';
  }

  @override
  String get subNoEndDate => 'Kein Enddatum';
}
