import 'package:injectable/injectable.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../../../../core/helpers/variance_strategy.dart';
import 'choose_variance_reason_state.dart';

@injectable
class ChooseVarianceReasonCubit extends SafeCubit<ChooseVarianceReasonState> {
  ChooseVarianceReasonCubit() : super(const ChooseVarianceReasonState());

  void setVarianceStrategy(VarianceStrategy varianceStrategy) {
    emit(state.copyWith(varianceStrategy: varianceStrategy));
  }
}
