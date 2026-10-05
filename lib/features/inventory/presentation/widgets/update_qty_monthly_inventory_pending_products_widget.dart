import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/inventory_slider_model.dart';
import '../../data/models/monthly_inventory_pending_products_response.dart';
import '../../data/models/update_qty_monthly_inventory_request.dart';
import '../cubit/update_qty_monthly_inventory/update_qty_monthly_inventory_bloc.dart';
import '../cubit/update_qty_monthly_inventory/update_qty_monthly_inventory_event.dart';
import '../cubit/update_qty_monthly_inventory/update_qty_monthly_inventory_state.dart';

class UpdateQtyMonthlyInventoryPendingProductsWidget extends StatefulWidget {
  final MonthlyInventoryPendingProduct product;
  final String inventoryId;

  const UpdateQtyMonthlyInventoryPendingProductsWidget({
    super.key,
    required this.product,
    required this.inventoryId,
  });

  @override
  State<UpdateQtyMonthlyInventoryPendingProductsWidget> createState() =>
      _UpdateQtyMonthlyInventoryPendingProductsWidgetState();
}

class _UpdateQtyMonthlyInventoryPendingProductsWidgetState
    extends State<UpdateQtyMonthlyInventoryPendingProductsWidget> {
  late final TextEditingController _qtyController;
  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(
      text: widget.product.quantityInventory == 0
          ? null
          : widget.product.quantityInventory.toString(),
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
      margin: EdgeInsets.only(bottom: 4.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const PurchaseItemImage(),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        widget.product.itemName,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 10.horizontalSpace,
              // if (widget.product.unit is LiterUnitStrategy ||
              //     widget.product.unit is PgUnitStrategy ||
              //     widget.product.unit is BottleUnitStrategy)
              //   ButtonTextIcon(
              //     onTap: () async {
              //       final result = await NavigationService.I.pushNamed(
              //         AppRouteName.inventorySliderScreen,
              //       );

              //       if (result == null) {
              //         AppLogger.log('No result from slider screen');
              //         return;
              //       }

              //       final castedResult = result as InventorySliderModel;

              //       context
              //           .read<ValidationCubit>()
              //           .validateFieldAndStoreTypedValue<InventorySliderModel>(
              //             fieldName:
              //                 'inventorySliderModel_${widget.product.id}',
              //             value: castedResult,
              //             isValid: true,
              //           );
              //     },
              //     label: context.tr.slider,
              //     icon: AppSvg(
              //       assetName: AppAssets.sliderSvg,
              //       width: 14.r,
              //       colorFilter: ColorFilter.mode(
              //         context.customColor.reversedTextColor,
              //         BlendMode.srcIn,
              //       ),
              //     ),
              //     padding: EdgeInsets.symmetric(
              //       vertical: 10.r,
              //       horizontal: 12.r,
              //     ),
              //     backgroundColor: context.theme.primaryColor,
              //     borderRadius: BorderRadius.circular(1000.r),
              //     borderColor: Colors.transparent,
              //     textColor: context.customColor.reversedTextColor,
              //     spaceBetweenTextAndIcon: 7.w,
              //   ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  context.tr.quantity,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              12.horizontalSpace,
              Flexible(
                flex: 3,
                child: BlocSelector<ValidationCubit, ValidationState, InventorySliderModel?>(
                  selector: (state) =>
                      state.getTypedValue<InventorySliderModel>(
                        'inventorySliderModel_${widget.product.id}',
                      ),
                  builder: (context, validationState) {
                    final total = validationState?.total ?? 0;

                    final percentage = validationState?.percentage ?? 0;

                    String result;

                    if (percentage == 100) {
                      result = '$total ${context.tr.full}';
                    } else if (percentage == 0) {
                      result = '${total - 1} ${context.tr.full}';
                    } else {
                      result =
                          '${total - 1} ${context.tr.full} + ${context.tr.one} $percentage% ${context.tr.full}';
                    }

                    return Row(
                      spacing: 10.w,
                      children: [
                        if (validationState != null)
                          AppSvgButton(
                            assetName: AppAssets.refresh,
                            onTap: () {
                              context
                                  .read<ValidationCubit>()
                                  .validateFieldAndStoreTypedValue<
                                    InventorySliderModel?
                                  >(
                                    fieldName:
                                        'inventorySliderModel_${widget.product.id}',
                                    value: null,
                                    isValid: true,
                                  );
                            },
                            iconSize: 12.r,
                            padding: EdgeInsets.all(5.r),
                          ),
                        Flexible(
                          child: ContainerCustomTextField(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.r,
                              horizontal: 8.r,
                            ),
                            borderColor: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: validationState != null
                                      ? Text(
                                          result,
                                          style: AppStyles.s12W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        )
                                      : BlocListener<
                                          UpdateQtyMonthlyInventoryBloc,
                                          UpdateQtyMonthlyInventoryState
                                        >(
                                          listener: (context, state) {
                                            if (state
                                                is UpdateQtyMonthlyInventoryFailure) {
                                              _qtyController.clear();

                                              AppDialog.showErrorDialog(
                                                context: context,
                                                failure: state.failure,
                                              );
                                            }
                                          },
                                          child: CustomTextField(
                                            controller: _qtyController,
                                            hintText: '0',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              context
                                                  .read<
                                                    UpdateQtyMonthlyInventoryBloc
                                                  >()
                                                  .add(
                                                    UpdateQtyMonthlyInventoryRequested(
                                                      inventoryId:
                                                          widget.inventoryId,
                                                      productId:
                                                          widget.product.id,
                                                      request:
                                                          UpdateQtyMonthlyInventoryRequest(
                                                            quantity:
                                                                int.tryParse(
                                                                  value,
                                                                ) ??
                                                                0,
                                                          ),
                                                    ),
                                                  );
                                            },
                                          ),
                                        ),
                                ),
                                5.horizontalSpace,
                                Text(
                                  '/${widget.product.unit}',
                                  style: AppStyles.s10W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                3.horizontalSpace,
                                AppSvg(
                                  assetName: AppAssets.edit,
                                  width: 10.w,
                                  height: 10.w,
                                  colorFilter: ColorFilter.mode(
                                    context.customColor.text3,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
