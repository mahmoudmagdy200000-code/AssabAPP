import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/add_cashier_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsSummarizeWidget extends StatelessWidget {
  const DetailsSummarizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCashierCubit, AddCashierState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: AppPaddingWidget(
            right: 5.w,
            left: 5.w,
            child: SizedBox(
              height: 600.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.reviewBeforeProceed,
                    style: AppStyles.s20W500,
                  ),
                  2.verticalSpace,
                  Text(
                    context.tr.reviewBeforeProceedDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  7.verticalSpace,
                  const CustomDivider(),
                  15.verticalSpace,

                  SummarizeCardWidget(
                    height: 190.h,
                    columnSpacing: 15.h,
                    children: [
                      2.verticalSpace,
                      Text(
                        context.tr.accountDetails,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),

                      SizedBox(width: 250.w, child: const CustomDivider()),

                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.employeeNameTitle,
                        data:
                            context.watch<AddCashierCubit>().fullName ?? 'N/A',
                      ),
                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.emailTitle,
                        data: context.watch<AddCashierCubit>().email ?? 'N/A',
                      ),

                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.roleTitle,
                        data: 'Cashier',
                      ),
                    ],
                  ),

                  10.verticalSpace,

                  SummarizeCardWidget(
                    height: 200.h,
                    columnSpacing: 15.h,
                    children: [
                      2.verticalSpace,
                      Text(
                        context.tr.shiftDetails,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),

                      SizedBox(width: 250.w, child: const CustomDivider()),

                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.storeBranch,
                        data:
                            context.read<AddCashierCubit>().storeBranch ??
                            'N/A',
                      ),
                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.workDays,
                        data: context.tr.sundayThursday,
                      ),

                      SummarizeRowAttributeEntityWidget(
                        title: context.tr.shiftTitle,
                        data:
                            context.read<AddCashierCubit>().shift?.name ??
                            'N/A',
                        subData:
                            '${context.read<AddCashierCubit>().shift?.formatTime12(context.read<AddCashierCubit>().shift?.startTime) ?? 'N/A'} - ${context.read<AddCashierCubit>().shift?.formatTime12(context.read<AddCashierCubit>().shift?.endTime) ?? 'N/A'}',
                      ),
                    ],
                  ),

                  10.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SummarizeRowAttributeEntityWidget extends StatelessWidget {
  const SummarizeRowAttributeEntityWidget({
    super.key,
    required this.title,
    required this.data,
    this.subData,
  });

  final String title;
  final String data;
  final String? subData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 180.w),
              child: Text(
                data,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (subData != null)
              Container(
                constraints: BoxConstraints(maxWidth: 180.w),
                child: Text(
                  subData!,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class SummarizeCardWidget extends StatelessWidget {
  const SummarizeCardWidget({
    super.key,
    required this.children,
    this.height,
    this.columnSpacing,
  });

  final List<Widget> children;
  final double? height;
  final double? columnSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: columnSpacing ?? 10.h,
        children: children,
      ),
    );
  }
}
