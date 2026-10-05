import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/variance_detected_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../core/cubits/media/media_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/app_dialog.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/app_scaffold.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../../../data/model/shift/reassign_shift/reassign_shift_with_handover.dart';
import '../../../data/model/shift/variance_model.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/choose_employee/choose_employee_cubit.dart';
import '../../logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import '../../logic/get_cashier/get_cashier_cubit.dart';
import '../../logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import '../widgets/reassign_widgets/choose_cashier.dart';
import '../widgets/reassign_widgets/reassign_request_widget.dart';
import '../widgets/reassign_widgets/reassign_shift_summary.dart';
import '../widgets/reassign_widgets/reassign_shift_top_section.dart';
import '../widgets/reassign_widgets/sales_break_down_widget.dart';
import '../widgets/shift_management_from_app_bar.dart';

class ReassignShiftWithHandoverScreen extends StatefulWidget {
  const ReassignShiftWithHandoverScreen({
    super.key,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  final bool isOpenedFromShiftDetailsScreen;
  @override
  State<ReassignShiftWithHandoverScreen> createState() =>
      _ReassignShiftWithHandoverScreenState();
}

class _ReassignShiftWithHandoverScreenState
    extends State<ReassignShiftWithHandoverScreen> {
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
    return AppScaffold(
      backgroundColor: context.theme.primaryColor,
      child: Column(
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
                    BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, state) {
                        final steps = [
                          context.tr.choose,
                          context.tr.salesBreakDown,
                          context.tr.summary,
                        ];

                        if (state.totalSteps > steps.length) {
                          steps.insert(2, context.tr.variance);
                        } else if (state.totalSteps < steps.length) {
                          steps.removeAt(2);
                        }

                        return ReassignShiftTopSection(titles: steps);
                      },
                    ),

                    14.verticalSpace,
                    Expanded(
                      child: BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;
                          final steps = [
                            // const AddCashierScreen(),
                            BlocProvider(
                              create: (context) => getIt<ChooseItemCubit>(),
                              child: const ChooseCashierWidget(),
                            ),

                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => AddItemCubit(),
                                ),
                              ],
                              child: SalesBreakDownWidget(
                                totalSaleSController: _totalSaleSController,
                                totalHandoverController:
                                    _totalHandoverController,
                                madaController: _madaSController,
                                cashController: _cashController,
                              ),
                            ),

                            ReassignShiftSummaryWidget(
                              isInProgress: !(context
                                  .read<ReassignShiftCubit>()
                                  .shift
                                  .hasEnded),
                            ),
                            // Container(color: Colors.green,)
                          ];

                          if (state.totalSteps > steps.length) {
                            steps.insert(
                              2,
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
                                  handOverAmount: context
                                      .read<ReassignShiftCubit>()
                                      .handOverAmount,
                                  totalSales: context
                                      .read<ReassignShiftCubit>()
                                      .totalSales,
                                  paymentMethodsTotal: context
                                      .read<ReassignShiftCubit>()
                                      .paymentMethodsTotal,
                                  varianceAmount:
                                      context
                                          .read<ReassignShiftCubit>()
                                          .varianceAmount ??
                                      0,
                                ),
                              ),
                            );
                          } else if (state.totalSteps < steps.length) {
                            steps.removeAt(2);
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
                                  if (currentIndex == 0) {
                                    final bool cashierName =
                                        state.fieldsValidity['cashierName'] ??
                                        false;

                                    return cashierName;
                                  } else if (currentIndex == 1) {
                                    final bool totalSales =
                                        state.fieldsValidity['totalSales'] ??
                                        false;
                                    final bool handOver =
                                        state
                                            .fieldsValidity['handoverAmount'] ??
                                        false;

                                    return totalSales && handOver;
                                  } else {
                                    return state.enableButton;
                                  }
                                },
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
                                          widget.isOpenedFromShiftDetailsScreen,
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
                                        onClick: pagingState.isLastStep
                                            ? () {
                                                context.read<ReassignShiftCubit>().reassignCashierWithHandOver(
                                                  request: ReassignShiftRequestWithHandOverRequest(
                                                    varianceAmount: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .varianceAmount,
                                                    isThereVariance: context
                                                        .read<ValidationCubit>()
                                                        .fieldIsRequired(
                                                          'responsibilityType',
                                                        ),
                                                    cardPayments: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .cardPayments,
                                                    aggregators: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .aggregators,
                                                    cashCollected: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .cashCollected,
                                                    totalSales: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .totalSales,
                                                    handoverAmount: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .handOverAmount,
                                                    nextCashierId: context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .selectedCashier
                                                        ?.id
                                                        .toString(),
                                                    variance: Variance(
                                                      currentCashierAmount:
                                                          (context
                                                                      .read<
                                                                        ReassignShiftCubit
                                                                      >()
                                                                      .varianceAmount ??
                                                                  0)
                                                              .abs(),
                                                      otherCashiers: _buildCashierList(
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
                                            : () {
                                                if (currentIndex == 1) {
                                                  context
                                                      .read<
                                                        ReassignShiftCubit
                                                      >()
                                                      .reassignTotalSalesValuesUpdated(
                                                        totalSales:
                                                            double.tryParse(
                                                              _totalSaleSController
                                                                  .text,
                                                            ) ??
                                                            0,
                                                        handOverAmount:
                                                            double.tryParse(
                                                              _totalHandoverController
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
                                                          .read<
                                                            ReassignShiftCubit
                                                          >()
                                                          .varianceAmount !=
                                                      0;

                                                  if (isVarianceDetected) {
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
                                                        .read<PagingCubit>()
                                                        .updateTotalSteps(3);
                                                  }
                                                }

                                                if (pagingState.totalSteps ==
                                                    4) {
                                                  if (currentIndex == 1) {
                                                    context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .reassignTotalSalesValuesUpdated(
                                                          totalSales:
                                                              double.tryParse(
                                                                _totalSaleSController
                                                                    .text,
                                                              ) ??
                                                              0,
                                                          handOverAmount:
                                                              double.tryParse(
                                                                _totalHandoverController
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
                                                  }
                                                } else if (pagingState
                                                        .totalSteps ==
                                                    3) {
                                                  if (currentIndex == 1) {
                                                    context
                                                        .read<
                                                          ReassignShiftCubit
                                                        >()
                                                        .reassignTotalSalesValuesUpdated(
                                                          totalSales:
                                                              double.tryParse(
                                                                _totalSaleSController
                                                                    .text,
                                                              ) ??
                                                              0,
                                                          handOverAmount:
                                                              double.tryParse(
                                                                _totalHandoverController
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
                                                  }
                                                }

                                                _onNextButtonPressed(
                                                  context,
                                                  currentIndex,
                                                );
                                              },
                                        enabled: enableButton,
                                        text: pagingState.totalSteps == 3
                                            ? (currentIndex == 2
                                                  ? context.tr.reassign_shift
                                                  : context.tr.next)
                                            : (currentIndex == 3
                                                  ? context.tr.reassign_shift
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

  void _navToSuccess(
    BuildContext context,
    ShiftEntity shift,
    bool? isOpenedFromShiftDetailsScreen,
  ) {
    NavigationService.I.replaceWith(
      MaterialPageRoute(
        builder: (context) => ReassignRequestWidget(
          shift: shift,
          isOpenedFromShiftDetailsScreen:
              isOpenedFromShiftDetailsScreen ?? false,
        ),
      ),
      result: true,
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  List<OtherCashier> _buildCashierList(
    ValidationCubit validationCubit,
    Map<CashierEntity, bool> cashierEntity,
  ) {
    return cashierEntity.entries.map((entry) {
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
