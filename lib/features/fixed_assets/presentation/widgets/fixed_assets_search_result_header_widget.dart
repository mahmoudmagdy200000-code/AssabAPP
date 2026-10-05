import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/fixed_assets_search_response.dart';

class FixedAssetsSearchResultHeaderWidget extends StatelessWidget {
  final FixedAssetsSearchResponse searchResults;

  const FixedAssetsSearchResultHeaderWidget({
    super.key,
    required this.searchResults,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: context.customColor.text2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${searchResults.assetTypeName} (${searchResults.items.length})',
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                // SizedBox(height: 4.h),
                // Text(
                //   '[Nakheel Branch | Updated: 2 Minutes]',
                //   style: AppStyles.s12W400.copyWith(
                //     color: context.customColor.text4,
                //   ),
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),
          // SizedBox(width: 12.w),
          // AppSvgButton(assetName: AppAssets.filter, onTap: () {}),
        ],
      ),
    );
  }
}
