import 'package:assab/core/enums/purchase_response_time_enum.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/enums/purchase_supplier_availability_enum.dart';

class FilterSuppliersState extends Equatable {
  final PurchaseSupplierAvailabilityEnum availability;
  final double distance;

  const FilterSuppliersState({
    this.availability = PurchaseSupplierAvailabilityEnum.non,
    this.distance = 5,
  });

  FilterSuppliersState copyWith({
    PurchaseSupplierAvailabilityEnum? availability,
    PurchaseResponseTimeEnum? responseTime,
    double? distance,
  }) {
    return FilterSuppliersState(
      availability: availability ?? this.availability,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object> get props => [availability, distance];
}
