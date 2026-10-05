part of 'get_responsibility_details_cubit.dart';

@immutable
sealed class GetResponsibilityDetailsState {}

final class GetResponsibilityDetailsInitial
    extends GetResponsibilityDetailsState {}

final class GetResponsibilityDetailsLoading
    extends GetResponsibilityDetailsState {}

final class GetResponsibilityDetailsFailure
    extends GetResponsibilityDetailsState {
  final ApiFailure failure;

  GetResponsibilityDetailsFailure(this.failure);
}

final class GetResponsibilityDetailsSuccess
    extends GetResponsibilityDetailsState {
  final ResponsibilityDetailsEntity responsibilityDetails;

  GetResponsibilityDetailsSuccess(this.responsibilityDetails);
}
