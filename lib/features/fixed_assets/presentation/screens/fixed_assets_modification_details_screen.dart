import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../cubit/get_requests_details/get_requests_details_cubit.dart';
import '../cubit/get_requests_details/get_requests_details_state.dart';
import '../widgets/fixed_assets_modification_details_header_widget.dart';
import '../widgets/fixed_assets_modification_details_tab_switcher_widget.dart';
import '../widgets/fixed_assets_modification_details_details_view.dart';

class FixedAssetsModificationDetailsScreen extends StatelessWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;

  const FixedAssetsModificationDetailsScreen({
    super.key,
    required this.requestId,
    required this.userTypeStrategy,
  });

  void _onRetry(BuildContext context) {
    context.read<GetRequestsDetailsCubit>().getModifyDetails(
      requestId: requestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const FixedAssetsModificationDetailsHeaderWidget(),
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
                child: BlocBuilder<GetRequestsDetailsCubit, GetRequestsDetailsState>(
                  builder: (context, state) {
                    if (state is GetRequestsDetailsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is GetRequestsDetailsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        onRetry: () => _onRetry(context),
                        withBorder: false,
                      );
                    } else if (state is GetRequestsDetailsModificationSuccess) {
                      final details = state.details;

                      return Column(
                        children: [
                          const FixedAssetsModificationDetailsTabSwitcherWidget(),
                          12.verticalSpace,
                          Expanded(
                            child: BlocSelector<PagingCubit, PagingState, int>(
                              selector: (state) => state.currentIndex,
                              builder: (context, currentIndex) {
                                return IndexedStack(
                                  index: currentIndex,
                                  children: [
                                    FixedAssetsModificationDetailsDetailsView(
                                      details: details,
                                    ),
                                    TimeLinesView(
                                      timelines: details.timelines.timelines,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (userTypeStrategy is BrandOwnerUserStrategy) ...[
                            20.verticalSpace,
                            Row(
                              spacing: 12.w,
                              children: [
                                Expanded(
                                  child: CustomTextButton(
                                    text: context.tr.reject,
                                    onTap: () {},
                                    textColor: context.customColor.text1,
                                    backgroundColor: Colors.transparent,
                                    borderColor: context.customColor.border,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.r,
                                    ),
                                    borderRadius: 12.r,
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextButton(
                                    text: context.tr.approve,
                                    onTap: () {},
                                    textColor:
                                        context.customColor.reversedTextColor,
                                    backgroundColor: context.theme.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.r,
                                    ),
                                    borderRadius: 12.r,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    }

                    return AppLocalFailure(
                      onRetry: () => _onRetry(context),
                      withBorder: false,
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
