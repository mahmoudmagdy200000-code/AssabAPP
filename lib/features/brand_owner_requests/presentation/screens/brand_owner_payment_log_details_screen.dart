import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/strategies/custody_preferred_receipt_method_strategy.dart';
import '../../../../core/enums/custody_preferred_receipt_method.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/repositories/brand_owner_requests_repository.dart';
import '../cubits/brand_owner_payment_log_cubit.dart';
import '../cubits/brand_owner_payment_log_state.dart';

class BrandOwnerPaymentLogDetailsScreen extends StatefulWidget {
  final String paymentLogId;

  const BrandOwnerPaymentLogDetailsScreen({
    super.key,
    this.paymentLogId = 'payment-log-1',
  });

  @override
  State<BrandOwnerPaymentLogDetailsScreen> createState() =>
      _BrandOwnerPaymentLogDetailsScreenState();
}

class _BrandOwnerPaymentLogDetailsScreenState
    extends State<BrandOwnerPaymentLogDetailsScreen> {
  late final BrandOwnerPaymentLogCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = BrandOwnerPaymentLogCubit(getIt<BrandOwnerRequestsRepository>())
      ..getBrandOwnerPaymentLogDetails(paymentLogId: widget.paymentLogId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: AppPaddingWidget(
          top: 40.r,
          child:
              BlocBuilder<BrandOwnerPaymentLogCubit, BrandOwnerPaymentLogState>(
                builder: (context, state) {
                  if (state is BrandOwnerPaymentLogLoading) {
                    return const AppLoadingWidget();
                  }

                  if (state is BrandOwnerPaymentLogFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () => context
                          .read<BrandOwnerPaymentLogCubit>()
                          .getBrandOwnerPaymentLogDetails(
                            paymentLogId: widget.paymentLogId,
                          ),
                      withBorder: false,
                    );
                  }

                  final details = state is BrandOwnerPaymentLogDetailsSuccess
                      ? state.details
                      : null;

                  if (details == null) {
                    return const AppLoadingWidget();
                  }

                  final receiptMethod = _getReceiptMethod(details.methodLabel);
                  final strategy =
                      CustodyPreferredReceiptMethodStrategy.getStrategy(
                        receiptMethod,
                      );

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        strategy.buildTopDetailsWidgetBrandOwner(context),
                        10.verticalSpace,
                        Text(
                          details.description,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        10.verticalSpace,
                        strategy.buildPaymentSummaryDetailsWidgetBrandOwner(
                          context,
                        ),
                        12.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.r,
                            vertical: 10.r,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  context.tr.branch,
                                  style: AppStyles.s16W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              const ProfileImageWidget(height: 110, width: 110),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context,
                                AppAssets.personSvg,
                                context.tr.manager,
                                details.managerName,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context,
                                AppAssets.branch,
                                context.tr.storeBranch,
                                details.branchName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String assetName,
    String title,
    String value, {
    bool isCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSvg(
                assetName: assetName,
                width: 15.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCurrency) const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CustodyPreferredReceiptMethod _getReceiptMethod(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('bank')) {
      return CustodyPreferredReceiptMethod.bankTransfer;
    }

    return CustodyPreferredReceiptMethod.cashHandover;
  }
}
