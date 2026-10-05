import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/container_custom_text_field.dart';

class ReasonTextFormField extends StatelessWidget {
  final String? label;
  final void Function(String value) onChanged;

  const ReasonTextFormField({super.key, required this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    return ContainerCustomTextField(
      label: label,
      child: TextFormField(
        style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
        maxLines: null,
        minLines: 4,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: false,
          counter: null,
          counterStyle: null,
          counterText: '',
          errorMaxLines: 6,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: context.tr.hintReasonForVariance,
          hintStyle: context.textTheme.bodySmall?.copyWith(
            color: context.customColor.text3,
          ),
        ),
      ),
    );
  }
}
