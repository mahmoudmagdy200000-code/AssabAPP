import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../cubit/add_item_purchase/add_item_purchase_state.dart';
import 'custom_svg_button.dart';
import 'purchase_item_image.dart';

class ItemListViewWidget extends StatefulWidget {
  final PurchaseBranchItemData item;

  const ItemListViewWidget({super.key, required this.item});

  @override
  State<ItemListViewWidget> createState() => _ItemListViewWidgetState();
}

class _ItemListViewWidgetState extends State<ItemListViewWidget> {
  late final TextEditingController _quantityController;
  late final FocusNode _quantityFocusNode;
  bool _isUpdatingFromCubit = false;

  @override
  void initState() {
    super.initState();
    final currentQty = context
        .read<AddItemPurchaseCubit>()
        .state
        .items[widget.item];
    _quantityController = TextEditingController(
      text: (currentQty != null && currentQty > 0) ? currentQty.toString() : '',
    );
    _quantityFocusNode = FocusNode();
    _quantityFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _quantityFocusNode.removeListener(_onFocusChange);
    _quantityFocusNode.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_quantityFocusNode.hasFocus && _quantityController.text.isEmpty) {
      if (!mounted) return;
      context.read<AddItemPurchaseCubit>().setItemQuantity(widget.item, 0);
      _validateItems(context);
    }
  }

  void _incrementItem(BuildContext context) {
    context.read<AddItemPurchaseCubit>().addItem(widget.item);
    _validateItems(context);
  }

  void _decrementItem(BuildContext context) {
    context.read<AddItemPurchaseCubit>().removeItem(widget.item);
    _validateItems(context);
  }

  void _onQuantityChanged(BuildContext context, String value) {
    if (_isUpdatingFromCubit) return;
    if (value.isEmpty) return;
    final qty = int.tryParse(value) ?? 0;
    context.read<AddItemPurchaseCubit>().setItemQuantity(widget.item, qty);
    _validateItems(context);
  }

  void _syncController(int? state) {
    final newText = (state != null && state > 0) ? state.toString() : '';
    if (_quantityController.text != newText) {
      _isUpdatingFromCubit = true;
      _quantityController.text = newText;
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      _isUpdatingFromCubit = false;
    }
  }

  void _validateItems(BuildContext context) {
    context.read<ValidationCubit>().validateField(
      'items',
      context.read<AddItemPurchaseCubit>().anyItemsSelected(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PurchaseItemImage(image: widget.item.itemLogo),
          10.horizontalSpace,
          Expanded(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.item.itemName} (${widget.item.itemUnit})',
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              widget.item.itemCode,
                              style: AppStyles.s10W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.horizontalSpace,
                      BlocSelector<
                        AddItemPurchaseCubit,
                        AddItemPurchaseState,
                        int?
                      >(
                        selector: (state) => state.items[widget.item],
                        builder: (context, state) {
                          _syncController(state);

                          return AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (state != null && state != 0) ...[
                                  CustomSvgButton(
                                    assetName: AppAssets.minus,
                                    onTap: () => _decrementItem(context),
                                  ),
                                  8.horizontalSpace,
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      controller: _quantityController,
                                      focusNode: _quantityFocusNode,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(),
                                        counterText: '',
                                      ),
                                      onTapOutside: (event) => FocusManager
                                          .instance
                                          .primaryFocus
                                          ?.unfocus(),
                                      onChanged: (value) =>
                                          _onQuantityChanged(context, value),
                                    ),
                                  ),
                                ],
                                8.horizontalSpace,
                                CustomSvgButton(
                                  assetName: AppAssets.add,
                                  onTap: () => _incrementItem(context),
                                  backgroundColor: context.theme.primaryColor,
                                  iconColor:
                                      context.customColor.reversedTextColor,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  BlocSelector<
                    AddItemPurchaseCubit,
                    AddItemPurchaseState,
                    int?
                  >(
                    selector: (state) => state.items[widget.item],
                    builder: (context, state) {
                      if (state == null || state == 0) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${context.tr.rate} = ${widget.item.rate} /kg',
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Text(
                                '=',
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              5.horizontalSpace,
                              SaudiRiyalSvgWidget(
                                size: 15.r,
                                color: context.customColor.text3,
                              ),
                              5.horizontalSpace,
                              Text(
                                widget.item.itemPrice.toString(),
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
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
            ),
          ),
        ],
      ),
    );
  }
}
