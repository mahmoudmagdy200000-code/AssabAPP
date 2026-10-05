import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/handover_user_item.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/helpers/paginator.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/cashier_model.dart';
import '../../../../data/model/get_all_cashiers_and_managers_response_model.dart';

part 'handover_state.dart';

@injectable
class HandoverCubit extends SafeCubit<HandoverState> {
  final ShiftManagementRepositoryImp _repository;
  final String shiftId;
  HandoverUserItem? selectedCashier;

  late final Paginator<HandoverUserItem, GetAllCashiersAndManagersResponse>
  paginator;

  HandoverCubit(this._repository, @factoryParam this.shiftId)
    : super(HandoverInitial()) {
    paginator = Paginator<HandoverUserItem, GetAllCashiersAndManagersResponse>(
      fetchPage: (page) async {
        return _repository.getAllCashiersAndManagers(page: page);
      },
      extractData: (response) {
        final managers = response.data.branchManagers.map(
          (m) => HandoverUserItem(
            id: m.id,
            name: m.name,
            image: m.image,
            status: m.status.value ?? CashierStatus.deactivated,
            branchName: m.branch.name,
            isManager: true,
          ),
        );

        final cashiers = response.data.cashiers.map(
          (c) => HandoverUserItem(
            id: c.id,
            name: c.name,
            image: c.image,
            status: c.status?.value ?? CashierStatus.deactivated,
            branchName: c.branch.name ?? 'N/A',
            isManager: false,
          ),
        );

        return [...managers, ...cashiers];
      },
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  Future<void> initFetch() async {
    paginator.reset();
    emit(HandoverCashiersFetchingLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(HandoverCashiersFetchingFailure(failure: f)),
      success: (usersList) {
        if (usersList.isNotEmpty) {
          emit(HandoverCashiersFetchingSuccess(usersList: usersList));
        } else {
          emit(HandoverCashiersFetchingEmpty());
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (!paginator.hasMore) return;

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(HandoverCashiersFetchingFailure(failure: f)),
      success: (moreUsers) {
        final currentUsers = state is HandoverCashiersFetchingSuccess
            ? (state as HandoverCashiersFetchingSuccess).usersList
            : [];

        emit(
          HandoverCashiersFetchingSuccess(
            usersList: [...currentUsers, ...moreUsers],
          ),
        );
      },
    );
  }

  Future<void> handOver({required double handOverAmount, String? note}) async {
    emit(RecordingHandoverLoading());

    final result = await _repository.handOver(
      isManager: selectedCashier!.isManager,
      shiftId: shiftId,
      cashierId: selectedCashier!.id,
      handOverAmount: handOverAmount,
      note: note,
    );

    handle(
      result,
      failure: (f) => emit(RecordingHandoverFailure(failure: f)),
      success: (success) => emit(RecordingHandoverSuccess()),
    );
  }
}
