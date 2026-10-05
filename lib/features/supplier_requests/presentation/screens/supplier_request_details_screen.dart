import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/dynamic_steps/dynamic_steps_state.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_manager_request_multi_order_details_app_bar.dart';
import '../cubit/supplier_get_request_details/supplier_get_request_details_cubit.dart';
import '../cubit/supplier_get_request_details/supplier_get_request_details_state.dart';
import '../widgets/details_timelines_branch_row_buttons.dart';
import '../widgets/supplier_request_branch_view.dart';
import '../widgets/supplier_request_details_view.dart';

class SupplierRequestDetailsScreen extends StatefulWidget {
  final String id;

  const SupplierRequestDetailsScreen({super.key, required this.id});

  @override
  State<SupplierRequestDetailsScreen> createState() =>
      _SupplierRequestDetailsScreenState();
}

class _SupplierRequestDetailsScreenState
    extends State<SupplierRequestDetailsScreen> {
  @override
  void initState() {
    super.initState();

    _getRequestDetails();
  }

  void _getRequestDetails() {
    context.read<SupplierGetRequestDetailsCubit>().getRequestDetails(
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          BranchManagerRequestDetailsAppBar(
            title: context.tr.orderViaSupplier,
            desc: context.tr.viewDetailsTimelinesAndStatuses,
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
              child:
                  BlocBuilder<
                    SupplierGetRequestDetailsCubit,
                    SupplierGetRequestDetailsState
                  >(
                    builder: (context, state) {
                      if (state is SupplierGetRequestDetailsLoading) {
                        return const AppLoadingWidget();
                      } else if (state is SupplierGetRequestDetailsFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          withBorder: false,
                          onRetry: _getRequestDetails,
                        );
                      } else if (state is SupplierGetRequestDetailsSuccess) {
                        final details = state.details;

                        final stepBuilders = [
                          () => SupplierRequestDetailsView(details: details),
                          () => TimeLinesView(
                            timelines: details.timelines.timelines,
                          ),
                          () => SupplierRequestBranchView(
                            branch: details.data.branch,
                            branchManager: details.data.branchManager,
                          ),
                        ];

                        final titles = [
                          context.tr.details,
                          context.tr.timelines,
                          context.tr.branch,
                        ];

                        context.read<DynamicStepsCubit>().buildSteps(
                          stepBuilders,
                          titles,
                        );

                        details.data.status.addTrackView(
                          context,
                          details.data.id,
                        );

                        final pagingCubit = context.read<PagingCubit>();
                        final dynamicState = context
                            .read<DynamicStepsCubit>()
                            .state;
                        pagingCubit.updateTotalSteps(
                          dynamicState.builders.length,
                        );

                        return BlocBuilder<
                          DynamicStepsCubit,
                          DynamicStepsState
                        >(
                          builder: (context, dynamicState) {
                            return BlocSelector<PagingCubit, PagingState, int>(
                              selector: (state) => state.currentIndex,
                              builder: (context, currentIndex) {
                                return Column(
                                  children: [
                                    10.verticalSpace,
                                    DetailsTimelinesBranchRowButtons(
                                      titles: dynamicState.titles,
                                    ),
                                    12.verticalSpace,
                                    Expanded(
                                      child: IndexedStack(
                                        index: currentIndex.clamp(
                                          0,
                                          dynamicState.builders.length - 1,
                                        ),
                                        children: dynamicState.builders
                                            .map((b) => b())
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
