import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/get_monthly_setup_info/get_monthly_setup_info_cubit.dart';
import '../cubit/get_monthly_setup_info/get_monthly_setup_info_state.dart';

class MonthlyInventoryInventoryInfoSection extends StatefulWidget {
  const MonthlyInventoryInventoryInfoSection({super.key});

  @override
  State<MonthlyInventoryInventoryInfoSection> createState() =>
      _MonthlyInventoryInventoryInfoSectionState();
}

class _MonthlyInventoryInventoryInfoSectionState
    extends State<MonthlyInventoryInventoryInfoSection> {
  late final ValueNotifier<bool> _valueNotifier;

  @override
  void initState() {
    super.initState();

    _valueNotifier = ValueNotifier<bool>(true);
    _getSetupInfo();
  }

  @override
  void dispose() {
    _valueNotifier.dispose();

    super.dispose();
  }

  void _getSetupInfo() {
    context.read<GetMonthlySetupInfoCubit>().getMonthlySetupInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (context, value, child) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: !value
                      ? BorderRadius.circular(20.r)
                      : BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 13.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr.inventoryInformation,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: value
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      size: 18.r,
                      padding: 5.r,
                      iconColor: context.customColor.text1,
                      onPressed: () {
                        _valueNotifier.value = !_valueNotifier.value;
                      },
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: !value
                    ? const SizedBox.shrink()
                    : BlocBuilder<
                        GetMonthlySetupInfoCubit,
                        GetMonthlySetupInfoState
                      >(
                        builder: (context, state) {
                          if (state is GetMonthlySetupInfoLoading) {
                            return const AppLoadingWidget();
                          } else if (state is GetMonthlySetupInfoFailure) {
                            return AppFailureWidget(
                              failure: state.failure,
                              onRetry: _getSetupInfo,
                              withBorder: false,
                            );
                          } else if (state is GetMonthlySetupInfoSuccess) {
                            final data = state.data;

                            return Container(
                              margin: EdgeInsets.all(16.r),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    context: context,
                                    label: context.tr.date,
                                    value: data.date,
                                    asset: AppAssets.calendar,
                                  ),
                                  10.verticalSpace,
                                  _buildInfoRow(
                                    context: context,
                                    label: context.tr.numberOfProducts,
                                    value:
                                        '${data.numberOfProducts} ${context.tr.product}',
                                    asset: AppAssets.calendar,
                                  ),
                                  10.verticalSpace,
                                  _buildInfoRow(
                                    context: context,
                                    label: context.tr.expectedTime,
                                    value: data.expectedTimeLabel,
                                    asset: AppAssets.clockSvg,
                                  ),
                                ],
                              ),
                            );
                          }

                          return AppLocalFailure(
                            onRetry: _getSetupInfo,
                            withBorder: false,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required String asset,
  }) {
    return Row(
      children: [
        AppSvg(
          assetName: asset,
          width: 16.r,
          colorFilter: ColorFilter.mode(
            context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
