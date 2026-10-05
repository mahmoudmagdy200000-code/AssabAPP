import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/di/dependency_injection.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/routing/app_route_name.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/utils/app_dialog.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/app_svg.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../../logic/shifts/handover/handover_cubit.dart';
import '../arguments/shift_arguments.dart';
import '../widgets/add_cashier/details_summarize_widget.dart';
import '../widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../widgets/end_shift_widgets/hand_over_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/shift_management_from_app_bar.dart';

class HandoverOnlyScreen extends StatefulWidget {
  const HandoverOnlyScreen({
    super.key,
    required this.shiftArguments,
    this.isOpenedFromShiftDetailsScreen = false,
    // required this.isNavigatedFromCashier
  });

  final ShiftArguments shiftArguments;
  final bool isOpenedFromShiftDetailsScreen;

  @override
  State<HandoverOnlyScreen> createState() => _HandoverOnlyScreenState();
}

class _HandoverOnlyScreenState extends State<HandoverOnlyScreen> {
  late final TextEditingController _handoverAmountController;
  late final TextEditingController _handoverNoteController;

  @override
  void initState() {
    super.initState();
    _handoverAmountController = TextEditingController();
    _handoverNoteController = TextEditingController();
  }

  @override
  void dispose() {
    _handoverAmountController.dispose();
    _handoverNoteController.dispose();
    super.dispose();
  }

  void _changeView(BuildContext context) {
    context.read<PagingCubit>().nextStep();
  }

  void _goBackView(BuildContext context) {
    context.read<PagingCubit>().previousStep();
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
    _goBackView(context);
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    _changeView(context);

    if (currentIndex == 1) {
      context.read<HandoverCubit>().handOver(
        handOverAmount:
            double.tryParse(
              context
                      .read<ValidationCubit>()
                      .state
                      .fieldsValue['handOverAmount'] ??
                  '0',
            ) ??
            0,
        note: context.read<ValidationCubit>().state.fieldsValue['notes'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ShiftManagementFromAppBar(text: context.tr.endShiftAndHandover),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: AppPaddingWidget(
                child: Column(
                  children: [
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, state) {
                        final steps = [context.tr.handover, context.tr.summary];
                        return ReassignShiftTopSection(titles: steps);
                      },
                    ),
                    14.verticalSpace,
                    Expanded(
                      child: BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;

                          final steps = <Widget>[
                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => getIt<ChooseItemCubit>(),
                                ),
                              ],
                              child: HandOverWidget(
                                handOverAmountController:
                                    _handoverAmountController,
                                handoverNoteController: _handoverNoteController,
                                totalSales:
                                    widget.shiftArguments.totalSales ?? 0,
                              ),
                            ),

                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.reviewBeforeProceed,
                                    style: AppStyles.s20W500,
                                  ),
                                  2.verticalSpace,
                                  Text(
                                    context.tr.reviewBeforeProceedReassignDesc,
                                    style: AppStyles.s14W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                  7.verticalSpace,
                                  const CustomDivider(),

                                  // if(widget!=null)
                                  //   widget!,
                                  15.verticalSpace,
                                  SummarizeCardWidget(
                                    height: 290.h,
                                    columnSpacing: 15.h,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGray,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              context.tr.totalSales,
                                              style: AppStyles.s16W600,
                                            ),
                                            10.verticalSpace,

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppSvg(
                                                  assetName:
                                                      AppAssets.saudiRiyal,
                                                  width: 30.w,
                                                  height: 25.h,
                                                ),
                                                4.horizontalSpace,
                                                Text(
                                                  (widget
                                                              .shiftArguments
                                                              .totalSales ??
                                                          0)
                                                      .toString(),
                                                  style: AppStyles.s16W600,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      2.verticalSpace,

                                      Text(
                                        context.tr.salesBreakDown,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),

                                      SizedBox(
                                        width: 250.w,
                                        child: const CustomDivider(),
                                      ),

                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.cash,
                                        title: context.tr.cashCollected,
                                        value:
                                            (widget
                                                        .shiftArguments
                                                        .cashCollected ??
                                                    0)
                                                .toStringAsFixed(2),
                                        firstValueSvgAsset:
                                            AppAssets.saudiRiyal,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),

                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.cash,
                                        title: context.tr.cardPayment,
                                        value:
                                            (widget
                                                        .shiftArguments
                                                        .cardPayment ??
                                                    0)
                                                .toStringAsFixed(2),
                                        firstValueSvgAsset:
                                            AppAssets.saudiRiyal,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),

                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.cash,
                                        title: context.tr.deliveryApps,
                                        value:
                                            (widget
                                                        .shiftArguments
                                                        .deliveryApps ??
                                                    0)
                                                .toStringAsFixed(2),
                                        firstValueSvgAsset:
                                            AppAssets.saudiRiyal,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),
                                    ],
                                  ),

                                  10.verticalSpace,

                                  SummarizeCardWidget(
                                    height: 180.h,
                                    children: [
                                      5.verticalSpace,
                                      Text(
                                        context.tr.handoverDetails,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      const CustomDivider(),
                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.cash,
                                        value:
                                            (double.tryParse(
                                                      _handoverAmountController
                                                          .text,
                                                    ) ??
                                                    0)
                                                .toStringAsFixed(2),
                                        title: context.tr.handOverAmount,
                                        firstValueSvgAsset:
                                            AppAssets.saudiRiyal,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),

                                      const CustomDivider(),
                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.cash,
                                        value:
                                            (widget.shiftArguments.variance ??
                                                    0)
                                                .toStringAsFixed(2),
                                        title: context.tr.variance,
                                        firstValueSvgAsset:
                                            AppAssets.saudiRiyal,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),

                                      const CustomDivider(),
                                      buildShiftCardRowWidget(
                                        context: context,
                                        firstTitleSvgAsset: AppAssets.personSvg,
                                        value:
                                            context
                                                .read<ValidationCubit>()
                                                .state
                                                .fieldsValue['cashierName'] ??
                                            context.tr.no_name,
                                        title: context.tr.handoverTo,
                                        hasSpaceBetweenTitleAndValue: true,
                                      ),
                                    ],
                                  ),

                                  10.verticalSpace,
                                ],
                              ),
                            ),
                          ];

                          return IndexedStack(
                            index: currentIndex,
                            children: steps,
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, pagingState) {
                        final currentIndex = pagingState.currentIndex;

                        return Row(
                          children: [
                            if (currentIndex == 1)
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.back,
                                  onTap: () {
                                    _onBackButtonPressed(context, currentIndex);
                                  },
                                  textColor: context.customColor.text1,
                                  borderRadius: 1000.r,
                                  padding: EdgeInsets.symmetric(vertical: 17.r),
                                ),
                              ),

                            Expanded(
                              child: BlocConsumer<HandoverCubit, HandoverState>(
                                listener: (context, state) {
                                  if (state is RecordingHandoverFailure) {
                                    AppDialog.showErrorDialog(
                                      context: context,
                                      failure: state.failure,
                                    );
                                  } else if (state
                                      is RecordingHandoverSuccess) {
                                    NavigationService.I.replaceWithNamed(
                                      AppRouteName.handoverSuccessScreen,
                                      arguments: {
                                        'shiftArguments': widget.shiftArguments,
                                        'isOpenedFromShiftDetailsScreen':
                                            widget
                                                .isOpenedFromShiftDetailsScreen ??
                                            false,
                                      },
                                      result: true,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is RecordingHandoverLoading) {
                                    return const AppButtonLoading();
                                  }
                                  return BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    bool
                                  >(
                                    selector: (state) => pagingState.isLastStep
                                        ? true
                                        : state.enableButton,
                                    builder: (context, enableButton) {
                                      return AppButton(
                                        onClick: () => _onNextButtonPressed(
                                          context,
                                          currentIndex,
                                        ),
                                        enabled: enableButton,
                                        text: currentIndex == 0
                                            ? context.tr.next
                                            : context.tr.confirm,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
