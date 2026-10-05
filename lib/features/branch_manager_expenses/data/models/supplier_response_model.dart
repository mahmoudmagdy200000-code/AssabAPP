import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SupplierResponseModel extends Equatable {
  final List<SupplierModel> data;

  const SupplierResponseModel({required this.data});

  factory SupplierResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierResponseModelToJson(this);

  @override
  List<Object> get props => [data];
}
