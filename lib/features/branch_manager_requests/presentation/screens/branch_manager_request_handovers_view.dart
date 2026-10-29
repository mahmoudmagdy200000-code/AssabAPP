import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/branch_manager_requests/data/models/handovers_response.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import '../../../shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/reject_handover_widgets/reject_handover_modal_sheet_widget.dart';
import '../cubit/get_handovers/get_handovers_cubit.dart';
import '../cubit/get_handovers/get_handovers_state.dart';
import '../formatters/variance_time_format.dart';
import '../widgets/accept_handover_sheet_widget.dart';
import '../widgets/branch_manager_requests_empty_widget.dart';
import '../../../../core/services/user_type_service.dart';
import '../../../../core/utils/currency_normalizer.dart';
class BranchManagerRequestHandoversView extends StatefulWidget {
  const BranchManagerRequestHandoversView({
    super.key,
    this.actorRole,
  });
  final UserType? actorRole;
  @override
  State<BranchManagerRequestHandoversView> createState() =>
      _BranchManagerRequestHandoversViewState();
}
class _BranchManagerRequestHandoversViewState
    extends State<BranchManagerRequestHandoversView> {
  late final ScrollController _scrollController;
  UserType? get _effectiveRole =>
      widget.actorRole ??
      UserTypeService.selectedUserType ??
      UserTypeService.getSavedUserType();
  @override
  void initState() {
    super.initState();
    _getHandovers();
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
      if (context.read<GetHandoversCubit>().paginator.hasMore) {
        _getHandovers(loadMore: true);
      }
    }
  }
  void _getHandovers({bool loadMore = false}) {
    context.read<GetHandoversCubit>().getHandovers(loadMore: loadMore);
  }
  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      bottom: 0,
      child: BlocBuilder<GetHandoversCubit, GetHandoversState>(
        builder: (context, state) {
          final orders = <HandoversResponseItem>[];
          if (state is GetHandoversLoading) {
            return const AppLoadingWidget();
          } else if (state is GetHandoversFailure) {
            return AppFailureWidget(
              failure: state.failure,
              onRetry: _getHandovers,
              withBorder: false,
            );
          } else if (state is GetHandoversSuccess) {
            orders.addAll(state.handovers);
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'count_handover',
              value: orders.length.toString(),
              isValid: true,
            );
          }
          if (orders.isEmpty) {
            return BranchManagerRequestsEmptyWidget(
              onRefresh: _getHandovers,
              message: context.tr.noHandovers,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _getHandovers(),
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
                      Text(
                        context.tr.openingBalance_o,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.cash,
                        title: context.tr.cashGiven,
                        value: orders[index].cashGiven == null ? '-' : CurrencyNormalizer.formatSar(orders[index].cashGiven!),
                        isCurrancy: true,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.cash,
                        title: context.tr.variance,
                        value: orders[index].variance.toString(),
                        isCurrancy: true,
                      ),
                      _buildRowItem(
                        context: context,
                        asset: AppAssets.personSvg,
                        title: context.tr.cashFrom,
                        value: orders[index].cashFrom,
                      ),
                      if (orders[index].status != HandoverStatus.pending)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(12.r),
                          child: Text(
                            orders[index].status.handoverRequestsTextDesc(
                              formatDateWithTime(
                                orders[index].responsibilityReviewedAt,
                              ),
                            ),
                            style: AppStyles.s14W400.copyWith(
                              color: orders[index].status.textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (orders[index].status == HandoverStatus.pending)
                        if (orders[index].canBeAccepted == true)
                          Row(
                            spacing: 12.w,
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.rejectHandover,
                                  onTap: () {
                                    AppBottomSheet.showModal(
                                      context,
                                      (sheetContext) => BlocProvider(
                                        create: (sheetContext) =>
                                            getIt<
                                              ApproveAndRejectHandoverCubit
                                            >(),
                                        child: RejectHandoverModalSheetWidget(
                                          shiftId: orders[index].id,
                                          isFromRequestsScreen: true,
                                          actorRole: _effectiveRole,
                                          successFunction: () {
                                            _getHandovers(loadMore: false);
                                          },
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    );
                                  },
                                  backgroundColor:
                                      context.customColor.reversedTextColor,
                                  textColor: context.customColor.error,
                                  borderRadius: 1000.r,
                                  padding: EdgeInsets.symmetric(vertical: 18.r),
                                ),
                              ),
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.acceptHandover,
                                  onTap: () {
                                    AppBottomSheet.showModal(
                                      context,
                                      (sheetContext) => BlocProvider(
                                        create: (sheetContext) =>
                                            getIt<
                                              ApproveAndRejectHandoverCubit
                                            >(),
                                        child: AcceptHandoverSheetWidget(
                                          shiftId: orders[index].id,
                                          cashFrom: orders[index].cashFrom,
                                          cashGiven: orders[index].cashGiven == null ? '' : CurrencyNormalizer.formatSar(orders[index].cashGiven!),
                                          variance: orders[index].variance,
                                          actorRole: _effectiveRole,
                                          successFunction: () {
                                            _getHandovers(loadMore: false);
                                          },
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    );
                                  },
                                  backgroundColor: context.theme.primaryColor,
                                  textColor:
                                      context.customColor.reversedTextColor,
                                  borderRadius: 1000.r,
                                  padding: EdgeInsets.symmetric(vertical: 18.r),
                                ),
                              ),
                            ],
                          )
                        else if (_effectiveRole == UserType.branchManager)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              context.tr.waitingForYourApproval,
                              textAlign: TextAlign.center,
                              style: AppStyles.s13W500.copyWith(
                                color: context.customColor.text2,
                              ),
                            ),
                          ),
                      if (orders[index].status == HandoverStatus.rejected)
                        AppButton(
                          onClick: () {
                            AppBottomSheet.showModal(
                              context,
                              (sheetContext) => BlocProvider(
                                create: (sheetContext) =>
                                    getIt<ApproveAndRejectHandoverCubit>(),
                                child: AcceptHandoverSheetWidget(
                                  shiftId: orders[index].id,
                                  cashFrom: orders[index].cashFrom,
                                  cashGiven: orders[index].cashGiven == null ? '' : CurrencyNormalizer.formatSar(orders[index].cashGiven!),
                                  variance: orders[index].variance,
                                  actorRole: _effectiveRole ?? UserType.branchManager,
                                  successFunction: () {
                                    _getHandovers(loadMore: false);
                                  },
                                ),
                              ),
                              isScrollControlled: true,
                            );
                          },
                          text: context.tr.seeDetails,
                          borderRadius: BorderRadius.circular(12.r),
                          background: AppColors.lightBackground,
                          borderColor: context.customColor.border,
                          textColor: context.customColor.text1,
                          enabled: true,
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
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        8.horizontalSpace,
        if (isCurrancy) const SaudiRiyalSvgWidget(),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
