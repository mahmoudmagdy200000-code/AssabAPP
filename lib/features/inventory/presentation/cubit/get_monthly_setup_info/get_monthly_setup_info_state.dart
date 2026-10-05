import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/monthly_setup_info_response.dart';

sealed class GetMonthlySetupInfoState extends Equatable {
  const GetMonthlySetupInfoState();

  @override
  List<Object> get props => [];
}

final class GetMonthlySetupInfoInit extends GetMonthlySetupInfoState {
  const GetMonthlySetupInfoInit();
}

final class GetMonthlySetupInfoLoading extends GetMonthlySetupInfoState {
  const GetMonthlySetupInfoLoading();
}

final class GetMonthlySetupInfoSuccess extends GetMonthlySetupInfoState {
  final MonthlySetupInfoData data;

  const GetMonthlySetupInfoSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetMonthlySetupInfoFailure extends GetMonthlySetupInfoState {
  final ApiFailure failure;

  const GetMonthlySetupInfoFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
