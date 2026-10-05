// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_cashiers_and_managers_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCashiersAndManagersResponse _$GetAllCashiersAndManagersResponseFromJson(
  Map<String, dynamic> json,
) => GetAllCashiersAndManagersResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CashiersData.fromJson(json['data'] as Map<String, dynamic>),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetAllCashiersAndManagersResponseToJson(
  GetAllCashiersAndManagersResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
  'meta': instance.meta.toJson(),
};

CashiersData _$CashiersDataFromJson(Map<String, dynamic> json) => CashiersData(
  branchManagers: (json['branch_managers'] as List<dynamic>)
      .map((e) => BranchManager.fromJson(e as Map<String, dynamic>))
      .toList(),
  cashiers: (json['cashiers'] as List<dynamic>)
      .map((e) => Cashier.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashiersDataToJson(
  CashiersData instance,
) => <String, dynamic>{
  'branch_managers': instance.branchManagers.map((e) => e.toJson()).toList(),
  'cashiers': instance.cashiers.map((e) => e.toJson()).toList(),
};

BranchManager _$BranchManagerFromJson(Map<String, dynamic> json) =>
    BranchManager(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),
      status: StatusModel.fromJson(json['status'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool,
      isFirstLogin: json['is_first_login'] as bool,
      emailVerified: json['email_verified'] as bool,
      phoneVerified: json['phone_verified'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$BranchManagerToJson(BranchManager instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'image': instance.image,
      'branch': instance.branch.toJson(),
      'status': instance.status.toJson(),
      'is_active': instance.isActive,
      'is_first_login': instance.isFirstLogin,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'created_at': instance.createdAt,
    };

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'image': instance.image,
};

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) =>
    StatusModel(value: $enumDecode(_$CashierStatusEnumMap, json['value']));

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{'value': _$CashierStatusEnumMap[instance.value]!};

const _$CashierStatusEnumMap = {
  CashierStatus.active: 'active',
  CashierStatus.pending: 'pending',
  CashierStatus.deactivated: 'deactivated',
};

Cashier _$CashierFromJson(Map<String, dynamic> json) => Cashier(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  statusLabel: json['status_label'] as String?,
  image: json['image'] as String?,
  status: json['status'] == null
      ? null
      : StatusModel.fromJson(json['status'] as Map<String, dynamic>),
  shiftsCount: (json['number_of_shifts_per_day'] as num?)?.toInt(),
);

Map<String, dynamic> _$CashierToJson(Cashier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'image': instance.image,
  'status': instance.status?.toJson(),
  'branch': instance.branch.toJson(),
  'number_of_shifts_per_day': instance.shiftsCount,
  'status_label': instance.statusLabel,
  'created_at': instance.createdAt,
};
