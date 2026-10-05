import 'package:assab/features/receive_goods/data/repository/receive_goods_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_receive_order_inspection_state.dart';

@injectable
class GetReceiveOrderInspectionCubit
    extends SafeCubit<GetReceiveOrderInspectionState> {
  final ReceiveGoodsRepository _receiveGoodsRepository;

  GetReceiveOrderInspectionCubit(this._receiveGoodsRepository)
    : super(const GetReceiveOrderInspectionInit());

  void getReceiveOrderInspection({required String orderId}) async {
    emit(const GetReceiveOrderInspectionLoading());

    final result = await _receiveGoodsRepository.getReceivingOrderInspection(
      orderId: orderId,
    );

    handle(
      result,
      success: (response) {
        emit(GetReceiveOrderInspectionSuccess(response));
      },
      failure: (failure) {
        emit(GetReceiveOrderInspectionFailure(failure));
      },
    );
  }
}
