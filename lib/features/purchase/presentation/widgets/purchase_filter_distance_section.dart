import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';

class PurchaseFilterDistanceSection<B extends BlocBase<S>, S>
    extends StatelessWidget {
  final double Function(S state) selector;
  final void Function(B bloc, double newValue) onChangedSlider;

  const PurchaseFilterDistanceSection({
    super.key,
    required this.selector,
    required this.onChangedSlider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.distance,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Text(
          context.tr.onlyShowBranchesWithin5km,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              BlocSelector<B, S, double>(
                bloc: context.read<B>(),
                selector: (state) => selector(state),
                builder: (context, state) {
                  return Slider(
                    value: state,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${state.toInt()} ${context.tr.km}',
                    onChanged: (double value) {
                      onChangedSlider(context.read<B>(), value);
                    },
                    padding: EdgeInsets.zero,
                    activeColor: context.theme.primaryColor,
                    inactiveColor: context.customColor.border,
                  );
                },
              ),
              16.verticalSpace,
              Row(
                children: [
                  Text(
                    '5 ${context.tr.km}',
                    style: AppStyles.s16W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    '24 ${context.tr.mins}',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '100 ${context.tr.km}+',
                    style: AppStyles.s16W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
