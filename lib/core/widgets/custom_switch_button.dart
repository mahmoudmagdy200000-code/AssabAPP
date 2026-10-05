import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class CustomSwitchButton extends StatelessWidget {
  final bool value;
  final void Function(bool newValue)? onChanged;

  const CustomSwitchButton({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 0,
        onChanged: onChanged,
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStatePropertyAll(
          value ? context.theme.primaryColor : context.customColor.border,
        ),
        trackOutlineColor: WidgetStatePropertyAll(context.customColor.border),
      ),
    );
  }
}
