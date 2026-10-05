import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../domain/entity/manager_shift/current_shift/progress_entity.dart';

class NoFinalHanOverWidget extends StatelessWidget {
  const NoFinalHanOverWidget({
    super.key,
    required this.progress,
    required this.shiftDate,
    required this.title,
    required this.firstSubTitle,
    required this.secondSubTitle,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonOnTap,
  });

  final ProgressEntity progress;
  final String shiftDate;
  final String title;
  final String firstSubTitle;
  final String secondSubTitle;
  final String buttonText;
  final Color buttonColor;
  final Function() buttonOnTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border, width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSvg(assetName: AppAssets.endManagerShiftSvg, width: 70.w),

            15.verticalSpace,
            Text(title, style: AppStyles.s16W500),

            15.verticalSpace,

            Text(
              firstSubTitle,
              textAlign: TextAlign.center,
              style: AppStyles.s14W400,
            ),

            15.verticalSpace,

            Text(
              secondSubTitle,
              textAlign: TextAlign.center,
              style: AppStyles.s14W400,
            ),

            25.verticalSpace,

            BlocBuilder<ManagerShiftCubit, ManagerShiftState>(
              builder: (context, state) {
                if (state is ManagerShiftButtonLoading) {
                  return AppButtonLoading(background: buttonColor);
                }
                return AppButton(
                  text: buttonText,
                  borderRadius: BorderRadius.circular(15.r),
                  onClick: buttonOnTap,
                  enabled: true,
                  background: buttonColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
