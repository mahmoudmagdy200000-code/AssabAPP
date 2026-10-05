import 'package:assab/features/fixed_assets/domain/enums/fixed_assets_search_type.dart';

class FixedAssetsSearchRequest {
  final FixedAssetsSearchType searchType;
  // if searchType is 'FixedAssetsSearchType.general', then these fields are required
  final String? zoneId;
  final String? typeId;
  final String? employeeId;
  final String? date;

  // if searchType is 'FixedAssetsSearchType.quick', then this field is required
  final String? quickSearchKey;

  FixedAssetsSearchRequest({
    required this.searchType,
    this.zoneId,
    this.typeId,
    this.employeeId,
    this.date,
    this.quickSearchKey,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'search_type': searchType.value,
      'zone_id': zoneId,
      'type_id': typeId,
      'employee_id': employeeId,
      'date': date,
    };

    if (searchType == FixedAssetsSearchType.quick) {
      data['quick_search_key'] = quickSearchKey;
    }

    return data;
  }
}
