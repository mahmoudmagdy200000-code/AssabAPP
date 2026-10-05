import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

abstract class PrioritiesStrategy {
  String priorityLabel(BuildContext context);

  String get priorityValue;

  Color get color;
}

final class NormalPriorityStrategy implements PrioritiesStrategy {
  @override
  String get priorityValue => 'normal';

  @override
  String priorityLabel(BuildContext context) => context.tr.normal;

  @override
  Color get color => AppColors.lightGreen;
}

class HighPriorityStrategy extends PrioritiesStrategy {
  @override
  String priorityLabel(BuildContext context) => context.tr.high;

  @override
  String get priorityValue => 'high';

  @override
  Color get color => AppColors.errorLight;
}

class MediumPriorityStrategy extends PrioritiesStrategy {
  @override
  String priorityLabel(BuildContext context) => context.tr.medium;

  @override
  String get priorityValue => 'medium';

  @override
  Color get color => AppColors.orange;
}

class LowPriorityStrategy extends PrioritiesStrategy {
  @override
  String priorityLabel(BuildContext context) => context.tr.low;

  @override
  String get priorityValue => 'low';

  @override
  Color get color => AppColors.lightGreen;
}
