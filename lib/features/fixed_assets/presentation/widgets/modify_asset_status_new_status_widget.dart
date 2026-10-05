import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/fixed_assets_condition_enum.dart';

class ModifyAssetStatusNewStatusWidget extends StatelessWidget {
  const ModifyAssetStatusNewStatusWidget({super.key});

  List<FixedAssetsConditionEnum> get _statuses => [
    FixedAssetsConditionEnum.excellent,
    FixedAssetsConditionEnum.needAttention,
    FixedAssetsConditionEnum.problem,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.newStatus),
        12.verticalSpace,
        BlocBuilder<ChooseItemCubit, ChooseItemState>(
          builder: (context, state) {
            return Column(
              children: List.generate(
                _statuses.length,
                (index) => _buildStatusItem(
                  context,
                  text: _statuses[index].label(context),
                  index: index,
                  isSelected: state.selectedIndex == index,
                  status: _statuses[index],
                ),
              ),
            );
          },
        ),
        12.verticalSpace,
        LabelTextField(text: context.tr.reasonForChange),
        8.verticalSpace,
        ContainerCustomTextField(
          backgroundColor: Colors.transparent,
          child: CustomTextField(
            maxLines: 4,
            hintText: context.tr.reason,
            onChanged: (value) {
              context.read<ValidationCubit>().validateFieldAndStoreValue(
                fieldName: 'reason',
                value: value,
                isValid: value.isNotEmpty,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String text,
    required int index,
    required bool isSelected,
    required FixedAssetsConditionEnum status,
  }) {
    return AppGestureDetectorButton(
      onTap: () {
        context.read<ChooseItemCubit>().selectItem(index);
        context.read<ValidationCubit>().validateFieldAndStoreValue(
          fieldName: 'newStatus',
          value: status.value,
          isValid: true,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.customColor.border,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 15.r,
              height: 15.r,
              decoration: BoxDecoration(
                color: status.color,
                shape: BoxShape.circle,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                text,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
