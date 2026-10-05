import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/sales_channel_level2_entity.dart';
import '../cubit/sales_channel_level2_cubit.dart';
import '../cubit/sales_channel_level2_state.dart';

class BrandOwnerSalesChannelLevel2Screen extends StatefulWidget {
  const BrandOwnerSalesChannelLevel2Screen({super.key});

  @override
  State<BrandOwnerSalesChannelLevel2Screen> createState() =>
      _BrandOwnerSalesChannelLevel2ScreenState();
}

class _BrandOwnerSalesChannelLevel2ScreenState
    extends State<BrandOwnerSalesChannelLevel2Screen> {
  @override
  void initState() {
    super.initState();
    context.read<SalesChannelLevel2Cubit>().loadSalesChannelLevel2();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesChannelLevel2Cubit, SalesChannelLevel2State>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.primaryColor,
          body: Column(
            children: [
              AppPaddingWidget(
                top: 30.r,
                child: Row(
                  children: [
                    const AppBackButton(isTransparent: true),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).salesChannelsLevel2,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            switch (state) {
                              SalesChannelLevel2Success(:final data) =>
                                S.of(context).overallPerformanceBreakdown(
                                  data.monthName,
                                ),
                              _ =>
                                S.of(context).overallPerformanceBreakdown(''),
                            },
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: Icons.refresh,
                      onPressed: () {
                        if (state is SalesChannelLevel2Loading) return;
                        context
                            .read<SalesChannelLevel2Cubit>()
                            .loadSalesChannelLevel2();
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: context.customColor.reversedTextColor,
                      borderColor: context.customColor.reversedTextColor,
                      borderRadius: 12.r,
                      padding: 10.r,
                      size: 16.r,
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: Icons.close,
                      onPressed: () => NavigationService.I.pop(),
                      backgroundColor: Colors.transparent,
                      iconColor: context.customColor.reversedTextColor,
                      borderColor: context.customColor.reversedTextColor,
                      borderRadius: 12.r,
                      padding: 10.r,
                      size: 16.r,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: switch (state) {
                    SalesChannelLevel2Initial() => const SizedBox.shrink(),
                    SalesChannelLevel2Loading() => const AppLoadingWidget(),
                    SalesChannelLevel2Success(
                      :final data,
                      :final branchId,
                    ) =>
                      _buildContent(context, data, branchId),
                    SalesChannelLevel2Failure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<SalesChannelLevel2Cubit>()
                            .loadSalesChannelLevel2(),
                      ),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    SalesChannelLevel2Entity data,
    String? branchId,
  ) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              Text(
                S.of(context).countSalesChanelsRecorded(
                  data.totalCount.toString(),
                ),
                style: AppStyles.s16W500.copyWith(
                  color: context.customColor.text1,
                ),
              ).sliverBoxAdapter,
              12.verticalSpace.sliverBoxAdapter,
              SliverList.builder(
                itemCount: data.items.length,
                itemBuilder: (context, index) {
                  final item = data.items[index];
                  final isLast = index == data.items.length - 1;

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 10.r),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppNetworkImage(
                              image: item.image,
                              borderRadius: BorderRadius.circular(8.r),
                              width: 50.r,
                              height: 50.r,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item.name,
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SaudiRiyalSvgWidget(),
                                            5.horizontalSpace,
                                            Flexible(
                                              child: Text(
                                                item.salesAmount
                                                    .toStringAsFixed(0),
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                  color: context
                                                      .theme.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            AppSvg(
                                              assetName: AppAssets.redShort,
                                              width: 16.r,
                                              colorFilter: ColorFilter.mode(
                                                item.isPositive
                                                    ? AppColors.lightGreen
                                                    : AppColors.red,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: Text(
                                                '${item.isPositive ? '+' : ''}${item.percentageChange.toStringAsFixed(0)}%',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                  color: item.isPositive
                                                      ? AppColors.lightGreen
                                                      : AppColors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: Text(
                                          item.comparisonText.toUpperCase(),
                                          style: AppStyles.s12W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        const CustomDivider(),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                context,
                                label: S.of(context).appcommissions,
                                amount: item.commissionAmount
                                    .toStringAsFixed(0),
                                percentage:
                                    '${item.commissionPercentage.toStringAsFixed(0)}%',
                              ),
                              15.verticalSpace,
                              _buildDetailRow(
                                context,
                                label: S.of(context).profitability,
                                amount: item.profitabilityAmount
                                    .toStringAsFixed(0),
                                percentage:
                                    '${item.profitabilityPercentage.toStringAsFixed(0)}%',
                              ),
                              15.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      S.of(context).orderCount,
                                      style: AppStyles.s13W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.orderCount.toString(),
                                            style: AppStyles.s13W500.copyWith(
                                              color:
                                                  context.customColor.text1,
                                            ),
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        Flexible(
                                          child: Text(
                                            S.of(context).orders,
                                            style: AppStyles.s12W400.copyWith(
                                              color:
                                                  context.customColor.text3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              15.verticalSpace,
                              _buildDetailRow(
                                context,
                                label: S.of(context).averageOrderValue,
                                amount: item.averageOrderValue
                                    .toStringAsFixed(0),
                                showPercentage: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
      ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String amount,
    String? percentage,
    bool showPercentage = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(
              color: context.customColor.text3,
            ),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SaudiRiyalSvgWidget(),
              3.horizontalSpace,
              Flexible(
                child: Text(
                  amount,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              if (showPercentage && percentage != null) ...[
                3.horizontalSpace,
                Flexible(
                  child: Text(
                    percentage,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
