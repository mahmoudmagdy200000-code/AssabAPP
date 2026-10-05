import 'package:equatable/equatable.dart';

sealed class AddItemState extends Equatable {
  const AddItemState();

  Map<String, List<String>> get lists => const {};

  @override
  List<Object> get props => [lists];
}

final class AddItemLoaded extends AddItemState {
  @override
  final Map<String, List<String>> lists;

  const AddItemLoaded(this.lists);

  @override
  List<Object> get props => [lists];
}
