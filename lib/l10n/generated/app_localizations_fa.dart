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
  String get settingsBillRemindersNote =>
      'یادآوری صورت‌حساب کارت و اقساط برنامه‌ها را خود برنامه روی گوشی شما محاسبه می‌کند تا مبالغ شما خصوصی بماند. اگر چند روز برنامه را باز نکنید، ممکن است یادآوری دیر برسد یا از دست برود.';

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
  String get voiceNeedsConnection =>
      'صدا به اتصال اینترنت نیاز دارد. می‌توانید به‌جایش تایپ کنید.';

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
  String get ppTitle => 'محافظت با عبارت عبور';

  @override
  String get ppRowOn => 'روشن';

  @override
  String get ppRowOff => 'خاموش';

  @override
  String get ppRowLocked => 'روی این گوشی قفل است';

  @override
  String get ppIntro =>
      'داده‌هایتان همین حالا روی این گوشی و در نسخه‌های پشتیبانتان رمزگذاری شده است. عبارت عبور یک قفل دیگر اضافه می‌کند تا فقط خودتان بتوانید داده‌های همگام‌شده و نسخه‌های پشتیبانتان را باز کنید — حتی ما هم نمی‌توانیم.';

  @override
  String get ppWithoutTitle => 'بدون عبارت عبور (وضعیت فعلی)';

  @override
  String get ppWithout1 => 'همه‌چیز روی این گوشی رمزگذاری شده است.';

  @override
  String get ppWithout2 =>
      'نسخه‌های پشتیبان و داده‌های همگام‌شده با کلیدی وابسته به حسابتان رمزگذاری می‌شوند.';

  @override
  String get ppWithout3 =>
      'روی گوشی جدید وارد حسابتان شوید و همه‌چیز برمی‌گردد، بی‌آنکه لازم باشد چیزی را به خاطر بسپارید.';

  @override
  String get ppWithout4 =>
      'این کلید روی سرور ما نگهداری می‌شود، پس در اصل ما می‌توانیم داده‌های همگام‌شده شما را باز کنیم.';

  @override
  String get ppWithTitle => 'با عبارت عبور';

  @override
  String get ppWith1 =>
      'فقط عبارت عبور یا کد بازیابی شما می‌تواند داده‌های همگام‌شده و نسخه‌های پشتیبانتان را باز کند.';

  @override
  String get ppWith2 =>
      'سرور ما فقط نسخه‌های قفل‌شده کلید شما را نگه می‌دارد. ما نمی‌توانیم داده‌هایتان را بخوانیم، و هر کسی هم که به سرورهای ما نفوذ کند نمی‌تواند.';

  @override
  String get ppWith3 =>
      'روی گوشی جدید، یا پس از نصب دوباره، یک بار عبارت عبورتان را وارد می‌کنید.';

  @override
  String get ppWith4 =>
      'این گوشی دقیقاً مثل الان کار می‌کند، حتی به‌صورت آفلاین.';

  @override
  String get ppCatchTitle => 'نکته مهم';

  @override
  String get ppCatchBody =>
      'اگر عبارت عبورتان را فراموش کنید و کد بازیابی‌تان را هم گم کنید، هیچ‌کس نمی‌تواند داده‌های همگام‌شده یا نسخه‌های پشتیبانتان را بازیابی کند — نه ما، نه هیچ‌کس دیگر. آنچه همین حالا روی این گوشی است، اینجا همچنان قابل خواندن می‌ماند.';

  @override
  String get ppAiNote =>
      'قابلیت‌های هوش مصنوعی همچنان خلاصه‌ای از وضعیت مالی شما را ارسال می‌کنند تا بتوانند پاسخ دهند. عبارت عبور این را تغییر نمی‌دهد.';

  @override
  String get ppSetButton => 'تنظیم عبارت عبور';

  @override
  String get ppSetTitle => 'یک عبارت عبور انتخاب کنید';

  @override
  String get ppSetHint =>
      'دست‌کم از 10 نویسه استفاده کنید. چند کلمه بی‌ربط به هم، به خاطر سپردنشان آسان و حدس زدنشان دشوار است.';

  @override
  String get ppPassphraseLabel => 'عبارت عبور';

  @override
  String get ppConfirmLabel => 'دوباره وارد کنید';

  @override
  String get ppTooShort => 'دست‌کم از 10 نویسه استفاده کنید.';

  @override
  String get ppMismatch => 'دو عبارت عبور با هم یکسان نیستند.';

  @override
  String get ppUnderstand =>
      'می‌دانم که اگر هم عبارت عبور و هم کد بازیابی‌ام را گم کنم، داده‌های همگام‌شده و نسخه‌های پشتیبانم قابل بازیابی نخواهند بود.';

  @override
  String get ppTurnOn => 'روشن کردن محافظت';

  @override
  String get ppWorking => 'در حال قفل کردن کلید شما. چند ثانیه طول می‌کشد…';

  @override
  String get ppMaybeSaved =>
      'اتصال قطع شد، پس ممکن است سرور این را از قبل ذخیره کرده باشد. دوباره انجامش دهید تا کد بازیابی را ببینید، و همان را نگه دارید.';

  @override
  String get ppRecoveryTitle => 'کد بازیابی شما';

  @override
  String get ppRecoveryBody =>
      'اگر عبارت عبورتان را فراموش کنید، این تنها راه دیگر برای دسترسی به داده‌هایتان است. آن را یادداشت کنید یا در یک برنامه مدیریت رمز عبور نگه دارید — جایی غیر از این گوشی.';

  @override
  String get ppCopy => 'کپی';

  @override
  String get ppCopied => 'کد بازیابی کپی شد';

  @override
  String get ppSavedIt => 'کد بازیابی‌ام را جای امنی ذخیره کرده‌ام';

  @override
  String get ppDone => 'انجام شد';

  @override
  String get ppOnTitle => 'محافظت روشن است';

  @override
  String get ppOnBody =>
      'فقط عبارت عبور یا کد بازیابی شما می‌تواند داده‌های همگام‌شده و نسخه‌های پشتیبانتان را باز کند.';

  @override
  String get ppChange => 'تغییر عبارت عبور';

  @override
  String get ppNewCode => 'دریافت کد بازیابی جدید';

  @override
  String get ppNewCodeWarn =>
      'کد بازیابی فعلی‌تان دیگر کار نخواهد کرد. حتماً کد جدید را ذخیره کنید.';

  @override
  String get ppTurnOff => 'خاموش کردن محافظت';

  @override
  String get ppTurnOffBody =>
      'سرور ما مانند قبل دوباره کلید شما را نگه می‌دارد. داده‌هایتان رمزگذاری‌شده می‌مانند، اما در اصل ما می‌توانیم داده‌های همگام‌شده شما را باز کنیم.';

  @override
  String get ppLockedTitle => 'باز کردن قفل داده‌ها';

  @override
  String get ppLockedBody =>
      'داده‌هایتان با عبارت عبور محافظت می‌شوند. برای باز کردن داده‌های همگام‌شده و نسخه‌های پشتیبانتان، یک بار آن را روی این گوشی وارد کنید.';

  @override
  String get ppUnlock => 'باز کردن قفل';

  @override
  String get ppUseRecovery => 'استفاده از کد بازیابی به‌جای آن';

  @override
  String get ppUsePassphrase => 'استفاده از عبارت عبور به‌جای آن';

  @override
  String get ppRecoveryLabel => 'کد بازیابی';

  @override
  String get ppWrongPassphrase => 'این عبارت عبور درست نیست.';

  @override
  String get ppWrongRecovery => 'این کد بازیابی درست نیست.';

  @override
  String get ppUnlocked => 'قفل روی این گوشی باز شد';

  @override
  String get ppChanged => 'عبارت عبور تغییر کرد';

  @override
  String get ppTurnedOn => 'محافظت روشن شد';

  @override
  String get ppTurnedOff => 'محافظت خاموش شد';

  @override
  String get encIntroTitle => 'داده‌های شما اکنون رمزگذاری شده‌اند';

  @override
  String get encIntroBody =>
      'همه‌چیز روی این گوشی رمزگذاری‌شده ذخیره می‌شود و پشتیبان‌ها و داده‌های همگام‌شده پیش از خروج از گوشی رمزگذاری می‌شوند. لازم نیست کاری انجام دهید.';

  @override
  String get encIntroPassphrase =>
      'قفل بیشتری می‌خواهید؟ یک عبارت عبور تعیین کنید تا فقط خودتان بتوانید داده‌های همگام‌شده و پشتیبان‌ها را باز کنید — حتی ما هم نه. این کار اختیاری است؛ اگر عبارت عبور و کد بازیابی آن را هر دو گم کنید، آن داده‌ها قابل بازیابی نیستند.';

  @override
  String get encIntroSetUp => 'تعیین عبارت عبور';

  @override
  String get encIntroNotNow => 'حالا نه';

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

  @override
  String get ppNeedsConnection =>
      'تنظیمات عبارت عبور به اتصال اینترنت نیاز دارد. به یک شبکه وصل شوید و دوباره این را باز کنید.';

  @override
  String get offlineToast =>
      'آفلاین هستید. هر چه اضافه کنید روی همین گوشی ذخیره می‌شود و وقتی دوباره آنلاین شوید همگام‌سازی می‌شود.';

  @override
  String get backupLockedTitle => 'باز کردن قفل این نسخهٔ پشتیبان';

  @override
  String get backupLockedBody =>
      'این نسخهٔ پشتیبان با یک عبارت عبور محافظت شده است. برای باز کردنش آن را یا کد بازیابی‌تان را وارد کنید. این کار بدون اتصال اینترنت هم انجام می‌شود.';

  @override
  String get settingsSupportDescribeFirst => 'لطفاً اول مشکلتان را توضیح دهید';

  @override
  String get settingsSupportSent => 'ممنون! پیامتان ارسال شد.';

  @override
  String get settingsSupportSendFailed =>
      'الان ارسال نشد. لطفاً دوباره امتحان کنید یا مستقیم به ما ایمیل بزنید.';

  @override
  String get settingsSupportSubjectHint => 'موضوع چیست؟';

  @override
  String get settingsSupportMessageHint =>
      'سؤال، مشکل یا بازخوردتان را بنویسید…';

  @override
  String get settingsSupportHeroBody =>
      'سؤال، باگ یا بازخورد — برایمان بفرستید تا پاسخ دهیم.';

  @override
  String get settingsSupportTipDescription => 'توضیح روشنی از مشکلتان';

  @override
  String get settingsSupportTipSteps => 'مراحل تکرار مشکل (اگر باگ است)';

  @override
  String get settingsSupportTipDevice => 'مدل دستگاه و نسخه Android شما';

  @override
  String settingsSupportPreferEmail(String email) {
    return 'ایمیل را ترجیح می‌دهید؟ $email';
  }

  @override
  String get settingsSupportEmailCopied => 'ایمیل در کلیپ‌بورد کپی شد';

  @override
  String get settingsAboutTagline => 'همراه مالی شخصی شما';

  @override
  String settingsAboutVersion(String version) {
    return 'نسخه: $version';
  }

  @override
  String get settingsAboutDescription =>
      'یک برنامه مالی شخصی با تمرکز\nبر حریم خصوصی و طراحی زیبا.';

  @override
  String settingsBaseCurrencyLabel(String currency) {
    return 'ارز پایه: $currency';
  }

  @override
  String settingsRatesLastUpdated(String when) {
    return 'آخرین به‌روزرسانی: $when';
  }

  @override
  String settingsEditRateTitle(String base, String target) {
    return 'ویرایش نرخ: $base → $target';
  }

  @override
  String settingsCurrentApiRate(String rate) {
    return 'نرخ فعلی API: $rate';
  }

  @override
  String settingsMinutesAgo(int count) {
    return '$count دقیقه پیش';
  }

  @override
  String settingsHoursAgo(int count) {
    return '$count ساعت پیش';
  }

  @override
  String settingsDaysAgo(int count) {
    return '$count روز پیش';
  }

  @override
  String get settingsExportSectionDateRange => 'بازه زمانی';

  @override
  String get settingsExportSectionFormat => 'قالب';

  @override
  String get settingsExportSectionInclude => 'شامل';

  @override
  String get settingsExportAllTime => 'همه زمان‌ها';

  @override
  String get settingsExportThisMonth => 'این ماه';

  @override
  String get settingsExportLastMonth => 'ماه گذشته';

  @override
  String get settingsExportLast3Months => '3 ماه گذشته';

  @override
  String get settingsExportThisYear => 'امسال';

  @override
  String get settingsExportPdfPremiumBody =>
      'خروجی CSV رایگان است — داده‌هایتان همیشه مال خودتان است. گزارش PDF قالب‌بندی‌شده، با خلاصه‌ها و تفکیک بر اساس دسته و کیف پول، از قابلیت‌های Premium است.';

  @override
  String settingsExportButton(String format) {
    return 'خروجی $format';
  }

  @override
  String settingsExportFailed(String error) {
    return 'خروجی گرفتن ناموفق بود: $error';
  }

  @override
  String get settingsExportShareSubject => 'The Accountant - خروجی';

  @override
  String settingsExportedCount(int count) {
    return '$count تراکنش خروجی گرفته شد';
  }

  @override
  String get settingsExportPdfShareSubject => 'The Accountant - گزارش مالی';

  @override
  String settingsExportPdfGenerated(int count) {
    return 'گزارش PDF با $count تراکنش ساخته شد';
  }

  @override
  String get settingsNumberFormatCommaThousands => 'ویرگول برای هزارگان';

  @override
  String get settingsNumberFormatDotThousands => 'نقطه برای هزارگان';

  @override
  String get settingsNumberFormatSpaceThousands => 'فاصله برای هزارگان';

  @override
  String get settingsNumberFormatNoSeparator => 'بدون جداکننده';

  @override
  String get settingsAutoLockImmediately => 'فوراً';

  @override
  String settingsAutoLockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقیقه',
      one: '1 دقیقه',
    );
    return '$_temp0';
  }

  @override
  String get settingsAutoLockNever => 'هرگز';

  @override
  String get settingsBiometricUnavailable =>
      'احراز هویت بیومتریک روی این دستگاه در دسترس نیست';

  @override
  String get settingsSetPassword => 'تنظیم رمز عبور';

  @override
  String get settingsChangePassword => 'تغییر رمز عبور';

  @override
  String get settingsAddPasswordSubtitle => 'برای حسابتان رمز عبور بگذارید';

  @override
  String get settingsPasswordChanged => 'رمز عبور با موفقیت تغییر کرد';

  @override
  String get settingsPasswordSet => 'رمز عبور با موفقیت تنظیم شد';

  @override
  String get settingsClearCacheBody =>
      'این کار داده‌های موقت را پاک می‌کند و در اجرای بعدی برنامه، همگام‌سازی دوباره انجام می‌شود. داده‌هایتان حذف نمی‌شود.';

  @override
  String get settingsClearingCache => 'در حال پاک کردن حافظه موقت...';

  @override
  String get settingsCacheCleared => 'حافظه موقت پاک شد و همگام‌سازی آغاز شد';

  @override
  String get settingsClearCacheFailed => 'پاک کردن حافظه موقت ناموفق بود';

  @override
  String get settingsClearAllDataBody =>
      'این کار همه تراکنش‌ها، بودجه‌ها، کیف پول‌ها، دسته‌ها و تنظیمات شما را برای همیشه حذف می‌کند. این کار قابل بازگشت نیست!';

  @override
  String get settingsClearAllDataConfirmBody =>
      'همه داده‌های مالی شما برای همیشه پاک خواهد شد.';

  @override
  String get settingsClearingAllData => 'در حال پاک کردن همه داده‌ها...';

  @override
  String get settingsAllDataCleared => 'همه داده‌ها با موفقیت پاک شد';

  @override
  String settingsClearDataFailed(String error) {
    return 'پاک کردن داده‌ها ناموفق بود: $error';
  }

  @override
  String get settingsDeleteAccountBody =>
      'به فرمی هدایت می‌شوید تا درخواست حذف حساب بدهید. این فرایند چند روز طول می‌کشد. پس از انجام، همه داده‌ها روی سرور برای همیشه حذف می‌شود.';

  @override
  String get settingsLockAuthFailed =>
      'احراز هویت ناموفق بود. لطفاً دوباره امتحان کنید.';

  @override
  String get settingsLockError => 'خطایی رخ داد. لطفاً دوباره امتحان کنید.';

  @override
  String get settingsLockAuthenticating => 'در حال احراز هویت...';

  @override
  String get settingsProfileNameEmpty => 'نام نمی‌تواند خالی باشد';

  @override
  String get settingsProfileUpdated => 'پروفایل با موفقیت به‌روز شد';

  @override
  String get settingsProfileUpdateFailed => 'به‌روزرسانی پروفایل ناموفق بود';

  @override
  String get settingsProfileSaveChanges => 'ذخیره تغییرات';

  @override
  String get settingsProfileSaved => 'ذخیره شد';

  @override
  String get settingsProfilePhotoSoon => 'بارگذاری عکس به‌زودی';

  @override
  String get settingsProfileAccountInformation => 'اطلاعات حساب';

  @override
  String get settingsProfileMemberSince => 'عضو از';

  @override
  String get settingsProfileUnknown => 'نامشخص';

  @override
  String get settingsProfileFree => 'رایگان';

  @override
  String get settingsProfileUserId => 'شناسه کاربر';

  @override
  String get settingsProfileUserIdCopied => 'شناسه کاربر کپی شد';

  @override
  String get settingsPremiumMonthly => 'Premium ماهانه';

  @override
  String get settingsPremiumYearly => 'Premium سالانه';

  @override
  String get settingsPremiumLifetime => 'Premium مادام‌العمر';

  @override
  String get settingsUnsavedChangesBody =>
      'تغییرات ذخیره‌نشده دارید. مطمئنید می‌خواهید خارج شوید؟';

  @override
  String settingsShareAppText(String url) {
    return 'The Accountant را ببین - یک برنامه مالی شخصی زیبا!\n\n$url';
  }

  @override
  String get settingsShareAppSubject => 'The Accountant - برنامه مالی شخصی';

  @override
  String get settingsCloudSyncGateBody =>
      'داده‌های مالی‌تان را روی همه دستگاه‌هایتان همگام نگه دارید. دیگر هرگز داده‌هایتان را از دست ندهید.';

  @override
  String settingsSyncPushed(int count) {
    return '$count ارسال شد';
  }

  @override
  String settingsSyncPulled(int count) {
    return '$count دریافت شد';
  }

  @override
  String settingsSyncConflicts(int count) {
    return '$count تعارض';
  }

  @override
  String get settingsSyncNowSubtitle => 'ارسال و دریافت همه تغییرات';

  @override
  String settingsSyncComplete(int pushed, int pulled) {
    return 'همگام‌سازی کامل شد — $pushed ارسال، $pulled دریافت';
  }

  @override
  String settingsSyncIncomplete(int count, String details) {
    return 'همگام‌سازی ناقص ماند — $count مورد ذخیره نشد و دوباره تلاش می‌شود. $details';
  }

  @override
  String settingsSyncFailed(String error) {
    return 'همگام‌سازی ناموفق بود: $error';
  }

  @override
  String get settingsRestoreFromCloudSubtitle =>
      'جایگزینی داده‌های این دستگاه با داده‌های ابری شما';

  @override
  String get settingsRestoreFromCloudBody =>
      'این کار همه داده‌های این دستگاه را پاک می‌کند و داده‌های ابری‌تان را جایگزین آن می‌کند. هر تغییری روی این دستگاه که هنوز همگام نشده از دست می‌رود. این کار قابل بازگشت نیست.';

  @override
  String settingsRestoredFromCloud(int count) {
    return '$count مورد از فضای ابری بازیابی شد';
  }

  @override
  String settingsRestoreCancelled(String details) {
    return 'بازیابی لغو شد — داده‌های این دستگاه دست‌نخورده ماند. $details';
  }

  @override
  String settingsRestoreFailed(String error) {
    return 'بازیابی ناموفق بود: $error';
  }

  @override
  String get settingsSyncInfoBody =>
      'داده‌هایتان هر 15 دقیقه و هر بار که برنامه را باز می‌کنید خودکار همگام می‌شود. مبالغ، نام‌ها و یادداشت‌ها پیش از همگام‌سازی روی همین گوشی رمزگذاری می‌شوند، پس سرور ما نمی‌تواند آن‌ها را بخواند.';

  @override
  String settingsSyncCompletedSeconds(int seconds) {
    return 'در $seconds ثانیه انجام شد';
  }

  @override
  String settingsSyncCompletedMinutes(int minutes, int seconds) {
    return 'در $minutes دقیقه و $seconds ثانیه انجام شد';
  }

  @override
  String settingsReconcileQuestion(String name) {
    return 'آیا این دسته «$name» شماست؟';
  }

  @override
  String get settingsReconcileSavedPending =>
      'ذخیره شد. در همگام‌سازی بعدی اعمال می‌شود.';

  @override
  String settingsReconcileBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'حساب شما از قبل $count دسته به نام «$name» دارد. بگویید یکی از آن‌ها را به‌عنوان دسته پیش‌فرض استفاده کنیم یا جدا نگه داریم. تا انتخاب نکنید چیزی تغییر نمی‌کند.',
      one:
          'حساب شما از قبل دسته‌ای به نام «$name» دارد. بگویید آن را به‌عنوان دسته پیش‌فرض استفاده کنیم یا جدا نگه داریم. تا انتخاب نکنید چیزی تغییر نمی‌کند.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepMine =>
      'نه — مال خودم بماند و یک دسته جدا اضافه شود';

  @override
  String get settingsReconcileNoneOfThese => 'هیچ‌کدام — یک دسته جدا اضافه شود';

  @override
  String settingsReconcileKeepSeparateBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'دسته‌های «$name» فعلی شما با همه تراکنش‌هایشان دقیقاً همان‌طور که هستند می‌مانند. یک «$name» پیش‌فرض جدید کنارشان اضافه می‌شود.',
      one:
          'دسته «$name» فعلی شما با همه تراکنش‌هایش دقیقاً همان‌طور که هست می‌ماند. یک «$name» پیش‌فرض جدید کنارش اضافه می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileKeepSeparate => 'جدا نگه دار';

  @override
  String settingsReconcileTransactionCount(int count) {
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
  String settingsReconcileUseTitle(String name) {
    return 'از «$name» استفاده شود؟';
  }

  @override
  String settingsReconcileUseBody(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'به دسته پیش‌فرض «$name» تبدیل می‌شود و هر $count تراکنش آن، همراه با زیردسته‌هایش، حفظ می‌شود. چیزی حذف نمی‌شود.',
      zero:
          'به دسته پیش‌فرض «$name» تبدیل می‌شود و هرچه زیر آن ثبت شده، همراه با زیردسته‌هایش، حفظ می‌شود. چیزی حذف نمی‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get settingsReconcileUseThisOne => 'از این استفاده شود';

  @override
  String settingsReconcileWillUse(String name) {
    return 'از «$name» استفاده می‌شود.';
  }

  @override
  String settingsReconcileWillAdd(String name) {
    return 'یک «$name» جدا اضافه می‌شود.';
  }

  @override
  String get settingsChangePasswordSubtitle =>
      'رمز عبور فعلی را وارد کنید و یک رمز جدید انتخاب کنید';

  @override
  String get settingsSetPasswordSubtitle =>
      'برای امنیت بیشتر، برای حسابتان رمز عبور بگذارید';

  @override
  String get settingsEnterCurrentPassword =>
      'لطفاً رمز عبور فعلی‌تان را وارد کنید';

  @override
  String get settingsEnterNewPassword => 'لطفاً یک رمز عبور جدید وارد کنید';

  @override
  String get settingsPasswordMinLength => 'رمز عبور باید دست‌کم 8 نویسه باشد';

  @override
  String get settingsConfirmYourPassword => 'لطفاً رمز عبورتان را تأیید کنید';

  @override
  String get settingsPasswordsDoNotMatch => 'رمزهای عبور یکسان نیستند';

  @override
  String get settingsPleaseWait => 'لطفاً صبر کنید...';

  @override
  String settingsTypeToConfirm(String word) {
    return 'برای تأیید «$word» را تایپ کنید';
  }

  @override
  String settingsPercentOfBudget(int percent) {
    return '$percent% بودجه';
  }

  @override
  String get authTooManyAttempts =>
      'تلاش‌ها بیش از حد بوده است. لطفاً یک دقیقه صبر کنید و دوباره امتحان کنید.';

  @override
  String get authServerDown =>
      'به سرورهای ما دسترسی پیدا نکردیم. مشکل از طرف ماست — لطفاً چند دقیقه دیگر دوباره امتحان کنید.';

  @override
  String get authInitFailed => 'راه‌اندازی احراز هویت ناموفق بود';

  @override
  String get authSignInError => 'هنگام ورود خطایی رخ داد';

  @override
  String get authSignUpError => 'هنگام ثبت‌نام خطایی رخ داد';

  @override
  String get authGoogleCancelled => 'ورود با Google لغو شد یا ناموفق بود';

  @override
  String get authFirebaseTokenFailed => 'دریافت توکن شناسه Firebase ناموفق بود';

  @override
  String get authGoogleSignInError => 'هنگام ورود با Google خطایی رخ داد';

  @override
  String get authAccountExistsDifferentCredential =>
      'حسابی با همین آدرس ایمیل ولی با روش ورود دیگری از قبل وجود دارد.';

  @override
  String get authInvalidCredential =>
      'اطلاعات ورود ارائه‌شده نادرست است یا منقضی شده است.';

  @override
  String get authGoogleDisabled => 'ورود با Google غیرفعال است.';

  @override
  String get authUserDisabled => 'این حساب کاربری غیرفعال شده است.';

  @override
  String get authAppleSignInError => 'هنگام ورود با Apple خطایی رخ داد';

  @override
  String get authAppleDisabled => 'ورود با Apple غیرفعال است.';

  @override
  String get authNoPendingLink => 'حسابی برای پیوند دادن در انتظار نیست';

  @override
  String get authLinkFailed => 'پیوند دادن حساب ناموفق بود';

  @override
  String get authIncorrectPassword =>
      'رمز عبور نادرست است. لطفاً دوباره امتحان کنید.';

  @override
  String get authSignOutError => 'هنگام خروج از حساب خطایی رخ داد';

  @override
  String get authLinkSubtitle =>
      'حسابی با این ایمیل از قبل وجود دارد. رمز عبورتان را وارد کنید تا حساب Google شما پیوند داده شود.';

  @override
  String get authEnterYourPasswordHint => 'رمز عبورتان را وارد کنید';

  @override
  String get authEnterYourPassword => 'لطفاً رمز عبورتان را وارد کنید';

  @override
  String get authLinkInfo =>
      'پس از پیوند، می‌توانید با ایمیل/رمز عبور یا Google وارد شوید.';

  @override
  String get authEnterYourEmail => 'لطفاً ایمیلتان را وارد کنید';

  @override
  String get authEnterValidEmail => 'لطفاً یک ایمیل معتبر وارد کنید';

  @override
  String get authPasswordMin6 => 'رمز عبور باید دست‌کم 6 نویسه باشد';

  @override
  String get authNoAccountPrompt => 'حساب ندارید؟ ';

  @override
  String get authForgotPasswordTitle => 'فراموشی رمز عبور';

  @override
  String get authCheckYourEmail => 'ایمیلتان را بررسی کنید';

  @override
  String get authForgotPasswordSubtitle =>
      'ایمیلتان را وارد کنید تا کدی برای بازنشانی رمز عبور برایتان بفرستیم.';

  @override
  String authCodeSentSubtitle(String email) {
    return 'یک کد 6 رقمی به $email فرستادیم. آن را همراه با رمز عبور جدیدتان در زیر وارد کنید.';
  }

  @override
  String get authEnterYourEmailHint => 'ایمیلتان را وارد کنید';

  @override
  String get authSixDigitCodeHint => 'کد 6 رقمی';

  @override
  String get authEnterTheCode => 'لطفاً کد را وارد کنید';

  @override
  String get authCodeIsSixDigits => 'کد 6 رقمی است';

  @override
  String get authCreateNewPasswordHint => 'یک رمز عبور جدید بسازید';

  @override
  String get authReenterNewPasswordHint => 'رمز عبور جدید را دوباره وارد کنید';

  @override
  String get authEnterYourNameHint => 'نامتان را وارد کنید';

  @override
  String get authEnterFullName => 'لطفاً نام کاملتان را وارد کنید';

  @override
  String get authNameMin2 => 'نام باید دست‌کم 2 نویسه باشد';

  @override
  String get authCreatePasswordHint => 'یک رمز عبور بسازید';

  @override
  String get authPasswordComplexity =>
      'باید شامل حرف بزرگ، حرف کوچک و عدد باشد';

  @override
  String get authReenterPasswordHint => 'رمز عبورتان را دوباره وارد کنید';

  @override
  String get authStrengthWeak => 'ضعیف';

  @override
  String get authStrengthFair => 'متوسط';

  @override
  String get authStrengthGood => 'خوب';

  @override
  String get authStrengthStrong => 'قوی';

  @override
  String authAgreeToTerms(String terms, String privacy) {
    return 'با $terms و $privacy موافقم';
  }

  @override
  String get authDefaultUserName => 'کاربر';

  @override
  String authMemberSince(String date) {
    return 'عضو از $date';
  }

  @override
  String get authFieldRequired => 'این فیلد الزامی است';

  @override
  String authSignOutFailed(String error) {
    return 'خروج از حساب ناموفق بود: $error';
  }

  @override
  String authPickImageFailed(String error) {
    return 'انتخاب تصویر ناموفق بود: $error';
  }

  @override
  String authUpdateProfileFailed(String error) {
    return 'به‌روزرسانی پروفایل ناموفق بود: $error';
  }

  @override
  String get premiumSaveAbout44 => 'حدود 44% صرفه‌جویی';

  @override
  String get premiumBestValue => 'بهترین ارزش';

  @override
  String get premiumIapUnavailable => 'IAP در دسترس نیست';

  @override
  String get premiumProductNotFound => 'محصول پیدا نشد';

  @override
  String get premiumPlanUnavailable =>
      'این طرح در حال حاضر برای حساب شما در دسترس نیست';

  @override
  String get premiumRestoreFailed => 'بازیابی خریدها ناموفق بود';

  @override
  String get premiumPurchaseFailed => 'خرید ناموفق بود';

  @override
  String get premiumVerificationFailed => 'تأیید ناموفق بود';

  @override
  String premiumPeriodDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز',
      one: '1 روز',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هفته',
      one: '1 هفته',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ماه',
      one: '1 ماه',
    );
    return '$_temp0';
  }

  @override
  String premiumPeriodYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سال',
      one: '1 سال',
    );
    return '$_temp0';
  }

  @override
  String premiumLimitUsed(int count, int limit, String items) {
    return 'از $limit $items رایگان، $count مورد را استفاده کرده‌اید.';
  }

  @override
  String premiumLimitUpgrade(String items) {
    return 'برای $items نامحدود و امکانات بیشتر به Premium ارتقا دهید!';
  }

  @override
  String premiumFreeLimitMessage(int limit, String items) {
    return 'به سقف رایگان $limit $items رسیده‌اید. برای $items نامحدود به Premium ارتقا دهید.';
  }

  @override
  String get premiumLimitWallets => 'کیف پول';

  @override
  String get premiumLimitCategories => 'دسته سفارشی';

  @override
  String get premiumLimitBudgets => 'بودجه فعال';

  @override
  String get premiumLimitObjectives => 'هدف فعال';

  @override
  String get premiumLimitPaymentMethods => 'روش پرداخت';

  @override
  String get backupErrNotJson =>
      'این فایل نسخه پشتیبان نیست — به‌صورت JSON خوانده نشد.';

  @override
  String get backupErrNotOurs => 'این فایل نسخه پشتیبان The Accountant نیست.';

  @override
  String get backupErrNewerVersion =>
      'این نسخه پشتیبان با نسخه جدیدتری از برنامه ساخته شده است. The Accountant را به‌روز کنید و دوباره امتحان کنید.';

  @override
  String backupErrTooOld(int version, int oldest) {
    return 'این نسخه پشتیبان از نسخه‌ای قدیمی‌تر از آن است که این برنامه بتواند بخواند (پایگاه داده $version، قدیمی‌ترین نسخه پشتیبانی‌شده $oldest).';
  }

  @override
  String get backupErrNoData => 'این نسخه پشتیبان هیچ داده‌ای ندارد.';

  @override
  String backupErrSectionDamaged(String section) {
    return 'بخش «$section» این نسخه پشتیبان آسیب دیده است.';
  }

  @override
  String get backupErrNoHeader =>
      'سرآیندی که نوع این نسخه پشتیبان را مشخص می‌کند وجود ندارد.';

  @override
  String get backupErrNoSchemaVersion =>
      'این نسخه پشتیبان مشخص نمی‌کند از کدام نسخه پایگاه داده گرفته شده، پس نمی‌توان آن را با اطمینان بازیابی کرد.';

  @override
  String get backupErrNoDate =>
      'این نسخه پشتیبان مشخص نمی‌کند چه زمانی گرفته شده است.';

  @override
  String get backupErrDamaged => 'این فایل پشتیبان آسیب دیده است.';

  @override
  String get backupErrWrongKey =>
      'این نسخه پشتیبان مال حساب دیگری است، یا فایل تغییر کرده است. برای بازیابی، با حسابی که آن را ساخته وارد شوید.';

  @override
  String get backupErrNoPassphraseLock =>
      'این نسخه پشتیبان با عبارت عبور باز نمی‌شود.';

  @override
  String get backupErrNeedsSecret =>
      'این نسخه پشتیبان با عبارت عبور محافظت شده است. برای بازیابی، عبارت عبور یا کد بازیابی را وارد کنید.';

  @override
  String get backupErrWrongSecret =>
      'این عبارت عبور یا کد بازیابی، این نسخه پشتیبان را باز نمی‌کند.';

  @override
  String backupErrNewerSchema(int version, int supported) {
    return 'این نسخه پشتیبان با نسخه جدیدتری از برنامه ساخته شده است (پایگاه داده $version، این نسخه تا $supported را می‌خواند). The Accountant را به‌روز کنید و دوباره امتحان کنید.';
  }

  @override
  String backupDriveUnreachable(String error) {
    return 'دسترسی به Google Drive ممکن نشد: $error';
  }

  @override
  String get backupDriveNotAllowed =>
      'The Accountant هنوز اجازه استفاده از Google Drive را ندارد.';

  @override
  String get backupDriveNoFolder =>
      'Google Drive پوشه‌ای برای نگهداری نسخه‌های پشتیبان نساخت.';

  @override
  String get backupDriveNoFileId =>
      'Google Drive نسخه پشتیبان را پذیرفت ولی نگفت آن را کجا گذاشته است.';

  @override
  String get backupDriveTimeout =>
      'پاسخ Google Drive بیش از حد طول می‌کشد. بعداً دوباره امتحان کنید.';

  @override
  String get backupDriveOffline =>
      'اتصالی به Google Drive نیست. وقتی آنلاین شدید دوباره امتحان کنید.';

  @override
  String get backupDriveDenied =>
      'Google Drive درخواست را رد کرد. دوباره اجازه دسترسی بدهید و امتحان کنید.';

  @override
  String get backupDriveFileGone =>
      'آن نسخه پشتیبان دیگر در Google Drive نیست.';

  @override
  String backupDriveHttpError(int status, String reason) {
    return 'پاسخ Google Drive: $status. $reason';
  }

  @override
  String get backupDriveTryAgainSoon => 'کمی بعد دوباره امتحان کنید.';

  @override
  String backupTakeFailed(String error) {
    return 'پشتیبان‌گیری انجام نشد: $error';
  }

  @override
  String get backupUnrestorableNewer =>
      'با نسخه جدیدتری از برنامه ساخته شده است.';

  @override
  String get backupUnrestorableOlder =>
      'قدیمی‌تر از آن است که این نسخه برنامه بتواند بخواند.';

  @override
  String get backupKeyUnusable =>
      'سرور یک کلید رمزگذاری غیرقابل‌استفاده فرستاد. بعداً دوباره امتحان کنید.';

  @override
  String get backupKeyNeedsSignIn =>
      'برای ساخت یا بازیابی نسخه پشتیبان وارد شوید — نسخه‌های پشتیبان با حساب شما رمزگذاری می‌شوند.';

  @override
  String get backupKeyNeedsInternet =>
      'یک بار به اینترنت وصل شوید تا داده‌هایتان رمزگذاری شود، سپس دوباره امتحان کنید.';

  @override
  String get backupKeyLocked =>
      'داده‌هایتان با عبارت عبور محافظت شده است. اول آن را روی این دستگاه باز کنید.';

  @override
  String get backupFrequencyManual => 'فقط وقتی خودم بخواهم';

  @override
  String get backupFrequencyDaily => 'هر روز';

  @override
  String get backupFrequencyWeekly => 'هر هفته';

  @override
  String get backupFrequencyMonthly => 'هر ماه';

  @override
  String get backupIntro =>
      'نسخه پشتیبان یک فایل است که همه‌چیزِ این دستگاه را در خود دارد — همه تراکنش‌ها، حساب‌ها، بودجه‌ها و اهداف. یکی را جای امنی نگه دارید تا هیچ‌چیز برای همیشه از دست نرود.';

  @override
  String get backupSectionOnDevice => 'روی این دستگاه';

  @override
  String get backupSectionGoogleDrive => 'GOOGLE DRIVE';

  @override
  String get backupSectionInDrive => 'نسخه‌های پشتیبان در DRIVE';

  @override
  String backupBackedUpCount(int count) {
    return 'از $count رکورد نسخه پشتیبان گرفته شد.';
  }

  @override
  String get backupSaveDialogTitle => 'ذخیره نسخه پشتیبان';

  @override
  String get backupChooseFileTitle => 'یک فایل پشتیبان انتخاب کنید';

  @override
  String backupFileUnreadable(String error) {
    return 'آن فایل خوانده نشد: $error';
  }

  @override
  String backupTakenOn(String date) {
    return 'گرفته‌شده در $date.';
  }

  @override
  String backupTakenOnDevice(String date, String device) {
    return 'گرفته‌شده در $date روی $device.';
  }

  @override
  String backupBelongedTo(String email) {
    return 'متعلق به $email بود.';
  }

  @override
  String get backupDifferentAccountWarning =>
      'این حسابی نیست که اینجا وارد شده است. با بازیابی، رکوردهای شخص دیگری روی این دستگاه قرار می‌گیرد.';

  @override
  String get backupRestoreEraseWarning =>
      'همه‌چیزِ فعلی این دستگاه پاک و جایگزین می‌شود. هرچه هنوز همگام نشده از دست می‌رود. این کار قابل بازگشت نیست.';

  @override
  String backupRestoredCount(int count) {
    return '$count رکورد بازیابی شد.';
  }

  @override
  String backupRestoredPartial(int count) {
    return '$count رکورد بازیابی شد. بخشی از فایل با این نسخه سازگار نبود و کنار گذاشته شد.';
  }

  @override
  String backupRestoreFailed(String error) {
    return 'چیزی تغییر نکرد — بازیابی ناموفق بود: $error';
  }

  @override
  String get backupConnectDriveSubtitle =>
      'نسخه‌های پشتیبان در پوشه‌ای خصوصی قرار می‌گیرند که فقط این برنامه می‌تواند باز کند. فایل‌های دیگرتان هرگز خوانده نمی‌شوند.';

  @override
  String get backupDriveConnectedTitle => 'Google Drive وصل شد';

  @override
  String backupDriveFolderFirst(String folder) {
    return 'نسخه‌های پشتیبان این دستگاه به پوشه‌ای به نام «$folder» در Drive شما می‌روند.';
  }

  @override
  String backupDriveFolder(String folder) {
    return 'نسخه‌های پشتیبان به «$folder» در Drive شما می‌روند.';
  }

  @override
  String get backupNoneYet =>
      'هنوز هیچ نسخه پشتیبانی از این دستگاه بارگذاری نشده است';

  @override
  String backupLastBackedUp(String date) {
    return 'آخرین پشتیبان‌گیری $date';
  }

  @override
  String backupKeepSubtitle(int count) {
    return '$count نسخه پشتیبان — با رسیدن نسخه جدید، نسخه‌های قدیمی‌تر حذف می‌شوند';
  }

  @override
  String get backupDisconnectSubtitle =>
      'پشتیبان‌گیری خودکار متوقف می‌شود. چیزی که قبلاً ذخیره شده حذف نمی‌شود.';

  @override
  String backupListFailed(String error) {
    return 'فهرست نسخه‌های پشتیبان دریافت نشد: $error';
  }

  @override
  String get backupDriveNotGranted => 'اجازه دسترسی به Google Drive داده نشد.';

  @override
  String get backupDriveConnected => 'Google Drive وصل شد.';

  @override
  String backupDriveConnectFailed(String error) {
    return 'اتصال به Google Drive ممکن نشد: $error';
  }

  @override
  String get backupDisconnectBody =>
      'پشتیبان‌گیری خودکار متوقف می‌شود. نسخه‌های پشتیبانی که در Drive هستند همان‌جا می‌مانند و هر زمان بخواهید می‌توانید دوباره وصل شوید.';

  @override
  String backupSavedToDrive(String name) {
    return '$name در Google Drive ذخیره شد.';
  }

  @override
  String backupCopyFailed(String error) {
    return 'آن نسخه پشتیبان ذخیره نشد: $error';
  }

  @override
  String get backupDeleteBody => 'برای همیشه از Google Drive حذف می‌شود.';

  @override
  String get backupRefresh => 'تازه‌سازی';

  @override
  String get ppErrKdfParams => 'پارامترهای استخراج کلید قابل‌قبول نیستند.';

  @override
  String get ppErrKdfAlgorithm => 'الگوریتم استخراج کلید ناشناخته است.';

  @override
  String get onboardingIntroAccountsTitle => 'همه حساب‌ها، یک موجودی';

  @override
  String get onboardingIntroAccountsBody =>
      'پول نقد، کارت‌ها و پس‌اندازها را کنار هم نگه دارید و ببینید واقعاً چقدر برایتان مانده است.';

  @override
  String get onboardingIntroBudgetsTitle => 'بودجه‌هایی که زود خبر می‌دهند';

  @override
  String get onboardingIntroBudgetsBody =>
      'برای هر دسته سقفی بگذارید. برنامه جمع را زیر نظر دارد و پیش از رد شدن از آن هشدار می‌دهد، نه بعدش.';

  @override
  String get onboardingIntroAskTitle => 'درباره خرج‌های خودتان بپرسید';

  @override
  String get onboardingIntroAskBody =>
      'یک رسید را اسکن کنید، یا بپرسید ماه پیش پولتان کجا رفت، و پاسخی بر اساس سوابق خودتان بگیرید.';

  @override
  String get onboardingIntroThemeTitle => 'ظاهرش را مال خودتان کنید';

  @override
  String get onboardingIntroThemeBody =>
      'همین حالا یک تم انتخاب کنید، یا هر وقت خواستید از تنظیمات عوضش کنید.';

  @override
  String get onboardingCreateYourAccount => 'حسابتان را بسازید';

  @override
  String get onboardingNext => 'بعدی';

  @override
  String get onboardingCurrencyInfo =>
      'این ارز اصلی شما خواهد بود. بعداً می‌توانید حساب‌هایی با ارزهای دیگر اضافه کنید.';

  @override
  String get onboardingTypeCash => 'نقد';

  @override
  String get onboardingTypeBank => 'حساب بانکی';

  @override
  String get onboardingTypeCard => 'کارت اعتباری';

  @override
  String get onboardingTypeDeposit => 'سپرده';

  @override
  String get onboardingTypeInvestment => 'سرمایه‌گذاری';

  @override
  String get onboardingTypeAsset => 'دارایی';

  @override
  String onboardingDayN(int day) {
    return 'روز $day';
  }

  @override
  String get onboardingAllSet => 'همه‌چیز آماده است!';

  @override
  String onboardingCompleteFailed(String error) {
    return 'تکمیل راه‌اندازی ناموفق بود: $error';
  }

  @override
  String get onboardingSkipFailed => 'رد کردن راه‌اندازی ناموفق بود';

  @override
  String get startupOfflineConfirmBody =>
      'داده‌هایتان دقیقاً همان‌جا که هست می‌ماند — هیچ‌چیز روی این دستگاه یا در فضای ابری حذف نمی‌شود.\n\nاما اگر این حساب داده ذخیره‌شده‌ای داشته باشد، هرچه اکنون اضافه کنید پس از بازیابی کنار آن قرار می‌گیرد — ممکن است موارد تکراری داشته باشید که باید مرتبشان کنید.';

  @override
  String get startupDataInCloudTitle => 'داده‌هایتان در فضای ابری منتظر شماست';

  @override
  String get startupLoadFailedTitle => 'نتوانستیم بارگیری حسابتان را کامل کنیم';

  @override
  String get startupGenericReason => 'هنگام بررسی این حساب مشکلی پیش آمد.';

  @override
  String get startupUseWithoutRestoring => 'استفاده از برنامه بدون بازیابی';

  @override
  String get legalTermsTab => 'شرایط';

  @override
  String get legalConsent =>
      'سیاست حفظ حریم خصوصی و شرایط و ضوابط را خوانده‌ام و با آن‌ها موافقم';

  @override
  String get walkthroughGotIt => 'متوجه شدم!';

  @override
  String get settingsFaqSectionGettingStarted => 'شروع کار';

  @override
  String get settingsFaq01Question => 'چطور تراکنش اضافه کنم؟';

  @override
  String get settingsFaq01Answer =>
      'روی دکمه + پایین صفحه اصلی بزنید. مبلغ را وارد کنید، یک دسته و یک کیف پول انتخاب کنید و اگر خواستید یادداشت بگذارید. برای ثبت تراکنش روی ذخیره بزنید.';

  @override
  String get settingsFaq02Question => 'فرق کیف پول و دسته چیست؟';

  @override
  String get settingsFaq02Answer =>
      'کیف پول‌ها نشان می‌دهند پول شما کجا نگه داشته می‌شود (مثلاً نقد، حساب بانکی، کارت اعتباری). دسته‌ها نشان می‌دهند پول صرف چه شده یا از کجا آمده (مثلاً غذا، حقوق، سرگرمی).';

  @override
  String get settingsFaq03Question => 'چطور قالب تاریخ و عدد را تغییر دهم؟';

  @override
  String get settingsFaq03Answer =>
      'به تنظیمات > تنظیمات منطقه‌ای بروید. می‌توانید واحد پول پیش‌فرض، قالب تاریخ (مثلاً DD/MM/YYYY یا MM/DD/YYYY) و قالب عدد (مثلاً 1,234.56 یا 1.234,56) را تغییر دهید. یک پیش‌نمایش زنده نشان می‌دهد تنظیمات شما چطور دیده می‌شود.';

  @override
  String get settingsFaqSectionTransactions => 'تراکنش‌ها';

  @override
  String get settingsFaq04Question =>
      'می‌توانم تراکنش‌های تکرارشونده را ثبت کنم؟';

  @override
  String get settingsFaq04Answer =>
      'بله! هنگام افزودن تراکنش، گزینه «تکرارشونده» را روشن کنید. می‌توانید آن را روزانه، هفتگی، ماهانه یا سالانه تکرار کنید. برنامه این تراکنش‌ها را خودکار برایتان می‌سازد.';

  @override
  String get settingsFaq05Question => 'چطور بین کیف پول‌ها پول جابه‌جا کنم؟';

  @override
  String get settingsFaq05Answer =>
      'هنگام افزودن تراکنش، «انتقال» را به‌عنوان نوع انتخاب کنید. کیف پول مبدأ و مقصد را انتخاب کنید و مبلغ را وارد کنید. برنامه خودکار مبلغ را از یکی کم و به دیگری اضافه می‌کند.';

  @override
  String get settingsFaq06Question => 'تراکنش‌های پیش رو چیست؟';

  @override
  String get settingsFaq06Answer =>
      'تراکنش‌های پیش رو هزینه‌ها یا درآمدهای آینده‌اند که انتظارشان را دارید اما هنوز پرداخت نشده‌اند. تا وقتی آن‌ها را پرداخت‌شده علامت نزنید، روی موجودی کیف پولتان اثری ندارند. موارد معوق و پیش رو را در بخش تراکنش‌ها پیدا می‌کنید.';

  @override
  String get settingsFaq07Question => 'چطور اشتراک‌هایم را دنبال کنم؟';

  @override
  String get settingsFaq07Answer =>
      'هنگام افزودن تراکنش، نوع ویژه را روی اشتراک بگذارید. این کار آن را به‌عنوان پرداخت تکراری یک سرویس علامت می‌زند. می‌توانید همه اشتراک‌هایتان را یک‌جا ببینید و هزینه ماهانه اشتراک‌ها را دنبال کنید.';

  @override
  String get settingsFaq08Question => 'ثبت طلب و بدهی چطور کار می‌کند؟';

  @override
  String get settingsFaq08Answer =>
      'برای پولی که به کسی قرض داده‌اید از طلب، و برای پولی که قرض گرفته‌اید از بدهی استفاده کنید. هر مورد مبلغ، اینکه چه کسی به چه کسی بدهکار است و میزان پرداخت را نگه می‌دارد. می‌توانید پرداخت‌های جزئی را ثبت کنید و وقتی کامل پرداخت شد، بدهی را تسویه‌شده علامت بزنید.';

  @override
  String get settingsFaq09Question =>
      'می‌توانم به تراکنش‌ها یادداشت یا رسید اضافه کنم؟';

  @override
  String get settingsFaq09Answer =>
      'بله! هنگام افزودن یا ویرایش تراکنش می‌توانید در بخش یادداشت بنویسید. کاربران Premium همچنین می‌توانند رسیدها را با اسکنر رسید هوش مصنوعی اسکن کنند که مبلغ و مشخصات فروشنده را خودکار درمی‌آورد.';

  @override
  String get settingsFaqSectionWalletsCurrencies => 'کیف پول‌ها و ارزها';

  @override
  String get settingsFaq10Question => 'چطور چند حساب را مدیریت کنم؟';

  @override
  String get settingsFaq10Answer =>
      'برنامه چهار نوع حساب دارد: نقد، حساب بانکی، کارت اعتباری و اشتراک. برای افزودن حساب جدید، در داشبورد به «حساب‌های شما» بروید و روی «افزودن حساب» بزنید. هر حساب می‌تواند نام، نماد، رنگ و واحد پول خودش را داشته باشد. اولین حساب شما خودکار پیش‌فرض می‌شود. برای کارت‌های اعتباری هم می‌توانید سقف اعتبار و روز صورت‌حساب را تعیین کنید تا اعتبار باقی‌مانده را دنبال کنید.';

  @override
  String get settingsFaq11Question => 'می‌توانم از چند ارز استفاده کنم؟';

  @override
  String get settingsFaq11Answer =>
      'بله! هر کیف پول می‌تواند ارز خودش را داشته باشد. برنامه با نرخ‌های تبدیل لحظه‌ای، ارزها را خودکار تبدیل می‌کند. همچنین می‌توانید نرخ‌های دلخواه خود را در تنظیمات > تنظیمات منطقه‌ای تعیین کنید.';

  @override
  String get settingsFaq12Question => 'تبدیل ارز چطور کار می‌کند؟';

  @override
  String get settingsFaq12Answer =>
      'هر کیف پول می‌تواند ارز متفاوتی داشته باشد و برنامه مبالغ را با نرخ‌های تبدیل لحظه‌ای که هر چند ساعت به‌روز می‌شوند، خودکار تبدیل می‌کند. همچنین می‌توانید برای هر جفت ارز نرخ دلخواه را در تنظیمات > تنظیمات منطقه‌ای تعیین کنید. برنامه از بیش از 150 ارز پشتیبانی می‌کند و نرخ‌ها را خودکار دریافت می‌کند.';

  @override
  String get settingsFaq13Question =>
      'اگر دسته‌ای را که تراکنش دارد حذف کنم چه می‌شود؟';

  @override
  String get settingsFaq13Answer =>
      'آن تراکنش‌ها به «بدون دسته» منتقل می‌شوند. بعد می‌توانید آن‌ها را به دسته دیگری بدهید یا بدون دسته بگذارید.';

  @override
  String get settingsFaq14Question => 'زیردسته چیست و چطور از آن استفاده کنم؟';

  @override
  String get settingsFaq14Answer =>
      'برای ثبت دقیق‌تر می‌توانید زیر هر دسته اصلی زیردسته بسازید. مثلاً زیر «غذا» می‌توانید «خواربار»، «رستوران» و «قهوه» داشته باشید. زیردسته‌ها به شما نشان می‌دهند پولتان دقیقاً کجا می‌رود.';

  @override
  String get settingsFaq15Question => 'اصلاح موجودی چیست؟';

  @override
  String get settingsFaq15Answer =>
      'با اصلاح موجودی می‌توانید موجودی یک کیف پول را وقتی با مبلغ واقعی نمی‌خواند تنظیم کنید. این کار یک تراکنش ویژه می‌سازد که موجودی ثبت‌شده را با واقعیت یکی می‌کند، بدون اینکه دستی درآمد یا هزینه اضافه کنید.';

  @override
  String get settingsFaqSectionBudgetsGoals => 'بودجه‌ها و اهداف';

  @override
  String get settingsFaq16Question => 'چطور بودجه تعیین کنم؟';

  @override
  String get settingsFaq16Answer =>
      'به زبانه بودجه‌ها بروید و روی «بودجه جدید» بزنید. یک نام انتخاب کنید، سقف هزینه را تعیین کنید، بازه زمانی (هفتگی/ماهانه) را انتخاب کنید و دسته‌هایی را که می‌خواهید دنبال شوند برگزینید. وقتی به سقف نزدیک شوید، برنامه به شما هشدار می‌دهد.';

  @override
  String get settingsFaq17Question => 'اهداف پس‌انداز چیست؟';

  @override
  String get settingsFaq17Answer =>
      'با اهداف پس‌انداز مبلغی را که می‌خواهید پس‌انداز کنید تعیین می‌کنید. در بخش اهداف یک هدف بسازید، مبلغ هدف را تعیین کنید و تراکنش‌ها را به آن وصل کنید تا پیشرفتتان را ببینید. برنامه یک نوار پیشرفت و درصد رسیدن به هدف را نشان می‌دهد.';

  @override
  String get settingsFaq18Question => 'چطور یک وام را دنبال کنم؟';

  @override
  String get settingsFaq18Answer =>
      'در بخش اهداف یک وام با کل مبلغ بدهی بسازید. هر بار که قسطی می‌پردازید، آن تراکنش را به وام وصل کنید تا روند بازپرداخت را ببینید. برنامه نشان می‌دهد چقدر پرداخته‌اید و چقدر مانده است.';

  @override
  String get settingsFaqSectionDataSync => 'داده‌ها و همگام‌سازی';

  @override
  String get settingsFaq19Question => 'همگام‌سازی ابری چطور کار می‌کند؟';

  @override
  String get settingsFaq19Answer =>
      'همگام‌سازی ابری داده‌های شما را روی همه دستگاه‌ها یکسان نگه می‌دارد. برای روشن کردنش به تنظیمات > مدیریت داده‌ها > همگام‌سازی ابری بروید. همگام‌سازی هر 15 دقیقه و هر بار که برنامه را باز می‌کنید خودکار انجام می‌شود. برای همگام‌سازی فوری هم می‌توانید روی «همگام‌سازی اکنون» بزنید. این یک قابلیت Premium است.';

  @override
  String get settingsFaq20Question => 'چطور از داده‌هایم خروجی بگیرم؟';

  @override
  String get settingsFaq20Answer =>
      'به تنظیمات > مدیریت داده‌ها > خروجی گرفتن از داده‌ها بروید. بازه تاریخ را انتخاب کنید، CSV (برای صفحه‌گسترده) یا PDF (برای گزارش مرتب) را برگزینید و روی خروجی بزنید. می‌توانید تفکیک بر اساس دسته و کیف پول را بگنجانید یا حذف کنید. این یک قابلیت Premium است.';

  @override
  String get settingsFaq21Question => 'اگر داده‌هایم را پاک کنم چه می‌شود؟';

  @override
  String get settingsFaq21Answer =>
      'به تنظیمات > حریم خصوصی و امنیت بروید. «پاک کردن حافظه موقت» داده‌های موقت را حذف می‌کند و بدون پاک کردن تراکنش‌هایتان همگام‌سازی دوباره را انجام می‌دهد. «پاک کردن همه داده‌ها» همه چیز را برای همیشه پاک می‌کند — برای تأیید باید DELETE را تایپ کنید. این کار برگشت‌پذیر نیست.';

  @override
  String get settingsFaqSectionPremiumAiFeatures =>
      'Premium و قابلیت‌های هوش مصنوعی';

  @override
  String get settingsFaq22Question => 'Premium چه قابلیت‌هایی دارد؟';

  @override
  String get settingsFaq22Answer =>
      'Premium این‌ها را باز می‌کند: هوش مصنوعی نامحدود (مشاور، خلاصه‌های ماهانه، خواندن رسید و توصیفش کنید) بدون تبلیغ، همگام‌سازی ابری، گزارش‌های PDF، تم‌های Premium، و محدودیت کیف پول، دسته، بودجه، هدف و روش پرداخت را برمی‌دارد. پشتیبانی با اولویت هم می‌گیرید.';

  @override
  String get settingsFaq23Question => 'محدودیت‌های نسخه رایگان چیست؟';

  @override
  String get settingsFaq23Answer =>
      'کاربران رایگان می‌توانند تا 3 کیف پول، 10 دسته دلخواه، 3 بودجه فعال، 2 هدف/وام فعال و 5 روش پرداخت بسازند. با ارتقا به Premium همه این محدودیت‌ها برداشته می‌شوند.';

  @override
  String get settingsFaq24Question => 'دستیار هوش مصنوعی چه کارهایی می‌کند؟';

  @override
  String get settingsFaq24Answer =>
      'مشاور مالی به پرسش‌هایی درباره پول خودتان پاسخ می‌دهد: پولتان کجا رفت، آیا با بودجه‌ها و اهدافتان پیش می‌روید، کدام قبض‌ها در راه‌اند، و چطور کمتر خرج کنید یا بیشتر پس‌انداز کنید. خلاصه‌ای از ارقام شما (جمع‌ها، دسته‌ها، بودجه‌ها، اهداف، قبض‌ها و تراکنش‌های اخیر) را می‌بیند تا پاسخ‌هایش بر پایه اعداد واقعی شما باشد، و بعد از هر پاسخ پرسش‌های بعدی پیشنهاد می‌دهد. راهنمایی کلی می‌دهد، نه مشاوره مالی حرفه‌ای. گفتگوهای شما ذخیره می‌شوند تا از همان جایی که ماندید ادامه دهید، و هر وقت بخواهید می‌توانید پاکشان کنید.';

  @override
  String get settingsFaq25Question => 'تحلیل‌های هوش مصنوعی چطور کار می‌کنند؟';

  @override
  String get settingsFaq25Answer =>
      'خلاصه ماهانه (آمار > تحلیل هزینه‌ها) این ماه را با ماه قبل مقایسه می‌کند: چقدر درآمد و هزینه داشتید و هر دسته چه تغییری کرد. روی خلاصه‌ام را بنویس بزنید تا هوش مصنوعی نکات برجسته را بگوید و یک کار برای امتحان پیشنهاد دهد. اعداد برای همه رایگان‌اند؛ متن هوش مصنوعی یک درخواست هوش مصنوعی مصرف می‌کند.';

  @override
  String get settingsFaq26Question => 'دسته‌بندی هوشمند چیست؟';

  @override
  String get settingsFaq26Answer =>
      'وقتی تراکنشی را دستی دسته‌بندی می‌کنید، برنامه به یاد می‌سپارد آن عنوان به کدام دسته تعلق دارد و دفعه بعد خودش آن را انتخاب می‌کند (این‌ها را می‌توانید در قوانین نام‌گذاری ببینید و ویرایش کنید). برای چیز تازه، روی دکمه درخشان در صفحه افزودن بزنید و از توصیفش کنید استفاده کنید: چیزی مثل «ناهار 250 دیروز از bKash» بنویسید تا هوش مصنوعی مبلغ، تاریخ، دسته و حساب را برای بررسی شما پر کند.';

  @override
  String get settingsFaq27Question => 'اسکنر رسید هوش مصنوعی چطور کار می‌کند؟';

  @override
  String get settingsFaq27Answer =>
      'از یک رسید عکس بگیرید یا عکسی انتخاب کنید. گوشی شما متن را روی خود دستگاه می‌خواند و فروشنده و جمع کل را پیشنهاد می‌دهد. روی خواندن با هوش مصنوعی بزنید تا هوش مصنوعی جمع واقعی، تاریخ، تک‌تک اقلام و دسته درست را پیدا کند، حتی روی رسید نامرتب؛ فقط متن فرستاده می‌شود، هرگز عکس. پیش از ذخیره می‌توانید همه چیز را بررسی و ویرایش کنید. خواندن با هوش مصنوعی یک درخواست هوش مصنوعی مصرف می‌کند.';

  @override
  String get settingsFaq28Question =>
      'چند درخواست هوش مصنوعی دارم و تبلیغ‌ها برای چیست؟';

  @override
  String get settingsFaq28Answer =>
      'همه هر ماه 10 درخواست رایگان هوش مصنوعی دارند که روز اول ماه برمی‌گردند. اگر بیشتر خواستید، می‌توانید با دیدن یک تبلیغ کوتاه یک درخواست اضافه بگیرید، تا 10 درخواست بیشتر در ماه. تبلیغ‌ها همچنین می‌توانند امتحان 24 ساعته یک تم Premium یا یک خروجی PDF را باز کنند. تبلیغ فقط بعد از اینکه روی دکمه‌ای بزنید و تأیید کنید پخش می‌شود؛ هیچ تبلیغ بنری نیست و هیچ چیزی خودبه‌خود ظاهر نمی‌شود. اعضای Premium هوش مصنوعی نامحدود و همه چیز دیگر را بدون هیچ تبلیغی دارند.';

  @override
  String get settingsFaq29Question => 'چطور خرید Premium خود را مدیریت کنم؟';

  @override
  String get settingsFaq29Answer =>
      'خریدهای Premium از طریق Google Play مدیریت می‌شوند. برای دیدن یا مدیریت طرح خود به تنظیمات اشتراک Google Play بروید. Premium به‌صورت ماهانه، سالانه یا خرید یک‌باره مادام‌العمر در دسترس است.';

  @override
  String get settingsFaqSectionPrivacySecurity => 'حریم خصوصی و امنیت';

  @override
  String get settingsFaq30Question => 'چطور قفل بیومتریک را راه بیندازم؟';

  @override
  String get settingsFaq30Answer =>
      'به تنظیمات > حریم خصوصی و امنیت بروید و قفل بیومتریک را روشن کنید. از آن به بعد برای باز کردن برنامه به اثر انگشت یا چهره‌تان نیاز دارید. همچنین می‌توانید زمان قفل خودکار را تنظیم کنید تا برنامه پس از مدتی بی‌استفاده ماندن قفل شود.';

  @override
  String get settingsFaq31Question => 'آیا داده‌های مالی من امن است؟';

  @override
  String get settingsFaq31Answer =>
      'بله. همه داده‌های شما روی دستگاه خودتان ذخیره می‌شوند. اگر همگام‌سازی ابری را روشن کنید، داده‌هایتان هنگام انتقال رمزگذاری می‌شوند. ما هرگز داده‌های مالی شما را با دیگران به اشتراک نمی‌گذاریم. سیاست حفظ حریم خصوصی ما را در تنظیمات > درباره ببینید.';

  @override
  String get txnLoadPaymentMethodsFailed =>
      'بارگذاری روش‌های پرداخت ناموفق بود';

  @override
  String get txnAddPaymentMethodFailed => 'افزودن روش پرداخت ناموفق بود';

  @override
  String get txnPaymentMethodNotFound => 'روش پرداخت پیدا نشد';

  @override
  String get txnUpdatePaymentMethodFailed =>
      'به‌روزرسانی روش پرداخت ناموفق بود';

  @override
  String get txnDeletePaymentMethodFailed => 'حذف روش پرداخت ناموفق بود';

  @override
  String txnLoadFailed(String error) {
    return 'بارگذاری تراکنش‌ها ناموفق بود: $error';
  }

  @override
  String get txnAddFailed => 'افزودن تراکنش ناموفق بود';

  @override
  String txnAddFailedWithError(String error) {
    return 'افزودن تراکنش ناموفق بود: $error';
  }

  @override
  String get txnNotFound => 'تراکنش پیدا نشد';

  @override
  String get txnUpdateFailed => 'به‌روزرسانی تراکنش ناموفق بود';

  @override
  String txnNotATransfer(String id) {
    return 'تراکنش $id انتقال نیست';
  }

  @override
  String txnUpdateTransferFailed(String error) {
    return 'به‌روزرسانی انتقال ناموفق بود: $error';
  }

  @override
  String get txnDeleteFailed => 'حذف تراکنش ناموفق بود';

  @override
  String txnLoadTransfersFailed(String error) {
    return 'بارگذاری انتقال‌ها ناموفق بود: $error';
  }

  @override
  String txnCreateTransferFailed(String error) {
    return 'ایجاد انتقال ناموفق بود: $error';
  }

  @override
  String txnDeleteTransferFailed(String error) {
    return 'حذف انتقال ناموفق بود: $error';
  }

  @override
  String txnLoadDataFailed(String error) {
    return 'بارگذاری داده‌ها ناموفق بود: $error';
  }

  @override
  String txnMarkPaidFailed(String error) {
    return 'علامت‌گذاری به‌عنوان پرداخت‌شده ناموفق بود: $error';
  }

  @override
  String txnMarkUnpaidFailed(String error) {
    return 'علامت‌گذاری به‌عنوان پرداخت‌نشده ناموفق بود: $error';
  }

  @override
  String txnSkipFailed(String error) {
    return 'رد کردن تراکنش ناموفق بود: $error';
  }

  @override
  String creditReceivedTitle(String title) {
    return 'دریافت شد: $title';
  }

  @override
  String creditPaidTitle(String title) {
    return 'پرداخت شد: $title';
  }

  @override
  String creditReversedTitle(String title) {
    return 'برگشت داده شد: $title';
  }

  @override
  String creditMarkSettledFailed(String error) {
    return 'علامت‌گذاری به‌عنوان تسویه‌شده ناموفق بود: $error';
  }

  @override
  String get creditPaymentMustBePositive =>
      'مبلغ پرداخت باید بیشتر از صفر باشد';

  @override
  String creditRecordPaymentFailed(String error) {
    return 'ثبت پرداخت ناموفق بود: $error';
  }

  @override
  String creditMarkPendingFailed(String error) {
    return 'علامت‌گذاری به‌عنوان در انتظار ناموفق بود: $error';
  }

  @override
  String creditRemaining(String amount) {
    return 'باقی‌مانده: $amount';
  }

  @override
  String creditPaymentRecorded(String amount) {
    return 'پرداخت $amount ثبت شد';
  }

  @override
  String creditMarkedCollected(String title) {
    return 'به‌عنوان دریافت‌شده از «$title» علامت خورد';
  }

  @override
  String get importFieldDescription => 'توضیحات';

  @override
  String get importFieldDirection => 'نوع (بستانکار/بدهکار)';

  @override
  String get importMissingDate => 'یک ستون تاریخ';

  @override
  String get importMissingAmount => 'یک ستون مبلغ';

  @override
  String importColumnN(int index) {
    return 'ستون $index';
  }

  @override
  String get importNoDate => 'بدون تاریخ';

  @override
  String importDateMismatch(String date, String format) {
    return 'تاریخ «$date» با $format مطابقت ندارد';
  }

  @override
  String get importAnyKnownFormat => 'هیچ قالب شناخته‌شده‌ای';

  @override
  String get importNoAmount => 'بدون مبلغ';

  @override
  String get importIntro =>
      'یک CSV از بانکتان بگیرید و اینجا باز کنید. ستون‌ها خودکار تشخیص داده می‌شوند و تا دقیقاً نبینید چه چیزی اضافه می‌شود، چیزی اضافه نمی‌شود.';

  @override
  String get importSavedBanks => 'بانک‌های ذخیره‌شده';

  @override
  String get importChooseStatement => 'یک صورت‌حساب انتخاب کنید';

  @override
  String get importNoRows => 'آن فایل هیچ ردیفی ندارد.';

  @override
  String importUsingSavedMapping(String name) {
    return 'از نگاشت ذخیره‌شده‌تان برای $name استفاده می‌شود.';
  }

  @override
  String importCouldNotRead(String error) {
    return 'آن فایل خوانده نشد: $error';
  }

  @override
  String importForgetTitle(String name) {
    return '$name فراموش شود؟';
  }

  @override
  String get importForgetBody =>
      'دفعه بعد دوباره از شما خواسته می‌شود ستون‌ها را نگاشت کنید.';

  @override
  String get importColumnsHeader => 'ستون‌ها';

  @override
  String get importHowToRead => 'نحوه خواندن مقادیر';

  @override
  String get importWhereItGoes => 'مقصد';

  @override
  String get importWhatWillBeAdded => 'آنچه اضافه می‌شود';

  @override
  String importRowsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ردیف',
      one: '۱ ردیف',
    );
    return '$_temp0';
  }

  @override
  String importColumnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ستون',
      one: '۱ ستون',
    );
    return '$_temp0';
  }

  @override
  String importSeparatedBy(String separator) {
    return 'جداشده با $separator';
  }

  @override
  String importMappedAs(String name) {
    return 'نگاشت‌شده به‌عنوان $name';
  }

  @override
  String get importDelimCommas => 'ویرگول';

  @override
  String get importDelimSemicolons => 'نقطه‌ویرگول';

  @override
  String get importDelimTabs => 'تب';

  @override
  String get importDelimPipes => 'خط عمودی (|)';

  @override
  String get importRequired => 'الزامی';

  @override
  String get importNotImported => 'وارد نمی‌شود';

  @override
  String get importEmptySample => 'خالی';

  @override
  String get importPickDateColumnFirst => 'ابتدا یک ستون تاریخ انتخاب کنید.';

  @override
  String importDateDoesNotFit(String sample) {
    return '«$sample» با این قالب جور نیست.';
  }

  @override
  String importDateReadsAs(String sample, String date) {
    return '«$sample» به‌صورت $date خوانده می‌شود';
  }

  @override
  String get importDecimalAuto => 'از فایل تشخیص داده شد';

  @override
  String get importDecimalFullStop => 'نقطه، مانند 1,234.56';

  @override
  String get importDecimalComma => 'ویرگول، مانند 1.234,56';

  @override
  String get importDuplicatesHint =>
      'بر اساس روز، مبلغ و توضیحات تطبیق می‌دهد، پس وارد کردن دوباره صورت‌حساب هم‌پوشان چیزی را دوبرابر نمی‌کند';

  @override
  String importStillNeeds(String item) {
    return 'هنوز $item لازم است.';
  }

  @override
  String importStillNeedsBoth(String first, String second) {
    return 'هنوز $first و $second لازم است.';
  }

  @override
  String get importNothingReadable =>
      'با این تنظیمات هیچ چیز از این فایل خوانده نمی‌شود. قالب تاریخ و ستون مبلغ را بررسی کنید.';

  @override
  String importTransactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش',
      one: '۱ تراکنش',
    );
    return '$_temp0';
  }

  @override
  String importAmountIn(String amount) {
    return '$amount ورودی';
  }

  @override
  String importAmountOut(String amount) {
    return '$amount خروجی';
  }

  @override
  String importAndMore(int count) {
    return 'و $count مورد دیگر';
  }

  @override
  String importLinesSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خط رد می‌شود',
      one: '۱ خط رد می‌شود',
    );
    return '$_temp0';
  }

  @override
  String importLinesSkippedSentence(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خط رد می‌شود.',
      one: '۱ خط رد می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String importLineProblem(int line, String problem) {
    return 'خط $line: $problem';
  }

  @override
  String get importAddAccountFirst => 'ابتدا یک حساب اضافه کنید';

  @override
  String importImportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'وارد کردن $count تراکنش',
      one: 'وارد کردن ۱ تراکنش',
    );
    return '$_temp0';
  }

  @override
  String importConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش وارد شود؟',
      one: '۱ تراکنش وارد شود؟',
    );
    return '$_temp0';
  }

  @override
  String get importConfirmBody =>
      'به سوابق شما اضافه می‌شوند و در همگام‌سازی بعدی بارگذاری می‌شوند.';

  @override
  String get importConfirmDuplicates =>
      'هر چیزی که از قبل با همان روز، مبلغ و توضیحات وجود دارد، دست‌نخورده می‌ماند.';

  @override
  String importFailed(String error) {
    return 'وارد کردن ناموفق بود: $error';
  }

  @override
  String importImportedTitle(int count) {
    return '$count مورد وارد شد';
  }

  @override
  String importSkippedDuplicates(int count) {
    return '$count مورد از قبل وجود داشت و دست‌نخورده ماند.';
  }

  @override
  String importUnreadableLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خط خوانده نشد.',
      one: '۱ خط خوانده نشد.',
    );
    return '$_temp0';
  }

  @override
  String importNewCategories(String names) {
    return 'دسته‌های جدید: $names.';
  }

  @override
  String importUnmatchedAccounts(String names) {
    return 'این نام‌های حساب اینجا مطابقی نداشتند، پس ردیف‌هایشان به حسابی که انتخاب کردید رفت: $names.';
  }

  @override
  String get importRememberBody =>
      'فایل بعدی با همین ستون‌ها بدون پرسیدن همین‌طور نگاشت می‌شود.';

  @override
  String get importNoHeaderCannotSave =>
      'فایلی بدون عنوان ستون دوباره شناخته نمی‌شود، پس چیزی برای تطبیق نیست.';

  @override
  String get importTemplateSaved =>
      'ذخیره شد. فایل‌هایی با این ستون‌ها از این پس از آن استفاده می‌کنند.';

  @override
  String get txnTransferSameWallet => 'کیف پول مبدأ و مقصد باید متفاوت باشند';

  @override
  String get txnTransferAmountPositive => 'مبلغ انتقال باید بیشتر از صفر باشد';

  @override
  String get txnTransferFeeNegative => 'کارمزد انتقال نمی‌تواند منفی باشد';

  @override
  String txnSourceWalletNotFound(String id) {
    return 'کیف پول مبدأ پیدا نشد: $id';
  }

  @override
  String txnDestinationWalletNotFound(String id) {
    return 'کیف پول مقصد پیدا نشد: $id';
  }

  @override
  String txnTransferTitle(String from, String to) {
    return 'انتقال: $from → $to';
  }

  @override
  String txnTransferWalletsMissing(String source, String destination) {
    return 'برای انتقال، هر دو کیف پول باید وجود داشته باشند (مبدأ: $source، مقصد: $destination).';
  }

  @override
  String txnTransferSameCurrencyReceived(
    String source,
    String destination,
    String currency,
  ) {
    return 'انتقال در یک ارز فقط یک مبلغ را جابه‌جا می‌کند: $source و $destination هر دو به $currency هستند، پس مبلغ دریافتی نمی‌تواند متفاوت باشد.';
  }

  @override
  String txnTransferNoRate(String from, String to, String destination) {
    return 'نرخی بین $from و $to معلوم نیست، پس مبلغی را که واقعاً به $destination رسید وارد کنید.';
  }

  @override
  String txnTransferReceivedPositive(String destination) {
    return 'مبلغ دریافتی باید بیشتر از صفر باشد. مبلغی را که واقعاً به $destination رسید وارد کنید.';
  }

  @override
  String txnFeeTitle(String title) {
    return 'کارمزد: $title';
  }

  @override
  String txnNotFoundWithId(String id) {
    return 'تراکنش پیدا نشد: $id';
  }

  @override
  String get txnNotATransferNoPair => 'تراکنش انتقال نیست (تراکنش جفت ندارد)';

  @override
  String txnPairedNotFound(String id) {
    return 'تراکنش جفت $id پیدا نشد؛ نیمی از یک انتقال ویرایش نمی‌شود.';
  }

  @override
  String walletNoSuchAccount(String id) {
    return 'چنین حسابی وجود ندارد: $id';
  }

  @override
  String get walletCorrectionTitle => 'اصلاح موجودی';

  @override
  String walletCorrectionNote(String name) {
    return '$name با موجودی واقعی‌اش هماهنگ شد.';
  }

  @override
  String get walletMergeIntoItself => 'یک حساب را نمی‌توان در خودش ادغام کرد.';

  @override
  String get walletMergeBothMustExist =>
      'برای ادغام، هر دو حساب باید وجود داشته باشند.';

  @override
  String walletMergeNoRate(String from, String to) {
    return 'نرخی بین $from و $to معلوم نیست، پس این حساب‌ها هنوز ادغام نمی‌شوند.';
  }

  @override
  String get walletMergeAdjustmentTitle => 'تعدیل ادغام';

  @override
  String walletMergeAdjustmentNote(String name) {
    return 'نرخ انتقالی بین این حساب‌ها با نرخ ادغام $name فرق دارد. این مورد تفاوت را ثبت می‌کند تا مجموع تغییر نکند.';
  }

  @override
  String get splitErrNoTotal => 'مبلغ صورت‌حساب را وارد کنید.';

  @override
  String get splitErrNoPeople => 'کسی را برای تقسیم اضافه کنید.';

  @override
  String splitErrPayerNotOnBill(String name) {
    return '$name در این صورت‌حساب سهمی ندارد.';
  }

  @override
  String get splitErrNothingToRecord =>
      'کس دیگری پرداخت کرده و شما سهمی نداشتید، پس چیزی برای ثبت نیست.';

  @override
  String get splitErrGiveOwnShare => 'سهم خودتان را وارد کنید.';

  @override
  String splitErrGiveShare(String name) {
    return 'سهم $name را وارد کنید.';
  }

  @override
  String get splitErrNegativeShare => 'سهم نمی‌تواند منفی باشد.';

  @override
  String splitErrSharesSum(String sum, String total) {
    return 'جمع سهم‌ها $sum است، نه $total.';
  }

  @override
  String splitErrPercentSum(String sum) {
    return 'جمع درصدها $sum% است، نه 100%.';
  }

  @override
  String get splitErrNameTooLong => 'نام‌ها باید کمتر از ۱۰۰ نویسه باشند.';

  @override
  String splitErrDuplicateName(String name) {
    return '$name دو بار در صورت‌حساب آمده است.';
  }

  @override
  String get splitErrTitleTooLong => 'عنوان باید کمتر از ۲۰۰ نویسه باشد.';

  @override
  String get splitErrChooseAccount =>
      'حسابی را که از آن پرداخت شد انتخاب کنید.';

  @override
  String get splitErrOrdinaryAccount => 'یک حساب عادی انتخاب کنید.';

  @override
  String get splitErrYourShareNothing => 'سهم شما صفر است، پس بدهی‌ای نیست.';

  @override
  String get splitErrEveryShareNothing => 'همه سهم‌ها صفر هستند.';

  @override
  String get recurringDaily => 'روزانه';

  @override
  String recurringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count روز',
      one: 'هر روز',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count هفته',
      one: 'هر هفته',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count ماه',
      one: 'هر ماه',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count سال',
      one: 'هر سال',
    );
    return '$_temp0';
  }

  @override
  String recurringEveryOther(int count, String unit) {
    return 'هر $count $unit';
  }

  @override
  String get recurringUntitled => 'تراکنش تکراری';

  @override
  String recurringInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز دیگر',
      one: '۱ روز دیگر',
    );
    return '$_temp0';
  }

  @override
  String get recurringNextWeek => 'هفته بعد';

  @override
  String recurringInWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هفته دیگر',
      one: '۱ هفته دیگر',
    );
    return '$_temp0';
  }

  @override
  String get txnPmKindCard => 'کارت';

  @override
  String get txnPmKindDigitalWallet => 'کیف پول دیجیتال';

  @override
  String get txnPmEmptyHint =>
      'کارت‌ها و حساب‌هایی را که با آن‌ها پرداخت می‌کنید اضافه کنید تا بتوانید در تراکنش یکی را انتخاب کنید.';

  @override
  String get txnPmDeleteBody =>
      'تراکنش‌هایی که قبلاً با آن ثبت شده‌اند باقی می‌مانند. فقط دیگر روش پرداختی را نشان نمی‌دهند.';

  @override
  String get txnPmNew => 'روش پرداخت جدید';

  @override
  String get txnPmEdit => 'ویرایش روش پرداخت';

  @override
  String get txnRecentlyDeletedFooter =>
      'تراکنش‌های حذف‌شده سی روز نگه داشته می‌شوند و سپس برای همیشه پاک می‌شوند.';

  @override
  String get txnUnknownCategory => 'نامشخص';

  @override
  String txnRuleSubtitle(String match, String category) {
    return '$match → $category';
  }

  @override
  String get txnRuleExactly => 'دقیقاً همین';

  @override
  String get txnRuleContaining => 'هر چیزی که این را دارد';

  @override
  String get txnRulesFooter =>
      'یک قانون هر جای عنوان را تطبیق می‌دهد، مگر اینکه آن را دقیق کنید. هر بار که چیزی را دستی دسته‌بندی کنید، برنامه یکی برایتان اضافه می‌کند.';

  @override
  String get txnRulesEmptyHint =>
      'یک بار به برنامه یاد بدهید هر چیزی کجا می‌رود، از آن به بعد همان‌طور دسته‌بندی می‌کند.';

  @override
  String get txnRuleNew => 'قانون جدید';

  @override
  String get txnRuleEdit => 'ویرایش قانون';

  @override
  String get txnRuleExactHint => 'فقط عنوان‌هایی که دقیقاً همین هستند';

  @override
  String get txnRuleContainingHint => 'هر عنوانی که آن را دارد';

  @override
  String get txnKindTransfer => 'انتقال بین حساب‌ها';

  @override
  String get txnKindRecurring => 'از یک مورد تکراری';

  @override
  String get txnMoneyIn => 'پول ورودی';

  @override
  String get txnMoneyOut => 'پول خروجی';

  @override
  String get txnNotYetPaid => 'هنوز پرداخت نشده';

  @override
  String get txnLentOut => 'قرض داده‌شده';

  @override
  String get txnSettledInFull => 'به‌طور کامل تسویه شد.';

  @override
  String txnLoanProgress(String paid, String owed) {
    return '$paid برگشته، $owed هنوز مانده.';
  }

  @override
  String get txnUncategorised => 'بدون دسته';

  @override
  String get txnUnknownAccount => 'نامشخص';

  @override
  String get txnTransferCannotCopy =>
      'یک انتقال را نمی‌توان به‌تنهایی کپی کرد.';

  @override
  String get txnCopied => 'کپی شد.';

  @override
  String get txnDeleteOneBody =>
      'موجودی حساب دوباره محاسبه می‌شود. اگر این یک طرف از یک انتقال باشد، طرف دیگر هم با آن می‌رود.';

  @override
  String txnUpcomingTab(int count) {
    return 'پیش رو ($count)';
  }

  @override
  String txnOverdueTab(int count) {
    return 'معوق ($count)';
  }

  @override
  String get txnNoOverdue => 'تراکنش معوقی وجود ندارد';

  @override
  String get txnNoUpcoming => 'تراکنش پیش رویی وجود ندارد';

  @override
  String get txnNoOverdueBody => 'همه پرداخت‌های شما به‌روز هستند!';

  @override
  String get txnNoUpcomingBody => 'هیچ پرداخت در انتظاری برنامه‌ریزی نشده است';

  @override
  String get txnTotalOverdue => 'مجموع معوق';

  @override
  String get txnTotalUpcoming => 'مجموع پیش رو';

  @override
  String txnItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد',
      one: '۱ مورد',
    );
    return '$_temp0';
  }

  @override
  String txnDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز معوق',
      one: '۱ روز معوق',
    );
    return '$_temp0';
  }

  @override
  String txnMarkedPaid(String title) {
    return '«$title» به‌عنوان پرداخت‌شده علامت خورد';
  }

  @override
  String txnSkippedTitle(String title) {
    return '«$title» رد شد';
  }

  @override
  String txnDateHeaderToday(String date) {
    return 'امروز، $date';
  }

  @override
  String txnDateHeaderYesterday(String date) {
    return 'دیروز، $date';
  }

  @override
  String txnDateHeaderTomorrow(String date) {
    return 'فردا، $date';
  }

  @override
  String txnDeleteError(String error) {
    return 'خطا در حذف تراکنش: $error';
  }

  @override
  String txnFilterTitle(String title) {
    return 'فیلتر $title';
  }

  @override
  String get txnMonthlyIncome => 'درآمد ماهانه';

  @override
  String get txnMonthlyExpenses => 'هزینه‌های ماهانه';

  @override
  String txnStatTransactions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تراکنش',
      one: 'تراکنش',
    );
    return '$_temp0';
  }

  @override
  String get txnAvgPerTransaction => 'میانگین هر تراکنش';

  @override
  String get txnNoPlannedIncome => 'درآمد برنامه‌ریزی‌شده‌ای نیست';

  @override
  String get txnNoPlannedExpenses => 'هزینه برنامه‌ریزی‌شده‌ای نیست';

  @override
  String txnAddFutureIncome(String month) {
    return 'درآمد آینده را برای $month اضافه کنید';
  }

  @override
  String txnAddFutureExpenses(String month) {
    return 'هزینه‌های آینده را برای $month اضافه کنید';
  }

  @override
  String get txnNoIncomeYet => 'این ماه هنوز درآمدی نیست';

  @override
  String get txnNoExpensesYet => 'این ماه هنوز هزینه‌ای نیست';

  @override
  String get txnStartTrackingIncome => 'از این ماه درآمدتان را ثبت کنید';

  @override
  String get txnStartTrackingExpenses => 'از این ماه هزینه‌هایتان را ثبت کنید';

  @override
  String txnNoIncomeIn(String month) {
    return 'در $month درآمدی نیست';
  }

  @override
  String txnNoExpensesIn(String month) {
    return 'در $month هزینه‌ای نیست';
  }

  @override
  String txnNoRecordsFor(String month) {
    return 'برای $month موردی ثبت نشده';
  }

  @override
  String get txnOtherCategory => 'سایر';

  @override
  String get txnSearchIncome => 'جستجوی درآمد';

  @override
  String get txnSearchExpenses => 'جستجوی هزینه‌ها';

  @override
  String txnErrorWith(String error) {
    return 'خطا: $error';
  }

  @override
  String get txnTapToEditAmount => 'برای ویرایش مبلغ ضربه بزنید';

  @override
  String get txnTapToEnterAmount => 'برای وارد کردن مبلغ ضربه بزنید';

  @override
  String get txnSpecialDefault => 'پیش‌فرض';

  @override
  String get txnSpecialRepetitive => 'تکراری';

  @override
  String get txnRepeatSettings => 'تنظیمات تکرار';

  @override
  String get txnSubscriptionSettings => 'تنظیمات اشتراک';

  @override
  String txnEndsOn(String date) {
    return 'پایان: $date';
  }

  @override
  String get txnNoEndDate => 'بدون تاریخ پایان';

  @override
  String get txnEditTransaction => 'ویرایش تراکنش';

  @override
  String get txnNewTransaction => 'تراکنش جدید';

  @override
  String get txnFromAccount => 'از حساب';

  @override
  String get txnToAccount => 'به حساب';

  @override
  String get txnAmountReceived => 'مبلغ دریافتی';

  @override
  String txnAmountReceivedHint(String account) {
    return 'این حساب‌ها با ارزهای متفاوتی حساب می‌شوند. مبلغی را که واقعاً به $account رسید وارد کنید، یا برای استفاده از نرخ برنامه خالی بگذارید.';
  }

  @override
  String txnInCurrency(String currency) {
    return 'به $currency';
  }

  @override
  String get txnTransferTitleHint => 'مثلاً انتقال به پس‌انداز (اختیاری)';

  @override
  String get txnTitleHint => 'برای چه بود؟';

  @override
  String get txnUpdate => 'به‌روزرسانی';

  @override
  String get txnSelectCategory => 'انتخاب دسته';

  @override
  String get txnSearchTransactions => 'جستجوی تراکنش‌ها';

  @override
  String get txnSpecialRegular => 'عادی';

  @override
  String get txnSpecialLend => 'قرض دادن';

  @override
  String get txnSpecialBorrow => 'قرض گرفتن';

  @override
  String get txnSpecialRegularDesc => 'تراکنش عادی';

  @override
  String get txnSpecialUpcomingDesc => 'پرداخت آینده برای پیگیری';

  @override
  String get txnSpecialSubscriptionDesc => 'پرداخت دوره‌ای یک سرویس';

  @override
  String get txnSpecialRepetitiveDesc => 'تراکنش تکراری';

  @override
  String get txnSpecialLendDesc => 'پولی که قرض دادید (به شما بدهکارند)';

  @override
  String get txnSpecialBorrowDesc => 'پولی که قرض گرفتید (به آن‌ها بدهکارید)';

  @override
  String txnFilterBoundsInverted(String min, String max) {
    return 'حد پایین از حد بالا بیشتر است، پس هیچ چیز مطابقت ندارد. $min تا $max.';
  }

  @override
  String get walletMyWallet => 'کیف پول من';

  @override
  String walletCreateFailed(String error) {
    return 'ایجاد کیف پول ناموفق بود: $error';
  }

  @override
  String get walletTypeBankAccount => 'حساب بانکی';

  @override
  String get walletTypeCreditCard => 'کارت اعتباری';

  @override
  String get walletTypeSubscription => 'اشتراک';

  @override
  String get walletTypeDeposit => 'سپرده';

  @override
  String get walletTypeInvestment => 'سرمایه‌گذاری';

  @override
  String get walletTypeAsset => 'دارایی';

  @override
  String get walletEnterAccountName => 'لطفاً نام حساب را وارد کنید';

  @override
  String get walletCreditLimitRequired => 'سقف اعتبار لازم است';

  @override
  String get walletEnterValidCreditLimit => 'لطفاً سقف اعتبار معتبری وارد کنید';

  @override
  String get walletEnterValidCreditLimitAboveZero =>
      'لطفاً سقف اعتبار معتبر بیشتر از ۰ وارد کنید';

  @override
  String get walletEditWallet => 'ویرایش کیف پول';

  @override
  String get walletAddNewWallet => 'افزودن کیف پول جدید';

  @override
  String get walletEnterWalletNameError => 'لطفاً نام کیف پول را وارد کنید';

  @override
  String get walletEnterValidNumber => 'لطفاً عدد معتبری وارد کنید';

  @override
  String get walletShowCents => 'نمایش سنت (مثلاً \$1,234.56)';

  @override
  String get walletWholeNumbersOnly => 'فقط اعداد صحیح (مثلاً \$1,235)';

  @override
  String get walletCreateWallet => 'ایجاد کیف پول';

  @override
  String get walletClosedPill =>
      'بسته شده. تاریخچه‌اش حفظ می‌شود، اما دیگر پیشنهاد یا شمرده نمی‌شود.';

  @override
  String get walletExcludedPill => 'از مجموع همه حساب‌ها کنار گذاشته شده.';

  @override
  String get walletReopen => 'بازگشایی';

  @override
  String get walletCloseAccount => 'بستن حساب';

  @override
  String get walletReopenSubtitle => 'دوباره پیشنهاد و شمرده شود';

  @override
  String get walletCloseAccountSubtitle => 'تاریخچه بماند، شمرده نشود';

  @override
  String get walletIncludeInTotal => 'در مجموع لحاظ شود';

  @override
  String get walletLeaveOutOfTotal => 'از مجموع کنار گذاشته شود';

  @override
  String get walletAlreadyTheBalance => 'موجودی همین است.';

  @override
  String get walletCorrectionRecorded => 'تفاوت به‌عنوان اصلاح ثبت شد.';

  @override
  String walletMergeConfirmBody(String name) {
    return 'همه موارد ثبت‌شده در $name منتقل می‌شوند و $name بسته می‌شود. چیزی حذف نمی‌شود.';
  }

  @override
  String walletMergeConfirmBodyConverted(String name, String from, String to) {
    return 'مبالغ هنگام انتقال از $from به $to تبدیل می‌شوند. چیزی حذف نمی‌شود و $name به‌جای پاک شدن بسته می‌شود.';
  }

  @override
  String walletCardInCredit(String amount, String available) {
    return '$amount بستانکار · $available در دسترس';
  }

  @override
  String walletCardOwed(String amount, String available) {
    return '$amount بدهی · $available هنوز در دسترس';
  }

  @override
  String walletCorrectBalanceBody(String name) {
    return 'مبلغی را که واقعاً در $name است وارد کنید. تفاوت به‌عنوان یک تراکنش ثبت می‌شود تا حساب با تاریخچه‌اش جور باشد.';
  }

  @override
  String get apiUpdateRequired =>
      'برای ادامهٔ همگام‌سازی، The Accountant را به‌روز کنید. تا آن موقع همه‌چیز روی همین گوشی می‌ماند.';

  @override
  String get apiAccountExistsLink =>
      'حسابی با این ایمیل از قبل وجود دارد. لطفاً حساب‌هایتان را به هم پیوند دهید.';

  @override
  String get apiServerTrouble =>
      'سرور ما الان دچار مشکل است. همه‌چیز روی این گوشی امن است؛ چند دقیقهٔ دیگر دوباره تلاش کنید.';

  @override
  String apiRequestFailedHttp(String status) {
    return 'درخواست ناموفق بود (HTTP $status).';
  }

  @override
  String get apiServerTimeout =>
      'پاسخ سرور ما خیلی طول کشید. اتصالتان را بررسی کنید یا چند دقیقهٔ دیگر دوباره تلاش کنید.';

  @override
  String get apiCannotReachServer =>
      'به سرور ما دسترسی نیست. اتصالتان را بررسی کنید؛ اگر آنلاین هستید، چند دقیقهٔ دیگر دوباره تلاش کنید.';

  @override
  String get apiSomethingWentWrong =>
      'در ارتباط با سرور ما مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String get syncAlreadyInProgress => 'همگام‌سازی در حال انجام است';

  @override
  String get syncRequiresPremium =>
      'همگام‌سازی ابری به اشتراک Premium نیاز دارد';

  @override
  String get syncNoInternet => 'اتصال اینترنت برقرار نیست';

  @override
  String get syncNotAuthenticated => 'وارد نشده‌اید';

  @override
  String get syncCouldNotFetchCloud =>
      'داده‌های ابری شما دریافت نشد. داده‌های این دستگاه تغییری نکرده است.';

  @override
  String get syncAccountUnknown => 'حساب واردشده مشخص نشد؛ همگام‌سازی لغو شد.';

  @override
  String get syncStoreOtherAccount =>
      'داده‌های این دستگاه متعلق به حساب دیگری است. پیش از همگام‌سازی، با آن حساب وارد شوید یا داده‌های این دستگاه را پاک کنید.';

  @override
  String syncRecordsNotSaved(String record) {
    return 'برخی رکوردهای ابری روی این دستگاه ذخیره نشدند: $record. در همگام‌سازی بعدی دوباره امتحان می‌شوند.';
  }

  @override
  String syncRecordsNotSavedMore(String record, int count) {
    return 'برخی رکوردهای ابری روی این دستگاه ذخیره نشدند: $record (و $count مورد دیگر). در همگام‌سازی بعدی دوباره امتحان می‌شوند.';
  }

  @override
  String notifCardStatementReady(String name) {
    return 'صورت‌حساب $name آماده است';
  }

  @override
  String notifCardStatementPaid(String amount) {
    return 'مبلغ آن $amount بود که پرداخت شده است. چیز دیگری بدهکار نیستید.';
  }

  @override
  String notifCardDueBy(String amount, String date) {
    return '$amount تا $date سررسید دارد.';
  }

  @override
  String notifCardPaidSoFar(String paid, String owed) {
    return '$paid از $owed پرداخت شده است.';
  }

  @override
  String notifCardDueTomorrow(String name) {
    return 'سررسید صورت‌حساب $name فرداست';
  }

  @override
  String notifCardDueInDays(String name, int days) {
    return 'سررسید صورت‌حساب $name $days روز دیگر است';
  }

  @override
  String notifPayBy(String amount, String date) {
    return '$amount را تا $date پرداخت کنید.';
  }

  @override
  String notifCardDueToday(String name) {
    return 'سررسید صورت‌حساب $name امروز است';
  }

  @override
  String notifCardStillUnpaid(String amount, String paidSoFar) {
    return '$amount هنوز پرداخت نشده است.$paidSoFar پرداخت امروز از جریمهٔ دیرکرد جلوگیری می‌کند.';
  }

  @override
  String get notifWhenToday => 'امروز';

  @override
  String get notifWhenTomorrow => 'فردا';

  @override
  String notifWhenInDays(int days) {
    return '$days روز دیگر';
  }

  @override
  String notifPlanPaysOut(String name, String when) {
    return '$name $when پرداخت می‌شود';
  }

  @override
  String notifPlanPayoutBody(String amount, String account, String date) {
    return '$amount در $date به $account واریز می‌شود.';
  }

  @override
  String notifPlanMatures(String name, String when) {
    return '$name $when سررسید می‌شود';
  }

  @override
  String notifPlanMaturityBody(String amount, String account, String date) {
    return '$amount در $date به $account برمی‌گردد.';
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
      'dps': 'سپردهٔ',
      'insurance': 'حق بیمهٔ',
      'sip': 'SIP',
      'other': 'قسط',
    });
    return '$name: $_temp0 $number از $total $when سررسید است';
  }

  @override
  String notifInvestBy(String amount, String date) {
    return '$amount را تا $date سرمایه‌گذاری کنید.';
  }

  @override
  String notifWillBeInvested(String amount, String account, String date) {
    return '$amount در $date از $account سرمایه‌گذاری می‌شود.';
  }

  @override
  String notifWillBeRecorded(String amount, String account, String date) {
    return '$amount در $date از $account ثبت می‌شود.';
  }

  @override
  String get notifYourAccount => 'حساب شما';

  @override
  String get notifPlansUpdatedTitle => 'اقساط و پس‌انداز به‌روز شد';

  @override
  String notifPlansUpdatedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد از برنامه‌ها در روز خودشان ثبت شدند.',
      one: '۱ مورد از برنامه در روز خودش ثبت شد.',
    );
    return '$_temp0';
  }

  @override
  String get notifRecurringRecordedTitle => 'تراکنش‌های تکراری ثبت شدند';

  @override
  String notifRecurringRecordedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تراکنش تکراری ثبت شد.',
      one: '۱ تراکنش تکراری ثبت شد.',
    );
    return '$_temp0';
  }

  @override
  String notifPaymentsToConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پرداخت برای تأیید',
      one: '۱ پرداخت برای تأیید',
    );
    return '$_temp0';
  }

  @override
  String get notifPaymentsToConfirmBody =>
      'در «پیش رو» مبلغ کسرشده را تأیید کنید یا از آن بگذرید.';

  @override
  String notifPaymentsToConfirmBodyNames(String names) {
    return '$names — در «پیش رو» مبلغ کسرشده را تأیید کنید یا از آن بگذرید.';
  }

  @override
  String get notifUpcomingFallbackTitle => 'تراکنش پیش رو';

  @override
  String notifUpcomingTitle(String title) {
    return 'پیش رو: $title';
  }

  @override
  String notifUpcomingIncomeBody(String amount) {
    return 'درآمد $amount به‌زودی سررسید می‌شود.';
  }

  @override
  String notifUpcomingExpenseBody(String amount) {
    return 'هزینهٔ $amount به‌زودی سررسید می‌شود.';
  }

  @override
  String get notifCreditFallback => 'طلب';

  @override
  String get notifDebtFallback => 'بدهی';

  @override
  String notifOverdueCreditTitle(String title) {
    return 'طلب معوق: $title';
  }

  @override
  String notifOverdueDebtTitle(String title) {
    return 'بدهی معوق: $title';
  }

  @override
  String notifOutstandingBody(String amount) {
    return '$amount هنوز تسویه نشده است. برای بررسی ضربه بزنید.';
  }

  @override
  String get notifRecurringFallbackTitle => 'تراکنش تکراری';

  @override
  String notifUpcomingRecurringTitle(String title) {
    return 'تکراری پیش رو: $title';
  }

  @override
  String notifDueOnBody(String amount, String date) {
    return '$amount با سررسید $date.';
  }

  @override
  String notifCreditDueTitle(String title) {
    return 'سررسید طلب: $title';
  }

  @override
  String notifDebtDueTitle(String title) {
    return 'سررسید بدهی: $title';
  }

  @override
  String notifSubscriptionDueTitle(String title) {
    return 'سررسید اشتراک: $title';
  }

  @override
  String notifBillDueTitle(String title) {
    return 'سررسید قبض: $title';
  }

  @override
  String notifDueSoonTitle(String title) {
    return 'سررسید نزدیک: $title';
  }

  @override
  String get notifRepetitiveBillFallback => 'قبض تکراری';

  @override
  String notifDueSoonBody(String amount) {
    return 'سررسید $amount نزدیک است. برای بررسی ضربه بزنید.';
  }

  @override
  String get notifChannelRecurring => 'تراکنش‌های تکراری';

  @override
  String get notifChannelRecurringDesc => 'اعلان‌های تراکنش‌های تکراریِ خودکار';

  @override
  String get notifChannelUpcoming => 'یادآوری‌های پیش رو';

  @override
  String get notifChannelUpcomingDesc => 'یادآوری تراکنش‌های پیش رو';

  @override
  String get notifChannelLoan => 'یادآوری وام‌ها';

  @override
  String get notifChannelLoanDesc => 'یادآوری طلب‌ها و بدهی‌های معوق';

  @override
  String get notifChannelDueDate => 'یادآوری سررسیدها';

  @override
  String get notifChannelDueDateDesc =>
      'یادآوری‌های یک‌باره برای سررسید تراکنش‌های مشخص';

  @override
  String get notifChannelBillsDesc =>
      'صورت‌حساب‌های کارت اعتباری و اقساط برنامه‌ها که سررسیدشان نزدیک است';

  @override
  String get notifOffset1Hour => '۱ ساعت قبل';

  @override
  String get notifOffset1Day => '۱ روز قبل';

  @override
  String get notifOffset3Days => '۳ روز قبل';

  @override
  String get notifOffset1Week => '۱ هفته قبل';

  @override
  String notifOffsetMinutes(int minutes) {
    return '$minutes دقیقه قبل';
  }

  @override
  String get notifChannelGeneral => 'عمومی';

  @override
  String get notifChannelGeneralDesc => 'اعلان‌های حساب و برنامه';

  @override
  String get notifChannelReminders => 'یادآوری‌های روزانه';

  @override
  String get notifChannelRemindersDesc => 'یادآوری برای ثبت خرج‌های روز';

  @override
  String get notifChannelBillsStatementsDesc =>
      'صورت‌حساب‌ها و سررسیدهای کارت اعتباری';

  @override
  String get notifChannelBudgets => 'هشدارهای بودجه';

  @override
  String get notifChannelBudgetsDesc =>
      'وقتی بودجه‌ای تقریباً یا کاملاً خرج شده است';

  @override
  String notifOverBudgetTitle(String name) {
    return 'فراتر از بودجه: $name';
  }

  @override
  String notifBudgetAlertTitle(String name) {
    return 'هشدار بودجه: $name';
  }

  @override
  String notifOverBudgetBody(String percent, String name) {
    return '$percent% از بودجهٔ $name این دوره را خرج کرده‌اید.';
  }

  @override
  String notifBudgetAlertBody(String percent, String name) {
    return '$percent% از بودجهٔ $name را مصرف کرده‌اید.';
  }

  @override
  String get notifPremiumEndingTitle => 'Premium به‌زودی تمام می‌شود';

  @override
  String get notifPremiumEndsTomorrow =>
      'Premium شما فردا تمام می‌شود. برای حفظ امکانات Premium تمدید کنید.';

  @override
  String notifPremiumEndsInDays(int days) {
    return 'Premium شما $days روز دیگر تمام می‌شود. برای حفظ امکانات Premium تمدید کنید.';
  }

  @override
  String get notifLargeIncomeTitle => 'هشدار درآمد بزرگ';

  @override
  String get notifLargeExpenseTitle => 'هشدار هزینهٔ بزرگ';

  @override
  String notifLargeIncomeBodyTitled(String amount, String title) {
    return 'درآمد $amount ثبت شد: $title';
  }

  @override
  String notifLargeIncomeBody(String amount) {
    return 'درآمد $amount ثبت شد';
  }

  @override
  String notifLargeExpenseBodyTitled(String amount, String title) {
    return 'هزینهٔ $amount ثبت شد: $title';
  }

  @override
  String notifLargeExpenseBody(String amount) {
    return 'هزینهٔ $amount ثبت شد';
  }

  @override
  String get notifChannelDailyRemindersDesc =>
      'اعلان‌های یادآوری روزانهٔ هزینه‌ها';

  @override
  String get notifDailyReminderTitle => 'یادآوری روزانهٔ هزینه‌ها';

  @override
  String get notifDailyReminderBody =>
      'ثبت هزینه‌های امروز را فراموش نکنید! خرج‌هایتان را زیر نظر داشته باشید.';

  @override
  String get notifTestTitle => 'اعلان آزمایشی';

  @override
  String get notifTestBody => 'اگر این را می‌بینید، اعلان‌ها کار می‌کنند!';

  @override
  String get notifActionSnooze1Day => '۱ روز بعد';

  @override
  String get notifActionSnooze1Week => '۱ هفته بعد';

  @override
  String get notifGroupThisWeek => 'این هفته';

  @override
  String get notifGroupThisMonth => 'این ماه';

  @override
  String notifDateAtTime(String date, String time) {
    return '$date ساعت $time';
  }

  @override
  String notifMinutesAgo(int count) {
    return '$count دقیقه پیش';
  }

  @override
  String notifHoursAgo(int count) {
    return '$count ساعت پیش';
  }

  @override
  String notifDaysAgo(int count) {
    return '$count روز پیش';
  }

  @override
  String get notifPrimerSheetBody =>
      'اعلان‌ها را روشن کنید تا دربارهٔ چیزهای مهم از قبل خبرتان کنیم.';

  @override
  String get notifPrimerBudgetsBody =>
      'پیش از اینکه از بودجه فراتر بروید باخبر شوید.';

  @override
  String get notifPrimerBillsTitle => 'یادآوری قبض‌ها و اشتراک‌ها';

  @override
  String get notifPrimerBillsBody => 'هیچ پرداخت تکراری‌ای را از دست ندهید.';

  @override
  String get notifPrimerLargeTitle => 'تراکنش‌های بزرگ';

  @override
  String get notifPrimerLargeBody => 'از فعالیت‌های غیرعادی باخبر شوید.';

  @override
  String get notifLoadFailed => 'بارگیری اعلان‌ها ناموفق بود';

  @override
  String get startupReasonSomethingWrong =>
      'هنگام راه‌اندازی مشکلی پیش آمد. داده‌هایتان روی این دستگاه امن است.';

  @override
  String get startupReasonCouldNotOpenLocal =>
      'داده‌های این حساب روی دستگاه باز نشد.';

  @override
  String get startupReasonSetupFailed =>
      'نتوانستیم راه‌اندازی این حساب را روی این دستگاه تمام کنیم. چیزی حذف نشده است.';

  @override
  String get startupReasonOffline =>
      'نتوانستیم به حسابتان دسترسی پیدا کنیم و این دستگاه هنوز داده‌های آن را ندارد. اگر قبلاً از The Accountant استفاده کرده‌اید، به اینترنت وصل شوید تا داده‌هایتان را برگردانیم. تازه آمده‌اید؟ همین حالا می‌توانید روی این دستگاه شروع کنید.';

  @override
  String get startupReasonNeedsSubscription =>
      'این حساب داده‌هایی در فضای ابری دارد. بازگردانی آن‌ها به اشتراک فعال نیاز دارد. چیزی حذف نشده است.';

  @override
  String get startupReasonConfirmingSubscription =>
      'این حساب داده‌هایی در فضای ابری دارد. هنوز در حال تأیید اشتراک شما هستیم تا بتوان آن‌ها را بازگرداند.';

  @override
  String startupReasonRestoreFailed(String error) {
    return 'بازگردانی ناموفق بود: $error';
  }

  @override
  String get startupReasonNotRestoredYet =>
      'این حساب داده‌هایی در فضای ابری دارد، اما هنوز بازگردانی نشده‌اند.';

  @override
  String get commonBiometricReason =>
      'برای باز کردن قفل The Accountant هویت خود را تأیید کنید';

  @override
  String get commonLoadCurrenciesFailed => 'بارگیری ارزها ناموفق بود';

  @override
  String get commonLoadRatesFailed => 'بارگیری نرخ ارز ناموفق بود';

  @override
  String get commonRefreshRatesFailed => 'به‌روزرسانی نرخ ارز ناموفق بود';

  @override
  String get commonAllCategories => 'همهٔ دسته‌ها';

  @override
  String commonCategoryCount(int count) {
    return '$count دسته';
  }

  @override
  String get commonTierFree => 'رایگان';

  @override
  String get commonTierMonthly => 'Premium ماهانه';

  @override
  String get commonTierYearly => 'Premium سالانه';

  @override
  String get commonTierLifetime => 'Premium مادام‌العمر';

  @override
  String get commonCategoryMergeSelf =>
      'یک دسته را نمی‌توان با خودش ادغام کرد.';

  @override
  String get commonCategoryMergeMissing =>
      'برای ادغام، هر دو دسته باید وجود داشته باشند.';

  @override
  String get commonCategoryMergeSystem =>
      'دسته‌های خود برنامه را نمی‌توان ادغام کرد.';

  @override
  String get commonCategoryMergeKinds =>
      'دسته‌های درآمد و هزینه را نمی‌توان ادغام کرد.';

  @override
  String get commonCategoryOneLevel =>
      'آن دسته داخل دستهٔ دیگری است و دسته‌ها فقط یک سطح دارند.';

  @override
  String get commonCategoryMoveSame =>
      'دستهٔ دیگری را برای انتقال انتخاب کنید.';

  @override
  String get commonCategoryMoveMissing =>
      'برای انتقال، هر دو دسته باید وجود داشته باشند.';

  @override
  String get commonCategoryMoveSystem =>
      'نمی‌توان بین دسته‌های خود برنامه جابه‌جا کرد.';

  @override
  String get commonCategoryMoveKinds =>
      'تراکنش‌های درآمد و هزینه نمی‌توانند دسته‌هایشان را عوض کنند.';

  @override
  String get commonCategoryGone => 'آن دسته دیگر وجود ندارد.';

  @override
  String get commonCategoryParentSystem =>
      'دسته‌های خود برنامه را نمی‌توان جابه‌جا کرد.';

  @override
  String get commonCategoryParentSelf => 'یک دسته نمی‌تواند داخل خودش باشد.';

  @override
  String get commonCategoryParentIntoSystem =>
      'هیچ چیزی را نمی‌توان داخل دسته‌های خود برنامه گذاشت.';

  @override
  String get commonCategoryParentKinds =>
      'یک دستهٔ درآمد و یک دستهٔ هزینه را نمی‌توان داخل هم گذاشت.';

  @override
  String get commonCategoryHasChildren =>
      'این دسته زیردسته‌های خودش را دارد، پس در سطح بالا می‌ماند.';

  @override
  String get commonTapToChange => 'برای تغییر ضربه بزنید';

  @override
  String get commonSelectColor => 'انتخاب رنگ';

  @override
  String get commonShowPalette => 'نمایش پالت';

  @override
  String get commonCustomColor => 'رنگ دلخواه';

  @override
  String get commonSelectCurrency => 'انتخاب ارز';

  @override
  String get commonEnableCryptoHint =>
      'برای جست‌وجوی توکن‌های دیجیتال، «شامل ارزهای دیجیتال» را روشن کنید.';

  @override
  String get commonSearchHint => 'جست‌وجو...';

  @override
  String get aiLoadConversationsFailed => 'بارگیری گفتگوها ناموفق بود.';

  @override
  String get aiLoadHistoryFailed => 'بارگیری تاریخچهٔ گفتگو ناموفق بود.';

  @override
  String get aiPremiumRequired =>
      'دستیار هوش مصنوعی به اشتراک Premium نیاز دارد';

  @override
  String get aiUnexpectedError =>
      'خطای غیرمنتظره‌ای رخ داد. لطفاً دوباره تلاش کنید.';

  @override
  String get aiResponseFailed =>
      'پاسخ هوش مصنوعی دریافت نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get aiServiceNotAnswering => 'سرویس هوش مصنوعی پاسخ نمی‌دهد.';

  @override
  String get aiReplyCutOff => 'پاسخ نیمه‌کاره ماند. لطفاً دوباره تلاش کنید.';

  @override
  String get aiCouldNotReachServer =>
      'به سرور دسترسی نیست. اتصالتان را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get aiSomethingWentWrong => 'مشکلی پیش آمد.';

  @override
  String get aiOpenConversationFailed => 'باز کردن گفتگو ناموفق بود.';

  @override
  String aiChangesSavedReplyLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count تغییر شما ذخیره شد، اما مشاور نتوانست پاسخش را تمام کند. پیش از پرسیدن دوباره، آن‌ها را در سوابقتان بررسی کنید.',
      one:
          'تغییر شما ذخیره شد، اما مشاور نتوانست پاسخش را تمام کند. پیش از پرسیدن دوباره، آن را در سوابقتان بررسی کنید.',
    );
    return '$_temp0';
  }

  @override
  String get aiServiceNotAnsweringNow =>
      'سرویس هوش مصنوعی فعلاً پاسخ نمی‌دهد. لطفاً دوباره تلاش کنید.';

  @override
  String aiMinutesShort(int count) {
    return '$count دقیقه';
  }

  @override
  String aiHoursShort(int count) {
    return '$count ساعت';
  }

  @override
  String aiDaysShort(int count) {
    return '$count روز';
  }

  @override
  String get aiOcrTextFailed => 'استخراج متن از تصویر ناموفق بود';

  @override
  String get aiOcrReceiptFailed => 'استخراج اطلاعات رسید از تصویر ناموفق بود';

  @override
  String get coachYes => 'بله';

  @override
  String get coachNo => 'خیر';

  @override
  String get coachTradeBuy => 'خرید';

  @override
  String get coachTradeSell => 'فروش';

  @override
  String get coachTradeDividend => 'سود سهام';

  @override
  String get planAccountGone => 'آن حساب دیگر وجود ندارد.';

  @override
  String get planPaidFromOrdinary =>
      'پرداخت طرح از یک حساب معمولی است، نه از سپرده.';

  @override
  String get planSipChooseHolding =>
      'صندوق یا سهمی را که خرید دوره‌ای می‌خرد انتخاب کنید.';

  @override
  String get planSipPayFromOther =>
      'هزینه خرید دوره‌ای را از حساب دیگری بپردازید.';

  @override
  String get planNeedNameError => 'برای طرح یک نام بگذارید.';

  @override
  String get planInstallmentCountRange =>
      'تعداد اقساط باید بین 1 تا 1200 باشد.';

  @override
  String get planIntervalMin => 'فاصله باید دست‌کم 1 باشد.';

  @override
  String get planRateRange => 'نرخ باید بین 0 تا 100 درصد باشد.';

  @override
  String get planTaxRange => 'مالیات باید بین 0 تا 100 درصد باشد.';

  @override
  String get planProviderTooLong =>
      'نام شرکت و شماره را کمتر از 100 نویسه نگه دارید.';

  @override
  String get planNeedPremium => 'حق بیمه را وارد کنید.';

  @override
  String get planNeedInstallmentAmount => 'مبلغ هر قسط را وارد کنید.';

  @override
  String get planNeedDeposited => 'مبلغ سپرده‌شده را وارد کنید.';

  @override
  String get planTermMonthsOrYears => 'مدت آن به ماه یا سال است.';

  @override
  String get planAmountNotNegative => 'مبلغ نمی‌تواند منفی باشد.';

  @override
  String planMaturesOnCloseEarly(String name, String date) {
    return '$name در $date سررسید می‌شود. برای برداشت پول پیش از آن، آن را زودتر ببندید.';
  }

  @override
  String get planNoLongerExists => 'آن طرح دیگر وجود ندارد.';

  @override
  String get planReminderDaysRange =>
      'یادآوری می‌تواند از 0 (خاموش) تا 30 روز قبل باشد.';

  @override
  String planStillHoldsMoney(String name, String account) {
    return '$name هنوز پول دارد. ابتدا آن را ببندید تا پول به $account برگردد.';
  }

  @override
  String get planItsAccount => 'حساب آن';

  @override
  String planAlreadyEnded(String name) {
    return '$name پیش‌تر به پایان رسیده است.';
  }

  @override
  String get investNeedName => 'برای سرمایه‌گذاری یک نام بگذارید.';

  @override
  String get investNameTooLong => 'نام را کمتر از 100 نویسه نگه دارید.';

  @override
  String get investSymbolTooLong => 'نماد را کمتر از 20 نویسه نگه دارید.';

  @override
  String get investPriceNotNegative => 'قیمت نمی‌تواند منفی باشد.';

  @override
  String investAlreadyTracked(String name) {
    return '$name از قبل پیگیری می‌شود.';
  }

  @override
  String get investNeedPaid => 'مبلغ پرداخت‌شده را وارد کنید.';

  @override
  String get investUnitsBoughtPositive =>
      'واحدهای خریداری‌شده باید بیشتر از صفر باشد.';

  @override
  String get investPayFromOther => 'هزینه را از حساب دیگری بپردازید.';

  @override
  String get investNeedSaleAmount => 'مبلغ حاصل از فروش را وارد کنید.';

  @override
  String get investUnitsSoldPositive =>
      'واحدهای فروخته‌شده باید بیشتر از صفر باشد.';

  @override
  String get investSellIntoOther => 'فروش را به حساب دیگری واریز کنید.';

  @override
  String investOnlyUnitsHeld(String units, String name) {
    return 'تنها $units واحد از $name نگهداری می‌شود.';
  }

  @override
  String get investNeedDividend => 'سود سهام دریافتی را وارد کنید.';

  @override
  String get investReceiveIntoOrdinary => 'آن را به یک حساب معمولی واریز کنید.';

  @override
  String get investPricePositive => 'قیمت باید بیشتر از صفر باشد.';

  @override
  String get investUnitsPositive => 'تعداد واحد باید بیشتر از صفر باشد.';

  @override
  String get investNotATrade => 'این معامله یک سرمایه‌گذاری نیست.';

  @override
  String investStillHoldsUnits(String name) {
    return '$name هنوز واحد دارد. ابتدا آن‌ها را بفروشید.';
  }

  @override
  String get investNoLongerExists => 'آن سرمایه‌گذاری دیگر وجود ندارد.';

  @override
  String get networthNeedAssetName => 'برای دارایی یک نام بگذارید.';

  @override
  String get networthValueNotNegative => 'ارزش نمی‌تواند منفی باشد.';

  @override
  String get networthNeedPaidFor => 'مبلغی را که برای آن پرداخت شد وارد کنید.';

  @override
  String get networthPayFromOrdinary => 'هزینه را از یک حساب معمولی بپردازید.';

  @override
  String get networthNeedWorth => 'ارزش آن را وارد کنید.';

  @override
  String get networthNeedSoldFor => 'مبلغ فروش آن را وارد کنید.';

  @override
  String get networthReceiveIntoOrdinary =>
      'پول را به یک حساب معمولی واریز کنید.';

  @override
  String networthStillWorth(String name) {
    return '$name هنوز ارزش دارد. ابتدا آن را بفروشید یا ارزشش را صفر کنید.';
  }

  @override
  String get networthAssetGone => 'آن دارایی دیگر پیگیری نمی‌شود.';

  @override
  String get zakatNeedAmountPaid => 'مبلغ پرداخت‌شده را وارد کنید.';

  @override
  String get zakatPayFromOrdinary => 'آن را از یک حساب معمولی بپردازید.';

  @override
  String get zakatReminderTitleToday => 'زکات شما امروز سررسید است';

  @override
  String zakatReminderTitleIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'زکات تا $count روز دیگر سررسید است',
      one: 'زکات تا 1 روز دیگر سررسید است',
    );
    return '$_temp0';
  }

  @override
  String get zakatReminderBodyToday =>
      'سال زکات شما امروز کامل می‌شود. برای دیدن مبلغ لازم ضربه بزنید.';

  @override
  String zakatReminderBodyOn(String date) {
    return 'سال زکات شما در $date کامل می‌شود. برای دیدن مبلغ لازم ضربه بزنید.';
  }

  @override
  String get budgetCheckFailed => 'بررسی بودجه‌ها ناموفق بود';

  @override
  String get budgetLoadFailed => 'بارگیری بودجه‌ها ناموفق بود';

  @override
  String get budgetAddFailed => 'افزودن بودجه ناموفق بود';

  @override
  String get budgetNotFound => 'بودجه پیدا نشد';

  @override
  String get budgetUpdateFailed => 'به‌روزرسانی بودجه ناموفق بود';

  @override
  String get budgetDeleteFailed => 'حذف بودجه ناموفق بود';

  @override
  String get budgetEdit => 'ویرایش بودجه';

  @override
  String get budgetNeedName => 'برای بودجه یک نام بگذارید';

  @override
  String get budgetEnterAmount => 'یک مبلغ وارد کنید';

  @override
  String get budgetAmountMoreThanZero => 'مبلغ باید بیشتر از صفر باشد';

  @override
  String get budgetTrackingEarnings => 'پیگیری درآمد';

  @override
  String get budgetTrackingSpending => 'پیگیری هزینه';

  @override
  String get budgetRepeats => 'تکرار';

  @override
  String get budgetTooBig => 'خیلی بزرگ';

  @override
  String get budgetStarts => 'شروع';

  @override
  String get budgetEnds => 'پایان';

  @override
  String get budgetStopsRepeating => 'پایان تکرار';

  @override
  String get budgetNever => 'هرگز';

  @override
  String get budgetCategoriesAll => 'دسته‌ها: همه';

  @override
  String budgetCategoriesSelected(int count) {
    return 'دسته‌ها: $count انتخاب‌شده';
  }

  @override
  String get budgetNoIncomeCategories => 'هنوز دسته درآمدی وجود ندارد.';

  @override
  String get budgetNoExpenseCategories => 'هنوز دسته هزینه‌ای وجود ندارد.';

  @override
  String get budgetCategoriesHint =>
      'برای زیر نظر گرفتن همه دسته‌ها خالی بگذارید. هر چیزی که داخل یک دسته انتخاب‌شده ثبت شود نیز حساب می‌شود.';

  @override
  String get budgetAccountsAll => 'حساب‌ها: همه';

  @override
  String budgetAccountsSelected(int count) {
    return 'حساب‌ها: $count انتخاب‌شده';
  }

  @override
  String get budgetRolloverHint =>
      'هر مبلغ خرج‌نشده به دوره بعد اضافه می‌شود. فراتر رفتن، بدهی را به دوره بعد منتقل نمی‌کند.';

  @override
  String get budgetPeriodDaily => 'روزانه';

  @override
  String get budgetPeriodFortnightly => 'دوهفته‌ای';

  @override
  String get budgetPeriodOneOff => 'یک‌باره';

  @override
  String get budgetUnitDays => 'روز';

  @override
  String get budgetUnitWeeks => 'هفته';

  @override
  String get budgetUnitFortnights => 'دوهفته';

  @override
  String get budgetUnitMonths => 'ماه';

  @override
  String get budgetUnitYears => 'سال';

  @override
  String get budgetOneOffNeedsEnd => 'بودجه یک‌باره به تاریخ پایان نیاز دارد.';

  @override
  String get budgetEndAfterStart => 'تاریخ پایان باید بعد از تاریخ شروع باشد.';

  @override
  String get budgetSaveFailed => 'ذخیره بودجه ممکن نشد.';

  @override
  String get budgetThisPeriod => 'این دوره';

  @override
  String budgetPeriodsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دوره پیش',
      one: '1 دوره پیش',
    );
    return '$_temp0';
  }

  @override
  String budgetDateRange(String start, String end) {
    return '$start تا $end';
  }

  @override
  String budgetOfLimit(String limit) {
    return 'از $limit';
  }

  @override
  String budgetOfLimitCarried(String limit, String carried) {
    return 'از $limit، شامل $carried منتقل‌شده';
  }

  @override
  String get budgetUncategorised => 'بدون دسته';

  @override
  String budgetOverTheLimit(String amount) {
    return '$amount بیش از سقف.';
  }

  @override
  String budgetLeftPerDay(String left, String daily) {
    return '$left مانده، حدود $daily در روز.';
  }

  @override
  String budgetLeftPlain(String left) {
    return '$left مانده.';
  }

  @override
  String budgetAveraging(String amount) {
    return 'به‌طور میانگین $amount در هر دوره.';
  }

  @override
  String budgetHeadingOver(String amount) {
    return 'در مسیر $amount فراتر از سقف';
  }

  @override
  String budgetForecastScheduled(String scheduled) {
    return 'با این روند، و با احتساب $scheduled که پیش از پایان دوره برنامه‌ریزی شده است.';
  }

  @override
  String get budgetForecastPlain => 'با این روند، تا پایان دوره.';

  @override
  String get budgetCapsExplain =>
      'بودجه می‌گوید آیا در این دوره بیش از حد خرج شده است. سقف می‌گوید کجا: بودجه غذایی که در کل خوب پیش می‌رود، ممکن است بیشترش غذای بیرون باشد.';

  @override
  String get budgetPercentOfBudget => 'درصد بودجه';

  @override
  String get budgetArchivedTitle => 'بودجه‌های بایگانی‌شده';

  @override
  String get budgetShowActive => 'نمایش فعال‌ها';

  @override
  String get budgetShowArchived => 'نمایش بایگانی‌شده‌ها';

  @override
  String get budgetUnpin => 'برداشتن سنجاق';

  @override
  String get budgetPinToTop => 'سنجاق به بالا';

  @override
  String get budgetStartCounting => 'دوباره شمردنش را شروع کن';

  @override
  String get budgetStopCounting => 'تاریخچه‌اش را نگه دار، دیگر نشمارش';

  @override
  String get budgetDeleteBody =>
      'بودجه حذف می‌شود، تراکنش‌های شما می‌مانند. چیزی از ثبت‌های شما پاک نمی‌شود.';

  @override
  String get budgetNothingArchived => 'چیزی بایگانی نشده';

  @override
  String get budgetNoneYet => 'هنوز بودجه‌ای نیست';

  @override
  String get budgetArchivedEmptyHint =>
      'بودجه‌هایی که بایگانی کنید اینجا نگه داشته می‌شوند.';

  @override
  String get budgetEmptyHint =>
      'برای یک دسته سقف بگذارید و ببینید ماه چطور پیش می‌رود.';

  @override
  String dashLoadFailed(String error) {
    return 'بارگیری داده‌های مالی ناموفق بود: $error';
  }

  @override
  String get categoryUnknown => 'نامشخص';

  @override
  String dashCardAvailable(String amount) {
    return 'در دسترس: $amount';
  }

  @override
  String dashCardInCreditAvailable(String amount) {
    return 'بستانکار · در دسترس: $amount';
  }

  @override
  String get dashTypeBank => 'بانک';

  @override
  String get dashTypeCredit => 'اعتباری';

  @override
  String get dashTypeSubs => 'اشتراک';

  @override
  String get dashTypeDeposit => 'سپرده';

  @override
  String get dashTypeInvest => 'سرمایه';

  @override
  String get dashTypeAsset => 'دارایی';

  @override
  String get dashAddAccountTile => 'افزودن\nحساب';

  @override
  String get categoryLoadFailed => 'بارگیری دسته‌ها ناموفق بود';

  @override
  String get categoryAddFailed => 'افزودن دسته ناموفق بود';

  @override
  String get categoryNotFound => 'دسته پیدا نشد';

  @override
  String get categoryUpdateFailed => 'به‌روزرسانی دسته ناموفق بود';

  @override
  String get categoryCannotDeleteSystem =>
      'دسته‌های خود برنامه را نمی‌توان حذف کرد';

  @override
  String get categoryCannotDeleteWithTransactions =>
      'دسته‌ای که تراکنش دارد قابل حذف نیست؛ ابتدا آن‌ها را منتقل یا حذف کنید';

  @override
  String get categoryDeleteFailed => 'حذف دسته ناموفق بود';

  @override
  String categorySaveFailed(String error) {
    return 'ذخیره دسته ناموفق بود: $error';
  }

  @override
  String get categoryEditTitle => 'ویرایش دسته';

  @override
  String get categoryNewTitle => 'دسته جدید';

  @override
  String get categoryPartOf => 'زیرمجموعه';

  @override
  String get categoryNamePlaceholder => 'نام دسته';

  @override
  String get categoryUpdate => 'به‌روزرسانی دسته';

  @override
  String get categoryCreate => 'ایجاد دسته';

  @override
  String reportLoadFailed(String error) {
    return 'بارگیری گزارش‌ها ناموفق بود: $error';
  }

  @override
  String get goalEdit => 'ویرایش هدف';

  @override
  String get goalNeedName => 'برای هدف یک نام بگذارید';

  @override
  String get goalTargetMoreThanZero => 'مبلغ هدف باید بیشتر از صفر باشد';

  @override
  String get goalNoDeadline => 'بدون مهلت';

  @override
  String get goalTargetDateAfterStart =>
      'تاریخ هدف باید بعد از تاریخ شروع باشد.';

  @override
  String get goalSaveFailed => 'ذخیره هدف ممکن نشد.';

  @override
  String get goalArchivedTitle => 'هدف‌های بایگانی‌شده';

  @override
  String get goalHideFromHome => 'پنهان از صفحه اصلی';

  @override
  String get goalShowOnHome => 'نمایش در صفحه اصلی';

  @override
  String get goalReached => 'رسیدید';

  @override
  String goalToGo(String amount) {
    return '$amount مانده';
  }

  @override
  String get goalNoneYet => 'هنوز هدفی نیست';

  @override
  String get goalArchivedEmptyHint =>
      'هدف‌هایی که بایگانی کنید اینجا نگه داشته می‌شوند.';

  @override
  String get goalEmptyHint =>
      'چیزی را که برایش پس‌انداز می‌کنید نام‌گذاری کنید، سپس تراکنش‌هایی را که به آن می‌روند پیوند دهید.';

  @override
  String goalSavedOfTarget(String saved, String target) {
    return '$saved از $target';
  }

  @override
  String goalOfTarget(String target) {
    return 'از $target';
  }

  @override
  String get goalReachedNicelyDone => 'رسیدید. آفرین.';

  @override
  String goalStillToGo(String amount) {
    return 'هنوز $amount مانده است.';
  }

  @override
  String goalDailyToArrive(String amount) {
    return 'روزی $amount برای رسیدن به‌موقع.';
  }

  @override
  String get goalNothingLinked =>
      'هنوز چیزی پیوند داده نشده. این هدف را روی یک تراکنش انتخاب کنید تا اینجا نمایش داده شود.';

  @override
  String get goalDeleteBody =>
      'هدف حذف می‌شود، تراکنش‌های شما می‌مانند. فقط دیگر برای آن حساب نمی‌شوند.';

  @override
  String goalPaymentsOf(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پرداخت $amount',
      one: '1 پرداخت $amount',
    );
    return '$_temp0';
  }

  @override
  String goalFinishingAround(String date) {
    return 'پایان حدود $date.';
  }

  @override
  String goalNotFound(String id) {
    return 'هدف پیدا نشد: $id';
  }

  @override
  String get goalPaidOff => 'تسویه شد!';

  @override
  String get goalCompleted => 'کامل شد!';

  @override
  String goalPercentComplete(String percent) {
    return '$percent٪ کامل';
  }

  @override
  String goalWeeksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هفته مانده',
      one: '1 هفته مانده',
    );
    return '$_temp0';
  }

  @override
  String goalMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ماه مانده',
      one: '1 ماه مانده',
    );
    return '$_temp0';
  }

  @override
  String goalYearsLeft(String years) {
    return '$years سال مانده';
  }

  @override
  String get subRecurringBill => 'قبض تکرارشونده';

  @override
  String subEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count روز',
      one: 'هر 1 روز',
    );
    return '$_temp0';
  }

  @override
  String subEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count هفته',
      one: 'هر 1 هفته',
    );
    return '$_temp0';
  }

  @override
  String subEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count ماه',
      one: 'هر 1 ماه',
    );
    return '$_temp0';
  }

  @override
  String subEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count سال',
      one: 'هر 1 سال',
    );
    return '$_temp0';
  }

  @override
  String subEveryOther(int count, String unit) {
    return 'هر $count $unit';
  }

  @override
  String subLoadFailed(String error) {
    return 'بارگیری اشتراک‌ها ناموفق بود: $error';
  }

  @override
  String subPauseFailed(String error) {
    return 'توقف اشتراک ناموفق بود: $error';
  }

  @override
  String subResumeFailed(String error) {
    return 'ازسرگیری اشتراک ناموفق بود: $error';
  }

  @override
  String subUpdateFailed(String error) {
    return 'به‌روزرسانی اشتراک ناموفق بود: $error';
  }

  @override
  String subCancelFailed(String error) {
    return 'لغو اشتراک ناموفق بود: $error';
  }

  @override
  String subActiveCount(int count) {
    return 'فعال ($count)';
  }

  @override
  String subPausedCount(int count) {
    return 'متوقف ($count)';
  }

  @override
  String get subEmptyTitle => 'اشتراک یا قبضی وجود ندارد';

  @override
  String get subEmptyBody =>
      'تراکنش‌های اشتراک یا قبض تکرارشونده را اضافه کنید تا اینجا پیگیری شوند';

  @override
  String get subRecurringCost => 'هزینه تکرارشونده';

  @override
  String subPerYear(String amount) {
    return '$amount / سال';
  }

  @override
  String get subActive => 'فعال';

  @override
  String subNext(String date) {
    return 'بعدی $date';
  }

  @override
  String get subResume => 'ازسرگیری';

  @override
  String get subPause => 'توقف';

  @override
  String get subCancelBillTitle => 'لغو قبض تکرارشونده';

  @override
  String get subCancelSubTitle => 'لغو اشتراک';

  @override
  String subCancelConfirm(String name) {
    return 'آیا مطمئنید که می‌خواهید «$name» را لغو کنید؟ همه پرداخت‌های تکرارشونده آینده متوقف می‌شوند.';
  }

  @override
  String subCancelled(String name) {
    return '«$name» لغو شد';
  }

  @override
  String subSaveError(String error) {
    return 'خطا: $error';
  }

  @override
  String get subEditBill => 'ویرایش قبض تکرارشونده';

  @override
  String get subEditSub => 'ویرایش اشتراک';

  @override
  String subUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'روز',
      one: 'روز',
    );
    return '$_temp0';
  }

  @override
  String subUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هفته',
      one: 'هفته',
    );
    return '$_temp0';
  }

  @override
  String subUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ماه',
      one: 'ماه',
    );
    return '$_temp0';
  }

  @override
  String subUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سال',
      one: 'سال',
    );
    return '$_temp0';
  }

  @override
  String subEndsOn(String date) {
    return 'پایان: $date';
  }

  @override
  String get subNoEndDate => 'بدون تاریخ پایان';
}
