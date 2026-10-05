import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_order_details/get_order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_state.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/widgets/time_lines_view.dart';
import '../../../../shared/models/time_line_response.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../widgets/branch_manager_request_multi_order_details_app_bar.dart';
import '../widgets/details_timelines_approval_row_buttons.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String id;
  final PurchaseSourceStrategy strategy;
  final bool isBranchOrderTypeStrategy;

  const RequestDetailsScreen({
    super.key,
    required this.id,
    required this.strategy,
    this.isBranchOrderTypeStrategy = true,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  void _getDetails() {
    widget.strategy.getDetails(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          BranchManagerRequestDetailsAppBar(
            title: widget.strategy.getName(context),
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
              child: BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
                builder: (context, state) {
                  if (state is GetOrderDetailsLoading) {
                    return const AppLoadingWidget();
                  } else if (state is GetOrderDetailsFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: _getDetails,
                      withBorder: false,
                    );
                  }

                  final stepBuilders = [
                    () => widget.strategy.buildDetailsView(
                      widget.isBranchOrderTypeStrategy,
                    ),
                    () =>
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          List<TimeLineItem>
                        >(
                          selector: (state) =>
                              state.getListValue<TimeLineItem>('timelines') ??
                              [],
                          builder: (context, state) {
                            return TimeLinesView(timelines: state);
                          },
                        ),
                    () => widget.strategy.buildApproval(widget.id),
                  ];

                  final titles = [
                    context.tr.details,
                    context.tr.timelines,
                    widget.strategy.approvalViewTitle(context),
                  ];

                  context.read<DynamicStepsCubit>().buildSteps(
                    stepBuilders,
                    titles,
                  );

                  state.addSaveTimeLine(context);
                  state.addTrackView(context);
                  state.addSaveApproval(context);

                  final pagingCubit = context.read<PagingCubit>();
                  final dynamicState = context.read<DynamicStepsCubit>().state;
                  pagingCubit.updateTotalSteps(dynamicState.builders.length);

                  return BlocBuilder<DynamicStepsCubit, DynamicStepsState>(
                    builder: (context, dynamicState) {
                      return BlocSelector<PagingCubit, PagingState, int>(
                        selector: (state) => state.currentIndex,
                        builder: (context, currentIndex) {
                          return Column(
                            children: [
                              10.verticalSpace,
                              DetailsTimelinesApprovalRowButtons(
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
