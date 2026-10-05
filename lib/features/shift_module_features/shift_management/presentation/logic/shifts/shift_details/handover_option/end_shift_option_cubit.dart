import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/enums/shift_status/end_shift_options.dart';
import '../../../../../../../../core/helpers/safe_cubit.dart';

part 'end_shift_option_state.dart';

@injectable
class EndShiftOptionCubit extends SafeCubit<EndShiftOptionState> {
  EndShiftOptionCubit() : super(EndShiftOptionState.initial());

  void selectWithHandover() {
    emit(state.copyWith(selectedOption: EndShiftOption.withHandover));
  }

  void selectWithoutHandover() {
    emit(state.copyWith(selectedOption: EndShiftOption.withoutHandover));
  }

  void reset() {
    emit(EndShiftOptionState.initial());
  }

  bool get isWithHandover =>
      state.selectedOption == EndShiftOption.withHandover;
}
