import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CustodyCreateRequestState extends Equatable {
  const CustodyCreateRequestState();

  @override
  List<Object> get props => [];
}

final class CustodyCreateRequestInit extends CustodyCreateRequestState {
  const CustodyCreateRequestInit();
}

final class CustodyCreateRequestLoading extends CustodyCreateRequestState {
  const CustodyCreateRequestLoading();
}

final class CustodyCreateRequestSuccess extends CustodyCreateRequestState {
  const CustodyCreateRequestSuccess();
}

final class CustodyCreateRequestFailure extends CustodyCreateRequestState {
  final ApiFailure failure;

  const CustodyCreateRequestFailure(this.failure);
}

final class CustodyCreateReusePastRequestFailure
    extends CustodyCreateRequestState {
  final ApiFailure failure;

  const CustodyCreateReusePastRequestFailure(this.failure);
}
