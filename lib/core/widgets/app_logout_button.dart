import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/logout/logout_cubit.dart';
import '../cubits/logout/logout_state.dart';
import '../di/dependency_injection.dart';
import '../routing/app_route_name.dart';
import '../services/navigation/navigation_service.dart';

class AppLogoutButton extends StatelessWidget {
  const AppLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LogoutCubit>(),
      child: const _AppLogoutButton(),
    );
  }
}

class _AppLogoutButton extends StatelessWidget {
  const _AppLogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is LogoutSuccess) {
          NavigationService.I.offAllNamed(AppRouteName.start);
        }
      },
      builder: (context, state) {
        if (state is LogoutLoading) {
          return AppButtonLoading(
            background: context.customColor.error.withValues(alpha: 0.4),
          );
        }

        return AppButton(
          onClick: () async => await context.read<LogoutCubit>().logout(),
          text: context.tr.logout,
          background: context.customColor.error,
          enabled: true,
        );
      },
    );
  }
}
