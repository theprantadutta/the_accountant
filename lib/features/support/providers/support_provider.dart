import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_accountant/data/models/support_ticket.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:uuid/uuid.dart';

class SupportState {
  final List<SupportTicket> tickets;
  final bool isLoading;
  final String? errorMessage;

  SupportState({
    this.tickets = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SupportState copyWith({
    List<SupportTicket>? tickets,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SupportState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Get tickets for a specific user
  List<SupportTicket> getUserTickets(String userId) {
    return tickets.where((ticket) => ticket.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

class SupportNotifier extends StateNotifier<SupportState> {
  final Ref _ref;

  SupportNotifier(this._ref) : super(SupportState());

  /// Create a new support ticket
  Future<void> createTicket({
    required String userId,
    required String title,
    required String description,
    required String category,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Check if user is premium for priority support
      final premiumState = _ref.read(premiumProvider);
      final isPremiumUser = premiumState.features.isUnlocked;
      final priority = isPremiumUser
          ? 1
          : 3; // 1 = high priority, 3 = normal priority

      final newTicket = SupportTicket(
        id: const Uuid().v4(),
        userId: userId,
        title: title,
        description: description,
        category: category,
        createdAt: DateTime.now(),
        status: 'Open',
        isPremiumUser: isPremiumUser,
        priority: priority,
      );

      state = state.copyWith(
        tickets: [...state.tickets, newTicket],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Get tickets sorted by priority (premium users first)
  List<SupportTicket> getPrioritySortedTickets() {
    return List<SupportTicket>.from(state.tickets)..sort((a, b) {
      // Premium users get priority
      if (a.isPremiumUser && !b.isPremiumUser) return -1;
      if (!a.isPremiumUser && b.isPremiumUser) return 1;

      // Then sort by priority level
      if (a.priority != b.priority) return a.priority.compareTo(b.priority);

      // Finally sort by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedTickets = state.tickets.map((ticket) {
        if (ticket.id == ticketId) {
          return ticket.copyWith(status: status, updatedAt: DateTime.now());
        }
        return ticket;
      }).toList();

      state = state.copyWith(tickets: updatedTickets, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Add response to ticket
  Future<void> addResponseToTicket(String ticketId, String response) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedTickets = state.tickets.map((ticket) {
        if (ticket.id == ticketId) {
          return ticket.copyWith(response: response, updatedAt: DateTime.now());
        }
        return ticket;
      }).toList();

      state = state.copyWith(tickets: updatedTickets, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final supportProvider = StateNotifierProvider<SupportNotifier, SupportState>((
  ref,
) {
  return SupportNotifier(ref);
});
