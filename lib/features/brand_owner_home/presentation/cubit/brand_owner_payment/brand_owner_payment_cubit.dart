import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_payment_request.dart';
import '../../../data/repository/brand_owner_home_repository.dart';
import 'brand_owner_payment_state.dart';

@injectable
class BrandOwnerPaymentCubit extends SafeCubit<BrandOwnerPaymentState> {
  final BrandOwnerHomeRepository _brandOwnerHomeRepository;

  BrandOwnerPaymentCubit(this._brandOwnerHomeRepository)
    : super(BrandOwnerPaymentInitial());

  Future<void> submitOwnerPaymentForm({
    required BrandOwnerPaymentRequest body,
  }) async {
    emit(BrandOwnerPaymentLoading());

    final result = await _brandOwnerHomeRepository.submitOwnerPaymentForm(
      body: body,
    );

    handle(
      result,
      success: (_) => emit(BrandOwnerPaymentSuccess()),
      failure: (failure) => emit(BrandOwnerPaymentFailure(failure)),
    );
  }
}
