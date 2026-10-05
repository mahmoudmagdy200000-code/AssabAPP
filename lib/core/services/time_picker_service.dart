import 'package:flutter/material.dart';

class TimePickerService {
  TimePickerService._();

  static Future<void> showTimePickerDialog(
    BuildContext context, {
    required void Function(TimeOfDay? time) onTimePicked,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    onTimePicked(time);
  }
}
