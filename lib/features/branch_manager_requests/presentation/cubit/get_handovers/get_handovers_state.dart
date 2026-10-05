import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/handovers_response.dart';

sealed class GetHandoversState extends Equatable {
  const GetHandoversState();

  @override
  List<Object> get props => [];
}

final class GetHandoversInit extends GetHandoversState {
  const GetHandoversInit();
}

final class GetHandoversLoading extends GetHandoversState {
  const GetHandoversLoading();
}

final class GetHandoversSuccess extends GetHandoversState {
  final List<HandoversResponseItem> handovers;

  const GetHandoversSuccess(this.handovers);

  @override
  List<Object> get props => [handovers];
}

final class GetHandoversFailure extends GetHandoversState {
  final ApiFailure failure;

  const GetHandoversFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
