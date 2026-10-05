import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_button.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';

class InventoryConfirmStaffTaskBottomSheetArguments {
  final String itemId;
  final String image;
  final String itemName;
  final int itemQuantity;

  InventoryConfirmStaffTaskBottomSheetArguments({
    required this.itemId,
    required this.image,
    required this.itemName,
    required this.itemQuantity,
  });

  InventoryConfirmStaffTaskBottomSheetArguments copyWith({
    String? itemId,
    String? image,
    String? itemName,
    int? itemQuantity,
  }) {
    return InventoryConfirmStaffTaskBottomSheetArguments(
      itemId: itemId ?? this.itemId,
      image: image ?? this.image,
      itemName: itemName ?? this.itemName,
      itemQuantity: itemQuantity ?? this.itemQuantity,
    );
  }
}

class InventoryConfirmStaffTaskBottomSheet extends StatefulWidget {
  final String title;
  final String description;
  final List<InventoryConfirmStaffTaskBottomSheetArguments> items;
  final void Function(
    List<InventoryConfirmStaffTaskBottomSheetArguments> updatedItems,
  )
  onConfirm;

  const InventoryConfirmStaffTaskBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.items,
    required this.onConfirm,
  });

  @override
  State<InventoryConfirmStaffTaskBottomSheet> createState() =>
      _InventoryConfirmStaffTaskBottomSheetState();
}

class _InventoryConfirmStaffTaskBottomSheetState
    extends State<InventoryConfirmStaffTaskBottomSheet> {
  late final List<TextEditingController> _quantityControllers;

  @override
  void initState() {
    super.initState();

    _quantityControllers = widget.items
        .map(
          (item) => TextEditingController(text: item.itemQuantity.toString()),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _quantityControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Text(
                    widget.title,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ).sliverBoxAdapter,
                  5.verticalSpace.sliverBoxAdapter,
                  Text(
                    widget.description,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ).sliverBoxAdapter,
                  20.verticalSpace.sliverBoxAdapter,
                  SliverList.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];

                      return Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.reversedTextColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                PurchaseItemImage(image: item.image),
                                12.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    item.itemName,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            5.verticalSpace,
                            AppTextFormField(
                              controller: _quantityControllers[index],
                              hint: context.tr.quantity,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.confirm,
              onTap: () {
                final updatedItems = List.generate(
                  widget.items.length,
                  (index) => widget.items[index].copyWith(
                    itemQuantity:
                        int.tryParse(_quantityControllers[index].text) ?? 0,
                  ),
                );

                widget.onConfirm(updatedItems);

                NavigationService.I.pop();
              },
              backgroundColor: context.theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14.r),
              borderColor: Colors.transparent,
              borderRadius: 12.r,
              textColor: context.customColor.reversedTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
