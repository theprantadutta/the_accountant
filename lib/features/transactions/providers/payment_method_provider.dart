import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/datasources/local/database_provider.dart';
import 'package:the_accountant/data/datasources/local/app_database.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/exceptions/premium_limit_exception.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String type; // 'card', 'bank', 'cash', 'digital_wallet'
  final String? lastFourDigits;
  final String? institution;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.lastFourDigits,
    this.institution,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
}

class PaymentMethodState {
  final List<PaymentMethod> paymentMethods;
  final bool isLoading;
  final String? errorMessage;

  PaymentMethodState({
    required this.paymentMethods,
    required this.isLoading,
    this.errorMessage,
  });

  PaymentMethodState copyWith({
    List<PaymentMethod>? paymentMethods,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PaymentMethodState(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PaymentMethodNotifier extends StateNotifier<PaymentMethodState> {
  final AppDatabase _db;
  final Ref _ref;

  PaymentMethodNotifier(this._db, this._ref)
    : super(PaymentMethodState(paymentMethods: [], isLoading: false)) {
    loadPaymentMethods();
  }

  Future<void> loadPaymentMethods({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);
    try {
      final dbPaymentMethods = await _db.getAllPaymentMethods();
      final paymentMethods = dbPaymentMethods
          .map(
            (p) => PaymentMethod(
              id: p.id,
              name: p.name,
              type: p.type,
              lastFourDigits: p.lastFourDigits,
              institution: p.institution,
              isDefault: p.isDefault,
              createdAt: p.createdAt,
              updatedAt: p.updatedAt,
            ),
          )
          .toList();

      state = state.copyWith(paymentMethods: paymentMethods, isLoading: false);
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load payment methods',
        );
      }
    }
  }

  Future<void> addPaymentMethod({
    required String name,
    required String type,
    String? lastFourDigits,
    String? institution,
    bool isDefault = false,
  }) async {
    // Enforce the free-tier limit; Premium removes it (part of "Unlimited
    // Everything"). Thrown before any state change so callers can surface the
    // upgrade dialog.
    final premiumState = _ref.read(premiumProvider);
    if (!premiumState.isPremium) {
      final currentCount = state.paymentMethods.length;
      if (currentCount >= FreeTierLimits.maxPaymentMethods) {
        throw PremiumLimitException(
          entityType: 'payment_method',
          currentCount: currentCount,
          limit: FreeTierLimits.maxPaymentMethods,
        );
      }
    }

    state = state.copyWith(isLoading: true);

    try {
      final now = DateTime.now();
      final newPaymentMethod = PaymentMethodsCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        type: Value(type),
        lastFourDigits: Value(lastFourDigits),
        institution: Value(institution),
        isDefault: Value(isDefault),
        syncStatus: const Value(SyncStatus.pendingCreate),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await _db.addPaymentMethod(newPaymentMethod);

      // Reload payment methods to get the new one
      await loadPaymentMethods();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add payment method',
      );
    }
  }

  Future<void> updatePaymentMethod({
    required String id,
    String? name,
    String? type,
    String? lastFourDigits,
    String? institution,
    bool? isDefault,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = await _db.findPaymentMethodById(id);
      if (existing == null) {
        throw Exception('Payment method not found');
      }

      final updatedPaymentMethod = PaymentMethodsCompanion(
        id: Value(id),
        name: Value(name ?? existing.name),
        type: Value(type ?? existing.type),
        lastFourDigits: Value(lastFourDigits ?? existing.lastFourDigits),
        institution: Value(institution ?? existing.institution),
        isDefault: Value(isDefault ?? existing.isDefault),
        syncStatus: const Value(SyncStatus.pendingUpdate),
        createdAt: Value(existing.createdAt),
        updatedAt: Value(DateTime.now()),
      );

      await _db.updatePaymentMethod(updatedPaymentMethod);

      // Reload payment methods to get the updated one
      await loadPaymentMethods();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update payment method',
      );
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      await _db.softDeletePaymentMethod(id);

      // Reload payment methods to reflect the deletion
      await loadPaymentMethods();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete payment method',
      );
    }
  }

  List<PaymentMethod> getDefaultPaymentMethods() {
    return state.paymentMethods.where((p) => p.isDefault).toList();
  }

  List<PaymentMethod> getPaymentMethodsByType(String type) {
    return state.paymentMethods.where((p) => p.type == type).toList();
  }
}

final paymentMethodProvider =
    StateNotifierProvider<PaymentMethodNotifier, PaymentMethodState>((ref) {
      final db = ref.watch(databaseProvider);
      return PaymentMethodNotifier(db, ref);
    });
