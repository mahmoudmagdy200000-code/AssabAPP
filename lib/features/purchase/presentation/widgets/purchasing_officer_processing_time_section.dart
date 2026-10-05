import 'package:assab/core/enums/purchasing_officer_processing_time_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/purchase/presentation/cubit/purchasing_officer_select_processing_time/purchasing_officer_select_processing_time_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/purchasing_officer_select_processing_time/purchasing_officer_select_processing_time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/label_text_field.dart';

class PurchasingOfficerProcessingTimeSection extends StatelessWidget {
  final String addedItemMainId;

  const PurchasingOfficerProcessingTimeSection({
    super.key,
    required this.addedItemMainId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.processingTime),
        Row(
          children: List.generate(2, (index) {
            final labels = [context.tr.standard, context.tr.urgent];
            final desc = ['3-5 business days', '1-2 business days (+5% fee)'];

            final times = [
              PurchasingOfficerProcessingTimeEnum.standard,
              PurchasingOfficerProcessingTimeEnum.urgent,
            ];

            return Expanded(
              child:
                  BlocSelector<
                    PurchasingOfficerSelectProcessingTimeCubit,
                    PurchasingOfficerSelectProcessingTimeState,
                    bool
                  >(
                    selector: (state) =>
                        state.selectedProcessingTime == times[index],
                    builder: (context, state) {
                      return _buildProcessingTimeOption(
                        context: context,
                        label: labels[index],
                        desc: desc[index],
                        isSelected: state,
                        marginEnd: index == 0 ? 10.r : 0,
                        onTap: () {
                          context
                              .read<
                                PurchasingOfficerSelectProcessingTimeCubit
                              >()
                              .selectProcessingTime(times[index]);

                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'time_$addedItemMainId',
                                value: times[index].name,
                                isValid: true,
                              );
                        },
                      );
                    },
                  ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProcessingTimeOption({
    required BuildContext context,
    required String label,
    required String desc,
    required bool isSelected,
    required double marginEnd,
    required void Function() onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        height: 91.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.customColor.border,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        margin: EdgeInsetsDirectional.only(end: marginEnd),
        child: Column(
          children: [
            Text(
              label,
              style: AppStyles.s14W500.copyWith(
                color: isSelected
                    ? context.theme.primaryColor
                    : context.customColor.text1,
              ),
            ),
            4.verticalSpace,
            Text(
              desc,
              textAlign: TextAlign.center,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
