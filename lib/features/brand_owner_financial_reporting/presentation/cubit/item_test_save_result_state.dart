import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ItemTestSaveResultState extends Equatable {
  const ItemTestSaveResultState();

  @override
  List<Object> get props => [];
}

final class ItemTestSaveResultInit extends ItemTestSaveResultState {
  const ItemTestSaveResultInit();
}

final class ItemTestSaveResultLoading extends ItemTestSaveResultState {
  const ItemTestSaveResultLoading();
}

final class ItemTestSaveResultSuccess extends ItemTestSaveResultState {
  const ItemTestSaveResultSuccess();
}

final class ItemTestSaveResultFailure extends ItemTestSaveResultState {
  final ApiFailure failure;

  const ItemTestSaveResultFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
