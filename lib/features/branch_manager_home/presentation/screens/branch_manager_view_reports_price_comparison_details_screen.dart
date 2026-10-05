import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_cubit.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_state.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison_details/branch_manager_price_comparison_details_cubit.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison_details/branch_manager_price_comparison_details_state.dart';
import 'package:assab/features/branch_manager_home/presentation/widgets/branch_manager_view_reports_export_price_comparison_bottom_sheet.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';
import 'package:assab/features/purchase/presentation/widgets/compare_price_additional_factors_section.dart';
import 'package:assab/features/purchase/presentation/widgets/compare_price_benefits_analysis_section.dart';
import 'package:assab/features/purchase/presentation/widgets/compare_price_detailed_comparison_section.dart';
import 'package:assab/features/purchase/presentation/widgets/compare_price_smart_recommendation_section.dart';
import 'package:assab/features/purchase/presentation/widgets/custom_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../cubit/branch_manager_create_order_with_recommended_source/branch_manager_create_order_with_recommended_source_cubit.dart';
import '../cubit/branch_manager_create_order_with_recommended_source/branch_manager_create_order_with_recommended_source_state.dart';

class BranchManagerViewReportsPriceComparisonDetailsScreen
    extends StatelessWidget {
  final String comparisonId;

  const BranchManagerViewReportsPriceComparisonDetailsScreen({
    super.key,
    required this.comparisonId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<BranchManagerPriceComparisonDetailsCubit>()
                ..loadDetails(comparisonId: comparisonId),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compare Prices',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Saved On: -',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  ButtonTextIcon(
                    onTap: () {
                      AppBottomSheet.customPageRoute(
                        context,
                        (context) => BlocProvider(
                          create: (context) =>
                              getIt<BranchManagerExportPriceComparisonCubit>(),
                          child: BlocProvider(
                            create: (context) =>
                                ValidationCubit(requiredFields: {'formatType'}),
                            child:
                                BranchManagerViewReportsExportPriceComparisonBottomSheet(
                                  comparisonId: comparisonId,
                                ),
                          ),
                        ),
                      );
                    },
                    label: context.tr.exportLabel,
                    icon: AppSvg(
                      assetName: AppAssets.download,
                      width: 14.r,
                      colorFilter: ColorFilter.mode(
                        context.theme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    textStyle: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 8.r,
                    ),
                    backgroundColor: context.customColor.reversedTextColor,
                    borderColor: Colors.transparent,
                    reversed: true,
                    borderRadius: BorderRadius.circular(8.r),
                    spaceBetweenTextAndIcon: 7,
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  BlocBuilder<
                    BranchManagerPriceComparisonDetailsCubit,
                    BranchManagerPriceComparisonDetailsState
                  >(
                    builder: (context, state) {
                      return switch (state) {
                        BranchManagerPriceComparisonDetailsLoading() =>
                          const AppLoadingWidget(),
                        BranchManagerPriceComparisonDetailsSuccess(
                          response: final response,
                        ) =>
                          _buildDetailsContent(context, response),
                        BranchManagerPriceComparisonDetailsFailure(
                          :final failure,
                        ) =>
                          AppFailureWidget(
                            failure: failure,
                            onRetry: () {
                              context
                                  .read<
                                    BranchManagerPriceComparisonDetailsCubit
                                  >()
                                  .loadDetails(comparisonId: comparisonId);
                            },
                          ),
                        _ => const SizedBox(),
                      };
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    PurchaseComparePriceResponse response,
  ) {
    final data = response.data;

    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context
                        .tr
                        .compareSourcesInRealtimeToChooseTheMostCosteffectiveOption,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: context.customColor.border),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        _buildComparePriceRow(
                          context,
                          context.tr.product,
                          data.itemName,
                        ),
                        4.verticalSpace,
                        const CustomDivider(),
                        4.verticalSpace,
                        _buildComparePriceRow(
                          context,
                          context.tr.quantity,
                          '${data.quantity} ${data.itemUnit}',
                        ),
                        4.verticalSpace,
                        const CustomDivider(),
                        4.verticalSpace,
                        _buildComparePriceRow(
                          context,
                          context.tr.period,
                          context.tr.last3Months,
                        ),
                        12.verticalSpace,
                        CustomChartWidget(priceTrends: data.priceTrends),
                      ],
                    ),
                  ),
                  14.verticalSpace,
                  ComparePriceDetailedComparisonSection(
                    comparePriceResponse: response,
                  ),
                  14.verticalSpace,
                  ComparePriceBenefitsAnalysisSection(
                    comparePriceResponse: response,
                  ),
                  14.verticalSpace,
                  ComparePriceAdditionalFactorsSection(factors: data.factors),
                  14.verticalSpace,
                  const ComparePriceSmartRecommendationSection(),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          BlocListener<
            BranchManagerCreateOrderWithRecommendedSourceCubit,
            BranchManagerCreateOrderWithRecommendedSourceState
          >(
            listener: (context, state) {
              if (state
                  is BranchManagerCreateOrderWithRecommendedSourceSuccess) {
                AppSnackBar.showSuccess(context, 'Order created successfully');
              } else if (state
                  is BranchManagerCreateOrderWithRecommendedSourceFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            child:
                BlocBuilder<
                  BranchManagerCreateOrderWithRecommendedSourceCubit,
                  BranchManagerCreateOrderWithRecommendedSourceState
                >(
                  builder: (context, state) {
                    if (state
                        is BranchManagerCreateOrderWithRecommendedSourceLoading) {
                      return const AppButtonLoading();
                    }
                    return CustomTextButton(
                      text: 'Create Order with recommended source',
                      onTap: () {
                        context
                            .read<
                              BranchManagerCreateOrderWithRecommendedSourceCubit
                            >()
                            .createOrderWithRecommendedSource(id: comparisonId);
                      },
                      padding: EdgeInsets.symmetric(
                        vertical: 18.r,
                        horizontal: 10.r,
                      ),
                      backgroundColor: context.theme.primaryColor,
                      textColor: context.customColor.reversedTextColor,
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparePriceRow(
    BuildContext context,
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
