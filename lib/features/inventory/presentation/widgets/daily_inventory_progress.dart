import 'dart:async';

import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class DailyInventoryProgress extends StatefulWidget {
  final int itemsLength;
  final List<String> quantityKeys;

  const DailyInventoryProgress({
    super.key,
    required this.itemsLength,
    required this.quantityKeys,
  });

  @override
  State<DailyInventoryProgress> createState() => _DailyInventoryProgressState();
}

class _DailyInventoryProgressState extends State<DailyInventoryProgress> {
  late DateTime _startTime;
  Timer? _timer;
  final ValueNotifier<Duration> _elapsedTimeNotifier = ValueNotifier(
    Duration.zero,
  );

  static const String _startTimeKey = 'inventory_start_time';
  static const String _timeTakenKey = 'inventory_time_taken';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _saveStartTime();
    _startTimer();
  }

  void _saveStartTime() {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: _startTimeKey,
      value: _startTime.toIso8601String(),
      isValid: true,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _elapsedTimeNotifier.value = DateTime.now().difference(_startTime);
      }
    });
  }

  void _saveTimeTaken() {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: _timeTakenKey,
      value: _elapsedTimeNotifier.value.inSeconds.toString(),
      isValid: true,
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  int _calculateCompletedItems(ValidationState state) {
    int completedCount = 0;
    for (final key in widget.quantityKeys) {
      final isValid = state.fieldsValidity[key] ?? false;
      if (isValid) {
        completedCount++;
      }
    }
    return completedCount;
  }

  double _calculateProgress(int completedItems) {
    if (widget.itemsLength == 0) return 0;
    return (completedItems / widget.itemsLength).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: _elapsedTimeNotifier,
      builder: (context, elapsed, child) {
        return BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, state) {
            final completedItems = _calculateCompletedItems(state);
            final progress = _calculateProgress(completedItems);

            if (completedItems == widget.itemsLength && _timer != null) {
              _timer?.cancel();
              _timer = null;
              _saveTimeTaken();
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr.personalInventory,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        _formatDuration(elapsed),
                        style: AppStyles.s13W500.copyWith(
                          color: context.customColor.text4,
                        ),
                      ),
                      5.horizontalSpace,
                      AppSvg(assetName: AppAssets.clockSvg, width: 12.r),
                    ],
                  ),
                  5.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(1000.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.r,
                      vertical: 5.r,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 20.h,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Center(
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: context.customColor.text3
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment((progress * 2) - 1, 0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.r,
                                      vertical: 4.r,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                    child: AppSvg(
                                      assetName: AppAssets.box,
                                      width: 8.r,
                                      colorFilter: ColorFilter.mode(
                                        context.customColor.reversedTextColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        Text(
                          '$completedItems',
                          style: AppStyles.s12W500.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        Text(
                          '/${widget.itemsLength}',
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
