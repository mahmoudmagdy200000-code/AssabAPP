import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_model.g.dart';

@JsonSerializable()
class SupplierModel extends Equatable {
  final String id;
  final String name;

  const SupplierModel({required this.id, required this.name});

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupplierModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  List<Object> get props => [id, name];
}
