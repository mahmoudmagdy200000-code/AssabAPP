import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/wasted_damage_items_response.dart';
import 'wasted_selected_items_state.dart';

@injectable
class WastedSelectedItemsCubit extends SafeCubit<WastedSelectedItemsState> {
  WastedSelectedItemsCubit() : super(const WastedSelectedItemsState());

  void addItems(List<WastedDamageItemData> newItems) {
    final currentItems = List<WastedDamageItemData>.from(state.items);
    final existingIds = currentItems.map((e) => e.id).toSet();

    for (final item in newItems) {
      if (!existingIds.contains(item.id)) {
        currentItems.add(item);
        existingIds.add(item.id);
      }
    }

    emit(state.copyWith(items: currentItems));
  }

  void removeItem(String itemId) {
    final updatedItems = state.items
        .where((item) => item.id != itemId)
        .toList();

    emit(state.copyWith(items: updatedItems));
  }

  void clearAll() {
    emit(const WastedSelectedItemsState());
  }
}
