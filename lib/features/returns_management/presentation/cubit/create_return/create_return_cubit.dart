import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/create_return_request.dart';
import '../../../data/repository/return_management_repository.dart';
import 'create_return_state.dart';

@injectable
class CreateReturnCubit extends SafeCubit<CreateReturnState> {
  final ReturnManagementRepository _returnManagementRepository;

  CreateReturnCubit(this._returnManagementRepository)
    : super(const CreateReturnInit());

  Future<void> createReturnRequest({required CreateReturnRequest body}) async {
    emit(const CreateReturnLoading());

    final result = await _returnManagementRepository.createReturnRequest(
      body: body,
    );

    handle(
      result,
      success: (_) => emit(const CreateReturnSuccess()),
      failure: (failure) => emit(CreateReturnFailure(failure)),
    );
  }
}
