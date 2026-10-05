import 'package:flutter/material.dart';

import '../../../../../domain/entity/shift/shift_entity.dart';
import '../../../arguments/shift_arguments.dart';

abstract class ShiftTabStrategy {
  Widget buildTabContent(
    BuildContext context, {
    required ShiftEntity shift,
    ShiftArguments? shiftArguments,
  });
}
