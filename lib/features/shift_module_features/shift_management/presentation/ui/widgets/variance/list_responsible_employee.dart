import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/select_responsible_employee_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/button_text_icon.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../core/widgets/label_text_field.dart';
import '../../../../domain/entity/cashier_entity.dart';
import '../../../logic/choose_employee/choose_employee_cubit.dart';
import '../../../logic/choose_employee/choose_employee_state.dart';

import 'selected_responsible_employee_widget.dart';

class ListResponsibleEmployee extends StatefulWidget {
  const ListResponsibleEmployee({super.key});

  @override
  State<ListResponsibleEmployee> createState() =>
      _ListResponsibleEmployeeState();
}

class _ListResponsibleEmployeeState extends State<ListResponsibleEmployee> {
  @override
  void initState() {
    context.read<GetCashierCubit>().getCashiers();
    super.initState();
  }

  void _showSelectResponsibleEmployeeBottomSheet(BuildContext context) {
    final chooseEmployeeCubit = context.read<ChooseEmployeeCubit>();
    final getCashierCubit = context.read<GetCashierCubit>();
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: chooseEmployeeCubit),
          BlocProvider.value(value: getCashierCubit),
          BlocProvider.value(value: validationCubit),
        ],
        child: const SelectResponsibleEmployeeBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ChooseEmployeeCubit,
      ChooseEmployeeState,
      Map<CashierEntity, bool>
    >(
      selector: (state) => state.selectedEmployees,
      builder: (context, state) {
        if (state.isEmpty ||
            state.values.where((element) => element).length < 2) {
          return AppGestureDetectorButton(
            onTap: () => _showSelectResponsibleEmployeeBottomSheet(context),
            child: ContainerCustomTextField(
              label: context.tr.selectResponsibleEmployee,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr.choose,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 16.r,
                    color: context.customColor.text1,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LabelTextField(
                    text: context.tr.selectResponsibleEmployee,
                  ),
                ),

                ButtonTextIcon(
                  onTap: () =>
                      _showSelectResponsibleEmployeeBottomSheet(context),
                  label: context.tr.add,
                  icon: Icon(
                    Icons.add,
                    color: context.theme.primaryColor,
                    size: 14.r,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.r,
                    vertical: 6.r,
                  ),
                  textColor: context.theme.primaryColor,
                  borderColor: context.theme.primaryColor,
                ),
              ],
            ),
            15.verticalSpace,

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.length,
              itemBuilder: (context, index) {
                context.read<ValidationCubit>().validateField(
                  'responsibleEmployees',
                  state.length >= 2,
                );

                final cashier = state.keys.elementAt(index);

                return SelectedResponsibleEmployeeWidget(
                  index: index,
                  cashier: cashier,
                  length: state.length,
                );
              },
            ),
            // 15.verticalSpace,
            // Column(
            //   children: List.generate(state.length, (index) {
            //     context.read<ValidationCubit>().validateField(
            //       'responsibleEmployees',
            //       state.length >= 2,
            //     );
            //
            //     final cashier = state.keys.elementAt(index);
            //
            //     return SelectedResponsibleEmployeeWidget(
            //       index: index,
            //       cashier: cashier,
            //       length: state.length,
            //     );
            //   }),
            // ),
          ],
        );
      },
    );
  }
}
