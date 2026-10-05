class FixedAssetPreviewAssetHistoryResponse {
  final String assetId;
  final String assetName;
  final String assetCode;
  final String location;
  final String assetImage;
  final FixedAssetPreviewPhotosSection? photos;
  final FixedAssetPreviewStatusSection? statusHistory;
  final FixedAssetPreviewTransfersSection? transfers;
  final FixedAssetPreviewCustodySection? custody;
  final FixedAssetPreviewFinancialSection? financial;

  FixedAssetPreviewAssetHistoryResponse({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
    required this.location,
    required this.assetImage,
    this.photos,
    this.statusHistory,
    this.transfers,
    this.custody,
    this.financial,
  });

  factory FixedAssetPreviewAssetHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return FixedAssetPreviewAssetHistoryResponse(
      assetId: data['assetId'] ?? '',
      assetName: data['assetName'] ?? '',
      assetCode: data['assetCode'] ?? '',
      location: data['location'] ?? '',
      assetImage: data['assetImage'] ?? '',
      photos: data['photos'] != null
          ? FixedAssetPreviewPhotosSection.fromJson(data['photos'])
          : null,
      statusHistory: data['statusHistory'] != null
          ? FixedAssetPreviewStatusSection.fromJson(data['statusHistory'])
          : null,
      transfers: data['transfers'] != null
          ? FixedAssetPreviewTransfersSection.fromJson(data['transfers'])
          : null,
      custody: data['custody'] != null
          ? FixedAssetPreviewCustodySection.fromJson(data['custody'])
          : null,
      financial: data['financial'] != null
          ? FixedAssetPreviewFinancialSection.fromJson(data['financial'])
          : null,
    );
  }
}

class FixedAssetPreviewPhoto {
  final String id;
  final String imageUrl;
  final String updatedBy;
  final String date;
  final bool isCurrent;

  FixedAssetPreviewPhoto({
    required this.id,
    required this.imageUrl,
    required this.updatedBy,
    required this.date,
    this.isCurrent = false,
  });

  factory FixedAssetPreviewPhoto.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewPhoto(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      date: json['date'] ?? '',
      isCurrent: json['isCurrent'] ?? false,
    );
  }
}

class FixedAssetPreviewPhotosSection {
  final List<FixedAssetPreviewPhoto> photos;
  final int totalCount;

  FixedAssetPreviewPhotosSection({
    required this.photos,
    required this.totalCount,
  });

  factory FixedAssetPreviewPhotosSection.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewPhotosSection(
      photos:
          (json['photos'] as List?)
              ?.map((p) => FixedAssetPreviewPhoto.fromJson(p))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class FixedAssetPreviewStatus {
  final String id;
  final String date;
  final String note;
  final String status;
  final String statusColor;

  FixedAssetPreviewStatus({
    required this.id,
    required this.date,
    required this.note,
    required this.status,
    required this.statusColor,
  });

  factory FixedAssetPreviewStatus.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewStatus(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      status: json['status'] ?? '',
      statusColor: json['statusColor'] ?? '',
    );
  }
}

class FixedAssetPreviewStatusSection {
  final List<FixedAssetPreviewStatus> statuses;
  final int totalCount;

  FixedAssetPreviewStatusSection({
    required this.statuses,
    required this.totalCount,
  });

  factory FixedAssetPreviewStatusSection.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewStatusSection(
      statuses:
          (json['statuses'] as List?)
              ?.map((s) => FixedAssetPreviewStatus.fromJson(s))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class FixedAssetPreviewTransfer {
  final String id;
  final String date;
  final String label;
  final String fromLocation;
  final String toLocation;

  FixedAssetPreviewTransfer({
    required this.id,
    required this.date,
    required this.label,
    required this.fromLocation,
    required this.toLocation,
  });

  factory FixedAssetPreviewTransfer.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewTransfer(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      label: json['label'] ?? '',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
    );
  }
}

class FixedAssetPreviewTransfersSection {
  final List<FixedAssetPreviewTransfer> transfers;
  final int totalCount;

  FixedAssetPreviewTransfersSection({
    required this.transfers,
    required this.totalCount,
  });

  factory FixedAssetPreviewTransfersSection.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetPreviewTransfersSection(
      transfers:
          (json['transfers'] as List?)
              ?.map((t) => FixedAssetPreviewTransfer.fromJson(t))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class FixedAssetPreviewCustodyRecord {
  final String id;
  final String custodianName;
  final String duration;
  final String role;

  FixedAssetPreviewCustodyRecord({
    required this.id,
    required this.custodianName,
    required this.duration,
    required this.role,
  });

  factory FixedAssetPreviewCustodyRecord.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewCustodyRecord(
      id: json['id'] ?? '',
      custodianName: json['custodianName'] ?? '',
      duration: json['duration'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class FixedAssetPreviewCustodySection {
  final FixedAssetPreviewCustodyRecord? currentCustody;
  final List<FixedAssetPreviewCustodyRecord> previousCustody;
  final String performanceScore;

  FixedAssetPreviewCustodySection({
    this.currentCustody,
    required this.previousCustody,
    required this.performanceScore,
  });

  factory FixedAssetPreviewCustodySection.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewCustodySection(
      currentCustody: json['currentCustody'] != null
          ? FixedAssetPreviewCustodyRecord.fromJson(json['currentCustody'])
          : null,
      previousCustody:
          (json['previousCustody'] as List?)
              ?.map((p) => FixedAssetPreviewCustodyRecord.fromJson(p))
              .toList() ??
          [],
      performanceScore: json['performanceScore'] ?? '',
    );
  }
}

class FixedAssetPreviewFinancial {
  final String label;
  final String value;

  FixedAssetPreviewFinancial({required this.label, required this.value});

  factory FixedAssetPreviewFinancial.fromJson(Map<String, dynamic> json) {
    return FixedAssetPreviewFinancial(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class FixedAssetPreviewFinancialSection {
  final List<FixedAssetPreviewFinancial> items;

  FixedAssetPreviewFinancialSection({required this.items});

  factory FixedAssetPreviewFinancialSection.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetPreviewFinancialSection(
      items:
          (json['items'] as List?)
              ?.map((i) => FixedAssetPreviewFinancial.fromJson(i))
              .toList() ??
          [],
    );
  }
}
