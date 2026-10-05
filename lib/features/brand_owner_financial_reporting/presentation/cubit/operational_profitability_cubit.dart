import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_operational_profitability_usecase.dart';
import 'operational_profitability_state.dart';

@injectable
class OperationalProfitabilityCubit
    extends SafeCubit<OperationalProfitabilityState> {
  final GetOperationalProfitabilityUseCase _getUseCase;

  OperationalProfitabilityCubit(this._getUseCase)
    : super(const OperationalProfitabilityInitial());

  Future<void> loadOperationalProfitability() async {
    emit(const OperationalProfitabilityLoading());
    final result = await _getUseCase();
    handle(
      result,
      success: (data) {
        emit(OperationalProfitabilitySuccess(data: data));
      },
      failure: (failure) =>
          emit(OperationalProfitabilityFailure(failure)),
    );
  }
}
