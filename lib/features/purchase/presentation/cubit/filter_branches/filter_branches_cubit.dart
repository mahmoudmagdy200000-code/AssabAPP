import 'package:assab/core/enums/purchase_response_time_enum.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/purchase_branch_availability_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'filter_branches_state.dart';

@injectable
class FilterBranchesCubit extends SafeCubit<FilterBranchesState> {
  FilterBranchesCubit() : super(const FilterBranchesState());

  void setAvailability(PurchaseBranchAvailabilityEnum availability) {
    emit(state.copyWith(availability: availability));
  }

  void setResponseTime(PurchaseResponseTimeEnum responseTime) {
    emit(state.copyWith(responseTime: responseTime));
  }

  void setDistance(double distance) {
    if (distance < 5) {
      distance = 5;
    }

    emit(state.copyWith(distance: distance));
  }

  void resetFilters() {
    emit(const FilterBranchesState());
  }
}
