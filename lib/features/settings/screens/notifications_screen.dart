import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/services/daily_reminder_scheduler.dart';
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
        title: const Text('Notifications'),
      ),
      body: prefsState.isLoading
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
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 24),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Configure when and how The Accountant should remind you to track your expenses.',
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
                  title: 'DAILY REMINDERS',
                  tiles: [
                    SettingsSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: 'Daily Reminders',
                      subtitle: 'Get reminded to track your expenses',
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
                  title: 'BUDGET ALERTS',
                  tiles: [
                    SettingsSwitchTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Budget Alerts',
                      subtitle: 'Notify when approaching budget limit',
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
                        title: 'Warning Threshold',
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
                  title: 'TRANSACTION ALERTS',
                  tiles: [
                    SettingsSwitchTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Large Transaction Alerts',
                      subtitle: 'Notify for transactions above threshold',
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
                        title: 'Large Transaction Threshold',
                        subtitle:
                            '\$${prefsState.largeTransactionThreshold.toStringAsFixed(0)}',
                        onTap: () => _showThresholdDialog(context),
                      ),
                    SettingsSwitchTile(
                      icon: Icons.repeat,
                      title: 'Recurring Transaction Reminders',
                      subtitle: 'Remind about upcoming recurring payments',
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
                        title: 'Remind Me Before Due Date',
                        subtitle: BackgroundTaskConstants.offsetLabel(
                          prefsState.reminderOffsetMinutes,
                        ),
                        onTap: () => _showReminderOffsetDialog(context),
                      ),
                  ],
                ),

                // SUBSCRIPTION & PROMOTIONAL SECTION
                SettingsSection(
                  title: 'OTHER NOTIFICATIONS',
                  tiles: [
                    SettingsSwitchTile(
                      icon: Icons.star_outline,
                      title: 'Subscription Expiry Alerts',
                      subtitle: 'Get notified before your premium expires',
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
                      title: 'Promotional Notifications',
                      subtitle: 'Receive offers and feature updates',
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
        title: 'Turn on daily reminders?',
        message:
            'The Accountant will send a gentle daily nudge to log your '
            'expenses. To deliver it on time we need permission to show '
            'notifications and schedule alarms.',
        points: const [
          PrimingPoint(
            Icons.notifications_outlined,
            'Show reminder notifications',
          ),
          PrimingPoint(
            Icons.alarm_outlined,
            'Deliver them at your chosen time',
          ),
          PrimingPoint(Icons.lock_outline, 'You can turn this off anytime'),
        ],
        allowLabel: 'Allow',
      );
      if (!proceed) return; // Declined — leave the toggle off.

      // The user opted in, so now request the actual OS permissions.
      final scheduler = DailyReminderScheduler();
      await scheduler.requestNotificationPermission();
      await scheduler.requestExactAlarmPermission();

      if (!mounted) return;
    }

    await notifier.setDailyReminderEnabled(value);
  }

  Future<void> _showReminderTimePicker(BuildContext context) async {
    final prefsState = ref.read(notificationPreferencesProvider);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: prefsState.dailyReminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryAccent,
              surface: AppColors.primarySurface,
            ),
          ),
          child: child!,
        );
      },
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
        backgroundColor: AppColors.primarySurface,
        title: const Text('Large Transaction Threshold'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: '\$ ',
            hintText: 'Enter amount',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
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
        backgroundColor: AppColors.primarySurface,
        title: const Text('Remind Me Before Due Date'),
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
      title: 'Reminder Time',
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

/// Debug section to test notifications
class _NotificationDebugSection extends StatefulWidget {
  @override
  State<_NotificationDebugSection> createState() =>
      _NotificationDebugSectionState();
}

class _NotificationDebugSectionState extends State<_NotificationDebugSection> {
  bool _hasExactAlarmPermission = false;
  bool _hasPendingReminder = false;
  bool _isLoading = true;
  int _pendingCount = 0;
  String _deviceTimezone = 'Loading...';
  String _scheduledTimezone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    final scheduler = DailyReminderScheduler();
    final hasPermission = await scheduler.hasExactAlarmPermission();
    final hasPending = await scheduler.isDailyReminderPending();
    final pending = await scheduler.getPendingNotifications();
    final scheduledTz = await scheduler.getScheduledTimezone();

    // Get device timezone
    String deviceTz = 'Unknown';
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      deviceTz = tzInfo.identifier;
    } catch (_) {}

    if (mounted) {
      setState(() {
        _hasExactAlarmPermission = hasPermission;
        _hasPendingReminder = hasPending;
        _pendingCount = pending.length;
        _deviceTimezone = deviceTz;
        _scheduledTimezone = scheduledTz;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendTestNotification() async {
    HapticFeedback.lightImpact();
    final scheduler = DailyReminderScheduler();
    await scheduler.showTestNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification sent! Check your notifications.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.lg),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            'DEBUG',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primarySurface.withValues(alpha: 0.5),
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          // Transparent Material so the tiles' ink is visible over the colour.
          child: Material(
            type: MaterialType.transparency,
            borderRadius: AppSpacing.borderRadiusLg,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Permission Status
                ListTile(
                  leading: Icon(
                    _hasExactAlarmPermission
                        ? Icons.check_circle
                        : Icons.error_outline,
                    color: _hasExactAlarmPermission
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  title: const Text(
                    'Exact Alarm Permission',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    _isLoading
                        ? 'Checking...'
                        : _hasExactAlarmPermission
                        ? 'Granted'
                        : 'Not granted - notifications may not work',
                    style: TextStyle(
                      color: _hasExactAlarmPermission
                          ? AppColors.textSecondary
                          : AppColors.error,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // Device Timezone
                ListTile(
                  leading: const Icon(Icons.public, color: AppColors.info),
                  title: const Text(
                    'Device Timezone',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    _isLoading ? 'Checking...' : _deviceTimezone,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // Pending Notifications
                ListTile(
                  leading: Icon(
                    _hasPendingReminder ? Icons.alarm_on : Icons.alarm_off,
                    color: _hasPendingReminder
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  title: const Text(
                    'Scheduled Notifications',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    _isLoading
                        ? 'Checking...'
                        : '$_pendingCount pending (daily: ${_hasPendingReminder ? "Yes" : "No"}, tz: $_scheduledTimezone)',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _checkStatus,
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // Test Notification Button
                ListTile(
                  leading: const Icon(
                    Icons.notifications_active,
                    color: AppColors.info,
                  ),
                  title: const Text(
                    'Send Test Notification',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: const Text(
                    'Tap to verify notifications work',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: ElevatedButton(
                    onPressed: _sendTestNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Test'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
