import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import '../../../logic/add_cashier/get_branches_cubit.dart';

class BranchSelectorBottomSheet extends StatefulWidget {
  const BranchSelectorBottomSheet({
    super.key,
    required this.onConfirm,
    this.initialBranchName,
  });

  final void Function(String branchName, String branchId) onConfirm;
  final String? initialBranchName;

  @override
  State<BranchSelectorBottomSheet> createState() =>
      _BranchSelectorBottomSheetState();
}

class _BranchSelectorBottomSheetState extends State<BranchSelectorBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _query = ValueNotifier('');

  String _branchId = '';

  @override
  void initState() {
    super.initState();

    final cubit = context.read<GetBranchesCubit>();
    cubit.getBranches(resetPagination: true);

    _scrollController.addListener(() {
      if (_query.value.isNotEmpty) return;

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (cubit.hasMore) {
          cubit.getBranches(resetPagination: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.validateFieldAndStoreValue(
      fieldName: 'storeBranch',
      value: '',
      isValid: false,
    );

    late List<BranchEntity> branches;

    return BlocProvider(
      create: (context) => ChooseItemCubit(),
      child: BlocBuilder<GetBranchesCubit, GetBranchesState>(
        builder: (context, cashierState) {
          // --- handle states first ---
          if (cashierState is GetBranchesLoading) {
            return const AppLoadingWidget();
          }

          if (cashierState is GetBranchesFailure) {
            return AppFailureWidget(
              failure: cashierState.failure,
              onRetry: () => context.read<GetBranchesCubit>().getBranches(
                resetPagination: true,
              ),
            );
          }

          if (cashierState is GetBranchesSuccess) {
            branches = cashierState.branches;

            if (widget.initialBranchName != null) {
              final searchIndex = branches.indexWhere(
                (s) => s.name == widget.initialBranchName,
              );
              if (searchIndex != -1) {
                context.read<ChooseItemCubit>().selectItem(searchIndex);

                context.read<ValidationCubit>().validateFieldAndStoreValue(
                  fieldName: 'storeBranch',
                  value: branches[searchIndex].name,
                  isValid: true,
                );
              }
            }
          }

          return AppPaddingWidget(
            child: SizedBox(
              height: 600.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr.cashierStoreBranch, style: AppStyles.s20W500),
                  2.verticalSpace,
                  Text(
                    context.tr.cashierStoreBranchDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  7.verticalSpace,
                  const CustomDivider(),
                  15.verticalSpace,

                  // --- Search box ---
                  SizedBox(
                    width: 300.w,
                    child: ContainerCustomTextField(
                      backgroundColor: context.customColor.reversedTextColor,
                      borderColor: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: context.customColor.text1,
                            size: 20.w,
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: CustomTextField(
                              maxLength: 30,
                              isFilled: true,
                              hintText: context.tr.searchBranch,
                              controller: _searchController,
                              onChanged: (text) =>
                                  _query.value = text.toLowerCase(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  5.verticalSpace,

                  // --- Filtered list ---
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _query,
                      builder: (_, q, __) {
                        final filtered = branches
                            .where(
                              (b) => b.name.toLowerCase().contains(q),
                            ) // assuming BranchEntity has name
                            .toList();

                        return BlocBuilder<ValidationCubit, ValidationState>(
                          builder: (context, state) {
                            return ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 5.h,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final branch = filtered[index];
                                return AppPaddingWidget(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  top: 15.r,
                                  child: AppGestureDetectorButton(
                                    onTap: () {
                                      context
                                          .read<ChooseItemCubit>()
                                          .selectItem(index);

                                      validationCubit
                                          .validateFieldAndStoreValue(
                                            fieldName: 'storeBranch',
                                            value: branch.name,
                                            isValid: true,
                                          );

                                      _branchId = filtered[index].id!;
                                    },
                                    child: Row(
                                      children: [
                                        AppSvg(
                                          assetName: AppAssets.branchStoreSvg,
                                          width: 25.w,
                                          height: 25.h,
                                        ),
                                        10.horizontalSpace,
                                        Expanded(
                                          child:
                                              BlocSelector<
                                                ChooseItemCubit,
                                                ChooseItemState,
                                                int?
                                              >(
                                                selector: (state) =>
                                                    state.selectedIndex,
                                                builder: (context, selectedIndex) {
                                                  return RowTextCirculeSelection(
                                                    text: branch.name,
                                                    isSelected:
                                                        selectedIndex == index,
                                                  );
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  15.verticalSpace,

                  BlocBuilder<ValidationCubit, ValidationState>(
                    builder: (context, state) {
                      final selectedBranch = state.fieldsValue['storeBranch'];

                      return AppButton(
                        text: context.tr.confirm,
                        enabled: selectedBranch?.isNotEmpty == true,
                        onClick: () {
                          if (selectedBranch != null) {
                            validationCubit.validateFieldAndStoreValue(
                              fieldName: 'storeBranch',
                              value: selectedBranch,
                              isValid: true,
                            );
                            context.read<GetBranchesCubit>().storeBranch =
                                selectedBranch;

                            widget.onConfirm(
                              context.read<GetBranchesCubit>().storeBranch!,
                              _branchId,
                            );
                            NavigationService.I.pop();
                          }
                        },
                      );
                    },
                  ),
                  10.verticalSpace,
                ],
              ),
            ),
          );

          // Default fallback (shouldn't happen)
          // return const SizedBox.shrink();
        },
      ),
    );
  }
}
