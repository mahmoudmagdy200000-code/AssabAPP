import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/pending_daily_closure_item.dart';
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
  final DailyCloseWorkdayEligibility? initialEligibility;
  final FutureApiResult<List<PendingDailyClosureItem>> Function({
    required String actorId,
    required String branchId,
  })?
  loadPendingClosures;

  const UpdateManagerFinalDailyCloseScreen({
    super.key,
    required this.branchName,
    this.initialEligibility,
    this.loadPendingClosures,
  });

  @override
  State<UpdateManagerFinalDailyCloseScreen> createState() =>
      _UpdateManagerFinalDailyCloseScreenState();
}

class _UpdateManagerFinalDailyCloseScreenState
    extends State<UpdateManagerFinalDailyCloseScreen>
    with WidgetsBindingObserver {
  late String draftManagerWorkdayId;
  late List<CashierBreakdownEntity> draftCashiersBreakdowns;
  late TotalsEntity draftTotals;
  late List<AggregatorFinalDailyCloseEntity> draftAggregators;
  bool _submittingFinal = false;
  String? _lastSubmissionRejection;
  DailyCloseWorkdayEligibility? _eligibility;
  bool _loadingEligibility = false;
  String? _verifiedEligibilityWorkdayId;

  Future<DailyCloseWorkdayEligibility> _fetchEligibility(
    FinalDailyCloseLoadedOrUpdated snapshot,
  ) async {
    final workdayId = snapshot.managerWorkdayId;
    final managerId = snapshot.managerId;
    final branchId = snapshot.branchId;
    if (workdayId == null ||
        workdayId.isEmpty ||
        managerId == null ||
        managerId.isEmpty ||
        branchId == null ||
        branchId.isEmpty) {
      return const DailyCloseWorkdayEligibility.unverified();
    }
    final prefs = await SharedPreferences.getInstance();
    final currentUid = prefs.getString('u_id') ?? '';
    if (currentUid != managerId) {
      return const DailyCloseWorkdayEligibility.unverified();
    }

    final ApiResult<List<PendingDailyClosureItem>> res;
    if (widget.loadPendingClosures != null) {
      res = await widget.loadPendingClosures!(
        actorId: managerId,
        branchId: branchId,
      );
    } else if (getIt.isRegistered<ShiftManagementRepositoryImp>()) {
      res = await getIt<ShiftManagementRepositoryImp>()
          .getPendingDailyClosures(actorId: managerId, branchId: branchId);
    } else {
      res = ApiResult<List<PendingDailyClosureItem>>.failure(
        ServerFailure(
          error: LocalErrorModel(
            message: 'Pending closures verification is unavailable.',
          ),
          icon: Icons.error_outline,
          statusCode: 500,
          stackTrace: StackTrace.current,
        ),
      );
    }

    return res.when(
      failure: (failure) => DailyCloseWorkdayEligibility.unverified(failure),
      success: (items) => PendingDailyClosureItem.evaluateWorkday(
        workdayId: workdayId,
        businessDate: snapshot.businessDate,
        orderedPending: items,
      ),
    );
  }

  Future<void> _verifyEligibilityFor(
    FinalDailyCloseLoadedOrUpdated snapshot, {
    bool force = false,
  }) async {
    final id = snapshot.managerWorkdayId;
    if (id == null || id.isEmpty) return;
    if (!force &&
        _verifiedEligibilityWorkdayId == id &&
        (_loadingEligibility || _eligibility != null)) {
      return;
    }
    if (mounted) {
      setState(() {
        _verifiedEligibilityWorkdayId = id;
        _loadingEligibility = true;
      });
    }
    final eligibility = await _fetchEligibility(snapshot);
    if (!mounted || _verifiedEligibilityWorkdayId != id) return;
    setState(() {
      _eligibility = eligibility;
      _loadingEligibility = false;
    });
  }

  Future<void> _refreshWorkdayAndEligibility(
    FinalDailyCloseLoadedOrUpdated snapshot,
  ) async {
    final id = snapshot.managerWorkdayId;
    if (id == null || id.isEmpty) return;
    await context.read<FinalDailyCloseCubit>().getDailyClose(
      managerWorkdayId: id,
    );
    if (!mounted) return;
    final current = context.read<FinalDailyCloseCubit>().state;
    if (current is FinalDailyCloseLoadedOrUpdated) {
      await _verifyEligibilityFor(current, force: true);
    }
  }

  bool _isVerifiedSubmitted(
    FinalDailyCloseState state, {
    required String workdayId,
    required String managerId,
    required String branchId,
  }) {
    return state is FinalDailyCloseLoadedOrUpdated &&
        state.managerWorkdayId == workdayId &&
        state.managerId == managerId &&
        state.branchId == branchId &&
        state.serverSubmitted == true;
  }

  Future<void> _submitFinal(FinalDailyCloseLoadedOrUpdated snapshot) async {
    if (_submittingFinal ||
        _loadingEligibility ||
        !snapshot.canSubmitFinal ||
        snapshot.isSubmitted) {
      return;
    }
    if (_eligibility == null || !_eligibility!.isEligible) {
      return;
    }
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr.submitDailyCloseFinal),
        content: Text(context.tr.submitDailyCloseFinalConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.tr.send),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted || _submittingFinal) return;
    final daily = context.read<FinalDailyCloseCubit>();
    if (!identical(daily.state, snapshot)) return;
    setState(() {
      _submittingFinal = true;
      _lastSubmissionRejection = null;
    });
    // Always re-verify oldest-pending eligibility right before sending POST so
    // stale-open screens never submit a blocked newer workday.
    final freshEligibility = await _fetchEligibility(snapshot);
    if (!mounted) return;
    if (!freshEligibility.isEligible) {
      final lang = Localizations.localeOf(context).languageCode;
      final blockedMsg =
          freshEligibility.status ==
              DailyCloseEligibilityStatus.blockedByOlderWorkday
          ? context.tr.closeWorkdayDateFirst(
              freshEligibility.localizedBlockingDate(lang),
            )
          : (freshEligibility.failure?.error.message ??
                context.tr.couldNotVerifyPendingClosures);
      setState(() {
        _submittingFinal = false;
        _eligibility = freshEligibility;
        _lastSubmissionRejection = blockedMsg;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(blockedMsg)));
      return;
    }
    final workdayId = snapshot.managerWorkdayId!;
    if (workdayId.isEmpty) {
      setState(() => _submittingFinal = false);
      return;
    }
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
        _isVerifiedSubmitted(
          refreshed,
          workdayId: workdayId,
          managerId: snapshot.managerId!,
          branchId: snapshot.branchId!,
        );
    if (confirmed) await action.resolveSubmitted(workdayId);
    if (!mounted) return;
    final parsedError = error != null
        ? DailyCloseSubmission.extractServerError(error)
        : null;
    final isDefinitiveRejection =
        !confirmed &&
        parsedError != null &&
        DailyCloseSubmission.isDefinitiveRollbackFailure(parsedError);
    final message = confirmed
        ? context.tr.dailyCloseSubmittedForReviewSuccess
        : isDefinitiveRejection
        ? parsedError.formatted(fallback: context.tr.dailyCloseRejectedByServer)
        : parsedError != null && parsedError.statusCode != null
        ? parsedError.formatted(fallback: context.tr.couldNotConfirmResultRefresh)
        : error is DioException
        ? context.tr.couldNotConfirmResultRefresh
        : context.tr.submissionNotConfirmedByServer;
    setState(() {
      _submittingFinal = false;
      _lastSubmissionRejection = isDefinitiveRejection ? message : null;
    });
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
    setState(() {
      _submittingFinal = true;
      _lastSubmissionRejection = null;
    });
    final outcome = await action.reconcile(
      id,
      refreshWorkday: () async {
        await daily.getDailyClose(managerWorkdayId: id);
        if (!mounted) {
          return const DailyCloseFreshRead(readSucceeded: false);
        }
        final refreshedState = daily.state;
        if (refreshedState is! FinalDailyCloseLoadedOrUpdated) {
          return const DailyCloseFreshRead(readSucceeded: false);
        }
        return DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: refreshedState.managerWorkdayId,
          managerId: refreshedState.managerId,
          branchId: refreshedState.branchId,
          serverSubmitted: refreshedState.serverSubmitted,
          reportRevision: refreshedState.managerReportRevision,
        );
      },
    );
    if (!mounted) return;
    final String snackMessage;
    String? rejectionBanner;
    switch (outcome.status) {
      case DailyCloseReconcileStatus.confirmed:
        snackMessage = context.tr.dailyCloseSubmissionVerified;
        break;
      case DailyCloseReconcileStatus.rejected:
        rejectionBanner = DailyCloseServerError(
          statusCode: outcome.statusCode,
          code: outcome.errorCode,
          message: outcome.message,
        ).formatted(fallback: context.tr.dailyCloseRejectedByServer);
        snackMessage = rejectionBanner;
        break;
      case DailyCloseReconcileStatus.verificationFailed:
      case DailyCloseReconcileStatus.unverifiedActor:
        snackMessage = context.tr.couldNotVerifyWorkdayStatus;
        break;
      case DailyCloseReconcileStatus.none:
      case DailyCloseReconcileStatus.pending:
      case DailyCloseReconcileStatus.revisionChangedAmbiguous:
        snackMessage = context.tr.resultUnconfirmedContactAccountant;
        break;
    }
    setState(() {
      _submittingFinal = false;
      _lastSubmissionRejection = rejectionBanner;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(snackMessage)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _eligibility = widget.initialEligibility;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<FinalDailyCloseCubit>().state;
      if (state is FinalDailyCloseLoadedOrUpdated) {
        _verifyEligibilityFor(state, force: true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<FinalDailyCloseCubit>().state;
    if (state is FinalDailyCloseLoadedOrUpdated &&
        state.managerWorkdayId != _verifiedEligibilityWorkdayId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _verifyEligibilityFor(state, force: true);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      final dailyState = context.read<FinalDailyCloseCubit>().state;
      if (dailyState is FinalDailyCloseLoadedOrUpdated) {
        _verifyEligibilityFor(dailyState, force: true);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                Expanded(
                  child: Column(
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
                                BlocConsumer<
                                  FinalDailyCloseCubit,
                                  FinalDailyCloseState
                                >(
                                  listener: (context, state) {
                                    if (state is FinalDailyCloseLoadedOrUpdated) {
                                      _verifyEligibilityFor(
                                        state,
                                        force:
                                            _verifiedEligibilityWorkdayId !=
                                            state.managerWorkdayId,
                                      );
                                    }
                                  },
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
                                                title: context.tr.changesSaved,
                                                subTitle:
                                                    context.tr.dailyCloseModificationsSaved,
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
                                        text: context.tr.editDailyClose,
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
                        final lang = Localizations.localeOf(context).languageCode;
                        return FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                          builder: (context, prefsSnapshot) {
                            if (!prefsSnapshot.hasData ||
                                state.managerId == null ||
                                state.branchId == null ||
                                state.managerWorkdayId == null) {
                              return Text(context.tr.couldNotVerifyWorkdayIdentity);
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
                              return Text(context.tr.couldNotVerifyManagerAccount);
                            }
                            if (unresolved) {
                              return Column(
                                children: [
                                  Text(
                                    context.tr.previousSubmissionPendingContactAdmin,
                                  ),
                                  TextButton(
                                    onPressed: _submittingFinal
                                        ? null
                                        : () => _reconcileFinal(state, action),
                                    child: Text(context.tr.refreshDailyCloseStatus),
                                  ),
                                ],
                              );
                            }
                            if (state.serverSubmitted == true) {
                              return Text(
                                context.tr.dailyCloseFinalSubmitted,
                              );
                            }
                            final eligibility = _eligibility;
                            final isBlockedByOlder =
                                eligibility?.status ==
                                DailyCloseEligibilityStatus.blockedByOlderWorkday;
                            final isEligibilityUnverified =
                                !_loadingEligibility &&
                                (eligibility == null ||
                                    eligibility.status ==
                                        DailyCloseEligibilityStatus
                                            .verificationFailed);
                            final canPressFinalSubmit =
                                state.canSubmitFinal &&
                                !state.isSubmitted &&
                                !_submittingFinal &&
                                !_loadingEligibility &&
                                (eligibility?.isEligible ?? false);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (state.businessDate != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: Text(
                                      state.businessDate!,
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                if (_loadingEligibility)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (isBlockedByOlder ||
                                    isEligibilityUnverified) ...[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: isBlockedByOlder
                                          ? Colors.orange.shade50
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isBlockedByOlder
                                            ? Colors.orange.shade200
                                            : Colors.red.shade200,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          isBlockedByOlder
                                              ? context.tr.closeWorkdayDateFirst(
                                                  eligibility!
                                                      .localizedBlockingDate(
                                                    lang,
                                                  ),
                                                )
                                              : (eligibility
                                                        ?.failure
                                                        ?.error
                                                        .message ??
                                                    context
                                                        .tr
                                                        .couldNotVerifyPendingClosures),
                                          style: AppStyles.s12W500.copyWith(
                                            color: isBlockedByOlder
                                                ? Colors.orange.shade900
                                                : Colors.red.shade800,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _refreshWorkdayAndEligibility(
                                                state,
                                              ),
                                          child: Text(
                                            isBlockedByOlder
                                                ? context
                                                      .tr
                                                      .refreshDailyCloseStatus
                                                : context
                                                      .tr
                                                      .retryLoadPendingClosures,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (_lastSubmissionRejection != null) ...[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Colors.red.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      _lastSubmissionRejection!,
                                      style: AppStyles.s12W500.copyWith(
                                        color: Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                                AppButton(
                                  onClick: () => _submitFinal(state),
                                  enabled: canPressFinalSubmit,
                                  text: _submittingFinal
                                      ? context.tr.submittingDailyClose
                                      : context.tr.submitDailyCloseFinal,
                                ),
                              ],
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
