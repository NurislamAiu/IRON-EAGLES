import 'package:flutter/material.dart';
import 'package:ArcheoAI/core/localization/app_localizations.dart';

class TypingIndicator extends StatefulWidget {
  final List<String> typingUsers;

  const TypingIndicator({super.key, required this.typingUsers});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) return const SizedBox.shrink();

    String text = widget.typingUsers.length == 1
        ? "${widget.typingUsers[0]} ${S.of(context).isTyping}"
        : "${widget.typingUsers.length} ${S.of(context).areTyping}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(width: 8),
          _buildDots(),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            double value = (index + _controller.value * 3) % 3;
            double opacity = value < 1 ? value : (value < 2 ? 2 - value : 0);
            return Container(
              margin: const EdgeInsets.only(right: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orangeAccent.withOpacity(opacity.clamp(0.2, 1.0)),
              ),
            );
          }),
        );
      },
    );
  }
}
