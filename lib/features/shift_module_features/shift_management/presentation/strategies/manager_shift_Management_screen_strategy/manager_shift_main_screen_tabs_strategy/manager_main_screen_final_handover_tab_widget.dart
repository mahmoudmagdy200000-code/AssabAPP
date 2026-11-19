import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/pending_daily_closure_item.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/final_handover_widget.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/historical_final_handover_sheet_widget.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/no_final_handover_widget.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/pending_daily_closures_section_widget.dart';
import 'manager_main_screen_tab_strategy.dart';

class ManagerMainScreenFinalHandoverTabWidget
    extends ManagerMainScreenTabStrategy {
  final String shiftDate;
  final ShiftStatusType shiftStatus;
  final CurrentShiftEntity currentManagerShift;
  final FutureApiResult<List<PendingDailyClosureItem>> Function({
    required String actorId,
    required String branchId,
  })?
  loadPendingClosures;
  final Future<void> Function(
    String workdayId,
    DailyCloseWorkdayEligibility? eligibility,
  )?
  onOpenDailyClose;

  ManagerMainScreenFinalHandoverTabWidget({
    required this.shiftDate,
    required this.shiftStatus,
    required this.currentManagerShift,
    this.loadPendingClosures,
    this.onOpenDailyClose,
  });

  @override
  Widget buildTabContent(BuildContext context) {
    return _ManagerFinalHandoverTabContent(
      shiftDate: shiftDate,
      shiftStatus: shiftStatus,
      currentManagerShift: currentManagerShift,
      loadPendingClosures: loadPendingClosures,
      onOpenDailyClose: onOpenDailyClose,
    );
  }
}

class _ManagerFinalHandoverTabContent extends StatefulWidget {
  const _ManagerFinalHandoverTabContent({
    required this.shiftDate,
    required this.shiftStatus,
    required this.currentManagerShift,
    this.loadPendingClosures,
    this.onOpenDailyClose,
  });

  final String shiftDate;
  final ShiftStatusType shiftStatus;
  final CurrentShiftEntity currentManagerShift;
  final FutureApiResult<List<PendingDailyClosureItem>> Function({
    required String actorId,
    required String branchId,
  })?
  loadPendingClosures;
  final Future<void> Function(
    String workdayId,
    DailyCloseWorkdayEligibility? eligibility,
  )?
  onOpenDailyClose;

  @override
  State<_ManagerFinalHandoverTabContent> createState() =>
      _ManagerFinalHandoverTabContentState();
}

class _ManagerFinalHandoverTabContentState
    extends State<_ManagerFinalHandoverTabContent> {
  bool _loading = true;
  ApiFailure? _failure;
  List<PendingDailyClosureItem> _allPending = const [];

  @override
  void initState() {
    super.initState();
    _fetchAllPending();
  }

  @override
  void didUpdateWidget(covariant _ManagerFinalHandoverTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentManagerShift.shift.id !=
            widget.currentManagerShift.shift.id ||
        oldWidget.shiftDate != widget.shiftDate ||
        oldWidget.shiftStatus != widget.shiftStatus) {
      _fetchAllPending();
    }
  }

  Future<void> _fetchAllPending() async {
    setState(() {
      _loading = true;
      _failure = null;
    });

    final ApiResult<List<PendingDailyClosureItem>> result;
    final prefs = await SharedPreferences.getInstance();
    final actorId = prefs.getString('u_id') ?? '';
    final branchId = widget.currentManagerShift.shift.shiftDetails.branchId;

    if (widget.loadPendingClosures != null) {
      result = await widget.loadPendingClosures!(
        actorId: actorId,
        branchId: branchId,
      );
    } else if (getIt.isRegistered<ShiftManagementRepositoryImp>()) {
      result = await getIt<ShiftManagementRepositoryImp>()
          .getPendingDailyClosures(actorId: actorId, branchId: branchId);
    } else {
      result = ApiResult<List<PendingDailyClosureItem>>.failure(
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

    if (!mounted) return;
    result.when(
      failure: (failure) => setState(() {
        _loading = false;
        _failure = failure;
      }),
      success: (items) => setState(() {
        _loading = false;
        _allPending = items;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProgressEntity progress = widget.currentManagerShift.progress;
    final isEn = Localizations.localeOf(context).languageCode.startsWith('en');

    final todayEligibility = PendingDailyClosureItem.evaluateWorkday(
      workdayId: widget.currentManagerShift.shift.id,
      businessDate: widget.currentManagerShift.shift.shiftDate,
      orderedPending: _allPending,
      loadFailure: _failure,
    );

    final Widget todaySection;
    if (widget.shiftStatus == ShiftStatusType.pending) {
      todaySection = NoFinalHanOverWidget(
        progress: progress,
        shiftDate: widget.shiftDate,
        title: context.tr.shiftNotStarted,
        firstSubTitle: context.tr.uHaventStartedYourShiftYet,
        secondSubTitle: context.tr.uNeedToBeginTheShift,
        buttonText: context.tr.start_shift,
        buttonColor: AppColors.primaryLight,
        buttonOnTap: () {
          context.read<ManagerShiftCubit>().startManagerShift();
        },
      );
    } else if (widget.shiftStatus == ShiftStatusType.inProgress) {
      todaySection = NoFinalHanOverWidget(
        progress: progress,
        shiftDate: widget.shiftDate,
        title: context.tr.EndShiftFirst,
        firstSubTitle: context.tr.youNeedToEndYourShiftBeforeFinalHandOver,
        secondSubTitle: context.tr.wrapUpYourShiftActivities,
        buttonText: context.tr.end_shift,
        buttonColor: progress.hasEnded(shiftDate: widget.shiftDate)
            ? AppColors.lightGreen
            : AppColors.red,
        buttonOnTap: () {
          NavigationService.I.pushNamed(
            AppRouteName.endManagerShiftScreen,
            arguments: {
              'handovers': widget.currentManagerShift.handover,
              'managerName':
                  widget.currentManagerShift.shift.shiftDetails.managerName,
              'managerCubit': context.read<ManagerShiftCubit>(),
              'serverCanEnd': widget.currentManagerShift.canEnd,
            },
          );
        },
      );
    } else {
      todaySection = FinalHandoverWidget(
        currentManagerShift: widget.currentManagerShift,
        eligibility: todayEligibility,
        isLoadingEligibility: _loading,
        onRetryEligibility: _fetchAllPending,
        onReturnedFromSubmission: _fetchAllPending,
        onOpenDailyClose: widget.onOpenDailyClose,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        todaySection,
        12.verticalSpace,
        PendingDailyClosuresSectionWidget(
          currentManagerShift: widget.currentManagerShift,
          sharedAllPending: _allPending,
          sharedLoading: _loading,
          sharedFailure: _failure,
          onRetryShared: _fetchAllPending,
          onAfterClosureReturned: _fetchAllPending,
          onOpenClosure: widget.onOpenDailyClose == null
              ? null
              : (item) => widget.onOpenDailyClose!(
                  item.id,
                  PendingDailyClosureItem.evaluateWorkday(
                    workdayId: item.id,
                    businessDate: item.shiftDate,
                    orderedPending: _allPending,
                    loadFailure: _failure,
                  ),
                ),
        ),
        12.verticalSpace,
        AppButton(
          onClick: () {
            AppBottomSheet.showModal(
              context,
              (_) => const HistoricalFinalHandoverSheetWidget(),
              isScrollControlled: true,
            );
          },
          enabled: true,
          isTransparent: true,
          borderColor: context.customColor.border,
          textColor: context.customColor.text1,
          borderRadius: BorderRadius.circular(10.r),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          text: isEn
              ? 'Previous Final Handovers'
              : 'عرض التسليمات النهائية السابقة',
        ),
        12.verticalSpace,
      ],
    );
  }
}
