import 'package:equatable/equatable.dart';

import 'item_test_result_entity.dart';

class ItemTestSavedTestEntity extends Equatable {
  final String id;
  final String itemName;
  final String branchName;
  final String dateTime;
  final ItemTestResultEntity details;

  const ItemTestSavedTestEntity({
    required this.id,
    required this.itemName,
    required this.branchName,
    required this.dateTime,
    required this.details,
  });

  @override
  List<Object> get props => [id, itemName, branchName, dateTime, details];
}
