import 'package:flutter/material.dart';

import '../../core/extensions/number_extensions.dart';

class AppPaddingWidget extends StatelessWidget {
  final Widget child;
  final double? top;
  final double? bottom;
  final double? right;
  final double? left;

  const AppPaddingWidget({
    super.key,
    required this.child,
    this.top,
    this.bottom,
    this.right,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top ?? 20.r,
        bottom: bottom ?? 20.r,
        right: right ?? 20.r,
        left: left ?? 20.r,
      ),
      child: child,
    );
  }
}
