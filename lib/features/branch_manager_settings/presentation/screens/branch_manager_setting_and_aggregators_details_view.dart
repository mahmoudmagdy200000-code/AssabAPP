import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';

class BranchManagerSettingAndAggregatorsDetailsView extends StatelessWidget {
  final BranchManagerBranchInfoEntity branchInfo;

  const BranchManagerSettingAndAggregatorsDetailsView({
    super.key,
    required this.branchInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSvg(
                        assetName: AppAssets.branchStoreSvg,
                        width: 24.w,
                        colorFilter: ColorFilter.mode(
                          context.customColor.text3,
                          BlendMode.srcIn,
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Text(
                          branchInfo.branchName,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Stack(
                  children: [
                    AppNetworkImage(
                      image: branchInfo.branchImageUrl,
                      borderRadius: BorderRadius.circular(15.r),
                      height: 180.h,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                            bottomStart: Radius.circular(15.r),
                          ),
                          color: context.customColor.reversedTextColor,
                          border: BorderDirectional(
                            start: BorderSide(
                              color: context.customColor.border,
                            ),
                            bottom: BorderSide(
                              color: context.customColor.border,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.r,
                          vertical: 8.r,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppSvg(
                              assetName: AppAssets.branchStoreSvg,
                              width: 14.w,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            10.horizontalSpace,
                            Flexible(
                              child: Text(
                                '${context.tr.opens}:  ${branchInfo.branchOpening}',
                                style: AppStyles.s12W500.copyWith(
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
                10.verticalSpace,
                ProfileImageWidget(
                  image: branchInfo.branchManagerImageUrl,
                  width: 180.h,
                  height: 180.h,
                ),
                10.verticalSpace,
                Text(
                  branchInfo.branchManagerName,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000.r),
                    border: Border.all(color: context.customColor.border),
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
                        width: 14.w,
                        colorFilter: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Text(
                          'Branch Manager',
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                ButtonTextIcon(
                  onTap: () {},
                  label: context.tr.mapToStore,
                  icon: AppSvg(
                    assetName: AppAssets.locationSvg,
                    width: 18.r,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(1000.r),
                  borderColor: context.theme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  textStyle: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  spaceBetweenTextAndIcon: 7,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Text(
            'Employee’s Summary',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          5.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: context.customColor.text2,
            ),
            padding: EdgeInsets.all(10.r),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Total Cashiers:',
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Text(
                          branchInfo.totalCashiers.toString(),
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Delivery apps and sales aggregators:',
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Text(
                          branchInfo.totalAggregators.toString(),
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
