import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../domain/strategies/repeat_frequency_strategy.dart';
import 'recurring_order_setting_choose_item_widget.dart';

class RecurringOrderSettingRepeatFrequencyWidget extends StatelessWidget {
  const RecurringOrderSettingRepeatFrequencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ChooseItemCubit>();
        final strategy = context
            .read<ValidationCubit>()
            .getTypedValue<RepeatFrequencyStrategy>('repeatFrequencyType');
        if (strategy is WeeklyRepeatFrequencyStrategy) {
          cubit.selectItem(0);
        } else if (strategy is MonthlyRepeatFrequencyStrategy) {
          cubit.selectItem(1);
        } else if (strategy is BasedOnInventoryLevelRepeatFrequencyStrategy) {
          cubit.selectItem(2);
        }
        return cubit;
      },
      child: const _RecurringOrderSettingRepeatFrequencyWidget(),
    );
  }
}

class _RecurringOrderSettingRepeatFrequencyWidget extends StatelessWidget {
  const _RecurringOrderSettingRepeatFrequencyWidget();

  List<String> _repeatFrequencyList(BuildContext context) => [
    context.tr.weekly,
    context.tr.monthly,
    context.tr.basedOnInventoryLevel,
  ];

  List<RepeatFrequencyStrategy> get _repeatFrequencyStrategyList => [
    WeeklyRepeatFrequencyStrategy(),
    MonthlyRepeatFrequencyStrategy(),
    BasedOnInventoryLevelRepeatFrequencyStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(text: context.tr.repeatFrequency),
          Text(
            context.tr.setHowOftenThisOrderShouldRepeat,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          ...List.generate(3, (index) {
            return BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
              selector: (state) => state.selectedIndex == index,
              builder: (context, state) {
                return RecurringOrderSettingChooseItemWidget(
                  text: _repeatFrequencyList(context)[index],
                  singleSelection: true,
                  isSelected: state,
                  onTap: () {
                    context.read<ChooseItemCubit>().selectItem(index);

                    context
                        .read<ValidationCubit>()
                        .validateFieldAndStoreTypedValue<
                          RepeatFrequencyStrategy
                        >(
                          fieldName: 'repeatFrequencyType',
                          value: _repeatFrequencyStrategyList[index],
                          isValid: true,
                        );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
