import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../cubit/brand_owner_branches/brand_owner_branches_cubit.dart';
import '../cubit/brand_owner_branches/brand_owner_branches_state.dart';
import '../cubit/brand_owner_home/brand_owner_home_cubit.dart';

class BrandOwnerChoosBranchBottomSheet extends StatelessWidget {
  const BrandOwnerChoosBranchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Data',
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              'Select a store branch below to filter your dashboard data. This helps you view insights specific to each location.',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: BlocBuilder<BrandOwnerBranchesCubit, BrandOwnerBranchesState>(
                builder: (context, state) => switch (state) {
                  BrandOwnerBranchesInit() ||
                  BrandOwnerBranchesLoading() => const AppLoadingWidget(),
                  BrandOwnerBranchesFailure() => AppFailureWidget(
                    failure: state.failure,
                    onRetry: () =>
                        context.read<BrandOwnerBranchesCubit>().loadBranches(),
                  ),
                  BrandOwnerBranchesSuccess(:final branches) =>
                    branches.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSvg(
                                  assetName: AppAssets.branchStoreSvg,
                                  width: 60.r,
                                  colorFilter: ColorFilter.mode(
                                    context.customColor.text4,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                16.verticalSpace,
                                Text(
                                  'No branches found',
                                  style: AppStyles.s16W500.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: branches.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final branch = branches[index];

                              return AppGestureDetectorButton(
                                onTap: () {
                                  context
                                      .read<ValidationCubit>()
                                      .validateFieldAndStoreValue(
                                        fieldName: 'branchId',
                                        value: branch.id,
                                        isValid: true,
                                      );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.r,
                                    vertical: 10.r,
                                  ),
                                  margin: EdgeInsets.only(bottom: 10.r),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          AppSvg(
                                            assetName: AppAssets.branchStoreSvg,
                                            width: 18.r,
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              branch.name,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          BlocSelector<
                                            ValidationCubit,
                                            ValidationState,
                                            bool
                                          >(
                                            selector: (state) {
                                              return state
                                                      .fieldsValue['branchId'] ==
                                                  branch.id;
                                            },
                                            builder: (context, state) {
                                              return SelectionCircule(
                                                isSelected: state,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      10.verticalSpace,
                                      Stack(
                                        children: [
                                          AppNetworkImage(
                                            image: branch.imageUrl ?? '',
                                            height: 150.h,
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                          ),
                                          if (branch.openingHours != null)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .customColor
                                                      .reversedTextColor,
                                                  borderRadius:
                                                      BorderRadiusDirectional.only(
                                                        bottomStart:
                                                            Radius.circular(
                                                              15.r,
                                                            ),
                                                      ),
                                                  border: BorderDirectional(
                                                    bottom: BorderSide(
                                                      color: context
                                                          .customColor
                                                          .border,
                                                    ),
                                                    start: BorderSide(
                                                      color: context
                                                          .customColor
                                                          .border,
                                                    ),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.r,
                                                  vertical: 5.r,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    AppSvg(
                                                      assetName: AppAssets
                                                          .branchStoreSvg,
                                                      width: 15.r,
                                                    ),
                                                    5.horizontalSpace,
                                                    Flexible(
                                                      child: Text(
                                                        '${context.tr.opens}: ${branch.openingHours}',
                                                        style: AppStyles.s13W500
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
                                        borderRadius: BorderRadius.circular(
                                          1000.r,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.r,
                                        ),
                                        textStyle: AppStyles.s13W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                        spaceBetweenTextAndIcon: 7,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                },
              ),
            ),
            10.verticalSpace,
            BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) {
                return state.fieldsValidity['branchId'] == true;
              },
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    NavigationService.I.pop();

                    context.read<BrandOwnerHomeCubit>().loadDashboard(
                      branchId: context.read<ValidationCubit>().getFieldValue(
                        'branchId',
                      ),
                      month: context.read<ValidationCubit>().getTypedValue<int>(
                        'month',
                      ),
                      year: context.read<ValidationCubit>().getTypedValue<int>(
                        'year',
                      ),
                    );
                  },
                  text: 'Sort Data',
                  borderRadius: BorderRadius.circular(15.r),
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  enabled: state,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
