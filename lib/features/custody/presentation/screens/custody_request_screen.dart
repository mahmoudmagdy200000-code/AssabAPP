import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../data/models/custody_get_past_requests_response.dart';
import '../../data/models/custody_request_cash_in_request_model.dart';
import '../cubit/custody_create_request/custody_create_request_cubit.dart';
import '../cubit/custody_create_request/custody_create_request_state.dart';
import '../cubit/custody_get_requets/custody_get_requets_cubit.dart';
import '../widgets/custody_request_attachment_section.dart';
import '../widgets/custody_request_preferred_receipt_method_section.dart';
import '../widgets/custody_reuse_past_request_bottom_sheet_widget.dart';

class CustodyRequestScreen extends StatelessWidget {
  const CustodyRequestScreen({super.key});

  void _validateField({
    required BuildContext context,
    required String fieldName,
    required String value,
    required bool valid,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: valid,
    );
  }

  CustodyRequestCashInRequestModel _buildRequestModel(BuildContext context) {
    final validationState = context.read<ValidationCubit>().state;
    return CustodyRequestCashInRequestModel(
      preferredReceiptMethod:
          validationState.fieldsValue['preferredReceiptMethod'] ?? '',
      purpose: validationState.fieldsValue['purpose'] ?? '',
      requestedAmount: double.parse(
        validationState.fieldsValue['requestAmount'] ?? '0',
      ),
      additionalNotes: validationState.fieldsValue['notes'],
      attachments: context
          .read<MediaCubit>()
          .allFilesSelected
          .map((e) => e.toFile)
          .toList(),
    );
  }

  void _createCashInRequest(BuildContext context) {
    context.read<CustodyCreateRequestCubit>().createCashInRequest(
      requestModel: _buildRequestModel(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          CustodyAppBar(title: context.tr.custodyRequestForm),
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
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: context.customColor.text3,
                                size: 20.r,
                              ),
                              10.horizontalSpace,
                              Flexible(
                                child: Text(
                                  context
                                      .tr
                                      .requestFundsFromTheStoreOwnerToReplenishYourCustody,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          Row(
                            children: [
                              Flexible(
                                child: LabelTextField(
                                  text: context.tr.requestedAmount,
                                ),
                              ),
                              10.horizontalSpace,
                              CustomTextButton(
                                text: context.tr.reusePastRequest,
                                onTap: () {
                                  final custodyCreateRequestCubit = context
                                      .read<CustodyCreateRequestCubit>();

                                  AppBottomSheet.pageRoute(
                                    context,
                                    (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              getIt<ChooseItemCubit>(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              SearchCubit<
                                                CustodyGetPastRequestData
                                              >(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              getIt<CustodyGetRequetsCubit>(),
                                        ),
                                        BlocProvider.value(
                                          value: custodyCreateRequestCubit,
                                        ),
                                        BlocProvider(
                                          create: (context) => ValidationCubit(
                                            requiredFields: {'itemId'},
                                          ),
                                        ),
                                      ],
                                      child:
                                          const CustodyReusePastRequestBottomSheetWidget(),
                                    ),
                                  );
                                },
                                borderColor: context.theme.primaryColor,
                                textColor: context.theme.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 11.3.r,
                                  horizontal: 12.r,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          ContainerCustomTextField(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: context.tr.howMuchDoYouWant,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _validateField(
                                        context: context,
                                        fieldName: 'requestAmount',
                                        value: value,
                                        valid: value.isNotEmpty,
                                      );
                                    },
                                  ),
                                ),
                                10.horizontalSpace,
                                const SaudiRiyalSvgWidget(),
                              ],
                            ),
                          ),
                          14.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.purpose,
                            child: CustomTextField(
                              hintText:
                                  context.tr.egReplenishCustodyForDailyExpenses,
                              onChanged: (value) {
                                _validateField(
                                  context: context,
                                  fieldName: 'purpose',
                                  value: value,
                                  valid: value.isNotEmpty,
                                );
                              },
                            ),
                          ),
                          14.verticalSpace,
                          const CustodyRequestPreferredReceiptMethodSection(),
                          14.verticalSpace,
                          const CustodyRequestAttachmentSection(),
                          14.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.additionalNotes,
                            isLabelRequired: false,
                            isLabelOptional: true,
                            child: CustomTextField(
                              hintText:
                                  context.tr.addAnyDetailsRegardingThisRequest,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                _validateField(
                                  context: context,
                                  fieldName: 'notes',
                                  value: value,
                                  valid: value.isNotEmpty,
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
                    CustodyCreateRequestCubit,
                    CustodyCreateRequestState
                  >(
                    listener: (context, state) {
                      if (state is CustodyCreateRequestSuccess) {
                        NavigationService.I.pop();
                        NavigationService.I.pushNamed(
                          AppRouteName.custodyRequestSuccessScreen,
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
                              onTap: () => NavigationService.I.pop(),
                              textColor: context.customColor.text1,
                              borderRadius: 1000.r,
                              padding: EdgeInsets.symmetric(vertical: 18.r),
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child:
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) => state.enableButton,
                                  builder: (context, state) {
                                    return AppButton(
                                      onClick: () {
                                        _createCashInRequest(context);
                                      },
                                      enabled: state,
                                      text: context.tr.submitRequest,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 18.r,
                                      ),
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
        ],
      ),
    );
  }
}
