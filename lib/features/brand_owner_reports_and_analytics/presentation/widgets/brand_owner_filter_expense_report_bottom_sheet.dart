import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/custody_preferred_receipt_method.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../brand_owner_requests/data/models/brand_owner_requests_models.dart';
import '../../../brand_owner_requests/presentation/cubits/brand_owner_payment_log_cubit.dart';
import '../../../brand_owner_requests/presentation/cubits/brand_owner_payment_log_state.dart';
import '../../domain/entities/brand_owner_expense_report_filter_entity.dart';
import '../../domain/enums/brand_owner_expense_report_status.dart';
import '../../domain/enums/brand_owner_expense_report_type.dart';
import '../cubit/brand_owner_expense_report_details_cubit.dart';

class BrandOwnerFilterExpenseReportBottomSheet extends StatefulWidget {
  final String reportId;

  const BrandOwnerFilterExpenseReportBottomSheet({
    super.key,
    required this.reportId,
  });

  @override
  State<BrandOwnerFilterExpenseReportBottomSheet> createState() =>
      _BrandOwnerFilterExpenseReportBottomSheetState();
}

class _BrandOwnerFilterExpenseReportBottomSheetState
    extends State<BrandOwnerFilterExpenseReportBottomSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectType(BuildContext context, BrandOwnerExpenseReportType type) {
    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<BrandOwnerExpenseReportType>(
          fieldName: 'expenseType',
          value: type,
          isValid: true,
        );
  }

  void _selectStatus(
    BuildContext context,
    BrandOwnerExpenseReportStatus status,
  ) {
    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<BrandOwnerExpenseReportStatus>(
          fieldName: 'expenseStatus',
          value: status,
          isValid: true,
        );
  }

  void _selectBranch(
    BuildContext context,
    BrandOwnerPaymentLogBranchItem branch,
  ) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<String>(
      fieldName: 'branch',
      value: branch.id,
      isValid: true,
    );
  }

  void _selectMonth(BuildContext context, int month) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<int>(
      fieldName: 'monthNumber',
      value: month,
      isValid: true,
    );
  }

  void _selectYear(BuildContext context, int year) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<int>(
      fieldName: 'year',
      value: year,
      isValid: true,
    );
  }

  void _showResults(BuildContext context) {
    NavigationService.I.pop();

    context.read<BrandOwnerExpenseReportDetailsCubit>().loadReport(
      reportId: widget.reportId,
      filters: BrandOwnerExpenseReportFilterEntity(
        branchId: context.read<ValidationCubit>().getTypedValue<String>(
          'branch',
        ),
        type: context
            .read<ValidationCubit>()
            .getTypedValue<BrandOwnerExpenseReportType>('expenseType'),
        status: context
            .read<ValidationCubit>()
            .getTypedValue<BrandOwnerExpenseReportStatus>('expenseStatus'),
        date:
            (context.read<ValidationCubit>().getTypedValue<int>(
                      'monthNumber',
                    ) !=
                    null &&
                context.read<ValidationCubit>().getTypedValue<int>('year') !=
                    null)
            ? ExpenseReportDateFilterEntity(
                month: context.read<ValidationCubit>().getTypedValue<int>(
                  'monthNumber',
                )!,
                year: context.read<ValidationCubit>().getTypedValue<int>(
                  'year',
                )!,
              )
            : null,
      ),
    );
  }

  void _clearFilters(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit
        .validateFieldAndStoreTypedValue<BrandOwnerExpenseReportType?>(
          fieldName: 'expenseType',
          value: null,
          isValid: false,
        );

    validationCubit
        .validateFieldAndStoreTypedValue<BrandOwnerExpenseReportStatus?>(
          fieldName: 'expenseStatus',
          value: null,
          isValid: false,
        );

    validationCubit.validateFieldAndStoreTypedValue<String?>(
      fieldName: 'branch',
      value: null,
      isValid: false,
    );

    validationCubit.validateFieldAndStoreTypedValue<int?>(
      fieldName: 'monthNumber',
      value: null,
      isValid: false,
    );

    validationCubit.validateFieldAndStoreTypedValue<int?>(
      fieldName: 'year',
      value: null,
      isValid: false,
    );

    _searchController.clear();

    NavigationService.I.pop();

    context.read<BrandOwnerExpenseReportDetailsCubit>().loadReport(
      reportId: widget.reportId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(
                        'Filter Payment Log By:',
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Row(
                      spacing: 10.w,
                      children: List.generate(2, (index) {
                        final texts = [
                          context.tr.quickCashExpense,
                          context.tr.invoice,
                        ];

                        final values = [
                          BrandOwnerExpenseReportType.quickCash,
                          BrandOwnerExpenseReportType.invoice,
                        ];

                        return Expanded(
                          child:
                              BlocSelector<
                                ValidationCubit,
                                ValidationState,
                                BrandOwnerExpenseReportType?
                              >(
                                selector: (state) => state
                                    .getTypedValue<BrandOwnerExpenseReportType>(
                                      'expenseType',
                                    ),
                                builder: (context, selectedType) {
                                  final isSelected =
                                      selectedType == values[index];

                                  return CustomTextButton(
                                    text: texts[index],
                                    onTap: () =>
                                        _selectType(context, values[index]),
                                    borderRadius: 1000.r,
                                    borderColor: isSelected
                                        ? context.theme.primaryColor
                                        : context.customColor.border,
                                    textColor: isSelected
                                        ? context.theme.primaryColor
                                        : context.customColor.text3,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.r,
                                    ),
                                  );
                                },
                              ),
                        );
                      }),
                    ),
                    10.verticalSpace,
                    Text(
                      context.tr.status,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    BlocSelector<
                      ValidationCubit,
                      ValidationState,
                      BrandOwnerExpenseReportStatus?
                    >(
                      selector: (state) =>
                          state.getTypedValue<BrandOwnerExpenseReportStatus?>(
                            'expenseStatus',
                          ),
                      builder: (context, selectedSort) {
                        return Row(
                          spacing: 10.h,
                          children: List.generate(3, (index) {
                            final texts = [
                              context.tr.pending,
                              context.tr.approved,
                              context.tr.rejected,
                            ];

                            final statusKeys = [
                              BrandOwnerExpenseReportStatus.pending,
                              BrandOwnerExpenseReportStatus.approved,
                              BrandOwnerExpenseReportStatus.rejected,
                            ];

                            final isSelected =
                                selectedSort == statusKeys[index];

                            return Expanded(
                              child: CustomTextButton(
                                text: texts[index],
                                onTap: () =>
                                    _selectStatus(context, statusKeys[index]),
                                borderRadius: 1000.r,
                                borderColor: isSelected
                                    ? context.theme.primaryColor
                                    : context.customColor.border,
                                textColor: isSelected
                                    ? context.theme.primaryColor
                                    : context.customColor.text3,
                                padding: EdgeInsets.symmetric(vertical: 10.r),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    10.verticalSpace,
                    Text(
                      context.tr.date,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown<int>(
                            items: const [
                              1,
                              2,
                              3,
                              4,
                              5,
                              6,
                              7,
                              8,
                              9,
                              10,
                              11,
                              12,
                            ],
                            displayTextBuilder: (value) => value != null
                                ? value.toString()
                                : context.tr.selectMonth,
                            itemBuilder: (context, item, isSelected) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 10.r,
                                ),
                                child: Text(
                                  item.toString(),
                                  style: AppStyles.s13W500.copyWith(
                                    color: isSelected
                                        ? context.theme.primaryColor
                                        : context.customColor.text1,
                                  ),
                                ),
                              );
                            },
                            onChanged: (value) {
                              _selectMonth(context, value);
                            },
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: CustomDropdown<int>(
                            items: List.generate(
                              10,
                              (index) => DateTime.now().year - index,
                            ),
                            displayTextBuilder: (value) => value != null
                                ? value.toString()
                                : context.tr.selectYear,
                            itemBuilder: (context, item, isSelected) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 10.r,
                                ),
                                child: Text(
                                  item.toString(),
                                  style: AppStyles.s13W500.copyWith(
                                    color: isSelected
                                        ? context.theme.primaryColor
                                        : context.customColor.text1,
                                  ),
                                ),
                              );
                            },
                            onChanged: (value) {
                              _selectYear(context, value);
                            },
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    BlocSelector<
                      SearchCubit<BrandOwnerPaymentLogBranchItem>,
                      SearchState<BrandOwnerPaymentLogBranchItem>,
                      int
                    >(
                      selector: (state) {
                        if (state
                            is SearchSuccess<BrandOwnerPaymentLogBranchItem>) {
                          return state.results.length;
                        }

                        return 0;
                      },
                      builder: (context, state) {
                        return Text(
                          '${context.tr.storeBranch} ($state)',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        );
                      },
                    ),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 12.r,
                      ),
                      height: 250.h,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AppSvg(assetName: AppAssets.search, width: 15.r),
                              10.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  controller: _searchController,
                                  hintText: 'Search by branch name',
                                  onChanged: (value) {
                                    context
                                        .read<
                                          SearchCubit<
                                            BrandOwnerPaymentLogBranchItem
                                          >
                                        >()
                                        .search(
                                          value,
                                          (item, query) => item.name
                                              .toLowerCase()
                                              .contains(query.toLowerCase()),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          const CustomDivider(),
                          10.verticalSpace,
                          Expanded(
                            child:
                                BlocListener<
                                  BrandOwnerPaymentLogCubit,
                                  BrandOwnerPaymentLogState
                                >(
                                  listener: (context, state) {
                                    if (state
                                        is BrandOwnerPaymentLogBranchesSuccess) {
                                      final branches = state.branches;
                                      context
                                          .read<
                                            SearchCubit<
                                              BrandOwnerPaymentLogBranchItem
                                            >
                                          >()
                                          .setData(branches);
                                    }
                                  },
                                  child:
                                      BlocBuilder<
                                        BrandOwnerPaymentLogCubit,
                                        BrandOwnerPaymentLogState
                                      >(
                                        builder: (context, state) {
                                          if (state
                                              is BrandOwnerPaymentLogLoading) {
                                            return const AppLoadingWidget();
                                          } else if (state
                                              is BrandOwnerPaymentLogFailure) {
                                            return AppFailureWidget(
                                              failure: state.failure,
                                              onRetry: () => context
                                                  .read<
                                                    BrandOwnerPaymentLogCubit
                                                  >()
                                                  .getBrandOwnerPaymentLogBranches(),
                                            );
                                          }

                                          return BlocBuilder<
                                            SearchCubit<
                                              BrandOwnerPaymentLogBranchItem
                                            >,
                                            SearchState<
                                              BrandOwnerPaymentLogBranchItem
                                            >
                                          >(
                                            builder: (context, state) {
                                              if (state
                                                  is SearchSuccess<
                                                    BrandOwnerPaymentLogBranchItem
                                                  >) {
                                                final branches = state.results;

                                                return ListView.builder(
                                                  itemCount: branches.length,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (context, index) {
                                                    final branch =
                                                        branches[index];

                                                    return Column(
                                                      children: [
                                                        BlocSelector<
                                                          ValidationCubit,
                                                          ValidationState,
                                                          String?
                                                        >(
                                                          selector: (state) =>
                                                              state.getTypedValue<
                                                                String
                                                              >(
                                                                'paymentLogBranch',
                                                              ),
                                                          builder:
                                                              (
                                                                context,
                                                                selectedBranchId,
                                                              ) {
                                                                return AppGestureDetectorButton(
                                                                  onTap: () =>
                                                                      _selectBranch(
                                                                        context,
                                                                        branch,
                                                                      ),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          branch
                                                                              .name,
                                                                          style: AppStyles.s13W500.copyWith(
                                                                            color:
                                                                                context.customColor.text1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      10.horizontalSpace,
                                                                      SelectionCircule(
                                                                        isSelected:
                                                                            selectedBranchId ==
                                                                            branch.id,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                        ),
                                                        10.verticalSpace,
                                                      ],
                                                    );
                                                  },
                                                );
                                              }

                                              return const SizedBox();
                                            },
                                          );
                                        },
                                      ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              spacing: 10.w,
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.defaultSettings,
                    onTap: () => _clearFilters(context),
                    borderRadius: 15.r,
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    textColor: context.customColor.text1,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ValidationCubit, ValidationState>(
                    builder: (context, validationState) {
                      return AppButton(
                        text: context.tr.showResults,
                        enabled: validationState.enableButton,
                        onClick: () => _showResults(context),
                        borderRadius: BorderRadius.circular(15.r),
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
