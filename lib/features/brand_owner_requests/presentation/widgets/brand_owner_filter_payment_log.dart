import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/custody_preferred_receipt_method.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../cubits/brand_owner_payment_log_cubit.dart';
import '../cubits/brand_owner_payment_log_state.dart';

class BrandOwnerFilterPaymentLog extends StatefulWidget {
  final BrandOwnerPaymentLogCubit paymentLogCubit;
  final BrandOwnerPaymentLogFilterQuery initialQuery;

  const BrandOwnerFilterPaymentLog({
    super.key,
    required this.paymentLogCubit,
    this.initialQuery = const BrandOwnerPaymentLogFilterQuery(),
  });

  @override
  State<BrandOwnerFilterPaymentLog> createState() =>
      _BrandOwnerFilterPaymentLogState();
}

class _BrandOwnerFilterPaymentLogState
    extends State<BrandOwnerFilterPaymentLog> {
  late final TextEditingController _searchController;
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _validationCubit = ValidationCubit(
      requiredFields: {'paymentLogType', 'paymentLogSortBy'},
    );
    _seedInitialSelections();

    widget.paymentLogCubit.getBrandOwnerPaymentLogBranches();
  }

  @override
  void dispose() {
    _validationCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  void _seedInitialSelections() {
    final query = widget.initialQuery;

    if (query.type != null) {
      final parsedType = _parseType(query.type!);
      if (parsedType != null) {
        _validationCubit
            .validateFieldAndStoreTypedValue<CustodyPreferredReceiptMethod>(
              fieldName: 'paymentLogType',
              value: parsedType,
              isValid: true,
            );
      }
    }

    if (query.sortByDate != null) {
      final parsedSort = _parseSort(query.sortByDate!);
      if (parsedSort != null) {
        _validationCubit.validateFieldAndStoreTypedValue<TimeKeys>(
          fieldName: 'paymentLogSortBy',
          value: parsedSort,
          isValid: true,
        );
      }
    }

    if (query.branchId != null) {
      _validationCubit.validateFieldAndStoreTypedValue<String>(
        fieldName: 'paymentLogBranch',
        value: query.branchId!,
        isValid: true,
      );
    }
  }

  CustodyPreferredReceiptMethod? _parseType(String value) {
    for (final type in CustodyPreferredReceiptMethod.values) {
      if (type.value == value) {
        return type;
      }
    }

    return null;
  }

  TimeKeys? _parseSort(String value) {
    for (final sort in TimeKeys.values) {
      if (sort.key == value) {
        return sort;
      }
    }

    return null;
  }

  void _selectType(BuildContext context, CustodyPreferredReceiptMethod type) {
    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<CustodyPreferredReceiptMethod>(
          fieldName: 'paymentLogType',
          value: type,
          isValid: true,
        );
  }

  void _selectSortBy(BuildContext context, TimeKeys time) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<TimeKeys>(
      fieldName: 'paymentLogSortBy',
      value: time,
      isValid: true,
    );
  }

  void _selectBranch(
    BuildContext context,
    BrandOwnerPaymentLogBranchItem branch,
  ) {
    context.read<ValidationCubit>().validateFieldAndStoreTypedValue<String>(
      fieldName: 'paymentLogBranch',
      value: branch.id,
      isValid: true,
    );
  }

  void _showResults(BuildContext context) {
    final validationState = context.read<ValidationCubit>().state;
    final selectedType = validationState
        .getTypedValue<CustodyPreferredReceiptMethod>('paymentLogType');
    final selectedSort = validationState.getTypedValue<TimeKeys>(
      'paymentLogSortBy',
    );
    final selectedBranchId = validationState.getTypedValue<String>(
      'paymentLogBranch',
    );

    NavigationService.I.pop(
      BrandOwnerPaymentLogFilterQuery(
        type: selectedType?.value,
        sortByDate: selectedSort?.key,
        branchId: selectedBranchId,
      ),
    );
  }

  void _clearFilters(BuildContext context) {
    NavigationService.I.pop(const BrandOwnerPaymentLogFilterQuery());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _validationCubit,
      child: BlocProvider.value(
        value: widget.paymentLogCubit,
        child: Scaffold(
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
                              context.tr.cashHandover,
                              context.tr.bankTransfer,
                            ];
                            final values = [
                              CustodyPreferredReceiptMethod.cashHandover,
                              CustodyPreferredReceiptMethod.bankTransfer,
                            ];

                            return Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    CustodyPreferredReceiptMethod?
                                  >(
                                    selector: (state) =>
                                        state.getTypedValue<
                                          CustodyPreferredReceiptMethod
                                        >('paymentLogType'),
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
                          context.tr.sortByDate,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        5.verticalSpace,
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          TimeKeys?
                        >(
                          selector: (state) =>
                              state.getTypedValue<TimeKeys>('paymentLogSortBy'),
                          builder: (context, selectedSort) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              child: Column(
                                spacing: 10.h,
                                children: List.generate(3, (index) {
                                  final texts = [
                                    context.tr.last24Hours,
                                    context.tr.last7Days,
                                    context.tr.last30Days,
                                  ];

                                  final timeKeys = [
                                    TimeKeys.last24Hours,
                                    TimeKeys.last7Days,
                                    TimeKeys.last30Days,
                                  ];

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          texts[index],
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      GestureDetector(
                                        onTap: () => _selectSortBy(
                                          context,
                                          timeKeys[index],
                                        ),
                                        child: SelectionCircule(
                                          isSelected:
                                              selectedSort == timeKeys[index],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                        10.verticalSpace,
                        BlocSelector<
                          SearchCubit<BrandOwnerPaymentLogBranchItem>,
                          SearchState<BrandOwnerPaymentLogBranchItem>,
                          int
                        >(
                          selector: (state) {
                            if (state
                                is SearchSuccess<
                                  BrandOwnerPaymentLogBranchItem
                                >) {
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
                            border: Border.all(
                              color: context.customColor.border,
                            ),
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
                                  AppSvg(
                                    assetName: AppAssets.search,
                                    width: 15.r,
                                  ),
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
                                                  .contains(
                                                    query.toLowerCase(),
                                                  ),
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
                                                    final branches =
                                                        state.results;

                                                    return ListView.builder(
                                                      itemCount:
                                                          branches.length,
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
                                                                      onTap: () => _selectBranch(
                                                                        context,
                                                                        branch,
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              branch.name,
                                                                              style: AppStyles.s13W500.copyWith(
                                                                                color: context.customColor.text1,
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
        ),
      ),
    );
  }
}
