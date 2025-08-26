import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/premium/providers/payment_provider.dart';
import 'package:the_accountant/features/premium/providers/premium_provider.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final premiumState = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unlock Premium Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get the most out of your financial management experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Premium features list
            const Text(
              'Premium Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureItem(
                    'Exclusive Themes',
                    'Customize the app with beautiful premium themes',
                    premiumState.features.isUnlocked,
                  ),
                  _buildFeatureItem(
                    'Priority Support',
                    'Get faster responses from our support team with dedicated priority handling',
                    premiumState.features.isUnlocked,
                  ),
                  _buildFeatureItem(
                    'Advanced Analytics',
                    'Unlock detailed financial insights and reports',
                    premiumState.features.isUnlocked,
                  ),
                  _buildFeatureItem(
                    'Custom Categories',
                    'Create unlimited custom categories for your expenses',
                    premiumState.features.isUnlocked,
                  ),
                  _buildFeatureItem(
                    'Data Export',
                    'Export your financial data in multiple formats',
                    premiumState.features.isUnlocked,
                  ),
                  _buildFeatureItem(
                    'No Ads',
                    'Enjoy an ad-free experience',
                    premiumState.features.isUnlocked,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Purchase button or status
            if (!premiumState.features.isUnlocked) ...[
              if (paymentState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    if (paymentState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          paymentState.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (paymentState.successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          paymentState.successMessage!,
                          style: const TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: paymentState.isAvailable
                            ? () => ref.read(paymentProvider.notifier).purchasePremiumFeatures()
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          paymentState.isAvailable
                              ? 'Unlock Premium - ${paymentState.productPrice ?? 'Loading...'}'
                              : 'Payments Not Available',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(paymentProvider.notifier).restorePurchases(),
                      child: const Text('Restore Purchases'),
                    ),
                  ],
                ),
            ] else
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Premium Unlocked!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Thank you for supporting our app!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to support screen
                          Navigator.pushNamed(context, '/support', arguments: 'user123');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text(
                          'Access Priority Support',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(paymentProvider.notifier).restorePurchases(),
                      child: const Text('Restore Purchases'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, bool isUnlocked) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          isUnlocked ? Icons.check_circle : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: isUnlocked ? Colors.black87 : Colors.grey,
          ),
        ),
      ),
    );
  }
}