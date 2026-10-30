import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/di/dependency_injection.dart';
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
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/daily_close_submission.dart';

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
  late String draftManagerWorkdayId;
  late List<CashierBreakdownEntity> draftCashiersBreakdowns;
  late TotalsEntity draftTotals;
  late List<AggregatorFinalDailyCloseEntity> draftAggregators;
  bool _submittingFinal = false;

  Future<void> _submitFinal(FinalDailyCloseLoadedOrUpdated snapshot) async {
    if (_submittingFinal || !snapshot.canSubmitFinal || snapshot.isSubmitted) {
      return;
    }
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال اليومية نهائياً'),
        content: const Text('هل تريد إرسال اليومية النهائية للمراجعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted || _submittingFinal) return;
    final daily = context.read<FinalDailyCloseCubit>();
    if (!identical(daily.state, snapshot)) return;
    setState(() => _submittingFinal = true);
    final workdayId = snapshot.managerWorkdayId!;
    Object? error;
    DailyCloseSubmission? action;
    try {
      action = DailyCloseSubmission(
        getIt<Dio>(),
        await SharedPreferences.getInstance(),
        actorId: snapshot.managerId!,
        branchId: snapshot.branchId!,
      );
      if (!action.hasCurrentActor || action.hasUnresolved(workdayId)) {
        throw StateError('Reconcile the earlier submission first.');
      }
      await action.submit(workdayId, snapshot.managerReportRevision!);
    } catch (e) {
      error = e;
    }
    if (!mounted) return;
    final current = daily.state;
    if (current is FinalDailyCloseLoadedOrUpdated &&
        current.managerWorkdayId == workdayId) {
      await daily.getDailyClose(managerWorkdayId: workdayId);
    }
    if (!mounted) return;
    final refreshed = daily.state;
    final confirmed =
        action != null &&
        action.hasCurrentActor &&
        refreshed is FinalDailyCloseLoadedOrUpdated &&
        refreshed.managerWorkdayId == workdayId &&
        refreshed.managerId == snapshot.managerId &&
        refreshed.branchId == snapshot.branchId &&
        refreshed.serverSubmitted == true;
    if (confirmed) await action.resolveSubmitted(workdayId);
    if (!mounted) return;
    setState(() => _submittingFinal = false);
    final message = confirmed
        ? 'تم إرسال اليومية النهائية للمراجعة.'
        : error is DioException
        ? (error.response?.data is Map
              ? (error.response?.data['message']?.toString() ??
                    'تعذر تأكيد النتيجة. حدّث اليومية قبل المحاولة مجدداً.')
              : 'تعذر تأكيد النتيجة. حدّث اليومية قبل المحاولة مجدداً.')
        : 'لم يتم تأكيد الإرسال من السيرفر. حدّث اليومية قبل المحاولة مجدداً.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _reconcileFinal(
    FinalDailyCloseLoadedOrUpdated snapshot,
    DailyCloseSubmission action,
  ) async {
    if (_submittingFinal || !action.hasCurrentActor) return;
    final daily = context.read<FinalDailyCloseCubit>();
    final id = snapshot.managerWorkdayId!;
    setState(() => _submittingFinal = true);
    await daily.getDailyClose(managerWorkdayId: id);
    if (!mounted) return;
    final updated = daily.state;
    final confirmed =
        action.hasCurrentActor &&
        updated is FinalDailyCloseLoadedOrUpdated &&
        updated.managerWorkdayId == id &&
        updated.managerId == snapshot.managerId &&
        updated.branchId == snapshot.branchId &&
        updated.serverSubmitted == true;
    if (confirmed) await action.resolveSubmitted(id);
    if (!mounted) return;
    setState(() => _submittingFinal = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          confirmed
              ? 'تم التحقق من إرسال اليومية للمراجعة.'
              : 'النتيجة غير مؤكدة. تواصل مع المحاسب أو مسؤول النظام قبل أي إجراء آخر.',
        ),
      ),
    );
  }

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
                                          child:
                                              EndAndUpdateManagerSuccessScreen(
                                                title: 'تم حفظ التعديلات',
                                                subTitle:
                                                    'تم حفظ تعديلات اليومية.',
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
                                                    managerWorkdayId:
                                                        draftManagerWorkdayId,
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
                                              child:
                                                  BlocBuilder<
                                                    FinalDailyCloseCubit,
                                                    FinalDailyCloseState
                                                  >(
                                                    builder: (context, dailyState) => AppButton(
                                                      onClick: () {
                                                        final daily = context
                                                            .read<
                                                              FinalDailyCloseCubit
                                                            >();
                                                        final snapshot =
                                                            daily.state;
                                                        if (snapshot
                                                                is! FinalDailyCloseLoadedOrUpdated ||
                                                            !snapshot
                                                                .canSubmit) {
                                                          return;
                                                        }
                                                        context
                                                            .read<
                                                              EndAndUpdateManagerShiftCubit
                                                            >()
                                                            .updateManagerHandoverShift(
                                                              workday: snapshot,
                                                            );
                                                      },
                                                      enabled:
                                                          dailyState
                                                              is FinalDailyCloseLoadedOrUpdated &&
                                                          dailyState.canSubmit,
                                                      text: context
                                                          .tr
                                                          .submitChanges,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        );
                                      }

                                      return AppButton(
                                        onClick: () {
                                          final snapshot = context
                                              .read<FinalDailyCloseCubit>()
                                              .state;
                                          if (snapshot
                                                  is! FinalDailyCloseLoadedOrUpdated ||
                                              snapshot.managerWorkdayId ==
                                                  null) {
                                            return;
                                          }
                                          draftManagerWorkdayId =
                                              snapshot.managerWorkdayId!;
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
                                        text: 'تعديل اليومية',
                                      );
                                    },
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    BlocBuilder<FinalDailyCloseCubit, FinalDailyCloseState>(
                      builder: (context, state) {
                        if (state is! FinalDailyCloseLoadedOrUpdated) {
                          return const SizedBox.shrink();
                        }
                        return FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                          builder: (context, prefsSnapshot) {
                            if (!prefsSnapshot.hasData ||
                                state.managerId == null ||
                                state.branchId == null ||
                                state.managerWorkdayId == null) {
                              return const Text('تعذر التحقق من هوية اليومية.');
                            }
                            final action = DailyCloseSubmission(
                              getIt<Dio>(),
                              prefsSnapshot.data!,
                              actorId: state.managerId!,
                              branchId: state.branchId!,
                            );
                            final unresolved = action.hasUnresolved(
                              state.managerWorkdayId!,
                            );
                            if (!action.hasCurrentActor) {
                              return const Text('تعذر التحقق من حساب المدير.');
                            }
                            if (unresolved) {
                              return Column(
                                children: [
                                  const Text(
                                    'نتيجة الإرسال السابق معلّقة. حدّث الحالة، وإن لم تتأكد تواصل مع المحاسب أو مسؤول النظام.',
                                  ),
                                  TextButton(
                                    onPressed: _submittingFinal
                                        ? null
                                        : () => _reconcileFinal(state, action),
                                    child: const Text('تحديث حالة اليومية'),
                                  ),
                                ],
                              );
                            }
                            if (state.serverSubmitted == true) {
                              return const Text(
                                'تم إرسال اليومية النهائية للمراجعة',
                              );
                            }
                            return AppButton(
                              onClick: () => _submitFinal(state),
                              enabled:
                                  state.canSubmitFinal &&
                                  !state.isSubmitted &&
                                  !_submittingFinal,
                              text: _submittingFinal
                                  ? 'جارٍ إرسال اليومية...'
                                  : 'إرسال اليومية نهائياً',
                            );
                          },
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
