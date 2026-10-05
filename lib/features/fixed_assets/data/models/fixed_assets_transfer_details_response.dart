import 'package:assab/shared/models/time_line_response.dart';

import '../../domain/enums/fixed_assets_condition_enum.dart';
import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'fixed_assets_types_response.dart';
import 'fixed_assets_zones_response.dart';

class FixedAssetsTransferDetailsResponse {
  final FixedAssetsTransferRequestDetails requestDetails;
  final List<FixedAssetsTransferAsset> assets;
  final bool skipConfirmation;

  final TimeLineResponse timelines;

  FixedAssetsTransferDetailsResponse({
    required this.requestDetails,
    required this.assets,
    required this.skipConfirmation,
    required this.timelines,
  });

  factory FixedAssetsTransferDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data']['data'] as Map<String, dynamic>;

    return FixedAssetsTransferDetailsResponse(
      requestDetails: FixedAssetsTransferRequestDetails.fromJson(
        data['request_details'] as Map<String, dynamic>,
      ),
      assets: [
        FixedAssetsTransferAsset.fromJson(
          data['asset'] as Map<String, dynamic>,
        ),
      ],
      skipConfirmation: data['skip_confirmation'] as bool,
      timelines: TimeLineResponse.fromJson(data),
    );
  }
}

class FixedAssetsTransferRequestDetails {
  final String from;
  final String to;
  final String requestDate;
  final String arrivalTime;
  final String transferId;
  final FixedAssetsRequestsStatusStrategy status;

  FixedAssetsTransferRequestDetails({
    required this.from,
    required this.to,
    required this.requestDate,
    required this.arrivalTime,
    required this.transferId,
    required this.status,
  });

  factory FixedAssetsTransferRequestDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsTransferRequestDetails(
      from: json['from'] as String,
      to: json['to'] as String,
      requestDate: json['request_date'] as String,
      arrivalTime: json['arrival_time'] as String,
      transferId: json['transfer_id'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
    );
  }
}

class FixedAssetsTransferAsset {
  final String name;
  final String code;
  final String imageUrl;
  final FixedAssetsZoneData zone;
  final FixedAssetsTypeData type;
  final FixedAssetsConditionEnum status;
  final String value;
  final String custody;
  final String transferReason;

  FixedAssetsTransferAsset({
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

  factory FixedAssetsTransferAsset.fromJson(Map<String, dynamic> json) {
    return FixedAssetsTransferAsset(
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
