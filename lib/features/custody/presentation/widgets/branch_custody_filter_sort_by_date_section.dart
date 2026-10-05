import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/time_keys.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/selection_circule.dart';

class BranchCustodyFilterSortByDateSection<B extends BlocBase<S>, S>
    extends StatelessWidget {
  final void Function(TimeKeys time) onTap;
  final TimeKeys Function(S state) state;

  const BranchCustodyFilterSortByDateSection({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
        sliver: SliverList.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            final texts = [
              context.tr.last24Hours,
              context.tr.last7Days,
              context.tr.last30Days,
              // context.tr.custom,
            ];

            final sortOptions = [
              TimeKeys.last24Hours,
              TimeKeys.last7Days,
              TimeKeys.last30Days,
              // TimeKeys.custom,
            ];

            final selectedTime = sortOptions[index];

            return AppGestureDetectorButton(
              onTap: () => onTap(selectedTime),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index != texts.length - 1
                        ? BorderSide(color: context.customColor.border)
                        : BorderSide.none,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 13.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        texts[index],
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    BlocSelector<B, S, bool>(
                      bloc: context.read<B>(),
                      selector: (state) => this.state(state) == selectedTime,
                      builder: (context, state) {
                        return SelectionCircule(isSelected: state);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
