import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
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
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/item_test_saved_test_entity.dart';
import '../cubit/item_test_saved_test_details_cubit.dart';
import '../cubit/item_test_saved_test_details_state.dart';
import 'brand_owner_financial_reporting_exports_buttons.dart';

class ItemTestSavedTestDetailsBottomSheet extends StatelessWidget {
  final ItemTestSavedTestEntity test;

  const ItemTestSavedTestDetailsBottomSheet({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final result = test.details;

    return BlocConsumer<
      ItemTestSavedTestDetailsCubit,
      ItemTestSavedTestDetailsState
    >(
      listener: (context, state) {
        switch (state) {
          case ItemTestSavedTestDetailsExportSuccess():
            AppSnackBar.showSuccess(context, 'Test exported successfully');
            getIt<DownloadService>().downloadFile(
              url: state.url,
              fileName: state.url.split('/').last,
            );
          case ItemTestSavedTestDetailsExportFailure(:final failure):
            AppDialog.showErrorDialog(context: context, failure: failure);
          case ItemTestSavedTestDetailsEmailSuccess():
            AppSnackBar.showSuccess(
              context,
              S.of(context).reportSentToEmailSuccessfully,
            );
          case ItemTestSavedTestDetailsEmailFailure(:final failure):
            AppDialog.showErrorDialog(context: context, failure: failure);
          default:
            break;
        }
      },
      builder: (context, detailsState) {
        final isExporting = detailsState is ItemTestSavedTestDetailsExporting;
        final isEmailing = detailsState is ItemTestSavedTestDetailsEmailing;
        final isBusy = isExporting || isEmailing;

        return Scaffold(
          body: AppPaddingWidget(
            top: 0,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.receipt,
                              width: 20.r,
                              colorFilter: ColorFilter.mode(
                                context.theme.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            10.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).savedTestResult,
                                style: AppStyles.s16W500.copyWith(
                                  color: context.theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff01F6F7)),
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
                                value: NumberFormat(
                                  '#,##0',
                                ).format(result.expectedMonthlyProfit),
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
                                value:
                                    '+${result.expectedGrowth.toStringAsFixed(0)}%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                if (isBusy)
                  const AppLoadingWidget()
                else
                  BrandOwnerFinancialReportingExportsButtons(
                    pdf: () {
                      context.read<ItemTestSavedTestDetailsCubit>().exportPdf(
                        testId: test.id,
                      );
                    },
                    excel: () {
                      context.read<ItemTestSavedTestDetailsCubit>().exportExcel(
                        testId: test.id,
                      );
                    },
                    email: (emailAddress) {
                      NavigationService.I.pop();
                      context.read<ItemTestSavedTestDetailsCubit>().sendEmail(
                        testId: test.id,
                        email: emailAddress,
                      );
                    },
                    showText: false,
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
