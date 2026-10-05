import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../purchase/presentation/widgets/purchasing_officer_summary_view_purchasing_officer_benefits_section.dart';

class PurchaseOfficerRequestDetailsScreenApprovalView extends StatelessWidget {
  const PurchaseOfficerRequestDetailsScreenApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(
                    'Name',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            PurchasingOfficerSummaryViewPurchasingOfficerBenefitsSection(
              isSliver: false,
              // non border
              border: Border.all(color: Colors.transparent),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
