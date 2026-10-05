import 'package:injectable/injectable.dart';

import '../../../../../core/enums/purchasing_officer_quality_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'purchasing_officer_select_quality_state.dart';

@injectable
class PurchasingOfficerSelectQualityCubit
    extends SafeCubit<PurchasingOfficerSelectQualityState> {
  PurchasingOfficerSelectQualityCubit()
    : super(const PurchasingOfficerSelectQualityState());

  void selectQuality(PurchasingOfficerQualityEnum quality) {
    emit(state.copyWith(selectedQuality: quality));
  }
}
