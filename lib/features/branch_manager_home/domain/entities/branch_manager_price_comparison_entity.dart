import 'package:equatable/equatable.dart';

class BranchManagerPriceComparisonEntity extends Equatable {
  final String id;
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final String itemCode;
  final String savedDate;
  final int quantity;

  const BranchManagerPriceComparisonEntity({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.itemLogo,
    required this.itemCode,
    required this.savedDate,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemName,
    itemLogo,
    itemCode,
    savedDate,
    quantity,
  ];
}
