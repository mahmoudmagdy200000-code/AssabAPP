import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/variances_response.dart';

sealed class GetVariancesState extends Equatable {
  const GetVariancesState();

  @override
  List<Object> get props => [];
}

final class GetVariancesInit extends GetVariancesState {
  const GetVariancesInit();
}

final class GetVariancesLoading extends GetVariancesState {
  const GetVariancesLoading();
}

final class GetVariancesSuccess extends GetVariancesState {
  final List<VarianceItem> variances;

  const GetVariancesSuccess(this.variances);

  @override
  List<Object> get props => [variances];
}

final class GetVariancesFailure extends GetVariancesState {
  final ApiFailure failure;

  const GetVariancesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
