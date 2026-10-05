import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../widgets/fixed_assets_search_screen_bulk_actions_bottom_sheet.dart';
import '../widgets/fixed_assets_search_result_header_widget.dart';
import '../widgets/fixed_assets_search_result_summary_widget.dart';
import '../widgets/fixed_assets_search_result_list_widget.dart';

class FixedAssetsSearchResultScreen extends StatefulWidget {
  final FixedAssetsSearchResponse searchResults;

  const FixedAssetsSearchResultScreen({super.key, required this.searchResults});

  @override
  State<FixedAssetsSearchResultScreen> createState() =>
      _FixedAssetsSearchResultScreenState();
}

class _FixedAssetsSearchResultScreenState
    extends State<FixedAssetsSearchResultScreen> {
  @override
  void initState() {
    super.initState();

    _addSelectionKeys();
  }

  void _addSelectionKeys() {
    final validationCubit = context.read<ValidationCubit>();

    for (var item in widget.searchResults.items) {
      validationCubit.addDynamicFields({
        'item_${item.id}',
        'itemId_${item.id}',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            FixedAssetsSearchResultHeaderWidget(
              searchResults: widget.searchResults,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FixedAssetsSearchResultSummaryWidget(
                      summary: widget.searchResults.summary,
                    ),
                    SizedBox(height: 16.h),
                    FixedAssetsSearchResultListWidget(
                      items: widget.searchResults.items,
                    ),
                  ],
                ),
              ),
            ),
            AppPaddingWidget(
              child: Row(
                spacing: 10.w,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: ButtonTextIcon(
                      onTap: () {
                        NavigationService.I.popToFirst();
                      },
                      label: context.tr.backToDashboard,
                      backgroundColor: context.customColor.text2,
                      textColor: context.customColor.text1,
                      borderRadius: BorderRadius.circular(15.r),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.r,
                        horizontal: 20.r,
                      ),
                      icon: AppSvg(
                        assetName: AppAssets.home,
                        width: 16.r,
                        colorFilter: ColorFilter.mode(
                          context.customColor.text1,
                          BlendMode.srcIn,
                        ),
                      ),
                      spaceBetweenTextAndIcon: 7.w,
                      isFlexible: true,
                    ),
                  ),
                  Flexible(
                    child:
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          List<FixedAssetsSearchItem>
                        >(
                          selector: (state) {
                            final selectedItems = widget.searchResults.items
                                .where(
                                  (item) =>
                                      state.fieldsValidity['item_${item.id}'] ==
                                      true,
                                )
                                .toList();

                            return selectedItems;
                          },
                          builder: (context, state) {
                            return AppButton(
                              onClick: () {
                                AppBottomSheet.customPageRoute(
                                  context,
                                  (context) =>
                                      FixedAssetsSearchScreenBulkActionsBottomSheet(
                                        selectedItemsCount: state.length,
                                        assets: state,
                                      ),
                                );
                              },
                              text: context.tr.bulkActions,
                              textColor: context.customColor.reversedTextColor,
                              borderRadius: BorderRadius.circular(15.r),
                              isFlexible: true,
                              enabled: state.length >= 2,
                              padding: EdgeInsets.symmetric(
                                vertical: 16.r,
                                horizontal: 20.r,
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
