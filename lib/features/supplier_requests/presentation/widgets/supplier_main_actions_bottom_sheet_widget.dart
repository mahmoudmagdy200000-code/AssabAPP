import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';

import '../../data/models/supplier_orders_response.dart';
import '../../domain/strategies/supplier_main_actions_strategy.dart';
import 'supplier_item_preview_widget.dart';

class SupplierMainActionsBottomSheetWidget extends StatefulWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierMainActionsBottomSheetWidget({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  State<SupplierMainActionsBottomSheetWidget> createState() =>
      _SupplierMainActionsBottomSheetWidgetState();
}

class _SupplierMainActionsBottomSheetWidgetState
    extends State<SupplierMainActionsBottomSheetWidget> {
  late final ValueNotifier<int> _selectedOptionIndexNotifier;

  @override
  void initState() {
    super.initState();

    _selectedOptionIndexNotifier = ValueNotifier<int>(-1);
  }

  @override
  void dispose() {
    _selectedOptionIndexNotifier.dispose();
    super.dispose();
  }

  List<SupplierMainActionsStrategy> get _actions => [
    ConfirmRequestedQuantityStrategyImpl(),
    ProposeNewQuantityStrategyImpl(),
    LowStockNeedTimeStrategyImpl(),
    ProposeAlternativeProductStrategyImpl(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.mainActions,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      context.tr.howWouldYouLikeToProceedWithThisItem,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    8.verticalSpace,
                    SupplierItemPreviewWidget(
                      itemName:
                          '${widget.item.productName} (${widget.item.orderedQuantity} ${widget.item.productUnit})',
                    ),
                    14.verticalSpace,
                    const CustomDivider(),
                    14.verticalSpace,
                    Text(
                      context.tr.alternativeOptions,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    12.verticalSpace,
                    ValueListenableBuilder(
                      valueListenable: _selectedOptionIndexNotifier,
                      builder: (context, value, child) {
                        return ListView.separated(
                          itemCount: 4,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final labels = [
                              context.tr.confirmRequestedQuantity,
                              context.tr.proposeNewQuantity,
                              context.tr.lowStockNeedTime,
                              context.tr.proposeAlternativeProduct,
                            ];

                            final descriptions = [
                              context
                                  .tr
                                  .iCanFulfillTheFullQuantityAsRequestedNoChangesNeeded,
                              context
                                  .tr
                                  .iCantProvideTheFullQtyIllEnterWhatIHaveRequiresBuyerApproval,
                              context
                                  .tr
                                  .iNeedMoreTimeToProcureAndDeliverTheFullQuantityRequiresBuyerApproval,
                              context
                                  .tr
                                  .theItemIsUnavailableIWillSuggestASubstituteForTheBuyerRequiresBuyerApproval,
                            ];

                            return _buildOptionRow(
                              context: context,
                              label: labels[index],
                              description: descriptions[index],
                              isSelected: value == index,
                              onTap: () {
                                _selectedOptionIndexNotifier.value = index;
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              12.verticalSpace,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            ValueListenableBuilder(
              valueListenable: _selectedOptionIndexNotifier,
              builder: (context, value, child) {
                return AppButton(
                  onClick: () {
                    _actions[value].action(
                      context,
                      widget.item,
                      widget.orderId,
                    );
                  },
                  enabled: value != -1,
                  text: context.tr.continue_c,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required BuildContext context,
    required String label,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.customColor.border),
          borderRadius: BorderRadius.circular(15.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    description,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
