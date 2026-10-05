import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';

@injectable
class ShowPasswordCubit extends SafeCubit<bool> {
  ShowPasswordCubit() : super(true);

  void toggle() {
    emit(!state);
  }
}
