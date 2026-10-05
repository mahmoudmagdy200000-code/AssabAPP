import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialAuditCountAssetsWidget extends StatelessWidget {
  const InitialAuditCountAssetsWidget({super.key});

  List<String> get _zones => ['Kitchen', 'Dining', 'Store'];
  List<String> get _types => ['Electronics', 'Furniture', 'Equipment'];
  List<String> get _statuses => ['Excellent', 'Maintenance', 'Problem'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 17.r),
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(
                assetName: AppAssets.assetCoinSvg,
                width: 20.r,
                height: 20.r,
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.countAssets,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      context.tr.clickOnAddButtonToGetStarted,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Container(
            padding: EdgeInsets.all(17.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerCustomTextField(
                  label: context.tr.name,
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 17.r,
                    vertical: 14.r,
                  ),
                  child: CustomTextField(
                    hintText: 'e.g Coffee Machine',
                    onChanged: (value) {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreValue(
                            fieldName: 'name',
                            value: value,
                            isValid: value.isNotEmpty,
                          );
                    },
                  ),
                ),
                16.verticalSpace,
                ContainerCustomTextField(
                  label: context.tr.totalNumberOfAsset,
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 17.r,
                    vertical: 14.r,
                  ),
                  child: CustomTextField(
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreValue(
                            fieldName: 'totalAssets',
                            value: value,
                            isValid: value.isNotEmpty,
                          );
                    },
                  ),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(child: _buildZoneDropdown(context)),
                    12.horizontalSpace,
                    Expanded(child: _buildTypeDropdown(context)),
                  ],
                ),
                16.verticalSpace,
                _buildPhotoSection(context),
                16.verticalSpace,
                _buildStatusDropdown(context),
              ],
            ),
          ),
          16.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: context.tr.addAssetNumber('2'),
            icon: AppSvg(
              assetName: AppAssets.add,
              width: 14.r,
              height: 14.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            isTransparent: false,
            backgroundColor: context.theme.primaryColor.withOpacity(0.07),
            borderColor: context.customColor.border,
            textColor: context.theme.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            borderRadius: BorderRadius.circular(100.r),
            textStyle: AppStyles.s12W500.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.zone),
        CustomDropdown<String>(
          items: _zones,
          hint: context.tr.choose,
          itemBuilder: (ctx, item, isSelected) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
            child: Text(
              item,
              style: AppStyles.s14W400.copyWith(
                color: isSelected
                    ? ctx.theme.primaryColor
                    : ctx.customColor.text1,
              ),
            ),
          ),
          onChanged: (val) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'zone',
              value: val,
              isValid: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.type),
        CustomDropdown<String>(
          items: _types,
          hint: context.tr.choose,
          itemBuilder: (ctx, item, isSelected) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
            child: Text(
              item,
              style: AppStyles.s14W400.copyWith(
                color: isSelected
                    ? ctx.theme.primaryColor
                    : ctx.customColor.text1,
              ),
            ),
          ),
          onChanged: (val) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'type',
              value: val,
              isValid: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.status),
        CustomDropdown<String>(
          items: _statuses,
          hint: context.tr.choose,
          itemBuilder: (ctx, item, isSelected) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
            child: Text(
              item,
              style: AppStyles.s14W400.copyWith(
                color: isSelected
                    ? ctx.theme.primaryColor
                    : ctx.customColor.text1,
              ),
            ),
          ),
          onChanged: (val) {
            context.read<ChooseItemCubit>().selectItem(_statuses.indexOf(val));
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'status',
              value: val,
              isValid: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.documentationPhotos),
        Row(
          children: [
            Expanded(
              child: _buildPhotoUploadBtn(
                context,
                icon: AppAssets.cameraConfig,
                label: context.tr.newPhoto,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _buildPhotoUploadBtn(
                context,
                icon: AppAssets.galleryConfig,
                label: context.tr.fromFiles,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploadBtn(
    BuildContext context, {
    required String icon,
    required String label,
  }) {
    return AppGestureDetectorButton(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17.r),
        decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.customColor.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(
              assetName: icon,
              width: 16.r,
              height: 16.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Text(
              label,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
