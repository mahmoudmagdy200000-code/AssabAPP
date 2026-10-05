import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/end_manager_success_screen.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/final_daily_close_widget.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/manager_end_shift_handoffs_received_widget.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/manager_end_shift_set_workday_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/shift_management_from_app_bar.dart';

class EndManagerShiftScreen extends StatefulWidget {
  final List<HandoverDetailsEntity> handovers;
  final String managerName;

  const EndManagerShiftScreen({
    super.key,
    required this.handovers,
    required this.managerName,
  });

  @override
  State<EndManagerShiftScreen> createState() => _EndManagerShiftScreenState();
}

class _EndManagerShiftScreenState extends State<EndManagerShiftScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _changeView(BuildContext context) {
    context.read<PagingCubit>().nextStep();
  }

  void _goBackView(BuildContext context) {
    context.read<PagingCubit>().previousStep();
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
    _goBackView(context);

    switch (currentIndex) {
      case 0:
        break;
      case 1:
        // _cashierInfoChangedToPreviousView(context);
        break;
      case 2:
        // _cashierInfoChangedToPreviousView(context);
        break;
    }
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    _changeView(context);
    if (currentIndex == 2) {
      final cubit = context.read<FinalDailyCloseCubit>();
      final totals = cubit.totals;
      context.read<EndAndUpdateManagerShiftCubit>().endManagerShift(
        aggregatorPayments: totals.totalDeliveryApps,
        cardPayments: totals.totalCardPayments,
        cashCollected: totals.totalCashCollected,
        totalSales: totals.totalSales,
        cashierBreakdown: cubit.cashiersBreakdown,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ShiftManagementFromAppBar(text: context.tr.end_shift),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: AppPaddingWidget(
                child: Column(
                  children: [
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, state) {
                        final steps = [
                          context.tr.handoffsReceived,
                          context.tr.setWorkDay,
                          context.tr.summary,
                        ];

                        return ReassignShiftTopSection(titles: steps);
                      },
                    ),

                    14.verticalSpace,
                    Expanded(
                      child: BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;

                          final steps = <Widget>[
                            ManagerEndShiftHandoffsReceivedWidget(
                              handovers: widget.handovers,
                              managerName: widget.managerName,
                            ),

                            BlocProvider(
                              create: (context) => getIt<ChooseItemCubit>(),
                              child: const ManagerEndShiftSetWorkdayWidget(),
                            ),

                            const FinalDailyCloseWidget(),
                          ];

                          return IndexedStack(
                            index: currentIndex,
                            children: steps,

                            // children: [
                            //   const EndShiftSummaryWidget(),
                            //   // Container(color: Colors.green,)
                            // ],
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, pagingState) {
                        final currentIndex = pagingState.currentIndex;

                        return Row(
                          children: [
                            if (currentIndex != 0) ...[
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.back,
                                  onTap: () => _onBackButtonPressed(
                                    context,
                                    currentIndex,
                                  ),
                                  textColor: context.customColor.text1,
                                  borderRadius: 1000.r,
                                  padding: EdgeInsets.symmetric(vertical: 17.r),
                                ),
                              ),
                              16.horizontalSpace,
                            ],
                            Expanded(
                              child: BlocSelector<ValidationCubit, ValidationState, bool>(
                                selector: (state) {
                                  if (currentIndex == 0) {
                                    final areAllHandoversCompleted =
                                        widget.handovers.isEmpty
                                        ? false
                                        : widget.handovers.every(
                                            (handover) =>
                                                handover.handoverStatus ==
                                                HandoverStatus.accepted,
                                          );

                                    return areAllHandoversCompleted;
                                  } else if (currentIndex == 1) {
                                    return context
                                            .read<ValidationCubit>()
                                            .state
                                            .fieldsValidity['handoverTiming'] ??
                                        false;
                                  }

                                  return true;
                                },
                                builder: (context, enableButton) {
                                  return BlocConsumer<
                                    EndAndUpdateManagerShiftCubit,
                                    EndAndUpdateManagerShiftState
                                  >(
                                    listener: (context, managerShiftState) {
                                      if (managerShiftState
                                          is EndManagerShiftFailure) {
                                        AppDialog.showErrorDialog(
                                          context: context,
                                          failure: managerShiftState.failure,
                                        );
                                      } else if (managerShiftState
                                          is EndManagerShiftSuccess) {
                                        final cubit = context
                                            .read<ManagerShiftCubit>();
                                        NavigationService.I.replaceWith(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider.value(
                                              value: cubit,
                                              child: EndAndUpdateManagerSuccessScreen(
                                                title: context
                                                    .tr
                                                    .businessDateClosed,
                                                subTitle: context.tr
                                                    .yourFinalHandoverHasBeenSubmittedForReview(
                                                      'Accountant Name',
                                                    ),
                                                managerShift: managerShiftState
                                                    .managerShift,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, managerShiftState) {
                                      if (managerShiftState
                                          is EndManagerShiftButtonLoading) {
                                        return const AppButtonLoading();
                                      }
                                      return AppButton(
                                        onClick: () => _onNextButtonPressed(
                                          context,
                                          currentIndex,
                                        ),
                                        enabled: enableButton,
                                        text: currentIndex == 2
                                            ? context.tr.end_shift
                                            : context.tr.next,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
