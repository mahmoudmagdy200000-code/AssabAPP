import 'package:assab/core/cubits/theme/theme_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePreferenceBottomSheetWidget extends StatelessWidget {
  const ThemePreferenceBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ThemeCubit>().state;
    final options = <(ThemeMode, String)>[
      (ThemeMode.system, context.tr.systemPreference),
      (ThemeMode.light, context.tr.lightMode),
      (ThemeMode.dark, context.tr.darkMode),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr.theme,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final (mode, label) in options)
              ListTile(
                title: Text(label),
                trailing: selected == mode ? const Icon(Icons.check) : null,
                onTap: () async {
                  await context.read<ThemeCubit>().toggle(mode);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
