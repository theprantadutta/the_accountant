import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @settingsRegionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Regional Settings'**
  String get settingsRegionalTitle;

  /// No description provided for @settingsSectionCurrency.
  ///
  /// In en, this message translates to:
  /// **'CURRENCY'**
  String get settingsSectionCurrency;

  /// No description provided for @settingsSectionDisplayFormat.
  ///
  /// In en, this message translates to:
  /// **'DISPLAY FORMAT'**
  String get settingsSectionDisplayFormat;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsDefaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default Currency'**
  String get settingsDefaultCurrency;

  /// No description provided for @settingsExchangeRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rates'**
  String get settingsExchangeRates;

  /// No description provided for @settingsExchangeRatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage currency conversion rates'**
  String get settingsExchangeRatesSubtitle;

  /// No description provided for @settingsDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get settingsDateFormat;

  /// No description provided for @settingsNumberFormat.
  ///
  /// In en, this message translates to:
  /// **'Number Format'**
  String get settingsNumberFormat;

  /// No description provided for @settingsCurrencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get settingsCurrencySymbol;

  /// No description provided for @settingsTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get settingsTimeFormat;

  /// No description provided for @settingsFirstDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'First Day of the Week'**
  String get settingsFirstDayOfWeek;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get settingsPreview;

  /// No description provided for @previewDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get previewDate;

  /// No description provided for @previewTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get previewTime;

  /// No description provided for @previewAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get previewAmount;

  /// No description provided for @previewWeekStarts.
  ///
  /// In en, this message translates to:
  /// **'This week starts'**
  String get previewWeekStarts;

  /// Follow the device setting rather than choosing explicitly.
  ///
  /// In en, this message translates to:
  /// **'Match my phone'**
  String get choiceMatchMyPhone;

  /// No description provided for @symbolBeforeAmount.
  ///
  /// In en, this message translates to:
  /// **'Before the amount'**
  String get symbolBeforeAmount;

  /// No description provided for @symbolAfterAmount.
  ///
  /// In en, this message translates to:
  /// **'After the amount'**
  String get symbolAfterAmount;

  /// No description provided for @time12Hour.
  ///
  /// In en, this message translates to:
  /// **'12-hour (1:30 PM)'**
  String get time12Hour;

  /// No description provided for @time24Hour.
  ///
  /// In en, this message translates to:
  /// **'24-hour (13:30)'**
  String get time24Hour;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @selectDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Date Format'**
  String get selectDateFormat;

  /// No description provided for @selectNumberFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Number Format'**
  String get selectNumberFormat;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Match my phone'**
  String get languageSystem;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get sectionAccount;

  /// No description provided for @sectionDataManagement.
  ///
  /// In en, this message translates to:
  /// **'DATA MANAGEMENT'**
  String get sectionDataManagement;

  /// No description provided for @sectionHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'HELP & SUPPORT'**
  String get sectionHelpSupport;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupRestore;

  /// No description provided for @settingsBackupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A file you keep, or automatic copies in Google Drive'**
  String get settingsBackupRestoreSubtitle;

  /// No description provided for @settingsImportStatement.
  ///
  /// In en, this message translates to:
  /// **'Import a statement'**
  String get settingsImportStatement;

  /// No description provided for @settingsImportStatementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring in a CSV from your bank, mapped once and remembered'**
  String get settingsImportStatementSubtitle;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// No description provided for @settingsRecentlyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get settingsRecentlyDeleted;

  /// No description provided for @settingsRecentlyDeletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Put back something removed in the last thirty days'**
  String get settingsRecentlyDeletedSubtitle;

  /// No description provided for @themePremiumHeading.
  ///
  /// In en, this message translates to:
  /// **'Premium Themes'**
  String get themePremiumHeading;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @dashCreditDebt.
  ///
  /// In en, this message translates to:
  /// **'Credit & Debt'**
  String get dashCreditDebt;

  /// No description provided for @dashSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get dashSubscriptions;

  /// No description provided for @moneyIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get moneyIncome;

  /// No description provided for @dashExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dashExpenses;

  /// No description provided for @dashSpendingOverview.
  ///
  /// In en, this message translates to:
  /// **'Spending Overview'**
  String get dashSpendingOverview;

  /// No description provided for @dashBudgetProgress.
  ///
  /// In en, this message translates to:
  /// **'Budget Progress'**
  String get dashBudgetProgress;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @txDeleteManyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} transactions?'**
  String txDeleteManyTitle(int count);

  /// No description provided for @txDeleteManyBody.
  ///
  /// In en, this message translates to:
  /// **'Balances are recalculated. Any transfer among them takes its other half with it.'**
  String get txDeleteManyBody;

  /// No description provided for @txMoveToAccount.
  ///
  /// In en, this message translates to:
  /// **'Move to account'**
  String get txMoveToAccount;

  /// No description provided for @txDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get txDeleted;

  /// No description provided for @txDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete that transaction: {error}'**
  String txDeleteFailed(String error);

  /// No description provided for @txSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String txSelectedCount(int count);

  /// No description provided for @txActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get txActions;

  /// No description provided for @txChangeCategory.
  ///
  /// In en, this message translates to:
  /// **'Change category'**
  String get txChangeCategory;

  /// No description provided for @txChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get txChangeDate;

  /// No description provided for @txMarkAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get txMarkAsPaid;

  /// No description provided for @txMarkAsCorrection.
  ///
  /// In en, this message translates to:
  /// **'Mark as balance correction'**
  String get txMarkAsCorrection;

  /// No description provided for @txMarkAsCorrectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Not income or spending?'**
  String get txMarkAsCorrectionTitle;

  /// No description provided for @txMarkAsCorrectionBody.
  ///
  /// In en, this message translates to:
  /// **'Use this for money that was neither earned nor spent, like a card\'s limit going up. The balance stays the same; it just stops counting as income or spending.'**
  String get txMarkAsCorrectionBody;

  /// No description provided for @txMarkedAsCorrection.
  ///
  /// In en, this message translates to:
  /// **'Now a balance correction.'**
  String get txMarkedAsCorrection;

  /// No description provided for @txMarkAsCorrectionFailed.
  ///
  /// In en, this message translates to:
  /// **'This one cannot be a correction.'**
  String get txMarkAsCorrectionFailed;

  /// No description provided for @txDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get txDuplicate;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get filterDirection;

  /// No description provided for @filterState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get filterState;

  /// No description provided for @filterKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get filterKind;

  /// No description provided for @filterTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get filterTransfers;

  /// No description provided for @filterAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get filterAccounts;

  /// No description provided for @filterCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get filterCategories;

  /// No description provided for @filterDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get filterDates;

  /// No description provided for @filterBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get filterBudget;

  /// No description provided for @filterGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get filterGoal;

  /// No description provided for @filterNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get filterNone;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get filterThisMonth;

  /// No description provided for @filterLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get filterLastMonth;

  /// No description provided for @filterLast3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get filterLast3Months;

  /// No description provided for @filterThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get filterThisYear;

  /// No description provided for @filterShowCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions match} =1{Show 1 transaction} other{Show {count} transactions}}'**
  String filterShowCount(int count);

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filterClear;

  /// No description provided for @filterNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get filterNoMatches;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get filterSpent;

  /// No description provided for @filterEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get filterEarned;

  /// No description provided for @filterHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get filterHidden;

  /// No description provided for @filterIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get filterIncluded;

  /// No description provided for @filterOnly.
  ///
  /// In en, this message translates to:
  /// **'Only'**
  String get filterOnly;

  /// No description provided for @filterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get filterFrom;

  /// No description provided for @filterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get filterTo;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @filterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get filterPaid;

  /// No description provided for @filterNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get filterNotYet;

  /// No description provided for @filterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get filterSkipped;

  /// No description provided for @filterAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get filterAmount;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @entityBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get entityBudget;

  /// No description provided for @budgetGone.
  ///
  /// In en, this message translates to:
  /// **'This budget no longer exists.'**
  String get budgetGone;

  /// No description provided for @budgetEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get budgetEarlier;

  /// No description provided for @budgetLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get budgetLater;

  /// No description provided for @budgetWhereItWent.
  ///
  /// In en, this message translates to:
  /// **'Where it went'**
  String get budgetWhereItWent;

  /// No description provided for @budgetRecentPeriods.
  ///
  /// In en, this message translates to:
  /// **'Recent periods'**
  String get budgetRecentPeriods;

  /// No description provided for @budgetCaps.
  ///
  /// In en, this message translates to:
  /// **'Caps'**
  String get budgetCaps;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @budgetNoCategoriesToCap.
  ///
  /// In en, this message translates to:
  /// **'This budget has no categories to cap yet.'**
  String get budgetNoCategoriesToCap;

  /// No description provided for @budgetCapACategory.
  ///
  /// In en, this message translates to:
  /// **'Cap a category'**
  String get budgetCapACategory;

  /// No description provided for @entityCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get entityCategory;

  /// No description provided for @budgetAsShare.
  ///
  /// In en, this message translates to:
  /// **'As a share of the budget'**
  String get budgetAsShare;

  /// No description provided for @budgetAsShareHint.
  ///
  /// In en, this message translates to:
  /// **'Moves with the budget when you change it'**
  String get budgetAsShareHint;

  /// No description provided for @actionSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get actionSet;

  /// No description provided for @budgetAcrossPeriod.
  ///
  /// In en, this message translates to:
  /// **'Across the period'**
  String get budgetAcrossPeriod;

  /// No description provided for @budgetPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'Previous period'**
  String get budgetPreviousPeriod;

  /// No description provided for @budgetEvenPace.
  ///
  /// In en, this message translates to:
  /// **'Even pace'**
  String get budgetEvenPace;

  /// No description provided for @budgetNew.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get budgetNew;

  /// No description provided for @budgetCreate.
  ///
  /// In en, this message translates to:
  /// **'Create a budget'**
  String get budgetCreate;

  /// No description provided for @budgetDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String budgetDeleteTitle(String name);

  /// No description provided for @entityAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get entityAccount;

  /// No description provided for @entityTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get entityTransaction;

  /// No description provided for @walletGone.
  ///
  /// In en, this message translates to:
  /// **'This account no longer exists.'**
  String get walletGone;

  /// No description provided for @walletCorrectBalance.
  ///
  /// In en, this message translates to:
  /// **'Correct the balance'**
  String get walletCorrectBalance;

  /// No description provided for @walletCorrectBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record the difference from the real figure'**
  String get walletCorrectBalanceSubtitle;

  /// No description provided for @walletMergeInto.
  ///
  /// In en, this message translates to:
  /// **'Merge into another account'**
  String get walletMergeInto;

  /// No description provided for @walletInThisMonth.
  ///
  /// In en, this message translates to:
  /// **'In this month'**
  String get walletInThisMonth;

  /// No description provided for @walletOutThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Out this month'**
  String get walletOutThisMonth;

  /// No description provided for @walletRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get walletRecentActivity;

  /// No description provided for @walletNoOtherAccount.
  ///
  /// In en, this message translates to:
  /// **'There is no other account to merge into.'**
  String get walletNoOtherAccount;

  /// No description provided for @walletMergeIntoTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge into'**
  String get walletMergeIntoTitle;

  /// No description provided for @walletMergeAction.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get walletMergeAction;

  /// No description provided for @walletMerged.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} into {target}.'**
  String walletMerged(int count, String target);

  /// No description provided for @walletMergedWithTransfersRemoved.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} into {target}. {removed, plural, =1{One transfer between the two accounts was removed} other{{removed} transfers between the two accounts were removed}}, as it no longer had two ends.'**
  String walletMergedWithTransfersRemoved(
    int count,
    String target,
    int removed,
  );

  /// No description provided for @walletRealBalance.
  ///
  /// In en, this message translates to:
  /// **'Real balance'**
  String get walletRealBalance;

  /// No description provided for @walletCorrectAction.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get walletCorrectAction;

  /// No description provided for @txGone.
  ///
  /// In en, this message translates to:
  /// **'This transaction no longer exists.'**
  String get txGone;

  /// No description provided for @txKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get txKind;

  /// No description provided for @txState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get txState;

  /// No description provided for @txWasDue.
  ///
  /// In en, this message translates to:
  /// **'Was due'**
  String get txWasDue;

  /// No description provided for @txNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get txNotes;

  /// No description provided for @txDeleteOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get txDeleteOneTitle;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Naming rules'**
  String get rulesTitle;

  /// No description provided for @rulesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get rulesAdd;

  /// No description provided for @rulesRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed the rule for {title}'**
  String rulesRemoved(String title);

  /// No description provided for @rulesWhenTitleSays.
  ///
  /// In en, this message translates to:
  /// **'When the title says'**
  String get rulesWhenTitleSays;

  /// No description provided for @rulesMatchExactly.
  ///
  /// In en, this message translates to:
  /// **'Match exactly'**
  String get rulesMatchExactly;

  /// No description provided for @rulesChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get rulesChooseCategory;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @goalNew.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalNew;

  /// No description provided for @goalLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your goals.'**
  String get goalLoadFailed;

  /// No description provided for @goalCreate.
  ///
  /// In en, this message translates to:
  /// **'Create a goal'**
  String get goalCreate;

  /// No description provided for @trashTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get trashTitle;

  /// No description provided for @trashRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get trashRestore;

  /// No description provided for @trashRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored.'**
  String get trashRestored;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get payTitle;

  /// No description provided for @payDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get payDefault;

  /// No description provided for @payAddOne.
  ///
  /// In en, this message translates to:
  /// **'Add one'**
  String get payAddOne;

  /// No description provided for @payDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String payDeleteTitle(String name);

  /// No description provided for @payName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get payName;

  /// No description provided for @payNameHint.
  ///
  /// In en, this message translates to:
  /// **'Everyday debit'**
  String get payNameHint;

  /// No description provided for @payKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get payKind;

  /// No description provided for @payBankOrIssuer.
  ///
  /// In en, this message translates to:
  /// **'Bank or issuer'**
  String get payBankOrIssuer;

  /// No description provided for @payLastFour.
  ///
  /// In en, this message translates to:
  /// **'Last four digits'**
  String get payLastFour;

  /// No description provided for @payUseByDefault.
  ///
  /// In en, this message translates to:
  /// **'Use by default'**
  String get payUseByDefault;

  /// No description provided for @backupChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get backupChecking;

  /// No description provided for @backupLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get backupLoading;

  /// No description provided for @backupSaveACopy.
  ///
  /// In en, this message translates to:
  /// **'Save a copy'**
  String get backupSaveACopy;

  /// No description provided for @backupAutomaticBackups.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get backupAutomaticBackups;

  /// No description provided for @backupHowManyBackupsToKeep.
  ///
  /// In en, this message translates to:
  /// **'How many backups to keep'**
  String get backupHowManyBackupsToKeep;

  /// No description provided for @backupSaveABackupFile.
  ///
  /// In en, this message translates to:
  /// **'Save a backup file'**
  String get backupSaveABackupFile;

  /// No description provided for @backupShareItToFilesEmail.
  ///
  /// In en, this message translates to:
  /// **'Share it to Files, email, or anywhere you like'**
  String get backupShareItToFilesEmail;

  /// No description provided for @backupRestoreFromAFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from a file'**
  String get backupRestoreFromAFile;

  /// No description provided for @backupReplacesEverythingCurrentlyOnThis.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything currently on this device'**
  String get backupReplacesEverythingCurrentlyOnThis;

  /// No description provided for @backupRestoreThisBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupRestoreThisBackup;

  /// No description provided for @backupEraseRestore.
  ///
  /// In en, this message translates to:
  /// **'Erase & Restore'**
  String get backupEraseRestore;

  /// No description provided for @backupGoogleDriveIsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google Drive is unavailable'**
  String get backupGoogleDriveIsUnavailable;

  /// No description provided for @backupConnectGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Drive'**
  String get backupConnectGoogleDrive;

  /// No description provided for @backupBackUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupBackUpNow;

  /// No description provided for @backupKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get backupKeep;

  /// No description provided for @backupTheLastAutomaticBackupDid.
  ///
  /// In en, this message translates to:
  /// **'The last automatic backup did not run'**
  String get backupTheLastAutomaticBackupDid;

  /// No description provided for @backupDisconnectGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Google Drive'**
  String get backupDisconnectGoogleDrive;

  /// No description provided for @backupDisconnectGoogleDrive2.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Google Drive?'**
  String get backupDisconnectGoogleDrive2;

  /// No description provided for @backupDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get backupDisconnect;

  /// No description provided for @backupDeleteThisBackup.
  ///
  /// In en, this message translates to:
  /// **'Delete this backup?'**
  String get backupDeleteThisBackup;

  /// No description provided for @importChooseACsvFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file'**
  String get importChooseACsvFile;

  /// No description provided for @importRememberTheseSettingsForThis.
  ///
  /// In en, this message translates to:
  /// **'Remember these settings for this bank'**
  String get importRememberTheseSettingsForThis;

  /// No description provided for @importChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get importChange;

  /// No description provided for @importAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get importAuto;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get importDone;

  /// No description provided for @importRememberThisBank.
  ///
  /// In en, this message translates to:
  /// **'Remember this bank'**
  String get importRememberThisBank;

  /// No description provided for @importForget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get importForget;

  /// No description provided for @importImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importImport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @settingsRefundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get settingsRefundPolicy;

  /// No description provided for @settingsOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsOpenSourceLicenses;

  /// No description provided for @settingsMeetTheDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Meet the Developer'**
  String get settingsMeetTheDeveloper;

  /// No description provided for @settingsContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get settingsContactSupport;

  /// No description provided for @settingsSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get settingsSubject;

  /// No description provided for @settingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get settingsMessage;

  /// No description provided for @settingsSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get settingsSendMessage;

  /// No description provided for @settingsUseApiRate.
  ///
  /// In en, this message translates to:
  /// **'Use API Rate'**
  String get settingsUseApiRate;

  /// No description provided for @settingsRefreshRates.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates'**
  String get settingsRefreshRates;

  /// No description provided for @settingsSearchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies...'**
  String get settingsSearchCurrencies;

  /// No description provided for @settingsCustomRate.
  ///
  /// In en, this message translates to:
  /// **'Custom rate'**
  String get settingsCustomRate;

  /// No description provided for @settingsSetCustomRate.
  ///
  /// In en, this message translates to:
  /// **'Set custom rate'**
  String get settingsSetCustomRate;

  /// No description provided for @settingsNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get settingsNotNow;

  /// No description provided for @settingsGoPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get settingsGoPremium;

  /// No description provided for @settingsCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get settingsCsv;

  /// No description provided for @settingsSpreadsheetFormatForExcelGoogle.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet format for Excel, Google Sheets'**
  String get settingsSpreadsheetFormatForExcelGoogle;

  /// No description provided for @settingsPdfReport.
  ///
  /// In en, this message translates to:
  /// **'PDF Report'**
  String get settingsPdfReport;

  /// No description provided for @settingsFormattedSummaryWithBreakdowns.
  ///
  /// In en, this message translates to:
  /// **'Formatted summary with breakdowns'**
  String get settingsFormattedSummaryWithBreakdowns;

  /// No description provided for @settingsAllIncomeAndExpenseRecords.
  ///
  /// In en, this message translates to:
  /// **'All income and expense records'**
  String get settingsAllIncomeAndExpenseRecords;

  /// No description provided for @settingsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get settingsCategories;

  /// No description provided for @settingsCategoryBreakdownAndTotals.
  ///
  /// In en, this message translates to:
  /// **'Category breakdown and totals'**
  String get settingsCategoryBreakdownAndTotals;

  /// No description provided for @settingsWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get settingsWallets;

  /// No description provided for @settingsWalletBalancesAndHistory.
  ///
  /// In en, this message translates to:
  /// **'Wallet balances and history'**
  String get settingsWalletBalancesAndHistory;

  /// No description provided for @settingsHelpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get settingsHelpFaq;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsLargeTransactionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Large Transaction Threshold'**
  String get settingsLargeTransactionThreshold;

  /// No description provided for @settingsRemindMeBeforeDueDate.
  ///
  /// In en, this message translates to:
  /// **'Remind Me Before Due Date'**
  String get settingsRemindMeBeforeDueDate;

  /// No description provided for @settingsDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'DAILY REMINDERS'**
  String get settingsDailyReminders;

  /// No description provided for @settingsDailyReminders2.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get settingsDailyReminders2;

  /// No description provided for @settingsGetRemindedToTrackYour.
  ///
  /// In en, this message translates to:
  /// **'Get reminded to track your expenses'**
  String get settingsGetRemindedToTrackYour;

  /// No description provided for @settingsBudgetAlerts.
  ///
  /// In en, this message translates to:
  /// **'BUDGET ALERTS'**
  String get settingsBudgetAlerts;

  /// No description provided for @settingsBudgetAlerts2.
  ///
  /// In en, this message translates to:
  /// **'Budget Alerts'**
  String get settingsBudgetAlerts2;

  /// No description provided for @settingsNotifyWhenApproachingBudgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Notify when approaching budget limit'**
  String get settingsNotifyWhenApproachingBudgetLimit;

  /// No description provided for @settingsWarningThreshold.
  ///
  /// In en, this message translates to:
  /// **'Warning Threshold'**
  String get settingsWarningThreshold;

  /// No description provided for @settingsTransactionAlerts.
  ///
  /// In en, this message translates to:
  /// **'TRANSACTION ALERTS'**
  String get settingsTransactionAlerts;

  /// No description provided for @settingsLargeTransactionAlerts.
  ///
  /// In en, this message translates to:
  /// **'Large Transaction Alerts'**
  String get settingsLargeTransactionAlerts;

  /// No description provided for @settingsNotifyForTransactionsAboveThreshold.
  ///
  /// In en, this message translates to:
  /// **'Notify for transactions above threshold'**
  String get settingsNotifyForTransactionsAboveThreshold;

  /// No description provided for @settingsRecurringTransactionReminders.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transaction Reminders'**
  String get settingsRecurringTransactionReminders;

  /// No description provided for @settingsRemindAboutUpcomingRecurringPayments.
  ///
  /// In en, this message translates to:
  /// **'Remind about upcoming recurring payments'**
  String get settingsRemindAboutUpcomingRecurringPayments;

  /// No description provided for @settingsOtherNotifications.
  ///
  /// In en, this message translates to:
  /// **'OTHER NOTIFICATIONS'**
  String get settingsOtherNotifications;

  /// No description provided for @settingsSubscriptionExpiryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Subscription Expiry Alerts'**
  String get settingsSubscriptionExpiryAlerts;

  /// No description provided for @settingsGetNotifiedBeforeYourPremium.
  ///
  /// In en, this message translates to:
  /// **'Get notified before your premium expires'**
  String get settingsGetNotifiedBeforeYourPremium;

  /// No description provided for @settingsPromotionalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Promotional Notifications'**
  String get settingsPromotionalNotifications;

  /// No description provided for @settingsReceiveOffersAndFeatureUpdates.
  ///
  /// In en, this message translates to:
  /// **'Receive offers and feature updates'**
  String get settingsReceiveOffersAndFeatureUpdates;

  /// No description provided for @settingsTurnOnDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Turn on daily reminders?'**
  String get settingsTurnOnDailyReminders;

  /// No description provided for @settingsEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get settingsEnterAmount;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get settingsReminderTime;

  /// No description provided for @settingsPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settingsPrivacySecurity;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get settingsSecurity;

  /// No description provided for @settingsBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get settingsBiometricLock;

  /// No description provided for @settingsUseFingerprintOrFaceTo.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face to unlock'**
  String get settingsUseFingerprintOrFaceTo;

  /// No description provided for @settingsAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get settingsAutoLock;

  /// No description provided for @settingsDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'DATA PRIVACY'**
  String get settingsDataPrivacy;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCachedDataAndForce.
  ///
  /// In en, this message translates to:
  /// **'Clear cached data and force re-sync'**
  String get settingsClearCachedDataAndForce;

  /// No description provided for @settingsClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get settingsClearAllData;

  /// No description provided for @settingsDeleteAllTransactionsBudgetsAnd.
  ///
  /// In en, this message translates to:
  /// **'Delete all transactions, budgets, and settings'**
  String get settingsDeleteAllTransactionsBudgetsAnd;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get settingsDangerZone;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsPermanentlyDeleteYourAccountAnd.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get settingsPermanentlyDeleteYourAccountAnd;

  /// No description provided for @settingsAutoLockTimeout.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock Timeout'**
  String get settingsAutoLockTimeout;

  /// No description provided for @settingsDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete Everything'**
  String get settingsDeleteEverything;

  /// No description provided for @settingsAreYouAbsolutelySure.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure?'**
  String get settingsAreYouAbsolutelySure;

  /// No description provided for @settingsYesDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete All'**
  String get settingsYesDeleteAll;

  /// No description provided for @settingsContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get settingsContinue;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get settingsDisplayName;

  /// No description provided for @settingsEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get settingsEmailAddress;

  /// No description provided for @settingsUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get settingsUnsavedChanges;

  /// No description provided for @settingsStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get settingsStay;

  /// No description provided for @settingsLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get settingsLeave;

  /// No description provided for @settingsSearchByCodeOrName.
  ///
  /// In en, this message translates to:
  /// **'Search by code or name...'**
  String get settingsSearchByCodeOrName;

  /// No description provided for @settingsSearchSettings.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get settingsSearchSettings;

  /// No description provided for @settingsSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsSubscription;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// No description provided for @settingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get settingsGoals;

  /// No description provided for @settingsCardsInNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Count credit cards in net worth'**
  String get settingsCardsInNetWorth;

  /// No description provided for @settingsCardsInNetWorthSub.
  ///
  /// In en, this message translates to:
  /// **'Off: only money you have counts, not card balances.'**
  String get settingsCardsInNetWorthSub;

  /// No description provided for @settingsSaveTowardSomethingAndTrack.
  ///
  /// In en, this message translates to:
  /// **'Save toward something and track how far along you are'**
  String get settingsSaveTowardSomethingAndTrack;

  /// No description provided for @settingsBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get settingsBudgets;

  /// No description provided for @settingsSetLimitsAndSeeHow.
  ///
  /// In en, this message translates to:
  /// **'Set limits and see how the period is going'**
  String get settingsSetLimitsAndSeeHow;

  /// No description provided for @settingsUpcomingAndOverdue.
  ///
  /// In en, this message translates to:
  /// **'Upcoming and overdue'**
  String get settingsUpcomingAndOverdue;

  /// No description provided for @settingsWhatIsDueAndWhat.
  ///
  /// In en, this message translates to:
  /// **'What is due, and what was missed'**
  String get settingsWhatIsDueAndWhat;

  /// No description provided for @settingsAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get settingsAccounts;

  /// No description provided for @settingsAddReorderAndEditYour.
  ///
  /// In en, this message translates to:
  /// **'Add, reorder, and edit your accounts'**
  String get settingsAddReorderAndEditYour;

  /// No description provided for @settingsTheCardsAndAccountsYou.
  ///
  /// In en, this message translates to:
  /// **'The cards and accounts you pay with'**
  String get settingsTheCardsAndAccountsYou;

  /// No description provided for @settingsWhereSomethingGoesBasedOn.
  ///
  /// In en, this message translates to:
  /// **'Where something goes, based on what it is called'**
  String get settingsWhereSomethingGoesBasedOn;

  /// No description provided for @settingsNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get settingsNotificationSettings;

  /// No description provided for @settingsCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get settingsCloudSync;

  /// No description provided for @settingsSyncYourDataAcrossDevices.
  ///
  /// In en, this message translates to:
  /// **'Sync your data across devices'**
  String get settingsSyncYourDataAcrossDevices;

  /// No description provided for @settingsCsvIsFreePdfReport.
  ///
  /// In en, this message translates to:
  /// **'CSV is free · PDF report is Premium'**
  String get settingsCsvIsFreePdfReport;

  /// No description provided for @settingsQuestionsComplaintsOrFeedback.
  ///
  /// In en, this message translates to:
  /// **'Questions, complaints, or feedback'**
  String get settingsQuestionsComplaintsOrFeedback;

  /// No description provided for @settingsRateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get settingsRateTheApp;

  /// No description provided for @settingsShareWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get settingsShareWithFriends;

  /// No description provided for @settingsReplayAppTour.
  ///
  /// In en, this message translates to:
  /// **'Replay App Tour'**
  String get settingsReplayAppTour;

  /// No description provided for @settingsSeeTheFeatureWalkthroughAgain.
  ///
  /// In en, this message translates to:
  /// **'See the feature walkthrough again'**
  String get settingsSeeTheFeatureWalkthroughAgain;

  /// No description provided for @settingsAboutTheAccountant.
  ///
  /// In en, this message translates to:
  /// **'About The Accountant'**
  String get settingsAboutTheAccountant;

  /// No description provided for @settingsVersionLicensesAndMore.
  ///
  /// In en, this message translates to:
  /// **'Version, licenses, and more'**
  String get settingsVersionLicensesAndMore;

  /// No description provided for @settingsTestCrash.
  ///
  /// In en, this message translates to:
  /// **'Test Crash'**
  String get settingsTestCrash;

  /// No description provided for @settingsTriggerATestExceptionFor.
  ///
  /// In en, this message translates to:
  /// **'Trigger a test exception for Crashlytics'**
  String get settingsTriggerATestExceptionFor;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER'**
  String get settingsDeveloper;

  /// No description provided for @settingsRestoreFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud?'**
  String get settingsRestoreFromCloud;

  /// No description provided for @settingsSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get settingsSyncing;

  /// No description provided for @settingsSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get settingsSynced;

  /// No description provided for @settingsSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync Error'**
  String get settingsSyncError;

  /// No description provided for @syncBackgroundFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sync. Your changes are safe on this device and will sync later.'**
  String get syncBackgroundFailed;

  /// No description provided for @settingsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get settingsOffline;

  /// No description provided for @settingsReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get settingsReady;

  /// No description provided for @settingsYesUseThis.
  ///
  /// In en, this message translates to:
  /// **'Yes, use this'**
  String get settingsYesUseThis;

  /// No description provided for @settingsKeepThemSeparate.
  ///
  /// In en, this message translates to:
  /// **'Keep them separate?'**
  String get settingsKeepThemSeparate;

  /// No description provided for @settingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get settingsCurrentPassword;

  /// No description provided for @settingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get settingsNewPassword;

  /// No description provided for @settingsConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get settingsConfirmPassword;

  /// No description provided for @walletEGPersonalSavingsBusiness.
  ///
  /// In en, this message translates to:
  /// **'e.g., Personal, Savings, Business'**
  String get walletEGPersonalSavingsBusiness;

  /// No description provided for @walletEnterCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Enter credit limit'**
  String get walletEnterCreditLimit;

  /// No description provided for @walletSelectBillingDay.
  ///
  /// In en, this message translates to:
  /// **'Select billing day'**
  String get walletSelectBillingDay;

  /// No description provided for @walletCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get walletCreateAccount;

  /// No description provided for @walletWalletCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Wallet created successfully'**
  String get walletWalletCreatedSuccessfully;

  /// No description provided for @walletAccountUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get walletAccountUpdatedSuccessfully;

  /// No description provided for @walletEditAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get walletEditAccount;

  /// No description provided for @walletSetAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get walletSetAsDefault;

  /// No description provided for @walletUseDecimals.
  ///
  /// In en, this message translates to:
  /// **'Use Decimals'**
  String get walletUseDecimals;

  /// No description provided for @walletEnterWalletName.
  ///
  /// In en, this message translates to:
  /// **'Enter wallet name'**
  String get walletEnterWalletName;

  /// No description provided for @walletCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get walletCurrency;

  /// No description provided for @walletIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get walletIcon;

  /// No description provided for @walletColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get walletColor;

  /// No description provided for @walletWalletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletWalletName;

  /// No description provided for @walletInitialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial Balance'**
  String get walletInitialBalance;

  /// No description provided for @txAddATransferFee.
  ///
  /// In en, this message translates to:
  /// **'Add a transfer fee'**
  String get txAddATransferFee;

  /// No description provided for @txRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get txRemove;

  /// No description provided for @txPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get txPaymentMethod;

  /// No description provided for @txObjective.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get txObjective;

  /// No description provided for @txTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get txTitle;

  /// No description provided for @txTesco.
  ///
  /// In en, this message translates to:
  /// **'Tesco'**
  String get txTesco;

  /// No description provided for @txAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get txAll;

  /// No description provided for @txSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get txSkip;

  /// No description provided for @txMarkAsPaid2.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get txMarkAsPaid2;

  /// No description provided for @txConfirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get txConfirmPayment;

  /// No description provided for @txAmountCharged.
  ///
  /// In en, this message translates to:
  /// **'Amount charged'**
  String get txAmountCharged;

  /// No description provided for @txUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get txUndo;

  /// No description provided for @txNoLoan.
  ///
  /// In en, this message translates to:
  /// **'No loan'**
  String get txNoLoan;

  /// No description provided for @txLentMoney.
  ///
  /// In en, this message translates to:
  /// **'Lent Money'**
  String get txLentMoney;

  /// No description provided for @txBorrowedMoney.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Money'**
  String get txBorrowedMoney;

  /// No description provided for @goalShowOnTheHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Show on the home screen'**
  String get goalShowOnTheHomeScreen;

  /// No description provided for @goalWhatAreYouSavingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get goalWhatAreYouSavingFor;

  /// No description provided for @goalNewLaptop.
  ///
  /// In en, this message translates to:
  /// **'New laptop'**
  String get goalNewLaptop;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get goalTarget;

  /// No description provided for @goalColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get goalColour;

  /// No description provided for @goalClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get goalClear;

  /// No description provided for @goalGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalGoal;

  /// No description provided for @goalThisGoalNoLongerExists.
  ///
  /// In en, this message translates to:
  /// **'This goal no longer exists.'**
  String get goalThisGoalNoLongerExists;

  /// No description provided for @goalAddToGoal.
  ///
  /// In en, this message translates to:
  /// **'Add to goal'**
  String get goalAddToGoal;

  /// No description provided for @goalUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get goalUnlink;

  /// No description provided for @reportUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get reportUpgrade;

  /// No description provided for @budgetSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get budgetSpending;

  /// No description provided for @budgetEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get budgetEarnings;

  /// No description provided for @budgetEvery.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get budgetEvery;

  /// No description provided for @budgetCarryOverWhatIsLeft.
  ///
  /// In en, this message translates to:
  /// **'Carry over what is left'**
  String get budgetCarryOverWhatIsLeft;

  /// No description provided for @budgetGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get budgetGroceries;

  /// No description provided for @authLinkYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Your Account'**
  String get authLinkYourAccount;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authLinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get authLinkAccount;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailAddress;

  /// No description provided for @authSendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get authSendResetCode;

  /// No description provided for @authResetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get authResetCode;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInToContinueYour.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your financial journey'**
  String get authSignInToContinueYour;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authJoinUsToStartYour.
  ///
  /// In en, this message translates to:
  /// **'Join us to start your financial journey'**
  String get authJoinUsToStartYour;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @premiumPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPremium;

  /// No description provided for @premiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premiumMonthly;

  /// No description provided for @premiumYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premiumYearly;

  /// No description provided for @premiumLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get premiumLifetime;

  /// No description provided for @premiumNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get premiumNotNow;

  /// No description provided for @aiRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get aiRename;

  /// No description provided for @aiRenameChat.
  ///
  /// In en, this message translates to:
  /// **'Rename chat'**
  String get aiRenameChat;

  /// No description provided for @aiDeleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat?'**
  String get aiDeleteChat;

  /// No description provided for @aiChatName.
  ///
  /// In en, this message translates to:
  /// **'Chat name'**
  String get aiChatName;

  /// No description provided for @aiScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get aiScanReceipt;

  /// No description provided for @aiCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get aiCamera;

  /// No description provided for @aiGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get aiGallery;

  /// No description provided for @aiMerchantTitle.
  ///
  /// In en, this message translates to:
  /// **'Merchant / title'**
  String get aiMerchantTitle;

  /// No description provided for @aiSaveAsTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save as transaction'**
  String get aiSaveAsTransaction;

  /// No description provided for @onboardBrowseThemes.
  ///
  /// In en, this message translates to:
  /// **'Browse themes'**
  String get onboardBrowseThemes;

  /// No description provided for @onboardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardBack;

  /// No description provided for @onboardGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardGetStarted;

  /// No description provided for @onboardMainAccount.
  ///
  /// In en, this message translates to:
  /// **'Main Account'**
  String get onboardMainAccount;

  /// No description provided for @creditRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get creditRecordPayment;

  /// No description provided for @creditPleaseEnterAValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get creditPleaseEnterAValidAmount;

  /// No description provided for @creditAmountExceedsRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds remaining balance'**
  String get creditAmountExceedsRemainingBalance;

  /// No description provided for @creditPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get creditPaymentAmount;

  /// No description provided for @creditPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get creditPaidOn;

  /// No description provided for @creditFullAmount.
  ///
  /// In en, this message translates to:
  /// **'Full amount'**
  String get creditFullAmount;

  /// No description provided for @subSubscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Subscription name'**
  String get subSubscriptionName;

  /// No description provided for @subAskBeforeEachPayment.
  ///
  /// In en, this message translates to:
  /// **'Ask before recording each payment'**
  String get subAskBeforeEachPayment;

  /// No description provided for @subAskBeforeEachPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Each payment waits in Upcoming until you confirm what was charged, or skip it. Best for charges that vary, like a card paid in another currency.'**
  String get subAskBeforeEachPaymentHint;

  /// No description provided for @subChangesApplyFromNext.
  ///
  /// In en, this message translates to:
  /// **'A new amount or account applies from the next payment. Payments already made stay as they were.'**
  String get subChangesApplyFromNext;

  /// No description provided for @catPleaseEnterACategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get catPleaseEnterACategoryName;

  /// No description provided for @catEnterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get catEnterCategoryName;

  /// No description provided for @catSearch.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get catSearch;

  /// No description provided for @catNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No category matches that.'**
  String get catNoMatch;

  /// No description provided for @catUseEmoji.
  ///
  /// In en, this message translates to:
  /// **'Use an emoji'**
  String get catUseEmoji;

  /// No description provided for @catEmojiHint.
  ///
  /// In en, this message translates to:
  /// **'Type or pick one emoji'**
  String get catEmojiHint;

  /// No description provided for @catArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get catArchive;

  /// No description provided for @catMergeInto.
  ///
  /// In en, this message translates to:
  /// **'Merge into…'**
  String get catMergeInto;

  /// No description provided for @catMergeIntoTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge {name} into'**
  String catMergeIntoTitle(String name);

  /// No description provided for @catMergeBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get catMergeBuiltIn;

  /// No description provided for @catMergeNoTargets.
  ///
  /// In en, this message translates to:
  /// **'There is no other category of the same kind to merge into.'**
  String get catMergeNoTargets;

  /// No description provided for @catMergeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge {from} into {to}?'**
  String catMergeConfirmTitle(String from, String to);

  /// No description provided for @catMergeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Every transaction, budget and subcategory in {from} moves to {to}, and {from} is removed. This syncs to your other devices.'**
  String catMergeConfirmBody(String from, String to);

  /// No description provided for @catMergeAction.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get catMergeAction;

  /// No description provided for @catMerged.
  ///
  /// In en, this message translates to:
  /// **'Merged {from} into {to}.'**
  String catMerged(String from, String to);

  /// No description provided for @catExpenseSection.
  ///
  /// In en, this message translates to:
  /// **'Expense categories'**
  String get catExpenseSection;

  /// No description provided for @catIncomeSection.
  ///
  /// In en, this message translates to:
  /// **'Income categories'**
  String get catIncomeSection;

  /// No description provided for @catSectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get catSectionEmpty;

  /// No description provided for @catSubcategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 subcategory} other{{count} subcategories}}'**
  String catSubcategoryCount(int count);

  /// No description provided for @catTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String catTransactionCount(int count);

  /// No description provided for @catInParent.
  ///
  /// In en, this message translates to:
  /// **'In {name}'**
  String catInParent(String name);

  /// No description provided for @catAddSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add subcategory'**
  String get catAddSubcategory;

  /// No description provided for @catMoveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to…'**
  String get catMoveTo;

  /// No description provided for @catMoveToTitle.
  ///
  /// In en, this message translates to:
  /// **'Move {name} to'**
  String catMoveToTitle(String name);

  /// No description provided for @catTopLevel.
  ///
  /// In en, this message translates to:
  /// **'Top level'**
  String get catTopLevel;

  /// No description provided for @catTopLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Not inside any category'**
  String get catTopLevelHint;

  /// No description provided for @catMovedInto.
  ///
  /// In en, this message translates to:
  /// **'{name} is now in {parent}.'**
  String catMovedInto(String name, String parent);

  /// No description provided for @catMovedToTop.
  ///
  /// In en, this message translates to:
  /// **'{name} is now a top-level category.'**
  String catMovedToTop(String name);

  /// No description provided for @catMoveNoParents.
  ///
  /// In en, this message translates to:
  /// **'There is no category it can go inside.'**
  String get catMoveNoParents;

  /// No description provided for @catMoveTransactions.
  ///
  /// In en, this message translates to:
  /// **'Move transactions…'**
  String get catMoveTransactions;

  /// No description provided for @catMoveTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Move {name}\'s transactions to'**
  String catMoveTransactionsTitle(String name);

  /// No description provided for @catMoveTransactionsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Move 1 transaction to {to}?} other{Move {count} transactions to {to}?}}'**
  String catMoveTransactionsConfirmTitle(int count, String to);

  /// No description provided for @catMoveTransactionsConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Only the transactions move. {from} stays, with its budgets and subcategories. This syncs to your other devices.'**
  String catMoveTransactionsConfirmBody(String from, String to);

  /// No description provided for @catMoveAction.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get catMoveAction;

  /// No description provided for @catMovedTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 transaction to {to}.} other{Moved {count} transactions to {to}.}}'**
  String catMovedTransactions(int count, String to);

  /// No description provided for @catNoTransactionsToMove.
  ///
  /// In en, this message translates to:
  /// **'{name} has no transactions to move.'**
  String catNoTransactionsToMove(String name);

  /// No description provided for @catNoMoveTargets.
  ///
  /// In en, this message translates to:
  /// **'There is no other category of the same kind to move them to.'**
  String get catNoMoveTargets;

  /// No description provided for @catDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String catDeleteTitle(String name);

  /// No description provided for @catDeleteEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'It has no transactions, so nothing else changes.'**
  String get catDeleteEmptyBody;

  /// No description provided for @catDeleteChildrenNote.
  ///
  /// In en, this message translates to:
  /// **'Its subcategories move to the top level.'**
  String get catDeleteChildrenNote;

  /// No description provided for @catDeleteWithTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction is filed under it. What should happen to it?} other{{count} transactions are filed under it. What should happen to them?}}'**
  String catDeleteWithTransactions(int count);

  /// No description provided for @catDeleteMoveThem.
  ///
  /// In en, this message translates to:
  /// **'Move to another category'**
  String get catDeleteMoveThem;

  /// No description provided for @catDeleteMoveThemHint.
  ///
  /// In en, this message translates to:
  /// **'Then {name} is deleted. Budgets that used it move too.'**
  String catDeleteMoveThemHint(String name);

  /// No description provided for @catDeleteThemToo.
  ///
  /// In en, this message translates to:
  /// **'Delete the transactions too'**
  String get catDeleteThemToo;

  /// No description provided for @catDeleteThemTooHint.
  ///
  /// In en, this message translates to:
  /// **'They go to Recently deleted, where you can restore them for 30 days.'**
  String get catDeleteThemTooHint;

  /// No description provided for @catDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {name}.'**
  String catDeleted(String name);

  /// No description provided for @catActionFailed.
  ///
  /// In en, this message translates to:
  /// **'That could not be done. Try again.'**
  String get catActionFailed;

  /// No description provided for @catStaysTopLevel.
  ///
  /// In en, this message translates to:
  /// **'This category has subcategories of its own, so it stays at the top level.'**
  String get catStaysTopLevel;

  /// No description provided for @catUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get catUnarchive;

  /// No description provided for @catArchivedSection.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get catArchivedSection;

  /// No description provided for @catArchivedHint.
  ///
  /// In en, this message translates to:
  /// **'Kept for their history, but not offered when you add a transaction.'**
  String get catArchivedHint;

  /// No description provided for @catNothingItsOwnCategory.
  ///
  /// In en, this message translates to:
  /// **'Nothing — its own category'**
  String get catNothingItsOwnCategory;

  /// No description provided for @notifEnableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notifEnableNotifications;

  /// No description provided for @startupContinueWithoutChecking.
  ///
  /// In en, this message translates to:
  /// **'Continue without checking?'**
  String get startupContinueWithoutChecking;

  /// No description provided for @startupContinueOffline.
  ///
  /// In en, this message translates to:
  /// **'Continue offline'**
  String get startupContinueOffline;

  /// No description provided for @startupViewSubscriptionOptions.
  ///
  /// In en, this message translates to:
  /// **'View subscription options'**
  String get startupViewSubscriptionOptions;

  /// No description provided for @sharedWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get sharedWelcomeBack;

  /// No description provided for @sharedRestoringYourDataFromThe.
  ///
  /// In en, this message translates to:
  /// **'Restoring your data from the cloud…'**
  String get sharedRestoringYourDataFromThe;

  /// No description provided for @walletMergeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge {source} into {target}?'**
  String walletMergeConfirmTitle(String source, String target);

  /// No description provided for @backupNothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get backupNothingHereYet;

  /// No description provided for @importAppliedAutomaticallyWhenAFile.
  ///
  /// In en, this message translates to:
  /// **'Applied automatically when a file has these columns'**
  String get importAppliedAutomaticallyWhenAFile;

  /// No description provided for @importDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get importDateFormat;

  /// No description provided for @importChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Choose one'**
  String get importChooseOne;

  /// No description provided for @importDecimalPoint.
  ///
  /// In en, this message translates to:
  /// **'Decimal point'**
  String get importDecimalPoint;

  /// No description provided for @importFlipTheSigns.
  ///
  /// In en, this message translates to:
  /// **'Flip the signs'**
  String get importFlipTheSigns;

  /// No description provided for @importForExportsThatWriteA.
  ///
  /// In en, this message translates to:
  /// **'For exports that write a spend as positive'**
  String get importForExportsThatWriteA;

  /// No description provided for @importWhereRowsGoWhenThe.
  ///
  /// In en, this message translates to:
  /// **'Where rows go when the file does not name an account of yours'**
  String get importWhereRowsGoWhenThe;

  /// No description provided for @importSkipWhatIsAlreadyHere.
  ///
  /// In en, this message translates to:
  /// **'Skip what is already here'**
  String get importSkipWhatIsAlreadyHere;

  /// No description provided for @importCreateCategoriesTheFileNames.
  ///
  /// In en, this message translates to:
  /// **'Create categories the file names'**
  String get importCreateCategoriesTheFileNames;

  /// No description provided for @importOtherwiseThoseRowsArriveUncategorised.
  ///
  /// In en, this message translates to:
  /// **'Otherwise those rows arrive uncategorised'**
  String get importOtherwiseThoseRowsArriveUncategorised;

  /// No description provided for @importCategoriesInThisFile.
  ///
  /// In en, this message translates to:
  /// **'Categories in this file'**
  String get importCategoriesInThisFile;

  /// No description provided for @settingsMadeWithLoveForPersonal.
  ///
  /// In en, this message translates to:
  /// **'Made with love for personal finance'**
  String get settingsMadeWithLoveForPersonal;

  /// No description provided for @settingsTheAccountant.
  ///
  /// In en, this message translates to:
  /// **'The Accountant'**
  String get settingsTheAccountant;

  /// No description provided for @settingsDevelopedMaintainedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed & Maintained By:'**
  String get settingsDevelopedMaintainedBy;

  /// No description provided for @settingsPrantaDutta.
  ///
  /// In en, this message translates to:
  /// **'Pranta Dutta'**
  String get settingsPrantaDutta;

  /// No description provided for @settingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsClose;

  /// No description provided for @settingsGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get settingsGetInTouch;

  /// No description provided for @settingsAsAPremiumMemberYour.
  ///
  /// In en, this message translates to:
  /// **'As a Premium member, your request is flagged for priority.'**
  String get settingsAsAPremiumMemberYour;

  /// No description provided for @settingsWhatToInclude.
  ///
  /// In en, this message translates to:
  /// **'What to include'**
  String get settingsWhatToInclude;

  /// No description provided for @settingsNoCurrenciesFound.
  ///
  /// In en, this message translates to:
  /// **'No currencies found'**
  String get settingsNoCurrenciesFound;

  /// No description provided for @settingsExportYourFinancialDataTo.
  ///
  /// In en, this message translates to:
  /// **'Export your financial data to analyze in other apps or keep as a backup.'**
  String get settingsExportYourFinancialDataTo;

  /// No description provided for @settingsDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get settingsDateRange;

  /// No description provided for @settingsPremium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get settingsPremium;

  /// No description provided for @settingsPdfReports.
  ///
  /// In en, this message translates to:
  /// **'PDF Reports'**
  String get settingsPdfReports;

  /// No description provided for @settingsGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get settingsGettingStarted;

  /// No description provided for @settingsStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get settingsStillNeedHelp;

  /// No description provided for @settingsOurSupportTeamIsHere.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to help you'**
  String get settingsOurSupportTeamIsHere;

  /// No description provided for @settingsAppLocked.
  ///
  /// In en, this message translates to:
  /// **'App Locked'**
  String get settingsAppLocked;

  /// No description provided for @settingsUnlockToAccessTheAccountant.
  ///
  /// In en, this message translates to:
  /// **'Unlock to access The Accountant'**
  String get settingsUnlockToAccessTheAccountant;

  /// No description provided for @settingsConfigureWhenAndHowThe.
  ///
  /// In en, this message translates to:
  /// **'Configure when and how The Accountant should remind you to track your expenses.'**
  String get settingsConfigureWhenAndHowThe;

  /// No description provided for @settingsYourEmailIsUsedTo.
  ///
  /// In en, this message translates to:
  /// **'Your email is used to sign in and can’t be changed here.'**
  String get settingsYourEmailIsUsedTo;

  /// No description provided for @settingsYourDataIsOnThis.
  ///
  /// In en, this message translates to:
  /// **'Your data is on this device only'**
  String get settingsYourDataIsOnThis;

  /// No description provided for @settingsUpgradeForCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for cloud sync'**
  String get settingsUpgradeForCloudSync;

  /// No description provided for @settingsNoSettingsFound.
  ///
  /// In en, this message translates to:
  /// **'No settings found'**
  String get settingsNoSettingsFound;

  /// No description provided for @settingsTryADifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get settingsTryADifferentSearchTerm;

  /// No description provided for @settingsSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'SYNC STATUS'**
  String get settingsSyncStatus;

  /// No description provided for @settingsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get settingsSyncNow;

  /// No description provided for @settingsRestoreFromCloud2.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud'**
  String get settingsRestoreFromCloud2;

  /// No description provided for @settingsPro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get settingsPro;

  /// No description provided for @settingsNeedsYourConfirmation.
  ///
  /// In en, this message translates to:
  /// **'NEEDS YOUR CONFIRMATION'**
  String get settingsNeedsYourConfirmation;

  /// No description provided for @walletCreateYourFirstAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Account'**
  String get walletCreateYourFirstAccount;

  /// No description provided for @walletYouNeedAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'You need at least one account to start tracking your finances'**
  String get walletYouNeedAtLeastOne;

  /// No description provided for @walletAccountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get walletAccountType;

  /// No description provided for @walletAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get walletAccountName;

  /// No description provided for @walletCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get walletCreditLimit;

  /// No description provided for @walletCreditLimitHelp.
  ///
  /// In en, this message translates to:
  /// **'Limit went up? Change it here. A new limit is not income.'**
  String get walletCreditLimitHelp;

  /// No description provided for @walletAmountOwed.
  ///
  /// In en, this message translates to:
  /// **'Amount owed'**
  String get walletAmountOwed;

  /// No description provided for @walletAmountOwedHelp.
  ///
  /// In en, this message translates to:
  /// **'What you owe on the card right now. Use 0 if it is paid off.'**
  String get walletAmountOwedHelp;

  /// No description provided for @walletCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get walletCurrentBalance;

  /// No description provided for @walletCurrentBalanceHelp.
  ///
  /// In en, this message translates to:
  /// **'A change is saved as a balance correction, so your history still adds up.'**
  String get walletCurrentBalanceHelp;

  /// No description provided for @walletCardBalanceQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is {amount} on this card?'**
  String walletCardBalanceQuestion(String amount);

  /// No description provided for @walletCardBalanceCreditLeft.
  ///
  /// In en, this message translates to:
  /// **'Credit I have left'**
  String get walletCardBalanceCreditLeft;

  /// No description provided for @walletCardBalanceOwed.
  ///
  /// In en, this message translates to:
  /// **'What I owe'**
  String get walletCardBalanceOwed;

  /// No description provided for @walletCardBalanceChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose what this amount is, so the debt is worked out right.'**
  String get walletCardBalanceChoose;

  /// No description provided for @walletBillingCycleDayOptional.
  ///
  /// In en, this message translates to:
  /// **'Billing Cycle Day (optional)'**
  String get walletBillingCycleDayOptional;

  /// No description provided for @walletThisWillBeYourDefault.
  ///
  /// In en, this message translates to:
  /// **'This will be your default account'**
  String get walletThisWillBeYourDefault;

  /// No description provided for @walletNothingRecordedAgainstThisAccount.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded against this account yet.'**
  String get walletNothingRecordedAgainstThisAccount;

  /// No description provided for @walletAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get walletAddAccount;

  /// No description provided for @walletYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Your Accounts'**
  String get walletYourAccounts;

  /// No description provided for @walletNoAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get walletNoAccountsYet;

  /// No description provided for @walletOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get walletOutstanding;

  /// No description provided for @walletAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get walletAvailable;

  /// No description provided for @walletLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get walletLimit;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalance;

  /// No description provided for @walletUseThisWalletForNew.
  ///
  /// In en, this message translates to:
  /// **'Use this wallet for new transactions'**
  String get walletUseThisWalletForNew;

  /// No description provided for @walletSelectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get walletSelectIcon;

  /// No description provided for @walletSelectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get walletSelectColor;

  /// No description provided for @txYouNeedAtLeast2.
  ///
  /// In en, this message translates to:
  /// **'You need at least 2 accounts to make a transfer'**
  String get txYouNeedAtLeast2;

  /// No description provided for @txNoAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'No account to record this against'**
  String get txNoAccountTitle;

  /// No description provided for @txNoAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Add an account, or reopen a closed one, and this form is ready to use.'**
  String get txNoAccountBody;

  /// No description provided for @txNoAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Manage accounts'**
  String get txNoAccountAction;

  /// No description provided for @txDeleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get txDeleteTransaction;

  /// No description provided for @txAreYouSureYouWant.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get txAreYouSureYouWant;

  /// No description provided for @txTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get txTransactionType;

  /// No description provided for @txTransferFee.
  ///
  /// In en, this message translates to:
  /// **'Transfer fee'**
  String get txTransferFee;

  /// No description provided for @txChargedSeparatelySoTheTransfer.
  ///
  /// In en, this message translates to:
  /// **'Charged separately, so the transfer itself stays balanced.'**
  String get txChargedSeparatelySoTheTransfer;

  /// No description provided for @txDeductedFrom.
  ///
  /// In en, this message translates to:
  /// **'Deducted from'**
  String get txDeductedFrom;

  /// No description provided for @txNoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment methods'**
  String get txNoPaymentMethods;

  /// No description provided for @txNothingDeletedRecently.
  ///
  /// In en, this message translates to:
  /// **'Nothing deleted recently'**
  String get txNothingDeletedRecently;

  /// No description provided for @txAnythingYouDeleteShowsUp.
  ///
  /// In en, this message translates to:
  /// **'Anything you delete shows up here for thirty days.'**
  String get txAnythingYouDeleteShowsUp;

  /// No description provided for @txNoRulesYet.
  ///
  /// In en, this message translates to:
  /// **'No rules yet'**
  String get txNoRulesYet;

  /// No description provided for @txClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get txClearAll;

  /// No description provided for @txApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get txApplyFilters;

  /// No description provided for @txUpcomingOverdue.
  ///
  /// In en, this message translates to:
  /// **'Upcoming & Overdue'**
  String get txUpcomingOverdue;

  /// No description provided for @txNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get txNew;

  /// No description provided for @txLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get txLoan;

  /// No description provided for @goalStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get goalStarted;

  /// No description provided for @goalTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get goalTargetDate;

  /// No description provided for @goalWithADateTheGoal.
  ///
  /// In en, this message translates to:
  /// **'With a date, the goal works out how much to put aside each day.'**
  String get goalWithADateTheGoal;

  /// No description provided for @goalCountedTowardThisGoal.
  ///
  /// In en, this message translates to:
  /// **'Counted toward this goal'**
  String get goalCountedTowardThisGoal;

  /// No description provided for @goalGettingThere.
  ///
  /// In en, this message translates to:
  /// **'Getting there'**
  String get goalGettingThere;

  /// No description provided for @goalSetATargetDateAnd.
  ///
  /// In en, this message translates to:
  /// **'Set a target date and this works out what to put aside.'**
  String get goalSetATargetDateAnd;

  /// No description provided for @reportSpendingInsights.
  ///
  /// In en, this message translates to:
  /// **'Spending Insights'**
  String get reportSpendingInsights;

  /// No description provided for @reportNoSpendingDataForThis.
  ///
  /// In en, this message translates to:
  /// **'No spending data for this period'**
  String get reportNoSpendingDataForThis;

  /// No description provided for @reportNoCategorySpendingData.
  ///
  /// In en, this message translates to:
  /// **'No category spending data'**
  String get reportNoCategorySpendingData;

  /// No description provided for @reportNoSpendingDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No spending data available'**
  String get reportNoSpendingDataAvailable;

  /// No description provided for @reportBudgetVsActual.
  ///
  /// In en, this message translates to:
  /// **'Budget vs Actual'**
  String get reportBudgetVsActual;

  /// No description provided for @reportNoActiveBudgets.
  ///
  /// In en, this message translates to:
  /// **'No active budgets'**
  String get reportNoActiveBudgets;

  /// No description provided for @reportCreateABudgetToTrack.
  ///
  /// In en, this message translates to:
  /// **'Create a budget to track your spending'**
  String get reportCreateABudgetToTrack;

  /// No description provided for @budgetSpendingFasterThanThePeriod.
  ///
  /// In en, this message translates to:
  /// **'Spending faster than the period is passing.'**
  String get budgetSpendingFasterThanThePeriod;

  /// No description provided for @budgetNothingRecordedInThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in this period.'**
  String get budgetNothingRecordedInThisPeriod;

  /// No description provided for @authPasswordResetSuccessfullyPleaseSign.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please sign in.'**
  String get authPasswordResetSuccessfullyPleaseSign;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authPleaseAcceptTheTermsAnd.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions'**
  String get authPleaseAcceptTheTermsAnd;

  /// No description provided for @authPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password Strength'**
  String get authPasswordStrength;

  /// No description provided for @authAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAnAccount;

  /// No description provided for @authPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get authPersonalInformation;

  /// No description provided for @authUpgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get authUpgradeToPremium;

  /// No description provided for @authUnlockUnlimitedBudgetsAdvancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited budgets, advanced analytics, and more!'**
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics;

  /// No description provided for @authUpgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get authUpgradeNow;

  /// No description provided for @authPremiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get authPremiumMember;

  /// No description provided for @authEnjoyingAllPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Enjoying all premium features'**
  String get authEnjoyingAllPremiumFeatures;

  /// No description provided for @authSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get authSaveChanges;

  /// No description provided for @authAreYouSureYouWant.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account?'**
  String get authAreYouSureYouWant;

  /// No description provided for @authChangeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get authChangeProfilePhoto;

  /// No description provided for @authTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get authTakePhoto;

  /// No description provided for @authUseYourCamera.
  ///
  /// In en, this message translates to:
  /// **'Use your camera'**
  String get authUseYourCamera;

  /// No description provided for @authChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get authChooseFromGallery;

  /// No description provided for @authSelectAnExistingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select an existing photo'**
  String get authSelectAnExistingPhoto;

  /// No description provided for @authPhotoSelectedUploadFeatureComing.
  ///
  /// In en, this message translates to:
  /// **'Photo selected! Upload feature coming soon.'**
  String get authPhotoSelectedUploadFeatureComing;

  /// No description provided for @authNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get authNameCannotBeEmpty;

  /// No description provided for @authProfileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get authProfileUpdatedSuccessfully;

  /// No description provided for @authTheAccountant.
  ///
  /// In en, this message translates to:
  /// **'THE ACCOUNTANT'**
  String get authTheAccountant;

  /// No description provided for @legalPrivacyTerms.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Terms'**
  String get legalPrivacyTerms;

  /// No description provided for @legalReviewTheseBeforeYouContinue.
  ///
  /// In en, this message translates to:
  /// **'Review these before you continue.'**
  String get legalReviewTheseBeforeYouContinue;

  /// No description provided for @premiumLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get premiumLimitReached;

  /// No description provided for @aiChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get aiChats;

  /// No description provided for @aiNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get aiNewChat;

  /// No description provided for @aiNoConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get aiNoConversationsYet;

  /// No description provided for @aiStartChattingAndYourThreads.
  ///
  /// In en, this message translates to:
  /// **'Start chatting and your threads show up here.'**
  String get aiStartChattingAndYourThreads;

  /// No description provided for @aiScanAReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get aiScanAReceipt;

  /// No description provided for @aiReadingYourReceipt.
  ///
  /// In en, this message translates to:
  /// **'Reading your receipt…'**
  String get aiReadingYourReceipt;

  /// No description provided for @aiReviewSave.
  ///
  /// In en, this message translates to:
  /// **'Review & save'**
  String get aiReviewSave;

  /// No description provided for @aiWeReadThisFromYour.
  ///
  /// In en, this message translates to:
  /// **'We read this from your receipt — check it and edit anything before saving.'**
  String get aiWeReadThisFromYour;

  /// No description provided for @dashErrorLoadingFinancialData.
  ///
  /// In en, this message translates to:
  /// **'Error loading financial data'**
  String get dashErrorLoadingFinancialData;

  /// No description provided for @dashNoSpendingDataYet.
  ///
  /// In en, this message translates to:
  /// **'No spending data yet'**
  String get dashNoSpendingDataYet;

  /// No description provided for @dashManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get dashManage;

  /// No description provided for @dashAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available: ****'**
  String get dashAvailable;

  /// No description provided for @onboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get onboardWelcome;

  /// No description provided for @onboardSelectYourDefaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select your default currency'**
  String get onboardSelectYourDefaultCurrency;

  /// No description provided for @onboardLoadingCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Loading currencies...'**
  String get onboardLoadingCurrencies;

  /// No description provided for @onboardSetUpYourPrimaryWallet.
  ///
  /// In en, this message translates to:
  /// **'Set up your primary wallet'**
  String get onboardSetUpYourPrimaryWallet;

  /// No description provided for @onboardInitialBalanceOptional.
  ///
  /// In en, this message translates to:
  /// **'Initial Balance (optional)'**
  String get onboardInitialBalanceOptional;

  /// No description provided for @onboardYourAccountIsReadyTo.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready to use'**
  String get onboardYourAccountIsReadyTo;

  /// No description provided for @onboardTipYouCanAddMore.
  ///
  /// In en, this message translates to:
  /// **'Tip: You can add more accounts with different currencies anytime from the Wallets section.'**
  String get onboardTipYouCanAddMore;

  /// No description provided for @creditSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get creditSettled;

  /// No description provided for @creditOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get creditOverdue;

  /// No description provided for @creditRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get creditRecord;

  /// No description provided for @subRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get subRecurring;

  /// No description provided for @subPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get subPaused;

  /// No description provided for @subAsksFirst.
  ///
  /// In en, this message translates to:
  /// **'Asks first'**
  String get subAsksFirst;

  /// No description provided for @subFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get subFrequency;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkAllRead;

  /// No description provided for @notifTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get notifTryAgain;

  /// No description provided for @notifStayOnTopOfYour.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of your money'**
  String get notifStayOnTopOfYour;

  /// No description provided for @notifNoNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifNoNotificationsYet;

  /// No description provided for @notifWhenYouReceiveNotificationsThey.
  ///
  /// In en, this message translates to:
  /// **'When you receive notifications, they will appear here.'**
  String get notifWhenYouReceiveNotificationsThey;

  /// No description provided for @startupNothingHasBeenChangedOr.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been changed or deleted.'**
  String get startupNothingHasBeenChangedOr;

  /// No description provided for @sharedIncludeCryptoCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Include crypto currencies'**
  String get sharedIncludeCryptoCurrencies;

  /// No description provided for @sharedTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get sharedTotalBalance;

  /// No description provided for @heatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily rhythm'**
  String get heatmapTitle;

  /// No description provided for @heatmapSpentMore.
  ///
  /// In en, this message translates to:
  /// **'Spent more'**
  String get heatmapSpentMore;

  /// No description provided for @heatmapEarnedMore.
  ///
  /// In en, this message translates to:
  /// **'Earned more'**
  String get heatmapEarnedMore;

  /// No description provided for @amountsLeftOutNoRate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One transaction is not shown: no rate is known between its account\'s currency and {currency}} other{{count} transactions are not shown: no rate is known between their accounts\' currencies and {currency}}}.'**
  String amountsLeftOutNoRate(int count, String currency);

  /// No description provided for @heatmapNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in this period yet.'**
  String get heatmapNothingYet;

  /// No description provided for @heatmapNetForRange.
  ///
  /// In en, this message translates to:
  /// **'Net over this range'**
  String get heatmapNetForRange;

  /// No description provided for @layoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Home layout'**
  String get layoutTitle;

  /// No description provided for @layoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder the home screen, or hide what you do not use'**
  String get layoutSubtitle;

  /// No description provided for @layoutExplain.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Anything switched off keeps its place, so turning it back on puts it where you left it.'**
  String get layoutExplain;

  /// No description provided for @layoutReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get layoutReset;

  /// No description provided for @layoutAllHidden.
  ///
  /// In en, this message translates to:
  /// **'Every section is hidden. The home screen will be empty.'**
  String get layoutAllHidden;

  /// No description provided for @layoutSectionGreeting.
  ///
  /// In en, this message translates to:
  /// **'Greeting'**
  String get layoutSectionGreeting;

  /// No description provided for @layoutSectionAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get layoutSectionAccounts;

  /// No description provided for @layoutSectionQuickStats.
  ///
  /// In en, this message translates to:
  /// **'Income and expenses'**
  String get layoutSectionQuickStats;

  /// No description provided for @layoutSectionQuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get layoutSectionQuickLinks;

  /// No description provided for @layoutSectionSpendingChart.
  ///
  /// In en, this message translates to:
  /// **'Spending overview'**
  String get layoutSectionSpendingChart;

  /// No description provided for @layoutSectionRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get layoutSectionRecent;

  /// No description provided for @layoutSectionBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budget progress'**
  String get layoutSectionBudgets;

  /// No description provided for @layoutSectionGoals.
  ///
  /// In en, this message translates to:
  /// **'Pinned goals'**
  String get layoutSectionGoals;

  /// No description provided for @shortcutAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get shortcutAddExpense;

  /// No description provided for @shortcutAddIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get shortcutAddIncome;

  /// No description provided for @shortcutScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get shortcutScanReceipt;

  /// No description provided for @shortcutTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get shortcutTransactions;

  /// No description provided for @backupBusySyncing.
  ///
  /// In en, this message translates to:
  /// **'A sync is running. Wait for it to finish before restoring.'**
  String get backupBusySyncing;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @themeSunriseLight.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Light'**
  String get themeSunriseLight;

  /// No description provided for @themeSunriseDark.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Dark'**
  String get themeSunriseDark;

  /// No description provided for @themeMatchSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get themeMatchSystem;

  /// No description provided for @themeMatchSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark with your phone'**
  String get themeMatchSystemHint;

  /// No description provided for @themeUnlockAll.
  ///
  /// In en, this message translates to:
  /// **'Unlock all themes'**
  String get themeUnlockAll;

  /// No description provided for @themeProBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get themeProBadge;

  /// No description provided for @themeAccentSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get themeAccentSunrise;

  /// No description provided for @themeAccentSapphire.
  ///
  /// In en, this message translates to:
  /// **'Sapphire'**
  String get themeAccentSapphire;

  /// No description provided for @themeAccentEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get themeAccentEmerald;

  /// No description provided for @themeAccentRuby.
  ///
  /// In en, this message translates to:
  /// **'Ruby'**
  String get themeAccentRuby;

  /// No description provided for @themeAccentAmethyst.
  ///
  /// In en, this message translates to:
  /// **'Amethyst'**
  String get themeAccentAmethyst;

  /// No description provided for @themeAccentGraphite.
  ///
  /// In en, this message translates to:
  /// **'Graphite'**
  String get themeAccentGraphite;

  /// No description provided for @themeAppearanceValue.
  ///
  /// In en, this message translates to:
  /// **'{accent} {mode}'**
  String themeAppearanceValue(String accent, String mode);

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @walkthroughTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Your day at a glance'**
  String get walkthroughTodayTitle;

  /// No description provided for @walkthroughTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Net worth, what you earned and spent, and today’s activity.'**
  String get walkthroughTodayBody;

  /// No description provided for @walkthroughAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add in seconds'**
  String get walkthroughAddTitle;

  /// No description provided for @walkthroughAddBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Add to record an expense, income or transfer.'**
  String get walkthroughAddBody;

  /// No description provided for @walkthroughTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your transactions'**
  String get walkthroughTransactionsTitle;

  /// No description provided for @walkthroughTransactionsBody.
  ///
  /// In en, this message translates to:
  /// **'Every transaction, month by month. Search and filter to find anything.'**
  String get walkthroughTransactionsBody;

  /// No description provided for @walkthroughStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'See where it goes'**
  String get walkthroughStatsTitle;

  /// No description provided for @walkthroughStatsBody.
  ///
  /// In en, this message translates to:
  /// **'Charts by week, month and year, by category.'**
  String get walkthroughStatsBody;

  /// No description provided for @walkthroughBellTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay informed'**
  String get walkthroughBellTitle;

  /// No description provided for @walkthroughBellBody.
  ///
  /// In en, this message translates to:
  /// **'Budget alerts and reminders appear here. You’re all set!'**
  String get walkthroughBellBody;

  /// No description provided for @walkthroughBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your net worth'**
  String get walkthroughBalanceTitle;

  /// No description provided for @walkthroughBalanceBody.
  ///
  /// In en, this message translates to:
  /// **'Every wallet adds up here, with a bar showing how it splits.'**
  String get walkthroughBalanceBody;

  /// No description provided for @txTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get txTransfer;

  /// No description provided for @txUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get txUncategorized;

  /// No description provided for @todayGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String todayGoodMorning(String name);

  /// No description provided for @todayGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String todayGoodAfternoon(String name);

  /// No description provided for @todayGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String todayGoodEvening(String name);

  /// No description provided for @todayGoodMorningPlain.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get todayGoodMorningPlain;

  /// No description provided for @todayGoodAfternoonPlain.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get todayGoodAfternoonPlain;

  /// No description provided for @todayGoodEveningPlain.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get todayGoodEveningPlain;

  /// No description provided for @todayNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Net worth'**
  String get todayNetWorth;

  /// No description provided for @todayThisMonthDelta.
  ///
  /// In en, this message translates to:
  /// **'{amount} this month'**
  String todayThisMonthDelta(String amount);

  /// No description provided for @todayEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get todayEarned;

  /// No description provided for @todaySpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get todaySpent;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @todayRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get todayRecent;

  /// No description provided for @todayAllActivity.
  ///
  /// In en, this message translates to:
  /// **'All activity'**
  String get todayAllActivity;

  /// No description provided for @todayNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet today'**
  String get todayNothingYet;

  /// No description provided for @todayNothingYetBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Add to record your first one.'**
  String get todayNothingYetBody;

  /// No description provided for @todayMoreWallets.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String todayMoreWallets(int count);

  /// No description provided for @todayCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask your money coach'**
  String get todayCoachTitle;

  /// No description provided for @todayCoachBody.
  ///
  /// In en, this message translates to:
  /// **'Answers and nudges from your own spending'**
  String get todayCoachBody;

  /// No description provided for @todayNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get todayNotifications;

  /// No description provided for @todayWithinBudget.
  ///
  /// In en, this message translates to:
  /// **'Within budget'**
  String get todayWithinBudget;

  /// No description provided for @todayOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get todayOverBudget;

  /// No description provided for @todayNetCredit.
  ///
  /// In en, this message translates to:
  /// **'Net credit'**
  String get todayNetCredit;

  /// No description provided for @todayNetDebt.
  ///
  /// In en, this message translates to:
  /// **'Net debt'**
  String get todayNetDebt;

  /// No description provided for @todayMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get todayMonthly;

  /// No description provided for @walletsTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get walletsTitle;

  /// No description provided for @walletsNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get walletsNew;

  /// No description provided for @walletsAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add bank, cash, savings…'**
  String get walletsAddHint;

  /// No description provided for @walletsPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get walletsPlanning;

  /// No description provided for @walletsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get walletsUpcoming;

  /// No description provided for @walletsUpcomingSub.
  ///
  /// In en, this message translates to:
  /// **'{count} due · {amount}'**
  String walletsUpcomingSub(int count, String amount);

  /// No description provided for @walletsUpcomingNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing due soon'**
  String get walletsUpcomingNone;

  /// No description provided for @walletsLendBorrow.
  ///
  /// In en, this message translates to:
  /// **'Lend & borrow'**
  String get walletsLendBorrow;

  /// No description provided for @splitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split a bill'**
  String get splitTitle;

  /// No description provided for @splitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a bill with friends; what they owe goes to Lend & borrow'**
  String get splitSubtitle;

  /// No description provided for @splitWhatFor.
  ///
  /// In en, this message translates to:
  /// **'What was it for'**
  String get splitWhatFor;

  /// No description provided for @splitTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get splitTotal;

  /// No description provided for @splitPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get splitPeople;

  /// No description provided for @splitYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get splitYou;

  /// No description provided for @splitIncludeMe.
  ///
  /// In en, this message translates to:
  /// **'I had a share'**
  String get splitIncludeMe;

  /// No description provided for @splitIncludeMeSub.
  ///
  /// In en, this message translates to:
  /// **'Turn off when you paid for the others only'**
  String get splitIncludeMeSub;

  /// No description provided for @splitAddPerson.
  ///
  /// In en, this message translates to:
  /// **'Add a person'**
  String get splitAddPerson;

  /// No description provided for @splitPersonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get splitPersonName;

  /// No description provided for @splitKnownPeople.
  ///
  /// In en, this message translates to:
  /// **'From Lend & borrow'**
  String get splitKnownPeople;

  /// No description provided for @splitRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get splitRemove;

  /// No description provided for @splitPaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get splitPaidBy;

  /// No description provided for @splitHow.
  ///
  /// In en, this message translates to:
  /// **'How to split'**
  String get splitHow;

  /// No description provided for @splitEqual.
  ///
  /// In en, this message translates to:
  /// **'Equally'**
  String get splitEqual;

  /// No description provided for @splitExact.
  ///
  /// In en, this message translates to:
  /// **'Amounts'**
  String get splitExact;

  /// No description provided for @splitPercent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get splitPercent;

  /// No description provided for @splitShares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get splitShares;

  /// No description provided for @splitYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share'**
  String get splitYourShare;

  /// No description provided for @splitOwesYou.
  ///
  /// In en, this message translates to:
  /// **'Owes you'**
  String get splitOwesYou;

  /// No description provided for @splitYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {name}'**
  String splitYouOwe(String name);

  /// No description provided for @splitPaidTheBill.
  ///
  /// In en, this message translates to:
  /// **'Paid the bill'**
  String get splitPaidTheBill;

  /// No description provided for @splitSettlesWith.
  ///
  /// In en, this message translates to:
  /// **'Settles up with {name}'**
  String splitSettlesWith(String name);

  /// No description provided for @splitSummaryIPaid.
  ///
  /// In en, this message translates to:
  /// **'{total} from your account; {owed} owed back to you'**
  String splitSummaryIPaid(String total, String owed);

  /// No description provided for @splitSummaryTheyPaid.
  ///
  /// In en, this message translates to:
  /// **'Nothing leaves your account now; you owe {name} {amount}'**
  String splitSummaryTheyPaid(String name, String amount);

  /// No description provided for @splitPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Percent of the bill'**
  String get splitPercentLabel;

  /// No description provided for @splitSave.
  ///
  /// In en, this message translates to:
  /// **'Split it'**
  String get splitSave;

  /// No description provided for @splitSaved.
  ///
  /// In en, this message translates to:
  /// **'Split recorded'**
  String get splitSaved;

  /// No description provided for @splitNeedCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category first.'**
  String get splitNeedCategory;

  /// No description provided for @splitThisBill.
  ///
  /// In en, this message translates to:
  /// **'Split this bill'**
  String get splitThisBill;

  /// No description provided for @splitThisBillSub.
  ///
  /// In en, this message translates to:
  /// **'With friends; what they owe goes to Lend & borrow'**
  String get splitThisBillSub;

  /// No description provided for @splitPartOf.
  ///
  /// In en, this message translates to:
  /// **'Split bill'**
  String get splitPartOf;

  /// No description provided for @walletsOwedToYou.
  ///
  /// In en, this message translates to:
  /// **'You’re owed {amount}'**
  String walletsOwedToYou(String amount);

  /// No description provided for @walletsYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}'**
  String walletsYouOwe(String amount);

  /// No description provided for @walletsAllSettled.
  ///
  /// In en, this message translates to:
  /// **'All settled'**
  String get walletsAllSettled;

  /// No description provided for @walletsGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get walletsGoals;

  /// No description provided for @walletsGoalsSub.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String walletsGoalsSub(int count);

  /// No description provided for @walletsBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get walletsBudgets;

  /// No description provided for @walletsSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get walletsSubscriptions;

  /// No description provided for @walletsTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer between wallets'**
  String get walletsTransfer;

  /// No description provided for @walletsArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get walletsArchived;

  /// No description provided for @walletsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? Every transaction in this account is deleted with it.'**
  String walletsDeleteMessage(String name);

  /// No description provided for @walletsDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String walletsDeleted(String name);

  /// No description provided for @walletsSetDefaultDone.
  ///
  /// In en, this message translates to:
  /// **'{name} is now your default'**
  String walletsSetDefaultDone(String name);

  /// No description provided for @walletsCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t create the account. Please try again.'**
  String get walletsCreateFailed;

  /// No description provided for @walletsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first account to start tracking.'**
  String get walletsEmptyBody;

  /// No description provided for @walletsTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get walletsTypeBank;

  /// No description provided for @walletsTypeCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get walletsTypeCard;

  /// No description provided for @walletsTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get walletsTypeCash;

  /// No description provided for @walletsTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get walletsTypeOther;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreGoPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get moreGoPremium;

  /// No description provided for @moreGoPremiumBody.
  ///
  /// In en, this message translates to:
  /// **'AI assistant, cloud sync, themes'**
  String get moreGoPremiumBody;

  /// No description provided for @moreUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get moreUnlock;

  /// No description provided for @morePremiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium is active'**
  String get morePremiumActive;

  /// No description provided for @morePremiumThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for supporting The Accountant'**
  String get morePremiumThanks;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get sectionPreferences;

  /// No description provided for @sectionTools.
  ///
  /// In en, this message translates to:
  /// **'MONEY TOOLS'**
  String get sectionTools;

  /// No description provided for @moreAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get moreAiAssistant;

  /// No description provided for @moreAiAssistantSub.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about your money'**
  String get moreAiAssistantSub;

  /// No description provided for @moreSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account on this device?'**
  String get moreSignOutConfirm;

  /// No description provided for @moreSignOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t sign out. Please try again.'**
  String get moreSignOutFailed;

  /// No description provided for @moreDeviceOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'Free accounts aren’t backed up to the cloud, so reinstalling or switching phones can lose your data. Upgrade for cloud sync, or export a backup regularly.'**
  String get moreDeviceOnlyBody;

  /// No description provided for @moreUpgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get moreUpgradeToPremium;

  /// No description provided for @moreUser.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get moreUser;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// No description provided for @statsWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsWeek;

  /// No description provided for @statsMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsMonth;

  /// No description provided for @statsYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsYear;

  /// No description provided for @statsSpending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get statsSpending;

  /// No description provided for @statsIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get statsIncome;

  /// No description provided for @statsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get statsCategories;

  /// No description provided for @statsSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get statsSpent;

  /// No description provided for @statsEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get statsEarned;

  /// No description provided for @statsNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get statsNet;

  /// No description provided for @statsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get statsThisMonth;

  /// No description provided for @statsVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{change} vs last month'**
  String statsVsLastMonth(String change);

  /// No description provided for @statsInsightsSub.
  ///
  /// In en, this message translates to:
  /// **'This month’s summary, trends & tips'**
  String get statsInsightsSub;

  /// No description provided for @statsAskCoach.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI coach about this'**
  String get statsAskCoach;

  /// No description provided for @statsOverBy.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String statsOverBy(String amount);

  /// No description provided for @statsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{percent}% remaining'**
  String statsRemaining(String percent);

  /// No description provided for @activityAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get activityAll;

  /// No description provided for @activitySpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get activitySpent;

  /// No description provided for @activityEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get activityEarned;

  /// No description provided for @activityTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get activityTransfers;

  /// No description provided for @activitySoFar.
  ///
  /// In en, this message translates to:
  /// **'{month} so far'**
  String activitySoFar(String month);

  /// No description provided for @activityNet.
  ///
  /// In en, this message translates to:
  /// **'{amount} net'**
  String activityNet(String amount);

  /// No description provided for @activitySearchFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 match across all months} other{{count} matches across all months}}'**
  String activitySearchFound(int count);

  /// No description provided for @activitySearchNothingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”'**
  String activitySearchNothingTitle(String query);

  /// No description provided for @activitySearchNothingBody.
  ///
  /// In en, this message translates to:
  /// **'Every month was searched. Try fewer words, another spelling, or clear a filter.'**
  String get activitySearchNothingBody;

  /// No description provided for @activityIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get activityIn;

  /// No description provided for @activityOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get activityOut;

  /// No description provided for @activityToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get activityToday;

  /// No description provided for @activityYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get activityYesterday;

  /// No description provided for @activityTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get activityTomorrow;

  /// No description provided for @activityEmptyFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'No planned transactions'**
  String get activityEmptyFutureTitle;

  /// No description provided for @activityEmptyFutureBody.
  ///
  /// In en, this message translates to:
  /// **'Add future payments for {month}'**
  String activityEmptyFutureBody(String month);

  /// No description provided for @activityEmptyNowTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get activityEmptyNowTitle;

  /// No description provided for @activityEmptyNowBody.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses this month'**
  String get activityEmptyNowBody;

  /// No description provided for @activityEmptyPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get activityEmptyPastTitle;

  /// No description provided for @activityEmptyPastBody.
  ///
  /// In en, this message translates to:
  /// **'No records for {month}'**
  String activityEmptyPastBody(String month);

  /// No description provided for @activityDeletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction deleted} other{{count} transactions deleted}}'**
  String activityDeletedCount(int count);

  /// No description provided for @activityMovedToCategory.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} to {name}'**
  String activityMovedToCategory(int count, String name);

  /// No description provided for @activityMixedCurrencies.
  ///
  /// In en, this message translates to:
  /// **'These are held in different currencies, so there is no one account they can all move to. Select rows from one currency.'**
  String get activityMixedCurrencies;

  /// No description provided for @activityMovedPartial.
  ///
  /// In en, this message translates to:
  /// **'Moved {count}; transfers were left where they are'**
  String activityMovedPartial(int count);

  /// No description provided for @activityMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} to another account'**
  String activityMoved(int count);

  /// No description provided for @activityRedated.
  ///
  /// In en, this message translates to:
  /// **'Re-dated {count}'**
  String activityRedated(int count);

  /// No description provided for @activityNothingToPay.
  ///
  /// In en, this message translates to:
  /// **'Nothing was waiting to be paid'**
  String get activityNothingToPay;

  /// No description provided for @activityMarkedPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked {count} as paid'**
  String activityMarkedPaid(int count);

  /// No description provided for @activityCopiedPartial.
  ///
  /// In en, this message translates to:
  /// **'Copied {count}; transfers cannot be copied on their own'**
  String activityCopiedPartial(int count);

  /// No description provided for @activityCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {count}'**
  String activityCopied(int count);

  /// No description provided for @activityDeleteOneBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from your records and your balance will be recalculated.'**
  String get activityDeleteOneBody;

  /// No description provided for @activitySearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get activitySearch;

  /// No description provided for @addNewExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get addNewExpense;

  /// No description provided for @addNewIncome.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get addNewIncome;

  /// No description provided for @addNewTransfer.
  ///
  /// In en, this message translates to:
  /// **'New transfer'**
  String get addNewTransfer;

  /// No description provided for @addEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get addEditTitle;

  /// No description provided for @addAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get addAmount;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addCategory;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get addMore;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get addWallet;

  /// No description provided for @addChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date, {date}'**
  String addChangeDate(String date);

  /// No description provided for @addChangeTime.
  ///
  /// In en, this message translates to:
  /// **'Change time, {time}'**
  String addChangeTime(String time);

  /// No description provided for @addSwapAccounts.
  ///
  /// In en, this message translates to:
  /// **'Swap the two accounts'**
  String get addSwapAccounts;

  /// No description provided for @notifCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check notifications'**
  String get notifCheckTitle;

  /// No description provided for @notifAllowed.
  ///
  /// In en, this message translates to:
  /// **'Notifications are allowed'**
  String get notifAllowed;

  /// No description provided for @notifAllowedHint.
  ///
  /// In en, this message translates to:
  /// **'Reminders can reach this phone'**
  String get notifAllowedHint;

  /// No description provided for @notifBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get notifBlocked;

  /// No description provided for @notifBlockedHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to allow them, or nothing can reach you'**
  String get notifBlockedHint;

  /// No description provided for @notifSendTest.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get notifSendTest;

  /// No description provided for @notifSendTestHint.
  ///
  /// In en, this message translates to:
  /// **'Sent from our server, the way reminders come'**
  String get notifSendTestHint;

  /// No description provided for @notifSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get notifSending;

  /// No description provided for @notifTestSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. It should appear in a few seconds, and in your inbox.'**
  String get notifTestSent;

  /// No description provided for @notifTestFailed.
  ///
  /// In en, this message translates to:
  /// **'It could not be sent: {reason}'**
  String notifTestFailed(String reason);

  /// No description provided for @notifTestOffline.
  ///
  /// In en, this message translates to:
  /// **'no connection to the server'**
  String get notifTestOffline;

  /// No description provided for @notifDailyPrimerBody.
  ///
  /// In en, this message translates to:
  /// **'The Accountant will send a gentle daily nudge to log your spending, at the time you choose. It needs permission to show notifications.'**
  String get notifDailyPrimerBody;

  /// No description provided for @notifPrimerShow.
  ///
  /// In en, this message translates to:
  /// **'Show reminder notifications'**
  String get notifPrimerShow;

  /// No description provided for @notifPrimerTime.
  ///
  /// In en, this message translates to:
  /// **'Arrive at your chosen time'**
  String get notifPrimerTime;

  /// No description provided for @notifPrimerOff.
  ///
  /// In en, this message translates to:
  /// **'You can turn this off anytime'**
  String get notifPrimerOff;

  /// No description provided for @notifPrimerAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get notifPrimerAllow;

  /// No description provided for @cardBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Card bills'**
  String get cardBillsTitle;

  /// No description provided for @cardBillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Credit card statements, due dates and reminders'**
  String get cardBillsSubtitle;

  /// No description provided for @cardBillsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No credit cards yet'**
  String get cardBillsEmptyTitle;

  /// No description provided for @cardBillsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add an account of the Credit card type, set its statement day and due day, and its bills show up here.'**
  String get cardBillsEmptyBody;

  /// No description provided for @cardBillsAddCard.
  ///
  /// In en, this message translates to:
  /// **'Add a card'**
  String get cardBillsAddCard;

  /// No description provided for @cardStatementDay.
  ///
  /// In en, this message translates to:
  /// **'Statement day'**
  String get cardStatementDay;

  /// No description provided for @cardStatementDayHint.
  ///
  /// In en, this message translates to:
  /// **'The day each month the bill is made. Everything up to the end of that day is on it.'**
  String get cardStatementDayHint;

  /// No description provided for @cardDueDay.
  ///
  /// In en, this message translates to:
  /// **'Payment due day'**
  String get cardDueDay;

  /// No description provided for @cardDueDayHint.
  ///
  /// In en, this message translates to:
  /// **'The last day to pay the bill, the first time that day comes round after the statement.'**
  String get cardDueDayHint;

  /// No description provided for @cardRemindTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get cardRemindTitle;

  /// No description provided for @cardRemindHint.
  ///
  /// In en, this message translates to:
  /// **'Before the due date, if any of the bill is still unpaid. Sent around 9 AM.'**
  String get cardRemindHint;

  /// No description provided for @cardRemindOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get cardRemindOff;

  /// No description provided for @cardRemindDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{The day before} other{{days} days before}}'**
  String cardRemindDaysBefore(int days);

  /// No description provided for @cardNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get cardNotSet;

  /// No description provided for @cardDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String cardDayOfMonth(int day);

  /// No description provided for @cardSetUpBody.
  ///
  /// In en, this message translates to:
  /// **'Set the statement day and the due day to see this card\'s bills and get reminded before they are due.'**
  String get cardSetUpBody;

  /// No description provided for @cardSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set the dates'**
  String get cardSetUp;

  /// No description provided for @cardDueBy.
  ///
  /// In en, this message translates to:
  /// **'Left to pay by {date}'**
  String cardDueBy(String date);

  /// No description provided for @cardLeftToPay.
  ///
  /// In en, this message translates to:
  /// **'Left to pay'**
  String get cardLeftToPay;

  /// No description provided for @cardStatementClosed.
  ///
  /// In en, this message translates to:
  /// **'Statement of {date}'**
  String cardStatementClosed(String date);

  /// No description provided for @cardPaidSince.
  ///
  /// In en, this message translates to:
  /// **'Paid since'**
  String get cardPaidSince;

  /// No description provided for @cardThisCycle.
  ///
  /// In en, this message translates to:
  /// **'Spent since, next statement {date}'**
  String cardThisCycle(String date);

  /// No description provided for @cardPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'{card} bill payment'**
  String cardPaymentTitle(String card);

  /// No description provided for @cardEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get cardEdit;

  /// No description provided for @cardEarlierStatements.
  ///
  /// In en, this message translates to:
  /// **'EARLIER STATEMENTS'**
  String get cardEarlierStatements;

  /// No description provided for @cardPaidShort.
  ///
  /// In en, this message translates to:
  /// **'paid'**
  String get cardPaidShort;

  /// No description provided for @cardUnpaidShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} unpaid'**
  String cardUnpaidShort(String amount);

  /// No description provided for @cardStatusNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Dates not set'**
  String get cardStatusNotSetUp;

  /// No description provided for @cardStatusNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get cardStatusNothingDue;

  /// No description provided for @cardStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get cardStatusPaid;

  /// No description provided for @cardStatusDueIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Due tomorrow} other{Due in {days} days}}'**
  String cardStatusDueIn(int days);

  /// No description provided for @cardStatusDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get cardStatusDueToday;

  /// No description provided for @cardStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get cardStatusOverdue;

  /// No description provided for @cardPaidOf.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {owed} paid'**
  String cardPaidOf(String paid, String owed);

  /// No description provided for @cardPayBill.
  ///
  /// In en, this message translates to:
  /// **'Pay bill'**
  String get cardPayBill;

  /// No description provided for @cardPayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay {card}'**
  String cardPayTitle(String card);

  /// No description provided for @cardPayHint.
  ///
  /// In en, this message translates to:
  /// **'Pay all of it or part of it. Anything you pay counts toward this bill, and the rest stays due.'**
  String get cardPayHint;

  /// No description provided for @cardPayFull.
  ///
  /// In en, this message translates to:
  /// **'Pay in full, {amount}'**
  String cardPayFull(String amount);

  /// No description provided for @cardPayFullHint.
  ///
  /// In en, this message translates to:
  /// **'Everything left on this bill'**
  String get cardPayFullHint;

  /// No description provided for @cardPayOther.
  ///
  /// In en, this message translates to:
  /// **'Pay another amount'**
  String get cardPayOther;

  /// No description provided for @cardPayOtherHint.
  ///
  /// In en, this message translates to:
  /// **'A part payment, or more than the bill'**
  String get cardPayOtherHint;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addNoteHint;

  /// No description provided for @addRepeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Repeat monthly'**
  String get addRepeatMonthly;

  /// No description provided for @addMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get addMoreOptions;

  /// No description provided for @addScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get addScanReceipt;

  /// No description provided for @addDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get addDelete;

  /// No description provided for @addTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get addTypeExpense;

  /// No description provided for @addTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get addTypeIncome;

  /// No description provided for @addTypeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get addTypeTransfer;

  /// No description provided for @gatePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get gatePremium;

  /// No description provided for @gateUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Premium'**
  String get gateUnlock;

  /// No description provided for @gateFootnote.
  ///
  /// In en, this message translates to:
  /// **'Lifetime or subscription · Restore anytime'**
  String get gateFootnote;

  /// No description provided for @aiCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet your money coach'**
  String get aiCoachTitle;

  /// No description provided for @aiCoachBody.
  ///
  /// In en, this message translates to:
  /// **'Ask in plain words. Get answers, nudges and plans built from your own spending.'**
  String get aiCoachBody;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiAskAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask about your money…'**
  String get aiAskAnything;

  /// No description provided for @aiSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aiSend;

  /// No description provided for @aiCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get aiCopy;

  /// No description provided for @aiCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get aiCopied;

  /// No description provided for @aiRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get aiRetry;

  /// No description provided for @aiDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get aiDismiss;

  /// No description provided for @aiTyping.
  ///
  /// In en, this message translates to:
  /// **'Coach is typing'**
  String get aiTyping;

  /// No description provided for @aiStarterCategory.
  ///
  /// In en, this message translates to:
  /// **'Where did my {category} money go?'**
  String aiStarterCategory(String category);

  /// No description provided for @aiStarterBudgets.
  ///
  /// In en, this message translates to:
  /// **'Am I on track with my budgets?'**
  String get aiStarterBudgets;

  /// No description provided for @aiStarterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'What bills are coming up?'**
  String get aiStarterUpcoming;

  /// No description provided for @aiStarterAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze my recent spending patterns'**
  String get aiStarterAnalyze;

  /// No description provided for @aiStarterBudgetTips.
  ///
  /// In en, this message translates to:
  /// **'Give me tips for better budgeting'**
  String get aiStarterBudgetTips;

  /// No description provided for @aiStarterSave.
  ///
  /// In en, this message translates to:
  /// **'How can I save more money?'**
  String get aiStarterSave;

  /// No description provided for @aiDeleteChatBody.
  ///
  /// In en, this message translates to:
  /// **'“{title}” will be permanently deleted.'**
  String aiDeleteChatBody(String title);

  /// No description provided for @aiJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get aiJustNow;

  /// No description provided for @aiErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'The coach couldn’t answer'**
  String get aiErrorTitle;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Accountant Premium'**
  String get paywallTitle;

  /// No description provided for @paywallTagline.
  ///
  /// In en, this message translates to:
  /// **'Everything the app can do, for you.'**
  String get paywallTagline;

  /// No description provided for @paywallActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium is active'**
  String get paywallActiveTitle;

  /// No description provided for @paywallActiveTagline.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support!'**
  String get paywallActiveTagline;

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get paywallRestore;

  /// No description provided for @paywallProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get paywallProcessing;

  /// No description provided for @paywallTriggered.
  ///
  /// In en, this message translates to:
  /// **'{feature} is a Premium feature'**
  String paywallTriggered(String feature);

  /// No description provided for @paywallDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String paywallDaysRemaining(int days);

  /// No description provided for @paywallFeatSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get paywallFeatSync;

  /// No description provided for @paywallFeatSyncSub.
  ///
  /// In en, this message translates to:
  /// **'All devices'**
  String get paywallFeatSyncSub;

  /// No description provided for @paywallFeatAi.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get paywallFeatAi;

  /// No description provided for @paywallFeatAiSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited, no ads'**
  String get paywallFeatAiSub;

  /// No description provided for @paywallFeatOcr.
  ///
  /// In en, this message translates to:
  /// **'Receipt scan'**
  String get paywallFeatOcr;

  /// No description provided for @paywallFeatOcrSub.
  ///
  /// In en, this message translates to:
  /// **'OCR with AI'**
  String get paywallFeatOcrSub;

  /// No description provided for @paywallFeatInsights.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get paywallFeatInsights;

  /// No description provided for @paywallFeatInsightsSub.
  ///
  /// In en, this message translates to:
  /// **'Monthly trends'**
  String get paywallFeatInsightsSub;

  /// No description provided for @paywallFeatThemes.
  ///
  /// In en, this message translates to:
  /// **'5 themes'**
  String get paywallFeatThemes;

  /// No description provided for @paywallFeatThemesSub.
  ///
  /// In en, this message translates to:
  /// **'Exclusive'**
  String get paywallFeatThemesSub;

  /// No description provided for @paywallFeatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF reports'**
  String get paywallFeatPdf;

  /// No description provided for @paywallFeatPdfSub.
  ///
  /// In en, this message translates to:
  /// **'CSV stays free'**
  String get paywallFeatPdfSub;

  /// No description provided for @paywallFeatUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallFeatUnlimited;

  /// No description provided for @paywallFeatUnlimitedSub.
  ///
  /// In en, this message translates to:
  /// **'Wallets, budgets'**
  String get paywallFeatUnlimitedSub;

  /// No description provided for @paywallFeatSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority help'**
  String get paywallFeatSupport;

  /// No description provided for @paywallFeatSupportSub.
  ///
  /// In en, this message translates to:
  /// **'Faster replies'**
  String get paywallFeatSupportSub;

  /// No description provided for @paywallPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get paywallPerMonth;

  /// No description provided for @paywallPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get paywallPerYear;

  /// No description provided for @paywallOnce.
  ///
  /// In en, this message translates to:
  /// **'once'**
  String get paywallOnce;

  /// No description provided for @paywallBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get paywallBestValue;

  /// No description provided for @paywallForever.
  ///
  /// In en, this message translates to:
  /// **'FOREVER'**
  String get paywallForever;

  /// No description provided for @paywallMonthlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly'**
  String get paywallMonthlyDesc;

  /// No description provided for @paywallYearlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Billed yearly'**
  String get paywallYearlyDesc;

  /// No description provided for @paywallLifetimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay once, keep it forever'**
  String get paywallLifetimeDesc;

  /// No description provided for @paywallTrial.
  ///
  /// In en, this message translates to:
  /// **'{trial} free, then {rest}'**
  String paywallTrial(String trial, String rest);

  /// No description provided for @paywallCtaLifetime.
  ///
  /// In en, this message translates to:
  /// **'Get lifetime access'**
  String get paywallCtaLifetime;

  /// No description provided for @paywallCtaYearly.
  ///
  /// In en, this message translates to:
  /// **'Start yearly plan'**
  String get paywallCtaYearly;

  /// No description provided for @paywallCtaMonthly.
  ///
  /// In en, this message translates to:
  /// **'Start monthly plan'**
  String get paywallCtaMonthly;

  /// No description provided for @paywallFootLifetime.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase · No subscription'**
  String get paywallFootLifetime;

  /// No description provided for @paywallFootSubscription.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically · Cancel anytime in the store'**
  String get paywallFootSubscription;

  /// No description provided for @paywallTerms.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions are charged to your App Store or Google Play account and renew automatically unless canceled at least 24 hours before the end of the current period.'**
  String get paywallTerms;

  /// No description provided for @paywallIapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'In-app purchases are unavailable on this device. Make sure Google Play Services is installed and the app came from the Play Store.'**
  String get paywallIapUnavailable;

  /// No description provided for @paywallLoadingPlans.
  ///
  /// In en, this message translates to:
  /// **'Loading plans…'**
  String get paywallLoadingPlans;

  /// No description provided for @paywallPlansFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load plans. Check your connection and try again.'**
  String get paywallPlansFailed;

  /// No description provided for @paywallTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get paywallTryAgain;

  /// No description provided for @paywallRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get paywallRestored;

  /// No description provided for @paywallPurchased.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Premium!'**
  String get paywallPurchased;

  /// No description provided for @paywallLifetimeNever.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access never expires'**
  String get paywallLifetimeNever;

  /// No description provided for @helpSearchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Search questions'**
  String get helpSearchQuestions;

  /// No description provided for @helpStepWallets.
  ///
  /// In en, this message translates to:
  /// **'Add wallets'**
  String get helpStepWallets;

  /// No description provided for @helpStepCategories.
  ///
  /// In en, this message translates to:
  /// **'Pick categories'**
  String get helpStepCategories;

  /// No description provided for @helpStepTrack.
  ///
  /// In en, this message translates to:
  /// **'Track daily'**
  String get helpStepTrack;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Money, brighter.'**
  String get splashTagline;

  /// No description provided for @introStep1.
  ///
  /// In en, this message translates to:
  /// **'Counting your coins…'**
  String get introStep1;

  /// No description provided for @introStep2.
  ///
  /// In en, this message translates to:
  /// **'Waking up your wallets…'**
  String get introStep2;

  /// No description provided for @introStep3.
  ///
  /// In en, this message translates to:
  /// **'Polishing the charts…'**
  String get introStep3;

  /// No description provided for @introStep4.
  ///
  /// In en, this message translates to:
  /// **'Almost there…'**
  String get introStep4;

  /// No description provided for @introTipLabel.
  ///
  /// In en, this message translates to:
  /// **'Money tip'**
  String get introTipLabel;

  /// No description provided for @introTip1.
  ///
  /// In en, this message translates to:
  /// **'Pay yourself first: move savings out the day your salary lands.'**
  String get introTip1;

  /// No description provided for @introTip2.
  ///
  /// In en, this message translates to:
  /// **'Small daily spends add up. Logging them is half the battle.'**
  String get introTip2;

  /// No description provided for @introTip3.
  ///
  /// In en, this message translates to:
  /// **'A 3-month emergency fund turns surprises into inconveniences.'**
  String get introTip3;

  /// No description provided for @introTip4.
  ///
  /// In en, this message translates to:
  /// **'Review subscriptions monthly: cancel what you didn’t use.'**
  String get introTip4;

  /// No description provided for @introTip5.
  ///
  /// In en, this message translates to:
  /// **'Give every taka a job before the month starts.'**
  String get introTip5;

  /// No description provided for @introTip6.
  ///
  /// In en, this message translates to:
  /// **'Wait 24 hours before any unplanned purchase.'**
  String get introTip6;

  /// No description provided for @introTip7.
  ///
  /// In en, this message translates to:
  /// **'Budgets aren’t limits, they’re permission to spend on what matters.'**
  String get introTip7;

  /// No description provided for @introTip8.
  ///
  /// In en, this message translates to:
  /// **'Celebrate small wins: every goal starts with the first deposit.'**
  String get introTip8;

  /// No description provided for @adConfirmTitleAiCall.
  ///
  /// In en, this message translates to:
  /// **'Get one more AI request'**
  String get adConfirmTitleAiCall;

  /// No description provided for @adConfirmTitleTheme.
  ///
  /// In en, this message translates to:
  /// **'Try premium themes for 24 hours'**
  String get adConfirmTitleTheme;

  /// No description provided for @adConfirmTitlePdf.
  ///
  /// In en, this message translates to:
  /// **'Export one PDF report'**
  String get adConfirmTitlePdf;

  /// No description provided for @adConfirmBodyAiCall.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used this month\'s free AI requests. Watch a short ad and you get one more.'**
  String get adConfirmBodyAiCall;

  /// No description provided for @adConfirmBodyTheme.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad and every premium theme is yours for the next 24 hours.'**
  String get adConfirmBodyTheme;

  /// No description provided for @adConfirmBodyPdf.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to export one PDF report.'**
  String get adConfirmBodyPdf;

  /// No description provided for @adConfirmWarning.
  ///
  /// In en, this message translates to:
  /// **'You\'re about to watch an ad. Continue?'**
  String get adConfirmWarning;

  /// No description provided for @adConfirmLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more ad available this month} other{{count} more ads available this month}}'**
  String adConfirmLeft(int count);

  /// No description provided for @adPremiumPitch.
  ///
  /// In en, this message translates to:
  /// **'Premium members get unlimited AI, every theme and PDF reports, with no ads at all.'**
  String get adPremiumPitch;

  /// No description provided for @adWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch ad'**
  String get adWatch;

  /// No description provided for @adGetPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get adGetPremium;

  /// No description provided for @adNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get adNotNow;

  /// No description provided for @adLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading the ad…'**
  String get adLoading;

  /// No description provided for @adVerifying.
  ///
  /// In en, this message translates to:
  /// **'Confirming your reward…'**
  String get adVerifying;

  /// No description provided for @adUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No ad is available right now. Please try again in a little while.'**
  String get adUnavailable;

  /// No description provided for @adSkipped.
  ///
  /// In en, this message translates to:
  /// **'The ad was closed before the end, so nothing was unlocked.'**
  String get adSkipped;

  /// No description provided for @adRewardAiCall.
  ///
  /// In en, this message translates to:
  /// **'Done! You have one more AI request.'**
  String get adRewardAiCall;

  /// No description provided for @adRewardTheme.
  ///
  /// In en, this message translates to:
  /// **'Premium themes unlocked for 24 hours.'**
  String get adRewardTheme;

  /// No description provided for @adRewardPdf.
  ///
  /// In en, this message translates to:
  /// **'One PDF export unlocked.'**
  String get adRewardPdf;

  /// No description provided for @adMonthlyCapReached.
  ///
  /// In en, this message translates to:
  /// **'That\'s all the ads for this month. Your free requests come back on the 1st, or go Premium for unlimited.'**
  String get adMonthlyCapReached;

  /// No description provided for @adRewardPending.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your reward will appear in a moment.'**
  String get adRewardPending;

  /// No description provided for @aiQuotaLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No free AI requests left this month} =1{1 free AI request left this month} other{{count} free AI requests left this month}}'**
  String aiQuotaLeft(int count);

  /// No description provided for @aiQuotaPremiumUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Premium: unlimited'**
  String get aiQuotaPremiumUnlimited;

  /// No description provided for @aiToolSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching your transactions…'**
  String get aiToolSearching;

  /// No description provided for @aiToolSummarizing.
  ///
  /// In en, this message translates to:
  /// **'Adding up the numbers…'**
  String get aiToolSummarizing;

  /// No description provided for @aiToolAccounts.
  ///
  /// In en, this message translates to:
  /// **'Checking your accounts…'**
  String get aiToolAccounts;

  /// No description provided for @aiToolCategories.
  ///
  /// In en, this message translates to:
  /// **'Looking at your categories…'**
  String get aiToolCategories;

  /// No description provided for @aiToolCards.
  ///
  /// In en, this message translates to:
  /// **'Checking card bills…'**
  String get aiToolCards;

  /// No description provided for @aiToolPlans.
  ///
  /// In en, this message translates to:
  /// **'Checking EMIs and savings…'**
  String get aiToolPlans;

  /// No description provided for @aiToolSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get aiToolSaving;

  /// No description provided for @aiActionAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add this transaction?'**
  String get aiActionAddTitle;

  /// No description provided for @aiActionUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Change this transaction?'**
  String get aiActionUpdateTitle;

  /// No description provided for @aiActionDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get aiActionDeleteTitle;

  /// No description provided for @aiActionPayCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay a card bill'**
  String get aiActionPayCardTitle;

  /// No description provided for @aiActionCardSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Change card dates'**
  String get aiActionCardSettingsTitle;

  /// No description provided for @aiActionCreatePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a plan'**
  String get aiActionCreatePlanTitle;

  /// No description provided for @aiActionPayPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a plan payment'**
  String get aiActionPayPlanTitle;

  /// No description provided for @aiActionClosePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'End a plan early'**
  String get aiActionClosePlanTitle;

  /// No description provided for @aiActionUpdatePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Change a plan'**
  String get aiActionUpdatePlanTitle;

  /// No description provided for @aiActionCreateInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an investment'**
  String get aiActionCreateInvestmentTitle;

  /// No description provided for @aiActionTradeInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a trade'**
  String get aiActionTradeInvestmentTitle;

  /// No description provided for @aiActionUpdateInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Update a price'**
  String get aiActionUpdateInvestmentTitle;

  /// No description provided for @aiActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get aiActionConfirm;

  /// No description provided for @aiActionClosePlan.
  ///
  /// In en, this message translates to:
  /// **'End it'**
  String get aiActionClosePlan;

  /// No description provided for @aiActionFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get aiActionFrom;

  /// No description provided for @aiActionTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get aiActionTo;

  /// No description provided for @aiActionBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get aiActionBill;

  /// No description provided for @aiActionLeftAfter.
  ///
  /// In en, this message translates to:
  /// **'Left after'**
  String get aiActionLeftAfter;

  /// No description provided for @aiActionRemindDays.
  ///
  /// In en, this message translates to:
  /// **'Remind, days before'**
  String get aiActionRemindDays;

  /// No description provided for @aiActionPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get aiActionPay;

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'EMI, loans & savings'**
  String get plansTitle;

  /// No description provided for @investmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get investmentsTitle;

  /// No description provided for @investmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mutual funds, shares and SIPs, valued at their latest price'**
  String get investmentsSubtitle;

  /// No description provided for @forecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash flow forecast'**
  String get forecastTitle;

  /// No description provided for @forecastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where your cash and bank money is headed, and any day it runs short'**
  String get forecastSubtitle;

  /// No description provided for @forecastRangeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String forecastRangeDays(int days);

  /// No description provided for @forecastNow.
  ///
  /// In en, this message translates to:
  /// **'Cash and bank now'**
  String get forecastNow;

  /// No description provided for @forecastMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Coming in'**
  String get forecastMoneyIn;

  /// No description provided for @forecastMoneyOut.
  ///
  /// In en, this message translates to:
  /// **'Going out'**
  String get forecastMoneyOut;

  /// No description provided for @forecastLowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get forecastLowest;

  /// No description provided for @forecastLowestOn.
  ///
  /// In en, this message translates to:
  /// **'on {date}'**
  String forecastLowestOn(String date);

  /// No description provided for @forecastChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Projected balance'**
  String get forecastChartTitle;

  /// No description provided for @forecastShortfallTitle.
  ///
  /// In en, this message translates to:
  /// **'On {date} you would be {amount} short'**
  String forecastShortfallTitle(String date, String amount);

  /// No description provided for @forecastShortfallCause.
  ///
  /// In en, this message translates to:
  /// **'Going out that day:'**
  String get forecastShortfallCause;

  /// No description provided for @forecastAlreadyShort.
  ///
  /// In en, this message translates to:
  /// **'Your cash and bank accounts are already below zero.'**
  String get forecastAlreadyShort;

  /// No description provided for @forecastAllCoveredTitle.
  ///
  /// In en, this message translates to:
  /// **'No shortfall in the next {days} days'**
  String forecastAllCoveredTitle(int days);

  /// No description provided for @forecastAllCoveredBody.
  ///
  /// In en, this message translates to:
  /// **'What is scheduled is covered by your cash and bank money.'**
  String get forecastAllCoveredBody;

  /// No description provided for @forecastScheduledOnly.
  ///
  /// In en, this message translates to:
  /// **'Counts only what is scheduled: plans, card bills, subscriptions, repeating and upcoming payments, and loans with a due date. Everyday spending is not included.'**
  String get forecastScheduledOnly;

  /// No description provided for @forecastEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get forecastEventsTitle;

  /// No description provided for @forecastDayBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String forecastDayBalance(String amount);

  /// No description provided for @forecastEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get forecastEmptyTitle;

  /// No description provided for @forecastEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Plans, card bills, subscriptions and upcoming payments in this period show here.'**
  String get forecastEmptyBody;

  /// No description provided for @forecastOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get forecastOverdue;

  /// No description provided for @forecastExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get forecastExpected;

  /// No description provided for @forecastKindInstallment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get forecastKindInstallment;

  /// No description provided for @forecastKindPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get forecastKindPremium;

  /// No description provided for @forecastKindDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get forecastKindDeposit;

  /// No description provided for @forecastKindSipBuy.
  ///
  /// In en, this message translates to:
  /// **'SIP purchase'**
  String get forecastKindSipBuy;

  /// No description provided for @forecastKindProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get forecastKindProfit;

  /// No description provided for @forecastKindMaturity.
  ///
  /// In en, this message translates to:
  /// **'Maturity'**
  String get forecastKindMaturity;

  /// No description provided for @forecastKindCardBill.
  ///
  /// In en, this message translates to:
  /// **'Card bill'**
  String get forecastKindCardBill;

  /// No description provided for @forecastKindCardBillNext.
  ///
  /// In en, this message translates to:
  /// **'Next card bill, so far'**
  String get forecastKindCardBillNext;

  /// No description provided for @forecastKindSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get forecastKindSubscription;

  /// No description provided for @forecastKindRecurringBill.
  ///
  /// In en, this message translates to:
  /// **'Repeating payment'**
  String get forecastKindRecurringBill;

  /// No description provided for @forecastKindRecurringIncome.
  ///
  /// In en, this message translates to:
  /// **'Repeating income'**
  String get forecastKindRecurringIncome;

  /// No description provided for @forecastKindUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get forecastKindUpcoming;

  /// No description provided for @forecastKindBorrowed.
  ///
  /// In en, this message translates to:
  /// **'Loan to repay'**
  String get forecastKindBorrowed;

  /// No description provided for @forecastKindLent.
  ///
  /// In en, this message translates to:
  /// **'Lent, due back'**
  String get forecastKindLent;

  /// No description provided for @forecastHomeWarning.
  ///
  /// In en, this message translates to:
  /// **'You may be {amount} short on {date}'**
  String forecastHomeWarning(String date, String amount);

  /// No description provided for @forecastHomeWarningBody.
  ///
  /// In en, this message translates to:
  /// **'See what is coming up'**
  String get forecastHomeWarningBody;

  /// No description provided for @forecastDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get forecastDismiss;

  /// No description provided for @forecastNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'You may run short on {day}'**
  String forecastNotifTitle(String day);

  /// No description provided for @forecastNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Scheduled payments would leave you {amount} short. Tap to see what is coming up.'**
  String forecastNotifBody(String amount);

  /// No description provided for @investmentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No investments yet'**
  String get investmentsEmptyTitle;

  /// No description provided for @investmentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Track a mutual fund, shares or gold: what you paid, what it is worth now, and the gain.'**
  String get investmentsEmptyBody;

  /// No description provided for @investmentsSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get investmentsSold;

  /// No description provided for @investmentsWorth.
  ///
  /// In en, this message translates to:
  /// **'Worth now'**
  String get investmentsWorth;

  /// No description provided for @investmentNew.
  ///
  /// In en, this message translates to:
  /// **'New investment'**
  String get investmentNew;

  /// No description provided for @investmentNewHint.
  ///
  /// In en, this message translates to:
  /// **'Units of a fund, a company\'s shares, or anything else bought by the unit, like gold by the gram.'**
  String get investmentNewHint;

  /// No description provided for @investmentKindFund.
  ///
  /// In en, this message translates to:
  /// **'Fund'**
  String get investmentKindFund;

  /// No description provided for @investmentKindStock.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get investmentKindStock;

  /// No description provided for @investmentKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get investmentKindOther;

  /// No description provided for @investmentNameHintFund.
  ///
  /// In en, this message translates to:
  /// **'e.g. UCB Income Plus Fund'**
  String get investmentNameHintFund;

  /// No description provided for @investmentNameHintStock.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grameenphone'**
  String get investmentNameHintStock;

  /// No description provided for @investmentNameHintOther.
  ///
  /// In en, this message translates to:
  /// **'e.g. Gold, 22 carat'**
  String get investmentNameHintOther;

  /// No description provided for @investmentSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol or code (optional)'**
  String get investmentSymbol;

  /// No description provided for @investmentFirstBuy.
  ///
  /// In en, this message translates to:
  /// **'What you bought'**
  String get investmentFirstBuy;

  /// No description provided for @investmentFirstBuyHint.
  ///
  /// In en, this message translates to:
  /// **'Leave the amount empty to add it without buying anything yet.'**
  String get investmentFirstBuyHint;

  /// No description provided for @investmentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get investmentPaid;

  /// No description provided for @investmentReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get investmentReceived;

  /// No description provided for @investmentPaidInto.
  ///
  /// In en, this message translates to:
  /// **'Paid into'**
  String get investmentPaidInto;

  /// No description provided for @investmentFee.
  ///
  /// In en, this message translates to:
  /// **'Fee or commission'**
  String get investmentFee;

  /// No description provided for @investmentUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get investmentUnits;

  /// No description provided for @investmentUnitsSold.
  ///
  /// In en, this message translates to:
  /// **'Units sold'**
  String get investmentUnitsSold;

  /// No description provided for @investmentUnitsShort.
  ///
  /// In en, this message translates to:
  /// **'{units} units'**
  String investmentUnitsShort(String units);

  /// No description provided for @investmentPerUnit.
  ///
  /// In en, this message translates to:
  /// **'{price} a unit'**
  String investmentPerUnit(String price);

  /// No description provided for @investmentNeedUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter how many units were bought.'**
  String get investmentNeedUnits;

  /// No description provided for @investmentSave.
  ///
  /// In en, this message translates to:
  /// **'Add investment'**
  String get investmentSave;

  /// No description provided for @investmentAdded.
  ///
  /// In en, this message translates to:
  /// **'Investment added'**
  String get investmentAdded;

  /// No description provided for @investmentGone.
  ///
  /// In en, this message translates to:
  /// **'This investment was deleted.'**
  String get investmentGone;

  /// No description provided for @netWorthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you own, less what you owe, and how it has moved'**
  String get netWorthSubtitle;

  /// No description provided for @netWorthToday.
  ///
  /// In en, this message translates to:
  /// **'You are worth'**
  String get netWorthToday;

  /// No description provided for @netWorthSinceLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} since last month'**
  String netWorthSinceLastMonth(String amount);

  /// No description provided for @netWorthBreakdown.
  ///
  /// In en, this message translates to:
  /// **'What it is made of'**
  String get netWorthBreakdown;

  /// No description provided for @netWorthCash.
  ///
  /// In en, this message translates to:
  /// **'Cash & bank'**
  String get netWorthCash;

  /// No description provided for @netWorthCards.
  ///
  /// In en, this message translates to:
  /// **'Credit cards'**
  String get netWorthCards;

  /// No description provided for @netWorthDeposits.
  ///
  /// In en, this message translates to:
  /// **'Savings deposits'**
  String get netWorthDeposits;

  /// No description provided for @netWorthAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get netWorthAssets;

  /// No description provided for @netWorthLent.
  ///
  /// In en, this message translates to:
  /// **'Lent to others'**
  String get netWorthLent;

  /// No description provided for @netWorthBorrowed.
  ///
  /// In en, this message translates to:
  /// **'Borrowed'**
  String get netWorthBorrowed;

  /// No description provided for @netWorthLoansNote.
  ///
  /// In en, this message translates to:
  /// **'Money you lent counts as yours until it is paid back, and money you borrowed counts against you until you repay it.'**
  String get netWorthLoansNote;

  /// No description provided for @netWorthCardsLeftOut.
  ///
  /// In en, this message translates to:
  /// **'Credit cards are not counted; you can change that in Settings.'**
  String get netWorthCardsLeftOut;

  /// No description provided for @netWorthHistory.
  ///
  /// In en, this message translates to:
  /// **'At each month end'**
  String get netWorthHistory;

  /// No description provided for @netWorthSixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get netWorthSixMonths;

  /// No description provided for @netWorthOneYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get netWorthOneYear;

  /// No description provided for @netWorthAllTime.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get netWorthAllTime;

  /// No description provided for @netWorthHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'The line starts once a month has ended with your records in it.'**
  String get netWorthHistoryEmpty;

  /// No description provided for @assetNew.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get assetNew;

  /// No description provided for @assetNewHint.
  ///
  /// In en, this message translates to:
  /// **'Land, a flat or house, a car, gold or anything else you own. Its value counts toward your net worth.'**
  String get assetNewHint;

  /// No description provided for @assetKind.
  ///
  /// In en, this message translates to:
  /// **'What it is'**
  String get assetKind;

  /// No description provided for @assetKindLand.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get assetKindLand;

  /// No description provided for @assetKindHome.
  ///
  /// In en, this message translates to:
  /// **'Flat or house'**
  String get assetKindHome;

  /// No description provided for @assetKindCar.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get assetKindCar;

  /// No description provided for @assetKindGold.
  ///
  /// In en, this message translates to:
  /// **'Gold & jewellery'**
  String get assetKindGold;

  /// No description provided for @assetKindOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get assetKindOther;

  /// No description provided for @assetNameHintLand.
  ///
  /// In en, this message translates to:
  /// **'e.g. Plot in Savar'**
  String get assetNameHintLand;

  /// No description provided for @assetNameHintHome.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flat in Mirpur'**
  String get assetNameHintHome;

  /// No description provided for @assetNameHintCar.
  ///
  /// In en, this message translates to:
  /// **'e.g. Toyota Axio'**
  String get assetNameHintCar;

  /// No description provided for @assetNameHintGold.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wedding jewellery'**
  String get assetNameHintGold;

  /// No description provided for @assetNameHintOther.
  ///
  /// In en, this message translates to:
  /// **'e.g. Camera'**
  String get assetNameHintOther;

  /// No description provided for @assetWorthNow.
  ///
  /// In en, this message translates to:
  /// **'Worth now'**
  String get assetWorthNow;

  /// No description provided for @assetBoughtNow.
  ///
  /// In en, this message translates to:
  /// **'Paid for it from an account'**
  String get assetBoughtNow;

  /// No description provided for @assetBoughtNowHint.
  ///
  /// In en, this message translates to:
  /// **'Off: you already own it, and no money moves.'**
  String get assetBoughtNowHint;

  /// No description provided for @assetSave.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get assetSave;

  /// No description provided for @assetAdded.
  ///
  /// In en, this message translates to:
  /// **'Asset added'**
  String get assetAdded;

  /// No description provided for @assetsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No assets yet'**
  String get assetsEmptyTitle;

  /// No description provided for @assetsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add land, a home, a car or gold to see everything you are worth.'**
  String get assetsEmptyBody;

  /// No description provided for @assetsSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get assetsSold;

  /// No description provided for @assetCostLine.
  ///
  /// In en, this message translates to:
  /// **'Cost {amount}'**
  String assetCostLine(String amount);

  /// No description provided for @assetUpdateValue.
  ///
  /// In en, this message translates to:
  /// **'Update value'**
  String get assetUpdateValue;

  /// No description provided for @assetSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get assetSell;

  /// No description provided for @assetDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get assetDelete;

  /// No description provided for @assetValueUpdated.
  ///
  /// In en, this message translates to:
  /// **'Value updated'**
  String get assetValueUpdated;

  /// No description provided for @assetSold.
  ///
  /// In en, this message translates to:
  /// **'Sold, and the money recorded'**
  String get assetSold;

  /// No description provided for @assetDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String assetDeleteTitle(String name);

  /// No description provided for @assetDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It is no longer counted. Its history stays with your records.'**
  String get assetDeleteBody;

  /// No description provided for @assetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Asset removed'**
  String get assetDeleted;

  /// No description provided for @aiActionCreateAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an asset'**
  String get aiActionCreateAssetTitle;

  /// No description provided for @aiActionUpdateAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'Update an asset\'s value'**
  String get aiActionUpdateAssetTitle;

  /// No description provided for @aiActionSellAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell an asset'**
  String get aiActionSellAssetTitle;

  /// No description provided for @investmentWorthNow.
  ///
  /// In en, this message translates to:
  /// **'Worth now'**
  String get investmentWorthNow;

  /// No description provided for @investmentGainLine.
  ///
  /// In en, this message translates to:
  /// **'{gain} overall'**
  String investmentGainLine(String gain);

  /// No description provided for @investmentPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get investmentPrice;

  /// No description provided for @investmentPutIn.
  ///
  /// In en, this message translates to:
  /// **'Put in'**
  String get investmentPutIn;

  /// No description provided for @investmentTakenOut.
  ///
  /// In en, this message translates to:
  /// **'Taken out'**
  String get investmentTakenOut;

  /// No description provided for @investmentBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get investmentBuy;

  /// No description provided for @investmentSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get investmentSell;

  /// No description provided for @investmentBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy {name}'**
  String investmentBuyTitle(String name);

  /// No description provided for @investmentSellTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell {name}'**
  String investmentSellTitle(String name);

  /// No description provided for @investmentDividendTitle.
  ///
  /// In en, this message translates to:
  /// **'Dividend from {name}'**
  String investmentDividendTitle(String name);

  /// No description provided for @investmentDividend.
  ///
  /// In en, this message translates to:
  /// **'Dividend'**
  String get investmentDividend;

  /// No description provided for @investmentRecordDividend.
  ///
  /// In en, this message translates to:
  /// **'Record a dividend'**
  String get investmentRecordDividend;

  /// No description provided for @investmentHeldNow.
  ///
  /// In en, this message translates to:
  /// **'{units} units held now.'**
  String investmentHeldNow(String units);

  /// No description provided for @investmentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get investmentRecorded;

  /// No description provided for @investmentUpdatePrice.
  ///
  /// In en, this message translates to:
  /// **'Update the price'**
  String get investmentUpdatePrice;

  /// No description provided for @investmentUpdatePriceHint.
  ///
  /// In en, this message translates to:
  /// **'Today\'s NAV or share price, for one unit'**
  String get investmentUpdatePriceHint;

  /// No description provided for @investmentPriceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Price updated'**
  String get investmentPriceUpdated;

  /// No description provided for @investmentStartSip.
  ///
  /// In en, this message translates to:
  /// **'Start a SIP'**
  String get investmentStartSip;

  /// No description provided for @investmentStartSipHint.
  ///
  /// In en, this message translates to:
  /// **'Buy a fixed amount every month, by itself'**
  String get investmentStartSipHint;

  /// No description provided for @investmentHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get investmentHistory;

  /// No description provided for @investmentBought.
  ///
  /// In en, this message translates to:
  /// **'Bought {units} units'**
  String investmentBought(String units);

  /// No description provided for @investmentSold.
  ///
  /// In en, this message translates to:
  /// **'Sold {units} units'**
  String investmentSold(String units);

  /// No description provided for @investmentPriceRose.
  ///
  /// In en, this message translates to:
  /// **'Price went up'**
  String get investmentPriceRose;

  /// No description provided for @investmentPriceFell.
  ///
  /// In en, this message translates to:
  /// **'Price went down'**
  String get investmentPriceFell;

  /// No description provided for @investmentUnitsUnknown.
  ///
  /// In en, this message translates to:
  /// **'units not known yet, tap to add'**
  String get investmentUnitsUnknown;

  /// No description provided for @investmentCorrectUnits.
  ///
  /// In en, this message translates to:
  /// **'Units on this trade'**
  String get investmentCorrectUnits;

  /// No description provided for @investmentCorrectUnitsHint.
  ///
  /// In en, this message translates to:
  /// **'As your fund or broker statement shows them.'**
  String get investmentCorrectUnitsHint;

  /// No description provided for @investmentUnitsCorrected.
  ///
  /// In en, this message translates to:
  /// **'Units corrected'**
  String get investmentUnitsCorrected;

  /// No description provided for @investmentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this investment'**
  String get investmentDelete;

  /// No description provided for @investmentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String investmentDeleteTitle(String name);

  /// No description provided for @investmentDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Its trades stay in your history. Only possible once everything is sold.'**
  String get investmentDeleteBody;

  /// No description provided for @investmentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Investment deleted'**
  String get investmentDeleted;

  /// No description provided for @plansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'EMIs, loans, DPS, FDR, insurance, bonds and SIPs, paid and collected on time'**
  String get plansSubtitle;

  /// No description provided for @planNew.
  ///
  /// In en, this message translates to:
  /// **'Start a plan'**
  String get planNew;

  /// No description provided for @planNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you starting?'**
  String get planNewTitle;

  /// No description provided for @plansEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No EMIs, loans or savings yet'**
  String get plansEmptyTitle;

  /// No description provided for @plansEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Track something bought in installments, a loan, a DPS or an FDR. Installments are recorded on their day and you are reminded before each.'**
  String get plansEmptyBody;

  /// No description provided for @plansEnded.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get plansEnded;

  /// No description provided for @planKindEmi.
  ///
  /// In en, this message translates to:
  /// **'EMI'**
  String get planKindEmi;

  /// No description provided for @planKindLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get planKindLoan;

  /// No description provided for @planKindDps.
  ///
  /// In en, this message translates to:
  /// **'DPS'**
  String get planKindDps;

  /// No description provided for @planKindFdr.
  ///
  /// In en, this message translates to:
  /// **'FDR'**
  String get planKindFdr;

  /// No description provided for @planKindInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get planKindInsurance;

  /// No description provided for @planKindBond.
  ///
  /// In en, this message translates to:
  /// **'Bond or certificate'**
  String get planKindBond;

  /// No description provided for @planKindSip.
  ///
  /// In en, this message translates to:
  /// **'SIP'**
  String get planKindSip;

  /// No description provided for @planKindEmiHint.
  ///
  /// In en, this message translates to:
  /// **'Something bought in installments, paid from cash, a bank account or a card'**
  String get planKindEmiHint;

  /// No description provided for @planKindLoanHint.
  ///
  /// In en, this message translates to:
  /// **'Money borrowed and paid back in installments, with interest'**
  String get planKindLoanHint;

  /// No description provided for @planKindDpsHint.
  ///
  /// In en, this message translates to:
  /// **'Save a fixed amount every month for a fixed time, and get it back with profit'**
  String get planKindDpsHint;

  /// No description provided for @planKindFdrHint.
  ///
  /// In en, this message translates to:
  /// **'Put a sum away at a bank for a fixed time, with profit monthly, every three months or at the end'**
  String get planKindFdrHint;

  /// No description provided for @planKindInsuranceHint.
  ///
  /// In en, this message translates to:
  /// **'A policy with a premium every month, quarter or year, and a payout at the end if it has one'**
  String get planKindInsuranceHint;

  /// No description provided for @planKindBondHint.
  ///
  /// In en, this message translates to:
  /// **'A bond or savings certificate: one sum held for years, with profit monthly, every three months or at the end, after tax'**
  String get planKindBondHint;

  /// No description provided for @planKindSipHint.
  ///
  /// In en, this message translates to:
  /// **'A fixed sum into a fund or shares every month, bought at the latest price'**
  String get planKindSipHint;

  /// No description provided for @planWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get planWeekly;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get planQuarterly;

  /// No description provided for @planHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Half-yearly'**
  String get planHalfYearly;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// No description provided for @planMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get planMonths;

  /// No description provided for @planYears.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get planYears;

  /// No description provided for @planFdrLine.
  ///
  /// In en, this message translates to:
  /// **'{amount} until {date}'**
  String planFdrLine(String amount, String date);

  /// No description provided for @planSavedLine.
  ///
  /// In en, this message translates to:
  /// **'{saved} of {total} saved'**
  String planSavedLine(String saved, String total);

  /// No description provided for @planPaidLine.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {total} paid'**
  String planPaidLine(String paid, String total);

  /// No description provided for @planNextLine.
  ///
  /// In en, this message translates to:
  /// **'Next: {amount} on {date}'**
  String planNextLine(String amount, String date);

  /// No description provided for @planStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get planStatusCompleted;

  /// No description provided for @planStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get planStatusClosed;

  /// No description provided for @planStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get planStatusOverdue;

  /// No description provided for @planStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get planStatusRunning;

  /// No description provided for @planInstallmentsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String planInstallmentsDone(int done, int total);

  /// No description provided for @planGone.
  ///
  /// In en, this message translates to:
  /// **'This plan has been deleted.'**
  String get planGone;

  /// No description provided for @planAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get planAccount;

  /// No description provided for @planAccountEmi.
  ///
  /// In en, this message translates to:
  /// **'Paid from'**
  String get planAccountEmi;

  /// No description provided for @planAccountLoan.
  ///
  /// In en, this message translates to:
  /// **'Received into and paid from'**
  String get planAccountLoan;

  /// No description provided for @planAccountSaving.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get planAccountSaving;

  /// No description provided for @planPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get planPrice;

  /// No description provided for @planBorrowed.
  ///
  /// In en, this message translates to:
  /// **'Amount borrowed'**
  String get planBorrowed;

  /// No description provided for @planDeposited.
  ///
  /// In en, this message translates to:
  /// **'Amount deposited'**
  String get planDeposited;

  /// No description provided for @planDeposit.
  ///
  /// In en, this message translates to:
  /// **'Each deposit'**
  String get planDeposit;

  /// No description provided for @planInstallment.
  ///
  /// In en, this message translates to:
  /// **'Each installment'**
  String get planInstallment;

  /// No description provided for @planWorkedOut.
  ///
  /// In en, this message translates to:
  /// **'Worked out from the price, rate and term'**
  String get planWorkedOut;

  /// No description provided for @planProgress.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get planProgress;

  /// No description provided for @planSavedSoFar.
  ///
  /// In en, this message translates to:
  /// **'Saved so far'**
  String get planSavedSoFar;

  /// No description provided for @planPaidSoFar.
  ///
  /// In en, this message translates to:
  /// **'Paid so far'**
  String get planPaidSoFar;

  /// No description provided for @planLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get planLeft;

  /// No description provided for @planTotal.
  ///
  /// In en, this message translates to:
  /// **'In all'**
  String get planTotal;

  /// No description provided for @planInterestCharges.
  ///
  /// In en, this message translates to:
  /// **'Interest and charges'**
  String get planInterestCharges;

  /// No description provided for @planRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get planRate;

  /// No description provided for @planRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate % a year'**
  String get planRateLabel;

  /// No description provided for @planRateOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get planRateOptional;

  /// No description provided for @planPayout.
  ///
  /// In en, this message translates to:
  /// **'Profit paid'**
  String get planPayout;

  /// No description provided for @planPayoutMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get planPayoutMonthly;

  /// No description provided for @planPayoutQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Every 3 months'**
  String get planPayoutQuarterly;

  /// No description provided for @planPayoutAtMaturity.
  ///
  /// In en, this message translates to:
  /// **'At the end'**
  String get planPayoutAtMaturity;

  /// No description provided for @planMaturesOn.
  ///
  /// In en, this message translates to:
  /// **'Matures on'**
  String get planMaturesOn;

  /// No description provided for @planMaturity.
  ///
  /// In en, this message translates to:
  /// **'Paid back at the end'**
  String get planMaturity;

  /// No description provided for @planEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated from the rate; tap to enter the bank\'s figure'**
  String get planEstimated;

  /// No description provided for @planHolding.
  ///
  /// In en, this message translates to:
  /// **'In the deposit now'**
  String get planHolding;

  /// No description provided for @planEnds.
  ///
  /// In en, this message translates to:
  /// **'Last installment'**
  String get planEnds;

  /// No description provided for @planTakeMaturity.
  ///
  /// In en, this message translates to:
  /// **'Take the maturity, {amount}'**
  String planTakeMaturity(String amount);

  /// No description provided for @planRecordProfit.
  ///
  /// In en, this message translates to:
  /// **'Record the profit, {amount}'**
  String planRecordProfit(String amount);

  /// No description provided for @planPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay installment {number} now, {amount}'**
  String planPayNow(int number, String amount);

  /// No description provided for @planPayPremiumNow.
  ///
  /// In en, this message translates to:
  /// **'Pay premium {number} now, {amount}'**
  String planPayPremiumNow(int number, String amount);

  /// No description provided for @planDepositNow.
  ///
  /// In en, this message translates to:
  /// **'Make deposit {number} now, {amount}'**
  String planDepositNow(int number, String amount);

  /// No description provided for @planRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded.'**
  String get planRecorded;

  /// No description provided for @planSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get planSaved;

  /// No description provided for @planPayOff.
  ///
  /// In en, this message translates to:
  /// **'Pay off early'**
  String get planPayOff;

  /// No description provided for @planEncash.
  ///
  /// In en, this message translates to:
  /// **'Encash early'**
  String get planEncash;

  /// No description provided for @planSurrender.
  ///
  /// In en, this message translates to:
  /// **'Surrender the policy'**
  String get planSurrender;

  /// No description provided for @planSurrenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Surrender {name}?'**
  String planSurrenderTitle(String name);

  /// No description provided for @planSurrenderBody.
  ///
  /// In en, this message translates to:
  /// **'Premiums stop. Whatever the insurer pays back is recorded as income.'**
  String get planSurrenderBody;

  /// No description provided for @planSurrenderNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing paid back'**
  String get planSurrenderNothing;

  /// No description provided for @planSurrenderValue.
  ///
  /// In en, this message translates to:
  /// **'Enter the surrender value'**
  String get planSurrenderValue;

  /// No description provided for @planSurrenderValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Surrender value'**
  String get planSurrenderValueLabel;

  /// No description provided for @planStopSip.
  ///
  /// In en, this message translates to:
  /// **'Stop the SIP'**
  String get planStopSip;

  /// No description provided for @planStopSipTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop {name}?'**
  String planStopSipTitle(String name);

  /// No description provided for @planStopSipBody.
  ///
  /// In en, this message translates to:
  /// **'No more buys. What it bought stays in the investment.'**
  String get planStopSipBody;

  /// No description provided for @planSipStopped.
  ///
  /// In en, this message translates to:
  /// **'SIP stopped'**
  String get planSipStopped;

  /// No description provided for @planSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get planSave;

  /// No description provided for @planSurrendered.
  ///
  /// In en, this message translates to:
  /// **'Policy surrendered'**
  String get planSurrendered;

  /// No description provided for @planPayOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay off {name}?'**
  String planPayOffTitle(String name);

  /// No description provided for @planPayOffHint.
  ///
  /// In en, this message translates to:
  /// **'One payment for what is left, and the plan ends.'**
  String get planPayOffHint;

  /// No description provided for @planPayOffLeft.
  ///
  /// In en, this message translates to:
  /// **'Pay what is left, {amount}'**
  String planPayOffLeft(String amount);

  /// No description provided for @planPayOffOther.
  ///
  /// In en, this message translates to:
  /// **'The lender quoted a different amount'**
  String get planPayOffOther;

  /// No description provided for @planEncashTitle.
  ///
  /// In en, this message translates to:
  /// **'Encash {name}?'**
  String planEncashTitle(String name);

  /// No description provided for @planEncashBody.
  ///
  /// In en, this message translates to:
  /// **'What is in the deposit goes back to its account, and the plan ends.'**
  String get planEncashBody;

  /// No description provided for @planEncashNoProfit.
  ///
  /// In en, this message translates to:
  /// **'Encash, without profit'**
  String get planEncashNoProfit;

  /// No description provided for @planEncashWithProfit.
  ///
  /// In en, this message translates to:
  /// **'Encash, with the profit the bank paid'**
  String get planEncashWithProfit;

  /// No description provided for @planEncashed.
  ///
  /// In en, this message translates to:
  /// **'Encashed. The money is back in its account.'**
  String get planEncashed;

  /// No description provided for @planPaidOff.
  ///
  /// In en, this message translates to:
  /// **'Paid off.'**
  String get planPaidOff;

  /// No description provided for @planAutoCollect.
  ///
  /// In en, this message translates to:
  /// **'Record by itself'**
  String get planAutoCollect;

  /// No description provided for @planAutoCollectHint.
  ///
  /// In en, this message translates to:
  /// **'Each installment, profit and maturity is recorded on its day'**
  String get planAutoCollectHint;

  /// No description provided for @planSchedule.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE'**
  String get planSchedule;

  /// No description provided for @planDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this plan'**
  String get planDelete;

  /// No description provided for @planDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String planDeleteTitle(String name);

  /// No description provided for @planDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'What it recorded stays in your transactions. Nothing more is recorded or reminded.'**
  String get planDeleteBody;

  /// No description provided for @planDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted.'**
  String get planDeleted;

  /// No description provided for @planEventInstallment.
  ///
  /// In en, this message translates to:
  /// **'Installment {number} of {total}'**
  String planEventInstallment(int number, int total);

  /// No description provided for @planEventPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium {number} of {total}'**
  String planEventPremium(int number, int total);

  /// No description provided for @planEventPayout.
  ///
  /// In en, this message translates to:
  /// **'Policy pays out'**
  String get planEventPayout;

  /// No description provided for @planEventProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit, month {number}'**
  String planEventProfit(int number);

  /// No description provided for @planEventMaturity.
  ///
  /// In en, this message translates to:
  /// **'Maturity'**
  String get planEventMaturity;

  /// No description provided for @planEventDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get planEventDone;

  /// No description provided for @planEventLate.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get planEventLate;

  /// No description provided for @planEventUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get planEventUpcoming;

  /// No description provided for @planNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose an account first.'**
  String get planNeedAccount;

  /// No description provided for @planCreated.
  ///
  /// In en, this message translates to:
  /// **'Started. Anything already due has been recorded.'**
  String get planCreated;

  /// No description provided for @planSummaryInstallments.
  ///
  /// In en, this message translates to:
  /// **'{count} × {installment} = {total}, of which {interest} is interest and charges.'**
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  );

  /// No description provided for @planSummaryNoInterest.
  ///
  /// In en, this message translates to:
  /// **'{count} × {installment} = {total}, with no interest.'**
  String planSummaryNoInterest(int count, String installment, String total);

  /// No description provided for @planSummaryDps.
  ///
  /// In en, this message translates to:
  /// **'You put in {deposited} and get back about {maturity} on {date}.'**
  String planSummaryDps(String deposited, String maturity, String date);

  /// No description provided for @planSummaryFdr.
  ///
  /// In en, this message translates to:
  /// **'{principal} grows to about {maturity} by {date}.'**
  String planSummaryFdr(String principal, String maturity, String date);

  /// No description provided for @planSummaryFdrMonthly.
  ///
  /// In en, this message translates to:
  /// **'{profit} profit every month, and {principal} back on {date}.'**
  String planSummaryFdrMonthly(String profit, String principal, String date);

  /// No description provided for @planSummaryInsurance.
  ///
  /// In en, this message translates to:
  /// **'{count} premiums of {premium}, {total} in all.'**
  String planSummaryInsurance(int count, String premium, String total);

  /// No description provided for @planSummaryInsurancePayout.
  ///
  /// In en, this message translates to:
  /// **'{count} premiums of {premium}, {total} in all, and {payout} back on {date}.'**
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  );

  /// No description provided for @planSummaryQuarterly.
  ///
  /// In en, this message translates to:
  /// **'{profit} profit every three months, and {principal} back on {date}.'**
  String planSummaryQuarterly(String profit, String principal, String date);

  /// No description provided for @planSummarySip.
  ///
  /// In en, this message translates to:
  /// **'{count} × {amount} into {fund}, {total} in all.'**
  String planSummarySip(int count, String amount, String total, String fund);

  /// No description provided for @planNewKind.
  ///
  /// In en, this message translates to:
  /// **'New {kind}'**
  String planNewKind(String kind);

  /// No description provided for @planName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get planName;

  /// No description provided for @planNameHintEmi.
  ///
  /// In en, this message translates to:
  /// **'e.g. Phone from Daraz'**
  String get planNameHintEmi;

  /// No description provided for @planNameHintLoan.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bike loan'**
  String get planNameHintLoan;

  /// No description provided for @planNameHintDps.
  ///
  /// In en, this message translates to:
  /// **'e.g. Brac DPS'**
  String get planNameHintDps;

  /// No description provided for @planNameHintFdr.
  ///
  /// In en, this message translates to:
  /// **'e.g. City Bank FDR'**
  String get planNameHintFdr;

  /// No description provided for @planNameHintInsurance.
  ///
  /// In en, this message translates to:
  /// **'e.g. Life policy'**
  String get planNameHintInsurance;

  /// No description provided for @planNameHintBond.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5-year Sanchayapatra'**
  String get planNameHintBond;

  /// No description provided for @planNameHintSip.
  ///
  /// In en, this message translates to:
  /// **'e.g. Monthly fund SIP'**
  String get planNameHintSip;

  /// No description provided for @planSipFund.
  ///
  /// In en, this message translates to:
  /// **'Buys'**
  String get planSipFund;

  /// No description provided for @planSipAmount.
  ///
  /// In en, this message translates to:
  /// **'Each SIP'**
  String get planSipAmount;

  /// No description provided for @planSipNoFund.
  ///
  /// In en, this message translates to:
  /// **'Add the fund or shares in Investments first.'**
  String get planSipNoFund;

  /// No description provided for @planProvider.
  ///
  /// In en, this message translates to:
  /// **'Bank or company'**
  String get planProvider;

  /// No description provided for @planReference.
  ///
  /// In en, this message translates to:
  /// **'Policy or account no.'**
  String get planReference;

  /// No description provided for @planSumAssured.
  ///
  /// In en, this message translates to:
  /// **'Sum assured'**
  String get planSumAssured;

  /// No description provided for @planPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get planPremium;

  /// No description provided for @planPremiums.
  ///
  /// In en, this message translates to:
  /// **'Premiums'**
  String get planPremiums;

  /// No description provided for @planTaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax at source %'**
  String get planTaxLabel;

  /// No description provided for @planTax.
  ///
  /// In en, this message translates to:
  /// **'Tax at source'**
  String get planTax;

  /// No description provided for @planFirstPremium.
  ///
  /// In en, this message translates to:
  /// **'First premium'**
  String get planFirstPremium;

  /// No description provided for @planLastPremium.
  ///
  /// In en, this message translates to:
  /// **'Last premium'**
  String get planLastPremium;

  /// No description provided for @planInsurancePayout.
  ///
  /// In en, this message translates to:
  /// **'Paid back at the end'**
  String get planInsurancePayout;

  /// No description provided for @planNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get planNone;

  /// No description provided for @planHowMany.
  ///
  /// In en, this message translates to:
  /// **'How many'**
  String get planHowMany;

  /// No description provided for @planTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get planTerm;

  /// No description provided for @planOpenedOn.
  ///
  /// In en, this message translates to:
  /// **'Opened on'**
  String get planOpenedOn;

  /// No description provided for @planFirstDue.
  ///
  /// In en, this message translates to:
  /// **'First installment'**
  String get planFirstDue;

  /// No description provided for @planCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get planCategory;

  /// No description provided for @planCategoryDefault.
  ///
  /// In en, this message translates to:
  /// **'Loan Payment'**
  String get planCategoryDefault;

  /// No description provided for @planCategoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get planCategoryInsurance;

  /// No description provided for @planLoanReceived.
  ///
  /// In en, this message translates to:
  /// **'Money received into this account'**
  String get planLoanReceived;

  /// No description provided for @planLoanReceivedHint.
  ///
  /// In en, this message translates to:
  /// **'Off if it went straight to a seller'**
  String get planLoanReceivedHint;

  /// No description provided for @planStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get planStart;

  /// No description provided for @aiActionDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'It goes to Recently deleted, where you can restore it for 30 days.'**
  String get aiActionDeleteNote;

  /// No description provided for @aiActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add it'**
  String get aiActionAdd;

  /// No description provided for @aiActionSave.
  ///
  /// In en, this message translates to:
  /// **'Save change'**
  String get aiActionSave;

  /// No description provided for @aiActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete it'**
  String get aiActionDelete;

  /// No description provided for @aiActionCancel.
  ///
  /// In en, this message translates to:
  /// **'No, leave it'**
  String get aiActionCancel;

  /// No description provided for @aiActionAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get aiActionAmount;

  /// No description provided for @aiActionKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get aiActionKind;

  /// No description provided for @aiActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get aiActionTitle;

  /// No description provided for @aiActionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get aiActionCategory;

  /// No description provided for @aiActionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get aiActionAccount;

  /// No description provided for @aiActionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get aiActionDate;

  /// No description provided for @aiActionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get aiActionNotes;

  /// No description provided for @aiReport.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get aiReport;

  /// No description provided for @aiReportWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'The coach got something wrong'**
  String get aiReportWrongAnswer;

  /// No description provided for @aiReportWrongAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'A wrong number, a made-up fact, or a change you did not ask for'**
  String get aiReportWrongAnswerHint;

  /// No description provided for @aiReportWrongAnswerSubject.
  ///
  /// In en, this message translates to:
  /// **'Money coach: wrong answer'**
  String get aiReportWrongAnswerSubject;

  /// No description provided for @aiReportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get aiReportBug;

  /// No description provided for @aiReportBugHint.
  ///
  /// In en, this message translates to:
  /// **'Something broke, froze or did not load'**
  String get aiReportBugHint;

  /// No description provided for @aiReportBugSubject.
  ///
  /// In en, this message translates to:
  /// **'Money coach: bug report'**
  String get aiReportBugSubject;

  /// No description provided for @aiAboutCoach.
  ///
  /// In en, this message translates to:
  /// **'How the coach works'**
  String get aiAboutCoach;

  /// No description provided for @aiDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you ask the coach'**
  String get aiDisclaimerTitle;

  /// No description provided for @aiDisclaimerMistakes.
  ///
  /// In en, this message translates to:
  /// **'The coach is an AI. It can get a number wrong, misread a question or state something that is not true, so check anything important against your own transactions.'**
  String get aiDisclaimerMistakes;

  /// No description provided for @aiDisclaimerData.
  ///
  /// In en, this message translates to:
  /// **'Your figures are read on your phone. To answer, the app sends your question and the figures it needs to our server and its AI model.'**
  String get aiDisclaimerData;

  /// No description provided for @aiDisclaimerChanges.
  ///
  /// In en, this message translates to:
  /// **'It never changes your money on its own. Every add, edit or delete is shown to you first and only happens if you confirm it.'**
  String get aiDisclaimerChanges;

  /// No description provided for @aiDisclaimerReport.
  ///
  /// In en, this message translates to:
  /// **'If an answer looks wrong, tap the flag at the top to tell us.'**
  String get aiDisclaimerReport;

  /// No description provided for @aiDisclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get aiDisclaimerAccept;

  /// No description provided for @aiOutOfRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used this month\'s free requests'**
  String get aiOutOfRequestsTitle;

  /// No description provided for @aiOutOfRequestsBody.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to ask this one, or go Premium for unlimited answers with no ads. Free requests come back on the 1st.'**
  String get aiOutOfRequestsBody;

  /// No description provided for @ocrNoCamera.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera.'**
  String get ocrNoCamera;

  /// No description provided for @ocrNoGallery.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the gallery.'**
  String get ocrNoGallery;

  /// No description provided for @ocrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get ocrScanTitle;

  /// No description provided for @ocrScanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan another'**
  String get ocrScanAnother;

  /// No description provided for @ocrScanBody.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo or pick one. The app reads it and the AI fills in the details.'**
  String get ocrScanBody;

  /// No description provided for @ocrReadingWithAi.
  ///
  /// In en, this message translates to:
  /// **'The AI is reading your receipt…'**
  String get ocrReadingWithAi;

  /// No description provided for @ocrNothingRead.
  ///
  /// In en, this message translates to:
  /// **'No text could be read from that photo. Try again in better light, with the whole receipt in view.'**
  String get ocrNothingRead;

  /// No description provided for @ocrAiOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Let the AI read it properly'**
  String get ocrAiOfferTitle;

  /// No description provided for @ocrAiOfferBody.
  ///
  /// In en, this message translates to:
  /// **'It finds the real total, the date, each item and the right category, even on a messy receipt.'**
  String get ocrAiOfferBody;

  /// No description provided for @ocrReadWithAi.
  ///
  /// In en, this message translates to:
  /// **'Read with AI'**
  String get ocrReadWithAi;

  /// No description provided for @ocrReadByAi.
  ///
  /// In en, this message translates to:
  /// **'Read by AI. Check it before saving.'**
  String get ocrReadByAi;

  /// No description provided for @ocrItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get ocrItems;

  /// No description provided for @quickAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe it'**
  String get quickAddTitle;

  /// No description provided for @quickAddSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type it the way you\'d say it. The AI fills in the form for you to check.'**
  String get quickAddSubtitle;

  /// No description provided for @quickAddHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. lunch 250 yesterday from bKash'**
  String get quickAddHint;

  /// No description provided for @quickAddFill.
  ///
  /// In en, this message translates to:
  /// **'Fill it in'**
  String get quickAddFill;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get summaryTitle;

  /// No description provided for @summarySpent.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get summarySpent;

  /// No description provided for @summaryEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned {amount}'**
  String summaryEarned(String amount);

  /// No description provided for @summaryLessThanLast.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than last month'**
  String summaryLessThanLast(int percent);

  /// No description provided for @summaryMoreThanLast.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than last month'**
  String summaryMoreThanLast(int percent);

  /// No description provided for @summaryAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Your month, in a nutshell'**
  String get summaryAiTitle;

  /// No description provided for @summaryAiBody.
  ///
  /// In en, this message translates to:
  /// **'The AI reads your month against last month and picks out what stood out, with one thing to try.'**
  String get summaryAiBody;

  /// No description provided for @summaryWrite.
  ///
  /// In en, this message translates to:
  /// **'Write my summary'**
  String get summaryWrite;

  /// No description provided for @summaryWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing your summary…'**
  String get summaryWriting;

  /// No description provided for @summaryByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get summaryByCategory;

  /// No description provided for @summaryNoSpending.
  ///
  /// In en, this message translates to:
  /// **'No spending recorded this month yet.'**
  String get summaryNoSpending;

  /// No description provided for @themeTrialUntil.
  ///
  /// In en, this message translates to:
  /// **'Premium themes unlocked until {time}'**
  String themeTrialUntil(String time);

  /// No description provided for @zakatTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakatTitle;

  /// No description provided for @zakatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Work out what is due on your wealth, and record what you pay'**
  String get zakatSubtitle;

  /// No description provided for @zakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat due'**
  String get zakatDue;

  /// No description provided for @zakatAboveNisab.
  ///
  /// In en, this message translates to:
  /// **'Above the nisab: 2.5% of {amount} net wealth'**
  String zakatAboveNisab(String amount);

  /// No description provided for @zakatBelowNisab.
  ///
  /// In en, this message translates to:
  /// **'Below the nisab by {amount}, so no zakat is due'**
  String zakatBelowNisab(String amount);

  /// No description provided for @zakatNeedPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter the price per gram to check the nisab'**
  String get zakatNeedPrice;

  /// No description provided for @zakatPaidSoFar.
  ///
  /// In en, this message translates to:
  /// **'Paid this year'**
  String get zakatPaidSoFar;

  /// No description provided for @zakatLeftToPay.
  ///
  /// In en, this message translates to:
  /// **'Left to pay'**
  String get zakatLeftToPay;

  /// No description provided for @zakatNextDate.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Your zakat date is today} =1{Zakat date tomorrow, {date}} other{Zakat date {date}, in {days} days}}'**
  String zakatNextDate(int days, String date);

  /// No description provided for @zakatNoDate.
  ///
  /// In en, this message translates to:
  /// **'Set your zakat date to track the year and get a reminder'**
  String get zakatNoDate;

  /// No description provided for @zakatPay.
  ///
  /// In en, this message translates to:
  /// **'Pay zakat'**
  String get zakatPay;

  /// No description provided for @zakatNisab.
  ///
  /// In en, this message translates to:
  /// **'Nisab'**
  String get zakatNisab;

  /// No description provided for @zakatBasisGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get zakatBasisGold;

  /// No description provided for @zakatBasisSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get zakatBasisSilver;

  /// No description provided for @zakatBasisHint.
  ///
  /// In en, this message translates to:
  /// **'Silver gives the lower nisab and is the more cautious choice when your wealth is mostly cash. Enter today\'s local price for one gram.'**
  String get zakatBasisHint;

  /// No description provided for @zakatPricePerGram.
  ///
  /// In en, this message translates to:
  /// **'Price per gram ({metal})'**
  String zakatPricePerGram(String metal);

  /// No description provided for @zakatNisabWeight.
  ///
  /// In en, this message translates to:
  /// **'{grams} g at that price'**
  String zakatNisabWeight(String grams);

  /// No description provided for @zakatGroupCash.
  ///
  /// In en, this message translates to:
  /// **'Cash and bank'**
  String get zakatGroupCash;

  /// No description provided for @zakatGroupDeposits.
  ///
  /// In en, this message translates to:
  /// **'Savings deposits'**
  String get zakatGroupDeposits;

  /// No description provided for @zakatGroupInvestments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get zakatGroupInvestments;

  /// No description provided for @zakatGroupMetals.
  ///
  /// In en, this message translates to:
  /// **'Gold and silver'**
  String get zakatGroupMetals;

  /// No description provided for @zakatGroupLent.
  ///
  /// In en, this message translates to:
  /// **'Money lent to others'**
  String get zakatGroupLent;

  /// No description provided for @zakatGroupOtherAssets.
  ///
  /// In en, this message translates to:
  /// **'Other assets'**
  String get zakatGroupOtherAssets;

  /// No description provided for @zakatGroupPaid.
  ///
  /// In en, this message translates to:
  /// **'Zakat paid this year'**
  String get zakatGroupPaid;

  /// No description provided for @zakatGroupManual.
  ///
  /// In en, this message translates to:
  /// **'Added by you'**
  String get zakatGroupManual;

  /// No description provided for @zakatGroupBorrowed.
  ///
  /// In en, this message translates to:
  /// **'Less: money you owe'**
  String get zakatGroupBorrowed;

  /// No description provided for @zakatGroupCards.
  ///
  /// In en, this message translates to:
  /// **'Less: credit card dues'**
  String get zakatGroupCards;

  /// No description provided for @zakatOtherAssetsNote.
  ///
  /// In en, this message translates to:
  /// **'Land, a home or a car you use is not zakatable. Switch one on only if you hold it for trade.'**
  String get zakatOtherAssetsNote;

  /// No description provided for @zakatPaidNote.
  ///
  /// In en, this message translates to:
  /// **'Added back, because it left your accounts after the year\'s wealth was counted.'**
  String get zakatPaidNote;

  /// No description provided for @zakatNoMetals.
  ///
  /// In en, this message translates to:
  /// **'No gold or silver is recorded. Add it as an asset, or add its value below.'**
  String get zakatNoMetals;

  /// No description provided for @zakatAddAmount.
  ///
  /// In en, this message translates to:
  /// **'Add an amount'**
  String get zakatAddAmount;

  /// No description provided for @zakatAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get zakatAmountLabel;

  /// No description provided for @zakatAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Business stock, cash at home…'**
  String get zakatAmountHint;

  /// No description provided for @zakatAmountDeduct.
  ///
  /// In en, this message translates to:
  /// **'It is a debt due now'**
  String get zakatAmountDeduct;

  /// No description provided for @zakatWealth.
  ///
  /// In en, this message translates to:
  /// **'Zakatable wealth'**
  String get zakatWealth;

  /// No description provided for @zakatDeductions.
  ///
  /// In en, this message translates to:
  /// **'Debts due now'**
  String get zakatDeductions;

  /// No description provided for @zakatNet.
  ///
  /// In en, this message translates to:
  /// **'Net wealth'**
  String get zakatNet;

  /// No description provided for @zakatRate.
  ///
  /// In en, this message translates to:
  /// **'2.5% of net wealth'**
  String get zakatRate;

  /// No description provided for @zakatYear.
  ///
  /// In en, this message translates to:
  /// **'Zakat year'**
  String get zakatYear;

  /// No description provided for @zakatDate.
  ///
  /// In en, this message translates to:
  /// **'Zakat date'**
  String get zakatDate;

  /// No description provided for @zakatDateHint.
  ///
  /// In en, this message translates to:
  /// **'The day your zakat year completes. It comes round every lunar year, 354 days.'**
  String get zakatDateHint;

  /// No description provided for @zakatRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get zakatRemind;

  /// No description provided for @zakatRemindHint.
  ///
  /// In en, this message translates to:
  /// **'3 days before, and on the day'**
  String get zakatRemindHint;

  /// No description provided for @zakatDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a guide to help you work zakat out, not a religious ruling. Scholars differ on some details; when unsure, ask a local scholar.'**
  String get zakatDisclaimer;

  /// No description provided for @zakatPayNote.
  ///
  /// In en, this message translates to:
  /// **'Recorded as an expense under Zakat, and counted toward this year.'**
  String get zakatPayNote;

  /// No description provided for @zakatPayRecord.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get zakatPayRecord;

  /// No description provided for @zakatPaidSnack.
  ///
  /// In en, this message translates to:
  /// **'Zakat recorded'**
  String get zakatPaidSnack;

  /// No description provided for @aiToolZakat.
  ///
  /// In en, this message translates to:
  /// **'Working out zakat…'**
  String get aiToolZakat;

  /// No description provided for @voiceButton.
  ///
  /// In en, this message translates to:
  /// **'Say a transaction'**
  String get voiceButton;

  /// No description provided for @voiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Say it'**
  String get voiceTitle;

  /// No description provided for @voiceUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get voiceUnlimited;

  /// No description provided for @voiceTapToTalk.
  ///
  /// In en, this message translates to:
  /// **'Tap the orb and say what you spent'**
  String get voiceTapToTalk;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get voiceListening;

  /// No description provided for @voiceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop listening'**
  String get voiceStop;

  /// No description provided for @voiceTypeInstead.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get voiceTypeInstead;

  /// No description provided for @voiceSpeakInstead.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get voiceSpeakInstead;

  /// No description provided for @voiceSend.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get voiceSend;

  /// No description provided for @voiceTrySaying.
  ///
  /// In en, this message translates to:
  /// **'Try saying'**
  String get voiceTrySaying;

  /// No description provided for @voiceExample1.
  ///
  /// In en, this message translates to:
  /// **'Lunch 250, rickshaw 60'**
  String get voiceExample1;

  /// No description provided for @voiceExample2.
  ///
  /// In en, this message translates to:
  /// **'Got my salary, 45,000'**
  String get voiceExample2;

  /// No description provided for @voiceExample3.
  ///
  /// In en, this message translates to:
  /// **'Yesterday\'s tea was 30, not 20'**
  String get voiceExample3;

  /// No description provided for @voiceExample4.
  ///
  /// In en, this message translates to:
  /// **'Delete today\'s lunch'**
  String get voiceExample4;

  /// No description provided for @voiceTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Lunch 250 and rickshaw 60 from bKash'**
  String get voiceTypeHint;

  /// No description provided for @voiceThinking.
  ///
  /// In en, this message translates to:
  /// **'Working it out…'**
  String get voiceThinking;

  /// No description provided for @voiceTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get voiceTryAgain;

  /// No description provided for @voiceSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get voiceSaving;

  /// No description provided for @voiceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get voiceEdit;

  /// No description provided for @voiceNeedsYou.
  ///
  /// In en, this message translates to:
  /// **'Needs you'**
  String get voiceNeedsYou;

  /// No description provided for @voiceNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get voiceNew;

  /// No description provided for @voiceChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get voiceChange;

  /// No description provided for @voiceRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get voiceRemove;

  /// No description provided for @voiceNeedsAmount.
  ///
  /// In en, this message translates to:
  /// **'No amount was said. Fill it in to add this one.'**
  String get voiceNeedsAmount;

  /// No description provided for @voiceAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get voiceAdjust;

  /// No description provided for @voiceFillIn.
  ///
  /// In en, this message translates to:
  /// **'Fill in'**
  String get voiceFillIn;

  /// No description provided for @voiceTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get voiceTime;

  /// No description provided for @voiceUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get voiceUndo;

  /// No description provided for @voiceUndone.
  ///
  /// In en, this message translates to:
  /// **'Put back as it was'**
  String get voiceUndone;

  /// No description provided for @voiceNoSpeech.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t catch that. Try again, or type it.'**
  String get voiceNoSpeech;

  /// No description provided for @voiceMicOff.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is off. Allow it in Settings, or type instead.'**
  String get voiceMicOff;

  /// No description provided for @voiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice isn\'t available on this phone. You can type instead.'**
  String get voiceUnavailable;

  /// No description provided for @voiceSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get voiceSomethingWrong;

  /// No description provided for @voiceFabSetting.
  ///
  /// In en, this message translates to:
  /// **'Floating mic on Today'**
  String get voiceFabSetting;

  /// No description provided for @voiceFabSettingSub.
  ///
  /// In en, this message translates to:
  /// **'A mic that floats over Today, for saying a transaction'**
  String get voiceFabSettingSub;

  /// No description provided for @voiceFabAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a mic to your Today screen?'**
  String get voiceFabAskTitle;

  /// No description provided for @voiceFabAskBody.
  ///
  /// In en, this message translates to:
  /// **'Tap it and say what you spent, like \"lunch 250 and a rickshaw 60\". You check everything before it\'s saved. Drag it anywhere you like.'**
  String get voiceFabAskBody;

  /// No description provided for @voiceFabAskYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, add the mic'**
  String get voiceFabAskYes;

  /// No description provided for @voiceFabAskNo.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get voiceFabAskNo;

  /// No description provided for @voiceFabAskLater.
  ///
  /// In en, this message translates to:
  /// **'You can turn it on or off any time in More.'**
  String get voiceFabAskLater;

  /// No description provided for @voiceFabHideTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide the floating mic?'**
  String get voiceFabHideTitle;

  /// No description provided for @voiceFabHideBody.
  ///
  /// In en, this message translates to:
  /// **'The mic at the top of Today stays. You can bring this one back in More.'**
  String get voiceFabHideBody;

  /// No description provided for @voiceFabHide.
  ///
  /// In en, this message translates to:
  /// **'Hide it'**
  String get voiceFabHide;

  /// No description provided for @voiceReady.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{NOTHING READY} =1{1 READY TO SAVE} other{{count} READY TO SAVE}}'**
  String voiceReady(int count);

  /// No description provided for @voiceSaveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing selected} =1{Save 1} other{Save {count}}}'**
  String voiceSaveCount(int count);

  /// No description provided for @voiceSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Saved 1 transaction} other{Saved {count} transactions}}'**
  String voiceSaved(int count);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return L10nBn();
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
