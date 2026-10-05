import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../brand_owner_reports_and_analytics/presentation/cubit/brand_owner_reports_and_analytics_cubit.dart';
import '../cubit/branch_manager_price_comparison/branch_manager_price_comparison_cubit.dart';
import 'branch_manager_view_reports_monthly_reports_view.dart';
import 'branch_manager_view_reports_price_comparison_view.dart';

class BranchManagerViewReportsScreen extends StatelessWidget {
  const BranchManagerViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        context.tr.reportsAndAnalytics,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      Text(
                        'View expense trends, supplier & branch insights',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                  ContainerCustomTextField(
                    padding: EdgeInsets.all(6.r),
                    borderRadius: BorderRadius.circular(1000.r),
                    child: Row(
                      children: List.generate(2, (index) {
                        return Expanded(
                          child: BlocSelector<PagingCubit, PagingState, bool>(
                            selector: (state) {
                              return state.currentIndex == index;
                            },
                            builder: (context, state) {
                              final texts = [
                                'Monthly Reports',
                                'Price Comparison',
                              ];
                              return CustomTextButton(
                                text: texts[index],
                                onTap: () {
                                  context.read<PagingCubit>().goToStep(index);
                                },
                                textColor: state
                                    ? context.customColor.text1
                                    : context.customColor.text3,
                                backgroundColor: state
                                    ? context.customColor.reversedTextColor
                                    : Colors.transparent,
                                borderRadius: 1000.r,
                                borderColor: Colors.transparent,
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) {
                        return state.currentIndex;
                      },
                      builder: (context, index) {
                        return IndexedStack(
                          index: index,
                          children: [
                            BlocProvider(
                              create: (context) =>
                                  getIt<BrandOwnerReportsAndAnalyticsCubit>()
                                    ..loadReportsAndAnalytics(),
                              child:
                                  const BranchManagerViewReportsMonthlyReportsView(),
                            ),
                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) =>
                                      getIt<BranchManagerPriceComparisonCubit>()
                                        ..loadPriceComparisons(),
                                ),
                                BlocProvider(
                                  create: (context) => ValidationCubit(
                                    requiredFields: {
                                      'sortBy',
                                      'itemId',
                                      'supplierId',
                                    },
                                  ),
                                ),
                              ],
                              child:
                                  const BranchManagerViewReportsPriceComparisonView(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
