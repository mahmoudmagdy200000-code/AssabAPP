import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/variance_detected_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/total_sales_end_shift_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/media/media_cubit.dart';
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
import '../../../data/model/shift/variance_model.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/choose_employee/choose_employee_cubit.dart';
import '../../logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import '../../logic/get_cashier/get_cashier_cubit.dart';
import '../arguments/shift_arguments.dart';
import '../widgets/end_shift_widgets/end_shift_request_widget.dart';
import '../widgets/end_shift_widgets/end_shift_summary_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/shift_management_from_app_bar.dart';

class EndShiftScreen extends StatefulWidget {
  const EndShiftScreen({
    super.key,
    required this.isNavigatedFromCashier,
    required this.isOpenedFromShiftDetailsScreen,
  });

  final bool isOpenedFromShiftDetailsScreen;
  final bool isNavigatedFromCashier;
  @override
  State<EndShiftScreen> createState() => _EndShiftScreenState();
}

class _EndShiftScreenState extends State<EndShiftScreen> {
  late final TextEditingController _totalSaleSController;
  late final TextEditingController _totalHandoverController;
  late final TextEditingController _madaSController;
  late final TextEditingController _cashController;
  @override
  void initState() {
    super.initState();
    _totalSaleSController = TextEditingController();
    _totalHandoverController = TextEditingController();
    _madaSController = TextEditingController();
    _cashController = TextEditingController();
  }

  @override
  void dispose() {
    _totalSaleSController.dispose();
    _totalHandoverController.dispose();
    _madaSController.dispose();
    _cashController.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ShiftManagementFromAppBar(text: context.tr.end_shift),
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
                        final steps = [
                          context.tr.totalSales,
                          context.tr.summary,
                        ];

                        if (state.totalSteps > steps.length) {
                          steps.insert(1, context.tr.variance);
                        } else if (state.totalSteps < steps.length) {
                          steps.removeAt(1);
                        }

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
                                  create: (context) => AddItemCubit(),
                                ),
                                BlocProvider(
                                  create: (context) => getIt<MediaCubit>(),
                                ),
                              ],
                              child: SalesBreakDownEndShiftWidget(
                                totalSaleSController: _totalSaleSController,
                                totalHandoverController:
                                    _totalHandoverController,
                                madaController: _madaSController,
                                cashController: _cashController,
                                viewUpload: false,
                              ),
                            ),

                            BlocBuilder<EndShiftCubit, EndShiftState>(
                              builder: (context, state) {
                                return state.varianceStrategy?.buildUI(
                                      context,
                                    ) ??
                                    const EndShiftSummaryWidget();
                              },
                            ),
                          ];

                          if (state.totalSteps > steps.length) {
                            steps.insert(
                              1,
                              MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        getIt<ChooseVarianceReasonCubit>(),
                                  ),

                                  BlocProvider(
                                    create: (context) =>
                                        getIt<GetCashierCubit>(),
                                  ),
                                ],
                                child: VarianceDetectedScreen(
                                  showButtons: false,
                                  handOverAmount:
                                      context
                                          .read<EndShiftCubit>()
                                          .handOverAmount ??
                                      0,
                                  totalSales: context
                                      .read<EndShiftCubit>()
                                      .totalSales,
                                  varianceAmount:
                                      context
                                          .read<EndShiftCubit>()
                                          .varianceAmount ??
                                      0,
                                  paymentMethodsTotal: context
                                      .read<EndShiftCubit>()
                                      .paymentMethodsTotal,
                                ),
                              ),
                            );
                          } else if (state.totalSteps < steps.length) {
                            steps.removeAt(1);
                          }
                          return IndexedStack(
                            index: currentIndex,
                            children: steps,

                            // children: [
                            //   const EndShiftSummaryWidget(),
                            //   // Container(color: Colors.green,)
                            // ],
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
                              child: BlocSelector<ValidationCubit, ValidationState, bool>(
                                selector: (state) {
                                  if (pagingState.currentIndex == 0) {
                                    final bool totalSales =
                                        state.fieldsValidity['totalSales'] ??
                                        false;

                                    return totalSales;
                                  }

                                  return state.enableButton;
                                },
                                builder: (context, enableButton) {
                                  return BlocConsumer<
                                    EndShiftCubit,
                                    EndShiftState
                                  >(
                                    listener: (context, state) {
                                      if (state is EndShiftSuccess) {
                                        final endShiftCubit = context
                                            .read<EndShiftCubit>();
                                        final variance =
                                            endShiftCubit.varianceAmount;
                                        final nextCashier =
                                            endShiftCubit.shift?.cashier.name;
                                        final totalSales =
                                            endShiftCubit.totalSales;
                                        final cashCollected =
                                            endShiftCubit.cashCollected;
                                        final deliveryApps = endShiftCubit
                                            .aggregators
                                            .fold<double>(
                                              0,
                                              (sum, e) => sum + (e.amount),
                                            );
                                        final cardPayment =
                                            endShiftCubit.cardPayments;
                                        final shiftId = endShiftCubit.shiftId;

                                        NavigationService.I.replaceWith(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EndShiftRequestWidget(
                                                  withHandOver: false,
                                                  shiftId: shiftId,
                                                  shiftArguments:
                                                      ShiftArguments(
                                                        shiftId: shiftId,
                                                        variance: variance ?? 0,
                                                        nextCashier:
                                                            nextCashier,
                                                        totalSales: totalSales,
                                                        cashCollected:
                                                            cashCollected,
                                                        deliveryApps:
                                                            deliveryApps,
                                                        cardPayment:
                                                            cardPayment,
                                                      ),
                                                  isNavigatedFromCashier: widget
                                                      .isNavigatedFromCashier,
                                                  isOpenedFromShiftDetailsScreen:
                                                      widget
                                                          .isOpenedFromShiftDetailsScreen,
                                                ),
                                          ),
                                          result: true,
                                        );
                                      } else if (state is EndShiftFailure) {
                                        return AppDialog.showErrorDialog(
                                          context: context,
                                          failure: state.failure,
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is EndShiftLoading) {
                                        return const AppButtonLoading();
                                      }
                                      return AppButton(
                                        onClick: pagingState.isLastStep
                                            ? () {
                                                context.read<EndShiftCubit>().endShift(
                                                  isThereVariance: context
                                                      .read<ValidationCubit>()
                                                      .fieldIsRequired(
                                                        'responsibilityType',
                                                      ),
                                                  variance: Variance(
                                                    currentCashierAmount:
                                                        (context
                                                                    .read<
                                                                      EndShiftCubit
                                                                    >()
                                                                    .varianceAmount ??
                                                                0)
                                                            .abs(),
                                                    otherCashiers:
                                                        _buildExpenseList(
                                                          context
                                                              .read<
                                                                ValidationCubit
                                                              >(),
                                                          context
                                                              .read<
                                                                ChooseEmployeeCubit
                                                              >()
                                                              .state
                                                              .selectedEmployees,
                                                        ),
                                                    reason: _getField(
                                                      context
                                                          .read<
                                                            ValidationCubit
                                                          >(),
                                                      'reason',
                                                    ),
                                                    responsibilityType:
                                                        _getField(
                                                          context
                                                              .read<
                                                                ValidationCubit
                                                              >(),
                                                          'responsibilityType',
                                                        ),
                                                    supportingFiles: context
                                                        .read<MediaCubit>()
                                                        .allFilesSelected
                                                        .map((e) => e.toFile)
                                                        .toList(),
                                                  ),
                                                );
                                              }
                                            : () {
                                                if (currentIndex == 0) {
                                                  //
                                                  context
                                                      .read<EndShiftCubit>()
                                                      .endShiftTotalSalesValuesUpdated(
                                                        totalSales:
                                                            double.tryParse(
                                                              _totalSaleSController
                                                                  .text,
                                                            ) ??
                                                            0,
                                                        cashCollected:
                                                            double.tryParse(
                                                              _cashController
                                                                  .text,
                                                            ) ??
                                                            0,
                                                        cardPayments:
                                                            double.tryParse(
                                                              _madaSController
                                                                  .text,
                                                            ) ??
                                                            0,
                                                        aggregators: context
                                                            .read<
                                                              AggregatorCubit
                                                            >()
                                                            .addedAggregators,
                                                      );

                                                  final isVarianceDetected =
                                                      context
                                                          .read<EndShiftCubit>()
                                                          .varianceAmount !=
                                                      0;

                                                  if (isVarianceDetected) {
                                                    context
                                                        .read<PagingCubit>()
                                                        .updateTotalSteps(3);
                                                    context
                                                        .read<ValidationCubit>()
                                                        .toggleFieldRequirement(
                                                          'responsibilityType',
                                                          isRequired: true,
                                                        );
                                                  } else if (!isVarianceDetected) {
                                                    context
                                                        .read<ValidationCubit>()
                                                        .toggleFieldRequirement(
                                                          'responsibilityType',
                                                          isRequired: false,
                                                        );
                                                    context
                                                        .read<ValidationCubit>()
                                                        .validateFieldAndStoreValue(
                                                          fieldName:
                                                              'responsibilityType',
                                                          isValid: false,
                                                          value: '',
                                                        );
                                                    context
                                                        .read<ValidationCubit>()
                                                        .validateFieldAndStoreValue(
                                                          fieldName: 'reason',
                                                          isValid: false,
                                                          value: '',
                                                        );
                                                    context
                                                        .read<ValidationCubit>()
                                                        .validateFieldAndStoreList(
                                                          fieldName:
                                                              'attachments',
                                                          isValid: false,
                                                          value: [],
                                                        );
                                                    context
                                                        .read<ValidationCubit>()
                                                        .removeDynamicFields({
                                                          'reason',
                                                          'responsibleEmployees',
                                                          'attachments',
                                                        });

                                                    context
                                                        .read<EndShiftCubit>()
                                                        .setVarianceType(null);

                                                    context
                                                        .read<PagingCubit>()
                                                        .updateTotalSteps(2);
                                                  }
                                                }

                                                if (pagingState.totalSteps ==
                                                    3) {
                                                  if (currentIndex == 1) {
                                                    context
                                                        .read<EndShiftCubit>()
                                                        .setVarianceType(
                                                          context
                                                                  .read<
                                                                    ValidationCubit
                                                                  >()
                                                                  .state
                                                                  .fieldsValue['responsibilityType'] ??
                                                              '',
                                                        );
                                                  }
                                                }

                                                // if(pagingState.totalSteps == 3){
                                                //   if(currentIndex == 1){
                                                //     context.read<EndShiftCubit>().setVarianceType(context.read<ValidationCubit>().state.fieldsValue['responsibilityType'] ?? '');
                                                //   }
                                                // }else if(pagingState.totalSteps == 2 ){
                                                //   if(currentIndex == 1){
                                                //     context.read<EndShiftCubit>().setVarianceType(null);
                                                //   }
                                                // }

                                                _onNextButtonPressed(
                                                  context,
                                                  currentIndex,
                                                );
                                              },

                                        enabled: enableButton,
                                        text: pagingState.totalSteps == 2
                                            ? (currentIndex == 1
                                                  ? context.tr.end_shift
                                                  : context.tr.next)
                                            : (currentIndex == 2
                                                  ? context.tr.end_shift
                                                  : context.tr.next),
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

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  List<OtherCashier> _buildExpenseList(
    ValidationCubit validationCubit,
    Map<CashierEntity, bool> expenses,
  ) {
    return expenses.entries.map((entry) {
      final cashier = entry.key;
      return OtherCashier(
        cashierId: cashier.id,
        amount:
            double.tryParse(
              _getField(validationCubit, cashier.id.toString()),
            ) ??
            0,
      );
    }).toList();
  }
}
