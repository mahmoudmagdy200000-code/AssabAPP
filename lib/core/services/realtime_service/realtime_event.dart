class RealtimeEvent<T> {
  final String event;
  final T data;

  const RealtimeEvent({required this.event, required this.data});

  @override
  String toString() => 'RealtimeEvent(event: $event, data: $data)';
}
