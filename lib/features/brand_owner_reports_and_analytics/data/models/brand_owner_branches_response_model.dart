class BrandOwnerBranchResponseModel {
  final String id;
  final String name;
  final String managerName;

  const BrandOwnerBranchResponseModel({
    required this.id,
    required this.name,
    required this.managerName,
  });

  factory BrandOwnerBranchResponseModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerBranchResponseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      managerName: json['managerName']?.toString() ?? '',
    );
  }
}

class BrandOwnerBranchesResponseModel {
  final List<BrandOwnerBranchResponseModel> branches;

  const BrandOwnerBranchesResponseModel({required this.branches});

  factory BrandOwnerBranchesResponseModel.fromJson(Map<String, dynamic> json) {
    final branchesJson = json['branches'] as List<dynamic>? ?? [];

    return BrandOwnerBranchesResponseModel(
      branches: branchesJson
          .map(
            (item) => BrandOwnerBranchResponseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
