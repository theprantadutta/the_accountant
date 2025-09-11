class AppConstants {
  static const String appName = 'The Accountant';
  static const String appVersion = '1.0.0';

  // Default currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'SEK',
    'NZD',
    'MXN',
    'SGD',
    'HKD',
    'NOK',
    'KRW',
    'TRY',
    'RUB',
    'INR',
    'BRL',
    'ZAR',
  ];

  // Transaction types
  static const String transactionTypeExpense = 'expense';
  static const String transactionTypeIncome = 'income';

  // Budget periods
  static const String budgetPeriodWeekly = 'weekly';
  static const String budgetPeriodMonthly = 'monthly';

  // Category types
  static const String categoryTypeExpense = 'expense';
  static const String categoryTypeIncome = 'income';

  // Default categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Food & Dining',
      'colorCode': '#FF6B6B',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Transportation',
      'colorCode': '#4ECDC4',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Shopping',
      'colorCode': '#45B7D1',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Entertainment',
      'colorCode': '#96CEB4',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Utilities',
      'colorCode': '#FFEAA7',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Healthcare',
      'colorCode': '#DDA0DD',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Travel',
      'colorCode': '#98D8C8',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Education',
      'colorCode': '#F7DC6F',
      'type': categoryTypeExpense,
      'isDefault': true,
    },
    {
      'name': 'Salary',
      'colorCode': '#58D68D',
      'type': categoryTypeIncome,
      'isDefault': true,
    },
    {
      'name': 'Investment',
      'colorCode': '#3498DB',
      'type': categoryTypeIncome,
      'isDefault': true,
    },
    {
      'name': 'Gift',
      'colorCode': '#BB8FCE',
      'type': categoryTypeIncome,
      'isDefault': true,
    },
    {
      'name': 'Other',
      'colorCode': '#A6ACAF',
      'type': categoryTypeIncome,
      'isDefault': true,
    },
  ];
}
