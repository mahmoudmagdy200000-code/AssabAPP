import 'package:injectable/injectable.dart';

import '../../../../../core/enums/purchasing_officer_processing_time_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'purchasing_officer_select_processing_time_state.dart';

@injectable
class PurchasingOfficerSelectProcessingTimeCubit
    extends SafeCubit<PurchasingOfficerSelectProcessingTimeState> {
  PurchasingOfficerSelectProcessingTimeCubit()
    : super(const PurchasingOfficerSelectProcessingTimeState());

  void selectProcessingTime(
    PurchasingOfficerProcessingTimeEnum processingTime,
  ) {
    emit(state.copyWith(selectedProcessingTime: processingTime));
  }
}
