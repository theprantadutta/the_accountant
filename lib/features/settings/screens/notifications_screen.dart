import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise_page.dart';
import 'package:the_accountant/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/services/notification_service.dart';
import 'package:the_accountant/core/utils/time_formatter.dart';
import 'package:the_accountant/features/notifications/providers/notification_history_provider.dart';
import 'package:the_accountant/shared/widgets/sunrise/sunrise.dart'
    show showSunriseSnack, SnackTone;
import 'package:the_accountant/core/constants/background_task_constants.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';
import 'package:the_accountant/shared/widgets/shimmer_loading.dart';
import 'package:the_accountant/shared/widgets/permission_priming_sheet.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load preferences from backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationPreferencesProvider.notifier).loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsState = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(L10n.of(context).settingsNotifications),
      ),
      body: CappedBody(
        child: prefsState.isLoading
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ShimmerCard(height: 80),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                    SizedBox(height: 12),
                    ShimmerCard(height: 64),
                  ],
                ),
              )
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  // INFO CARD
                  Container(
                    margin: EdgeInsets.only(top: AppSpacing.lg),
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.08),
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(
                        color: AppColors.primaryAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Symbols.info_rounded,
                          color: AppColors.primaryAccent,
                          size: 24,
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            L10n.of(context).settingsConfigureWhenAndHowThe,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error message if any
                  if (prefsState.errorMessage != null)
                    Container(
                      margin: EdgeInsets.only(top: AppSpacing.md),
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: AppSpacing.borderRadiusLg,
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        prefsState.errorMessage!,
                        style: TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),

                  // DAILY REMINDERS SECTION
                  SettingsSection(
                    title: L10n.of(context).settingsDailyReminders,
                    tiles: [
                      SettingsSwitchTile(
                        icon: Icons.notifications_outlined,
                        title: L10n.of(context).settingsDailyReminders2,
                        subtitle: L10n.of(
                          context,
                        ).settingsGetRemindedToTrackYour,
                        value: prefsState.dailyReminderEnabled,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          _setDailyReminders(value);
                        },
                      ),
                      if (prefsState.dailyReminderEnabled)
                        _ReminderTimeTile(
                          reminderTime: prefsState.dailyReminderTime,
                          onTap: () => _showReminderTimePicker(context),
                        ),
                    ],
                  ),

                  // BUDGET ALERTS SECTION
                  SettingsSection(
                    title: L10n.of(context).settingsBudgetAlerts,
                    tiles: [
                      SettingsSwitchTile(
                        icon: Icons.account_balance_wallet_outlined,
                        title: L10n.of(context).settingsBudgetAlerts2,
                        subtitle: L10n.of(
                          context,
                        ).settingsNotifyWhenApproachingBudgetLimit,
                        value: prefsState.budgetAlertsEnabled,
                        onChanged: (value) async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(notificationPreferencesProvider.notifier)
                              .setBudgetAlertsEnabled(value);
                        },
                      ),
                      if (prefsState.budgetAlertsEnabled)
                        SettingsSliderTile(
                          icon: Icons.warning_amber_outlined,
                          iconColor: AppColors.warning,
                          title: L10n.of(context).settingsWarningThreshold,
                          subtitle:
                              '${prefsState.budgetWarningThreshold.toInt()}% of budget',
                          value: prefsState.budgetWarningThreshold,
                          min: 50,
                          max: 95,
                          divisions: 9,
                          onChanged: (value) async {
                            await ref
                                .read(notificationPreferencesProvider.notifier)
                                .setBudgetWarningThreshold(value);
                          },
                        ),
                    ],
                  ),

                  // TRANSACTION ALERTS SECTION
                  SettingsSection(
                    title: L10n.of(context).settingsTransactionAlerts,
                    tiles: [
                      SettingsSwitchTile(
                        icon: Icons.receipt_long_outlined,
                        title: L10n.of(context).settingsLargeTransactionAlerts,
                        subtitle: L10n.of(
                          context,
                        ).settingsNotifyForTransactionsAboveThreshold,
                        value: prefsState.largeTransactionAlertsEnabled,
                        onChanged: (value) async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(notificationPreferencesProvider.notifier)
                              .setLargeTransactionAlertsEnabled(value);
                        },
                      ),
                      if (prefsState.largeTransactionAlertsEnabled)
                        SettingsNavigationTile(
                          icon: Icons.attach_money,
                          title: L10n.of(
                            context,
                          ).settingsLargeTransactionThreshold,
                          subtitle:
                              '\$${prefsState.largeTransactionThreshold.toStringAsFixed(0)}',
                          onTap: () => _showThresholdDialog(context),
                        ),
                      SettingsSwitchTile(
                        icon: Icons.repeat,
                        title: L10n.of(
                          context,
                        ).settingsRecurringTransactionReminders,
                        subtitle: L10n.of(
                          context,
                        ).settingsRemindAboutUpcomingRecurringPayments,
                        value: prefsState.recurringTransactionRemindersEnabled,
                        onChanged: (value) async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(notificationPreferencesProvider.notifier)
                              .setRecurringRemindersEnabled(value);
                        },
                      ),
                      if (prefsState.recurringTransactionRemindersEnabled)
                        SettingsNavigationTile(
                          icon: Icons.calendar_today,
                          title: L10n.of(context).settingsRemindMeBeforeDueDate,
                          subtitle: BackgroundTaskConstants.offsetLabel(
                            prefsState.reminderOffsetMinutes,
                          ),
                          onTap: () => _showReminderOffsetDialog(context),
                        ),
                    ],
                  ),

                  // SUBSCRIPTION & PROMOTIONAL SECTION
                  SettingsSection(
                    title: L10n.of(context).settingsOtherNotifications,
                    tiles: [
                      SettingsSwitchTile(
                        icon: Icons.star_outline,
                        title: L10n.of(
                          context,
                        ).settingsSubscriptionExpiryAlerts,
                        subtitle: L10n.of(
                          context,
                        ).settingsGetNotifiedBeforeYourPremium,
                        value: prefsState.subscriptionExpiryAlertsEnabled,
                        onChanged: (value) async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(notificationPreferencesProvider.notifier)
                              .setSubscriptionExpiryAlertsEnabled(value);
                        },
                      ),
                      SettingsSwitchTile(
                        icon: Icons.campaign_outlined,
                        title: L10n.of(
                          context,
                        ).settingsPromotionalNotifications,
                        subtitle: L10n.of(
                          context,
                        ).settingsReceiveOffersAndFeatureUpdates,
                        value: prefsState.promotionalNotificationsEnabled,
                        onChanged: (value) async {
                          HapticFeedback.lightImpact();
                          await ref
                              .read(notificationPreferencesProvider.notifier)
                              .setPromotionalNotificationsEnabled(value);
                        },
                      ),
                    ],
                  ),

                  // DEBUG SECTION
                  _NotificationDebugSection(),

                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
      ),
    );
  }

  /// Enable/disable daily reminders. When turning on, first show an in-app
  /// priming sheet explaining why, and only then request the OS permissions —
  /// so the system dialogs never appear unprompted.
  Future<void> _setDailyReminders(bool value) async {
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    if (value) {
      final proceed = await showPermissionPrimingSheet(
        context,
        icon: Icons.notifications_active_outlined,
        title: L10n.of(context).settingsTurnOnDailyReminders,
        message: L10n.of(context).notifDailyPrimerBody,
        points: [
          PrimingPoint(
            Icons.notifications_outlined,
            L10n.of(context).notifPrimerShow,
          ),
          PrimingPoint(Icons.alarm_outlined, L10n.of(context).notifPrimerTime),
          PrimingPoint(Icons.lock_outline, L10n.of(context).notifPrimerOff),
        ],
        allowLabel: L10n.of(context).notifPrimerAllow,
      );
      if (!proceed) return; // Declined — leave the toggle off.

      // The user opted in, so now ask Android. Only to show notifications:
      // the reminder comes from the server, so no alarm permission is needed.
      await NotificationService().requestPermission();

      if (!mounted) return;
    }

    await notifier.setDailyReminderEnabled(value);
  }

  Future<void> _showReminderTimePicker(BuildContext context) async {
    final prefsState = ref.read(notificationPreferencesProvider);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: prefsState.dailyReminderTime,
      builder: (context, child) => AppTimeFormatter.withClock(context, child!),
    );

    if (selectedTime != null) {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .setDailyReminderTime(selectedTime);
    }
  }

  Future<void> _showThresholdDialog(BuildContext context) async {
    final prefsState = ref.read(notificationPreferencesProvider);
    final controller = TextEditingController(
      text: prefsState.largeTransactionThreshold.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).settingsLargeTransactionThreshold),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: L10n.of(context).settingsEnterAmount,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context).actionCancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: Text(L10n.of(context).actionSave),
          ),
        ],
      ),
    );

    if (result != null) {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .setLargeTransactionThreshold(result);
    }
  }

  Future<void> _showReminderOffsetDialog(BuildContext context) async {
    final prefsState = ref.read(notificationPreferencesProvider);

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).settingsRemindMeBeforeDueDate),
        content: RadioGroup<int>(
          groupValue: prefsState.reminderOffsetMinutes,
          onChanged: (value) => Navigator.pop(context, value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: BackgroundTaskConstants.offsetOptions.map((minutes) {
              return ListTile(
                title: Text(BackgroundTaskConstants.offsetLabel(minutes)),
                leading: Radio<int>(value: minutes),
                onTap: () => Navigator.pop(context, minutes),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (result != null) {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .setReminderOffset(result);
    }
  }
}

class _ReminderTimeTile extends StatelessWidget {
  const _ReminderTimeTile({required this.reminderTime, required this.onTap});

  final TimeOfDay reminderTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SettingsNavigationTile(
      icon: Icons.access_time,
      title: L10n.of(context).settingsReminderTime,
      subtitle: _formatTimeOfDay(reminderTime),
      onTap: onTap,
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

/// Whether notifications can reach this phone, and a way to prove it.
///
/// This used to report exact-alarm permission and a count of alarms the phone
/// had scheduled, which said nothing useful once reminders started coming
/// from the server. Now it says whether notifications are allowed, and sends a
/// real one through the server, the same road every reminder takes.
class _NotificationDebugSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NotificationDebugSection> createState() =>
      _NotificationDebugSectionState();
}

class _NotificationDebugSectionState
    extends ConsumerState<_NotificationDebugSection> {
  bool? _allowed;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final allowed = await NotificationService().hasPermission();
    if (mounted) setState(() => _allowed = allowed);
  }

  Future<void> _allow() async {
    HapticFeedback.lightImpact();
    await NotificationService().requestPermission();
    await _checkStatus();
  }

  Future<void> _sendTest() async {
    HapticFeedback.lightImpact();
    final l10n = L10n.of(context);
    setState(() => _sending = true);
    try {
      final result = await ref
          .read(notificationHistoryProvider.notifier)
          .sendTest();
      if (!mounted) return;
      showSunriseSnack(
        context,
        result.delivered
            ? l10n.notifTestSent
            : l10n.notifTestFailed(result.error ?? '?'),
        tone: result.delivered ? SnackTone.success : SnackTone.error,
      );
    } catch (e) {
      if (mounted) {
        showSunriseSnack(
          context,
          l10n.notifTestFailed(l10n.notifTestOffline),
          tone: SnackTone.error,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final allowed = _allowed;
    return SettingsSection(
      title: l10n.notifCheckTitle,
      tiles: [
        SettingsNavigationTile(
          icon: allowed == false
              ? Icons.notifications_off_outlined
              : Icons.notifications_active_outlined,
          iconColor: allowed == false ? AppColors.error : AppColors.success,
          title: allowed == false ? l10n.notifBlocked : l10n.notifAllowed,
          subtitle: allowed == false
              ? l10n.notifBlockedHint
              : l10n.notifAllowedHint,
          onTap: allowed == false ? _allow : _checkStatus,
        ),
        SettingsNavigationTile(
          key: const Key('send_test_notification'),
          icon: Icons.send_outlined,
          title: l10n.notifSendTest,
          subtitle: _sending ? l10n.notifSending : l10n.notifSendTestHint,
          onTap: () {
            if (!_sending) _sendTest();
          },
        ),
      ],
    );
  }
}
