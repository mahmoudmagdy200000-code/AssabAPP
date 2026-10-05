import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/purchase/presentation/cubit/purchasing_officer_select_quality/purchasing_officer_select_quality_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/purchasing_officer_select_quality/purchasing_officer_select_quality_cubit.dart';

class PurchasingOfficerQualitySection extends StatelessWidget {
  final String addedItemMainId;

  const PurchasingOfficerQualitySection({
    super.key,
    required this.addedItemMainId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.tr.quality,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.horizontalSpace,
            Text(
              '(${context.tr.grade})',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.horizontalSpace,
            Text(
              '*',
              style: AppStyles.s16W600.copyWith(
                color: context.customColor.error,
              ),
            ),
          ],
        ),
        5.verticalSpace,
        Row(
          children: List.generate(3, (index) {
            final texts = [
              context.tr.economy,
              context.tr.standard,
              context.tr.premium,
            ];

            final qualities = [
              PurchasingOfficerQualityEnum.economy,
              PurchasingOfficerQualityEnum.standard,
              PurchasingOfficerQualityEnum.premium,
            ];

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<
                          PurchasingOfficerSelectQualityCubit,
                          PurchasingOfficerSelectQualityState,
                          bool
                        >(
                          selector: (state) =>
                              state.selectedQuality == qualities[index],
                          builder: (context, state) {
                            return CustomTextButton(
                              text: texts[index],
                              textColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.text3,
                              borderColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.border,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.r,
                                vertical: 12.r,
                              ),
                              onTap: () {
                                context
                                    .read<PurchasingOfficerSelectQualityCubit>()
                                    .selectQuality(qualities[index]);

                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'quality_$addedItemMainId',
                                      value: qualities[index].name,
                                      isValid: true,
                                    );
                              },
                            );
                          },
                        ),
                  ),
                  if (index != 2) 10.horizontalSpace,
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
