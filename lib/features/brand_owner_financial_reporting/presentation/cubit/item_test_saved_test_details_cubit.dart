import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/email_item_test_usecase.dart';
import '../../domain/usecases/export_item_test_usecase.dart';
import 'item_test_saved_test_details_state.dart';

@injectable
class ItemTestSavedTestDetailsCubit
    extends SafeCubit<ItemTestSavedTestDetailsState> {
  final ExportItemTestUseCase _exportUseCase;
  final EmailItemTestUseCase _emailUseCase;

  ItemTestSavedTestDetailsCubit(
    this._exportUseCase,
    this._emailUseCase,
  ) : super(const ItemTestSavedTestDetailsInit());

  Future<void> exportPdf({required String testId}) async {
    emit(const ItemTestSavedTestDetailsExporting());

    final result = await _exportUseCase(
      testId: testId,
      formatType: 'pdf',
    );

    handle(
      result,
      success: (url) => emit(ItemTestSavedTestDetailsExportSuccess(url)),
      failure: (failure) =>
          emit(ItemTestSavedTestDetailsExportFailure(failure)),
    );
  }

  Future<void> exportExcel({required String testId}) async {
    emit(const ItemTestSavedTestDetailsExporting());

    final result = await _exportUseCase(
      testId: testId,
      formatType: 'excel',
    );

    handle(
      result,
      success: (url) => emit(ItemTestSavedTestDetailsExportSuccess(url)),
      failure: (failure) =>
          emit(ItemTestSavedTestDetailsExportFailure(failure)),
    );
  }

  Future<void> sendEmail({
    required String testId,
    required String email,
  }) async {
    emit(const ItemTestSavedTestDetailsEmailing());

    final result = await _emailUseCase(testId: testId, email: email);

    handle(
      result,
      success: (_) => emit(const ItemTestSavedTestDetailsEmailSuccess()),
      failure: (failure) =>
          emit(ItemTestSavedTestDetailsEmailFailure(failure)),
    );
  }

  void reset() {
    emit(const ItemTestSavedTestDetailsInit());
  }
}
