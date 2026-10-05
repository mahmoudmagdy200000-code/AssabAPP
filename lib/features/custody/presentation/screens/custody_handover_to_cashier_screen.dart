import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/custody_handover_to_cashier_request.dart';
import '../cubit/create_handover_to_cashier/create_handover_to_cashier_cubit.dart';
import '../cubit/create_handover_to_cashier/create_handover_to_cashier_state.dart';
import '../cubit/get_custody_recipients/get_custody_recipients_cubit.dart';
import '../widgets/custody_app_bar.dart';
import '../widgets/custody_request_preferred_receipt_method_section.dart';
import 'custody_handover_to_cashier_choose_recipient_bottom_sheet_widget.dart';
import 'custody_transfer_completed_screen.dart';

class CustodyHandoverToCashierScreen extends StatefulWidget {
  const CustodyHandoverToCashierScreen({super.key});

  @override
  State<CustodyHandoverToCashierScreen> createState() =>
      _CustodyHandoverToCashierScreenState();
}

class _CustodyHandoverToCashierScreenState
    extends State<CustodyHandoverToCashierScreen> {
  // late final TextEditingController _transferAmountController;

  // @override
  // void initState() {
  //   super.initState();

  //   _transferAmountController = TextEditingController();

  //   _getPersonalBalanceOnly();
  // }

  // @override
  // void dispose() {
  //   _transferAmountController.dispose();
  //   super.dispose();
  // }

  // void _getPersonalBalanceOnly() {
  //   context.read<CustodyGetPersonalBalanceOnlyCubit>().getPersonalBalanceOnly();
  // }

  void _showCalendarBottomSheet(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(
      context,
      (context) => Expanded(
        child: AppPaddingWidget(
          top: 0,
          child: CustomCalendar(
            onDateSelected: (value) {
              NavigationService.I.pop();

              validationCubit.validateFieldAndStoreValue(
                fieldName: 'handoverDate',
                value: value.toIso8601String(),
                isValid: true,
              );
            },
          ),
        ),
      ),
    );
  }

  void _createHandover() {
    context.read<CreateHandoverToCashierCubit>().handoverToCashier(
      requestModel: CustodyHandoverToCashierRequest(
        handoverAmount:
            double.tryParse(
              context
                      .read<ValidationCubit>()
                      .state
                      .fieldsValue['handoverAmount'] ??
                  '0',
            ) ??
            0,
        handoverDate:
            context.read<ValidationCubit>().state.fieldsValue['handoverDate'] ??
            '',
        handoverMethod:
            context
                .read<ValidationCubit>()
                .state
                .fieldsValue['preferredReceiptMethod'] ??
            '',
        recipientId:
            context.read<ValidationCubit>().getTypedValue<String>(
              'handoverRecipientId',
            ) ??
            '',
        recipientType:
            context.read<ValidationCubit>().getTypedValue<String>(
              'recipientType',
            ) ??
            '',
        additionalNotes:
            context
                .read<ValidationCubit>()
                .state
                .fieldsValue['additionalNote'] ??
            '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          CustodyAppBar(title: context.tr.cashHandover),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: context.customColor.text2,
                          //     borderRadius: BorderRadius.circular(20.r),
                          //     border: Border.all(
                          //       color: context.customColor.border,
                          //     ),
                          //   ),
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 21.r,
                          //     horizontal: 21.r,
                          //   ),
                          //   child:
                          //       BlocBuilder<
                          //         CustodyGetPersonalBalanceOnlyCubit,
                          //         CustodyGetPersonalBalanceOnlyState
                          //       >(
                          //         builder: (context, state) {
                          //           double personalBalance = 0;

                          //           if (state
                          //               is CustodyGetPersonalBalanceOnlyLoading) {
                          //             return const AppLoadingWidget();
                          //           } else if (state
                          //               is CustodyGetPersonalBalanceOnlyFailure) {
                          //             return AppFailureWidget(
                          //               failure: state.failure,
                          //               onRetry: _getPersonalBalanceOnly,
                          //             );
                          //           } else if (state
                          //               is CustodyGetPersonalBalanceOnlySuccess) {
                          //             personalBalance = state.balance;
                          //           }

                          //           return Row(
                          //             children: [
                          //               Expanded(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       context
                          //                           .tr
                          //                           .personalCustodyBalance,
                          //                       style: AppStyles.s12W400
                          //                           .copyWith(
                          //                             color: context
                          //                                 .customColor
                          //                                 .text3,
                          //                           ),
                          //                     ),
                          //                     8.verticalSpace,
                          //                     Row(
                          //                       children: [
                          //                         const SaudiRiyalSvgWidget(),
                          //                         Text(
                          //                           personalBalance
                          //                               .toStringAsFixed(2),
                          //                           style: AppStyles.s14W500
                          //                               .copyWith(
                          //                                 color: context
                          //                                     .customColor
                          //                                     .text1,
                          //                               ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               10.horizontalSpace,
                          //               AppGestureDetectorButton(
                          //                 onTap: () {
                          //                   _transferAmountController.text =
                          //                       personalBalance.toStringAsFixed(
                          //                         2,
                          //                       );
                          //                 },
                          //                 child: Text(
                          //                   context.tr.transferAll,
                          //                   style: AppStyles.s12W500.copyWith(
                          //                     color: context.theme.primaryColor,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       ),
                          // ),
                          // 12.verticalSpace,
                          // const CustomDivider(),
                          // 12.verticalSpace,
                          Text(
                            context.tr.cashHandover,
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            context.tr.confirmWhoWillReceiveTheCashAndAmount,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          12.verticalSpace,
                          const CustomDivider(),
                          12.verticalSpace,
                          AppGestureDetectorButton(
                            onTap: () {
                              final validationCubit = context
                                  .read<ValidationCubit>();
                              final chooseItemCubit = context
                                  .read<ChooseItemCubit>();

                              chooseItemCubit.initTempSelection();

                              AppBottomSheet.pageRoute(
                                context,
                                (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          getIt<GetCustodyRecipientsCubit>(),
                                    ),
                                    BlocProvider.value(value: validationCubit),
                                    BlocProvider.value(value: chooseItemCubit),
                                  ],
                                  child:
                                      const CustodyHandoverToCashierChooseRecipientBottomSheetWidget(),
                                ),
                              );
                            },
                            child: ContainerCustomTextField(
                              label: context.tr.handoverRecipient,
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String?
                                        >(
                                          selector: (state) =>
                                              state.getTypedValue<String>(
                                                'handoverRecipientName',
                                              ),
                                          builder: (context, state) {
                                            return Text(
                                              state ??
                                                  context
                                                      .tr
                                                      .whoAreYouHandingOverTo,
                                              style: AppStyles.s14W400.copyWith(
                                                color: state == null
                                                    ? context.customColor.text3
                                                    : context.customColor.text1,
                                                fontWeight: state == null
                                                    ? FontWeight.w400
                                                    : FontWeight.w500,
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16.r,
                                    color: context.customColor.text1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.handoverAmount,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    // controller: _transferAmountController,
                                    hintText: context.tr.amount,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      context
                                          .read<ValidationCubit>()
                                          .validateFieldAndStoreValue(
                                            fieldName: 'handoverAmount',
                                            value: value,
                                            isValid:
                                                double.tryParse(value) !=
                                                    null &&
                                                double.tryParse(value)! > 0,
                                          );
                                    },
                                  ),
                                ),
                                10.horizontalSpace,
                                const SaudiRiyalSvgWidget(),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                          CustodyRequestPreferredReceiptMethodSection(
                            title: context.tr.handoverMethod,
                          ),
                          16.verticalSpace,
                          AppGestureDetectorButton(
                            onTap: () => _showCalendarBottomSheet(context),
                            child: ContainerCustomTextField(
                              label: context.tr.handoverDate,
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String?
                                        >(
                                          selector: (state) {
                                            return state
                                                .fieldsValue['handoverDate'];
                                          },
                                          builder: (context, state) {
                                            return Text(
                                              DateFormatter.formatDateMDY(
                                                    DateTime.tryParse(
                                                      state ?? '',
                                                    ),
                                                  ) ??
                                                  context.tr.choose,
                                              style: AppStyles.s12W400.copyWith(
                                                color: state == null
                                                    ? context.customColor.text3
                                                    : context.customColor.text1,
                                                fontWeight: state == null
                                                    ? FontWeight.w400
                                                    : FontWeight.w500,
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16.r,
                                    color: context.customColor.text1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.additionalNote,
                            isLabelRequired: false,
                            isLabelOptional: true,
                            child: CustomTextField(
                              hintText: context.tr.optionalNotes,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'additionalNote',
                                      value: value,
                                      isValid: value.isNotEmpty,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<
                    CreateHandoverToCashierCubit,
                    CreateHandoverToCashierState
                  >(
                    listener: (context, state) {
                      if (state is CreateHandoverToCashierSuccess) {
                        NavigationService.I.pop();

                        AppBottomSheet.pageRoute(
                          context,
                          (context) => CustodyTransferCompletedScreen(
                            onClickSeeDetails: () {
                              NavigationService.I.pop();
                              NavigationService.I.pop();

                              // NavigationService.I.pushNamed(
                              //   AppRouteName
                              //       .custodyHandoverToCashierDetailsScreen,
                              // );
                            },
                          ),
                        );
                      } else if (state is CreateHandoverToCashierFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CreateHandoverToCashierLoading) {
                        return const AppButtonLoading();
                      }

                      return BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        bool
                      >(
                        selector: (state) => state.enableButton,
                        builder: (context, state) {
                          return AppButton(
                            onClick: () {
                              _createHandover();
                            },
                            enabled: state,
                            text: context.tr.confirmHandover,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
