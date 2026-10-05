import 'package:equatable/equatable.dart';

class PendingSaleItemEntity extends Equatable {
  final String name;
  final String image;
  final double amount;
  final String type;

  const PendingSaleItemEntity({
    required this.name,
    required this.image,
    required this.amount,
    required this.type,
  });

  @override
  List<Object> get props => [name, image, amount, type];
}

class PendingSalesEntity extends Equatable {
  final double total;
  final double paidAmount;
  final double shownInProfits;
  final String reason;
  final List<PendingSaleItemEntity> items;

  const PendingSalesEntity({
    required this.total,
    required this.paidAmount,
    required this.shownInProfits,
    required this.reason,
    required this.items,
  });

  @override
  List<Object> get props => [total, paidAmount, shownInProfits, reason, items];
}

class RentPaidEntity extends Equatable {
  final double amount;
  final double paidAmount;
  final double shownInProfits;

  const RentPaidEntity({
    required this.amount,
    required this.paidAmount,
    required this.shownInProfits,
  });

  @override
  List<Object> get props => [amount, paidAmount, shownInProfits];
}

class PreviousExpenseReconciliationEntity extends Equatable {
  final double amount;

  const PreviousExpenseReconciliationEntity({required this.amount});

  @override
  List<Object> get props => [amount];
}

class AdvancesFixedAssetsEntity extends Equatable {
  final double amount;

  const AdvancesFixedAssetsEntity({required this.amount});

  @override
  List<Object> get props => [amount];
}

class ZakatTaxesEntity extends Equatable {
  final double amount;
  final double boughtAmount;
  final double usedAmount;

  const ZakatTaxesEntity({
    required this.amount,
    required this.boughtAmount,
    required this.usedAmount,
  });

  @override
  List<Object> get props => [amount, boughtAmount, usedAmount];
}

class InventoryItemEntity extends Equatable {
  final String name;
  final double amount;
  final String type;

  const InventoryItemEntity({
    required this.name,
    required this.amount,
    required this.type,
  });

  @override
  List<Object> get props => [name, amount, type];
}

class InventoryEntity extends Equatable {
  final double total;
  final String reason;
  final List<InventoryItemEntity> items;

  const InventoryEntity({
    required this.total,
    required this.reason,
    required this.items,
  });

  @override
  List<Object> get props => [total, reason, items];
}

class NonCashExpenseEntity extends Equatable {
  final double depreciation;
  final double others;
  final double total;
  final String reason;

  const NonCashExpenseEntity({
    required this.depreciation,
    required this.others,
    required this.total,
    required this.reason,
  });

  @override
  List<Object> get props => [depreciation, others, total, reason];
}

class SupplierObligationItemEntity extends Equatable {
  final String name;
  final double amount;

  const SupplierObligationItemEntity({
    required this.name,
    required this.amount,
  });

  @override
  List<Object> get props => [name, amount];
}

class SupplierObligationsEntity extends Equatable {
  final double total;
  final String reason;
  final List<SupplierObligationItemEntity> items;

  const SupplierObligationsEntity({
    required this.total,
    required this.reason,
    required this.items,
  });

  @override
  List<Object> get props => [total, reason, items];
}

class AccruedSalaryItemEntity extends Equatable {
  final String name;
  final double amount;

  const AccruedSalaryItemEntity({
    required this.name,
    required this.amount,
  });

  @override
  List<Object> get props => [name, amount];
}

class AccruedSalariesEntity extends Equatable {
  final double total;
  final String reason;
  final List<AccruedSalaryItemEntity> items;

  const AccruedSalariesEntity({
    required this.total,
    required this.reason,
    required this.items,
  });

  @override
  List<Object> get props => [total, reason, items];
}

class FinalResultInfoEntity extends Equatable {
  final String description;

  const FinalResultInfoEntity({required this.description});

  @override
  List<Object> get props => [description];
}

class ProfitVsCashReconciliationEntity extends Equatable {
  final String dateRangeLabel;
  final double monthlyProfits;
  final double currentCash;
  final double difference;
  final PendingSalesEntity pendingSales;
  final RentPaidEntity rentPaid;
  final PreviousExpenseReconciliationEntity previousExpenseReconciliation;
  final AdvancesFixedAssetsEntity advancesFixedAssets;
  final ZakatTaxesEntity zakatTaxes;
  final InventoryEntity unusedInventory;
  final NonCashExpenseEntity nonCashExpenses;
  final SupplierObligationsEntity supplierObligations;
  final AccruedSalariesEntity accruedSalaries;
  final double expectedCash;
  final List<FinalResultInfoEntity> finalResultInfo;

  const ProfitVsCashReconciliationEntity({
    required this.dateRangeLabel,
    required this.monthlyProfits,
    required this.currentCash,
    required this.difference,
    required this.pendingSales,
    required this.rentPaid,
    required this.previousExpenseReconciliation,
    required this.advancesFixedAssets,
    required this.zakatTaxes,
    required this.unusedInventory,
    required this.nonCashExpenses,
    required this.supplierObligations,
    required this.accruedSalaries,
    required this.expectedCash,
    required this.finalResultInfo,
  });

  @override
  List<Object> get props => [
    dateRangeLabel,
    monthlyProfits,
    currentCash,
    difference,
    pendingSales,
    rentPaid,
    previousExpenseReconciliation,
    advancesFixedAssets,
    zakatTaxes,
    unusedInventory,
    nonCashExpenses,
    supplierObligations,
    accruedSalaries,
    expectedCash,
    finalResultInfo,
  ];
}
