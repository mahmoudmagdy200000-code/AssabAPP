import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import 'supplier_order_approved_bottom_sheet.dart';

class SupplierApproveAllBottomSheetWidget extends StatelessWidget {
  final List<SupplierOrderItem> items;
  final String orderId;

  const SupplierApproveAllBottomSheetWidget({
    super.key,
    required this.items,
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
                    context.tr.approveAllItems(3),
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr.approveAllItemsDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SupplierItemPreviewWidget(
                              itemName: items[index].productName,
                              // itemImageUrl: items[index].,
                            ),
                            if (index != items.length - 1) 12.verticalSpace,
                          ],
                        );
                      },
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
                  text: context.tr.approveAll,
                  onTap: () {
                    context
                        .read<SupplierConfirmOrRejectOrderOrItemCubit>()
                        .supplierConfirmOrder(orderId: orderId);
                  },
                  backgroundColor: context.theme.primaryColor,
                  textColor: context.customColor.reversedTextColor,
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                  borderRadius: 15.r,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
