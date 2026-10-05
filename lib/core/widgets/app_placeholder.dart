import 'package:flutter/material.dart';

class AppPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const AppPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<AppPlaceholder> createState() => _AppPlaceholderState();
}

class _AppPlaceholderState extends State<AppPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final double shimmerPosition = _controller.value * 2 - 1;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(shimmerPosition - 0.3, shimmerPosition - 0.3),
              end: Alignment(shimmerPosition + 0.3, shimmerPosition + 0.3),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
