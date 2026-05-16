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
      duration: const Duration(milliseconds: 1200),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.orangeAccent, 
                    fontSize: 11, 
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _buildDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Offset start time for each dot
            double begin = index * 0.2;
            double end = begin + 0.6;
            
            double val = 0.0;
            if (_controller.value >= begin && _controller.value <= end) {
              val = (_controller.value - begin) / 0.6;
            } else if (_controller.value < begin && _controller.value + 1.0 <= end) {
              val = (_controller.value + 1.0 - begin) / 0.6;
            }

            // Peak at 0.5
            double factor = val < 0.5 ? val * 2 : 2 * (1 - val);
            factor = Curves.easeInOut.transform(factor.clamp(0.0, 1.0));

            return Container(
              margin: const EdgeInsets.only(right: 3),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orangeAccent.withOpacity(0.3 + 0.7 * factor),
              ),
              transform: Matrix4.translationValues(0, -4 * factor, 0),
            );
          }),
        );
      },
    );
  }
}
