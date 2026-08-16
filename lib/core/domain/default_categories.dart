/// The catalogue of categories the app creates for every user, and the stable
/// slugs that give them a cross-device identity.
///
/// ## Why a slug rather than a fixed id
///
/// Category ids are random UUIDs, and they have to be: the backend's category
/// primary key is global, so if every install used the same hard-coded id for
/// "Food & Dining" the second user to sync would hit a primary-key collision —
/// which surfaces at flush time and takes down their entire push batch.
///
/// A slug solves the identity problem without touching the key. `defaultKey`
/// says *which* built-in category a row is, independently of the id it happens
/// to carry on this device. That is what lets:
///
/// * a second device recognise "I already have this one" instead of uploading a
///   duplicate set of defaults;
/// * the backend enforce one built-in per slug per user
///   (`ix_categories_user_id_default_key`);
/// * the client merge duplicates that already exist, safely — two rows sharing a
///   slug are *provably* the same built-in category, whereas two rows that merely
///   share a name might be a default and a user-created one.
///
/// A user-created category always has a null slug and is never merged.
///
/// ## Stability contract
///
/// **Slugs are permanent.** Renaming one orphans every existing row that carries
/// it and re-creates the category as a duplicate on the next sync. `name` /
/// `colorCode` / `iconName` are presentation and may change freely; `key` may
/// not. A golden test pins the full slug list against accidental edits.
library;

/// One built-in category.
class DefaultCategorySpec {
  /// Permanent cross-device identity. Never change this for an existing entry.
  final String key;

  final String name;
  final String colorCode;
  final String iconName;
  final bool isIncome;
  final int orderIndex;

  /// System categories are created for internal bookkeeping (transfers, balance
  /// corrections) rather than for the user to pick from a list.
  final bool isSystem;

  const DefaultCategorySpec({
    required this.key,
    required this.name,
    required this.colorCode,
    required this.iconName,
    required this.isIncome,
    required this.orderIndex,
    this.isSystem = false,
  });
}

/// Well-known slugs the code refers to directly.
class SystemCategoryKeys {
  const SystemCategoryKeys._();

  /// The category both legs of a wallet-to-wallet transfer are filed under.
  static const String transfer = 'transfer';

  /// The category used when a wallet balance is corrected manually.
  static const String balanceCorrection = 'balance_correction';

  static const List<String> all = [transfer, balanceCorrection];
}

class DefaultCategoryCatalog {
  const DefaultCategoryCatalog._();

  /// Expense categories, in display order.
  static const List<DefaultCategorySpec> expenses = [
    DefaultCategorySpec(
      key: 'food_dining',
      name: 'Food & Dining',
      colorCode: '#FF6B6B',
      iconName: 'restaurant',
      isIncome: false,
      orderIndex: 0,
    ),
    DefaultCategorySpec(
      key: 'transportation',
      name: 'Transportation',
      colorCode: '#4ECDC4',
      iconName: 'directions_car',
      isIncome: false,
      orderIndex: 1,
    ),
    DefaultCategorySpec(
      key: 'shopping',
      name: 'Shopping',
      colorCode: '#45B7D1',
      iconName: 'shopping_bag',
      isIncome: false,
      orderIndex: 2,
    ),
    DefaultCategorySpec(
      key: 'entertainment',
      name: 'Entertainment',
      colorCode: '#96CEB4',
      iconName: 'movie',
      isIncome: false,
      orderIndex: 3,
    ),
    DefaultCategorySpec(
      key: 'bills_utilities',
      name: 'Bills & Utilities',
      colorCode: '#FFA07A',
      iconName: 'receipt',
      isIncome: false,
      orderIndex: 4,
    ),
    DefaultCategorySpec(
      key: 'healthcare',
      name: 'Healthcare',
      colorCode: '#F7DC6F',
      iconName: 'local_hospital',
      isIncome: false,
      orderIndex: 5,
    ),
    DefaultCategorySpec(
      key: 'education',
      name: 'Education',
      colorCode: '#58D68D',
      iconName: 'school',
      isIncome: false,
      orderIndex: 6,
    ),
    DefaultCategorySpec(
      key: 'travel',
      name: 'Travel',
      colorCode: '#85C1E9',
      iconName: 'flight',
      isIncome: false,
      orderIndex: 7,
    ),
    DefaultCategorySpec(
      key: 'groceries',
      name: 'Groceries',
      colorCode: '#82E0AA',
      iconName: 'local_grocery_store',
      isIncome: false,
      orderIndex: 8,
    ),
    DefaultCategorySpec(
      key: 'rent',
      name: 'Rent',
      colorCode: '#F8C471',
      iconName: 'home',
      isIncome: false,
      orderIndex: 9,
    ),
    DefaultCategorySpec(
      key: 'insurance',
      name: 'Insurance',
      colorCode: '#BB8FCE',
      iconName: 'security',
      isIncome: false,
      orderIndex: 10,
    ),
    DefaultCategorySpec(
      key: 'personal_care',
      name: 'Personal Care',
      colorCode: '#F1948A',
      iconName: 'spa',
      isIncome: false,
      orderIndex: 11,
    ),
    DefaultCategorySpec(
      key: 'subscriptions',
      name: 'Subscriptions',
      colorCode: '#7FB3D3',
      iconName: 'subscriptions',
      isIncome: false,
      orderIndex: 12,
    ),
    DefaultCategorySpec(
      key: 'gifts_donations',
      name: 'Gifts & Donations',
      colorCode: '#D7BDE2',
      iconName: 'card_giftcard',
      isIncome: false,
      orderIndex: 13,
    ),
    DefaultCategorySpec(
      key: 'loan_expense',
      name: 'Loan',
      colorCode: '#E57373',
      iconName: 'account_balance',
      isIncome: false,
      orderIndex: 14,
    ),
    DefaultCategorySpec(
      key: 'loan_payment',
      name: 'Loan Payment',
      colorCode: '#EF9A9A',
      iconName: 'payments',
      isIncome: false,
      orderIndex: 15,
    ),
    DefaultCategorySpec(
      key: 'other_expenses',
      name: 'Other Expenses',
      colorCode: '#AED6F1',
      iconName: 'more_horiz',
      isIncome: false,
      orderIndex: 16,
    ),
  ];

  /// Income categories, in display order.
  static const List<DefaultCategorySpec> incomes = [
    DefaultCategorySpec(
      key: 'salary',
      name: 'Salary',
      colorCode: '#FFEAA7',
      iconName: 'work',
      isIncome: true,
      orderIndex: 0,
    ),
    DefaultCategorySpec(
      key: 'freelance',
      name: 'Freelance',
      colorCode: '#DDA0DD',
      iconName: 'laptop',
      isIncome: true,
      orderIndex: 1,
    ),
    DefaultCategorySpec(
      key: 'business',
      name: 'Business',
      colorCode: '#98D8C8',
      iconName: 'business',
      isIncome: true,
      orderIndex: 2,
    ),
    DefaultCategorySpec(
      key: 'investment',
      name: 'Investment',
      colorCode: '#A9DFBF',
      iconName: 'trending_up',
      isIncome: true,
      orderIndex: 3,
    ),
    DefaultCategorySpec(
      key: 'rental_income',
      name: 'Rental Income',
      colorCode: '#F9E79F',
      iconName: 'apartment',
      isIncome: true,
      orderIndex: 4,
    ),
    DefaultCategorySpec(
      key: 'bonus',
      name: 'Bonus',
      colorCode: '#D5A6BD',
      iconName: 'star',
      isIncome: true,
      orderIndex: 5,
    ),
    DefaultCategorySpec(
      key: 'gift_received',
      name: 'Gift Received',
      colorCode: '#AED6F1',
      iconName: 'redeem',
      isIncome: true,
      orderIndex: 6,
    ),
    DefaultCategorySpec(
      key: 'refund',
      name: 'Refund',
      colorCode: '#A3E4D7',
      iconName: 'replay',
      isIncome: true,
      orderIndex: 7,
    ),
    DefaultCategorySpec(
      key: 'loan_income',
      name: 'Loan',
      colorCode: '#81C784',
      iconName: 'account_balance',
      isIncome: true,
      orderIndex: 8,
    ),
    DefaultCategorySpec(
      key: 'loan_received',
      name: 'Loan Received',
      colorCode: '#A5D6A7',
      iconName: 'payments',
      isIncome: true,
      orderIndex: 9,
    ),
    DefaultCategorySpec(
      key: 'other_income',
      name: 'Other Income',
      colorCode: '#D2B4DE',
      iconName: 'add_circle',
      isIncome: true,
      orderIndex: 10,
    ),
  ];

  /// Internal bookkeeping categories. They follow exactly the same cross-device
  /// identity rules as the user-facing defaults — they are ordinary per-user
  /// categories as far as the backend is concerned.
  static const List<DefaultCategorySpec> system = [
    DefaultCategorySpec(
      key: SystemCategoryKeys.transfer,
      name: 'Transfer',
      colorCode: '#9E9E9E',
      iconName: 'swap_horiz',
      isIncome: false,
      orderIndex: -1,
      isSystem: true,
    ),
    DefaultCategorySpec(
      key: SystemCategoryKeys.balanceCorrection,
      name: 'Balance Correction',
      colorCode: '#607D8B',
      iconName: 'tune',
      isIncome: false,
      orderIndex: -2,
      isSystem: true,
    ),
  ];

  /// Every built-in category.
  static List<DefaultCategorySpec> get all => [
    ...expenses,
    ...incomes,
    ...system,
  ];

  static Map<String, DefaultCategorySpec> get byKey => {
    for (final spec in all) spec.key: spec,
  };

  /// Resolve the slug for a legacy default category that predates slugs, by its
  /// stored name and direction.
  ///
  /// Used once by the schema-13 migration to give existing rows an identity. Two
  /// built-ins are both called "Loan" — one income, one expense — so the
  /// direction is part of the match.
  static String? keyForLegacyDefault({
    required String name,
    required bool isIncome,
  }) {
    for (final spec in all) {
      if (spec.name == name && spec.isIncome == isIncome) return spec.key;
    }
    return null;
  }
}
