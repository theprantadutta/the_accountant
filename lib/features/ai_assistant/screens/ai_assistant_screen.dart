import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
// import 'package:the_accountant/features/ai_assistant/providers/gemini_provider.dart';
// import 'package:the_accountant/features/transactions/providers/transaction_provider.dart';
// import 'package:the_accountant/features/budgets/providers/budget_provider.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late AnimationController _typingAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _typingAnimation;

  bool _isTyping = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'Hello! I\'m your AI financial assistant. I\'m here to help you manage your finances, analyze your spending, and provide personalized advice. How can I assist you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isWelcome': true,
    },
  ];

  void _sendMessage([String? customMessage]) {
    final message = customMessage ?? _textController.text.trim();
    if (message.isNotEmpty) {
      HapticFeedback.lightImpact();

      setState(() {
        _messages.add({
          'text': message,
          'isUser': true,
          'timestamp': DateTime.now(),
        });
        _isTyping = true;
      });

      if (customMessage == null) {
        _textController.clear();
      }

      _typingAnimationController.repeat();

      // Simulate AI response delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        _generateAIResponse(message);
      });

      _scrollToBottom();
    }
  }

  void _generateAIResponse(String userMessage) {
    String response = '';
    bool isInsight = false;
    bool isSuggestion = false;

    // Mock AI responses based on keywords
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('spending') || lowerMessage.contains('analyze')) {
      response =
          'Based on your recent transactions, I can see that your largest expense category is Food & Dining at \$1,245 this month (35% of total expenses). You\'ve spent \$320 on transportation and \$710 on shopping. Your spending pattern shows you tend to spend more on weekends. Consider setting a weekly dining budget to better control this category.';
      isInsight = true;
    } else if (lowerMessage.contains('budget')) {
      response =
          'Here are some personalized budgeting tips:\n\n• Use the 50/30/20 rule: 50% for needs, 30% for wants, 20% for savings\n• Set up automatic transfers to savings\n• Track your expenses weekly\n• Use cashback rewards cards for recurring expenses\n• Review and adjust your budget monthly';
      isSuggestion = true;
    } else if (lowerMessage.contains('save')) {
      response =
          'To save more money, try these strategies:\n\n• Reduce dining out by cooking 2 more meals per week (save ~\$200/month)\n• Cancel unused subscriptions\n• Use the "24-hour rule" for non-essential purchases\n• Set up automatic savings transfers\n• Consider generic brands for groceries';
      isSuggestion = true;
    } else if (lowerMessage.contains('invest')) {
      response =
          'Based on your current savings rate, here are some investment options to consider:\n\n• Start with a high-yield savings account for emergency fund\n• Consider low-cost index funds for long-term growth\n• Max out your 401(k) match if available\n• Look into Roth IRA for tax-free growth\n• Dollar-cost averaging for consistent investing\n\nRemember to invest only what you can afford to lose and consult a financial advisor for personalized advice.';
      isSuggestion = true;
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      response =
          'Hello! I\'m excited to help you with your financial journey today. What would you like to know about your spending, savings, or budget?';
    } else {
      response =
          'That\'s a great question! Based on your financial data, I\'d recommend focusing on creating a sustainable budget that aligns with your goals. Your current spending patterns show good discipline, but there\'s always room for optimization. Would you like me to analyze a specific category or help you set up a savings plan?';
    }

    setState(() {
      _isTyping = false;
      _messages.add({
        'text': response,
        'isUser': false,
        'timestamp': DateTime.now(),
        'isInsight': isInsight,
        'isSuggestion': isSuggestion,
      });
    });

    _typingAnimationController.stop();
    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _typingAnimation = CurvedAnimation(
      parent: _typingAnimationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // AI Assistant Header
                AnimationUtils.slideTransition(
                  animation: _slideAnimation,
                  begin: const Offset(0, -1),
                  child: _buildAIHeader(),
                ),

                const SizedBox(height: 8),
                // Quick action buttons
                AnimationUtils.fadeTransition(
                  animation: AnimationUtils.createStaggeredAnimation(
                    controller: _animationController,
                    startFraction: 0.1,
                    endFraction: 0.3,
                  ),
                  child: _buildQuickActions(),
                ),

                const SizedBox(height: 8),
                // Chat Messages
                Expanded(
                  child: AnimationUtils.fadeTransition(
                    animation: AnimationUtils.createStaggeredAnimation(
                      controller: _animationController,
                      startFraction: 0.2,
                      endFraction: 0.5,
                    ),
                    child: _buildChatArea(),
                  ),
                ),

                // Typing Indicator
                if (_isTyping)
                  AnimationUtils.fadeTransition(
                    animation: _typingAnimation,
                    child: _buildTypingIndicator(),
                  ),

                // Add bottom padding for message input
                const SizedBox(height: 75),
              ],
            ),
          ),

          // Message Input positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 80, // Above navigation bar
            child: AnimationUtils.slideTransition(
              animation: AnimationUtils.createStaggeredAnimation(
                controller: _animationController,
                startFraction: 0.4,
                endFraction: 0.7,
              ),
              begin: const Offset(0, 1),
              child: _buildMessageInput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppTheme.glassmorphicContainer(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: AppTheme.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Financial Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Smart insights • Budget tips • Personalized advice',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _messages.clear();
                    _messages.add({
                      'text':
                          'Hello! I\'m your AI financial assistant. I\'m here to help you manage your finances, analyze your spending, and provide personalized advice. How can I assist you today?',
                      'isUser': false,
                      'timestamp': DateTime.now(),
                      'isWelcome': true,
                    });
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final quickActions = [
      {
        'label': 'Analyze\nSpending',
        'message': 'Analyze my recent spending patterns',
        'icon': Icons.analytics,
      },
      {
        'label': 'Budget\nTips',
        'message': 'Give me tips for better budgeting',
        'icon': Icons.savings,
      },
      {
        'label': 'Save\nMore',
        'message': 'How can I save more money?',
        'icon': Icons.account_balance_wallet,
      },
      {
        'label': 'Investment\nAdvice',
        'message': 'What are good investment options?',
        'icon': Icons.trending_up,
      },
    ];

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => _sendMessage(action['message'] as String),
              child: AppTheme.glassmorphicContainer(
                width: 70,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: AppTheme.secondaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: AppTheme.glassmorphicContainer(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            return _buildMessageBubble(
              message['text'],
              message['isUser'],
              message['timestamp'],
              isInsight: message['isInsight'] as bool? ?? false,
              isSuggestion: message['isSuggestion'] as bool? ?? false,
              isWelcome: message['isWelcome'] as bool? ?? false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppTheme.glassmorphicContainer(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return Row(
                    children: [
                      _buildDot(0),
                      const SizedBox(width: 3),
                      _buildDot(1),
                      const SizedBox(width: 3),
                      _buildDot(2),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                'AI is thinking...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final delay = index * 0.2;
    final animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Interval(delay, delay + 0.6, curve: Curves.easeInOut),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: animation.value),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(
    String text,
    bool isUser,
    DateTime timestamp, {
    bool isInsight = false,
    bool isSuggestion = false,
    bool isWelcome = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: isWelcome
                    ? AppTheme.primaryGradient
                    : (isInsight
                          ? AppTheme.secondaryGradient
                          : AppTheme.primaryGradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isWelcome
                    ? Icons.waving_hand
                    : (isInsight
                          ? Icons.lightbulb
                          : (isSuggestion
                                ? Icons.tips_and_updates
                                : Icons.auto_awesome)),
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isUser ? AppTheme.primaryGradient : null,
                    color: isUser
                        ? null
                        : (isInsight
                              ? const Color(0xFF667eea).withValues(alpha: 0.1)
                              : (isSuggestion
                                    ? const Color(
                                        0xFF11998e,
                                      ).withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.05))),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    border: isInsight || isSuggestion || isWelcome
                        ? Border.all(
                            color: isWelcome
                                ? const Color(0xFF667eea).withValues(alpha: 0.3)
                                : (isInsight
                                      ? const Color(
                                          0xFF667eea,
                                        ).withValues(alpha: 0.3)
                                      : const Color(
                                          0xFF11998e,
                                        ).withValues(alpha: 0.3)),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (isInsight || isSuggestion || isWelcome) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isWelcome
                                  ? Icons.auto_awesome
                                  : (isInsight
                                        ? Icons.analytics
                                        : Icons.tips_and_updates),
                              color: isWelcome
                                  ? const Color(0xFF667eea)
                                  : (isInsight
                                        ? const Color(0xFF667eea)
                                        : const Color(0xFF11998e)),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isWelcome
                                  ? 'AI Assistant'
                                  : (isInsight
                                        ? 'Financial Insight'
                                        : 'Pro Tips'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isWelcome
                                    ? const Color(0xFF667eea)
                                    : (isInsight
                                          ? const Color(0xFF667eea)
                                          : const Color(0xFF11998e)),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.95),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    DateFormat('h:mm a').format(timestamp),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppTheme.glassmorphicContainer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Ask about your finances...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _sendMessage(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
