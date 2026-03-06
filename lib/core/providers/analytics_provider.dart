import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/core/services/analytics_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
