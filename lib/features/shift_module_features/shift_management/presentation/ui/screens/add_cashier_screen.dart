import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/add_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/get_available_cashier_shifts_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/cashier_management_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/add_cashier/add_cashier_request_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/add_cashier/cashier_info_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/add_cashier/details_summarize_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/add_cashier/select_working_shifts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../widgets/add_cashier/add_cashier_app_bar.dart';
import '../widgets/shift_management_from_app_bar.dart';

class AddCashierScreen extends StatefulWidget {
  const AddCashierScreen({super.key});

  @override
  State<AddCashierScreen> createState() => _AddCashierScreenState();
}

class _AddCashierScreenState extends State<AddCashierScreen> {
  late final TextEditingController fullName;
  late final TextEditingController email;

  @override
  void initState() {
    super.initState();
    fullName = TextEditingController();
    email = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    fullName.dispose();
    email.dispose();
  }

  void _changeView(BuildContext context) {
    context.read<PagingCubit>().nextStep();
  }

  void _goBackView(BuildContext context) {
    context.read<PagingCubit>().previousStep();
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
    _goBackView(context);

    switch (currentIndex) {
      case 0:
        break;
      case 1:
        _removeShiftSelectionValidationFields(context);
        break;
      case 2:
        // _removeShiftSelectionValidationFields(context);
        break;
    }
  }

  void _cashierInfoChangedToNextView(BuildContext context) {
    context.read<AddCashierCubit>().fullName = fullName.text;
    context.read<AddCashierCubit>().email = email.text;

    _shiftSelectionChangedToNextView(context);

    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'selectedShift',
      value: context.read<AddCashierCubit>().shift?.name ?? '',
      isValid: context.read<AddCashierCubit>().shift?.name.isNotEmpty,
    );

    context.read<PagingCubit>().nextStep();
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    if (currentIndex == 0) {
      context.read<AddCashierCubit>().validateEmail(
        email: email.text,
        context: context,
      );
      return;
    }

    _changeView(context);

    switch (currentIndex) {
      // case 0:
      // context.read<AddCashierCubit>().fullName = fullName.text;
      // context.read<AddCashierCubit>().email = email.text;
      //
      // _shiftSelectionChangedToNextView(context);
      //
      // context.read<ValidationCubit>().validateFieldAndStoreValue(
      //   fieldName: 'selectedShift',
      //   value: context.read<AddCashierCubit>().shift?.name ?? '',
      //   isValid: context.read<AddCashierCubit>().shift?.name.isNotEmpty,
      // );
      // break;
      case 1:
        context.read<AddCashierCubit>().setCubitValues(
          fullName: fullName.text,
          email: email.text,
          storeBranch: context.read<AddCashierCubit>().storeBranch,
          selectedBranchId: context.read<AddCashierCubit>().selectedBranchId,
          shift: context.read<AddCashierCubit>().shift,
        );
        break;
      case 2:
        // final addCashierCubit = context.read<AddCashierCubit>();
        // AppBottomSheet.show(
        //   context,
        //   (context) => BlocProvider.value(
        //     value: addCashierCubit,
        //     child: const AddCashierRequestWidget(),
        //   ),
        // );

        context.read<AddCashierCubit>().addCashier();

        break;
    }
  }

  void _removeShiftSelectionValidationFields(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({'selectedShift'});
  }

  void _shiftSelectionChangedToNextView(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'selectedShift'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ShiftManagementFromAppBar(text: context.tr.addCashier),
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
                    const AddCashierTopSection(),
                    14.verticalSpace,
                    Expanded(
                      child: BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;

                          return IndexedStack(
                            index: currentIndex,
                            children: [
                              MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (_) => getIt<SwitchButtonCubit>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<PagingCubit>(),
                                  ),
                                ],
                                child: AddCashierInfoWidget(
                                  fullNameController: fullName,
                                  emailController: email,
                                ),
                              ),

                              // const AddCashierScreen(),
                              MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        getIt<ChooseItemCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        GetAvailableCashierShiftsCubit(
                                          getIt<ShiftManagementRepositoryImp>(),
                                        ),
                                  ),
                                ],
                                child: SelectWorkingShiftWidget(
                                  onAction: (shift) {
                                    context.read<AddCashierCubit>().shift =
                                        shift;
                                  },
                                ),
                              ),

                              const DetailsSummarizeWidget(),
                              // Container(color: Colors.green,)
                            ],
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, state) {
                        final currentIndex = state.currentIndex;

                        return Row(
                          children: [
                            if (currentIndex != 0) ...[
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.back,
                                  onTap: () => _onBackButtonPressed(
                                    context,
                                    currentIndex,
                                  ),
                                  textColor: context.customColor.text1,
                                  borderRadius: 1000.r,
                                  padding: EdgeInsets.symmetric(vertical: 17.r),
                                ),
                              ),
                              16.horizontalSpace,
                            ],
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    bool
                                  >(
                                    selector: (state) => state.enableButton,
                                    builder: (context, enableButton) {
                                      return BlocConsumer<
                                        AddCashierCubit,
                                        AddCashierState
                                      >(
                                        listener: (context, state) {
                                          if (state is CheckEmailValid) {
                                            _cashierInfoChangedToNextView(
                                              context,
                                            );
                                          }

                                          if (state is CheckEmailInvalid) {
                                            AppDialog.showErrorDialog(
                                              context: context,
                                              failure: state.failure,
                                            );
                                          }

                                          if (state is AddCashierSuccess) {
                                            _navToSuccess(context);
                                          } else if (state
                                              is AddCashierFailure) {
                                            AppDialog.showErrorDialog(
                                              context: context,
                                              failure: state.failure,
                                            );
                                          }
                                        },

                                        builder: (context, state) {
                                          if (state is AddCashierLoading) {
                                            return const AppButtonLoading();
                                          }
                                          return AppButton(
                                            onClick: () => _onNextButtonPressed(
                                              context,
                                              currentIndex,
                                            ),
                                            enabled: enableButton,
                                            text: currentIndex == 2
                                                ? context.tr.addCashier
                                                : context.tr.next,
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

  void _navToSuccess(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final cashierCubit = context.read<CashierManagementCubit>();

    cashierCubit.getCashiers(loadMore: false);
    NavigationService.I.replaceWith(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: validationCubit,
          child: const AddCashierRequestWidget(),
        ),
      ),
    );
  }
}
