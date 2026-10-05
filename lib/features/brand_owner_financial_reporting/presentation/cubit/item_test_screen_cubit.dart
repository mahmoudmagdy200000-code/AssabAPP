import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/submit_item_test_usecase.dart';
import 'item_test_screen_state.dart';

@injectable
class ItemTestScreenCubit extends SafeCubit<ItemTestScreenState> {
  final SubmitItemTestUseCase _submitTestUseCase;

  String _itemName = '';
  double _expectedSellingPrice = 0;
  double _productionCost = 0;
  int _expectedSales = 0;
  double _expectedGrowth = 0;

  ItemTestScreenCubit(this._submitTestUseCase)
    : super(const ItemTestScreenInit());

  void initializeForm() {
    emit(const ItemTestScreenFormReady());
  }

  void updateItemName(String value) {
    _itemName = value;
  }

  void updateExpectedSellingPrice(double value) {
    _expectedSellingPrice = value;
  }

  void updateProductionCost(double value) {
    _productionCost = value;
  }

  void updateExpectedSales(int value) {
    _expectedSales = value;
  }

  void updateExpectedGrowth(double value) {
    _expectedGrowth = value;
  }

  void returnToFormReady() {
    emit(
      ItemTestScreenFormReady(
        itemName: _itemName,
        expectedSellingPrice: _expectedSellingPrice,
        productionCost: _productionCost,
        expectedSales: _expectedSales,
        expectedGrowth: _expectedGrowth,
      ),
    );
  }

  void newTest() {
    _itemName = '';
    _expectedSellingPrice = 0;
    _productionCost = 0;
    _expectedSales = 0;
    _expectedGrowth = 0;
    emit(const ItemTestScreenInit());
  }

  Future<void> submitTest({
    required String branchId,
    required String branchName,
  }) async {
    emit(const ItemTestScreenSubmitting());

    final result = await _submitTestUseCase(
      branchId: branchId,
      branchName: branchName,
      itemName: _itemName,
      expectedSellingPrice: _expectedSellingPrice,
      productionCost: _productionCost,
      expectedSales: _expectedSales,
      expectedGrowth: _expectedGrowth,
    );

    handle(
      result,
      success: (data) => emit(ItemTestScreenSubmitSuccess(data)),
      failure: (failure) => emit(ItemTestScreenSubmitFailure(failure)),
    );
  }
}
