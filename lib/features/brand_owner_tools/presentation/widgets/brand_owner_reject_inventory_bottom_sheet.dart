import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';

class BrandOwnerRejectInventoryBottomSheet extends StatelessWidget {
  final String id;
  final String desc;
  final List<String?> itemsImages;
  final List<String> itemNames;
  final VoidCallback rejectAllOnTap;

  const BrandOwnerRejectInventoryBottomSheet({
    super.key,
    required this.id,
    required this.desc,
    required this.itemsImages,
    required this.itemNames,
    required this.rejectAllOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.rejectAll,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.verticalSpace,
            Text(
              desc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemCount: itemsImages.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return 10.verticalSpace;
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: context.customColor.text2,
                        width: 10.r,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.r,
                      vertical: 5.r,
                    ),
                    child: Row(
                      children: [
                        PurchaseItemImage(image: itemsImages[index]),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            itemNames[index],
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            10.verticalSpace,
            CustomTextButton(
              text: context.tr.rejectAll,
              onTap: rejectAllOnTap,
              backgroundColor: context.customColor.error,
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(vertical: 14.r),
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
