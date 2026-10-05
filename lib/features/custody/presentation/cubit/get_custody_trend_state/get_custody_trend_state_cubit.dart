import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_custody_trend_state_state.dart';

@injectable
class GetCustodyTrendStateCubit extends SafeCubit<GetCustodyTrendStateState> {
  final CustodyRepository _custodyRepository;

  GetCustodyTrendStateCubit(this._custodyRepository)
    : super(const GetCustodyTrendStateInit());

  Future<void> getTrendBalanceState({
    String? month,
    String? year,
    String? custodyType,
    String? granularity,
  }) async {
    emit(const GetCustodyTrendStateLoading());

    final result = await _custodyRepository.getTrendBalanceState(
      month: month,
      year: year,
      custodyType: custodyType,
      granularity: granularity,
    );

    handle(
      result,
      success: (response) => emit(GetCustodyTrendStateSuccess(response)),
      failure: (failure) => emit(GetCustodyTrendStateFailure(failure)),
    );
  }
}
