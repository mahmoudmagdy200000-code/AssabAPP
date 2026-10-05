import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/receive_goods/presentation/widgets/receive_goods_variance_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../domain/strategies/document_type_strategy.dart';

class ReceiveGoodsVarianceView extends StatefulWidget {
  final DocumentTypeStrategy strategy;

  const ReceiveGoodsVarianceView({super.key, required this.strategy});

  @override
  State<ReceiveGoodsVarianceView> createState() =>
      _ReceiveGoodsVarianceViewState();
}

class _ReceiveGoodsVarianceViewState extends State<ReceiveGoodsVarianceView> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();
    _validationCubit = context.read<ValidationCubit>();

    _validationCubit.addDynamicFields({'note'});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.tr.varianceDetected,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                const ReceiveGoodsVarianceSummaryWidget(),
                10.verticalSpace,
                widget.strategy.buildMiddleSectionInVarianceView(context),
                ContainerCustomTextField(
                  label: context.tr.additionalNote,
                  isLabelOptional: true,
                  isLabelRequired: false,
                  borderColor: context.customColor.border,
                  backgroundColor: Colors.transparent,
                  child: CustomTextField(
                    hintText: context
                        .tr
                        .describeTheInspectionsIncludingAnyDiscoveriesOrDetails,
                    maxLines: 5,
                    onChanged: (value) {
                      _validationCubit.validateFieldAndStoreValue(
                        fieldName: 'note',
                        value: value,
                        isValid: value.isNotEmpty,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: context.tr.back,
                onTap: () {
                  context.read<PagingCubit>().previousStep();
                },
                padding: EdgeInsets.symmetric(vertical: 18.r),
                textColor: context.customColor.text1,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: AppButton(
                onClick: () {
                  context.read<PagingCubit>().nextStep();
                },
                enabled: true,
                text: context.tr.continue_c,
                borderRadius: BorderRadius.circular(15.r),
                padding: EdgeInsets.symmetric(vertical: 18.r),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
