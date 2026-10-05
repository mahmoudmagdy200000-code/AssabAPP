import 'package:assab/core/cubits/payment_method/payment_method_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/payment_method/payment_method_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/payment_method_widget.dart';
import '../../data/models/supplier_model.dart';

class ExpensesPaymentField extends StatelessWidget {
  final bool showHeader;
  final bool showConfirmButton;
  final bool showSupplierCredit;
  final ValueChanged<PaymentMethod>? onPaymentMethodSelected;

  const ExpensesPaymentField({
    super.key,
    this.onPaymentMethodSelected,
    this.showHeader = true,
    this.showConfirmButton = true,
    this.showSupplierCredit = true,
  });

  void _onTap(BuildContext context) {
    final paymentMethodCubit = context.read<PaymentMethodCubit>();
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: paymentMethodCubit),
          BlocProvider.value(value: validationCubit),
          BlocProvider(create: (context) => getIt<SuppliersCubit>()),
        ],
        child: PaymentMethodWidget(
          showHeader: showHeader,
          showConfirmButton: showConfirmButton,
          showSupplierCredit: showSupplierCredit,
          onPaymentMethodSelected: onPaymentMethodSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PaymentMethodCubit,
      PaymentMethodState,
      (PaymentMethod?, SupplierModel?)
    >(
      selector: (state) => (state.selectedMethod, state.supplier),
      builder: (context, tuple) {
        final paymentMethodState = tuple.$1;
        final supplierName = tuple.$2;

        return BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, state) {
            return AppGestureDetectorButton(
              onTap: () => _onTap(context),
              child: ContainerCustomTextField(
                label: context.tr.paymentMethod,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        paymentMethodState == PaymentMethod.supplier
                            ? '${paymentMethodState?.displayName(context)}/${supplierName?.name}'
                            : paymentMethodState?.displayName(context) ??
                                  context.tr.choose,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.customColor.text1,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
