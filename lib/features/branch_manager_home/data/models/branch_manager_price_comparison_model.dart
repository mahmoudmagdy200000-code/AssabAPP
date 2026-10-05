import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';

class BranchManagerPriceComparisonModel {
  final List<BranchManagerPriceComparisonItemModel> comparisons;

  const BranchManagerPriceComparisonModel({required this.comparisons});

  factory BranchManagerPriceComparisonModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final comparisonsJson = json['data'] as List<dynamic>;
    final comparisonsList = comparisonsJson
        .map(
          (item) => BranchManagerPriceComparisonItemModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return BranchManagerPriceComparisonModel(comparisons: comparisonsList);
  }
}

class BranchManagerPriceComparisonItemModel
    extends BranchManagerPriceComparisonEntity {
  const BranchManagerPriceComparisonItemModel({
    required super.id,
    required super.itemId,
    required super.itemName,
    super.itemLogo,
    required super.itemCode,
    required super.savedDate,
    required super.quantity,
  });

  factory BranchManagerPriceComparisonItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchManagerPriceComparisonItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      itemLogo: json['itemLogo'] as String?,
      itemCode: json['itemCode'] as String,
      savedDate: json['savedDate'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'item_name': itemName,
      'item_logo': itemLogo,
      'item_code': itemCode,
      'saved_date': savedDate,
      'quantity': quantity,
    };
  }
}
