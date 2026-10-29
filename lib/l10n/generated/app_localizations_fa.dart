// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class L10nFa extends L10n {
  L10nFa([String locale = 'fa']) : super(locale);

  @override
  String get actionCancel => 'لغو';

  @override
  String get actionConfirm => 'تأیید';

  @override
  String get dateToday => 'امروز';

  @override
  String get dateYesterday => 'دیروز';

  @override
  String get dateTomorrow => 'فردا';

  @override
  String get navTransactions => 'تراکنش‌ها';

  @override
  String get settingsRegionalTitle => 'تنظیمات منطقه‌ای';

  @override
  String get settingsSectionCurrency => 'واحد پول';

  @override
  String get settingsSectionDisplayFormat => 'قالب نمایش';

  @override
  String get settingsSectionLanguage => 'زبان';

  @override
  String get settingsDefaultCurrency => 'واحد پول پیش‌فرض';

  @override
  String get settingsExchangeRates => 'نرخ‌های تبدیل ارز';

  @override
  String get settingsExchangeRatesSubtitle => 'مدیریت نرخ‌های تبدیل ارز';

  @override
  String get settingsDateFormat => 'قالب تاریخ';

  @override
  String get settingsNumberFormat => 'قالب اعداد';

  @override
  String get settingsCurrencySymbol => 'نماد واحد پول';

  @override
  String get settingsTimeFormat => 'قالب ساعت';

  @override
  String get settingsFirstDayOfWeek => 'اولین روز هفته';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsPreview => 'پیش‌نمایش';

  @override
  String get previewDate => 'تاریخ';

  @override
  String get previewTime => 'ساعت';

  @override
  String get previewAmount => 'مبلغ';

  @override
  String get previewWeekStarts => 'این هفته شروع می‌شود';

  @override
  String get choiceMatchMyPhone => 'مطابق گوشی';

  @override
  String get symbolBeforeAmount => 'قبل از مبلغ';

  @override
  String get symbolAfterAmount => 'بعد از مبلغ';

  @override
  String get time12Hour => '12 ساعته (1:30 PM)';

  @override
  String get time24Hour => '24 ساعته (13:30)';

  @override
  String get weekdayMonday => 'دوشنبه';

  @override
  String get weekdaySaturday => 'شنبه';

  @override
  String get weekdaySunday => 'یکشنبه';

  @override
  String get selectDateFormat => 'انتخاب قالب تاریخ';

  @override
  String get selectNumberFormat => 'انتخاب قالب اعداد';

  @override
  String get selectCurrency => 'انتخاب واحد پول';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get languageSystem => 'مطابق گوشی';

  @override
  String get sectionAccount => 'حساب کاربری';

  @override
  String get sectionDataManagement => 'مدیریت داده‌ها';

  @override
  String get sectionHelpSupport => 'راهنما و پشتیبانی';

  @override
  String get settingsAppearance => 'ظاهر';

  @override
  String get settingsBackupRestore => 'پشتیبان‌گیری و بازیابی';

  @override
  String get settingsBackupRestoreSubtitle =>
      'فایلی که خودتان نگه می‌دارید، یا نسخه‌های خودکار در Google Drive';

  @override
  String get settingsImportStatement => 'وارد کردن صورت‌حساب';

  @override
  String get settingsImportStatementSubtitle =>
      'یک فایل CSV از بانکتان وارد کنید؛ یک بار تنظیم و برای دفعات بعد به خاطر سپرده می‌شود';

  @override
  String get settingsExportData => 'خروجی گرفتن از داده‌ها';

  @override
  String get settingsRecentlyDeleted => 'حذف‌شده‌های اخیر';

  @override
  String get settingsRecentlyDeletedSubtitle =>
      'بازگرداندن چیزهایی که در سی روز گذشته حذف شده‌اند';

  @override
  String get themePremiumHeading => 'تم‌های Premium';

  @override
  String get actionRetry => 'تلاش دوباره';

  @override
  String get dashCreditDebt => 'طلب و بدهی';

  @override
  String get dashSubscriptions => 'اشتراک‌ها';

  @override
  String get moneyIncome => 'درآمد';

  @override
  String get dashExpenses => 'هزینه‌ها';

  @override
  String get dashSpendingOverview => 'نمای کلی هزینه‌ها';

  @override
  String get dashBudgetProgress => 'پیشرفت بودجه';

  @override
  String get actionDelete => 'حذف';

  @override
  String txDeleteManyTitle(int count) {
    return '$count تراکنش حذف شود؟';
  }

  @override
  String get txDeleteManyBody =>
      'موجودی‌ها دوباره محاسبه می‌شوند. هر انتقالی در میان آن‌ها، طرف دیگرش را هم با خود حذف می‌کند.';

  @override
  String get txMoveToAccount => 'انتقال به حساب';

  @override
  String get txDeleted => 'تراکنش حذف شد';

  @override
  String txDeleteFailed(String error) {
    return 'حذف این تراکنش ممکن نشد: $error';
  }

  @override
  String txSelectedCount(int count) {
    return '$count انتخاب شده';
  }

  @override
  String get txActions => 'عملیات';

  @override
  String get txChangeCategory => 'تغییر دسته';

  @override
  String get txChangeDate => 'تغییر تاریخ';

  @override
  String get txMarkAsPaid => 'علامت‌گذاری به‌عنوان پرداخت‌شده';

  @override
  String get txMarkAsCorrection => 'علامت‌گذاری به‌عنوان اصلاح موجودی';

  @override
  String get txMarkAsCorrectionTitle => 'نه درآمد است نه هزینه؟';

  @override
  String get txMarkAsCorrectionBody =>
      'از این گزینه برای پولی استفاده کنید که نه درآمد بوده و نه هزینه، مثل افزایش سقف کارت. موجودی تغییری نمی‌کند؛ فقط دیگر به‌عنوان درآمد یا هزینه حساب نمی‌شود.';

  @override
  String get txMarkedAsCorrection => 'اکنون یک اصلاح موجودی است.';

  @override
  String get txMarkAsCorrectionFailed =>
      'این تراکنش نمی‌تواند اصلاح موجودی باشد.';

  @override
  String get txDuplicate => 'تکثیر';

  @override
  String get filterTitle => 'فیلتر';

  @override
  String get filterDirection => 'جهت';

  @override
  String get filterState => 'وضعیت';

  @override
  String get filterKind => 'نوع';

  @override
  String get filterTransfers => 'انتقال‌ها';

  @override
  String get filterAccounts => 'حساب‌ها';

  @override
  String get filterCategories => 'دسته‌ها';

  @override
  String get filterDates => 'تاریخ‌ها';

  @override
  String get filterBudget => 'بودجه';

  @override
  String get filterGoal => 'هدف';

  @override
  String get filterNone => 'هیچ‌کدام';

  @override
  String get filterThisMonth => 'این ماه';

  @override
  String get filterLastMonth => 'ماه گذشته';

  @override
  String get filterLast3Months => '3 ماه گذشته';

  @override
  String get filterThisYear => 'امسال';

  @override
  String filterShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نمایش $count تراکنش',
      one: 'نمایش 1 تراکنش',
      zero: 'هیچ تراکنشی مطابقت ندارد',
    );
    return '$_temp0';
  }

  @override
  String get filterClear => 'پاک کردن';

  @override
  String get filterNoMatches => 'موردی یافت نشد';

  @override
  String get filterAny => 'همه';

  @override
  String get filterSpent => 'خرج‌شده';

  @override
  String get filterEarned => 'دریافتی';

  @override
  String get filterHidden => 'پنهان';

  @override
  String get filterIncluded => 'شامل';

  @override
  String get filterOnly => 'فقط';

  @override
  String get filterFrom => 'از';

  @override
  String get filterTo => 'تا';

  @override
  String get actionApply => 'اعمال';

  @override
  String get filterPaid => 'پرداخت‌شده';

  @override
  String get filterNotYet => 'هنوز نه';

  @override
  String get filterSkipped => 'رد‌شده';

  @override
  String get filterAmount => 'مبلغ';

  @override
  String get actionEdit => 'ویرایش';

  @override
  String get entityBudget => 'بودجه';

  @override
  String get budgetGone => 'این بودجه دیگر وجود ندارد.';

  @override
  String get budgetEarlier => 'قبلی';

  @override
  String get budgetLater => 'بعدی';

  @override
  String get budgetWhereItWent => 'کجا خرج شد';

  @override
  String get budgetRecentPeriods => 'دوره‌های اخیر';

  @override
  String get budgetCaps => 'سقف‌ها';

  @override
  String get actionAdd => 'افزودن';

  @override
  String get budgetNoCategoriesToCap =>
      'این بودجه هنوز دسته‌ای برای تعیین سقف ندارد.';

  @override
  String get budgetCapACategory => 'تعیین سقف برای یک دسته';

  @override
  String get entityCategory => 'دسته';

  @override
  String get budgetAsShare => 'به‌صورت درصدی از بودجه';

  @override
  String get budgetAsShareHint => 'با تغییر بودجه، این مقدار هم تغییر می‌کند';

  @override
  String get actionSet => 'تنظیم';

  @override
  String get budgetAcrossPeriod => 'در طول دوره';

  @override
  String get budgetPreviousPeriod => 'دوره قبل';

  @override
  String get budgetEvenPace => 'روند یکنواخت';

  @override
  String get budgetNew => 'بودجه جدید';

  @override
  String get budgetCreate => 'ایجاد بودجه';

  @override
  String budgetDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get entityAccount => 'حساب';

  @override
  String get entityTransaction => 'تراکنش';

  @override
  String get walletGone => 'این حساب دیگر وجود ندارد.';

  @override
  String get walletCorrectBalance => 'اصلاح موجودی';

  @override
  String get walletCorrectBalanceSubtitle => 'ثبت اختلاف با رقم واقعی';

  @override
  String get walletMergeInto => 'ادغام در حساب دیگر';

  @override
  String get walletInThisMonth => 'ورودی این ماه';

  @override
  String get walletOutThisMonth => 'خروجی این ماه';

  @override
  String get walletRecentActivity => 'فعالیت‌های اخیر';

  @override
  String get walletNoOtherAccount => 'حساب دیگری برای ادغام وجود ندارد.';

  @override
  String get walletMergeIntoTitle => 'ادغام در';

  @override
  String get walletMergeAction => 'ادغام';

  @override
  String walletMerged(int count, String target) {
    return '$count مورد به $target منتقل شد.';
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
      other: '$removed انتقال بین این دو حساب حذف شد',
      one: 'یک انتقال بین این دو حساب حذف شد',
    );
    return '$count مورد به $target منتقل شد. $_temp0، چون دیگر دو طرف نداشت.';
  }

  @override
  String get walletRealBalance => 'موجودی واقعی';

  @override
  String get walletCorrectAction => 'اصلاح';

  @override
  String get txGone => 'این تراکنش دیگر وجود ندارد.';

  @override
  String get txKind => 'نوع';

  @override
  String get txState => 'وضعیت';

  @override
  String get txWasDue => 'سررسید بود';

  @override
  String get txNotes => 'یادداشت‌ها';

  @override
  String get txDeleteOneTitle => 'این تراکنش حذف شود؟';

  @override
  String get rulesTitle => 'قوانین نام‌گذاری';

  @override
  String get rulesAdd => 'افزودن قانون';

  @override
  String rulesRemoved(String title) {
    return 'قانون مربوط به $title حذف شد';
  }

  @override
  String get rulesWhenTitleSays => 'وقتی عنوان شامل این باشد';

  @override
  String get rulesMatchExactly => 'تطابق دقیق';

  @override
  String get rulesChooseCategory => 'انتخاب دسته';

  @override
  String get actionSave => 'ذخیره';

  @override
  String get goalNew => 'هدف جدید';

  @override
  String get goalLoadFailed => 'بارگیری اهدافتان ممکن نشد.';

  @override
  String get goalCreate => 'ایجاد هدف';

  @override
  String get trashTitle => 'حذف‌شده‌های اخیر';

  @override
  String get trashRestore => 'بازگردانی';

  @override
  String get trashRestored => 'بازگردانده شد.';

  @override
  String get payTitle => 'روش‌های پرداخت';

  @override
  String get payDefault => 'پیش‌فرض';

  @override
  String get payAddOne => 'افزودن';

  @override
  String payDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get payName => 'نام';

  @override
  String get payNameHint => 'کارت بانکی روزمره';

  @override
  String get payKind => 'نوع';

  @override
  String get payBankOrIssuer => 'بانک یا صادرکننده';

  @override
  String get payLastFour => 'چهار رقم آخر';

  @override
  String get payUseByDefault => 'استفاده به‌صورت پیش‌فرض';

  @override
  String get backupChecking => 'در حال بررسی…';

  @override
  String get backupLoading => 'در حال بارگیری…';

  @override
  String get backupSaveACopy => 'ذخیره یک نسخه';

  @override
  String get backupAutomaticBackups => 'پشتیبان‌گیری خودکار';

  @override
  String get backupHowManyBackupsToKeep =>
      'تعداد نسخه‌های پشتیبان برای نگهداری';

  @override
  String get backupSaveABackupFile => 'ذخیره فایل پشتیبان';

  @override
  String get backupShareItToFilesEmail =>
      'آن را در Files، ایمیل یا هر جای دیگری به اشتراک بگذارید';

  @override
  String get backupRestoreFromAFile => 'بازیابی از فایل';

  @override
  String get backupReplacesEverythingCurrentlyOnThis =>
      'همه داده‌های فعلی این دستگاه جایگزین می‌شوند';

  @override
  String get backupRestoreThisBackup => 'این نسخه پشتیبان بازیابی شود؟';

  @override
  String get backupEraseRestore => 'پاک کردن و بازیابی';

  @override
  String get backupGoogleDriveIsUnavailable => 'Google Drive در دسترس نیست';

  @override
  String get backupConnectGoogleDrive => 'اتصال به Google Drive';

  @override
  String get backupBackUpNow => 'پشتیبان‌گیری اکنون';

  @override
  String get backupKeep => 'نگه‌داشتن';

  @override
  String get backupTheLastAutomaticBackupDid =>
      'آخرین پشتیبان‌گیری خودکار انجام نشد';

  @override
  String get backupDisconnectGoogleDrive => 'قطع اتصال Google Drive';

  @override
  String get backupDisconnectGoogleDrive2 => 'اتصال Google Drive قطع شود؟';

  @override
  String get backupDisconnect => 'قطع اتصال';

  @override
  String get backupDeleteThisBackup => 'این نسخه پشتیبان حذف شود؟';

  @override
  String get importChooseACsvFile => 'انتخاب فایل CSV';

  @override
  String get importRememberTheseSettingsForThis =>
      'این تنظیمات برای این بانک به خاطر سپرده شود';

  @override
  String get importChange => 'تغییر';

  @override
  String get importAuto => 'خودکار';

  @override
  String get importDone => 'تمام';

  @override
  String get importRememberThisBank => 'به خاطر سپردن این بانک';

  @override
  String get importForget => 'فراموش کردن';

  @override
  String get importImport => 'وارد کردن';

  @override
  String get settingsAbout => 'درباره';

  @override
  String get settingsPrivacyPolicy => 'سیاست حفظ حریم خصوصی';

  @override
  String get settingsTermsOfService => 'شرایط استفاده از خدمات';

  @override
  String get settingsRefundPolicy => 'سیاست بازپرداخت';

  @override
  String get settingsOpenSourceLicenses => 'مجوزهای متن‌باز';

  @override
  String get settingsMeetTheDeveloper => 'آشنایی با توسعه‌دهنده';

  @override
  String get settingsContactSupport => 'تماس با پشتیبانی';

  @override
  String get settingsSubject => 'موضوع';

  @override
  String get settingsMessage => 'پیام';

  @override
  String get settingsSendMessage => 'ارسال پیام';

  @override
  String get settingsUseApiRate => 'استفاده از نرخ API';

  @override
  String get settingsRefreshRates => 'به‌روزرسانی نرخ‌ها';

  @override
  String get settingsSearchCurrencies => 'جستجوی ارزها...';

  @override
  String get settingsCustomRate => 'نرخ دلخواه';

  @override
  String get settingsSetCustomRate => 'تنظیم نرخ دلخواه';

  @override
  String get settingsNotNow => 'الان نه';

  @override
  String get settingsGoPremium => 'ارتقا به Premium';

  @override
  String get settingsCsv => 'CSV';

  @override
  String get settingsSpreadsheetFormatForExcelGoogle =>
      'قالب صفحه‌گسترده برای Excel و Google Sheets';

  @override
  String get settingsPdfReport => 'گزارش PDF';

  @override
  String get settingsFormattedSummaryWithBreakdowns =>
      'خلاصه قالب‌بندی‌شده با جزئیات تفکیکی';

  @override
  String get settingsAllIncomeAndExpenseRecords => 'همه سوابق درآمد و هزینه';

  @override
  String get settingsCategories => 'دسته‌ها';

  @override
  String get settingsCategoryBreakdownAndTotals => 'تفکیک دسته‌ها و مجموع‌ها';

  @override
  String get settingsWallets => 'کیف پول‌ها';

  @override
  String get settingsWalletBalancesAndHistory => 'موجودی و تاریخچه کیف پول‌ها';

  @override
  String get settingsHelpFaq => 'راهنما و پرسش‌های متداول';

  @override
  String get settingsNotifications => 'اعلان‌ها';

  @override
  String get settingsLargeTransactionThreshold => 'آستانه تراکنش بزرگ';

  @override
  String get settingsRemindMeBeforeDueDate => 'یادآوری قبل از سررسید';

  @override
  String get settingsDailyReminders => 'یادآوری‌های روزانه';

  @override
  String get settingsDailyReminders2 => 'یادآوری‌های روزانه';

  @override
  String get settingsGetRemindedToTrackYour => 'یادآوری برای ثبت هزینه‌هایتان';

  @override
  String get settingsBudgetAlerts => 'هشدارهای بودجه';

  @override
  String get settingsBudgetAlerts2 => 'هشدارهای بودجه';

  @override
  String get settingsNotifyWhenApproachingBudgetLimit =>
      'اطلاع هنگام نزدیک شدن به سقف بودجه';

  @override
  String get settingsWarningThreshold => 'آستانه هشدار';

  @override
  String get settingsTransactionAlerts => 'هشدارهای تراکنش';

  @override
  String get settingsLargeTransactionAlerts => 'هشدار تراکنش‌های بزرگ';

  @override
  String get settingsNotifyForTransactionsAboveThreshold =>
      'اطلاع برای تراکنش‌های بالاتر از آستانه';

  @override
  String get settingsRecurringTransactionReminders =>
      'یادآوری تراکنش‌های تکرارشونده';

  @override
  String get settingsRemindAboutUpcomingRecurringPayments =>
      'یادآوری پرداخت‌های تکرارشونده پیش رو';

  @override
  String get settingsOtherNotifications => 'سایر اعلان‌ها';

  @override
  String get settingsSubscriptionExpiryAlerts => 'هشدار انقضای اشتراک';

  @override
  String get settingsGetNotifiedBeforeYourPremium =>
      'قبل از پایان Premium به شما اطلاع داده شود';

  @override
  String get settingsPromotionalNotifications => 'اعلان‌های تبلیغاتی';

  @override
  String get settingsReceiveOffersAndFeatureUpdates =>
      'دریافت پیشنهادها و خبر قابلیت‌های جدید';

  @override
  String get settingsTurnOnDailyReminders => 'یادآوری‌های روزانه روشن شود؟';

  @override
  String get settingsEnterAmount => 'مبلغ را وارد کنید';

  @override
  String get settingsReminderTime => 'زمان یادآوری';

  @override
  String get settingsPrivacySecurity => 'حریم خصوصی و امنیت';

  @override
  String get settingsSecurity => 'امنیت';

  @override
  String get settingsBiometricLock => 'قفل بیومتریک';

  @override
  String get settingsUseFingerprintOrFaceTo =>
      'باز کردن قفل با اثر انگشت یا چهره';

  @override
  String get settingsAutoLock => 'قفل خودکار';

  @override
  String get settingsDataPrivacy => 'حریم خصوصی داده‌ها';

  @override
  String get settingsClearCache => 'پاک کردن حافظه موقت';

  @override
  String get settingsClearCachedDataAndForce =>
      'پاک کردن داده‌های موقت و همگام‌سازی مجدد';

  @override
  String get settingsClearAllData => 'پاک کردن همه داده‌ها';

  @override
  String get settingsDeleteAllTransactionsBudgetsAnd =>
      'حذف همه تراکنش‌ها، بودجه‌ها و تنظیمات';

  @override
  String get settingsDangerZone => 'منطقه خطر';

  @override
  String get settingsDeleteAccount => 'حذف حساب کاربری';

  @override
  String get settingsPermanentlyDeleteYourAccountAnd =>
      'حذف دائمی حساب کاربری و همه داده‌ها';

  @override
  String get settingsAutoLockTimeout => 'زمان قفل خودکار';

  @override
  String get settingsDeleteEverything => 'حذف همه چیز';

  @override
  String get settingsAreYouAbsolutelySure => 'کاملاً مطمئن هستید؟';

  @override
  String get settingsYesDeleteAll => 'بله، همه حذف شود';

  @override
  String get settingsContinue => 'ادامه';

  @override
  String get settingsEditProfile => 'ویرایش نمایه';

  @override
  String get settingsDisplayName => 'نام نمایشی';

  @override
  String get settingsEmailAddress => 'آدرس ایمیل';

  @override
  String get settingsUnsavedChanges => 'تغییرات ذخیره‌نشده';

  @override
  String get settingsStay => 'ماندن';

  @override
  String get settingsLeave => 'خروج';

  @override
  String get settingsSearchByCodeOrName => 'جستجو با کد یا نام...';

  @override
  String get settingsSearchSettings => 'جستجوی تنظیمات...';

  @override
  String get settingsSubscription => 'اشتراک';

  @override
  String get settingsSignOut => 'خروج از حساب';

  @override
  String get settingsGoals => 'اهداف';

  @override
  String get settingsCardsInNetWorth =>
      'احتساب کارت‌های اعتباری در دارایی خالص';

  @override
  String get settingsCardsInNetWorthSub =>
      'خاموش: فقط پولی که دارید حساب می‌شود، نه بدهی کارت‌ها.';

  @override
  String get settingsSaveTowardSomethingAndTrack =>
      'برای چیزی پس‌انداز کنید و پیشرفتتان را دنبال کنید';

  @override
  String get settingsBudgets => 'بودجه‌ها';

  @override
  String get settingsSetLimitsAndSeeHow =>
      'سقف تعیین کنید و روند دوره را ببینید';

  @override
  String get settingsUpcomingAndOverdue => 'پیش رو و معوق';

  @override
  String get settingsWhatIsDueAndWhat =>
      'چه چیزی سررسید است و چه چیزی جا مانده';

  @override
  String get settingsAccounts => 'حساب‌ها';

  @override
  String get settingsAddReorderAndEditYour =>
      'افزودن، مرتب‌سازی و ویرایش حساب‌ها';

  @override
  String get settingsTheCardsAndAccountsYou =>
      'کارت‌ها و حساب‌هایی که با آن‌ها پرداخت می‌کنید';

  @override
  String get settingsWhereSomethingGoesBasedOn =>
      'تعیین دسته هر مورد بر اساس نام آن';

  @override
  String get settingsNotificationSettings => 'تنظیمات اعلان‌ها';

  @override
  String get settingsCloudSync => 'همگام‌سازی ابری';

  @override
  String get settingsSyncYourDataAcrossDevices =>
      'همگام‌سازی داده‌ها بین دستگاه‌ها';

  @override
  String get settingsCsvIsFreePdfReport =>
      'CSV رایگان است · گزارش PDF مخصوص Premium است';

  @override
  String get settingsQuestionsComplaintsOrFeedback => 'پرسش، شکایت یا بازخورد';

  @override
  String get settingsRateTheApp => 'امتیاز به برنامه';

  @override
  String get settingsShareWithFriends => 'اشتراک‌گذاری با دوستان';

  @override
  String get settingsReplayAppTour => 'نمایش دوباره راهنمای برنامه';

  @override
  String get settingsSeeTheFeatureWalkthroughAgain =>
      'دیدن دوباره معرفی قابلیت‌ها';

  @override
  String get settingsAboutTheAccountant => 'درباره The Accountant';

  @override
  String get settingsVersionLicensesAndMore => 'نسخه، مجوزها و موارد دیگر';

  @override
  String get settingsTestCrash => 'آزمایش کرش';

  @override
  String get settingsTriggerATestExceptionFor =>
      'ایجاد یک خطای آزمایشی برای Crashlytics';

  @override
  String get settingsDeveloper => 'توسعه‌دهنده';

  @override
  String get settingsRestoreFromCloud => 'بازیابی از فضای ابری؟';

  @override
  String get settingsSyncing => 'در حال همگام‌سازی...';

  @override
  String get settingsSynced => 'همگام شد';

  @override
  String get settingsSyncError => 'خطای همگام‌سازی';

  @override
  String get syncBackgroundFailed =>
      'همگام‌سازی انجام نشد. تغییراتتان روی این دستگاه امن است و بعداً همگام می‌شود.';

  @override
  String get settingsOffline => 'آفلاین';

  @override
  String get settingsReady => 'آماده';

  @override
  String get settingsYesUseThis => 'بله، از این استفاده شود';

  @override
  String get settingsKeepThemSeparate => 'جدا نگه داشته شوند؟';

  @override
  String get settingsCurrentPassword => 'رمز عبور فعلی';

  @override
  String get settingsNewPassword => 'رمز عبور جدید';

  @override
  String get settingsConfirmPassword => 'تکرار رمز عبور';

  @override
  String get walletEGPersonalSavingsBusiness => 'مثلاً شخصی، پس‌انداز، کاری';

  @override
  String get walletEnterCreditLimit => 'سقف اعتبار را وارد کنید';

  @override
  String get walletSelectBillingDay => 'انتخاب روز صورت‌حساب';

  @override
  String get walletCreateAccount => 'ایجاد حساب';

  @override
  String get walletWalletCreatedSuccessfully => 'کیف پول با موفقیت ایجاد شد';

  @override
  String get walletAccountUpdatedSuccessfully =>
      'حساب با موفقیت به‌روزرسانی شد';

  @override
  String get walletEditAccount => 'ویرایش حساب';

  @override
  String get walletSetAsDefault => 'تنظیم به‌عنوان پیش‌فرض';

  @override
  String get walletUseDecimals => 'استفاده از اعشار';

  @override
  String get walletEnterWalletName => 'نام کیف پول را وارد کنید';

  @override
  String get walletCurrency => 'واحد پول';

  @override
  String get walletIcon => 'نماد';

  @override
  String get walletColor => 'رنگ';

  @override
  String get walletWalletName => 'نام کیف پول';

  @override
  String get walletInitialBalance => 'موجودی اولیه';

  @override
  String get txAddATransferFee => 'افزودن کارمزد انتقال';

  @override
  String get txRemove => 'حذف';

  @override
  String get txPaymentMethod => 'روش پرداخت';

  @override
  String get txObjective => 'هدف';

  @override
  String get txTitle => 'عنوان';

  @override
  String get txTesco => 'فروشگاه رفاه';

  @override
  String get txAll => 'همه';

  @override
  String get txSkip => 'رد کردن';

  @override
  String get txMarkAsPaid2 => 'پرداخت شد';

  @override
  String get txConfirmPayment => 'تأیید پرداخت';

  @override
  String get txAmountCharged => 'مبلغ کسرشده';

  @override
  String get txUndo => 'واگرد';

  @override
  String get txNoLoan => 'بدون وام';

  @override
  String get txLentMoney => 'پول قرض داده‌شده';

  @override
  String get txBorrowedMoney => 'پول قرض گرفته‌شده';

  @override
  String get goalShowOnTheHomeScreen => 'نمایش در صفحه اصلی';

  @override
  String get goalWhatAreYouSavingFor => 'برای چه چیزی پس‌انداز می‌کنید؟';

  @override
  String get goalNewLaptop => 'لپ‌تاپ جدید';

  @override
  String get goalTarget => 'مبلغ هدف';

  @override
  String get goalColour => 'رنگ';

  @override
  String get goalClear => 'پاک کردن';

  @override
  String get goalGoal => 'هدف';

  @override
  String get goalThisGoalNoLongerExists => 'این هدف دیگر وجود ندارد.';

  @override
  String get goalAddToGoal => 'افزودن به هدف';

  @override
  String get goalUnlink => 'لغو پیوند';

  @override
  String get reportUpgrade => 'ارتقا';

  @override
  String get budgetSpending => 'هزینه';

  @override
  String get budgetEarnings => 'درآمد';

  @override
  String get budgetEvery => 'هر';

  @override
  String get budgetCarryOverWhatIsLeft => 'انتقال باقی‌مانده به دوره بعد';

  @override
  String get budgetGroceries => 'خواربار';

  @override
  String get authLinkYourAccount => 'پیوند حساب کاربری';

  @override
  String get authPassword => 'رمز عبور';

  @override
  String get authLinkAccount => 'پیوند حساب';

  @override
  String get authEmailAddress => 'آدرس ایمیل';

  @override
  String get authSendResetCode => 'ارسال کد بازنشانی';

  @override
  String get authResetCode => 'کد بازنشانی';

  @override
  String get authResetPassword => 'بازنشانی رمز عبور';

  @override
  String get authWelcomeBack => 'خوش برگشتید';

  @override
  String get authSignInToContinueYour =>
      'وارد شوید تا مسیر مالی‌تان را ادامه دهید';

  @override
  String get authSignIn => 'ورود';

  @override
  String get authJoinUsToStartYour =>
      'به ما بپیوندید و مسیر مالی‌تان را شروع کنید';

  @override
  String get authFullName => 'نام کامل';

  @override
  String get premiumPremium => 'Premium';

  @override
  String get premiumMonthly => 'ماهانه';

  @override
  String get premiumYearly => 'سالانه';

  @override
  String get premiumLifetime => 'مادام‌العمر';

  @override
  String get premiumNotNow => 'الان نه';

  @override
  String get aiRename => 'تغییر نام';

  @override
  String get aiRenameChat => 'تغییر نام گفتگو';

  @override
  String get aiDeleteChat => 'گفتگو حذف شود؟';

  @override
  String get aiChatName => 'نام گفتگو';

  @override
  String get aiScanReceipt => 'اسکن رسید';

  @override
  String get aiCamera => 'دوربین';

  @override
  String get aiGallery => 'گالری';

  @override
  String get aiMerchantTitle => 'فروشنده / عنوان';

  @override
  String get aiSaveAsTransaction => 'ذخیره به‌عنوان تراکنش';

  @override
  String get onboardBrowseThemes => 'مرور تم‌ها';

  @override
  String get onboardBack => 'بازگشت';

  @override
  String get onboardGetStarted => 'شروع کنید';

  @override
  String get onboardMainAccount => 'حساب اصلی';

  @override
  String get creditRecordPayment => 'ثبت پرداخت';

  @override
  String get creditPleaseEnterAValidAmount => 'لطفاً مبلغ معتبری وارد کنید';

  @override
  String get creditAmountExceedsRemainingBalance => 'مبلغ از مانده بیشتر است';

  @override
  String get creditPaymentAmount => 'مبلغ پرداخت';

  @override
  String get creditPaidOn => 'تاریخ پرداخت';

  @override
  String get creditFullAmount => 'کل مبلغ';

  @override
  String get subSubscriptionName => 'نام اشتراک';

  @override
  String get subAskBeforeEachPayment => 'پیش از ثبت هر پرداخت سؤال شود';

  @override
  String get subAskBeforeEachPaymentHint =>
      'هر پرداخت در «پیش رو» منتظر می‌ماند تا مبلغ کسرشده را تأیید کنید یا آن را رد کنید. مناسب برای مبالغ متغیر، مثل کارتی که با ارز دیگری پرداخت می‌شود.';

  @override
  String get subChangesApplyFromNext =>
      'مبلغ یا حساب جدید از پرداخت بعدی اعمال می‌شود. پرداخت‌های قبلی همان‌طور که بودند باقی می‌مانند.';

  @override
  String get catPleaseEnterACategoryName => 'لطفاً نام دسته را وارد کنید';

  @override
  String get catEnterCategoryName => 'نام دسته را وارد کنید';

  @override
  String get catSearch => 'جستجوی دسته‌ها';

  @override
  String get catNoMatch => 'هیچ دسته‌ای با این مطابقت ندارد.';

  @override
  String get catUseEmoji => 'استفاده از ایموجی';

  @override
  String get catEmojiHint => 'یک ایموجی تایپ یا انتخاب کنید';

  @override
  String get catArchive => 'بایگانی';

  @override
  String get catMergeInto => 'ادغام در…';

  @override
  String catMergeIntoTitle(String name) {
    return 'ادغام $name در';
  }

  @override
  String get catMergeBuiltIn => 'پیش‌ساخته';

  @override
  String get catMergeNoTargets =>
      'دسته دیگری از همین نوع برای ادغام وجود ندارد.';

  @override
  String catMergeConfirmTitle(String from, String to) {
    return '$from در $to ادغام شود؟';
  }

  @override
  String catMergeConfirmBody(String from, String to) {
    return 'همه تراکنش‌ها، بودجه‌ها و زیردسته‌های $from به $to منتقل می‌شوند و $from حذف می‌شود. این تغییر با دستگاه‌های دیگرتان همگام می‌شود.';
  }

  @override
  String get catMergeAction => 'ادغام';

  @override
  String catMerged(String from, String to) {
    return '$from در $to ادغام شد.';
  }

  @override
  String get catExpenseSection => 'دسته‌های هزینه';

  @override
  String get catIncomeSection => 'دسته‌های درآمد';

  @override
  String get catSectionEmpty => 'هنوز موردی نیست';

  @override
  String catSubcategoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count زیردسته',
      one: '1 زیردسته',
    );
    return '$_temp0';
  }

  @override
  String catTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش',
      one: '1 تراکنش',
      zero: 'بدون تراکنش',
    );
    return '$_temp0';
  }

  @override
  String catInParent(String name) {
    return 'در $name';
  }

  @override
  String get catAddSubcategory => 'افزودن زیردسته';

  @override
  String get catNoSubcategoriesYet => 'هنوز زیردسته‌ای نیست. یکی اضافه کنید';

  @override
  String get catMoveTo => 'انتقال به…';

  @override
  String catMoveToTitle(String name) {
    return 'انتقال $name به';
  }

  @override
  String get catTopLevel => 'سطح بالا';

  @override
  String get catTopLevelHint => 'داخل هیچ دسته‌ای نیست';

  @override
  String catMovedInto(String name, String parent) {
    return '$name اکنون در $parent است.';
  }

  @override
  String catMovedToTop(String name) {
    return '$name اکنون یک دسته سطح بالا است.';
  }

  @override
  String get catMoveNoParents =>
      'دسته‌ای وجود ندارد که بتواند داخل آن قرار گیرد.';

  @override
  String get catMoveTransactions => 'انتقال تراکنش‌ها…';

  @override
  String catMoveTransactionsTitle(String name) {
    return 'انتقال تراکنش‌های $name به';
  }

  @override
  String catMoveTransactionsConfirmTitle(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش به $to منتقل شود؟',
      one: '1 تراکنش به $to منتقل شود؟',
    );
    return '$_temp0';
  }

  @override
  String catMoveTransactionsConfirmBody(String from, String to) {
    return 'فقط تراکنش‌ها منتقل می‌شوند. $from با بودجه‌ها و زیردسته‌هایش باقی می‌ماند. این تغییر با دستگاه‌های دیگرتان همگام می‌شود.';
  }

  @override
  String get catMoveAction => 'انتقال';

  @override
  String catMovedTransactions(int count, String to) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش به $to منتقل شد.',
      one: '1 تراکنش به $to منتقل شد.',
    );
    return '$_temp0';
  }

  @override
  String catNoTransactionsToMove(String name) {
    return '$name تراکنشی برای انتقال ندارد.';
  }

  @override
  String get catNoMoveTargets =>
      'دسته دیگری از همین نوع برای انتقال آن‌ها وجود ندارد.';

  @override
  String catDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get catDeleteEmptyBody => 'تراکنشی ندارد، پس چیز دیگری تغییر نمی‌کند.';

  @override
  String get catDeleteChildrenNote =>
      'زیردسته‌های آن به سطح بالا منتقل می‌شوند.';

  @override
  String catDeleteWithTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش در این دسته ثبت شده است. با آن‌ها چه کنیم؟',
      one: '1 تراکنش در این دسته ثبت شده است. با آن چه کنیم؟',
    );
    return '$_temp0';
  }

  @override
  String get catDeleteMoveThem => 'انتقال به دسته دیگر';

  @override
  String catDeleteMoveThemHint(String name) {
    return 'سپس $name حذف می‌شود. بودجه‌هایی که از آن استفاده می‌کردند هم منتقل می‌شوند.';
  }

  @override
  String get catDeleteThemToo => 'تراکنش‌ها هم حذف شوند';

  @override
  String get catDeleteThemTooHint =>
      'به «حذف‌شده‌های اخیر» می‌روند و تا 30 روز می‌توانید آن‌ها را بازگردانید.';

  @override
  String catDeleted(String name) {
    return '$name حذف شد.';
  }

  @override
  String get catActionFailed => 'انجام نشد. دوباره تلاش کنید.';

  @override
  String get catStaysTopLevel =>
      'این دسته زیردسته‌های خودش را دارد، پس در سطح بالا می‌ماند.';

  @override
  String get catUnarchive => 'خروج از بایگانی';

  @override
  String get catArchivedSection => 'بایگانی‌شده';

  @override
  String get catArchivedHint =>
      'برای سوابق نگه داشته می‌شوند، اما هنگام افزودن تراکنش پیشنهاد نمی‌شوند.';

  @override
  String get catNothingItsOwnCategory => 'هیچ — دسته مستقل';

  @override
  String get notifEnableNotifications => 'فعال‌سازی اعلان‌ها';

  @override
  String get startupContinueWithoutChecking => 'بدون بررسی ادامه می‌دهید؟';

  @override
  String get startupContinueOffline => 'ادامه به‌صورت آفلاین';

  @override
  String get startupViewSubscriptionOptions => 'مشاهده گزینه‌های اشتراک';

  @override
  String get sharedWelcomeBack => 'خوش برگشتید';

  @override
  String get sharedRestoringYourDataFromThe =>
      'در حال بازیابی داده‌هایتان از فضای ابری…';

  @override
  String walletMergeConfirmTitle(String source, String target) {
    return '$source در $target ادغام شود؟';
  }

  @override
  String get backupNothingHereYet => 'هنوز چیزی اینجا نیست.';

  @override
  String get importAppliedAutomaticallyWhenAFile =>
      'وقتی فایلی این ستون‌ها را داشته باشد، خودکار اعمال می‌شود';

  @override
  String get importDateFormat => 'قالب تاریخ';

  @override
  String get importChooseOne => 'یکی را انتخاب کنید';

  @override
  String get importDecimalPoint => 'ممیز اعشار';

  @override
  String get importFlipTheSigns => 'معکوس کردن علامت‌ها';

  @override
  String get importForExportsThatWriteA =>
      'برای خروجی‌هایی که هزینه را مثبت ثبت می‌کنند';

  @override
  String get importWhereRowsGoWhenThe =>
      'مقصد ردیف‌ها وقتی فایل نام هیچ‌یک از حساب‌هایتان را ندارد';

  @override
  String get importSkipWhatIsAlreadyHere =>
      'رد کردن مواردی که از قبل وجود دارند';

  @override
  String get importCreateCategoriesTheFileNames =>
      'ایجاد دسته‌هایی که در فایل نام برده شده‌اند';

  @override
  String get importOtherwiseThoseRowsArriveUncategorised =>
      'در غیر این صورت آن ردیف‌ها بدون دسته وارد می‌شوند';

  @override
  String get importCategoriesInThisFile => 'دسته‌های این فایل';

  @override
  String get settingsMadeWithLoveForPersonal =>
      'ساخته‌شده با عشق برای امور مالی شخصی';

  @override
  String get settingsTheAccountant => 'The Accountant';

  @override
  String get settingsDevelopedMaintainedBy => 'توسعه و نگهداری توسط:';

  @override
  String get settingsPrantaDutta => 'پرانتا دوتا';

  @override
  String get settingsClose => 'بستن';

  @override
  String get settingsGetInTouch => 'در تماس باشید';

  @override
  String get settingsAsAPremiumMemberYour =>
      'به‌عنوان عضو Premium، درخواست شما در اولویت قرار می‌گیرد.';

  @override
  String get settingsWhatToInclude => 'چه چیزهایی گنجانده شود';

  @override
  String get settingsNoCurrenciesFound => 'ارزی یافت نشد';

  @override
  String get settingsExportYourFinancialDataTo =>
      'از داده‌های مالی‌تان خروجی بگیرید تا در برنامه‌های دیگر تحلیل کنید یا به‌عنوان پشتیبان نگه دارید.';

  @override
  String get settingsDateRange => 'بازه زمانی';

  @override
  String get settingsPremium => 'PREMIUM';

  @override
  String get settingsPdfReports => 'گزارش‌های PDF';

  @override
  String get settingsGettingStarted => 'شروع کار';

  @override
  String get settingsStillNeedHelp => 'هنوز به کمک نیاز دارید؟';

  @override
  String get settingsOurSupportTeamIsHere =>
      'تیم پشتیبانی ما آماده کمک به شماست';

  @override
  String get settingsAppLocked => 'برنامه قفل است';

  @override
  String get settingsUnlockToAccessTheAccountant =>
      'برای دسترسی به The Accountant قفل را باز کنید';

  @override
  String get settingsConfigureWhenAndHowThe =>
      'تعیین کنید The Accountant چه زمانی و چگونه برای ثبت هزینه‌ها به شما یادآوری کند.';

  @override
  String get settingsYourEmailIsUsedTo =>
      'ایمیل شما برای ورود استفاده می‌شود و اینجا قابل تغییر نیست.';

  @override
  String get settingsYourDataIsOnThis => 'داده‌های شما فقط روی این دستگاه است';

  @override
  String get settingsUpgradeForCloudSync => 'برای همگام‌سازی ابری ارتقا دهید';

  @override
  String get settingsNoSettingsFound => 'تنظیماتی یافت نشد';

  @override
  String get settingsTryADifferentSearchTerm => 'عبارت دیگری را جستجو کنید';

  @override
  String get settingsSyncStatus => 'وضعیت همگام‌سازی';

  @override
  String get settingsSyncNow => 'همگام‌سازی اکنون';

  @override
  String get settingsRestoreFromCloud2 => 'بازیابی از فضای ابری';

  @override
  String get settingsPro => 'حرفه‌ای';

  @override
  String get settingsNeedsYourConfirmation => 'نیازمند تأیید شما';

  @override
  String get walletCreateYourFirstAccount => 'اولین حسابتان را بسازید';

  @override
  String get walletYouNeedAtLeastOne =>
      'برای شروع پیگیری امور مالی، حداقل به یک حساب نیاز دارید';

  @override
  String get walletAccountType => 'نوع حساب';

  @override
  String get walletAccountName => 'نام حساب';

  @override
  String get walletCreditLimit => 'سقف اعتبار';

  @override
  String get walletCreditLimitHelp =>
      'سقف بالا رفته؟ اینجا تغییرش دهید. سقف جدید درآمد حساب نمی‌شود.';

  @override
  String get walletAmountOwed => 'مبلغ بدهی';

  @override
  String get walletAmountOwedHelp =>
      'بدهی فعلی شما روی کارت. اگر تسویه شده، 0 وارد کنید.';

  @override
  String get walletCurrentBalance => 'موجودی فعلی';

  @override
  String get walletCurrentBalanceHelp =>
      'تغییر به‌عنوان اصلاح موجودی ذخیره می‌شود تا تاریخچه‌تان همچنان درست جمع بخورد.';

  @override
  String walletCardBalanceQuestion(String amount) {
    return '$amount روی این کارت چیست؟';
  }

  @override
  String get walletCardBalanceCreditLeft => 'اعتبار باقی‌مانده من';

  @override
  String get walletCardBalanceOwed => 'بدهی من';

  @override
  String get walletCardBalanceChoose =>
      'مشخص کنید این مبلغ چیست تا بدهی درست محاسبه شود.';

  @override
  String get walletBillingCycleDayOptional => 'روز چرخه صورت‌حساب (اختیاری)';

  @override
  String get walletThisWillBeYourDefault => 'این حساب پیش‌فرض شما خواهد بود';

  @override
  String get walletNothingRecordedAgainstThisAccount =>
      'هنوز چیزی برای این حساب ثبت نشده است.';

  @override
  String get walletAddAccount => 'افزودن حساب';

  @override
  String get walletYourAccounts => 'حساب‌های شما';

  @override
  String get walletNoAccountsYet => 'هنوز حسابی ندارید';

  @override
  String get walletOutstanding => 'بدهی';

  @override
  String get walletAvailable => 'در دسترس';

  @override
  String get walletLimit => 'سقف';

  @override
  String get walletBalance => 'موجودی';

  @override
  String get walletUseThisWalletForNew =>
      'استفاده از این کیف پول برای تراکنش‌های جدید';

  @override
  String get walletSelectIcon => 'انتخاب نماد';

  @override
  String get walletSelectColor => 'انتخاب رنگ';

  @override
  String get txYouNeedAtLeast2 => 'برای انتقال حداقل به 2 حساب نیاز دارید';

  @override
  String get txNoAccountTitle => 'حسابی برای ثبت این مورد وجود ندارد';

  @override
  String get txNoAccountBody =>
      'یک حساب اضافه کنید یا یک حساب بسته را دوباره باز کنید تا این فرم قابل استفاده شود.';

  @override
  String get txNoAccountAction => 'مدیریت حساب‌ها';

  @override
  String get txDeleteTransaction => 'حذف تراکنش';

  @override
  String get txAreYouSureYouWant => 'مطمئنید می‌خواهید این تراکنش را حذف کنید؟';

  @override
  String get txTransactionType => 'نوع تراکنش';

  @override
  String get txTransferFee => 'کارمزد انتقال';

  @override
  String get txChargedSeparatelySoTheTransfer =>
      'جداگانه کسر می‌شود تا خود انتقال متوازن بماند.';

  @override
  String get txDeductedFrom => 'کسر از';

  @override
  String get txNoPaymentMethods => 'روش پرداختی وجود ندارد';

  @override
  String get txNothingDeletedRecently => 'اخیراً چیزی حذف نشده است';

  @override
  String get txAnythingYouDeleteShowsUp =>
      'هر چیزی که حذف کنید تا سی روز اینجا نمایش داده می‌شود.';

  @override
  String get txNoRulesYet => 'هنوز قانونی نیست';

  @override
  String get txClearAll => 'پاک کردن همه';

  @override
  String get txApplyFilters => 'اعمال فیلترها';

  @override
  String get txUpcomingOverdue => 'پیش رو و معوق';

  @override
  String get txNew => 'جدید';

  @override
  String get txLoan => 'وام';

  @override
  String get goalStarted => 'شروع';

  @override
  String get goalTargetDate => 'تاریخ هدف';

  @override
  String get goalWithADateTheGoal =>
      'با تعیین تاریخ، هدف محاسبه می‌کند روزانه چقدر کنار بگذارید.';

  @override
  String get goalCountedTowardThisGoal => 'محاسبه‌شده برای این هدف';

  @override
  String get goalGettingThere => 'در حال نزدیک شدن';

  @override
  String get goalSetATargetDateAnd =>
      'یک تاریخ هدف تعیین کنید تا مبلغ پس‌انداز لازم محاسبه شود.';

  @override
  String get reportSpendingInsights => 'تحلیل هزینه‌ها';

  @override
  String get reportNoSpendingDataForThis =>
      'برای این دوره داده هزینه‌ای وجود ندارد';

  @override
  String get reportNoCategorySpendingData => 'داده هزینه دسته‌ها وجود ندارد';

  @override
  String get reportNoSpendingDataAvailable => 'داده هزینه‌ای در دسترس نیست';

  @override
  String get reportBudgetVsActual => 'بودجه در برابر واقعی';

  @override
  String get reportNoActiveBudgets => 'بودجه فعالی وجود ندارد';

  @override
  String get reportCreateABudgetToTrack =>
      'برای پیگیری هزینه‌ها یک بودجه بسازید';

  @override
  String get budgetSpendingFasterThanThePeriod =>
      'سرعت خرج کردن از گذر دوره بیشتر است.';

  @override
  String get budgetNothingRecordedInThisPeriod =>
      'در این دوره چیزی ثبت نشده است.';

  @override
  String budgetCardSemantics(String name, String spent, String limit) {
    return '$name، $spent از $limit مصرف شده';
  }

  @override
  String budgetAmountLeft(String amount) {
    return '$amount باقی‌مانده';
  }

  @override
  String budgetAmountOver(String amount) {
    return '$amount بیش از سقف';
  }

  @override
  String get budgetPeriodEnded => 'دوره تمام شد';

  @override
  String get budgetPaceOver => 'بیش از حد';

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز مانده',
      one: '1 روز مانده',
    );
    return '$_temp0';
  }

  @override
  String get authPasswordResetSuccessfullyPleaseSign =>
      'رمز عبور با موفقیت بازنشانی شد. لطفاً وارد شوید.';

  @override
  String get authResendCode => 'ارسال دوباره کد';

  @override
  String get authForgotPassword => 'رمز عبور را فراموش کرده‌اید؟';

  @override
  String get authOrContinueWith => 'یا ادامه با';

  @override
  String get authContinueWithGoogle => 'ادامه با Google';

  @override
  String get authContinueWithApple => 'ادامه با Apple';

  @override
  String get authSignUp => 'ثبت‌نام';

  @override
  String get authPleaseAcceptTheTermsAnd => 'لطفاً شرایط و قوانین را بپذیرید';

  @override
  String get authPasswordStrength => 'قدرت رمز عبور';

  @override
  String get authAlreadyHaveAnAccount => 'حساب کاربری دارید؟ ';

  @override
  String get authPersonalInformation => 'اطلاعات شخصی';

  @override
  String get authUpgradeToPremium => 'ارتقا به Premium';

  @override
  String get authUnlockUnlimitedBudgetsAdvancedAnalytics =>
      'بودجه‌های نامحدود، تحلیل‌های پیشرفته و موارد بیشتر را باز کنید!';

  @override
  String get authUpgradeNow => 'همین حالا ارتقا دهید';

  @override
  String get authPremiumMember => 'عضو Premium';

  @override
  String get authEnjoyingAllPremiumFeatures =>
      'در حال استفاده از همه قابلیت‌های Premium';

  @override
  String get authSaveChanges => 'ذخیره تغییرات';

  @override
  String get authAreYouSureYouWant =>
      'مطمئنید می‌خواهید از حساب کاربری خود خارج شوید؟';

  @override
  String get authChangeProfilePhoto => 'تغییر عکس نمایه';

  @override
  String get authTakePhoto => 'گرفتن عکس';

  @override
  String get authUseYourCamera => 'استفاده از دوربین';

  @override
  String get authChooseFromGallery => 'انتخاب از گالری';

  @override
  String get authSelectAnExistingPhoto => 'انتخاب یک عکس موجود';

  @override
  String get authPhotoSelectedUploadFeatureComing =>
      'عکس انتخاب شد! قابلیت بارگذاری به‌زودی می‌آید.';

  @override
  String get authNameCannotBeEmpty => 'نام نمی‌تواند خالی باشد';

  @override
  String get authProfileUpdatedSuccessfully =>
      'نمایه با موفقیت به‌روزرسانی شد!';

  @override
  String get authTheAccountant => 'THE ACCOUNTANT';

  @override
  String get legalPrivacyTerms => 'حریم خصوصی و شرایط';

  @override
  String get legalReviewTheseBeforeYouContinue =>
      'پیش از ادامه این موارد را مطالعه کنید.';

  @override
  String get premiumLimitReached => 'به سقف رسیدید';

  @override
  String get aiChats => 'گفتگوها';

  @override
  String get aiNewChat => 'گفتگوی جدید';

  @override
  String get aiNoConversationsYet => 'هنوز گفتگویی نیست';

  @override
  String get aiStartChattingAndYourThreads =>
      'گفتگو را شروع کنید تا رشته‌هایتان اینجا نمایش داده شوند.';

  @override
  String get aiScanAReceipt => 'اسکن یک رسید';

  @override
  String get aiReadingYourReceipt => 'در حال خواندن رسید شما…';

  @override
  String get aiReviewSave => 'بررسی و ذخیره';

  @override
  String get aiWeReadThisFromYour =>
      'این را از رسید شما خواندیم — پیش از ذخیره بررسی و در صورت نیاز ویرایش کنید.';

  @override
  String get dashErrorLoadingFinancialData => 'خطا در بارگیری داده‌های مالی';

  @override
  String get dashNoSpendingDataYet => 'هنوز داده هزینه‌ای نیست';

  @override
  String get dashManage => 'مدیریت';

  @override
  String get dashAvailable => 'در دسترس: ****';

  @override
  String get onboardWelcome => 'خوش آمدید!';

  @override
  String get onboardSelectYourDefaultCurrency =>
      'واحد پول پیش‌فرض خود را انتخاب کنید';

  @override
  String get onboardLoadingCurrencies => 'در حال بارگیری ارزها...';

  @override
  String get onboardSetUpYourPrimaryWallet => 'کیف پول اصلی خود را تنظیم کنید';

  @override
  String get onboardInitialBalanceOptional => 'موجودی اولیه (اختیاری)';

  @override
  String get onboardYourAccountIsReadyTo => 'حساب شما آماده استفاده است';

  @override
  String get onboardTipYouCanAddMore =>
      'نکته: هر زمان بخواهید می‌توانید از بخش کیف پول‌ها حساب‌های بیشتری با ارزهای مختلف اضافه کنید.';

  @override
  String get creditSettled => 'تسویه‌شده';

  @override
  String get creditOverdue => 'معوق';

  @override
  String creditTabCredit(int count) {
    return 'طلب‌ها ($count)';
  }

  @override
  String creditTabDebt(int count) {
    return 'بدهی‌ها ($count)';
  }

  @override
  String get creditNetOutstanding => 'خالص مانده';

  @override
  String get creditAllSettled => 'همه تسویه شده';

  @override
  String get creditOthersOweYou => 'دیگران به شما بدهکارند';

  @override
  String get creditYouOweOthers => 'شما به دیگران بدهکارید';

  @override
  String creditOverdueCount(int count) {
    return '$count معوق';
  }

  @override
  String get creditEmptyAll => 'هیچ پولی قرض داده یا گرفته نشده';

  @override
  String get creditEmptyLent => 'پولی قرض داده نشده';

  @override
  String get creditEmptyBorrowed => 'پولی قرض گرفته نشده';

  @override
  String get creditEmptyAllSettled => 'همه چیز تسویه شده است.';

  @override
  String get creditEmptyHint =>
      'پولی را که قرض داده یا گرفته‌اید ثبت کنید تا بدانید چه کسی به چه کسی بدهکار است.';

  @override
  String get creditShowAll => 'نمایش همه';

  @override
  String get creditShowUnpaid => 'فقط پرداخت‌نشده‌ها';

  @override
  String get creditMoneyLent => 'پول قرض داده‌شده';

  @override
  String get creditMoneyBorrowed => 'پول قرض گرفته‌شده';

  @override
  String get creditTheyOweYou => 'به شما بدهکار است';

  @override
  String get creditYouOwe => 'شما بدهکارید';

  @override
  String get creditCollected => 'دریافت‌شده';

  @override
  String creditPaidOf(String paid, String total) {
    return '$paid از $total پرداخت شده';
  }

  @override
  String get creditRecord => 'ثبت';

  @override
  String get subRecurring => 'تکرارشونده';

  @override
  String get subPaused => 'متوقف';

  @override
  String get subAsksFirst => 'اول می‌پرسد';

  @override
  String get subFrequency => 'تناوب';

  @override
  String get notifMarkAllRead => 'خواندن همه';

  @override
  String get notifTryAgain => 'تلاش دوباره';

  @override
  String get notifStayOnTopOfYour => 'پولتان را زیر نظر داشته باشید';

  @override
  String get notifNoNotificationsYet => 'هنوز اعلانی نیست';

  @override
  String get notifWhenYouReceiveNotificationsThey =>
      'اعلان‌هایی که دریافت کنید اینجا نمایش داده می‌شوند.';

  @override
  String get startupNothingHasBeenChangedOr => 'چیزی تغییر یا حذف نشده است.';

  @override
  String get sharedIncludeCryptoCurrencies => 'شامل ارزهای دیجیتال';

  @override
  String get sharedTotalBalance => 'موجودی کل';

  @override
  String get heatmapTitle => 'ریتم روزانه';

  @override
  String get heatmapSpentMore => 'خرج بیشتر';

  @override
  String get heatmapEarnedMore => 'درآمد بیشتر';

  @override
  String amountsLeftOutNoRate(int count, String currency) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count تراکنش نمایش داده نمی‌شوند: نرخی بین ارز حساب‌های آن‌ها و $currency موجود نیست',
      one:
          'یک تراکنش نمایش داده نمی‌شود: نرخی بین ارز حساب آن و $currency موجود نیست',
    );
    return '$_temp0.';
  }

  @override
  String get heatmapNothingYet => 'هنوز در این دوره چیزی ثبت نشده است.';

  @override
  String get heatmapNetForRange => 'خالص در این بازه';

  @override
  String get layoutTitle => 'چیدمان صفحه اصلی';

  @override
  String get layoutSubtitle =>
      'صفحه اصلی را مرتب کنید یا چیزهایی را که استفاده نمی‌کنید پنهان کنید';

  @override
  String get layoutExplain =>
      'برای مرتب‌سازی بکشید. هر بخشی که خاموش شود جایش حفظ می‌شود، پس با روشن کردن دوباره همان‌جا قرار می‌گیرد.';

  @override
  String get layoutReset => 'بازنشانی به پیش‌فرض';

  @override
  String get layoutAllHidden =>
      'همه بخش‌ها پنهان هستند. صفحه اصلی خالی خواهد بود.';

  @override
  String get layoutSectionGreeting => 'خوشامدگویی';

  @override
  String get layoutSectionAccounts => 'حساب‌ها';

  @override
  String get layoutSectionQuickStats => 'درآمد و هزینه';

  @override
  String get layoutSectionQuickLinks => 'میان‌برها';

  @override
  String get layoutSectionSpendingChart => 'نمای کلی هزینه‌ها';

  @override
  String get layoutSectionRecent => 'تراکنش‌های اخیر';

  @override
  String get layoutSectionBudgets => 'پیشرفت بودجه';

  @override
  String get layoutSectionGoals => 'اهداف سنجاق‌شده';

  @override
  String get shortcutAddExpense => 'افزودن هزینه';

  @override
  String get shortcutAddIncome => 'افزودن درآمد';

  @override
  String get shortcutScanReceipt => 'اسکن رسید';

  @override
  String get shortcutTransactions => 'تراکنش‌ها';

  @override
  String get backupBusySyncing =>
      'همگام‌سازی در حال انجام است. پیش از بازیابی صبر کنید تا تمام شود.';

  @override
  String get appearanceTitle => 'ظاهر';

  @override
  String get themeSunriseLight => 'طلوع روشن';

  @override
  String get themeSunriseDark => 'طلوع تیره';

  @override
  String get themeMatchSystem => 'مطابق سیستم';

  @override
  String get themeMatchSystemHint => 'تغییر بین روشن و تیره همراه با گوشی';

  @override
  String get themeUnlockAll => 'باز کردن همه تم‌ها';

  @override
  String get themeProBadge => 'حرفه‌ای';

  @override
  String get themeAccentSunrise => 'طلوع';

  @override
  String get themeAccentSapphire => 'یاقوت کبود';

  @override
  String get themeAccentEmerald => 'زمرد';

  @override
  String get themeAccentRuby => 'یاقوت سرخ';

  @override
  String get themeAccentAmethyst => 'آمتیست';

  @override
  String get themeAccentGraphite => 'گرافیت';

  @override
  String themeAppearanceValue(String accent, String mode) {
    return '$accent $mode';
  }

  @override
  String get navToday => 'امروز';

  @override
  String get navAdd => 'افزودن';

  @override
  String get navStats => 'آمار';

  @override
  String get navMore => 'بیشتر';

  @override
  String get walkthroughTodayTitle => 'روزتان در یک نگاه';

  @override
  String get walkthroughTodayBody =>
      'دارایی خالص، درآمد و هزینه‌تان و فعالیت‌های امروز.';

  @override
  String get walkthroughAddTitle => 'ثبت در چند ثانیه';

  @override
  String get walkthroughAddBody =>
      'برای ثبت هزینه، درآمد یا انتقال روی «افزودن» بزنید.';

  @override
  String get walkthroughTransactionsTitle => 'تراکنش‌های شما';

  @override
  String get walkthroughTransactionsBody =>
      'همه تراکنش‌ها، ماه به ماه. با جستجو و فیلتر هر چیزی را پیدا کنید.';

  @override
  String get walkthroughStatsTitle => 'ببینید پولتان کجا می‌رود';

  @override
  String get walkthroughStatsBody =>
      'نمودارهای هفتگی، ماهانه و سالانه، بر اساس دسته.';

  @override
  String get walkthroughBellTitle => 'در جریان باشید';

  @override
  String get walkthroughBellBody =>
      'هشدارهای بودجه و یادآوری‌ها اینجا نمایش داده می‌شوند. همه چیز آماده است!';

  @override
  String get walkthroughBalanceTitle => 'دارایی خالص شما';

  @override
  String get walkthroughBalanceBody =>
      'همه کیف پول‌ها اینجا جمع می‌شوند، با نواری که سهم هر کدام را نشان می‌دهد.';

  @override
  String get txTransfer => 'انتقال';

  @override
  String get txUncategorized => 'بدون دسته';

  @override
  String todayGoodMorning(String name) {
    return 'صبح بخیر، $name';
  }

  @override
  String todayGoodAfternoon(String name) {
    return 'ظهر بخیر، $name';
  }

  @override
  String todayGoodEvening(String name) {
    return 'عصر بخیر، $name';
  }

  @override
  String get todayGoodMorningPlain => 'صبح بخیر';

  @override
  String get todayGoodAfternoonPlain => 'ظهر بخیر';

  @override
  String get todayGoodEveningPlain => 'عصر بخیر';

  @override
  String get todayNetWorth => 'دارایی خالص';

  @override
  String todayThisMonthDelta(String amount) {
    return '$amount در این ماه';
  }

  @override
  String get todayEarned => 'درآمد';

  @override
  String get todaySpent => 'هزینه';

  @override
  String get todayTitle => 'امروز';

  @override
  String get todayRecent => 'اخیر';

  @override
  String get todayAllActivity => 'همه فعالیت‌ها';

  @override
  String get todayNothingYet => 'امروز هنوز چیزی نیست';

  @override
  String get todayNothingYetBody => 'برای ثبت اولین مورد روی «افزودن» بزنید.';

  @override
  String todayMoreWallets(int count) {
    return '+$count مورد دیگر';
  }

  @override
  String get todayCoachTitle => 'از مشاور مالی‌تان بپرسید';

  @override
  String get todayCoachBody => 'پاسخ‌ها و پیشنهادهایی بر اساس هزینه‌های خودتان';

  @override
  String get todayNotifications => 'اعلان‌ها';

  @override
  String get todayWithinBudget => 'در محدوده بودجه';

  @override
  String get todayOverBudget => 'فراتر از بودجه';

  @override
  String get todayNetCredit => 'خالص طلب';

  @override
  String get todayNetDebt => 'خالص بدهی';

  @override
  String get todayMonthly => 'ماهانه';

  @override
  String get walletsTitle => 'کیف پول‌ها';

  @override
  String get walletsNew => 'جدید';

  @override
  String get walletsAddHint => 'افزودن بانک، نقد، پس‌انداز…';

  @override
  String get walletsPlanning => 'برنامه‌ریزی';

  @override
  String get walletsUpcoming => 'پیش رو';

  @override
  String walletsUpcomingSub(int count, String amount) {
    return '$count سررسید · $amount';
  }

  @override
  String get walletsUpcomingNone => 'به‌زودی سررسیدی نیست';

  @override
  String get walletsLendBorrow => 'قرض دادن و گرفتن';

  @override
  String get splitTitle => 'تقسیم صورت‌حساب';

  @override
  String get splitSubtitle =>
      'صورت‌حساب را با دوستان تقسیم کنید؛ بدهی آن‌ها به «قرض دادن و گرفتن» می‌رود';

  @override
  String get splitWhatFor => 'بابت چه بود';

  @override
  String get splitTotal => 'مجموع';

  @override
  String get splitPeople => 'افراد';

  @override
  String get splitYou => 'شما';

  @override
  String get splitIncludeMe => 'من هم سهم داشتم';

  @override
  String get splitIncludeMeSub => 'اگر فقط برای دیگران پرداخت کردید خاموش کنید';

  @override
  String get splitAddPerson => 'افزودن فرد';

  @override
  String get splitPersonName => 'نام';

  @override
  String get splitKnownPeople => 'از «قرض دادن و گرفتن»';

  @override
  String get splitRemove => 'حذف';

  @override
  String get splitPaidBy => 'پرداخت‌کننده';

  @override
  String get splitHow => 'نحوه تقسیم';

  @override
  String get splitEqual => 'مساوی';

  @override
  String get splitExact => 'مبلغ';

  @override
  String get splitPercent => 'درصد';

  @override
  String get splitShares => 'سهم';

  @override
  String get splitYourShare => 'سهم شما';

  @override
  String get splitOwesYou => 'به شما بدهکار است';

  @override
  String splitYouOwe(String name) {
    return 'شما به $name بدهکارید';
  }

  @override
  String get splitPaidTheBill => 'صورت‌حساب را پرداخت کرد';

  @override
  String splitSettlesWith(String name) {
    return 'تسویه با $name';
  }

  @override
  String splitSummaryIPaid(String total, String owed) {
    return '$total از حساب شما؛ $owed باید به شما برگردد';
  }

  @override
  String splitSummaryTheyPaid(String name, String amount) {
    return 'فعلاً چیزی از حسابتان کم نمی‌شود؛ شما $amount به $name بدهکارید';
  }

  @override
  String get splitPercentLabel => 'درصد از صورت‌حساب';

  @override
  String get splitSave => 'تقسیم کن';

  @override
  String get splitSaved => 'تقسیم ثبت شد';

  @override
  String get splitNeedCategory => 'ابتدا یک دسته انتخاب کنید.';

  @override
  String get splitThisBill => 'تقسیم این صورت‌حساب';

  @override
  String get splitThisBillSub =>
      'با دوستان؛ بدهی آن‌ها به «قرض دادن و گرفتن» می‌رود';

  @override
  String get splitPartOf => 'صورت‌حساب تقسیم‌شده';

  @override
  String walletsOwedToYou(String amount) {
    return '$amount طلب دارید';
  }

  @override
  String walletsYouOwe(String amount) {
    return '$amount بدهکارید';
  }

  @override
  String get walletsAllSettled => 'همه تسویه شده';

  @override
  String get walletsGoals => 'اهداف';

  @override
  String walletsGoalsSub(int count) {
    return '$count فعال';
  }

  @override
  String get walletsBudgets => 'بودجه‌ها';

  @override
  String get walletsSubscriptions => 'اشتراک‌ها';

  @override
  String get walletsTransfer => 'انتقال بین کیف پول‌ها';

  @override
  String get walletsArchived => 'بایگانی‌شده';

  @override
  String walletsDeleteMessage(String name) {
    return '«$name» حذف شود؟ همه تراکنش‌های این حساب هم با آن حذف می‌شوند.';
  }

  @override
  String walletsDeleted(String name) {
    return '$name حذف شد';
  }

  @override
  String walletsSetDefaultDone(String name) {
    return '$name اکنون پیش‌فرض شماست';
  }

  @override
  String get walletsCreateFailed =>
      'ایجاد حساب ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get walletsEmptyBody => 'برای شروع پیگیری، اولین حسابتان را بسازید.';

  @override
  String get walletsTypeBank => 'حساب بانکی';

  @override
  String get walletsTypeCard => 'کارت اعتباری';

  @override
  String get walletsTypeCash => 'نقد';

  @override
  String get walletsTypeOther => 'حساب';

  @override
  String get moreTitle => 'بیشتر';

  @override
  String get moreGoPremium => 'ارتقا به Premium';

  @override
  String get moreGoPremiumBody => 'دستیار هوش مصنوعی، همگام‌سازی ابری، تم‌ها';

  @override
  String get moreUnlock => 'باز کردن';

  @override
  String get morePremiumActive => 'Premium فعال است';

  @override
  String get morePremiumThanks => 'از حمایت شما از The Accountant سپاسگزاریم';

  @override
  String get sectionPreferences => 'ترجیحات';

  @override
  String get sectionTools => 'ابزارهای مالی';

  @override
  String get moreAiAssistant => 'دستیار هوش مصنوعی';

  @override
  String get moreAiAssistantSub => 'درباره پولتان سؤال بپرسید';

  @override
  String get moreSignOutConfirm =>
      'از حساب کاربری‌تان در این دستگاه خارج می‌شوید؟';

  @override
  String get moreSignOutFailed => 'خروج ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get moreDeviceOnlyBody =>
      'از حساب‌های رایگان در فضای ابری پشتیبان گرفته نمی‌شود، پس با نصب دوباره یا تعویض گوشی ممکن است داده‌هایتان از دست برود. برای همگام‌سازی ابری ارتقا دهید یا به‌طور منظم پشتیبان بگیرید.';

  @override
  String get moreUpgradeToPremium => 'ارتقا به Premium';

  @override
  String get moreUser => 'شما';

  @override
  String get statsTitle => 'آمار';

  @override
  String get statsWeek => 'هفته';

  @override
  String get statsMonth => 'ماه';

  @override
  String get statsYear => 'سال';

  @override
  String get statsSpending => 'هزینه';

  @override
  String get statsIncome => 'درآمد';

  @override
  String get statsCategories => 'دسته‌ها';

  @override
  String get statsSpent => 'هزینه';

  @override
  String get statsEarned => 'درآمد';

  @override
  String get statsNet => 'خالص';

  @override
  String get statsThisMonth => 'این ماه';

  @override
  String statsVsLastMonth(String change) {
    return '$change نسبت به ماه قبل';
  }

  @override
  String get statsInsightsSub => 'خلاصه، روندها و نکات این ماه';

  @override
  String get statsAskCoach => 'درباره این از مشاور هوش مصنوعی بپرسید';

  @override
  String statsOverBy(String amount) {
    return '$amount بیش از سقف';
  }

  @override
  String statsRemaining(String percent) {
    return '$percent% باقی‌مانده';
  }

  @override
  String get activityAll => 'همه';

  @override
  String get activitySpent => 'هزینه';

  @override
  String get activityEarned => 'درآمد';

  @override
  String get activityTransfers => 'انتقال‌ها';

  @override
  String activitySoFar(String month) {
    return '$month تا امروز';
  }

  @override
  String activityNet(String amount) {
    return '$amount خالص';
  }

  @override
  String activitySearchFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد در همه ماه‌ها',
      one: '1 مورد در همه ماه‌ها',
    );
    return '$_temp0';
  }

  @override
  String get statsPeriodLast7Days => '7 روز گذشته';

  @override
  String get statsPeriodThisMonth => 'این ماه';

  @override
  String get statsPeriodThisYear => 'امسال';

  @override
  String statsCategoryCount(String period, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش',
      one: '1 تراکنش',
    );
    return '$period · $_temp0';
  }

  @override
  String activitySearchNothingTitle(String query) {
    return 'هیچ موردی با «$query» مطابقت ندارد';
  }

  @override
  String get activitySearchNothingBody =>
      'همه ماه‌ها جستجو شد. کلمات کمتر یا املای دیگری امتحان کنید، یا یک فیلتر را بردارید.';

  @override
  String get activityIn => 'ورودی';

  @override
  String get activityOut => 'خروجی';

  @override
  String get activityToday => 'امروز';

  @override
  String get activityYesterday => 'دیروز';

  @override
  String get activityTomorrow => 'فردا';

  @override
  String get activityEmptyFutureTitle => 'تراکنش برنامه‌ریزی‌شده‌ای نیست';

  @override
  String activityEmptyFutureBody(String month) {
    return 'پرداخت‌های آینده را برای $month اضافه کنید';
  }

  @override
  String get activityEmptyNowTitle => 'هنوز تراکنشی نیست';

  @override
  String get activityEmptyNowBody => 'ثبت هزینه‌های این ماه را شروع کنید';

  @override
  String get activityEmptyPastTitle => 'تراکنشی یافت نشد';

  @override
  String activityEmptyPastBody(String month) {
    return 'برای $month سابقه‌ای نیست';
  }

  @override
  String activityDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش حذف شد',
      one: '1 تراکنش حذف شد',
    );
    return '$_temp0';
  }

  @override
  String activityMovedToCategory(int count, String name) {
    return '$count مورد به $name منتقل شد';
  }

  @override
  String get activityMixedCurrencies =>
      'این موارد با ارزهای مختلف هستند، پس حسابی وجود ندارد که همه بتوانند به آن منتقل شوند. ردیف‌های یک ارز را انتخاب کنید.';

  @override
  String activityMovedPartial(int count) {
    return '$count مورد منتقل شد؛ انتقال‌ها سر جای خود ماندند';
  }

  @override
  String activityMoved(int count) {
    return '$count مورد به حساب دیگری منتقل شد';
  }

  @override
  String activityRedated(int count) {
    return 'تاریخ $count مورد تغییر کرد';
  }

  @override
  String get activityNothingToPay => 'چیزی در انتظار پرداخت نبود';

  @override
  String activityMarkedPaid(int count) {
    return '$count مورد پرداخت‌شده علامت خورد';
  }

  @override
  String activityCopiedPartial(int count) {
    return '$count مورد کپی شد؛ انتقال‌ها به‌تنهایی کپی نمی‌شوند';
  }

  @override
  String activityCopied(int count) {
    return '$count مورد کپی شد';
  }

  @override
  String get activityDeleteOneBody =>
      'از سوابق شما حذف می‌شود و موجودی دوباره محاسبه می‌شود.';

  @override
  String get activitySearch => 'جستجو';

  @override
  String get addNewExpense => 'هزینه جدید';

  @override
  String get addNewIncome => 'درآمد جدید';

  @override
  String get addNewTransfer => 'انتقال جدید';

  @override
  String get addEditTitle => 'ویرایش تراکنش';

  @override
  String get addAmount => 'مبلغ';

  @override
  String get addCategory => 'دسته';

  @override
  String get addMore => 'بیشتر';

  @override
  String get addWallet => 'کیف پول';

  @override
  String addChangeDate(String date) {
    return 'تغییر تاریخ، $date';
  }

  @override
  String addChangeTime(String time) {
    return 'تغییر ساعت، $time';
  }

  @override
  String get addSwapAccounts => 'جابه‌جایی دو حساب';

  @override
  String get notifCheckTitle => 'بررسی اعلان‌ها';

  @override
  String get notifAllowed => 'اعلان‌ها مجاز هستند';

  @override
  String get notifAllowedHint => 'یادآوری‌ها می‌توانند به این گوشی برسند';

  @override
  String get notifBlocked => 'اعلان‌ها خاموش هستند';

  @override
  String get notifBlockedHint =>
      'برای مجاز کردن بزنید، وگرنه چیزی به شما نمی‌رسد';

  @override
  String get notifSendTest => 'ارسال اعلان آزمایشی';

  @override
  String get notifSendTestHint =>
      'از سرور ما ارسال می‌شود، همان‌طور که یادآوری‌ها می‌آیند';

  @override
  String get notifSending => 'در حال ارسال…';

  @override
  String get notifTestSent =>
      'ارسال شد. باید تا چند ثانیه دیگر نمایش داده شود و در صندوق اعلان‌هایتان هم باشد.';

  @override
  String notifTestFailed(String reason) {
    return 'ارسال ممکن نشد: $reason';
  }

  @override
  String get notifTestOffline => 'اتصال به سرور برقرار نیست';

  @override
  String get notifDailyPrimerBody =>
      'The Accountant هر روز در زمانی که انتخاب می‌کنید، با یک یادآوری ملایم شما را به ثبت هزینه‌ها دعوت می‌کند. برای این کار به اجازه نمایش اعلان نیاز دارد.';

  @override
  String get notifPrimerShow => 'نمایش اعلان‌های یادآوری';

  @override
  String get notifPrimerTime => 'در زمان انتخابی شما می‌رسد';

  @override
  String get notifPrimerOff => 'هر زمان می‌توانید خاموشش کنید';

  @override
  String get notifPrimerAllow => 'اجازه دادن';

  @override
  String get cardBillsTitle => 'صورت‌حساب کارت‌ها';

  @override
  String get cardBillsSubtitle =>
      'صورت‌حساب‌های کارت اعتباری، سررسیدها و یادآوری‌ها';

  @override
  String get cardBillsEmptyTitle => 'هنوز کارت اعتباری ندارید';

  @override
  String get cardBillsEmptyBody =>
      'یک حساب از نوع کارت اعتباری اضافه کنید، روز صورت‌حساب و روز سررسید را تنظیم کنید تا صورت‌حساب‌هایش اینجا نمایش داده شوند.';

  @override
  String get cardBillsAddCard => 'افزودن کارت';

  @override
  String get cardStatementDay => 'روز صورت‌حساب';

  @override
  String get cardStatementDayHint =>
      'روزی از ماه که صورت‌حساب صادر می‌شود. همه چیز تا پایان آن روز در آن قرار می‌گیرد.';

  @override
  String get cardDueDay => 'روز سررسید پرداخت';

  @override
  String get cardDueDayHint =>
      'آخرین روز پرداخت صورت‌حساب؛ اولین باری که آن روز پس از صدور صورت‌حساب فرا می‌رسد.';

  @override
  String get cardRemindTitle => 'یادآوری کن';

  @override
  String get cardRemindHint =>
      'قبل از سررسید، اگر بخشی از صورت‌حساب هنوز پرداخت نشده باشد. حدود ساعت 9 صبح ارسال می‌شود.';

  @override
  String get cardRemindOff => 'خاموش';

  @override
  String cardRemindDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز قبل',
      one: 'یک روز قبل',
    );
    return '$_temp0';
  }

  @override
  String get cardNotSet => 'تنظیم نشده';

  @override
  String cardDayOfMonth(int day) {
    return 'روز $day';
  }

  @override
  String get cardSetUpBody =>
      'روز صورت‌حساب و روز سررسید را تنظیم کنید تا صورت‌حساب‌های این کارت را ببینید و پیش از سررسید یادآوری دریافت کنید.';

  @override
  String get cardSetUp => 'تنظیم تاریخ‌ها';

  @override
  String cardDueBy(String date) {
    return 'مانده پرداخت تا $date';
  }

  @override
  String get cardLeftToPay => 'مانده پرداخت';

  @override
  String cardStatementClosed(String date) {
    return 'صورت‌حساب $date';
  }

  @override
  String get cardPaidSince => 'پرداخت‌شده از آن زمان';

  @override
  String cardThisCycle(String date) {
    return 'هزینه از آن زمان، صورت‌حساب بعدی $date';
  }

  @override
  String cardPaymentTitle(String card) {
    return 'پرداخت صورت‌حساب $card';
  }

  @override
  String get cardEdit => 'ویرایش کارت';

  @override
  String get cardEarlierStatements => 'صورت‌حساب‌های قبلی';

  @override
  String get cardPaidShort => 'پرداخت‌شده';

  @override
  String cardUnpaidShort(String amount) {
    return '$amount پرداخت‌نشده';
  }

  @override
  String get cardStatusNotSetUp => 'تاریخ‌ها تنظیم نشده';

  @override
  String get cardStatusNothingDue => 'سررسیدی نیست';

  @override
  String get cardStatusPaid => 'پرداخت‌شده';

  @override
  String cardStatusDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'سررسید تا $days روز دیگر',
      one: 'سررسید فردا',
    );
    return '$_temp0';
  }

  @override
  String get cardStatusDueToday => 'سررسید امروز';

  @override
  String get cardStatusOverdue => 'معوق';

  @override
  String cardPaidOf(String paid, String owed) {
    return '$paid از $owed پرداخت شده';
  }

  @override
  String get cardPayBill => 'پرداخت صورت‌حساب';

  @override
  String cardPayTitle(String card) {
    return 'پرداخت $card';
  }

  @override
  String get cardPayHint =>
      'تمام یا بخشی از آن را بپردازید. هر مبلغی که بپردازید از این صورت‌حساب کم می‌شود و بقیه همچنان سررسید باقی می‌ماند.';

  @override
  String cardPayFull(String amount) {
    return 'پرداخت کامل، $amount';
  }

  @override
  String get cardPayFullHint => 'همه مانده این صورت‌حساب';

  @override
  String get cardPayOther => 'پرداخت مبلغ دیگر';

  @override
  String get cardPayOtherHint => 'پرداخت بخشی، یا بیشتر از صورت‌حساب';

  @override
  String get addNoteHint => 'افزودن یادداشت';

  @override
  String get addRepeatMonthly => 'تکرار ماهانه';

  @override
  String get addMoreOptions => 'گزینه‌های بیشتر';

  @override
  String get addScanReceipt => 'اسکن رسید';

  @override
  String get addDelete => 'حذف تراکنش';

  @override
  String get addTypeExpense => 'هزینه';

  @override
  String get addTypeIncome => 'درآمد';

  @override
  String get addTypeTransfer => 'انتقال';

  @override
  String get gatePremium => 'Premium';

  @override
  String get gateUnlock => 'باز کردن با Premium';

  @override
  String get gateFootnote => 'مادام‌العمر یا اشتراکی · بازیابی در هر زمان';

  @override
  String get aiCoachTitle => 'با مشاور مالی‌تان آشنا شوید';

  @override
  String get aiCoachBody =>
      'به زبان ساده بپرسید. پاسخ‌ها، پیشنهادها و برنامه‌هایی بر اساس هزینه‌های خودتان بگیرید.';

  @override
  String get aiAssistantTitle => 'دستیار هوش مصنوعی';

  @override
  String get aiAskAnything => 'درباره پولتان بپرسید…';

  @override
  String get aiSend => 'ارسال';

  @override
  String get aiCopy => 'کپی';

  @override
  String get aiCopied => 'کپی شد';

  @override
  String get aiRetry => 'تلاش دوباره';

  @override
  String get aiDismiss => 'بستن';

  @override
  String get aiTyping => 'مشاور در حال نوشتن است';

  @override
  String aiStarterCategory(String category) {
    return 'پول $category من کجا رفت؟';
  }

  @override
  String get aiStarterBudgets => 'آیا طبق بودجه‌هایم پیش می‌روم؟';

  @override
  String get aiStarterUpcoming => 'چه صورت‌حساب‌هایی در پیش است؟';

  @override
  String get aiStarterAnalyze => 'الگوهای هزینه اخیرم را تحلیل کن';

  @override
  String get aiStarterBudgetTips => 'برای بودجه‌بندی بهتر نکته بده';

  @override
  String get aiStarterSave => 'چطور می‌توانم بیشتر پس‌انداز کنم؟';

  @override
  String aiDeleteChatBody(String title) {
    return '«$title» برای همیشه حذف می‌شود.';
  }

  @override
  String get aiJustNow => 'همین حالا';

  @override
  String get aiErrorTitle => 'مشاور نتوانست پاسخ دهد';

  @override
  String get paywallTitle => 'Accountant Premium';

  @override
  String get paywallTagline => 'همه توانایی‌های برنامه، برای شما.';

  @override
  String get paywallActiveTitle => 'Premium فعال است';

  @override
  String get paywallActiveTagline => 'از حمایت شما سپاسگزاریم!';

  @override
  String get paywallRestore => 'بازیابی';

  @override
  String get paywallProcessing => 'در حال پردازش…';

  @override
  String paywallTriggered(String feature) {
    return '$feature یک قابلیت Premium است';
  }

  @override
  String paywallDaysRemaining(int days) {
    return '$days روز باقی‌مانده';
  }

  @override
  String get paywallFeatSync => 'همگام‌سازی ابری';

  @override
  String get paywallFeatSyncSub => 'همه دستگاه‌ها';

  @override
  String get paywallFeatAi => 'دستیار هوش مصنوعی';

  @override
  String get paywallFeatAiSub => 'نامحدود، بدون تبلیغ';

  @override
  String get paywallFeatOcr => 'اسکن رسید';

  @override
  String get paywallFeatOcrSub => 'OCR با هوش مصنوعی';

  @override
  String get paywallFeatInsights => 'تحلیل هزینه‌ها';

  @override
  String get paywallFeatInsightsSub => 'روندهای ماهانه';

  @override
  String get paywallFeatThemes => '5 تم';

  @override
  String get paywallFeatThemesSub => 'اختصاصی';

  @override
  String get paywallFeatPdf => 'گزارش‌های PDF';

  @override
  String get paywallFeatPdfSub => 'CSV رایگان می‌ماند';

  @override
  String get paywallFeatUnlimited => 'نامحدود';

  @override
  String get paywallFeatUnlimitedSub => 'کیف پول‌ها، بودجه‌ها';

  @override
  String get paywallFeatSupport => 'پشتیبانی ویژه';

  @override
  String get paywallFeatSupportSub => 'پاسخ سریع‌تر';

  @override
  String get paywallPerMonth => '/ماه';

  @override
  String get paywallPerYear => '/سال';

  @override
  String get paywallOnce => 'یک‌بار';

  @override
  String get paywallBestValue => 'بهترین ارزش';

  @override
  String get paywallForever => 'برای همیشه';

  @override
  String get paywallMonthlyDesc => 'پرداخت ماهانه';

  @override
  String get paywallYearlyDesc => 'پرداخت سالانه';

  @override
  String get paywallLifetimeDesc => 'یک بار بپردازید، برای همیشه داشته باشید';

  @override
  String paywallTrial(String trial, String rest) {
    return '$trial رایگان، سپس $rest';
  }

  @override
  String get paywallCtaLifetime => 'دریافت دسترسی مادام‌العمر';

  @override
  String get paywallCtaYearly => 'شروع طرح سالانه';

  @override
  String get paywallCtaMonthly => 'شروع طرح ماهانه';

  @override
  String get paywallFootLifetime => 'خرید یک‌باره · بدون اشتراک';

  @override
  String get paywallFootSubscription =>
      'تمدید خودکار · لغو در هر زمان از فروشگاه';

  @override
  String get paywallTerms =>
      'هزینه اشتراک از حساب App Store یا Google Play شما کسر می‌شود و به‌طور خودکار تمدید می‌شود، مگر اینکه حداقل 24 ساعت پیش از پایان دوره فعلی لغو شود.';

  @override
  String get paywallIapUnavailable =>
      'خرید درون‌برنامه‌ای در این دستگاه در دسترس نیست. مطمئن شوید Google Play Services نصب است و برنامه از Play Store دریافت شده است.';

  @override
  String get paywallLoadingPlans => 'در حال بارگیری طرح‌ها…';

  @override
  String get paywallPlansFailed =>
      'بارگیری طرح‌ها ممکن نشد. اتصال خود را بررسی و دوباره تلاش کنید.';

  @override
  String get paywallTryAgain => 'تلاش دوباره';

  @override
  String get paywallRestored => 'خریدها بازیابی شد';

  @override
  String get paywallPurchased => 'به Premium خوش آمدید!';

  @override
  String get paywallLifetimeNever => 'دسترسی مادام‌العمر هرگز منقضی نمی‌شود';

  @override
  String get helpSearchQuestions => 'جستجوی پرسش‌ها';

  @override
  String get helpStepWallets => 'افزودن کیف پول‌ها';

  @override
  String get helpStepCategories => 'انتخاب دسته‌ها';

  @override
  String get helpStepTrack => 'ثبت روزانه';

  @override
  String get splashTagline => 'پول، روشن‌تر.';

  @override
  String get introStep1 => 'در حال شمردن سکه‌هایتان…';

  @override
  String get introStep2 => 'در حال بیدار کردن کیف پول‌هایتان…';

  @override
  String get introStep3 => 'در حال صیقل دادن نمودارها…';

  @override
  String get introStep4 => 'تقریباً آماده است…';

  @override
  String get introTipLabel => 'نکته مالی';

  @override
  String get introTip1 =>
      'اول سهم خودتان را بدهید: همان روزی که حقوق می‌رسد، پس‌انداز را کنار بگذارید.';

  @override
  String get introTip2 =>
      'خرج‌های کوچک روزانه روی هم جمع می‌شوند. ثبت کردنشان نیمی از کار است.';

  @override
  String get introTip3 =>
      'صندوق اضطراری 3 ماهه، غافلگیری‌ها را به دردسرهای کوچک تبدیل می‌کند.';

  @override
  String get introTip4 =>
      'اشتراک‌ها را ماهانه بررسی کنید: آنچه استفاده نکردید را لغو کنید.';

  @override
  String get introTip5 => 'پیش از شروع ماه، برای هر تومان یک کار تعیین کنید.';

  @override
  String get introTip6 => 'پیش از هر خرید برنامه‌ریزی‌نشده 24 ساعت صبر کنید.';

  @override
  String get introTip7 =>
      'بودجه محدودیت نیست، اجازه خرج کردن برای چیزهای مهم است.';

  @override
  String get introTip8 =>
      'موفقیت‌های کوچک را جشن بگیرید: هر هدفی با اولین واریز شروع می‌شود.';

  @override
  String get adConfirmTitleAiCall => 'یک درخواست هوش مصنوعی دیگر بگیرید';

  @override
  String get adConfirmTitleTheme => 'تم‌های Premium را 24 ساعت امتحان کنید';

  @override
  String get adConfirmTitlePdf => 'خروجی یک گزارش PDF';

  @override
  String get adConfirmBodyAiCall =>
      'درخواست‌های رایگان هوش مصنوعی این ماه را استفاده کرده‌اید. یک تبلیغ کوتاه ببینید و یک درخواست دیگر بگیرید.';

  @override
  String get adConfirmBodyTheme =>
      'یک تبلیغ کوتاه ببینید و همه تم‌های Premium تا 24 ساعت آینده مال شماست.';

  @override
  String get adConfirmBodyPdf =>
      'برای خروجی گرفتن یک گزارش PDF یک تبلیغ کوتاه ببینید.';

  @override
  String get adConfirmWarning =>
      'در آستانه دیدن یک تبلیغ هستید. ادامه می‌دهید؟';

  @override
  String adConfirmLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تبلیغ دیگر در این ماه در دسترس است',
      one: '1 تبلیغ دیگر در این ماه در دسترس است',
    );
    return '$_temp0';
  }

  @override
  String get adPremiumPitch =>
      'اعضای Premium هوش مصنوعی نامحدود، همه تم‌ها و گزارش‌های PDF را بدون هیچ تبلیغی دارند.';

  @override
  String get adWatch => 'دیدن تبلیغ';

  @override
  String get adGetPremium => 'دریافت Premium';

  @override
  String get adNotNow => 'الان نه';

  @override
  String get adLoading => 'در حال بارگیری تبلیغ…';

  @override
  String get adVerifying => 'در حال تأیید پاداش شما…';

  @override
  String get adUnavailable =>
      'فعلاً تبلیغی در دسترس نیست. لطفاً کمی بعد دوباره تلاش کنید.';

  @override
  String get adSkipped => 'تبلیغ پیش از پایان بسته شد، پس چیزی باز نشد.';

  @override
  String get adRewardAiCall => 'انجام شد! یک درخواست هوش مصنوعی دیگر دارید.';

  @override
  String get adRewardTheme => 'تم‌های Premium برای 24 ساعت باز شدند.';

  @override
  String get adRewardPdf => 'یک خروجی PDF باز شد.';

  @override
  String get adMonthlyCapReached =>
      'تبلیغ‌های این ماه تمام شد. درخواست‌های رایگان شما روز اول ماه برمی‌گردند، یا برای استفاده نامحدود Premium بگیرید.';

  @override
  String get adRewardPending =>
      'سپاسگزاریم! پاداش شما تا لحظاتی دیگر نمایش داده می‌شود.';

  @override
  String aiQuotaLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count درخواست رایگان هوش مصنوعی در این ماه باقی مانده',
      one: '1 درخواست رایگان هوش مصنوعی در این ماه باقی مانده',
      zero: 'درخواست رایگان هوش مصنوعی این ماه تمام شد',
    );
    return '$_temp0';
  }

  @override
  String get aiQuotaPremiumUnlimited => 'Premium: نامحدود';

  @override
  String get aiToolSearching => 'در حال جستجوی تراکنش‌هایتان…';

  @override
  String get aiToolSummarizing => 'در حال جمع زدن اعداد…';

  @override
  String get aiToolAccounts => 'در حال بررسی حساب‌هایتان…';

  @override
  String get aiToolCategories => 'در حال بررسی دسته‌هایتان…';

  @override
  String get aiToolCards => 'در حال بررسی صورت‌حساب کارت‌ها…';

  @override
  String get aiToolPlans => 'در حال بررسی اقساط و پس‌اندازها…';

  @override
  String get aiToolSaving => 'در حال ذخیره…';

  @override
  String get aiActionAddTitle => 'این تراکنش اضافه شود؟';

  @override
  String get aiActionUpdateTitle => 'این تراکنش تغییر کند؟';

  @override
  String get aiActionDeleteTitle => 'این تراکنش حذف شود؟';

  @override
  String get aiActionPayCardTitle => 'پرداخت صورت‌حساب کارت';

  @override
  String get aiActionCardSettingsTitle => 'تغییر تاریخ‌های کارت';

  @override
  String get aiActionCreatePlanTitle => 'شروع یک طرح';

  @override
  String get aiActionPayPlanTitle => 'ثبت پرداخت طرح';

  @override
  String get aiActionClosePlanTitle => 'پایان زودهنگام طرح';

  @override
  String get aiActionUpdatePlanTitle => 'تغییر طرح';

  @override
  String get aiActionCreateInvestmentTitle => 'افزودن سرمایه‌گذاری';

  @override
  String get aiActionTradeInvestmentTitle => 'ثبت معامله';

  @override
  String get aiActionUpdateInvestmentTitle => 'به‌روزرسانی قیمت';

  @override
  String get aiActionConfirm => 'تأیید';

  @override
  String get aiActionClosePlan => 'پایان دادن';

  @override
  String get aiActionFrom => 'از';

  @override
  String get aiActionTo => 'به';

  @override
  String get aiActionBill => 'صورت‌حساب';

  @override
  String get aiActionLeftAfter => 'باقی‌مانده پس از آن';

  @override
  String get aiActionRemindDays => 'یادآوری، چند روز قبل';

  @override
  String get aiActionPay => 'پرداخت';

  @override
  String get plansTitle => 'اقساط، وام‌ها و پس‌انداز';

  @override
  String get investmentsTitle => 'سرمایه‌گذاری‌ها';

  @override
  String get investmentsSubtitle =>
      'صندوق‌های سرمایه‌گذاری، سهام و خریدهای دوره‌ای، با آخرین قیمت';

  @override
  String get forecastTitle => 'پیش‌بینی جریان نقدی';

  @override
  String get forecastSubtitle =>
      'پول نقد و بانکی شما به کجا می‌رود، و هر روزی که کم می‌آورید';

  @override
  String forecastRangeDays(int days) {
    return '$days روز';
  }

  @override
  String get forecastNow => 'نقد و بانک اکنون';

  @override
  String get forecastMoneyIn => 'ورودی';

  @override
  String get forecastMoneyOut => 'خروجی';

  @override
  String get forecastLowest => 'کمترین';

  @override
  String forecastLowestOn(String date) {
    return 'در $date';
  }

  @override
  String get forecastChartTitle => 'موجودی پیش‌بینی‌شده';

  @override
  String forecastShortfallTitle(String date, String amount) {
    return 'در $date به اندازه $amount کم می‌آورید';
  }

  @override
  String get forecastShortfallCause => 'خروجی‌های آن روز:';

  @override
  String get forecastAlreadyShort =>
      'حساب‌های نقد و بانکی شما هم‌اکنون زیر صفر هستند.';

  @override
  String forecastAllCoveredTitle(int days) {
    return 'در $days روز آینده کسری ندارید';
  }

  @override
  String get forecastAllCoveredBody =>
      'پرداخت‌های برنامه‌ریزی‌شده با پول نقد و بانکی شما پوشش داده می‌شوند.';

  @override
  String get forecastScheduledOnly =>
      'فقط موارد برنامه‌ریزی‌شده حساب می‌شوند: طرح‌ها، صورت‌حساب کارت‌ها، اشتراک‌ها، پرداخت‌های تکراری و پیش رو، و وام‌های دارای سررسید. هزینه‌های روزمره لحاظ نمی‌شوند.';

  @override
  String get forecastEventsTitle => 'پیش رو';

  @override
  String forecastDayBalance(String amount) {
    return 'موجودی $amount';
  }

  @override
  String get forecastEmptyTitle => 'چیزی برنامه‌ریزی نشده';

  @override
  String get forecastEmptyBody =>
      'طرح‌ها، صورت‌حساب کارت‌ها، اشتراک‌ها و پرداخت‌های پیش روی این دوره اینجا نمایش داده می‌شوند.';

  @override
  String get forecastOverdue => 'معوق';

  @override
  String get forecastExpected => 'مورد انتظار';

  @override
  String get forecastEventWhen => 'زمان';

  @override
  String get forecastEventKind => 'نوع';

  @override
  String get forecastEventAccount => 'حساب';

  @override
  String get forecastEventOpen => 'باز کردن';

  @override
  String get forecastEventOverdueNote =>
      'تاریخش گذشته و هنوز باز است، پس سررسید امروز حساب می‌شود.';

  @override
  String get forecastKindInstallment => 'قسط';

  @override
  String get forecastKindPremium => 'حق بیمه';

  @override
  String get forecastKindDeposit => 'واریز';

  @override
  String get forecastKindSipBuy => 'خرید دوره‌ای';

  @override
  String get forecastKindProfit => 'سود';

  @override
  String get forecastKindMaturity => 'سررسید';

  @override
  String get forecastKindCardBill => 'صورت‌حساب کارت';

  @override
  String get forecastKindCardBillNext => 'صورت‌حساب بعدی کارت، تا اینجا';

  @override
  String get forecastKindSubscription => 'اشتراک';

  @override
  String get forecastKindRecurringBill => 'پرداخت تکراری';

  @override
  String get forecastKindRecurringIncome => 'درآمد تکراری';

  @override
  String get forecastKindUpcoming => 'پیش رو';

  @override
  String get forecastKindBorrowed => 'وام برای بازپرداخت';

  @override
  String get forecastKindLent => 'قرض داده‌شده، قابل وصول';

  @override
  String forecastHomeWarning(String date, String amount) {
    return 'ممکن است در $date به اندازه $amount کم بیاورید';
  }

  @override
  String get forecastHomeWarningBody => 'ببینید چه چیزی در پیش است';

  @override
  String get forecastDismiss => 'بستن';

  @override
  String forecastNotifTitle(String day) {
    return 'ممکن است در $day کم بیاورید';
  }

  @override
  String get settingsBillReminders => 'یادآوری صورت‌حساب‌ها و اقساط';

  @override
  String get settingsBillRemindersSub =>
      'سررسید صورت‌حساب کارت‌ها، و اقساط وام یا پس‌انداز پیش رو';

  @override
  String get forecastNotifNowTitle => 'امروز کمبود پول دارید';

  @override
  String forecastNotifNowBody(String amount) {
    return 'مبالغ سررسید فعلی $amount بیشتر از موجودی حساب‌هایتان است. برای دیدن موارد پیش رو بزنید.';
  }

  @override
  String forecastNotifBody(String amount) {
    return 'پرداخت‌های برنامه‌ریزی‌شده شما را $amount کم می‌آورد. برای دیدن موارد پیش رو بزنید.';
  }

  @override
  String get investmentsEmptyTitle => 'هنوز سرمایه‌گذاری ندارید';

  @override
  String get investmentsEmptyBody =>
      'صندوق سرمایه‌گذاری، سهام یا طلا را پیگیری کنید: چقدر پرداختید، اکنون چقدر می‌ارزد و چقدر سود کرده‌اید.';

  @override
  String get investmentsSold => 'فروخته‌شده';

  @override
  String get investmentsWorth => 'ارزش فعلی';

  @override
  String get investmentNew => 'سرمایه‌گذاری جدید';

  @override
  String get investmentNewHint =>
      'واحدهای یک صندوق، سهام یک شرکت، یا هر چیزی که واحدی خریده می‌شود، مثل طلا به گرم.';

  @override
  String get investmentKindFund => 'صندوق';

  @override
  String get investmentKindStock => 'سهام';

  @override
  String get investmentKindOther => 'سایر';

  @override
  String get investmentNameHintFund => 'مثلاً صندوق درآمد ثابت';

  @override
  String get investmentNameHintStock => 'مثلاً فولاد مبارکه';

  @override
  String get investmentNameHintOther => 'مثلاً طلای 18 عیار';

  @override
  String get investmentSymbol => 'نماد یا کد (اختیاری)';

  @override
  String get investmentFirstBuy => 'آنچه خریدید';

  @override
  String get investmentFirstBuyHint =>
      'اگر هنوز چیزی نخریده‌اید، مبلغ را خالی بگذارید.';

  @override
  String get investmentPaid => 'پرداختی';

  @override
  String get investmentReceived => 'دریافتی';

  @override
  String get investmentPaidInto => 'واریز به';

  @override
  String get investmentFee => 'کارمزد';

  @override
  String get investmentUnits => 'تعداد واحد';

  @override
  String get investmentUnitsSold => 'واحدهای فروخته‌شده';

  @override
  String investmentUnitsShort(String units) {
    return '$units واحد';
  }

  @override
  String investmentPerUnit(String price) {
    return 'هر واحد $price';
  }

  @override
  String get investmentNeedUnits => 'تعداد واحدهای خریداری‌شده را وارد کنید.';

  @override
  String get investmentSave => 'افزودن سرمایه‌گذاری';

  @override
  String get investmentAdded => 'سرمایه‌گذاری اضافه شد';

  @override
  String get investmentGone => 'این سرمایه‌گذاری حذف شد.';

  @override
  String get netWorthSubtitle => 'همه دارایی‌ها منهای بدهی‌ها، و روند تغییر آن';

  @override
  String get netWorthToday => 'دارایی خالص شما';

  @override
  String netWorthSinceLastMonth(String amount) {
    return '$amount از ماه گذشته';
  }

  @override
  String get netWorthBreakdown => 'از چه تشکیل شده';

  @override
  String get netWorthCash => 'نقد و بانک';

  @override
  String get netWorthCards => 'کارت‌های اعتباری';

  @override
  String get netWorthDeposits => 'سپرده‌های پس‌انداز';

  @override
  String get netWorthAssets => 'دارایی‌ها';

  @override
  String get netWorthLent => 'قرض داده به دیگران';

  @override
  String get netWorthBorrowed => 'قرض گرفته‌شده';

  @override
  String get netWorthLoansNote =>
      'پولی که قرض داده‌اید تا زمان بازپرداخت مال شما حساب می‌شود، و پولی که قرض گرفته‌اید تا زمان بازپرداخت از دارایی‌تان کم می‌شود.';

  @override
  String get netWorthCardsLeftOut =>
      'کارت‌های اعتباری حساب نمی‌شوند؛ می‌توانید این را در تنظیمات تغییر دهید.';

  @override
  String get netWorthHistory => 'در پایان هر ماه';

  @override
  String get netWorthSixMonths => '6 ماه';

  @override
  String get netWorthOneYear => '1 سال';

  @override
  String get netWorthAllTime => 'همه';

  @override
  String get netWorthHistoryEmpty =>
      'نمودار پس از پایان یک ماه با سوابق شما شروع می‌شود.';

  @override
  String get assetNew => 'افزودن دارایی';

  @override
  String get assetNewHint =>
      'زمین، آپارتمان یا خانه، خودرو، طلا یا هر چیز دیگری که دارید. ارزش آن در دارایی خالص شما حساب می‌شود.';

  @override
  String get assetKind => 'چیست';

  @override
  String get assetKindLand => 'زمین';

  @override
  String get assetKindHome => 'آپارتمان یا خانه';

  @override
  String get assetKindCar => 'خودرو';

  @override
  String get assetKindGold => 'طلا و جواهر';

  @override
  String get assetKindOther => 'چیز دیگر';

  @override
  String get assetNameHintLand => 'مثلاً زمین در کرج';

  @override
  String get assetNameHintHome => 'مثلاً آپارتمان در تهرانپارس';

  @override
  String get assetNameHintCar => 'مثلاً پژو 206';

  @override
  String get assetNameHintGold => 'مثلاً جواهرات عروسی';

  @override
  String get assetNameHintOther => 'مثلاً دوربین';

  @override
  String get assetWorthNow => 'ارزش فعلی';

  @override
  String get assetBoughtNow => 'از یک حساب پرداخت شد';

  @override
  String get assetBoughtNowHint =>
      'خاموش: از قبل آن را دارید و پولی جابه‌جا نمی‌شود.';

  @override
  String get assetSave => 'افزودن دارایی';

  @override
  String get assetAdded => 'دارایی اضافه شد';

  @override
  String get assetsEmptyTitle => 'هنوز دارایی ندارید';

  @override
  String get assetsEmptyBody =>
      'زمین، خانه، خودرو یا طلا اضافه کنید تا کل دارایی‌تان را ببینید.';

  @override
  String get assetsSold => 'فروخته‌شده';

  @override
  String assetCostLine(String amount) {
    return 'بهای خرید $amount';
  }

  @override
  String get assetUpdateValue => 'به‌روزرسانی ارزش';

  @override
  String get assetSell => 'فروش';

  @override
  String get assetDelete => 'حذف';

  @override
  String get assetValueUpdated => 'ارزش به‌روزرسانی شد';

  @override
  String get assetSold => 'فروخته شد و مبلغ ثبت شد';

  @override
  String assetDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get assetDeleteBody =>
      'دیگر حساب نمی‌شود. تاریخچه آن در سوابق شما باقی می‌ماند.';

  @override
  String get assetDeleted => 'دارایی حذف شد';

  @override
  String get aiActionCreateAssetTitle => 'افزودن دارایی';

  @override
  String get aiActionUpdateAssetTitle => 'به‌روزرسانی ارزش دارایی';

  @override
  String get aiActionSellAssetTitle => 'فروش دارایی';

  @override
  String get investmentWorthNow => 'ارزش فعلی';

  @override
  String investmentGainLine(String gain) {
    return '$gain در مجموع';
  }

  @override
  String get investmentPrice => 'قیمت';

  @override
  String get investmentPutIn => 'سرمایه‌گذاری‌شده';

  @override
  String get investmentTakenOut => 'برداشت‌شده';

  @override
  String get investmentBuy => 'خرید';

  @override
  String get investmentSell => 'فروش';

  @override
  String investmentBuyTitle(String name) {
    return 'خرید $name';
  }

  @override
  String investmentSellTitle(String name) {
    return 'فروش $name';
  }

  @override
  String investmentDividendTitle(String name) {
    return 'سود نقدی از $name';
  }

  @override
  String get investmentDividend => 'سود نقدی';

  @override
  String get investmentRecordDividend => 'ثبت سود نقدی';

  @override
  String investmentHeldNow(String units) {
    return 'اکنون $units واحد در اختیار دارید.';
  }

  @override
  String get investmentRecorded => 'ثبت شد';

  @override
  String get investmentUpdatePrice => 'به‌روزرسانی قیمت';

  @override
  String get investmentUpdatePriceHint => 'NAV یا قیمت سهم امروز، برای یک واحد';

  @override
  String get investmentPriceUpdated => 'قیمت به‌روزرسانی شد';

  @override
  String get investmentStartSip => 'شروع خرید دوره‌ای';

  @override
  String get investmentStartSipHint =>
      'هر ماه مبلغ ثابتی به‌طور خودکار خریداری شود';

  @override
  String get investmentHistory => 'تاریخچه';

  @override
  String investmentBought(String units) {
    return '$units واحد خریداری شد';
  }

  @override
  String investmentSold(String units) {
    return '$units واحد فروخته شد';
  }

  @override
  String get investmentPriceRose => 'قیمت بالا رفت';

  @override
  String get investmentPriceFell => 'قیمت پایین آمد';

  @override
  String get investmentUnitsUnknown =>
      'تعداد واحد هنوز مشخص نیست، برای افزودن بزنید';

  @override
  String get investmentCorrectUnits => 'تعداد واحد این معامله';

  @override
  String get investmentCorrectUnitsHint =>
      'همان‌طور که در صورت‌حساب صندوق یا کارگزار نشان داده شده.';

  @override
  String get investmentUnitsCorrected => 'تعداد واحد اصلاح شد';

  @override
  String get investmentDelete => 'حذف این سرمایه‌گذاری';

  @override
  String investmentDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get investmentDeleteBody =>
      'معاملات آن در تاریخچه شما باقی می‌ماند. فقط پس از فروش همه واحدها امکان‌پذیر است.';

  @override
  String get investmentDeleted => 'سرمایه‌گذاری حذف شد';

  @override
  String get plansSubtitle =>
      'اقساط، وام‌ها، سپرده‌ها، بیمه، اوراق و خریدهای دوره‌ای، پرداخت و دریافت به‌موقع';

  @override
  String get planNew => 'شروع طرح';

  @override
  String get planNewTitle => 'چه چیزی را شروع می‌کنید؟';

  @override
  String get plansEmptyTitle => 'هنوز قسط، وام یا پس‌اندازی ندارید';

  @override
  String get plansEmptyBody =>
      'خرید قسطی، وام، سپرده ماهانه یا سپرده مدت‌دار را پیگیری کنید. اقساط در روز خود ثبت می‌شوند و پیش از هر کدام یادآوری دریافت می‌کنید.';

  @override
  String get plansEnded => 'پایان‌یافته';

  @override
  String get planKindEmi => 'خرید قسطی';

  @override
  String get planKindLoan => 'وام';

  @override
  String get planKindDps => 'سپرده ماهانه';

  @override
  String get planKindFdr => 'سپرده مدت‌دار';

  @override
  String get planKindInsurance => 'بیمه';

  @override
  String get planKindBond => 'اوراق یا گواهی';

  @override
  String get planKindSip => 'خرید دوره‌ای';

  @override
  String get planKindEmiHint =>
      'چیزی که قسطی خریده شده و از نقد، حساب بانکی یا کارت پرداخت می‌شود';

  @override
  String get planKindLoanHint =>
      'پول قرض گرفته‌شده که با سود به‌صورت قسطی بازپرداخت می‌شود';

  @override
  String get planKindDpsHint =>
      'هر ماه مبلغ ثابتی را برای مدت مشخص پس‌انداز کنید و آن را با سود پس بگیرید';

  @override
  String get planKindFdrHint =>
      'مبلغی را برای مدت مشخص در بانک بگذارید، با سود ماهانه، هر سه ماه یا در پایان دوره';

  @override
  String get planKindInsuranceHint =>
      'بیمه‌نامه‌ای با حق بیمه ماهانه، فصلی یا سالانه، و پرداخت در پایان اگر داشته باشد';

  @override
  String get planKindBondHint =>
      'اوراق یا گواهی سپرده: مبلغی که سال‌ها نگه داشته می‌شود، با سود ماهانه، هر سه ماه یا در پایان، پس از کسر مالیات';

  @override
  String get planKindSipHint =>
      'مبلغ ثابتی هر ماه در صندوق یا سهام، با آخرین قیمت خریداری می‌شود';

  @override
  String get planWeekly => 'هفتگی';

  @override
  String get planMonthly => 'ماهانه';

  @override
  String get planQuarterly => 'سه‌ماهه';

  @override
  String get planHalfYearly => 'شش‌ماهه';

  @override
  String get planYearly => 'سالانه';

  @override
  String get planMonths => 'ماه';

  @override
  String get planYears => 'سال';

  @override
  String planFdrLine(String amount, String date) {
    return '$amount تا $date';
  }

  @override
  String planSavedLine(String saved, String total) {
    return '$saved از $total پس‌انداز شده';
  }

  @override
  String planPaidLine(String paid, String total) {
    return '$paid از $total پرداخت شده';
  }

  @override
  String planNextLine(String amount, String date) {
    return 'بعدی: $amount در $date';
  }

  @override
  String get planStatusCompleted => 'تکمیل‌شده';

  @override
  String get planStatusClosed => 'بسته‌شده';

  @override
  String get planStatusOverdue => 'معوق';

  @override
  String get planStatusRunning => 'در جریان';

  @override
  String planInstallmentsDone(int done, int total) {
    return '$done از $total';
  }

  @override
  String get planGone => 'این طرح حذف شده است.';

  @override
  String get planAccount => 'حساب';

  @override
  String get planAccountEmi => 'پرداخت از';

  @override
  String get planAccountLoan => 'دریافت به و پرداخت از';

  @override
  String get planAccountSaving => 'از حساب';

  @override
  String get planPrice => 'قیمت';

  @override
  String get planBorrowed => 'مبلغ وام';

  @override
  String get planDeposited => 'مبلغ سپرده';

  @override
  String get planDeposit => 'هر واریز';

  @override
  String get planInstallment => 'هر قسط';

  @override
  String get planWorkedOut => 'محاسبه‌شده از قیمت، نرخ و مدت';

  @override
  String get planProgress => 'انجام‌شده';

  @override
  String get planSavedSoFar => 'پس‌انداز تاکنون';

  @override
  String get planPaidSoFar => 'پرداخت تاکنون';

  @override
  String get planLeft => 'باقی‌مانده';

  @override
  String get planTotal => 'در مجموع';

  @override
  String get planInterestCharges => 'سود و کارمزد';

  @override
  String get planRate => 'نرخ';

  @override
  String get planRateLabel => 'نرخ % سالانه';

  @override
  String get planRateOptional => 'اختیاری';

  @override
  String get planPayout => 'پرداخت سود';

  @override
  String get planPayoutMonthly => 'هر ماه';

  @override
  String get planPayoutQuarterly => 'هر 3 ماه';

  @override
  String get planPayoutAtMaturity => 'در پایان';

  @override
  String get planMaturesOn => 'سررسید در';

  @override
  String get planMaturity => 'بازپرداخت در پایان';

  @override
  String get planEstimated =>
      'برآورد بر اساس نرخ؛ برای وارد کردن رقم بانک بزنید';

  @override
  String get planHolding => 'موجودی فعلی سپرده';

  @override
  String get planEnds => 'آخرین قسط';

  @override
  String planTakeMaturity(String amount) {
    return 'دریافت مبلغ سررسید، $amount';
  }

  @override
  String planRecordProfit(String amount) {
    return 'ثبت سود، $amount';
  }

  @override
  String planPayNow(int number, String amount) {
    return 'پرداخت قسط $number اکنون، $amount';
  }

  @override
  String planPayPremiumNow(int number, String amount) {
    return 'پرداخت حق بیمه $number اکنون، $amount';
  }

  @override
  String planDepositNow(int number, String amount) {
    return 'واریز $number اکنون، $amount';
  }

  @override
  String get planRecorded => 'ثبت شد.';

  @override
  String get planSaved => 'ذخیره شد.';

  @override
  String get planPayOff => 'تسویه زودهنگام';

  @override
  String get planEncash => 'برداشت زودهنگام';

  @override
  String get planSurrender => 'بازخرید بیمه‌نامه';

  @override
  String planSurrenderTitle(String name) {
    return '$name بازخرید شود؟';
  }

  @override
  String get planSurrenderBody =>
      'پرداخت حق بیمه متوقف می‌شود. هر مبلغی که بیمه‌گر برگرداند به‌عنوان درآمد ثبت می‌شود.';

  @override
  String get planSurrenderNothing => 'چیزی برگردانده نشد';

  @override
  String get planSurrenderValue => 'ارزش بازخرید را وارد کنید';

  @override
  String get planSurrenderValueLabel => 'ارزش بازخرید';

  @override
  String get planStopSip => 'توقف خرید دوره‌ای';

  @override
  String planStopSipTitle(String name) {
    return '$name متوقف شود؟';
  }

  @override
  String get planStopSipBody =>
      'خرید دیگری انجام نمی‌شود. آنچه خریداری شده در سرمایه‌گذاری باقی می‌ماند.';

  @override
  String get planSipStopped => 'خرید دوره‌ای متوقف شد';

  @override
  String get planSave => 'ذخیره';

  @override
  String get planSurrendered => 'بیمه‌نامه بازخرید شد';

  @override
  String planPayOffTitle(String name) {
    return '$name تسویه شود؟';
  }

  @override
  String get planPayOffHint =>
      'یک پرداخت برای باقی‌مانده، و طرح به پایان می‌رسد.';

  @override
  String planPayOffLeft(String amount) {
    return 'پرداخت باقی‌مانده، $amount';
  }

  @override
  String get planPayOffOther => 'وام‌دهنده مبلغ دیگری اعلام کرد';

  @override
  String planEncashTitle(String name) {
    return '$name برداشت شود؟';
  }

  @override
  String get planEncashBody =>
      'موجودی سپرده به حساب خود برمی‌گردد و طرح به پایان می‌رسد.';

  @override
  String get planEncashNoProfit => 'برداشت، بدون سود';

  @override
  String get planEncashWithProfit => 'برداشت، با سودی که بانک پرداخت کرد';

  @override
  String get planEncashed => 'برداشت شد. پول به حساب خود برگشت.';

  @override
  String get planPaidOff => 'تسویه شد.';

  @override
  String get planAutoCollect => 'ثبت خودکار';

  @override
  String get planAutoCollectHint =>
      'هر قسط، سود و سررسید در روز خود ثبت می‌شود';

  @override
  String get planSchedule => 'زمان‌بندی';

  @override
  String get planDelete => 'حذف این طرح';

  @override
  String planDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get planDeleteBody =>
      'آنچه ثبت کرده در تراکنش‌هایتان باقی می‌ماند. دیگر چیزی ثبت یا یادآوری نمی‌شود.';

  @override
  String get planDeleted => 'حذف شد.';

  @override
  String planEventInstallment(int number, int total) {
    return 'قسط $number از $total';
  }

  @override
  String planEventPremium(int number, int total) {
    return 'حق بیمه $number از $total';
  }

  @override
  String get planEventPayout => 'پرداخت بیمه‌نامه';

  @override
  String planEventProfit(int number) {
    return 'سود، ماه $number';
  }

  @override
  String get planEventMaturity => 'سررسید';

  @override
  String get planEventDone => 'انجام‌شده';

  @override
  String get planEventLate => 'معوق';

  @override
  String get planEventUpcoming => 'پیش رو';

  @override
  String get planNeedAccount => 'ابتدا یک حساب انتخاب کنید.';

  @override
  String get planCreated => 'شروع شد. هر مورد سررسیدشده ثبت شده است.';

  @override
  String planSummaryInstallments(
    int count,
    String installment,
    String total,
    String interest,
  ) {
    return '$count × $installment = $total، که $interest آن سود و کارمزد است.';
  }

  @override
  String planSummaryNoInterest(int count, String installment, String total) {
    return '$count × $installment = $total، بدون سود.';
  }

  @override
  String planSummaryDps(String deposited, String maturity, String date) {
    return '$deposited واریز می‌کنید و حدود $maturity در $date پس می‌گیرید.';
  }

  @override
  String planSummaryFdr(String principal, String maturity, String date) {
    return '$principal تا $date به حدود $maturity می‌رسد.';
  }

  @override
  String planSummaryFdrMonthly(String profit, String principal, String date) {
    return 'هر ماه $profit سود، و بازگشت $principal در $date.';
  }

  @override
  String planSummaryInsurance(int count, String premium, String total) {
    return '$count حق بیمه $premium، در مجموع $total.';
  }

  @override
  String planSummaryInsurancePayout(
    int count,
    String premium,
    String total,
    String payout,
    String date,
  ) {
    return '$count حق بیمه $premium، در مجموع $total، و دریافت $payout در $date.';
  }

  @override
  String planSummaryQuarterly(String profit, String principal, String date) {
    return 'هر سه ماه $profit سود، و بازگشت $principal در $date.';
  }

  @override
  String planSummarySip(int count, String amount, String total, String fund) {
    return '$count × $amount در $fund، در مجموع $total.';
  }

  @override
  String planNewKind(String kind) {
    return '$kind جدید';
  }

  @override
  String get planName => 'نام';

  @override
  String get planNameHintEmi => 'مثلاً گوشی از دیجی‌کالا';

  @override
  String get planNameHintLoan => 'مثلاً وام موتور';

  @override
  String get planNameHintDps => 'مثلاً سپرده ماهانه بانک ملت';

  @override
  String get planNameHintFdr => 'مثلاً سپرده بلندمدت بانک ملی';

  @override
  String get planNameHintInsurance => 'مثلاً بیمه عمر';

  @override
  String get planNameHintBond => 'مثلاً اوراق مشارکت 5 ساله';

  @override
  String get planNameHintSip => 'مثلاً خرید ماهانه صندوق';

  @override
  String get planSipFund => 'خرید';

  @override
  String get planSipAmount => 'هر خرید دوره‌ای';

  @override
  String get planSipNoFund =>
      'ابتدا صندوق یا سهام را در بخش سرمایه‌گذاری‌ها اضافه کنید.';

  @override
  String get planProvider => 'بانک یا شرکت';

  @override
  String get planReference => 'شماره بیمه‌نامه یا حساب';

  @override
  String get planSumAssured => 'سرمایه بیمه';

  @override
  String get planPremium => 'حق بیمه';

  @override
  String get planPremiums => 'حق بیمه‌ها';

  @override
  String get planTaxLabel => 'مالیات تکلیفی %';

  @override
  String get planTax => 'مالیات تکلیفی';

  @override
  String get planFirstPremium => 'اولین حق بیمه';

  @override
  String get planLastPremium => 'آخرین حق بیمه';

  @override
  String get planInsurancePayout => 'بازپرداخت در پایان';

  @override
  String get planNone => 'هیچ';

  @override
  String get planHowMany => 'تعداد';

  @override
  String get planTerm => 'مدت';

  @override
  String get planOpenedOn => 'تاریخ افتتاح';

  @override
  String get planFirstDue => 'اولین قسط';

  @override
  String get planCategory => 'دسته';

  @override
  String get planCategoryDefault => 'پرداخت وام';

  @override
  String get planCategoryInsurance => 'بیمه';

  @override
  String get planLoanReceived => 'پول به این حساب واریز شد';

  @override
  String get planLoanReceivedHint => 'اگر مستقیم به فروشنده رفت، خاموش کنید';

  @override
  String get planStart => 'شروع';

  @override
  String get aiActionDeleteNote =>
      'به «حذف‌شده‌های اخیر» می‌رود و تا 30 روز می‌توانید آن را بازگردانید.';

  @override
  String get aiActionAdd => 'اضافه کن';

  @override
  String get aiActionSave => 'ذخیره تغییر';

  @override
  String get aiActionDelete => 'حذف کن';

  @override
  String get aiActionCancel => 'نه، بماند';

  @override
  String get aiActionAmount => 'مبلغ';

  @override
  String get aiActionKind => 'نوع';

  @override
  String get aiActionTitle => 'عنوان';

  @override
  String get aiActionCategory => 'دسته';

  @override
  String get aiActionAccount => 'حساب';

  @override
  String get aiActionDate => 'تاریخ';

  @override
  String get aiActionNotes => 'یادداشت‌ها';

  @override
  String get aiReport => 'گزارش مشکل';

  @override
  String get aiReportWrongAnswer => 'مشاور اشتباه کرد';

  @override
  String get aiReportWrongAnswerHint =>
      'عدد اشتباه، اطلاعات ساختگی، یا تغییری که درخواست نکرده بودید';

  @override
  String get aiReportWrongAnswerSubject => 'مشاور مالی: پاسخ اشتباه';

  @override
  String get aiReportBug => 'گزارش خطا';

  @override
  String get aiReportBugHint => 'چیزی خراب شد، هنگ کرد یا بارگیری نشد';

  @override
  String get aiReportBugSubject => 'مشاور مالی: گزارش خطا';

  @override
  String get aiAboutCoach => 'مشاور چگونه کار می‌کند';

  @override
  String get aiDisclaimerTitle => 'پیش از پرسیدن از مشاور';

  @override
  String get aiDisclaimerMistakes =>
      'مشاور یک هوش مصنوعی است. ممکن است عددی را اشتباه بگوید، سؤالی را بد بفهمد یا چیزی نادرست بیان کند، پس هر چیز مهمی را با تراکنش‌های خودتان مقایسه کنید.';

  @override
  String get aiDisclaimerData =>
      'ارقام شما روی گوشی‌تان خوانده می‌شوند. برای پاسخ دادن، برنامه سؤال شما و ارقام لازم را به سرور ما و مدل هوش مصنوعی آن می‌فرستد.';

  @override
  String get aiDisclaimerChanges =>
      'هرگز خودسرانه پول شما را تغییر نمی‌دهد. هر افزودن، ویرایش یا حذف ابتدا به شما نشان داده می‌شود و فقط با تأیید شما انجام می‌شود.';

  @override
  String get aiDisclaimerReport =>
      'اگر پاسخی اشتباه به نظر رسید، روی پرچم بالای صفحه بزنید تا به ما خبر دهید.';

  @override
  String get aiDisclaimerAccept => 'متوجه شدم';

  @override
  String get aiOutOfRequestsTitle =>
      'درخواست‌های رایگان این ماه را استفاده کرده‌اید';

  @override
  String get aiOutOfRequestsBody =>
      'برای پرسیدن این سؤال یک تبلیغ کوتاه ببینید، یا برای پاسخ‌های نامحدود بدون تبلیغ Premium بگیرید. درخواست‌های رایگان روز اول ماه برمی‌گردند.';

  @override
  String get ocrNoCamera => 'باز کردن دوربین ممکن نشد.';

  @override
  String get ocrNoGallery => 'باز کردن گالری ممکن نشد.';

  @override
  String get ocrScanTitle => 'اسکن رسید';

  @override
  String get ocrScanAnother => 'اسکن رسید دیگر';

  @override
  String get ocrScanBody =>
      'عکس بگیرید یا یکی را انتخاب کنید. برنامه آن را می‌خواند و هوش مصنوعی جزئیات را پر می‌کند.';

  @override
  String get ocrReadingWithAi => 'هوش مصنوعی در حال خواندن رسید شماست…';

  @override
  String get ocrNothingRead =>
      'هیچ متنی از این عکس خوانده نشد. در نور بهتر و با کل رسید در کادر دوباره امتحان کنید.';

  @override
  String get ocrAiOfferTitle => 'بگذارید هوش مصنوعی آن را درست بخواند';

  @override
  String get ocrAiOfferBody =>
      'مبلغ کل واقعی، تاریخ، هر قلم و دسته درست را پیدا می‌کند، حتی روی رسیدهای نامرتب.';

  @override
  String get ocrReadWithAi => 'خواندن با هوش مصنوعی';

  @override
  String get ocrReadByAi =>
      'خوانده‌شده توسط هوش مصنوعی. پیش از ذخیره بررسی کنید.';

  @override
  String get ocrItems => 'اقلام';

  @override
  String get quickAddTitle => 'توصیفش کنید';

  @override
  String get quickAddSubtitle =>
      'همان‌طور که می‌گویید بنویسید. هوش مصنوعی فرم را برای بررسی شما پر می‌کند.';

  @override
  String get quickAddHint => 'مثلاً ناهار 250 دیروز از bKash';

  @override
  String get quickAddFill => 'پر کن';

  @override
  String get summaryTitle => 'خلاصه ماهانه';

  @override
  String get summarySpent => 'هزینه این ماه';

  @override
  String summaryEarned(String amount) {
    return 'درآمد $amount';
  }

  @override
  String summaryLessThanLast(int percent) {
    return '$percent% کمتر از ماه گذشته';
  }

  @override
  String summaryMoreThanLast(int percent) {
    return '$percent% بیشتر از ماه گذشته';
  }

  @override
  String get summaryAiTitle => 'ماه شما، به‌طور خلاصه';

  @override
  String get summaryAiBody =>
      'هوش مصنوعی ماه شما را با ماه قبل مقایسه می‌کند و نکات برجسته را همراه با یک پیشنهاد برای امتحان بیان می‌کند.';

  @override
  String get summaryWrite => 'خلاصه‌ام را بنویس';

  @override
  String get summaryOutdated =>
      'تراکنش‌های شما از زمان نوشتن این خلاصه تغییر کرده‌اند.';

  @override
  String get summaryUpdate => 'به‌روزرسانی خلاصه';

  @override
  String get summaryWriting => 'در حال نوشتن خلاصه شما…';

  @override
  String get summaryByCategory => 'بر اساس دسته';

  @override
  String get summaryNoSpending => 'هنوز هزینه‌ای در این ماه ثبت نشده است.';

  @override
  String themeTrialUntil(String time) {
    return 'تم‌های Premium تا $time باز هستند';
  }

  @override
  String get zakatTitle => 'زکات';

  @override
  String get zakatSubtitle =>
      'زکات واجب بر دارایی‌تان را محاسبه و پرداخت‌هایتان را ثبت کنید';

  @override
  String get zakatSubtitleOff =>
      'شما زکات نمی‌پردازید. برای بررسی در هر حال بزنید';

  @override
  String get zakatAskTitle => 'آیا زکات می‌پردازید؟';

  @override
  String get zakatAskBody =>
      'همه نمی‌پردازند. اگر شما نمی‌پردازید، برنامه زکات را از سر راهتان برمی‌دارد: نه سررسیدی و نه یادآوری.';

  @override
  String get zakatIPay => 'زکات می‌پردازم';

  @override
  String get zakatIDontPay => 'زکات نمی‌پردازم';

  @override
  String get zakatOffTitle => 'شما زکات نمی‌پردازید';

  @override
  String get zakatOffBody =>
      'بنابراین هیچ زکاتی سررسید نشان داده نمی‌شود و یادآوری زکات هم نیست. همچنان هر زمان می‌توانید ببینید چقدر می‌شد؛ نگاه کردن پاسخ شما را تغییر نمی‌دهد.';

  @override
  String get zakatOffPeek => 'ببینید چقدر می‌شود';

  @override
  String get zakatPeekBanner => 'فقط یک نگاه. گفته‌اید زکات نمی‌پردازید.';

  @override
  String get zakatOptOutTitle => 'پیگیری زکات متوقف شود؟';

  @override
  String get zakatOptOutBody =>
      'هیچ چیزی سررسید نشان داده نمی‌شود و یادآوری زکات نخواهد بود. ارقام شما حفظ می‌شوند و هر زمان می‌توانید اینجا بررسی‌شان کنید.';

  @override
  String get zakatDue => 'زکات واجب';

  @override
  String zakatAboveNisab(String amount) {
    return 'بالای نصاب: 2.5% از $amount دارایی خالص';
  }

  @override
  String zakatBelowNisab(String amount) {
    return '$amount کمتر از نصاب، پس زکاتی واجب نیست';
  }

  @override
  String get zakatNeedPrice => 'برای بررسی نصاب، قیمت هر گرم را وارد کنید';

  @override
  String get zakatPaidSoFar => 'پرداخت‌شده امسال';

  @override
  String get zakatLeftToPay => 'مانده پرداخت';

  @override
  String zakatNextDate(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'تاریخ زکات $date، $days روز دیگر',
      one: 'تاریخ زکات فردا، $date',
      zero: 'تاریخ زکات شما امروز است',
    );
    return '$_temp0';
  }

  @override
  String get zakatNoDate =>
      'تاریخ زکات خود را تنظیم کنید تا سال را پیگیری کنید و یادآوری بگیرید';

  @override
  String get zakatPay => 'پرداخت زکات';

  @override
  String get zakatNisab => 'نصاب';

  @override
  String get zakatBasisGold => 'طلا';

  @override
  String get zakatBasisSilver => 'نقره';

  @override
  String get zakatBasisHint =>
      'نقره نصاب پایین‌تری دارد و وقتی بیشتر دارایی‌تان نقد است، انتخاب محتاطانه‌تری است. قیمت امروز یک گرم را در بازار محلی وارد کنید.';

  @override
  String zakatPricePerGram(String metal) {
    return 'قیمت هر گرم ($metal)';
  }

  @override
  String zakatNisabWeight(String grams) {
    return '$grams گرم با این قیمت';
  }

  @override
  String get zakatGroupCash => 'نقد و بانک';

  @override
  String get zakatGroupDeposits => 'سپرده‌های پس‌انداز';

  @override
  String get zakatGroupInvestments => 'سرمایه‌گذاری‌ها';

  @override
  String get zakatGroupMetals => 'طلا و نقره';

  @override
  String get zakatGroupLent => 'پول قرض داده به دیگران';

  @override
  String get zakatGroupOtherAssets => 'سایر دارایی‌ها';

  @override
  String get zakatGroupPaid => 'زکات پرداخت‌شده امسال';

  @override
  String get zakatGroupManual => 'افزوده‌شده توسط شما';

  @override
  String get zakatGroupBorrowed => 'کسر: بدهی‌های شما';

  @override
  String get zakatGroupCards => 'کسر: بدهی کارت اعتباری';

  @override
  String get zakatOtherAssetsNote =>
      'زمین، خانه یا خودرویی که استفاده می‌کنید مشمول زکات نیست. فقط اگر برای تجارت نگه می‌دارید روشنش کنید.';

  @override
  String get zakatPaidNote =>
      'دوباره اضافه شد، چون پس از محاسبه دارایی سال از حساب‌هایتان خارج شده است.';

  @override
  String get zakatNoMetals =>
      'طلا یا نقره‌ای ثبت نشده است. آن را به‌عنوان دارایی اضافه کنید یا ارزشش را در زیر وارد کنید.';

  @override
  String get zakatAddAmount => 'افزودن مبلغ';

  @override
  String get zakatAmountLabel => 'این چیست؟';

  @override
  String get zakatAmountHint => 'موجودی کالای تجاری، پول نقد در خانه…';

  @override
  String get zakatAmountDeduct => 'این یک بدهی سررسیدشده است';

  @override
  String get zakatWealth => 'دارایی مشمول زکات';

  @override
  String get zakatDeductions => 'بدهی‌های سررسیدشده';

  @override
  String get zakatNet => 'دارایی خالص';

  @override
  String get zakatRate => '2.5% از دارایی خالص';

  @override
  String get zakatYear => 'سال زکات';

  @override
  String get zakatDate => 'تاریخ زکات';

  @override
  String get zakatDateHint =>
      'روزی که سال زکات شما کامل می‌شود. هر سال قمری، یعنی 354 روز، تکرار می‌شود.';

  @override
  String get zakatRemind => 'یادآوری کن';

  @override
  String get zakatRemindHint => '3 روز قبل، و در همان روز';

  @override
  String get zakatDisclaimer =>
      'این راهنمایی برای کمک به محاسبه زکات است، نه حکم شرعی. علما در برخی جزئیات اختلاف نظر دارند؛ در صورت تردید از یک عالم محلی بپرسید.';

  @override
  String get zakatPayNote =>
      'به‌عنوان هزینه در دسته زکات ثبت و برای امسال محاسبه می‌شود.';

  @override
  String get zakatPayRecord => 'ثبت پرداخت';

  @override
  String get zakatPaidSnack => 'زکات ثبت شد';

  @override
  String get aiToolZakat => 'در حال محاسبه زکات…';

  @override
  String get voiceButton => 'تراکنش را بگویید';

  @override
  String get voiceTitle => 'بگویید';

  @override
  String get voiceUnlimited => 'نامحدود';

  @override
  String get voiceTapToTalk => 'روی دایره بزنید و بگویید چه خرج کردید';

  @override
  String get voiceListening => 'در حال گوش دادن…';

  @override
  String get voiceStop => 'توقف گوش دادن';

  @override
  String get voiceTypeInstead => 'تایپ';

  @override
  String get voiceSpeakInstead => 'صحبت';

  @override
  String get voiceSend => 'تمام';

  @override
  String get voiceTrySaying => 'امتحان کنید بگویید';

  @override
  String get voiceExample1 => 'ناهار 250، تاکسی 60';

  @override
  String get voiceExample2 => 'حقوقم رسید، 45,000';

  @override
  String get voiceExample3 => 'چای دیروز 30 بود، نه 20';

  @override
  String get voiceExample4 => 'ناهار امروز را حذف کن';

  @override
  String get voiceTypeHint => 'ناهار 250 و تاکسی 60 از bKash';

  @override
  String get voiceThinking => 'در حال بررسی…';

  @override
  String get voiceTryAgain => 'دوباره';

  @override
  String get voiceSaving => 'در حال ذخیره…';

  @override
  String get voiceEdit => 'ویرایش';

  @override
  String get voiceNeedsYou => 'نیاز به شما';

  @override
  String get voiceNew => 'جدید';

  @override
  String get voiceChange => 'تغییر';

  @override
  String get voiceRemove => 'حذف';

  @override
  String get voiceNeedsAmount =>
      'مبلغی گفته نشد. برای افزودن این مورد آن را وارد کنید.';

  @override
  String get voiceAdjust => 'تنظیم';

  @override
  String get voiceFillIn => 'تکمیل';

  @override
  String get voiceTime => 'ساعت';

  @override
  String get voiceUndo => 'واگرد';

  @override
  String get voiceUndone => 'به حالت قبل برگشت';

  @override
  String get voiceNoSpeech => 'متوجه نشدم. دوباره امتحان کنید یا تایپ کنید.';

  @override
  String get voiceMicOff =>
      'دسترسی به میکروفون خاموش است. در تنظیمات اجازه دهید یا تایپ کنید.';

  @override
  String get voiceUnavailable =>
      'صدا در این گوشی در دسترس نیست. می‌توانید تایپ کنید.';

  @override
  String get voiceSomethingWrong => 'مشکلی پیش آمد. دوباره تلاش کنید.';

  @override
  String get voiceFabSetting => 'میکروفون شناور در صفحه امروز';

  @override
  String get amountHidden => 'مبلغ پنهان';

  @override
  String get privacyShowAmounts => 'نمایش مبالغ';

  @override
  String get privacyHideAmounts => 'پنهان کردن مبالغ';

  @override
  String get privacyAmounts => 'مبالغ روی صفحه';

  @override
  String get privacyAmountsFooter =>
      'موجودی‌ها و مجموع‌ها تار می‌شوند تا اطرافیان نتوانند آن‌ها را بخوانند. تراکنش‌های تکی قابل مشاهده می‌مانند. آیکون چشم در صفحه امروز هم آن‌ها را نشان می‌دهد یا پنهان می‌کند.';

  @override
  String get privacyHideTitle => 'پنهان کردن موجودی‌ها و مجموع‌ها';

  @override
  String get privacyHideSub => 'تا وقتی خودتان بخواهید تار بمانند';

  @override
  String get privacyTapTitle => 'برای نمایش مبلغ پنهان روی آن بزنید';

  @override
  String get privacyTapSub =>
      'در غیر این صورت فقط آیکون چشم در صفحه امروز آن‌ها را نشان می‌دهد';

  @override
  String get privacyStartTitle => 'هنگام باز شدن برنامه';

  @override
  String get privacyStartHidden => 'پنهان';

  @override
  String get privacyStartHiddenSub =>
      'همیشه با موجودی‌ها و مجموع‌های پنهان باز شود';

  @override
  String get privacyStartShown => 'نمایان';

  @override
  String get privacyStartShownSub =>
      'همیشه با موجودی‌ها و مجموع‌های نمایان باز شود';

  @override
  String get privacyStartRemember => 'همان‌طور که گذاشتم';

  @override
  String get privacyStartRememberSub => 'با آخرین وضعیت آیکون چشم باز شود';

  @override
  String get privacyIntroTitle => 'جدید: موجودی‌هایتان را پنهان کنید';

  @override
  String get privacyIntroBody =>
      'موجودی‌ها و مجموع‌ها اکنون پنهان هستند تا اطرافیان نتوانند آن‌ها را بخوانند. برای نمایش یا پنهان کردن، روی آیکون چشم در صفحه امروز بزنید؛ برنامه وضعیت را به خاطر می‌سپارد. نحوه باز شدن برنامه را می‌توانید در تنظیمات انتخاب کنید.';

  @override
  String get privacyIntroOk => 'متوجه شدم';

  @override
  String get privacyIntroSettings => 'انتخاب در تنظیمات';

  @override
  String get voiceFabSettingSub =>
      'میکروفونی شناور روی صفحه امروز، برای گفتن تراکنش';

  @override
  String get voiceFabAskTitle => 'میکروفون به صفحه امروز اضافه شود؟';

  @override
  String get voiceFabAskBody =>
      'روی آن بزنید و بگویید چه خرج کردید، مثلاً \"ناهار 250 و تاکسی 60\". پیش از ذخیره همه چیز را بررسی می‌کنید. هر جا خواستید آن را بکشید.';

  @override
  String get voiceFabAskYes => 'بله، میکروفون اضافه شود';

  @override
  String get voiceFabAskNo => 'الان نه';

  @override
  String get voiceFabAskLater =>
      'هر زمان می‌توانید آن را در بخش «بیشتر» روشن یا خاموش کنید.';

  @override
  String get voiceFabHideTitle => 'میکروفون شناور پنهان شود؟';

  @override
  String get voiceFabHideBody =>
      'میکروفون بالای صفحه امروز باقی می‌ماند. این یکی را می‌توانید از بخش «بیشتر» برگردانید.';

  @override
  String get voiceFabHide => 'پنهان کن';

  @override
  String voiceReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد آماده ذخیره',
      one: '1 مورد آماده ذخیره',
      zero: 'چیزی آماده نیست',
    );
    return '$_temp0';
  }

  @override
  String voiceSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذخیره $count',
      one: 'ذخیره 1',
      zero: 'چیزی انتخاب نشده',
    );
    return '$_temp0';
  }

  @override
  String voiceSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش ذخیره شد',
      one: '1 تراکنش ذخیره شد',
    );
    return '$_temp0';
  }
}
