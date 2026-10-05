import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/branch_manager_requests/domain/strategies/approve_or_reject_order_strategy.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/orders_response.dart';
import '../../data/models/partial_approve_order_request.dart';
import '../cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';
import '../cubit/select_branch_manager_delivery_time/select_branch_manager_delivery_time_cubit.dart';
import 'branch_manager_requests_delivery_time_bottom_sheet_widget.dart';

class PartialApprovalBottomSheetWidget extends StatefulWidget {
  final OrderData request;

  const PartialApprovalBottomSheetWidget({super.key, required this.request});

  @override
  State<PartialApprovalBottomSheetWidget> createState() =>
      _PartialApprovalBottomSheetWidgetState();
}

class _PartialApprovalBottomSheetWidgetState
    extends State<PartialApprovalBottomSheetWidget> {
  final PartialApproveOrderRequest _body = PartialApproveOrderRequest();

  @override
  void initState() {
    super.initState();

    for (var item in widget.request.items) {
      context.read<ValidationCubit>().addDynamicFields({'new_qty_${item.id}'});
    }
  }

  void _onConfirmButtonPressed() {
    final validationState = context.read<ValidationCubit>().state;

    _body.updateItemsFromValidation(
      fieldsValue: validationState.fieldsValue,
      orderItems: widget.request.items,
    );

    final approveOrRejectOrderCubit = context.read<ApproveOrRejectOrderCubit>();

    AppBottomSheet.show(
      context,
      (context) => _branchManagerRequestsDeliveryTimeBottomSheetWidget(
        context,
        approveOrRejectOrderCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.request.items.length,
              itemBuilder: (context, index) {
                final item = widget.request.items[index];
                final itemUnit = item.unitOfMeasurement ?? '';

                return Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.only(bottom: 12.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          PurchaseItemImage(
                            bgColor: context.customColor.reversedTextColor,
                          ),
                          10.horizontalSpace,
                          Text(
                            '${item.itemName} ($itemUnit)',
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.originalRequestedQty,
                        value: '${item.quantityOrdered} $itemUnit',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.newQty,
                        customValue: Expanded(
                          child: ContainerCustomTextField(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.r,
                              vertical: 6.r,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: context.tr.newQty,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      context
                                          .read<ValidationCubit>()
                                          .validateFieldAndStoreValue(
                                            fieldName: 'new_qty_${item.id}',
                                            value: value,
                                            isValid:
                                                value.isNotEmpty &&
                                                int.tryParse(value) != null &&
                                                int.parse(value) > 0,
                                          );
                                    },
                                  ),
                                ),
                                2.horizontalSpace,
                                Text(
                                  '/$itemUnit',
                                  style: AppStyles.s10W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.ourCurrentStock,
                        value: '${item.availableInSource} $itemUnit',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      BlocSelector<ValidationCubit, ValidationState, int>(
                        selector: (state) =>
                            int.tryParse(
                              state.fieldsValue['new_qty_${item.id}'] ?? '0',
                            ) ??
                            0,
                        builder: (context, state) {
                          return _buildItemRow(
                            context: context,
                            title: context.tr.afterTransfer,
                            value:
                                '${(item.availableInSource ?? 0) - state} $itemUnit',
                          );
                        },
                      ),
                      16.verticalSpace,
                      BlocSelector<ValidationCubit, ValidationState, int>(
                        selector: (state) =>
                            int.tryParse(
                              state.fieldsValue['new_qty_${item.id}'] ?? '0',
                            ) ??
                            0,
                        builder: (context, state) {
                          final availableStockAfterTransfer =
                              (item.availableInSource ?? 0) - state > 75;

                          return _buildStateBox(
                            context: context,
                            title: context.tr.warning,
                            desc: availableStockAfterTransfer
                                ? context.tr.safeStockLevelMaintained
                                : context
                                      .tr
                                      .fulfillingThisRequestWillDropAvailableStockBelowTheMinimum,
                            assetName: availableStockAfterTransfer
                                ? AppAssets.check
                                : AppAssets.warning,
                            customTitle: availableStockAfterTransfer
                                ? Row(
                                    children: [
                                      Text(
                                        '${context.tr.stockLevel}:',
                                        style: AppStyles.s14W600.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                      4.horizontalSpace,
                                      Text(
                                        context.tr.helthy,
                                        style: AppStyles.s14W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          );
                        },
                      ),
                      16.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.ourDailyConsumption,
                        value: '${item.dailyConsumptionQuantity} $itemUnit',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.weekendForecast,
                        value: '${item.weekendForecastQuantity} $itemUnit',
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildItemRow(
                        context: context,
                        title: context.tr.nextSupply,
                        value: '${item.nextSupply} $itemUnit',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          20.verticalSpace,
          Row(
            children: [
              CustomTextButton(
                text: context.tr.cancel,
                padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 37.r),
                textColor: context.customColor.text4,
                onTap: () => NavigationService.I.pop(),
              ),
              12.horizontalSpace,
              Expanded(
                child: BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) => state.enableButton,
                  builder: (context, state) {
                    return AppButton(
                      onClick: _onConfirmButtonPressed,
                      enabled: state,
                      borderRadius: BorderRadius.circular(12.r),
                      text: context.tr.chooseDeliveryTime,
                    );
                  },
                ),
              ),
            ],
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        customValue ??
            Text(
              value ?? '',
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }

  Widget _buildStateBox({
    required BuildContext context,
    required String title,
    required String desc,
    required String assetName,
    Widget? customTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(18.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(assetName: assetName, width: 18.w, height: 18.w),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTitle ??
                    Text(
                      title,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                8.verticalSpace,
                Text(
                  desc,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _branchManagerRequestsDeliveryTimeBottomSheetWidget(
    BuildContext context,
    ApproveOrRejectOrderCubit approveOrRejectOrderCubit,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SelectBranchManagerDeliveryTimeCubit>(),
        ),
        BlocProvider.value(value: approveOrRejectOrderCubit),
      ],
      child: BranchManagerRequestsDeliveryTimeBottomSheetWidget(
        onConfirmButtonSuccess: () => NavigationService.I.popToFirst(),
        strategy: PartialApproveOrderStrategy(
          body: _body,
          orderId: widget.request.id,
        ),
      ),
    );
  }
}
