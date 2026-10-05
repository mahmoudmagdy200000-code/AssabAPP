import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_list_request_models/cashiers_filter_attributes_model.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/date_filter.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../ui/filters/cashier_filter/cashier_status_filter.dart';

part 'cashier_filter_state.dart';

@injectable
class CashierFilterCubit extends SafeCubit<CashierFilterState> {
  CashierFilterCubit() : super(CashierFilterState.initial());

  void updateDateFilter(DateFilterOption value) {
    emit(state.copyWith(dateFilter: value));
  }

  void updateStatusFilter(CashierStatusFilter value) {
    emit(state.copyWith(statusFilter: value));
  }

  void resetFilters() {
    emit(CashierFilterState.initial());
  }

  bool get hasActiveFilters {
    return state.dateFilter != null || state.statusFilter != null;
  }

  CashiersFilterAttributesModel toModel() {
    return CashiersFilterAttributesModel(
      status: state.statusFilter?.apiValue,
      dateFilter: state.dateFilter?.dateOption,
    );
  }
}
