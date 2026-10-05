import 'package:assab/features/cashier_requests/data/models/reassigned_shift_item_model.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';

class ReassignedShiftsResponse {
  final List<ReassignedShiftItemModel> data;
  final MetaModel meta;

  const ReassignedShiftsResponse({required this.data, required this.meta});

  factory ReassignedShiftsResponse.fromJson(Map<String, dynamic> json) {
    return ReassignedShiftsResponse(
      data: (json['data'] as List)
          .map((e) => ReassignedShiftItemModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
