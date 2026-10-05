class FixedAssetsBranchesResponse {
  final List<FixedAssetsBranchItem> branches;

  FixedAssetsBranchesResponse({required this.branches});

  factory FixedAssetsBranchesResponse.fromJson(Map<String, dynamic> json) {
    final branchesJson = json['data']['data'] as List<dynamic>;
    final branches = branchesJson
        .map(
          (branchJson) => FixedAssetsBranchItem.fromJson(
            branchJson as Map<String, dynamic>,
          ),
        )
        .toList();

    return FixedAssetsBranchesResponse(branches: branches);
  }
}

class FixedAssetsBranchItem {
  final String id;
  final String name;
  final String image;

  FixedAssetsBranchItem({
    required this.id,
    required this.name,
    required this.image,
  });

  factory FixedAssetsBranchItem.fromJson(Map<String, dynamic> json) {
    return FixedAssetsBranchItem(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
