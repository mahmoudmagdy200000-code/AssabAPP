import '../../domain/entities/brand_owner_branch_entity.dart';

class BrandOwnerBranchModel extends BrandOwnerBranchEntity {
  const BrandOwnerBranchModel({required super.id, required super.name});

  factory BrandOwnerBranchModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerBranchModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class BrandOwnerBranchesResponseModel {
  final List<BrandOwnerBranchModel> branches;

  const BrandOwnerBranchesResponseModel({required this.branches});

  factory BrandOwnerBranchesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    final branches = (data?['branches'] as List<dynamic>? ?? []);

    return BrandOwnerBranchesResponseModel(
      branches: branches.map((e) => BrandOwnerBranchModel.fromJson(e)).toList(),
    );
  }

  List<BrandOwnerBranchEntity> toEntity() => branches;
}
