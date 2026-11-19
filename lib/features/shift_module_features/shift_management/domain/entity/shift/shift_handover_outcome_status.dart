enum ShiftHandoverOutcomeStatus {
  accepted,
  pending,
  unknown;

  static ShiftHandoverOutcomeStatus fromApiPayload(dynamic payload) {
    final status = _extractStatus(payload)?.trim().toLowerCase();
    if (status == 'accepted' || status == 'approved') {
      return ShiftHandoverOutcomeStatus.accepted;
    }
    if (status == 'pending') {
      return ShiftHandoverOutcomeStatus.pending;
    }
    return ShiftHandoverOutcomeStatus.unknown;
  }

  static String? _extractStatus(dynamic payload) {
    if (payload is! Map) return null;
    final map = payload is Map<String, dynamic>
        ? payload
        : Map<String, dynamic>.from(payload);

    final data = map['data'];
    final root = data is Map
        ? (data is Map<String, dynamic>
              ? data
              : Map<String, dynamic>.from(data))
        : map;

    final summary = root['summary'];
    if (summary is Map && summary['handover_details'] is Map) {
      final s = summary['handover_details']['status'];
      if (s != null) return s.toString();
    }

    if (root['handover_details'] is Map) {
      final s = root['handover_details']['status'];
      if (s != null) return s.toString();
    }

    return null;
  }
}
