import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_menu_engineering_entity.dart';

class BrandOwnerMenuEngineeringDetailsScreen extends StatelessWidget {
  final String type;
  final String itemsCount;
  final List<MenuEngineeringCategoryItemEntity>? items;

  const BrandOwnerMenuEngineeringDetailsScreen({
    super.key,
    required this.type,
    required this.itemsCount,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items ??
        const [
          MenuEngineeringCategoryItemEntity(
            category: 'Arabic Box',
            salesPercentage: 13.97,
            profitPercentage: 17,
          ),
          MenuEngineeringCategoryItemEntity(
            category: 'Pizza',
            salesPercentage: 22.5,
            profitPercentage: 30,
          ),
        ];

    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(
              assetName: AppAssets.eye,
              width: 24.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            5.verticalSpace,
            Text(
              context.tr.viewDetails,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              S.of(context).reviewBreakdownOfTheSelectedCategoryLists,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(12.r),
              child: Text(
                '$type - $itemsCount ${context.tr.items}',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              S.of(context).listBreakdown,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            5.verticalSpace,
            CategorySalesProfitTable(data: displayItems),
          ],
        ),
      ),
    );
  }
}

class CategorySalesProfitTable extends StatelessWidget {
  const CategorySalesProfitTable({super.key, required this.data});

  final List<MenuEngineeringCategoryItemEntity> data;

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            S.of(context).category,
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text3,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            S.of(context).salesPersintage,
            textAlign: TextAlign.center,
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text3,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            S.of(context).profit,
            textAlign: TextAlign.end,
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          10.verticalSpace,
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.separated(
        itemCount: data.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildRow(context, data[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 16.h,
            thickness: 1.r,
            color: context.customColor.border,
          );
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, MenuEngineeringCategoryItemEntity item) {
    return SizedBox(
      height: 32.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          final catWidth = totalWidth * (3 / 7);
          final salesWidth = totalWidth * (2 / 7);

          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.category,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.salesPercentage.toStringAsFixed(1)}%',
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.profitPercentage.toStringAsFixed(0)}%',
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                left: catWidth,
                top: 0,
                bottom: 0,
                child: _vLine(context),
              ),

              Positioned(
                left: catWidth + salesWidth,
                top: 0,
                bottom: 0,
                child: _vLine(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _vLine(BuildContext context) {
    return Container(width: 1.w, color: context.customColor.border);
  }
}
