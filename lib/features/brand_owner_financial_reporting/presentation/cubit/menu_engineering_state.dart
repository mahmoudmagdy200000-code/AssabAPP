import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_menu_engineering_entity.dart';

sealed class MenuEngineeringState extends Equatable {
  const MenuEngineeringState();

  @override
  List<Object> get props => [];
}

final class MenuEngineeringInitial extends MenuEngineeringState {
  const MenuEngineeringInitial();
}

final class MenuEngineeringLoading extends MenuEngineeringState {
  const MenuEngineeringLoading();
}

final class MenuEngineeringSuccess extends MenuEngineeringState {
  final MenuEngineeringEntity data;

  const MenuEngineeringSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class MenuEngineeringFailure extends MenuEngineeringState {
  final ApiFailure failure;

  const MenuEngineeringFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
