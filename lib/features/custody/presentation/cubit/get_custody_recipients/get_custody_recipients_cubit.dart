import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_custody_recipients_state.dart';

@injectable
class GetCustodyRecipientsCubit extends SafeCubit<GetCustodyRecipientsState> {
  final CustodyRepository _custodyRepository;

  GetCustodyRecipientsCubit(this._custodyRepository)
    : super(const GetCustodyRecipientsInit());

  Future<void> getRecipients() async {
    emit(const GetCustodyRecipientsLoading());

    final result = await _custodyRepository.getRecipients();

    handle(
      result,
      failure: (f) => emit(GetCustodyRecipientsFailure(f)),
      success: (response) => emit(GetCustodyRecipientsSuccess(response)),
    );
  }
}
