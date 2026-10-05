abstract final class FixedAssetsHandoverRealtimeEvents {
  static const statusStarted = 'handover.started';
  static const statusChanged = 'handover.status.changed';
  static const signatureReceiver = 'handover.signature.receiver';
  static const signatureSender = 'handover.signature.sender';
}

abstract final class FixedAssetsHandoverRealtimeChannels {
  static String handoverSession(String sessionId) =>
      'private-handover-session.$sessionId';
}
