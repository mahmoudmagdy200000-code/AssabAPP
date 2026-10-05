import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/entities/brand_owner_custody_report_details_entity.dart';
import '../../domain/repositories/brand_owner_reports_and_analytics_repository.dart';
import '../../domain/usecases/get_custody_report_details_usecase.dart';
import '../cubit/brand_owner_custody_report_details_cubit.dart';
import '../cubit/brand_owner_custody_report_details_state.dart';
import '../cubit/export_custody_report_cubit.dart';
import '../cubit/export_custody_report_state.dart';
import '../widgets/brand_owner_export_custody_report_bottom_sheet.dart';
import '../widgets/brand_owner_export_expense_report_bottom_sheet.dart';

class BrandOwnerCustodyReportDetailsScreen extends StatelessWidget {
  final VoidCallback? onExportSuccess;

  const BrandOwnerCustodyReportDetailsScreen({super.key, this.onExportSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrandOwnerCustodyReportDetailsCubit(
        GetIt.I<GetCustodyReportDetailsUseCase>(),
      )..loadCustodyReport(reportId: 'default'),
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
                  BlocBuilder<
                    BrandOwnerCustodyReportDetailsCubit,
                    BrandOwnerCustodyReportDetailsState
                  >(
                    builder: (context, state) {
                      final periodLabel =
                          state is BrandOwnerCustodyReportDetailsSuccess
                          ? state.data.periodLabel
                          : 'June Custody Summary';
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              periodLabel,
                              style: AppStyles.s16W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              context.tr.trackEverySpendInOnePlace,
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  10.horizontalSpace,
                  ButtonTextIcon(
                    onTap: () {
                      AppBottomSheet.customPageRoute(
                        context,
                        (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => ValidationCubit(
                                requiredFields: {
                                  'formatType',
                                  'year',
                                  'monthNumber',
                                },
                              ),
                            ),
                            BlocProvider(
                              create: (context) => ExportCustodyReportCubit(
                                GetIt.I<
                                  BrandOwnerReportsAndAnalyticsRepository
                                >(),
                              ),
                            ),
                          ],
                          child: BrandOwnerExportCustodyReportBottomSheet(
                            onExportSuccess: onExportSuccess,
                          ),
                        ),
                      );
                    },
                    label: context.tr.exportLabel,
                    icon: AppSvg(
                      assetName: AppAssets.download,
                      width: 14.r,
                      colorFilter: ColorFilter.mode(
                        context.theme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    textStyle: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 8.r,
                    ),
                    backgroundColor: context.customColor.reversedTextColor,
                    borderColor: Colors.transparent,
                    reversed: true,
                    borderRadius: BorderRadius.circular(8.r),
                    spaceBetweenTextAndIcon: 7,
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
                      BrandOwnerCustodyReportDetailsCubit,
                      BrandOwnerCustodyReportDetailsState
                    >(
                      builder: (context, state) {
                        if (state is BrandOwnerCustodyReportDetailsLoading) {
                          return const AppLoadingWidget();
                        }

                        if (state is BrandOwnerCustodyReportDetailsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: () {},
                          );
                        }

                        if (state is BrandOwnerCustodyReportDetailsSuccess) {
                          return _buildContent(context, state.data);
                        }

                        return AppLocalFailure(
                          onRetry: () {
                            context
                                .read<BrandOwnerCustodyReportDetailsCubit>()
                                .loadCustodyReport(reportId: 'default');
                          },
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandOwnerCustodyReportDetailsEntity data,
  ) {
    return Column(
      children: [
        Row(
          children: [
            AppSvg(
              assetName: AppAssets.custody,
              width: 25.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                data.periodLabel,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            10.horizontalSpace,
            Text(
              '${data.branches.length} Accounts',
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        const CustomDivider(),
        10.verticalSpace,
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: data.branches.length,
            itemBuilder: (context, index) {
              final person = data.branches[index];

              return Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(12.r),
                margin: EdgeInsets.only(bottom: 12.r),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ProfileImageWidget(
                              height: 170.h,
                              width: 170.h,
                              image: person.imageUrl,
                            ),
                          ),
                          10.verticalSpace,
                          const CustomDivider(),
                          10.verticalSpace,
                          _buildRow(
                            context,
                            AppAssets.personSvg,
                            context.tr.name,
                            person.name,
                          ),
                          10.verticalSpace,
                          _buildRow(
                            context,
                            AppAssets.branchStoreSvg,
                            context.tr.branch,
                            person.branch,
                          ),
                          20.verticalSpace,
                          Text(
                            'Current Custody Balance',
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          5.verticalSpace,
                          Row(
                            children: [
                              const SaudiRiyalSvgWidget(),
                              10.horizontalSpace,
                              Text(
                                person.currentBalance.toStringAsFixed(2),
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    _buildAmmountRow(
                      context: context,
                      title:
                          '${person.amounts.monthName} ${context.tr.openingBalance}',
                      amount: person.amounts.monthOpeningBalance,
                      sideColor: context.customColor.text1,
                      amountColor: context.customColor.text1,
                    ),
                    10.verticalSpace,
                    _buildAmmountRow(
                      context: context,
                      title: context.tr.totalCashIn,
                      amount: person.amounts.totalCashIn,
                      sideColor: AppColors.lightGreen,
                    ),
                    10.verticalSpace,
                    _buildAmmountRow(
                      context: context,
                      title: context.tr.totalCashOut,
                      amount: person.amounts.totalCashOut,
                      sideColor: context.customColor.error,
                    ),
                    10.verticalSpace,
                    _buildAmmountRow(
                      context: context,
                      title: context.tr.currentBalance,
                      amount: person.amounts.currentBalance,
                      sideColor: context.customColor.text1,
                      amountColor: context.customColor.text1,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDefaultAmountRows(BuildContext context) {
    return [
      _buildAmmountRow(
        context: context,
        title: 'June ${context.tr.openingBalance}',
        amount: 12.01,
        sideColor: context.customColor.text1,
        amountColor: context.customColor.text1,
      ),
      10.verticalSpace,
      _buildAmmountRow(
        context: context,
        title: context.tr.totalCashIn,
        amount: 24019.19,
        sideColor: AppColors.lightGreen,
      ),
      10.verticalSpace,
      _buildAmmountRow(
        context: context,
        title: context.tr.totalCashOut,
        amount: -19457.90,
        sideColor: context.customColor.error,
      ),
      10.verticalSpace,
      _buildAmmountRow(
        context: context,
        title: context.tr.currentBalance,
        amount: 4561.29,
        sideColor: context.customColor.text1,
        amountColor: context.customColor.text1,
      ),
    ];
  }

  Widget _buildRow(
    BuildContext context,
    String assetName,
    String title,
    String value, {
    bool isCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSvg(
                assetName: assetName,
                width: 15.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCurrency) const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmmountRow({
    required BuildContext context,
    required String title,
    required double amount,
    required Color sideColor,
    Color? amountColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(height: 30.h, width: 3.w, color: sideColor),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  amount.toStringAsFixed(2),
                  style: AppStyles.s13W500.copyWith(
                    color:
                        amountColor ??
                        (amount < 0
                            ? context.customColor.error
                            : AppColors.lightGreen),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
