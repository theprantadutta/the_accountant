import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_accountant/core/themes/app_theme.dart';
import 'package:the_accountant/core/utils/animation_utils.dart';
import 'package:the_accountant/data/models/premium_features.dart';
import 'package:the_accountant/features/ai_assistant/models/chat_message.dart';
import 'package:the_accountant/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:the_accountant/features/premium/widgets/premium_gate.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

/// Wrapper that shows premium gate for non-premium users
class AIAssistantScreenGated extends ConsumerWidget {
  const AIAssistantScreenGated({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumGate(
      featureId: PremiumFeatureIds.aiAssistant,
      featureName: 'AI Assistant',
      featureDescription:
          'Get personalized financial advice, spending analysis, and smart insights powered by AI.',
      featureIcon: Icons.smart_toy,
      child: const AIAssistantScreen(),
    );
  }
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late AnimationController _typingAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _typingAnimation;

  void _sendMessage([String? customMessage]) async {
    final message = customMessage ?? _textController.text.trim();
    if (message.isNotEmpty) {
      HapticFeedback.lightImpact();

      // Close keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      if (customMessage == null) {
        _textController.clear();
      }

      _typingAnimationController.repeat();

      // Send message via provider
      await ref.read(aiChatProvider.notifier).sendMessage(message);

      _typingAnimationController.stop();
      _scrollToBottom();
    }
  }

  void _clearChat() {
    ref.read(aiChatProvider.notifier).clearMessages();
    HapticFeedback.lightImpact();
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

    // Add listener for text field focus to scroll to bottom
    _textController.addListener(_onTextChanged);

    // Load chat history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).loadHistory();
    });
  }

  void _onTextChanged() {
    // Scroll to bottom when user starts typing
    if (_textController.text.isNotEmpty) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch chat state from provider
    final chatState = ref.watch(aiChatProvider);
    final isLoading = chatState.isLoading;
    final isLoadingHistory = chatState.isLoadingHistory;
    final messages = chatState.messages;

    // Get keyboard state
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // Scroll to bottom when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Collapse header spacing when keyboard is open
            SizedBox(height: isKeyboardOpen ? 8 : 16),

            // AI Assistant Header - hide when keyboard is open to save space
            if (!isKeyboardOpen)
              AnimationUtils.slideTransition(
                animation: _slideAnimation,
                begin: const Offset(0, -1),
                child: _buildAIHeader(),
              ),

            // Error banner
            if (chatState.hasError && !isKeyboardOpen)
              _buildErrorBanner(chatState.errorMessage, chatState.errorType),

            // Quick action buttons - hide when keyboard is open
            if (!isKeyboardOpen) ...[
              const SizedBox(height: 8),
              AnimationUtils.fadeTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.1,
                  endFraction: 0.3,
                ),
                child: _buildQuickActions(),
              ),
            ],

            SizedBox(height: isKeyboardOpen ? 4 : 8),
            // Chat Messages - takes all available space
            Expanded(
              child: AnimationUtils.fadeTransition(
                animation: AnimationUtils.createStaggeredAnimation(
                  controller: _animationController,
                  startFraction: 0.2,
                  endFraction: 0.5,
                ),
                child: isLoadingHistory
                    ? _buildLoadingHistoryIndicator()
                    : _buildChatArea(messages),
              ),
            ),

            // Typing Indicator - smaller when keyboard is open
            if (isLoading)
              AnimationUtils.fadeTransition(
                animation: _typingAnimation,
                child: _buildTypingIndicator(),
              ),

            // Message Input - properly at bottom
            _buildMessageInput(isLoading || isLoadingHistory),

            // Bottom spacing
            SizedBox(height: isKeyboardOpen ? 8 : 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingHistoryIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading conversation...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String? errorMessage, String? errorType) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade300,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage ?? 'AI response may be limited',
              style: TextStyle(
                color: Colors.orange.shade200,
                fontSize: 13,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(aiChatProvider.notifier).retryLastMessage();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.orange.shade200,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AppTheme.glassmorphicContainer(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // AI Icon with outer glow ring (like premium gate hero)
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF667eea).withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: AppTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.3),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
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
                        'Smart insights \u2022 Budget tips \u2022 Personalized advice',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _clearChat,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _sendMessage(action['message'] as String),
              child: Container(
                width: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppTheme.glassmorphicContainer(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppTheme.secondaryGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF11998e).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatArea(List<ChatMessage> messages) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessageBubble(
            message.text,
            message.isFromUser,
            message.timestamp,
            isInsight: message.isInsight,
            isSuggestion: message.isSuggestion,
            isWelcome: message.isWelcome,
            isError: message.isAiFallback,
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppTheme.glassmorphicContainer(
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedBuilder(
                  animation: _typingAnimation,
                  builder: (context, child) {
                    return Row(
                      children: [
                        _buildDot(0),
                        const SizedBox(width: 4),
                        _buildDot(1),
                        const SizedBox(width: 4),
                        _buildDot(2),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  'AI is thinking...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: animation.value),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withValues(alpha: animation.value * 0.5),
                blurRadius: 4,
              ),
            ],
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
    bool isError = false,
  }) {
    // Determine accent color for special messages
    final Color accentColor;
    if (isError) {
      accentColor = Colors.orange;
    } else if (isInsight || isWelcome) {
      accentColor = const Color(0xFF667eea);
    } else {
      accentColor = const Color(0xFF11998e);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // AI Avatar with glow effect
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: isError
                        ? LinearGradient(
                            colors: [Colors.orange.shade400, Colors.orange.shade600],
                          )
                        : (isWelcome
                            ? AppTheme.primaryGradient
                            : (isInsight
                                  ? AppTheme.secondaryGradient
                                  : AppTheme.primaryGradient)),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isError
                        ? Icons.warning_amber_rounded
                        : (isWelcome
                            ? Icons.waving_hand
                            : (isInsight
                                  ? Icons.lightbulb
                                  : (isSuggestion
                                        ? Icons.tips_and_updates
                                        : Icons.auto_awesome))),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                        : (isError
                              ? Colors.orange.withValues(alpha: 0.15)
                              : (isInsight
                                    ? const Color(0xFF667eea).withValues(alpha: 0.15)
                                    : (isSuggestion
                                          ? const Color(0xFF11998e).withValues(alpha: 0.15)
                                          : Colors.white.withValues(alpha: 0.08)))),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    border: Border.all(
                      color: isUser
                          ? Colors.transparent
                          : (isError || isInsight || isSuggestion || isWelcome
                              ? accentColor.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.1)),
                      width: 1,
                    ),
                    boxShadow: [
                      if (isUser)
                        BoxShadow(
                          color: const Color(0xFF667eea).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        )
                      else
                        BoxShadow(
                          color: (isError || isInsight || isSuggestion || isWelcome)
                              ? accentColor.withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (isError || isInsight || isSuggestion || isWelcome) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isError
                                  ? Icons.cloud_off
                                  : (isWelcome
                                      ? Icons.auto_awesome
                                      : (isInsight
                                            ? Icons.analytics
                                            : Icons.tips_and_updates)),
                              color: accentColor,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isError
                                  ? 'Connection Issue'
                                  : (isWelcome
                                      ? 'AI Assistant'
                                      : (isInsight
                                            ? 'Financial Insight'
                                            : 'Pro Tips')),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: accentColor,
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
            const SizedBox(width: 10),
            // User Avatar with gradient border
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.5),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _textController,
                  enabled: !isLoading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: const Color(0xFF667eea),
                  decoration: InputDecoration(
                    hintText: isLoading ? 'Waiting for response...' : 'Ask about your finances...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isLoading ? null : () => _sendMessage(),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: isLoading
                      ? LinearGradient(
                          colors: [
                            Colors.grey.shade600,
                            Colors.grey.shade700,
                          ],
                        )
                      : AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.5),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: Icon(
                  isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
