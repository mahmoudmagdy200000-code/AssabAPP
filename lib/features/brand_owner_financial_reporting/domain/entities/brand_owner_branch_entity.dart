import 'package:equatable/equatable.dart';

class BrandOwnerBranchEntity extends Equatable {
  final String id;
  final String name;

  const BrandOwnerBranchEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
