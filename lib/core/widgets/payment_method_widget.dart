import 'package:assab/core/cubits/payment_method/payment_method_state.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/price_label.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/branch_manager_expenses/data/models/supplier_model.dart';
import '../../features/branch_manager_expenses/presentation/cubit/expenses_get_custody_balance/expenses_get_custody_balance_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/expenses_get_custody_balance/expenses_get_custody_balance_state.dart';
import '../../features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_state.dart';
import '../../features/branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import '../constants/app_assets.dart';
import '../cubits/payment_method/payment_method_cubit.dart';
import '../cubits/search/search_state.dart';
import '../di/dependency_injection.dart';
import '../enums/payment_method.dart';
import '../styles/app_styles.dart';
import 'app_button.dart';
import 'app_padding_widget.dart';
import 'app_search_empty_result_widget.dart';
import 'app_svg.dart';
import 'custom_divider.dart';

class PaymentMethodWidget extends StatefulWidget {
  final bool showHeader;
  final bool showConfirmButton;
  final bool showSupplierCredit;
  final ValueChanged<PaymentMethod>? onPaymentMethodSelected;

  const PaymentMethodWidget({
    super.key,
    this.showHeader = true,
    this.showConfirmButton = true,
    this.onPaymentMethodSelected,
    this.showSupplierCredit = true,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  late final ValueNotifier<bool> _isSupplierCreditExpanded;
  late final ValueNotifier<int> _supplierCreditCount;

  @override
  void initState() {
    context.read<SuppliersCubit>().getSuppliers();
    _isSupplierCreditExpanded = ValueNotifier<bool>(false);
    _supplierCreditCount = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  dispose() {
    _supplierCreditCount.dispose();
    _isSupplierCreditExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchCubit<SupplierModel>()),
        BlocProvider(
          create: (context) =>
              getIt<ExpensesGetCustodyBalanceCubit>()..getCustodyBalance(),
        ),
      ],
      child: Container(
        color: context.theme.scaffoldBackgroundColor,
        width: double.infinity,
        child: AppPaddingWidget(
          top: 0,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showHeader) ...[
                  Text(
                    context.tr.paymentMethod,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    context.tr.howWasThisExpensePaid,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  14.verticalSpace,
                  const CustomDivider(),
                  14.verticalSpace,
                ],
                _buildCustodyBalance(),
                12.verticalSpace,
                if (widget.showSupplierCredit) ...[
                  _buildSupplierCreditExpansion(),
                  12.verticalSpace,
                ],
                _buildCash(),
                if (widget.showConfirmButton) ...[
                  30.verticalSpace,
                  BlocSelector<PaymentMethodCubit, PaymentMethodState, bool>(
                    selector: (state) => state.selectedMethod != null,
                    builder: (context, state) {
                      return AppButton(
                        onClick: () {
                          NavigationService.I.pop();
                        },
                        enabled: state,
                        text: context.tr.confirmSelection,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustodyBalance() {
    return BlocBuilder<
      ExpensesGetCustodyBalanceCubit,
      ExpensesGetCustodyBalanceState
    >(
      builder: (context, state) {
        if (state is ExpensesGetCustodyBalanceLoading) {
          return const AppLoadingWidget();
        } else if (state is ExpensesGetCustodyBalanceFailure) {
          return AppFailureWidget(
            failure: state.failure,
            withBorder: false,
            onRetry: () {
              context
                  .read<ExpensesGetCustodyBalanceCubit>()
                  .getCustodyBalance();
            },
          );
        } else if (state is ExpensesGetCustodyBalanceSuccess) {
          final isBalanceZero = state.balance == 0;
          return IgnorePointer(
            ignoring: isBalanceZero,
            child: Opacity(
              opacity: isBalanceZero ? 0.5 : 1.0,
              child: AppGestureDetectorButton(
                onTap: () {
                  context.read<PaymentMethodCubit>().selectMethod(
                    PaymentMethod.custody,
                  );
                  widget.onPaymentMethodSelected?.call(PaymentMethod.custody);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr.custodyBalance,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          BlocSelector<
                            PaymentMethodCubit,
                            PaymentMethodState,
                            PaymentMethod?
                          >(
                            selector: (state) => state.selectedMethod,
                            builder: (context, selectedMethod) {
                              return SelectionCircule(
                                isSelected:
                                    selectedMethod == PaymentMethod.custody,
                              );
                            },
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: context.customColor.border),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              context.tr.balance,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text6,
                              ),
                            ),
                            const Spacer(),
                            PriceLabel(
                              amount: state.balance.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return AppLocalFailure(
          onRetry: () => context
              .read<ExpensesGetCustodyBalanceCubit>()
              .getCustodyBalance(),
          withBorder: false,
        );
      },
    );
  }

  Widget _buildSupplierCreditExpansion() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSupplierCreditExpanded,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppGestureDetectorButton(
                onTap: () => _isSupplierCreditExpanded.value =
                    !_isSupplierCreditExpanded.value,
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _supplierCreditCount,
                      builder: (context, value, child) {
                        return Text(
                          context.tr.supplierCredit(value),
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        );
                      },
                    ),
                    4.horizontalSpace,
                    Icon(
                      value
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      color: context.customColor.text1,
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Column(
                    children: [
                      TextFormField(
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                        onChanged: (value) {
                          context.read<SearchCubit<SupplierModel>>().search(
                            value,
                            (supplier, query) => supplier.name
                                .toLowerCase()
                                .contains(query.toLowerCase()),
                          );
                        },
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          hintText: context.tr.searchHint,
                          prefixIcon: Transform.scale(
                            scale: 0.4,
                            alignment: Alignment.center,
                            child: const AppSvg(assetName: AppAssets.search),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      BlocConsumer<SuppliersCubit, SuppliersState>(
                        listener: (context, state) {
                          if (state is SuppliersSuccess) {
                            context.read<SearchCubit<SupplierModel>>().setData(
                              state.suppliers.data,
                            );

                            _supplierCreditCount.value =
                                state.suppliers.data.length;
                          }
                        },
                        builder: (context, state) {
                          if (state is SuppliersLoading) {
                            return const AppLoadingWidget();
                          } else if (state is SuppliersFailure) {
                            return AppFailureWidget(
                              failure: state.failure,
                              withBorder: false,
                              onRetry: () {
                                context.read<SuppliersCubit>().getSuppliers();
                              },
                            );
                          }

                          return BlocBuilder<
                            SearchCubit<SupplierModel>,
                            SearchState<SupplierModel>
                          >(
                            builder: (context, searchState) {
                              if (searchState is SearchSuccess<SupplierModel>) {
                                final suppliers = searchState.results;

                                if (suppliers.isEmpty) {
                                  return const AppSearchEmptyResultWidget();
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: suppliers.length,
                                  itemBuilder: (context, index) {
                                    final supplier = suppliers[index];
                                    return AppGestureDetectorButton(
                                      onTap: () {
                                        context
                                            .read<PaymentMethodCubit>()
                                            .selectMethod(
                                              PaymentMethod.supplier,
                                            );
                                        context
                                            .read<PaymentMethodCubit>()
                                            .selectSupplier(supplier);
                                        widget.onPaymentMethodSelected?.call(
                                          PaymentMethod.supplier,
                                        );
                                        context
                                            .read<ValidationCubit>()
                                            .validateFieldAndStoreValue(
                                              fieldName: 'paymentSupplierId',
                                              value: supplier.id,
                                              isValid: true,
                                            );
                                      },
                                      child: Column(
                                        children: [
                                          BlocSelector<
                                            PaymentMethodCubit,
                                            PaymentMethodState,
                                            bool
                                          >(
                                            selector: (state) =>
                                                state.selectedMethod ==
                                                    PaymentMethod.supplier &&
                                                state.supplier?.id ==
                                                    supplier.id,
                                            builder: (context, isSelected) {
                                              return RowTextCirculeSelection(
                                                text: supplier.name,
                                                isSelected: isSelected,
                                              );
                                            },
                                          ),
                                          15.verticalSpace,
                                          Divider(
                                            height: 1.h,
                                            color: context.customColor.text2,
                                          ),
                                          15.verticalSpace,
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
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
      },
    );
  }

  Widget _buildCash() {
    return AppGestureDetectorButton(
      onTap: () {
        context.read<PaymentMethodCubit>().selectMethod(PaymentMethod.cash);
        widget.onPaymentMethodSelected?.call(PaymentMethod.cash);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr.cash,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            BlocSelector<
              PaymentMethodCubit,
              PaymentMethodState,
              PaymentMethod?
            >(
              selector: (state) => state.selectedMethod,
              builder: (context, selectedMethod) {
                return SelectionCircule(
                  isSelected: selectedMethod == PaymentMethod.cash,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
