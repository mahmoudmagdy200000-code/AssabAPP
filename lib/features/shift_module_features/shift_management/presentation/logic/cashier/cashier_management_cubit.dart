import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/errors/api_failure.dart';
import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/mapper/cashier_mapper.dart';
import '../../../data/model/cashier_model.dart';
import '../../../data/model/cashiers_response_model.dart';
import '../../../data/repository/shift_management_repository_imp.dart';
import '../../../domain/entity/cashier_entity.dart';

part 'cashier_management_state.dart';

@injectable
class CashierManagementCubit extends SafeCubit<CashierManagementState> {
  final ShiftManagementRepositoryImp _repository;

  late final Paginator<CashierModel, CashiersResponseModel> paginator;

  String? dateOption;
  String? status;
  String? search;

  CashierManagementCubit(this._repository) : super(CashierManagementInitial()) {
    paginator = Paginator<CashierModel, CashiersResponseModel>(
      fetchPage: (page) async {
        return _repository.getCashiers(
          dateOption: dateOption,
          status: status,
          search: search,
          page: page,
        );
      },
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }

  Future<void> getCashiers({
    String? dateOption,
    String? status,
    String? search,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      paginator.reset();
      emit(CashierManagementLoading());
    }

    this.dateOption = dateOption;
    this.status = status;
    this.search = search;

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) {
        emit(CashierManagementFailure(failure));
      },
      success: (items) {
        if (items.isNotEmpty) {
          emit(
            CashierManagementSuccess(items.map((e) => e.toEntity()).toList()),
          );
        } else {
          emit(CashierManagementEmpty(fromFilter: hasFilters));
        }
      },
    );
  }

  bool get hasFilters => dateOption != null || status != null || search != null;

  bool get hasMore => paginator.hasMore;
}
