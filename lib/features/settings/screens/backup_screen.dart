import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/providers/backup_provider.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    final backupState = ref.watch(backupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Google Drive Backup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Automatically backup your data to Google Drive. '
              'This includes all transactions, budgets, categories, and settings.',
            ),
            const SizedBox(height: 24),
            // Encrypted backup toggle
            Card(
              child: SwitchListTile(
                title: const Text('Encrypted Backup'),
                subtitle: const Text(
                  'Encrypt your backup data for additional security. '
                  'Encrypted backups can only be restored on this device.',
                ),
                value: backupState.useEncryptedBackup,
                onChanged: (value) {
                  ref.read(backupProvider.notifier).toggleEncryptedBackup(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Create Backup'),
                subtitle: backupState.isBackingUp
                    ? const Text('Creating backup...')
                    : const Text('Backup your data to Google Drive'),
                trailing: backupState.isBackingUp
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.backup),
                onTap: backupState.isBackingUp
                    ? null
                    : () async {
                        await ref
                            .read(backupProvider.notifier)
                            .createBackup(encrypted: backupState.useEncryptedBackup);
                        if (!context.mounted) return;
                        if (backupState.errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                backupState.useEncryptedBackup
                                    ? 'Encrypted backup created successfully'
                                    : 'Backup created successfully',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Backup failed: ${backupState.errorMessage}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Restore from Backup'),
                subtitle: backupState.isRestoring
                    ? const Text('Restoring from backup...')
                    : backupState.isBackupAvailable
                        ? const Text('Restore your data from Google Drive')
                        : const Text('No backups available'),
                trailing: backupState.isRestoring
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.restore),
                onTap: backupState.isRestoring || !backupState.isBackupAvailable
                    ? null
                    : () async {
                        // Show confirmation dialog
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Restore Backup'),
                            content: Text(
                              'This will replace all your current data with the backup. '
                              'This action cannot be undone. Are you sure?\n\n'
                              'Note: Make sure to select the correct backup type '
                              '(encrypted or unencrypted).',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Restore'),
                              ),
                            ],
                          ),
                        );

                        if (!context.mounted) return;
                        if (confirmed == true) {
                          // Show a dialog to select which backup to restore
                          _showBackupSelectionDialog(context);
                        }
                      },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Backups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (backupState.availableBackups.isEmpty)
              const Center(
                child: Text('No backups available'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: backupState.availableBackups.length,
                  itemBuilder: (context, index) {
                    final backup = backupState.availableBackups[index];
                    final isEncrypted = (backup['name'] as String)
                        .contains('encrypted');
                    return Card(
                      child: ListTile(
                        title: Text(backup['name'] as String),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (backup['createdTime'] as DateTime?)?.toString() ??
                                  'Unknown date',
                            ),
                            Text(
                              isEncrypted ? 'Encrypted' : 'Unencrypted',
                              style: TextStyle(
                                color: isEncrypted ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.download),
                        onTap: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Restore Backup'),
                              content: Text(
                                'Restore from backup ${backup['name']}? '
                                'This will replace all your current data.\n\n'
                                'Backup type: ${isEncrypted ? 'Encrypted' : 'Unencrypted'}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (!context.mounted) return;
                                    // Restore from this backup
                                    ref.read(backupProvider.notifier).restoreFromBackup(
                                          backup['id'] as String,
                                          encrypted: isEncrypted,
                                        );
                                  },
                                  child: const Text('Restore'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Show a dialog to select which backup to restore
  void _showBackupSelectionDialog(BuildContext context) {
    final backupState = ref.read(backupProvider);
    
    if (backupState.availableBackups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No backups available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Backup'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: backupState.availableBackups.length,
            itemBuilder: (context, index) {
              final backup = backupState.availableBackups[index];
              final isEncrypted = (backup['name'] as String).contains('encrypted');
              return ListTile(
                title: Text(backup['name'] as String),
                subtitle: Text(
                  '${(backup['createdTime'] as DateTime?)?.toString() ?? 'Unknown date'}\n'
                  'Type: ${isEncrypted ? 'Encrypted' : 'Unencrypted'}',
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (!context.mounted) return;
                  // Restore from this backup
                  ref.read(backupProvider.notifier).restoreFromBackup(
                        backup['id'] as String,
                        encrypted: isEncrypted,
                      );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}