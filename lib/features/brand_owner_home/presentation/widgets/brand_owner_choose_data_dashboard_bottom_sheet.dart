import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../cubit/brand_owner_home/brand_owner_home_cubit.dart';

class BrandOwnerChooseDataDashboardBottomSheet extends StatelessWidget {
  const BrandOwnerChooseDataDashboardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Summary',
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    'Sort your dashboard data by date range below, choose to view activity by month, week, or a custom day.',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const LabelTextField(text: 'Month'),
                            CustomDropdown<int>(
                              items: const [
                                1,
                                2,
                                3,
                                4,
                                5,
                                6,
                                7,
                                8,
                                9,
                                10,
                                11,
                                12,
                              ],
                              displayTextBuilder: (value) => value == null
                                  ? 'Select Month'
                                  : value.toString(),
                              backgroundColor: context.customColor.text2,
                              borderRadius: 18.r,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(8.r),
                                  child: Text(
                                    item.toString(),
                                    style: AppStyles.s14W500.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreTypedValue<int>(
                                      fieldName: 'month',
                                      value: value,
                                      isValid: true,
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          children: [
                            const LabelTextField(text: 'Year'),
                            CustomDropdown<int>(
                              items: List.generate(
                                10,
                                (index) => DateTime.now().year - index,
                              ),
                              displayTextBuilder: (value) => value == null
                                  ? 'Select Year'
                                  : value.toString(),
                              backgroundColor: context.customColor.text2,
                              borderRadius: 18.r,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(8.r),
                                  child: Text(
                                    item.toString(),
                                    style: AppStyles.s14W500.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreTypedValue<int>(
                                      fieldName: 'year',
                                      value: value,
                                      isValid: true,
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) =>
                  state.fieldsValidity['month'] == true &&
                  state.fieldsValidity['year'] == true,
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    NavigationService.I.pop();

                    context.read<BrandOwnerHomeCubit>().loadDashboard(
                      branchId: context.read<ValidationCubit>().getFieldValue(
                        'branchId',
                      ),
                      month: context.read<ValidationCubit>().getTypedValue<int>(
                        'month',
                      ),
                      year: context.read<ValidationCubit>().getTypedValue<int>(
                        'year',
                      ),
                    );
                  },
                  text: 'Sort Data',
                  enabled: state,
                  borderRadius: BorderRadius.circular(18.r),
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
