import 'package:injectable/injectable.dart';

import '../../../../../core/enums/approve_request_type_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_branch_manager_approve_request_state.dart';

@injectable
class SelectBranchManagerApproveRequestCubit
    extends SafeCubit<SelectBranchManagerApproveRequestState> {
  SelectBranchManagerApproveRequestCubit()
    : super(const SelectBranchManagerApproveRequestState());

  void selectApproveRequestType(ApproveRequestTypeEnum type) {
    emit(state.copyWith(approveRequestType: type));
  }
}
