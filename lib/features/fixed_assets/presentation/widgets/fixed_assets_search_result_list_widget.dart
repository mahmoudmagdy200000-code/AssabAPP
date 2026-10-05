import 'package:assab/core/widgets/app_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/fixed_assets_search_response.dart';
import 'fixed_assets_search_result_item_widget.dart';

class FixedAssetsSearchResultListWidget extends StatelessWidget {
  final List<FixedAssetsSearchItem> items;

  const FixedAssetsSearchResultListWidget({super.key, required this.items});

  void _selectAndUnSelectAllItems(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final allItemsSelected = items.every(
      (item) => validationCubit.fieldIsValid('item_${item.id}'),
    );

    if (!allItemsSelected) {
      for (var item in items) {
        if (validationCubit.fieldIsValid('item_${item.id}')) {
          continue;
        }

        validationCubit.validateFieldAndStoreTypedValue<bool>(
          fieldName: 'item_${item.id}',
          value: !validationCubit.fieldIsValid('item_${item.id}'),
          isValid: !validationCubit.fieldIsValid('item_${item.id}'),
        );

        validationCubit.validateFieldAndStoreTypedValue<FixedAssetsSearchItem?>(
          fieldName: 'itemId_${item.id}',
          value: item,
          isValid: !validationCubit.fieldIsValid('item_${item.id}'),
        );
      }
    } else {
      for (var item in items) {
        validationCubit.validateFieldAndStoreTypedValue<bool>(
          fieldName: 'item_${item.id}',
          value: false,
          isValid: false,
        );

        validationCubit.validateFieldAndStoreTypedValue<FixedAssetsSearchItem?>(
          fieldName: 'itemId_${item.id}',
          value: null,
          isValid: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppSvg(
                  assetName: AppAssets.assetCoinSvg,
                  width: 16.r,
                  height: 16.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  '${context.tr.assets} (${items.length})',
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  context.tr.selectAll,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                SizedBox(width: 8.w),
                BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) {
                    if (items.isEmpty) {
                      return false;
                    }

                    return items.every(
                      (item) => state.fieldsValidity['item_${item.id}'] == true,
                    );
                  },
                  builder: (context, state) {
                    return AppCheckBox(
                      onChanged: (value) {
                        _selectAndUnSelectAllItems(context);
                      },
                      value: state,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: context.customColor.text2,
            border: Border.all(color: context.customColor.text2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              return BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) {
                  return state.fieldsValidity['item_${item.id}'] ?? false;
                },
                builder: (context, state) {
                  return FixedAssetsSearchResultItemWidget(
                    item: item,
                    isSelected: state,
                    onTapCheckBox: () {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreTypedValue<bool>(
                            fieldName: 'item_${item.id}',
                            value: !state,
                            isValid: !state,
                          );

                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreTypedValue<
                            FixedAssetsSearchItem?
                          >(
                            fieldName: 'itemId_${item.id}',
                            value: !state ? item : null,
                            isValid: !state,
                          );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
