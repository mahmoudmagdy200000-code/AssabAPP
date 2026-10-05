import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/fixed_assets_active_handover_session_details_response.dart';
import '../../data/models/fixed_assets_active_handover_session_preview_response.dart';
import '../cubit/confirm_active_handover_signature/confirm_active_handover_signature_cubit.dart';
import '../cubit/confirm_active_handover_signature/confirm_active_handover_signature_state.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_cubit.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_state.dart';
import '../cubit/get_active_handover_session_preview_assets/get_active_handover_session_preview_assets_cubit.dart';
import '../cubit/get_active_handover_session_preview_assets/get_active_handover_session_preview_assets_state.dart';
import '../cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';

class FixedAssetsActiveHandoverSessionPreviewAssetsView extends StatefulWidget {
  final String sessionId;

  const FixedAssetsActiveHandoverSessionPreviewAssetsView({
    super.key,
    required this.sessionId,
  });

  @override
  State<FixedAssetsActiveHandoverSessionPreviewAssetsView> createState() =>
      _FixedAssetsActiveHandoverSessionPreviewAssetsViewState();
}

class _FixedAssetsActiveHandoverSessionPreviewAssetsViewState
    extends State<FixedAssetsActiveHandoverSessionPreviewAssetsView>
    with TickerProviderStateMixin {
  bool _acceptedExpanded = false;
  bool _noteExpanded = false;
  bool _rejectedExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final previewState = context
        .read<GetActiveHandoverSessionPreviewAssetsCubit>()
        .state;
    if (previewState is GetActiveHandoverSessionPreviewAssetsInit) {
      _loadPreviewAssets(context);
    }
  }

  void _loadPreviewAssets(BuildContext context) {
    final detailsState = context
        .read<GetActiveHandoverSessionDetailsCubit>()
        .state;

    if (detailsState is GetActiveHandoverSessionDetailsSuccess &&
        _areAllZonesApproved(detailsState.response)) {
      context
          .read<GetActiveHandoverSessionPreviewAssetsCubit>()
          .getPreviewAssets(sessionId: detailsState.response.sessionId);
    }
  }

  bool _areAllZonesApproved(
    FixedAssetsActiveHandoverSessionDetailsResponse response,
  ) {
    return response.zones.isNotEmpty &&
        response.zones.every((zone) => zone.isZoneApproved);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      ConfirmActiveHandoverSignatureCubit,
      ConfirmActiveHandoverSignatureState
    >(
      listener: (context, state) {
        if (state is ConfirmActiveHandoverSignatureSuccess) {
          _loadPreviewAssets(context);

          context
              .read<GetActiveHandoverSessionSignatureCubit>()
              .getActiveHandoverSessionSignature(sessionId: widget.sessionId);

          context.read<PagingCubit>().nextStep();
        } else if (state is ConfirmActiveHandoverSignatureFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocListener<
            GetActiveHandoverSessionDetailsCubit,
            GetActiveHandoverSessionDetailsState
          >(
            listenWhen: (previous, current) {
              if (current is! GetActiveHandoverSessionDetailsSuccess) {
                return false;
              }

              if (previous is! GetActiveHandoverSessionDetailsSuccess) {
                return _areAllZonesApproved(current.response);
              }

              final wasApproved = _areAllZonesApproved(previous.response);
              final isApproved = _areAllZonesApproved(current.response);
              return !wasApproved && isApproved;
            },
            listener: (context, state) {
              if (state is GetActiveHandoverSessionDetailsSuccess) {
                _loadPreviewAssets(context);
              }
            },
            child:
                BlocBuilder<
                  GetActiveHandoverSessionPreviewAssetsCubit,
                  GetActiveHandoverSessionPreviewAssetsState
                >(
                  builder: (context, state) {
                    final detailsState = context
                        .read<GetActiveHandoverSessionDetailsCubit>()
                        .state;
                    if (detailsState
                            is GetActiveHandoverSessionDetailsSuccess &&
                        !_areAllZonesApproved(detailsState.response)) {
                      return const SizedBox.shrink();
                    }

                    if (state is GetActiveHandoverSessionPreviewAssetsLoading) {
                      return const AppLoadingWidget();
                    }

                    if (state is GetActiveHandoverSessionPreviewAssetsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        onRetry: () => _loadPreviewAssets(context),
                      );
                    }

                    if (state
                        is! GetActiveHandoverSessionPreviewAssetsSuccess) {
                      return AppLocalFailure(
                        onRetry: () => _loadPreviewAssets(context),
                      );
                    }

                    return _buildPreviewContent(
                      context,
                      response: state.response,
                    );
                  },
                ),
          ),
    );
  }

  Widget _buildPreviewContent(
    BuildContext context, {
    required FixedAssetsActiveHandoverSessionPreviewResponse response,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.progressMap,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.r,
                          crossAxisSpacing: 8.r,
                          childAspectRatio: 3.5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: response.progressItems.length,
                        itemBuilder: (context, index) {
                          final item = response.progressItems[index];

                          return _buildProgressItem(
                            context,
                            label: index == response.progressItems.length - 1
                                ? context.tr.total
                                : item.label,
                            percent: item.percent,
                          );
                        },
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '${context.tr.time}: ',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                              children: [
                                TextSpan(
                                  text: response.timeSpent,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          5.horizontalSpace,
                          RichText(
                            text: TextSpan(
                              text: '${context.tr.remaining}: ',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                              children: [
                                TextSpan(
                                  text: '(${response.remainingPercent}%)',
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  context.tr.handoverSummary,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: context.customColor.text2,
                  ),
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.h,
                    children: [
                      _buildSummaryCard(
                        context,
                        title: context.tr.totalAssets,
                        value: response.totalAssets.toString(),
                      ),
                      _buildExpandableSummaryCard(
                        context,
                        title: context.tr.numberAcceptedAssets,
                        count: response.acceptedAssets,
                        isExpanded: _acceptedExpanded,
                        onToggle: () {
                          setState(() {
                            _acceptedExpanded = !_acceptedExpanded;
                          });
                        },
                        items: response.acceptedList,
                      ),
                      _buildExpandableSummaryCard(
                        context,
                        title: context.tr.numberNoteAssets,
                        count: response.noteAssets,
                        isExpanded: _noteExpanded,
                        onToggle: () {
                          setState(() {
                            _noteExpanded = !_noteExpanded;
                          });
                        },
                        items: response.noteList,
                      ),
                      _buildExpandableSummaryCard(
                        context,
                        title: context.tr.numberRejectedAssets,
                        count: response.rejectedAssets,
                        isExpanded: _rejectedExpanded,
                        onToggle: () {
                          setState(() {
                            _rejectedExpanded = !_rejectedExpanded;
                          });
                        },
                        items: response.rejectedList,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: CustomTextButton(
                text: context.tr.back,
                onTap: () {
                  context.read<PagingCubit>().previousStep();
                },
                borderRadius: 1000.r,
                padding: EdgeInsets.symmetric(vertical: 14.r),
                textColor: context.customColor.text1,
              ),
            ),
            Expanded(
              child:
                  BlocBuilder<
                    ConfirmActiveHandoverSignatureCubit,
                    ConfirmActiveHandoverSignatureState
                  >(
                    builder: (context, confirmState) {
                      if (confirmState
                          is ConfirmActiveHandoverSignatureLoading) {
                        return const AppButtonLoading();
                      }

                      return CustomTextButton(
                        text: context.tr.signatureAndConfirmation,
                        onTap: () {
                          if (!response.iAmSigned) {
                            context
                                .read<ConfirmActiveHandoverSignatureCubit>()
                                .confirmActiveHandoverSessionSignatureReceiver(
                                  sessionId: widget.sessionId,
                                );
                          } else {
                            context
                                .read<GetActiveHandoverSessionSignatureCubit>()
                                .getActiveHandoverSessionSignature(
                                  sessionId: widget.sessionId,
                                );
                            context.read<PagingCubit>().nextStep();
                          }
                        },
                        borderRadius: 1000.r,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        textColor: context.customColor.reversedTextColor,
                        backgroundColor: context.theme.primaryColor,
                      );
                    },
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String label,
    required int percent,
  }) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        children: [
          TextSpan(
            text: '($percent%)',
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          Text(
            title,
            style: AppStyles.s15W400.copyWith(color: context.customColor.text3),
          ),
          10.verticalSpace,
          Text(
            value,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSummaryCard(
    BuildContext context, {
    required String title,
    required int count,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<FixedAssetsActiveHandoverPreviewAsset> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        spacing: 8.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s15W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        count.toString(),
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    10.horizontalSpace,
                    AppGestureDetectorButton(
                      onTap: onToggle,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.customColor.text2,
                        ),
                        padding: EdgeInsets.all(6.r),
                        child: AnimatedRotation(
                          turns: isExpanded ? 0 : 0.5,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.keyboard_arrow_up, size: 12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? ListView.builder(
                    itemCount: items.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildItemListView(context, items[index]);
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    required String value,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCurrency) const SaudiRiyalSvgWidget(),
              2.horizontalSpace,
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14W500.copyWith(
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

  Widget _buildItemListView(
    BuildContext context,
    FixedAssetsActiveHandoverPreviewAsset asset,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
        border: Border.all(color: context.customColor.text2, width: 5.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: AppNetworkImage(
                  image: asset.assetImageUrl,
                  height: 100.r,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.assetName,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      asset.assetCode,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      asset.zoneName,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            label: context.tr.zone,
            value: asset.zoneName,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            label: context.tr.type,
            value: asset.typeName,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            label: context.tr.value,
            value: asset.value.toString(),
            showCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context: context, label: context.tr.age, value: asset.age),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            label: context.tr.handoverDescription,
            value: asset.handoverDescription,
          ),
        ],
      ),
    );
  }
}
