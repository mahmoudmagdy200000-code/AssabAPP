import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';
import 'package:assab/features/purchase/presentation/widgets/custom_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/compare_price/compare_price_cubit.dart';
import '../cubit/compare_price/compare_price_state.dart';
import '../cubit/save_compare_price/save_compare_price_cubit.dart';
import '../cubit/save_compare_price/save_compare_price_state.dart';
import '../widgets/compare_price_additional_factors_section.dart';
import '../widgets/compare_price_benefits_analysis_section.dart';
import '../widgets/compare_price_detailed_comparison_section.dart';
import '../widgets/compare_price_smart_recommendation_section.dart';

class ComparePricesScreen extends StatefulWidget {
  final String itemId;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final PurchaseBranchItemData item;
  final int quantity;
  final String addedItemMainId;

  const ComparePricesScreen({
    super.key,
    required this.itemId,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.item,
    required this.quantity,
    required this.addedItemMainId,
  });

  @override
  State<ComparePricesScreen> createState() => _ComparePricesScreenState();
}

class _ComparePricesScreenState extends State<ComparePricesScreen> {
  @override
  void initState() {
    super.initState();

    _comparePrices();
  }

  void _comparePrices() {
    context.read<ComparePriceCubit>().comparePrices(itemId: widget.itemId);
  }

  void _useRecommendation(
    PurchaseComparePriceResponseUseRecommendation? useRecommendation,
  ) {
    if (useRecommendation != null) {
      PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(useRecommendation.sourceType),
      ).useRecommendedSource(
        context,
        useRecommendation,
        widget.sourceTypeFieldName,
        widget.sourceIdFieldName,
        widget.sourceNameFieldName,
        widget.choosedSourceItemIdFieldName,
        widget.itemId,
        widget.item,
        widget.quantity,
        widget.addedItemMainId,
      );
    } else {
      AppSnackBar.showSuccess(context, context.tr.noSourceToChoose);
    }
  }

  void _saveComparison() {
    context.read<SaveComparePriceCubit>().saveComparePrices(id: widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: BlocListener<SaveComparePriceCubit, SaveComparePriceState>(
          listenWhen: (previous, current) =>
              current is SaveComparePriceSuccess ||
              current is SaveComparePriceFailure,
          listener: (context, state) {
            if (state is SaveComparePriceSuccess) {
              AppSnackBar.showSuccess(context, 'Comparison saved successfully');
              NavigationService.I.pop();
            } else if (state is SaveComparePriceFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          child: BlocBuilder<ComparePriceCubit, ComparePriceState>(
            builder: (context, state) {
              PurchaseComparePriceResponse? comparePriceResponse;

              if (state is ComparePriceLoading) {
                return const AppLoadingWidget();
              } else if (state is ComparePriceFailure) {
                return AppFailureWidget(
                  failure: state.failure,
                  withBorder: false,
                  onRetry: _comparePrices,
                );
              } else if (state is ComparePriceSuccess) {
                comparePriceResponse = state.comparePriceResponse;
              }

              if (comparePriceResponse == null) {
                return AppLocalFailure(
                  withBorder: false,
                  onRetry: _comparePrices,
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.comparePrices,
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          8.verticalSpace,
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
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                _buildComparePriceRow(
                                  context,
                                  context.tr.product,
                                  comparePriceResponse.data.itemName,
                                ),
                                4.verticalSpace,
                                const CustomDivider(),
                                4.verticalSpace,
                                _buildComparePriceRow(
                                  context,
                                  context.tr.quantity,
                                  '${comparePriceResponse.data.quantity} ${comparePriceResponse.data.itemUnit}',
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
                                CustomChartWidget(
                                  priceTrends:
                                      comparePriceResponse.data.priceTrends,
                                ),
                              ],
                            ),
                          ),
                          14.verticalSpace,
                          ComparePriceDetailedComparisonSection(
                            comparePriceResponse: comparePriceResponse,
                          ),
                          14.verticalSpace,
                          ComparePriceBenefitsAnalysisSection(
                            comparePriceResponse: comparePriceResponse,
                          ),
                          14.verticalSpace,
                          ComparePriceAdditionalFactorsSection(
                            factors: comparePriceResponse.data.factors,
                          ),
                          14.verticalSpace,
                          const ComparePriceSmartRecommendationSection(),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child:
                            BlocBuilder<
                              SaveComparePriceCubit,
                              SaveComparePriceState
                            >(
                              buildWhen: (previous, current) =>
                                  current is SaveComparePriceLoading ||
                                  current is SaveComparePriceSuccess,
                              builder: (context, saveState) {
                                if (saveState is SaveComparePriceLoading) {
                                  return const AppButtonLoading();
                                }

                                return CustomTextButton(
                                  text: context.tr.saveComparison,
                                  onTap: () {
                                    _saveComparison();
                                  },
                                  padding: EdgeInsets.symmetric(
                                    vertical: 18.r,
                                    horizontal: 10.r,
                                  ),
                                );
                              },
                            ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: AppButton(
                          onClick: () => _useRecommendation(
                            comparePriceResponse!.data.useRecommendation,
                          ),
                          enabled: true,
                          text: context.tr.useRecommendation,
                          borderRadius: BorderRadius.circular(12.r),
                          padding: EdgeInsets.symmetric(
                            vertical: 18.r,
                            horizontal: 10.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
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
