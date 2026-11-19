import 'dart:async';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../logic/cashier/start_cashier_shift_cubit.dart';

class CashierStartShiftButton extends StatefulWidget {
  const CashierStartShiftButton({
    super.key,
    required this.selectedShiftsStatus,
    required this.shiftId,
    this.actorRole,
    this.canStart = true,
    this.serverCanStart,
    this.canStartLate,
    this.isLateStart,
    this.requiresManagerAuthorization,
    this.isNextShift,
    this.windowPhase,
    this.disabledReason,
    this.startDisabledCode,
    this.shiftDate,
    this.startTime,
    this.endTime,
  });
  final String shiftId;
  final ShiftStatus selectedShiftsStatus;
  final UserType? actorRole;
  final bool canStart;
  final bool? serverCanStart;
  final bool? canStartLate;
  final bool? isLateStart;
  final bool? requiresManagerAuthorization;
  final bool? isNextShift;
  final String? windowPhase;
  final String? disabledReason;
  final String? startDisabledCode;
  final dynamic shiftDate;
  final String? startTime;
  final String? endTime;

  @override
  State<CashierStartShiftButton> createState() => _CashierStartShiftButtonState();
}

class _CashierStartShiftButtonState extends State<CashierStartShiftButton> {
  Timer? _ticker;
  late bool _canStart;
  bool _isLateStart = false;
  String? _disabledReason;
  String _languageCode = 'ar';

  @override
  void initState() {
    super.initState();
    _evaluate();
    _startTicker();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextLang = Localizations.maybeLocaleOf(context)?.languageCode ?? 'ar';
    if (nextLang != _languageCode) {
      _languageCode = nextLang;
      _evaluate();
    }
  }

  @override
  void didUpdateWidget(CashierStartShiftButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shiftDate != oldWidget.shiftDate ||
        widget.startTime != oldWidget.startTime ||
        widget.endTime != oldWidget.endTime ||
        widget.canStart != oldWidget.canStart ||
        widget.serverCanStart != oldWidget.serverCanStart ||
        widget.canStartLate != oldWidget.canStartLate ||
        widget.isLateStart != oldWidget.isLateStart ||
        widget.isNextShift != oldWidget.isNextShift ||
        widget.windowPhase != oldWidget.windowPhase ||
        widget.disabledReason != oldWidget.disabledReason ||
        widget.startDisabledCode != oldWidget.startDisabledCode) {
      _evaluate();
    }
  }

  void _evaluate() {
    final isManager = widget.actorRole == UserType.branchManager;
    final effectiveServerCanStart =
        widget.serverCanStart ?? (widget.canStart ? null : false);

    if (widget.shiftDate != null && widget.startTime != null && widget.endTime != null) {
      final result = ShiftStartWindowHelper.resolveStartEligibility(
        shiftDate: widget.shiftDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
        isNextShift: widget.isNextShift ?? true,
        isBranchManager: isManager,
        serverCanStart: effectiveServerCanStart,
        serverCanStartLate: widget.canStartLate,
        serverIsLateStart: widget.isLateStart,
        requiresManagerAuthorization: widget.requiresManagerAuthorization,
        serverWindowPhase: widget.windowPhase,
        serverDisabledReason: widget.disabledReason,
        serverDisabledCode: widget.startDisabledCode,
        languageCode: _languageCode,
      );
      _canStart = result.canStart;
      _isLateStart = result.isLateStart;
      _disabledReason = result.reason;
    } else {
      _canStart = widget.serverCanStart ?? widget.canStart;
      _isLateStart = widget.isLateStart ?? false;
      _disabledReason = widget.disabledReason;
    }
  }

  void _startTicker() {
    if (widget.shiftDate != null && widget.startTime != null && widget.endTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        final prevCanStart = _canStart;
        final prevLate = _isLateStart;
        final prevReason = _disabledReason;
        _evaluate();
        if (_canStart != prevCanStart ||
            _isLateStart != prevLate ||
            _disabledReason != prevReason) {
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  Future<void> _onStartPressed(BuildContext context) async {
    if (!_canStart) return;
    final cubit = context.read<StartCashierShiftCubit>();

    if (_isLateStart && widget.actorRole == UserType.branchManager) {
      final reason = await _promptLateStartReason(context);
      if (reason == null || !mounted) return;
      await cubit.startLateShiftByManager(
        shiftId: widget.shiftId,
        lateStartReason: reason,
      );
      return;
    }

    await cubit.startShift(
      shiftId: widget.shiftId,
      actorRole: widget.actorRole,
    );
  }

  Future<String?> _promptLateStartReason(BuildContext context) async {
    final isEn = _languageCode.toLowerCase().startsWith('en');
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isEn ? 'Authorize Late Shift Start' : 'تأكيد بدء الوردية المتأخر',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEn
                  ? 'Normal start window has ended. Confirm manager authorization for late start.'
                  : 'انتهت نافذة البدء الطبيعية. يرجى تأكيد موافقة مدير الفرع للبدء المتأخر.',
              style: AppStyles.s12W400,
            ),
            10.verticalSpace,
            TextField(
              controller: controller,
              maxLength: 250,
              decoration: InputDecoration(
                hintText: isEn ? 'Late start reason (optional)' : 'سبب التأخير (اختياري)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(isEn ? 'Cancel' : 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.of(dialogContext).pop(
                text.isEmpty ? 'Branch manager authorized late start' : text,
              );
            },
            child: Text(isEn ? 'Authorize & Start' : 'تأكيد والبدء'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEn = _languageCode.toLowerCase().startsWith('en');
    final buttonText = (_canStart && _isLateStart && widget.actorRole == UserType.branchManager)
        ? (isEn ? 'Late Start' : 'بدء متأخر')
        : context.tr.start_shift;

    return BlocBuilder<StartCashierShiftCubit, StartCashierShiftState>(
      buildWhen: (prev, curr) {
        final prevId = prev is StartCashierShiftLoading
            ? prev.loadingShiftId
            : null;
        final currId = curr is StartCashierShiftLoading
            ? curr.loadingShiftId
            : null;
        return prevId != currId;
      },
      builder: (context, state) {
        final isLoading =
            state is StartCashierShiftLoading &&
            state.loadingShiftId == widget.shiftId;

        if (isLoading) {
          return const Expanded(child: AppButtonLoading());
        }
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                padding: EdgeInsets.all(12.w),
                borderRadius: BorderRadius.circular(12.r),
                onClick: () => _onStartPressed(context),
                text: buttonText,
                enabled: _canStart,
                isTransparent: !_canStart,
                borderColor: context.customColor.border,
              ),
              if (!_canStart && _disabledReason != null && _disabledReason!.isNotEmpty) ...[
                4.verticalSpace,
                Text(
                  _disabledReason!,
                  style: AppStyles.s10W400.copyWith(color: context.customColor.error),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
