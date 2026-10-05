import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/inventory/presentation/cubit/get_monthly_details/get_monthly_details_state.dart';
import 'package:assab/features/inventory/presentation/cubit/submit_monthly_inventory/submit_monthly_inventory_cubit.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/get_monthly_details/get_monthly_details_cubit.dart';
import '../cubit/submit_monthly_inventory/submit_monthly_inventory_state.dart';
import 'monthly_inventory_completed_screen.dart';

class MonthlyInventorySummaryScreen extends StatelessWidget {
  final String id;

  const MonthlyInventorySummaryScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.monthlyRegularInventory,
            subtitle: context.tr.simplifiedMonthlyInventoryCount,
          ),
          20.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: BlocBuilder<GetMonthlyDetailsCubit, GetMonthlyDetailsState>(
                builder: (context, state) {
                  if (state is GetMonthlyDetailsLoading) {
                    return const AppLoadingWidget();
                  } else if (state is GetMonthlyDetailsFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () {
                        context
                            .read<GetMonthlyDetailsCubit>()
                            .getMonthlyDetails(id: id);
                      },
                      withBorder: false,
                    );
                  } else if (state is GetMonthlyDetailsSuccess) {
                    final data = state.response.data;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        context.tr.inventoryComplete,
                                        style: AppStyles.s20W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      data.timeTakenSeconds.toString(),
                                      style: AppStyles.s13W600.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    AppSvg(
                                      assetName: AppAssets.clockSvg,
                                      width: 14.r,
                                      height: 14.r,
                                    ),
                                  ],
                                ),
                                16.verticalSpace,
                                Text(
                                  context
                                      .tr
                                      .youCanSaveAsADraftOrSubmitNowForReview,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                12.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color: context.customColor.text2,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context.tr.inventorySummary,
                                              style: AppStyles.s16W600.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            8.verticalSpace,
                                            const CustomDivider(),
                                            8.verticalSpace,
                                            _buildInventorySummaryRow(
                                              context: context,
                                              icon: AppAssets.box,
                                              label: context
                                                  .tr
                                                  .allProductsComplete,
                                              value: Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      data.inventoriedCount
                                                          .toString(),
                                                      style: AppStyles.s13W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text1,
                                                          ),
                                                    ),
                                                    Text(
                                                      '/${data.productsCount}',
                                                      style: AppStyles.s13W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                    ),
                                                    3.horizontalSpace,
                                                    Text(
                                                      '(${data.inventoriedCount / data.productsCount * 100}%)',
                                                      style: AppStyles.s13W500
                                                          .copyWith(
                                                            color: AppColors
                                                                .lightGreen,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            10.verticalSpace,
                                            _buildInventorySummaryRow(
                                              context: context,
                                              icon: AppAssets.timer,
                                              label: context.tr.timeTaken,
                                              value: Text(
                                                data.timeTaken ?? '-',
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ),
                                            10.verticalSpace,
                                            _buildInventorySummaryRow(
                                              context: context,
                                              icon: AppAssets.timer,
                                              label: context
                                                  .tr
                                                  .numberOfParticipants,
                                              value: Text(
                                                '${data.staff.length} ${context.tr.staff}',
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ),
                                            10.verticalSpace,
                                            _buildInventorySummaryRow(
                                              context: context,
                                              icon: AppAssets.timer,
                                              label:
                                                  '${context.tr.inventoryStatus}:',
                                              value: Text(
                                                data.inventoriedCount ==
                                                        data.productsCount
                                                    ? context
                                                          .tr
                                                          .successfullyCompleted
                                                    : context.tr.inProgress,
                                                style: AppStyles.s13W500.copyWith(
                                                  color:
                                                      data.inventoriedCount ==
                                                          data.productsCount
                                                      ? AppColors.lightGreen
                                                      : AppColors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      12.verticalSpace,
                                      Text(
                                        context.tr.teamContribution,
                                        style: AppStyles.s16W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      12.verticalSpace,
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.r),
                                        child: Column(
                                          children: List.generate(
                                            data.staff.length,
                                            (index) {
                                              final staff = data.staff[index];
                                              return Column(
                                                children: [
                                                  _buildTeamContributionWidget(
                                                    context: context,
                                                    name: staff.name,
                                                    value:
                                                        '${staff.productsCounted} ${context.tr.products}',
                                                  ),
                                                  if (index !=
                                                      data.staff.length -
                                                          1) ...[
                                                    10.verticalSpace,
                                                    const CustomDivider(),
                                                    10.verticalSpace,
                                                  ],
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      12.verticalSpace,
                                      Text(
                                        context.tr.inventoriedProducts(
                                          data.inventoriedCount,
                                        ),
                                        style: AppStyles.s16W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      12.verticalSpace,
                                      ListView.builder(
                                        itemCount: data.products.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final product = data.products[index];

                                          return Container(
                                            decoration: BoxDecoration(
                                              color: context
                                                  .customColor
                                                  .reversedTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                            padding: EdgeInsets.all(16.r),
                                            margin: EdgeInsets.only(
                                              bottom: 8.r,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    PurchaseItemImage(
                                                      image: product.itemLogo,
                                                    ),
                                                    10.horizontalSpace,
                                                    Flexible(
                                                      child: Text(
                                                        product.itemName,
                                                        style: AppStyles.s14W400
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text1,
                                                            ),
                                                      ),
                                                    ),
                                                    // const Spacer(),
                                                    // AppSvgButton(
                                                    //   assetName:
                                                    //       AppAssets.offEye,
                                                    //   onTap: () {},
                                                    //   iconColor: context
                                                    //       .customColor
                                                    //       .text3,
                                                    //   iconSize: 14.r,
                                                    //   padding: EdgeInsets.all(
                                                    //     5.r,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                10.verticalSpace,
                                                const CustomDivider(),
                                                10.verticalSpace,
                                                _buildInventorySummaryRow(
                                                  context: context,
                                                  icon: AppAssets.box,
                                                  label:
                                                      '${context.tr.quantity}:',
                                                  value: Text(
                                                    '${product.quantityInventory} ${product.unit}',
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
                                          );
                                        },
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.r),
                                        child: Column(
                                          children: [
                                            Text(
                                              context.tr.totalInventoryValue,
                                              style: AppStyles.s12W500.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                            5.verticalSpace,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SaudiRiyalSvgWidget(),
                                                Text(
                                                  data.products
                                                      .map(
                                                        (e) =>
                                                            e.unitPrice *
                                                            e.quantityInventory,
                                                      )
                                                      .reduce((a, b) => a + b)
                                                      .toStringAsFixed(2),
                                                  style: AppStyles.s20W600
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        BlocConsumer<
                          SubmitMonthlyInventoryCubit,
                          SubmitMonthlyInventoryState
                        >(
                          listener: (context, state) {
                            if (state is SubmitMonthlyInventorySuccess) {
                              NavigationService.I.popUntil(
                                (p1) =>
                                    p1.settings.name ==
                                    AppRouteName.inventoryScreen,
                              );

                              NavigationService.I.push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MonthlyInventoryCompletedScreen(),
                                ),
                              );
                            } else if (state is SubmitMonthlyInventoryFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is SubmitMonthlyInventoryLoading) {
                              return const AppLoadingWidget();
                            }

                            return CustomTextButton(
                              text: context.tr.send,
                              onTap: () {
                                context
                                    .read<SubmitMonthlyInventoryCubit>()
                                    .submitMonthlyInventory(inventoryId: id);
                              },
                              backgroundColor: context.theme.primaryColor,
                              textColor: context.customColor.reversedTextColor,
                              padding: EdgeInsets.symmetric(vertical: 18.r),
                              borderRadius: 16.r,
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return AppLocalFailure(
                    onRetry: () {
                      context.read<GetMonthlyDetailsCubit>().getMonthlyDetails(
                        id: id,
                      );
                    },
                    withBorder: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySummaryRow({
    required BuildContext context,
    required String icon,
    required String label,
    Widget? value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        AppSvg(
          assetName: icon,
          width: 14.w,
          height: 14.h,
          colorFilter: ColorFilter.mode(
            iconColor ?? context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
        8.horizontalSpace,
        ?value,
      ],
    );
  }

  Widget _buildTeamContributionWidget({
    required BuildContext context,
    required String name,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            5.horizontalSpace,
            Text(
              value,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
        5.horizontalSpace,
        _buildInventorySummaryRow(
          context: context,
          icon: AppAssets.star,
          iconColor: AppColors.orange,
          label: context.tr.excellentPerformance,
        ),
      ],
    );
  }
}
