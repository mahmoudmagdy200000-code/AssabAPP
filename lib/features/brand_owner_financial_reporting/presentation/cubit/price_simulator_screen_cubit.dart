import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/entities/price_simulator_item_info_entity.dart';
import '../../domain/usecases/get_price_simulator_item_info_usecase.dart';
import '../../domain/usecases/submit_price_simulation_usecase.dart';
import 'price_simulator_screen_state.dart';

@injectable
class PriceSimulatorScreenCubit extends SafeCubit<PriceSimulatorScreenState> {
  final GetPriceSimulatorItemInfoUseCase _getItemInfoUseCase;
  final SubmitPriceSimulationUseCase _submitSimulationUseCase;

  PriceSimulatorItemInfoEntity? _currentItemInfo;
  double _changePrice = 0;
  double _expectedGrowthDecline = 0.0;

  PriceSimulatorScreenCubit(
    this._getItemInfoUseCase,
    this._submitSimulationUseCase,
  ) : super(const PriceSimulatorScreenInit());

  void loadItemInfo({required String branchId, required String itemId}) async {
    emit(const PriceSimulatorScreenItemInfoLoading());

    final result = await _getItemInfoUseCase(
      branchId: branchId,
      itemId: itemId,
    );

    handle(
      result,
      success: (itemInfo) {
        _currentItemInfo = itemInfo;
        _changePrice = _currentItemInfo?.currentSellingPrice ?? 0;
        _expectedGrowthDecline = 5.0;
        emit(
          PriceSimulatorScreenItemInfoSuccess(
            itemInfo: itemInfo,
            changePrice: _changePrice,
            expectedGrowthDecline: _expectedGrowthDecline,
          ),
        );
      },
      failure: (failure) => emit(PriceSimulatorScreenItemInfoFailure(failure)),
    );
  }

  void incrementChangePrice() {
    _changePrice++;
    _emitCurrentSuccess();
  }

  void decrementChangePrice() {
    if (_changePrice <= 0) return;
    _changePrice--;
    _emitCurrentSuccess();
  }

  void incrementExpectedGrowthDecline() {
    _expectedGrowthDecline++;
    _emitCurrentSuccess();
  }

  void decrementExpectedGrowthDecline() {
    _expectedGrowthDecline--;
    _emitCurrentSuccess();
  }

  void updateChangePrice(double value) {
    _changePrice = value;
    _emitCurrentSuccess();
  }

  void updateExpectedGrowthDecline(double value) {
    _expectedGrowthDecline = value;
    _emitCurrentSuccess();
  }

  void submitSimulation({
    required String branchId,
    required String itemId,
  }) async {
    final info = _currentItemInfo;
    if (info == null) return;

    emit(const PriceSimulatorScreenSimulationLoading());

    final result = await _submitSimulationUseCase(
      branchId: branchId,
      itemId: itemId,
      changePrice: _changePrice.toDouble(),
      expectedGrowthDecline: _expectedGrowthDecline,
    );

    handle(
      result,
      success: (simulationResult) =>
          emit(PriceSimulatorScreenSimulationSuccess(
        result: simulationResult,
        branchId: branchId,
        itemId: itemId,
        changePrice: _changePrice.toDouble(),
        expectedGrowthDecline: _expectedGrowthDecline,
      )),
      failure: (failure) =>
          emit(PriceSimulatorScreenSimulationFailure(failure)),
    );
  }

  void returnToLoadedState() {
    _emitCurrentSuccess();
  }

  void newSimulation() {
    _currentItemInfo = null;
    _changePrice = 0;
    _expectedGrowthDecline = 0.0;
    emit(const PriceSimulatorScreenInit());
  }

  void _emitCurrentSuccess() {
    if (_currentItemInfo != null) {
      emit(
        PriceSimulatorScreenItemInfoSuccess(
          itemInfo: _currentItemInfo!,
          changePrice: _changePrice,
          expectedGrowthDecline: _expectedGrowthDecline,
        ),
      );
    }
  }
}
