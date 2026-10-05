import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../cubit/get_branch_info/get_branch_info_cubit.dart';
import '../cubit/get_branch_info/get_branch_info_state.dart';

class CashierStoreBranchInfoBottomSheetWidget extends StatelessWidget {
  const CashierStoreBranchInfoBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.storeBranchInfo,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Text(
              context
                  .tr
                  .learnMoreAboutYourStoreBranchAndYourDailyWorkAssignments,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            BlocBuilder<GetBranchInfoCubit, GetBranchInfoState>(
              builder: (context, state) {
                if (state is GetBranchInfoLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetBranchInfoFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: () {
                      context.read<GetBranchInfoCubit>().getBranchInfo();
                    },
                    withBorder: false,
                  );
                }
                if (state is GetBranchInfoSuccess) {
                  final branch = state.branchInfo;

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(16.r),
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
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              color: context.customColor.reversedTextColor,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    AppNetworkImage(
                                      image: branch.image,
                                      height: 230.h,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    PositionedDirectional(
                                      bottom: 0,
                                      start: 0,
                                      child: Container(
                                        width: 250.w,
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                                bottomStart: Radius.circular(
                                                  20.r,
                                                ),
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
                                                '${branch.openingHours} - ${branch.closingHours}',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
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
                                ProfileImageWidget(
                                  image: branch.branchManager.image,
                                ),
                                10.verticalSpace,
                                Text(
                                  branch.branchManager.name,
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
                  );
                }

                return AppLocalFailure(
                  onRetry: () {
                    context.read<GetBranchInfoCubit>().getBranchInfo();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
