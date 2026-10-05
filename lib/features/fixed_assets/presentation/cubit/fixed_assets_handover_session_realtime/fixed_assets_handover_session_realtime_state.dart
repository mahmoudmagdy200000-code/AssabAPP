import 'package:equatable/equatable.dart';

sealed class FixedAssetsHandoverSessionRealtimeState extends Equatable {
  const FixedAssetsHandoverSessionRealtimeState();

  @override
  List<Object?> get props => [];
}

final class FixedAssetsHandoverSessionRealtimeIdle
    extends FixedAssetsHandoverSessionRealtimeState {
  const FixedAssetsHandoverSessionRealtimeIdle();
}

final class FixedAssetsHandoverSessionRealtimeStarted
    extends FixedAssetsHandoverSessionRealtimeState {
  const FixedAssetsHandoverSessionRealtimeStarted();
}

final class FixedAssetsHandoverSessionRealtimeReceiverSigned
    extends FixedAssetsHandoverSessionRealtimeState {
  const FixedAssetsHandoverSessionRealtimeReceiverSigned();
}

final class FixedAssetsHandoverSessionRealtimeSenderSigned
    extends FixedAssetsHandoverSessionRealtimeState {
  const FixedAssetsHandoverSessionRealtimeSenderSigned();
}

final class FixedAssetsHandoverSessionRealtimeStatusChanged
    extends FixedAssetsHandoverSessionRealtimeState {
  const FixedAssetsHandoverSessionRealtimeStatusChanged();
}
