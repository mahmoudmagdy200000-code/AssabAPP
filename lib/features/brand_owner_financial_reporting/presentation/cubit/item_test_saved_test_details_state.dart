import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ItemTestSavedTestDetailsState extends Equatable {
  const ItemTestSavedTestDetailsState();

  @override
  List<Object> get props => [];
}

final class ItemTestSavedTestDetailsInit
    extends ItemTestSavedTestDetailsState {
  const ItemTestSavedTestDetailsInit();
}

final class ItemTestSavedTestDetailsExporting
    extends ItemTestSavedTestDetailsState {
  const ItemTestSavedTestDetailsExporting();
}

final class ItemTestSavedTestDetailsExportSuccess
    extends ItemTestSavedTestDetailsState {
  final String url;

  const ItemTestSavedTestDetailsExportSuccess(this.url);

  @override
  List<Object> get props => [url];
}

final class ItemTestSavedTestDetailsExportFailure
    extends ItemTestSavedTestDetailsState {
  final ApiFailure failure;

  const ItemTestSavedTestDetailsExportFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ItemTestSavedTestDetailsEmailing
    extends ItemTestSavedTestDetailsState {
  const ItemTestSavedTestDetailsEmailing();
}

final class ItemTestSavedTestDetailsEmailSuccess
    extends ItemTestSavedTestDetailsState {
  const ItemTestSavedTestDetailsEmailSuccess();
}

final class ItemTestSavedTestDetailsEmailFailure
    extends ItemTestSavedTestDetailsState {
  final ApiFailure failure;

  const ItemTestSavedTestDetailsEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
