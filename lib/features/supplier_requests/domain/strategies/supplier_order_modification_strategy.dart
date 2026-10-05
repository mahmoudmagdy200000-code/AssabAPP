import 'package:flutter/cupertino.dart';

import '../../data/models/supplier_order_modification_response.dart';
import '../../presentation/widgets/supplier_requests_modification_new_item_view.dart';
import '../../presentation/widgets/supplier_requests_modification_new_quantity_view .dart';
import '../../presentation/widgets/supplier_requests_modification_new_time_view.dart';

abstract class SupplierOrderModificationStrategy {
  Widget buildModificationDetailsWidget(
    BuildContext context,
    SupplierOrderModificationResponse modification,
  );
}

class NewQuantitySupplierOrderModificationStrategy
    implements SupplierOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    SupplierOrderModificationResponse modification,
  ) {
    return SupplierRequestsModificationNewQuantityView(
      modification:
          modification as SupplierOrderModificationNewQuantityResponse,
    );
  }
}

class NewTimeSupplierOrderModificationStrategy
    implements SupplierOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    SupplierOrderModificationResponse modification,
  ) {
    return SupplierRequestsModificationNewTimeView(
      modification: modification as SupplierOrderModificationNewTimeResponse,
    );
  }
}

class NewItemSupplierOrderModificationStrategy
    implements SupplierOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    SupplierOrderModificationResponse modification,
  ) {
    return SupplierRequestsModificationNewItemView(
      modification: modification as SupplierOrderModificationNewItemResponse,
    );
  }
}
