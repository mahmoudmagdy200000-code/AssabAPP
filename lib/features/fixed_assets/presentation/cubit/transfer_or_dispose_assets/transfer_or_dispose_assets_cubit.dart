import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_transfer_and_dispose_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'transfer_or_dispose_assets_state.dart';

@injectable
class TransferOrDisposeAssetsCubit
    extends SafeCubit<TransferOrDisposeAssetsState> {
  final FixedAssetsRepository _repository;

  TransferOrDisposeAssetsCubit(this._repository)
    : super(const TransferOrDisposeAssetsInit());

  Future<void> transferOrDisposeAssets({
    required FixedAssetsTransferAndDisposeRequest request,
  }) async {
    emit(const TransferOrDisposeAssetsLoading());

    final result = await _repository.transferOrDisposeAssets(request: request);

    handle(
      result,
      success: (_) => emit(const TransferOrDisposeAssetsSuccess()),
      failure: (failure) => emit(TransferOrDisposeAssetsFailure(failure)),
    );
  }
}
