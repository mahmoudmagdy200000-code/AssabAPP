import 'dart:async';

import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';

class ShiftProgressIndicator extends StatefulWidget {
  final String startTime;
  final String endTime;
  final String? actualStart;
  final String? actualEnd;

  const ShiftProgressIndicator({
    super.key,
    required this.startTime,
    required this.endTime,
    this.actualEnd,
    this.actualStart,
  });

  @override
  State<ShiftProgressIndicator> createState() => _ShiftProgressIndicatorState();
}

class _ShiftProgressIndicatorState extends State<ShiftProgressIndicator> {
  late double progress;
  late double elapsedHours;
  late double totalHours;
  Timer? _timer;

  DateTime _toDate(String time, {int year = 2000, int month = 1, int day = 1}) {
    final t = DateFormat('HH:mm').parse(time);
    return DateTime(year, month, day, t.hour, t.minute);
  }

  int _plannedMinutes() {
    final startParts = widget.startTime.split(':');
    final endParts = widget.endTime.split(':');

    int startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    int endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    int minutes = endMinutes - startMinutes;
    if (minutes <= 0) minutes += 24 * 60; // overnight

    return minutes;
  }

  @override
  @override
  void initState() {
    super.initState();

    progress = 0;
    elapsedHours = 0;
    totalHours = 0;

    _updateProgress();

    // Start timer only if shift is ongoing
    if (widget.actualStart != null &&
        (widget.actualEnd == null || widget.actualEnd!.isEmpty)) {
      _timer = Timer.periodic(
        const Duration(minutes: 1),
        (_) => _updateProgress(),
      );
    }
  }

  void _updateProgress() {
    final now = DateTime.now();

    // Total planned shift duration in minutes
    final plannedMinutes = _plannedMinutes();

    int elapsedMinutes = 0;

    // Shift hasn't started
    if (widget.actualStart == null || widget.actualStart!.isEmpty) {
      elapsedMinutes = 0;
    } else {
      //  Shift started
      final actualStart = DateTime.parse(widget.actualStart!);

      if (widget.actualEnd != null && widget.actualEnd!.isNotEmpty) {
        // Shift finished
        final actualEnd = DateTime.parse(widget.actualEnd!);
        elapsedMinutes = actualEnd.difference(actualStart).inMinutes;
      } else {
        // Shift ongoing
        elapsedMinutes = now.difference(actualStart).inMinutes;
      }

      if (elapsedMinutes < 0) elapsedMinutes = 0; // safety
    }

    setState(() {
      elapsedHours = elapsedMinutes / 60;
      totalHours = plannedMinutes / 60;

      // Show progress relative to planned shift duration
      progress = elapsedMinutes / plannedMinutes;
      // Remove clamp if you want progress to exceed 100% when overtime
      // progress = (elapsedMinutes / plannedMinutes).clamp(0.0, 1.0);
    });
  }

  String _formatTime(String time24h) {
    final date = DateFormat('HH:mm').parse(time24h);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatHours(double hours) {
    return hours % 1 == 0 ? hours.toInt().toString() : hours.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final formattedElapsed = _formatHours(elapsedHours);
    final formattedTotal = _formatHours(totalHours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(fontSize: 14.w, color: Colors.black),
                  children: [
                    TextSpan(
                      text: formattedElapsed,
                      style: AppStyles.s18W600.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    TextSpan(
                      text: context.tr.slashWithTotalHrs(formattedTotal),
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.horizontalSpace,

            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ],
        ),

        7.verticalSpace,

        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primaryLight,
            minHeight: 12.h,
          ),
        ),

        7.verticalSpace,

        // Start / End times
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _formatTime(widget.startTime),
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            10.horizontalSpace,
            Flexible(
              child: Text(
                _formatTime(widget.endTime),
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
