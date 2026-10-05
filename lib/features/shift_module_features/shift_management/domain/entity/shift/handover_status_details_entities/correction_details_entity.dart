class CorrectionDetailsEntity {
  final String requestedBy;
  final String requestedById;
  final String requestedByType;
  final String managerComment;
  final String requestedAt;
  final bool canCashierEdit;

  const CorrectionDetailsEntity({
    required this.requestedBy,
    required this.requestedById,
    required this.requestedByType,
    required this.managerComment,
    required this.requestedAt,
    required this.canCashierEdit,
  });
}
