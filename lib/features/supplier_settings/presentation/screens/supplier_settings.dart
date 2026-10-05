import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/features/supplier_settings/presentation/widgets/supplier_settings_account_and_password_section.dart'
    show SupplierSettingsAccountAndPasswordSection;
import 'package:flutter/material.dart';

import '../widgets/supplier_settings_system_settings_section.dart';
import '../widgets/supplier_settings_top_section.dart';

class SupplierSettings extends StatelessWidget {
  const SupplierSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SupplierSettingsTopSection(),
              SupplierSettingsAccountAndPasswordSection(),
              SupplierSettingsSystemSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
