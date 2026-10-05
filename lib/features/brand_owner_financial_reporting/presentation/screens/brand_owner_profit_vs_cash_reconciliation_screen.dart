import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';
import '../cubit/export_profit_vs_cash_reconciliation_cubit.dart';
import '../cubit/export_profit_vs_cash_reconciliation_state.dart';
import '../cubit/profit_vs_cash_reconciliation_cubit.dart';
import '../cubit/profit_vs_cash_reconciliation_state.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';
import '../widgets/profit_vs_cash_reconciliation_accrued_salaries_details_bottom_sheet.dart';
import '../widgets/profit_vs_cash_reconciliation_final_result_bottom_sheet.dart';
import '../widgets/profit_vs_cash_reconciliation_inventory_details_bottom_sheet.dart';
import '../widgets/profit_vs_cash_reconciliation_non_cash_expenses_bottom_sheet.dart';
import '../widgets/profit_vs_cash_reconciliation_pending_sales_overview_bottom_sheet.dart';
import '../widgets/profit_vs_cash_reconciliation_supplier_obligations_details_bottom_sheet.dart';

class BrandOwnerProfitVsCashReconciliationScreen extends StatefulWidget {
  const BrandOwnerProfitVsCashReconciliationScreen({super.key});

  @override
  State<BrandOwnerProfitVsCashReconciliationScreen> createState() =>
      _BrandOwnerProfitVsCashReconciliationScreenState();
}

class _BrandOwnerProfitVsCashReconciliationScreenState
    extends State<BrandOwnerProfitVsCashReconciliationScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProfitVsCashReconciliationCubit>()
        .loadProfitVsCashReconciliation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ProfitVsCashReconciliationCubit,
      ProfitVsCashReconciliationState
    >(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.primaryColor,
          body: Column(
            children: [
              AppPaddingWidget(
                top: 30.r,
                child: Row(
                  children: [
                    const AppBackButton(isTransparent: true),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).profitVsCashReconciliation,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            context.tr.nakheelRestaurantChain,
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: Icons.refresh,
                      onPressed: () {
                        if (state is ProfitVsCashReconciliationLoading) {
                          return;
                        }
                        context
                            .read<ProfitVsCashReconciliationCubit>()
                            .loadProfitVsCashReconciliation();
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: context.customColor.reversedTextColor,
                      borderColor: context.customColor.reversedTextColor,
                      borderRadius: 12.r,
                      padding: 10.r,
                      size: 16.r,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: switch (state) {
                    ProfitVsCashReconciliationInitial() =>
                      const SizedBox.shrink(),
                    ProfitVsCashReconciliationLoading() =>
                      const AppLoadingWidget(),
                    ProfitVsCashReconciliationSuccess(:final data) =>
                      _buildContent(context, data),
                    ProfitVsCashReconciliationFailure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<ProfitVsCashReconciliationCubit>()
                            .loadProfitVsCashReconciliation(),
                      ),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfitVsCashReconciliationEntity data,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).quickOverview,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildQuickOverview(context, data),
                10.verticalSpace,
                Text(
                  S.of(context).amountsCalculatedButNotReceived,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildPendingSalesCard(context, data.pendingSales),
                10.verticalSpace,
                Text(
                  S.of(context).paidCashButNotFullyShownInProfits,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildRentPaidCard(context, data.rentPaid),
                10.verticalSpace,
                _buildPreviousExpenseCard(
                  context,
                  data.previousExpenseReconciliation,
                ),
                10.verticalSpace,
                _buildAdvancesFixedAssetsCard(
                  context,
                  data.advancesFixedAssets,
                ),
                10.verticalSpace,
                _buildZakatTaxesCard(context, data.zakatTaxes),
                10.verticalSpace,
                _buildUnusedInventoryCard(context, data.unusedInventory),
                10.verticalSpace,
                _buildNonCashExpensesCard(context, data.nonCashExpenses),
                10.verticalSpace,
                Text(
                  S.of(context).obligationsNotYetPaid,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildSupplierObligationsCard(
                  context,
                  data.supplierObligations,
                ),
                10.verticalSpace,
                _buildAccruedSalariesCard(context, data.accruedSalaries),
                10.verticalSpace,
                _buildFinalResultHeader(context, data),
                10.verticalSpace,
                _buildExpectedCashCard(context, data.expectedCash),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context),
      ],
    );
  }

  Widget _buildQuickOverview(
    BuildContext context,
    ProfitVsCashReconciliationEntity data,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          _buildRowOverview(
            context,
            title: 'Your Monthly Profits',
            amount: data.monthlyProfits.toStringAsFixed(0),
          ),
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          _buildRowOverview(
            context,
            title: 'Your Current Cash',
            amount: data.currentCash.toStringAsFixed(0),
          ),
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          _buildRowOverview(
            context,
            title: S.of(context).difference,
            amount: data.difference.toStringAsFixed(0),
            amountColor: context.customColor.error,
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvg(
                  assetName: AppAssets.calendar,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                5.horizontalSpace,
                Flexible(
                  child: Text(
                    data.dateRangeLabel,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSalesCard(
    BuildContext context,
    PendingSalesEntity pendingSales,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.cash,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                _buildRowOverview(
                  context,
                  title: S.of(context).pendingSalesApps,
                  amount: '-${pendingSales.total.toStringAsFixed(0)}',
                  amountColor: context.customColor.error,
                  titleTextStyle: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Paid ${pendingSales.paidAmount.toStringAsFixed(0)} Only ${pendingSales.shownInProfits.toStringAsFixed(0)} Shown in Profits',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    _buildRecButton(
                      context,
                      onTap: () {
                        AppBottomSheet.showModal(
                          context,
                          isScrollControlled: true,
                          (context) =>
                              ProfitVsCashReconciliationPendingSalesOverviewBottomSheet(
                                data: pendingSales,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentPaidCard(BuildContext context, RentPaidEntity rentPaid) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.home,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                _buildRowOverview(
                  context,
                  title: S.of(context).rentPaid,
                  amount: '-${rentPaid.amount.toStringAsFixed(0)}',
                  amountColor: context.customColor.error,
                  titleTextStyle: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Paid ${rentPaid.paidAmount.toStringAsFixed(0)} Only ${rentPaid.shownInProfits.toStringAsFixed(0)} Shown in Profits',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    _buildRecButton(context, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousExpenseCard(
    BuildContext context,
    PreviousExpenseReconciliationEntity item,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.receipt,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildRowOverview(
                    context,
                    title: S.of(context).previousExpenseReconciliation,
                    amount: '-${item.amount.toStringAsFixed(0)}',
                    amountColor: context.customColor.error,
                    titleTextStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                _buildRecButton(context, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancesFixedAssetsCard(
    BuildContext context,
    AdvancesFixedAssetsEntity item,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.cashHandoverSvg,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildRowOverview(
                    context,
                    title: S.of(context).advancesfixedAssets,
                    amount: '-${item.amount.toStringAsFixed(0)}',
                    amountColor: context.customColor.error,
                    titleTextStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                _buildRecButton(context, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZakatTaxesCard(
    BuildContext context,
    ZakatTaxesEntity zakatTaxes,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.home,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                _buildRowOverview(
                  context,
                  title: S.of(context).zakattaxes,
                  amount: '-${zakatTaxes.amount.toStringAsFixed(0)}',
                  amountColor: context.customColor.error,
                  titleTextStyle: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Bought ${zakatTaxes.boughtAmount.toStringAsFixed(0)} used Only ${zakatTaxes.usedAmount.toStringAsFixed(0)}',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    _buildRecButton(context, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnusedInventoryCard(
    BuildContext context,
    InventoryEntity inventory,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.box,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildRowOverview(
                    context,
                    title: S.of(context).unusedInventory,
                    amount: '-${inventory.total.toStringAsFixed(0)}',
                    amountColor: context.customColor.error,
                    titleTextStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                _buildRecButton(
                  context,
                  onTap: () {
                    AppBottomSheet.showModal(
                      context,
                      isScrollControlled: true,
                      (context) =>
                          ProfitVsCashReconciliationInventoryDetailsBottomSheet(
                            data: inventory,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonCashExpensesCard(
    BuildContext context,
    NonCashExpenseEntity nonCashExpenses,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.primaryColor.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.receipt,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                _buildRowOverview(
                  context,
                  title: S.of(context).noncashExpenses,
                  amount: '+${nonCashExpenses.total.toStringAsFixed(0)}',
                  amountColor: AppColors.lightGreen,
                  titleTextStyle: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        S.of(context).depreciationEtc,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    _buildRecButton(
                      context,
                      onTap: () {
                        AppBottomSheet.showModal(
                          context,
                          isScrollControlled: true,
                          (context) =>
                              ProfitVsCashReconciliationNonCashExpensesBottomSheet(
                                data: nonCashExpenses,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierObligationsCard(
    BuildContext context,
    SupplierObligationsEntity supplierObligations,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffFBBDE1), width: 3.r),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.expenseSvg,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildRowOverview(
                    context,
                    title: S.of(context).supplierInvoices,
                    amount: '+${supplierObligations.total.toStringAsFixed(0)}',
                    amountColor: AppColors.lightGreen,
                    titleTextStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                _buildRecButton(
                  context,
                  onTap: () {
                    AppBottomSheet.showModal(
                      context,
                      isScrollControlled: true,
                      (context) =>
                          ProfitVsCashReconciliationSupplierObligationsDetailsBottomSheet(
                            data: supplierObligations,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccruedSalariesCard(
    BuildContext context,
    AccruedSalariesEntity accruedSalaries,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffFBBDE1), width: 3.r),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.personSvg,
            width: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _buildRowOverview(
                    context,
                    title: S.of(context).accruedSalaries,
                    amount: '+${accruedSalaries.total.toStringAsFixed(0)}',
                    amountColor: AppColors.lightGreen,
                    titleTextStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                5.horizontalSpace,
                _buildRecButton(
                  context,
                  onTap: () {
                    AppBottomSheet.showModal(
                      context,
                      isScrollControlled: true,
                      (context) =>
                          ProfitVsCashReconciliationAccruedSalariesDetailsBottomSheet(
                            data: accruedSalaries,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalResultHeader(
    BuildContext context,
    ProfitVsCashReconciliationEntity data,
  ) {
    return Row(
      children: [
        Flexible(
          child: Text(
            S.of(context).finalResult,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
          ),
        ),
        5.horizontalSpace,
        AppGestureDetectorButton(
          onTap: () {
            AppBottomSheet.showModal(
              context,
              (context) => ProfitVsCashReconciliationFinalResultBottomSheet(
                data: data.finalResultInfo,
              ),
            );
          },
          child: Icon(
            Icons.error,
            color: context.theme.primaryColor.withValues(alpha: 0.5),
            size: 16.r,
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedCashCard(BuildContext context, double expectedCash) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightGreen.withValues(alpha: 0.5),
          width: 3.r,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _buildRowOverview(
              context,
              title: S.of(context).yourExpectedCash,
              amount: expectedCash.toStringAsFixed(0),
              amountColor: context.customColor.text1,
              titleTextStyle: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 18.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(BuildContext context) {
    return BlocListener<
      ExportProfitVsCashReconciliationCubit,
      ExportProfitVsCashReconciliationState
    >(
      listener: (context, state) {
        if (state is ExportProfitVsCashReconciliationSuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportProfitVsCashReconciliationFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is ExportProfitVsCashReconciliationEmailSuccess) {
          AppSnackBar.showSuccess(context, 'Report sent to email successfully');
        } else if (state is ExportProfitVsCashReconciliationEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            ExportProfitVsCashReconciliationCubit,
            ExportProfitVsCashReconciliationState
          >(
            builder: (context, exportState) {
              return switch (exportState) {
                ExportProfitVsCashReconciliationLoading() ||
                ExportProfitVsCashReconciliationEmailLoading() =>
                  const AppLoadingWidget(),
                _ => BrandOwnerFinancialReportingExportsButtons(
                  pdf: () {
                    context
                        .read<ExportProfitVsCashReconciliationCubit>()
                        .exportProfitVsCashReconciliation(
                          formatType: 'pdf',
                        );
                  },
                  excel: () {
                    context
                        .read<ExportProfitVsCashReconciliationCubit>()
                        .exportProfitVsCashReconciliation(
                          formatType: 'excel',
                        );
                  },
                  email: (email) {
                    NavigationService.I.pop();
                    context
                        .read<ExportProfitVsCashReconciliationCubit>()
                        .exportProfitVsCashReconciliationByEmail(
                          email: email,
                        );
                  },
                ),
              };
            },
          ),
    );
  }

  Widget _buildRowOverview(
    BuildContext context, {
    required String title,
    required String amount,
    Color? amountColor,
    TextStyle? titleTextStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style:
                titleTextStyle ??
                AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SaudiRiyalSvgWidget(),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  amount,
                  style: AppStyles.s13W500.copyWith(
                    color: amountColor ?? context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecButton(BuildContext context, {required VoidCallback onTap}) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: AppSvg(
        assetName: AppAssets.receipt,
        width: 12.r,
        colorFilter: ColorFilter.mode(
          context.theme.primaryColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
