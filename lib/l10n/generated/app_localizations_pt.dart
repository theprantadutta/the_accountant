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
  String get settingsBillRemindersNote =>
      'Os lembretes de faturas do cartão e de prestações dos planos são calculados pela app no seu telemóvel, para que os seus montantes fiquem privados. Se não abrir a app durante alguns dias, um lembrete pode chegar atrasado ou falhar.';

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
  String get voiceNeedsConnection =>
      'A voz precisa de ligação. Pode escrever em vez disso.';

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
  String get ppTitle => 'Proteção por frase-passe';

  @override
  String get ppRowOn => 'Ativada';

  @override
  String get ppRowOff => 'Desativada';

  @override
  String get ppRowLocked => 'Bloqueada neste telemóvel';

  @override
  String get ppIntro =>
      'Os seus dados já estão encriptados neste telemóvel e nas suas cópias de segurança. Uma frase-passe acrescenta mais um cadeado, para que mais ninguém além de si possa abrir os dados sincronizados e as cópias de segurança — nem mesmo nós.';

  @override
  String get ppWithoutTitle => 'Sem frase-passe (como está agora)';

  @override
  String get ppWithout1 => 'Tudo o que está neste telemóvel está encriptado.';

  @override
  String get ppWithout2 =>
      'As cópias de segurança e os dados sincronizados são encriptados com uma chave associada à sua conta.';

  @override
  String get ppWithout3 =>
      'Inicie sessão num telemóvel novo e tudo volta, sem nada para memorizar.';

  @override
  String get ppWithout4 =>
      'O nosso servidor guarda essa chave, por isso, em princípio, poderíamos abrir os seus dados sincronizados.';

  @override
  String get ppWithTitle => 'Com frase-passe';

  @override
  String get ppWith1 =>
      'Só a sua frase-passe ou o seu código de recuperação podem abrir os dados sincronizados e as cópias de segurança.';

  @override
  String get ppWith2 =>
      'O nosso servidor guarda apenas cópias bloqueadas da sua chave. Não conseguimos ler os seus dados, nem ninguém que invada os nossos servidores.';

  @override
  String get ppWith3 =>
      'Num telemóvel novo, ou depois de reinstalar, introduz a sua frase-passe uma vez.';

  @override
  String get ppWith4 =>
      'Este telemóvel continua a funcionar exatamente como agora, mesmo sem ligação.';

  @override
  String get ppCatchTitle => 'O senão';

  @override
  String get ppCatchBody =>
      'Se se esquecer da frase-passe e também perder o código de recuperação, ninguém consegue recuperar os seus dados sincronizados nem as cópias de segurança — nem nós, nem ninguém. O que já está neste telemóvel continua legível aqui.';

  @override
  String get ppAiNote =>
      'As funcionalidades de IA continuam a enviar um resumo das suas finanças para lhe poderem responder. Uma frase-passe não altera isso.';

  @override
  String get ppSetButton => 'Definir uma frase-passe';

  @override
  String get ppSetTitle => 'Escolha uma frase-passe';

  @override
  String get ppSetHint =>
      'Use pelo menos 10 caracteres. Algumas palavras sem relação entre si são fáceis de lembrar e difíceis de adivinhar.';

  @override
  String get ppPassphraseLabel => 'Frase-passe';

  @override
  String get ppConfirmLabel => 'Escreva-a novamente';

  @override
  String get ppTooShort => 'Use pelo menos 10 caracteres.';

  @override
  String get ppMismatch => 'As duas frases-passe não coincidem.';

  @override
  String get ppUnderstand =>
      'Compreendo que, se perder a frase-passe e o código de recuperação, os meus dados sincronizados e as cópias de segurança não poderão ser recuperados.';

  @override
  String get ppTurnOn => 'Ativar proteção';

  @override
  String get ppWorking => 'A bloquear a sua chave. Demora alguns segundos…';

  @override
  String get ppMaybeSaved =>
      'A ligação caiu, por isso o servidor pode já ter guardado isto. Repita até ver um código de recuperação e guarde esse.';

  @override
  String get ppRecoveryTitle => 'O seu código de recuperação';

  @override
  String get ppRecoveryBody =>
      'É a única outra forma de aceder aos seus dados se se esquecer da frase-passe. Anote-o ou guarde-o num gestor de palavras-passe — num local que não seja este telemóvel.';

  @override
  String get ppCopy => 'Copiar';

  @override
  String get ppCopied => 'Código de recuperação copiado';

  @override
  String get ppSavedIt =>
      'Guardei o meu código de recuperação num local seguro';

  @override
  String get ppDone => 'Concluído';

  @override
  String get ppOnTitle => 'A proteção está ativada';

  @override
  String get ppOnBody =>
      'Só a sua frase-passe ou o seu código de recuperação podem abrir os dados sincronizados e as cópias de segurança.';

  @override
  String get ppChange => 'Alterar frase-passe';

  @override
  String get ppNewCode => 'Obter um novo código de recuperação';

  @override
  String get ppNewCodeWarn =>
      'O seu código de recuperação atual deixará de funcionar. Certifique-se de que guarda o novo.';

  @override
  String get ppTurnOff => 'Desativar proteção';

  @override
  String get ppTurnOffBody =>
      'O nosso servidor voltará a guardar a sua chave, como antes. Os seus dados continuam encriptados, mas, em princípio, poderíamos abrir os seus dados sincronizados.';

  @override
  String get ppLockedTitle => 'Desbloqueie os seus dados';

  @override
  String get ppLockedBody =>
      'Os seus dados estão protegidos por uma frase-passe. Introduza-a uma vez neste telemóvel para abrir os dados sincronizados e as cópias de segurança.';

  @override
  String get ppUnlock => 'Desbloquear';

  @override
  String get ppUseRecovery => 'Usar antes o código de recuperação';

  @override
  String get ppUsePassphrase => 'Usar antes a frase-passe';

  @override
  String get ppRecoveryLabel => 'Código de recuperação';

  @override
  String get ppWrongPassphrase => 'Essa frase-passe não está correta.';

  @override
  String get ppWrongRecovery => 'Esse código de recuperação não está correto.';

  @override
  String get ppUnlocked => 'Desbloqueado neste telemóvel';

  @override
  String get ppChanged => 'Frase-passe alterada';

  @override
  String get ppTurnedOn => 'A proteção está ativada';

  @override
  String get ppTurnedOff => 'Proteção desativada';

  @override
  String get encIntroTitle => 'Os seus dados estão agora encriptados';

  @override
  String get encIntroBody =>
      'Tudo neste telemóvel fica guardado de forma encriptada, e as suas cópias de segurança e dados sincronizados são encriptados antes de saírem dele. Não precisa de fazer nada.';

  @override
  String get encIntroPassphrase =>
      'Quer um cadeado extra? Defina uma frase-passe e só você poderá abrir os dados sincronizados e as cópias de segurança — nem nós. É opcional; se perder a frase-passe e o código de recuperação, esses dados não podem ser recuperados.';

  @override
  String get encIntroSetUp => 'Definir frase-passe';

  @override
  String get encIntroNotNow => 'Agora não';

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

  @override
  String get ppNeedsConnection =>
      'As definições da frase-passe precisam de ligação à Internet. Ligue-se a uma rede e abra isto novamente.';

  @override
  String get offlineToast =>
      'Está offline. Tudo o que adicionar fica guardado neste telemóvel e é sincronizado quando voltar a estar online.';

  @override
  String get backupLockedTitle => 'Desbloquear esta cópia de segurança';

  @override
  String get backupLockedBody =>
      'Esta cópia de segurança está protegida com uma frase-passe. Introduza-a, ou o seu código de recuperação, para a abrir. Funciona sem ligação à Internet.';

  @override
  String get settingsSupportDescribeFirst => 'Descreva primeiro o seu problema';

  @override
  String get settingsSupportSent => 'Obrigado! A sua mensagem foi enviada.';

  @override
  String get settingsSupportSendFailed =>
      'Não foi possível enviar agora. Tente novamente ou envie-nos um e-mail diretamente.';

  @override
  String get settingsSupportSubjectHint => 'Sobre o que é?';

  @override
  String get settingsSupportMessageHint =>
      'Descreva a sua pergunta, problema ou sugestão…';

  @override
  String get settingsSupportHeroBody =>
      'Perguntas, erros ou sugestões — envie-nos e responderemos.';

  @override
  String get settingsSupportTipDescription => 'Uma descrição clara do problema';

  @override
  String get settingsSupportTipSteps =>
      'Passos para o reproduzir (se for um erro)';

  @override
  String get settingsSupportTipDevice =>
      'O modelo do seu dispositivo e a versão do Android';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'Prefere e-mail? $email';
  }

  @override
  String get settingsSupportEmailCopied => 'E-mail copiado';

  @override
  String get settingsAboutTagline => 'O seu companheiro de finanças pessoais';

  @override
  String settingsAboutVersion(String version) {
    return 'Versão: $version';
  }

  @override
  String get settingsAboutDescription =>
      'Uma app de finanças pessoais focada\nna privacidade e num design bonito.';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'Moeda base: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'Última atualização: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'Editar taxa: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'Taxa atual da API: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return 'há $count minutos';
  }

  @override
  String settingsHoursAgo(int count) {
    return 'há $count horas';
  }

  @override
  String settingsDaysAgo(int count) {
    return 'há $count dias';
  }

  @override
  String get settingsExportSectionDateRange => 'PERÍODO';

  @override
  String get settingsExportSectionFormat => 'FORMATO';

  @override
  String get settingsExportSectionInclude => 'INCLUIR';

  @override
  String get settingsExportAllTime => 'Desde sempre';

  @override
  String get settingsExportThisMonth => 'Este mês';

  @override
  String get settingsExportLastMonth => 'Mês passado';

  @override
  String get settingsExportLast3Months => 'Últimos 3 meses';

  @override
  String get settingsExportThisYear => 'Este ano';

  @override
  String get settingsExportPdfPremiumBody =>
      'A exportação CSV é gratuita — os seus dados são sempre seus. O relatório PDF formatado, com resumos e detalhe por categoria e carteira, é uma funcionalidade Premium.';

  @override
  String settingsExportButton(String format) {
    return 'Exportar $format';
  }

  @override
  String settingsExportFailed(String error) {
    return 'A exportação falhou: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - Exportação';

  @override
  String settingsExportedCount(int count) {
    return '$count transações exportadas';
  }

  @override
  String get settingsExportPdfShareSubject =>
      'The Accountant - Relatório financeiro';

  @override
  String settingsExportPdfGenerated(int count) {
    return 'Relatório PDF gerado com $count transações';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'Vírgula para milhares';

  @override
  String get settingsNumberFormatDotThousands => 'Ponto para milhares';

  @override
  String get settingsNumberFormatSpaceThousands => 'Espaço para milhares';

  @override
  String get settingsNumberFormatNoSeparator => 'Sem separador';

  @override
  String get settingsAutoLockImmediately => 'Imediatamente';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'Nunca';

  @override
  String get settingsBiometricUnavailable =>
      'A autenticação biométrica não está disponível neste dispositivo';

  @override
  String get settingsSetPassword => 'Definir palavra-passe';

  @override
  String get settingsChangePassword => 'Alterar palavra-passe';

  @override
  String get settingsAddPasswordSubtitle =>
      'Adicionar uma palavra-passe à sua conta';

  @override
  String get settingsPasswordChanged => 'Palavra-passe alterada com sucesso';

  @override
  String get settingsPasswordSet => 'Palavra-passe definida com sucesso';

  @override
  String get settingsClearCacheBody =>
      'Isto limpa os dados em cache e força uma nova sincronização na próxima vez que abrir a app. Os seus dados não serão eliminados.';

  @override
  String get settingsClearingCache => 'A limpar a cache...';

  @override
  String get settingsCacheCleared => 'Cache limpa e sincronização iniciada';

  @override
  String get settingsClearCacheFailed => 'Não foi possível limpar a cache';

  @override
  String get settingsClearAllDataBody =>
      'Isto elimina permanentemente TODAS as suas transações, orçamentos, carteiras, categorias e definições. Esta ação não pode ser anulada!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'Todos os seus dados financeiros serão apagados permanentemente.';

  @override
  String get settingsClearingAllData => 'A apagar todos os dados...';

  @override
  String get settingsAllDataCleared => 'Todos os dados foram apagados';

  @override
  String settingsClearDataFailed(String error) {
    return 'Não foi possível apagar os dados: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'Vai ser encaminhado para um formulário para pedir a eliminação da conta. O processo demora alguns dias. Depois de concluído, todos os dados no servidor serão eliminados permanentemente.';

  @override
  String get settingsLockAuthFailed =>
      'A autenticação falhou. Tente novamente.';

  @override
  String get settingsLockError => 'Ocorreu um erro. Tente novamente.';

  @override
  String get settingsLockAuthenticating => 'A autenticar...';

  @override
  String get settingsProfileNameEmpty => 'O nome não pode ficar vazio';

  @override
  String get settingsProfileUpdated => 'Perfil atualizado com sucesso';

  @override
  String get settingsProfileUpdateFailed =>
      'Não foi possível atualizar o perfil';

  @override
  String get settingsProfileSaveChanges => 'Guardar alterações';

  @override
  String get settingsProfileSaved => 'Guardado';

  @override
  String get settingsProfilePhotoSoon =>
      'O carregamento de fotos chega em breve';

  @override
  String get settingsProfileAccountInformation => 'Informações da conta';

  @override
  String get settingsProfileMemberSince => 'Membro desde';

  @override
  String get settingsProfileUnknown => 'Desconhecido';

  @override
  String get settingsProfileFree => 'Grátis';

  @override
  String get settingsProfileUserId => 'ID de utilizador';

  @override
  String get settingsProfileUserIdCopied => 'ID de utilizador copiado';

  @override
  String get settingsPremiumMonthly => 'Premium mensal';

  @override
  String get settingsPremiumYearly => 'Premium anual';

  @override
  String get settingsPremiumLifetime => 'Premium vitalício';

  @override
  String get settingsUnsavedChangesBody =>
      'Tem alterações por guardar. Tem a certeza de que quer sair?';

  @override
  String settingsShareAppText(String url) {
    return 'Experimente o The Accountant — uma app de finanças pessoais muito bonita!\n\n$url';
  }

  @override
  String get settingsShareAppSubject =>
      'The Accountant - App de finanças pessoais';

  @override
  String get settingsCloudSyncGateBody =>
      'Mantenha os seus dados financeiros sincronizados em todos os seus dispositivos. Nunca mais perca os seus dados.';

  @override
  String settingsSyncPushed(int count) {
    return '$count enviados';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$count recebidos';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count conflitos';
  }

  @override
  String get settingsSyncNowSubtitle => 'Enviar e receber todas as alterações';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'Sincronização concluída — $pushed enviados, $pulled recebidos';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'Sincronização incompleta — $count registo(s) não puderam ser guardados e serão tentados novamente. $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'A sincronização falhou: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'Substituir os dados deste dispositivo pelos seus dados na nuvem';

  @override
  String get settingsRestoreFromCloudBody =>
      'Isto apaga TODOS os dados deste dispositivo e substitui-os pelos seus dados na nuvem. As alterações neste dispositivo que ainda não foram sincronizadas perdem-se. Esta ação não pode ser anulada.';

  @override
  String settingsRestoredFromCloud(int count) {
    return '$count itens restaurados da nuvem';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'Restauro cancelado — os seus dados locais ficaram inalterados. $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'O restauro falhou: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'Os seus dados sincronizam automaticamente a cada 15 minutos e quando abre a app. Os valores, nomes e notas são encriptados neste telemóvel antes de sincronizar, por isso o nosso servidor não os consegue ler.';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'Concluído em $seconds s';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'Concluído em $minutes min $seconds s';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'Esta é a sua categoria “$name”?';
  }

  @override
  String get settingsReconcileSavedPending =>
      'Guardado. Será aplicado na próxima sincronização.';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'A sua conta já tem $count categorias chamadas “$name”. Diga-nos se devemos usar uma delas como categoria integrada ou mantê-las separadas. Nada muda até escolher.',
      one:
          'A sua conta já tem uma categoria chamada “$name”. Diga-nos se a devemos usar como categoria integrada ou mantê-la separada. Nada muda até escolher.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'Não — manter a minha e adicionar uma separada';

  @override
  String get settingsReconcileNoneOfThese =>
      'Nenhuma destas — adicionar uma separada';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'As suas categorias “$name” existentes ficam exatamente como estão, com todas as suas transações. Uma nova categoria integrada “$name” será adicionada ao lado.',
      one:
          'A sua categoria “$name” existente fica exatamente como está, com todas as suas transações. Uma nova categoria integrada “$name” será adicionada ao lado.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'Manter separada';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return 'Usar “$name”?';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Passa a ser a categoria integrada “$name” e mantém as suas $count transações, incluindo as subcategorias. Nada é eliminado.',
      zero:
          'Passa a ser a categoria integrada “$name” e mantém tudo o que está nela, incluindo as subcategorias. Nada é eliminado.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'Usar esta';

  @override
  String settingsReconcileWillUse(String name) {
    return 'Será usada “$name”.';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'Será adicionada uma “$name” separada.';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'Introduza a palavra-passe atual e escolha uma nova';

  @override
  String get settingsSetPasswordSubtitle =>
      'Adicione uma palavra-passe à sua conta para mais segurança';

  @override
  String get settingsEnterCurrentPassword =>
      'Introduza a sua palavra-passe atual';

  @override
  String get settingsEnterNewPassword => 'Introduza uma nova palavra-passe';

  @override
  String get settingsPasswordMinLength =>
      'A palavra-passe tem de ter pelo menos 8 caracteres';

  @override
  String get settingsConfirmYourPassword => 'Confirme a sua palavra-passe';

  @override
  String get settingsPasswordsDoNotMatch => 'As palavras-passe não coincidem';

  @override
  String get settingsPleaseWait => 'Aguarde...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'Escreva “$word” para confirmar';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return '$percent% do orçamento';
  }

  @override
  String get authTooManyAttempts =>
      'Demasiadas tentativas. Aguarde um minuto e tente novamente.';

  @override
  String get authServerDown =>
      'Não conseguimos contactar os nossos servidores. O problema é do nosso lado — tente novamente dentro de alguns minutos.';

  @override
  String get authInitFailed => 'Não foi possível iniciar a autenticação';

  @override
  String get authSignInError => 'Ocorreu um erro ao iniciar sessão';

  @override
  String get authSignUpError => 'Ocorreu um erro ao registar';

  @override
  String get authGoogleCancelled =>
      'O início de sessão com o Google foi cancelado ou falhou';

  @override
  String get authFirebaseTokenFailed =>
      'Não foi possível obter o token de ID do Firebase';

  @override
  String get authGoogleSignInError =>
      'Ocorreu um erro ao iniciar sessão com o Google';

  @override
  String get authAccountExistsDifferentCredential =>
      'Já existe uma conta com o mesmo endereço de e-mail, mas com outras credenciais de início de sessão.';

  @override
  String get authInvalidCredential =>
      'A credencial fornecida está mal formada ou expirou.';

  @override
  String get authGoogleDisabled =>
      'O início de sessão com o Google está desativado.';

  @override
  String get authUserDisabled => 'Esta conta de utilizador foi desativada.';

  @override
  String get authAppleSignInError =>
      'Ocorreu um erro ao iniciar sessão com a Apple';

  @override
  String get authAppleDisabled =>
      'O início de sessão com a Apple está desativado.';

  @override
  String get authNoPendingLink => 'Não há nenhuma conta pendente para associar';

  @override
  String get authLinkFailed => 'Não foi possível associar a conta';

  @override
  String get authIncorrectPassword =>
      'Palavra-passe incorreta. Tente novamente.';

  @override
  String get authSignOutError => 'Ocorreu um erro ao terminar sessão';

  @override
  String get authLinkSubtitle =>
      'Já existe uma conta com este e-mail. Introduza a sua palavra-passe para associar a sua conta Google.';

  @override
  String get authEnterYourPasswordHint => 'Introduza a sua palavra-passe';

  @override
  String get authEnterYourPassword => 'Introduza a sua palavra-passe';

  @override
  String get authLinkInfo =>
      'Depois de associar, pode iniciar sessão com e-mail/palavra-passe ou com o Google.';

  @override
  String get authEnterYourEmail => 'Introduza o seu e-mail';

  @override
  String get authEnterValidEmail => 'Introduza um e-mail válido';

  @override
  String get authPasswordMin6 =>
      'A palavra-passe tem de ter pelo menos 6 caracteres';

  @override
  String get authNoAccountPrompt => 'Não tem conta? ';

  @override
  String get authForgotPasswordTitle => 'Esqueci-me da palavra-passe';

  @override
  String get authCheckYourEmail => 'Verifique o seu e-mail';

  @override
  String get authForgotPasswordSubtitle =>
      'Introduza o seu e-mail e enviamos-lhe um código para repor a palavra-passe.';

  @override
  String authCodeSentSubtitle(String email) {
    return 'Enviámos um código de 6 dígitos para $email. Introduza-o abaixo com a sua nova palavra-passe.';
  }

  @override
  String get authEnterYourEmailHint => 'Introduza o seu e-mail';

  @override
  String get authSixDigitCodeHint => 'Código de 6 dígitos';

  @override
  String get authEnterTheCode => 'Introduza o código';

  @override
  String get authCodeIsSixDigits => 'O código tem 6 dígitos';

  @override
  String get authCreateNewPasswordHint => 'Crie uma nova palavra-passe';

  @override
  String get authReenterNewPasswordHint =>
      'Volte a introduzir a nova palavra-passe';

  @override
  String get authEnterYourNameHint => 'Introduza o seu nome';

  @override
  String get authEnterFullName => 'Introduza o seu nome completo';

  @override
  String get authNameMin2 => 'O nome tem de ter pelo menos 2 caracteres';

  @override
  String get authCreatePasswordHint => 'Crie uma palavra-passe';

  @override
  String get authPasswordComplexity =>
      'Tem de ter maiúsculas, minúsculas e um número';

  @override
  String get authReenterPasswordHint => 'Volte a introduzir a palavra-passe';

  @override
  String get authStrengthWeak => 'Fraca';

  @override
  String get authStrengthFair => 'Razoável';

  @override
  String get authStrengthGood => 'Boa';

  @override
  String get authStrengthStrong => 'Forte';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'Aceito os $terms e a $privacy';
  }

  @override
  String get authDefaultUserName => 'Utilizador';

  @override
  String authMemberSince(String date) {
    return 'Membro desde $date';
  }

  @override
  String get authFieldRequired => 'Este campo é obrigatório';

  @override
  String authSignOutFailed(String error) {
    return 'Não foi possível terminar sessão: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'Não foi possível escolher a imagem: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'Não foi possível atualizar o perfil: $error';
  }

  @override
  String get premiumSaveAbout44 => 'Poupe ~44%';

  @override
  String get premiumBestValue => 'Melhor opção';

  @override
  String get premiumIapUnavailable => 'IAP indisponível';

  @override
  String get premiumProductNotFound => 'Produto não encontrado';

  @override
  String get premiumPlanUnavailable =>
      'Este plano não está disponível na sua conta neste momento';

  @override
  String get premiumRestoreFailed => 'Não foi possível restaurar as compras';

  @override
  String get premiumPurchaseFailed => 'A compra falhou';

  @override
  String get premiumVerificationFailed => 'A verificação falhou';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mês',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anos',
      one: '1 ano',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'Já usou $count de $limit $items da versão gratuita.';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'Mude para Premium e tenha $items sem limite, e muito mais!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'Atingiu o limite gratuito de $limit $items. Mude para Premium e tenha $items sem limite.';
  }

  @override
  String get premiumLimitWallets => 'carteiras';

  @override
  String get premiumLimitCategories => 'categorias personalizadas';

  @override
  String get premiumLimitBudgets => 'orçamentos ativos';

  @override
  String get premiumLimitObjectives => 'objetivos ativos';

  @override
  String get premiumLimitPaymentMethods => 'métodos de pagamento';

  @override
  String get backupErrNotJson =>
      'Este ficheiro não é uma cópia de segurança — não foi possível lê-lo como JSON.';

  @override
  String get backupErrNotOurs =>
      'Este ficheiro não é uma cópia de segurança do The Accountant.';

  @override
  String get backupErrNewerVersion =>
      'Esta cópia foi criada por uma versão mais recente da app. Atualize o The Accountant e tente novamente.';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'Esta cópia é de uma versão da app mais antiga do que esta consegue ler (base de dados $version, mais antiga suportada $oldest).';
  }

  @override
  String get backupErrNoData => 'Esta cópia não tem dados.';

  @override
  String backupErrSectionDamaged(String section) {
    return 'A secção “$section” desta cópia está danificada.';
  }

  @override
  String get backupErrNoHeader =>
      'Falta a esta cópia o cabeçalho que indica o que ela é.';

  @override
  String get backupErrNoSchemaVersion =>
      'Esta cópia não indica de que versão da base de dados foi feita, por isso não pode ser restaurada em segurança.';

  @override
  String get backupErrNoDate => 'Esta cópia não indica quando foi feita.';

  @override
  String get backupErrDamaged => 'Este ficheiro de cópia está danificado.';

  @override
  String get backupErrWrongKey =>
      'Esta cópia pertence a outra conta, ou o ficheiro foi alterado. Inicie sessão com a conta que a criou para a restaurar.';

  @override
  String get backupErrNoPassphraseLock =>
      'Esta cópia não pode ser aberta com uma frase-passe.';

  @override
  String get backupErrNeedsSecret =>
      'Esta cópia está protegida com uma frase-passe. Introduza-a, ou o código de recuperação, para a restaurar.';

  @override
  String get backupErrWrongSecret =>
      'Essa frase-passe ou código de recuperação não abre esta cópia.';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'Esta cópia foi criada por uma versão mais recente da app (base de dados $version, esta versão lê até $supported). Atualize o The Accountant e tente novamente.';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'Não foi possível contactar o Google Drive: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'O The Accountant ainda não tem permissão para usar o Google Drive.';

  @override
  String get backupDriveNoFolder =>
      'O Google Drive não criou uma pasta para guardar as cópias.';

  @override
  String get backupDriveNoFileId =>
      'O Google Drive aceitou a cópia, mas não indicou onde a guardou.';

  @override
  String get backupDriveTimeout =>
      'O Google Drive está a demorar demasiado a responder. Tente mais tarde.';

  @override
  String get backupDriveOffline =>
      'Sem ligação ao Google Drive. Tente novamente quando estiver online.';

  @override
  String get backupDriveDenied =>
      'O Google Drive recusou o pedido. Conceda o acesso novamente e tente outra vez.';

  @override
  String get backupDriveFileGone => 'Essa cópia já não está no Google Drive.';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'O Google Drive respondeu $status. $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'Tente novamente daqui a pouco.';

  @override
  String backupTakeFailed(String error) {
    return 'Não foi possível fazer a cópia: $error';
  }

  @override
  String get backupUnrestorableNewer =>
      'Criada por uma versão mais recente da app.';

  @override
  String get backupUnrestorableOlder =>
      'Mais antiga do que esta versão da app consegue ler.';

  @override
  String get backupKeyUnusable =>
      'O servidor enviou uma chave de encriptação inutilizável. Tente mais tarde.';

  @override
  String get backupKeyNeedsSignIn =>
      'Inicie sessão para fazer ou restaurar uma cópia — as cópias são encriptadas com a sua conta.';

  @override
  String get backupKeyNeedsInternet =>
      'Ligue-se à internet uma vez para que os seus dados possam ser encriptados e tente novamente.';

  @override
  String get backupKeyLocked =>
      'Os seus dados estão protegidos com uma frase-passe. Desbloqueie-os primeiro neste dispositivo.';

  @override
  String get backupFrequencyManual => 'Só quando eu pedir';

  @override
  String get backupFrequencyDaily => 'Todos os dias';

  @override
  String get backupFrequencyWeekly => 'Todas as semanas';

  @override
  String get backupFrequencyMonthly => 'Todos os meses';

  @override
  String get backupIntro =>
      'Uma cópia de segurança é um único ficheiro com tudo o que está neste dispositivo — cada transação, conta, orçamento e objetivo. Guarde uma num lugar seguro e nada daqui se perde para sempre.';

  @override
  String get backupSectionOnDevice => 'NESTE DISPOSITIVO';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'CÓPIAS NO DRIVE';

  @override
  String backupBackedUpCount(int count) {
    return '$count registos copiados.';
  }

  @override
  String get backupSaveDialogTitle => 'Guardar cópia';

  @override
  String get backupChooseFileTitle => 'Escolher um ficheiro de cópia';

  @override
  String backupFileUnreadable(String error) {
    return 'Não foi possível ler esse ficheiro: $error';
  }

  @override
  String backupTakenOn(String date) {
    return 'Feita a $date.';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return 'Feita a $date em $device.';
  }

  @override
  String backupBelongedTo(String email) {
    return 'Pertencia a $email.';
  }

  @override
  String get backupDifferentAccountWarning =>
      'Esta não é a conta com sessão iniciada aqui. O restauro vai colocar os registos de outra pessoa neste dispositivo.';

  @override
  String get backupRestoreEraseWarning =>
      'Tudo o que está neste dispositivo é apagado e substituído. O que ainda não foi sincronizado perde-se. Esta ação não pode ser anulada.';

  @override
  String backupRestoredCount(int count) {
    return '$count registos restaurados.';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$count registos restaurados. Uma parte do ficheiro não era compatível com esta versão e ficou de fora.';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'Nada foi alterado — o restauro falhou: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'As cópias vão para uma pasta privada que só esta app pode abrir. Os seus outros ficheiros nunca são lidos.';

  @override
  String get backupDriveConnectedTitle => 'Google Drive ligado';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'As cópias deste dispositivo vão para uma pasta chamada “$folder” no seu Drive.';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'As cópias vão para “$folder” no seu Drive.';
  }

  @override
  String get backupNoneYet =>
      'Ainda não foi enviada nenhuma cópia deste dispositivo';

  @override
  String backupLastBackedUp(String date) {
    return 'Última cópia: $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count cópias — as mais antigas são removidas quando chega uma nova';
  }

  @override
  String get backupDisconnectSubtitle =>
      'Para as cópias automáticas. Nada do que já foi guardado é eliminado.';

  @override
  String backupListFailed(String error) {
    return 'Não foi possível listar as suas cópias: $error';
  }

  @override
  String get backupDriveNotGranted =>
      'O acesso ao Google Drive não foi concedido.';

  @override
  String get backupDriveConnected => 'Google Drive ligado.';

  @override
  String backupDriveConnectFailed(String error) {
    return 'Não foi possível ligar o Google Drive: $error';
  }

  @override
  String get backupDisconnectBody =>
      'As cópias automáticas param. As cópias que já estão no Drive ficam onde estão, e pode voltar a ligar a qualquer momento.';

  @override
  String backupSavedToDrive(String name) {
    return '$name guardado no Google Drive.';
  }

  @override
  String backupCopyFailed(String error) {
    return 'Não foi possível guardar essa cópia: $error';
  }

  @override
  String get backupDeleteBody => 'É removida do Google Drive para sempre.';

  @override
  String get backupRefresh => 'Atualizar';

  @override
  String get ppErrKdfParams => 'Parâmetros de derivação de chave inaceitáveis.';

  @override
  String get ppErrKdfAlgorithm =>
      'Algoritmo de derivação de chave desconhecido.';

  @override
  String get onboardingIntroAccountsTitle => 'Todas as contas, um só saldo';

  @override
  String get onboardingIntroAccountsBody =>
      'Tenha dinheiro, cartões e poupanças lado a lado e veja o que realmente lhe resta.';

  @override
  String get onboardingIntroBudgetsTitle => 'Orçamentos que avisam a tempo';

  @override
  String get onboardingIntroBudgetsBody =>
      'Defina um limite por categoria. A app acompanha o total e avisa-o antes de o ultrapassar, não depois.';

  @override
  String get onboardingIntroAskTitle =>
      'Pergunte sobre os seus próprios gastos';

  @override
  String get onboardingIntroAskBody =>
      'Digitalize um recibo, ou pergunte para onde foi o dinheiro no mês passado, e receba uma resposta baseada nos seus registos.';

  @override
  String get onboardingIntroThemeTitle => 'Deixe-a à sua maneira';

  @override
  String get onboardingIntroThemeBody =>
      'Escolha um tema agora ou mude-o quando quiser nas definições.';

  @override
  String get onboardingCreateYourAccount => 'Crie a sua conta';

  @override
  String get onboardingNext => 'Seguinte';

  @override
  String get onboardingCurrencyInfo =>
      'Esta será a sua moeda principal. Pode adicionar contas noutras moedas mais tarde.';

  @override
  String get onboardingTypeCash => 'Dinheiro';

  @override
  String get onboardingTypeBank => 'Conta bancária';

  @override
  String get onboardingTypeCard => 'Cartão de crédito';

  @override
  String get onboardingTypeDeposit => 'Depósito';

  @override
  String get onboardingTypeInvestment => 'Investimento';

  @override
  String get onboardingTypeAsset => 'Ativo';

  @override
  String onboardingDayN(int day) {
    return 'Dia $day';
  }

  @override
  String get onboardingAllSet => 'Está tudo pronto!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'Não foi possível concluir a configuração: $error';
  }

  @override
  String get onboardingSkipFailed => 'Não foi possível saltar a configuração';

  @override
  String get startupOfflineConfirmBody =>
      'Os seus dados ficam exatamente onde estão — nada neste dispositivo ou na nuvem será eliminado.\n\nMas, se a conta tiver dados guardados, tudo o que adicionar agora vai ficar ao lado deles quando restaurar — poderá ter duplicados para arrumar.';

  @override
  String get startupDataInCloudTitle =>
      'Os seus dados estão à sua espera na nuvem';

  @override
  String get startupLoadFailedTitle =>
      'Não conseguimos terminar de carregar a sua conta';

  @override
  String get startupGenericReason => 'Algo correu mal ao verificar esta conta.';

  @override
  String get startupUseWithoutRestoring => 'Usar a app sem restaurar';

  @override
  String get legalTermsTab => 'Termos';

  @override
  String get legalConsent =>
      'Li e aceito a Política de privacidade e os Termos e Condições';

  @override
  String get walkthroughGotIt => 'Entendido!';

  @override
  String get settingsFaqSectionGettingStarted => 'Primeiros passos';

  @override
  String get settingsFaq01Question => 'Como adiciono uma transação?';

  @override
  String get settingsFaq01Answer =>
      'Toque no botão + na parte de baixo do ecrã inicial. Indique o valor, escolha uma categoria e uma carteira e, se quiser, adicione notas. Toque em Guardar para registar a transação.';

  @override
  String get settingsFaq02Question =>
      'Qual é a diferença entre carteiras e categorias?';

  @override
  String get settingsFaq02Answer =>
      'As carteiras mostram onde está o seu dinheiro (por ex. Dinheiro, Conta bancária, Cartão de crédito). As categorias descrevem em que foi gasto o dinheiro ou de onde veio (por ex. Alimentação, Salário, Lazer).';

  @override
  String get settingsFaq03Question =>
      'Como personalizo o formato de data e de números?';

  @override
  String get settingsFaq03Answer =>
      'Vá a Definições > Definições regionais. Pode mudar a moeda predefinida, o formato de data (por ex. DD/MM/YYYY ou MM/DD/YYYY) e o formato de números (por ex. 1,234.56 ou 1.234,56). Uma pré-visualização mostra logo como fica.';

  @override
  String get settingsFaqSectionTransactions => 'Transações';

  @override
  String get settingsFaq04Question => 'Posso registar transações recorrentes?';

  @override
  String get settingsFaq04Answer =>
      'Sim! Ao adicionar uma transação, ative a opção «Recorrente». Pode defini-la para se repetir todos os dias, semanas, meses ou anos. A app cria essas transações automaticamente por si.';

  @override
  String get settingsFaq05Question =>
      'Como transfiro dinheiro entre carteiras?';

  @override
  String get settingsFaq05Answer =>
      'Ao adicionar uma transação, escolha «Transferência» como tipo. Escolha a carteira de origem e a de destino e indique o valor. A app retira automaticamente o valor de uma e adiciona-o à outra.';

  @override
  String get settingsFaq06Question => 'O que são transações próximas?';

  @override
  String get settingsFaq06Answer =>
      'As transações próximas são despesas ou receitas futuras que espera, mas que ainda não foram pagas. Não afetam o saldo da carteira até as marcar como pagas. Encontra os itens em atraso e próximos na secção de transações.';

  @override
  String get settingsFaq07Question => 'Como acompanho as minhas subscrições?';

  @override
  String get settingsFaq07Answer =>
      'Ao adicionar uma transação, defina o tipo como Subscrição. Assim fica marcada como pagamento regular de um serviço. Pode ver todas as suas subscrições num só lugar e acompanhar quanto gasta com elas por mês.';

  @override
  String get settingsFaq08Question =>
      'Como funciona o registo de crédito e dívida?';

  @override
  String get settingsFaq08Answer =>
      'Use Crédito para o dinheiro que emprestou a alguém e Dívida para o dinheiro que pediu emprestado. Cada registo guarda o valor, quem deve a quem e quanto já foi pago. Pode registar pagamentos parciais e marcar as dívidas como saldadas quando estiverem pagas.';

  @override
  String get settingsFaq09Question =>
      'Posso adicionar notas ou recibos às transações?';

  @override
  String get settingsFaq09Answer =>
      'Sim! Ao adicionar ou editar uma transação, pode escrever no campo de notas. Os utilizadores Premium também podem digitalizar recibos com o leitor de recibos com IA, que extrai automaticamente o valor e o comerciante.';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'Carteiras e moedas';

  @override
  String get settingsFaq10Question => 'Como faço a gestão de várias contas?';

  @override
  String get settingsFaq10Answer =>
      'A app tem quatro tipos de conta: Dinheiro, Conta bancária, Cartão de crédito e Subscrição. Para adicionar uma conta, vá a «As suas contas» no painel e toque em «Adicionar conta». Cada conta pode ter o seu nome, ícone, cor e moeda. A primeira conta passa automaticamente a ser a predefinida. Nos cartões de crédito também pode definir o limite de crédito e o dia de faturação, para acompanhar o crédito disponível.';

  @override
  String get settingsFaq11Question => 'Posso usar várias moedas?';

  @override
  String get settingsFaq11Answer =>
      'Sim! Cada carteira pode ter a sua própria moeda. A app converte automaticamente os valores com taxas de câmbio atualizadas. Também pode definir taxas de câmbio personalizadas em Definições > Definições regionais.';

  @override
  String get settingsFaq12Question => 'Como funciona a conversão de moedas?';

  @override
  String get settingsFaq12Answer =>
      'Cada carteira pode ter uma moeda diferente, e a app converte os valores automaticamente com taxas de câmbio atualizadas de poucas em poucas horas. Também pode definir taxas personalizadas para qualquer par de moedas em Definições > Definições regionais. A app suporta mais de 150 moedas, com taxas obtidas automaticamente.';

  @override
  String get settingsFaq13Question =>
      'O que acontece se eu apagar uma categoria com transações?';

  @override
  String get settingsFaq13Answer =>
      'Essas transações passam para «Sem categoria». Depois pode atribuí-las a outra categoria ou deixá-las sem categoria.';

  @override
  String get settingsFaq14Question => 'O que são subcategorias e como as uso?';

  @override
  String get settingsFaq14Answer =>
      'Pode criar subcategorias dentro de qualquer categoria principal para um registo mais detalhado. Por exemplo, em «Alimentação» pode ter «Supermercado», «Restaurantes» e «Café». As subcategorias mostram exatamente para onde vai o seu dinheiro.';

  @override
  String get settingsFaq15Question => 'O que é uma correção de saldo?';

  @override
  String get settingsFaq15Answer =>
      'Uma correção de saldo permite ajustar o saldo de uma carteira quando não corresponde ao valor real. Cria uma transação especial que acerta o saldo registado com a realidade, sem ter de adicionar receitas ou despesas à mão.';

  @override
  String get settingsFaqSectionBudgetsGoals => 'Orçamentos e objetivos';

  @override
  String get settingsFaq16Question => 'Como crio um orçamento?';

  @override
  String get settingsFaq16Answer =>
      'Vá ao separador Orçamentos e toque em «Novo orçamento». Escolha um nome, defina o limite de gastos, escolha o período (semanal/mensal) e as categorias a acompanhar. A app avisa-o quando se aproximar do limite.';

  @override
  String get settingsFaq17Question => 'O que são objetivos de poupança?';

  @override
  String get settingsFaq17Answer =>
      'Os objetivos de poupança permitem definir um valor que quer poupar. Crie um objetivo na secção Objetivos, defina a meta e associe transações para acompanhar o progresso. A app mostra uma barra de progresso e a percentagem já alcançada.';

  @override
  String get settingsFaq18Question => 'Como acompanho um empréstimo?';

  @override
  String get settingsFaq18Answer =>
      'Crie um objetivo do tipo Empréstimo na secção Objetivos com o valor total em dívida. À medida que faz pagamentos, associe essas transações ao empréstimo para acompanhar o reembolso. A app mostra quanto já pagou e quanto falta.';

  @override
  String get settingsFaqSectionDataSync => 'Dados e sincronização';

  @override
  String get settingsFaq19Question => 'Como funciona a sincronização na nuvem?';

  @override
  String get settingsFaq19Answer =>
      'A sincronização na nuvem mantém os seus dados iguais em todos os dispositivos. Vá a Definições > Gestão de dados > Sincronização na nuvem para a ativar. A sincronização corre automaticamente a cada 15 minutos e sempre que abre a app. Também pode tocar em «Sincronizar agora» para sincronizar de imediato. Esta é uma funcionalidade Premium.';

  @override
  String get settingsFaq20Question => 'Como exporto os meus dados?';

  @override
  String get settingsFaq20Answer =>
      'Vá a Definições > Gestão de dados > Exportar dados. Escolha um intervalo de datas, selecione CSV (para folhas de cálculo) ou PDF (para um relatório formatado) e toque em Exportar. Pode incluir ou excluir os detalhes por categoria e por carteira. Esta é uma funcionalidade Premium.';

  @override
  String get settingsFaq21Question =>
      'O que acontece se eu limpar os meus dados?';

  @override
  String get settingsFaq21Answer =>
      'Vá a Definições > Privacidade e segurança. «Limpar cache» remove os dados temporários e força uma nova sincronização sem apagar as suas transações. «Limpar todos os dados» apaga tudo de forma permanente — terá de escrever DELETE para confirmar. Esta ação não pode ser desfeita.';

  @override
  String get settingsFaqSectionPremiumAiFeatures =>
      'Premium e funcionalidades de IA';

  @override
  String get settingsFaq22Question => 'O que está incluído no Premium?';

  @override
  String get settingsFaq22Answer =>
      'O Premium desbloqueia: IA ilimitada (o consultor, os resumos mensais, a leitura de recibos e o Descreva-a) sem anúncios, sincronização na nuvem, relatórios PDF, temas Premium, e remove os limites de carteiras, categorias, orçamentos, objetivos e métodos de pagamento. Também tem apoio prioritário.';

  @override
  String get settingsFaq23Question =>
      'Quais são os limites da versão gratuita?';

  @override
  String get settingsFaq23Answer =>
      'Na versão gratuita pode criar até 3 carteiras, 10 categorias personalizadas, 3 orçamentos ativos, 2 objetivos/empréstimos ativos e 5 métodos de pagamento. Ao passar a Premium, todos estes limites desaparecem.';

  @override
  String get settingsFaq24Question => 'O que pode fazer o assistente de IA?';

  @override
  String get settingsFaq24Answer =>
      'O consultor financeiro responde a perguntas sobre o seu próprio dinheiro: para onde foi, se está a cumprir os orçamentos e objetivos, que contas estão para chegar e como gastar menos ou poupar mais. Vê um resumo dos seus números (totais, categorias, orçamentos, objetivos, contas a pagar e transações recentes), por isso as respostas usam os seus valores reais, e sugere perguntas de seguimento depois de cada resposta. Dá orientações gerais, não aconselhamento financeiro profissional. As conversas ficam guardadas para poder continuar onde parou, e pode apagá-las a qualquer momento.';

  @override
  String get settingsFaq25Question => 'Como funcionam as análises com IA?';

  @override
  String get settingsFaq25Answer =>
      'O resumo mensal (Estatísticas > Análise de gastos) compara este mês com o anterior: o que ganhou e gastou e como mudou cada categoria. Toque em Escrever o meu resumo e a IA destaca o que sobressaiu e sugere uma coisa para experimentar. Os números são gratuitos para todos; o texto da IA usa um pedido de IA.';

  @override
  String get settingsFaq26Question => 'O que é a categorização inteligente?';

  @override
  String get settingsFaq26Answer =>
      'Quando classifica uma transação à mão, a app lembra-se de que categoria corresponde a esse título e escolhe-a por si da próxima vez (pode vê-las e editá-las em Regras de nomes). Para algo novo, toque no botão de brilho no ecrã de adicionar e use o Descreva-a: escreva algo como «almoço 250 ontem pelo bKash» e a IA preenche o valor, a data, a categoria e a conta para confirmar.';

  @override
  String get settingsFaq27Question =>
      'Como funciona o leitor de recibos com IA?';

  @override
  String get settingsFaq27Answer =>
      'Tire ou escolha uma foto de um recibo. O telemóvel lê o texto no próprio dispositivo e sugere o comerciante e o total. Toque em Ler com IA e a IA descobre o total real, a data, cada artigo e a categoria certa, mesmo num recibo confuso; só o texto é enviado, nunca a foto. Pode rever e editar antes de guardar. Ler com IA usa um pedido de IA.';

  @override
  String get settingsFaq28Question =>
      'Quantos pedidos de IA tenho e para que servem os anúncios?';

  @override
  String get settingsFaq28Answer =>
      'Todos têm 10 pedidos de IA gratuitos por mês, que voltam no dia 1. Se quiser mais, pode optar por ver um anúncio curto para ganhar mais um pedido, até mais 10 por mês. Os anúncios também podem desbloquear um teste de 24 horas de um tema Premium ou uma exportação em PDF. Um anúncio só passa depois de tocar num botão e confirmar; não há anúncios em banner e nada aparece sozinho. Os membros Premium têm IA ilimitada e tudo o resto, sem anúncios nenhuns.';

  @override
  String get settingsFaq29Question =>
      'Como faço a gestão da minha compra Premium?';

  @override
  String get settingsFaq29Answer =>
      'As compras Premium são geridas através do Google Play. Abra as definições de subscrições do Google Play para ver ou gerir o seu plano. O Premium está disponível como compra mensal, anual ou vitalícia única.';

  @override
  String get settingsFaqSectionPrivacySecurity => 'Privacidade e segurança';

  @override
  String get settingsFaq30Question => 'Como configuro o bloqueio biométrico?';

  @override
  String get settingsFaq30Answer =>
      'Vá a Definições > Privacidade e segurança e ative o Bloqueio biométrico. A partir daí, precisa da impressão digital ou do rosto para abrir a app. Também pode definir um temporizador de bloqueio automático para a app bloquear após algum tempo sem uso.';

  @override
  String get settingsFaq31Question =>
      'Os meus dados financeiros estão seguros?';

  @override
  String get settingsFaq31Answer =>
      'Sim. Todos os seus dados ficam guardados localmente no seu dispositivo. Se ativar a sincronização na nuvem, os dados são encriptados durante a transferência. Nunca partilhamos os seus dados financeiros com terceiros. Pode consultar a nossa Política de privacidade em Definições > Sobre.';

  @override
  String get txnLoadPaymentMethodsFailed =>
      'Não foi possível carregar os métodos de pagamento';

  @override
  String get txnAddPaymentMethodFailed =>
      'Não foi possível adicionar o método de pagamento';

  @override
  String get txnPaymentMethodNotFound => 'Método de pagamento não encontrado';

  @override
  String get txnUpdatePaymentMethodFailed =>
      'Não foi possível atualizar o método de pagamento';

  @override
  String get txnDeletePaymentMethodFailed =>
      'Não foi possível eliminar o método de pagamento';

  @override
  String txnLoadFailed(String error) {
    return 'Não foi possível carregar as transações: $error';
  }

  @override
  String get txnAddFailed => 'Não foi possível adicionar a transação';

  @override
  String txnAddFailedWithError(String error) {
    return 'Não foi possível adicionar a transação: $error';
  }

  @override
  String get txnNotFound => 'Transação não encontrada';

  @override
  String get txnUpdateFailed => 'Não foi possível atualizar a transação';

  @override
  String txnNotATransfer(String id) {
    return 'A transação $id não é uma transferência';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'Não foi possível atualizar a transferência: $error';
  }

  @override
  String get txnDeleteFailed => 'Não foi possível eliminar a transação';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'Não foi possível carregar as transferências: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'Não foi possível criar a transferência: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'Não foi possível eliminar a transferência: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'Não foi possível carregar os dados: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'Não foi possível marcar como pago: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'Não foi possível marcar como não pago: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'Não foi possível ignorar a transação: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'Recebido: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'Pago: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'Revertido: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'Não foi possível marcar como liquidado: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'O valor do pagamento tem de ser positivo';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'Não foi possível registar o pagamento: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'Não foi possível marcar como pendente: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'Em falta: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'Pagamento de $amount registado';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'Marcado como recebido de \"$title\"';
  }

  @override
  String get importFieldDescription => 'Descrição';

  @override
  String get importFieldDirection => 'Tipo (crédito/débito)';

  @override
  String get importMissingDate => 'uma coluna de data';

  @override
  String get importMissingAmount => 'uma coluna de valor';

  @override
  String importColumnN(int index) {
    return 'Coluna $index';
  }

  @override
  String get importNoDate => 'Sem data';

  @override
  String importDateMismatch(String date, String format) {
    return 'A data \"$date\" não corresponde a $format';
  }

  @override
  String get importAnyKnownFormat => 'nenhum formato conhecido';

  @override
  String get importNoAmount => 'Sem valor';

  @override
  String get importIntro =>
      'Exporte um CSV do seu banco e abra-o aqui. As colunas são identificadas por si, e nada é adicionado antes de ver exatamente o que vai ser.';

  @override
  String get importSavedBanks => 'BANCOS GUARDADOS';

  @override
  String get importChooseStatement => 'Escolher um extrato';

  @override
  String get importNoRows => 'Esse ficheiro não tem linhas.';

  @override
  String importUsingSavedMapping(String name) {
    return 'A usar o seu mapeamento guardado para $name.';
  }

  @override
  String importCouldNotRead(String error) {
    return 'Não foi possível ler esse ficheiro: $error';
  }

  @override
  String importForgetTitle(String name) {
    return 'Esquecer $name?';
  }

  @override
  String get importForgetBody =>
      'Da próxima vez, ser-lhe-á pedido que associe as colunas de novo.';

  @override
  String get importColumnsHeader => 'COLUNAS';

  @override
  String get importHowToRead => 'COMO LER OS VALORES';

  @override
  String get importWhereItGoes => 'PARA ONDE VAI';

  @override
  String get importWhatWillBeAdded => 'O QUE VAI SER ADICIONADO';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas',
      one: '1 linha',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count colunas',
      one: '1 coluna',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'separadas por $separator';
  }

  @override
  String importMappedAs(String name) {
    return 'mapeado como $name';
  }

  @override
  String get importDelimCommas => 'vírgulas';

  @override
  String get importDelimSemicolons => 'pontos e vírgulas';

  @override
  String get importDelimTabs => 'tabulações';

  @override
  String get importDelimPipes => 'barras verticais';

  @override
  String get importRequired => 'Obrigatório';

  @override
  String get importNotImported => 'Não importado';

  @override
  String get importEmptySample => 'vazio';

  @override
  String get importPickDateColumnFirst =>
      'Escolha primeiro uma coluna de data.';

  @override
  String importDateDoesNotFit(String sample) {
    return '\"$sample\" não corresponde a este formato.';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '\"$sample\" lê-se como $date';
  }

  @override
  String get importDecimalAuto => 'Deduzido do ficheiro';

  @override
  String get importDecimalFullStop => 'Um ponto, como em 1,234.56';

  @override
  String get importDecimalComma => 'Uma vírgula, como em 1.234,56';

  @override
  String get importDuplicatesHint =>
      'Compara o dia, o valor e a descrição, para que reimportar um extrato sobreposto não duplique nada';

  @override
  String importStillNeeds(String item) {
    return 'Ainda falta $item.';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'Ainda falta $first e $second.';
  }

  @override
  String get importNothingReadable =>
      'Nada neste ficheiro pode ser lido com estas definições. Verifique o formato da data e a coluna que tem o valor.';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações',
      one: '1 transação',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount de entrada';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount de saída';
  }

  @override
  String importAndMore(int count) {
    return 'e mais $count';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas serão ignoradas',
      one: '1 linha será ignorada',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas serão ignoradas.',
      one: '1 linha será ignorada.',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'Linha $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'Adicione primeiro uma conta';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count transações',
      one: 'Importar 1 transação',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count transações?',
      one: 'Importar 1 transação?',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'São adicionadas aos seus registos e enviadas na próxima sincronização.';

  @override
  String get importConfirmDuplicates =>
      'O que já existe no mesmo dia, com o mesmo valor e descrição, fica como está.';

  @override
  String importFailed(String error) {
    return 'A importação falhou: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count importadas';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count já existiam e ficaram como estavam.';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas não puderam ser lidas.',
      one: '1 linha não pôde ser lida.',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'Novas categorias: $names.';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'Estes nomes de conta não tinham correspondência aqui, por isso as linhas foram para a conta que escolheu: $names.';
  }

  @override
  String get importRememberBody =>
      'O próximo ficheiro com estas mesmas colunas será mapeado assim sem perguntar.';

  @override
  String get importNoHeaderCannotSave =>
      'Um ficheiro sem títulos de coluna não pode ser reconhecido de novo, por isso não há nada para comparar.';

  @override
  String get importTemplateSaved =>
      'Guardado. Os ficheiros com estas colunas passam a usá-lo.';

  @override
  String get txnTransferSameWallet =>
      'As carteiras de origem e destino têm de ser diferentes';

  @override
  String get txnTransferAmountPositive =>
      'O valor da transferência tem de ser positivo';

  @override
  String get txnTransferFeeNegative =>
      'A taxa de transferência não pode ser negativa';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'Carteira de origem não encontrada: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'Carteira de destino não encontrada: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'Transferência: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'As duas carteiras têm de existir para transferir entre elas (origem: $source, destino: $destination).';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'Uma transferência numa só moeda move um único valor: $source e $destination estão ambas em $currency, por isso o valor recebido não pode ser diferente.';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'Não se conhece nenhuma taxa entre $from e $to, por isso introduza o que realmente chegou a $destination.';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'O valor recebido tem de ser superior a zero. Introduza o que realmente chegou a $destination.';
  }

  @override
  String txnFeeTitle(String title) {
    return 'Taxa: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'Transação não encontrada: $id';
  }

  @override
  String get txnNotATransferNoPair =>
      'A transação não é uma transferência (sem transação associada)';

  @override
  String txnPairedNotFound(String id) {
    return 'Transação associada $id não encontrada; não é possível editar metade de uma transferência.';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'Conta inexistente: $id';
  }

  @override
  String get walletCorrectionTitle => 'Correção do saldo';

  @override
  String walletCorrectionNote(String name) {
    return '$name ajustada ao saldo real.';
  }

  @override
  String get walletMergeIntoItself =>
      'Uma conta não pode ser fundida em si própria.';

  @override
  String get walletMergeBothMustExist =>
      'As duas contas têm de existir para serem fundidas.';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'Não se conhece nenhuma taxa entre $from e $to, por isso estas contas ainda não podem ser fundidas.';
  }

  @override
  String get walletMergeAdjustmentTitle => 'Ajuste da fusão';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'A taxa de uma transferência entre estas contas é diferente da taxa a que $name foi fundida. Isto regista a diferença para que o total não mude.';
  }

  @override
  String get splitErrNoTotal => 'Introduza o valor da conta.';

  @override
  String get splitErrNoPeople => 'Adicione alguém com quem dividir.';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name não faz parte desta conta.';
  }

  @override
  String get splitErrNothingToRecord =>
      'Outra pessoa pagou e não teve parte nenhuma, por isso não há nada a registar.';

  @override
  String get splitErrGiveOwnShare => 'Indique a sua parte.';

  @override
  String splitErrGiveShare(String name) {
    return 'Indique a parte de $name.';
  }

  @override
  String get splitErrNegativeShare => 'Uma parte não pode ser negativa.';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'As partes somam $sum, não $total.';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'As percentagens somam $sum%, não 100%.';
  }

  @override
  String get splitErrNameTooLong =>
      'Os nomes devem ter menos de 100 caracteres.';

  @override
  String splitErrDuplicateName(String name) {
    return '$name está duas vezes na conta.';
  }

  @override
  String get splitErrTitleTooLong =>
      'O título deve ter menos de 200 caracteres.';

  @override
  String get splitErrChooseAccount => 'Escolha a conta de onde foi pago.';

  @override
  String get splitErrOrdinaryAccount => 'Escolha uma conta normal.';

  @override
  String get splitErrYourShareNothing =>
      'A sua parte é nula, por isso não há nada em dívida.';

  @override
  String get splitErrEveryShareNothing => 'Todas as partes são nulas.';

  @override
  String get recurringDaily => 'Diário';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count dias',
      one: 'Todos os dias',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count semanas',
      one: 'Todas as semanas',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count meses',
      one: 'Todos os meses',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count anos',
      one: 'Todos os anos',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'A cada $count $unit';
  }

  @override
  String get recurringUntitled => 'Transação recorrente';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Daqui a $count dias',
      one: 'Daqui a 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'Na próxima semana';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Daqui a $count semanas',
      one: 'Daqui a 1 semana',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'Cartão';

  @override
  String get txnPmKindDigitalWallet => 'Carteira digital';

  @override
  String get txnPmEmptyHint =>
      'Adicione os cartões e contas com que paga e poderá escolher um numa transação.';

  @override
  String get txnPmDeleteBody =>
      'As transações já registadas com ele mantêm-se. Apenas deixam de indicar um método de pagamento.';

  @override
  String get txnPmNew => 'Novo método de pagamento';

  @override
  String get txnPmEdit => 'Editar método de pagamento';

  @override
  String get txnRecentlyDeletedFooter =>
      'As transações eliminadas ficam guardadas trinta dias e depois são removidas de vez.';

  @override
  String get txnUnknownCategory => 'Desconhecida';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'Exatamente isto';

  @override
  String get txnRuleContaining => 'Tudo o que contenha isto';

  @override
  String get txnRulesFooter =>
      'Uma regra corresponde a qualquer parte do título, a menos que a torne exata. A aplicação cria uma sempre que classifica algo à mão.';

  @override
  String get txnRulesEmptyHint =>
      'Ensine uma vez à aplicação onde algo pertence e ela passa a classificá-lo assim.';

  @override
  String get txnRuleNew => 'Nova regra';

  @override
  String get txnRuleEdit => 'Editar regra';

  @override
  String get txnRuleExactHint => 'Apenas títulos que sejam exatamente isto';

  @override
  String get txnRuleContainingHint => 'Qualquer título que o contenha';

  @override
  String get txnKindTransfer => 'Transferência entre contas';

  @override
  String get txnKindRecurring => 'De uma entrada recorrente';

  @override
  String get txnMoneyIn => 'Entrada';

  @override
  String get txnMoneyOut => 'Saída';

  @override
  String get txnNotYetPaid => 'Ainda não pago';

  @override
  String get txnLentOut => 'Emprestado';

  @override
  String get txnSettledInFull => 'Liquidado na totalidade.';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid devolvido, $owed ainda em dívida.';
  }

  @override
  String get txnUncategorised => 'Sem categoria';

  @override
  String get txnUnknownAccount => 'Desconhecida';

  @override
  String get txnTransferCannotCopy =>
      'Uma transferência não pode ser copiada sozinha.';

  @override
  String get txnCopied => 'Copiada.';

  @override
  String get txnDeleteOneBody =>
      'O saldo da conta é recalculado. Se isto for metade de uma transferência, a outra metade vai junto.';

  @override
  String txnUpcomingTab(int count) {
    return 'Próximos ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'Em atraso ($count)';
  }

  @override
  String get txnNoOverdue => 'Sem transações em atraso';

  @override
  String get txnNoUpcoming => 'Sem transações próximas';

  @override
  String get txnNoOverdueBody => 'Todos os seus pagamentos estão em dia!';

  @override
  String get txnNoUpcomingBody => 'Não tem pagamentos pendentes agendados';

  @override
  String get txnTotalOverdue => 'Total em atraso';

  @override
  String get txnTotalUpcoming => 'Total próximo';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias em atraso',
      one: '1 dia em atraso',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '\"$title\" marcado como pago';
  }

  @override
  String txnSkippedTitle(String title) {
    return '\"$title\" ignorado';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'Hoje, $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'Ontem, $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'Amanhã, $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'Erro ao eliminar a transação: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return 'Filtrar $title';
  }

  @override
  String get txnMonthlyIncome => 'Rendimento mensal';

  @override
  String get txnMonthlyExpenses => 'Despesas mensais';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'transações',
      one: 'transação',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'média por transação';

  @override
  String get txnNoPlannedIncome => 'Sem rendimentos planeados';

  @override
  String get txnNoPlannedExpenses => 'Sem despesas planeadas';

  @override
  String txnAddFutureIncome(String month) {
    return 'Adicione rendimentos futuros para $month';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'Adicione despesas futuras para $month';
  }

  @override
  String get txnNoIncomeYet => 'Ainda sem rendimentos este mês';

  @override
  String get txnNoExpensesYet => 'Ainda sem despesas este mês';

  @override
  String get txnStartTrackingIncome =>
      'Comece a registar os seus rendimentos este mês';

  @override
  String get txnStartTrackingExpenses =>
      'Comece a registar as suas despesas este mês';

  @override
  String txnNoIncomeIn(String month) {
    return 'Sem rendimentos em $month';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'Sem despesas em $month';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'Sem registos para $month';
  }

  @override
  String get txnOtherCategory => 'Outra';

  @override
  String get txnSearchIncome => 'Pesquisar rendimentos';

  @override
  String get txnSearchExpenses => 'Pesquisar despesas';

  @override
  String txnErrorWith(String error) {
    return 'Erro: $error';
  }

  @override
  String get txnTapToEditAmount => 'Toque para editar o valor';

  @override
  String get txnTapToEnterAmount => 'Toque para introduzir o valor';

  @override
  String get txnSpecialDefault => 'Normal';

  @override
  String get txnSpecialRepetitive => 'Repetitiva';

  @override
  String get txnRepeatSettings => 'Definições de repetição';

  @override
  String get txnSubscriptionSettings => 'Definições da subscrição';

  @override
  String txnEndsOn(String date) {
    return 'Termina: $date';
  }

  @override
  String get txnNoEndDate => 'Sem data de fim';

  @override
  String get txnEditTransaction => 'Editar transação';

  @override
  String get txnNewTransaction => 'Nova transação';

  @override
  String get txnFromAccount => 'Da conta';

  @override
  String get txnToAccount => 'Para a conta';

  @override
  String get txnAmountReceived => 'Valor recebido';

  @override
  String txnAmountReceivedHint(String account) {
    return 'Estas contas usam moedas diferentes. Introduza o que realmente chegou a $account, ou deixe em branco para usar a taxa da aplicação.';
  }

  @override
  String txnInCurrency(String currency) {
    return 'Em $currency';
  }

  @override
  String get txnTransferTitleHint => 'ex. Passar para poupanças (opcional)';

  @override
  String get txnTitleHint => 'Foi para quê?';

  @override
  String get txnUpdate => 'Atualizar';

  @override
  String get txnSelectCategory => 'Selecionar categoria';

  @override
  String get txnSearchTransactions => 'Pesquisar transações';

  @override
  String get txnSpecialRegular => 'Normal';

  @override
  String get txnSpecialLend => 'Emprestar';

  @override
  String get txnSpecialBorrow => 'Pedir emprestado';

  @override
  String get txnSpecialRegularDesc => 'Transação normal';

  @override
  String get txnSpecialUpcomingDesc => 'Pagamento futuro a acompanhar';

  @override
  String get txnSpecialSubscriptionDesc => 'Pagamento recorrente de um serviço';

  @override
  String get txnSpecialRepetitiveDesc => 'Transação repetida';

  @override
  String get txnSpecialLendDesc => 'Dinheiro que emprestou (devem-lhe)';

  @override
  String get txnSpecialBorrowDesc =>
      'Dinheiro que pediu emprestado (deve-lhes)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'O limite inferior está acima do superior, por isso nada pode corresponder. $min a $max.';
  }

  @override
  String get walletMyWallet => 'A minha carteira';

  @override
  String walletCreateFailed(String error) {
    return 'Não foi possível criar a carteira: $error';
  }

  @override
  String get walletTypeBankAccount => 'Conta bancária';

  @override
  String get walletTypeCreditCard => 'Cartão de crédito';

  @override
  String get walletTypeSubscription => 'Subscrição';

  @override
  String get walletTypeDeposit => 'Depósito';

  @override
  String get walletTypeInvestment => 'Investimento';

  @override
  String get walletTypeAsset => 'Bem';

  @override
  String get walletEnterAccountName => 'Introduza um nome para a conta';

  @override
  String get walletCreditLimitRequired => 'O limite de crédito é obrigatório';

  @override
  String get walletEnterValidCreditLimit =>
      'Introduza um limite de crédito válido';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'Introduza um limite de crédito válido superior a 0';

  @override
  String get walletEditWallet => 'Editar carteira';

  @override
  String get walletAddNewWallet => 'Adicionar nova carteira';

  @override
  String get walletEnterWalletNameError => 'Introduza um nome para a carteira';

  @override
  String get walletEnterValidNumber => 'Introduza um número válido';

  @override
  String get walletShowCents => 'Mostrar cêntimos (ex.: \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'Apenas números inteiros (ex.: \$1,235)';

  @override
  String get walletCreateWallet => 'Criar carteira';

  @override
  String get walletClosedPill =>
      'Fechada. O histórico mantém-se, mas deixa de ser proposta ou contada.';

  @override
  String get walletExcludedPill => 'Excluída do total de todas as contas.';

  @override
  String get walletReopen => 'Reabrir';

  @override
  String get walletCloseAccount => 'Fechar conta';

  @override
  String get walletReopenSubtitle => 'Voltar a propor e contar';

  @override
  String get walletCloseAccountSubtitle =>
      'Manter o histórico, deixar de contar';

  @override
  String get walletIncludeInTotal => 'Incluir no total';

  @override
  String get walletLeaveOutOfTotal => 'Excluir do total';

  @override
  String get walletAlreadyTheBalance => 'Esse já é o saldo.';

  @override
  String get walletCorrectionRecorded =>
      'A diferença foi registada como correção.';

  @override
  String walletMergeConfirmBody(String name) {
    return 'Tudo o que está registado em $name passa para lá, e $name é fechada. Nada é eliminado.';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'Os valores são convertidos de $from para $to ao passar. Nada é eliminado, e $name é fechada em vez de removida.';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount a crédito · $available disponível';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount em dívida · $available ainda disponível';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return 'Introduza o que $name realmente tem. A diferença é registada como uma transação, para que a conta continue a bater certo com o seu histórico.';
  }

  @override
  String get apiUpdateRequired =>
      'Atualize The Accountant para continuar a sincronizar. Até lá, tudo fica neste telemóvel.';

  @override
  String get apiAccountExistsLink =>
      'Já existe uma conta com este email. Associe as suas contas.';

  @override
  String get apiServerTrouble =>
      'O nosso servidor está com problemas neste momento. Está tudo seguro neste telemóvel; tente de novo daqui a alguns minutos.';

  @override
  String apiRequestFailedHttp(String status) {
    return 'O pedido falhou (HTTP $status).';
  }

  @override
  String get apiServerTimeout =>
      'O nosso servidor demorou demasiado a responder. Verifique a sua ligação ou tente de novo daqui a alguns minutos.';

  @override
  String get apiCannotReachServer =>
      'Não é possível contactar o nosso servidor. Verifique a sua ligação; se estiver online, tente de novo daqui a alguns minutos.';

  @override
  String get apiSomethingWentWrong =>
      'Algo correu mal ao comunicar com o nosso servidor. Tente de novo.';

  @override
  String get syncAlreadyInProgress => 'Sincronização já em curso';

  @override
  String get syncRequiresPremium =>
      'A sincronização na nuvem requer uma subscrição Premium';

  @override
  String get syncNoInternet => 'Sem ligação à Internet';

  @override
  String get syncNotAuthenticated => 'Sessão não iniciada';

  @override
  String get syncCouldNotFetchCloud =>
      'Não foi possível obter os seus dados da nuvem. Os dados locais não foram alterados.';

  @override
  String get syncAccountUnknown =>
      'Não foi possível identificar a conta com sessão iniciada; sincronização cancelada.';

  @override
  String get syncStoreOtherAccount =>
      'Os dados deste dispositivo pertencem a outra conta. Inicie sessão com essa conta, ou apague os dados locais, antes de sincronizar.';

  @override
  String syncRecordsNotSaved(String record) {
    return 'Alguns registos da nuvem não puderam ser guardados neste dispositivo: $record. Serão tentados de novo na próxima sincronização.';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'Alguns registos da nuvem não puderam ser guardados neste dispositivo: $record (e mais $count). Serão tentados de novo na próxima sincronização.';
  }

  @override
  String notifCardStatementReady(String name) {
    return 'O extrato de $name está pronto';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'Ficou em $amount, já pago. Não há mais nada a pagar.';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount a pagar até $date.';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$paid de $owed já está pago.';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return 'A fatura de $name vence amanhã';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return 'A fatura de $name vence daqui a $days dias';
  }

  @override
  String notifPayBy(String amount, String date) {
    return 'Pague $amount até $date.';
  }

  @override
  String notifCardDueToday(String name) {
    return 'A fatura de $name vence hoje';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount ainda está por pagar.$paidSoFar Pagar hoje evita uma taxa de atraso.';
  }

  @override
  String get notifWhenToday => 'hoje';

  @override
  String get notifWhenTomorrow => 'amanhã';

  @override
  String notifWhenInDays(int days) {
    return 'daqui a $days dias';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name paga $when';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount deve entrar em $account a $date.';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name vence $when';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount volta para $account a $date.';
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
      'dps': 'depósito',
      'insurance': 'prémio',
      'sip': 'SIP',
      'other': 'prestação',
    });
    return '$name: $_temp0 $number de $total vence $when';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return 'Invista $amount até $date.';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount será investido a partir de $account a $date.';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount será registado a partir de $account a $date.';
  }

  @override
  String get notifYourAccount => 'a sua conta';

  @override
  String get notifPlansUpdatedTitle => 'Prestações e poupanças atualizadas';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registos de plano feitos no seu dia.',
      one: '1 registo de plano feito no seu dia.',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'Transações recorrentes registadas';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações recorrentes registadas.',
      one: '1 transação recorrente registada.',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagamentos por confirmar',
      one: '1 pagamento por confirmar',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'Confirme o que foi cobrado, ou ignore, em Próximos.';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — confirme o que foi cobrado, ou ignore, em Próximos.';
  }

  @override
  String get notifUpcomingFallbackTitle => 'Transação próxima';

  @override
  String notifUpcomingTitle(String title) {
    return 'Próximo: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return 'Receita de $amount prevista em breve.';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return 'Despesa de $amount a vencer em breve.';
  }

  @override
  String get notifCreditFallback => 'Crédito';

  @override
  String get notifDebtFallback => 'Dívida';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'Crédito em atraso: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'Dívida em atraso: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount ainda está em dívida. Toque para rever.';
  }

  @override
  String get notifRecurringFallbackTitle => 'Transação recorrente';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'Recorrente próximo: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount a pagar a $date.';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'Crédito a vencer: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'Dívida a vencer: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'Subscrição a vencer: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'Conta a vencer: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'Vence em breve: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'Conta recorrente';

  @override
  String notifDueSoonBody(String amount) {
    return '$amount vence em breve. Toque para rever.';
  }

  @override
  String get notifChannelRecurring => 'Transações recorrentes';

  @override
  String get notifChannelRecurringDesc =>
      'Notificações de transações recorrentes criadas automaticamente';

  @override
  String get notifChannelUpcoming => 'Lembretes de próximos';

  @override
  String get notifChannelUpcomingDesc => 'Lembretes de transações próximas';

  @override
  String get notifChannelLoan => 'Lembretes de empréstimos';

  @override
  String get notifChannelLoanDesc =>
      'Lembretes de créditos e dívidas em atraso';

  @override
  String get notifChannelDueDate => 'Lembretes de vencimento';

  @override
  String get notifChannelDueDateDesc =>
      'Lembretes únicos para vencimentos de transações específicas';

  @override
  String get notifChannelBillsDesc =>
      'Faturas de cartão de crédito e prestações de planos a vencer';

  @override
  String get notifOffset1Hour => '1 hora antes';

  @override
  String get notifOffset1Day => '1 dia antes';

  @override
  String get notifOffset3Days => '3 dias antes';

  @override
  String get notifOffset1Week => '1 semana antes';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes minutos antes';
  }

  @override
  String get notifChannelGeneral => 'Geral';

  @override
  String get notifChannelGeneralDesc => 'Notificações da conta e da app';

  @override
  String get notifChannelReminders => 'Lembretes diários';

  @override
  String get notifChannelRemindersDesc =>
      'Um lembrete para registar as despesas do dia';

  @override
  String get notifChannelBillsStatementsDesc =>
      'Extratos e vencimentos do cartão de crédito';

  @override
  String get notifChannelBudgets => 'Alertas de orçamento';

  @override
  String get notifChannelBudgetsDesc =>
      'Quando um orçamento está quase ou totalmente gasto';

  @override
  String notifOverBudgetTitle(String name) {
    return 'Acima do orçamento: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'Alerta de orçamento: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return 'Gastou $percent% do seu orçamento $name para este período.';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return 'Usou $percent% do seu orçamento $name.';
  }

  @override
  String get notifPremiumEndingTitle => 'O Premium termina em breve';

  @override
  String get notifPremiumEndsTomorrow =>
      'O seu Premium termina amanhã. Renove para manter as funcionalidades Premium.';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'O seu Premium termina daqui a $days dias. Renove para manter as funcionalidades Premium.';
  }

  @override
  String get notifLargeIncomeTitle => 'Alerta de receita elevada';

  @override
  String get notifLargeExpenseTitle => 'Alerta de despesa elevada';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return 'Receita de $amount registada: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return 'Receita de $amount registada';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return 'Despesa de $amount registada: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return 'Despesa de $amount registada';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'Notificações de lembrete diário de despesas';

  @override
  String get notifDailyReminderTitle => 'Lembrete diário de despesas';

  @override
  String get notifDailyReminderBody =>
      'Não se esqueça de registar as despesas de hoje! Acompanhe os seus gastos.';

  @override
  String get notifTestTitle => 'Notificação de teste';

  @override
  String get notifTestBody =>
      'Se está a ver isto, as notificações estão a funcionar!';

  @override
  String get notifActionSnooze1Day => 'Adiar 1 d';

  @override
  String get notifActionSnooze1Week => 'Adiar 1 sem.';

  @override
  String get notifGroupThisWeek => 'Esta semana';

  @override
  String get notifGroupThisMonth => 'Este mês';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date às $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return 'há $count min';
  }

  @override
  String notifHoursAgo(int count) {
    return 'há $count h';
  }

  @override
  String notifDaysAgo(int count) {
    return 'há $count d';
  }

  @override
  String get notifPrimerSheetBody =>
      'Ative as notificações e avisamos sobre o que importa.';

  @override
  String get notifPrimerBudgetsBody =>
      'Saiba antes de ultrapassar um orçamento.';

  @override
  String get notifPrimerBillsTitle => 'Lembretes de contas e subscrições';

  @override
  String get notifPrimerBillsBody => 'Nunca perca um pagamento recorrente.';

  @override
  String get notifPrimerLargeTitle => 'Transações elevadas';

  @override
  String get notifPrimerLargeBody => 'Seja avisado de atividade invulgar.';

  @override
  String get notifLoadFailed => 'Não foi possível carregar as notificações';

  @override
  String get startupReasonSomethingWrong =>
      'Algo correu mal ao iniciar. Os seus dados estão seguros neste dispositivo.';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'Não foi possível abrir os dados locais desta conta.';

  @override
  String get startupReasonSetupFailed =>
      'Não conseguimos terminar de configurar esta conta neste dispositivo. Nada foi apagado.';

  @override
  String get startupReasonOffline =>
      'Não conseguimos contactar a sua conta, e este dispositivo ainda não tem os dados dela. Se já usou The Accountant, ligue-se à Internet e traremos os seus dados de volta. É novo aqui? Pode começar neste dispositivo agora.';

  @override
  String get startupReasonNeedsSubscription =>
      'Esta conta tem dados guardados na nuvem. Restaurá-los requer uma subscrição ativa. Nada foi apagado.';

  @override
  String get startupReasonConfirmingSubscription =>
      'Esta conta tem dados na nuvem. Ainda estamos a confirmar a sua subscrição para que possam ser restaurados.';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'O restauro falhou: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'Esta conta tem dados na nuvem, mas ainda não foi possível restaurá-los.';

  @override
  String get commonBiometricReason =>
      'Autentique-se para desbloquear The Accountant';

  @override
  String get commonLoadCurrenciesFailed =>
      'Não foi possível carregar as moedas';

  @override
  String get commonLoadRatesFailed =>
      'Não foi possível carregar as taxas de câmbio';

  @override
  String get commonRefreshRatesFailed =>
      'Não foi possível atualizar as taxas de câmbio';

  @override
  String get commonAllCategories => 'Todas as categorias';

  @override
  String commonCategoryCount(int count) {
    return '$count categorias';
  }

  @override
  String get commonTierFree => 'Gratuito';

  @override
  String get commonTierMonthly => 'Premium mensal';

  @override
  String get commonTierYearly => 'Premium anual';

  @override
  String get commonTierLifetime => 'Premium vitalício';

  @override
  String get commonCategoryMergeSelf =>
      'Uma categoria não pode ser fundida consigo própria.';

  @override
  String get commonCategoryMergeMissing =>
      'As duas categorias têm de existir para as fundir.';

  @override
  String get commonCategoryMergeSystem =>
      'As categorias da própria app não podem ser fundidas.';

  @override
  String get commonCategoryMergeKinds =>
      'Categorias de receita e de despesa não podem ser fundidas.';

  @override
  String get commonCategoryOneLevel =>
      'Essa categoria está dentro de outra, e as categorias só têm um nível.';

  @override
  String get commonCategoryMoveSame =>
      'Escolha outra categoria para onde as mover.';

  @override
  String get commonCategoryMoveMissing =>
      'As duas categorias têm de existir para mover entre elas.';

  @override
  String get commonCategoryMoveSystem =>
      'Não é possível mover entre as categorias da própria app.';

  @override
  String get commonCategoryMoveKinds =>
      'Transações de receita e de despesa não podem trocar de categoria.';

  @override
  String get commonCategoryGone => 'Essa categoria já não existe.';

  @override
  String get commonCategoryParentSystem =>
      'As categorias da própria app não podem ser movidas.';

  @override
  String get commonCategoryParentSelf =>
      'Uma categoria não pode ficar dentro de si própria.';

  @override
  String get commonCategoryParentIntoSystem =>
      'Nada pode ser arquivado dentro das categorias da própria app.';

  @override
  String get commonCategoryParentKinds =>
      'Uma categoria de receita e uma de despesa não podem ficar uma dentro da outra.';

  @override
  String get commonCategoryHasChildren =>
      'Esta categoria tem subcategorias próprias, por isso fica no nível de topo.';

  @override
  String get commonTapToChange => 'Toque para alterar';

  @override
  String get commonSelectColor => 'Escolher cor';

  @override
  String get commonShowPalette => 'Mostrar paleta';

  @override
  String get commonCustomColor => 'Cor personalizada';

  @override
  String get commonSelectCurrency => 'Escolher moeda';

  @override
  String get commonEnableCryptoHint =>
      'Ative \'Incluir criptomoedas\' para pesquisar tokens cripto.';

  @override
  String get commonSearchHint => 'Pesquisar...';

  @override
  String get aiLoadConversationsFailed =>
      'Não foi possível carregar as conversas.';

  @override
  String get aiLoadHistoryFailed =>
      'Não foi possível carregar o histórico da conversa.';

  @override
  String get aiPremiumRequired =>
      'É necessária uma subscrição Premium para o assistente de IA';

  @override
  String get aiUnexpectedError => 'Ocorreu um erro inesperado. Tente de novo.';

  @override
  String get aiResponseFailed =>
      'Não foi possível obter a resposta da IA. Tente de novo.';

  @override
  String get aiServiceNotAnswering => 'O serviço de IA não está a responder.';

  @override
  String get aiReplyCutOff => 'A resposta foi interrompida. Tente de novo.';

  @override
  String get aiCouldNotReachServer =>
      'Não foi possível contactar o servidor. Verifique a sua ligação e tente de novo.';

  @override
  String get aiSomethingWentWrong => 'Algo correu mal.';

  @override
  String get aiOpenConversationFailed => 'Não foi possível abrir a conversa.';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'As suas $count alterações foram guardadas, mas o consultor não conseguiu terminar a resposta. Verifique-as nos seus registos antes de perguntar de novo.',
      one:
          'A sua alteração foi guardada, mas o consultor não conseguiu terminar a resposta. Verifique-a nos seus registos antes de perguntar de novo.',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'O serviço de IA não está a responder neste momento. Tente de novo.';

  @override
  String aiMinutesShort(int count) {
    return '$count min';
  }

  @override
  String aiHoursShort(int count) {
    return '$count h';
  }

  @override
  String aiDaysShort(int count) {
    return '$count d';
  }

  @override
  String get aiOcrTextFailed => 'Não foi possível extrair o texto da imagem';

  @override
  String get aiOcrReceiptFailed =>
      'Não foi possível extrair os dados do recibo da imagem';

  @override
  String get coachYes => 'sim';

  @override
  String get coachNo => 'não';

  @override
  String get coachTradeBuy => 'compra';

  @override
  String get coachTradeSell => 'venda';

  @override
  String get coachTradeDividend => 'dividendo';

  @override
  String get planAccountGone => 'Essa conta já não existe.';

  @override
  String get planPaidFromOrdinary =>
      'Um plano é pago a partir de uma conta comum, não de um depósito.';

  @override
  String get planSipChooseHolding =>
      'Escolha o fundo ou a ação que o investimento periódico compra.';

  @override
  String get planSipPayFromOther =>
      'Pague o investimento periódico a partir de outra conta.';

  @override
  String get planNeedNameError => 'Dê um nome ao plano.';

  @override
  String get planInstallmentCountRange =>
      'O número de prestações tem de ser de 1 a 1200.';

  @override
  String get planIntervalMin => 'O intervalo tem de ser pelo menos 1.';

  @override
  String get planRateRange => 'A taxa tem de estar entre 0 e 100 por cento.';

  @override
  String get planTaxRange => 'O imposto tem de estar entre 0 e 100 por cento.';

  @override
  String get planProviderTooLong =>
      'Mantenha a empresa e o número com menos de 100 caracteres.';

  @override
  String get planNeedPremium => 'Introduza o prémio.';

  @override
  String get planNeedInstallmentAmount =>
      'Introduza o valor de cada prestação.';

  @override
  String get planNeedDeposited => 'Introduza o valor depositado.';

  @override
  String get planTermMonthsOrYears => 'Dura meses ou anos.';

  @override
  String get planAmountNotNegative => 'O valor não pode ser negativo.';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name vence em $date. Para levantar o dinheiro antes disso, encerre-o antecipadamente.';
  }

  @override
  String get planNoLongerExists => 'Esse plano já não existe.';

  @override
  String get planReminderDaysRange =>
      'Os lembretes podem ser de 0 (desligado) a 30 dias antes.';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name ainda tem dinheiro. Encerre-o primeiro, o que devolve o dinheiro a $account.';
  }

  @override
  String get planItsAccount => 'a sua conta';

  @override
  String planAlreadyEnded(String name) {
    return '$name já terminou.';
  }

  @override
  String get investNeedName => 'Dê um nome ao investimento.';

  @override
  String get investNameTooLong =>
      'Mantenha o nome com menos de 100 caracteres.';

  @override
  String get investSymbolTooLong =>
      'Mantenha o símbolo com menos de 20 caracteres.';

  @override
  String get investPriceNotNegative => 'Um preço não pode ser negativo.';

  @override
  String investAlreadyTracked(String name) {
    return '$name já está a ser acompanhado.';
  }

  @override
  String get investNeedPaid => 'Introduza o que foi pago.';

  @override
  String get investUnitsBoughtPositive =>
      'As unidades compradas têm de ser mais do que zero.';

  @override
  String get investPayFromOther => 'Pague a partir de outra conta.';

  @override
  String get investNeedSaleAmount => 'Introduza o que a venda rendeu.';

  @override
  String get investUnitsSoldPositive =>
      'As unidades vendidas têm de ser mais do que zero.';

  @override
  String get investSellIntoOther => 'Venda para outra conta.';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'Só são detidas $units unidades de $name.';
  }

  @override
  String get investNeedDividend => 'Introduza o dividendo recebido.';

  @override
  String get investReceiveIntoOrdinary => 'Receba-o numa conta comum.';

  @override
  String get investPricePositive => 'Um preço tem de ser mais do que zero.';

  @override
  String get investUnitsPositive => 'As unidades têm de ser mais do que zero.';

  @override
  String get investNotATrade => 'Isso não é uma transação de um investimento.';

  @override
  String investStillHoldsUnits(String name) {
    return '$name ainda tem unidades. Venda-as primeiro.';
  }

  @override
  String get investNoLongerExists => 'Esse investimento já não existe.';

  @override
  String get networthNeedAssetName => 'Dê um nome ao bem.';

  @override
  String get networthValueNotNegative => 'Um valor não pode ser negativo.';

  @override
  String get networthNeedPaidFor => 'Introduza o que foi pago por ele.';

  @override
  String get networthPayFromOrdinary => 'Pague a partir de uma conta comum.';

  @override
  String get networthNeedWorth => 'Introduza quanto vale.';

  @override
  String get networthNeedSoldFor => 'Introduza o valor por que foi vendido.';

  @override
  String get networthReceiveIntoOrdinary =>
      'Receba o dinheiro numa conta comum.';

  @override
  String networthStillWorth(String name) {
    return '$name ainda vale alguma coisa. Venda-o ou ponha o valor a zero primeiro.';
  }

  @override
  String get networthAssetGone => 'Esse bem já não é acompanhado.';

  @override
  String get zakatNeedAmountPaid => 'Introduza o valor pago.';

  @override
  String get zakatPayFromOrdinary => 'Pague-o a partir de uma conta comum.';

  @override
  String get zakatReminderTitleToday => 'O seu zakat vence hoje';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakat vence dentro de $count dias',
      one: 'Zakat vence dentro de 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'O seu ano de zakat termina hoje. Toque para ver o que é devido.';

  @override
  String zakatReminderBodyOn(String date) {
    return 'O seu ano de zakat termina a $date. Toque para ver o que é devido.';
  }

  @override
  String get budgetCheckFailed => 'Não foi possível verificar os orçamentos';

  @override
  String get budgetLoadFailed => 'Não foi possível carregar os orçamentos';

  @override
  String get budgetAddFailed => 'Não foi possível adicionar o orçamento';

  @override
  String get budgetNotFound => 'Orçamento não encontrado';

  @override
  String get budgetUpdateFailed => 'Não foi possível atualizar o orçamento';

  @override
  String get budgetDeleteFailed => 'Não foi possível eliminar o orçamento';

  @override
  String get budgetEdit => 'Editar orçamento';

  @override
  String get budgetNeedName => 'Dê um nome ao orçamento';

  @override
  String get budgetEnterAmount => 'Introduza um valor';

  @override
  String get budgetAmountMoreThanZero => 'O valor tem de ser mais do que zero';

  @override
  String get budgetTrackingEarnings => 'A acompanhar ganhos';

  @override
  String get budgetTrackingSpending => 'A acompanhar despesas';

  @override
  String get budgetRepeats => 'Repete';

  @override
  String get budgetTooBig => 'Demasiado grande';

  @override
  String get budgetStarts => 'Começa';

  @override
  String get budgetEnds => 'Termina';

  @override
  String get budgetStopsRepeating => 'Deixa de repetir';

  @override
  String get budgetNever => 'Nunca';

  @override
  String get budgetCategoriesAll => 'Categorias: todas';

  @override
  String budgetCategoriesSelected(int count) {
    return 'Categorias: $count selecionadas';
  }

  @override
  String get budgetNoIncomeCategories => 'Ainda não há categorias de receita.';

  @override
  String get budgetNoExpenseCategories => 'Ainda não há categorias de despesa.';

  @override
  String get budgetCategoriesHint =>
      'Deixe vazio para acompanhar todas as categorias. Tudo o que estiver dentro de uma categoria escolhida também conta.';

  @override
  String get budgetAccountsAll => 'Contas: todas';

  @override
  String budgetAccountsSelected(int count) {
    return 'Contas: $count selecionadas';
  }

  @override
  String get budgetRolloverHint =>
      'O que não for gasto passa para o período seguinte. Ultrapassar não transporta uma dívida.';

  @override
  String get budgetPeriodDaily => 'Diário';

  @override
  String get budgetPeriodFortnightly => 'Quinzenal';

  @override
  String get budgetPeriodOneOff => 'Pontual';

  @override
  String get budgetUnitDays => 'dias';

  @override
  String get budgetUnitWeeks => 'semanas';

  @override
  String get budgetUnitFortnights => 'quinzenas';

  @override
  String get budgetUnitMonths => 'meses';

  @override
  String get budgetUnitYears => 'anos';

  @override
  String get budgetOneOffNeedsEnd =>
      'Um orçamento pontual precisa de uma data de fim.';

  @override
  String get budgetEndAfterStart =>
      'A data de fim tem de ser depois da data de início.';

  @override
  String get budgetSaveFailed => 'Não foi possível guardar o orçamento.';

  @override
  String get budgetThisPeriod => 'Este período';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count períodos',
      one: 'Há 1 período',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'de $limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'de $limit, incluindo $carried transitado';
  }

  @override
  String get budgetUncategorised => 'Sem categoria';

  @override
  String budgetOverTheLimit(String amount) {
    return '$amount acima do limite.';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return 'Restam $left, cerca de $daily por dia.';
  }

  @override
  String budgetLeftPlain(String left) {
    return 'Restam $left.';
  }

  @override
  String budgetAveraging(String amount) {
    return 'Média de $amount por período.';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'A caminho de $amount acima';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'A este ritmo, contando com $scheduled já agendado antes do fim do período.';
  }

  @override
  String get budgetForecastPlain => 'A este ritmo, até ao fim do período.';

  @override
  String get budgetCapsExplain =>
      'Um orçamento diz se o período foi ultrapassado. Um limite diz onde: um orçamento de comida em dia no total pode ser sobretudo comida para fora.';

  @override
  String get budgetPercentOfBudget => 'Percentagem do orçamento';

  @override
  String get budgetArchivedTitle => 'Orçamentos arquivados';

  @override
  String get budgetShowActive => 'Mostrar ativos';

  @override
  String get budgetShowArchived => 'Mostrar arquivados';

  @override
  String get budgetUnpin => 'Desafixar';

  @override
  String get budgetPinToTop => 'Afixar no topo';

  @override
  String get budgetStartCounting => 'Voltar a contá-lo';

  @override
  String get budgetStopCounting => 'Manter o histórico, deixar de o contar';

  @override
  String get budgetDeleteBody =>
      'O orçamento sai, as suas transações ficam. Nada do que registou é removido.';

  @override
  String get budgetNothingArchived => 'Nada arquivado';

  @override
  String get budgetNoneYet => 'Ainda sem orçamentos';

  @override
  String get budgetArchivedEmptyHint =>
      'Os orçamentos que arquivar ficam aqui.';

  @override
  String get budgetEmptyHint =>
      'Defina um limite para uma categoria e veja como corre o mês.';

  @override
  String dashLoadFailed(String error) {
    return 'Não foi possível carregar os dados financeiros: $error';
  }

  @override
  String get categoryUnknown => 'Desconhecida';

  @override
  String dashCardAvailable(String amount) {
    return 'Disponível: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'Com saldo a favor · Disponível: $amount';
  }

  @override
  String get dashTypeBank => 'Banco';

  @override
  String get dashTypeCredit => 'Crédito';

  @override
  String get dashTypeSubs => 'Subscr.';

  @override
  String get dashTypeDeposit => 'Depósito';

  @override
  String get dashTypeInvest => 'Invest.';

  @override
  String get dashTypeAsset => 'Bem';

  @override
  String get dashAddAccountTile => 'Adicionar\nconta';

  @override
  String get categoryLoadFailed => 'Não foi possível carregar as categorias';

  @override
  String get categoryAddFailed => 'Não foi possível adicionar a categoria';

  @override
  String get categoryNotFound => 'Categoria não encontrada';

  @override
  String get categoryUpdateFailed => 'Não foi possível atualizar a categoria';

  @override
  String get categoryCannotDeleteSystem =>
      'Não é possível eliminar as categorias da própria aplicação';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'Não é possível eliminar uma categoria com transações; mova-as ou elimine-as primeiro';

  @override
  String get categoryDeleteFailed => 'Não foi possível eliminar a categoria';

  @override
  String categorySaveFailed(String error) {
    return 'Não foi possível guardar a categoria: $error';
  }

  @override
  String get categoryEditTitle => 'Editar categoria';

  @override
  String get categoryNewTitle => 'Nova categoria';

  @override
  String get categoryPartOf => 'Faz parte de';

  @override
  String get categoryNamePlaceholder => 'Nome da categoria';

  @override
  String get categoryUpdate => 'Atualizar categoria';

  @override
  String get categoryCreate => 'Criar categoria';

  @override
  String reportLoadFailed(String error) {
    return 'Não foi possível carregar os relatórios: $error';
  }

  @override
  String get goalEdit => 'Editar objetivo';

  @override
  String get goalNeedName => 'Dê um nome ao objetivo';

  @override
  String get goalTargetMoreThanZero => 'A meta tem de ser mais do que zero';

  @override
  String get goalNoDeadline => 'Sem prazo';

  @override
  String get goalTargetDateAfterStart =>
      'A data da meta tem de ser depois da data de início.';

  @override
  String get goalSaveFailed => 'Não foi possível guardar o objetivo.';

  @override
  String get goalArchivedTitle => 'Objetivos arquivados';

  @override
  String get goalHideFromHome => 'Ocultar do início';

  @override
  String get goalShowOnHome => 'Mostrar no início';

  @override
  String get goalReached => 'Atingido';

  @override
  String goalToGo(String amount) {
    return 'Faltam $amount';
  }

  @override
  String get goalNoneYet => 'Ainda sem objetivos';

  @override
  String get goalArchivedEmptyHint => 'Os objetivos que arquivar ficam aqui.';

  @override
  String get goalEmptyHint =>
      'Dê nome a algo para que está a poupar e depois associe as transações que contribuem para isso.';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$saved de $target';
  }

  @override
  String goalOfTarget(String target) {
    return 'de $target';
  }

  @override
  String get goalReachedNicelyDone => 'Atingido. Muito bem.';

  @override
  String goalStillToGo(String amount) {
    return 'Ainda faltam $amount.';
  }

  @override
  String goalDailyToArrive(String amount) {
    return '$amount por dia para chegar a tempo.';
  }

  @override
  String get goalNothingLinked =>
      'Ainda nada associado. Escolha este objetivo numa transação e ela aparecerá aqui.';

  @override
  String get goalDeleteBody =>
      'O objetivo sai, as suas transações ficam. Apenas deixam de contar para ele.';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagamentos de $amount',
      one: '1 pagamento de $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'Termina por volta de $date.';
  }

  @override
  String goalNotFound(String id) {
    return 'Objetivo não encontrado: $id';
  }

  @override
  String get goalPaidOff => 'Pago na totalidade!';

  @override
  String get goalCompleted => 'Concluído!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent% concluído';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count semanas',
      one: 'Falta 1 semana',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count meses',
      one: 'Falta 1 mês',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return 'Faltam $years anos';
  }

  @override
  String get subRecurringBill => 'Fatura recorrente';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count dias',
      one: 'A cada 1 dia',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count semanas',
      one: 'A cada 1 semana',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count meses',
      one: 'A cada 1 mês',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count anos',
      one: 'A cada 1 ano',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'A cada $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'Não foi possível carregar as subscrições: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'Não foi possível pausar a subscrição: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'Não foi possível retomar a subscrição: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'Não foi possível atualizar a subscrição: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'Não foi possível cancelar a subscrição: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'Ativas ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'Em pausa ($count)';
  }

  @override
  String get subEmptyTitle => 'Sem subscrições nem faturas';

  @override
  String get subEmptyBody =>
      'Adicione transações de subscrições ou faturas recorrentes para as acompanhar aqui';

  @override
  String get subRecurringCost => 'Custo recorrente';

  @override
  String subPerYear(String amount) {
    return '$amount / ano';
  }

  @override
  String get subActive => 'Ativas';

  @override
  String subNext(String date) {
    return 'Próximo $date';
  }

  @override
  String get subResume => 'Retomar';

  @override
  String get subPause => 'Pausar';

  @override
  String get subCancelBillTitle => 'Cancelar fatura recorrente';

  @override
  String get subCancelSubTitle => 'Cancelar subscrição';

  @override
  String subCancelConfirm(String name) {
    return 'Tem a certeza de que quer cancelar \"$name\"? Isto vai parar todos os pagamentos recorrentes futuros.';
  }

  @override
  String subCancelled(String name) {
    return '\"$name\" cancelada';
  }

  @override
  String subSaveError(String error) {
    return 'Erro: $error';
  }

  @override
  String get subEditBill => 'Editar fatura recorrente';

  @override
  String get subEditSub => 'Editar subscrição';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'semanas',
      one: 'semana',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'Termina: $date';
  }

  @override
  String get subNoEndDate => 'Sem data de fim';
}
