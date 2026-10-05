import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/top_section_auth_widget.dart';
import 'package:assab/features/login/presentation/cubits/login_form/login_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/shared_login_form.dart';

class LoginWithPhoneScreen extends StatelessWidget {
  const LoginWithPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginFormCubit(),
      child: Scaffold(
        backgroundColor: context.theme.primaryColor,
        body: Column(
          children: [
            25.verticalSpace,
            TopSectionAuthWidget(
              title: context.tr.welcomeBack,
              desc: context.tr.loginToAccessYourAccountToGetStarted,
            ),
            40.verticalSpace,
            SharedLoginForm(
              identifierType: LoginIdentifierType.phone,
              onSwitchMethod: () {
                NavigationService.I.replaceWithNamed(AppRouteName.loginWithEmailScreen);
              },
              switchMethodText: context.tr.loginWithEmail,
            ),
          ],
        ),
      ),
    );
  }
}
