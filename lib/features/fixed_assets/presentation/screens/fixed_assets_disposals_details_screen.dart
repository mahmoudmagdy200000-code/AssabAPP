import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:flutter/material.dart';

import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../../data/models/fixed_assets_disposals_details_response.dart';
import '../cubit/fixed_assets_disposals_details/fixed_assets_disposals_details_cubit.dart';
import '../cubit/fixed_assets_disposals_details/fixed_assets_disposals_details_state.dart';

class FixedAssetsDisposalsDetailsScreen extends StatefulWidget {
  const FixedAssetsDisposalsDetailsScreen({super.key});

  @override
  State<FixedAssetsDisposalsDetailsScreen> createState() =>
      _FixedAssetsDisposalsDetailsScreenState();
}

class _FixedAssetsDisposalsDetailsScreenState
    extends State<FixedAssetsDisposalsDetailsScreen> {
  void _onRetry(BuildContext context) {
    final requestId = context.arguments as String? ?? '';

    context.read<FixedAssetsDisposalsDetailsCubit>().getDisposalsDetails(
      requestId: requestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const TransferDetailsHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child:
                  BlocBuilder<
                    FixedAssetsDisposalsDetailsCubit,
                    FixedAssetsDisposalsDetailsState
                  >(
                    builder: (context, state) {
                      if (state is FixedAssetsDisposalsDetailsLoading) {
                        return const AppLoadingWidget();
                      } else if (state is FixedAssetsDisposalsDetailsFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          onRetry: () => _onRetry(context),
                          withBorder: false,
                        );
                      } else if (state is FixedAssetsDisposalsDetailsSuccess) {
                        final details = state.details;

                        return Column(
                          children: [
                            const TransferTabSelector(),
                            12.verticalSpace,
                            Expanded(
                              child:
                                  BlocSelector<PagingCubit, PagingState, int>(
                                    selector: (state) => state.currentIndex,
                                    builder: (context, currentIndex) {
                                      return IndexedStack(
                                        index: currentIndex,
                                        children: [
                                          FixedAssetsTransferDetailsView(
                                            details: details,
                                          ),
                                          TimeLinesView(
                                            timelines:
                                                details.timelines.timelines,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            ),
                          ],
                        );
                      }

                      return AppLocalFailure(
                        onRetry: () => _onRetry(context),
                        withBorder: false,
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class FixedAssetsTransferDetailsView extends StatelessWidget {
  const FixedAssetsTransferDetailsView({super.key, required this.details});

  final FixedAssetsDisposalsDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          details.requestDetails.status.buildDisposalStatusWidget(
            context,
            approvedOn: details.requestDetails.approvedOn,
          ),
          12.verticalSpace,
          RequestDetailsSection(details: details.requestDetails),
          12.verticalSpace,
          AssetListSection(details: details),
          12.verticalSpace,
          const AcknowledgmentsSection(),
        ],
      ),
    );
  }
}

class TransferDetailsHeader extends StatelessWidget {
  const TransferDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          const AppBackButton(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.finalDisposalDetails,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text6,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.tr.viewDetailsTimelinesAndStatuses,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text4.withValues(alpha: 0.8),
                    letterSpacing: -0.32.f,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransferTabSelector extends StatelessWidget {
  const TransferTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = [context.tr.details, context.tr.timelines];

    return ContainerCustomTextField(
      padding: EdgeInsets.all(6.r),
      borderRadius: BorderRadius.circular(1000.r),
      backgroundColor: context.customColor.text2,
      child: Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: BlocSelector<PagingCubit, PagingState, bool>(
              selector: (state) {
                return state.currentIndex == index;
              },
              builder: (context, state) {
                return CustomTextButton(
                  text: texts[index],
                  onTap: () {
                    context.read<PagingCubit>().goToStep(index);
                  },
                  backgroundColor: state
                      ? context.customColor.reversedTextColor
                      : Colors.transparent,
                  borderRadius: 1000.r,
                  borderColor: Colors.transparent,
                  textColor: state
                      ? context.customColor.text1
                      : context.customColor.text3,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RequestDetailsSection extends StatelessWidget {
  const RequestDetailsSection({super.key, required this.details});

  final FixedAssetsDisposalsRequestDetails details;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.text2),
      ),
      padding: EdgeInsets.all(17.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.requestDetailsTitle,
            style: AppStyles.s16W600.copyWith(
              color: context.customColor.text1,
              letterSpacing: 0.32.f,
            ),
          ),
          8.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(17.r),
            child: Column(
              children: [
                DetailRow(
                  label: context.tr.type,
                  value: context.tr.finalDisposal,
                ),
                const AppDivider(),
                DetailRow(
                  label: context.tr.proposedDisposalDate,
                  value: details.proposedDate,
                ),
                const AppDivider(),
                DetailRow(
                  label: context.tr.proposedDisposalTime,
                  value: details.proposedTime,
                ),
                const AppDivider(),
                DetailRow(
                  label: context.tr.disposalMethod,
                  value: details.disposalMethod,
                ),
                const AppDivider(),
                DetailRow(
                  label: context.tr.selectedAssets,
                  value: '${details.selectedAssets} ${context.tr.assets}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? customValueWidget;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.customValueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.5.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text4,
                letterSpacing: 0.32.f,
              ),
            ),
          ),
          8.horizontalSpace,
          Flexible(
            child:
                customValueWidget ??
                Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text6,
                  ),
                  textAlign: TextAlign.right,
                ),
          ),
        ],
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  const StatusRow({super.key, required this.statusLabel});

  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.tr.status,
            style: AppStyles.s13W400.copyWith(
              color: context.customColor.text4,
              letterSpacing: 0.32.f,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 5.r),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: context.customColor.text2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusLabel,
                style: AppStyles.s10W500.copyWith(color: AppColors.darkGreen),
              ),
              6.horizontalSpace,
              Icon(Icons.check, size: 12.r, color: AppColors.darkGreen),
            ],
          ),
        ),
      ],
    );
  }
}

class AssetListSection extends StatelessWidget {
  const AssetListSection({super.key, required this.details});

  final FixedAssetsDisposalsDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(9.r),
            child: Text(
              context.tr.assetListCount(details.assets.length),
              style: AppStyles.s16W600.copyWith(
                color: context.customColor.text6,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final asset = details.assets[index];

              return Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: context.customColor.text2),
                ),
                margin: EdgeInsets.all(
                  index < details.assets.length - 1 ? 8.r : 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(17.r),
                  child: Column(
                    children: [
                      AssetHeader(asset: asset),
                      8.verticalSpace,
                      const AppDivider(),
                      8.verticalSpace,
                      AssetDetails(asset: asset),
                      8.verticalSpace,
                      TransferReasonCard(reason: asset.transferReason),
                      8.verticalSpace,
                      AttachmentPreview(attachmentUrl: asset.imageUrl),
                    ],
                  ),
                ),
              );
            },
            itemCount: details.assets.length,
          ),
        ],
      ),
    );
  }
}

class AssetHeader extends StatelessWidget {
  const AssetHeader({super.key, required this.asset});

  final FixedAssetsDisposalsAsset asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppNetworkImage(
          image: asset.imageUrl,
          borderRadius: BorderRadius.circular(12.r),
          height: 85.r,
          width: 85.r,
        ),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.name,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text6,
                  letterSpacing: 0.32.f,
                ),
              ),
              4.verticalSpace,
              Text(
                asset.code,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text4,
                  letterSpacing: 0.32.f,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AssetDetails extends StatelessWidget {
  const AssetDetails({super.key, required this.asset});

  final FixedAssetsDisposalsAsset asset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailRow(label: context.tr.zone, value: asset.zone.name),
        const AppDivider(),
        DetailRow(label: context.tr.type, value: asset.type.name),
        const AppDivider(),
        DetailRow(label: context.tr.status, value: asset.status.label(context)),
        const AppDivider(),
        ValueRow(value: asset.value),
        const AppDivider(),
        DetailRow(label: context.tr.custody, value: asset.custody),
      ],
    );
  }
}

class ValueRow extends StatelessWidget {
  const ValueRow({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.5.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.value,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text4,
                letterSpacing: 0.32.f,
              ),
            ),
          ),
          Row(
            children: [
              const SaudiRiyalSvgWidget(),
              2.horizontalSpace,
              Text(
                value,
                style: AppStyles.s13WB.copyWith(
                  color: context.customColor.text6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransferReasonCard extends StatelessWidget {
  const TransferReasonCard({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text5,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 17.r, vertical: 13.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.transferReason,
            style: AppStyles.s14W600.copyWith(
              color: context.customColor.text3,
              letterSpacing: 0.32.f,
            ),
          ),
          4.verticalSpace,
          Text(
            reason,
            style: AppStyles.s14W400.copyWith(
              color: context.customColor.text6,
              letterSpacing: -0.32.f,
            ),
          ),
        ],
      ),
    );
  }
}

class AttachmentPreview extends StatelessWidget {
  const AttachmentPreview({super.key, required this.attachmentUrl});

  final String attachmentUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.attachmentCount(1),
          style: AppStyles.s14W400.copyWith(
            color: context.customColor.text3,
            letterSpacing: 0.32.f,
          ),
        ),
        4.verticalSpace,
        AppNetworkImage(
          image: attachmentUrl,
          borderRadius: BorderRadius.circular(8.r),
          height: 176.h,
          width: double.infinity,
        ),
      ],
    );
  }
}

class AcknowledgmentsSection extends StatelessWidget {
  const AcknowledgmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.r),
            child: Text(
              context.tr.acknowledgments,
              style: AppStyles.s16W600.copyWith(
                color: context.customColor.text6,
              ),
            ),
          ),
          8.verticalSpace,
          AcknowledgmentItem(
            text: context.tr.iAcknowledgeTransferPolicy,
            value: true,
          ),
          AcknowledgmentItem(
            text: context.tr.coordinatedWithReceivingBranch,
            value: true,
          ),
        ],
      ),
    );
  }
}

class AcknowledgmentItem extends StatelessWidget {
  final String text;
  final bool value;

  const AcknowledgmentItem({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: context.customColor.text5,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.customColor.text2),
      ),
      padding: EdgeInsets.all(9.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text4,
                letterSpacing: 0.32.f,
              ),
            ),
          ),
          Icon(
            Icons.check,
            size: 12.r,
            color: value ? AppColors.primaryLight : context.customColor.text3,
          ),
        ],
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.customColor.text2,
      height: 1.r,
      thickness: 0.5.r,
    );
  }
}
