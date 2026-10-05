import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/fixed_assets_overview_response.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_state.dart';
import '../cubit/get_fixed_assets_overview/get_fixed_assets_overview_cubit.dart';
import '../cubit/get_fixed_assets_overview/get_fixed_assets_overview_state.dart';
import '../widgets/fixed_assets_handover_rejected_assets_bottom_sheet_widget.dart';
import '../widgets/fixed_assets_header_widget.dart';
import '../widgets/fixed_assets_overview_widget.dart';
import '../widgets/fixed_assets_quick_actions_widget.dart';

class FixedAssetsScreen extends StatefulWidget {
  const FixedAssetsScreen({super.key});

  @override
  State<FixedAssetsScreen> createState() => _FixedAssetsScreenState();
}

class _FixedAssetsScreenState extends State<FixedAssetsScreen> {
  late final FixedAssetsHandoverSessionRealtimeCubit _realtimeCubit;
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _realtimeCubit = context.read<FixedAssetsHandoverSessionRealtimeCubit>();
  }

  @override
  void dispose() {
    if (_currentSessionId != null) {
      _realtimeCubit.unsubscribe(sessionId: _currentSessionId!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.reversedTextColor,
      body:
          BlocListener<
            FixedAssetsHandoverSessionRealtimeCubit,
            FixedAssetsHandoverSessionRealtimeState
          >(
            listener: (context, state) {
              if (state is FixedAssetsHandoverSessionRealtimeStarted ||
                  state is FixedAssetsHandoverSessionRealtimeReceiverSigned ||
                  state is FixedAssetsHandoverSessionRealtimeStatusChanged) {
                context.read<GetFixedAssetsOverviewCubit>().getOverview(
                  loading: false,
                );
              }
            },
            child:
                BlocBuilder<
                  GetFixedAssetsOverviewCubit,
                  GetFixedAssetsOverviewState
                >(
                  builder: (context, state) {
                    if (state is GetFixedAssetsOverviewLoading) {
                      return const AppLoadingWidget();
                    } else if (state is GetFixedAssetsOverviewFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        onRetry: () {
                          context
                              .read<GetFixedAssetsOverviewCubit>()
                              .getOverview();
                        },
                      );
                    } else if (state is GetFixedAssetsOverviewSuccess) {
                      final overview = state.overview;

                      if (overview.handover != null) {
                        _currentSessionId = overview.handover!.id;
                        context
                            .read<FixedAssetsHandoverSessionRealtimeCubit>()
                            .subscribe(sessionId: overview.handover!.id);
                      }

                      return Column(
                        children: [
                          const FixedAssetsHeaderWidget(),
                          CustomDivider(thickness: 10.h),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (overview.handover != null)
                                    overview.handover!.status.buildStatusWidget(
                                      context,
                                      handoverId: overview.handover!.id,
                                      recipientName:
                                          overview.handover!.recipientName,
                                      type: overview.handover!.type,
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.r,
                                      vertical: 16.r,
                                    ),
                                    child: Column(
                                      children: [
                                        FixedAssetsOverviewWidget(
                                          overview: overview,
                                        ),
                                        SizedBox(height: 16.h),
                                        const FixedAssetsQuickActionsWidget(),
                                        _buildPendingYourActionWidget(
                                          context,
                                          overview.rejectedAssets,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return AppLocalFailure(
                      onRetry: () {
                        context
                            .read<GetFixedAssetsOverviewCubit>()
                            .getOverview();
                      },
                    );
                  },
                ),
          ),
    );
  }

  Widget _buildPendingYourActionWidget(
    BuildContext context,
    List<FixedAssetsOverviewAssetRejectedItem> rejectedAssets,
  ) {
    if (rejectedAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: AppGestureDetectorButton(
        onTap: () {
          AppBottomSheet.customPageRoute(
            context,
            (context) => FixedAssetsHandoverRejectedAssetsBottomSheetWidget(
              rejectedAssets: rejectedAssets,
            ),
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.warning,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.error,
                    BlendMode.srcIn,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    context.tr.pendingYourAction,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: context.customColor.text2,
                  width: 10.r,
                ),
              ),
              padding: EdgeInsets.all(12.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${rejectedAssets.length} ${context.tr.rejectedAssetsPendingYourReview}',
                    ),
                  ),
                  5.horizontalSpace,
                  AppSvg(
                    assetName: AppAssets.arrowRight,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
