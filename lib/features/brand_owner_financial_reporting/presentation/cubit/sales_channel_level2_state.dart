import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/sales_channel_level2_entity.dart';

sealed class SalesChannelLevel2State extends Equatable {
  const SalesChannelLevel2State();

  @override
  List<Object> get props => [];
}

final class SalesChannelLevel2Initial extends SalesChannelLevel2State {
  const SalesChannelLevel2Initial();
}

final class SalesChannelLevel2Loading extends SalesChannelLevel2State {
  const SalesChannelLevel2Loading();
}

final class SalesChannelLevel2Success extends SalesChannelLevel2State {
  final SalesChannelLevel2Entity data;
  final String? branchId;

  const SalesChannelLevel2Success({
    required this.data,
    this.branchId,
  });

  @override
  List<Object> get props => [data, branchId ?? ''];
}

final class SalesChannelLevel2Failure extends SalesChannelLevel2State {
  final ApiFailure failure;

  const SalesChannelLevel2Failure(this.failure);

  @override
  List<Object> get props => [failure];
}
