import 'package:assab/features/fixed_assets/data/models/fixed_assets_search_response.dart';

class FixedAssetsAllAssetsResponse {
  final List<FixedAssetsSearchItem> assets;

  FixedAssetsAllAssetsResponse({required this.assets});

  factory FixedAssetsAllAssetsResponse.fromJson(Map<String, dynamic> json) {
    final assetsJson = json['data']['data'] as List<dynamic>;
    final assets = assetsJson
        .map(
          (branchJson) => FixedAssetsSearchItem.fromJson(
            branchJson as Map<String, dynamic>,
          ),
        )
        .toList();

    return FixedAssetsAllAssetsResponse(assets: assets);
  }
}

// class FixedAssetsAssetItem {
//   final String id;
//   final String name;
//   final String code;
//   final String image;
//   final FixedAssetsSearchLocation location;
//   final FixedAssetsConditionStrategy status;

//   FixedAssetsAssetItem({
//     required this.id,
//     required this.name,
//     required this.code,
//     required this.image,
//     required this.location,
//     required this.status,
//   });

//   factory FixedAssetsAssetItem.fromJson(Map<String, dynamic> json) {
//     return FixedAssetsAssetItem(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       code: json['code'] as String,
//       image: json['image'] as String,
//       location: FixedAssetsSearchLocation.fromJson(
//         json['zone'] as Map<String, dynamic>,
//       ),
//       status: FixedAssetsConditionStrategy.fromCondition(
//         json['status'] as String,
//       ),
//     );
//   }
// }
