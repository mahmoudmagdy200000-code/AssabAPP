import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:flutter/material.dart';

abstract class ShiftStatus {
  ShiftStatusType get type;
  String get name;
  String get icon;
  String get title;
  String get desc;

  void get(BuildContext context, {bool loadMore = false});
}
