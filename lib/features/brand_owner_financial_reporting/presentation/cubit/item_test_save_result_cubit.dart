import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/entities/item_test_result_entity.dart';
import '../../domain/usecases/save_item_test_usecase.dart';
import 'item_test_save_result_state.dart';

@injectable
class ItemTestSaveResultCubit extends SafeCubit<ItemTestSaveResultState> {
  final SaveItemTestUseCase _useCase;

  ItemTestSaveResultCubit(this._useCase)
    : super(const ItemTestSaveResultInit());

  Future<void> saveResult(ItemTestResultEntity result) async {
    emit(const ItemTestSaveResultLoading());

    final resultData = await _useCase(result);

    handle(
      resultData,
      success: (_) => emit(const ItemTestSaveResultSuccess()),
      failure: (failure) => emit(ItemTestSaveResultFailure(failure)),
    );
  }
}
