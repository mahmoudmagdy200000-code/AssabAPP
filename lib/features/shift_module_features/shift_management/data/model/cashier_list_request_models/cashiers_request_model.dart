import 'cashiers_filter_attributes_model.dart';
import 'pagination_model.dart';

class CashiersRequestModel {
  final PaginationModel? pagination;
  final CashiersFilterAttributesModel? filters;

  CashiersRequestModel({this.pagination, this.filters});

  Map<String, dynamic> toQueryParams() {
    return {...?pagination?.toJson(), ...?filters?.toJson()};
  }
}
