import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/custody/presentation/cubit/get_custody_details/get_custody_details_cubit.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assab/core/enums/custody_requests_status_enum.dart';
import '../../data/custody_receipt_action.dart';
import '../../data/custody_request_resubmit_action.dart';
import '../cubit/get_branch_balance/get_branch_balance_cubit.dart';

import '../cubit/get_custody_details/get_custody_details_state.dart';
import 'custody_request_details_screen_approval_view.dart';
import 'custody_request_details_screen_details_view.dart';

class CustodyRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;

  const CustodyRequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.userTypeStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<GetCustodyDetailsCubit>()
            ..getRequestDetails(requestId: requestId),
      child: _CustodyRequestDetailsScreen(
        requestId: requestId,
        userTypeStrategy: userTypeStrategy,
      ),
    );
  }
}

class _CustodyRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  final UserTypeStrategy userTypeStrategy;

  const _CustodyRequestDetailsScreen({
    required this.requestId,
    required this.userTypeStrategy,
  });

  void _getRequestDetails(BuildContext context) {
    context.read<GetCustodyDetailsCubit>().getRequestDetails(
      requestId: requestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          10.verticalSpace,
          CustodyAppBar(
            title: context.tr.custodyRequestForm,
            subtitle: context.tr.viewDetailsTimelinesAndStatuses,
            titleStyle: AppStyles.s16W600.copyWith(
              color: context.customColor.text1,
            ),
            iconColor: context.customColor.text1,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
              child: BlocBuilder<GetCustodyDetailsCubit, GetCustodyDetailsState>(
                builder: (context, getCustodyDetailsState) {
                  if (getCustodyDetailsState is GetCustodyDetailsLoading) {
                    return const AppLoadingWidget();
                  } else if (getCustodyDetailsState
                      is GetCustodyDetailsFailure) {
                    return AppFailureWidget(
                      failure: getCustodyDetailsState.failure,
                      onRetry: () => _getRequestDetails(context),
                      withBorder: false,
                    );
                  } else if (getCustodyDetailsState
                      is GetCustodyRequestDetailsSuccess) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.text2,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.all(6.r),
                          child: Row(
                            children: List.generate(3, (index) {
                              final texts = [
                                context.tr.details,
                                context.tr.timelines,
                                context.tr.approval,
                              ];

                              return Expanded(
                                child:
                                    BlocSelector<
                                      PagingCubit,
                                      PagingState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.currentIndex == index,
                                      builder: (context, state) {
                                        return CustomTextButton(
                                          text: texts[index],
                                          onTap: () {
                                            context
                                                .read<PagingCubit>()
                                                .goToStep(index);
                                          },
                                          textColor: context.customColor.text1,
                                          borderRadius: 1000.r,
                                          borderColor: Colors.transparent,
                                          backgroundColor: state
                                              ? context
                                                    .customColor
                                                    .reversedTextColor
                                              : Colors.transparent,
                                        );
                                      },
                                    ),
                              );
                            }),
                          ),
                        ),
                        12.verticalSpace,
                        Expanded(
                          child: BlocSelector<PagingCubit, PagingState, int>(
                            selector: (state) => state.currentIndex,
                            builder: (context, state) {
                              return IndexedStack(
                                index: state,
                                children: [
                                  CustodyRequestDetailsScreenDetailsView(
                                    details:
                                        getCustodyDetailsState.details.data,
                                    userTypeStrategy: userTypeStrategy,
                                    onApproveRejectSuccess: () {
                                      _getRequestDetails(context);
                                    },
                                  ),
                                  TimeLinesView(
                                    timelines: getCustodyDetailsState
                                        .details
                                        .data
                                        .timeline
                                        .timelines,
                                  ),
                                  CustodyRequestDetailsScreenApprovalView(
                                    approval: getCustodyDetailsState
                                        .details
                                        .data
                                        .approval,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        if (userTypeStrategy is BranchManagerUserStrategy &&
                            getCustodyDetailsState.details.data.requestId ==
                                requestId) ...[
                          _ResubmitRequestButton(
                            requestId: requestId,
                            eligible: getCustodyDetailsState
                                .details
                                .data
                                .canResubmit,
                          ),
                          _ConfirmReceiptButton(
                            requestId: requestId,
                            eligible: getCustodyDetailsState
                                    .details
                                    .data
                                    .canConfirmReceipt &&
                                getCustodyDetailsState.details.data.status !=
                                    CustodyRequestsStatusEnum.completed,
                          ),
                        ],
                      ],
                    );
                  }

                  return AppLocalFailure(
                    onRetry: () => _getRequestDetails(context),
                    withBorder: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResubmitRequestButton extends StatefulWidget {
  const _ResubmitRequestButton({required this.requestId, required this.eligible});

  final String requestId;
  final bool eligible;

  @override
  State<_ResubmitRequestButton> createState() => _ResubmitRequestButtonState();
}

class _ResubmitRequestButtonState extends State<_ResubmitRequestButton> {
  bool _busy = false;

  Future<void> _resubmit() async {
    if (_busy || !widget.eligible) return;
    setState(() => _busy = true);
    final cubit = context.read<GetCustodyDetailsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      try {
        await CustodyRequestResubmitAction(getIt<Dio>()).resubmit(widget.requestId);
      } catch (_) {
        // A lost response may follow a successful state change; verify by GET.
      }
      await cubit.getRequestDetails(requestId: widget.requestId);
      final state = cubit.state;
      final resubmitted = state is GetCustodyRequestDetailsSuccess &&
          state.details.data.requestId == widget.requestId &&
          state.details.data.status != CustodyRequestsStatusEnum.rejected &&
          !state.details.data.canResubmit;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            resubmitted
                ? 'تمت إعادة إرسال الطلب نفسه للمراجعة.'
                : 'لم تتأكد إعادة الإرسال. حدّث الحالة قبل المحاولة مرة أخرى.',
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذر التحقق من حالة إعادة الإرسال.')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.eligible) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 8.r),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _busy ? null : _resubmit,
          child: Text(_busy ? 'جارٍ إعادة الإرسال...' : context.tr.submitRequest),
        ),
      ),
    );
  }
}

class _ConfirmReceiptButton extends StatefulWidget {
  const _ConfirmReceiptButton({
    required this.requestId,
    required this.eligible,
  });
  final String requestId;
  final bool eligible;
  @override
  State<_ConfirmReceiptButton> createState() => _ConfirmReceiptButtonState();
}

class _ConfirmReceiptButtonState extends State<_ConfirmReceiptButton> {
  static final Set<String> _inFlight = {};
  bool _busy = false;

  Future<void> _reconcile() async {
    if (_busy) return;
    setState(() => _busy = true);
    final details = context.read<GetCustodyDetailsCubit>();
    final balance = context.read<GetBranchBalanceCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final requestId = widget.requestId;
    try {
      final prefs = await SharedPreferences.getInstance();
      final actor = prefs.getString('u_id') ?? '';
      final action = CustodyReceiptAction(getIt<Dio>(), prefs, actorId: actor);
      if (!action.hasCurrentActor) throw StateError('Account unavailable.');
      await Future.wait([
        details.getRequestDetails(requestId: requestId),
        balance.getBranchBalance(),
      ]);
      final refreshed = details.state;
      if (action.hasCurrentActor &&
          refreshed is GetCustodyRequestDetailsSuccess &&
          refreshed.details.data.requestId == requestId &&
          refreshed.details.data.status ==
              CustodyRequestsStatusEnum.completed) {
        await action.resolveConfirmed(requestId);
        messenger.showSnackBar(
          const SnackBar(content: Text('تم التحقق من استلام الطلب.')),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'النتيجة غير مؤكدة. تواصل مع المحاسب أو مسؤول النظام قبل أي إجراء آخر.',
            ),
          ),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('تعذر تحديث الحالة. تواصل مع المحاسب أو مسؤول النظام.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirm() async {
    if (_busy || !_inFlight.add(widget.requestId)) return;
    setState(() => _busy = true);
    try {
      final agreed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد استلام التغذية'),
          content: const Text('هل استلمت المبلغ فعلياً؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تأكيد الاستلام'),
            ),
          ],
        ),
      );
      if (agreed != true || !mounted) return;
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final actor = prefs.getString('u_id') ?? '';
      final action = CustodyReceiptAction(getIt<Dio>(), prefs, actorId: actor);
      if (!action.hasCurrentActor || !widget.eligible) {
        throw StateError('Account or eligibility unavailable.');
      }
      if (action.isUnresolved(widget.requestId)) {
        throw StateError('Receipt outcome requires reconciliation.');
      }
      final details = context.read<GetCustodyDetailsCubit>();
      final balance = context.read<GetBranchBalanceCubit>();
      final messenger = ScaffoldMessenger.of(context);
      final requestId = widget.requestId;
      final confirmed = await action.confirmAndReconcile(
        requestId,
        refreshDetails: () async {
          await details.getRequestDetails(requestId: requestId);
          final refreshed = details.state;
          return refreshed is GetCustodyRequestDetailsSuccess &&
              refreshed.details.data.requestId == requestId &&
              refreshed.details.data.status ==
                  CustodyRequestsStatusEnum.completed;
        },
        refreshBalance: balance.getBranchBalance,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            confirmed
                ? 'تم تأكيد الاستلام. راجع رصيد الفرع بعد تحديثه.'
                : 'لم تتأكد نتيجة الاستلام. راجع حالة الطلب قبل أي محاولة أخرى.',
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر تأكيد الاستلام بأمان. راجع حالة الطلب.'),
          ),
        );
      }
    } finally {
      _inFlight.remove(widget.requestId);
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const SizedBox.shrink();
      final prefs = snapshot.data!;
      final actor = prefs.getString('u_id') ?? '';
      final action = CustodyReceiptAction(getIt<Dio>(), prefs, actorId: actor);
      final unresolved = action.isUnresolved(widget.requestId);
      if (!unresolved && !widget.eligible) return const SizedBox.shrink();
      return Column(
        children: [
          if (!_busy && unresolved) ...[
            const Text(
              'الاستلام معلّق. حدّث الحالة، وإن بقيت غير مؤكدة تواصل مع المحاسب أو مسؤول النظام.',
            ),
            TextButton(
              onPressed: !action.hasCurrentActor ? null : _reconcile,
              child: const Text('تحديث حالة الاستلام'),
            ),
          ],
          if (widget.eligible || (!_busy && unresolved))
            FilledButton(
              onPressed:
                  _busy ||
                      unresolved ||
                      !widget.eligible ||
                      !action.hasCurrentActor
                  ? null
                  : _confirm,
              child: Text(_busy ? 'جارٍ التأكيد...' : 'تأكيد استلام التغذية'),
            ),
        ],
      );
    },
  );
}
