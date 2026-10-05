import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class AnimatedContainerOfPagingWidget extends StatelessWidget {
  final bool condition;
  final double? width;
  final double? height;
  final Color? color;

  const AnimatedContainerOfPagingWidget({
    super.key,
    required this.condition,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color ?? context.customColor.text2,
        borderRadius: BorderRadius.circular(1000.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.r),
      width: condition ? width ?? 50.w : 0,
      height: height ?? 4.h,
    );
  }
}
