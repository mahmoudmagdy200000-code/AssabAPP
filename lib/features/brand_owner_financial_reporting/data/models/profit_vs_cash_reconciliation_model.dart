import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';

class PendingSaleItemModel extends PendingSaleItemEntity {
  const PendingSaleItemModel({
    required super.name,
    required super.image,
    required super.amount,
    required super.type,
  });

  factory PendingSaleItemModel.fromJson(Map<String, dynamic> json) {
    return PendingSaleItemModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
    );
  }
}

class PendingSalesModel extends PendingSalesEntity {
  const PendingSalesModel({
    required super.total,
    required super.paidAmount,
    required super.shownInProfits,
    required super.reason,
    required super.items,
  });

  factory PendingSalesModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map(
              (e) => PendingSaleItemModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return PendingSalesModel(
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      shownInProfits: (json['shown_in_profits'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
      items: itemsList,
    );
  }
}

class RentPaidModel extends RentPaidEntity {
  const RentPaidModel({
    required super.amount,
    required super.paidAmount,
    required super.shownInProfits,
  });

  factory RentPaidModel.fromJson(Map<String, dynamic> json) {
    return RentPaidModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      shownInProfits: (json['shown_in_profits'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PreviousExpenseReconciliationModel
    extends PreviousExpenseReconciliationEntity {
  const PreviousExpenseReconciliationModel({required super.amount});

  factory PreviousExpenseReconciliationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PreviousExpenseReconciliationModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AdvancesFixedAssetsModel extends AdvancesFixedAssetsEntity {
  const AdvancesFixedAssetsModel({required super.amount});

  factory AdvancesFixedAssetsModel.fromJson(Map<String, dynamic> json) {
    return AdvancesFixedAssetsModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ZakatTaxesModel extends ZakatTaxesEntity {
  const ZakatTaxesModel({
    required super.amount,
    required super.boughtAmount,
    required super.usedAmount,
  });

  factory ZakatTaxesModel.fromJson(Map<String, dynamic> json) {
    return ZakatTaxesModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      boughtAmount: (json['bought_amount'] as num?)?.toDouble() ?? 0.0,
      usedAmount: (json['used_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InventoryItemModel extends InventoryItemEntity {
  const InventoryItemModel({
    required super.name,
    required super.amount,
    required super.type,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
    );
  }
}

class InventoryModel extends InventoryEntity {
  const InventoryModel({
    required super.total,
    required super.reason,
    required super.items,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return InventoryModel(
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
      items: itemsList,
    );
  }
}

class NonCashExpenseModel extends NonCashExpenseEntity {
  const NonCashExpenseModel({
    required super.depreciation,
    required super.others,
    required super.total,
    required super.reason,
  });

  factory NonCashExpenseModel.fromJson(Map<String, dynamic> json) {
    return NonCashExpenseModel(
      depreciation: (json['depreciation'] as num?)?.toDouble() ?? 0.0,
      others: (json['others'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class SupplierObligationItemModel extends SupplierObligationItemEntity {
  const SupplierObligationItemModel({
    required super.name,
    required super.amount,
  });

  factory SupplierObligationItemModel.fromJson(Map<String, dynamic> json) {
    return SupplierObligationItemModel(
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SupplierObligationsModel extends SupplierObligationsEntity {
  const SupplierObligationsModel({
    required super.total,
    required super.reason,
    required super.items,
  });

  factory SupplierObligationsModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map(
              (e) => SupplierObligationItemModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    return SupplierObligationsModel(
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
      items: itemsList,
    );
  }
}

class AccruedSalaryItemModel extends AccruedSalaryItemEntity {
  const AccruedSalaryItemModel({required super.name, required super.amount});

  factory AccruedSalaryItemModel.fromJson(Map<String, dynamic> json) {
    return AccruedSalaryItemModel(
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AccruedSalariesModel extends AccruedSalariesEntity {
  const AccruedSalariesModel({
    required super.total,
    required super.reason,
    required super.items,
  });

  factory AccruedSalariesModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map(
              (e) => AccruedSalaryItemModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return AccruedSalariesModel(
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
      items: itemsList,
    );
  }
}

class FinalResultInfoModel extends FinalResultInfoEntity {
  const FinalResultInfoModel({required super.description});

  factory FinalResultInfoModel.fromJson(Map<String, dynamic> json) {
    return FinalResultInfoModel(
      description: json['description']?.toString() ?? '',
    );
  }
}

class ProfitVsCashReconciliationModel extends ProfitVsCashReconciliationEntity {
  const ProfitVsCashReconciliationModel({
    required super.dateRangeLabel,
    required super.monthlyProfits,
    required super.currentCash,
    required super.difference,
    required super.pendingSales,
    required super.rentPaid,
    required super.previousExpenseReconciliation,
    required super.advancesFixedAssets,
    required super.zakatTaxes,
    required super.unusedInventory,
    required super.nonCashExpenses,
    required super.supplierObligations,
    required super.accruedSalaries,
    required super.expectedCash,
    required super.finalResultInfo,
  });

  factory ProfitVsCashReconciliationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final finalResultList =
        (data['final_result_info'] as List<dynamic>?)
            ?.map(
              (e) => FinalResultInfoModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return ProfitVsCashReconciliationModel(
      dateRangeLabel: data['date_range_label']?.toString() ?? '',
      monthlyProfits: (data['monthly_profits'] as num?)?.toDouble() ?? 0.0,
      currentCash: (data['current_cash'] as num?)?.toDouble() ?? 0.0,
      difference: (data['difference'] as num?)?.toDouble() ?? 0.0,
      pendingSales: PendingSalesModel.fromJson(
        data['pending_sales'] as Map<String, dynamic>? ?? {},
      ),
      rentPaid: RentPaidModel.fromJson(
        data['rent_paid'] as Map<String, dynamic>? ?? {},
      ),
      previousExpenseReconciliation:
          PreviousExpenseReconciliationModel.fromJson(
            data['previous_expense_reconciliation'] as Map<String, dynamic>? ??
                {},
          ),
      advancesFixedAssets: AdvancesFixedAssetsModel.fromJson(
        data['advances_fixed_assets'] as Map<String, dynamic>? ?? {},
      ),
      zakatTaxes: ZakatTaxesModel.fromJson(
        data['zakat_taxes'] as Map<String, dynamic>? ?? {},
      ),
      unusedInventory: InventoryModel.fromJson(
        data['unused_inventory'] as Map<String, dynamic>? ?? {},
      ),
      nonCashExpenses: NonCashExpenseModel.fromJson(
        data['non_cash_expenses'] as Map<String, dynamic>? ?? {},
      ),
      supplierObligations: SupplierObligationsModel.fromJson(
        data['supplier_obligations'] as Map<String, dynamic>? ?? {},
      ),
      accruedSalaries: AccruedSalariesModel.fromJson(
        data['accrued_salaries'] as Map<String, dynamic>? ?? {},
      ),
      expectedCash: (data['expected_cash'] as num?)?.toDouble() ?? 0.0,
      finalResultInfo: finalResultList,
    );
  }
}
