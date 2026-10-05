class FixedAssetsActiveHandoverSessionPreviewResponse {
  final String sessionId;
  final bool iAmSigned;
  final List<FixedAssetsActiveHandoverPreviewProgressItem> progressItems;
  final String timeSpent;
  final int remainingPercent;
  final int totalAssets;
  final int acceptedAssets;
  final int noteAssets;
  final int rejectedAssets;
  final List<FixedAssetsActiveHandoverPreviewAsset> acceptedList;
  final List<FixedAssetsActiveHandoverPreviewAsset> noteList;
  final List<FixedAssetsActiveHandoverPreviewAsset> rejectedList;

  const FixedAssetsActiveHandoverSessionPreviewResponse({
    required this.sessionId,
    required this.iAmSigned,
    required this.progressItems,
    required this.timeSpent,
    required this.remainingPercent,
    required this.totalAssets,
    required this.acceptedAssets,
    required this.noteAssets,
    required this.rejectedAssets,
    required this.acceptedList,
    required this.noteList,
    required this.rejectedList,
  });

  factory FixedAssetsActiveHandoverSessionPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final progressList = data['progressItems'] as List? ?? [];
    final acceptedList = data['acceptedList'] as List? ?? [];
    final noteList = data['noteList'] as List? ?? [];
    final rejectedList = data['rejectedList'] as List? ?? [];

    return FixedAssetsActiveHandoverSessionPreviewResponse(
      sessionId: data['sessionId'] as String,
      iAmSigned: data['iAmSigned'] as bool,
      progressItems: progressList
          .map(
            (item) =>
                FixedAssetsActiveHandoverPreviewProgressItem.fromJson(item),
          )
          .toList(),
      timeSpent: data['timeSpent'] as String,
      remainingPercent: data['remainingPercent'] as int,
      totalAssets: data['totalAssets'] as int,
      acceptedAssets: data['acceptedAssets'] as int,
      noteAssets: data['noteAssets'] as int,
      rejectedAssets: data['rejectedAssets'] as int,
      acceptedList: acceptedList
          .map((item) => FixedAssetsActiveHandoverPreviewAsset.fromJson(item))
          .toList(),
      noteList: noteList
          .map((item) => FixedAssetsActiveHandoverPreviewAsset.fromJson(item))
          .toList(),
      rejectedList: rejectedList
          .map((item) => FixedAssetsActiveHandoverPreviewAsset.fromJson(item))
          .toList(),
    );
  }
}

class FixedAssetsActiveHandoverPreviewProgressItem {
  final String label;
  final int percent;

  const FixedAssetsActiveHandoverPreviewProgressItem({
    required this.label,
    required this.percent,
  });

  factory FixedAssetsActiveHandoverPreviewProgressItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsActiveHandoverPreviewProgressItem(
      label: json['label'] as String,
      percent: json['percent'] as int,
    );
  }
}

class FixedAssetsActiveHandoverPreviewAsset {
  final String assetId;
  final String assetName;
  final String assetCode;
  final String assetImageUrl;
  final String zoneName;
  final String typeName;
  final int value;
  final String age;
  final String handoverDescription;

  const FixedAssetsActiveHandoverPreviewAsset({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
    required this.assetImageUrl,
    required this.zoneName,
    required this.typeName,
    required this.value,
    required this.age,
    required this.handoverDescription,
  });

  factory FixedAssetsActiveHandoverPreviewAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsActiveHandoverPreviewAsset(
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      assetCode: json['assetCode'] as String,
      assetImageUrl: json['assetImageUrl'] as String,
      zoneName: json['zoneName'] as String,
      typeName: json['typeName'] as String,
      value: json['value'] as int,
      age: json['age'] as String,
      handoverDescription: json['handoverDescription'] as String,
    );
  }
}
