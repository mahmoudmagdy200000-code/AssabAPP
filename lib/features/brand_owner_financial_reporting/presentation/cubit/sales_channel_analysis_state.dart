import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/sales_channel_analysis_entity.dart';

sealed class SalesChannelAnalysisState extends Equatable {
  const SalesChannelAnalysisState();

  @override
  List<Object> get props => [];
}

final class SalesChannelAnalysisInitial extends SalesChannelAnalysisState {
  const SalesChannelAnalysisInitial();
}

final class SalesChannelAnalysisLoading extends SalesChannelAnalysisState {
  const SalesChannelAnalysisLoading();
}

final class SalesChannelAnalysisSuccess extends SalesChannelAnalysisState {
  final SalesChannelAnalysisEntity data;

  const SalesChannelAnalysisSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class SalesChannelAnalysisFailure extends SalesChannelAnalysisState {
  final ApiFailure failure;

  const SalesChannelAnalysisFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
