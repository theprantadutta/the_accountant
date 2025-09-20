import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class WalletInitializationService {
  final AppDatabase _db;

  WalletInitializationService(this._db);

  Future<void> initializeDefaultWallets() async {
    try {
      // Check if wallets already exist
      final existingWallets = await _db.getAllWallets();

      // If no wallets exist, create default ones
      if (existingWallets.isEmpty) {
        final defaultWallets = [
          {'name': 'Personal Wallet', 'currency': 'USD', 'balance': 0.0},
          {'name': 'Savings Account', 'currency': 'USD', 'balance': 0.0},
          {'name': 'Business Account', 'currency': 'USD', 'balance': 0.0},
        ];

        for (final walletData in defaultWallets) {
          final wallet = WalletsCompanion(
            id: Value(const Uuid().v4()),
            name: Value(walletData['name'] as String),
            currency: Value(walletData['currency'] as String),
            balance: Value(walletData['balance'] as double),
          );

          await _db.addWallet(wallet);
        }
      }
    } catch (e) {
      // Handle error silently or log it
      // TODO: Replace with proper logging in production
      // ignore: avoid_print
      print('Error initializing default wallets: $e');
    }
  }
}
