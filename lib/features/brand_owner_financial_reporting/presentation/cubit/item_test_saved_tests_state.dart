import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/item_test_saved_test_entity.dart';

sealed class ItemTestSavedTestsState extends Equatable {
  const ItemTestSavedTestsState();

  @override
  List<Object> get props => [];
}

final class ItemTestSavedTestsInit extends ItemTestSavedTestsState {
  const ItemTestSavedTestsInit();
}

final class ItemTestSavedTestsLoading extends ItemTestSavedTestsState {
  const ItemTestSavedTestsLoading();
}

final class ItemTestSavedTestsSuccess extends ItemTestSavedTestsState {
  final List<ItemTestSavedTestEntity> tests;
  final List<ItemTestSavedTestEntity> filteredTests;
  final String searchQuery;

  const ItemTestSavedTestsSuccess({
    required this.tests,
    required this.filteredTests,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [tests, filteredTests, searchQuery];
}

final class ItemTestSavedTestsFailure extends ItemTestSavedTestsState {
  final ApiFailure failure;

  const ItemTestSavedTestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
