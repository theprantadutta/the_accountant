import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/services/iap_service.dart';

/// Provider for IAP service
final iapServiceProvider = Provider<IAPService>((ref) {
  throw UnimplementedError('IAPService must be overridden in ProviderScope');
});

/// Provider for subscription products
final subscriptionProductsProvider = FutureProvider<List<ProductDetails>>((ref) async {
  final iapService = ref.watch(iapServiceProvider);
  await iapService.loadProducts();
  return iapService.products;
});

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(premiumState),
              const SizedBox(height: 32),

              // If premium, show status
              if (premiumState.isPremium) ...[
                _buildPremiumStatus(premiumState),
                const SizedBox(height: 24),
              ],

              // Features section
              _buildFeaturesSection(premiumState.isPremium),
              const SizedBox(height: 32),

              // Subscription tiers (only show if not premium)
              if (!premiumState.isPremium) ...[
                _buildSubscriptionTiers(),
                const SizedBox(height: 24),
              ],

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Restore purchases
              TextButton.icon(
                onPressed: _isLoading ? null : _restorePurchases,
                icon: const Icon(Icons.restore, size: 18),
                label: const Text('Restore Purchases'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Terms
              Text(
                'Subscriptions will be charged to your payment method through your App Store or Google Play account. Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(PremiumState premiumState) {
    return Column(
      children: [
        // Premium icon with glow effect
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            premiumState.isPremium
                ? Icons.workspace_premium
                : Icons.diamond_outlined,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          premiumState.isPremium ? 'Premium Active' : 'Unlock Premium',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          premiumState.isPremium
              ? 'Thank you for your support!'
              : 'Get the most out of your financial journey',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPremiumStatus(PremiumState premiumState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                premiumState.tier.displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (premiumState.daysRemaining != null) ...[
            const SizedBox(height: 8),
            Text(
              '${premiumState.daysRemaining} days remaining',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          if (premiumState.tier == SubscriptionTier.premiumLifetime) ...[
            const SizedBox(height: 8),
            Text(
              'Lifetime access - Never expires',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isPremium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Premium Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureRow(Icons.sync, 'Cloud Sync', 'Sync across all your devices', isPremium),
        _buildFeatureRow(Icons.backup, 'Google Drive Backup', 'Encrypted cloud backups', isPremium),
        _buildFeatureRow(Icons.smart_toy, 'AI Assistant', 'Gemini-powered financial advice', isPremium),
        _buildFeatureRow(Icons.document_scanner, 'Receipt OCR', 'Scan receipts with AI', isPremium),
        _buildFeatureRow(Icons.insights, 'AI Insights', 'Smart spending analysis', isPremium),
        _buildFeatureRow(Icons.analytics, 'Advanced Reports', 'Monthly & yearly analytics', isPremium),
        _buildFeatureRow(Icons.palette, 'Premium Themes', '5 exclusive color themes', isPremium),
        _buildFeatureRow(Icons.all_inclusive, 'Unlimited Everything', 'No limits on wallets, budgets, etc.', isPremium),
        _buildFeatureRow(Icons.download, 'Data Export', 'Export to CSV & PDF', isPremium),
        _buildFeatureRow(Icons.support_agent, 'Priority Support', 'Faster response times', isPremium),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle, bool isUnlocked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.primaryAccent.withValues(alpha: 0.2)
                  : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? AppColors.primaryAccent : AppColors.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isUnlocked ? Icons.check_circle : Icons.lock_outline,
            color: isUnlocked ? AppColors.success : AppColors.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionTiers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Monthly
        _buildTierCard(
          productId: PremiumProductIds.monthly,
          title: 'Monthly',
          price: '\$1.49',
          period: '/month',
          description: 'Billed monthly',
          isRecommended: false,
        ),
        const SizedBox(height: 12),

        // Yearly (recommended)
        _buildTierCard(
          productId: PremiumProductIds.yearly,
          title: 'Yearly',
          price: '\$9.99',
          period: '/year',
          description: 'Save 44% - \$0.83/month',
          isRecommended: true,
          badge: 'BEST VALUE',
        ),
        const SizedBox(height: 12),

        // Lifetime
        _buildTierCard(
          productId: PremiumProductIds.lifetime,
          title: 'Lifetime',
          price: '\$29.99',
          period: '',
          description: 'One-time purchase, forever access',
          isRecommended: false,
          badge: 'FOREVER',
        ),
      ],
    );
  }

  Widget _buildTierCard({
    required String productId,
    required String title,
    required String price,
    required String period,
    required String description,
    required bool isRecommended,
    String? badge,
  }) {
    final isSelected = _selectedProductId == productId;

    return GestureDetector(
      onTap: _isLoading ? null : () => _purchaseProduct(productId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryElevated : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRecommended
                ? AppColors.primaryAccent
                : isSelected
                    ? AppColors.primaryGlow
                    : AppColors.glassBorder,
            width: isRecommended || isSelected ? 2 : 1,
          ),
          boxShadow: isRecommended
              ? [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Badge
            if (badge != null)
              Positioned(
                top: -30,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isRecommended
                        ? AppColors.primaryGradient
                        : const LinearGradient(
                            colors: [AppColors.warning, AppColors.warningDark],
                          ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

            Row(
              children: [
                // Radio indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAccent : AppColors.textMuted,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (period.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Loading overlay
            if (_isLoading && _selectedProductId == productId)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchaseProduct(String productId) async {
    setState(() {
      _isLoading = true;
      _selectedProductId = productId;
      _errorMessage = null;
    });

    try {
      // For now, just simulate purchase - actual IAP integration will use IAPService
      // In production, this would call the IAP service
      await Future.delayed(const Duration(seconds: 1));

      // Determine tier from product ID
      SubscriptionTier tier;
      DateTime? expiresAt;

      switch (productId) {
        case PremiumProductIds.monthly:
          tier = SubscriptionTier.premiumMonthly;
          expiresAt = DateTime.now().add(const Duration(days: 30));
          break;
        case PremiumProductIds.yearly:
          tier = SubscriptionTier.premiumYearly;
          expiresAt = DateTime.now().add(const Duration(days: 365));
          break;
        case PremiumProductIds.lifetime:
          tier = SubscriptionTier.premiumLifetime;
          expiresAt = null;
          break;
        default:
          throw Exception('Unknown product');
      }

      // Update premium state
      ref.read(premiumProvider.notifier).updateSubscription(
            tier: tier,
            expiresAt: expiresAt,
            purchaseId: 'test_${DateTime.now().millisecondsSinceEpoch}',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully subscribed to ${tier.displayName}!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Purchase failed: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate restore - in production, use IAPService
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No previous purchases found'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Restore failed: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
