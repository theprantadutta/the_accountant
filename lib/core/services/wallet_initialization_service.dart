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
          {
            'name': 'Personal Wallet',
            'currency': 'USD',
            'balance': 0.0,
            'iconName': 'account_balance_wallet',
            'color': '#6366F1',
            'isDefault': true, // First wallet is default
            'orderIndex': 0,
          },
          {
            'name': 'Savings Account',
            'currency': 'USD',
            'balance': 0.0,
            'iconName': 'savings',
            'color': '#10B981',
            'isDefault': false,
            'orderIndex': 1,
          },
          {
            'name': 'Business Account',
            'currency': 'USD',
            'balance': 0.0,
            'iconName': 'business_center',
            'color': '#F59E0B',
            'isDefault': false,
            'orderIndex': 2,
          },
        ];

        final now = DateTime.now();
        for (final walletData in defaultWallets) {
          final wallet = WalletsCompanion(
            id: Value(const Uuid().v4()),
            name: Value(walletData['name'] as String),
            currency: Value(walletData['currency'] as String),
            balance: Value(walletData['balance'] as double),
            iconName: Value(walletData['iconName'] as String),
            color: Value(walletData['color'] as String),
            isDefault: Value(walletData['isDefault'] as bool),
            orderIndex: Value(walletData['orderIndex'] as int),
            createdAt: Value(now),
            updatedAt: Value(now),
          );

          await _db.addWallet(wallet);
        }
      }
    } catch (e) {
      // Handle error silently - proper logging should be used in production
    }
  }
}
