class FixedAssetsTypesResponse {
  final List<FixedAssetsTypeData> types;

  FixedAssetsTypesResponse({required this.types});

  factory FixedAssetsTypesResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data']['data'] as List;
    List<FixedAssetsTypeData> typesData = dataList
        .map((item) => FixedAssetsTypeData.fromJson(item))
        .toList();

    return FixedAssetsTypesResponse(types: typesData);
  }
}

class FixedAssetsTypeData {
  final String id;
  final String name;

  FixedAssetsTypeData({required this.id, required this.name});

  factory FixedAssetsTypeData.fromJson(Map<String, dynamic> json) {
    return FixedAssetsTypeData(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
