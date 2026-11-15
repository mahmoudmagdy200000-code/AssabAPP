import 'dart:async';

import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:flutter/widgets.dart';

class CashierShiftEndGate extends StatefulWidget {
  const CashierShiftEndGate({
    super.key,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.builder,
  });

  final DateTime? shiftDate;
  final String startTime;
  final String endTime;
  final Widget Function(bool canEnd) builder;

  @override
  State<CashierShiftEndGate> createState() => _CashierShiftEndGateState();
}

class _CashierShiftEndGateState extends State<CashierShiftEndGate> {
  late final Timer _clock;
  late bool _canEnd;

  bool get _canEndNow => ShiftStartWindowHelper.hasReachedScheduledEnd(
    shiftDate: widget.shiftDate,
    startTime: widget.startTime,
    endTime: widget.endTime,
  );

  @override
  void initState() {
    super.initState();
    _canEnd = _canEndNow;
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      final canEnd = _canEndNow;
      if (canEnd != _canEnd) setState(() => _canEnd = canEnd);
    });
  }

  @override
  void didUpdateWidget(CashierShiftEndGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    _canEnd = _canEndNow;
  }

  @override
  void dispose() {
    _clock.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_canEnd);
}
