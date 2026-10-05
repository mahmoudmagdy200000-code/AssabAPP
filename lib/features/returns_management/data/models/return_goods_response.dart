import '../../../../core/enums/item_return_status_enum.dart';
import '../../domain/strategies/item_return_status_strategy.dart';

class ReturnGoodsResponse {
  final List<ReturnGoodsData> data;

  ReturnGoodsResponse({required this.data});

  factory ReturnGoodsResponse.fromJson(Map<String, dynamic> json) {
    return ReturnGoodsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ReturnGoodsData.fromJson(e))
          .toList(),
    );
  }
}

class ReturnGoodsData {
  final String id;
  final ItemReturnStatusStrategy status;
  final String returnNumber;
  final String createdAt;

  ReturnGoodsData({
    required this.id,
    required this.status,
    required this.returnNumber,
    required this.createdAt,
  });

  factory ReturnGoodsData.fromJson(Map<String, dynamic> json) {
    return ReturnGoodsData(
      id: json['id'],
      status: ItemReturnStatusEnum.fromString(json['status']).strategy,
      returnNumber: json['return_number'],
      createdAt: json['created_at'],
    );
  }
}
