import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/working_shift_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../data/model/cashier_model.dart';

class CashierEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final BranchEntity branch;
  final CashierStatus status;
  final int shiftsCount;
  final ShiftCashierEntity? nextCashier;
  final List<WorkingShiftEntity>? workingShifts;
  final String? createdByName;
  final String? createdAt;

  const CashierEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.branch,
    required this.status,
    required this.shiftsCount,
    this.nextCashier,
    this.workingShifts,
    this.createdByName,
    this.createdAt,
  });

  String? get formattedCreatedAt {
    if (createdAt == null) return null;
    try {
      final date = DateTime.parse(createdAt!);
      return DateFormat('dd/MMM/yyyy - hh:mm a').format(date);
    } catch (_) {
      return createdAt;
    }
  }

  CashierEntity copyWith({
    String? name,
    String? email,
    CashierStatus? status,
    BranchEntity? branch,
    List<WorkingShiftEntity>? workingShifts,
  }) {
    return CashierEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone,
      image: image,
      branch: branch ?? this.branch,
      status: status ?? this.status,
      shiftsCount: shiftsCount,
      workingShifts: workingShifts ?? this.workingShifts,
      createdByName: createdByName,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [name, email, status, branch, workingShifts];
}

// branch_entity.dart
class BranchEntity {
  final String? id;
  final String name;
  final String? location;
  final String? image;
  final String? openingHours;
  final String? mapCoordinates;
  final String? createdAt;
  final String? updatedAt;

  BranchEntity({
    this.id,
    required this.name,
    this.location,
    this.image,
    this.openingHours,
    this.mapCoordinates,
    this.createdAt,
    this.updatedAt,
  });
}

class CreatedByEntity {
  final String id;
  final String name;

  CreatedByEntity({required this.id, required this.name});
}
