import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/strategies/user_type_strategy.dart';
import 'choose_user_type_state.dart';

@injectable
class ChooseUserTypeCubit extends SafeCubit<ChooseUserTypeState> {
  ChooseUserTypeCubit() : super(const ChooseUserTypeState());

  void selectUserType(UserType userType) {
    emit(state.copyWith(selectedUserType: userType));
  }
}
