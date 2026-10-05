import 'package:equatable/equatable.dart';

import '../../../data/models/wasted_damage_items_response.dart';

class WastedSelectedItemsState extends Equatable {
  final List<WastedDamageItemData> items;

  const WastedSelectedItemsState({this.items = const []});

  WastedSelectedItemsState copyWith({List<WastedDamageItemData>? items}) {
    return WastedSelectedItemsState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
