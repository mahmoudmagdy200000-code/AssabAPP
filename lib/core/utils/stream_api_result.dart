import '../services/realtime_service/realtime_event.dart';
import 'api_result.dart';

typedef StreamApiResult<T> = Stream<ApiResult<RealtimeEvent<T>>>;
