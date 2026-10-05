import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'suppliers_state.dart';

@injectable
class SuppliersCubit extends SafeCubit<SuppliersState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  SuppliersCubit(this._branchManagerExpensesRepository)
    : super(const SuppliersInitial());

  Future<void> getSuppliers() async {
    emit(const SuppliersLoading());
    final result = await _branchManagerExpensesRepository.getSuppliers();

    handle(
      result,
      failure: (failure) => emit(SuppliersFailure(failure)),
      success: (suppliers) => emit(SuppliersSuccess(suppliers)),
    );
  }

  void selectSupplier(String supplierId, String supplierName) {
    emit(SelectSupplier(supplierId, supplierName));
  }
}
