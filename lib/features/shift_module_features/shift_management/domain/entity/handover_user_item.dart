import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';

class HandoverUserItem {
  final String id;
  final String name;
  final String? image;
  final CashierStatus status;
  final String branchName;
  final bool isManager;
  final bool disabled;
  final String? reasonDisabled;
  final bool isSuggested;
  final String? suggestionReason;

  HandoverUserItem({
    required this.id,
    required this.name,
    this.image,
    required this.status,
    required this.branchName,
    required this.isManager,
    this.disabled = false,
    this.reasonDisabled,
    this.isSuggested = false,
    this.suggestionReason,
  });
}
