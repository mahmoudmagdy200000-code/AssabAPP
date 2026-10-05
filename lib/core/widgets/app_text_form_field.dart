import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/password/show_password_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/app_gesture_detector_button.dart';
import '../enums/text_form_type.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final String? error;
  final bool? enabled;
  final TextInputType keyboardType;
  final TextFormType textFormType;
  final Widget? prefixIcon;
  final int? maxLength;
  final void Function(String value)? onChanged;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.error,
    this.onChanged,
    this.enabled,
    this.keyboardType = TextInputType.text,
    this.textFormType = TextFormType.text,
    this.prefixIcon,
    this.label,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          4.verticalSpace,
        ],
        BlocBuilder<ShowPasswordCubit, bool>(
          builder: (context, state) {
            return TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: textFormType == TextFormType.phone
                  ? TextInputType.phone
                  : keyboardType,
              obscureText: textFormType == TextFormType.password
                  ? state
                  : false,
              maxLength: textFormType == TextFormType.phone ? 9 : maxLength,
              obscuringCharacter: '*',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
              decoration: InputDecoration(
                hintText: hint,
                errorText: error,
                counter: null,
                counterStyle: null,
                counterText: '',
                errorMaxLines: 6,
                suffixIconConstraints: BoxConstraints(
                  minWidth: 36.r,
                  minHeight: 36.r,
                  maxWidth: 36.r,
                  maxHeight: 36.r,
                ),
                suffixIcon: textFormType == TextFormType.password
                    ? AppGestureDetectorButton(
                        onTap: () => context.read<ShowPasswordCubit>().toggle(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 16.r),
                          child: AppSvg(
                            assetName: state ? AppAssets.eye : AppAssets.offEye,
                          ),
                        ),
                      )
                    : null,
                prefixIcon: textFormType == TextFormType.phone
                    ? Container(
                        width: 40.w,
                        padding: EdgeInsetsDirectional.only(start: 10.r),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            '+966',
                            textAlign: TextAlign.center,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text6,
                            ),
                          ),
                        ),
                      )
                    : prefixIcon,
              ),
              onChanged: onChanged,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
            );
          },
        ),
      ],
    );
  }
}
