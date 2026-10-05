import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import 'add_item_state.dart';

@injectable
class AddItemCubit extends SafeCubit<AddItemState> {
  AddItemCubit() : super(const AddItemLoaded({}));

  String _generateRandomId() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(10, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  void addItem(String listName) {
    final updated = Map<String, List<String>>.from(state.lists);
    final items = List<String>.from(updated[listName] ?? []);
    items.add(_generateRandomId());
    updated[listName] = items;
    emit(AddItemLoaded(updated));
  }

  void removeItem(String listName, int index) {
    final updated = Map<String, List<String>>.from(state.lists);
    final items = List<String>.from(updated[listName] ?? []);

    if (index < 0 || index >= items.length) return;

    items.removeAt(index);
    updated[listName] = items;
    emit(AddItemLoaded(updated));
  }

  void clearList(String listName) {
    final updated = Map<String, List<String>>.from(state.lists);
    updated[listName] = [];
    emit(AddItemLoaded(updated));
  }
}
