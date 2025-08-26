import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/settings/screens/backup_screen.dart';
import 'package:the_accountant/core/providers/daily_reminder_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/settings/screens/theme_selection_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final dailyReminderState = ref.watch(dailyReminderProvider);
    final premiumState = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Account'),
            subtitle: Text('Manage your account settings'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Daily Reminders'),
            subtitle: const Text('Get reminded to track your expenses daily'),
            value: dailyReminderState.isEnabled,
            onChanged: (value) async {
              if (value) {
                await ref.read(dailyReminderProvider.notifier).enableReminders();
              } else {
                await ref.read(dailyReminderProvider.notifier).disableReminders();
              }
            },
          ),
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(
              '${dailyReminderState.reminderTime.hour}:${dailyReminderState.reminderTime.minute.toString().padLeft(2, '0')}',
            ),
            enabled: dailyReminderState.isEnabled,
            onTap: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: dailyReminderState.reminderTime,
              );
              
              if (selectedTime != null) {
                await ref.read(dailyReminderProvider.notifier).setReminderTime(selectedTime);
              }
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Appearance'),
            subtitle: Text('Customize the app appearance'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Select app theme'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSelectionScreen(),
                ),
              );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Security'),
            subtitle: Text('Manage security settings'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Backup & Restore'),
            subtitle: const Text('Backup your data to Google Drive'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Premium Features'),
            subtitle: Text(
              premiumState.features.isUnlocked 
                  ? 'Manage your premium features' 
                  : 'Unlock exclusive features',
            ),
            trailing: premiumState.features.isUnlocked
                ? const Icon(Icons.workspace_premium, color: Colors.amber)
                : const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/premium');
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('About'),
            subtitle: Text('App version and information'),
          ),
        ],
      ),
    );
  }
}