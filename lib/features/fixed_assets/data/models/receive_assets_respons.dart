class ReceiveAssetsResponse {
  final List<ReceiveAssetsData> items;

  ReceiveAssetsResponse({required this.items});

  factory ReceiveAssetsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as Map<String, dynamic>? ?? {};
    final items = [ReceiveAssetsData.fromJson(dataList)];

    return ReceiveAssetsResponse(items: items);
  }
}

class ReceiveAssetsData {
  final String id;
  final String assetName;
  final String assetCode;
  final String assetImage;

  ReceiveAssetsData({
    required this.id,
    required this.assetName,
    required this.assetCode,
    required this.assetImage,
  });

  factory ReceiveAssetsData.fromJson(Map<String, dynamic> json) {
    return ReceiveAssetsData(
      id: json['id'] as String,
      assetName: json['assetName'] as String,
      assetCode: json['assetCode'] as String,
      assetImage: json['assetImage'] as String,
    );
  }
}
