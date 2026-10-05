import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/locale/locale_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_logout_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/change_language_bottom_sheet_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'supplier_settings_system_settings_item_widget.dart';

class SupplierSettingsSystemSettingsSection extends StatelessWidget {
  const SupplierSettingsSystemSettingsSection({super.key});

  void _showChangeLanguageBottomSheet(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();

    AppBottomSheet.showModal(
      context,
      (context) => BlocProvider.value(
        value: localeCubit,
        child: const ChangeLanguageBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customColor.reversedTextColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.systemSettings,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, state) {
              return SupplierSettingsSystemSettingsItemWidget(
                onTap: () => _showChangeLanguageBottomSheet(context),
                title: context.tr.language,
                assetName: AppAssets.language,
                selectedValue: state.languageCode == 'en'
                    ? 'English'
                    : 'العربية',
                customIcon: AppSvg(
                  assetName: state.languageCode == 'en'
                      ? AppAssets.enFlag
                      : AppAssets.arFlag,
                  width: 13.r,
                ),
              );
            },
          ),
          SupplierSettingsSystemSettingsItemWidget(
            onTap: () {},
            title: context.tr.theme,
            assetName: AppAssets.theme,
          ),
          16.verticalSpace,
          const AppLogoutButton(),
        ],
      ),
    );
  }
}
