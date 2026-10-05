import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_need_time_request.dart';
import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'supplier_partial_confirm_success_bottom_sheet_widget.dart';

class SupplierNeedTimeItemBottomSheetWidget extends StatelessWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierNeedTimeItemBottomSheetWidget({
    super.key,
    required this.item,
    required this.orderId,
  });

  void _chooseNewDate(BuildContext context) async {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(context, (context) {
      return Scaffold(
        body: AppPaddingWidget(
          child: CustomCalendar(
            onDateSelected: (selectedDate) {
              validationCubit.validateFieldAndStoreValue(
                fieldName: 'newDate',
                value: selectedDate.toIso8601String(),
                isValid: true,
              );

              NavigationService.I.pop();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          AppPaddingWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.lowStockNeedTime,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                3.verticalSpace,
                Text(
                  context.tr.editTheOrderDetailsFromRiyadhBranchMalqa,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 60.h,
                                color: context.theme.primaryColor,
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Text(
                                  context
                                      .tr
                                      .chooseHowSoonYouCanRestockAndDeliverTheFull,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          25.verticalSpace,
                          Text(
                            context.tr.modificationDetails,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    PurchaseItemImage(
                                      bgColor:
                                          context.customColor.reversedTextColor,
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
                                  context.tr.originalDeliveryDate,
                                  '',
                                ),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                          AppGestureDetectorButton(
                            onTap: () => _chooseNewDate(context),
                            child: ContainerCustomTextField(
                              label: context.tr.newDeliveryDate,
                              child: Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.calendar,
                                    width: 20.r,
                                  ),
                                  8.horizontalSpace,
                                  Expanded(
                                    child:
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String?
                                        >(
                                          selector: (state) =>
                                              state.fieldsValue['newDate'],
                                          builder: (context, state) {
                                            return Text(
                                              DateFormatter.formatDateMDY(
                                                    DateTime.tryParse(
                                                      state ?? '',
                                                    ),
                                                  ) ??
                                                  context.tr.choose,
                                              style: AppStyles.s14W400.copyWith(
                                                color: state != null
                                                    ? context.customColor.text1
                                                    : context.customColor.text3,
                                                fontWeight: state != null
                                                    ? FontWeight.w500
                                                    : FontWeight.w400,
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                  5.horizontalSpace,
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16.r,
                                    color: context.theme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            context.tr.modificationDetails,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                          8.verticalSpace,
                          ContainerCustomTextField(
                            child: CustomTextField(
                              hintText: context
                                  .tr
                                  .egSorryForBeefShortageDueToHighDemandThis,
                              maxLines: 5,
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'note',
                                      value: value,
                                      isValid: value.isNotEmpty,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<
                    SupplierConfirmOrRejectOrderOrItemCubit,
                    SupplierConfirmOrRejectOrderOrItemState
                  >(
                    listener: (context, state) {
                      if (state is SupplierConfirmOrRejectOrderOrItemFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      } else if (state
                          is SupplierConfirmOrRejectOrderOrItemSuccess) {
                        NavigationService.I.popToFirst();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) =>
                              const SupplierPartialConfirmSuccessBottomSheetWidget(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is SupplierConfirmOrRejectOrderOrItemLoading) {
                        return const AppLoadingWidget();
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: CustomTextButton(
                              text: context.tr.cancel,
                              onTap: () {
                                NavigationService.I.pop();
                              },
                              backgroundColor: Colors.transparent,
                              textColor: context.customColor.text1,
                              padding: EdgeInsets.symmetric(vertical: 14.r),
                              borderRadius: 15.r,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child:
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) => state.enableButton,
                                  builder: (context, state) {
                                    final validationCubit = context
                                        .read<ValidationCubit>();

                                    return AppButton(
                                      text: context.tr.sendModification,
                                      onClick: () {
                                        context
                                            .read<
                                              SupplierConfirmOrRejectOrderOrItemCubit
                                            >()
                                            .supplierNeedTimeItem(
                                              orderId: orderId,
                                              itemId: item.productId,
                                              body: SupplierNeedTimeRequest(
                                                newNeededByDate: validationCubit
                                                    .getFieldValue('newDate'),
                                                reason: validationCubit
                                                    .getFieldValue('note'),
                                              ),
                                            );
                                      },
                                      enabled: state,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                      borderRadius: BorderRadius.circular(15.r),
                                    );
                                  },
                                ),
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

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
    Widget? customValueWidget,
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
        customValueWidget ??
            Text(
              value,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
