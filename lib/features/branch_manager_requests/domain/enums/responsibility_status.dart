enum ResponsibilityStatus { approved, rejected, notSubmitted }

extension ResponsibilityStatusX on ResponsibilityStatus {
  String get value {
    switch (this) {
      case ResponsibilityStatus.approved:
        return 'approved';
      case ResponsibilityStatus.rejected:
        return 'rejected';
      case ResponsibilityStatus.notSubmitted:
        return 'not_submitted';
    }
  }

  static ResponsibilityStatus fromJson(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'approved':
        return ResponsibilityStatus.approved;
      case 'rejected':
        return ResponsibilityStatus.rejected;
      case 'not_submitted':
        return ResponsibilityStatus.notSubmitted;
      default:
        return ResponsibilityStatus.notSubmitted;
    }
  }
}
