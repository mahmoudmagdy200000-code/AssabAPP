import 'package:injectable/injectable.dart';

import '../../../../../core/enums/purchase_supplier_availability_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'filter_suppliers_state.dart';

@injectable
class FilterSuppliersCubit extends SafeCubit<FilterSuppliersState> {
  FilterSuppliersCubit() : super(const FilterSuppliersState());

  void setAvailability(PurchaseSupplierAvailabilityEnum availability) {
    emit(state.copyWith(availability: availability));
  }

  void setDistance(double distance) {
    emit(state.copyWith(distance: distance));
  }

  void resetFilters() {
    emit(const FilterSuppliersState());
  }
}
