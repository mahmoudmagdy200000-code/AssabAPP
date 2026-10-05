import 'package:flutter/material.dart';

class AppGestureDetectorButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final HitTestBehavior? behavior;

  const AppGestureDetectorButton({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior ?? HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
