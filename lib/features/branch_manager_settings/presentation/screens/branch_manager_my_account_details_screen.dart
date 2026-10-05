import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../cubits/branch_manager_my_account_details_cubit.dart';
import '../cubits/branch_manager_my_account_details_state.dart';

class BranchManagerMyAccountDetailsScreen extends StatefulWidget {
  const BranchManagerMyAccountDetailsScreen({super.key});

  @override
  State<BranchManagerMyAccountDetailsScreen> createState() =>
      _BranchManagerMyAccountDetailsScreenState();
}

class _BranchManagerMyAccountDetailsScreenState
    extends State<BranchManagerMyAccountDetailsScreen> {
  late final BranchManagerMyAccountDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = getIt<BranchManagerMyAccountDetailsCubit>()..loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return ContainerCustomTextField(
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 12.r),
      label: label,
      isLabelRequired: false,
      isLabelOptional: false,
      labelColor: context.customColor.text3,
      borderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: Row(
        children: [
          Text(
            value,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My account details',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Edit your personal and profile details.',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                padding: EdgeInsets.all(16.r),
                child:
                    BlocBuilder<
                      BranchManagerMyAccountDetailsCubit,
                      BranchManagerMyAccountDetailsState
                    >(
                      builder: (context, state) {
                        switch (state) {
                          case BranchManagerMyAccountDetailsInitial():
                          case BranchManagerMyAccountDetailsLoading():
                            return const AppLoadingWidget();
                          case BranchManagerMyAccountDetailsFailure(
                            :final failure,
                          ):
                            return AppFailureWidget(
                              failure: failure,
                              onRetry: () {
                                context
                                    .read<BranchManagerMyAccountDetailsCubit>()
                                    .loadData();
                              },
                            );
                          case BranchManagerMyAccountDetailsLoaded(:final data):
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildField(
                                          context,
                                          label: 'First Name',
                                          value: data.firstName,
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: _buildField(
                                          context,
                                          label: 'Last Name',
                                          value: data.lastName,
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,
                                  _buildField(
                                    context,
                                    label: 'Email address',
                                    value: data.emailAddress,
                                  ),
                                  10.verticalSpace,
                                  _buildField(
                                    context,
                                    label: 'Role',
                                    value: data.role,
                                  ),
                                  10.verticalSpace,
                                  _buildField(
                                    context,
                                    label: 'Assigned to',
                                    value: data.assignedTo,
                                  ),
                                  10.verticalSpace,
                                  _buildField(
                                    context,
                                    label: 'Wrokday\'s',
                                    value: data.weekdays,
                                  ),
                                  10.verticalSpace,
                                  _buildField(
                                    context,
                                    label: 'Work Shift',
                                    value: data.workShift,
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: context.theme.primaryColor,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          'Only HR can make changes to this information. Please contact them for any updates.',
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                        }
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
