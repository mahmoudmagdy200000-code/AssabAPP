import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_sup_category_entity.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/categories/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/switch_button/switch_button_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/entities/expenses_main_category_response_entity.dart';
import '../../domain/strategies/category_strategy.dart';
import 'select_item_expense_bottom_sheet_widget.dart';

class ItemViewPurchasesWidget extends StatefulWidget {
  final String id;
  final int index;
  final String fieldName;
  final String? listName;
  final bool? alwaysShowDelete;
  final Function(String qty, String unitPrice) onChangeData;
  final Function(ExpensesSupCategoryEntity expensesSupCategoryEntity)
  onChooseSubItem;

  const ItemViewPurchasesWidget({
    super.key,
    required this.id,
    required this.onChangeData,
    required this.onChooseSubItem,
    required this.fieldName,
    required this.index,
    this.listName,
    this.alwaysShowDelete,
  });

  @override
  State<ItemViewPurchasesWidget> createState() =>
      _ItemViewPurchasesWidgetState();
}

class _ItemViewPurchasesWidgetState extends State<ItemViewPurchasesWidget> {
  late final TextEditingController _qtyController;
  late final TextEditingController _unitPriceController;

  @override
  void initState() {
    final validationState = context.read<ValidationCubit>().state;

    _qtyController = TextEditingController(
      text: validationState.fieldsValue['purchaseQty_${widget.id}'] ?? '',
    );
    _unitPriceController = TextEditingController(
      text: validationState.fieldsValue['purchaseUnitPrice_${widget.id}'] ?? '',
    );

    _qtyController.addListener(_onDataChanged);
    _unitPriceController.addListener(_onDataChanged);
    super.initState();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    widget.onChangeData(_qtyController.text, _unitPriceController.text);
  }

  void _selectItemBottomSheet() {
    final validationCubit = context.read<ValidationCubit>();
    final categoriesCubit = context.read<CategoriesCubit>();

    AppBottomSheet.show(context, (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<SwitchButtonCubit>()),
          BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
          BlocProvider.value(value: validationCubit),
          BlocProvider.value(value: categoriesCubit),
          BlocProvider(
            create: (context) =>
                SearchCubit<ExpensesMainCategoryResponseEntity>(),
          ),
        ],
        child: SelectItemExpenseBottomSheetWidget(
          type: PurchaseCategoryStrategy(),
          onChooseSubItem: widget.onChooseSubItem,
        ),
      );
    });
  }

  void _removeValidationsFields() {
    context.read<ValidationCubit>().removeDynamicFields({
      'itemPurchasedId_${widget.id}',
      'itemPurchasedName_${widget.id}',
      'purchaseQty_${widget.id}',
      'purchaseUnitPrice_${widget.id}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.alwaysShowDelete == true ||
            (widget.alwaysShowDelete == null && widget.index != 0))
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: AppGestureDetectorButton(
              child: const AppSvg(assetName: AppAssets.trashSvg),
              onTap: () {
                _removeValidationsFields();
                context.read<AddItemCubit>().removeItem(
                  widget.listName ?? 'purchases',
                  widget.index,
                );
              },
            ),
          ),
        12.verticalSpace,
        AppGestureDetectorButton(
          onTap: _selectItemBottomSheet,
          child: ContainerCustomTextField(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue[widget.fieldName],
                  builder: (context, state) {
                    return Expanded(
                      child: Text(
                        state ?? context.tr.item,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    );
                  },
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
        8.verticalSpace,
        Row(
          children: [
            Expanded(
              child: ContainerCustomTextField(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _qtyController,
                        hintText: context.tr.qty,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '/${context.tr.unit}',
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.customColor.text1,
                          size: 15.r,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: ContainerCustomTextField(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _unitPriceController,
                        hintText: context.tr.unitPrice,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SaudiRiyalSvgWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
