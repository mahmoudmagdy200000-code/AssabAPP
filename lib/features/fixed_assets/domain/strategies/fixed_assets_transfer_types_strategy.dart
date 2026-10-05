import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../presentation/widgets/fixed_assets_view_details_request_button.dart';
import '../enums/fixed_assets_transfer_types_enum.dart';

abstract class FixedAssetsTransferTypesStrategy {
  static FixedAssetsTransferTypesStrategy fromTransferType(
    String transferType,
  ) {
    if (transferType == FixedAssetsTransferTypesEnum.fromBranch.value) {
      return FromBranchTransferTypeStrategy();
    } else if (transferType == FixedAssetsTransferTypesEnum.fromFinance.value) {
      return FromFinanceTransferTypeStrategy();
    } else if (transferType == FixedAssetsTransferTypesEnum.toBranch.value) {
      return ToBranchTransferTypeStrategy();
    } else {
      return ToBranchTransferTypeStrategy();
    }
  }

  FixedAssetsTransferTypesEnum get transferType;

  Widget buildButtonPendingWidget(
    BuildContext context, {
    required FixedAssetsTransferTypesStrategy type,
    required String requestId,
  });

  Widget buildButtonApprovedWidget(
    BuildContext context, {
    required String requestId,
  });

  Widget buildButtonPendingApprovalWidget(
    BuildContext context, {
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }

  Widget buildButtonRejectedWidget(
    BuildContext context, {
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }

  String label(BuildContext context);
}

class FromBranchTransferTypeStrategy extends FixedAssetsTransferTypesStrategy {
  @override
  FixedAssetsTransferTypesEnum get transferType =>
      FixedAssetsTransferTypesEnum.fromBranch;

  @override
  String label(BuildContext context) => context.tr.fromBranch;

  @override
  Widget buildButtonPendingWidget(
    BuildContext context, {
    required FixedAssetsTransferTypesStrategy type,
    required String requestId,
  }) {
    return Row(
      children: [
        Expanded(
          child: FixedAssetsViewDetailsRequestButton(
            onPressed: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsTransferDetailsScreen,
                arguments: requestId,
              );
            },
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: ButtonTextIcon(
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsReceiveAssetsScreen,
                arguments: {'type': type, 'requestId': requestId},
              );
            },
            label: context.tr.approve,
            textColor: context.customColor.reversedTextColor,
            backgroundColor: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(1000.r),
            padding: EdgeInsets.symmetric(vertical: 11.r),
            icon: AppSvg(
              assetName: AppAssets.check,
              colorFilter: ColorFilter.mode(
                context.customColor.reversedTextColor,
                BlendMode.srcIn,
              ),
              width: 16.w,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildButtonApprovedWidget(
    BuildContext context, {
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }
}

class FromFinanceTransferTypeStrategy extends FixedAssetsTransferTypesStrategy {
  @override
  FixedAssetsTransferTypesEnum get transferType =>
      FixedAssetsTransferTypesEnum.fromFinance;

  @override
  String label(BuildContext context) => context.tr.fromFinance;

  @override
  Widget buildButtonPendingWidget(
    BuildContext context, {
    required FixedAssetsTransferTypesStrategy type,
    required String requestId,
  }) {
    return Row(
      children: [
        Expanded(
          child: FixedAssetsViewDetailsRequestButton(
            onPressed: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsTransferDetailsScreen,
                arguments: requestId,
              );
            },
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: ButtonTextIcon(
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsReceiveAssetsScreen,
                arguments: {'type': type, 'requestId': requestId},
              );
            },
            label: context.tr.approve,
            textColor: context.customColor.reversedTextColor,
            backgroundColor: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(1000.r),
            padding: EdgeInsets.symmetric(vertical: 11.r),
            icon: AppSvg(
              assetName: AppAssets.check,
              colorFilter: ColorFilter.mode(
                context.customColor.reversedTextColor,
                BlendMode.srcIn,
              ),
              width: 16.w,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildButtonApprovedWidget(
    BuildContext context, {
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }
}

class ToBranchTransferTypeStrategy extends FixedAssetsTransferTypesStrategy {
  @override
  FixedAssetsTransferTypesEnum get transferType =>
      FixedAssetsTransferTypesEnum.toBranch;

  @override
  String label(BuildContext context) => context.tr.outgoingTransfer;

  @override
  Widget buildButtonPendingWidget(
    BuildContext context, {
    required FixedAssetsTransferTypesStrategy type,
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }

  @override
  Widget buildButtonApprovedWidget(
    BuildContext context, {
    required String requestId,
  }) {
    return FixedAssetsViewDetailsRequestButton(
      onPressed: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsTransferDetailsScreen,
          arguments: requestId,
        );
      },
    );
  }
}
