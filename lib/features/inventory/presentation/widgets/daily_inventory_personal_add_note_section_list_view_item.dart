import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class DailyInventoryPersonalAddNoteSectionListViewItem extends StatefulWidget {
  final String itemId;

  const DailyInventoryPersonalAddNoteSectionListViewItem({
    super.key,
    required this.itemId,
  });

  @override
  State<DailyInventoryPersonalAddNoteSectionListViewItem> createState() =>
      _DailyInventoryPersonalAddNoteSectionListViewItemState();
}

class _DailyInventoryPersonalAddNoteSectionListViewItemState
    extends State<DailyInventoryPersonalAddNoteSectionListViewItem> {
  late final ValueNotifier<bool> _isNoteAdded;

  String get _noteKey => 'note_${widget.itemId}';

  @override
  void initState() {
    super.initState();

    _isNoteAdded = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isNoteAdded.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isNoteAdded,
      builder: (context, value, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: value
              ? AppGestureDetectorButton(
                  onTap: () {
                    _isNoteAdded.value = !_isNoteAdded.value;
                  },
                  child: ContainerCustomTextField(
                    label: context.tr.additionalNote,
                    backgroundColor: context.customColor.reversedTextColor,
                    borderColor: Colors.transparent,
                    child: CustomTextField(
                      hintText: context.tr.additionalNote,
                      maxLines: 5,
                      onChanged: (value) {
                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreValue(
                              fieldName: _noteKey,
                              value: value,
                              isValid: true,
                            );
                      },
                    ),
                  ),
                )
              : AppGestureDetectorButton(
                  onTap: () {
                    _isNoteAdded.value = !_isNoteAdded.value;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSvg(
                          assetName: AppAssets.edit,
                          colorFilter: ColorFilter.mode(
                            context.theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          context.tr.addNote,
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        3.horizontalSpace,
                        Text(
                          '(${context.tr.optional})',
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
