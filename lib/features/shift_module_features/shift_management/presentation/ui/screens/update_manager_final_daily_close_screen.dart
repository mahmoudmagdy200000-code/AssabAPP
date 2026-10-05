import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../domain/entity/manager_shift/current_shift/final_daily_close/AggregatorFinalDailyCloseEntity.dart';
import '../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import '../../logic/manager_shift/manager_shift_cubit.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/end_manager_success_screen.dart';
import '../widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/final_daily_close_table_widget.dart';

class UpdateManagerFinalDailyCloseScreen extends StatefulWidget {
  final String branchName;

  const UpdateManagerFinalDailyCloseScreen({
    super.key,
    required this.branchName,
  });

  @override
  State<UpdateManagerFinalDailyCloseScreen> createState() =>
      _UpdateManagerFinalDailyCloseScreenState();
}

class _UpdateManagerFinalDailyCloseScreenState
    extends State<UpdateManagerFinalDailyCloseScreen> {
  late List<CashierBreakdownEntity> draftCashiersBreakdowns;
  late TotalsEntity draftTotals;
  late List<AggregatorFinalDailyCloseEntity> draftAggregators;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
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

  void _onNextButtonPressed(BuildContext context) {
    // if(currentIndex == 2){
    //
    //   final cubit = context.read<FinalDailyCloseCubit>();
    //   final totals = cubit.totals;
    //   // context.read<EndAndUpdateManagerShiftCubit>().endManagerShift(   Upddaaaate
    //   //     aggregatorPayments: totals.totalDeliveryApps,
    //   //     cardPayments: totals.totalCardPayments,
    //   //     cashCollected: totals.totalCashCollected,
    //   //     totalSales: totals.totalSales,
    //   //     cashierBreakdown: cubit.cashiersBreakdown
    //   // );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.theme.primaryColor,
      child: Column(
        children: [
          AppPaddingWidget(
            child: Row(
              children: [
                const AppBackButton(isTransparent: true),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.editFinalSubmission,
                      softWrap: true,
                      style: AppStyles.s20W400.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),

                    Text(
                      widget.branchName,
                      softWrap: true,
                      style: AppStyles.s15W400.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.reviewAndCorrectFinal,
                              style: AppStyles.s18W500,
                            ),
                            10.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .uAreMakingCorrectionsToTheFinalShiftSubmission,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),

                            14.verticalSpace,
                            Column(
                              children: [
                                BlocBuilder<
                                  FinalDailyCloseCubit,
                                  FinalDailyCloseState
                                >(
                                  builder: (context, state) {
                                    if (state is FinalDailyCloseFetchLoading) {
                                      return Container(
                                        height: 100.h,
                                        alignment: Alignment.center,
                                        child: const AppLoadingWidget(),
                                      );
                                    } else if (state
                                        is FinalDailyCloseFetchFailure) {
                                      return Center(
                                        child: AppFailureWidget(
                                          failure: state.failure,
                                          onRetry: () => context
                                              .read<FinalDailyCloseCubit>()
                                              .getDailyClose(),
                                        ),
                                      );
                                    } else if (state
                                        is FinalDailyCloseLoadedOrUpdated) {
                                      context
                                              .read<FinalDailyCloseCubit>()
                                              .cashiersBreakdown =
                                          state.cashiers;
                                      context
                                              .read<FinalDailyCloseCubit>()
                                              .totals =
                                          state.totals;
                                    }

                                    return BlocSelector<
                                      FinalDailyCloseCubit,
                                      FinalDailyCloseState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state
                                              is FinalDailyCloseLoadedOrUpdated
                                          ? state.isSubmitted
                                          : false,
                                      builder: (context, isSubmitted) {
                                        final cubit = context
                                            .read<FinalDailyCloseCubit>();
                                        return FinalDailyCloseTableWidget(
                                          cashiersBreakdowns:
                                              cubit.cashiersBreakdown,
                                          totals: cubit.totals,
                                          isEnabled: isSubmitted,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    10.verticalSpace,
                    Row(
                      children: [
                        // if (currentIndex != 0) ...[
                        //   Expanded(
                        //     child: CustomTextButton(
                        //       text: context.tr.back,
                        //       onTap: () => _onBackButtonPressed(
                        //         context,
                        //         currentIndex,
                        //       ),
                        //       textColor: context.customColor.text1,
                        //       borderRadius: 1000.r,
                        //       padding: EdgeInsets.symmetric(vertical: 17.r),
                        //     ),
                        //   ),
                        //   16.horizontalSpace,
                        // ],
                        Expanded(
                          child:
                              BlocConsumer<
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
                                            title:
                                                context.tr.submissionSuccessful,
                                            subTitle: context
                                                .tr
                                                .yourFinalHandoverHasBeenSubmitted,
                                            managerShift:
                                                managerShiftState.managerShift,
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

                                  return BlocSelector<
                                    FinalDailyCloseCubit,
                                    FinalDailyCloseState,
                                    bool
                                  >(
                                    selector: (state) =>
                                        state is FinalDailyCloseLoadedOrUpdated
                                        ? state.isSubmitted
                                        : false,
                                    builder: (context, isSubmitted) {
                                      if (isSubmitted) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: AppButton(
                                                onClick: () {
                                                  final cubit = context
                                                      .read<
                                                        FinalDailyCloseCubit
                                                      >();
                                                  cubit.undoChanges(
                                                    draftCashiers:
                                                        draftCashiersBreakdowns,
                                                    draftTotals: draftTotals,
                                                    draftAggregators:
                                                        draftAggregators,
                                                  );
                                                },
                                                enabled: true,
                                                isTransparent: true,
                                                text: context.tr.undoChanges,
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: AppButton(
                                                onClick: () {
                                                  context
                                                      .read<
                                                        EndAndUpdateManagerShiftCubit
                                                      >()
                                                      .updateManagerHandoverShift(
                                                        cashierBreakdown: context
                                                            .read<
                                                              FinalDailyCloseCubit
                                                            >()
                                                            .cashiersBreakdown,
                                                      );
                                                },
                                                enabled: true,
                                                text: context.tr.submitChanges,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return AppButton(
                                        onClick: () {
                                          draftCashiersBreakdowns = context
                                              .read<FinalDailyCloseCubit>()
                                              .cashiersBreakdown;
                                          draftTotals = context
                                              .read<FinalDailyCloseCubit>()
                                              .totals;
                                          draftAggregators =
                                              context
                                                  .read<FinalDailyCloseCubit>()
                                                  .aggregators ??
                                              [];
                                          context
                                              .read<FinalDailyCloseCubit>()
                                              .toggleSubmitted();
                                        },
                                        enabled: true,
                                        text: context.tr.submitDailyReport,
                                      );
                                    },
                                  );
                                },
                              ),
                        ),
                      ],
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
