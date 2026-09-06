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

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

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

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

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

  /// No description provided for @themeSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Match whatever your phone is set to'**
  String get themeSystemDescription;

  /// No description provided for @themeLightDescription.
  ///
  /// In en, this message translates to:
  /// **'Bright, for daylight and shared screens'**
  String get themeLightDescription;

  /// No description provided for @themeDarkDescription.
  ///
  /// In en, this message translates to:
  /// **'The original - deep space with indigo accents'**
  String get themeDarkDescription;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Match my phone'**
  String get languageSystem;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get navAi;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get navAiAssistant;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get sectionAccount;

  /// No description provided for @sectionMoney.
  ///
  /// In en, this message translates to:
  /// **'MONEY'**
  String get sectionMoney;

  /// No description provided for @sectionRegional.
  ///
  /// In en, this message translates to:
  /// **'REGIONAL'**
  String get sectionRegional;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get sectionNotifications;

  /// No description provided for @sectionPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY & SECURITY'**
  String get sectionPrivacySecurity;

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

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get sectionAbout;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and accent colour'**
  String get settingsAppearanceSubtitle;

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

  /// No description provided for @themeExpressYourself.
  ///
  /// In en, this message translates to:
  /// **'Express Yourself'**
  String get themeExpressYourself;

  /// No description provided for @themeExpressYourselfBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a theme that reflects your style and makes managing finances a joy.'**
  String get themeExpressYourselfBody;

  /// No description provided for @themePremiumHeading.
  ///
  /// In en, this message translates to:
  /// **'Premium Themes'**
  String get themePremiumHeading;

  /// No description provided for @themeUnlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Themes'**
  String get themeUnlockPremium;

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

  /// No description provided for @dashRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get dashRecentTransactions;

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

  /// No description provided for @filterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get filterClearAll;

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

  /// No description provided for @dashThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashThisMonth;

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

  /// No description provided for @settingsTestNotificationSentCheckYour.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent! Check your notifications.'**
  String get settingsTestNotificationSentCheckYour;

  /// No description provided for @settingsTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get settingsTest;

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

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL'**
  String get settingsLegal;

  /// No description provided for @settingsReadOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get settingsReadOurPrivacyPolicy;

  /// No description provided for @settingsReadOurTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get settingsReadOurTermsOfService;

  /// No description provided for @settingsHowRefundsAndCancellationsWork.
  ///
  /// In en, this message translates to:
  /// **'How refunds and cancellations work'**
  String get settingsHowRefundsAndCancellationsWork;

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

  /// No description provided for @settingsRenameRecolourAndGroupThem.
  ///
  /// In en, this message translates to:
  /// **'Rename, recolour, and group them'**
  String get settingsRenameRecolourAndGroupThem;

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

  /// No description provided for @settingsDailyRemindersBudgetAlerts.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders, budget alerts'**
  String get settingsDailyRemindersBudgetAlerts;

  /// No description provided for @settingsBiometricLockDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock, data management'**
  String get settingsBiometricLockDataManagement;

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

  /// No description provided for @settingsGetAnswersToCommonQuestions.
  ///
  /// In en, this message translates to:
  /// **'Get answers to common questions'**
  String get settingsGetAnswersToCommonQuestions;

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

  /// No description provided for @walletSaveWallet.
  ///
  /// In en, this message translates to:
  /// **'Save Wallet'**
  String get walletSaveWallet;

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

  /// No description provided for @walletSelectBillingDayOptional.
  ///
  /// In en, this message translates to:
  /// **'Select billing day (optional)'**
  String get walletSelectBillingDayOptional;

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

  /// No description provided for @txScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get txScan;

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

  /// No description provided for @reportMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get reportMaybeLater;

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

  /// No description provided for @aiRefreshSummary.
  ///
  /// In en, this message translates to:
  /// **'Refresh Summary'**
  String get aiRefreshSummary;

  /// No description provided for @aiNetSavings.
  ///
  /// In en, this message translates to:
  /// **'Net Savings'**
  String get aiNetSavings;

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

  /// No description provided for @subSubscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Subscription name'**
  String get subSubscriptionName;

  /// No description provided for @catDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get catDeleteCategory;

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
