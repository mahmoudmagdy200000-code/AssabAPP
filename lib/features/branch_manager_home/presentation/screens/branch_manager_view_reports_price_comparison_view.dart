import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison/branch_manager_price_comparison_cubit.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison/branch_manager_price_comparison_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';
import '../widgets/branch_manager_view_reports_filter_price_comparison_bottom_sheet.dart';

class BranchManagerViewReportsPriceComparisonView extends StatelessWidget {
  const BranchManagerViewReportsPriceComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child:
                  BlocBuilder<
                    BranchManagerPriceComparisonCubit,
                    BranchManagerPriceComparisonState
                  >(
                    builder: (context, state) {
                      final count = switch (state) {
                        BranchManagerPriceComparisonSuccess(
                          comparisons: final c,
                        ) =>
                          c.length,
                        _ => 0,
                      };
                      return Text(
                        'Saved Data ($count)',
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      );
                    },
                  ),
            ),
            10.horizontalSpace,
            ButtonTextIcon(
              onTap: () {
                final priceComparisonCubit = context
                    .read<BranchManagerPriceComparisonCubit>();

                AppBottomSheet.customPageRoute(
                  context,
                  (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: priceComparisonCubit),
                      BlocProvider(
                        create: (_) => ValidationCubit(
                          requiredFields: {'sortBy', 'itemId', 'supplierId'},
                        ),
                      ),
                    ],
                    child:
                        const BranchManagerViewReportsFilterPriceComparisonBottomSheet(),
                  ),
                );
              },
              label: 'Filter data',
              icon: AppSvg(
                assetName: AppAssets.filter,
                colorFilter: ColorFilter.mode(
                  context.theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              borderRadius: BorderRadius.circular(1000.r),
              textColor: context.customColor.text3,
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            ),
          ],
        ),
        10.verticalSpace,
        Expanded(
          child:
              BlocBuilder<
                BranchManagerPriceComparisonCubit,
                BranchManagerPriceComparisonState
              >(
                builder: (context, state) {
                  return switch (state) {
                    BranchManagerPriceComparisonInit() =>
                      const SizedBox.shrink(),
                    BranchManagerPriceComparisonLoading() =>
                      const AppLoadingWidget(),
                    BranchManagerPriceComparisonSuccess(
                      comparisons: final comparisons,
                    )
                        when comparisons.isEmpty =>
                      const CustodyEmptyWidget(
                        asset: AppAssets.boxPNG,
                        title: 'No price comparisons found.',
                        desc:
                            'Price comparisons that you save will appear here.',
                      ),
                    BranchManagerPriceComparisonSuccess(
                      comparisons: final comparisons,
                    ) =>
                      Container(
                        decoration: BoxDecoration(
                          color: context.customColor.text2,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<BranchManagerPriceComparisonCubit>()
                                .loadPriceComparisons();
                          },
                          child: ListView.builder(
                            itemCount: comparisons.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final comparison = comparisons[index];

                              return AppGestureDetectorButton(
                                onTap: () {
                                  NavigationService.I.pushNamed(
                                    AppRouteName
                                        .branchManagerViewReportsPriceComparisonDetailsScreen,
                                    arguments: comparison.id.toString(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  margin: EdgeInsets.only(
                                    bottom: index < comparisons.length - 1
                                        ? 8.r
                                        : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      PurchaseItemImage(
                                        image: comparison.itemLogo,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comparison.itemName,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            Text(
                                              'Saved On: ${_formatDate(comparison.savedDate)}',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      AppSvg(
                                        assetName: AppAssets.arrowRight,
                                        colorFilter: ColorFilter.mode(
                                          context.customColor.text1,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    BranchManagerPriceComparisonFailure(:final failure) =>
                      AppFailureWidget(failure: failure),
                  };
                },
              ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
