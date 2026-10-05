import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/purchase_suppliers_response.dart';
import 'choose_supplier_options_bottom_sheet.dart';

class DirectSupplierListViewWidget extends StatelessWidget {
  final PurchaseSuppliersData supplier;
  final int quantity;
  final int selectedIndex;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final String addedItemMainId;

  const DirectSupplierListViewWidget({
    super.key,
    required this.supplier,
    required this.quantity,
    required this.selectedIndex,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.addedItemMainId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 12.r),
      child: Column(
        children: [
          Row(
            children: [
              ProfileImageWidget(image: supplier.supplier.image),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.supplier.name,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Row(
                      children: [
                        supplier.supplier.status.buildStatusWidget(context),
                      ],
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              SelectionCircule(
                isSelected:
                    context.watch<ChooseItemCubit>().state.selectedIndex ==
                    selectedIndex,
              ),
            ],
          ),
          16.verticalSpace,
          PurchaseItemPreviewWidget(
            itemImage: supplier.itemLogo,
            itemName: supplier.itemTitle,
            itemUnit: supplier.itemUnit,
            itemPrice: supplier.itemPrice.toDouble(),
            itemQuantity: quantity,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          Column(
            children: [
              _buildSupplierDetailRow(
                context: context,
                label:
                    'price Per ${supplier.itemUnit} i.e Kg',
                value: supplier.itemPrice.toDouble().toStringAsFixed(2),
              ),
              8.verticalSpace,
              _buildSupplierDetailRow(
                context: context,
                label: context.tr.deliveryTime,
                value: '${supplier.deliveryHours} ${context.tr.hr}',
              ),
              8.verticalSpace,
              _buildSupplierDetailRow(
                context: context,
                label: context.tr.availableOn,
                customValue: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    supplier.supplier.contactMethods.length,
                    (index) {
                      return _buildAvailabilityText(
                        context: context,
                        label: supplier.supplier.contactMethods[index],
                      );
                    },
                  ),
                ),
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          8.verticalSpace,
          AppButton(
            onClick: () {
              final validationCubit = context.read<ValidationCubit>();
              final chooseItemCubit = context.read<ChooseItemCubit>();

              AppBottomSheet.show(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: validationCubit),
                    BlocProvider.value(value: chooseItemCubit),
                  ],
                  child: ChooseSupplierOptionsBottomSheet(
                    supplier: supplier,
                    selectedIndex: selectedIndex,
                    sourceTypeFieldName: sourceTypeFieldName,
                    sourceIdFieldName: sourceIdFieldName,
                    sourceNameFieldName: sourceNameFieldName,
                    choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
                    addedItemMainId: addedItemMainId,
                  ),
                ),
              );
            },
            enabled: true,
            text: context.tr.selectThisSupplier,
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierDetailRow({
    required BuildContext context,
    required String label,
    String? value,
    Widget? customValue,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Expanded(
          child:
              customValue ??
              Text(
                value!,
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityText({
    required BuildContext context,
    required String label,
  }) {
    return Text(
      '$label -',
      textAlign: TextAlign.end,
      style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
    );
  }
}
