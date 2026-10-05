import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/password_strength.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final ValueNotifier<PasswordStrength> valueNotifier;

  const PasswordStrengthWidget({super.key, required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            return Text(
              value == PasswordStrength.weak
                  ? context.tr.weakPassword
                  : value == PasswordStrength.medium
                  ? context.tr.passwordIsOk
                  : value == PasswordStrength.strong
                  ? context.tr.passwordIsPerfect
                  : context.tr.weakPassword,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            );
          },
        ),
        8.horizontalSpace,
        Expanded(
          child: Row(
            children: List.generate(3, (index) {
              return ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (context, value, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 65.w,
                    height: 5.h,
                    margin: EdgeInsetsDirectional.only(end: 5.r),
                    decoration: BoxDecoration(
                      color: value == PasswordStrength.empty
                          ? context.customColor.text2
                          : value == PasswordStrength.weak
                          ? index == 0
                                ? context.customColor.error
                                : context.customColor.text2
                          : value == PasswordStrength.medium
                          ? index == 0 || index == 1
                                ? AppColors.yellow
                                : context.customColor.text2
                          : AppColors.green,
                      borderRadius: BorderRadius.circular(1000.r),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
