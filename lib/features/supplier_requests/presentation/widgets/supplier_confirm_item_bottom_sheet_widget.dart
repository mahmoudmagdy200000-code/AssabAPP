import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_order_approved_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';

class SupplierConfirmItemBottomSheetWidget extends StatelessWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierConfirmItemBottomSheetWidget({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.confirmApproval,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    context
                        .tr
                        .youreApprovingTheRequestedQuantityForThisItemWithNo,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  30.verticalSpace,
                  Text(
                    context
                        .tr
                        .onceConfirmedTheSupplierWillBeNotifiedAndCanBegin,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    context.tr.areYouSureYouWantToProceed,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            PurchaseItemImage(
                              bgColor: context.customColor.reversedTextColor,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                item.productName,
                                style: AppStyles.s14W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.requestedQty,
                          item.orderedQuantity.toString(),
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.quality,
                          item.qualityLevel.getString(context),
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.price,
                          item.unitPrice.toString(),
                          showCurrencySymbol: true,
                        ),
                        8.verticalSpace,
                        _buildDiv(context),
                        8.verticalSpace,
                        _buildDetailRow(
                          context,
                          context.tr.totalAmount,
                          item.totalPrice.toString(),
                          showCurrencySymbol: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              SupplierConfirmOrRejectOrderOrItemCubit,
              SupplierConfirmOrRejectOrderOrItemState
            >(
              listener: (context, state) {
                if (state is SupplierConfirmOrRejectOrderOrItemSuccess) {
                  NavigationService.I.popToFirst();

                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => const SupplierOrderApprovedBottomSheet(),
                  );
                } else if (state is SupplierConfirmOrRejectOrderOrItemFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is SupplierConfirmOrRejectOrderOrItemLoading) {
                  return const AppButtonLoading();
                }

                return CustomTextButton(
                  text: context.tr.confirmApproveItem,
                  onTap: () {
                    context
                        .read<SupplierConfirmOrRejectOrderOrItemCubit>()
                        .supplierFullConfirmItem(
                          orderId: orderId,
                          itemId: item.productId,
                        );
                  },
                  backgroundColor: context.theme.primaryColor,
                  textColor: context.customColor.reversedTextColor,
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showCurrencySymbol) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
