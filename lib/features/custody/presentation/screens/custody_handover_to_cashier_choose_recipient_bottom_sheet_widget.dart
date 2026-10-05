import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../data/models/custody_recipients_response.dart';
import '../cubit/get_custody_recipients/get_custody_recipients_cubit.dart';
import '../cubit/get_custody_recipients/get_custody_recipients_state.dart';

class CustodyHandoverToCashierChooseRecipientBottomSheetWidget
    extends StatefulWidget {
  const CustodyHandoverToCashierChooseRecipientBottomSheetWidget({super.key});

  @override
  State<CustodyHandoverToCashierChooseRecipientBottomSheetWidget>
  createState() =>
      _CustodyHandoverToCashierChooseRecipientBottomSheetWidgetState();
}

class _CustodyHandoverToCashierChooseRecipientBottomSheetWidgetState
    extends State<CustodyHandoverToCashierChooseRecipientBottomSheetWidget> {
  @override
  void initState() {
    super.initState();

    _getRecipients();
  }

  void _getRecipients() {
    context.read<GetCustodyRecipientsCubit>().getRecipients();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.chooseRecipient,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Text(
              context.tr.thisCouldBeTheNextStoreOwnerBrandManagerOr,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            Expanded(
              child: Column(
                children: [
                  // _buildCustodyBalance(context),
                  // 12.verticalSpace,
                  Expanded(
                    child:
                        BlocBuilder<
                          GetCustodyRecipientsCubit,
                          GetCustodyRecipientsState
                        >(
                          builder: (context, state) {
                            final recipients = <CustodyRecipientData>[];

                            if (state is GetCustodyRecipientsLoading) {
                              return const AppLoadingWidget();
                            } else if (state is GetCustodyRecipientsFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: _getRecipients,
                                withBorder: false,
                              );
                            } else if (state is GetCustodyRecipientsSuccess) {
                              recipients.addAll(state.response.recipients);
                            }

                            return ListView.builder(
                              itemCount: recipients.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    BlocSelector<
                                      ChooseItemCubit,
                                      ChooseItemState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.tempSelectedIndex == index,
                                      builder: (context, state) {
                                        return _buildRecipientItem(
                                          context: context,
                                          image: AppAssets.testProfile,
                                          type: recipients[index].type,
                                          fullName: recipients[index].name,
                                          onTap: () {
                                            context
                                                .read<ChooseItemCubit>()
                                                .selectTempItem(index);
                                          },
                                          isSelected: state,
                                        );
                                      },
                                    ),
                                    if (index != recipients.length - 1)
                                      12.verticalSpace,
                                  ],
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocBuilder<GetCustodyRecipientsCubit, GetCustodyRecipientsState>(
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    final validationCubit = context.read<ValidationCubit>();
                    final selectedIndex = context
                        .read<ChooseItemCubit>()
                        .state
                        .tempSelectedIndex;

                    if (state is GetCustodyRecipientsSuccess) {
                      context.read<ChooseItemCubit>().confirmTempSelection();

                      final selectedRecipient =
                          state.response.recipients[selectedIndex!];

                      validationCubit.validateFieldAndStoreTypedValue<String>(
                        fieldName: 'handoverRecipientId',
                        value: selectedRecipient.id,
                        isValid: selectedRecipient.id.isNotEmpty,
                      );

                      validationCubit.validateFieldAndStoreTypedValue<String>(
                        fieldName: 'handoverRecipientName',
                        value: selectedRecipient.name,
                        isValid: selectedRecipient.name.isNotEmpty,
                      );

                      validationCubit.validateFieldAndStoreTypedValue<String>(
                        fieldName: 'recipientType',
                        value: selectedRecipient.type,
                        isValid: selectedRecipient.type.isNotEmpty,
                      );

                      NavigationService.I.pop();
                    }
                  },
                  text: context.tr.confirmRecipient,
                  enabled:
                      state is GetCustodyRecipientsSuccess &&
                      context
                              .watch<ChooseItemCubit>()
                              .state
                              .tempSelectedIndex !=
                          null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCustodyBalance(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20.r),
  //       border: Border.all(color: context.customColor.border),
  //     ),
  //     padding: EdgeInsets.all(16.r),
  //     child: Column(
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     context.tr.branchCustodyBalance,
  //                     style: AppStyles.s14W500.copyWith(
  //                       color: context.theme.primaryColor,
  //                     ),
  //                   ),
  //                   4.verticalSpace,
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(15.r),
  //                       border: Border.all(color: context.customColor.border),
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: 12.r,
  //                       horizontal: 20.r,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             context.tr.balance,
  //                             style: AppStyles.s14W400.copyWith(
  //                               color: context.customColor.text3,
  //                             ),
  //                           ),
  //                         ),
  //                         10.horizontalSpace,
  //                         const SaudiRiyalSvgWidget(),
  //                         Text(
  //                           '50,000.00',
  //                           style: AppStyles.s16W500.copyWith(
  //                             color: context.customColor.text1,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             12.horizontalSpace,
  //             const SelectionCircule(isSelected: false),
  //           ],
  //         ),
  //         8.verticalSpace,
  //         const CustomDivider(),
  //         8.verticalSpace,
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.error_outline,
  //               size: 16.r,
  //               color: context.customColor.text3,
  //             ),
  //             10.horizontalSpace,
  //             Text(
  //               context.tr.noApprovalRequired,
  //               style: AppStyles.s12W400.copyWith(
  //                 color: context.customColor.text3,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRecipientItem({
    required BuildContext context,
    required String image,
    required String type,
    required String fullName,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            AppAssetImage(image: image, width: 50.w, height: 50.h),
            5.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    fullName,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
