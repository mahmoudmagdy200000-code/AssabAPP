import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/app_dialog.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_button_loading.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../../logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import '../widgets/reassign_widgets/choose_cashier.dart';
import '../widgets/reassign_widgets/reassign_request_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_summary.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/shift_management_from_app_bar.dart';

class ReassignShiftWithoutHandoverScreen extends StatefulWidget {
  const ReassignShiftWithoutHandoverScreen({
    super.key,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  final bool isOpenedFromShiftDetailsScreen;
  @override
  State<ReassignShiftWithoutHandoverScreen> createState() =>
      _ReassignShiftWithoutHandoverScreenState();
}

class _ReassignShiftWithoutHandoverScreenState
    extends State<ReassignShiftWithoutHandoverScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

    switch (currentIndex) {
      case 0:
        break;
      case 1:
        _cashierInfoChangedToPreviousView(context);
        break;
    }
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    _changeView(context);

    switch (currentIndex) {
      case 0:
        _removeCashierSelectionValidationFields(context);
        break;
      case 1:
        context.read<ReassignShiftCubit>().reassignCashier(
          context.read<ValidationCubit>().getFieldValue('reason'),
        );
        break;
    }
  }

  void _removeCashierSelectionValidationFields(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({'cashierName'});
  }

  void _cashierInfoChangedToPreviousView(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'cashierName'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ShiftManagementFromAppBar(text: context.tr.reassign_shift),
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
                    ReassignShiftTopSection(
                      titles: [context.tr.choose, context.tr.summary],
                    ),
                    14.verticalSpace,
                    Expanded(
                      child: BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;

                          return IndexedStack(
                            index: currentIndex,
                            children: [
                              // const AddCashierScreen(),
                              BlocProvider(
                                create: (context) => getIt<ChooseItemCubit>(),
                                child: const ChooseCashierWidget(),
                              ),

                              const ReassignShiftSummaryWidget(),
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
                                        ReassignShiftCubit,
                                        ReassignShiftState
                                      >(
                                        listener: (context, state) {
                                          if (state is ReassignShiftSuccess) {
                                            _navToSuccess(
                                              context,
                                              context
                                                  .read<ReassignShiftCubit>()
                                                  .shift,
                                              widget
                                                  .isOpenedFromShiftDetailsScreen,
                                            );
                                          } else if (state
                                              is ReassignShiftFailure) {
                                            AppDialog.showErrorDialog(
                                              context: context,
                                              failure: state.failure,
                                            );
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is ReassignShiftLoading) {
                                            return const AppButtonLoading();
                                          }
                                          return AppButton(
                                            onClick: () {
                                              if (currentIndex == 0) {
                                                context
                                                    .read<ReassignShiftCubit>()
                                                    .updateChooseEmployeeValues();
                                              }
                                              _onNextButtonPressed(
                                                context,
                                                currentIndex,
                                              );
                                            },
                                            enabled: enableButton,
                                            text: currentIndex == 1
                                                ? context.tr.reassign_shift
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

  void _navToSuccess(
    BuildContext context,
    ShiftEntity shift,
    bool isOpenedFromShiftDetailsScreen,
  ) {
    NavigationService.I.replaceWith(
      MaterialPageRoute(
        builder: (context) => ReassignRequestWidget(
          shift: shift,
          isOpenedFromShiftDetailsScreen: isOpenedFromShiftDetailsScreen,
        ),
      ),
      result: true,
    );
  }
}
