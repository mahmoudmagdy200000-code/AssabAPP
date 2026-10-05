import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/purchase_repository.dart';
import 'delete_order_draft_state.dart';

@injectable
class DeleteOrderDraftCubit extends SafeCubit<DeleteOrderDraftState> {
  final PurchaseRepository _purchaseRepository;

  DeleteOrderDraftCubit(this._purchaseRepository)
    : super(const DeleteOrderDraftInit());

  Future<void> deleteDraft({required String id}) async {
    emit(const DeleteOrderDraftLoading());

    final result = await _purchaseRepository.deleteOrderDraft(id: id);

    handle(
      result,
      success: (response) => emit(const DeleteOrderDraftSuccess()),
      failure: (failure) => emit(DeleteOrderDraftFailure(failure)),
    );
  }
}
