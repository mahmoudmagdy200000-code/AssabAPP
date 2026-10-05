import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_search_request.dart';
import '../../../data/models/fixed_assets_search_response.dart';
import '../../../data/repositories/fixed_assets_repository.dart';

part 'fixed_assets_search_state.dart';

@injectable
class FixedAssetsSearchCubit extends SafeCubit<FixedAssetsSearchState> {
  final FixedAssetsRepository _repository;

  FixedAssetsSearchCubit(this._repository) : super(FixedAssetsSearchInitial());

  Future<void> search({required FixedAssetsSearchRequest request}) async {
    emit(FixedAssetsSearchLoading());

    final result = await _repository.searchForAssets(request: request);

    handle(
      result,
      success: (response) => emit(FixedAssetsSearchSuccess(response)),
      failure: (failure) => emit(FixedAssetsSearchFailure(failure)),
    );
  }
}
