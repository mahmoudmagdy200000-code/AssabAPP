import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/cashier_home_repository.dart';
import 'get_tasks_state.dart';

@injectable
class GetTasksCubit extends SafeCubit<GetTasksState> {
  final CashierHomeRepository _repository;

  GetTasksCubit(this._repository) : super(const GetTasksInit());

  Future<void> getTasks() async {
    emit(const GetTasksLoading());

    final result = await _repository.getInventoryTasks();

    handle(
      result,
      failure: (failure) => emit(GetTasksFailure(failure)),
      success: (response) => emit(GetTasksSuccess(response)),
    );
  }
}
