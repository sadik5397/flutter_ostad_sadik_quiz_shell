import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, this.dotColor, this.size = 6});

  final Color? dotColor;
  final double size;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.dotColor ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 0.6),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final double progress = (_controller.value - (i * 0.2)) % 1.0;
                final double clamped = progress < 0 ? progress + 1 : progress;
                final double bounce = (clamped < 0.5 ? clamped * 2 : (1 - clamped) * 2);
                return Transform.translate(
                  offset: Offset(0, -bounce * 6),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.85), shape: BoxShape.circle),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
