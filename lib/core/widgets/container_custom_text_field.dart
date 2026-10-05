import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import 'label_text_field.dart';

class ContainerCustomTextField extends StatelessWidget {
  final String? label;
  final Color? labelColor;
  final bool isLabelRequired;
  final bool isLabelOptional;
  final String? appAssetSvg;
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;
  final String? imageUrl;
  final String? pngAssetName;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final String? customTextOption;
  final double? width;

  const ContainerCustomTextField({
    super.key,
    required this.child,
    this.label,
    this.labelColor,
    this.borderColor,
    this.backgroundColor,
    this.isLabelRequired = true,
    this.isLabelOptional = false,
    this.appAssetSvg,
    this.imageUrl,
    this.pngAssetName,
    this.padding,
    this.borderRadius,
    this.customTextOption,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label != null)
          LabelTextField(
            text: label!,
            appAssetSvg: appAssetSvg,
            isLabelRequired: isLabelRequired,
            isLabelOptional: isLabelOptional,
            imageUrl: imageUrl,
            pngAssetName: pngAssetName,
            customTextOption: customTextOption,
            labelColor: labelColor,
          ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor ?? context.customColor.text2,
            borderRadius: borderRadius ?? BorderRadius.circular(20.r),
            border: Border.all(
              color: borderColor ?? context.customColor.border,
            ),
          ),
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 18.r, horizontal: 16.r),
          child: child,
        ),
      ],
    );
  }
}
