import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/purchase_branch_items_response.dart';
import 'add_item_purchase_state.dart';

@injectable
class AddItemPurchaseCubit extends SafeCubit<AddItemPurchaseState> {
  AddItemPurchaseCubit() : super(const AddItemPurchaseState());

  void addItem(PurchaseBranchItemData item) {
    final updatedItems = Map<PurchaseBranchItemData, int>.from(state.items);

    updatedItems[item] = (updatedItems[item] ?? 0) + 1;

    emit(state.copyWith(items: updatedItems));
  }

  void setItemQuantity(PurchaseBranchItemData item, int quantity) {
    final updatedItems = Map<PurchaseBranchItemData, int>.from(state.items);

    if (quantity <= 0) {
      updatedItems.remove(item);
    } else {
      updatedItems[item] = quantity;
    }

    emit(state.copyWith(items: updatedItems));
  }

  void removeItem(PurchaseBranchItemData item) {
    final updatedItems = Map<PurchaseBranchItemData, int>.from(state.items);

    final current = updatedItems[item] ?? 0;

    if (current > 1) {
      updatedItems[item] = current - 1;
    } else {
      updatedItems.remove(item);
    }

    emit(state.copyWith(items: updatedItems));
  }

  bool anyItemsSelected() {
    return state.items.values.any((quantity) => quantity > 0);
  }

  /// Atomically replaces all items in the map. Used to swap draft-created
  /// keys with API-fetched keys while preserving quantities in a single emit.
  void replaceItems(Map<PurchaseBranchItemData, int> items) {
    emit(state.copyWith(items: items));
  }

  void clearItems() {
    emit(state.copyWith(items: {}));
  }

  int get totalItemsInCart => state.items.length;
}
