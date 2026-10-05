import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custody_recipients_response.dart';

sealed class GetCustodyRecipientsState extends Equatable {
  const GetCustodyRecipientsState();

  @override
  List<Object> get props => [];
}

final class GetCustodyRecipientsInit extends GetCustodyRecipientsState {
  const GetCustodyRecipientsInit();
}

final class GetCustodyRecipientsLoading extends GetCustodyRecipientsState {
  const GetCustodyRecipientsLoading();
}

final class GetCustodyRecipientsSuccess extends GetCustodyRecipientsState {
  final CustodyRecipientsResponse response;

  const GetCustodyRecipientsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetCustodyRecipientsFailure extends GetCustodyRecipientsState {
  final ApiFailure failure;

  const GetCustodyRecipientsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
