import 'package:flutter/material.dart';

import '../../../../../../../core/errors/api_failure.dart';
import '../../../../domain/entity/handover_user_item.dart';

@immutable
abstract class FetchManagerState {}

class FetchManagerInitial extends FetchManagerState {}

class FetchManagerLoading extends FetchManagerState {}

class FetchManagerPaginationLoading extends FetchManagerState {}

class FetchManagerSuccess extends FetchManagerState {
  final List<HandoverUserItem> managers;

  FetchManagerSuccess({required this.managers});
}

class FetchManagerEmpty extends FetchManagerState {}

class FetchManagerFailure extends FetchManagerState {
  final ApiFailure failure;

  FetchManagerFailure({required this.failure});
}
