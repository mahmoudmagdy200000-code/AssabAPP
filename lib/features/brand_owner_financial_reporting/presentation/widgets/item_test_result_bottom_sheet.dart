import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/item_test_result_entity.dart';
import '../cubit/item_test_save_result_cubit.dart';
import '../cubit/item_test_save_result_state.dart';

class ItemTestResultBottomSheet extends StatelessWidget {
  final ItemTestResultEntity result;

  const ItemTestResultBottomSheet({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemTestSaveResultCubit, ItemTestSaveResultState>(
      listener: (context, state) {
        if (state is ItemTestSaveResultSuccess) {
          AppSnackBar.showSuccess(context, S.of(context).saveScenario);
        }
        if (state is ItemTestSaveResultFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      builder: (context, saveState) {
        final isLoading = saveState is ItemTestSaveResultLoading;

        return Scaffold(
          body: AppPaddingWidget(
            top: 30.r,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).testCompleted,
                          style: AppStyles.s16W500.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: const Color(0xff01F6F7)),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).testResults,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).profitMargin,
                                assetName: AppAssets.viewReports,
                                customWidget: Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          '${result.profitMargin.toStringAsFixed(1)}% ',
                                      style: AppStyles.s13W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '(',
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: result.profitMarginLabel,
                                          style: AppStyles.s13W500.copyWith(
                                            color: AppColors.lightGreen,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ')',
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedMonthlyProfit,
                                assetName: AppAssets.cash,
                                value: NumberFormat('#,##0').format(
                                  result.expectedMonthlyProfit,
                                ),
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedClassification,
                                assetName: AppAssets.star,
                                customWidget: Flexible(
                                  child: Text(
                                    result.expectedClassification,
                                    style: AppStyles.s13W500.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).menuImpact,
                                assetName: AppAssets.over,
                                value: result.menuImpact,
                              ),
                            ],
                          ),
                        ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).testData,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).date,
                                assetName: AppAssets.calendar,
                                value: result.date,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).branch,
                                assetName: AppAssets.branchStoreSvg,
                                value: result.branchName,
                              ),
                            ],
                          ),
                        ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).testItemData,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).itemName,
                                assetName: AppAssets.box,
                                value: result.itemName,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedSellingPrice,
                                assetName: AppAssets.wallet,
                                value: result.expectedSellingPrice
                                    .toStringAsFixed(0),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).productionCost,
                                assetName: AppAssets.expenseSvg,
                                value: result.productionCost.toStringAsFixed(1),
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedSales,
                                assetName: AppAssets.custody,
                                value: '${result.expectedSales} Pieces',
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedGrowth,
                                assetName: AppAssets.over,
                                value: '+${result.expectedGrowth.toStringAsFixed(0)}%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                isLoading
                    ? const AppLoadingWidget()
                    : ButtonTextIcon(
                        onTap: () {
                          context
                              .read<ItemTestSaveResultCubit>()
                              .saveResult(result);
                        },
                        label: S.of(context).saveScenario,
                        icon: AppSvg(
                          assetName: AppAssets.receipt,
                          width: 16.r,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text1,
                            BlendMode.srcIn,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        borderRadius: BorderRadius.circular(15.r),
                        spaceBetweenTextAndIcon: 7,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String assetName,
    String? value,
    bool showCurrency = false,
    Widget? customWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(
                assetName: assetName,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        ?customWidget,
        if (value != null && customWidget == null) ...[
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showCurrency) const SaudiRiyalSvgWidget(),
                3.horizontalSpace,
                Flexible(
                  child: Text(
                    value,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
