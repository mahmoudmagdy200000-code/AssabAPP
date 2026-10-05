import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/track_order/track_order_cubit.dart';
import '../cubits/track_order/track_order_state.dart';

class OrderTrackView extends StatefulWidget {
  final String orderId;

  const OrderTrackView({super.key, required this.orderId});

  @override
  State<OrderTrackView> createState() => _OrderTrackViewState();
}

class _OrderTrackViewState extends State<OrderTrackView> {
  @override
  void initState() {
    super.initState();

    _getTrack();
  }

  void _getTrack() {
    context.read<TrackOrderCubit>().getTrackOrder(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.customColor.border),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(20.r),
        child: BlocBuilder<TrackOrderCubit, TrackOrderState>(
          builder: (context, state) {
            if (state is TrackOrderLoading) {
              return const AppLoadingWidget();
            } else if (state is TrackOrderFailure) {
              return AppFailureWidget(
                failure: state.failure,
                onRetry: _getTrack,
                withBorder: false,
              );
            } else if (state is TrackOrderSuccess) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.tr.trackDelivery,
                          textAlign: TextAlign.center,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    state.buildPreparing(context),
                    state.buildOutToDelivery(context),
                    state.buildDelivered(context),
                    state.buildConfirmation(context),
                    state.buildVariance(context),
                  ],
                ),
              );
            }

            return AppLocalFailure(onRetry: _getTrack, withBorder: false);
          },
        ),
      ),
    );
  }
}
