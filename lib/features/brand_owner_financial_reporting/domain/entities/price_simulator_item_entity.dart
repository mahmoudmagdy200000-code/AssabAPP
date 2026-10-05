import 'package:equatable/equatable.dart';

class PriceSimulatorItemEntity extends Equatable {
  final String id;
  final String name;

  const PriceSimulatorItemEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
