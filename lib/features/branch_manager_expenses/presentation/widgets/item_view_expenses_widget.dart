import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_main_category_response_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/entities/expenses_sup_category_entity.dart';
import '../../domain/strategies/category_strategy.dart';
import '../cubit/categories/categories_cubit.dart';
import 'select_item_expense_bottom_sheet_widget.dart';

class ItemViewExpensesWidget extends StatefulWidget {
  final int index;
  final String id;
  final String fieldName;
  final Function(String unitPrice) onChangeData;
  final Function(ExpensesSupCategoryEntity expensesSupCategoryEntity)
  onChooseSubExpense;

  const ItemViewExpensesWidget({
    super.key,
    required this.id,
    required this.onChangeData,
    required this.onChooseSubExpense,
    required this.fieldName,
    required this.index,
  });

  @override
  State<ItemViewExpensesWidget> createState() => _ItemViewExpensesWidgetState();
}

class _ItemViewExpensesWidgetState extends State<ItemViewExpensesWidget> {
  late final TextEditingController _unitPriceController;

  @override
  void initState() {
    _unitPriceController = TextEditingController(
      text:
          context
              .read<ValidationCubit>()
              .state
              .fieldsValue['expenseUnitPrice_${widget.id}'] ??
          '',
    );

    _unitPriceController.addListener(_onDataChanged);
    super.initState();
  }

  @override
  void dispose() {
    _unitPriceController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    widget.onChangeData(_unitPriceController.text);
  }

  void _selectCategory() {
    final categoriesCubit = context.read<CategoriesCubit>();

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<SwitchButtonCubit>()),
          BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
          BlocProvider(
            create: (context) =>
                SearchCubit<ExpensesMainCategoryResponseEntity>(),
          ),
          BlocProvider.value(value: categoriesCubit),
        ],
        child: SelectItemExpenseBottomSheetWidget(
          type: ExpenseCategoryStrategy(),
          onChooseSubItem: widget.onChooseSubExpense,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.index != 0)
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: AppGestureDetectorButton(
              child: const AppSvg(assetName: AppAssets.trashSvg),
              onTap: () {
                context.read<AddItemCubit>().removeItem(
                  'expenses',
                  widget.index,
                );
              },
            ),
          ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: AppGestureDetectorButton(
                onTap: _selectCategory,
                child: ContainerCustomTextField(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) =>
                            state.fieldsValue[widget.fieldName],
                        builder: (context, state) {
                          return Expanded(
                            child: Text(
                              state ?? context.tr.category,
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
                        size: 15.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            16.horizontalSpace,
            Flexible(
              fit: FlexFit.loose,
              child: ContainerCustomTextField(
                child: Row(
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
