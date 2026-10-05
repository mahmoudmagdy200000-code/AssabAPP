import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/features/purchase/presentation/widgets/supplier_status_widget.dart';
import 'package:flutter/cupertino.dart';

abstract class SupplierStatusStrategy {
  Widget buildStatusWidget(BuildContext context);
}

class OnlineSupplierStatusStrategy implements SupplierStatusStrategy {
  @override
  Widget buildStatusWidget(BuildContext context) {
    return SupplierStatusWidget(
      status: context.tr.online,
      iconAssetName: AppAssets.online,
      borderColor: AppColors.lightGreen,
    );
  }
}

class AwaySupplierStatusStrategy implements SupplierStatusStrategy {
  @override
  Widget buildStatusWidget(BuildContext context) {
    return SupplierStatusWidget(
      status: context.tr.awayNotificationsActive,
      iconAssetName: AppAssets.away,
      borderColor: AppColors.orange,
    );
  }
}

class OfflineSupplierStatusStrategy implements SupplierStatusStrategy {
  @override
  Widget buildStatusWidget(BuildContext context) {
    return SupplierStatusWidget(
      status: context.tr.offline,
      iconAssetName: AppAssets.away,
      borderColor: AppColors.errorLight,
    );
  }
}
