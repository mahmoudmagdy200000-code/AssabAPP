import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/inventory/data/models/inventory_employee_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/wasted_damage_items_response.dart';

class WastedDamageDetailsResponsibleEmployeesWidget extends StatelessWidget {
  final String? itemId;
  final WastedDamageItemData? item;

  const WastedDamageDetailsResponsibleEmployeesWidget({
    super.key,
    this.itemId,
    this.item,
  });

  String _key(String base) => itemId != null ? '${base}_$itemId' : base;

  void _handleRemoveEmployee(BuildContext context, int index) {
    final validationCubit = context.read<ValidationCubit>();
    final selectedEmployees =
        validationCubit.state.getTypedValue<List<InventoryEmployee>>(
          _key('selectedEmployees'),
        ) ??
        [];
    final quantities =
        validationCubit.state.getTypedValue<List<String>>(
          _key('employeeQuantities'),
        ) ??
        [];

    final newEmployees = List<InventoryEmployee>.from(selectedEmployees)
      ..removeAt(index);
    final newQuantities = List<String>.from(quantities)..removeAt(index);

    validationCubit.validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
      fieldName: _key('selectedEmployees'),
      value: newEmployees,
    );
    validationCubit.validateFieldAndStoreTypedValue<List<String>>(
      fieldName: _key('employeeQuantities'),
      value: newQuantities,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (context, validationState) {
        final selectedEmployees =
            validationState.getTypedValue<List<InventoryEmployee>>(
              _key('selectedEmployees'),
            ) ??
            [];
        final quantities =
            validationState.getTypedValue<List<String>>(
              _key('employeeQuantities'),
            ) ??
            [];

        if (selectedEmployees.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
          margin: EdgeInsets.only(top: 12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: List.generate(selectedEmployees.length, (i) {
              final total = selectedEmployees.length;

              final canRemove = i != 0 && !(i == 1 && total <= 2);

              return _buildEmployeeItem(
                context,
                selectedEmployees[i],
                quantities[i],
                i,
                canRemove,
                item,
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeItem(
    BuildContext context,
    InventoryEmployee employee,
    String quantity,
    int index,
    bool canRemove,
    WastedDamageItemData? item,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileImageWidget(image: employee.image),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              // 5.verticalSpace,
              // Text(
              //   'Store Branch Name',
              //   style: AppStyles.s12W500.copyWith(
              //     color: context.customColor.text3,
              //   ),
              // ),
              5.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(horizontal: 17.r, vertical: 10.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        quantity,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      '/${item?.itemUnit}',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        14.horizontalSpace,
        if (canRemove)
          AppSvgButton(
            assetName: AppAssets.trashSvg,
            onTap: () => _handleRemoveEmployee(context, index),
            iconSize: 12.r,
            iconColor: context.customColor.error,
          ),
      ],
    );
  }
}
