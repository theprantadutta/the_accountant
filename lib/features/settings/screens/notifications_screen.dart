import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/features/settings/providers/notification_preferences_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';

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
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: prefsState.isLoading
          ? const Center(child: CircularProgressIndicator())
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
                    border:
                        Border.all(color: AppColors.info.withValues(alpha: 0.3)),
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
                      onChanged: (value) async {
                        HapticFeedback.lightImpact();
                        await ref
                            .read(notificationPreferencesProvider.notifier)
                            .setDailyReminderEnabled(value);
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
                        title: 'Days Before Reminder',
                        subtitle:
                            '${prefsState.recurringReminderDaysBefore} day(s) before',
                        onTap: () => _showDaysBeforeDialog(context),
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

                SizedBox(height: AppSpacing.xxl),
              ],
            ),
    );
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

  Future<void> _showDaysBeforeDialog(BuildContext context) async {
    final prefsState = ref.read(notificationPreferencesProvider);
    final List<int> options = [1, 2, 3, 5, 7, 14];

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primarySurface,
        title: const Text('Days Before Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((days) {
            return ListTile(
              title: Text('$days day${days == 1 ? '' : 's'} before'),
              leading: Radio<int>(
                value: days,
                groupValue: prefsState.recurringReminderDaysBefore,
                onChanged: (value) => Navigator.pop(context, value),
              ),
              onTap: () => Navigator.pop(context, days),
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      await ref
          .read(notificationPreferencesProvider.notifier)
          .setRecurringReminderDaysBefore(result);
    }
  }
}

class _ReminderTimeTile extends StatelessWidget {
  const _ReminderTimeTile({
    required this.reminderTime,
    required this.onTap,
  });

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
