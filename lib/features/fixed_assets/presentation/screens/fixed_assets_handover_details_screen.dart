import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/fixed_assets/presentation/screens/fixed_assets_handover_details_initiated_view.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../data/models/fixed_assets_handover_details_response.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_state.dart';
import '../cubit/get_fixed_assets_handover_details/get_fixed_assets_handover_details_cubit.dart';
import '../cubit/get_fixed_assets_handover_details/get_fixed_assets_handover_details_state.dart';
import 'fixed_assets_handover_details_completed_view.dart';

class FixedAssetsHandoverDetailsScreen extends StatefulWidget {
  final String handoverId;

  const FixedAssetsHandoverDetailsScreen({super.key, required this.handoverId});

  @override
  State<FixedAssetsHandoverDetailsScreen> createState() =>
      _FixedAssetsHandoverDetailsScreenState();
}

class _FixedAssetsHandoverDetailsScreenState
    extends State<FixedAssetsHandoverDetailsScreen> {
  late final FixedAssetsHandoverSessionRealtimeCubit _realtimeCubit;

  @override
  void initState() {
    super.initState();
    _realtimeCubit = context.read<FixedAssetsHandoverSessionRealtimeCubit>();
    _realtimeCubit.subscribe(sessionId: widget.handoverId);
  }

  List<String> _texts(BuildContext context) => [
    context.tr.initiated,
    context.tr.completed,
    context.tr.timelines,
  ];

  List<String> _texts2(BuildContext context) => [
    context.tr.initiated,
    context.tr.timelines,
  ];

  List<Widget> _views(FixedAssetsHandoverDetailsResponse details) => [
    FixedAssetsHandoverDetailsInitiatedView(
      status: details.status,
      initiatedDetails: details.initiatedDetails,
      recipientName: details.recipientName,
    ),
    FixedAssetsHandoverDetailsCompletedView(
      status: details.status,
      type: details.type,
      completedDetails: details.completedDetails!,
      handoverId: widget.handoverId,
      recipientName: details.recipientName,
      isDeduction: details.isDeduction,
      deductionDetails: details.deductionDetails,
    ),
    TimeLinesView(timelines: details.timeLine.timelines),
  ];

  List<Widget> _views2(FixedAssetsHandoverDetailsResponse details) => [
    FixedAssetsHandoverDetailsInitiatedView(
      status: details.status,
      initiatedDetails: details.initiatedDetails,
      recipientName: details.recipientName,
    ),
    TimeLinesView(timelines: details.timeLine.timelines),
  ];

  void _retry(BuildContext context) {
    context.read<GetFixedAssetsHandoverDetailsCubit>().getHandoverDetails(
      handoverId: widget.handoverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body:
          BlocListener<
            FixedAssetsHandoverSessionRealtimeCubit,
            FixedAssetsHandoverSessionRealtimeState
          >(
            listener: (context, state) {
              if (state is FixedAssetsHandoverSessionRealtimeReceiverSigned ||
                  state is FixedAssetsHandoverSessionRealtimeStatusChanged) {
                context
                    .read<GetFixedAssetsHandoverDetailsCubit>()
                    .getHandoverDetails(
                      handoverId: widget.handoverId,
                      loading: false,
                    );
              }
            },
            child: Column(
              children: [
                PurchaseAppBar(
                  title: context.tr.assetsHandoverDetails,
                  subtitle: context.tr.viewDetailsTimelinesAndStatuses,
                  titleColor: context.customColor.text1,
                  iconColor: context.customColor.text1,
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
                    child:
                        BlocBuilder<
                          GetFixedAssetsHandoverDetailsCubit,
                          GetFixedAssetsHandoverDetailsState
                        >(
                          builder: (context, state) {
                            if (state is GetFixedAssetsHandoverDetailsLoading) {
                              return const AppLoadingWidget();
                            } else if (state
                                is GetFixedAssetsHandoverDetailsFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: () => _retry(context),
                              );
                            } else if (state
                                is GetFixedAssetsHandoverDetailsSuccess) {
                              final handoverDetails = state.response;

                              return Column(
                                children: [
                                  ContainerCustomTextField(
                                    padding: EdgeInsets.all(6.r),
                                    borderRadius: BorderRadius.circular(1000.r),
                                    child: Row(
                                      children: List.generate(
                                        (handoverDetails.completedDetails !=
                                                    null &&
                                                handoverDetails.status
                                                    is! PendingApprovalHandoverStrategy)
                                            ? _texts(context).length
                                            : _texts2(context).length,
                                        (index) {
                                          return Expanded(
                                            child:
                                                BlocSelector<
                                                  PagingCubit,
                                                  PagingState,
                                                  bool
                                                >(
                                                  selector: (state) {
                                                    return state.currentIndex ==
                                                        index;
                                                  },
                                                  builder: (context, isSelected) {
                                                    return CustomTextButton(
                                                      text:
                                                          (handoverDetails
                                                                      .completedDetails !=
                                                                  null &&
                                                              handoverDetails
                                                                      .status
                                                                  is! PendingApprovalHandoverStrategy)
                                                          ? _texts(
                                                              context,
                                                            )[index]
                                                          : _texts2(
                                                              context,
                                                            )[index],
                                                      backgroundColor:
                                                          isSelected
                                                          ? context
                                                                .customColor
                                                                .reversedTextColor
                                                          : Colors.transparent,
                                                      textColor: isSelected
                                                          ? context
                                                                .customColor
                                                                .text1
                                                          : context
                                                                .customColor
                                                                .text3,
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 1000.r,
                                                      onTap: () {
                                                        context
                                                            .read<PagingCubit>()
                                                            .goToStep(index);
                                                      },
                                                    );
                                                  },
                                                ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Expanded(
                                    child:
                                        BlocSelector<
                                          PagingCubit,
                                          PagingState,
                                          int
                                        >(
                                          selector: (state) =>
                                              state.currentIndex,
                                          builder: (context, pagingState) {
                                            return IndexedStack(
                                              index: pagingState,
                                              children:
                                                  (handoverDetails
                                                              .completedDetails !=
                                                          null &&
                                                      handoverDetails.status
                                                          is! PendingApprovalHandoverStrategy)
                                                  ? _views(handoverDetails)
                                                  : _views2(handoverDetails),
                                            );
                                          },
                                        ),
                                  ),
                                ],
                              );
                            }

                            return AppLocalFailure(
                              onRetry: () => _retry(context),
                            );
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
