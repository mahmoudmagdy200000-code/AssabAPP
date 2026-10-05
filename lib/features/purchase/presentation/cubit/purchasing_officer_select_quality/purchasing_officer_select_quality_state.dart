import 'package:equatable/equatable.dart';

import '../../../../../core/enums/purchasing_officer_quality_enum.dart';

class PurchasingOfficerSelectQualityState extends Equatable {
  final PurchasingOfficerQualityEnum selectedQuality;

  const PurchasingOfficerSelectQualityState({
    this.selectedQuality = PurchasingOfficerQualityEnum.non,
  });

  PurchasingOfficerSelectQualityState copyWith({
    PurchasingOfficerQualityEnum? selectedQuality,
  }) {
    return PurchasingOfficerSelectQualityState(
      selectedQuality: selectedQuality ?? this.selectedQuality,
    );
  }

  @override
  List<Object> get props => [selectedQuality];
}
