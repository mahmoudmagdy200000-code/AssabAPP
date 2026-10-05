import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/payment_method_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/top_section_of_single_expense_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/suppliers/suppliers_cubit.dart';
import '../widgets/payment_deferred_type.dart';
import '../widgets/payment_partial_type.dart';

class SingleExpensePaymentView extends StatelessWidget {
  final ValueChanged<int> whenPaymentTypeChange;

  const SingleExpensePaymentView({
    super.key,
    required this.whenPaymentTypeChange,
  });

  void _onClickPaymentButton(BuildContext context, int index) {
    whenPaymentTypeChange(index);
    context.read<PagingCubit>().goToStep(index);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopSectionOfSingleExpenseViews(
            title: context.tr.paymentMethod,
            desc: context.tr.selectPaymentMethodDesc,
          ),
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: BlocBuilder<PagingCubit, PagingState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    final paymentMethods = <String>[
                      context.tr.full,
                      context.tr.partial,
                      context.tr.deferred,
                    ];

                    return _paymentMethodButton(
                      context: context,
                      text: paymentMethods[index],
                      isSelected: state.currentIndex == index,
                      onTap: () => _onClickPaymentButton(context, index),
                    );
                  }),
                );
              },
            ),
          ),
          14.verticalSpace,
          const CustomDivider(),
          14.verticalSpace,
          BlocBuilder<PagingCubit, PagingState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.currentIndex,
                children: [
                  BlocProvider(
                    create: (context) => getIt<SuppliersCubit>(),
                    child: PaymentMethodWidget(
                      showHeader: false,
                      showConfirmButton: false,
                      onPaymentMethodSelected: (value) {
                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreValue(
                              fieldName: 'singlePaymentMethod',
                              value: value.paymentMethodToString(),
                              isValid: true,
                            );
                      },
                    ),
                  ),
                  const PaymentPartialType(),
                  const PaymentDeferredType(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColor.reversedTextColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.r),
        child: Text(
          text,
          style: AppStyles.s13W600.copyWith(
            color: isSelected
                ? context.customColor.text1
                : context.customColor.text3,
          ),
        ),
      ),
    );
  }
}
