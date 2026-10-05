import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:assab/core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/features/receive_goods/data/models/receive_goods_local_item_model.dart';

import '../../../../core/enums/variance_required_actions_enum.dart';
import '../../presentation/screens/receive_order_order_view.dart';

abstract class VarianceRequiredActionsStrategy {
  String get value;

  int get insertIndex => 3;

  String actionLabel(BuildContext context);

  void addDynamicView(BuildContext context) {
    final dynamicStepsCubit = context.read<DynamicStepsCubit>();
    // Remove only the required action step, not the summary
    if (dynamicStepsCubit.state.builders.length > insertIndex + 1) {
      dynamicStepsCubit.removeStep(insertIndex);
    }
  }

  Widget buildAmountDetailsWidget(BuildContext context, bool isSelected) {
    if (!isSelected) {
      return const SizedBox.shrink();
    }

    final validationCubit = context.read<ValidationCubit>();
    final List<ReceiveGoodsLocalItemModel>? items = validationCubit
        .getListValue<ReceiveGoodsLocalItemModel>('receiveGoodsItems');

    double beforeVarianceAmount = 0;
    double afterVarianceAmount = 0;

    for (final item in items ?? []) {
      beforeVarianceAmount += item.qtyOrdered * item.unitPrice;
      afterVarianceAmount += item.qtyReceived * item.unitPrice;
    }

    final double amountToDeduct = afterVarianceAmount - beforeVarianceAmount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              context.tr.amountToDeduct,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          const SaudiRiyalSvgWidget(),
          Text(
            amountToDeduct.toStringAsFixed(2),
            style: AppStyles.s13WB.copyWith(color: context.customColor.text4),
          ),
        ],
      ),
    );
  }
}

class AcceptAsIsVarianceRequiredActionsStrategy
    extends VarianceRequiredActionsStrategy {
  @override
  String get value => VarianceRequiredActionsEnum.acceptAsIs.value;

  @override
  String actionLabel(BuildContext context) => context.tr.acceptVarianceAsIs;

  @override
  Widget buildAmountDetailsWidget(BuildContext context, bool isSelected) {
    return const SizedBox.shrink();
  }
}

class CreateCompensatoryOrderVarianceRequiredActionsStrategy
    extends VarianceRequiredActionsStrategy {
  @override
  String get value => VarianceRequiredActionsEnum.createCompensatoryOrder.value;

  @override
  String actionLabel(BuildContext context) =>
      context.tr.createCompensatoryOrderForMissingQuantity;

  @override
  void addDynamicView(BuildContext context) {
    super.addDynamicView(context);
    final dynamicStepsCubit = context.read<DynamicStepsCubit>();
    dynamicStepsCubit.insertStep(
      insertIndex,
      () => const ReceiveOrderOrderView(),
      context.tr.order,
    );
  }
}

class DeductFromInvoiceValueVarianceRequiredActionsStrategy
    extends VarianceRequiredActionsStrategy {
  @override
  String get value => VarianceRequiredActionsEnum.deductFromInvoiceValue.value;

  @override
  String actionLabel(BuildContext context) => context.tr.deductFromInvoiceValue;
}
