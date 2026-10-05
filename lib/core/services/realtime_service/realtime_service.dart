import 'realtime_event.dart';

abstract class RealtimeService {
  Future<void> connect();

  Stream<RealtimeEvent<T>> subscribe<T>({
    required String channel,
    required T Function(Map<String, dynamic> json) mapper,
  });

  Future<void> unsubscribe(String channel);

  Future<void> disconnect();
}
