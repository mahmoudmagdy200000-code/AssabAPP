import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/shared/models/branch_manager_details_response.dart';
import 'package:flutter/material.dart';

import '../../../../shared/models/branch_details_response.dart';

class SupplierRequestBranchView extends StatelessWidget {
  final BranchDetailsResponse branch;
  final BranchManagerDetailsResponse branchManager;

  const SupplierRequestBranchView({
    super.key,
    required this.branch,
    required this.branchManager,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppSvg(assetName: AppAssets.branch, width: 16.r),
                  8.horizontalSpace,
                  Text(
                    branch.name,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: context.customColor.text2,
                ),
                padding: EdgeInsets.all(4.r),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                    color: context.customColor.reversedTextColor,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          AppAssetImage(
                            image: AppAssets.testBranch,
                            height: 230.h,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          PositionedDirectional(
                            bottom: 0,
                            start: 0,
                            child: Container(
                              width: 250.w,
                              decoration: BoxDecoration(
                                color: context.customColor.reversedTextColor,
                                borderRadius: BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(20.r),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.r,
                                horizontal: 12.r,
                              ),
                              child: Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.branch,
                                    width: 16.r,
                                  ),
                                  8.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      '${context.tr.opens}: ${DateFormatter.getDayName(branch.openingHours)} - ${DateFormatter.getDayName(branch.closingHours)} / ${DateFormatter.formatTimeHM(branch.openingHours)} - ${DateFormatter.formatTimeHM(branch.closingHours)}',
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      ProfileImageWidget(image: branchManager.image),
                      10.verticalSpace,
                      Text(
                        branchManager.name,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppSvg(
                            assetName: AppAssets.checkWithContainer,
                            width: 16.r,
                          ),
                          8.horizontalSpace,
                          Text(
                            context.tr.branchManager,
                            style: AppStyles.s12W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                      25.verticalSpace,
                    ],
                  ),
                ),
              ),
              16.verticalSpace,
              ButtonTextIcon(
                onTap: () {},
                label: context.tr.mapToStore,
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 20.r,
                  color: context.theme.primaryColor,
                ),
                borderRadius: BorderRadius.circular(1000.r),
                backgroundColor: Colors.transparent,
                textColor: context.customColor.text1,
                padding: EdgeInsets.symmetric(vertical: 14.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
