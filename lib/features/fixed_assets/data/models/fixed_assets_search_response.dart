import '../../domain/enums/fixed_assets_condition_enum.dart';

class FixedAssetsSearchResponse {
  final String assetTypeName;
  final FixedAssetsSearchIResultSummary summary;
  final List<FixedAssetsSearchItem> items;

  FixedAssetsSearchResponse({
    required this.assetTypeName,
    required this.summary,
    required this.items,
  });

  factory FixedAssetsSearchResponse.fromJson(Map<String, dynamic> json) {
    final root = json['data'] as Map<String, dynamic>;

    final innerData = root['data'] as Map<String, dynamic>;

    final summary = FixedAssetsSearchIResultSummary.fromJson(innerData);

    final itemsJson = (innerData['items'] as List<dynamic>? ?? []);

    return FixedAssetsSearchResponse(
      assetTypeName: root['asset_type_name'] ?? '',
      summary: summary,
      items: itemsJson
          .map((e) => FixedAssetsSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FixedAssetsSearchIResultSummary {
  final int totalItems;
  final int totalItemsMatchingSearch;
  final int totalItemsMatchingSearchExcellentStatus;
  final int totalItemsMatchingSearchMaintenanceStatus;
  final int totalItemsMatchingSearchProblemStatus;

  FixedAssetsSearchIResultSummary({
    required this.totalItems,
    required this.totalItemsMatchingSearch,
    required this.totalItemsMatchingSearchExcellentStatus,
    required this.totalItemsMatchingSearchMaintenanceStatus,
    required this.totalItemsMatchingSearchProblemStatus,
  });

  factory FixedAssetsSearchIResultSummary.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;

    int toInt(dynamic v) => (v ?? 0) is int ? v : (v ?? 0).toInt();

    return FixedAssetsSearchIResultSummary(
      totalItems: toInt(summary['total_items']),
      totalItemsMatchingSearch: toInt(summary['total_items_matching_search']),
      totalItemsMatchingSearchExcellentStatus: toInt(
        summary['total_items_matching_search_excellent_status'],
      ),
      totalItemsMatchingSearchMaintenanceStatus: toInt(
        summary['total_items_matching_search_maintenance_status'],
      ),
      totalItemsMatchingSearchProblemStatus: toInt(
        summary['total_items_matching_search_problem_status'],
      ),
    );
  }
}

class FixedAssetsSearchItem {
  final String id;
  final String name;
  final String code;
  final String image;
  final FixedAssetsSearchLocation location;
  final FixedAssetsConditionEnum status;
  final String assignedTo;
  final String age;
  final String value;
  final String custody;

  FixedAssetsSearchItem({
    required this.id,
    required this.name,
    required this.code,
    required this.image,
    required this.location,
    required this.status,
    required this.assignedTo,
    required this.age,
    required this.value,
    required this.custody,
  });

  factory FixedAssetsSearchItem.fromJson(Map<String, dynamic> json) {
    return FixedAssetsSearchItem(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      image: json['image'] as String,
      location: FixedAssetsSearchLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      status: FixedAssetsConditionEnum.fromString(json['status'] as String),
      assignedTo: json['assigned_to'] as String,
      age: json['age'] as String,
      value: json['value'] as String,
      custody: json['custody'] as String,
    );
  }
}

class FixedAssetsSearchLocation {
  final String id;
  final String name;

  FixedAssetsSearchLocation({required this.id, required this.name});

  factory FixedAssetsSearchLocation.fromJson(Map<String, dynamic> json) {
    return FixedAssetsSearchLocation(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
