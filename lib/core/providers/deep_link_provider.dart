import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/deep_link_service.dart';

/// The one receiver of links and launcher shortcuts.
///
/// Kept alive for the app's lifetime: a link that arrives while it is disposed
/// is a link that is lost, and the whole point of the service is that an
/// arrival waits rather than being dropped.
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService();
  ref.onDispose(service.dispose);
  return service;
});
