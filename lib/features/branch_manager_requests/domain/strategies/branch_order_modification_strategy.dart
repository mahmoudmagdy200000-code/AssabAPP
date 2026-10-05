import 'package:flutter/cupertino.dart';

import '../../data/models/branch_order_modification_response.dart';
import '../../presentation/widgets/branch_requests_modification_new_item_view.dart';
import '../../presentation/widgets/branch_requests_modification_new_quantity_view .dart';
import '../../presentation/widgets/branch_requests_modification_new_time_view.dart';

abstract class BranchOrderModificationStrategy {
  Widget buildModificationDetailsWidget(
    BuildContext context,
    BranchOrderModificationResponse modification,
  );
}

class NewQuantityBranchOrderModificationStrategy
    implements BranchOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    BranchOrderModificationResponse modification,
  ) {
    return BranchRequestsModificationNewQuantityView(
      modification: modification as BranchOrderModificationNewQuantityResponse,
    );
  }
}

class NewTimeBranchOrderModificationStrategy
    implements BranchOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    BranchOrderModificationResponse modification,
  ) {
    return BranchRequestsModificationNewTimeView(
      modification: modification as BranchOrderModificationNewTimeResponse,
    );
  }
}

class NewItemBranchOrderModificationStrategy
    implements BranchOrderModificationStrategy {
  @override
  Widget buildModificationDetailsWidget(
    BuildContext context,
    BranchOrderModificationResponse modification,
  ) {
    return BranchRequestsModificationNewItemView(
      modification: modification as BranchOrderModificationNewItemResponse,
    );
  }
}
