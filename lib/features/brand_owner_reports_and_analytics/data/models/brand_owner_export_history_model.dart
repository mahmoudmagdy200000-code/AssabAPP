import '../../domain/entities/brand_owner_export_history_entity.dart';

class BrandOwnerExportHistoryModel extends BrandOwnerExportHistoryEntity {
  const BrandOwnerExportHistoryModel({
    required super.id,
    required super.title,
    required super.createdAtLabel,
    required super.downloadUrl,
    required super.type,
  });

  factory BrandOwnerExportHistoryModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerExportHistoryModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      createdAtLabel: json['created_at_label'] ?? '',
      downloadUrl: json['download_url'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
