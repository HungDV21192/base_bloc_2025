import 'package:base_code/features/settings/settings_cubit.dart';
import 'package:base_code/features/settings/widgets/radio_language.dart';
import 'package:base_code/features/settings/widgets/radio_theme.dart';
import 'package:base_code/widgets/custom_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      final settingsCubit = context.read<SettingsCubit>();
      return CustomScreen(
        titleAppBar: 'settings'.tr(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              RadioThemeWidget(
                initMode: state.themeMode,
                onChanged: (theme) => settingsCubit.updateTheme(theme),
              ),
              const Divider(height: 5, color: Colors.grey),
              RadioLangWidget(
                initLocale: state.locale,
                onChanged: (locale) {
                  context.setLocale(locale);
                  settingsCubit.updateLanguage(locale);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
