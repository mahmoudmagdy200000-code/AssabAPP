import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/brand_owner_home_data_model.dart';

sealed class BrandOwnerHomeState extends Equatable {
  const BrandOwnerHomeState();

  @override
  List<Object?> get props => [];
}

final class BrandOwnerHomeInitial extends BrandOwnerHomeState {
  const BrandOwnerHomeInitial();
}

final class BrandOwnerHomeLoading extends BrandOwnerHomeState {
  const BrandOwnerHomeLoading();
}

final class BrandOwnerHomeSuccess extends BrandOwnerHomeState {
  final BrandOwnerHomeDataModel data;

  const BrandOwnerHomeSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class BrandOwnerHomeFailure extends BrandOwnerHomeState {
  final ApiFailure failure;

  const BrandOwnerHomeFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
