import 'package:json_annotation/json_annotation.dart';

import '../../../../../shared/models/meta_model/meta_model.dart';
import 'cashier_model.dart';

part 'get_all_cashiers_and_managers_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAllCashiersAndManagersResponse {
  final bool success;
  final String message;
  final CashiersData data;
  final MetaModel meta;

  GetAllCashiersAndManagersResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory GetAllCashiersAndManagersResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GetAllCashiersAndManagersResponseFromJson(json);
  Map<String, dynamic> toJson() =>
      _$GetAllCashiersAndManagersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CashiersData {
  @JsonKey(name: 'branch_managers')
  final List<BranchManager> branchManagers;
  final List<Cashier> cashiers;

  CashiersData({required this.branchManagers, required this.cashiers});

  factory CashiersData.fromJson(Map<String, dynamic> json) =>
      _$CashiersDataFromJson(json);
  Map<String, dynamic> toJson() => _$CashiersDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BranchManager {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final Branch branch;
  final StatusModel status;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_first_login')
  final bool isFirstLogin;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  BranchManager({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    required this.branch,
    required this.status,
    required this.isActive,
    required this.isFirstLogin,
    required this.emailVerified,
    required this.phoneVerified,
    this.createdAt,
  });

  factory BranchManager.fromJson(Map<String, dynamic> json) =>
      _$BranchManagerFromJson(json);
  Map<String, dynamic> toJson() => _$BranchManagerToJson(this);
}

@JsonSerializable()
class Branch {
  final String id;
  final String name;
  final String? location;
  final String? image;

  Branch({required this.id, required this.name, this.location, this.image});

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
  Map<String, dynamic> toJson() => _$BranchToJson(this);
}

@JsonSerializable()
class StatusModel {
  final CashierStatus value;

  StatusModel({required this.value});

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Cashier {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? image;
  final StatusModel? status;

  final Branch branch;

  @JsonKey(name: 'number_of_shifts_per_day')
  final int? shiftsCount;
  @JsonKey(name: 'status_label')
  final String? statusLabel;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  Cashier({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.branch,
    this.createdAt,
    this.statusLabel,
    this.image,
    this.status,
    this.shiftsCount,
  });

  factory Cashier.fromJson(Map<String, dynamic> json) =>
      _$CashierFromJson(json);

  Map<String, dynamic> toJson() => _$CashierToJson(this);
}
