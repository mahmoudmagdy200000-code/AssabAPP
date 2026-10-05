import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/custody/presentation/cubit/get_custody_details/get_custody_details_cubit.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/get_custody_details/get_custody_details_state.dart';
import 'custody_request_details_screen_approval_view.dart';
import 'custody_request_details_screen_details_view.dart';

class CustodyRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;

  const CustodyRequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.userTypeStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<GetCustodyDetailsCubit>()
            ..getRequestDetails(requestId: requestId),
      child: _CustodyRequestDetailsScreen(
        requestId: requestId,
        userTypeStrategy: userTypeStrategy,
      ),
    );
  }
}

class _CustodyRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;

  const _CustodyRequestDetailsScreen({
    required this.requestId,
    required this.userTypeStrategy,
  });

  void _getRequestDetails(BuildContext context) {
    context.read<GetCustodyDetailsCubit>().getRequestDetails(
      requestId: requestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          10.verticalSpace,
          CustodyAppBar(
            title: context.tr.custodyRequestForm,
            subtitle: context.tr.viewDetailsTimelinesAndStatuses,
            titleStyle: AppStyles.s16W600.copyWith(
              color: context.customColor.text1,
            ),
            iconColor: context.customColor.text1,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
              child: BlocBuilder<GetCustodyDetailsCubit, GetCustodyDetailsState>(
                builder: (context, getCustodyDetailsState) {
                  if (getCustodyDetailsState is GetCustodyDetailsLoading) {
                    return const AppLoadingWidget();
                  } else if (getCustodyDetailsState
                      is GetCustodyDetailsFailure) {
                    return AppFailureWidget(
                      failure: getCustodyDetailsState.failure,
                      onRetry: () => _getRequestDetails(context),
                      withBorder: false,
                    );
                  } else if (getCustodyDetailsState
                      is GetCustodyRequestDetailsSuccess) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.text2,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.all(6.r),
                          child: Row(
                            children: List.generate(3, (index) {
                              final texts = [
                                context.tr.details,
                                context.tr.timelines,
                                context.tr.approval,
                              ];

                              return Expanded(
                                child:
                                    BlocSelector<
                                      PagingCubit,
                                      PagingState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.currentIndex == index,
                                      builder: (context, state) {
                                        return CustomTextButton(
                                          text: texts[index],
                                          onTap: () {
                                            context
                                                .read<PagingCubit>()
                                                .goToStep(index);
                                          },
                                          textColor: context.customColor.text1,
                                          borderRadius: 1000.r,
                                          borderColor: Colors.transparent,
                                          backgroundColor: state
                                              ? context
                                                    .customColor
                                                    .reversedTextColor
                                              : Colors.transparent,
                                        );
                                      },
                                    ),
                              );
                            }),
                          ),
                        ),
                        12.verticalSpace,
                        Expanded(
                          child: BlocSelector<PagingCubit, PagingState, int>(
                            selector: (state) => state.currentIndex,
                            builder: (context, state) {
                              return IndexedStack(
                                index: state,
                                children: [
                                  CustodyRequestDetailsScreenDetailsView(
                                    details:
                                        getCustodyDetailsState.details.data,
                                    userTypeStrategy: userTypeStrategy,
                                    onApproveRejectSuccess: () {
                                      _getRequestDetails(context);
                                    },
                                  ),
                                  TimeLinesView(
                                    timelines: getCustodyDetailsState
                                        .details
                                        .data
                                        .timeline
                                        .timelines,
                                  ),
                                  CustodyRequestDetailsScreenApprovalView(
                                    approval: getCustodyDetailsState
                                        .details
                                        .data
                                        .approval,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return AppLocalFailure(
                    onRetry: () => _getRequestDetails(context),
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
}
