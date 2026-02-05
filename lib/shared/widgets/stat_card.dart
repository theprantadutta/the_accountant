import 'package:flutter/material.dart';
import 'package:the_accountant/core/themes/app_colors.dart';
import 'package:the_accountant/core/themes/app_spacing.dart';
import 'package:the_accountant/core/themes/app_typography.dart';
import 'package:the_accountant/core/themes/app_animations.dart';
import 'package:the_accountant/shared/widgets/glass_card.dart';

/// A stat card with animated counter and optional trend indicator.
///
/// Features:
/// - Animated number counter on load
/// - Trend indicator (up/down arrow with color)
/// - Glass background with accent glow
/// - Mini sparkline graph option
/// - Customizable accent colors
class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.trend,
    this.trendValue,
    this.icon,
    this.iconColor,
    this.accentColor,
    this.enableGlow = false,
    this.animateValue = true,
    this.sparklineData,
    this.onTap,
    this.variant = GlassCardVariant.standard,
  });

  final String label;
  final double value;
  final String prefix;
  final String suffix;
  final TrendDirection? trend;
  final String? trendValue;
  final IconData? icon;
  final Color? iconColor;
  final Color? accentColor;
  final bool enableGlow;
  final bool animateValue;
  final List<double>? sparklineData;
  final VoidCallback? onTap;
  final GlassCardVariant variant;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.dramatic,
    );

    _valueAnimation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );

    if (widget.animateValue) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(StatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.animateValue) {
      _valueAnimation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(
            CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
          );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = widget.accentColor ?? AppColors.primaryAccent;

    return GlassCard(
      onTap: widget.onTap,
      enableGlow: widget.enableGlow,
      glowColor: effectiveAccentColor,
      variant: widget.variant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with label and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: AppTypography.secondary(AppTypography.labelMedium),
              ),
              if (widget.icon != null)
                Container(
                  padding: AppSpacing.paddingXs,
                  decoration: BoxDecoration(
                    color: (widget.iconColor ?? effectiveAccentColor)
                        .withValues(alpha: 0.15),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Icon(
                    widget.icon,
                    size: AppSpacing.iconXs,
                    color: widget.iconColor ?? effectiveAccentColor,
                  ),
                ),
            ],
          ),
          AppSpacing.gapSm,

          // Value with animation
          AnimatedBuilder(
            animation: widget.animateValue ? _valueAnimation : _controller,
            builder: (context, child) {
              final displayValue = widget.animateValue
                  ? _valueAnimation.value
                  : widget.value;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.prefix.isNotEmpty)
                    Text(
                      widget.prefix,
                      style: AppTypography.monoMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      _formatValue(displayValue),
                      style: AppTypography.monoLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.suffix.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppSpacing.xs,
                        bottom: AppSpacing.xs,
                      ),
                      child: Text(
                        widget.suffix,
                        style: AppTypography.monoSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Trend indicator
          if (widget.trend != null && widget.trendValue != null) ...[
            AppSpacing.gapSm,
            _TrendIndicator(trend: widget.trend!, value: widget.trendValue!),
          ],

          // Sparkline
          if (widget.sparklineData != null &&
              widget.sparklineData!.isNotEmpty) ...[
            AppSpacing.gapMd,
            SizedBox(
              height: 32,
              child: _MiniSparkline(
                data: widget.sparklineData!,
                color: effectiveAccentColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Trend direction enum
enum TrendDirection { up, down, neutral }

/// Trend indicator widget
class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({required this.trend, required this.value});

  final TrendDirection trend;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = trend == TrendDirection.up
        ? AppColors.success
        : trend == TrendDirection.down
        ? AppColors.error
        : AppColors.textMuted;

    final icon = trend == TrendDirection.up
        ? Icons.trending_up
        : trend == TrendDirection.down
        ? Icons.trending_down
        : Icons.trending_flat;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.iconXs, color: color),
        AppSpacing.gapHXs,
        Text(value, style: AppTypography.labelSmall.copyWith(color: color)),
      ],
    );
  }
}

/// Mini sparkline chart widget
class _MiniSparkline extends StatelessWidget {
  const _MiniSparkline({required this.data, required this.color});

  final List<double> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 32),
      painter: _SparklinePainter(data: data, color: color),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.data, required this.color});

  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    final path = Path();
    final fillPath = Path();
    final strokeWidth = 2.0;

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = range == 0 ? 0.5 : (data[i] - minValue) / range;
      final y = size.height - (normalizedY * (size.height - strokeWidth));
      points.add(Offset(x, y));
    }

    // Draw line
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      path.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }

    // Draw fill
    fillPath.addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);

    // End dot
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(points.last, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return data != oldDelegate.data || color != oldDelegate.color;
  }
}

/// A compact stat widget for inline display
class CompactStat extends StatelessWidget {
  const CompactStat({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final TrendDirection? trend;

  @override
  Widget build(BuildContext context) {
    final trendColor = trend == TrendDirection.up
        ? AppColors.success
        : trend == TrendDirection.down
        ? AppColors.error
        : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppSpacing.iconXs,
            color: iconColor ?? AppColors.textMuted,
          ),
          AppSpacing.gapHXs,
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Text(
              value,
              style: AppTypography.monoSmall.copyWith(
                color: trendColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A hero balance card for displaying main account balance
class HeroBalanceCard extends StatelessWidget {
  const HeroBalanceCard({
    super.key,
    required this.balance,
    this.currencySymbol = '\$',
    this.income,
    this.expenses,
    this.sparklineData,
    this.onTap,
  });

  final double balance;
  final String currencySymbol;
  final double? income;
  final double? expenses;
  final List<double>? sparklineData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AccentGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTypography.secondary(AppTypography.labelMedium),
          ),
          AppSpacing.gapSm,

          // Balance display
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currencySymbol,
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapHXs,
              Expanded(child: _AnimatedBalance(value: balance)),
            ],
          ),
          AppSpacing.gapLg,

          // Income/Expense row
          if (income != null && expenses != null)
            Row(
              children: [
                Expanded(
                  child: _IncomeExpenseItem(
                    label: 'Income',
                    value: income!,
                    currencySymbol: currencySymbol,
                    isIncome: true,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.glassBorder),
                Expanded(
                  child: _IncomeExpenseItem(
                    label: 'Expenses',
                    value: expenses!,
                    currencySymbol: currencySymbol,
                    isIncome: false,
                  ),
                ),
              ],
            ),

          // Sparkline
          if (sparklineData != null && sparklineData!.isNotEmpty) ...[
            AppSpacing.gapLg,
            SizedBox(
              height: 48,
              child: _MiniSparkline(
                data: sparklineData!,
                color: AppColors.primaryAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnimatedBalance extends StatefulWidget {
  const _AnimatedBalance({required this.value});

  final double value;

  @override
  State<_AnimatedBalance> createState() => _AnimatedBalanceState();
}

class _AnimatedBalanceState extends State<_AnimatedBalance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.long,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(
            CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
          );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toStringAsFixed(2),
          style: AppTypography.monoLarge.copyWith(fontSize: 42),
        );
      },
    );
  }
}

class _IncomeExpenseItem extends StatelessWidget {
  const _IncomeExpenseItem({
    required this.label,
    required this.value,
    required this.currencySymbol,
    required this.isIncome,
  });

  final String label;
  final double value;
  final String currencySymbol;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.success : AppColors.error;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingXs,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppSpacing.iconXs, color: color),
          ),
          AppSpacing.gapHSm,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '$currencySymbol${value.toStringAsFixed(0)}',
                style: AppTypography.monoSmall.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
