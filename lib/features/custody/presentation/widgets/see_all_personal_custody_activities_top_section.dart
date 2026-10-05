import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/export_personal_balance_as_pdf/export_personal_balance_as_pdf_cubit.dart';
import '../cubit/select_export_account_statement_as_pdf/select_export_account_statement_as_pdf_cubit.dart';
import 'custody_export_as_pdf_bottom_sheet_widget.dart';

class SeeAllPersonalCustodyActivitiesTopSection extends StatelessWidget {
  const SeeAllPersonalCustodyActivitiesTopSection({super.key});

  void _exportAsPdfBottomSheet(BuildContext context) {
    AppBottomSheet.pageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<SelectExportAccountStatementAsPdfCubit>(),
          ),
          BlocProvider(
            create: (context) => getIt<ExportPersonalBalanceAsPdfCubit>(),
          ),
        ],
        child: const CustodyExportAsPdfBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: Row(
              children: List.generate(2, (index) {
                final texts = [context.tr.daily, context.tr.detailed];

                return Expanded(
                  child: BlocSelector<PagingCubit, PagingState, bool>(
                    selector: (state) => state.currentIndex == index,
                    builder: (context, state) {
                      return CustomTextButton(
                        text: texts[index],
                        borderRadius: 1000.r,
                        textColor: context.customColor.text1,
                        backgroundColor: state
                            ? context.customColor.reversedTextColor
                            : Colors.transparent,
                        borderColor: Colors.transparent,
                        onTap: () {
                          context.read<PagingCubit>().goToStep(index);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
        30.horizontalSpace,
        ButtonTextIcon(
          onTap: () => _exportAsPdfBottomSheet(context),
          label: context.tr.exportAsPdf,
          icon: AppSvg(
            assetName: AppAssets.pdfSvg,
            width: 14.w,
            colorFilter: ColorFilter.mode(
              context.customColor.error,
              BlendMode.srcIn,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r),
          borderRadius: BorderRadius.circular(12.r),
          textStyle: AppStyles.s12W500.copyWith(
            color: context.customColor.text1,
          ),
        ),
      ],
    );
  }
}
