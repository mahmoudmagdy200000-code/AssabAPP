import 'package:injectable/injectable.dart';

import '../../../../../core/enums/select_branch_manager_delivery_time_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_branch_manager_delivery_time_state.dart';

@injectable
class SelectBranchManagerDeliveryTimeCubit
    extends SafeCubit<SelectBranchManagerDeliveryTimeState> {
  SelectBranchManagerDeliveryTimeCubit()
    : super(const SelectBranchManagerDeliveryTimeState());

  void selectDeliveryTime(SelectBranchManagerDeliveryTimeEnum deliveryTime) {
    emit(state.copyWith(selectedDeliveryTime: deliveryTime));
  }
}
