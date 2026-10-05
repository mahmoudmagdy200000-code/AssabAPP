import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLength;
  final void Function(String value)? onChanged;
  final String? initialValue;

  final TextInputType keyboardType;
  final String? error;
  final bool isEnabled;
  final bool isFilled;
  final Color fillColor;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? textColor;
  final UnderlineInputBorder? underlineInputBorder;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLength,
    this.onChanged,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.error,
    this.isEnabled = true,
    this.isFilled = false,
    this.fillColor = Colors.white,
    this.maxLines,
    this.textAlign,
    this.textColor,
    this.underlineInputBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign ?? TextAlign.start,
      controller: controller,
      style: context.textTheme.bodyMedium?.copyWith(
        color: textColor ?? context.customColor.text1,
        fontSize: 14.f,
      ),
      initialValue: initialValue,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      keyboardType: keyboardType,
      enabled: isEnabled,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
          : null,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: isFilled ? fillColor : null,
        errorText: error,
        counter: null,
        counterStyle: null,
        counterText: '',
        errorMaxLines: 6,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        border: underlineInputBorder ?? InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        hintText: hintText,
        hintStyle: context.textTheme.bodySmall?.copyWith(
          color: context.customColor.text3,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
