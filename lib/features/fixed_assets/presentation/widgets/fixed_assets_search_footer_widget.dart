import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../domain/enums/fixed_assets_quick_search_type.dart';
import '../../domain/enums/fixed_assets_search_type.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../data/models/fixed_assets_search_request.dart';
import '../cubit/fixed_assets_search/fixed_assets_search_cubit.dart';

class FixedAssetsSearchFooterWidget extends StatelessWidget {
  const FixedAssetsSearchFooterWidget({super.key});

  void _search(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    context.read<FixedAssetsSearchCubit>().search(
      request: FixedAssetsSearchRequest(
        searchType: validationCubit.getTypedValue<FixedAssetsSearchType>(
          'searchType',
        )!,
        zoneId: validationCubit.getFieldValue('zoneId'),
        typeId: validationCubit.getFieldValue('typeId'),
        employeeId: context.read<ValidationCubit>().getFieldValue(
          'responsibleId',
        ),
        date: validationCubit.getFieldValue('date'),
        quickSearchKey: validationCubit
            .getTypedValue<FixedAssetsQuickSearchType>('quickSearchType')
            ?.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: context.customColor.text4.withValues(alpha: 0.05),
            blurRadius: 20.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ButtonTextIcon(
                onTap: () {},
                label: context.tr.uploadImage,
                icon: AppSvg(assetName: AppAssets.upload, width: 14.r),
                spaceBetweenTextAndIcon: 7.w,
                padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child:
                  BlocConsumer<FixedAssetsSearchCubit, FixedAssetsSearchState>(
                    listener: (context, state) {
                      if (state is FixedAssetsSearchFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      } else if (state is FixedAssetsSearchSuccess) {
                        NavigationService.I.pushNamed(
                          AppRouteName.fixedAssetsSearchResultScreen,
                          arguments: state.results,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is FixedAssetsSearchLoading) {
                        return const AppButtonLoading();
                      }

                      return BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        bool
                      >(
                        selector: (state) {
                          if (state.getTypedValue<FixedAssetsSearchType>(
                                'searchType',
                              ) ==
                              FixedAssetsSearchType.general) {
                            return state.fieldsValidity['zoneId'] == true &&
                                state.fieldsValidity['typeId'] == true &&
                                state.fieldsValidity['responsibleId'] == true &&
                                state.fieldsValidity['typeName'] == true &&
                                state.fieldsValidity['zoneName'] == true &&
                                state.fieldsValidity['responsibleName'] ==
                                    true &&
                                state.fieldsValidity['date'] == true;
                          } else if (state.getTypedValue<FixedAssetsSearchType>(
                                'searchType',
                              ) ==
                              FixedAssetsSearchType.quick) {
                            return state.fieldsValidity['quickSearchType'] ==
                                true;
                          }

                          return false;
                        },
                        builder: (context, enableButton) {
                          return AppButton(
                            onClick: () => _search(context),
                            icon: AppSvg(
                              assetName: AppAssets.search,
                              width: 14.r,
                              colorFilter: ColorFilter.mode(
                                enableButton
                                    ? context.customColor.reversedTextColor
                                    : context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            text: context.tr.startSearch,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.r,
                              vertical: 14.r,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                            enabled: enableButton,
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
