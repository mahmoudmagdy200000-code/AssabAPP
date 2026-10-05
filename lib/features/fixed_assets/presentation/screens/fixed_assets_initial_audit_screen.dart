import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/initial_audit_bottom_buttons_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/initial_audit_count_assets_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/initial_audit_count_progress_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/initial_audit_zone_setup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixedAssetsInitialAuditScreen extends StatelessWidget {
  const FixedAssetsInitialAuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      bottomNavigationBar: const InitialAuditBottomButtonsWidget(),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(21.r, 13.r, 21.r, 20.r),
                child: Column(
                  children: [
                    const InitialAuditZoneSetupWidget(),
                    12.verticalSpace,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (_) => getIt<ChooseItemCubit>()),
                        BlocProvider(create: (_) => getIt<ValidationCubit>()),
                      ],
                      child: const InitialAuditCountAssetsWidget(),
                    ),
                    16.verticalSpace,
                    const InitialAuditCountProgressWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppPaddingWidget(
      top: 50.h,
      bottom: 14.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(isTransparent: true),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.initialAudit,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                6.verticalSpace,
                Text(
                  context.tr.addZonesAndCountAssetsAsNewBranch,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
