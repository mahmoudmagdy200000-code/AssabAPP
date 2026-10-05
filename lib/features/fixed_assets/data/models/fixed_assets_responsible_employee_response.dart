class FixedAssetsResponsibleEmployeeResponse {
  final List<FixedAssetsResponsibleEmployeeData> data;

  FixedAssetsResponsibleEmployeeResponse({required this.data});

  factory FixedAssetsResponsibleEmployeeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsResponsibleEmployeeResponse(
      data: (json['data']['data'] as List<dynamic>)
          .map(
            (item) => FixedAssetsResponsibleEmployeeData.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class FixedAssetsResponsibleEmployeeData {
  final String id;
  final String name;
  final String image;

  FixedAssetsResponsibleEmployeeData({
    required this.id,
    required this.name,
    required this.image,
  });

  factory FixedAssetsResponsibleEmployeeData.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsResponsibleEmployeeData(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
