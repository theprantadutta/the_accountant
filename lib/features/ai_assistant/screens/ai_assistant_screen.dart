import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_accountant/features/ai_assistant/providers/gemini_provider.dart';
import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      // Get transactions and budgets for processing
      final transactions = ref.read(transactionProvider).transactions;
      final budgets = ref.read(budgetProvider).budgets;
      
      ref.read(aiAssistantProvider.notifier).sendMessage(
        _textController.text,
        transactions: transactions,
        budgets: budgets,
      );
      _textController.clear();
      
      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _generateFinancialInsights() {
    final transactions = ref.read(transactionProvider).transactions;
    ref.read(aiAssistantProvider.notifier).generateFinancialInsights(transactions);
  }

  void _generatePersonalizedAdvice() {
    final transactions = ref.read(transactionProvider).transactions;
    // For now, we'll use placeholder values for monthly income and financial goals
    // In a real implementation, these would come from user input or profile data
    final monthlyIncome = 5000.0; // Placeholder value
    final financialGoals = ['Save for vacation', 'Pay off credit card debt']; // Placeholder values
    
    ref.read(aiAssistantProvider.notifier).generatePersonalizedAdvice(
      transactions: transactions,
      monthlyIncome: monthlyIncome,
      financialGoals: financialGoals,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiAssistantProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: () {
              // Handle AI settings
              _showAISettings();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Clear conversation
              ref.read(aiAssistantProvider.notifier).clearConversation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick action buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildQuickActionButton('Analyze Spending', 'Analyze my recent spending patterns'),
                  const SizedBox(width: 8),
                  _buildQuickActionButton('Budget Tips', 'Give me tips for better budgeting'),
                  const SizedBox(width: 8),
                  _buildQuickActionButton('Save More', 'How can I save more money?'),
                  const SizedBox(width: 8),
                  _buildQuickActionButton('Invest Advice', 'What are good investment options?'),
                  const SizedBox(width: 8),
                  _buildQuickActionButton('Financial Insights', _generateFinancialInsights),
                  const SizedBox(width: 8),
                  _buildQuickActionButton('Personalized Advice', _generatePersonalizedAdvice),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: aiState.messages.length,
              itemBuilder: (context, index) {
                final message = aiState.messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['isUser'],
                  message['timestamp'],
                  isInsight: message['isInsight'] as bool? ?? false,
                  isSuggestion: message['isSuggestion'] as bool? ?? false,
                );
              },
            ),
          ),
          if (aiState.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, dynamic onPressed) {
    if (onPressed is String) {
      // Text prompt
      return ElevatedButton(
        onPressed: () {
          _textController.text = onPressed;
          _sendMessage();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      );
    } else if (onPressed is VoidCallback) {
      // Function callback
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildMessageBubble(String text, bool isUser, DateTime timestamp, {bool isInsight = false, bool isSuggestion = false}) {
    Color backgroundColor;
    if (isInsight) {
      backgroundColor = Colors.blue.withValues(alpha: 0.2);
    } else if (isSuggestion) {
      backgroundColor = Colors.green.withValues(alpha: 0.2);
    } else {
      backgroundColor = isUser ? Colors.blue : Colors.grey[700]!;
    }
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isInsight || isSuggestion ? Border.all(color: Colors.blue.withValues(alpha: 0.3)) : null,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isInsight)
              const Text(
                '💡 Financial Insight',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              )
            else if (isSuggestion)
              const Text(
                '💡 Pro Tips',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            if (isInsight || isSuggestion)
              const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: isUser ? Colors.white70 : Colors.black54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Ask about your finances...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _showAISettings() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Assistant Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Customize your AI assistant experience'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement AI personality settings
                },
                child: const Text('AI Personality'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement response length settings
                },
                child: const Text('Response Length'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement privacy settings
                },
                child: const Text('Privacy Settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}