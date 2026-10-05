import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'available_cashiers_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AvailableCashiersResponse {
  final bool success;
  final String message;
  final List<AvailableCashier> data;
  final MetaModel meta;

  AvailableCashiersResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AvailableCashiersResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableCashiersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableCashiersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AvailableCashier {
  final String id;
  final String name;
  final String email;
  final String? image;

  @JsonKey(name: 'is_available')
  final bool isAvailable;

  @JsonKey(name: 'reason_disabled')
  final String? reasonDisabled;

  AvailableCashier({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.isAvailable,
    this.reasonDisabled,
  });

  factory AvailableCashier.fromJson(Map<String, dynamic> json) =>
      _$AvailableCashierFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableCashierToJson(this);
}
