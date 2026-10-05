import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/details_timelines_approval_row_buttons.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../data/models/recurring_order_details_response.dart';
import '../../domain/strategies/recurring_order_actions_strategy.dart';
import '../../domain/strategies/recurring_order_status_strategy.dart';
import '../cubit/get_recurring_order_details/get_recurring_order_details_cubit.dart';
import '../cubit/get_recurring_order_details/get_recurring_order_details_state.dart';
import '../cubit/recurring_order_actions/recurring_order_actions_cubit.dart';
import '../cubit/recurring_order_actions/recurring_order_actions_state.dart';
import 'recurring_order_deatils_details_view.dart';
import 'recurring_order_deatils_history_view.dart';
import 'recurring_order_deatils_status_view.dart';

class RecurringOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const RecurringOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<RecurringOrderDetailsScreen> createState() =>
      _RecurringOrderDetailsScreenState();
}

class _RecurringOrderDetailsScreenState
    extends State<RecurringOrderDetailsScreen> {
  final GlobalKey _menuKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  Future<void> _getDetails() async {
    await context
        .read<GetRecurringOrderDetailsCubit>()
        .getRecurringOrderDetails(id: widget.orderId);
  }

  void _showCustomMenu() async {
    final RenderBox button =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + button.size.height + 8.h,
      overlay.size.width - buttonPosition.dx - button.size.width,
      overlay.size.height - buttonPosition.dy,
    );

    final statusIsNotPaused =
        context
                .read<ValidationCubit>()
                .getTypedValue<RecurringOrderStatusStrategy>('scheduleStatus')
            is! PausedRecurringOrderStatusStrategy;

    final selected = await showMenu<RecurringOrderActionsStrategy>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      color: context.customColor.reversedTextColor,
      items: [
        if (statusIsNotPaused)
          PopupMenuItem(
            value: PauseScheduleRecurringOrderActionsStrategy(),
            child: _buildPopupMenuItemWidget(
              text: context.tr.pauseSchedule,
              iconColor: AppColors.orange,
              assetName: AppAssets.wait,
            ),
          ),
        PopupMenuItem(
          value: EditScheduleRecurringOrderActionsStrategy(),
          child: _buildPopupMenuItemWidget(
            text: context.tr.editSchedule,
            iconColor: context.theme.primaryColor,
            assetName: AppAssets.edit,
          ),
        ),
        PopupMenuItem(
          value: DeleteScheduleRecurringOrderActionsStrategy(),
          child: _buildPopupMenuItemWidget(
            text: context.tr.deleteSchedule,
            iconColor: context.customColor.error,
            assetName: AppAssets.trashSvg,
          ),
        ),
      ],
    );

    selected?.action(context, id: widget.orderId);
  }

  Row _buildPopupMenuItemWidget({
    required String text,
    required Color iconColor,
    required String assetName,
  }) {
    return Row(
      spacing: 8.w,
      children: [
        AppSvg(
          assetName: assetName,
          width: 15.r,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        Expanded(
          child: Text(
            text,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text4),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PurchaseAppBar(
                  title: context.tr.scheduleDetails,
                  subtitle: context.tr.viewActivityAndManageSchedule,
                  titleColor: context.customColor.text1,
                  iconColor: context.customColor.text1,
                ),
              ),
              AppIconButton(
                key: _menuKey,
                icon: Icons.more_vert_outlined,
                iconColor: context.customColor.text1,
                onPressed: _showCustomMenu,
              ),
              20.horizontalSpace,
            ],
          ),
          Expanded(
            child:
                BlocConsumer<
                  RecurringOrderActionsCubit,
                  RecurringOrderActionsState
                >(
                  listener: (context, state) {
                    if (state is RecurringOrderActionsFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    } else if (state is RecurringOrderActionsSuccess) {
                      NavigationService.I.pop();
                    }
                  },
                  builder: (context, state) {
                    if (state is RecurringOrderActionsLoading) {
                      return const AppLoadingWidget();
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        children: [
                          DetailsTimelinesApprovalRowButtons(
                            titles: [
                              context.tr.status,
                              context.tr.details,
                              context.tr.history,
                            ],
                          ),
                          10.verticalSpace,
                          Expanded(
                            child:
                                BlocBuilder<
                                  GetRecurringOrderDetailsCubit,
                                  GetRecurringOrderDetailsState
                                >(
                                  builder: (context, state) {
                                    if (state
                                        is GetRecurringOrderDetailsLoading) {
                                      return const AppLoadingWidget();
                                    } else if (state
                                        is GetRecurringOrderDetailsFailure) {
                                      return AppFailureWidget(
                                        failure: state.failure,
                                        onRetry: _getDetails,
                                        withBorder: false,
                                      );
                                    } else if (state
                                        is GetRecurringOrderDetailsSuccess) {
                                      final RecurringOrderDetailsResponse
                                      details = state.details;

                                      context
                                          .read<ValidationCubit>()
                                          .validateFieldAndStoreTypedValue<
                                            RecurringOrderStatusStrategy
                                          >(
                                            fieldName: 'scheduleStatus',
                                            value: details
                                                .data
                                                .statusSection
                                                .statusValue,
                                            isValid: true,
                                          );

                                      return BlocSelector<
                                        PagingCubit,
                                        PagingState,
                                        int
                                      >(
                                        selector: (state) => state.currentIndex,
                                        builder: (context, state) {
                                          return IndexedStack(
                                            index: state,
                                            children: [
                                              RecurringOrderDeatilsStatusView(
                                                details: details,
                                              ),
                                              RecurringOrderDeatilsDetailsView(
                                                details: details,
                                              ),
                                              const RecurringOrderDeatilsHistoryView(),
                                            ],
                                          );
                                        },
                                      );
                                    }

                                    return AppLocalFailure(
                                      onRetry: _getDetails,
                                      withBorder: false,
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
