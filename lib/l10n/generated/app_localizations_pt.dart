// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class L10nPt extends L10n {
  L10nPt([String locale = 'pt']) : super(locale);

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get dateToday => 'Hoje';

  @override
  String get dateYesterday => 'Ontem';

  @override
  String get dateTomorrow => 'Amanhã';

  @override
  String get navTransactions => 'Transações';

  @override
  String get settingsRegionalTitle => 'Definições regionais';

  @override
  String get settingsSectionCurrency => 'MOEDA';

  @override
  String get settingsSectionDisplayFormat => 'FORMATO DE EXIBIÇÃO';

  @override
  String get settingsSectionLanguage => 'IDIOMA';

  @override
  String get settingsDefaultCurrency => 'Moeda predefinida';

  @override
  String get settingsExchangeRates => 'Taxas de câmbio';

  @override
  String get settingsExchangeRatesSubtitle =>
      'Gerir as taxas de conversão de moeda';

  @override
  String get settingsDateFormat => 'Formato da data';

  @override
  String get settingsNumberFormat => 'Formato dos números';

  @override
  String get settingsCurrencySymbol => 'Símbolo da moeda';

  @override
  String get settingsTimeFormat => 'Formato da hora';

  @override
  String get settingsFirstDayOfWeek => 'Primeiro dia da semana';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsPreview => 'Pré-visualização';

  @override
  String get previewDate => 'Data';

  @override
  String get previewTime => 'Hora';

  @override
  String get previewAmount => 'Valor';

  @override
  String get previewWeekStarts => 'Esta semana começa';

  @override
  String get choiceMatchMyPhone => 'Igual ao telemóvel';

  @override
  String get symbolBeforeAmount => 'Antes do valor';

  @override
  String get symbolAfterAmount => 'Depois do valor';

  @override
  String get time12Hour => '12 horas (1:30 PM)';

  @override
  String get time24Hour => '24 horas (13:30)';

  @override
  String get weekdayMonday => 'Segunda-feira';

  @override
  String get weekdaySaturday => 'Sábado';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get selectDateFormat => 'Escolher formato da data';

  @override
  String get selectNumberFormat => 'Escolher formato dos números';

  @override
  String get selectCurrency => 'Escolher moeda';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get languageSystem => 'Igual ao telemóvel';

  @override
  String get sectionAccount => 'CONTA';

  @override
  String get sectionDataManagement => 'GESTÃO DE DADOS';

  @override
  String get sectionHelpSupport => 'AJUDA E SUPORTE';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsBackupRestore => 'Cópia de segurança e restauro';

  @override
  String get settingsBackupRestoreSubtitle =>
      'Um ficheiro que guarda ou cópias automáticas no Google Drive';

  @override
  String get settingsImportStatement => 'Importar um extrato';

  @override
  String get settingsImportStatementSubtitle =>
      'Traga um CSV do seu banco, mapeado uma vez e memorizado';

  @override
  String get settingsExportData => 'Exportar dados';

  @override
  String get settingsRecentlyDeleted => 'Eliminados recentemente';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'Recupere algo removido nos últimos trinta dias';

  @override
  String get themePremiumHeading => 'Temas Premium';

  @override
  String get actionRetry => 'Tentar de novo';

  @override
  String get dashCreditDebt => 'Crédito e dívida';

  @override
  String get dashSubscriptions => 'Subscrições';

  @override
  String get moneyIncome => 'Receitas';

  @override
  String get dashExpenses => 'Despesas';

  @override
  String get dashSpendingOverview => 'Resumo de gastos';

  @override
  String get dashBudgetProgress => 'Progresso do orçamento';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String txDeleteManyTitle(int count) {
    return 'Eliminar $count transações?';
  }

  @override
  String get txDeleteManyBody =>
      'Os saldos são recalculados. Qualquer transferência entre elas leva consigo a outra metade.';

  @override
  String get txMoveToAccount => 'Mover para conta';

  @override
  String get txDeleted => 'Transação eliminada';

  @override
  String txDeleteFailed(String error) {
    return 'Não foi possível eliminar essa transação: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count selecionadas';
  }

  @override
  String get txActions => 'Ações';

  @override
  String get txChangeCategory => 'Mudar categoria';

  @override
  String get txChangeDate => 'Mudar data';

  @override
  String get txMarkAsPaid => 'Marcar como paga';

  @override
  String get txMarkAsCorrection => 'Marcar como correção de saldo';

  @override
  String get txMarkAsCorrectionTitle => 'Não é receita nem gasto?';

  @override
  String get txMarkAsCorrectionBody =>
      'Use isto para dinheiro que não foi ganho nem gasto, como o aumento do limite de um cartão. O saldo mantém-se; apenas deixa de contar como receita ou gasto.';

  @override
  String get txMarkedAsCorrection => 'Agora é uma correção de saldo.';

  @override
  String get txMarkAsCorrectionFailed => 'Esta não pode ser uma correção.';

  @override
  String get txDuplicate => 'Duplicar';

  @override
  String get filterTitle => 'Filtrar';

  @override
  String get filterDirection => 'Sentido';

  @override
  String get filterState => 'Estado';

  @override
  String get filterKind => 'Tipo';

  @override
  String get filterTransfers => 'Transferências';

  @override
  String get filterAccounts => 'Contas';

  @override
  String get filterCategories => 'Categorias';

  @override
  String get filterDates => 'Datas';

  @override
  String get filterBudget => 'Orçamento';

  @override
  String get filterGoal => 'Objetivo';

  @override
  String get filterNone => 'Nenhum';

  @override
  String get filterThisMonth => 'Este mês';

  @override
  String get filterLastMonth => 'Mês passado';

  @override
  String get filterLast3Months => 'Últimos 3 meses';

  @override
  String get filterThisYear => 'Este ano';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count transações',
      one: 'Mostrar 1 transação',
      zero: 'Nenhuma transação corresponde',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'Limpar';

  @override
  String get filterNoMatches => 'Sem resultados';

  @override
  String get filterAny => 'Qualquer';

  @override
  String get filterSpent => 'Gasto';

  @override
  String get filterEarned => 'Ganho';

  @override
  String get filterHidden => 'Ocultas';

  @override
  String get filterIncluded => 'Incluídas';

  @override
  String get filterOnly => 'Apenas';

  @override
  String get filterFrom => 'De';

  @override
  String get filterTo => 'Até';

  @override
  String get actionApply => 'Aplicar';

  @override
  String get filterPaid => 'Pago';

  @override
  String get filterNotYet => 'Ainda não';

  @override
  String get filterSkipped => 'Ignorado';

  @override
  String get filterAmount => 'Valor';

  @override
  String get actionEdit => 'Editar';

  @override
  String get entityBudget => 'Orçamento';

  @override
  String get budgetGone => 'Este orçamento já não existe.';

  @override
  String get budgetEarlier => 'Anterior';

  @override
  String get budgetLater => 'Seguinte';

  @override
  String get budgetWhereItWent => 'Para onde foi';

  @override
  String get budgetRecentPeriods => 'Períodos recentes';

  @override
  String get budgetCaps => 'Limites';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get budgetNoCategoriesToCap =>
      'Este orçamento ainda não tem categorias para limitar.';

  @override
  String get budgetCapACategory => 'Limitar uma categoria';

  @override
  String get entityCategory => 'Categoria';

  @override
  String get budgetAsShare => 'Como parte do orçamento';

  @override
  String get budgetAsShareHint => 'Acompanha o orçamento quando o altera';

  @override
  String get actionSet => 'Definir';

  @override
  String get budgetAcrossPeriod => 'Ao longo do período';

  @override
  String get budgetPreviousPeriod => 'Período anterior';

  @override
  String get budgetEvenPace => 'Ritmo uniforme';

  @override
  String get budgetNew => 'Novo orçamento';

  @override
  String get budgetCreate => 'Criar um orçamento';

  @override
  String budgetDeleteTitle(String name) {
    return 'Eliminar $name?';
  }

  @override
  String get entityAccount => 'Conta';

  @override
  String get entityTransaction => 'Transação';

  @override
  String get walletGone => 'Esta conta já não existe.';

  @override
  String get walletCorrectBalance => 'Corrigir o saldo';

  @override
  String get walletCorrectBalanceSubtitle =>
      'Registar a diferença face ao valor real';

  @override
  String get walletMergeInto => 'Fundir noutra conta';

  @override
  String get walletInThisMonth => 'Entradas este mês';

  @override
  String get walletOutThisMonth => 'Saídas este mês';

  @override
  String get walletRecentActivity => 'Atividade recente';

  @override
  String get walletNoOtherAccount => 'Não há outra conta com que fundir.';

  @override
  String get walletMergeIntoTitle => 'Fundir em';

  @override
  String get walletMergeAction => 'Fundir';

  @override
  String walletMerged(int count, String target) {
    return '$count movidas para $target.';
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
      other: 'Foram removidas $removed transferências entre as duas contas',
      one: 'Foi removida uma transferência entre as duas contas',
    );
    return '$count movidas para $target. $_temp0, por já não ter duas pontas.';
  }

  @override
  String get walletRealBalance => 'Saldo real';

  @override
  String get walletCorrectAction => 'Corrigir';

  @override
  String get txGone => 'Esta transação já não existe.';

  @override
  String get txKind => 'Tipo';

  @override
  String get txState => 'Estado';

  @override
  String get txWasDue => 'Vencia em';

  @override
  String get txNotes => 'Notas';

  @override
  String get txDeleteOneTitle => 'Eliminar esta transação?';

  @override
  String get rulesTitle => 'Regras de nomes';

  @override
  String get rulesAdd => 'Adicionar regra';

  @override
  String rulesRemoved(String title) {
    return 'Regra de $title removida';
  }

  @override
  String get rulesWhenTitleSays => 'Quando o título diz';

  @override
  String get rulesMatchExactly => 'Correspondência exata';

  @override
  String get rulesChooseCategory => 'Escolher categoria';

  @override
  String get actionSave => 'Guardar';

  @override
  String get goalNew => 'Novo objetivo';

  @override
  String get goalLoadFailed => 'Não foi possível carregar os seus objetivos.';

  @override
  String get goalCreate => 'Criar um objetivo';

  @override
  String get trashTitle => 'Eliminados recentemente';

  @override
  String get trashRestore => 'Restaurar';

  @override
  String get trashRestored => 'Restaurado.';

  @override
  String get payTitle => 'Métodos de pagamento';

  @override
  String get payDefault => 'Predefinido';

  @override
  String get payAddOne => 'Adicionar um';

  @override
  String payDeleteTitle(String name) {
    return 'Eliminar $name?';
  }

  @override
  String get payName => 'Nome';

  @override
  String get payNameHint => 'Débito do dia a dia';

  @override
  String get payKind => 'Tipo';

  @override
  String get payBankOrIssuer => 'Banco ou emissor';

  @override
  String get payLastFour => 'Últimos quatro dígitos';

  @override
  String get payUseByDefault => 'Usar por predefinição';

  @override
  String get backupChecking => 'A verificar…';

  @override
  String get backupLoading => 'A carregar…';

  @override
  String get backupSaveACopy => 'Guardar uma cópia';

  @override
  String get backupAutomaticBackups => 'Cópias automáticas';

  @override
  String get backupHowManyBackupsToKeep => 'Quantas cópias manter';

  @override
  String get backupSaveABackupFile => 'Guardar ficheiro de cópia';

  @override
  String get backupShareItToFilesEmail =>
      'Partilhe para Ficheiros, e-mail ou onde preferir';

  @override
  String get backupRestoreFromAFile => 'Restaurar de um ficheiro';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'Substitui tudo o que está neste dispositivo';

  @override
  String get backupRestoreThisBackup => 'Restaurar esta cópia?';

  @override
  String get backupEraseRestore => 'Apagar e restaurar';

  @override
  String get backupGoogleDriveIsUnavailable =>
      'O Google Drive não está disponível';

  @override
  String get backupConnectGoogleDrive => 'Ligar o Google Drive';

  @override
  String get backupBackUpNow => 'Fazer cópia agora';

  @override
  String get backupKeep => 'Manter';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'A última cópia automática não foi executada';

  @override
  String get backupDisconnectGoogleDrive => 'Desligar o Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'Desligar o Google Drive?';

  @override
  String get backupDisconnect => 'Desligar';

  @override
  String get backupDeleteThisBackup => 'Eliminar esta cópia?';

  @override
  String get importChooseACsvFile => 'Escolher um ficheiro CSV';

  @override
  String get importRememberTheseSettingsForThis =>
      'Memorizar estas definições para este banco';

  @override
  String get importChange => 'Alterar';

  @override
  String get importAuto => 'Auto';

  @override
  String get importDone => 'Concluído';

  @override
  String get importRememberThisBank => 'Memorizar este banco';

  @override
  String get importForget => 'Esquecer';

  @override
  String get importImport => 'Importar';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsTermsOfService => 'Termos de serviço';

  @override
  String get settingsRefundPolicy => 'Política de reembolso';

  @override
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get settingsMeetTheDeveloper => 'Conheça o programador';

  @override
  String get settingsContactSupport => 'Contactar o suporte';

  @override
  String get settingsSubject => 'Assunto';

  @override
  String get settingsMessage => 'Mensagem';

  @override
  String get settingsSendMessage => 'Enviar mensagem';

  @override
  String get settingsUseApiRate => 'Usar taxa da API';

  @override
  String get settingsRefreshRates => 'Atualizar taxas';

  @override
  String get settingsSearchCurrencies => 'Pesquisar moedas...';

  @override
  String get settingsCustomRate => 'Taxa personalizada';

  @override
  String get settingsSetCustomRate => 'Definir taxa personalizada';

  @override
  String get settingsNotNow => 'Agora não';

  @override
  String get settingsGoPremium => 'Obter Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'Formato de folha de cálculo para Excel e Google Sheets';

  @override
  String get settingsPdfReport => 'Relatório PDF';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'Resumo formatado com detalhes';

  @override
  String get settingsAllIncomeAndExpenseRecords =>
      'Todos os registos de receitas e despesas';

  @override
  String get settingsCategories => 'Categorias';

  @override
  String get settingsCategoryBreakdownAndTotals =>
      'Detalhe e totais por categoria';

  @override
  String get settingsWallets => 'Carteiras';

  @override
  String get settingsWalletBalancesAndHistory =>
      'Saldos e histórico das carteiras';

  @override
  String get settingsHelpFaq => 'Ajuda e perguntas frequentes';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsLargeTransactionThreshold => 'Limite de transação elevada';

  @override
  String get settingsRemindMeBeforeDueDate => 'Lembrar antes do vencimento';

  @override
  String get settingsDailyReminders => 'LEMBRETES DIÁRIOS';

  @override
  String get settingsDailyReminders2 => 'Lembretes diários';

  @override
  String get settingsGetRemindedToTrackYour =>
      'Receba lembretes para registar as suas despesas';

  @override
  String get settingsBudgetAlerts => 'ALERTAS DE ORÇAMENTO';

  @override
  String get settingsBudgetAlerts2 => 'Alertas de orçamento';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'Avisar ao aproximar-se do limite do orçamento';

  @override
  String get settingsWarningThreshold => 'Limite de aviso';

  @override
  String get settingsTransactionAlerts => 'ALERTAS DE TRANSAÇÕES';

  @override
  String get settingsLargeTransactionAlerts => 'Alertas de transações elevadas';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'Avisar para transações acima do limite';

  @override
  String get settingsRecurringTransactionReminders =>
      'Lembretes de transações recorrentes';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'Lembrar pagamentos recorrentes próximos';

  @override
  String get settingsOtherNotifications => 'OUTRAS NOTIFICAÇÕES';

  @override
  String get settingsSubscriptionExpiryAlerts => 'Alertas de fim da subscrição';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'Seja avisado antes de o seu Premium expirar';

  @override
  String get settingsPromotionalNotifications => 'Notificações promocionais';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'Receber ofertas e novidades';

  @override
  String get settingsTurnOnDailyReminders => 'Ativar lembretes diários?';

  @override
  String get settingsEnterAmount => 'Introduza o valor';

  @override
  String get settingsReminderTime => 'Hora do lembrete';

  @override
  String get settingsPrivacySecurity => 'Privacidade e segurança';

  @override
  String get settingsSecurity => 'SEGURANÇA';

  @override
  String get settingsBiometricLock => 'Bloqueio biométrico';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'Use a impressão digital ou o rosto para desbloquear';

  @override
  String get settingsAutoLock => 'Bloqueio automático';

  @override
  String get settingsDataPrivacy => 'PRIVACIDADE DOS DADOS';

  @override
  String get settingsClearCache => 'Limpar cache';

  @override
  String get settingsClearCachedDataAndForce =>
      'Limpar dados em cache e forçar nova sincronização';

  @override
  String get settingsClearAllData => 'Limpar todos os dados';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'Eliminar todas as transações, orçamentos e definições';

  @override
  String get settingsDangerZone => 'ZONA DE PERIGO';

  @override
  String get settingsDeleteAccount => 'Eliminar conta';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'Eliminar permanentemente a sua conta e todos os dados';

  @override
  String get settingsAutoLockTimeout => 'Tempo do bloqueio automático';

  @override
  String get settingsDeleteEverything => 'Eliminar tudo';

  @override
  String get settingsAreYouAbsolutelySure => 'Tem a certeza absoluta?';

  @override
  String get settingsYesDeleteAll => 'Sim, eliminar tudo';

  @override
  String get settingsContinue => 'Continuar';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsDisplayName => 'Nome a mostrar';

  @override
  String get settingsEmailAddress => 'Endereço de e-mail';

  @override
  String get settingsUnsavedChanges => 'Alterações por guardar';

  @override
  String get settingsStay => 'Ficar';

  @override
  String get settingsLeave => 'Sair';

  @override
  String get settingsSearchByCodeOrName => 'Pesquisar por código ou nome...';

  @override
  String get settingsSearchSettings => 'Pesquisar definições...';

  @override
  String get settingsSubscription => 'Subscrição';

  @override
  String get settingsSignOut => 'Terminar sessão';

  @override
  String get settingsGoals => 'Objetivos';

  @override
  String get settingsCardsInNetWorth =>
      'Contar cartões de crédito no património';

  @override
  String get settingsCardsInNetWorthSub =>
      'Desligado: só conta o dinheiro que tem, não os saldos dos cartões.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'Poupe para algo e acompanhe o seu progresso';

  @override
  String get settingsBudgets => 'Orçamentos';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'Defina limites e veja como vai o período';

  @override
  String get settingsUpcomingAndOverdue => 'Próximos e em atraso';

  @override
  String get settingsWhatIsDueAndWhat => 'O que vence e o que ficou por pagar';

  @override
  String get settingsAccounts => 'Contas';

  @override
  String get settingsAddReorderAndEditYour =>
      'Adicione, reordene e edite as suas contas';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'Os cartões e contas com que paga';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'Para onde vai algo, com base no seu nome';

  @override
  String get settingsNotificationSettings => 'Definições de notificações';

  @override
  String get settingsCloudSync => 'Sincronização na nuvem';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'Sincronize os seus dados entre dispositivos';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV é grátis · Relatório PDF é Premium';

  @override
  String get settingsQuestionsComplaintsOrFeedback =>
      'Perguntas, reclamações ou sugestões';

  @override
  String get settingsRateTheApp => 'Avaliar a app';

  @override
  String get settingsShareWithFriends => 'Partilhar com amigos';

  @override
  String get settingsReplayAppTour => 'Rever a visita guiada';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'Veja de novo a apresentação das funcionalidades';

  @override
  String get settingsAboutTheAccountant => 'Sobre o The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'Versão, licenças e mais';

  @override
  String get settingsTestCrash => 'Falha de teste';

  @override
  String get settingsTriggerATestExceptionFor =>
      'Provocar uma exceção de teste para o Crashlytics';

  @override
  String get settingsDeveloper => 'PROGRAMADOR';

  @override
  String get settingsRestoreFromCloud => 'Restaurar da nuvem?';

  @override
  String get settingsSyncing => 'A sincronizar...';

  @override
  String get settingsSynced => 'Sincronizado';

  @override
  String get settingsSyncError => 'Erro de sincronização';

  @override
  String get syncBackgroundFailed =>
      'Não foi possível sincronizar. As suas alterações estão seguras neste dispositivo e serão sincronizadas mais tarde.';

  @override
  String get settingsOffline => 'Sem ligação';

  @override
  String get settingsReady => 'Pronto';

  @override
  String get settingsYesUseThis => 'Sim, usar isto';

  @override
  String get settingsKeepThemSeparate => 'Mantê-las separadas?';

  @override
  String get settingsCurrentPassword => 'Palavra-passe atual';

  @override
  String get settingsNewPassword => 'Nova palavra-passe';

  @override
  String get settingsConfirmPassword => 'Confirmar palavra-passe';

  @override
  String get walletEGPersonalSavingsBusiness =>
      'ex.: Pessoal, Poupança, Negócio';

  @override
  String get walletEnterCreditLimit => 'Introduza o limite de crédito';

  @override
  String get walletSelectBillingDay => 'Escolha o dia de faturação';

  @override
  String get walletCreateAccount => 'Criar conta';

  @override
  String get walletWalletCreatedSuccessfully => 'Carteira criada com sucesso';

  @override
  String get walletAccountUpdatedSuccessfully => 'Conta atualizada com sucesso';

  @override
  String get walletEditAccount => 'Editar conta';

  @override
  String get walletSetAsDefault => 'Definir como predefinida';

  @override
  String get walletUseDecimals => 'Usar decimais';

  @override
  String get walletEnterWalletName => 'Introduza o nome da carteira';

  @override
  String get walletCurrency => 'Moeda';

  @override
  String get walletIcon => 'Ícone';

  @override
  String get walletColor => 'Cor';

  @override
  String get walletWalletName => 'Nome da carteira';

  @override
  String get walletInitialBalance => 'Saldo inicial';

  @override
  String get txAddATransferFee => 'Adicionar taxa de transferência';

  @override
  String get txRemove => 'Remover';

  @override
  String get txPaymentMethod => 'Método de pagamento';

  @override
  String get txObjective => 'Finalidade';

  @override
  String get txTitle => 'Título';

  @override
  String get txTesco => 'Supermercado';

  @override
  String get txAll => 'Todas';

  @override
  String get txSkip => 'Ignorar';

  @override
  String get txMarkAsPaid2 => 'Marcar como paga';

  @override
  String get txConfirmPayment => 'Confirmar pagamento';

  @override
  String get txAmountCharged => 'Valor cobrado';

  @override
  String get txUndo => 'Desfazer';

  @override
  String get txNoLoan => 'Sem empréstimo';

  @override
  String get txLentMoney => 'Dinheiro emprestado a outros';

  @override
  String get txBorrowedMoney => 'Dinheiro pedido emprestado';

  @override
  String get goalShowOnTheHomeScreen => 'Mostrar no ecrã inicial';

  @override
  String get goalWhatAreYouSavingFor => 'Para que está a poupar?';

  @override
  String get goalNewLaptop => 'Portátil novo';

  @override
  String get goalTarget => 'Meta';

  @override
  String get goalColour => 'Cor';

  @override
  String get goalClear => 'Limpar';

  @override
  String get goalGoal => 'Objetivo';

  @override
  String get goalThisGoalNoLongerExists => 'Este objetivo já não existe.';

  @override
  String get goalAddToGoal => 'Adicionar ao objetivo';

  @override
  String get goalUnlink => 'Desassociar';

  @override
  String get reportUpgrade => 'Atualizar';

  @override
  String get budgetSpending => 'Gastos';

  @override
  String get budgetEarnings => 'Ganhos';

  @override
  String get budgetEvery => 'A cada';

  @override
  String get budgetCarryOverWhatIsLeft => 'Transitar o que sobrar';

  @override
  String get budgetGroceries => 'Mercearia';

  @override
  String get authLinkYourAccount => 'Associe a sua conta';

  @override
  String get authPassword => 'Palavra-passe';

  @override
  String get authLinkAccount => 'Associar conta';

  @override
  String get authEmailAddress => 'Endereço de e-mail';

  @override
  String get authSendResetCode => 'Enviar código de reposição';

  @override
  String get authResetCode => 'Código de reposição';

  @override
  String get authResetPassword => 'Repor palavra-passe';

  @override
  String get authWelcomeBack => 'Bem-vindo de volta';

  @override
  String get authSignInToContinueYour =>
      'Inicie sessão para continuar a sua jornada financeira';

  @override
  String get authSignIn => 'Iniciar sessão';

  @override
  String get authJoinUsToStartYour =>
      'Junte-se a nós para começar a sua jornada financeira';

  @override
  String get authFullName => 'Nome completo';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'Mensal';

  @override
  String get premiumYearly => 'Anual';

  @override
  String get premiumLifetime => 'Vitalício';

  @override
  String get premiumNotNow => 'Agora não';

  @override
  String get aiRename => 'Mudar o nome';

  @override
  String get aiRenameChat => 'Mudar o nome da conversa';

  @override
  String get aiDeleteChat => 'Eliminar conversa?';

  @override
  String get aiChatName => 'Nome da conversa';

  @override
  String get aiScanReceipt => 'Digitalizar recibo';

  @override
  String get aiCamera => 'Câmara';

  @override
  String get aiGallery => 'Galeria';

  @override
  String get aiMerchantTitle => 'Comerciante / título';

  @override
  String get aiSaveAsTransaction => 'Guardar como transação';

  @override
  String get onboardBrowseThemes => 'Ver temas';

  @override
  String get onboardBack => 'Voltar';

  @override
  String get onboardGetStarted => 'Começar';

  @override
  String get onboardMainAccount => 'Conta principal';

  @override
  String get creditRecordPayment => 'Registar pagamento';

  @override
  String get creditPleaseEnterAValidAmount => 'Introduza um valor válido';

  @override
  String get creditAmountExceedsRemainingBalance =>
      'O valor excede o saldo em falta';

  @override
  String get creditPaymentAmount => 'Valor do pagamento';

  @override
  String get creditPaidOn => 'Pago em';

  @override
  String get creditFullAmount => 'Valor total';

  @override
  String get subSubscriptionName => 'Nome da subscrição';

  @override
  String get subAskBeforeEachPayment =>
      'Perguntar antes de registar cada pagamento';

  @override
  String get subAskBeforeEachPaymentHint =>
      'Cada pagamento fica em Próximos até confirmar o valor cobrado, ou ignorá-lo. Ideal para cobranças variáveis, como um cartão pago noutra moeda.';

  @override
  String get subChangesApplyFromNext =>
      'Um novo valor ou conta aplica-se a partir do próximo pagamento. Os pagamentos já feitos ficam como estavam.';

  @override
  String get catPleaseEnterACategoryName =>
      'Introduza um nome para a categoria';

  @override
  String get catEnterCategoryName => 'Introduza o nome da categoria';

  @override
  String get catSearch => 'Pesquisar categorias';

  @override
  String get catNoMatch => 'Nenhuma categoria corresponde.';

  @override
  String get catUseEmoji => 'Usar um emoji';

  @override
  String get catEmojiHint => 'Escreva ou escolha um emoji';

  @override
  String get catArchive => 'Arquivar';

  @override
  String get catMergeInto => 'Fundir em…';

  @override
  String catMergeIntoTitle(String name) {
    return 'Fundir $name em';
  }

  @override
  String get catMergeBuiltIn => 'Integrada';

  @override
  String get catMergeNoTargets =>
      'Não há outra categoria do mesmo tipo com que fundir.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return 'Fundir $from em $to?';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'Todas as transações, orçamentos e subcategorias de $from passam para $to, e $from é removida. Isto sincroniza com os seus outros dispositivos.';
  }

  @override
  String get catMergeAction => 'Fundir';

  @override
  String catMerged(String from, String to) {
    return '$from fundida em $to.';
  }

  @override
  String get catExpenseSection => 'Categorias de despesa';

  @override
  String get catIncomeSection => 'Categorias de receita';

  @override
  String get catSectionEmpty => 'Ainda nenhuma';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subcategorias',
      one: '1 subcategoria',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações',
      one: '1 transação',
      zero: 'Sem transações',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'Em $name';
  }

  @override
  String get catAddSubcategory => 'Adicionar subcategoria';

  @override
  String get catNoSubcategoriesYet => 'Ainda sem subcategorias. Adicione uma';

  @override
  String get catMoveTo => 'Mover para…';

  @override
  String catMoveToTitle(String name) {
    return 'Mover $name para';
  }

  @override
  String get catTopLevel => 'Nível superior';

  @override
  String get catTopLevelHint => 'Fora de qualquer categoria';

  @override
  String catMovedInto(String name, String parent) {
    return '$name está agora em $parent.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name é agora uma categoria de nível superior.';
  }

  @override
  String get catMoveNoParents => 'Não há nenhuma categoria onde possa entrar.';

  @override
  String get catMoveTransactions => 'Mover transações…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'Mover as transações de $name para';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mover $count transações para $to?',
      one: 'Mover 1 transação para $to?',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'Só as transações são movidas. $from mantém-se, com os seus orçamentos e subcategorias. Isto sincroniza com os seus outros dispositivos.';
  }

  @override
  String get catMoveAction => 'Mover';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações movidas para $to.',
      one: '1 transação movida para $to.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name não tem transações para mover.';
  }

  @override
  String get catNoMoveTargets =>
      'Não há outra categoria do mesmo tipo para onde as mover.';

  @override
  String catDeleteTitle(String name) {
    return 'Eliminar $name?';
  }

  @override
  String get catDeleteEmptyBody =>
      'Não tem transações, por isso nada mais muda.';

  @override
  String get catDeleteChildrenNote =>
      'As suas subcategorias passam para o nível superior.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count transações nesta categoria. O que deve acontecer-lhes?',
      one: 'Há 1 transação nesta categoria. O que deve acontecer-lhe?',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'Mover para outra categoria';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'Depois, $name é eliminada. Os orçamentos que a usavam também passam.';
  }

  @override
  String get catDeleteThemToo => 'Eliminar também as transações';

  @override
  String get catDeleteThemTooHint =>
      'Vão para Eliminados recentemente, onde as pode restaurar durante 30 dias.';

  @override
  String catDeleted(String name) {
    return '$name eliminada.';
  }

  @override
  String get catActionFailed => 'Não foi possível fazer isso. Tente de novo.';

  @override
  String get catStaysTopLevel =>
      'Esta categoria tem subcategorias próprias, por isso fica no nível superior.';

  @override
  String get catUnarchive => 'Desarquivar';

  @override
  String get catArchivedSection => 'Arquivadas';

  @override
  String get catArchivedHint =>
      'Mantidas pelo histórico, mas não aparecem ao adicionar uma transação.';

  @override
  String get catNothingItsOwnCategory => 'Nenhuma — categoria própria';

  @override
  String get notifEnableNotifications => 'Ativar notificações';

  @override
  String get startupContinueWithoutChecking => 'Continuar sem verificar?';

  @override
  String get startupContinueOffline => 'Continuar sem ligação';

  @override
  String get startupViewSubscriptionOptions => 'Ver opções de subscrição';

  @override
  String get sharedWelcomeBack => 'Bem-vindo de volta';

  @override
  String get sharedRestoringYourDataFromThe =>
      'A restaurar os seus dados da nuvem…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return 'Fundir $source em $target?';
  }

  @override
  String get backupNothingHereYet => 'Ainda não há nada aqui.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'Aplicado automaticamente quando um ficheiro tem estas colunas';

  @override
  String get importDateFormat => 'Formato da data';

  @override
  String get importChooseOne => 'Escolha um';

  @override
  String get importDecimalPoint => 'Separador decimal';

  @override
  String get importFlipTheSigns => 'Inverter os sinais';

  @override
  String get importForExportsThatWriteA =>
      'Para exportações que escrevem um gasto como positivo';

  @override
  String get importWhereRowsGoWhenThe =>
      'Para onde vão as linhas quando o ficheiro não indica nenhuma conta sua';

  @override
  String get importSkipWhatIsAlreadyHere => 'Ignorar o que já existe';

  @override
  String get importCreateCategoriesTheFileNames =>
      'Criar as categorias indicadas no ficheiro';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'Caso contrário, essas linhas chegam sem categoria';

  @override
  String get importCategoriesInThisFile => 'Categorias neste ficheiro';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'Feito com carinho para as finanças pessoais';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'Desenvolvido e mantido por:';

  @override
  String get settingsPrantaDutta => 'Pranta Dutta';

  @override
  String get settingsClose => 'Fechar';

  @override
  String get settingsGetInTouch => 'Entre em contacto';

  @override
  String get settingsAsAPremiumMemberYour =>
      'Como membro Premium, o seu pedido tem prioridade.';

  @override
  String get settingsWhatToInclude => 'O que incluir';

  @override
  String get settingsNoCurrenciesFound => 'Nenhuma moeda encontrada';

  @override
  String get settingsExportYourFinancialDataTo =>
      'Exporte os seus dados financeiros para analisar noutras apps ou guardar como cópia de segurança.';

  @override
  String get settingsDateRange => 'Intervalo de datas';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'Relatórios PDF';

  @override
  String get settingsGettingStarted => 'Primeiros passos';

  @override
  String get settingsStillNeedHelp => 'Ainda precisa de ajuda?';

  @override
  String get settingsOurSupportTeamIsHere =>
      'A nossa equipa de suporte está aqui para ajudar';

  @override
  String get settingsAppLocked => 'App bloqueada';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'Desbloqueie para aceder ao The Accountant';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'Configure quando e como o The Accountant deve lembrá-lo de registar as suas despesas.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'O seu e-mail serve para iniciar sessão e não pode ser alterado aqui.';

  @override
  String get settingsYourDataIsOnThis =>
      'Os seus dados estão só neste dispositivo';

  @override
  String get settingsUpgradeForCloudSync =>
      'Atualize para sincronizar na nuvem';

  @override
  String get settingsNoSettingsFound => 'Nenhuma definição encontrada';

  @override
  String get settingsTryADifferentSearchTerm =>
      'Experimente outro termo de pesquisa';

  @override
  String get settingsSyncStatus => 'ESTADO DA SINCRONIZAÇÃO';

  @override
  String get settingsSyncNow => 'Sincronizar agora';

  @override
  String get settingsRestoreFromCloud2 => 'Restaurar da nuvem';

  @override
  String get settingsPro => 'PRO';

  @override
  String get settingsNeedsYourConfirmation => 'PRECISA DA SUA CONFIRMAÇÃO';

  @override
  String get walletCreateYourFirstAccount => 'Crie a sua primeira conta';

  @override
  String get walletYouNeedAtLeastOne =>
      'Precisa de pelo menos uma conta para começar a acompanhar as suas finanças';

  @override
  String get walletAccountType => 'Tipo de conta';

  @override
  String get walletAccountName => 'Nome da conta';

  @override
  String get walletCreditLimit => 'Limite de crédito';

  @override
  String get walletCreditLimitHelp =>
      'O limite subiu? Altere-o aqui. Um novo limite não é receita.';

  @override
  String get walletAmountOwed => 'Valor em dívida';

  @override
  String get walletAmountOwedHelp =>
      'O que deve no cartão neste momento. Use 0 se estiver pago.';

  @override
  String get walletCurrentBalance => 'Saldo atual';

  @override
  String get walletCurrentBalanceHelp =>
      'Uma alteração é guardada como correção de saldo, para que o histórico continue a bater certo.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return 'O que é $amount neste cartão?';
  }

  @override
  String get walletCardBalanceCreditLeft => 'Crédito que me resta';

  @override
  String get walletCardBalanceOwed => 'O que devo';

  @override
  String get walletCardBalanceChoose =>
      'Escolha o que este valor representa, para que a dívida seja calculada corretamente.';

  @override
  String get walletBillingCycleDayOptional =>
      'Dia do ciclo de faturação (opcional)';

  @override
  String get walletThisWillBeYourDefault => 'Esta será a sua conta predefinida';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'Ainda nada registado nesta conta.';

  @override
  String get walletAddAccount => 'Adicionar conta';

  @override
  String get walletYourAccounts => 'As suas contas';

  @override
  String get walletNoAccountsYet => 'Ainda sem contas';

  @override
  String get walletOutstanding => 'Em dívida';

  @override
  String get walletAvailable => 'Disponível';

  @override
  String get walletLimit => 'Limite';

  @override
  String get walletBalance => 'Saldo';

  @override
  String get walletUseThisWalletForNew =>
      'Usar esta carteira para novas transações';

  @override
  String get walletSelectIcon => 'Escolher ícone';

  @override
  String get walletSelectColor => 'Escolher cor';

  @override
  String get txYouNeedAtLeast2 =>
      'Precisa de pelo menos 2 contas para fazer uma transferência';

  @override
  String get txNoAccountTitle => 'Não há conta onde registar isto';

  @override
  String get txNoAccountBody =>
      'Adicione uma conta, ou reabra uma fechada, e este formulário fica pronto a usar.';

  @override
  String get txNoAccountAction => 'Gerir contas';

  @override
  String get txDeleteTransaction => 'Eliminar transação';

  @override
  String get txAreYouSureYouWant =>
      'Tem a certeza de que quer eliminar esta transação?';

  @override
  String get txTransactionType => 'Tipo de transação';

  @override
  String get txTransferFee => 'Taxa de transferência';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'Cobrada à parte, para que a transferência em si fique equilibrada.';

  @override
  String get txDeductedFrom => 'Descontada de';

  @override
  String get txNoPaymentMethods => 'Sem métodos de pagamento';

  @override
  String get txNothingDeletedRecently => 'Nada eliminado recentemente';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'Tudo o que eliminar aparece aqui durante trinta dias.';

  @override
  String get txNoRulesYet => 'Ainda sem regras';

  @override
  String get txClearAll => 'Limpar tudo';

  @override
  String get txApplyFilters => 'Aplicar filtros';

  @override
  String get txUpcomingOverdue => 'Próximos e em atraso';

  @override
  String get txNew => 'Nova';

  @override
  String get txLoan => 'Empréstimo';

  @override
  String get goalStarted => 'Início';

  @override
  String get goalTargetDate => 'Data-alvo';

  @override
  String get goalWithADateTheGoal =>
      'Com uma data, o objetivo calcula quanto pôr de parte por dia.';

  @override
  String get goalCountedTowardThisGoal => 'Contado para este objetivo';

  @override
  String get goalGettingThere => 'Quase lá';

  @override
  String get goalSetATargetDateAnd =>
      'Defina uma data-alvo e isto calcula quanto pôr de parte.';

  @override
  String get reportSpendingInsights => 'Análise de gastos';

  @override
  String get reportNoSpendingDataForThis =>
      'Sem dados de gastos para este período';

  @override
  String get reportNoCategorySpendingData =>
      'Sem dados de gastos por categoria';

  @override
  String get reportNoSpendingDataAvailable => 'Sem dados de gastos disponíveis';

  @override
  String get reportBudgetVsActual => 'Orçamento vs real';

  @override
  String get reportNoActiveBudgets => 'Sem orçamentos ativos';

  @override
  String get reportCreateABudgetToTrack =>
      'Crie um orçamento para acompanhar os seus gastos';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'Está a gastar mais depressa do que passa o período.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'Nada registado neste período.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name, $spent de $limit usados';
  }

  @override
  String budgetAmountLeft(String amount) {
    return 'Restam $amount';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount acima';
  }

  @override
  String get budgetPeriodEnded => 'Período terminado';

  @override
  String get budgetPaceOver => 'Acima';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Faltam $days dias',
      one: 'Falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'Palavra-passe reposta com sucesso. Inicie sessão.';

  @override
  String get authResendCode => 'Reenviar código';

  @override
  String get authForgotPassword => 'Esqueceu-se da palavra-passe?';

  @override
  String get authOrContinueWith => 'Ou continue com';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authContinueWithApple => 'Continuar com Apple';

  @override
  String get authSignUp => 'Registar';

  @override
  String get authPleaseAcceptTheTermsAnd => 'Aceite os termos e condições';

  @override
  String get authPasswordStrength => 'Força da palavra-passe';

  @override
  String get authAlreadyHaveAnAccount => 'Já tem conta? ';

  @override
  String get authPersonalInformation => 'Informações pessoais';

  @override
  String get authUpgradeToPremium => 'Atualizar para Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'Desbloqueie orçamentos ilimitados, análises avançadas e mais!';

  @override
  String get authUpgradeNow => 'Atualizar agora';

  @override
  String get authPremiumMember => 'Membro Premium';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'A desfrutar de todas as funcionalidades Premium';

  @override
  String get authSaveChanges => 'Guardar alterações';

  @override
  String get authAreYouSureYouWant =>
      'Tem a certeza de que quer terminar sessão?';

  @override
  String get authChangeProfilePhoto => 'Mudar foto de perfil';

  @override
  String get authTakePhoto => 'Tirar foto';

  @override
  String get authUseYourCamera => 'Use a câmara';

  @override
  String get authChooseFromGallery => 'Escolher da galeria';

  @override
  String get authSelectAnExistingPhoto => 'Selecione uma foto existente';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'Foto selecionada! O envio estará disponível em breve.';

  @override
  String get authNameCannotBeEmpty => 'O nome não pode estar vazio';

  @override
  String get authProfileUpdatedSuccessfully => 'Perfil atualizado com sucesso!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'Privacidade e termos';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'Reveja isto antes de continuar.';

  @override
  String get premiumLimitReached => 'Limite atingido';

  @override
  String get aiChats => 'Conversas';

  @override
  String get aiNewChat => 'Nova conversa';

  @override
  String get aiNoConversationsYet => 'Ainda sem conversas';

  @override
  String get aiStartChattingAndYourThreads =>
      'Comece a conversar e as suas conversas aparecem aqui.';

  @override
  String get aiScanAReceipt => 'Digitalizar um recibo';

  @override
  String get aiReadingYourReceipt => 'A ler o seu recibo…';

  @override
  String get aiReviewSave => 'Rever e guardar';

  @override
  String get aiWeReadThisFromYour =>
      'Lemos isto do seu recibo — verifique e edite o que for preciso antes de guardar.';

  @override
  String get dashErrorLoadingFinancialData =>
      'Erro ao carregar os dados financeiros';

  @override
  String get dashNoSpendingDataYet => 'Ainda sem dados de gastos';

  @override
  String get dashManage => 'Gerir';

  @override
  String get dashAvailable => 'Disponível: ****';

  @override
  String get onboardWelcome => 'Bem-vindo!';

  @override
  String get onboardSelectYourDefaultCurrency =>
      'Escolha a sua moeda predefinida';

  @override
  String get onboardLoadingCurrencies => 'A carregar moedas...';

  @override
  String get onboardSetUpYourPrimaryWallet =>
      'Configure a sua carteira principal';

  @override
  String get onboardInitialBalanceOptional => 'Saldo inicial (opcional)';

  @override
  String get onboardYourAccountIsReadyTo => 'A sua conta está pronta a usar';

  @override
  String get onboardTipYouCanAddMore =>
      'Dica: pode adicionar mais contas com outras moedas a qualquer momento na secção Carteiras.';

  @override
  String get creditSettled => 'Liquidado';

  @override
  String get creditOverdue => 'Em atraso';

  @override
  String creditTabCredit(int count) {
    return 'Emprestado ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'Pedido ($count)';
  }

  @override
  String get creditNetOutstanding => 'Saldo líquido em aberto';

  @override
  String get creditAllSettled => 'Tudo liquidado';

  @override
  String get creditOthersOweYou => 'Devem-lhe';

  @override
  String get creditYouOweOthers => 'Deve a outros';

  @override
  String creditOverdueCount(int count) {
    return '$count em atraso';
  }

  @override
  String get creditEmptyAll => 'Nenhum dinheiro emprestado ou pedido';

  @override
  String get creditEmptyLent => 'Nenhum dinheiro emprestado';

  @override
  String get creditEmptyBorrowed => 'Nenhum dinheiro pedido emprestado';

  @override
  String get creditEmptyAllSettled => 'Está tudo liquidado.';

  @override
  String get creditEmptyHint =>
      'Registe dinheiro que emprestou ou pediu emprestado para saber quem deve a quem.';

  @override
  String get creditShowAll => 'Mostrar tudo';

  @override
  String get creditShowUnpaid => 'Mostrar só por pagar';

  @override
  String get creditMoneyLent => 'Dinheiro emprestado';

  @override
  String get creditMoneyBorrowed => 'Dinheiro pedido';

  @override
  String get creditTheyOweYou => 'Devem-lhe';

  @override
  String get creditYouOwe => 'Deve';

  @override
  String get creditCollected => 'Recebido';

  @override
  String creditPaidOf(String paid, String total) {
    return 'Pago $paid de $total';
  }

  @override
  String get creditRecord => 'Registar';

  @override
  String get subRecurring => 'Recorrente';

  @override
  String get subPaused => 'Em pausa';

  @override
  String get subAsksFirst => 'Pergunta antes';

  @override
  String get subFrequency => 'Frequência';

  @override
  String get notifMarkAllRead => 'Marcar tudo como lido';

  @override
  String get notifTryAgain => 'Tentar de novo';

  @override
  String get notifStayOnTopOfYour => 'Mantenha o controlo do seu dinheiro';

  @override
  String get notifNoNotificationsYet => 'Ainda sem notificações';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'Quando receber notificações, elas aparecem aqui.';

  @override
  String get startupNothingHasBeenChangedOr =>
      'Nada foi alterado nem eliminado.';

  @override
  String get sharedIncludeCryptoCurrencies => 'Incluir criptomoedas';

  @override
  String get sharedTotalBalance => 'Saldo total';

  @override
  String get heatmapTitle => 'Ritmo diário';

  @override
  String get heatmapSpentMore => 'Gastou mais';

  @override
  String get heatmapEarnedMore => 'Ganhou mais';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transações não são mostradas: não se conhece nenhuma taxa entre as moedas das suas contas e $currency',
      one:
          'Uma transação não é mostrada: não se conhece nenhuma taxa entre a moeda da sua conta e $currency',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet => 'Ainda nada registado neste período.';

  @override
  String get heatmapNetForRange => 'Saldo líquido neste intervalo';

  @override
  String get layoutTitle => 'Disposição do início';

  @override
  String get layoutSubtitle =>
      'Reordene o ecrã inicial ou oculte o que não usa';

  @override
  String get layoutExplain =>
      'Arraste para reordenar. O que for desligado mantém o seu lugar, por isso ao voltar a ligá-lo fica onde o deixou.';

  @override
  String get layoutReset => 'Repor predefinição';

  @override
  String get layoutAllHidden =>
      'Todas as secções estão ocultas. O ecrã inicial ficará vazio.';

  @override
  String get layoutSectionGreeting => 'Saudação';

  @override
  String get layoutSectionAccounts => 'Contas';

  @override
  String get layoutSectionQuickStats => 'Receitas e despesas';

  @override
  String get layoutSectionQuickLinks => 'Atalhos';

  @override
  String get layoutSectionSpendingChart => 'Resumo de gastos';

  @override
  String get layoutSectionRecent => 'Transações recentes';

  @override
  String get layoutSectionBudgets => 'Progresso dos orçamentos';

  @override
  String get layoutSectionGoals => 'Objetivos fixados';

  @override
  String get shortcutAddExpense => 'Adicionar despesa';

  @override
  String get shortcutAddIncome => 'Adicionar receita';

  @override
  String get shortcutScanReceipt => 'Digitalizar recibo';

  @override
  String get shortcutTransactions => 'Transações';

  @override
  String get backupBusySyncing =>
      'Está a decorrer uma sincronização. Aguarde que termine antes de restaurar.';

  @override
  String get appearanceTitle => 'Aparência';

  @override
  String get themeSunriseLight => 'Aurora claro';

  @override
  String get themeSunriseDark => 'Aurora escuro';

  @override
  String get themeMatchSystem => 'Igual ao sistema';

  @override
  String get themeMatchSystemHint =>
      'Alterna entre claro e escuro com o telemóvel';

  @override
  String get themeUnlockAll => 'Desbloquear todos os temas';

  @override
  String get themeProBadge => 'PRO';

  @override
  String get themeAccentSunrise => 'Aurora';

  @override
  String get themeAccentSapphire => 'Safira';

  @override
  String get themeAccentEmerald => 'Esmeralda';

  @override
  String get themeAccentRuby => 'Rubi';

  @override
  String get themeAccentAmethyst => 'Ametista';

  @override
  String get themeAccentGraphite => 'Grafite';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'Hoje';

  @override
  String get navAdd => 'Adicionar';

  @override
  String get navStats => 'Estatísticas';

  @override
  String get navMore => 'Mais';

  @override
  String get walkthroughTodayTitle => 'O seu dia num relance';

  @override
  String get walkthroughTodayBody =>
      'Património, o que ganhou e gastou e a atividade de hoje.';

  @override
  String get walkthroughAddTitle => 'Adicione em segundos';

  @override
  String get walkthroughAddBody =>
      'Toque em Adicionar para registar uma despesa, receita ou transferência.';

  @override
  String get walkthroughTransactionsTitle => 'As suas transações';

  @override
  String get walkthroughTransactionsBody =>
      'Todas as transações, mês a mês. Pesquise e filtre para encontrar qualquer coisa.';

  @override
  String get walkthroughStatsTitle => 'Veja para onde vai';

  @override
  String get walkthroughStatsBody =>
      'Gráficos por semana, mês e ano, por categoria.';

  @override
  String get walkthroughBellTitle => 'Fique a par';

  @override
  String get walkthroughBellBody =>
      'Os alertas de orçamento e lembretes aparecem aqui. Está tudo pronto!';

  @override
  String get walkthroughBalanceTitle => 'O seu património';

  @override
  String get walkthroughBalanceBody =>
      'Todas as carteiras somam aqui, com uma barra que mostra a divisão.';

  @override
  String get txTransfer => 'Transferência';

  @override
  String get txUncategorized => 'Sem categoria';

  @override
  String todayGoodMorning(String name) {
    return 'Bom dia, $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'Boa tarde, $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'Boa noite, $name';
  }

  @override
  String get todayGoodMorningPlain => 'Bom dia';

  @override
  String get todayGoodAfternoonPlain => 'Boa tarde';

  @override
  String get todayGoodEveningPlain => 'Boa noite';

  @override
  String get todayNetWorth => 'Património';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount este mês';
  }

  @override
  String get todayEarned => 'Ganho';

  @override
  String get todaySpent => 'Gasto';

  @override
  String get todayTitle => 'Hoje';

  @override
  String get todayRecent => 'Recentes';

  @override
  String get todayAllActivity => 'Toda a atividade';

  @override
  String get todayNothingYet => 'Ainda nada hoje';

  @override
  String get todayNothingYetBody =>
      'Toque em Adicionar para registar a primeira.';

  @override
  String todayMoreWallets(int count) {
    return '+$count mais';
  }

  @override
  String get todayCoachTitle => 'Pergunte ao seu consultor financeiro';

  @override
  String get todayCoachBody => 'Respostas e sugestões com base nos seus gastos';

  @override
  String get todayNotifications => 'Notificações';

  @override
  String get todayWithinBudget => 'Dentro do orçamento';

  @override
  String get todayOverBudget => 'Acima do orçamento';

  @override
  String get todayNetCredit => 'Crédito líquido';

  @override
  String get todayNetDebt => 'Dívida líquida';

  @override
  String get todayMonthly => 'Mensal';

  @override
  String get walletsTitle => 'Carteiras';

  @override
  String get walletsNew => 'Nova';

  @override
  String get walletsAddHint => 'Adicione banco, dinheiro, poupança…';

  @override
  String get walletsPlanning => 'Planeamento';

  @override
  String get walletsUpcoming => 'Próximos';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count a vencer · $amount';
  }

  @override
  String get walletsUpcomingNone => 'Nada a vencer em breve';

  @override
  String get walletsLendBorrow => 'Emprestar e pedir';

  @override
  String get splitTitle => 'Dividir uma conta';

  @override
  String get splitSubtitle =>
      'Divida uma conta com amigos; o que devem vai para Emprestar e pedir';

  @override
  String get splitWhatFor => 'Para que foi';

  @override
  String get splitTotal => 'Total';

  @override
  String get splitPeople => 'Pessoas';

  @override
  String get splitYou => 'Eu';

  @override
  String get splitIncludeMe => 'Tive uma parte';

  @override
  String get splitIncludeMeSub => 'Desligue se pagou só pelos outros';

  @override
  String get splitAddPerson => 'Adicionar pessoa';

  @override
  String get splitPersonName => 'Nome';

  @override
  String get splitKnownPeople => 'De Emprestar e pedir';

  @override
  String get splitRemove => 'Remover';

  @override
  String get splitPaidBy => 'Pago por';

  @override
  String get splitHow => 'Como dividir';

  @override
  String get splitEqual => 'Igualmente';

  @override
  String get splitExact => 'Valores';

  @override
  String get splitPercent => 'Percentagem';

  @override
  String get splitShares => 'Partes';

  @override
  String get splitYourShare => 'A sua parte';

  @override
  String get splitOwesYou => 'Deve-lhe';

  @override
  String splitYouOwe(String name) {
    return 'Deve a $name';
  }

  @override
  String get splitPaidTheBill => 'Pagou a conta';

  @override
  String splitSettlesWith(String name) {
    return 'Acerta contas com $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total da sua conta; $owed a receber de volta';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'Nada sai da sua conta agora; deve $amount a $name';
  }

  @override
  String get splitPercentLabel => 'Percentagem da conta';

  @override
  String get splitSave => 'Dividir';

  @override
  String get splitSaved => 'Divisão registada';

  @override
  String get splitNeedCategory => 'Escolha primeiro uma categoria.';

  @override
  String get splitThisBill => 'Dividir esta conta';

  @override
  String get splitThisBillSub =>
      'Com amigos; o que devem vai para Emprestar e pedir';

  @override
  String get splitPartOf => 'Conta dividida';

  @override
  String walletsOwedToYou(String amount) {
    return 'Devem-lhe $amount';
  }

  @override
  String walletsYouOwe(String amount) {
    return 'Deve $amount';
  }

  @override
  String get walletsAllSettled => 'Tudo liquidado';

  @override
  String get walletsGoals => 'Objetivos';

  @override
  String walletsGoalsSub(int count) {
    return '$count ativos';
  }

  @override
  String get walletsBudgets => 'Orçamentos';

  @override
  String get walletsSubscriptions => 'Subscrições';

  @override
  String get walletsTransfer => 'Transferir entre carteiras';

  @override
  String get walletsArchived => 'Arquivadas';

  @override
  String walletsDeleteMessage(String name) {
    return 'Eliminar “$name”? Todas as transações desta conta são eliminadas com ela.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name eliminada';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name é agora a sua predefinida';
  }

  @override
  String get walletsCreateFailed =>
      'Não foi possível criar a conta. Tente de novo.';

  @override
  String get walletsEmptyBody => 'Crie a sua primeira conta para começar.';

  @override
  String get walletsTypeBank => 'Conta bancária';

  @override
  String get walletsTypeCard => 'Cartão de crédito';

  @override
  String get walletsTypeCash => 'Dinheiro';

  @override
  String get walletsTypeOther => 'Conta';

  @override
  String get moreTitle => 'Mais';

  @override
  String get moreGoPremium => 'Obter Premium';

  @override
  String get moreGoPremiumBody =>
      'Assistente de IA, sincronização na nuvem, temas';

  @override
  String get moreUnlock => 'Desbloquear';

  @override
  String get morePremiumActive => 'Premium ativo';

  @override
  String get morePremiumThanks => 'Obrigado por apoiar o The Accountant';

  @override
  String get sectionPreferences => 'PREFERÊNCIAS';

  @override
  String get sectionTools => 'FERRAMENTAS';

  @override
  String get moreAiAssistant => 'Assistente de IA';

  @override
  String get moreAiAssistantSub => 'Faça perguntas sobre o seu dinheiro';

  @override
  String get moreSignOutConfirm => 'Terminar sessão neste dispositivo?';

  @override
  String get moreSignOutFailed =>
      'Não foi possível terminar sessão. Tente de novo.';

  @override
  String get moreDeviceOnlyBody =>
      'As contas gratuitas não têm cópia na nuvem, por isso reinstalar ou mudar de telemóvel pode fazer perder os dados. Atualize para sincronizar na nuvem ou exporte uma cópia com regularidade.';

  @override
  String get moreUpgradeToPremium => 'Atualizar para Premium';

  @override
  String get moreUser => 'Eu';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get statsWeek => 'Semana';

  @override
  String get statsMonth => 'Mês';

  @override
  String get statsYear => 'Ano';

  @override
  String get statsSpending => 'Gastos';

  @override
  String get statsIncome => 'Receitas';

  @override
  String get statsCategories => 'Categorias';

  @override
  String get statsSpent => 'Gasto';

  @override
  String get statsEarned => 'Ganho';

  @override
  String get statsNet => 'Líquido';

  @override
  String get statsThisMonth => 'Este mês';

  @override
  String statsVsLastMonth(String change) {
    return '$change face ao mês passado';
  }

  @override
  String get statsInsightsSub => 'Resumo do mês, tendências e dicas';

  @override
  String get statsAskCoach => 'Perguntar ao consultor de IA';

  @override
  String statsOverBy(String amount) {
    return 'Excedido em $amount';
  }

  @override
  String statsRemaining(String percent) {
    return 'Restam $percent%';
  }

  @override
  String get activityAll => 'Tudo';

  @override
  String get activitySpent => 'Gasto';

  @override
  String get activityEarned => 'Ganho';

  @override
  String get activityTransfers => 'Transferências';

  @override
  String activitySoFar(String month) {
    return '$month até agora';
  }

  @override
  String activityNet(String amount) {
    return '$amount líquido';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados em todos os meses',
      one: '1 resultado em todos os meses',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => 'Últimos 7 dias';

  @override
  String get statsPeriodThisMonth => 'Este mês';

  @override
  String get statsPeriodThisYear => 'Este ano';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações',
      one: '1 transação',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'Nada corresponde a “$query”';
  }

  @override
  String get activitySearchNothingBody =>
      'Todos os meses foram pesquisados. Tente menos palavras, outra grafia ou limpe um filtro.';

  @override
  String get activityIn => 'Entradas';

  @override
  String get activityOut => 'Saídas';

  @override
  String get activityToday => 'Hoje';

  @override
  String get activityYesterday => 'Ontem';

  @override
  String get activityTomorrow => 'Amanhã';

  @override
  String get activityEmptyFutureTitle => 'Sem transações planeadas';

  @override
  String activityEmptyFutureBody(String month) {
    return 'Adicione pagamentos futuros para $month';
  }

  @override
  String get activityEmptyNowTitle => 'Ainda sem transações';

  @override
  String get activityEmptyNowBody =>
      'Comece a registar as suas despesas deste mês';

  @override
  String get activityEmptyPastTitle => 'Nenhuma transação encontrada';

  @override
  String activityEmptyPastBody(String month) {
    return 'Sem registos para $month';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações eliminadas',
      one: '1 transação eliminada',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count movidas para $name';
  }

  @override
  String get activityMixedCurrencies =>
      'Estão em moedas diferentes, por isso não há uma conta para onde todas possam ir. Selecione linhas de uma só moeda.';

  @override
  String activityMovedPartial(int count) {
    return '$count movidas; as transferências ficaram onde estavam';
  }

  @override
  String activityMoved(int count) {
    return '$count movidas para outra conta';
  }

  @override
  String activityRedated(int count) {
    return 'Data alterada em $count';
  }

  @override
  String get activityNothingToPay => 'Nada estava à espera de pagamento';

  @override
  String activityMarkedPaid(int count) {
    return '$count marcadas como pagas';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count copiadas; as transferências não podem ser copiadas sozinhas';
  }

  @override
  String activityCopied(int count) {
    return '$count copiadas';
  }

  @override
  String get activityDeleteOneBody =>
      'Será removida dos seus registos e o saldo será recalculado.';

  @override
  String get activitySearch => 'Pesquisar';

  @override
  String get addNewExpense => 'Nova despesa';

  @override
  String get addNewIncome => 'Nova receita';

  @override
  String get addNewTransfer => 'Nova transferência';

  @override
  String get addEditTitle => 'Editar transação';

  @override
  String get addAmount => 'Valor';

  @override
  String get addCategory => 'Categoria';

  @override
  String get addMore => 'Mais';

  @override
  String get addWallet => 'Carteira';

  @override
  String addChangeDate(String date) {
    return 'Mudar data, $date';
  }

  @override
  String addChangeTime(String time) {
    return 'Mudar hora, $time';
  }

  @override
  String get addSwapAccounts => 'Trocar as duas contas';

  @override
  String get notifCheckTitle => 'Verificar notificações';

  @override
  String get notifAllowed => 'As notificações estão permitidas';

  @override
  String get notifAllowedHint => 'Os lembretes podem chegar a este telemóvel';

  @override
  String get notifBlocked => 'As notificações estão desligadas';

  @override
  String get notifBlockedHint => 'Toque para as permitir, senão nada lhe chega';

  @override
  String get notifSendTest => 'Enviar notificação de teste';

  @override
  String get notifSendTestHint =>
      'Enviada do nosso servidor, como chegam os lembretes';

  @override
  String get notifSending => 'A enviar…';

  @override
  String get notifTestSent =>
      'Enviada. Deve aparecer dentro de segundos, e também na caixa de entrada.';

  @override
  String notifTestFailed(String reason) {
    return 'Não foi possível enviar: $reason';
  }

  @override
  String get notifTestOffline => 'sem ligação ao servidor';

  @override
  String get notifDailyPrimerBody =>
      'O The Accountant enviará um lembrete diário discreto para registar os seus gastos, à hora que escolher. Precisa de permissão para mostrar notificações.';

  @override
  String get notifPrimerShow => 'Mostrar notificações de lembrete';

  @override
  String get notifPrimerTime => 'Chegam à hora escolhida';

  @override
  String get notifPrimerOff => 'Pode desligar isto quando quiser';

  @override
  String get notifPrimerAllow => 'Permitir';

  @override
  String get cardBillsTitle => 'Faturas do cartão';

  @override
  String get cardBillsSubtitle =>
      'Extratos de cartão de crédito, vencimentos e lembretes';

  @override
  String get cardBillsEmptyTitle => 'Ainda sem cartões de crédito';

  @override
  String get cardBillsEmptyBody =>
      'Adicione uma conta do tipo Cartão de crédito, defina o dia do extrato e o dia de vencimento, e as faturas aparecem aqui.';

  @override
  String get cardBillsAddCard => 'Adicionar cartão';

  @override
  String get cardStatementDay => 'Dia do extrato';

  @override
  String get cardStatementDayHint =>
      'O dia de cada mês em que a fatura é emitida. Tudo até ao fim desse dia entra nela.';

  @override
  String get cardDueDay => 'Dia de vencimento';

  @override
  String get cardDueDayHint =>
      'O último dia para pagar a fatura, na primeira vez que esse dia chega depois do extrato.';

  @override
  String get cardRemindTitle => 'Lembrar-me';

  @override
  String get cardRemindHint =>
      'Antes do vencimento, se parte da fatura ainda estiver por pagar. Enviado por volta das 9h.';

  @override
  String get cardRemindOff => 'Desligado';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias antes',
      one: 'Na véspera',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'Não definido';

  @override
  String cardDayOfMonth(int day) {
    return 'Dia $day';
  }

  @override
  String get cardSetUpBody =>
      'Defina o dia do extrato e o dia de vencimento para ver as faturas deste cartão e ser lembrado antes de vencerem.';

  @override
  String get cardSetUp => 'Definir as datas';

  @override
  String cardDueBy(String date) {
    return 'Falta pagar até $date';
  }

  @override
  String get cardLeftToPay => 'Falta pagar';

  @override
  String cardStatementClosed(String date) {
    return 'Extrato de $date';
  }

  @override
  String get cardPaidSince => 'Pago desde então';

  @override
  String cardThisCycle(String date) {
    return 'Gasto desde então, próximo extrato $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'Pagamento da fatura $card';
  }

  @override
  String get cardEdit => 'Editar cartão';

  @override
  String get cardEarlierStatements => 'EXTRATOS ANTERIORES';

  @override
  String get cardPaidShort => 'pago';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount por pagar';
  }

  @override
  String get cardStatusNotSetUp => 'Datas não definidas';

  @override
  String get cardStatusNothingDue => 'Nada a pagar';

  @override
  String get cardStatusPaid => 'Paga';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vence daqui a $days dias',
      one: 'Vence amanhã',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'Vence hoje';

  @override
  String get cardStatusOverdue => 'Em atraso';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid de $owed pagos';
  }

  @override
  String get cardPayBill => 'Pagar fatura';

  @override
  String cardPayTitle(String card) {
    return 'Pagar $card';
  }

  @override
  String get cardPayHint =>
      'Pague tudo ou parte. Tudo o que pagar conta para esta fatura e o resto continua por pagar.';

  @override
  String cardPayFull(String amount) {
    return 'Pagar tudo, $amount';
  }

  @override
  String get cardPayFullHint => 'Tudo o que falta nesta fatura';

  @override
  String get cardPayOther => 'Pagar outro valor';

  @override
  String get cardPayOtherHint =>
      'Um pagamento parcial, ou mais do que a fatura';

  @override
  String get addNoteHint => 'Adicionar nota';

  @override
  String get addRepeatMonthly => 'Repetir mensalmente';

  @override
  String get addMoreOptions => 'Mais opções';

  @override
  String get addScanReceipt => 'Digitalizar recibo';

  @override
  String get addDelete => 'Eliminar transação';

  @override
  String get addTypeExpense => 'Despesa';

  @override
  String get addTypeIncome => 'Receita';

  @override
  String get addTypeTransfer => 'Transferência';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'Desbloquear com Premium';

  @override
  String get gateFootnote => 'Vitalício ou subscrição · Restaure quando quiser';

  @override
  String get aiCoachTitle => 'Conheça o seu consultor financeiro';

  @override
  String get aiCoachBody =>
      'Pergunte por palavras simples. Receba respostas, sugestões e planos com base nos seus gastos.';

  @override
  String get aiAssistantTitle => 'Assistente de IA';

  @override
  String get aiAskAnything => 'Pergunte sobre o seu dinheiro…';

  @override
  String get aiSend => 'Enviar';

  @override
  String get aiCopy => 'Copiar';

  @override
  String get aiCopied => 'Copiado';

  @override
  String get aiRetry => 'Tentar de novo';

  @override
  String get aiDismiss => 'Dispensar';

  @override
  String get aiTyping => 'O consultor está a escrever';

  @override
  String aiStarterCategory(String category) {
    return 'Para onde foi o meu dinheiro de $category?';
  }

  @override
  String get aiStarterBudgets => 'Estou a cumprir os meus orçamentos?';

  @override
  String get aiStarterUpcoming => 'Que contas estão para chegar?';

  @override
  String get aiStarterAnalyze => 'Analise os meus padrões de gastos recentes';

  @override
  String get aiStarterBudgetTips => 'Dê-me dicas para orçamentar melhor';

  @override
  String get aiStarterSave => 'Como posso poupar mais dinheiro?';

  @override
  String aiDeleteChatBody(String title) {
    return '“$title” será eliminada permanentemente.';
  }

  @override
  String get aiJustNow => 'Agora mesmo';

  @override
  String get aiErrorTitle => 'O consultor não conseguiu responder';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'Tudo o que a app sabe fazer, para si.';

  @override
  String get paywallActiveTitle => 'Premium ativo';

  @override
  String get paywallActiveTagline => 'Obrigado pelo seu apoio!';

  @override
  String get paywallRestore => 'Restaurar';

  @override
  String get paywallProcessing => 'A processar…';

  @override
  String paywallTriggered(String feature) {
    return '$feature é uma funcionalidade Premium';
  }

  @override
  String paywallDaysRemaining(int days) {
    return 'Faltam $days dias';
  }

  @override
  String get paywallFeatSync => 'Sincronização';

  @override
  String get paywallFeatSyncSub => 'Todos os dispositivos';

  @override
  String get paywallFeatAi => 'Assistente de IA';

  @override
  String get paywallFeatAiSub => 'Ilimitado, sem anúncios';

  @override
  String get paywallFeatOcr => 'Digitalizar recibos';

  @override
  String get paywallFeatOcrSub => 'OCR com IA';

  @override
  String get paywallFeatInsights => 'Análise de gastos';

  @override
  String get paywallFeatInsightsSub => 'Tendências mensais';

  @override
  String get paywallFeatThemes => '5 temas';

  @override
  String get paywallFeatThemesSub => 'Exclusivos';

  @override
  String get paywallFeatPdf => 'Relatórios PDF';

  @override
  String get paywallFeatPdfSub => 'CSV continua grátis';

  @override
  String get paywallFeatUnlimited => 'Ilimitado';

  @override
  String get paywallFeatUnlimitedSub => 'Carteiras, orçamentos';

  @override
  String get paywallFeatSupport => 'Ajuda prioritária';

  @override
  String get paywallFeatSupportSub => 'Respostas mais rápidas';

  @override
  String get paywallPerMonth => '/mês';

  @override
  String get paywallPerYear => '/ano';

  @override
  String get paywallOnce => 'uma vez';

  @override
  String get paywallBestValue => 'MELHOR VALOR';

  @override
  String get paywallForever => 'PARA SEMPRE';

  @override
  String get paywallMonthlyDesc => 'Faturado mensalmente';

  @override
  String get paywallYearlyDesc => 'Faturado anualmente';

  @override
  String get paywallLifetimeDesc => 'Pague uma vez, fique para sempre';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial grátis, depois $rest';
  }

  @override
  String get paywallCtaLifetime => 'Obter acesso vitalício';

  @override
  String get paywallCtaYearly => 'Iniciar plano anual';

  @override
  String get paywallCtaMonthly => 'Iniciar plano mensal';

  @override
  String get paywallFootLifetime => 'Compra única · Sem subscrição';

  @override
  String get paywallFootSubscription =>
      'Renova automaticamente · Cancele quando quiser na loja';

  @override
  String get paywallTerms =>
      'As subscrições são cobradas na sua conta da App Store ou do Google Play e renovam automaticamente, salvo se forem canceladas pelo menos 24 horas antes do fim do período atual.';

  @override
  String get paywallIapUnavailable =>
      'As compras na app não estão disponíveis neste dispositivo. Confirme que os Serviços do Google Play estão instalados e que a app veio da Play Store.';

  @override
  String get paywallLoadingPlans => 'A carregar planos…';

  @override
  String get paywallPlansFailed =>
      'Não foi possível carregar os planos. Verifique a ligação e tente de novo.';

  @override
  String get paywallTryAgain => 'Tentar de novo';

  @override
  String get paywallRestored => 'Compras restauradas';

  @override
  String get paywallPurchased => 'Bem-vindo ao Premium!';

  @override
  String get paywallLifetimeNever => 'O acesso vitalício nunca expira';

  @override
  String get helpSearchQuestions => 'Pesquisar perguntas';

  @override
  String get helpStepWallets => 'Adicione carteiras';

  @override
  String get helpStepCategories => 'Escolha categorias';

  @override
  String get helpStepTrack => 'Registe diariamente';

  @override
  String get splashTagline => 'Dinheiro, mais claro.';

  @override
  String get introStep1 => 'A contar as suas moedas…';

  @override
  String get introStep2 => 'A acordar as suas carteiras…';

  @override
  String get introStep3 => 'A polir os gráficos…';

  @override
  String get introStep4 => 'Quase lá…';

  @override
  String get introTipLabel => 'Dica financeira';

  @override
  String get introTip1 =>
      'Pague-se primeiro: ponha a poupança de parte no dia em que recebe o salário.';

  @override
  String get introTip2 =>
      'Pequenos gastos diários acumulam. Registá-los já é meio caminho.';

  @override
  String get introTip3 =>
      'Um fundo de emergência de 3 meses transforma surpresas em meros incómodos.';

  @override
  String get introTip4 =>
      'Reveja as subscrições todos os meses: cancele o que não usou.';

  @override
  String get introTip5 => 'Dê uma função a cada moeda antes de o mês começar.';

  @override
  String get introTip6 =>
      'Espere 24 horas antes de qualquer compra não planeada.';

  @override
  String get introTip7 =>
      'Orçamentos não são limites, são permissão para gastar no que importa.';

  @override
  String get introTip8 =>
      'Celebre pequenas vitórias: todo o objetivo começa com o primeiro depósito.';

  @override
  String get adConfirmTitleAiCall => 'Obter mais um pedido de IA';

  @override
  String get adConfirmTitleTheme => 'Experimente temas Premium por 24 horas';

  @override
  String get adConfirmTitlePdf => 'Exportar um relatório PDF';

  @override
  String get adConfirmBodyAiCall =>
      'Já usou os pedidos de IA gratuitos deste mês. Veja um anúncio curto e recebe mais um.';

  @override
  String get adConfirmBodyTheme =>
      'Veja um anúncio curto e todos os temas Premium ficam seus durante as próximas 24 horas.';

  @override
  String get adConfirmBodyPdf =>
      'Veja um anúncio curto para exportar um relatório PDF.';

  @override
  String get adConfirmWarning => 'Está prestes a ver um anúncio. Continuar?';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mais $count anúncios disponíveis este mês',
      one: 'Mais 1 anúncio disponível este mês',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'Os membros Premium têm IA ilimitada, todos os temas e relatórios PDF, sem qualquer anúncio.';

  @override
  String get adWatch => 'Ver anúncio';

  @override
  String get adGetPremium => 'Obter Premium';

  @override
  String get adNotNow => 'Agora não';

  @override
  String get adLoading => 'A carregar o anúncio…';

  @override
  String get adVerifying => 'A confirmar a sua recompensa…';

  @override
  String get adUnavailable =>
      'Não há nenhum anúncio disponível agora. Tente de novo daqui a pouco.';

  @override
  String get adSkipped =>
      'O anúncio foi fechado antes do fim, por isso nada foi desbloqueado.';

  @override
  String get adRewardAiCall => 'Feito! Tem mais um pedido de IA.';

  @override
  String get adRewardTheme => 'Temas Premium desbloqueados por 24 horas.';

  @override
  String get adRewardPdf => 'Uma exportação PDF desbloqueada.';

  @override
  String get adMonthlyCapReached =>
      'Acabaram os anúncios deste mês. Os pedidos gratuitos voltam no dia 1, ou passe a Premium para ter ilimitados.';

  @override
  String get adRewardPending =>
      'Obrigado! A sua recompensa aparece dentro de momentos.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restam $count pedidos de IA gratuitos este mês',
      one: 'Resta 1 pedido de IA gratuito este mês',
      zero: 'Sem pedidos de IA gratuitos este mês',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: ilimitado';

  @override
  String get aiToolSearching => 'A pesquisar as suas transações…';

  @override
  String get aiToolSummarizing => 'A somar os números…';

  @override
  String get aiToolAccounts => 'A verificar as suas contas…';

  @override
  String get aiToolCategories => 'A ver as suas categorias…';

  @override
  String get aiToolCards => 'A verificar as faturas dos cartões…';

  @override
  String get aiToolPlans => 'A verificar prestações e poupanças…';

  @override
  String get aiToolSaving => 'A guardar…';

  @override
  String get aiActionAddTitle => 'Adicionar esta transação?';

  @override
  String get aiActionUpdateTitle => 'Alterar esta transação?';

  @override
  String get aiActionDeleteTitle => 'Eliminar esta transação?';

  @override
  String get aiActionPayCardTitle => 'Pagar uma fatura de cartão';

  @override
  String get aiActionCardSettingsTitle => 'Alterar datas do cartão';

  @override
  String get aiActionCreatePlanTitle => 'Iniciar um plano';

  @override
  String get aiActionPayPlanTitle => 'Registar pagamento do plano';

  @override
  String get aiActionClosePlanTitle => 'Terminar um plano mais cedo';

  @override
  String get aiActionUpdatePlanTitle => 'Alterar um plano';

  @override
  String get aiActionCreateInvestmentTitle => 'Adicionar um investimento';

  @override
  String get aiActionTradeInvestmentTitle => 'Registar uma operação';

  @override
  String get aiActionUpdateInvestmentTitle => 'Atualizar um preço';

  @override
  String get aiActionConfirm => 'Confirmar';

  @override
  String get aiActionClosePlan => 'Terminar';

  @override
  String get aiActionFrom => 'De';

  @override
  String get aiActionTo => 'Para';

  @override
  String get aiActionBill => 'Fatura';

  @override
  String get aiActionLeftAfter => 'Resta depois';

  @override
  String get aiActionRemindDays => 'Lembrar, dias antes';

  @override
  String get aiActionPay => 'Pagar';

  @override
  String get plansTitle => 'Prestações, empréstimos e poupanças';

  @override
  String get investmentsTitle => 'Investimentos';

  @override
  String get investmentsSubtitle =>
      'Fundos, ações e planos de investimento, ao preço mais recente';

  @override
  String get forecastTitle => 'Previsão de tesouraria';

  @override
  String get forecastSubtitle =>
      'Para onde vai o seu dinheiro em caixa e no banco, e qualquer dia em que falte';

  @override
  String forecastRangeDays(int days) {
    return '$days dias';
  }

  @override
  String get forecastNow => 'Dinheiro e banco agora';

  @override
  String get forecastMoneyIn => 'A entrar';

  @override
  String get forecastMoneyOut => 'A sair';

  @override
  String get forecastLowest => 'Mínimo';

  @override
  String forecastLowestOn(String date) {
    return 'em $date';
  }

  @override
  String get forecastChartTitle => 'Saldo previsto';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'Em $date faltariam $amount';
  }

  @override
  String get forecastShortfallCause => 'A sair nesse dia:';

  @override
  String get forecastAlreadyShort =>
      'As suas contas de dinheiro e banco já estão abaixo de zero.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'Sem falta de dinheiro nos próximos $days dias';
  }

  @override
  String get forecastAllCoveredBody =>
      'O que está agendado está coberto pelo seu dinheiro em caixa e no banco.';

  @override
  String get forecastScheduledOnly =>
      'Conta só o que está agendado: planos, faturas de cartão, subscrições, pagamentos recorrentes e próximos, e empréstimos com data de vencimento. Os gastos do dia a dia não estão incluídos.';

  @override
  String get forecastEventsTitle => 'A seguir';

  @override
  String forecastDayBalance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String get forecastEmptyTitle => 'Nada agendado';

  @override
  String get forecastEmptyBody =>
      'Planos, faturas de cartão, subscrições e pagamentos próximos neste período aparecem aqui.';

  @override
  String get forecastOverdue => 'Em atraso';

  @override
  String get forecastExpected => 'Previsto';

  @override
  String get forecastEventWhen => 'Quando';

  @override
  String get forecastEventKind => 'Tipo';

  @override
  String get forecastEventAccount => 'Conta';

  @override
  String get forecastEventOpen => 'Abrir';

  @override
  String get forecastEventOverdueNote =>
      'A data já passou e continua em aberto, por isso conta como vencido hoje.';

  @override
  String get forecastKindInstallment => 'Prestação';

  @override
  String get forecastKindPremium => 'Prémio';

  @override
  String get forecastKindDeposit => 'Depósito';

  @override
  String get forecastKindSipBuy => 'Compra programada';

  @override
  String get forecastKindProfit => 'Lucro';

  @override
  String get forecastKindMaturity => 'Vencimento';

  @override
  String get forecastKindCardBill => 'Fatura do cartão';

  @override
  String get forecastKindCardBillNext => 'Próxima fatura, até agora';

  @override
  String get forecastKindSubscription => 'Subscrição';

  @override
  String get forecastKindRecurringBill => 'Pagamento recorrente';

  @override
  String get forecastKindRecurringIncome => 'Receita recorrente';

  @override
  String get forecastKindUpcoming => 'Próximo';

  @override
  String get forecastKindBorrowed => 'Empréstimo a pagar';

  @override
  String get forecastKindLent => 'Emprestado, a receber';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'Podem faltar-lhe $amount em $date';
  }

  @override
  String get forecastHomeWarningBody => 'Veja o que aí vem';

  @override
  String get forecastDismiss => 'Dispensar';

  @override
  String forecastNotifTitle(String day) {
    return 'Pode ficar sem dinheiro em $day';
  }

  @override
  String get settingsBillReminders => 'Lembretes de faturas e prestações';

  @override
  String get settingsBillRemindersSub =>
      'Faturas de cartão a vencer e prestações ou poupanças a chegar';

  @override
  String get forecastNotifNowTitle => 'Hoje está com falta de dinheiro';

  @override
  String forecastNotifNowBody(String amount) {
    return 'O que vence agora é $amount a mais do que as suas contas têm. Toque para ver o que aí vem.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'Com os pagamentos agendados, faltariam $amount. Toque para ver o que aí vem.';
  }

  @override
  String get investmentsEmptyTitle => 'Ainda sem investimentos';

  @override
  String get investmentsEmptyBody =>
      'Acompanhe um fundo, ações ou ouro: o que pagou, quanto vale agora e o ganho.';

  @override
  String get investmentsSold => 'Vendidos';

  @override
  String get investmentsWorth => 'Vale agora';

  @override
  String get investmentNew => 'Novo investimento';

  @override
  String get investmentNewHint =>
      'Unidades de um fundo, ações de uma empresa ou qualquer coisa comprada à unidade, como ouro ao grama.';

  @override
  String get investmentKindFund => 'Fundo';

  @override
  String get investmentKindStock => 'Ações';

  @override
  String get investmentKindOther => 'Outro';

  @override
  String get investmentNameHintFund => 'ex.: Fundo de Rendimento Mais';

  @override
  String get investmentNameHintStock => 'ex.: Empresa de Telecomunicações';

  @override
  String get investmentNameHintOther => 'ex.: Ouro, 22 quilates';

  @override
  String get investmentSymbol => 'Símbolo ou código (opcional)';

  @override
  String get investmentFirstBuy => 'O que comprou';

  @override
  String get investmentFirstBuyHint =>
      'Deixe o valor vazio para o adicionar sem comprar nada ainda.';

  @override
  String get investmentPaid => 'Pago';

  @override
  String get investmentReceived => 'Recebido';

  @override
  String get investmentPaidInto => 'Pago para';

  @override
  String get investmentFee => 'Taxa ou comissão';

  @override
  String get investmentUnits => 'Unidades';

  @override
  String get investmentUnitsSold => 'Unidades vendidas';

  @override
  String investmentUnitsShort(String units) {
    return '$units unidades';
  }

  @override
  String investmentPerUnit(String price) {
    return '$price por unidade';
  }

  @override
  String get investmentNeedUnits =>
      'Introduza quantas unidades foram compradas.';

  @override
  String get investmentSave => 'Adicionar investimento';

  @override
  String get investmentAdded => 'Investimento adicionado';

  @override
  String get investmentGone => 'Este investimento foi eliminado.';

  @override
  String get netWorthSubtitle =>
      'Tudo o que tem, menos o que deve, e como tem evoluído';

  @override
  String get netWorthToday => 'O seu património';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount desde o mês passado';
  }

  @override
  String get netWorthBreakdown => 'Do que é feito';

  @override
  String get netWorthCash => 'Dinheiro e banco';

  @override
  String get netWorthCards => 'Cartões de crédito';

  @override
  String get netWorthDeposits => 'Depósitos a prazo';

  @override
  String get netWorthAssets => 'Bens';

  @override
  String get netWorthLent => 'Emprestado a outros';

  @override
  String get netWorthBorrowed => 'Pedido emprestado';

  @override
  String get netWorthLoansNote =>
      'O dinheiro que emprestou conta como seu até ser devolvido, e o que pediu emprestado conta contra si até o pagar.';

  @override
  String get netWorthCardsLeftOut =>
      'Os cartões de crédito não são contados; pode alterar isso nas Definições.';

  @override
  String get netWorthHistory => 'No fim de cada mês';

  @override
  String get netWorthSixMonths => '6 meses';

  @override
  String get netWorthOneYear => '1 ano';

  @override
  String get netWorthAllTime => 'Tudo';

  @override
  String get netWorthHistoryEmpty =>
      'A linha começa quando terminar um mês com registos seus.';

  @override
  String get assetNew => 'Adicionar bem';

  @override
  String get assetNewHint =>
      'Terreno, apartamento ou casa, carro, ouro ou qualquer outra coisa que possua. O seu valor conta para o património.';

  @override
  String get assetKind => 'O que é';

  @override
  String get assetKindLand => 'Terreno';

  @override
  String get assetKindHome => 'Apartamento ou casa';

  @override
  String get assetKindCar => 'Veículo';

  @override
  String get assetKindGold => 'Ouro e joias';

  @override
  String get assetKindOther => 'Outra coisa';

  @override
  String get assetNameHintLand => 'ex.: Terreno nos arredores';

  @override
  String get assetNameHintHome => 'ex.: Apartamento no centro';

  @override
  String get assetNameHintCar => 'ex.: Toyota Corolla';

  @override
  String get assetNameHintGold => 'ex.: Joias de casamento';

  @override
  String get assetNameHintOther => 'ex.: Câmara fotográfica';

  @override
  String get assetWorthNow => 'Vale agora';

  @override
  String get assetBoughtNow => 'Pago a partir de uma conta';

  @override
  String get assetBoughtNowHint =>
      'Desligado: já o possui e nenhum dinheiro é movimentado.';

  @override
  String get assetSave => 'Adicionar bem';

  @override
  String get assetAdded => 'Bem adicionado';

  @override
  String get assetsEmptyTitle => 'Ainda sem bens';

  @override
  String get assetsEmptyBody =>
      'Adicione terreno, casa, carro ou ouro para ver tudo o que vale.';

  @override
  String get assetsSold => 'Vendidos';

  @override
  String assetCostLine(String amount) {
    return 'Custo $amount';
  }

  @override
  String get assetUpdateValue => 'Atualizar valor';

  @override
  String get assetSell => 'Vender';

  @override
  String get assetDelete => 'Remover';

  @override
  String get assetValueUpdated => 'Valor atualizado';

  @override
  String get assetSold => 'Vendido, e o dinheiro registado';

  @override
  String assetDeleteTitle(String name) {
    return 'Remover $name?';
  }

  @override
  String get assetDeleteBody =>
      'Deixa de ser contado. O histórico fica nos seus registos.';

  @override
  String get assetDeleted => 'Bem removido';

  @override
  String get aiActionCreateAssetTitle => 'Adicionar um bem';

  @override
  String get aiActionUpdateAssetTitle => 'Atualizar o valor de um bem';

  @override
  String get aiActionSellAssetTitle => 'Vender um bem';

  @override
  String get investmentWorthNow => 'Vale agora';

  @override
  String investmentGainLine(String gain) {
    return '$gain no total';
  }

  @override
  String get investmentPrice => 'Preço';

  @override
  String get investmentPutIn => 'Investido';

  @override
  String get investmentTakenOut => 'Retirado';

  @override
  String get investmentBuy => 'Comprar';

  @override
  String get investmentSell => 'Vender';

  @override
  String investmentBuyTitle(String name) {
    return 'Comprar $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'Vender $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'Dividendo de $name';
  }

  @override
  String get investmentDividend => 'Dividendo';

  @override
  String get investmentRecordDividend => 'Registar um dividendo';

  @override
  String investmentHeldNow(String units) {
    return '$units unidades detidas agora.';
  }

  @override
  String get investmentRecorded => 'Registado';

  @override
  String get investmentUpdatePrice => 'Atualizar o preço';

  @override
  String get investmentUpdatePriceHint =>
      'O valor da unidade de participação ou da ação hoje, por unidade';

  @override
  String get investmentPriceUpdated => 'Preço atualizado';

  @override
  String get investmentStartSip => 'Iniciar investimento periódico';

  @override
  String get investmentStartSipHint =>
      'Comprar um valor fixo todos os meses, automaticamente';

  @override
  String get investmentHistory => 'Histórico';

  @override
  String investmentBought(String units) {
    return 'Compradas $units unidades';
  }

  @override
  String investmentSold(String units) {
    return 'Vendidas $units unidades';
  }

  @override
  String get investmentPriceRose => 'O preço subiu';

  @override
  String get investmentPriceFell => 'O preço desceu';

  @override
  String get investmentUnitsUnknown =>
      'unidades ainda desconhecidas, toque para adicionar';

  @override
  String get investmentCorrectUnits => 'Unidades nesta operação';

  @override
  String get investmentCorrectUnitsHint =>
      'Tal como aparecem no extrato do fundo ou da corretora.';

  @override
  String get investmentUnitsCorrected => 'Unidades corrigidas';

  @override
  String get investmentDelete => 'Eliminar este investimento';

  @override
  String investmentDeleteTitle(String name) {
    return 'Eliminar $name?';
  }

  @override
  String get investmentDeleteBody =>
      'As operações ficam no histórico. Só é possível depois de vender tudo.';

  @override
  String get investmentDeleted => 'Investimento eliminado';

  @override
  String get plansSubtitle =>
      'Prestações, empréstimos, poupanças, depósitos a prazo, seguros, obrigações e investimentos periódicos, pagos e recebidos a tempo';

  @override
  String get planNew => 'Iniciar um plano';

  @override
  String get planNewTitle => 'O que vai iniciar?';

  @override
  String get plansEmptyTitle =>
      'Ainda sem prestações, empréstimos ou poupanças';

  @override
  String get plansEmptyBody =>
      'Acompanhe algo comprado a prestações, um empréstimo, uma poupança mensal ou um depósito a prazo. As prestações são registadas no seu dia e é lembrado antes de cada uma.';

  @override
  String get plansEnded => 'Terminados';

  @override
  String get planKindEmi => 'Prestações';

  @override
  String get planKindLoan => 'Empréstimo';

  @override
  String get planKindDps => 'Poupança mensal';

  @override
  String get planKindFdr => 'Depósito a prazo';

  @override
  String get planKindInsurance => 'Seguro';

  @override
  String get planKindBond => 'Obrigação ou certificado';

  @override
  String get planKindSip => 'Investimento periódico';

  @override
  String get planKindEmiHint =>
      'Algo comprado a prestações, pago em dinheiro, por conta bancária ou cartão';

  @override
  String get planKindLoanHint =>
      'Dinheiro pedido emprestado e pago em prestações, com juros';

  @override
  String get planKindDpsHint =>
      'Poupe um valor fixo todos os meses durante um tempo fixo e receba-o com lucro';

  @override
  String get planKindFdrHint =>
      'Deposite uma quantia num banco por um tempo fixo, com lucro mensal, trimestral ou no fim';

  @override
  String get planKindInsuranceHint =>
      'Uma apólice com prémio mensal, trimestral ou anual, e um pagamento no fim se tiver';

  @override
  String get planKindBondHint =>
      'Uma obrigação ou certificado de aforro: uma quantia aplicada durante anos, com lucro mensal, trimestral ou no fim, após impostos';

  @override
  String get planKindSipHint =>
      'Uma quantia fixa num fundo ou em ações todos os meses, comprada ao preço mais recente';

  @override
  String get planWeekly => 'Semanal';

  @override
  String get planMonthly => 'Mensal';

  @override
  String get planQuarterly => 'Trimestral';

  @override
  String get planHalfYearly => 'Semestral';

  @override
  String get planYearly => 'Anual';

  @override
  String get planMonths => 'Meses';

  @override
  String get planYears => 'Anos';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount até $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved de $total poupados';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid de $total pagos';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'Próximo: $amount em $date';
  }

  @override
  String get planStatusCompleted => 'Concluído';

  @override
  String get planStatusClosed => 'Fechado';

  @override
  String get planStatusOverdue => 'Em atraso';

  @override
  String get planStatusRunning => 'Em curso';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done de $total';
  }

  @override
  String get planGone => 'Este plano foi eliminado.';

  @override
  String get planAccount => 'Conta';

  @override
  String get planAccountEmi => 'Pago de';

  @override
  String get planAccountLoan => 'Recebido em e pago de';

  @override
  String get planAccountSaving => 'Da conta';

  @override
  String get planPrice => 'Preço';

  @override
  String get planBorrowed => 'Valor emprestado';

  @override
  String get planDeposited => 'Valor depositado';

  @override
  String get planDeposit => 'Cada depósito';

  @override
  String get planInstallment => 'Cada prestação';

  @override
  String get planWorkedOut => 'Calculado a partir do preço, taxa e prazo';

  @override
  String get planProgress => 'Feito';

  @override
  String get planSavedSoFar => 'Poupado até agora';

  @override
  String get planPaidSoFar => 'Pago até agora';

  @override
  String get planLeft => 'Falta';

  @override
  String get planTotal => 'No total';

  @override
  String get planInterestCharges => 'Juros e encargos';

  @override
  String get planRate => 'Taxa';

  @override
  String get planRateLabel => 'Taxa % ao ano';

  @override
  String get planRateOptional => 'Opcional';

  @override
  String get planPayout => 'Lucro pago';

  @override
  String get planPayoutMonthly => 'Todos os meses';

  @override
  String get planPayoutQuarterly => 'A cada 3 meses';

  @override
  String get planPayoutAtMaturity => 'No fim';

  @override
  String get planMaturesOn => 'Vence em';

  @override
  String get planMaturity => 'Devolvido no fim';

  @override
  String get planEstimated =>
      'Estimado pela taxa; toque para introduzir o valor do banco';

  @override
  String get planHolding => 'No depósito agora';

  @override
  String get planEnds => 'Última prestação';

  @override
  String planTakeMaturity(String amount) {
    return 'Receber o vencimento, $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'Registar o lucro, $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'Pagar a prestação $number agora, $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'Pagar o prémio $number agora, $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'Fazer o depósito $number agora, $amount';
  }

  @override
  String get planRecorded => 'Registado.';

  @override
  String get planSaved => 'Guardado.';

  @override
  String get planPayOff => 'Liquidar antecipadamente';

  @override
  String get planEncash => 'Resgatar antecipadamente';

  @override
  String get planSurrender => 'Resgatar a apólice';

  @override
  String planSurrenderTitle(String name) {
    return 'Resgatar $name?';
  }

  @override
  String get planSurrenderBody =>
      'Os prémios param. O que a seguradora devolver é registado como receita.';

  @override
  String get planSurrenderNothing => 'Nada devolvido';

  @override
  String get planSurrenderValue => 'Introduza o valor de resgate';

  @override
  String get planSurrenderValueLabel => 'Valor de resgate';

  @override
  String get planStopSip => 'Parar o investimento periódico';

  @override
  String planStopSipTitle(String name) {
    return 'Parar $name?';
  }

  @override
  String get planStopSipBody =>
      'Não haverá mais compras. O que já foi comprado fica no investimento.';

  @override
  String get planSipStopped => 'Investimento periódico parado';

  @override
  String get planSave => 'Guardar';

  @override
  String get planSurrendered => 'Apólice resgatada';

  @override
  String planPayOffTitle(String name) {
    return 'Liquidar $name?';
  }

  @override
  String get planPayOffHint => 'Um pagamento pelo que falta e o plano termina.';

  @override
  String planPayOffLeft(String amount) {
    return 'Pagar o que falta, $amount';
  }

  @override
  String get planPayOffOther => 'O credor indicou outro valor';

  @override
  String planEncashTitle(String name) {
    return 'Resgatar $name?';
  }

  @override
  String get planEncashBody =>
      'O que está no depósito volta para a sua conta e o plano termina.';

  @override
  String get planEncashNoProfit => 'Resgatar, sem lucro';

  @override
  String get planEncashWithProfit => 'Resgatar, com o lucro pago pelo banco';

  @override
  String get planEncashed => 'Resgatado. O dinheiro voltou à sua conta.';

  @override
  String get planPaidOff => 'Liquidado.';

  @override
  String get planAutoCollect => 'Registar automaticamente';

  @override
  String get planAutoCollectHint =>
      'Cada prestação, lucro e vencimento é registado no seu dia';

  @override
  String get planSchedule => 'CALENDÁRIO';

  @override
  String get planDelete => 'Eliminar este plano';

  @override
  String planDeleteTitle(String name) {
    return 'Eliminar $name?';
  }

  @override
  String get planDeleteBody =>
      'O que registou fica nas suas transações. Nada mais é registado nem lembrado.';

  @override
  String get planDeleted => 'Eliminado.';

  @override
  String planEventInstallment(int number, int total) {
    return 'Prestação $number de $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'Prémio $number de $total';
  }

  @override
  String get planEventPayout => 'A apólice paga';

  @override
  String planEventProfit(int number) {
    return 'Lucro, mês $number';
  }

  @override
  String get planEventMaturity => 'Vencimento';

  @override
  String get planEventDone => 'Feito';

  @override
  String get planEventLate => 'Em atraso';

  @override
  String get planEventUpcoming => 'Próximo';

  @override
  String get planNeedAccount => 'Escolha primeiro uma conta.';

  @override
  String get planCreated =>
      'Iniciado. Tudo o que já estava vencido foi registado.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total, dos quais $interest são juros e encargos.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total, sem juros.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return 'Deposita $deposited e recebe cerca de $maturity em $date.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal cresce até cerca de $maturity em $date.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return '$profit de lucro todos os meses e $principal devolvidos em $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count prémios de $premium, $total no total.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count prémios de $premium, $total no total, e $payout devolvidos em $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return '$profit de lucro a cada três meses e $principal devolvidos em $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount em $fund, $total no total.';
  }

  @override
  String planNewKind(String kind) {
    return 'Novo: $kind';
  }

  @override
  String get planName => 'Nome';

  @override
  String get planNameHintEmi => 'ex.: Telemóvel a prestações';

  @override
  String get planNameHintLoan => 'ex.: Empréstimo da mota';

  @override
  String get planNameHintDps => 'ex.: Poupança mensal do banco';

  @override
  String get planNameHintFdr => 'ex.: Depósito a prazo no banco';

  @override
  String get planNameHintInsurance => 'ex.: Seguro de vida';

  @override
  String get planNameHintBond => 'ex.: Certificado de aforro a 5 anos';

  @override
  String get planNameHintSip => 'ex.: Investimento mensal num fundo';

  @override
  String get planSipFund => 'Compra';

  @override
  String get planSipAmount => 'Cada compra';

  @override
  String get planSipNoFund =>
      'Adicione primeiro o fundo ou as ações em Investimentos.';

  @override
  String get planProvider => 'Banco ou empresa';

  @override
  String get planReference => 'N.º da apólice ou conta';

  @override
  String get planSumAssured => 'Capital seguro';

  @override
  String get planPremium => 'Prémio';

  @override
  String get planPremiums => 'Prémios';

  @override
  String get planTaxLabel => 'Imposto retido %';

  @override
  String get planTax => 'Imposto retido';

  @override
  String get planFirstPremium => 'Primeiro prémio';

  @override
  String get planLastPremium => 'Último prémio';

  @override
  String get planInsurancePayout => 'Devolvido no fim';

  @override
  String get planNone => 'Nenhum';

  @override
  String get planHowMany => 'Quantos';

  @override
  String get planTerm => 'Prazo';

  @override
  String get planOpenedOn => 'Aberto em';

  @override
  String get planFirstDue => 'Primeira prestação';

  @override
  String get planCategory => 'Categoria';

  @override
  String get planCategoryDefault => 'Pagamento de empréstimo';

  @override
  String get planCategoryInsurance => 'Seguro';

  @override
  String get planLoanReceived => 'Dinheiro recebido nesta conta';

  @override
  String get planLoanReceivedHint =>
      'Desligue se foi diretamente para um vendedor';

  @override
  String get planStart => 'Iniciar';

  @override
  String get aiActionDeleteNote =>
      'Vai para Eliminados recentemente, onde a pode restaurar durante 30 dias.';

  @override
  String get aiActionAdd => 'Adicionar';

  @override
  String get aiActionSave => 'Guardar alteração';

  @override
  String get aiActionDelete => 'Eliminar';

  @override
  String get aiActionCancel => 'Não, deixar';

  @override
  String get aiActionAmount => 'Valor';

  @override
  String get aiActionKind => 'Tipo';

  @override
  String get aiActionTitle => 'Título';

  @override
  String get aiActionCategory => 'Categoria';

  @override
  String get aiActionAccount => 'Conta';

  @override
  String get aiActionDate => 'Data';

  @override
  String get aiActionNotes => 'Notas';

  @override
  String get aiReport => 'Comunicar um problema';

  @override
  String get aiReportWrongAnswer => 'O consultor errou em algo';

  @override
  String get aiReportWrongAnswerHint =>
      'Um número errado, um facto inventado ou uma alteração que não pediu';

  @override
  String get aiReportWrongAnswerSubject =>
      'Consultor financeiro: resposta errada';

  @override
  String get aiReportBug => 'Comunicar um erro';

  @override
  String get aiReportBugHint =>
      'Algo deixou de funcionar, bloqueou ou não carregou';

  @override
  String get aiReportBugSubject => 'Consultor financeiro: relatório de erro';

  @override
  String get aiAboutCoach => 'Como funciona o consultor';

  @override
  String get aiDisclaimerTitle => 'Antes de perguntar ao consultor';

  @override
  String get aiDisclaimerMistakes =>
      'O consultor é uma IA. Pode errar um número, interpretar mal uma pergunta ou afirmar algo que não é verdade, por isso confirme tudo o que for importante nas suas próprias transações.';

  @override
  String get aiDisclaimerData =>
      'Os seus valores são lidos no telemóvel. Para responder, a app envia a sua pergunta e os valores necessários para o nosso servidor e o respetivo modelo de IA.';

  @override
  String get aiDisclaimerChanges =>
      'Nunca altera o seu dinheiro sozinho. Cada adição, edição ou eliminação é-lhe mostrada primeiro e só acontece se a confirmar.';

  @override
  String get aiDisclaimerReport =>
      'Se uma resposta parecer errada, toque na bandeira no topo para nos avisar.';

  @override
  String get aiDisclaimerAccept => 'Compreendo';

  @override
  String get aiOutOfRequestsTitle => 'Já usou os pedidos gratuitos deste mês';

  @override
  String get aiOutOfRequestsBody =>
      'Veja um anúncio curto para fazer esta pergunta, ou passe a Premium para respostas ilimitadas sem anúncios. Os pedidos gratuitos voltam no dia 1.';

  @override
  String get ocrNoCamera => 'Não foi possível abrir a câmara.';

  @override
  String get ocrNoGallery => 'Não foi possível abrir a galeria.';

  @override
  String get ocrScanTitle => 'Digitalizar um recibo';

  @override
  String get ocrScanAnother => 'Digitalizar outro';

  @override
  String get ocrScanBody =>
      'Tire uma foto ou escolha uma. A app lê-a e a IA preenche os detalhes.';

  @override
  String get ocrReadingWithAi => 'A IA está a ler o seu recibo…';

  @override
  String get ocrNothingRead =>
      'Não foi possível ler texto nessa foto. Tente de novo com melhor luz e o recibo inteiro visível.';

  @override
  String get ocrAiOfferTitle => 'Deixe a IA lê-lo como deve ser';

  @override
  String get ocrAiOfferBody =>
      'Encontra o total real, a data, cada artigo e a categoria certa, mesmo num recibo confuso.';

  @override
  String get ocrReadWithAi => 'Ler com IA';

  @override
  String get ocrReadByAi => 'Lido pela IA. Verifique antes de guardar.';

  @override
  String get ocrItems => 'Artigos';

  @override
  String get quickAddTitle => 'Descreva-a';

  @override
  String get quickAddSubtitle =>
      'Escreva como diria. A IA preenche o formulário para verificar.';

  @override
  String get quickAddHint => 'ex.: almoço 250 ontem via bKash';

  @override
  String get quickAddFill => 'Preencher';

  @override
  String get summaryTitle => 'Resumo mensal';

  @override
  String get summarySpent => 'Gasto este mês';

  @override
  String summaryEarned(String amount) {
    return 'Ganho $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent% menos do que no mês passado';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent% mais do que no mês passado';
  }

  @override
  String get summaryAiTitle => 'O seu mês, em poucas palavras';

  @override
  String get summaryAiBody =>
      'A IA compara o seu mês com o anterior e destaca o que sobressaiu, com uma sugestão para experimentar.';

  @override
  String get summaryWrite => 'Escrever o meu resumo';

  @override
  String get summaryOutdated =>
      'As suas transações mudaram desde que este resumo foi escrito.';

  @override
  String get summaryUpdate => 'Atualizar o meu resumo';

  @override
  String get summaryWriting => 'A escrever o seu resumo…';

  @override
  String get summaryByCategory => 'Por categoria';

  @override
  String get summaryNoSpending => 'Ainda sem gastos registados este mês.';

  @override
  String themeTrialUntil(String time) {
    return 'Temas Premium desbloqueados até $time';
  }

  @override
  String get zakatTitle => 'Zakat';

  @override
  String get zakatSubtitle =>
      'Calcule o que é devido sobre a sua riqueza e registe o que paga';

  @override
  String get zakatSubtitleOff => 'Não paga zakat. Toque para calcular na mesma';

  @override
  String get zakatAskTitle => 'Paga zakat?';

  @override
  String get zakatAskBody =>
      'Nem toda a gente paga. Se não paga, a app tira o zakat do seu caminho: nada devido e sem lembretes.';

  @override
  String get zakatIPay => 'Pago zakat';

  @override
  String get zakatIDontPay => 'Não pago zakat';

  @override
  String get zakatOffTitle => 'Não paga zakat';

  @override
  String get zakatOffBody =>
      'Por isso nada sobre zakat aparece como devido e não há lembretes de zakat. Pode sempre ver quanto seria; consultar não altera a sua resposta.';

  @override
  String get zakatOffPeek => 'Ver quanto seria';

  @override
  String get zakatPeekBanner => 'Só uma consulta. Indicou que não paga zakat.';

  @override
  String get zakatOptOutTitle => 'Deixar de acompanhar o zakat?';

  @override
  String get zakatOptOutBody =>
      'Nada aparecerá como devido e não haverá lembretes de zakat. Os seus valores são mantidos e pode consultá-los aqui a qualquer momento.';

  @override
  String get zakatDue => 'Zakat devido';

  @override
  String zakatAboveNisab(String amount) {
    return 'Acima do nisab: 2,5% de $amount de riqueza líquida';
  }

  @override
  String zakatBelowNisab(String amount) {
    return 'Abaixo do nisab em $amount, por isso não há zakat devido';
  }

  @override
  String get zakatNeedPrice =>
      'Introduza o preço por grama para verificar o nisab';

  @override
  String get zakatPaidSoFar => 'Pago este ano';

  @override
  String get zakatLeftToPay => 'Falta pagar';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Data de zakat $date, daqui a $days dias',
      one: 'Data de zakat amanhã, $date',
      zero: 'A sua data de zakat é hoje',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'Defina a sua data de zakat para acompanhar o ano e receber um lembrete';

  @override
  String get zakatPay => 'Pagar zakat';

  @override
  String get zakatNisab => 'Nisab';

  @override
  String get zakatBasisGold => 'Ouro';

  @override
  String get zakatBasisSilver => 'Prata';

  @override
  String get zakatBasisHint =>
      'A prata dá o nisab mais baixo e é a escolha mais prudente quando a sua riqueza é sobretudo dinheiro. Introduza o preço local de hoje por grama.';

  @override
  String zakatPricePerGram(String metal) {
    return 'Preço por grama ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams g a esse preço';
  }

  @override
  String get zakatGroupCash => 'Dinheiro e banco';

  @override
  String get zakatGroupDeposits => 'Depósitos a prazo';

  @override
  String get zakatGroupInvestments => 'Investimentos';

  @override
  String get zakatGroupMetals => 'Ouro e prata';

  @override
  String get zakatGroupLent => 'Dinheiro emprestado a outros';

  @override
  String get zakatGroupOtherAssets => 'Outros bens';

  @override
  String get zakatGroupPaid => 'Zakat pago este ano';

  @override
  String get zakatGroupManual => 'Adicionado por si';

  @override
  String get zakatGroupBorrowed => 'Menos: dinheiro que deve';

  @override
  String get zakatGroupCards => 'Menos: dívidas de cartão de crédito';

  @override
  String get zakatOtherAssetsNote =>
      'Terreno, casa ou carro que usa não estão sujeitos a zakat. Ative um só se o tiver para comércio.';

  @override
  String get zakatPaidNote =>
      'Somado de volta, porque saiu das suas contas depois de a riqueza do ano ter sido contada.';

  @override
  String get zakatNoMetals =>
      'Não há ouro nem prata registados. Adicione-os como bem, ou adicione o valor abaixo.';

  @override
  String get zakatAddAmount => 'Adicionar um valor';

  @override
  String get zakatAmountLabel => 'O que é?';

  @override
  String get zakatAmountHint => 'Stock do negócio, dinheiro em casa…';

  @override
  String get zakatAmountDeduct => 'É uma dívida a pagar agora';

  @override
  String get zakatWealth => 'Riqueza sujeita a zakat';

  @override
  String get zakatDeductions => 'Dívidas a pagar agora';

  @override
  String get zakatNet => 'Riqueza líquida';

  @override
  String get zakatRate => '2,5% da riqueza líquida';

  @override
  String get zakatYear => 'Ano do zakat';

  @override
  String get zakatDate => 'Data do zakat';

  @override
  String get zakatDateHint =>
      'O dia em que o seu ano de zakat se completa. Repete-se a cada ano lunar, 354 dias.';

  @override
  String get zakatRemind => 'Lembrar-me';

  @override
  String get zakatRemindHint => '3 dias antes e no próprio dia';

  @override
  String get zakatDisclaimer =>
      'Isto é um guia para ajudar a calcular o zakat, não uma decisão religiosa. Os estudiosos divergem em alguns detalhes; em caso de dúvida, consulte um estudioso local.';

  @override
  String get zakatPayNote =>
      'Registado como despesa em Zakat e contado para este ano.';

  @override
  String get zakatPayRecord => 'Registar pagamento';

  @override
  String get zakatPaidSnack => 'Zakat registado';

  @override
  String get aiToolZakat => 'A calcular o zakat…';

  @override
  String get voiceButton => 'Dizer uma transação';

  @override
  String get voiceTitle => 'Diga';

  @override
  String get voiceUnlimited => 'Ilimitado';

  @override
  String get voiceTapToTalk => 'Toque na esfera e diga o que gastou';

  @override
  String get voiceListening => 'A ouvir…';

  @override
  String get voiceStop => 'Parar de ouvir';

  @override
  String get voiceTypeInstead => 'Escrever';

  @override
  String get voiceSpeakInstead => 'Falar';

  @override
  String get voiceSend => 'Feito';

  @override
  String get voiceTrySaying => 'Experimente dizer';

  @override
  String get voiceExample1 => 'Almoço 250, táxi 60';

  @override
  String get voiceExample2 => 'Recebi o salário, 45.000';

  @override
  String get voiceExample3 => 'O chá de ontem foi 30, não 20';

  @override
  String get voiceExample4 => 'Apaga o almoço de hoje';

  @override
  String get voiceTypeHint => 'Almoço 250 e táxi 60 via bKash';

  @override
  String get voiceThinking => 'A processar…';

  @override
  String get voiceTryAgain => 'De novo';

  @override
  String get voiceSaving => 'A guardar…';

  @override
  String get voiceEdit => 'Editar';

  @override
  String get voiceNeedsYou => 'Precisa de si';

  @override
  String get voiceNew => 'Nova';

  @override
  String get voiceChange => 'Alteração';

  @override
  String get voiceRemove => 'Remover';

  @override
  String get voiceNeedsAmount =>
      'Não foi dito nenhum valor. Preencha-o para adicionar esta.';

  @override
  String get voiceAdjust => 'Ajustar';

  @override
  String get voiceFillIn => 'Preencher';

  @override
  String get voiceTime => 'Hora';

  @override
  String get voiceUndo => 'Desfazer';

  @override
  String get voiceUndone => 'Reposto como estava';

  @override
  String get voiceNoSpeech => 'Não percebi. Tente de novo ou escreva.';

  @override
  String get voiceMicOff =>
      'O acesso ao microfone está desligado. Permita-o nas Definições ou escreva.';

  @override
  String get voiceUnavailable =>
      'A voz não está disponível neste telemóvel. Pode escrever.';

  @override
  String get voiceSomethingWrong => 'Algo correu mal. Tente de novo.';

  @override
  String get voiceFabSetting => 'Microfone flutuante em Hoje';

  @override
  String get amountHidden => 'Valor oculto';

  @override
  String get privacyShowAmounts => 'Mostrar valores';

  @override
  String get privacyHideAmounts => 'Ocultar valores';

  @override
  String get privacyAmounts => 'Valores no ecrã';

  @override
  String get privacyAmountsFooter =>
      'Os saldos e totais ficam desfocados para que quem está perto não os consiga ler. As transações individuais continuam visíveis. O olho em Hoje também os mostra ou oculta.';

  @override
  String get privacyHideTitle => 'Ocultar saldos e totais';

  @override
  String get privacyHideSub => 'Desfocá-los até decidir mostrá-los';

  @override
  String get privacyTapTitle => 'Toque num valor oculto para o mostrar';

  @override
  String get privacyTapSub => 'Caso contrário, só o olho em Hoje os mostra';

  @override
  String get privacyStartTitle => 'Ao abrir a app';

  @override
  String get privacyStartHidden => 'Ocultos';

  @override
  String get privacyStartHiddenSub =>
      'Abrir sempre com saldos e totais ocultos';

  @override
  String get privacyStartShown => 'Visíveis';

  @override
  String get privacyStartShownSub =>
      'Abrir sempre com saldos e totais visíveis';

  @override
  String get privacyStartRemember => 'Como deixei';

  @override
  String get privacyStartRememberSub => 'Abrir como o olho ficou da última vez';

  @override
  String get privacyIntroTitle => 'Novo: oculte os seus saldos';

  @override
  String get privacyIntroBody =>
      'Os saldos e totais estão agora ocultos, para que quem está perto não os consiga ler. Toque no olho em Hoje para os mostrar ou ocultar; a app lembra-se de como os deixou. Pode escolher como a app abre nas Definições.';

  @override
  String get privacyIntroOk => 'Entendido';

  @override
  String get privacyIntroSettings => 'Escolher nas Definições';

  @override
  String get voiceFabSettingSub =>
      'Um microfone que flutua sobre Hoje, para dizer uma transação';

  @override
  String get voiceFabAskTitle => 'Adicionar um microfone ao ecrã Hoje?';

  @override
  String get voiceFabAskBody =>
      'Toque nele e diga o que gastou, como \"almoço 250 e um táxi 60\". Verifica tudo antes de ser guardado. Arraste-o para onde quiser.';

  @override
  String get voiceFabAskYes => 'Sim, adicionar o microfone';

  @override
  String get voiceFabAskNo => 'Agora não';

  @override
  String get voiceFabAskLater =>
      'Pode ligá-lo ou desligá-lo a qualquer momento em Mais.';

  @override
  String get voiceFabHideTitle => 'Ocultar o microfone flutuante?';

  @override
  String get voiceFabHideBody =>
      'O microfone no topo de Hoje continua. Pode trazer este de volta em Mais.';

  @override
  String get voiceFabHide => 'Ocultar';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PRONTAS A GUARDAR',
      one: '1 PRONTA A GUARDAR',
      zero: 'NADA PRONTO',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Guardar $count',
      one: 'Guardar 1',
      zero: 'Nada selecionado',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações guardadas',
      one: '1 transação guardada',
    );
    return '$_temp0';
  }
}
