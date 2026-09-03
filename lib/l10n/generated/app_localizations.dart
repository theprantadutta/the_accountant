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

  /// The name of the app. Not translated.
  ///
  /// In en, this message translates to:
  /// **'The Accountant'**
  String get appTitle;

  /// Button labels that recur across the whole app.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

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

  /// The direction money moved. Used on cards, filters and charts.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get moneyIncome;

  /// No description provided for @moneyExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get moneyExpense;

  /// No description provided for @moneyTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get moneyTransfer;

  /// No description provided for @moneyBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get moneyBalance;

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

  /// No description provided for @navBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get navBudgets;

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

  /// No description provided for @entityAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get entityAccount;

  /// No description provided for @entityCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get entityCategory;

  /// No description provided for @entityBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get entityBudget;

  /// No description provided for @entityGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get entityGoal;

  /// No description provided for @entityTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get entityTransaction;

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

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get languageBangla;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get confirmIrreversible;

  /// No description provided for @emptyNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get emptyNothingHere;
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
