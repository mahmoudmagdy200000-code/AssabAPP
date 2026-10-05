import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../cubit/choose_user_type/choose_user_type_cubit.dart';
import '../cubit/choose_user_type/choose_user_type_state.dart';
import '../../../../core/strategies/user_type_strategy.dart';

class UserTypeButton extends StatelessWidget {
  final String title;
  final UserTypeStrategy userTypeStrategy;
  final VoidCallback onTap;

  const UserTypeButton({
    super.key,
    required this.title,
    required this.userTypeStrategy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: BlocBuilder<ChooseUserTypeCubit, ChooseUserTypeState>(
        builder: (context, state) {
          final isSelected =
              state.selectedUserType == userTypeStrategy.userType;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? context.theme.primaryColor
                    : context.customColor.border,
              ),
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
            child: Row(
              children: [
                SelectionCircule(isSelected: isSelected),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: isSelected
                        ? AppStyles.s14W600.copyWith(
                            color: context.customColor.text4,
                          )
                        : AppStyles.s14W400.copyWith(
                            color: context.customColor.text4,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
