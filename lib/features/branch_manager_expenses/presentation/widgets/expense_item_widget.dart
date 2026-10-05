import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/quick_cash_expenses_title_field.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/quick_cash_expenses_total_amount_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class ExpensesItem extends StatefulWidget {
  final int? index;
  final String labelTitle;
  final String labelAmount;
  final String? title;
  final String? amount;
  final String totalAmountFieldValidationKey;
  final bool isSingle;
  final void Function()? validateItemsAmount;
  final Function(String title, String amount)? onDataChanged;

  const ExpensesItem({
    super.key,
    this.index,
    this.onDataChanged,
    required this.labelTitle,
    required this.labelAmount,
    this.isSingle = false,
    required this.totalAmountFieldValidationKey,
    this.validateItemsAmount,
    this.title,
    this.amount,
  });

  @override
  State<ExpensesItem> createState() => _ExpensesItemState();
}

class _ExpensesItemState extends State<ExpensesItem> {
  late final TextEditingController _titleController;

  late final TextEditingController _amountController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    _amountController = TextEditingController(text: widget.amount);

    _titleController.addListener(_onDataChanged);
    _amountController.addListener(_onDataChanged);
    super.initState();
  }

  void _onDataChanged() {
    if (widget.onDataChanged != null) {
      widget.onDataChanged!(_titleController.text, _amountController.text);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.validateItemsAmount?.call();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onDeletePressed() {
    final addItemCubit = context.read<AddItemCubit>();
    final validationCubit = context.read<ValidationCubit>();

    addItemCubit.removeItem('quick_cash_expense_items', widget.index ?? 0);

    widget.validateItemsAmount?.call();

    if (addItemCubit.state.lists['quick_cash_expense_items']?.isEmpty ?? true) {
      validationCubit.toggleFieldRequirement('itemsAmount', isRequired: false);
      validationCubit.validateField('itemsAmount', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      margin: EdgeInsets.only(bottom: 12.r),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          if (!widget.isSingle)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: AppGestureDetectorButton(
                onTap: () => _onDeletePressed(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(6.r),
                  child: const AppSvg(assetName: AppAssets.trashSvg),
                ),
              ),
            ),
          QuickCashExpensesTitleField(
            controller: _titleController,
            label: widget.labelTitle,
          ),
          12.verticalSpace,
          if (widget.totalAmountFieldValidationKey == 'totalAmount')
            BlocSelector<ValidationCubit, ValidationState, bool?>(
              selector: (state) =>
                  state.fieldsValidity[widget.totalAmountFieldValidationKey],
              builder: (context, state) {
                final isValid = state;

                return Column(
                  children: [
                    QuickCashExpensesTotalAmountField(
                      controller: _amountController,
                      label: widget.labelAmount,
                      borderColor: isValid == null || isValid
                          ? null
                          : context.customColor.error,
                    ),
                    isValid == null || isValid
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              10.verticalSpace,
                              Text(
                                context.tr.amount500Desc,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.error,
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              },
            )
          else
            BlocSelector<ValidationCubit, ValidationState, bool?>(
              selector: (state) => state.fieldsValidity['itemsAmount'],
              builder: (context, isValid) {
                return Column(
                  children: [
                    QuickCashExpensesTotalAmountField(
                      controller: _amountController,
                      label: widget.labelAmount,
                      borderColor: isValid == null || isValid
                          ? null
                          : context.customColor.error,
                    ),
                    isValid == null || isValid
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              10.verticalSpace,
                              Text(
                                context.tr.itemsAmountMustBeEqualToTotalAmount,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.error,
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
