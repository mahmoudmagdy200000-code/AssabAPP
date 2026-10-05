import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/animated_container_of_paging_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_paging_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_cubit.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_state.dart';
import 'fixed_assets_active_handover_session_preview_assets_view.dart';
import 'fixed_assets_active_handover_session_signature_view.dart';
import 'fixed_assets_active_handover_session_summary_view.dart';
import 'fixed_assets_active_handover_session_zone_assets_details_view.dart';

class FixedAssetsActiveHandoverSessionScreen extends StatefulWidget {
  final String sessionId;

  const FixedAssetsActiveHandoverSessionScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<FixedAssetsActiveHandoverSessionScreen> createState() =>
      _FixedAssetsActiveHandoverSessionScreenState();
}

class _FixedAssetsActiveHandoverSessionScreenState
    extends State<FixedAssetsActiveHandoverSessionScreen> {
  late final FixedAssetsHandoverSessionRealtimeCubit _realtimeCubit;

  @override
  void initState() {
    super.initState();
    _realtimeCubit = context.read<FixedAssetsHandoverSessionRealtimeCubit>();
    _realtimeCubit.subscribe(sessionId: widget.sessionId);
  }

  List<String> _title(BuildContext context) => [
    context.tr.reviewAssets,
    context.tr.preview,
    context.tr.signature,
    context.tr.summary,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.activeHandoverSession,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                BlocBuilder<
                  GetActiveHandoverSessionDetailsCubit,
                  GetActiveHandoverSessionDetailsState
                >(
                  builder: (context, state) {
                    if (state is GetActiveHandoverSessionDetailsSuccess) {
                      return Text(
                        context.tr.activeHandoverFromTo(
                          state.response.fromEmployeeName,
                          state.response.toEmployeeName,
                        ),
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: BlocSelector<PagingCubit, PagingState, int>(
                selector: (state) => state.currentIndex,
                builder: (context, state) {
                  return Column(
                    children: [
                      BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, pagingState) {
                          final currentIndex = pagingState.currentIndex;

                          return Wrap(
                            children: List.generate(4, (index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomPagingWidget(
                                    condition: index == currentIndex,
                                    text: _title(context)[index],
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.r,
                                      vertical: 5.r,
                                    ),
                                  ),
                                  AnimatedContainerOfPagingWidget(
                                    width: 40.w,
                                    condition: index == currentIndex,
                                    color: context.theme.primaryColor,
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                      5.verticalSpace,
                      Expanded(
                        child: IndexedStack(
                          index: state,
                          children: [
                            FixedAssetsActiveHandoverSessionZoneAssetsDetailsView(
                              sessionId: widget.sessionId,
                            ),
                            FixedAssetsActiveHandoverSessionPreviewAssetsView(
                              sessionId: widget.sessionId,
                            ),
                            FixedAssetsActiveHandoverSessionSignatureView(
                              sessionId: widget.sessionId,
                            ),
                            FixedAssetsActiveHandoverSessionSummaryView(
                              sessionId: widget.sessionId,
                            ),
                          ],
                        ),
                      ),
                    ],
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
