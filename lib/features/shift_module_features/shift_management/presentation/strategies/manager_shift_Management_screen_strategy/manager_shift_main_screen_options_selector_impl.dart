import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_options_selector.dart';
import 'package:flutter/src/widgets/framework.dart';

class ManagerShiftsAllOption extends ManagerMainScreenOptions {
  @override
  String name(BuildContext context) {
    return context.tr.all;
  }
}

class ManagerShiftsShiftDetailsOption extends ManagerMainScreenOptions {
  @override
  String name(BuildContext context) => context.tr.shiftDetails;
}

class ManagerShiftsHandOffsReceivedOption extends ManagerMainScreenOptions {
  @override
  String name(BuildContext context) => context.tr.handoffsReceived;
}

class ManagerShiftsFinalHandOverOption extends ManagerMainScreenOptions {
  @override
  String name(BuildContext context) => context.tr.finalHandOver;
}
