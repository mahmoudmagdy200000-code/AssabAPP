import 'package:equatable/equatable.dart';

import '../../../data/models/purchase_branch_items_response.dart';

class AddItemPurchaseState extends Equatable {
  final Map<PurchaseBranchItemData, int> items;

  const AddItemPurchaseState({this.items = const {}});

  AddItemPurchaseState copyWith({Map<PurchaseBranchItemData, int>? items}) {
    return AddItemPurchaseState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
