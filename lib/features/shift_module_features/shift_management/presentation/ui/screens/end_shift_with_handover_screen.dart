import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_handover_summary_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/total_sales_end_shift_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../core/cubits/media/media_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../../../data/model/shift/end_shift_request_with_variance.dart';
import '../../../data/model/shift/variance_model.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/choose_employee/choose_employee_cubit.dart';
import '../../logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import '../../logic/shifts/handover/handover_cubit.dart';
import '../widgets/end_shift_widgets/cash_shortage_allocation_widget.dart';
import '../widgets/end_shift_widgets/end_shift_request_widget.dart';
import '../widgets/end_shift_widgets/hand_over_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/shift_management_from_app_bar.dart';
import 'variance_detected_screen.dart';

class EndShiftWithHandoverScreen extends StatefulWidget {
  const EndShiftWithHandoverScreen({
    super.key,
    required this.isNavigatedFromCashier,
    this.isOpenedFromShiftDetailsScreen = false,
  });
  final bool isNavigatedFromCashier;
  final bool isOpenedFromShiftDetailsScreen;

  @override
  State<EndShiftWithHandoverScreen> createState() =>
      _EndShiftWithHandoverScreenState();
}

class _EndShiftWithHandoverScreenState
    extends State<EndShiftWithHandoverScreen> {
  late final TextEditingController _totalSaleSController;
  late final TextEditingController _totalHandoverController;
  late final TextEditingController _madaSController;
  late final TextEditingController _cashController;
  late final TextEditingController _countedCashController;
  late final TextEditingController _handoverAmountController;
  late final TextEditingController _handoverNoteController;

  @override
  void initState() {
    super.initState();
    _totalSaleSController = TextEditingController();
    _totalHandoverController = TextEditingController();
    _madaSController = TextEditingController();
    _cashController = TextEditingController();
    _countedCashController = TextEditingController();
    _handoverAmountController = TextEditingController();
    _handoverNoteController = TextEditingController();
  }

  @override
  void dispose() {
    _totalSaleSController.dispose();
    _totalHandoverController.dispose();
    _madaSController.dispose();
    _cashController.dispose();
    _countedCashController.dispose();
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
  }

  void _selectedCashierToNextView(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({
      'cashierName',
      'handOverAmount',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.theme.primaryColor,
      child: Column(
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
                        final steps = [
                          context.tr.totalSales,
                          context.tr.handover,
                          context.tr.summary,
                        ];

                        if (state.totalSteps > steps.length) {
                          steps.insert(1, context.tr.variance);
                        } else if (state.totalSteps == 3 && steps.length == 4) {
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
                                countedCashController: _countedCashController,
                                viewUpload: true,
                              ),
                            ),

                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => getIt<HandoverCubit>(
                                    param1: context
                                        .read<EndShiftCubit>()
                                        .shiftId,
                                  ),
                                ),

                                BlocProvider(
                                  create: (context) => getIt<ChooseItemCubit>(),
                                ),
                              ],
                              child: HandOverWidget(
                                onCashierSelected: (selectedCashier) {
                                  context.read<EndShiftCubit>().nextCashierId =
                                      selectedCashier.id.toString();
                                  context.read<EndShiftCubit>().cashier =
                                      selectedCashier;
                                },
                                handOverAmountController:
                                    _handoverAmountController,
                                handoverNoteController: _handoverNoteController,
                                totalSales:
                                    double.tryParse(
                                      _totalSaleSController.text,
                                    ) ??
                                    0,
                              ),
                            ),

                            BlocBuilder<EndShiftCubit, EndShiftState>(
                              builder: (context, state) {
                                final cubit = context.read<EndShiftCubit>();
                                final preview = cubit.previewData;
                                double shortage = 0;
                                bool allocationRequired = false;
                                if (preview != null) {
                                  final pMap = (preview['data']
                                          is Map<String, dynamic>)
                                      ? preview['data'] as Map<String, dynamic>
                                      : preview;
                                  shortage =
                                      (pMap['shortage_to_allocate'] as num?)
                                              ?.toDouble() ??
                                          0.0;
                                  allocationRequired =
                                      pMap['allocation_required'] == true;
                                }

                                return Column(
                                  children: [
                                    Expanded(
                                      child: state.varianceStrategy?.buildUI(
                                            context,
                                          ) ??
                                          const EndShiftWithHandoverSummaryWidget(),
                                    ),
                                    if (allocationRequired && shortage > 0) ...[
                                      10.verticalSpace,
                                      CashShortageAllocationWidget(
                                        shortageAmount: shortage,
                                        initialAllocations:
                                            cubit.shortageAllocations,
                                        onAllocationsChanged: (allocs) {
                                          cubit.updateShortageAllocations(allocs);
                                          setState(() {});
                                        },
                                        initialReason: cubit.allocationReason,
                                        onReasonChanged: (reason) {
                                          cubit.updateShortageAllocations(
                                            cubit.shortageAllocations,
                                            reason,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                );
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
                                  onTap: () {
                                    if (pagingState.totalSteps == 4) {
                                      if (currentIndex == 2) {
                                        context
                                            .read<ValidationCubit>()
                                            .removeDynamicFields({
                                              'handOverAmount',
                                            });
                                        context
                                            .read<ValidationCubit>()
                                            .removeDynamicFields({
                                              'cashierName',
                                            });
                                        _handoverAmountController.text = '';
                                        _handoverNoteController.text = '';
                                      }
                                    }
                                    _onBackButtonPressed(context, currentIndex);
                                  },
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
                                  if (currentIndex == 0) {
                                    final bool totalSales =
                                        state.fieldsValidity['totalSales'] ??
                                        false;
                                    final bool countedCash =
                                        state.fieldsValidity['countedCash'] ??
                                        false;

                                    return totalSales && countedCash;
                                  }

                                  if (pagingState.isLastStep) {
                                    final cubit = context.read<EndShiftCubit>();
                                    if (!cubit.canProceedToEndShift) {
                                      return false;
                                    }
                                  }

                                  if (pagingState.totalSteps == 3) {
                                    if (currentIndex == 1) {
                                      final bool cashierName =
                                          state.fieldsValidity['cashierName'] ??
                                          false;
                                      final bool handOverAmount =
                                          state
                                              .fieldsValidity['handOverAmount'] ??
                                          false;

                                      return cashierName && handOverAmount;
                                    } else if (currentIndex == 2) {
                                      final bool cashierName =
                                          state.fieldsValidity['cashierName'] ??
                                          false;
                                      final bool handOverAmount =
                                          state
                                              .fieldsValidity['handOverAmount'] ??
                                          false;

                                      final bool totalSales =
                                          state.fieldsValidity['totalSales'] ??
                                          false;

                                      return cashierName &&
                                          handOverAmount &&
                                          totalSales;
                                    } else {
                                      return state.enableButton;
                                    }
                                  } else {
                                    return state.enableButton;
                                  }
                                },
                                builder: (context, enableButton) {
                                  return BlocConsumer<
                                    EndShiftCubit,
                                    EndShiftState
                                  >(
                                    listener: (context, state) {
                                      if (state is EndShiftSuccess) {
                                        final shiftId = context
                                            .read<EndShiftCubit>()
                                            .shiftId;
                                        final handoverReceiverName =
                                            context
                                                .read<EndShiftCubit>()
                                                .cashier
                                                ?.name ??
                                            'N/A';

                                        NavigationService.I.replaceWith(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EndShiftRequestWidget(
                                                  withHandOver: true,
                                                  shiftId: shiftId,
                                                  handoverReceiverName:
                                                      handoverReceiverName,
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
                                      } else if (state is EndShiftPreviewFailure) {
                                        return AppDialog.showErrorDialog(
                                          context: context,
                                          failure: state.failure,
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      final cubit = context.read<EndShiftCubit>();
                                      if (state is EndShiftLoading ||
                                          state is EndShiftPreviewLoading ||
                                          cubit.isPreviewLoading) {
                                        return const AppButtonLoading();
                                      }
                                      return AppButton(
                                        onClick: pagingState.isLastStep
                                            ? () {
                                                context.read<EndShiftCubit>().endShitWithHandOver(
                                                  EndShiftRequestWithHandOver(
                                                    isThereVariance: context
                                                        .read<ValidationCubit>()
                                                        .fieldIsRequired(
                                                          'responsibilityType',
                                                        ),
                                                    cardPayments: context
                                                        .read<EndShiftCubit>()
                                                        .cardPayments,
                                                    aggregators: context
                                                        .read<EndShiftCubit>()
                                                        .aggregators,
                                                    cashCollected: context
                                                        .read<EndShiftCubit>()
                                                        .cashCollected,
                                                    totalSales: context
                                                        .read<EndShiftCubit>()
                                                        .totalSales,
                                                    handoverAmount: context
                                                        .read<EndShiftCubit>()
                                                        .handOverAmount,
                                                    handoverNotes: context
                                                        .read<EndShiftCubit>()
                                                        .handOverNote,
                                                    nextCashierId: context
                                                        .read<EndShiftCubit>()
                                                        .nextCashierId
                                                        .toString(),
                                                    posReceipt: context
                                                        .read<EndShiftCubit>()
                                                        .posReceipt,
                                                    isManager:
                                                        context
                                                            .read<
                                                              EndShiftCubit
                                                            >()
                                                            .cashier
                                                            ?.isManager ??
                                                        false,
                                                    variance: Variance(
                                                      currentCashierAmount:
                                                          (context
                                                                      .read<
                                                                        EndShiftCubit
                                                                      >()
                                                                      .varianceAmount ??
                                                                  0)
                                                              .abs(),
                                                      otherCashiers: _buildExpenseList(
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
                                                  ),
                                                );
                                              }
                                            : () async {
                                                if (currentIndex == 0) {
                                                  if (cubit.isPreviewLoading) return;

                                                  final counted = double.tryParse(
                                                    _countedCashController.text.trim(),
                                                  );
                                                  cubit.setCountedCash(counted);

                                                  cubit.endShiftTotalSalesValuesUpdated(
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

                                                  // Await server preview calculation
                                                  final previewSuccess =
                                                      await cubit
                                                          .fetchCashReconciliationPreview();
                                                  if (!context.mounted) return;
                                                  if (!previewSuccess) {
                                                    // Stay on step 0 if preview failed or is invalid
                                                    return;
                                                  }

                                                  final isVarianceDetected =
                                                      context
                                                          .read<EndShiftCubit>()
                                                          .varianceAmount !=
                                                      0;

                                                  if (isVarianceDetected) {
                                                    context
                                                        .read<ValidationCubit>()
                                                        .removeDynamicFields({
                                                          'responsibilityType',
                                                        });
                                                    context
                                                        .read<ValidationCubit>()
                                                        .toggleFieldRequirement(
                                                          'responsibilityType',
                                                          isRequired: true,
                                                        );
                                                    context
                                                        .read<PagingCubit>()
                                                        .updateTotalSteps(4);
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
                                                        .updateTotalSteps(3);
                                                  }
                                                }

                                                if (pagingState.totalSteps ==
                                                    4) {
                                                  if (currentIndex == 1) {
                                                    _selectedCashierToNextView(
                                                      context,
                                                    ); // add Validation Fields for the HandOver Widget
                                                  } else if (currentIndex ==
                                                      2) {
                                                    context
                                                        .read<EndShiftCubit>()
                                                        .endShiftHandOverValuesUpdated(
                                                          handOverAmount:
                                                              double.tryParse(
                                                                _handoverAmountController
                                                                    .text,
                                                              ) ??
                                                              0,
                                                          handOverNote:
                                                              _handoverNoteController
                                                                  .text,
                                                          cashier: context
                                                              .read<
                                                                EndShiftCubit
                                                              >()
                                                              .cashier,
                                                        );
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
                                                } else if (pagingState
                                                        .totalSteps ==
                                                    3) {
                                                  if (currentIndex == 1) {
                                                    context
                                                        .read<EndShiftCubit>()
                                                        .endShiftHandOverValuesUpdated(
                                                          handOverAmount:
                                                              double.tryParse(
                                                                _handoverAmountController
                                                                    .text,
                                                              ) ??
                                                              0,
                                                          handOverNote:
                                                              _handoverNoteController
                                                                  .text,
                                                          cashier: context
                                                              .read<
                                                                EndShiftCubit
                                                              >()
                                                              .cashier,
                                                        );
                                                    context
                                                        .read<EndShiftCubit>()
                                                        .setVarianceType(null);
                                                  }
                                                }

                                                _onNextButtonPressed(
                                                  context,
                                                  currentIndex,
                                                );
                                              },
                                        enabled: pagingState.isLastStep
                                            ? (enableButton && cubit.canProceedToEndShift)
                                            : enableButton,
                                        text: pagingState.totalSteps == 3
                                            ? (currentIndex == 2
                                                  ? context.tr.end_shift
                                                  : context.tr.next)
                                            : (currentIndex == 3
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