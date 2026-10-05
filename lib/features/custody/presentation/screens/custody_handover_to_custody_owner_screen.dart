import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/custody/presentation/cubit/custody_create_request/custody_create_request_cubit.dart';
import 'package:assab/features/custody/presentation/cubit/custody_create_request/custody_create_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/custody_create_request_transfer_request_model.dart';
import '../cubit/custody_get_personal_balance_only/custody_get_personal_balance_only_cubit.dart';
import '../cubit/custody_get_personal_balance_only/custody_get_personal_balance_only_state.dart';
import 'custody_transfer_completed_screen.dart';

class CustodyHandoverToCustodyOwnerScreen extends StatefulWidget {
  const CustodyHandoverToCustodyOwnerScreen({super.key});

  @override
  State<CustodyHandoverToCustodyOwnerScreen> createState() =>
      _CustodyHandoverToCustodyOwnerScreenState();
}

class _CustodyHandoverToCustodyOwnerScreenState
    extends State<CustodyHandoverToCustodyOwnerScreen> {
  late final TextEditingController _transferAmountController;

  @override
  void initState() {
    super.initState();

    _transferAmountController = TextEditingController();

    _getPersonalBalanceOnly();
  }

  @override
  void dispose() {
    _transferAmountController.dispose();
    super.dispose();
  }

  void _getPersonalBalanceOnly() {
    context.read<CustodyGetPersonalBalanceOnlyCubit>().getPersonalBalanceOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 40.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.cashTransferToCustody,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .transferFromYourPersonalCustodyToTheBranchCustodyTo,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  12.verticalSpace,
                  const CustomDivider(),
                  24.verticalSpace,
                  LabelTextField(text: context.tr.transferAmount),
                  BlocBuilder<
                    CustodyGetPersonalBalanceOnlyCubit,
                    CustodyGetPersonalBalanceOnlyState
                  >(
                    builder: (context, state) {
                      double personalBalance = 0;

                      if (state is CustodyGetPersonalBalanceOnlyLoading) {
                        return const AppLoadingWidget();
                      } else if (state
                          is CustodyGetPersonalBalanceOnlyFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          onRetry: _getPersonalBalanceOnly,
                        );
                      } else if (state
                          is CustodyGetPersonalBalanceOnlySuccess) {
                        personalBalance = state.balance;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            left: BorderSide(color: context.customColor.border),
                            right: BorderSide(
                              color: context.customColor.border,
                            ),
                            bottom: BorderSide(
                              color: context.customColor.border,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            ContainerCustomTextField(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _transferAmountController,
                                      hintText: '0',
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        context
                                            .read<ValidationCubit>()
                                            .validateFieldAndStoreValue(
                                              fieldName: 'transferAmount',
                                              value: value,
                                              isValid:
                                                  value.isNotEmpty &&
                                                  double.tryParse(value) !=
                                                      null &&
                                                  double.parse(value) > 0,
                                            );
                                      },
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  const SaudiRiyalSvgWidget(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 21.r,
                                vertical: 13.r,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr.personalCustodyBalance,
                                          style: AppStyles.s12W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                        8.verticalSpace,
                                        Row(
                                          children: [
                                            const SaudiRiyalSvgWidget(),
                                            Text(
                                              personalBalance.toStringAsFixed(
                                                2,
                                              ),
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  AppGestureDetectorButton(
                                    onTap: () {
                                      _transferAmountController.text =
                                          personalBalance.toStringAsFixed(2);

                                      context
                                          .read<ValidationCubit>()
                                          .validateFieldAndStoreValue(
                                            fieldName: 'transferAmount',
                                            value:
                                                _transferAmountController.text,
                                            isValid: personalBalance > 0,
                                          );
                                    },
                                    child: Text(
                                      context.tr.transferAll,
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocConsumer<CustodyCreateRequestCubit, CustodyCreateRequestState>(
              listener: (context, state) {
                if (state is CustodyCreateRequestSuccess) {
                  NavigationService.I.pop();
                  AppBottomSheet.pageRoute(
                    context,
                    (context) => const CustodyTransferCompletedScreen(),
                  );
                } else if (state is CustodyCreateRequestFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is CustodyCreateRequestLoading) {
                  return const AppButtonLoading();
                }

                return Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.cancel,
                        onTap: () {
                          NavigationService.I.pop();
                        },
                        textColor: context.customColor.text1,
                        padding: EdgeInsets.symmetric(vertical: 18.r),
                        borderRadius: 1000.r,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: BlocSelector<ValidationCubit, ValidationState, bool>(
                        selector: (state) => state.enableButton,
                        builder: (context, state) {
                          return AppButton(
                            onClick: () {
                              context
                                  .read<CustodyCreateRequestCubit>()
                                  .createTransferRequest(
                                    requestModel:
                                        CustodyCreateRequestTransferRequestModel(
                                          transferAmount:
                                              double.tryParse(
                                                context
                                                    .read<ValidationCubit>()
                                                    .getFieldValue(
                                                      'transferAmount',
                                                    ),
                                              ) ??
                                              0,
                                        ),
                                  );
                            },
                            text: context.tr.transfer,
                            enabled: state,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
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
    );
  }
}
