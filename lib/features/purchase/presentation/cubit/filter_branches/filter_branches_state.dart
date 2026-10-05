import 'package:assab/core/enums/purchase_branch_availability_enum.dart';
import 'package:assab/core/enums/purchase_response_time_enum.dart';
import 'package:equatable/equatable.dart';

class FilterBranchesState extends Equatable {
  final PurchaseBranchAvailabilityEnum availability;
  final PurchaseResponseTimeEnum responseTime;
  final double distance;

  const FilterBranchesState({
    this.availability = PurchaseBranchAvailabilityEnum.non,
    this.responseTime = PurchaseResponseTimeEnum.non,
    this.distance = 5,
  });

  FilterBranchesState copyWith({
    PurchaseBranchAvailabilityEnum? availability,
    PurchaseResponseTimeEnum? responseTime,
    double? distance,
  }) {
    return FilterBranchesState(
      availability: availability ?? this.availability,
      responseTime: responseTime ?? this.responseTime,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object> get props => [availability, responseTime, distance];
}
