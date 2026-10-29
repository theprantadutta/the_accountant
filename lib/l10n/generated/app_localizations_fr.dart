// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get dateToday => 'Aujourd\'hui';

  @override
  String get dateYesterday => 'Hier';

  @override
  String get dateTomorrow => 'Demain';

  @override
  String get navTransactions => 'Opérations';

  @override
  String get settingsRegionalTitle => 'Paramètres régionaux';

  @override
  String get settingsSectionCurrency => 'DEVISE';

  @override
  String get settingsSectionDisplayFormat => 'FORMAT D\'AFFICHAGE';

  @override
  String get settingsSectionLanguage => 'LANGUE';

  @override
  String get settingsDefaultCurrency => 'Devise par défaut';

  @override
  String get settingsExchangeRates => 'Taux de change';

  @override
  String get settingsExchangeRatesSubtitle =>
      'Gérer les taux de conversion des devises';

  @override
  String get settingsDateFormat => 'Format de date';

  @override
  String get settingsNumberFormat => 'Format des nombres';

  @override
  String get settingsCurrencySymbol => 'Symbole monétaire';

  @override
  String get settingsTimeFormat => 'Format de l\'heure';

  @override
  String get settingsFirstDayOfWeek => 'Premier jour de la semaine';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsPreview => 'Aperçu';

  @override
  String get previewDate => 'Date';

  @override
  String get previewTime => 'Heure';

  @override
  String get previewAmount => 'Montant';

  @override
  String get previewWeekStarts => 'Cette semaine commence le';

  @override
  String get choiceMatchMyPhone => 'Comme mon téléphone';

  @override
  String get symbolBeforeAmount => 'Avant le montant';

  @override
  String get symbolAfterAmount => 'Après le montant';

  @override
  String get time12Hour => '12 heures (1:30 PM)';

  @override
  String get time24Hour => '24 heures (13:30)';

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get weekdaySaturday => 'Samedi';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String get selectDateFormat => 'Choisir le format de date';

  @override
  String get selectNumberFormat => 'Choisir le format des nombres';

  @override
  String get selectCurrency => 'Choisir la devise';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get languageSystem => 'Comme mon téléphone';

  @override
  String get sectionAccount => 'COMPTE';

  @override
  String get sectionDataManagement => 'GESTION DES DONNÉES';

  @override
  String get sectionHelpSupport => 'AIDE ET ASSISTANCE';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsBackupRestore => 'Sauvegarde et restauration';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Un fichier que vous conservez, ou des copies automatiques sur Google Drive';

  @override
  String get settingsImportStatement => 'Importer un relevé';

  @override
  String get settingsImportStatementSubtitle =>
      'Importez un CSV de votre banque, configuré une fois et mémorisé';

  @override
  String get settingsExportData => 'Exporter les données';

  @override
  String get settingsRecentlyDeleted => 'Supprimés récemment';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'Récupérez ce qui a été supprimé ces trente derniers jours';

  @override
  String get themePremiumHeading => 'Thèmes Premium';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get dashCreditDebt => 'Crédits et dettes';

  @override
  String get dashSubscriptions => 'Abonnements';

  @override
  String get moneyIncome => 'Revenus';

  @override
  String get dashExpenses => 'Dépenses';

  @override
  String get dashSpendingOverview => 'Aperçu des dépenses';

  @override
  String get dashBudgetProgress => 'Suivi des budgets';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String txDeleteManyTitle(int count) {
    return 'Supprimer $count opérations ?';
  }

  @override
  String get txDeleteManyBody =>
      'Les soldes sont recalculés. Tout virement parmi elles emporte son autre moitié.';

  @override
  String get txMoveToAccount => 'Déplacer vers un compte';

  @override
  String get txDeleted => 'Opération supprimée';

  @override
  String txDeleteFailed(String error) {
    return 'Impossible de supprimer cette opération : $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get txActions => 'Actions';

  @override
  String get txChangeCategory => 'Changer de catégorie';

  @override
  String get txChangeDate => 'Changer la date';

  @override
  String get txMarkAsPaid => 'Marquer comme payé';

  @override
  String get txMarkAsCorrection => 'Marquer comme correction de solde';

  @override
  String get txMarkAsCorrectionTitle => 'Ni revenu ni dépense ?';

  @override
  String get txMarkAsCorrectionBody =>
      'À utiliser pour de l\'argent ni gagné ni dépensé, comme une hausse du plafond d\'une carte. Le solde ne change pas ; il n\'est simplement plus compté comme revenu ou dépense.';

  @override
  String get txMarkedAsCorrection =>
      'C\'est maintenant une correction de solde.';

  @override
  String get txMarkAsCorrectionFailed =>
      'Celle-ci ne peut pas être une correction.';

  @override
  String get txDuplicate => 'Dupliquer';

  @override
  String get filterTitle => 'Filtrer';

  @override
  String get filterDirection => 'Sens';

  @override
  String get filterState => 'État';

  @override
  String get filterKind => 'Type';

  @override
  String get filterTransfers => 'Virements';

  @override
  String get filterAccounts => 'Comptes';

  @override
  String get filterCategories => 'Catégories';

  @override
  String get filterDates => 'Dates';

  @override
  String get filterBudget => 'Budget';

  @override
  String get filterGoal => 'Objectif';

  @override
  String get filterNone => 'Aucun';

  @override
  String get filterThisMonth => 'Ce mois-ci';

  @override
  String get filterLastMonth => 'Le mois dernier';

  @override
  String get filterLast3Months => '3 derniers mois';

  @override
  String get filterThisYear => 'Cette année';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afficher $count opérations',
      one: 'Afficher 1 opération',
      zero: 'Aucune opération ne correspond',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Effacer';

  @override
  String get filterNoMatches => 'Aucun résultat';

  @override
  String get filterAny => 'Tous';

  @override
  String get filterSpent => 'Dépensé';

  @override
  String get filterEarned => 'Gagné';

  @override
  String get filterHidden => 'Masqué';

  @override
  String get filterIncluded => 'Inclus';

  @override
  String get filterOnly => 'Uniquement';

  @override
  String get filterFrom => 'Du';

  @override
  String get filterTo => 'Au';

  @override
  String get actionApply => 'Appliquer';

  @override
  String get filterPaid => 'Payé';

  @override
  String get filterNotYet => 'Pas encore';

  @override
  String get filterSkipped => 'Ignoré';

  @override
  String get filterAmount => 'Montant';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get entityBudget => 'Budget';

  @override
  String get budgetGone => 'Ce budget n\'existe plus.';

  @override
  String get budgetEarlier => 'Avant';

  @override
  String get budgetLater => 'Après';

  @override
  String get budgetWhereItWent => 'Où est passé l\'argent';

  @override
  String get budgetRecentPeriods => 'Périodes récentes';

  @override
  String get budgetCaps => 'Plafonds';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get budgetNoCategoriesToCap =>
      'Ce budget n\'a encore aucune catégorie à plafonner.';

  @override
  String get budgetCapACategory => 'Plafonner une catégorie';

  @override
  String get entityCategory => 'Catégorie';

  @override
  String get budgetAsShare => 'En part du budget';

  @override
  String get budgetAsShareHint => 'Suit le budget quand vous le modifiez';

  @override
  String get actionSet => 'Définir';

  @override
  String get budgetAcrossPeriod => 'Sur la période';

  @override
  String get budgetPreviousPeriod => 'Période précédente';

  @override
  String get budgetEvenPace => 'Rythme régulier';

  @override
  String get budgetNew => 'Nouveau budget';

  @override
  String get budgetCreate => 'Créer un budget';

  @override
  String budgetDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get entityAccount => 'Compte';

  @override
  String get entityTransaction => 'Opération';

  @override
  String get walletGone => 'Ce compte n\'existe plus.';

  @override
  String get walletCorrectBalance => 'Corriger le solde';

  @override
  String get walletCorrectBalanceSubtitle =>
      'Enregistrer l\'écart avec le montant réel';

  @override
  String get walletMergeInto => 'Fusionner avec un autre compte';

  @override
  String get walletInThisMonth => 'Entrées ce mois-ci';

  @override
  String get walletOutThisMonth => 'Sorties ce mois-ci';

  @override
  String get walletRecentActivity => 'Activité récente';

  @override
  String get walletNoOtherAccount =>
      'Il n\'y a aucun autre compte avec lequel fusionner.';

  @override
  String get walletMergeIntoTitle => 'Fusionner avec';

  @override
  String get walletMergeAction => 'Fusionner';

  @override
  String walletMerged(int count, String target) {
    return '$count déplacée(s) vers $target.';
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
      other: '$removed virements entre les deux comptes ont été supprimés',
      one: 'Un virement entre les deux comptes a été supprimé',
    );
    return '$count déplacée(s) vers $target. $_temp0, car il n\'avait plus deux extrémités.';
  }

  @override
  String get walletRealBalance => 'Solde réel';

  @override
  String get walletCorrectAction => 'Corriger';

  @override
  String get txGone => 'Cette opération n\'existe plus.';

  @override
  String get txKind => 'Type';

  @override
  String get txState => 'État';

  @override
  String get txWasDue => 'Échéance';

  @override
  String get txNotes => 'Notes';

  @override
  String get txDeleteOneTitle => 'Supprimer cette opération ?';

  @override
  String get rulesTitle => 'Règles de nommage';

  @override
  String get rulesAdd => 'Ajouter une règle';

  @override
  String rulesRemoved(String title) {
    return 'Règle pour $title supprimée';
  }

  @override
  String get rulesWhenTitleSays => 'Quand le titre contient';

  @override
  String get rulesMatchExactly => 'Correspondance exacte';

  @override
  String get rulesChooseCategory => 'Choisir une catégorie';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get goalNew => 'Nouvel objectif';

  @override
  String get goalLoadFailed => 'Impossible de charger vos objectifs.';

  @override
  String get goalCreate => 'Créer un objectif';

  @override
  String get trashTitle => 'Supprimés récemment';

  @override
  String get trashRestore => 'Restaurer';

  @override
  String get trashRestored => 'Restauré.';

  @override
  String get payTitle => 'Moyens de paiement';

  @override
  String get payDefault => 'Par défaut';

  @override
  String get payAddOne => 'En ajouter un';

  @override
  String payDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get payName => 'Nom';

  @override
  String get payNameHint => 'Carte du quotidien';

  @override
  String get payKind => 'Type';

  @override
  String get payBankOrIssuer => 'Banque ou émetteur';

  @override
  String get payLastFour => '4 derniers chiffres';

  @override
  String get payUseByDefault => 'Utiliser par défaut';

  @override
  String get backupChecking => 'Vérification…';

  @override
  String get backupLoading => 'Chargement…';

  @override
  String get backupSaveACopy => 'Enregistrer une copie';

  @override
  String get backupAutomaticBackups => 'Sauvegardes automatiques';

  @override
  String get backupHowManyBackupsToKeep => 'Nombre de sauvegardes à conserver';

  @override
  String get backupSaveABackupFile => 'Enregistrer un fichier de sauvegarde';

  @override
  String get backupShareItToFilesEmail =>
      'Partagez-le vers Fichiers, par e-mail ou ailleurs';

  @override
  String get backupRestoreFromAFile => 'Restaurer depuis un fichier';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Remplace tout ce qui se trouve sur cet appareil';

  @override
  String get backupRestoreThisBackup => 'Restaurer cette sauvegarde ?';

  @override
  String get backupEraseRestore => 'Effacer et restaurer';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive est indisponible';

  @override
  String get backupConnectGoogleDrive => 'Connecter Google Drive';

  @override
  String get backupBackUpNow => 'Sauvegarder maintenant';

  @override
  String get backupKeep => 'Conserver';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'La dernière sauvegarde automatique n\'a pas eu lieu';

  @override
  String get backupDisconnectGoogleDrive => 'Déconnecter Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'Déconnecter Google Drive ?';

  @override
  String get backupDisconnect => 'Déconnecter';

  @override
  String get backupDeleteThisBackup => 'Supprimer cette sauvegarde ?';

  @override
  String get importChooseACsvFile => 'Choisir un fichier CSV';

  @override
  String get importRememberTheseSettingsForThis =>
      'Mémoriser ces réglages pour cette banque';

  @override
  String get importChange => 'Changer';

  @override
  String get importAuto => 'Auto';

  @override
  String get importDone => 'Terminé';

  @override
  String get importRememberThisBank => 'Mémoriser cette banque';

  @override
  String get importForget => 'Oublier';

  @override
  String get importImport => 'Importer';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTermsOfService => 'Conditions d\'utilisation';

  @override
  String get settingsRefundPolicy => 'Politique de remboursement';

  @override
  String get settingsOpenSourceLicenses => 'Licences open source';

  @override
  String get settingsMeetTheDeveloper => 'Le développeur';

  @override
  String get settingsContactSupport => 'Contacter l\'assistance';

  @override
  String get settingsSubject => 'Objet';

  @override
  String get settingsMessage => 'Message';

  @override
  String get settingsSendMessage => 'Envoyer le message';

  @override
  String get settingsUseApiRate => 'Utiliser le taux de l\'API';

  @override
  String get settingsRefreshRates => 'Actualiser les taux';

  @override
  String get settingsSearchCurrencies => 'Rechercher des devises...';

  @override
  String get settingsCustomRate => 'Taux personnalisé';

  @override
  String get settingsSetCustomRate => 'Définir un taux personnalisé';

  @override
  String get settingsNotNow => 'Pas maintenant';

  @override
  String get settingsGoPremium => 'Passer à Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Format tableur pour Excel, Google Sheets';

  @override
  String get settingsPdfReport => 'Rapport PDF';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Synthèse mise en forme avec répartitions';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'Tous les revenus et dépenses';

  @override
  String get settingsCategories => 'Catégories';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Répartition et totaux par catégorie';

  @override
  String get settingsWallets => 'Portefeuilles';

  @override
  String get settingsWalletBalancesAndHistory =>
      'Soldes et historique des portefeuilles';

  @override
  String get settingsHelpFaq => 'Aide et FAQ';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLargeTransactionThreshold =>
      'Seuil des grosses opérations';

  @override
  String get settingsRemindMeBeforeDueDate => 'Me rappeler avant l\'échéance';

  @override
  String get settingsDailyReminders => 'RAPPELS QUOTIDIENS';

  @override
  String get settingsDailyReminders2 => 'Rappels quotidiens';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Recevez un rappel pour noter vos dépenses';

  @override
  String get settingsBudgetAlerts => 'ALERTES BUDGET';

  @override
  String get settingsBudgetAlerts2 => 'Alertes budget';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'M\'avertir à l\'approche de la limite du budget';

  @override
  String get settingsWarningThreshold => 'Seuil d\'alerte';

  @override
  String get settingsTransactionAlerts => 'ALERTES D\'OPÉRATIONS';

  @override
  String get settingsLargeTransactionAlerts => 'Alertes grosses opérations';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'M\'avertir des opérations au-dessus du seuil';

  @override
  String get settingsRecurringTransactionReminders =>
      'Rappels d\'opérations récurrentes';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'Rappeler les paiements récurrents à venir';

  @override
  String get settingsOtherNotifications => 'AUTRES NOTIFICATIONS';

  @override
  String get settingsSubscriptionExpiryAlerts =>
      'Alertes d\'expiration d\'abonnement';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Soyez averti avant l\'expiration de Premium';

  @override
  String get settingsPromotionalNotifications =>
      'Notifications promotionnelles';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Recevoir des offres et des nouveautés';

  @override
  String get settingsTurnOnDailyReminders => 'Activer les rappels quotidiens ?';

  @override
  String get settingsEnterAmount => 'Saisir un montant';

  @override
  String get settingsReminderTime => 'Heure du rappel';

  @override
  String get settingsPrivacySecurity => 'Confidentialité et sécurité';

  @override
  String get settingsSecurity => 'SÉCURITÉ';

  @override
  String get settingsBiometricLock => 'Verrouillage biométrique';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Déverrouiller avec l\'empreinte ou le visage';

  @override
  String get settingsAutoLock => 'Verrouillage auto';

  @override
  String get settingsDataPrivacy => 'CONFIDENTIALITÉ DES DONNÉES';

  @override
  String get settingsClearCache => 'Vider le cache';

  @override
  String get settingsClearCachedDataAndForce =>
      'Vider le cache et forcer une resynchronisation';

  @override
  String get settingsClearAllData => 'Effacer toutes les données';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Supprimer toutes les opérations, budgets et réglages';

  @override
  String get settingsDangerZone => 'ZONE DANGEREUSE';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Supprimer définitivement votre compte et toutes vos données';

  @override
  String get settingsAutoLockTimeout => 'Délai de verrouillage auto';

  @override
  String get settingsDeleteEverything => 'Tout supprimer';

  @override
  String get settingsAreYouAbsolutelySure => 'En êtes-vous vraiment sûr ?';

  @override
  String get settingsYesDeleteAll => 'Oui, tout supprimer';

  @override
  String get settingsContinue => 'Continuer';

  @override
  String get settingsEditProfile => 'Modifier le profil';

  @override
  String get settingsDisplayName => 'Nom affiché';

  @override
  String get settingsEmailAddress => 'Adresse e-mail';

  @override
  String get settingsUnsavedChanges => 'Modifications non enregistrées';

  @override
  String get settingsStay => 'Rester';

  @override
  String get settingsLeave => 'Quitter';

  @override
  String get settingsSearchByCodeOrName => 'Rechercher par code ou nom...';

  @override
  String get settingsSearchSettings => 'Rechercher dans les paramètres...';

  @override
  String get settingsSubscription => 'Abonnement';

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String get settingsGoals => 'Objectifs';

  @override
  String get settingsCardsInNetWorth =>
      'Inclure les cartes de crédit dans le patrimoine';

  @override
  String get settingsCardsInNetWorthSub =>
      'Désactivé : seul l\'argent que vous avez compte, pas les soldes des cartes.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Épargnez pour un projet et suivez votre progression';

  @override
  String get settingsBudgets => 'Budgets';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Fixez des limites et suivez la période en cours';

  @override
  String get settingsUpcomingAndOverdue => 'À venir et en retard';

  @override
  String get settingsWhatIsDueAndWhat =>
      'Ce qui est dû, et ce qui a été manqué';

  @override
  String get settingsAccounts => 'Comptes';

  @override
  String get settingsAddReorderAndEditYour =>
      'Ajoutez, réorganisez et modifiez vos comptes';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'Les cartes et comptes avec lesquels vous payez';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Où classer une opération selon son nom';

  @override
  String get settingsNotificationSettings => 'Paramètres de notification';

  @override
  String get settingsCloudSync => 'Synchronisation cloud';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Synchronisez vos données sur vos appareils';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV gratuit · Rapport PDF en Premium';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Questions, réclamations ou avis';

  @override
  String get settingsRateTheApp => 'Noter l\'application';

  @override
  String get settingsShareWithFriends => 'Partager avec des amis';

  @override
  String get settingsReplayAppTour => 'Revoir la visite guidée';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'Revoir la présentation des fonctionnalités';

  @override
  String get settingsAboutTheAccountant => 'À propos de The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Version, licences et plus';

  @override
  String get settingsTestCrash => 'Plantage de test';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Déclencher une exception de test pour Crashlytics';

  @override
  String get settingsDeveloper => 'DÉVELOPPEUR';

  @override
  String get settingsRestoreFromCloud => 'Restaurer depuis le cloud ?';

  @override
  String get settingsSyncing => 'Synchronisation...';

  @override
  String get settingsSynced => 'Synchronisé';

  @override
  String get settingsSyncError => 'Erreur de synchro';

  @override
  String get syncBackgroundFailed =>
      'Synchronisation impossible. Vos modifications sont en sécurité sur cet appareil et seront synchronisées plus tard.';

  @override
  String get settingsOffline => 'Hors ligne';

  @override
  String get settingsReady => 'Prêt';

  @override
  String get settingsYesUseThis => 'Oui, utiliser celui-ci';

  @override
  String get settingsKeepThemSeparate => 'Les garder séparés ?';

  @override
  String get settingsCurrentPassword => 'Mot de passe actuel';

  @override
  String get settingsNewPassword => 'Nouveau mot de passe';

  @override
  String get settingsConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get walletEGPersonalSavingsBusiness => 'ex. : Personnel, Épargne, Pro';

  @override
  String get walletEnterCreditLimit => 'Saisir le plafond de crédit';

  @override
  String get walletSelectBillingDay => 'Choisir le jour de facturation';

  @override
  String get walletCreateAccount => 'Créer le compte';

  @override
  String get walletWalletCreatedSuccessfully => 'Portefeuille créé';

  @override
  String get walletAccountUpdatedSuccessfully => 'Compte mis à jour';

  @override
  String get walletEditAccount => 'Modifier le compte';

  @override
  String get walletSetAsDefault => 'Définir par défaut';

  @override
  String get walletUseDecimals => 'Utiliser les décimales';

  @override
  String get walletEnterWalletName => 'Saisir le nom du portefeuille';

  @override
  String get walletCurrency => 'Devise';

  @override
  String get walletIcon => 'Icône';

  @override
  String get walletColor => 'Couleur';

  @override
  String get walletWalletName => 'Nom du portefeuille';

  @override
  String get walletInitialBalance => 'Solde initial';

  @override
  String get txAddATransferFee => 'Ajouter des frais de virement';

  @override
  String get txRemove => 'Retirer';

  @override
  String get txPaymentMethod => 'Moyen de paiement';

  @override
  String get txObjective => 'Objectif';

  @override
  String get txTitle => 'Titre';

  @override
  String get txTesco => 'Carrefour';

  @override
  String get txAll => 'Tout';

  @override
  String get txSkip => 'Ignorer';

  @override
  String get txMarkAsPaid2 => 'Marquer comme payé';

  @override
  String get txConfirmPayment => 'Confirmer le paiement';

  @override
  String get txAmountCharged => 'Montant débité';

  @override
  String get txUndo => 'Annuler';

  @override
  String get txNoLoan => 'Aucun prêt';

  @override
  String get txLentMoney => 'Argent prêté';

  @override
  String get txBorrowedMoney => 'Argent emprunté';

  @override
  String get goalShowOnTheHomeScreen => 'Afficher sur l\'écran d\'accueil';

  @override
  String get goalWhatAreYouSavingFor => 'Pour quoi épargnez-vous ?';

  @override
  String get goalNewLaptop => 'Nouvel ordinateur portable';

  @override
  String get goalTarget => 'Cible';

  @override
  String get goalColour => 'Couleur';

  @override
  String get goalClear => 'Effacer';

  @override
  String get goalGoal => 'Objectif';

  @override
  String get goalThisGoalNoLongerExists => 'Cet objectif n\'existe plus.';

  @override
  String get goalAddToGoal => 'Ajouter à l\'objectif';

  @override
  String get goalUnlink => 'Dissocier';

  @override
  String get reportUpgrade => 'Passer à Premium';

  @override
  String get budgetSpending => 'Dépenses';

  @override
  String get budgetEarnings => 'Gains';

  @override
  String get budgetEvery => 'Chaque';

  @override
  String get budgetCarryOverWhatIsLeft => 'Reporter le reste';

  @override
  String get budgetGroceries => 'Courses';

  @override
  String get authLinkYourAccount => 'Associer votre compte';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authLinkAccount => 'Associer le compte';

  @override
  String get authEmailAddress => 'Adresse e-mail';

  @override
  String get authSendResetCode => 'Envoyer le code';

  @override
  String get authResetCode => 'Code de réinitialisation';

  @override
  String get authResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get authWelcomeBack => 'Bon retour';

  @override
  String get authSignInToContinueYour =>
      'Connectez-vous pour poursuivre votre parcours financier';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authJoinUsToStartYour =>
      'Rejoignez-nous pour démarrer votre parcours financier';

  @override
  String get authFullName => 'Nom complet';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Mensuel';

  @override
  String get premiumYearly => 'Annuel';

  @override
  String get premiumLifetime => 'À vie';

  @override
  String get premiumNotNow => 'Pas maintenant';

  @override
  String get aiRename => 'Renommer';

  @override
  String get aiRenameChat => 'Renommer la discussion';

  @override
  String get aiDeleteChat => 'Supprimer la discussion ?';

  @override
  String get aiChatName => 'Nom de la discussion';

  @override
  String get aiScanReceipt => 'Scanner un ticket';

  @override
  String get aiCamera => 'Appareil photo';

  @override
  String get aiGallery => 'Galerie';

  @override
  String get aiMerchantTitle => 'Commerçant / titre';

  @override
  String get aiSaveAsTransaction => 'Enregistrer comme opération';

  @override
  String get onboardBrowseThemes => 'Parcourir les thèmes';

  @override
  String get onboardBack => 'Retour';

  @override
  String get onboardGetStarted => 'Commencer';

  @override
  String get onboardMainAccount => 'Compte principal';

  @override
  String get creditRecordPayment => 'Enregistrer un paiement';

  @override
  String get creditPleaseEnterAValidAmount =>
      'Veuillez saisir un montant valide';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'Le montant dépasse le solde restant';

  @override
  String get creditPaymentAmount => 'Montant du paiement';

  @override
  String get creditPaidOn => 'Payé le';

  @override
  String get creditFullAmount => 'Montant total';

  @override
  String get subSubscriptionName => 'Nom de l\'abonnement';

  @override
  String get subAskBeforeEachPayment => 'Demander avant chaque paiement';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Chaque paiement attend dans « À venir » jusqu\'à ce que vous confirmiez le montant débité, ou que vous l\'ignoriez. Idéal pour les montants variables, comme une carte payée dans une autre devise.';

  @override
  String get subChangesApplyFromNext =>
      'Un nouveau montant ou compte s\'applique à partir du prochain paiement. Les paiements déjà effectués restent inchangés.';

  @override
  String get catPleaseEnterACategoryName =>
      'Veuillez saisir un nom de catégorie';

  @override
  String get catEnterCategoryName => 'Saisir le nom de la catégorie';

  @override
  String get catSearch => 'Rechercher des catégories';

  @override
  String get catNoMatch => 'Aucune catégorie ne correspond.';

  @override
  String get catUseEmoji => 'Utiliser un emoji';

  @override
  String get catEmojiHint => 'Tapez ou choisissez un emoji';

  @override
  String get catArchive => 'Archiver';

  @override
  String get catMergeInto => 'Fusionner avec…';

  @override
  String catMergeIntoTitle(String name) {
    return 'Fusionner $name avec';
  }

  @override
  String get catMergeBuiltIn => 'Intégrée';

  @override
  String get catMergeNoTargets =>
      'Il n\'y a aucune autre catégorie du même type avec laquelle fusionner.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return 'Fusionner $from avec $to ?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Toutes les opérations, budgets et sous-catégories de $from passent dans $to, et $from est supprimée. Cela se synchronise sur vos autres appareils.';
  }

  @override
  String get catMergeAction => 'Fusionner';

  @override
  String catMerged(String from, String to) {
    return '$from fusionnée avec $to.';
  }

  @override
  String get catExpenseSection => 'Catégories de dépenses';

  @override
  String get catIncomeSection => 'Catégories de revenus';

  @override
  String get catSectionEmpty => 'Aucune pour l\'instant';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sous-catégories',
      one: '1 sous-catégorie',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations',
      one: '1 opération',
      zero: 'Aucune opération',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'Dans $name';
  }

  @override
  String get catAddSubcategory => 'Ajouter une sous-catégorie';

  @override
  String get catNoSubcategoriesYet => 'Aucune sous-catégorie. Ajoutez-en une';

  @override
  String get catMoveTo => 'Déplacer vers…';

  @override
  String catMoveToTitle(String name) {
    return 'Déplacer $name vers';
  }

  @override
  String get catTopLevel => 'Niveau principal';

  @override
  String get catTopLevelHint => 'Dans aucune catégorie';

  @override
  String catMovedInto(String name, String parent) {
    return '$name est maintenant dans $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name est maintenant une catégorie principale.';
  }

  @override
  String get catMoveNoParents =>
      'Il n\'y a aucune catégorie dans laquelle la placer.';

  @override
  String get catMoveTransactions => 'Déplacer les opérations…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Déplacer les opérations de $name vers';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Déplacer $count opérations vers $to ?',
      one: 'Déplacer 1 opération vers $to ?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Seules les opérations sont déplacées. $from reste, avec ses budgets et sous-catégories. Cela se synchronise sur vos autres appareils.';
  }

  @override
  String get catMoveAction => 'Déplacer';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations déplacées vers $to.',
      one: '1 opération déplacée vers $to.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name n\'a aucune opération à déplacer.';
  }

  @override
  String get catNoMoveTargets =>
      'Il n\'y a aucune autre catégorie du même type vers laquelle les déplacer.';

  @override
  String catDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get catDeleteEmptyBody =>
      'Elle ne contient aucune opération, rien d\'autre ne change.';

  @override
  String get catDeleteChildrenNote =>
      'Ses sous-catégories passent au niveau principal.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations y sont classées. Que doivent-elles devenir ?',
      one: '1 opération y est classée. Que doit-elle devenir ?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'Déplacer vers une autre catégorie';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Puis $name est supprimée. Les budgets qui l\'utilisaient suivent aussi.';
  }

  @override
  String get catDeleteThemToo => 'Supprimer aussi les opérations';

  @override
  String get catDeleteThemTooHint =>
      'Elles vont dans « Supprimés récemment », où vous pouvez les restaurer pendant 30 jours.';

  @override
  String catDeleted(String name) {
    return '$name supprimée.';
  }

  @override
  String get catActionFailed => 'Action impossible. Réessayez.';

  @override
  String get catStaysTopLevel =>
      'Cette catégorie a ses propres sous-catégories, elle reste donc au niveau principal.';

  @override
  String get catUnarchive => 'Désarchiver';

  @override
  String get catArchivedSection => 'Archivées';

  @override
  String get catArchivedHint =>
      'Conservées pour l\'historique, mais non proposées quand vous ajoutez une opération.';

  @override
  String get catNothingItsOwnCategory => 'Aucune — catégorie à part entière';

  @override
  String get notifEnableNotifications => 'Activer les notifications';

  @override
  String get startupContinueWithoutChecking => 'Continuer sans vérifier ?';

  @override
  String get startupContinueOffline => 'Continuer hors ligne';

  @override
  String get startupViewSubscriptionOptions =>
      'Voir les formules d\'abonnement';

  @override
  String get sharedWelcomeBack => 'Bon retour';

  @override
  String get sharedRestoringYourDataFromThe =>
      'Restauration de vos données depuis le cloud…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return 'Fusionner $source avec $target ?';
  }

  @override
  String get backupNothingHereYet => 'Rien pour l\'instant.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Appliqué automatiquement quand un fichier a ces colonnes';

  @override
  String get importDateFormat => 'Format de date';

  @override
  String get importChooseOne => 'En choisir un';

  @override
  String get importDecimalPoint => 'Séparateur décimal';

  @override
  String get importFlipTheSigns => 'Inverser les signes';

  @override
  String get importForExportsThatWriteA =>
      'Pour les exports qui notent une dépense en positif';

  @override
  String get importWhereRowsGoWhenThe =>
      'Où vont les lignes quand le fichier ne cite aucun de vos comptes';

  @override
  String get importSkipWhatIsAlreadyHere => 'Ignorer ce qui existe déjà';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Créer les catégories citées dans le fichier';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Sinon, ces lignes arrivent sans catégorie';

  @override
  String get importCategoriesInThisFile => 'Catégories de ce fichier';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Fait avec amour pour les finances personnelles';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'Développé et maintenu par :';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Fermer';

  @override
  String get settingsGetInTouch => 'Nous contacter';

  @override
  String get settingsAsAPremiumMemberYour =>
      'En tant que membre Premium, votre demande est traitée en priorité.';

  @override
  String get settingsWhatToInclude => 'Contenu à inclure';

  @override
  String get settingsNoCurrenciesFound => 'Aucune devise trouvée';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Exportez vos données financières pour les analyser dans d\'autres applis ou les garder en sauvegarde.';

  @override
  String get settingsDateRange => 'Période';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'Rapports PDF';

  @override
  String get settingsGettingStarted => 'Premiers pas';

  @override
  String get settingsStillNeedHelp => 'Besoin d\'aide ?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'Notre équipe d\'assistance est là pour vous aider';

  @override
  String get settingsAppLocked => 'Application verrouillée';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Déverrouillez pour accéder à The Accountant';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Choisissez quand et comment The Accountant doit vous rappeler de noter vos dépenses.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'Votre e-mail sert à vous connecter et ne peut pas être modifié ici.';

  @override
  String get settingsYourDataIsOnThis =>
      'Vos données sont uniquement sur cet appareil';

  @override
  String get settingsUpgradeForCloudSync =>
      'Passez à Premium pour la synchro cloud';

  @override
  String get settingsNoSettingsFound => 'Aucun paramètre trouvé';

  @override
  String get settingsTryADifferentSearchTerm => 'Essayez un autre terme';

  @override
  String get settingsSyncStatus => 'ÉTAT DE LA SYNCHRO';

  @override
  String get settingsSyncNow => 'Synchroniser';

  @override
  String get settingsRestoreFromCloud2 => 'Restaurer depuis le cloud';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'À CONFIRMER';

  @override
  String get walletCreateYourFirstAccount => 'Créez votre premier compte';

  @override
  String get walletYouNeedAtLeastOne =>
      'Il vous faut au moins un compte pour commencer à suivre vos finances';

  @override
  String get walletAccountType => 'Type de compte';

  @override
  String get walletAccountName => 'Nom du compte';

  @override
  String get walletCreditLimit => 'Plafond de crédit';

  @override
  String get walletCreditLimitHelp =>
      'Plafond augmenté ? Modifiez-le ici. Un nouveau plafond n\'est pas un revenu.';

  @override
  String get walletAmountOwed => 'Montant dû';

  @override
  String get walletAmountOwedHelp =>
      'Ce que vous devez actuellement sur la carte. Indiquez 0 si elle est soldée.';

  @override
  String get walletCurrentBalance => 'Solde actuel';

  @override
  String get walletCurrentBalanceHelp =>
      'Une modification est enregistrée comme correction de solde, pour que votre historique reste juste.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'Que représente $amount sur cette carte ?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Le crédit qu\'il me reste';

  @override
  String get walletCardBalanceOwed => 'Ce que je dois';

  @override
  String get walletCardBalanceChoose =>
      'Indiquez ce que représente ce montant, pour que la dette soit bien calculée.';

  @override
  String get walletBillingCycleDayOptional =>
      'Jour de facturation (facultatif)';

  @override
  String get walletThisWillBeYourDefault => 'Ce sera votre compte par défaut';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Rien n\'est encore enregistré sur ce compte.';

  @override
  String get walletAddAccount => 'Ajouter un compte';

  @override
  String get walletYourAccounts => 'Vos comptes';

  @override
  String get walletNoAccountsYet => 'Aucun compte pour l\'instant';

  @override
  String get walletOutstanding => 'Encours';

  @override
  String get walletAvailable => 'Disponible';

  @override
  String get walletLimit => 'Plafond';

  @override
  String get walletBalance => 'Solde';

  @override
  String get walletUseThisWalletForNew =>
      'Utiliser ce portefeuille pour les nouvelles opérations';

  @override
  String get walletSelectIcon => 'Choisir une icône';

  @override
  String get walletSelectColor => 'Choisir une couleur';

  @override
  String get txYouNeedAtLeast2 =>
      'Il faut au moins 2 comptes pour faire un virement';

  @override
  String get txNoAccountTitle => 'Aucun compte pour enregistrer ceci';

  @override
  String get txNoAccountBody =>
      'Ajoutez un compte, ou rouvrez un compte clôturé, et ce formulaire sera prêt.';

  @override
  String get txNoAccountAction => 'Gérer les comptes';

  @override
  String get txDeleteTransaction => 'Supprimer l\'opération';

  @override
  String get txAreYouSureYouWant =>
      'Voulez-vous vraiment supprimer cette opération ?';

  @override
  String get txTransactionType => 'Type d\'opération';

  @override
  String get txTransferFee => 'Frais de virement';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Prélevés à part, pour que le virement lui-même reste équilibré.';

  @override
  String get txDeductedFrom => 'Prélevé sur';

  @override
  String get txNoPaymentMethods => 'Aucun moyen de paiement';

  @override
  String get txNothingDeletedRecently => 'Rien de supprimé récemment';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Tout ce que vous supprimez apparaît ici pendant trente jours.';

  @override
  String get txNoRulesYet => 'Aucune règle pour l\'instant';

  @override
  String get txClearAll => 'Tout effacer';

  @override
  String get txApplyFilters => 'Appliquer les filtres';

  @override
  String get txUpcomingOverdue => 'À venir et en retard';

  @override
  String get txNew => 'Nouveau';

  @override
  String get txLoan => 'Prêt';

  @override
  String get goalStarted => 'Commencé le';

  @override
  String get goalTargetDate => 'Date cible';

  @override
  String get goalWithADateTheGoal =>
      'Avec une date, l\'objectif calcule combien mettre de côté chaque jour.';

  @override
  String get goalCountedTowardThisGoal => 'Compté pour cet objectif';

  @override
  String get goalGettingThere => 'En bonne voie';

  @override
  String get goalSetATargetDateAnd =>
      'Fixez une date cible et le montant à mettre de côté sera calculé.';

  @override
  String get reportSpendingInsights => 'Analyse des dépenses';

  @override
  String get reportNoSpendingDataForThis => 'Aucune dépense sur cette période';

  @override
  String get reportNoCategorySpendingData => 'Aucune dépense par catégorie';

  @override
  String get reportNoSpendingDataAvailable => 'Aucune donnée de dépenses';

  @override
  String get reportBudgetVsActual => 'Budget vs réel';

  @override
  String get reportNoActiveBudgets => 'Aucun budget actif';

  @override
  String get reportCreateABudgetToTrack =>
      'Créez un budget pour suivre vos dépenses';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Vous dépensez plus vite que la période n\'avance.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'Rien d\'enregistré sur cette période.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent sur $limit utilisés';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount restants';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount de dépassement';
  }

  @override
  String get budgetPeriodEnded => 'Période terminée';

  @override
  String get budgetPaceOver => 'Dépassé';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Mot de passe réinitialisé. Veuillez vous connecter.';

  @override
  String get authResendCode => 'Renvoyer le code';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authOrContinueWith => 'Ou continuer avec';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithApple => 'Continuer avec Apple';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String get authPleaseAcceptTheTermsAnd =>
      'Veuillez accepter les conditions générales';

  @override
  String get authPasswordStrength => 'Robustesse du mot de passe';

  @override
  String get authAlreadyHaveAnAccount => 'Déjà un compte ? ';

  @override
  String get authPersonalInformation => 'Informations personnelles';

  @override
  String get authUpgradeToPremium => 'Passer à Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Débloquez les budgets illimités, les analyses avancées et plus encore !';

  @override
  String get authUpgradeNow => 'Passer à Premium';

  @override
  String get authPremiumMember => 'Membre Premium';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'Vous profitez de toutes les fonctionnalités Premium';

  @override
  String get authSaveChanges => 'Enregistrer';

  @override
  String get authAreYouSureYouWant =>
      'Voulez-vous vraiment vous déconnecter de votre compte ?';

  @override
  String get authChangeProfilePhoto => 'Changer la photo de profil';

  @override
  String get authTakePhoto => 'Prendre une photo';

  @override
  String get authUseYourCamera => 'Utiliser l\'appareil photo';

  @override
  String get authChooseFromGallery => 'Choisir dans la galerie';

  @override
  String get authSelectAnExistingPhoto => 'Sélectionner une photo existante';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Photo sélectionnée ! L\'envoi arrive bientôt.';

  @override
  String get authNameCannotBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get authProfileUpdatedSuccessfully => 'Profil mis à jour !';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Confidentialité et conditions';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Lisez-les avant de continuer.';

  @override
  String get premiumLimitReached => 'Limite atteinte';

  @override
  String get aiChats => 'Discussions';

  @override
  String get aiNewChat => 'Nouvelle discussion';

  @override
  String get aiNoConversationsYet => 'Aucune discussion pour l\'instant';

  @override
  String get aiStartChattingAndYourThreads =>
      'Lancez une discussion et vos échanges apparaîtront ici.';

  @override
  String get aiScanAReceipt => 'Scanner un ticket';

  @override
  String get aiReadingYourReceipt => 'Lecture de votre ticket…';

  @override
  String get aiReviewSave => 'Vérifier et enregistrer';

  @override
  String get aiWeReadThisFromYour =>
      'Ces infos viennent de votre ticket — vérifiez et corrigez si besoin avant d\'enregistrer.';

  @override
  String get dashErrorLoadingFinancialData =>
      'Erreur de chargement des données financières';

  @override
  String get dashNoSpendingDataYet => 'Aucune dépense pour l\'instant';

  @override
  String get dashManage => 'Gérer';

  @override
  String get dashAvailable => 'Disponible : ****';

  @override
  String get onboardWelcome => 'Bienvenue !';

  @override
  String get onboardSelectYourDefaultCurrency =>
      'Choisissez votre devise par défaut';

  @override
  String get onboardLoadingCurrencies => 'Chargement des devises...';

  @override
  String get onboardSetUpYourPrimaryWallet =>
      'Configurez votre portefeuille principal';

  @override
  String get onboardInitialBalanceOptional => 'Solde initial (facultatif)';

  @override
  String get onboardYourAccountIsReadyTo => 'Votre compte est prêt';

  @override
  String get onboardTipYouCanAddMore =>
      'Astuce : vous pouvez ajouter d\'autres comptes dans d\'autres devises à tout moment depuis la section Portefeuilles.';

  @override
  String get creditSettled => 'Réglé';

  @override
  String get creditOverdue => 'En retard';

  @override
  String creditTabCredit(int count) {
    return 'Prêté ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Emprunté ($count)';
  }

  @override
  String get creditNetOutstanding => 'Solde net dû';

  @override
  String get creditAllSettled => 'Tout est réglé';

  @override
  String get creditOthersOweYou => 'On vous doit';

  @override
  String get creditYouOweOthers => 'Vous devez';

  @override
  String creditOverdueCount(int count) {
    return '$count en retard';
  }

  @override
  String get creditEmptyAll => 'Aucun argent prêté ou emprunté';

  @override
  String get creditEmptyLent => 'Aucun argent prêté';

  @override
  String get creditEmptyBorrowed => 'Aucun argent emprunté';

  @override
  String get creditEmptyAllSettled => 'Tout est réglé.';

  @override
  String get creditEmptyHint =>
      'Ajoutez l\'argent prêté ou emprunté pour savoir qui doit quoi à qui.';

  @override
  String get creditShowAll => 'Tout afficher';

  @override
  String get creditShowUnpaid => 'Non réglés uniquement';

  @override
  String get creditMoneyLent => 'Argent prêté';

  @override
  String get creditMoneyBorrowed => 'Argent emprunté';

  @override
  String get creditTheyOweYou => 'On vous doit';

  @override
  String get creditYouOwe => 'Vous devez';

  @override
  String get creditCollected => 'Encaissé';

  @override
  String creditPaidOf(String paid, String total) {
    return '$paid payés sur $total';
  }

  @override
  String get creditRecord => 'Enregistrer';

  @override
  String get subRecurring => 'Récurrent';

  @override
  String get subPaused => 'En pause';

  @override
  String get subAsksFirst => 'Demande d\'abord';

  @override
  String get subFrequency => 'Fréquence';

  @override
  String get notifMarkAllRead => 'Tout marquer comme lu';

  @override
  String get notifTryAgain => 'Réessayer';

  @override
  String get notifStayOnTopOfYour => 'Gardez le contrôle de votre argent';

  @override
  String get notifNoNotificationsYet => 'Aucune notification pour l\'instant';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'Vos notifications apparaîtront ici.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Rien n\'a été modifié ni supprimé.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Inclure les cryptomonnaies';

  @override
  String get sharedTotalBalance => 'Solde total';

  @override
  String get heatmapTitle => 'Rythme quotidien';

  @override
  String get heatmapSpentMore => 'Plus dépensé';

  @override
  String get heatmapEarnedMore => 'Plus gagné';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count opérations ne sont pas affichées : aucun taux n\'est connu entre les devises de leurs comptes et $currency',
      one:
          'Une opération n\'est pas affichée : aucun taux n\'est connu entre la devise de son compte et $currency',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet =>
      'Rien d\'enregistré sur cette période pour l\'instant.';

  @override
  String get heatmapNetForRange => 'Net sur cette période';

  @override
  String get layoutTitle => 'Disposition de l\'accueil';

  @override
  String get layoutSubtitle =>
      'Réorganisez l\'écran d\'accueil ou masquez ce que vous n\'utilisez pas';

  @override
  String get layoutExplain =>
      'Faites glisser pour réorganiser. Ce qui est désactivé garde sa place : le réactiver le remet où vous l\'aviez laissé.';

  @override
  String get layoutReset => 'Rétablir par défaut';

  @override
  String get layoutAllHidden =>
      'Toutes les sections sont masquées. L\'écran d\'accueil sera vide.';

  @override
  String get layoutSectionGreeting => 'Message d\'accueil';

  @override
  String get layoutSectionAccounts => 'Comptes';

  @override
  String get layoutSectionQuickStats => 'Revenus et dépenses';

  @override
  String get layoutSectionQuickLinks => 'Raccourcis';

  @override
  String get layoutSectionSpendingChart => 'Aperçu des dépenses';

  @override
  String get layoutSectionRecent => 'Opérations récentes';

  @override
  String get layoutSectionBudgets => 'Suivi des budgets';

  @override
  String get layoutSectionGoals => 'Objectifs épinglés';

  @override
  String get shortcutAddExpense => 'Ajouter une dépense';

  @override
  String get shortcutAddIncome => 'Ajouter un revenu';

  @override
  String get shortcutScanReceipt => 'Scanner un ticket';

  @override
  String get shortcutTransactions => 'Opérations';

  @override
  String get backupBusySyncing =>
      'Une synchronisation est en cours. Attendez qu\'elle se termine avant de restaurer.';

  @override
  String get appearanceTitle => 'Apparence';

  @override
  String get themeSunriseLight => 'Aurore clair';

  @override
  String get themeSunriseDark => 'Aurore sombre';

  @override
  String get themeMatchSystem => 'Comme le système';

  @override
  String get themeMatchSystemHint =>
      'Passer du clair au sombre avec votre téléphone';

  @override
  String get themeUnlockAll => 'Débloquer tous les thèmes';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Aurore';

  @override
  String get themeAccentSapphire => 'Saphir';

  @override
  String get themeAccentEmerald => 'Émeraude';

  @override
  String get themeAccentRuby => 'Rubis';

  @override
  String get themeAccentAmethyst => 'Améthyste';

  @override
  String get themeAccentGraphite => 'Graphite';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Aujourd\'hui';

  @override
  String get navAdd => 'Ajouter';

  @override
  String get navStats => 'Stats';

  @override
  String get navMore => 'Plus';

  @override
  String get walkthroughTodayTitle => 'Votre journée en un coup d\'œil';

  @override
  String get walkthroughTodayBody =>
      'Patrimoine, ce que vous avez gagné et dépensé, et l\'activité du jour.';

  @override
  String get walkthroughAddTitle => 'Ajoutez en quelques secondes';

  @override
  String get walkthroughAddBody =>
      'Touchez Ajouter pour enregistrer une dépense, un revenu ou un virement.';

  @override
  String get walkthroughTransactionsTitle => 'Vos opérations';

  @override
  String get walkthroughTransactionsBody =>
      'Toutes vos opérations, mois par mois. Recherchez et filtrez pour tout retrouver.';

  @override
  String get walkthroughStatsTitle => 'Voyez où va l\'argent';

  @override
  String get walkthroughStatsBody =>
      'Graphiques par semaine, mois et année, par catégorie.';

  @override
  String get walkthroughBellTitle => 'Restez informé';

  @override
  String get walkthroughBellBody =>
      'Les alertes budget et les rappels apparaissent ici. Tout est prêt !';

  @override
  String get walkthroughBalanceTitle => 'Votre patrimoine';

  @override
  String get walkthroughBalanceBody =>
      'Tous vos portefeuilles s\'additionnent ici, avec une barre qui montre leur répartition.';

  @override
  String get txTransfer => 'Virement';

  @override
  String get txUncategorized => 'Sans catégorie';

  @override
  String todayGoodMorning(String name) {
    return 'Bonjour, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Bon après-midi, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Bonsoir, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Bonjour';

  @override
  String get todayGoodAfternoonPlain => 'Bon après-midi';

  @override
  String get todayGoodEveningPlain => 'Bonsoir';

  @override
  String get todayNetWorth => 'Patrimoine';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount ce mois-ci';
  }

  @override
  String get todayEarned => 'Gagné';

  @override
  String get todaySpent => 'Dépensé';

  @override
  String get todayTitle => 'Aujourd\'hui';

  @override
  String get todayRecent => 'Récent';

  @override
  String get todayAllActivity => 'Toute l\'activité';

  @override
  String get todayNothingYet => 'Rien pour l\'instant aujourd\'hui';

  @override
  String get todayNothingYetBody =>
      'Touchez Ajouter pour enregistrer la première.';

  @override
  String todayMoreWallets(int count) {
    return '+$count de plus';
  }

  @override
  String get todayCoachTitle => 'Demandez à votre coach financier';

  @override
  String get todayCoachBody =>
      'Des réponses et conseils tirés de vos propres dépenses';

  @override
  String get todayNotifications => 'Notifications';

  @override
  String get todayWithinBudget => 'Dans le budget';

  @override
  String get todayOverBudget => 'Budget dépassé';

  @override
  String get todayNetCredit => 'Créance nette';

  @override
  String get todayNetDebt => 'Dette nette';

  @override
  String get todayMonthly => 'Mensuel';

  @override
  String get walletsTitle => 'Portefeuilles';

  @override
  String get walletsNew => 'Nouveau';

  @override
  String get walletsAddHint => 'Ajoutez banque, espèces, épargne…';

  @override
  String get walletsPlanning => 'Planification';

  @override
  String get walletsUpcoming => 'À venir';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count à payer · $amount';
  }

  @override
  String get walletsUpcomingNone => 'Rien à payer prochainement';

  @override
  String get walletsLendBorrow => 'Prêts et emprunts';

  @override
  String get splitTitle => 'Partager une note';

  @override
  String get splitSubtitle =>
      'Partagez une note entre amis ; ce qu\'ils doivent va dans Prêts et emprunts';

  @override
  String get splitWhatFor => 'C\'était pour quoi';

  @override
  String get splitTotal => 'Total';

  @override
  String get splitPeople => 'Personnes';

  @override
  String get splitYou => 'Vous';

  @override
  String get splitIncludeMe => 'J\'avais une part';

  @override
  String get splitIncludeMeSub =>
      'Désactivez si vous avez payé uniquement pour les autres';

  @override
  String get splitAddPerson => 'Ajouter une personne';

  @override
  String get splitPersonName => 'Nom';

  @override
  String get splitKnownPeople => 'Depuis Prêts et emprunts';

  @override
  String get splitRemove => 'Retirer';

  @override
  String get splitPaidBy => 'Payé par';

  @override
  String get splitHow => 'Mode de partage';

  @override
  String get splitEqual => 'À parts égales';

  @override
  String get splitExact => 'Montants';

  @override
  String get splitPercent => 'Pourcentage';

  @override
  String get splitShares => 'Parts';

  @override
  String get splitYourShare => 'Votre part';

  @override
  String get splitOwesYou => 'Vous doit';

  @override
  String splitYouOwe(String name) {
    return 'Vous devez à $name';
  }

  @override
  String get splitPaidTheBill => 'A payé la note';

  @override
  String splitSettlesWith(String name) {
    return 'Règle avec $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total depuis votre compte ; $owed vous sont dus';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Rien ne sort de votre compte maintenant ; vous devez $amount à $name';
  }

  @override
  String get splitPercentLabel => 'Pourcentage de la note';

  @override
  String get splitSave => 'Partager';

  @override
  String get splitSaved => 'Partage enregistré';

  @override
  String get splitNeedCategory => 'Choisissez d\'abord une catégorie.';

  @override
  String get splitThisBill => 'Partager cette note';

  @override
  String get splitThisBillSub =>
      'Entre amis ; ce qu\'ils doivent va dans Prêts et emprunts';

  @override
  String get splitPartOf => 'Note partagée';

  @override
  String walletsOwedToYou(String amount) {
    return 'On vous doit $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'Vous devez $amount';
  }

  @override
  String get walletsAllSettled => 'Tout est réglé';

  @override
  String get walletsGoals => 'Objectifs';

  @override
  String walletsGoalsSub(int count) {
    return '$count actif(s)';
  }

  @override
  String get walletsBudgets => 'Budgets';

  @override
  String get walletsSubscriptions => 'Abonnements';

  @override
  String get walletsTransfer => 'Virement entre portefeuilles';

  @override
  String get walletsArchived => 'Archivés';

  @override
  String walletsDeleteMessage(String name) {
    return 'Supprimer « $name » ? Toutes les opérations de ce compte seront supprimées avec lui.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name supprimé';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name est maintenant votre compte par défaut';
  }

  @override
  String get walletsCreateFailed =>
      'Impossible de créer le compte. Veuillez réessayer.';

  @override
  String get walletsEmptyBody =>
      'Créez votre premier compte pour commencer le suivi.';

  @override
  String get walletsTypeBank => 'Compte bancaire';

  @override
  String get walletsTypeCard => 'Carte de crédit';

  @override
  String get walletsTypeCash => 'Espèces';

  @override
  String get walletsTypeOther => 'Compte';

  @override
  String get moreTitle => 'Plus';

  @override
  String get moreGoPremium => 'Passer à Premium';

  @override
  String get moreGoPremiumBody => 'Assistant IA, synchro cloud, thèmes';

  @override
  String get moreUnlock => 'Débloquer';

  @override
  String get morePremiumActive => 'Premium est actif';

  @override
  String get morePremiumThanks => 'Merci de soutenir The Accountant';

  @override
  String get sectionPreferences => 'PRÉFÉRENCES';

  @override
  String get sectionTools => 'OUTILS FINANCIERS';

  @override
  String get moreAiAssistant => 'Assistant IA';

  @override
  String get moreAiAssistantSub => 'Posez vos questions sur votre argent';

  @override
  String get moreSignOutConfirm =>
      'Se déconnecter de votre compte sur cet appareil ?';

  @override
  String get moreSignOutFailed => 'Déconnexion impossible. Veuillez réessayer.';

  @override
  String get moreDeviceOnlyBody =>
      'Les comptes gratuits ne sont pas sauvegardés dans le cloud : réinstaller l\'appli ou changer de téléphone peut faire perdre vos données. Passez à Premium pour la synchro cloud, ou exportez régulièrement une sauvegarde.';

  @override
  String get moreUpgradeToPremium => 'Passer à Premium';

  @override
  String get moreUser => 'Vous';

  @override
  String get statsTitle => 'Stats';

  @override
  String get statsWeek => 'Semaine';

  @override
  String get statsMonth => 'Mois';

  @override
  String get statsYear => 'Année';

  @override
  String get statsSpending => 'Dépenses';

  @override
  String get statsIncome => 'Revenus';

  @override
  String get statsCategories => 'Catégories';

  @override
  String get statsSpent => 'Dépensé';

  @override
  String get statsEarned => 'Gagné';

  @override
  String get statsNet => 'Net';

  @override
  String get statsThisMonth => 'Ce mois-ci';

  @override
  String statsVsLastMonth(String change) {
    return '$change vs mois dernier';
  }

  @override
  String get statsInsightsSub => 'Résumé, tendances et conseils du mois';

  @override
  String get statsAskCoach => 'Demander au coach IA';

  @override
  String statsOverBy(String amount) {
    return 'Dépassement de $amount';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent % restant';
  }

  @override
  String get activityAll => 'Tout';

  @override
  String get activitySpent => 'Dépensé';

  @override
  String get activityEarned => 'Gagné';

  @override
  String get activityTransfers => 'Virements';

  @override
  String activitySoFar(String month) {
    return '$month jusqu\'ici';
  }

  @override
  String activityNet(String amount) {
    return '$amount net';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats sur tous les mois',
      one: '1 résultat sur tous les mois',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => '7 derniers jours';

  @override
  String get statsPeriodThisMonth => 'Ce mois-ci';

  @override
  String get statsPeriodThisYear => 'Cette année';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations',
      one: '1 opération',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get activitySearchNothingBody =>
      'Tous les mois ont été parcourus. Essayez moins de mots, une autre orthographe, ou retirez un filtre.';

  @override
  String get activityIn => 'Entrées';

  @override
  String get activityOut => 'Sorties';

  @override
  String get activityToday => 'Aujourd\'hui';

  @override
  String get activityYesterday => 'Hier';

  @override
  String get activityTomorrow => 'Demain';

  @override
  String get activityEmptyFutureTitle => 'Aucune opération prévue';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Ajoutez des paiements futurs pour $month';
  }

  @override
  String get activityEmptyNowTitle => 'Aucune opération pour l\'instant';

  @override
  String get activityEmptyNowBody =>
      'Commencez à suivre vos dépenses ce mois-ci';

  @override
  String get activityEmptyPastTitle => 'Aucune opération trouvée';

  @override
  String activityEmptyPastBody(String month) {
    return 'Aucun enregistrement pour $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations supprimées',
      one: '1 opération supprimée',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count déplacée(s) vers $name';
  }

  @override
  String get activityMixedCurrencies =>
      'Elles sont dans des devises différentes, aucun compte ne peut donc toutes les recevoir. Sélectionnez des lignes d\'une seule devise.';

  @override
  String activityMovedPartial(int count) {
    return '$count déplacée(s) ; les virements sont restés en place';
  }

  @override
  String activityMoved(int count) {
    return '$count déplacée(s) vers un autre compte';
  }

  @override
  String activityRedated(int count) {
    return 'Date modifiée pour $count';
  }

  @override
  String get activityNothingToPay => 'Rien n\'était en attente de paiement';

  @override
  String activityMarkedPaid(int count) {
    return '$count marquée(s) comme payée(s)';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count copiée(s) ; les virements ne peuvent pas être copiés seuls';
  }

  @override
  String activityCopied(int count) {
    return '$count copiée(s)';
  }

  @override
  String get activityDeleteOneBody =>
      'Elle sera retirée de vos enregistrements et votre solde sera recalculé.';

  @override
  String get activitySearch => 'Rechercher';

  @override
  String get addNewExpense => 'Nouvelle dépense';

  @override
  String get addNewIncome => 'Nouveau revenu';

  @override
  String get addNewTransfer => 'Nouveau virement';

  @override
  String get addEditTitle => 'Modifier l\'opération';

  @override
  String get addAmount => 'Montant';

  @override
  String get addCategory => 'Catégorie';

  @override
  String get addMore => 'Plus';

  @override
  String get addWallet => 'Portefeuille';

  @override
  String addChangeDate(String date) {
    return 'Changer la date, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Changer l\'heure, $time';
  }

  @override
  String get addSwapAccounts => 'Inverser les deux comptes';

  @override
  String get notifCheckTitle => 'Vérifier les notifications';

  @override
  String get notifAllowed => 'Les notifications sont autorisées';

  @override
  String get notifAllowedHint => 'Les rappels peuvent arriver sur ce téléphone';

  @override
  String get notifBlocked => 'Les notifications sont désactivées';

  @override
  String get notifBlockedHint =>
      'Touchez pour les autoriser, sinon rien ne vous parviendra';

  @override
  String get notifSendTest => 'Envoyer une notification de test';

  @override
  String get notifSendTestHint =>
      'Envoyée depuis notre serveur, comme les rappels';

  @override
  String get notifSending => 'Envoi…';

  @override
  String get notifTestSent =>
      'Envoyée. Elle devrait apparaître dans quelques secondes, ainsi que dans votre boîte de réception.';

  @override
  String notifTestFailed(String reason) {
    return 'Envoi impossible : $reason';
  }

  @override
  String get notifTestOffline => 'pas de connexion au serveur';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant vous enverra chaque jour un petit rappel pour noter vos dépenses, à l\'heure choisie. L\'appli doit pouvoir afficher des notifications.';

  @override
  String get notifPrimerShow => 'Afficher les notifications de rappel';

  @override
  String get notifPrimerTime => 'À l\'heure de votre choix';

  @override
  String get notifPrimerOff => 'Désactivable à tout moment';

  @override
  String get notifPrimerAllow => 'Autoriser';

  @override
  String get cardBillsTitle => 'Relevés de carte';

  @override
  String get cardBillsSubtitle =>
      'Relevés de carte de crédit, échéances et rappels';

  @override
  String get cardBillsEmptyTitle => 'Aucune carte de crédit';

  @override
  String get cardBillsEmptyBody =>
      'Ajoutez un compte de type Carte de crédit, définissez son jour de relevé et d\'échéance, et ses relevés apparaîtront ici.';

  @override
  String get cardBillsAddCard => 'Ajouter une carte';

  @override
  String get cardStatementDay => 'Jour du relevé';

  @override
  String get cardStatementDayHint =>
      'Le jour du mois où le relevé est établi. Tout ce qui précède la fin de ce jour y figure.';

  @override
  String get cardDueDay => 'Jour d\'échéance';

  @override
  String get cardDueDayHint =>
      'Le dernier jour pour payer le relevé, la première fois que ce jour revient après le relevé.';

  @override
  String get cardRemindTitle => 'Me le rappeler';

  @override
  String get cardRemindHint =>
      'Avant l\'échéance, s\'il reste une partie à payer. Envoyé vers 9 h.';

  @override
  String get cardRemindOff => 'Désactivé';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours avant',
      one: 'La veille',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Non défini';

  @override
  String cardDayOfMonth(int day) {
    return 'Le $day';
  }

  @override
  String get cardSetUpBody =>
      'Définissez le jour du relevé et le jour d\'échéance pour voir les relevés de cette carte et recevoir un rappel avant l\'échéance.';

  @override
  String get cardSetUp => 'Définir les dates';

  @override
  String cardDueBy(String date) {
    return 'Reste à payer avant le $date';
  }

  @override
  String get cardLeftToPay => 'Reste à payer';

  @override
  String cardStatementClosed(String date) {
    return 'Relevé du $date';
  }

  @override
  String get cardPaidSince => 'Payé depuis';

  @override
  String cardThisCycle(String date) {
    return 'Dépensé depuis, prochain relevé le $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'Paiement du relevé $card';
  }

  @override
  String get cardEdit => 'Modifier la carte';

  @override
  String get cardEarlierStatements => 'RELEVÉS PRÉCÉDENTS';

  @override
  String get cardPaidShort => 'payé';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount impayés';
  }

  @override
  String get cardStatusNotSetUp => 'Dates non définies';

  @override
  String get cardStatusNothingDue => 'Rien à payer';

  @override
  String get cardStatusPaid => 'Payé';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'À payer dans $days jours',
      one: 'À payer demain',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'À payer aujourd\'hui';

  @override
  String get cardStatusOverdue => 'En retard';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid payés sur $owed';
  }

  @override
  String get cardPayBill => 'Payer le relevé';

  @override
  String cardPayTitle(String card) {
    return 'Payer $card';
  }

  @override
  String get cardPayHint =>
      'Payez tout ou une partie. Tout paiement est déduit de ce relevé, et le reste reste dû.';

  @override
  String cardPayFull(String amount) {
    return 'Payer la totalité, $amount';
  }

  @override
  String get cardPayFullHint => 'Tout ce qui reste sur ce relevé';

  @override
  String get cardPayOther => 'Payer un autre montant';

  @override
  String get cardPayOtherHint => 'Un paiement partiel, ou plus que le relevé';

  @override
  String get addNoteHint => 'Ajouter une note';

  @override
  String get addRepeatMonthly => 'Répéter chaque mois';

  @override
  String get addMoreOptions => 'Plus d\'options';

  @override
  String get addScanReceipt => 'Scanner un ticket';

  @override
  String get addDelete => 'Supprimer l\'opération';

  @override
  String get addTypeExpense => 'Dépense';

  @override
  String get addTypeIncome => 'Revenu';

  @override
  String get addTypeTransfer => 'Virement';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Débloquer avec Premium';

  @override
  String get gateFootnote => 'À vie ou abonnement · Restauration à tout moment';

  @override
  String get aiCoachTitle => 'Découvrez votre coach financier';

  @override
  String get aiCoachBody =>
      'Posez vos questions simplement. Obtenez réponses, conseils et plans fondés sur vos propres dépenses.';

  @override
  String get aiAssistantTitle => 'Assistant IA';

  @override
  String get aiAskAnything => 'Une question sur votre argent…';

  @override
  String get aiSend => 'Envoyer';

  @override
  String get aiCopy => 'Copier';

  @override
  String get aiCopied => 'Copié';

  @override
  String get aiRetry => 'Réessayer';

  @override
  String get aiDismiss => 'Ignorer';

  @override
  String get aiTyping => 'Le coach écrit';

  @override
  String aiStarterCategory(String category) {
    return 'Où est passé mon argent en $category ?';
  }

  @override
  String get aiStarterBudgets => 'Est-ce que je respecte mes budgets ?';

  @override
  String get aiStarterUpcoming => 'Quelles factures arrivent bientôt ?';

  @override
  String get aiStarterAnalyze => 'Analyse mes dépenses récentes';

  @override
  String get aiStarterBudgetTips =>
      'Donne-moi des conseils pour mieux budgéter';

  @override
  String get aiStarterSave => 'Comment épargner davantage ?';

  @override
  String aiDeleteChatBody(String title) {
    return '« $title » sera définitivement supprimée.';
  }

  @override
  String get aiJustNow => 'À l\'instant';

  @override
  String get aiErrorTitle => 'Le coach n\'a pas pu répondre';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'Tout ce que l\'appli sait faire, pour vous.';

  @override
  String get paywallActiveTitle => 'Premium est actif';

  @override
  String get paywallActiveTagline => 'Merci pour votre soutien !';

  @override
  String get paywallRestore => 'Restaurer';

  @override
  String get paywallProcessing => 'Traitement…';

  @override
  String paywallTriggered(String feature) {
    return '$feature est une fonctionnalité Premium';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String get paywallFeatSync => 'Synchro cloud';

  @override
  String get paywallFeatSyncSub => 'Tous vos appareils';

  @override
  String get paywallFeatAi => 'Assistant IA';

  @override
  String get paywallFeatAiSub => 'Illimité, sans pub';

  @override
  String get paywallFeatOcr => 'Scan de tickets';

  @override
  String get paywallFeatOcrSub => 'OCR par IA';

  @override
  String get paywallFeatInsights => 'Analyse des dépenses';

  @override
  String get paywallFeatInsightsSub => 'Tendances mensuelles';

  @override
  String get paywallFeatThemes => '5 thèmes';

  @override
  String get paywallFeatThemesSub => 'Exclusifs';

  @override
  String get paywallFeatPdf => 'Rapports PDF';

  @override
  String get paywallFeatPdfSub => 'CSV reste gratuit';

  @override
  String get paywallFeatUnlimited => 'Illimité';

  @override
  String get paywallFeatUnlimitedSub => 'Portefeuilles, budgets';

  @override
  String get paywallFeatSupport => 'Aide prioritaire';

  @override
  String get paywallFeatSupportSub => 'Réponses plus rapides';

  @override
  String get paywallPerMonth => '/mois';

  @override
  String get paywallPerYear => '/an';

  @override
  String get paywallOnce => 'une fois';

  @override
  String get paywallBestValue => 'MEILLEUR PRIX';

  @override
  String get paywallForever => 'À VIE';

  @override
  String get paywallMonthlyDesc => 'Facturé chaque mois';

  @override
  String get paywallYearlyDesc => 'Facturé chaque année';

  @override
  String get paywallLifetimeDesc => 'Payez une fois, gardez-le pour toujours';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial gratuit, puis $rest';
  }

  @override
  String get paywallCtaLifetime => 'Obtenir l\'accès à vie';

  @override
  String get paywallCtaYearly => 'Démarrer la formule annuelle';

  @override
  String get paywallCtaMonthly => 'Démarrer la formule mensuelle';

  @override
  String get paywallFootLifetime => 'Achat unique · Sans abonnement';

  @override
  String get paywallFootSubscription =>
      'Renouvellement automatique · Résiliable à tout moment dans le store';

  @override
  String get paywallTerms =>
      'Les abonnements sont facturés sur votre compte App Store ou Google Play et se renouvellent automatiquement, sauf résiliation au moins 24 heures avant la fin de la période en cours.';

  @override
  String get paywallIapUnavailable =>
      'Les achats intégrés sont indisponibles sur cet appareil. Vérifiez que les services Google Play sont installés et que l\'appli provient du Play Store.';

  @override
  String get paywallLoadingPlans => 'Chargement des formules…';

  @override
  String get paywallPlansFailed =>
      'Impossible de charger les formules. Vérifiez votre connexion et réessayez.';

  @override
  String get paywallTryAgain => 'Réessayer';

  @override
  String get paywallRestored => 'Achats restaurés';

  @override
  String get paywallPurchased => 'Bienvenue dans Premium !';

  @override
  String get paywallLifetimeNever => 'L\'accès à vie n\'expire jamais';

  @override
  String get helpSearchQuestions => 'Rechercher une question';

  @override
  String get helpStepWallets => 'Ajoutez des portefeuilles';

  @override
  String get helpStepCategories => 'Choisissez des catégories';

  @override
  String get helpStepTrack => 'Suivez au quotidien';

  @override
  String get splashTagline => 'L\'argent, plus clair.';

  @override
  String get introStep1 => 'On compte vos pièces…';

  @override
  String get introStep2 => 'On réveille vos portefeuilles…';

  @override
  String get introStep3 => 'On peaufine les graphiques…';

  @override
  String get introStep4 => 'Presque prêt…';

  @override
  String get introTipLabel => 'Astuce finances';

  @override
  String get introTip1 =>
      'Payez-vous en premier : mettez de côté le jour où votre salaire tombe.';

  @override
  String get introTip2 =>
      'Les petites dépenses quotidiennes s\'accumulent. Les noter, c\'est déjà la moitié du chemin.';

  @override
  String get introTip3 =>
      'Une épargne de précaution de 3 mois transforme les imprévus en simples contretemps.';

  @override
  String get introTip4 =>
      'Passez vos abonnements en revue chaque mois : résiliez ce que vous n\'utilisez pas.';

  @override
  String get introTip5 =>
      'Donnez une mission à chaque centime avant le début du mois.';

  @override
  String get introTip6 => 'Attendez 24 heures avant tout achat imprévu.';

  @override
  String get introTip7 =>
      'Un budget n\'est pas une limite, c\'est la permission de dépenser pour ce qui compte.';

  @override
  String get introTip8 =>
      'Fêtez les petites victoires : chaque objectif commence par un premier dépôt.';

  @override
  String get adConfirmTitleAiCall => 'Obtenir une requête IA de plus';

  @override
  String get adConfirmTitleTheme =>
      'Essayer les thèmes Premium pendant 24 heures';

  @override
  String get adConfirmTitlePdf => 'Exporter un rapport PDF';

  @override
  String get adConfirmBodyAiCall =>
      'Vous avez utilisé vos requêtes IA gratuites du mois. Regardez une courte pub et obtenez-en une de plus.';

  @override
  String get adConfirmBodyTheme =>
      'Regardez une courte pub et tous les thèmes Premium sont à vous pendant 24 heures.';

  @override
  String get adConfirmBodyPdf =>
      'Regardez une courte pub pour exporter un rapport PDF.';

  @override
  String get adConfirmWarning =>
      'Vous allez regarder une publicité. Continuer ?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Encore $count pubs disponibles ce mois-ci',
      one: 'Encore 1 pub disponible ce mois-ci',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Les membres Premium ont l\'IA illimitée, tous les thèmes et les rapports PDF, sans aucune pub.';

  @override
  String get adWatch => 'Regarder la pub';

  @override
  String get adGetPremium => 'Obtenir Premium';

  @override
  String get adNotNow => 'Pas maintenant';

  @override
  String get adLoading => 'Chargement de la pub…';

  @override
  String get adVerifying => 'Confirmation de votre récompense…';

  @override
  String get adUnavailable =>
      'Aucune pub disponible pour le moment. Réessayez un peu plus tard.';

  @override
  String get adSkipped =>
      'La pub a été fermée avant la fin, rien n\'a été débloqué.';

  @override
  String get adRewardAiCall =>
      'C\'est fait ! Vous avez une requête IA de plus.';

  @override
  String get adRewardTheme => 'Thèmes Premium débloqués pendant 24 heures.';

  @override
  String get adRewardPdf => 'Un export PDF débloqué.';

  @override
  String get adMonthlyCapReached =>
      'C\'est tout pour les pubs ce mois-ci. Vos requêtes gratuites reviennent le 1er, ou passez à Premium pour l\'illimité.';

  @override
  String get adRewardPending =>
      'Merci ! Votre récompense va apparaître dans un instant.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requêtes IA gratuites restantes ce mois-ci',
      one: '1 requête IA gratuite restante ce mois-ci',
      zero: 'Plus aucune requête IA gratuite ce mois-ci',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium : illimité';

  @override
  String get aiToolSearching => 'Recherche dans vos opérations…';

  @override
  String get aiToolSummarizing => 'Calcul des totaux…';

  @override
  String get aiToolAccounts => 'Vérification de vos comptes…';

  @override
  String get aiToolCategories => 'Examen de vos catégories…';

  @override
  String get aiToolCards => 'Vérification des relevés de carte…';

  @override
  String get aiToolPlans => 'Vérification des mensualités et de l\'épargne…';

  @override
  String get aiToolSaving => 'Enregistrement…';

  @override
  String get aiActionAddTitle => 'Ajouter cette opération ?';

  @override
  String get aiActionUpdateTitle => 'Modifier cette opération ?';

  @override
  String get aiActionDeleteTitle => 'Supprimer cette opération ?';

  @override
  String get aiActionPayCardTitle => 'Payer un relevé de carte';

  @override
  String get aiActionCardSettingsTitle => 'Modifier les dates de la carte';

  @override
  String get aiActionCreatePlanTitle => 'Démarrer un plan';

  @override
  String get aiActionPayPlanTitle => 'Enregistrer un versement';

  @override
  String get aiActionClosePlanTitle => 'Clôturer un plan par anticipation';

  @override
  String get aiActionUpdatePlanTitle => 'Modifier un plan';

  @override
  String get aiActionCreateInvestmentTitle => 'Ajouter un investissement';

  @override
  String get aiActionTradeInvestmentTitle => 'Enregistrer une transaction';

  @override
  String get aiActionUpdateInvestmentTitle => 'Mettre à jour un cours';

  @override
  String get aiActionConfirm => 'Confirmer';

  @override
  String get aiActionClosePlan => 'Clôturer';

  @override
  String get aiActionFrom => 'De';

  @override
  String get aiActionTo => 'Vers';

  @override
  String get aiActionBill => 'Relevé';

  @override
  String get aiActionLeftAfter => 'Reste après';

  @override
  String get aiActionRemindDays => 'Rappel, jours avant';

  @override
  String get aiActionPay => 'Payer';

  @override
  String get plansTitle => 'Mensualités, prêts et épargne';

  @override
  String get investmentsTitle => 'Investissements';

  @override
  String get investmentsSubtitle =>
      'Fonds, actions et versements programmés, valorisés au dernier cours';

  @override
  String get forecastTitle => 'Prévision de trésorerie';

  @override
  String get forecastSubtitle =>
      'Où va votre argent en espèces et en banque, et les jours où il manquera';

  @override
  String forecastRangeDays(int days) {
    return '$days jours';
  }

  @override
  String get forecastNow => 'Espèces et banque aujourd\'hui';

  @override
  String get forecastMoneyIn => 'Entrées';

  @override
  String get forecastMoneyOut => 'Sorties';

  @override
  String get forecastLowest => 'Minimum';

  @override
  String forecastLowestOn(String date) {
    return 'le $date';
  }

  @override
  String get forecastChartTitle => 'Solde prévisionnel';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'Le $date, il vous manquerait $amount';
  }

  @override
  String get forecastShortfallCause => 'Sorties ce jour-là :';

  @override
  String get forecastAlreadyShort =>
      'Vos comptes espèces et bancaires sont déjà en dessous de zéro.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'Aucun découvert dans les $days prochains jours';
  }

  @override
  String get forecastAllCoveredBody =>
      'Ce qui est prévu est couvert par votre argent en espèces et en banque.';

  @override
  String get forecastScheduledOnly =>
      'Ne compte que ce qui est programmé : plans, relevés de carte, abonnements, paiements récurrents et à venir, et prêts avec échéance. Les dépenses courantes ne sont pas incluses.';

  @override
  String get forecastEventsTitle => 'À venir';

  @override
  String forecastDayBalance(String amount) {
    return 'Solde $amount';
  }

  @override
  String get forecastEmptyTitle => 'Rien de programmé';

  @override
  String get forecastEmptyBody =>
      'Les plans, relevés de carte, abonnements et paiements à venir de cette période s\'affichent ici.';

  @override
  String get forecastOverdue => 'En retard';

  @override
  String get forecastExpected => 'Prévu';

  @override
  String get forecastEventWhen => 'Quand';

  @override
  String get forecastEventKind => 'Type';

  @override
  String get forecastEventAccount => 'Compte';

  @override
  String get forecastEventOpen => 'Ouvrir';

  @override
  String get forecastEventOverdueNote =>
      'Sa date est passée et il reste ouvert, il est donc compté comme dû aujourd\'hui.';

  @override
  String get forecastKindInstallment => 'Mensualité';

  @override
  String get forecastKindPremium => 'Prime';

  @override
  String get forecastKindDeposit => 'Versement';

  @override
  String get forecastKindSipBuy => 'Achat programmé';

  @override
  String get forecastKindProfit => 'Bénéfice';

  @override
  String get forecastKindMaturity => 'Échéance';

  @override
  String get forecastKindCardBill => 'Relevé de carte';

  @override
  String get forecastKindCardBillNext => 'Prochain relevé, à ce jour';

  @override
  String get forecastKindSubscription => 'Abonnement';

  @override
  String get forecastKindRecurringBill => 'Paiement récurrent';

  @override
  String get forecastKindRecurringIncome => 'Revenu récurrent';

  @override
  String get forecastKindUpcoming => 'À venir';

  @override
  String get forecastKindBorrowed => 'Prêt à rembourser';

  @override
  String get forecastKindLent => 'Prêté, à récupérer';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'Il pourrait vous manquer $amount le $date';
  }

  @override
  String get forecastHomeWarningBody => 'Voir ce qui arrive';

  @override
  String get forecastDismiss => 'Ignorer';

  @override
  String forecastNotifTitle(String day) {
    return 'Vous pourriez manquer d\'argent le $day';
  }

  @override
  String get settingsBillReminders => 'Rappels de relevés et de mensualités';

  @override
  String get settingsBillRemindersSub =>
      'Relevés de carte à payer, et mensualités ou versements d\'épargne à venir';

  @override
  String get forecastNotifNowTitle =>
      'Il vous manque de l\'argent aujourd\'hui';

  @override
  String forecastNotifNowBody(String amount) {
    return 'Ce qui est dû maintenant dépasse de $amount ce que contiennent vos comptes. Touchez pour voir ce qui arrive.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Les paiements programmés vous laisseraient à découvert de $amount. Touchez pour voir ce qui arrive.';
  }

  @override
  String get investmentsEmptyTitle => 'Aucun investissement';

  @override
  String get investmentsEmptyBody =>
      'Suivez un fonds, des actions ou de l\'or : ce que vous avez payé, ce que ça vaut aujourd\'hui, et la plus-value.';

  @override
  String get investmentsSold => 'Vendus';

  @override
  String get investmentsWorth => 'Valeur actuelle';

  @override
  String get investmentNew => 'Nouvel investissement';

  @override
  String get investmentNewHint =>
      'Des parts de fonds, des actions d\'une société, ou tout ce qui s\'achète à l\'unité, comme l\'or au gramme.';

  @override
  String get investmentKindFund => 'Fonds';

  @override
  String get investmentKindStock => 'Actions';

  @override
  String get investmentKindOther => 'Autre';

  @override
  String get investmentNameHintFund => 'ex. : UCB Income Plus Fund';

  @override
  String get investmentNameHintStock => 'ex. : Grameenphone';

  @override
  String get investmentNameHintOther => 'ex. : Or, 22 carats';

  @override
  String get investmentSymbol => 'Symbole ou code (facultatif)';

  @override
  String get investmentFirstBuy => 'Ce que vous avez acheté';

  @override
  String get investmentFirstBuyHint =>
      'Laissez le montant vide pour l\'ajouter sans rien acheter pour l\'instant.';

  @override
  String get investmentPaid => 'Payé';

  @override
  String get investmentReceived => 'Reçu';

  @override
  String get investmentPaidInto => 'Versé sur';

  @override
  String get investmentFee => 'Frais ou commission';

  @override
  String get investmentUnits => 'Parts';

  @override
  String get investmentUnitsSold => 'Parts vendues';

  @override
  String investmentUnitsShort(String units) {
    return '$units parts';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price la part';
  }

  @override
  String get investmentNeedUnits =>
      'Indiquez combien de parts ont été achetées.';

  @override
  String get investmentSave => 'Ajouter l\'investissement';

  @override
  String get investmentAdded => 'Investissement ajouté';

  @override
  String get investmentGone => 'Cet investissement a été supprimé.';

  @override
  String get netWorthSubtitle =>
      'Tout ce que vous possédez, moins ce que vous devez, et son évolution';

  @override
  String get netWorthToday => 'Votre patrimoine';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount depuis le mois dernier';
  }

  @override
  String get netWorthBreakdown => 'Sa composition';

  @override
  String get netWorthCash => 'Espèces et banque';

  @override
  String get netWorthCards => 'Cartes de crédit';

  @override
  String get netWorthDeposits => 'Dépôts d\'épargne';

  @override
  String get netWorthAssets => 'Biens';

  @override
  String get netWorthLent => 'Prêté à d\'autres';

  @override
  String get netWorthBorrowed => 'Emprunté';

  @override
  String get netWorthLoansNote =>
      'L\'argent prêté compte comme le vôtre jusqu\'à son remboursement, et l\'argent emprunté compte contre vous jusqu\'à ce que vous le remboursiez.';

  @override
  String get netWorthCardsLeftOut =>
      'Les cartes de crédit ne sont pas comptées ; modifiable dans les Paramètres.';

  @override
  String get netWorthHistory => 'À chaque fin de mois';

  @override
  String get netWorthSixMonths => '6 mois';

  @override
  String get netWorthOneYear => '1 an';

  @override
  String get netWorthAllTime => 'Tout';

  @override
  String get netWorthHistoryEmpty =>
      'La courbe commence dès qu\'un mois s\'est terminé avec vos enregistrements.';

  @override
  String get assetNew => 'Ajouter un bien';

  @override
  String get assetNewHint =>
      'Un terrain, un appartement ou une maison, une voiture, de l\'or ou tout autre bien. Sa valeur compte dans votre patrimoine.';

  @override
  String get assetKind => 'De quoi s\'agit-il';

  @override
  String get assetKindLand => 'Terrain';

  @override
  String get assetKindHome => 'Appartement ou maison';

  @override
  String get assetKindCar => 'Véhicule';

  @override
  String get assetKindGold => 'Or et bijoux';

  @override
  String get assetKindOther => 'Autre chose';

  @override
  String get assetNameHintLand => 'ex. : Terrain à Savar';

  @override
  String get assetNameHintHome => 'ex. : Appartement à Mirpur';

  @override
  String get assetNameHintCar => 'ex. : Toyota Axio';

  @override
  String get assetNameHintGold => 'ex. : Bijoux de mariage';

  @override
  String get assetNameHintOther => 'ex. : Appareil photo';

  @override
  String get assetWorthNow => 'Valeur actuelle';

  @override
  String get assetBoughtNow => 'Payé depuis un compte';

  @override
  String get assetBoughtNowHint =>
      'Désactivé : vous le possédez déjà, aucun argent ne bouge.';

  @override
  String get assetSave => 'Ajouter le bien';

  @override
  String get assetAdded => 'Bien ajouté';

  @override
  String get assetsEmptyTitle => 'Aucun bien pour l\'instant';

  @override
  String get assetsEmptyBody =>
      'Ajoutez un terrain, un logement, une voiture ou de l\'or pour voir votre patrimoine complet.';

  @override
  String get assetsSold => 'Vendus';

  @override
  String assetCostLine(String amount) {
    return 'Coût $amount';
  }

  @override
  String get assetUpdateValue => 'Mettre à jour la valeur';

  @override
  String get assetSell => 'Vendre';

  @override
  String get assetDelete => 'Retirer';

  @override
  String get assetValueUpdated => 'Valeur mise à jour';

  @override
  String get assetSold => 'Vendu, et l\'argent enregistré';

  @override
  String assetDeleteTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get assetDeleteBody =>
      'Il n\'est plus compté. Son historique reste dans vos enregistrements.';

  @override
  String get assetDeleted => 'Bien retiré';

  @override
  String get aiActionCreateAssetTitle => 'Ajouter un bien';

  @override
  String get aiActionUpdateAssetTitle => 'Mettre à jour la valeur d\'un bien';

  @override
  String get aiActionSellAssetTitle => 'Vendre un bien';

  @override
  String get investmentWorthNow => 'Valeur actuelle';

  @override
  String investmentGainLine(String gain) {
    return '$gain au total';
  }

  @override
  String get investmentPrice => 'Cours';

  @override
  String get investmentPutIn => 'Investi';

  @override
  String get investmentTakenOut => 'Retiré';

  @override
  String get investmentBuy => 'Acheter';

  @override
  String get investmentSell => 'Vendre';

  @override
  String investmentBuyTitle(String name) {
    return 'Acheter $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'Vendre $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Dividende de $name';
  }

  @override
  String get investmentDividend => 'Dividende';

  @override
  String get investmentRecordDividend => 'Enregistrer un dividende';

  @override
  String investmentHeldNow(String units) {
    return '$units parts détenues actuellement.';
  }

  @override
  String get investmentRecorded => 'Enregistré';

  @override
  String get investmentUpdatePrice => 'Mettre à jour le cours';

  @override
  String get investmentUpdatePriceHint =>
      'La valeur liquidative ou le cours du jour, pour une part';

  @override
  String get investmentPriceUpdated => 'Cours mis à jour';

  @override
  String get investmentStartSip => 'Démarrer des versements programmés';

  @override
  String get investmentStartSipHint =>
      'Acheter un montant fixe chaque mois, automatiquement';

  @override
  String get investmentHistory => 'Historique';

  @override
  String investmentBought(String units) {
    return '$units parts achetées';
  }

  @override
  String investmentSold(String units) {
    return '$units parts vendues';
  }

  @override
  String get investmentPriceRose => 'Le cours a monté';

  @override
  String get investmentPriceFell => 'Le cours a baissé';

  @override
  String get investmentUnitsUnknown =>
      'parts encore inconnues, touchez pour ajouter';

  @override
  String get investmentCorrectUnits => 'Parts de cette transaction';

  @override
  String get investmentCorrectUnitsHint =>
      'Telles qu\'indiquées sur le relevé de votre fonds ou courtier.';

  @override
  String get investmentUnitsCorrected => 'Parts corrigées';

  @override
  String get investmentDelete => 'Supprimer cet investissement';

  @override
  String investmentDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get investmentDeleteBody =>
      'Ses transactions restent dans votre historique. Possible uniquement une fois tout vendu.';

  @override
  String get investmentDeleted => 'Investissement supprimé';

  @override
  String get plansSubtitle =>
      'Paiements échelonnés, prêts, épargne, dépôts à terme, assurances, obligations et versements programmés, payés et encaissés à temps';

  @override
  String get planNew => 'Démarrer un plan';

  @override
  String get planNewTitle => 'Que démarrez-vous ?';

  @override
  String get plansEmptyTitle => 'Aucun paiement échelonné, prêt ou épargne';

  @override
  String get plansEmptyBody =>
      'Suivez un achat payé en plusieurs fois, un prêt, une épargne programmée ou un dépôt à terme. Les échéances sont enregistrées le jour prévu et vous êtes prévenu avant chacune.';

  @override
  String get plansEnded => 'Terminés';

  @override
  String get planKindEmi => 'Paiement échelonné';

  @override
  String get planKindLoan => 'Prêt';

  @override
  String get planKindDps => 'Épargne programmée';

  @override
  String get planKindFdr => 'Dépôt à terme';

  @override
  String get planKindInsurance => 'Assurance';

  @override
  String get planKindBond => 'Obligation ou bon';

  @override
  String get planKindSip => 'Versements programmés';

  @override
  String get planKindEmiHint =>
      'Un achat payé en plusieurs fois, depuis les espèces, un compte bancaire ou une carte';

  @override
  String get planKindLoanHint =>
      'De l\'argent emprunté et remboursé par mensualités, avec intérêts';

  @override
  String get planKindDpsHint =>
      'Épargnez un montant fixe chaque mois pendant une durée fixe, et récupérez-le avec un rendement';

  @override
  String get planKindFdrHint =>
      'Placez une somme en banque pour une durée fixe, avec un rendement mensuel, trimestriel ou à l\'échéance';

  @override
  String get planKindInsuranceHint =>
      'Un contrat avec une prime mensuelle, trimestrielle ou annuelle, et un capital versé à la fin s\'il y en a un';

  @override
  String get planKindBondHint =>
      'Une obligation ou un bon d\'épargne : une somme placée pour des années, avec un rendement mensuel, trimestriel ou à l\'échéance, après impôt';

  @override
  String get planKindSipHint =>
      'Une somme fixe investie chaque mois dans un fonds ou des actions, au dernier cours';

  @override
  String get planWeekly => 'Hebdomadaire';

  @override
  String get planMonthly => 'Mensuel';

  @override
  String get planQuarterly => 'Trimestriel';

  @override
  String get planHalfYearly => 'Semestriel';

  @override
  String get planYearly => 'Annuel';

  @override
  String get planMonths => 'Mois';

  @override
  String get planYears => 'Années';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount jusqu\'au $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved épargnés sur $total';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid payés sur $total';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Prochain : $amount le $date';
  }

  @override
  String get planStatusCompleted => 'Terminé';

  @override
  String get planStatusClosed => 'Clôturé';

  @override
  String get planStatusOverdue => 'En retard';

  @override
  String get planStatusRunning => 'En cours';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done sur $total';
  }

  @override
  String get planGone => 'Ce plan a été supprimé.';

  @override
  String get planAccount => 'Compte';

  @override
  String get planAccountEmi => 'Payé depuis';

  @override
  String get planAccountLoan => 'Reçu sur et payé depuis';

  @override
  String get planAccountSaving => 'Depuis le compte';

  @override
  String get planPrice => 'Prix';

  @override
  String get planBorrowed => 'Montant emprunté';

  @override
  String get planDeposited => 'Montant déposé';

  @override
  String get planDeposit => 'Chaque versement';

  @override
  String get planInstallment => 'Chaque échéance';

  @override
  String get planWorkedOut =>
      'Calculé à partir du prix, du taux et de la durée';

  @override
  String get planProgress => 'Effectué';

  @override
  String get planSavedSoFar => 'Épargné à ce jour';

  @override
  String get planPaidSoFar => 'Payé à ce jour';

  @override
  String get planLeft => 'Reste';

  @override
  String get planTotal => 'Au total';

  @override
  String get planInterestCharges => 'Intérêts et frais';

  @override
  String get planRate => 'Taux';

  @override
  String get planRateLabel => 'Taux % par an';

  @override
  String get planRateOptional => 'Facultatif';

  @override
  String get planPayout => 'Rendement versé';

  @override
  String get planPayoutMonthly => 'Chaque mois';

  @override
  String get planPayoutQuarterly => 'Tous les 3 mois';

  @override
  String get planPayoutAtMaturity => 'À l\'échéance';

  @override
  String get planMaturesOn => 'Échéance le';

  @override
  String get planMaturity => 'Remboursé à l\'échéance';

  @override
  String get planEstimated =>
      'Estimé d\'après le taux ; touchez pour saisir le montant de la banque';

  @override
  String get planHolding => 'Actuellement sur le dépôt';

  @override
  String get planEnds => 'Dernière échéance';

  @override
  String planTakeMaturity(String amount) {
    return 'Encaisser l\'échéance, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Enregistrer le rendement, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Payer l\'échéance $number maintenant, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Payer la prime $number maintenant, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Faire le versement $number maintenant, $amount';
  }

  @override
  String get planRecorded => 'Enregistré.';

  @override
  String get planSaved => 'Enregistré.';

  @override
  String get planPayOff => 'Rembourser par anticipation';

  @override
  String get planEncash => 'Retirer par anticipation';

  @override
  String get planSurrender => 'Racheter le contrat';

  @override
  String planSurrenderTitle(String name) {
    return 'Racheter $name ?';
  }

  @override
  String get planSurrenderBody =>
      'Les primes s\'arrêtent. Ce que l\'assureur reverse est enregistré comme revenu.';

  @override
  String get planSurrenderNothing => 'Rien n\'est reversé';

  @override
  String get planSurrenderValue => 'Saisir la valeur de rachat';

  @override
  String get planSurrenderValueLabel => 'Valeur de rachat';

  @override
  String get planStopSip => 'Arrêter les versements';

  @override
  String planStopSipTitle(String name) {
    return 'Arrêter $name ?';
  }

  @override
  String get planStopSipBody =>
      'Plus aucun achat. Ce qui a été acheté reste dans l\'investissement.';

  @override
  String get planSipStopped => 'Versements arrêtés';

  @override
  String get planSave => 'Enregistrer';

  @override
  String get planSurrendered => 'Contrat racheté';

  @override
  String planPayOffTitle(String name) {
    return 'Rembourser $name ?';
  }

  @override
  String get planPayOffHint =>
      'Un seul paiement pour le reste, et le plan prend fin.';

  @override
  String planPayOffLeft(String amount) {
    return 'Payer le reste, $amount';
  }

  @override
  String get planPayOffOther => 'Le prêteur a indiqué un autre montant';

  @override
  String planEncashTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get planEncashBody =>
      'Le montant du dépôt revient sur son compte, et le plan prend fin.';

  @override
  String get planEncashNoProfit => 'Retirer, sans rendement';

  @override
  String get planEncashWithProfit =>
      'Retirer, avec le rendement versé par la banque';

  @override
  String get planEncashed => 'Retiré. L\'argent est revenu sur son compte.';

  @override
  String get planPaidOff => 'Remboursé.';

  @override
  String get planAutoCollect => 'Enregistrer automatiquement';

  @override
  String get planAutoCollectHint =>
      'Chaque échéance, rendement et capital final est enregistré le jour prévu';

  @override
  String get planSchedule => 'ÉCHÉANCIER';

  @override
  String get planDelete => 'Supprimer ce plan';

  @override
  String planDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get planDeleteBody =>
      'Ce qu\'il a enregistré reste dans vos opérations. Plus rien ne sera enregistré ni rappelé.';

  @override
  String get planDeleted => 'Supprimé.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Échéance $number sur $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Prime $number sur $total';
  }

  @override
  String get planEventPayout => 'Versement du contrat';

  @override
  String planEventProfit(int number) {
    return 'Rendement, mois $number';
  }

  @override
  String get planEventMaturity => 'Échéance finale';

  @override
  String get planEventDone => 'Effectué';

  @override
  String get planEventLate => 'En retard';

  @override
  String get planEventUpcoming => 'À venir';

  @override
  String get planNeedAccount => 'Choisissez d\'abord un compte.';

  @override
  String get planCreated =>
      'Démarré. Tout ce qui était déjà dû a été enregistré.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, dont $interest d\'intérêts et frais.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, sans intérêts.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'Vous versez $deposited et récupérez environ $maturity le $date.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal devient environ $maturity d\'ici le $date.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return '$profit de rendement chaque mois, et $principal récupérés le $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count primes de $premium, $total au total.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count primes de $premium, $total au total, et $payout récupérés le $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return '$profit de rendement tous les trois mois, et $principal récupérés le $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount dans $fund, $total au total.';
  }

  @override
  String planNewKind(String kind) {
    return 'Nouveau : $kind';
  }

  @override
  String get planName => 'Nom';

  @override
  String get planNameHintEmi => 'ex. : Téléphone acheté sur Daraz';

  @override
  String get planNameHintLoan => 'ex. : Prêt moto';

  @override
  String get planNameHintDps => 'ex. : Épargne Brac';

  @override
  String get planNameHintFdr => 'ex. : Dépôt à terme City Bank';

  @override
  String get planNameHintInsurance => 'ex. : Assurance vie';

  @override
  String get planNameHintBond => 'ex. : Sanchayapatra 5 ans';

  @override
  String get planNameHintSip => 'ex. : Versement mensuel sur un fonds';

  @override
  String get planSipFund => 'Achète';

  @override
  String get planSipAmount => 'Chaque versement';

  @override
  String get planSipNoFund =>
      'Ajoutez d\'abord le fonds ou les actions dans Investissements.';

  @override
  String get planProvider => 'Banque ou société';

  @override
  String get planReference => 'N° de contrat ou de compte';

  @override
  String get planSumAssured => 'Capital assuré';

  @override
  String get planPremium => 'Prime';

  @override
  String get planPremiums => 'Primes';

  @override
  String get planTaxLabel => 'Retenue à la source %';

  @override
  String get planTax => 'Retenue à la source';

  @override
  String get planFirstPremium => 'Première prime';

  @override
  String get planLastPremium => 'Dernière prime';

  @override
  String get planInsurancePayout => 'Versé à la fin';

  @override
  String get planNone => 'Aucun';

  @override
  String get planHowMany => 'Combien';

  @override
  String get planTerm => 'Durée';

  @override
  String get planOpenedOn => 'Ouvert le';

  @override
  String get planFirstDue => 'Première échéance';

  @override
  String get planCategory => 'Catégorie';

  @override
  String get planCategoryDefault => 'Remboursement de prêt';

  @override
  String get planCategoryInsurance => 'Assurance';

  @override
  String get planLoanReceived => 'Argent reçu sur ce compte';

  @override
  String get planLoanReceivedHint =>
      'Désactivez s\'il est allé directement au vendeur';

  @override
  String get planStart => 'Démarrer';

  @override
  String get aiActionDeleteNote =>
      'Elle va dans « Supprimés récemment », où vous pouvez la restaurer pendant 30 jours.';

  @override
  String get aiActionAdd => 'Ajouter';

  @override
  String get aiActionSave => 'Enregistrer';

  @override
  String get aiActionDelete => 'Supprimer';

  @override
  String get aiActionCancel => 'Non, laisser';

  @override
  String get aiActionAmount => 'Montant';

  @override
  String get aiActionKind => 'Type';

  @override
  String get aiActionTitle => 'Titre';

  @override
  String get aiActionCategory => 'Catégorie';

  @override
  String get aiActionAccount => 'Compte';

  @override
  String get aiActionDate => 'Date';

  @override
  String get aiActionNotes => 'Notes';

  @override
  String get aiReport => 'Signaler un problème';

  @override
  String get aiReportWrongAnswer => 'Le coach s\'est trompé';

  @override
  String get aiReportWrongAnswerHint =>
      'Un chiffre faux, un fait inventé ou une modification que vous n\'avez pas demandée';

  @override
  String get aiReportWrongAnswerSubject => 'Coach financier : mauvaise réponse';

  @override
  String get aiReportBug => 'Signaler un bug';

  @override
  String get aiReportBugHint =>
      'Quelque chose a planté, s\'est figé ou ne s\'est pas chargé';

  @override
  String get aiReportBugSubject => 'Coach financier : rapport de bug';

  @override
  String get aiAboutCoach => 'Fonctionnement du coach';

  @override
  String get aiDisclaimerTitle => 'Avant d\'interroger le coach';

  @override
  String get aiDisclaimerMistakes =>
      'Le coach est une IA. Il peut se tromper sur un chiffre, mal comprendre une question ou affirmer quelque chose de faux : vérifiez tout ce qui est important dans vos propres opérations.';

  @override
  String get aiDisclaimerData =>
      'Vos chiffres sont lus sur votre téléphone. Pour répondre, l\'appli envoie votre question et les chiffres nécessaires à notre serveur et à son modèle d\'IA.';

  @override
  String get aiDisclaimerChanges =>
      'Il ne modifie jamais votre argent de lui-même. Chaque ajout, modification ou suppression vous est d\'abord présenté et n\'a lieu que si vous confirmez.';

  @override
  String get aiDisclaimerReport =>
      'Si une réponse semble fausse, touchez le drapeau en haut pour nous le signaler.';

  @override
  String get aiDisclaimerAccept => 'J\'ai compris';

  @override
  String get aiOutOfRequestsTitle =>
      'Vous avez utilisé vos requêtes gratuites du mois';

  @override
  String get aiOutOfRequestsBody =>
      'Regardez une courte pub pour poser cette question, ou passez à Premium pour des réponses illimitées sans pub. Les requêtes gratuites reviennent le 1er.';

  @override
  String get ocrNoCamera => 'Impossible d\'ouvrir l\'appareil photo.';

  @override
  String get ocrNoGallery => 'Impossible d\'ouvrir la galerie.';

  @override
  String get ocrScanTitle => 'Scanner un ticket';

  @override
  String get ocrScanAnother => 'En scanner un autre';

  @override
  String get ocrScanBody =>
      'Prenez une photo ou choisissez-en une. L\'appli la lit et l\'IA remplit les détails.';

  @override
  String get ocrReadingWithAi => 'L\'IA lit votre ticket…';

  @override
  String get ocrNothingRead =>
      'Aucun texte n\'a pu être lu sur cette photo. Réessayez avec une meilleure lumière, le ticket entier dans le cadre.';

  @override
  String get ocrAiOfferTitle => 'Laissez l\'IA le lire correctement';

  @override
  String get ocrAiOfferBody =>
      'Elle trouve le vrai total, la date, chaque article et la bonne catégorie, même sur un ticket difficile à lire.';

  @override
  String get ocrReadWithAi => 'Lire avec l\'IA';

  @override
  String get ocrReadByAi => 'Lu par l\'IA. Vérifiez avant d\'enregistrer.';

  @override
  String get ocrItems => 'Articles';

  @override
  String get quickAddTitle => 'Décrivez-la';

  @override
  String get quickAddSubtitle =>
      'Écrivez-la comme vous le diriez. L\'IA remplit le formulaire, à vous de vérifier.';

  @override
  String get quickAddHint => 'ex. : déjeuner 250 hier depuis bKash';

  @override
  String get quickAddFill => 'Remplir';

  @override
  String get summaryTitle => 'Bilan mensuel';

  @override
  String get summarySpent => 'Dépensé ce mois-ci';

  @override
  String summaryEarned(String amount) {
    return '$amount gagnés';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent % de moins que le mois dernier';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent % de plus que le mois dernier';
  }

  @override
  String get summaryAiTitle => 'Votre mois, en bref';

  @override
  String get summaryAiBody =>
      'L\'IA compare votre mois au précédent et relève ce qui ressort, avec une piste à essayer.';

  @override
  String get summaryWrite => 'Rédiger mon bilan';

  @override
  String get summaryOutdated =>
      'Vos opérations ont changé depuis la rédaction de ce bilan.';

  @override
  String get summaryUpdate => 'Mettre à jour mon bilan';

  @override
  String get summaryWriting => 'Rédaction de votre bilan…';

  @override
  String get summaryByCategory => 'Par catégorie';

  @override
  String get summaryNoSpending =>
      'Aucune dépense enregistrée ce mois-ci pour l\'instant.';

  @override
  String themeTrialUntil(String time) {
    return 'Thèmes Premium débloqués jusqu\'à $time';
  }

  @override
  String get zakatTitle => 'Zakat';

  @override
  String get zakatSubtitle =>
      'Calculez ce qui est dû sur votre patrimoine, et enregistrez ce que vous versez';

  @override
  String get zakatSubtitleOff =>
      'Vous ne versez pas la zakat. Touchez pour la calculer quand même';

  @override
  String get zakatAskTitle => 'Versez-vous la zakat ?';

  @override
  String get zakatAskBody =>
      'Tout le monde ne la verse pas. Si ce n\'est pas votre cas, l\'appli la laisse de côté : rien de dû et aucun rappel.';

  @override
  String get zakatIPay => 'Je verse la zakat';

  @override
  String get zakatIDontPay => 'Je ne verse pas la zakat';

  @override
  String get zakatOffTitle => 'Vous ne versez pas la zakat';

  @override
  String get zakatOffBody =>
      'Rien concernant la zakat n\'apparaît donc comme dû, et il n\'y a aucun rappel de zakat. Vous pouvez quand même voir à combien elle s\'élèverait, à tout moment ; regarder ne change pas votre réponse.';

  @override
  String get zakatOffPeek => 'Voir à combien elle s\'élèverait';

  @override
  String get zakatPeekBanner =>
      'Simple aperçu. Vous avez indiqué ne pas verser la zakat.';

  @override
  String get zakatOptOutTitle => 'Arrêter le suivi de la zakat ?';

  @override
  String get zakatOptOutBody =>
      'Rien n\'apparaîtra comme dû et il n\'y aura aucun rappel de zakat. Vos chiffres sont conservés, et vous pouvez les consulter ici à tout moment.';

  @override
  String get zakatDue => 'Zakat due';

  @override
  String zakatAboveNisab(String amount) {
    return 'Au-dessus du nisab : 2,5 % de $amount de patrimoine net';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'Sous le nisab de $amount, aucune zakat n\'est due';
  }

  @override
  String get zakatNeedPrice =>
      'Saisissez le prix au gramme pour vérifier le nisab';

  @override
  String get zakatPaidSoFar => 'Versé cette année';

  @override
  String get zakatLeftToPay => 'Reste à verser';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Date de zakat le $date, dans $days jours',
      one: 'Date de zakat demain, $date',
      zero: 'Votre date de zakat est aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Définissez votre date de zakat pour suivre l\'année et recevoir un rappel';

  @override
  String get zakatPay => 'Verser la zakat';

  @override
  String get zakatNisab => 'Nisab';

  @override
  String get zakatBasisGold => 'Or';

  @override
  String get zakatBasisSilver => 'Argent';

  @override
  String get zakatBasisHint =>
      'L\'argent donne le nisab le plus bas et c\'est le choix le plus prudent si votre patrimoine est surtout en liquide. Saisissez le prix local du jour pour un gramme.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Prix au gramme ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams g à ce prix';
  }

  @override
  String get zakatGroupCash => 'Espèces et banque';

  @override
  String get zakatGroupDeposits => 'Dépôts d\'épargne';

  @override
  String get zakatGroupInvestments => 'Investissements';

  @override
  String get zakatGroupMetals => 'Or et argent';

  @override
  String get zakatGroupLent => 'Argent prêté à d\'autres';

  @override
  String get zakatGroupOtherAssets => 'Autres biens';

  @override
  String get zakatGroupPaid => 'Zakat versée cette année';

  @override
  String get zakatGroupManual => 'Ajouté par vous';

  @override
  String get zakatGroupBorrowed => 'Moins : l\'argent que vous devez';

  @override
  String get zakatGroupCards => 'Moins : dettes de carte de crédit';

  @override
  String get zakatOtherAssetsNote =>
      'Un terrain, un logement ou une voiture que vous utilisez n\'est pas soumis à la zakat. N\'activez-en un que si vous le détenez pour le commerce.';

  @override
  String get zakatPaidNote =>
      'Réintégré, car il a quitté vos comptes après le calcul du patrimoine de l\'année.';

  @override
  String get zakatNoMetals =>
      'Aucun or ni argent enregistré. Ajoutez-le comme bien, ou ajoutez sa valeur ci-dessous.';

  @override
  String get zakatAddAmount => 'Ajouter un montant';

  @override
  String get zakatAmountLabel => 'De quoi s\'agit-il ?';

  @override
  String get zakatAmountHint => 'Stock commercial, liquide à la maison…';

  @override
  String get zakatAmountDeduct => 'C\'est une dette exigible';

  @override
  String get zakatWealth => 'Patrimoine soumis à la zakat';

  @override
  String get zakatDeductions => 'Dettes exigibles';

  @override
  String get zakatNet => 'Patrimoine net';

  @override
  String get zakatRate => '2,5 % du patrimoine net';

  @override
  String get zakatYear => 'Année de zakat';

  @override
  String get zakatDate => 'Date de zakat';

  @override
  String get zakatDateHint =>
      'Le jour où votre année de zakat s\'achève. Il revient chaque année lunaire, soit 354 jours.';

  @override
  String get zakatRemind => 'Me le rappeler';

  @override
  String get zakatRemindHint => '3 jours avant, et le jour même';

  @override
  String get zakatDisclaimer =>
      'Ceci est un guide pour vous aider à calculer la zakat, pas un avis religieux. Les savants divergent sur certains détails ; en cas de doute, consultez un savant local.';

  @override
  String get zakatPayNote =>
      'Enregistré comme dépense dans Zakat, et compté pour cette année.';

  @override
  String get zakatPayRecord => 'Enregistrer le versement';

  @override
  String get zakatPaidSnack => 'Zakat enregistrée';

  @override
  String get aiToolZakat => 'Calcul de la zakat…';

  @override
  String get voiceButton => 'Dicter une opération';

  @override
  String get voiceTitle => 'Dites-le';

  @override
  String get voiceUnlimited => 'Illimité';

  @override
  String get voiceTapToTalk =>
      'Touchez la bulle et dites ce que vous avez dépensé';

  @override
  String get voiceListening => 'Écoute…';

  @override
  String get voiceStop => 'Arrêter l\'écoute';

  @override
  String get voiceTypeInstead => 'Écrire';

  @override
  String get voiceSpeakInstead => 'Parler';

  @override
  String get voiceSend => 'Terminé';

  @override
  String get voiceTrySaying => 'Essayez de dire';

  @override
  String get voiceExample1 => 'Déjeuner 250, rickshaw 60';

  @override
  String get voiceExample2 => 'J\'ai reçu mon salaire, 45 000';

  @override
  String get voiceExample3 => 'Le thé d\'hier c\'était 30, pas 20';

  @override
  String get voiceExample4 => 'Supprime le déjeuner d\'aujourd\'hui';

  @override
  String get voiceTypeHint => 'Déjeuner 250 et rickshaw 60 depuis bKash';

  @override
  String get voiceThinking => 'Analyse en cours…';

  @override
  String get voiceTryAgain => 'Recommencer';

  @override
  String get voiceSaving => 'Enregistrement…';

  @override
  String get voiceEdit => 'Modifier';

  @override
  String get voiceNeedsYou => 'À compléter';

  @override
  String get voiceNew => 'Nouveau';

  @override
  String get voiceChange => 'Modification';

  @override
  String get voiceRemove => 'Suppression';

  @override
  String get voiceNeedsAmount =>
      'Aucun montant n\'a été dit. Complétez-le pour ajouter celle-ci.';

  @override
  String get voiceAdjust => 'Ajuster';

  @override
  String get voiceFillIn => 'Compléter';

  @override
  String get voiceTime => 'Heure';

  @override
  String get voiceUndo => 'Annuler';

  @override
  String get voiceUndone => 'Rétabli comme avant';

  @override
  String get voiceNoSpeech => 'Je n\'ai pas compris. Réessayez, ou écrivez-le.';

  @override
  String get voiceMicOff =>
      'L\'accès au micro est désactivé. Autorisez-le dans les Réglages, ou écrivez plutôt.';

  @override
  String get voiceUnavailable =>
      'La voix n\'est pas disponible sur ce téléphone. Vous pouvez écrire à la place.';

  @override
  String get voiceSomethingWrong => 'Une erreur s\'est produite. Réessayez.';

  @override
  String get voiceFabSetting => 'Micro flottant sur Aujourd\'hui';

  @override
  String get amountHidden => 'Montant masqué';

  @override
  String get privacyShowAmounts => 'Afficher les montants';

  @override
  String get privacyHideAmounts => 'Masquer les montants';

  @override
  String get privacyAmounts => 'Montants à l\'écran';

  @override
  String get privacyAmountsFooter =>
      'Les soldes et totaux sont floutés pour que votre entourage ne puisse pas les lire. Les opérations individuelles restent visibles. L\'œil sur Aujourd\'hui les affiche ou les masque aussi.';

  @override
  String get privacyHideTitle => 'Masquer soldes et totaux';

  @override
  String get privacyHideSub =>
      'Les flouter jusqu\'à ce que vous choisissiez de les afficher';

  @override
  String get privacyTapTitle => 'Toucher un montant masqué pour l\'afficher';

  @override
  String get privacyTapSub => 'Sinon, seul l\'œil sur Aujourd\'hui les affiche';

  @override
  String get privacyStartTitle => 'À l\'ouverture de l\'appli';

  @override
  String get privacyStartHidden => 'Masqués';

  @override
  String get privacyStartHiddenSub =>
      'Toujours ouvrir avec soldes et totaux masqués';

  @override
  String get privacyStartShown => 'Affichés';

  @override
  String get privacyStartShownSub =>
      'Toujours ouvrir avec soldes et totaux affichés';

  @override
  String get privacyStartRemember => 'Comme je l\'ai laissé';

  @override
  String get privacyStartRememberSub =>
      'Ouvrir selon le dernier état de l\'œil';

  @override
  String get privacyIntroTitle => 'Nouveau : masquez vos soldes';

  @override
  String get privacyIntroBody =>
      'Les soldes et totaux sont désormais masqués, pour que votre entourage ne puisse pas les lire. Touchez l\'œil sur Aujourd\'hui pour les afficher ou les masquer ; l\'appli s\'en souvient. Vous pouvez choisir l\'état à l\'ouverture dans les Paramètres.';

  @override
  String get privacyIntroOk => 'Compris';

  @override
  String get privacyIntroSettings => 'Choisir dans les Paramètres';

  @override
  String get voiceFabSettingSub =>
      'Un micro flottant sur Aujourd\'hui, pour dicter une opération';

  @override
  String get voiceFabAskTitle => 'Ajouter un micro à l\'écran Aujourd\'hui ?';

  @override
  String get voiceFabAskBody =>
      'Touchez-le et dites ce que vous avez dépensé, comme « déjeuner 250 et un rickshaw 60 ». Vous vérifiez tout avant l\'enregistrement. Déplacez-le où vous voulez.';

  @override
  String get voiceFabAskYes => 'Oui, ajouter le micro';

  @override
  String get voiceFabAskNo => 'Pas maintenant';

  @override
  String get voiceFabAskLater =>
      'Vous pouvez l\'activer ou le désactiver à tout moment dans Plus.';

  @override
  String get voiceFabHideTitle => 'Masquer le micro flottant ?';

  @override
  String get voiceFabHideBody =>
      'Le micro en haut d\'Aujourd\'hui reste. Vous pouvez réafficher celui-ci dans Plus.';

  @override
  String get voiceFabHide => 'Masquer';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRÊTES À ENREGISTRER',
      one: '1 PRÊTE À ENREGISTRER',
      zero: 'RIEN DE PRÊT',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Enregistrer $count',
      one: 'Enregistrer 1',
      zero: 'Rien de sélectionné',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations enregistrées',
      one: '1 opération enregistrée',
    );
    return '$_temp0';
  }
}
