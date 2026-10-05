import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/mapper/shift/aggregator_mapper.dart';
import '../../../data/model/shift/aggregators_response_model.dart';
import '../../../domain/entity/shift/aggregator_entites.dart';

part 'aggregator_state.dart';

@injectable
class AggregatorCubit extends SafeCubit<AggregatorState> {
  final ShiftManagementRepositoryImp _repository;
  late final Paginator<AggregatorModel, AggregatorsResponseModel> paginator;

  AggregatorCubit(this._repository) : super(AggregatorInitial()) {
    paginator = Paginator<AggregatorModel, AggregatorsResponseModel>(
      fetchPage: (page) async {
        return _repository.getAggregators(page: page);
      },
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }
  final List<AggregatorEntity> _addedAggregators = [];

  List<AggregatorEntity> get addedAggregators => _addedAggregators;

  void addAggregator(AggregatorEntity aggregator) {
    _addedAggregators.add(aggregator);
    emit(AggregatorAddedSuccess(_addedAggregators));
  }

  final List<AggregatorEntity> _aggregators = [];

  Future getAggregators({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      _aggregators.clear();
      emit(AggregatorLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(AggregatorFailure(f)),
      success: (items) {
        if (items.isNotEmpty) {
          _aggregators.addAll(items.map((e) => e.toEntity()));

          emit(AggregatorLoadedSuccess(List.unmodifiable(_aggregators)));
        } else {
          emit(AggregatorEmpty());
        }
      },
    );
  }

  bool isAggregatorAdded(String id) {
    return addedAggregators.any((a) => a.id == id);
  }

  bool get hasMore => paginator.hasMore;
}
