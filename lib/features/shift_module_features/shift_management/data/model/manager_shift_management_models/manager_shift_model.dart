import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/shift_time_stamps.dart';

import '../../../../../../core/enums/shift_status/shift_status_type.dart';
import 'available_actions.dart';
import 'daily_close.dart';
import 'final_handover.dart';
import 'financial_summary.dart';
import 'handoffs_summary.dart';
import 'manager_shift_details.dart';

class ManagerShiftModel {
  final String id;
  final String shiftDate;
  final ShiftStatusType status;
  final String statusLabel;

  // @JsonKey(name: 'shift_overview')
  // final ShiftOverview shiftOverview;

  final ManagerShiftDetails shiftDetails;
  final HandoffsSummary handoffsSummary;
  final FinalHandover finalHandover;
  final DailyClose? dailyClose;
  final FinancialSummary? financialSummary;
  final AvailableActions availableActions;
  final ShiftTimestamps timestamps;

  ManagerShiftModel({
    required this.id,
    required this.shiftDate,
    required this.status,
    required this.statusLabel,
    // required this.shiftOverview,
    required this.shiftDetails,
    required this.handoffsSummary,
    required this.finalHandover,
    required this.dailyClose,
    required this.financialSummary,
    required this.availableActions,
    required this.timestamps,
  });

  factory ManagerShiftModel.fromJson(Map<String, dynamic> json) =>
      ManagerShiftModel(
        id: json['id'] as String,
        shiftDate: json['shift_date'] as String,
        status: ShiftStatusType.fromString(json['status'] as String),
        statusLabel: json['status_label'] as String,
        shiftDetails: ManagerShiftDetails.fromJson(
          json['shift_details'] as Map<String, dynamic>,
        ),
        handoffsSummary: HandoffsSummary.fromJson(
          json['handoffs_summary'] as Map<String, dynamic>,
        ),
        finalHandover: FinalHandover.fromJson(
          json['final_handover'] as Map<String, dynamic>,
        ),
        dailyClose: json['daily_close'] == null
            ? null
            : DailyClose.fromJson(json['daily_close'] as Map<String, dynamic>),
        financialSummary: json['financial_summary'] == null
            ? null
            : FinancialSummary.fromJson(
                json['financial_summary'] as Map<String, dynamic>,
              ),
        availableActions: AvailableActions.fromJson(
          json['available_actions'] as Map<String, dynamic>,
        ),
        timestamps: ShiftTimestamps.fromJson(
          json['timestamps'] as Map<String, dynamic>,
        ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'shift_date': shiftDate,
    'status': status.value,
    'status_label': statusLabel,
    'shift_details': shiftDetails.toJson(),
    'handoffs_summary': handoffsSummary.toJson(),
    'final_handover': finalHandover.toJson(),
    'daily_close': dailyClose?.toJson(),
    'financial_summary': financialSummary?.toJson(),
    'available_actions': availableActions.toJson(),
    'timestamps': timestamps.toJson(),
  };
}
