import 'package:assab/shared/models/time_line_response.dart';

import '../../domain/enums/fixed_assets_condition_enum.dart';
import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'fixed_assets_types_response.dart';
import 'fixed_assets_zones_response.dart';

class FixedAssetsDisposalsDetailsResponse {
  final FixedAssetsDisposalsRequestDetails requestDetails;
  final List<FixedAssetsDisposalsAsset> assets;
  final TimeLineResponse timelines;

  FixedAssetsDisposalsDetailsResponse({
    required this.requestDetails,
    required this.assets,
    required this.timelines,
  });

  factory FixedAssetsDisposalsDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data']['data'] as Map<String, dynamic>;

    return FixedAssetsDisposalsDetailsResponse(
      requestDetails: FixedAssetsDisposalsRequestDetails.fromJson(
        data['request_details'] as Map<String, dynamic>,
      ),
      assets: (data['assets'] as List<dynamic>)
          .map(
            (item) => FixedAssetsDisposalsAsset.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      timelines: TimeLineResponse.fromJson(data),
    );
  }
}

class FixedAssetsDisposalsRequestDetails {
  final String proposedDate;
  final String proposedTime;
  final String disposalMethod;
  final int selectedAssets;
  final FixedAssetsRequestsStatusStrategy status;
  final String? approvedOn;

  FixedAssetsDisposalsRequestDetails({
    required this.proposedDate,
    required this.proposedTime,
    required this.disposalMethod,
    required this.selectedAssets,
    required this.status,
    this.approvedOn,
  });

  factory FixedAssetsDisposalsRequestDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsDisposalsRequestDetails(
      proposedDate: json['proposed_date'] as String,
      proposedTime: json['proposed_time'] as String,
      disposalMethod: json['disposal_method'] as String,
      selectedAssets: (json['selected_assets'] as num).toInt(),
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
    );
  }
}

class FixedAssetsDisposalsAsset {
  final String name;
  final String code;
  final String imageUrl;
  final FixedAssetsZoneData zone;
  final FixedAssetsTypeData type;
  final FixedAssetsConditionEnum status;
  final String value;
  final String custody;
  final String transferReason;

  FixedAssetsDisposalsAsset({
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.zone,
    required this.type,
    required this.status,
    required this.value,
    required this.custody,
    required this.transferReason,
  });

  factory FixedAssetsDisposalsAsset.fromJson(Map<String, dynamic> json) {
    return FixedAssetsDisposalsAsset(
      name: json['name'] as String,
      code: json['code'] as String,
      imageUrl: json['image_url'] as String,
      zone: FixedAssetsZoneData.fromJson(json['zone'] as Map<String, dynamic>),
      type: FixedAssetsTypeData.fromJson(json['type'] as Map<String, dynamic>),
      status: FixedAssetsConditionEnum.fromString(json['status'] as String),
      value: json['value'] as String,
      custody: json['custody'] as String,
      transferReason: json['transfer_reason'] as String,
    );
  }
}
