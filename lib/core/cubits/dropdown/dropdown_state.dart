import 'package:equatable/equatable.dart';

class DropdownState<T> extends Equatable {
  final bool isOpen;
  final T? value;

  const DropdownState({this.isOpen = false, this.value});

  DropdownState<T> copyWith({bool? isOpen, T? value}) {
    return DropdownState<T>(
      isOpen: isOpen ?? this.isOpen,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [isOpen, value];
}
