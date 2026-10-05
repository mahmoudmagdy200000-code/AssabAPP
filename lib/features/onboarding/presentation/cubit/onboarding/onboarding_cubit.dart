import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends SafeCubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitState());

  int _currentPage = 0;
  double _appBarAndNumRowHeight = 0;

  void changePage(int page) {
    _currentPage = page;
    emit(OnboardingChangePageState(_currentPage));
  }

  void getAppBarAndNumRowHeight(double appBarAndNumRowHeight) {
    _appBarAndNumRowHeight = appBarAndNumRowHeight;
    emit(OnboardingAppBarAndNumRowHeightState(_appBarAndNumRowHeight));
  }

  int get currentPage => _currentPage;

  double get appBarAndNumRowHeight => _appBarAndNumRowHeight;
}
