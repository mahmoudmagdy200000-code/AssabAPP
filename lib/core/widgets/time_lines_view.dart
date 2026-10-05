import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/shared/models/time_line_response.dart';
import 'package:flutter/material.dart';

class TimeLinesView extends StatelessWidget {
  final List<TimeLineItem> timelines;

  const TimeLinesView({super.key, required this.timelines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: ListView.builder(
        itemCount: timelines.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Column(
            children: [
              timelines[index].eventType.buildTimeLineItem(
                context,
                timelines[index],
              ),
              16.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}
