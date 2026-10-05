import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

class BranchRequestDetailsScreenApprovalView extends StatelessWidget {
  const BranchRequestDetailsScreenApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.only(bottom: 20.r, left: 20.r, right: 20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr.approvalRequiredBy,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    context.tr.recipientDetails,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                12.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ProfileImageWidget(width: 150.w, height: 150.w),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.customColor.text2,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 8.r,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppSvg(
                                assetName: AppAssets.checkWithContainer,
                                width: 12.r,
                                height: 12.r,
                              ),
                              4.horizontalSpace,
                              Text(
                                context.tr.branchManager,
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                _buildRowDetails(
                  context: context,
                  assetName: AppAssets.personSvg,
                  title: context.tr.name,
                  value: 'Ahmed Mohamed',
                ),
                10.verticalSpace,
                _buildRowDetails(
                  context: context,
                  assetName: AppAssets.branch,
                  title: context.tr.branch,
                  value: 'Ahmed Mohamed',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    required String assetName,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        AppSvg(assetName: assetName, width: 16.r, height: 16.r),
        5.horizontalSpace,
        Text(
          '$title:',
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        5.horizontalSpace,
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
          ),
        ),
      ],
    );
  }
}
