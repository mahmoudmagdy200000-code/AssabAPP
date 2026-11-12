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
    this.disabledReason,
    this.shiftDate,
    this.startTime,
    this.endTime,
  });
  final String shiftId;
  final ShiftStatus selectedShiftsStatus;
  final UserType? actorRole;
  final bool canStart;
  final String? disabledReason;
  final dynamic shiftDate;
  final String? startTime;
  final String? endTime;

  @override
  State<CashierStartShiftButton> createState() => _CashierStartShiftButtonState();
}

class _CashierStartShiftButtonState extends State<CashierStartShiftButton> {
  Timer? _ticker;
  late bool _canStart;
  String? _disabledReason;

  @override
  void initState() {
    super.initState();
    _evaluate();
    _startTicker();
  }

  @override
  void didUpdateWidget(CashierStartShiftButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shiftDate != oldWidget.shiftDate ||
        widget.startTime != oldWidget.startTime ||
        widget.endTime != oldWidget.endTime ||
        widget.canStart != oldWidget.canStart ||
        widget.disabledReason != oldWidget.disabledReason) {
      _evaluate();
    }
  }

  void _evaluate() {
    if (widget.shiftDate != null && widget.startTime != null && widget.endTime != null) {
      final status = ShiftStartWindowHelper.evaluate(
        shiftDate: widget.shiftDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
      );
      _canStart = status.canStart;
      _disabledReason = status.disabledReason;
    } else {
      _canStart = widget.canStart;
      _disabledReason = widget.disabledReason;
    }
  }

  void _startTicker() {
    if (widget.shiftDate != null && widget.startTime != null && widget.endTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        final status = ShiftStartWindowHelper.evaluate(
          shiftDate: widget.shiftDate,
          startTime: widget.startTime,
          endTime: widget.endTime,
        );
        if (status.canStart != _canStart || status.disabledReason != _disabledReason) {
          if (mounted) {
            setState(() {
              _canStart = status.canStart;
              _disabledReason = status.disabledReason;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onClick: () {
                  if (_canStart) {
                    context.read<StartCashierShiftCubit>().startShift(
                      shiftId: widget.shiftId,
                      actorRole: widget.actorRole,
                    );
                  }
                },
                text: context.tr.start_shift,
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
                  maxLines: 1,
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
