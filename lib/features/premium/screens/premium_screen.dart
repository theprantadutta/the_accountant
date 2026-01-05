import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/premium/providers/iap_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';
import 'package:the_accountant/features/premium/services/iap_service.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  String? _selectedProductId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(iapNotifierProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumProvider);
    final iapState = ref.watch(iapNotifierProvider);

    // Listen for purchase status changes
    ref.listen<IAPState>(iapNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        setState(() => _errorMessage = next.error);
      }

      if (next.lastPurchaseStatus == PurchaseStatus.purchased ||
          next.lastPurchaseStatus == PurchaseStatus.restored) {
        // Refresh IAP state after successful purchase
        ref.read(iapNotifierProvider.notifier).refresh();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.lastPurchaseStatus == PurchaseStatus.restored
                    ? 'Purchases restored successfully!'
                    : 'Purchase completed successfully!',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    });

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
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(premiumState),
              SizedBox(height: AppSpacing.xl),

              // If premium, show status
              if (premiumState.isPremium) ...[
                _buildPremiumStatus(premiumState),
                SizedBox(height: AppSpacing.lg),
              ],

              // Features section
              _buildFeaturesSection(premiumState.isPremium),
              SizedBox(height: AppSpacing.xl),

              // Subscription tiers (only show if not premium)
              if (!premiumState.isPremium) ...[
                _buildSubscriptionTiers(iapState),
                SizedBox(height: AppSpacing.lg),
              ],

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.error),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: AppColors.error, fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.error, size: 18),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                      ],
                    ),
                  ),
                ),

              // Restore purchases
              TextButton.icon(
                onPressed: iapState.isLoading ? null : _restorePurchases,
                icon: iapState.isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : const Icon(Icons.restore, size: 18),
                label: Text(iapState.isLoading ? 'Processing...' : 'Restore Purchases'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: AppSpacing.md),

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
        SizedBox(height: AppSpacing.lg),
        Text(
          premiumState.isPremium ? 'Premium Active' : 'Unlock Premium',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
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
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: Colors.white, size: 24),
              SizedBox(width: AppSpacing.xs),
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
            SizedBox(height: AppSpacing.xs),
            Text(
              '${premiumState.daysRemaining} days remaining',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          if (premiumState.tier == SubscriptionTier.premiumLifetime) ...[
            SizedBox(height: AppSpacing.xs),
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
        SizedBox(height: AppSpacing.md),
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
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
          SizedBox(width: AppSpacing.sm),
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

  Widget _buildSubscriptionTiers(IAPState iapState) {
    // Get prices from IAP products if available
    final monthlyProduct = iapState.products.firstWhere(
      (p) => p.id == PremiumProductIds.monthly,
      orElse: () => PremiumProduct(ProductDetails(
        id: PremiumProductIds.monthly,
        title: 'Monthly',
        description: '',
        price: '\$1.49',
        rawPrice: 1.49,
        currencyCode: 'USD',
      )),
    );

    final yearlyProduct = iapState.products.firstWhere(
      (p) => p.id == PremiumProductIds.yearly,
      orElse: () => PremiumProduct(ProductDetails(
        id: PremiumProductIds.yearly,
        title: 'Yearly',
        description: '',
        price: '\$9.99',
        rawPrice: 9.99,
        currencyCode: 'USD',
      )),
    );

    final lifetimeProduct = iapState.products.firstWhere(
      (p) => p.id == PremiumProductIds.lifetime,
      orElse: () => PremiumProduct(ProductDetails(
        id: PremiumProductIds.lifetime,
        title: 'Lifetime',
        description: '',
        price: '\$29.99',
        rawPrice: 29.99,
        currencyCode: 'USD',
      )),
    );

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
        SizedBox(height: AppSpacing.md),

        // Monthly
        _buildTierCard(
          productId: PremiumProductIds.monthly,
          title: 'Monthly',
          price: monthlyProduct.price,
          period: '/month',
          description: 'Billed monthly',
          isRecommended: false,
          isLoading: iapState.isLoading && _selectedProductId == PremiumProductIds.monthly,
        ),
        SizedBox(height: AppSpacing.sm),

        // Yearly (recommended)
        _buildTierCard(
          productId: PremiumProductIds.yearly,
          title: 'Yearly',
          price: yearlyProduct.price,
          period: '/year',
          description: 'Save 44% - Best value!',
          isRecommended: true,
          badge: 'BEST VALUE',
          isLoading: iapState.isLoading && _selectedProductId == PremiumProductIds.yearly,
        ),
        SizedBox(height: AppSpacing.sm),

        // Lifetime
        _buildTierCard(
          productId: PremiumProductIds.lifetime,
          title: 'Lifetime',
          price: lifetimeProduct.price,
          period: '',
          description: 'One-time purchase, forever access',
          isRecommended: false,
          badge: 'FOREVER',
          isLoading: iapState.isLoading && _selectedProductId == PremiumProductIds.lifetime,
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
    bool isLoading = false,
  }) {
    final isSelected = _selectedProductId == productId;

    return GestureDetector(
      onTap: isLoading ? null : () => _purchaseProduct(productId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryElevated : AppColors.primarySurface,
          borderRadius: AppSpacing.borderRadiusLg,
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                SizedBox(width: AppSpacing.md),

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
                      SizedBox(height: AppSpacing.xs),
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
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.7),
                    borderRadius: AppSpacing.borderRadiusLg,
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
    HapticFeedback.mediumImpact();

    setState(() {
      _selectedProductId = productId;
      _errorMessage = null;
    });

    final success = await ref.read(iapNotifierProvider.notifier).purchase(productId);

    if (!success && mounted) {
      // If purchase initiation failed, reset selection
      setState(() {
        _selectedProductId = null;
      });
    }
  }

  Future<void> _restorePurchases() async {
    HapticFeedback.mediumImpact();

    setState(() => _errorMessage = null);

    await ref.read(iapNotifierProvider.notifier).restorePurchases();
  }
}
