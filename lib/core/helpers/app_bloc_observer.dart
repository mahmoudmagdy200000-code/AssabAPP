import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (error is StateError &&
        error.message.contains('Cannot emit new states after calling close')) {
      AppLogger.log('Emit after close prevented in ${bloc.runtimeType}');
      return;
    }

    super.onError(bloc, error, stackTrace);
  }
}
