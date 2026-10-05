import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'choose_branch_state.dart';

@injectable
class ChooseBranchCubit extends SafeCubit<ChooseBranchState> {
  ChooseBranchCubit() : super(const ChooseBranchState());
}
