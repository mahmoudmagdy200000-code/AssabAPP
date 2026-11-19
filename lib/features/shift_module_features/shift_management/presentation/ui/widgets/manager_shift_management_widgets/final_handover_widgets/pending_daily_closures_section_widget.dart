import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/pending_daily_closure_item.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cashier_shifts_management_widgets/cashier_info_container_widget.dart';

class PendingDailyClosuresSectionWidget extends StatefulWidget {
  const PendingDailyClosuresSectionWidget({
    super.key,
    required this.currentManagerShift,
    this.loadPending,
    this.onOpenClosure,
  });

  final CurrentShiftEntity currentManagerShift;
  final FutureApiResult<List<PendingDailyClosureItem>> Function()? loadPending;
  final Future<void> Function(PendingDailyClosureItem item)? onOpenClosure;

  @override
  State<PendingDailyClosuresSectionWidget> createState() =>
      _PendingDailyClosuresSectionWidgetState();
}

class _PendingDailyClosuresSectionWidgetState
    extends State<PendingDailyClosuresSectionWidget> {
  bool _loading = true;
  ApiFailure? _failure;
  List<PendingDailyClosureItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void didUpdateWidget(covariant PendingDailyClosuresSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentManagerShift.shift.id !=
        widget.currentManagerShift.shift.id) {
      _fetch();
    }
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _failure = null;
    });

    final result = widget.loadPending != null
        ? await widget.loadPending!()
        : await _defaultLoad();

    if (!mounted) return;
    result.when(
      failure: (failure) => setState(() {
        _loading = false;
        _failure = failure;
      }),
      success: (items) => setState(() {
        _loading = false;
        _items = items;
      }),
    );
  }

  FutureApiResult<List<PendingDailyClosureItem>> _defaultLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final actorId = prefs.getString('u_id') ?? '';
    final branchId = widget.currentManagerShift.shift.shiftDetails.branchId;
    return getIt<ShiftManagementRepositoryImp>().getPendingDailyClosures(
      actorId: actorId,
      branchId: branchId,
      excludeWorkdayId: widget.currentManagerShift.shift.id,
    );
  }

  Future<void> _openItem(PendingDailyClosureItem item) async {
    if (widget.onOpenClosure != null) {
      await widget.onOpenClosure!(item);
      await _fetch();
      return;
    }
    final managerCubit = context.read<ManagerShiftCubit>();
    final branchName = item.branchName.isNotEmpty
        ? item.branchName
        : widget.currentManagerShift.shift.shiftDetails.storeBranch;
    await NavigationService.I.pushNamed(
      AppRouteName.updateManagerFinalDailyCloseScreen,
      arguments: {
        'manager_workday_id': item.id,
        'branchName': branchName,
        'managerCubit': managerCubit,
      },
    );
    if (!mounted) return;
    await managerCubit.getCurrentShift();
    await _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final isEn = Localizations.localeOf(context).languageCode.startsWith('en');

    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_failure != null) {
      return CashierInfoContainerWidget(
        children: [
          Text(
            context.tr.pendingDailyClosuresTitle,
            style: AppStyles.s14W600,
          ),
          6.verticalSpace,
          Text(
            _failure!.error.message ?? context.tr.dailyCloseRejectedByServer,
            style: AppStyles.s12W400.copyWith(color: AppColors.red),
          ),
          8.verticalSpace,
          AppButton(
            onClick: _fetch,
            enabled: true,
            isTransparent: true,
            borderRadius: BorderRadius.circular(8.r),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            text: context.tr.retryLoadPendingClosures,
          ),
        ],
      );
    }

    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr.pendingDailyClosuresTitle,
                style: AppStyles.s14W600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '${_items.length}',
                style: AppStyles.s12W600.copyWith(
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Text(
          context.tr.pendingDailyClosuresSubtitle,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        const CustomDivider(),
        for (var i = 0; i < _items.length; i++) ...[
          _PendingClosureCard(
            item: _items[i],
            isOldestAllowed: i == 0,
            isEn: isEn,
            onSubmit: () => _openItem(_items[i]),
          ),
          if (i < _items.length - 1) const CustomDivider(),
        ],
      ],
    );
  }
}

class _PendingClosureCard extends StatelessWidget {
  const _PendingClosureCard({
    required this.item,
    required this.isOldestAllowed,
    required this.isEn,
    required this.onSubmit,
  });

  final PendingDailyClosureItem item;
  final bool isOldestAllowed;
  final bool isEn;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final salesText = item.totalSales.toStringAsFixed(2);
    final cashText = item.cashCollected.toStringAsFixed(2);
    final statusText = isEn
        ? 'Completed • Not Submitted'
        : 'مكتمل • غير مُرسل';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.shiftDate,
                style: AppStyles.s13W600,
              ),
            ),
            Text(
              statusText,
              style: AppStyles.s12W500.copyWith(color: Colors.orange.shade800),
            ),
          ],
        ),
        4.verticalSpace,
        Wrap(
          spacing: 12.w,
          runSpacing: 4.h,
          children: [
            Text(
              isEn ? 'Sales: $salesText SAR' : 'المبيعات: $salesText ر.س',
              style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
            ),
            Text(
              isEn ? 'Cash: $cashText SAR' : 'الكاش: $cashText ر.س',
              style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
            ),
            if (item.handoverStatus.isNotEmpty)
              Text(
                isEn
                    ? 'Handover: ${item.handoverStatus}'
                    : 'التسليم: ${item.handoverStatus}',
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
          ],
        ),
        if (!isOldestAllowed) ...[
          6.verticalSpace,
          Text(
            context.tr.closeOldestPendingWorkdayFirst,
            style: AppStyles.s12W400.copyWith(color: Colors.orange.shade800),
          ),
        ],
        8.verticalSpace,
        AppButton(
          onClick: onSubmit,
          enabled: isOldestAllowed,
          borderRadius: BorderRadius.circular(8.r),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          text: context.tr.submitDailyCloseFinal,
        ),
      ],
    );
  }
}
