class AvailableRecipientsResponseModel {
  final bool success;
  final String message;
  final AvailableRecipientsData data;

  AvailableRecipientsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AvailableRecipientsResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailableRecipientsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: AvailableRecipientsData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class AvailableRecipientsData {
  final List<RecipientItemModel> recipients;
  final bool autoHandoverEnabled;
  final bool hasBranchManager;
  final String? reason;

  AvailableRecipientsData({
    required this.recipients,
    required this.autoHandoverEnabled,
    required this.hasBranchManager,
    this.reason,
  });

  factory AvailableRecipientsData.fromJson(Map<String, dynamic> json) {
    final list = (json['recipients'] as List<dynamic>?)
            ?.map((e) => RecipientItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AvailableRecipientsData(
      recipients: list,
      autoHandoverEnabled: json['auto_handover_enabled'] as bool? ?? false,
      hasBranchManager: json['has_branch_manager'] as bool? ?? false,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'recipients': recipients.map((e) => e.toJson()).toList(),
        'auto_handover_enabled': autoHandoverEnabled,
        'has_branch_manager': hasBranchManager,
        'reason': reason,
      };
}

class RecipientItemModel {
  final String id;
  final String name;
  final String? image;
  final String type; // 'cashier' or 'branch_manager'
  final bool isAvailable;
  final bool disabled;
  final String? reasonDisabled;
  final bool isSuggested;
  final String? suggestionReason;

  RecipientItemModel({
    required this.id,
    required this.name,
    this.image,
    required this.type,
    required this.isAvailable,
    required this.disabled,
    this.reasonDisabled,
    required this.isSuggested,
    this.suggestionReason,
  });

  factory RecipientItemModel.fromJson(Map<String, dynamic> json) {
    return RecipientItemModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      type: json['type'] as String? ?? 'cashier',
      isAvailable: json['is_available'] as bool? ?? true,
      disabled: json['disabled'] as bool? ?? false,
      reasonDisabled: json['reason_disabled'] as String?,
      isSuggested: json['is_suggested'] as bool? ?? false,
      suggestionReason: json['suggestion_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'type': type,
        'is_available': isAvailable,
        'disabled': disabled,
        'reason_disabled': reasonDisabled,
        'is_suggested': isSuggested,
        'suggestion_reason': suggestionReason,
      };
}
