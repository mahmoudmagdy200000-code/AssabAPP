import '../../domain/entities/price_simulator_item_entity.dart';

class PriceSimulatorItemModel extends PriceSimulatorItemEntity {
  const PriceSimulatorItemModel({
    required super.id,
    required super.name,
  });

  factory PriceSimulatorItemModel.fromJson(Map<String, dynamic> json) {
    return PriceSimulatorItemModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? json['item_name'] ?? json['itemName'])
          ?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
