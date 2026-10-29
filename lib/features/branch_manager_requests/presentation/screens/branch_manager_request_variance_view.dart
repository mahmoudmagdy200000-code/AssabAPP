import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/mappers/responsibility_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../shift_module_features/shift_management/presentation/logic/shifts/variance/variance_cubit.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/variance/variance_details_bottom_sheet_widget.dart';
import '../../data/models/variances_response.dart';
import '../../domain/enums/responsibility_status.dart';
import '../cubit/get_variances/get_variances_cubit.dart';
import '../cubit/get_variances/get_variances_state.dart';
import '../formatters/variance_time_format.dart';
import '../widgets/branch_manager_requests_empty_widget.dart';
import '../widgets/branch_requests_status_widget.dart';
class BranchManagerRequestVarianceView extends StatefulWidget {
  const BranchManagerRequestVarianceView({super.key});
  @override
  State<BranchManagerRequestVarianceView> createState() =>
      _BranchManagerRequestVarianceViewState();
}
class _BranchManagerRequestVarianceViewState
    extends State<BranchManagerRequestVarianceView> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _getVariances();
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }
  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    super.dispose();
  }
  void _listenToScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400.r) {
      if (context.read<GetVariancesCubit>().paginator.hasMore) {
        _getVariances(loadMore: true);
      }
    }
  }
  void _getVariances({bool loadMore = false}) {
    context.read<GetVariancesCubit>().getVariances(loadMore: loadMore);
  }
  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      bottom: 0,
      child: BlocBuilder<GetVariancesCubit, GetVariancesState>(
        builder: (context, state) {
          final orders = <VarianceItem>[];
          if (state is GetVariancesLoading) {
            return const AppLoadingWidget();
          } else if (state is GetVariancesFailure) {
            return AppFailureWidget(
              failure: state.failure,
              onRetry: _getVariances,
              withBorder: false,
            );
          } else if (state is GetVariancesSuccess) {
            orders.addAll(state.variances);
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'count_variance',
              value: orders.length.toString(),
              isValid: true,
            );
          }
          if (orders.isEmpty) {
            return BranchManagerRequestsEmptyWidget(
              onRefresh: _getVariances,
              message: context.tr.noVariances,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _getVariances(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(20.r),
                  margin: EdgeInsets.only(bottom: 8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10.w,
                        children: [
                          Flexible(
                            child: Text(
                              context.tr.reasonForVariance,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          BranchRequestsStatusWidget(
                            status: orders[index].responsibilityStatus.title(
                              context,
                            ),
                            textColor: orders[index].responsibilityStatus
                                .textColor(),
                            borderColor: Colors.transparent,
                            backgroundColor:
                                context.customColor.reversedTextColor,
                          ),
                        ],
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.handOverFrom,
                        value: orders[index].handOverFrom,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.handOverTo,
                        value: orders[index].handOverTo ?? '-',
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.cash,
                        title: context.tr.cashHandoverAmount,
                        value: orders[index].cashHandoverAmount.toString(),
                        isCurrancy: true,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.cash,
                        title: context.tr.variance,
                        value: orders[index].varianceAmount.toString(),
                        isCurrancy: true,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(12.r),
                        child: Text(
                          orders[index].responsibilityStatus
                              .varianceStatusDescription(
                                context,
                                text:
                                    orders[index].responsibilityStatus ==
                                        ResponsibilityStatus.notSubmitted
                                    ? orders[index].handOverFrom
                                    : formatDateWithTime(
                                        orders[index].responsibilityReviewedAt,
                                      ),
                              ),
                          style: AppStyles.s14W400.copyWith(
                            color: orders[index].responsibilityStatus
                                .textColor(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomTextButton(
                        text: context.tr.reviewDetails,
                        onTap: () {
                          AppBottomSheet.showModal(context, (context) {
                            return BlocProvider(
                              create: (context) => getIt<VarianceCubit>(),
                              child: VarianceDetailsBottomSheetWidget(
                                handoverAmount:
                                    double.tryParse(
                                      orders[index].cashHandoverAmount
                                          .toString(),
                                    ) ??
                                    0,
                                 varianceAmount: orders[index].varianceAmount,
                                showButtons:
                                    orders[index].responsibilityStatus !=
                                    ResponsibilityStatus.approved,
                                shiftId: orders[index].id,
                                isResponsibilityRejected:
                                    orders[index].responsibilityStatus ==
                                    ResponsibilityStatus.rejected,
                                successFunction: () {
                                  _getVariances(loadMore: false);
                                },
                              ),
                            );
                          }, isScrollControlled: true);
                        },
                        backgroundColor:
                            orders[index].responsibilityStatus ==
                                ResponsibilityStatus.notSubmitted
                            ? context.theme.primaryColor
                            : AppColors.lightBackground,
                        textColor:
                            orders[index].responsibilityStatus ==
                                ResponsibilityStatus.notSubmitted
                            ? context.customColor.reversedTextColor
                            : context.customColor.text1,
                        borderRadius: 1000.r,
                        padding: EdgeInsets.symmetric(vertical: 12.r),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  Widget _buildRowItem({
    required BuildContext context,
    required String asset,
    required String title,
    required String value,
    bool isCurrancy = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              AppSvg(
                assetName: asset,
                width: 18.w,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
              Expanded(
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
        8.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCurrancy) const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
