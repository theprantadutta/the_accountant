import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/providers/daily_reminder_provider.dart';
import 'package:the_accountant/features/settings/providers/settings_provider.dart';
import 'package:the_accountant/features/settings/widgets/settings_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyReminderState = ref.watch(dailyReminderProvider);
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // INFO CARD
          Container(
            margin: EdgeInsets.only(top: AppSpacing.lg),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
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

          // DAILY REMINDERS SECTION
          SettingsSection(
            title: 'DAILY REMINDERS',
            tiles: [
              SettingsSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Daily Reminders',
                subtitle: 'Get reminded to track your expenses',
                value: dailyReminderState.isEnabled,
                onChanged: (value) async {
                  HapticFeedback.lightImpact();
                  if (value) {
                    await ref.read(dailyReminderProvider.notifier).enableReminders();
                  } else {
                    await ref.read(dailyReminderProvider.notifier).disableReminders();
                  }
                },
              ),
              if (dailyReminderState.isEnabled)
                _ReminderTimeTile(
                  reminderTime: dailyReminderState.reminderTime,
                  onTap: () => _showReminderTimePicker(context, ref),
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
                value: settingsState.budgetNotificationsEnabled,
                onChanged: (value) async {
                  HapticFeedback.lightImpact();
                  await ref.read(settingsProvider.notifier).toggleBudgetNotifications(value);
                },
              ),
              if (settingsState.budgetNotificationsEnabled)
                SettingsSliderTile(
                  icon: Icons.warning_amber_outlined,
                  iconColor: AppColors.warning,
                  title: 'Warning Threshold',
                  subtitle: '${settingsState.budgetWarningThreshold.toInt()}% of budget',
                  value: settingsState.budgetWarningThreshold,
                  min: 50,
                  max: 95,
                  divisions: 9,
                  onChanged: (value) async {
                    await ref.read(settingsProvider.notifier).setBudgetWarningThreshold(value);
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
                value: false, // TODO: Implement this feature
                onChanged: (value) async {
                  // TODO: Implement
                  HapticFeedback.lightImpact();
                },
              ),
              SettingsSwitchTile(
                icon: Icons.repeat,
                title: 'Recurring Transaction Reminders',
                subtitle: 'Remind about upcoming recurring payments',
                value: false, // TODO: Implement this feature
                onChanged: (value) async {
                  // TODO: Implement
                  HapticFeedback.lightImpact();
                },
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _showReminderTimePicker(BuildContext context, WidgetRef ref) async {
    final dailyReminderState = ref.read(dailyReminderProvider);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: dailyReminderState.reminderTime,
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
      await ref.read(dailyReminderProvider.notifier).setReminderTime(selectedTime);
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
