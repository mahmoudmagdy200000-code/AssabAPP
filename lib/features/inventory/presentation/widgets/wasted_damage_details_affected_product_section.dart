import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/wasted_for_reason_enum.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../domain/strategies/wasted_problem_type_strategy.dart';

class WastedDamageDetailsAffectedProductSection extends StatelessWidget {
  final WastedDamageItemData? item;
  final String? itemId;

  const WastedDamageDetailsAffectedProductSection({
    super.key,
    this.item,
    this.itemId,
  });

  String _key(String base) => itemId != null ? '${base}_$itemId' : base;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          LabelTextField(text: context.tr.affectedProduct),
          _buildRowItem(
            context: context,
            title: '${context.tr.quantity}:',
            customWValue: Expanded(
              child: ContainerCustomTextField(
                padding: EdgeInsets.symmetric(horizontal: 9.r, vertical: 7.r),
                borderRadius: BorderRadius.circular(10.r),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: '0',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: _key('quantity'),
                                value: value,
                                isValid:
                                    value.isNotEmpty &&
                                    double.tryParse(value) != null &&
                                    double.parse(value) > 0,
                              );
                        },
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      '/kg',
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    3.horizontalSpace,
                    AppSvg(
                      assetName: AppAssets.edit,
                      width: 12.r,
                      colorFilter: ColorFilter.mode(
                        context.theme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: '${context.tr.value}:',
            value:
                ((item?.pricePerUnit ?? 0) *
                        (double.tryParse(
                              context
                                      .watch<ValidationCubit>()
                                      .state
                                      .fieldsValue[_key('quantity')] ??
                                  '0',
                            ) ??
                            0))
                    .toStringAsFixed(2),
            isCurrency: true,
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: context.tr.reasonForWasteDamage,
            customWValue: Expanded(
              child:
                  BlocSelector<
                    ValidationCubit,
                    ValidationState,
                    WastedProblemTypeStrategy?
                  >(
                    selector: (state) =>
                        state.getTypedValue<WastedProblemTypeStrategy>(
                          _key('problemType'),
                        ),
                    builder: (context, state) {
                      return CustomDropdown<WastedForReasonEnum>(
                        items: state?.reasons ?? [],
                        displayTextBuilder: (value) =>
                            value?.label(context) ?? '',
                        initialValue: state?.reasons.first,
                        autoSelectIfInvalid: true,
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.all(16.r),
                            child: Text(
                              item.label(context),
                              style: AppStyles.s12W500.copyWith(
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
                              .validateFieldAndStoreTypedValue<
                                WastedForReasonEnum
                              >(
                                fieldName: _key('reasonForWaste'),
                                value: value,
                                isValid: true,
                              );
                        },
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.r,
                          vertical: 7.r,
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customWValue,
    bool isCurrency = false,
  }) {
    return Row(
      spacing: 5.w,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        if (isCurrency) const SaudiRiyalSvgWidget(),
        customWValue ??
            Text(
              value ?? '',
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }
}
