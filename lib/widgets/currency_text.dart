import 'package:finance_app/services/settings_service.dart';
import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final bool showShort;
  final String? prefix;

  const CurrencyText({
    Key? key,
    required this.amount,
    this.style,
    this.showShort = false,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();
    final formattedAmount = showShort 
        ? settingsService.formatAmountShort(amount)
        : settingsService.formatAmount(amount);
    
    return Text(
      prefix != null ? '$prefix$formattedAmount' : formattedAmount,
      style: style,
    );
  }
}

class AnimatedCurrencyText extends StatefulWidget {
  final double amount;
  final TextStyle? style;
  final bool showShort;
  final String? prefix;
  final Duration duration;

  const AnimatedCurrencyText({
    Key? key,
    required this.amount,
    this.style,
    this.showShort = false,
    this.prefix,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<AnimatedCurrencyText> createState() => _AnimatedCurrencyTextState();
}

class _AnimatedCurrencyTextState extends State<AnimatedCurrencyText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousAmount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0,
      end: widget.amount,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _previousAmount = widget.amount;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCurrencyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _previousAmount = _animation.value;
      _animation = Tween<double>(
        begin: _previousAmount,
        end: widget.amount,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      
      _controller.reset();
      _controller.forward();
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
        return CurrencyText(
          amount: _animation.value,
          style: widget.style,
          showShort: widget.showShort,
          prefix: widget.prefix,
        );
      },
    );
  }
}