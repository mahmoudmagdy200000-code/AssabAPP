import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/styles/app_colors.dart';

class AddCashierRequestWidget extends StatelessWidget {
  const AddCashierRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            70.verticalSpace,

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.sBlack, width: 1.w),
              ),
              child: AppAssetImage(
                image: AppAssets.cashierCreatedGif,
                width: 260.w,
                height: 260.h,
              ),
            ),

            25.verticalSpace,

            Text(context.tr.accountCreated, style: AppStyles.s17W500),

            15.verticalSpace,

            SizedBox(
              width: 300.w,
              child: BlocSelector<ValidationCubit, ValidationState, String?>(
                selector: (state) {
                  return state.fieldsValue['email'];
                },
                builder: (context, state) {
                  // return Text(
                  //   context.tr.accountCreatedDesc(
                  //     state ?? 'N/A'),
                  //   style: AppStyles.s14W400,
                  //   textAlign: TextAlign.center,
                  // );

                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text4,
                      ),
                      children: [
                        TextSpan(text: context.tr.accountCreatedDesc_before),
                        TextSpan(
                          text: state != null
                              ? '($state).'
                              : '(OmarAl-Farsi@Assab.sa).',
                          style: AppStyles.s14W600.copyWith(
                            color: AppColors.primaryLight, // 👈 email color
                          ),
                        ),
                        TextSpan(text: context.tr.accountCreatedDesc_after),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Spacer(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
              child: AppButton(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                borderRadius: BorderRadius.circular(25.r),
                onClick: () {
                  NavigationService.I.pop();
                },
                enabled: true,
                text: context.tr.backToCashierList,
                textColor: AppColors.primaryLight,
                borderColor: AppColors.primaryLight,
                isTransparent: true,
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
