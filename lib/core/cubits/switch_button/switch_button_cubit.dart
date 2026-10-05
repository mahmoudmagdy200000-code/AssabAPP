import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';

@injectable
class SwitchButtonCubit extends SafeCubit<bool> {
  SwitchButtonCubit() : super(false);

  void toggle() {
    emit(!state);
  }
}
