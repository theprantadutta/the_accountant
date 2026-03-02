import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/connectivity_service.dart';

/// Provider for the ConnectivityService singleton.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider that emits true/false when connectivity changes.
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

/// Simple provider for current online status (derived from stream).
final isOnlineProvider = Provider<bool>((ref) {
  final stream = ref.watch(connectivityStreamProvider);
  return stream.when(
    data: (online) => online,
    loading: () => true,
    error: (_, _) => true,
  );
});
