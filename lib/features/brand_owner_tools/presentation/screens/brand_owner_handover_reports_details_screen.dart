import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/time_lines_view.dart';
import '../cubit/brand_owner_handover_reports_details/brand_owner_handover_reports_details_cubit.dart';
import '../cubit/brand_owner_handover_reports_details/brand_owner_handover_reports_details_state.dart';
import '../cubit/brand_owner_fixed_assets_requests/brand_owner_fixed_assets_requests_cubit.dart';
import 'brand_owner_handover_details_details_screen_details_view.dart';

class BrandOwnerHandoverReportsDetailsScreen extends StatelessWidget {
  final String requestId;

  const BrandOwnerHandoverReportsDetailsScreen({
    super.key,
    required this.requestId,
  });

  List<String> tabTitles(BuildContext context) => [
    context.tr.details,
    context.tr.timelines,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      BrandOwnerHandoverReportsDetailsCubit,
      BrandOwnerHandoverReportsDetailsState
    >(
      listenWhen: (previous, current) =>
          current is BrandOwnerHandoverReportsDetailsActionSuccess ||
          current is BrandOwnerHandoverReportsDetailsActionFailure,
      listener: (context, state) {
        if (state is BrandOwnerHandoverReportsDetailsActionSuccess) {
          AppSnackBar.showSuccess(
            context,
            state.isSalaryDeduction ? 'Salary Deducted' : context.tr.approved,
          );
          context
              .read<BrandOwnerFixedAssetsRequestsCubit>()
              .getHandoverReportsRequests();
        } else if (state is BrandOwnerHandoverReportsDetailsActionFailure) {
          AppSnackBar.showError(context, state.failure.error.getErrorMessage);
        }
      },
      builder: (context, state) {
        if (state is BrandOwnerHandoverReportsDetailsInitial ||
            state is BrandOwnerHandoverReportsDetailsLoading) {
          return Scaffold(
            backgroundColor: context.customColor.text2,
            body: const AppLoadingWidget(),
          );
        }

        if (state is BrandOwnerHandoverReportsDetailsFailure) {
          return Scaffold(
            backgroundColor: context.customColor.text2,
            body: AppFailureWidget(
              failure: state.failure,
              onRetry: () => context
                  .read<BrandOwnerHandoverReportsDetailsCubit>()
                  .load(requestId: requestId),
            ),
          );
        }

        final details = switch (state) {
          BrandOwnerHandoverReportsDetailsSuccess(:final details) => details,
          BrandOwnerHandoverReportsDetailsActionLoading(:final details) =>
            details,
          BrandOwnerHandoverReportsDetailsActionSuccess(:final details) =>
            details,
          BrandOwnerHandoverReportsDetailsActionFailure(:final details) =>
            details,
          _ => null,
        };

        if (details == null) {
          return Scaffold(
            backgroundColor: context.customColor.reversedTextColor,
            body: const AppLoadingWidget(),
          );
        }

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
                            'Review Major Discrepancies',
                            style: AppStyles.s16W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          Text(
                            'View details, timelines, and statuses.',
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      BlocSelector<PagingCubit, PagingState, int>(
                        selector: (state) => state.currentIndex,
                        builder: (context, currentIndex) {
                          return ContainerCustomTextField(
                            padding: EdgeInsets.all(6.r),
                            borderRadius: BorderRadius.circular(1000.r),
                            borderColor: Colors.transparent,
                            child: Row(
                              children: List.generate(
                                tabTitles(context).length,
                                (index) {
                                  return Expanded(
                                    child: CustomTextButton(
                                      text: tabTitles(context)[index],
                                      onTap: () => context
                                          .read<PagingCubit>()
                                          .goToStep(index),
                                      backgroundColor: currentIndex == index
                                          ? context
                                                .customColor
                                                .reversedTextColor
                                          : Colors.transparent,
                                      borderColor: Colors.transparent,
                                      textColor: currentIndex == index
                                          ? context.customColor.text1
                                          : context.customColor.text3,
                                      borderRadius: 1000.r,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      10.verticalSpace,
                      Expanded(
                        child: BlocSelector<PagingCubit, PagingState, int>(
                          selector: (state) => state.currentIndex,
                          builder: (context, currentIndex) {
                            return IndexedStack(
                              index: currentIndex,
                              children: [
                                BrandOwnerHandoverDetailsDetailsScreenDetailsView(
                                  details: details,
                                  isActionLoading:
                                      state
                                          is BrandOwnerHandoverReportsDetailsActionLoading,
                                  onWrittenWarning: (warningNote) => context
                                      .read<
                                        BrandOwnerHandoverReportsDetailsCubit
                                      >()
                                      .approve(
                                        requestId: requestId,
                                        warningNote: warningNote,
                                      ),
                                  onSalaryDeduction: (amount, reason) => context
                                      .read<
                                        BrandOwnerHandoverReportsDetailsCubit
                                      >()
                                      .salaryDeduction(
                                        requestId: requestId,
                                        amount: amount,
                                        reason: reason,
                                      ),
                                ),
                                TimeLinesView(
                                  timelines: details.timelines.timelines,
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
      },
    );
  }
}
