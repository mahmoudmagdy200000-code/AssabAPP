class PendingDailyClosureItem {
  const PendingDailyClosureItem({
    required this.id,
    required this.shiftDate,
    required this.status,
    required this.managerId,
    required this.managerName,
    required this.branchId,
    required this.branchName,
    required this.dailyReportSubmitted,
    required this.isHeadFinalApproved,
    required this.handoverStatus,
    required this.handoverAmount,
    required this.totalSales,
    required this.cashCollected,
    this.reportRevision,
  });

  final String id;
  final String shiftDate;
  final String status;
  final String managerId;
  final String managerName;
  final String branchId;
  final String branchName;
  final bool dailyReportSubmitted;
  final bool isHeadFinalApproved;
  final String handoverStatus;
  final double handoverAmount;
  final double totalSales;
  final double cashCollected;
  final int? reportRevision;

  bool get isEligibleForSubmission =>
      status == 'completed' && !dailyReportSubmitted && !isHeadFinalApproved;

  factory PendingDailyClosureItem.fromHistoryJson(Map<String, dynamic> json) {
    Map<String, dynamic> asMap(dynamic v) => v is Map<String, dynamic>
        ? v
        : (v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{});
    double toDouble(dynamic v) =>
        v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '') ?? 0.0);

    final shiftDetails = asMap(json['shift_details']);
    final finalHandover = asMap(json['final_handover']);
    final dailyClose = asMap(json['daily_close']);
    final financial = asMap(json['financial_summary']);
    final rawRev = dailyClose['report_revision'];
    final revision = rawRev is int
        ? rawRev
        : int.tryParse(rawRev?.toString() ?? '');
    final approvedAt = dailyClose['approved_at']?.toString();

    return PendingDailyClosureItem(
      id: (json['id'] ?? '').toString(),
      shiftDate: (json['shift_date'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      managerId: (shiftDetails['manager_id'] ?? '').toString(),
      managerName: (shiftDetails['manager_name'] ?? '').toString(),
      branchId: (shiftDetails['branch_id'] ?? '').toString(),
      branchName: (shiftDetails['store_branch'] ?? '').toString(),
      dailyReportSubmitted: dailyClose['is_submitted'] == true,
      isHeadFinalApproved: approvedAt != null && approvedAt.trim().isNotEmpty,
      handoverStatus: (finalHandover['status'] ?? '').toString(),
      handoverAmount: toDouble(finalHandover['handover_amount']),
      totalSales: toDouble(financial['total_sales']),
      cashCollected: toDouble(financial['cash_collected']),
      reportRevision: revision,
    );
  }

  /// Filters strictly to completed, unsubmitted, non-final workdays owned by the
  /// active manager and branch, ordered oldest business date first so carryover
  /// memberships are closed chronologically without conflicts.
  static List<PendingDailyClosureItem> filterAndOrderPending(
    List<PendingDailyClosureItem> items, {
    required String currentActorId,
    required String currentBranchId,
    String? excludeWorkdayId,
  }) {
    final filtered = items.where((item) {
      if (item.id.isEmpty || item.shiftDate.isEmpty) return false;
      if (excludeWorkdayId != null && item.id == excludeWorkdayId) return false;
      if (!item.isEligibleForSubmission) return false;
      if (currentActorId.isNotEmpty &&
          item.managerId.isNotEmpty &&
          item.managerId != currentActorId) {
        return false;
      }
      if (currentBranchId.isNotEmpty &&
          item.branchId.isNotEmpty &&
          item.branchId != currentBranchId) {
        return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) => a.shiftDate.compareTo(b.shiftDate));
    return filtered;
  }
}
